FILEPATH = ./sole

.PHONY: sole
sole: sole.bin ## assemble sole.bin
sole.bin: sole.asm assemble

.PHONY: resole
resole: reassemble ## delete and reassemble sole.bin

.PHONY: remove
remove:
	rm -f ${FILEPATH}.bin

.PHONY: assemble
assemble: ## assemble a specific file using FILEPATH=./path/to/file
	vasm6502_oldstyle -dotdir ${FILEPATH}.asm -Fbin -o ${FILEPATH}.bin

.PHONY: reassemble
reassemble: remove assemble ## delete and reassemble a specific file using FILEPATH=./path/to/file

.PHONY: dump
dump: sole.bin ## print out a hexdump of sole.bin
	hexdump sole.bin 

.PHONY: write
write: ## writes a specific binary to the EEPROM using FILEPATH=./path/to/file
ifeq ($(shell uname),Windows_NT)     # is Windows_NT on XP, 2000, 7, Vista, 10...
	@echo Can\\'t write to an EEPROM from a CLI on a Windows machine
	@echo \\(get in touch with me if you know how\\)
else
	minipro -p AT28C256 -w ${FILEPATH}.bin
endif

.PHONY: cobble
cobble: write ## write sole.bin to the EEPROM

.PHONY: help
help: ## display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@printf "\n\033[36m%-30s\033[0m %s\n" "Note:" "When using the FILEPATH variable, don't include the file's extension"

# .PHONY: build
# build:
# 	docker build -t sole .

# .PHONY: sh ## opens a shell to the shoebox docker container
# sh: 
# 	docker-compose run -it sole 

# .PHONY: down
# down: ## kills the shoebox docker container
# 	docker-compose down
