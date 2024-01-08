FILEPATH = ./sole

# determine OS
ifeq ($(OS),Windows_NT)
    OS :=  Windows
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        OS := Linux
    endif
    ifeq ($(UNAME_S),Darwin)
        OS := MacOS
    endif
endif

.PHONY: all
ifeq ($(OS),Windows)
all: assemble link ## assemble, link, and write file to the EEPROM (if possible)
else
all: assemble link write
endif

# Aliases
.PHONY: i
.PHONY: a
.PHONY: l
.PHONY: d
.PHONY: w
.PHONY: h
i: install
a: assemble
l: link
d: dump
w: write
h: help

.PHONY: install
ifeq ($(OS),Linux)
ifneq ($(wildcard /etc/debian_version),)
install: ## install all dependencies (only available on Ubuntu)
# Minipro
	apt-get install build-essential pkg-config git libusb-1.0-0-dev
	git clone https://gitlab.com/DavidGriffith/minipro.git && cd minipro && make && make install && cd .. && rm -rf minipro
# CC65
	apt-get install cc65
else
install:
	@echo only available on Ubuntu
endif
else
install:
	@echo only available on Ubuntu
endif

.PHONY: assemble
assemble: ${FILEPATH}.asm ## assemble a file
	ca65 ${FILEPATH}.asm

.PHONY: link ## link a config and assembled file to create a binary
link: ${FILEPATH}.cfg ${FILEPATH}.o
	ld65 -C ${FILEPATH}.cfg -o ${FILEPATH}.bin ${FILEPATH}.o

.PHONY: dump
dump: ${FILEPATH}.bin ## view a file's hex contents
	hexdump -C ${FILEPATH}.bin

.PHONY:  write
write: ${FILEPATH}.bin ## write a binary to the EEPROM
ifeq ($(OS),Windows)
	@echo Can\\'t write to an EEPROM from a CLI on a Windows machine
	@echo \\(get in touch with me if you know how\\)
else
	minipro -p AT28C256 -w ${FILEPATH}.bin
endif

.PHONY: help
help: ## display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@printf "\n\033[36m%-30s\033[0m %s\n" "Note:" "Most commands can be pointed towards a specific file by using the FILEPATH variable"
	@printf "\033[36m%-30s\033[0m %s\n" "" "When using this variable, do not give the file's extension"

# Docker targets
# .PHONY: build
# build:
# 	docker build -t sole .

# .PHONY: sh ## opens a shell to the shoebox docker container
# sh: 
# 	docker-compose run -it sole 

# .PHONY: down
# down: ## kills the shoebox docker container
# 	docker-compose down
