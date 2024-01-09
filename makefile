FILEPATH = ./sole

# determine OS
ifeq ($(OS),Windows_NT)
	OS :=  Windows
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Darwin)
		OS := MacOS
	else ifeq ($(UNAME_S),Linux)
		OS := Linux
		ifneq ($(wildcard /etc/debian_version),)
		  OS := Debian_Based
      # So we assume it has apt-get
		endif
	endif
endif

# aliases
.PHONY: all install assemble link dump write clean help

ifeq ($(OS),Windows)
all: assemble link ##F assemble, link, and write file to the EEPROM (if possible)
else
all: assemble link write
endif

install: ## install all dependencies (Mac: assumes you have homebrew installed) (Windows: not availbable)
ifeq ($(OS),Debian_Based)
# minipro
	apt-get install build-essential pkg-config libusb-1.0-0-dev
	git clone https://gitlab.com/DavidGriffith/minipro.git && cd minipro && make && make install && cd .. && rm -rf minipro
# CC65
	apt-get install cc65
endif
ifeq ($(OS),MacOS)
	brew install pkg-config
	brew install minipro
	brew install cc65
	brew install libusb

else
	@echo only available on Mac and Debian-based systems
endif

link: $(FILEPATH).bin

%.o: %.asm ##F assemble a file
	ca65 $^

%.bin: %.cfg %.o #Generate a respective *.bin file from any *.cfg and *.o
	ld65 -C $^ -o $@

dump: $(FILEPATH).bin ##F view a file's hex contents
	hexdump -C $^

write: ${FILEPATH}.bin ##F write a binary to the EEPROM (requires Linux/Unix)
ifeq ($(OS),Windows)
	@echo "Can't write to an EEPROM from a CLI on a Windows machine"
	@echo "(get in touch with me if you know how)"
else
	minipro -p AT28C256 -w ${FILEPATH}.bin
endif

help: ## display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?##F .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?##F "}; {printf "\033[36m*%-29s\033[0m %s\n", $$1, $$2}'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@printf "\n\033[36m%-30s\033[0m %s\n" "Note:" "* Commands can be pointed towards a specific file by using the FILEPATH variable."
	@printf "\033[36m%-30s\033[0m %s\n"   ""      "When using this variable, do not give the file's extension."

clean: #Delete all binaries
ifeq ($(OS),Windows)
	del $(FILEPATH).bin $(FILEPATH).o
else
	rm -f *.bin *.o
endif
## Docker targets

# .PHONY: build
# build: ## Builds the Docker stuff
# 	docker build -t sole .

# .PHONY: sh
# sh: ## opens a shell to the shoebox docker container
# 	docker-compose run -it sole

# .PHONY: down
# down: ## kills the shoebox docker container
# 	docker-compose down