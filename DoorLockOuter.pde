//Code for door lock project, outer Arduino mounted on door
//Dan Heidel

byte Rx = 0, Tx = 1;
byte KeyIn1 = 2, KeyIn2 = 3, KeyIn3 = 4;
byte KeyOut1 = 5, KeyOut2 = 6, KeyOut3 = 7, KeyOut4 = 8;
byte LEDR = 9, LEDG = 10, LEDB = 11;
byte Switch = 12;
byte NO = 14, NC = 15;

void setup() {
  pinMode(Rx, INPUT);
  pinMode(Tx, OUTPUT);
  pinMode(KeyIn1, OUTPUT);
  digitalWrite(KeyIn1, HIGH); 
  pinMode(KeyIn2, OUTPUT);
  digitalWrite(KeyIn2, HIGH); 
  pinMode(KeyIn3, OUTPUT);
  digitalWrite(KeyIn3, HIGH); 
  pinMode(KeyOut1, INPUT);
  digitalWrite(KeyOut1, HIGH); //set pullup resistor
  pinMode(KeyOut2, INPUT);
  digitalWrite(KeyOut2, HIGH); //set pullup resistor
  pinMode(KeyOut3, INPUT);
  digitalWrite(KeyOut3, HIGH); //set pullup resistor
  pinMode(KeyOut4, INPUT);
  digitalWrite(KeyOut4, HIGH); //set pullup resistor
  pinMode(LEDR, OUTPUT);
  pinMode(LEDG, OUTPUT);
  pinMode(LEDB, OUTPUT);
  pinMode(Switch, OUTPUT);
  pinMode(NO, INPUT);
  digitalWrite(NO, HIGH); //set pullup resistor
  pinMode(NC, INPUT);
  digitalWrite(NC, HIGH); //set pullup resistor
  
  Serial.begin(9600);
}

byte ReadKeypad()
{
  //The keypad reads keys 1-9 (no 0) and two function keys with a set of 3 and 4 lines
  //connected through keypresses.  I've abitrarily decided to call the 3 line bundle input and the 4 line
  //set output.  
  //All of the input lines are set with pullup resistors so active connections are tested by looking for 
  //output lines being pulled to LOW
  //The mapping is as follows:
  //Key    input    output
  //1      2        4
  //2      1        1
  //3      1        3
  //4      1        2
  //5      1        4
  //6      3        1
  //7      3        3
  //8      3        2
  //9      3        4
  //A      2        1
  //B      2        3
  
  boolean KeyArray[4][4]; 
  int KeyTotal = 0;
  
  //Set all 3 keypad input lines to HIGH as a check to make sure keypad has no sorts, etc
  digitalWrite(KeyIn1, HIGH);
  digitalWrite(KeyIn2, HIGH);
  digitalWrite(KeyIn3, HIGH);
  KeyArray[3][0] = digitalRead(KeyOut1);
  KeyArray[3][1] = digitalRead(KeyOut2);
  KeyArray[3][2] = digitalRead(KeyOut3);
  KeyArray[3][3] = digitalRead(KeyOut4);
  
  //Set input 1 to low and check the outputs
  digitalWrite(KeyIn1, LOW);
  KeyArray[0][0] = digitalRead(KeyOut1);
  KeyArray[0][1] = digitalRead(KeyOut2);
  KeyArray[0][2] = digitalRead(KeyOut3);
  KeyArray[0][0] = digitalRead(KeyOut4);
  
  //Set input 1 back to HIGH and input 2 to LOW
  digitalWrite(KeyIn1, HIGH);
  digitalWrite(KeyIn2, LOW);
  KeyArray[1][0] = digitalRead(KeyOut1);
  KeyArray[1][1] = digitalRead(KeyOut2);
  KeyArray[1][2] = digitalRead(KeyOut3);
  KeyArray[1][3] = digitalRead(KeyOut4);
  
  //Set input 2 back to HIGH and input 3 to LOW
  digitalWrite(KeyIn2, HIGH);
  digitalWrite(KeyIn3, LOW);
  KeyArray[2][0] = digitalRead(KeyOut1);
  KeyArray[2][1] = digitalRead(KeyOut2);
  KeyArray[2][2] = digitalRead(KeyOut3);
  KeyArray[2][3] = digitalRead(KeyOut4);
  
  //Set input 3 back to HIGH
  digitalWrite(KeyIn3, HIGH);
  
  //if any of the first set of reads is LOW, something is wrong with the keypad, return an error code
  if(KeyArray[3][0] == LOW || KeyArray[3][1] == LOW || KeyArray[3][2] == LOW || KeyArray[3][3] == LOW)
    return 255;
    
  //total up the number of pressed keys
  KeyTotal = 0;
  for(int rep=0;rep<3;rep++)
  {
    for(int rep2=0;rep2<4;rep2++)
    {
      if(KeyArray[rep][rep2] == LOW) KeyTotal++;
    }
  }
  //if no keys are pressed, return 0
  if(KeyTotal == 0) return 0;
  //if more than one key is pressed, return a multiple keypress error
  if(KeyTotal > 1) return 123;
  
  if(KeyArray[1][3] == LOW) return 1;
  if(KeyArray[0][0] == LOW) return 2;
  if(KeyArray[0][2] == LOW) return 3;
  if(KeyArray[0][1] == LOW) return 4;
  if(KeyArray[0][3] == LOW) return 5;
  if(KeyArray[2][0] == LOW) return 6;
  if(KeyArray[2][2] == LOW) return 7;
  if(KeyArray[2][1] == LOW) return 8;
  if(KeyArray[2][3] == LOW) return 9;
  //Button A
  if(KeyArray[1][0] == LOW) return 11;
  //Button B
  if(KeyArray[1][2] == LOW) return 12;
  
  //if, for some reason, the function hasn't returned yet, return error message
  return 254;
}

void loop() {
  
}
