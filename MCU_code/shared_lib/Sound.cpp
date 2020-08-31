#include "Arduino.h"
#include "Sound.h"

Sound::Sound(int pin)
{
  pinMode(pin, OUTPUT);
  _pin = pin;
}

void Sound::wonky_screwdriver() {
  for(int i = 0; i < 1000; i++) {
    soundFX(_pin, 3000.0,30+200*(1+sin(millis()/5000))); 
  }
}

void Sound::sonic_screwdriver() {
  for(int i = 0; i < 1000; i++) {
    soundFX(_pin, 3000.0,30); 
  }
}

void Sound::ray_gun() {
  for(int i = 0; i < 1000; i++) {
    soundFX(_pin, 100.0,30.0); 
  }
}

void Sound::star_trek1() {
  for(int i = 0; i < 10000; i++) {
    soundFX(_pin, 3.0, 30.0); 
  }
}

void Sound::starwars() {
  play_note(_pin, a, 500);
  play_note(_pin, a, 500);    
  play_note(_pin, a, 500);
  play_note(_pin, f, 350);
  play_note(_pin, cH, 150);  
  play_note(_pin, a, 500);
  play_note(_pin, f, 350);
  play_note(_pin, cH, 150);
  play_note(_pin, a, 650);
  delay(500);
 
  play_note(_pin, eH, 500);
  play_note(_pin, eH, 500);
  play_note(_pin, eH, 500);  
  play_note(_pin, fH, 350);
  play_note(_pin, cH, 150);
  play_note(_pin, gS, 500);
  play_note(_pin, f, 350);
  play_note(_pin, cH, 150);
  play_note(_pin, a, 650);
 
  delay(500);

  play_note(_pin, aH, 500);
  play_note(_pin, a, 300);
  play_note(_pin, a, 150);
  play_note(_pin, aH, 500);
  play_note(_pin, gSH, 325);
  play_note(_pin, gH, 175);
  play_note(_pin, fSH, 125);
  play_note(_pin, fH, 125);    
  play_note(_pin, fSH, 250);
 
  delay(325);
 
  play_note(_pin, aS, 250);
  play_note(_pin, dSH, 500);
  play_note(_pin, dH, 325);  
  play_note(_pin, cSH, 175);  
  play_note(_pin, cH, 125);  
  play_note(_pin, b, 125);  
  play_note(_pin, cH, 250);  
 
  delay(350);

}

void Sound::tweetON() {
  tone(_pin, 600); delayMicroseconds(240000); 
  noTone(_pin); delayMicroseconds(60000); 
  tone(_pin, 1000); delayMicroseconds(120000); 
  noTone(_pin); delayMicroseconds(60000); 
  tone(_pin, 1000); delayMicroseconds(60000); 
  noTone(_pin); delayMicroseconds(60000); 
  tone(_pin, 1000); delayMicroseconds(60000); 
  noTone(_pin); delayMicroseconds(60000); 
}

void Sound::tweetOFF() {
  tone(_pin, 600); delayMicroseconds(240000); 
  noTone(_pin);
  tone(_pin, 1000); delayMicroseconds(120000); 
  noTone(_pin); delayMicroseconds(60000); 
  tone(_pin, 1000); delayMicroseconds(60000); 
  noTone(_pin); delayMicroseconds(60000); 
  tone(_pin, 1000); delayMicroseconds(180000); 
  noTone(_pin);
}

void Sound::play_note(int pin, int note, int duration) {
  tone(pin, note, duration);
  delay(duration);
  noTone(pin);
  delay(50);
}

void Sound::soundFX(int pin, float amplitude, float period){ 

  int uDelay = 2+amplitude+amplitude*sin(millis()/period);

  for(int i=0;i<5;i++){
    digitalWrite(pin,HIGH);
    delayMicroseconds(uDelay);
    digitalWrite(pin,LOW);
    delayMicroseconds(uDelay);
  }

}

