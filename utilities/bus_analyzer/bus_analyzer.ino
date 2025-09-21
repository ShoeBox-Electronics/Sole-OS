// #define CLOCK_IN 2
#define CLOCK_OUT 4
#define READ_WRITE 3

const char ADDR_PINS[] = {22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52};
const char DATA_PINS[] = {53, 51, 49, 47, 45, 43, 41, 39};

void setManyPinMode(char pins[], char mode)
{
  for (int i = 0; i < sizeof(pins); i++)
  {
    pinMode(pins[i], mode);
  }
}

unsigned int printBitsAndReturnHex(char pins[], int size)
{
  unsigned int hex = 0;

  for (int i = 0; i < size; i++)
  {
    int bit = digitalRead(pins[i]) ? 1 : 0;
    Serial.print(bit);
    hex = (hex << 1) + bit;
  }

  return hex;
}

void displayBus()
{
  unsigned int address = printBitsAndReturnHex(ADDR_PINS, 16);
  Serial.print(digitalRead(READ_WRITE) ? "  1  " : "  0  ");
  unsigned int data = printBitsAndReturnHex(DATA_PINS, 8);

  char output[15];
  sprintf(output, "   %04x  %s  %02x", address, digitalRead(READ_WRITE) ? "r" : "W", data);
  Serial.println(output);
}

void setup()
{
  setManyPinMode(ADDR_PINS, INPUT);
  setManyPinMode(DATA_PINS, INPUT);
  // pinMode(CLOCK_IN, INPUT);
  pinMode(READ_WRITE, INPUT);
  pinMode(CLOCK_OUT, OUTPUT);

  // attachInterrupt(digitalPinToInterrupt(CLOCK_IN), displayBus, RISING);

  Serial.begin(57600);
}

void loop()
{
  digitalWrite(CLOCK_OUT, HIGH);  // turn the LED on (HIGH is the voltage level)
  displayBus();
  digitalWrite(CLOCK_OUT, LOW);   // turn the LED off by making the voltage LOW
}
