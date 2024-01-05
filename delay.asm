  .org $8000

COUNTER = $10

reset:
  ; Init Stack
  ldx #$ff
  txs
  ; Main
  jsr LCD_init
  jsr TIME_init

  lda #0
  sta COUNTER

loop:
  jsr LCD_clear_display

  jsr print_counter
  inc COUNTER
  lda #1
  jsr TIME_delay_s
  
  jmp loop

print_counter:
  lda COUNTER
  sta MATH_HEXDEC_VAL
  lda #0
  sta MATH_HEXDEC_VAL + 1

  jsr MATH_hexdec_convert

  lda #<MATH_HEXDEC_OUT    ; #< Means low byte of the address of a label.  
  sta LCD_STRING_PTR       ; Save to pointer  
  lda #>MATH_HEXDEC_OUT    ; #> Means high byte of the address of a label.  
  sta LCD_STRING_PTR + 1   ; Save to pointer + 1  

  jsr LCD_print_string

  rts

nmi:
  rti
  
irq:
  rti

  .include "address_map.asm"
  .include "lib/lcd.asm"
  .include "lib/math.asm"
  .include "lib/time.asm"

  .org $fffa    ; Vector Sector
  .word nmi     ; NMI Destination
  .word reset   ; Reset Destination
  .word irq     ; IRQ Destination
  