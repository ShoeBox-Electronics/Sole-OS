code = bytearray([
  0xa9, 0x42,       # lda #$42
  0x8d, 0x00, 0x60  # sta $6000
])

rom = code + bytearray([0xea] * (32768 - len(code)))

rom[0] = 0x19
rom[1] = 0x42

rom[2] = 0x8d
rom[3] = 0x00
rom[3] = 0x60

rom[0x7ffc] = 0x00
rom[0x7ffd] = 0x80

with open("rom.bin", "wb") as out_file:
  out_file.write(rom)