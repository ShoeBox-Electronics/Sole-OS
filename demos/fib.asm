  .org $8000

reset:
  ; Init Stack
  ldx #$ff
  txs
  ; Main
  jsr LCD_init
  jsr TIME_init

loop:
  lda #0 
  sta MATH_FIB_A
  lda #1
  sta MATH_FIB_B
  lda #12
  sta MATH_FIB_LIMIT
display_loop:
  jsr LCD_clear_display
  ldx MATH_FIB_A
  jsr MATH_fibonacci

  jsr display_current_nums

  lda #1
  jsr TIME_delay_s
  dec MATH_FIB_LIMIT
  lda MATH_FIB_LIMIT
  beq loop
  jmp display_loop

display_current_nums:
  txa
  jsr convert_and_print_num
  lda #"+"
  jsr LCD_print_char
  lda MATH_FIB_A
  jsr convert_and_print_num
  lda #"="
  jsr LCD_print_char
  
  lda #$41
  jsr LCD_goto_address
  lda MATH_FIB_B
  jsr convert_and_print_num

  rts

convert_and_print_num:
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
  .include "lib/time.asm"
  .include "lib/lcd.asm"
  .include "lib/math.asm"

  .org $fffa    ; Vector Sector
  .word nmi     ; NMI Destination
  .word reset   ; Reset Destination
  .word irq     ; IRQ Destination
  