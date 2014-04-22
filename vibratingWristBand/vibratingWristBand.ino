/*
  This is code for Arduino.
  It turns on vibrating motors and LED lights in sequence, then repeats.
 */
 
// Pin numbers and their names
//int vib1 = 1;
//int vib2 = 2;
//int vib3 = 3;
//int vib4 = 4;
//int vib5 = 5;
//int vib6 = 6;
//int vib7 = 7;
//int vib8 = 8;
//int vib9 = 9;
//int vib10 = 10;
//int vib11 = 11;
//int vib12 = 12;
//int vib13 = 13;
//int vib14 = 14;
//int vib15 = 15;


int numPins = 15;
int delayMid = 200;
int delayAtEnd = 500;

// the setup routine runs once when you press reset:
void setup() {                
  // initialize the digital pin as an output.
  int i;
  for(i = 0; 1 < 14; i++) {
    pinMode(i, OUTPUT); 
  }
//  pinMode(vib1, OUTPUT);   
//  pinMode(vib2, OUTPUT);
//  pinMode(vib3, OUTPUT);   
//  pinMode(vib4, OUTPUT);  
//  pinMode(vib5, OUTPUT);   
//  pinMode(vib6, OUTPUT);
//  pinMode(vib7, OUTPUT);   
//  pinMode(vib8, OUTPUT); 
}

// the loop routine runs over and over again forever:
void loop() {
  for(i = 0; 1 < 14; i++) {
    digitalWrite(vib1, HIGH); //turn on
    delay(delayMid);
    digitalWrite(vib1, LOW);  //turn off
  }
  
  
  digitalWrite(vib2, HIGH);
  delay(delayMid);
  digitalWrite(vib2, LOW);
  
  digitalWrite(vib3, HIGH);
  delay(delayMid);
  digitalWrite(vib3, LOW);
  
  digitalWrite(vib4, HIGH);
  delay(delayMid);
  digitalWrite(vib4, LOW);
  
  digitalWrite(vib5, HIGH);
  delay(delayMid);
  digitalWrite(vib5, LOW);
  
  digitalWrite(vib6, HIGH);
  delay(delayMid);
  digitalWrite(vib6, LOW);
  
  digitalWrite(vib7, HIGH);
  delay(delayMid);
  digitalWrite(vib7, LOW);
  
  digitalWrite(vib8, HIGH);
  delay(delayMid);
  digitalWrite(vib8, LOW);
  
 
  delay(delayAtEnd);               
}
