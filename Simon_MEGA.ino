/*

 MGDS-PET Prototype: Simon Wristband
 
 8-button Simon game for MEGA wristband
 
 Ryan Maksymic
 Hudson Pridham
 
 OCAD University
 
 Created on April 4, 2014
 
 Modified on:
 * April 22, 2014
 * May 7, 2014
 
 References:
 * http://www.instructables.com/id/Arduino-Simple-Simon-Says-Game/
 * 
 
 */


int button[] =  {
  22, 23, 24, 25, 26, 27, 28, 29};

int led[] =     {
  32, 33, 34, 35, 36, 37, 38, 39};

int vib[] =    {
  42, 43, 44, 45, 46, 47, 48, 49};


int turn = 0;    // turn counter
int pressCount = 0;    // button press counter
int randomArray[100];    // stores 100 (arbitrary high number) random values

boolean hard = false;    // true = hard mode engaged (no LEDs; only vib motors)


void setup() 
{
  Serial.begin(9600);

  for(int i = 0; i < 8; i++)    // LED/vib pins are outputs
  {
    pinMode(button[i], INPUT);
    pinMode(led[i], OUTPUT);
    pinMode(vib[i], OUTPUT);
  }
}


void loop() 
{
  if (turn == 0)    // if a new game is started
  {
    for (int y = 0; y <= 99; y++)    // create a random 100-number sequence
    {
      randomArray[y] = random(8);
    }

    delay(500);
  }

  for (int i = turn; i <= turn; i++)    // loop through each turn
  {
    // print the turn number:
    Serial.print("Turn: ");
    Serial.print(i);
    Serial.println("");

    // turn on Hard mode after x number of turns:
    if (turn > 4)
    {
      hard = true;
    }

    // display each random number:
    for (int j = 0; j <= turn; j++)
    {
      Serial.print(randomArray[j]);    // print each random number

      // flash LED and pulse vib motor for each random number:
      if (hard == false) digitalWrite(led[randomArray[j]], HIGH);    // only activate LEDs if 
      digitalWrite(vib[randomArray[j]], HIGH);
      delay(400);
      digitalWrite(led[randomArray[j]], LOW);
      digitalWrite(vib[randomArray[j]], LOW);
      delay(100);
    }

    Serial.println("");

    // collect user input:
    while (pressCount <= turn)    // until enough buttons have been pressed,
    {
      for (int q = 0; q < 8; q++)    // listen to all eight buttons
      {
        if (digitalRead(button[q]) == HIGH)    // if a button is pressed,
        {
          // illuminate corresponding LED and pulse vib motor:
          digitalWrite(led[q], HIGH);
          digitalWrite(vib[q], HIGH);
          delay(400);
          digitalWrite(led[q], LOW);
          digitalWrite(vib[q], LOW);

          if (q == randomArray[pressCount])    // if the input is correct,
          {
            Serial.println("YES!");    // print confirmation
            pressCount++;    // increment pressCount
          }
          else    // if the input is incorrect
          {
            Serial.println("GAME OVER");    // print the bad news

            // angry feedback:
            for (int r = 0; r < 5; r++)
            {
              for (int q = 0; q < 8; q++)
              {
                digitalWrite(led[q], HIGH);
                digitalWrite(vib[q], HIGH);
              }
              delay(200);
              for (int q = 0; q < 8; q++)
              {
                digitalWrite(led[q], LOW);
                digitalWrite(vib[q], LOW);
              }
              delay(100);
            }

            // set failure values:
            pressCount = turn;
            turn = -1;
          }
        }
      }
    }

    turn++;    // increment turn
    pressCount = 0;    // reset pressCount
    delay(500);
  }
}

