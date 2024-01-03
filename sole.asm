  .org $8000

reset:
  ; Init Stack
  ldx #$ff
  txs
  ; Main
  jsr lcd_init
  jsr display_splash_screen

loop:
  jmp loop

message_1:      .asciiz "This is ShoeBox"  
message_2:      .asciiz "Running Sole OS"

display_splash_screen:
  ; Load message_1 into the STRING_PTR
  lda #<message_1         ; #< means low byte of the address of a label.  
  sta STRING_PTR         ; save to pointer  
  lda #>message_1         ; #> means high byte of the address of a label.  
  sta STRING_PTR + 1     ; save to pointer + 1  
  jsr lcd_print_string

  jsr lcd_go_home_second_row

  ; Load message_2 into the STRING_PTR
  lda #<message_2         ; #< means low byte of the address of a label.  
  sta STRING_PTR         ; save to pointer  
  lda #>message_2         ; #> means high byte of the address of a label.  
  sta STRING_PTR + 1     ; save to pointer + 1  
  jsr lcd_print_string

  rts

nmi:
  rti
  
irq:
  rti

  .include "lcd.asm"

  .org $fffa    ; Vector Sector
  .word nmi     ; NMI Destination
  .word reset   ; Reset Destination
  .word irq     ; IRQ Destination