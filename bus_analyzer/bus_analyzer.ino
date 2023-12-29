#define CLOCK 2
#define READ_WRITE 3

const char ADDR[] = {22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52};
const char DATA[] = {39, 41, 43, 45, 47, 49, 51, 53};

void setPinsMode(char pins[], char mode) {
  for (int i=0; i < sizeof(pins); i++) {
    pinMode(pins[i], mode);
  }
}

unsigned int printBitsAndReturnHex(char pins[], int size) {
  unsigned int hex = 0;
  for (int i=0; i < size; i++) {
    int bit = digitalRead(pins[i]) ? 1 : 0;
    Serial.print(bit);
    hex = (hex << 1) + bit;
  }
  return hex;
}

void onClock() {
  unsigned int address = printBitsAndReturnHex(ADDR, 16);

  Serial.print("  ");

  unsigned int data = printBitsAndReturnHex(DATA, 8);

  char output[15];
  sprintf(output, "   %04x  %s  %02x", address, digitalRead(READ_WRITE) ? "r" : "W",  data);
  Serial.print(output);

  Serial.println();
}

void setup() {
  setPinsMode(ADDR, INPUT);
  setPinsMode(DATA, INPUT);
  pinMode(CLOCK, INPUT);
  pinMode(READ_WRITE, INPUT);

  attachInterrupt(digitalPinToInterrupt(CLOCK), onClock, RISING);

  Serial.begin(57600);
}

void loop() {}
