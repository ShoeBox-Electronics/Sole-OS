  .setcpu "65C02"
  .segment "SOLE"
  .include "address_map.asm"
  .include "lib/lcd.asm"
  .include "lib/math.asm"
  .include "lib/time.asm"
  .include "lib/fib.asm"

reset:
  ; Init Stack
  ldx #$ff
  txs
  ; Main
  jsr LCD_init
  jsr LCD_display_splash_screen
mult_test:
  jsr MATH_clear_inputs
  jsr MATH_clear_output

  lda #3
  sta MATH_INPUT_1
  lda #5
  sta MATH_INPUT_2
  
  jsr MATH_mlt

  lda MATH_OUTPUT
  sta MATH_HEXDEC_VAL
  lda MATH_OUTPUT + 1
  sta MATH_HEXDEC_VAL + 1

  jsr MATH_hex_to_decstring
  jsr LCD_display_decstring
loop:
  jmp loop
;   jsr FIB_init
; display_loop:
;   ; calculate next fibs
;   jsr FIB_progress
;   lda FIB_LIMIT
;   beq loop
;   jmp display_loop

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
  