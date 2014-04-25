
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
const int vibes_button[8] = {43, 45, 47, 49};

int buttonsStates[8]=      {0, 0, 0, 0, 0, 0, 0, 0}; //-1 init?

const int numElems = 8;
const int flashDelay = 50;
const int delayMid = 50;
int bState = 0;

// variables will change:
//int bState_01, bState_02, bState_03, bState_04, bState_05, bState_06, bState_07, bState_08 = 0;  // variable for reading the pushbutton status

void setup() {
  //set up input and output pins
  for(int i = 0; i < numElems; i++) {
    pinMode(buttons_all[i], INPUT);
    pinMode(LEDs_all[i], OUTPUT);
    pinMode(vibes_all[i], OUTPUT);
  }
}

//the main loop
void loop() {
  //do something based on the button pressed
  respondToButtonPressed(getFirstButtonPressed());
}

//the functions called according to each button pressed
void respondToButtonPressed(int button) {
  switch (button) {
    case 1: //first button
      //digitalWrite(13, HIGH);
      //delay(flashDelay);
      //digitalWrite(13, LOW);
      flashLEDs(LEDs_all, 3);
      break;
    case 2:
    break;
  } 
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
      //return the button number at first button pressed
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

//send a specific array of LED pins and flash them
void flashLEDs(const int input[], int numFlashes) {
  // repeat ON/OFF cycles this many times
  for(int i = 0; i < numFlashes; i++) {
     //turn ON LEDs
     for(int i = 0; i < sizeof(input); i++) {
       digitalWrite(input[i], HIGH); 
     }
     delay(flashDelay); //wait
     //turn OFF LEDs
     for(int i = 0; i < sizeof(input); i++) {
       digitalWrite(input[i], LOW); 
     }
  }
}
