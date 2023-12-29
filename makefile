cygwinPath = /c/cygwin64
miniproPath = ~/MiniproCC65

all: rom.bin

rom.bin:
	python make_rom.py

dump: rom.bin
	hexdump rom.bin

write: rom.bin
	$(cygwinPath)/bin/bash.exe -l -c $(miniproPath)/minipro.exe
