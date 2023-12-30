#define WRITE_EN 5
#define OUT_EN 6
#define CHIP_EN 7

// Set the EEPROM Address and Data pin numbers
const char ADDR[] = {23, 25, 27, 29, 31, 33, 35, 37, 39, 41, 43, 45, 47, 49, 51};
const char DATA[] = {22, 24, 26, 28, 30, 32, 34, 36};

// Include the first low bytes data file, replace filenames with absolute path
const PROGMEM char MY_DATA_1[] = {
#include "C:\\Users\\joeps\\coding\\ShoeBox\\Sole OS\\a1.csv"
};

// Include the second high bytes data file, requires 2 files due to array limits
const PROGMEM char MY_DATA_2[] = {
#include "C:\\Users\\joeps\\coding\\ShoeBox\\Sole OS\\a2.csv"
};

// Function to write a byte to a specific memory address
void writeAddress(long address, byte data) {
  // Initialise EEPROM Control pins prior to writing data
  digitalWrite(WRITE_EN, HIGH);
  digitalWrite(OUT_EN, HIGH);
  Serial.print("Write ");
  // Set EEPROM Data pins for output
  for (int n = 0; n < 8; n += 1) {
    pinMode(DATA[n], OUTPUT);
  }
  // Set EEPROM Address pins
  for (int n = 0; n < 15; n += 1) {
    digitalWrite(ADDR[n], address & 1);
    Serial.print(address & 1);
    address = address >> 1;
  }
  Serial.print(" ");
  // Set EEPROM Data pins based for the data byte
  for (int n = 0; n < 8; n += 1) {
    digitalWrite(DATA[n], data & 1);
    Serial.print(data & 1);
    data = data >> 1;
  }
  Serial.println("");
  // Cycle write enable to write to EEPROM
  digitalWrite(WRITE_EN, LOW);
  delayMicroseconds(1);
  digitalWrite(WRITE_EN, HIGH);
  digitalWrite(OUT_EN, LOW);
  delay(10);
}

// Function to return a byte from a specific memory address
byte readAddress(long address) {
  // Initialise EEPROM Control pins prior to reading data
  digitalWrite(WRITE_EN, HIGH);
  digitalWrite(OUT_EN, HIGH);
  // Set EEPROM Data pins for input
  for (int n = 0; n < 8; n += 1) {
    pinMode(DATA[n], INPUT);
  }
  // Set EEPROM Address pins
  for (int n = 0; n < 15; n += 1) {
    digitalWrite(ADDR[n], address & 1);
    address = address >> 1;
  }
  // Enable EEPROM Output Enable
  digitalWrite(OUT_EN, LOW);
  // Read and return byte from EEPROM Data pins
  byte data = 0;
  for (int n = 7; n >= 0; n -= 1) {
    data = (data << 1) + digitalRead(DATA[n]);;
  }
  return data;
}

// Print the contents of a range of addresses from the EEPROM
void printContents(int first, int last) {
  Serial.println("Reading EEPROM");
  for (long base = first; base <= last; base += 16) {
    byte data[16];
    for (long offset = 0; offset <= 15; offset += 1) {
      data[offset] = readAddress(base + offset);
    }
    char buf[80];
    sprintf(buf,
      "%04lx:  %02x %02x %02x %02x %02x %02x %02x %02x   %02x %02x %02x %02x %02x %02x %02x %02x",
      base, data[0], data[1], data[2], data[3], data[4], data[5], data[6],
      data[7], data[8], data[9], data[10], data[11], data[12], data[13],
      data[14], data[15]);
    Serial.println(buf);
  }
  Serial.println("Done");
}

void setup() {
  // Set EEPROM Control and Address pins to output
  pinMode(WRITE_EN, OUTPUT);
  pinMode(OUT_EN, OUTPUT);
  pinMode(CHIP_EN, OUTPUT);
  for (int n = 0; n < 15; n += 1) {
    pinMode(ADDR[n], OUTPUT);
  }
  // Initialise EEPROM Control pins
  digitalWrite(WRITE_EN, HIGH);
  digitalWrite(OUT_EN, HIGH);
  digitalWrite(CHIP_EN, LOW);
  // Setup serial monitor output
  Serial.begin(57600);
  // Delay for a second to let the pins settle before writing
  delay(1000); 
  Serial.println("Writing EEPROM");
  // Write the first file to the low addresses
  for (long n = 0; n < sizeof(MY_DATA_1) ; n += 1) {
    writeAddress(n, pgm_read_byte_near(MY_DATA_1 + n));
  }
  // Write the second file to the high addresses
  for (long n = 0; n < sizeof(MY_DATA_2) ; n += 1) {
    writeAddress(n + 16384, pgm_read_byte_near(MY_DATA_2 + n));
  }
  // Print contents of EEPROM to confirm write was successful
  printContents(0, 32767);
}

void loop() {
}