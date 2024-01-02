vasmPath = /c/Users/joeps/bin/vasm

all: sole

resole:
	rm -f ./sole.bin
	make sole
sole: sole.bin
sole.bin: sole.asm
	$(vasmPath)/vasm6502_oldstyle -dotdir sole.asm -Fbin -o sole.bin 

dump: sole.bin
	hexdump sole.bin

.PHONY: sole
.PHONY: dump
.PHONY: write
.PHONY: assemble
