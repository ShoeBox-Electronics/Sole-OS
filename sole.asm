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
  ; jsr LCD_display_splash_screen

  jsr mult_test
loop:
  jmp loop
;   jsr FIB_init
; display_loop:
;   ; calculate next fibs
;   jsr FIB_progress
;   lda FIB_LIMIT
;   beq loop
;   jmp display_loop

mult_test:
  jsr MATH_clear_inputs
  jsr MATH_clear_output

  lda #5
  sta MATH_INPUT_1
  lda #$f6
  sta MATH_INPUT_2
  lda #$ff
  sta MATH_INPUT_2 + 1
  
  jsr MATH_mlt
  jsr print ; 5 x -10 = -50
  ; return
  rts

; add_test:
;   jsr MATH_clear_inputs
;   jsr MATH_clear_output
  
;   lda #50
;   sta MATH_INPUT_1
;   sta MATH_INPUT_2

;   jsr MATH_add
;   jsr print ; 50 + 50 = 100
;   ; return
;   rts

; add_test_2:
;   jsr MATH_clear_inputs
;   jsr MATH_clear_output
  
;   lda #$88
;   sta MATH_INPUT_1
;   sta MATH_INPUT_1 + 1
;   lda #$14
;   sta MATH_INPUT_2
;   lda #$77
;   sta MATH_INPUT_2 + 1

;   jsr MATH_add
;   jsr print ; -30584 + 30484 = -100
;   ; return
;   rts

print:
  lda MATH_OUTPUT
  sta MATH_HEXDEC_VAL
  lda MATH_OUTPUT + 1
  sta MATH_HEXDEC_VAL + 1

  jsr MATH_hex_to_decstring
  jsr LCD_display_decstring
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
  