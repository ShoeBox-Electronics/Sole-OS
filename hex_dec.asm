  .org $8000

reset:
  ; Init Stack
  ldx #$ff
  txs
  ; Main
  jsr LCD_init

  ; Initialize the value to be the number to convert
  lda number
  sta HEXDEC_VAL
  lda number + 1
  sta HEXDEC_VAL + 1

  jsr MATH_hexdec_convert

  lda #<HEXDEC_OUT    ; #< Means low byte of the address of a label.  
  sta STRING_PTR      ; Save to pointer  
  lda #>HEXDEC_OUT    ; #> Means high byte of the address of a label.  
  sta STRING_PTR + 1  ; Save to pointer + 1  

  jsr LCD_print_string

loop:
  jmp loop

nmi:
  rti
  
irq:
  rti

number: .word $B520 ; largest 2-byte Fibonacci number

  .include "lib/lcd.asm"
  .include "lib/math.asm"

  .org $fffa    ; Vector Sector
  .word nmi     ; NMI Destination
  .word reset   ; Reset Destination
  .word irq     ; IRQ Destination
  