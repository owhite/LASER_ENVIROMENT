// this slave sends signals to a bank of relays
// slave only receives input. no output is sent back
// one requirement - it shuts off all relays unless it
//  it receives a periodic signal from master

#include <Sound.h>
#include <laser_systems.h>

#define S_IDLE                1
#define S_SETPINS             3
#define S_MAKE_ACTIVATE_SOUND 8
#define S_SHUTDOWN            9

#define SPK_PIN      20
#define MCU_PIN      14
#define LED_PIN      13
#define OUTPUT_RANGE 12 // total number of relays

#define IN_PIN1 23
#define IN_PIN2 17
#define IN_PIN3 16
#define IN_PIN4 18

int state = S_IDLE;

uint32_t timeOfLastDebounce;
uint32_t delayofDebounce = 40;
boolean debounceFlag = true;

uint8_t saveInput;
uint8_t oldInput;
uint8_t input;

boolean tweetFlag = false;
boolean blinkFlag = false;

Sound sound(SPK_PIN);

boolean  blinkOn = false;
uint32_t blinkDelta = 0;
uint32_t blinkInterval = 300;
uint32_t blinkNow;

uint8_t readInputs(){
  input = 0;

  if (digitalRead(IN_PIN1) == HIGH) { input = input | 0x01; }
  if (digitalRead(IN_PIN2) == HIGH) { input = input | 0x02; }
  if (digitalRead(IN_PIN3) == HIGH) { input = input | 0x04; }
  if (digitalRead(IN_PIN4) == HIGH) { input = input | 0x08; }

  return(input);
}

// mask is used to turn LEDs on
void orSetLEDsON(uint8_t in1, uint8_t in2) {

  for (int i = 0; i < 8; i++) {
    if  (in1 & (B10000000 >> i)) {
      digitalWrite(i, HIGH);
    }
  }
  for (int i = 0; i < 4; i++) {
    if  (in2 & (B10000000 >> i)) {
      digitalWrite(i + 8, HIGH);
    }
  }
}

// mask is used to turn LEDs off
void orSetLEDsOFF(uint8_t in1, uint8_t in2) {

  for (int i = 0; i < 8; i++) {
    if  (in1 & (B10000000 >> i)) {
      digitalWrite(i, LOW);
    }
  }
  for (int i = 0; i < 4; i++) {
    if  (in2 & (B10000000 >> i)) {
      digitalWrite(i + 8, LOW);
    }
  }
}

void handle_cmd(uint8_t value) {
  if (value != 0x0E) { tweetFlag = false; }

  switch (value) {
  case 0x00: // all off
    for(int i=0; i < OUTPUT_RANGE; i++){
      pinMode(i, OUTPUT);
      digitalWrite(i, LOW);
    }  
    digitalWrite(LED_PIN, HIGH);
    break;
  case 0x01:
    orSetLEDsON(B10000000, B00000000);
    break;
  case 0x02:
    orSetLEDsON(B01000000, B00000000);
    break;
  case 0x03:
    orSetLEDsON(B00100000, B00000000);
    break;
  case 0x04:
    orSetLEDsON(B00010000, B00000000);
    break;
  case 0x05:
    orSetLEDsON(B00001000, B00000000);
    break;
  case 0x06:
    orSetLEDsON(B00000100, B00000000);
    break;
  case 0x07:
    orSetLEDsOFF(B10000000, B00000000);
    break;
  case 0x08:
    orSetLEDsOFF(B01000000, B00000000);
    break;
  case 0x09:
    orSetLEDsOFF(B00100000, B00000000);
    break;
  case 0x0A:
    orSetLEDsOFF(B00010000, B00000000);
    break;
  case 0x0B:
    orSetLEDsOFF(B00001000, B00000000);
    break;
  case 0x0C:
    orSetLEDsOFF(B00000100, B00000000);
    break;
  case 0x0E:
    if (tweetFlag == false) { sound.sonic_screwdriver(); }
    tweetFlag = true; // helps with tweeting just once
    break;
  case 0x0F:
    break;
  default:
    // unknown state
    for(int i=0; i < OUTPUT_RANGE; i++){
      pinMode(i, OUTPUT);
      digitalWrite(i, LOW);
    }  
    digitalWrite(LED_PIN, HIGH);
    break;
  }

}

void setup() {
  Serial.begin(SERIAL_SPEED);

  pinMode(IN_PIN1, INPUT);
  pinMode(IN_PIN2, INPUT);
  pinMode(IN_PIN3, INPUT);
  pinMode(IN_PIN4, INPUT);

  for(int i=0; i < OUTPUT_RANGE; i++){
    pinMode(i, OUTPUT);
    digitalWrite(i, LOW);
  }

  pinMode(MCU_PIN, OUTPUT);
  pinMode(LED_PIN, OUTPUT);
  analogWrite(MCU_PIN, 1);

}


void loop() {

  // blinky dink the indicator LED
  blinkNow = millis();
  if ((blinkNow - blinkDelta) > blinkInterval) {
    blinkOn = !blinkOn;
    if (blinkFlag) { digitalWrite(LED_PIN, blinkOn); }
    else { digitalWrite(LED_PIN, HIGH); }
    blinkDelta = blinkNow;
  }
 
  input = readInputs();

  if (input != oldInput) {
    timeOfLastDebounce = millis();
    debounceFlag = true;
    saveInput = input;
  }

  if ((millis() - timeOfLastDebounce) > delayofDebounce && debounceFlag) {
    if (saveInput == input) {
      handle_cmd(input);
    }
    debounceFlag = false;
  }

  oldInput = input;
}
