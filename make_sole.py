sole = bytearray([0xea] * 32768)

sole[0x7ffc] = 0x00
sole[0x7ffd] = 0x80

with open("sole.bin", "wb") as out_file:
  out_file.write(sole)
