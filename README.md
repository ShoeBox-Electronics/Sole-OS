# Sole-OS

## Requirements
* [cygwin](https://www.cygwin.com/) (windows only, needed to run minipro)
* [minipro](https://gitlab.com/DavidGriffith/minipro/) (needed to flash an EEPROM from CLI)
* [hexdump for windows](https://www.di-mgt.com.au/hexdump-for-windows.html) (windows only, needed to view binaries as hex code in CLI)
* [vasm](http://sun.hasenbraten.de/vasm/) (to compile the assembly into byte code)

On Windows, you will need to install these manually if not already installed.
On Linux or Mac, just run `sudo make install`. Note that the Mac installation assumes that Homebrew is already installed!

## Build Options
Commands can be pointed towards a specific file by using the `FILEPATH` variable.
When using this variable, do not give the file's extension.
For example, to generate `test.bin` from `test.asm` and `test.cfg`, you would run the following:
```
make FILEPATH=test
```
Below is a complete list of all available make commands.

|Command|Description|
|---|---|
|`make` or `make all`|Assemble, link, and write file to the EEPROM (if possible).|
|`make assemble`|Compile the assembly source.|
|`make link`|Link the object code generated by the above step.|
|`make write`|Write the generated binary file to EEPROM.|
|`make dump`|View a hexdump of the binary file's contents.|
|`make install`|Install dependencies (see "Requirements" section).|
