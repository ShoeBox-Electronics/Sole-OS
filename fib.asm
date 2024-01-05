  .org $8000

reset:
  ; Init Stack
  ldx #$ff
  txs
  ; Main
  jsr LCD_init

  lda #10
  sta MATH_FIB_LIMIT
  jsr MATH_fibonacci

loop:
  jmp loop

nmi:
  rti
  
irq:
  rti

  .include "address_map.asm"
  .include "lib/lcd.asm"
  .include "lib/math.asm"

  .org $fffa    ; Vector Sector
  .word nmi     ; NMI Destination
  .word reset   ; Reset Destination
  .word irq     ; IRQ Destination
  