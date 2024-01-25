  .setcpu "65C02"
  .segment "SOLE"
  
  .include "address_map.asm"            ; Addresses for devices and memory variables
  .include "lib/lcd.asm"                ; Lib for working with the HD44780 LCD
  .include "lib/math/math.asm"          ; Lib for math
  .include "lib/time.asm"               ; Lib for time delays
  .include "lib/fib.asm"                ; Lib for Fibonacci numbers

  .include "tests/test.asm"             ; Lib for testing other functions

reset:
  jsr LCD_init
  jsr TEST_suite_all ; when left uncommented, nothing but the test suite will run
  ; jsr LCD_display_splash_screen
  ; jsr FIB_demo
nmi:
  ; return
  rti
  
irq:
  ; return
  rti

  .segment "RESETVEC"

  .word nmi     ; NMI Destination
  .word reset   ; Reset Destination
  .word irq     ; IRQ Destination
  