Z_VAR0 = $00		; a zeropage address pointer - 2 bytes
Z_VAR1 = $02		; a zeropage address pointer - 2 bytes
Z_VAR2 = $04		; a zeropage address pointer - 2 bytes
Z_VAR3 = $16		; a zeropage address pointer - 2 bytes

VAR0 = $2000    ; a regular memory address on the RAM - 16 bytes
VAR1 = $2010    ; a regular memory address on the RAM - 16 bytes
VAR2 = $2020    ; a regular memory address on the RAM - 16 bytes
VAR3 = $2030    ; a regular memory address on the RAM - 16 bytes

  .org $8000    ; Our start memory location indicator

reset:          ; Setup
  ; Init Stack
  ldx #$ff
  txs
  ; Main
  jsr lcd_init
  jsr example_soubroutine

loop:
  jmp loop

example_soubroutine:
  rts

nmi:
  rti
  
irq:
  rti

  .include "lcd.asm"

  .org $fffa    ; Vector Sector
  .word nmi     ; NMI Destination
  .word reset   ; Reset Destination
  .word irq     ; IRQ Destination