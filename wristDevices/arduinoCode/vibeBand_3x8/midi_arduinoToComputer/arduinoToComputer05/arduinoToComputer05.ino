/*
 Attempting to send midi data from Arduino back to the virtual synth
 qsynth using the Arduino Midi Library
 
 Similar to:
 http://www.arduino.cc/en/Tutorial/Midi
 */

void setup() {
  //  Set MIDI baud rate:
  Serial.begin(9600);
}

void loop() {
    //Note on channel 1 (0x90), note, middle velocity (0x45):
    noteOn(0x90, 0x3C, 0x45);
    delay(500);
    //Note on channel 1 (0x90), note, silent velocity (0x00):
    noteOn(0x90, 0x3C, 0x00);   
    delay(250);
}

//  plays a MIDI note.  Doesn't check to see that
//  cmd is greater than 127, or that data values are less than 127:
void noteOn(int cmd, int pitch, int velocity) {
  Serial.write(cmd);
  Serial.write(pitch);
  Serial.write(velocity);
}

