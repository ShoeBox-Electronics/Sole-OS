cygwinPath = /c/cygwin64 # change me to the correct path (windows only)
miniproPath = ~/MiniproCC65 # change me to the correct path (windows only)
miniproArgs = -p AT28C256 -w rom.bin

all: rom.bin

rom.bin:
	python make_rom.py

dump: rom.bin
	hexdump rom.bin

write: rom.bin
	ifeq ($(OS),Windows_NT)
		$(cygwinPath)/bin/bash.exe -l -c $(miniproPath)/minipro.exe $(miniproArgs)
	else
			minipro $(miniproArgs)
	endif
