FILEPATH = ./sole

.PHONY: all
ifeq ($(OS),Windows_NT)     # is Windows_NT on XP, 2000, 7, Vista, 10...
  all: assemble link dump
else
  all: assemble link dump write
endif

# Aliases
.PHONY: a
.PHONY: l
.PHONY: w
.PHONY: d
.PHONY: h
a: assemble
l: link
w: write
d: dump
h: help

.PHONY: assemble
assemble: ${FILEPATH}.asm ## assemble a file using FILEPATH=./path/to/file (sole by default)
	ca65 ${FILEPATH}.asm

.PHONY: link
link: ${FILEPATH}.cfg ${FILEPATH}.o
	ld65 -C ${FILEPATH}.cfg -o ${FILEPATH}.bin ${FILEPATH}.o

.PHONY:  write
write: ${FILEPATH}.bin ## write a binary to the EEPROM using FILEPATH=./path/to/file (sole by default)
ifeq ($(OS),Windows_NT)     # is Windows_NT on XP, 2000, 7, Vista, 10...
	@echo Can\\'t write to an EEPROM from a CLI on a Windows machine
	@echo \\(get in touch with me if you know how\\)
else
	minipro -p AT28C256 -w ${FILEPATH}.bin
endif

.PHONY: dump
dump: ${FILEPATH}.bin ## view a file's hex contents using FILEPATH=./path/to/file (sole by default)
	hexdump -C ${FILEPATH}.bin

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
