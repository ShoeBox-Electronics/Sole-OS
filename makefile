# change below to the correct path (windows only)
cygwinPath = /c/cygwin64
# change below to the correct path (windows only)
miniproPath = ~/MiniproCC65
miniproArgs = -p AT28C256 -w sole.bin
# change below to the correct path
vasmPath = /c/Users/joeps/bin/vasm

all: sole

sole: sole.bin
sole.bin: sole.asm
	$(vasmPath)/vasm6502_oldstyle -dotdir sole.asm -Fbin -o sole.bin 

dump: sole.bin
	hexdump sole.bin

write: sole.bin
	$(cygwinPath)/bin/bash.exe -l -c "$(miniproPath)/minipro.exe $(miniproArgs)"

.PHONY: sole
.PHONY: dump
.PHONY: write
.PHONY: assemble
