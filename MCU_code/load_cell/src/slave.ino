// slave to monitor load cells. load cells detect if something
//   is pushing on a laser optic and complains if there
//   is too much pressure. The program also rotates a stepper motor when the user
//   hits a switch.
// if the user hits the pushbutton you can calibrate -- set the levels
//   of the set screws that come into the load cells

#include <RunningAverage.h>
#include <laser_systems.h>
#include <Sound.h>

#define S_IDLE                1
#define S_MOTOR_INIT          2
#define S_MOTOR_RUN           3
#define S_MOTOR_OFF           4
#define S_CALIBRATE           5
#define S_MAKE_ACTIVATE_SOUND 6

boolean NO_SOUND    = true;
boolean NO_THROB    = true;
boolean CHECK_IO    = true;
boolean THROW_ERROR = false;

int direction = 0;
#define FORWARD    1
#define REVERSE    3

#define HBT_PIN_IN    20 // pulse this thing to show it's on
#define TWEET_PIN_IN  21 // toggle to make a "hello" noise
#define STOP_SQUEAL   23 // toggle to stop squealing
#define MOVE_PIN      22 // output. toggle to indicate there was movement

#define GECKOENBL  4 // enable the motor driver
#define DIR_PIN    2 // direction of the motor
#define STEP_PIN   3 // step the motor

#define LED_PIN    5 // displays the board is active 
#define SPKR_PIN   10
#define PB_PIN     1

#define LED1       14 // indicators of load cell status
#define LED2       15
#define LED3       16

#define LC_PIN1    19 // input from the load cells
#define LC_PIN2    18
#define LC_PIN3    17

#define SW_PIN1    11 // user input to move motor
#define SW_PIN2    12

boolean blinkOn = false; 
uint32_t blinkDelta = 0;
uint32_t blinkInterval = 300; 
uint32_t blinkNow;

elapsedMillis elapsedCountTime;
uint16_t countSampleTime = 100;

elapsedMillis elapsedErrorTime;
uint16_t errorTime      = 2000;

int state = S_IDLE;
int motorCount = 0;
float decayN = 0.0;
int decayTime = 0;
int LC1 = 0; int LC2 = 0; int LC3 = 0;

// sampling parameters
int RAsamples =        500; // number of samples in rolling buffer
int delta =            18;  // degree of change in rolling buffer to prompt a response
int averageThreshold = 30;  // must be over this level to be counted
int touchThreshold =   80;  // level where lights go green
int compressed_counter= 0;

// parameters used to ramp up the motor slowly. 
// this create a decay function to eat away at the number of cycles
// that serve as a delay to pulse the motor. this is
// a great way to have the motor slowly ramp up in speed. 
// these parameters will make no sense unless you plot them. 
int accelTime  = 600;       // Number of loops to arrive at velocity
int startDelay = 8000;	    // Number of atoms at t = 0, starting velocity
int finalDelay = 500;       // Number of atoms to decay to, ending velocity
float decayConstant = .02;  // Impacts the degree of decay at each step

// motor variables
int rotF = HIGH; // pin setting to rotate motor forward
int rotR = LOW;

// decay function variables
int leftSpan;            
int rightSpan;
int endPoint;

Sound sound(SPKR_PIN);

RunningAverage RA1(RAsamples);
RunningAverage RA2(RAsamples);
RunningAverage RA3(RAsamples);

void initDecay() {
  // find final decay point using the above parameters
  float N = float(startDelay);
  int t;

  for (t = 0; t < accelTime; t++) {
    N = N - (decayConstant * N);
    t += 1;
  }

  int endPoint = int(N);

  // The issue is the decay of our atoms may be much larger or smaller
  // than what we want. But presumably we love the rate. So
  // Scale our final end point to our desired endpoint
  // do this by getting ranges
  leftSpan = startDelay - endPoint;
  rightSpan = startDelay - finalDelay;
}

int scaleDecay(float N) {
  // scale our current value to our desired endpoint
  float s = (N - float(endPoint)) / float(leftSpan);

  return (int(finalDelay + (s * rightSpan)));
}

