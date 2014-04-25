/*
  This is code for Arduino.
  It turns on vibrating motors and LED lights in sequence, then repeats.
 */

int startPin = 22; //digital pin number on Arduino board
int numPins = 15;

int delayMid = 200;
int delayAtEnd = 500;

// the setup routine runs once when you press reset:
void setup() {                
  // initialize the digital pins as outputs.
  for(int i = startPin; i < startPin+numPins; i++) {
    pinMode(i, OUTPUT); 
  }
}

// the main loop routine
void loop() {
  // turn on then off each element in sequence
  for(int i = startPin; i < startPin+numPins; i++) {
    digitalWrite(i, HIGH); //turn on
    delay(delayMid);
    digitalWrite(i, LOW);  //turn off
  }
  delay(delayAtEnd);               
}
