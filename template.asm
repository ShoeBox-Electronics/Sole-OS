  .org $8000

reset:
  ; Init Stack
  ldx #$ff
  txs

  jsr LCD_init

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
