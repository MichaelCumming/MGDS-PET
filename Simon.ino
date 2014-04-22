/*

 MGDS-PET Prototype: Simon Wristband
 
 8-button Simon game. LEDs and vib motors are connected in series.
 
 Ryan Maksymic
 Hudson Pridham
 
 OCAD University
 
 Created on April 4, 2014
 
 Modified on:
 * April 22, 2014
 
 References:
 * http://www.instructables.com/id/Arduino-Simple-Simon-Says-Game/
 * 
 
 */


int button[] = {
  1, 2, 3, 4, 5, 6, 7, 8};    // set button pins
int ledVib[] = {
  9, 10, 11, 12, 13, 14, 15, 16};    // set LED/vib motor pins


int turn = 0;    // turn counter
int pressCount = 0;    // button press counter
int randomArray[100];    // stores 100 (arbitrary high number) random values


void setup() 
{
  Serial.begin(9600);

  for(int i = 0; i < 8; i++)    // LED/vib pins are outputs
  {
    pinMode(ledVib[i], OUTPUT);
  }

  for(int j = 0; j < 8; j++)    // button pins are inputs
  {
    pinMode(button[j], INPUT);
  }

  for (int q = 0; q < 8; q++)    // pull up button pins
  {
    digitalWrite(button[q], HIGH);
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

    for (int j = 0; j <= turn; j++)    // display each random number
    {
      Serial.print(randomArray[j]);    // print each random number

      // flash LED and pulse vib motor for each random number:
      digitalWrite(ledVib[randomArray[j]], HIGH);
      delay(400);
      digitalWrite(ledVib[randomArray[j]], LOW);
      delay(100);
    }

    Serial.println("");

    // collect user input:
    while (pressCount <= turn)    // wait until enough buttons have been pressed
    {
      for (int q = 0; q < 8; q++)    // listen to all eight buttons
      {
        if (digitalRead(button[q]) == LOW)    // if a button is pressed
        {
          // illuminate corresponding LED and pulse vib motor:
          digitalWrite(ledVib[q], HIGH);
          delay(400);
          digitalWrite(ledVib[q], LOW);

          if (q == randomArray[pressCount])    // if the input is correct
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
                digitalWrite(ledVib[q], HIGH);
              }
              delay(200);
              for (int q = 0; q < 8; q++)
              {
                digitalWrite(ledVib[q], LOW);
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

