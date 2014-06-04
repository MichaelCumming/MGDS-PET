#include <MIDI.h>
// Simple tutorial on how to receive and send MIDI messages.
// Here, when receiving any message on channel 4, the Arduino
// will blink a led and play back a note for 1 second.

#define LED 13 // LED pin on Arduino Uno
void setup()
{
  pinMode(LED, OUTPUT);
  // Initiate MIDI communications, listen to all channels
  MIDI.begin(MIDI_CHANNEL_OMNI);
  // Connect the HandleNoteOn function to the library,
  // so it is called upon reception of a NoteOn.
  MIDI.setHandleNoteOn(HandleNoteOn); // Put only the name of the function
}
void loop()
{
  MIDI.read();
  //  if(MIDI.read(1))
  //  {
  //digitalWrite(LED,HIGH);
  //    MIDI.sendNoteOn(61,127,1);
  //delay(1000); // Wait for a second
  //digitalWrite(LED,LOW);
  //    MIDI.sendNoteOff(61,0,1);
  //  }
}

//note on handing
//remember to switch the WIDI shield to 'run'
void HandleNoteOn(byte channel, byte pitch, byte velocity) {
  if(pitch==60) {
    digitalWrite(LED,HIGH);
    delay(250);
    digitalWrite(LED,LOW);
  }
  
  //MIDI.sendNoteOn(pitch+1,velocity,channel+1);
  //MIDI.sendNoteOn(pitch+1,0,channel+1);

  // Do whatever you want when you receive a Note On.
  //Serial.print(int(pitch));
  //printToSerial("channel: ", channel);
  //printToSerial("pitch: ", pitch);
  //printToSerial("velocity: ", velocity);
  //pitchToLED (pitch, velocity);
}








