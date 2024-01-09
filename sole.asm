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
  lda #5 
  jsr TIME_delay_ts ; pause for half a second 

loop:
  jsr FIB_init
display_loop:
  ; calculate next fibs
  jsr FIB_progress
  lda FIB_LIMIT
  beq loop
  jmp display_loop

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
  