void LED_GO (int _LED) {
  digitalWrite(_LED, LOW);
}

void LED_STOP (int _LED) {
  digitalWrite(_LED, HIGH);
}

void setup() {
  Serial.begin(SERIAL_SPEED);
  initDecay();

  RA1.clear(); RA2.clear(); RA3.clear();
  analogReference(EXTERNAL);

  pinMode(MOVE_PIN, OUTPUT);
  pinMode(HBT_PIN_IN, INPUT);
  pinMode(STOP_SQUEAL, INPUT);
  pinMode(TWEET_PIN_IN, INPUT);

  pinMode(SW_PIN1, INPUT);
  pinMode(SW_PIN2, INPUT);
  pinMode(PB_PIN, INPUT);
  pinMode(STEP_PIN, OUTPUT);
  pinMode(GECKOENBL, OUTPUT);
  pinMode(STEP_PIN, OUTPUT);
  pinMode(DIR_PIN, OUTPUT);
  pinMode(LED_PIN, OUTPUT);
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);

  digitalWrite(STEP_PIN, HIGH);
  digitalWrite(DIR_PIN, HIGH);
  digitalWrite(GECKOENBL, LOW);
  digitalWrite(LED1, HIGH);
  digitalWrite(LED2, HIGH);
  digitalWrite(LED3, HIGH);
}

void checkIO() {

  // sources of I/O
  //  HBT_PIN_IN   -- input from RJ45
  //  STOP_SQUEAL  -- input from RJ45
  //  TWEET_PIN_IN -- input from RJ45
  //  MOVE_PIN     -- output to RJ45
  //  PB_PIN       -- user input for calibrate
  //  SW1/2_PIN    -- user input moves motor up or down

  state = S_IDLE;
  NO_SOUND = true;
  NO_THROB = true;

  if (digitalRead(HBT_PIN_IN) == LOW)  { NO_THROB = false; }
  if (digitalRead(STOP_SQUEAL) == HIGH) { NO_SOUND = false; }

  // user request for movement overrides any state
  if (digitalRead(SW_PIN1) == HIGH) {
    delay(5);
    if (digitalRead(SW_PIN1) == HIGH) {
      state = S_MOTOR_INIT;
      direction = FORWARD;
    }
  }
  if (digitalRead(SW_PIN2) == HIGH) {
    delay(5);
    if (digitalRead(SW_PIN2) == HIGH) {
      state = S_MOTOR_INIT;
      direction = REVERSE;
    }
  }

  // user request for calibrate overrides request for movement
  if (digitalRead(TWEET_PIN_IN) == LOW) { state = S_MAKE_ACTIVATE_SOUND; }

  // user request for calibrate overrides request for movement
  if (digitalRead(PB_PIN) == HIGH) { state = S_CALIBRATE; }
}

