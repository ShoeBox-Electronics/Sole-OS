import sys

result_file1 = open(sys.argv[2],'wb')
result_file2 = open(sys.argv[3],'wb')
a = 0
for b in open(sys.argv[1], 'rb').read():
  if a < 16384:
    result_file1.write(b'0x%02X,' % b)
  else:
    result_file2.write(b'0x%02X,' % b)
  a = a + 1
result_file1.close()
result_file2.close()