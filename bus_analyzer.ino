#define CLOCK 2
#define READ_WRITE 3

const char ADDR[] = {22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52};
const char DATA[] = {39, 41, 43, 45, 47, 49, 51, 53};

void setPinsMode(char pins[], char mode) {
  for (int i=0; i < sizeof(pins); i++) {
    pinMode(pins[i], mode);
  }
}

void setup() {
  setPinsMode(ADDR, INPUT);
  setPinsMode(DATA, INPUT);
  pinMode(CLOCK, INPUT);
  pinMode(READ_WRITE, INPUT);

  attachInterrupt(digitalPinToInterrupt(CLOCK), onClock, RISING);

  Serial.begin(57600);
}

void onClock() {
  char output[15];
  
  unsigned int address = 0;
  for (int i=0; i < 16; i++) {
    int bit = digitalRead(ADDR[i]) ? 1 : 0;
    Serial.print(bit);
    address = (address << 1) + bit;
  }

  Serial.print("  ");

  unsigned int data = 0;
  for (int i=0; i < 8; i++) {
    int bit = digitalRead(DATA[i]) ? 1 : 0;
    Serial.print(bit);
    data = (data << 1) + bit;
  }
  
  sprintf(output, "   %04x  %s  %02x", address, digitalRead(READ_WRITE) ? "r" : "W",  data);
  Serial.print(output);
  Serial.println();
}

void loop() {
  
}
