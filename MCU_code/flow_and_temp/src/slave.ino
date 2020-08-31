// this slave measures blips coming from flow sensor and reads temperature

#include <Sound.h>
#include <Throb.h>
#include <laser_systems.h>

#define HBT_PIN_IN    9
#define TWEET_PIN_IN  8
#define HIGH_FLOW_OUT 10
#define LOW_TEMP_OUT  11


#define WATER_PIN      4
#define TEMP_PIN      15
#define BUTTON_IN     14
#define LED_PIN       20
#define SPK_PIN       21

long interval = 1000; // length of time sensors are checked 
unsigned long currentMillis;
long previousMillis = 0;  

boolean blinkOn = false; 
uint32_t blinkDelta = 0;
uint32_t blinkInterval = 200; 
uint32_t blinkNow;

long tweetInterval = 400; // length of time tweet request has to be on
unsigned long tweetMillis;
long previousTweetMillis = 0;  
boolean tweetHigh = false; 

int water_count = 0;
float temp = 0.0;

Sound sound(SPK_PIN);
Throb throb(LED_PIN);

// dis bumpy dee counter for the water flow
void isrService() {
  cli();
  water_count += 1;
  sei();
}

void setup() {
  Serial.begin(SERIAL_SPEED);

  attachInterrupt(WATER_PIN, isrService, FALLING);

  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);

  pinMode(BUTTON_IN, INPUT);

  // four status pins tied to RJ45
  pinMode(TWEET_PIN_IN, INPUT);
  pinMode(HBT_PIN_IN, INPUT);
  pinMode(LOW_TEMP_OUT, OUTPUT); 
  pinMode(HIGH_FLOW_OUT, OUTPUT);
}

void loop() {
  // could call a reset if needed
  if (digitalRead(BUTTON_IN)) { }

  // blinky dink the indicator LED
  blinkNow = millis();
  if ((blinkNow - blinkDelta) > blinkInterval) {
    blinkOn = !blinkOn;
    if (digitalRead(HBT_PIN_IN) == LOW) { digitalWrite(LED_PIN, blinkOn); }
    else { digitalWrite(LED_PIN, HIGH); }
    blinkDelta = blinkNow;
  }

  // tweet if pin is HIGH for a long period
  if (digitalRead(TWEET_PIN_IN) == LOW and tweetHigh == false) {
    previousTweetMillis = millis();
    tweetHigh = true;
  }
  if (digitalRead(TWEET_PIN_IN) == LOW and tweetHigh == true) {
    tweetMillis = millis();
    if(tweetMillis - previousTweetMillis > tweetInterval) {
      sound.ray_gun();
      tweetHigh = false;
    }
  }
  if (digitalRead(TWEET_PIN_IN) == HIGH) {
    tweetHigh == false;
  }

  currentMillis = millis();
  if(currentMillis - previousMillis > interval) {
    previousMillis = currentMillis;   

    // drive pin LOW when the water flow is good
    // Serial.println(water_count);
    if (water_count > 60) {
      digitalWrite(HIGH_FLOW_OUT, LOW);
    }
    else {
      digitalWrite(HIGH_FLOW_OUT, HIGH);
    }
    water_count = 0;

    temp = analogRead(TEMP_PIN);
    // Serial.println(temp);
    // tested this emperically
    if (temp > 830) { 
      // drive pin HIGH when temperature is good
      digitalWrite(LOW_TEMP_OUT, HIGH);
    }
    else {
      digitalWrite(LOW_TEMP_OUT, LOW);
    }
  }
}
