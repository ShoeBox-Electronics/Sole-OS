  .setcpu "65C02"
  .segment "SOLE"
  .include "address_map.asm"
  .include "lib/lcd.asm"
  .include "lib/math.asm"
  .include "lib/time.asm"
  .include "lib/fib.asm"
  .include "lib/test.asm"

reset:
  ; Init Stack
  ldx #$ff
  txs
  ; Main
  jsr LCD_init
  ; jsr LCD_display_splash_screen

  lda #$f0
  sta MATH_CONVERT_VAL
  lda #$fa
  sta MATH_CONVERT_VAL + 1
  jsr MATH_hex_to_hexstring

  jsr LCD_display_math_convert_out

loop:
  jmp loop
;   jsr FIB_init
; display_loop:
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
  