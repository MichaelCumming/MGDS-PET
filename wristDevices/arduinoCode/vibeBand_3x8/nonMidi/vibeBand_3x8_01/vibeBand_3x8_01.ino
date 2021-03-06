
//digital pin numbers on the Arduino board (in contiguous blocks of 8)
const int startButtonPin = 22; //22-29 incl

//pin assignments
const int buttons_all[8] =  {22, 23, 24, 25, 26, 27, 28, 29};
const int buttons_top[4] =  {22, 24, 26, 28};
const int buttons_bottom[4] =  {23, 25, 27, 29};

const int LEDs_all[8] =     {32, 33, 34, 35, 36, 37, 38, 39};
const int LEDs_green[4] =   {32, 34, 36, 38};
const int LEDs_red[4] =     {33, 35, 37, 39};

const int vibes_all[8] =    {42, 43, 44, 45, 46, 47, 48, 49};
const int vibes_top[8] =    {42, 44, 46, 48};
const int vibes_bottom[8] = {43, 45, 47, 49};

//keep track of previous button state?
int buttonsStates[8] =      {-1, -1, -1, -1, -1, -1, -1, -1}; //-1 init

int b = -1;
const int numElems = 8;
const int flashDelay = 200;
const int delayMid = 200;
int bState = 0;

void setup() {
  Serial.begin(9600);
  //set up input and output pins on Arduino board
  for(int i = 0; i < numElems; i++) {
    pinMode(buttons_all[i], INPUT);
    pinMode(LEDs_all[i], OUTPUT);
    pinMode(vibes_all[i], OUTPUT);
  }
}

//**************************************************
//the main loop
void loop() {
  //test01_flashAdj();
  test02_flashAll();
  //respondToButton(b);
  //lightIfButton(b); 
}
//**************************************************
//third function 2014-05-01 (put this in the main loop)
void test03_simpleSequences() {

}

//second function 2014-05-01 (put this in the main loop)
void test02_flashAll() {
  //if first button
   int b = getFirstButtonPressed();
   //printToSerial("button_: ", b);
   test02_respondToButton(b);
 }

//first function 2014-05-01 (put this in the main loop)
void test01_flashAdj() {
  b = getFirstButtonPressed();
  flashAdjLED(b);
  flashAdjVibe(b);
  //printToSerial("button: ", b);
  lightLED13(b);
}

//Functions called according to button pressed
void test02_respondToButton(int button) {
  switch (button) {
    case 0: //first button
       //squareWave_ON(LEDs_all, 8);
       rhythm_02(vibes_top, 4, 4, 150);
      break;
    case 1: //second button
       //squareWave_ON(LEDs_green, 4);
      break;
    case 2: //third button
       //squareWave_ON(LEDs_red, 4);
      break;
    case 3: //fourth button
       //squareWave_ON(vibes_all, 8);
      break;
    case 4: //fifth button
       //squareWave_ON(vibes_top, 4);
      break;
    case 5: //sixth button
       //squareWave_ON(vibes_bottom, 4);
      break;
    case 6:
      flashAdjLED(button);
      flashAdjVibe(button);
    case 7:
      flashAdjLED(button);
      flashAdjVibe(button);
    break;
  } 
}

void flashAdjLED(int button) {
  int ledOffset = 32; //based on pin assignments above
  int ledPin = button + ledOffset;
  //printToSerial("ledPin: ", ledPin);
  digitalWrite(ledPin, HIGH);
  delay(flashDelay);
  digitalWrite(ledPin, LOW);
}

void flashAdjVibe(int button) {
  int vibeOffset = 42; //based on pin assignments above
  int vPin = button + vibeOffset;
  //printToSerial("vPin: ", vPin);
  digitalWrite(vPin, HIGH);
  delay(flashDelay);
  digitalWrite(vPin, LOW);
}

void printToSerial(char* message, int n) {
  Serial.print(message);
  Serial.println(n);
  delay(1);
}

void lightLED13(int b) {
  if (b > -1) {
    digitalWrite(13, HIGH);
    delay(flashDelay);
    digitalWrite(13, LOW);
  }  
}


//
void lightIfButton(int bPin) {
  digitalWrite(bPin, HIGH);
  delay(flashDelay);
  digitalWrite(bPin, LOW);
}

//NEXT: respond to patterns when buttons pressed array passed in?

//returns the number of the button pressed; first button = 1
//stops at the first button pressed
//next step: reads all buttons and records in an array?
int getFirstButtonPressed() {
  //cycles through all the buttons
 for(int i = 0; i < numElems; i++) {
    //if button pressed
    if(digitalRead(buttons_all[i]) == HIGH) {
      //record which button was pressed
      //buttonsStates[i] = 1; //'1' means button has been just pressed     
      return i; 
    }
  }
}

//records the states of all buttons
//assumes the buttonsStates array is globally accessible
int getAllButtonsPressed() {
  //cycles through all the buttons
 for(int i = 0; i < numElems; i++) {
    //record states in buttonsStates array
    buttonsStates[i] = digitalRead(buttons_all[i]);
  }
}


const int ON_duration = 200;
const int OFF_duration = 100;

//produces one square wave
void squareWave_ON(const int input[], int inputLength, int onDuration) {
     //turn ON LEDs
     for(int j = 0; j < inputLength; j++) {
       digitalWrite(input[j], HIGH); 
       //printToSerial("input HIGH: ", j);
     }
     //wait
     delay(onDuration);
     //turn OFF LEDs
     for(int k = 0; k < inputLength; k++) {
       digitalWrite(input[k], LOW); 
     }
}

//produces a single square wave
//OFF_duration = duration of wave at zero
void squareWave_repeat(const int input[], int arrayLength, int numRepeats, int onDuration) {
  for (int i = 0; i < numRepeats; i++) {
    squareWave_ON(input, arrayLength, onDuration);
    delay(OFF_duration);
  }
}

//rhythms based on durations and repeats (not dynamics of square waves)
void rhythm_01(const int input[], int arrayLength, int numRepeats, int onDuration) {
  for (int i = 0; i < numRepeats-1; i++) {
  for (int j = 0; j < numRepeats-1; j++) {
    squareWave_ON(input, arrayLength, onDuration);
    delay(onDuration*0.50);
  }
  for (int k = 0; k < numRepeats+1; k++) {
    squareWave_ON(input, arrayLength, onDuration);
    delay(onDuration*2.00);
  }
  }
}
//strong beat followed by weaker ones
void rhythm_02(const int input[], int arrayLength, int numRepeats, int onDuration) {
  for (int i = 0; i < numRepeats; i++) {
  squareWave_ON(input, arrayLength, onDuration*2.00);
  delay(onDuration*0.50); 
  for (int i = 0; i < numRepeats-1; i++) {
      squareWave_ON(input, arrayLength, onDuration*1.00);
      delay(onDuration*1.00);
   }
  }
}

