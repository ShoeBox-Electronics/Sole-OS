FILE_PATH = ./sole
vasmPath = /c/Users/joeps/bin/vasm

# write

.PHONY: resole
resole: ## delete sole.bin and reassemble it
	rm -f ./sole.bin
	make sole

.PHONY: sole
sole: sole.bin ## assemble sole.bin
sole.bin: sole.asm 
	/c/Users/joeps/bin/vasm/vasm6502_oldstyle -dotdir ${FILE_PATH}.asm -Fbin -o ${FILE_PATH}.bin

.PHONY: dump
dump: sole.bin ## print out a hexdump of sole.bin
	hexdump sole.bin 

.PHONY: help
help: ## display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: write
write: ## writes sole.bin to the ROM chip (not available on Windows)
ifeq ($(OS),Windows_NT)     # is Windows_NT on XP, 2000, 7, Vista, 10...
	@echo Can\\'t write to an EEPROM from a CLI on a Windows machine
	@echo \\(get in touch with me if you know how\\)
else
	minipro -p AT28C256 -w sole.bin
endif

# .PHONY: build
# build:
# 	docker build -t sole .

# .PHONY: sh ## opens a shell to the shoebox docker container
# sh: 
# 	docker-compose run -it sole 

# .PHONY: down
# down: ## kills the shoebox docker container
# 	docker-compose down
