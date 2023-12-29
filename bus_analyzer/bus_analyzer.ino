#define CLOCK 2
#define READ_WRITE 3

const char ADDR[] = {22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52};
const char DATA[] = {39, 41, 43, 45, 47, 49, 51, 53};

void setManyPinMode(char pins[], char mode) {
  for (int i=0; i < sizeof(pins); i++) {
    pinMode(pins[i], mode);
  }
}

unsigned int printBitsAndReturnHex(char pins[], int size, bool padding) {
  unsigned int hex = 0;

  for (int i=0; i < size; i++) {
    int bit = digitalRead(pins[i]) ? 1 : 0;
    Serial.print(bit);
    hex = (hex << 1) + bit;
  }

  if (padding) Serial.print("  ");

  return hex;
}

void displayBus() {
  unsigned int address = printBitsAndReturnHex(ADDR, 16, true);
  unsigned int data = printBitsAndReturnHex(DATA, 8, false);

  char output[15];
  sprintf(output, "   %04x  %s  %02x", address, digitalRead(READ_WRITE) ? "r" : "W",  data);
  Serial.println(output);
}

void setup() {
  setManyPinMode(ADDR, INPUT);
  setManyPinMode(DATA, INPUT);
  pinMode(CLOCK, INPUT);
  pinMode(READ_WRITE, INPUT);

  attachInterrupt(digitalPinToInterrupt(CLOCK), displayBus, RISING);

  Serial.begin(57600);
}

void loop() {}