void loop() {
  // under some circumstances we pause checking the inputs
  if (CHECK_IO) { checkIO(); }

  // blinky dink the indicator LED
  blinkNow = millis();
  if ((blinkNow - blinkDelta) > blinkInterval) {
    blinkOn = !blinkOn;
    if (! NO_THROB) { digitalWrite(LED_PIN, blinkOn); }
    else { digitalWrite(LED_PIN, HIGH); }
    blinkDelta = blinkNow;
  }

  switch (state) {
  case S_MOTOR_INIT:
    if (direction == FORWARD) {
      LED_GO(LED3);
      digitalWrite(DIR_PIN, rotR);
    }
    if (direction == REVERSE) {
      LED_GO(LED1);
      digitalWrite(DIR_PIN, rotF);
    }
    digitalWrite(GECKOENBL, HIGH); // activate gecko motor driver
    motorCount = 0;
    decayN = float(startDelay);
    decayTime = 0;
    CHECK_IO = false;
    state = S_MOTOR_RUN;
    break;

  case S_MOTOR_RUN:
    if (motorCount < accelTime) {
      decayN = decayN - (decayConstant * decayN);
      decayTime = scaleDecay(decayN);
    }
    else {
      decayTime = finalDelay;
    }
    digitalWrite(STEP_PIN, HIGH);
    delayMicroseconds(decayTime); 
    digitalWrite(STEP_PIN, LOW);
    delayMicroseconds(decayTime); 
    motorCount += 1;
    if (digitalRead(SW_PIN1) == LOW && digitalRead(SW_PIN2) == LOW ) { state = S_MOTOR_OFF; }
    break;

  case S_CALIBRATE:
    // see if load cells are receiving a certain amount of pressure. 
    LC1 = analogRead(LC_PIN1);  LC2 = analogRead(LC_PIN2);  LC3 = analogRead(LC_PIN3);

    // indicate it hit the threshold amount
    if (LC1 > touchThreshold) { LED_GO(LED1); }
    // this cell is broken, so it's deactivated
    // if (LC2 > touchThreshold) { LED_GO(LED2); }
    if (LC3 > touchThreshold) { LED_GO(LED3); }
    if (digitalRead(PB_PIN) == LOW) { state = S_IDLE; }
    break;

  case S_MOTOR_OFF:
    digitalWrite(GECKOENBL, LOW);
    LED_STOP(LED1); LED_STOP(LED2); LED_STOP(LED3);
    delay(400); // snooze after moving
    state = S_IDLE;
    break;

  case S_IDLE:
    CHECK_IO = true;

    // read what the load cells are doing and complain if needed
    LC1 = analogRead(LC_PIN1);  LC2 = analogRead(LC_PIN2);  LC3 = analogRead(LC_PIN3);

    RA1.addValue(LC1);  RA2.addValue(LC2);  RA3.addValue(LC3);

    if (abs(RA1.getAverage() - LC1) > delta &&
	RA1.getAverage() > averageThreshold) {

      // the magic numbers in tone have to do with the range of the load cells
      //  and the range of audible tones coming out of the speaker
      if (NO_SOUND == false) { // squeal
	tone(SPKR_PIN, map(LC1, 50, 1000, 2000, 6000));  
      }
      elapsedCountTime = 0;
      compressed_counter++;
      LED_STOP(LED1);
    }
    else if (abs(RA2.getAverage() - LC2) > delta &&
	     RA2.getAverage() > averageThreshold) {
      if (NO_SOUND == false) { // squeal
	tone(SPKR_PIN, map(LC2, 50, 1000, 2000, 6000)); 
      }
      elapsedCountTime = 0;
      compressed_counter++;
      LED_STOP(LED2);
    }
    else if (abs(RA3.getAverage() - LC3) > delta &&
	     RA3.getAverage() > averageThreshold) {

      if (NO_SOUND == false) { // squeal
	tone(SPKR_PIN, map(LC3, 50, 1000, 2000, 6000)); 
      }
      elapsedCountTime = 0;
      compressed_counter++; // something is bumping the optics
      LED_STOP(LED3);
    }
    else {
      // no problems, so be quiet
      noTone(SPKR_PIN);
      LED_STOP(LED1); LED_STOP(LED2); LED_STOP(LED3);
    }

    // something bumped the optics for too long
    if (compressed_counter > 100) { 
      digitalWrite(MOVE_PIN, HIGH); 
      elapsedErrorTime = 0;
      THROW_ERROR = true;
    }
    // it threw an error, hopefully the laser caught it
    if (THROW_ERROR && elapsedErrorTime > errorTime) { 
      if (NO_SOUND == false) {
	sound.tweetON();
      }
      digitalWrite(MOVE_PIN, LOW); 
      THROW_ERROR = false;
    }
    // collected some bumps, but not enough to throw an error
    if (elapsedCountTime > countSampleTime) {
      compressed_counter = 0;
    }
    break;

  case S_MAKE_ACTIVATE_SOUND:
    sound.wonky_screwdriver();
    delay(1000);
    state = S_IDLE;
    break;

  default:
    // unknown state
    break;
  }
}
