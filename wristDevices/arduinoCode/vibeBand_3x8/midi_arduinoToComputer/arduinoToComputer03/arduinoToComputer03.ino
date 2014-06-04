/*
MIDI note on messages with variable velocity
By Amanda Ghassaei
July 2012
http://www.instructables.com/id/Send-and-Receive-MIDI-with-Arduino/

 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.

*/

int noteON = 144;//144 = 10010000 in binary, note on command

void setup() {
  //  Set MIDI baud rate:
  Serial.begin(9600);
}

void loop() {
  int velocity = 20; //set velocity to 20
  for (int note=50; note<70; note++) { //from note 50 (D3) to note 69 (A4)
    MIDImessage(noteON, note, velocity); //turn note on
    delay(300); //hold note for 300ms
    MIDImessage(noteON, note, 0); //turn note off
    delay(200); //wait 200ms until triggering next note
    velocity += 5; //ad 5 to current velocity value
  }
}

//send MIDI message
void MIDImessage(int command, int MIDInote, int MIDIvelocity) {
  Serial.write(command);//send note on or note off command 
  Serial.write(MIDInote);//send pitch data
  Serial.write(MIDIvelocity);//send velocity data
}

