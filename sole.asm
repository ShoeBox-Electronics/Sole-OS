  .setcpu "65C02"
  .segment "SOLE"
  .include "address_map.asm"
  .include "lib/lcd.asm"
  .include "lib/math.asm"
  .include "lib/time.asm"

reset:
  ; Init Stack
  ldx #$ff
  txs
  ; Main
  jsr LCD_init
  jsr LCD_display_splash_screen
  lda #3
  jsr TIME_delay_s
  jsr LCD_clear_display
  lda #5
  jsr TIME_delay_ts 

loop:
  jsr init_fib
display_loop:
  ; calculate next fibs
  jsr MATH_fibonacci
  jsr show_results
  ; print out results and increment fib counter
  dec MATH_FIB_LIMIT
  lda MATH_FIB_LIMIT
  beq loop
  jmp display_loop

convert_and_print_num:
  jsr MATH_hexdec_convert
  ; store output location into string pointer
  lda #<MATH_HEXDEC_OUT    ; #< Means low byte of the address of a label.  
  sta LCD_STRING_PTR       ; Save to pointer  
  lda #>MATH_HEXDEC_OUT    ; #> Means high byte of the address of a label.  
  sta LCD_STRING_PTR + 1   ; Save to pointer + 1  
  ; print the string at the string pointer
  jsr LCD_print_string
  ; return
  rts

init_fib:
  lda #0 
  sta MATH_INPUT_1
  sta MATH_INPUT_1 + 1
  sta MATH_INPUT_2
  sta MATH_INPUT_2 + 1
  sta MATH_OUTPUT + 1
  lda #1
  sta MATH_OUTPUT
  lda #23
  sta MATH_FIB_LIMIT
  ; return
  rts

show_results:
  jsr LCD_clear_display
  ; print INPUT_1
  lda MATH_INPUT_1
  sta MATH_HEXDEC_VAL
  lda MATH_INPUT_1 + 1
  sta MATH_HEXDEC_VAL + 1
  jsr convert_and_print_num
  ; print '+'
  lda #'+'
  jsr LCD_print_char
  ; print INPUT_2
  lda MATH_INPUT_2
  sta MATH_HEXDEC_VAL
  lda MATH_INPUT_2 + 1
  sta MATH_HEXDEC_VAL + 1
  jsr convert_and_print_num
  ; print '='
  lda #'='
  jsr LCD_print_char
  ; Second row, second column
  lda #$41
  jsr LCD_goto_address
  ; print OUTPUT
  lda MATH_OUTPUT
  sta MATH_HEXDEC_VAL
  lda MATH_OUTPUT + 1
  sta MATH_HEXDEC_VAL + 1
  jsr convert_and_print_num
  ; wait one second
  lda #1
  jsr TIME_delay_s
  ; return
  rts

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
  