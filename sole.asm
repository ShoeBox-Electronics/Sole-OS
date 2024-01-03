  .org $8000

reset:
  ; Init Stack
  ldx #$ff
  txs
  ; Main
  jsr LCD_init
  jsr display_splash_screen

loop:
  jmp loop

message_1:      .asciiz "This is ShoeBox"  
message_2:      .asciiz "Running Sole OS"

display_splash_screen:
  ; Load message_1 into the STRING_PTR
  lda #<message_1       ; #< Means low byte of the address of a label.  
  sta STRING_PTR        ; Save to pointer  
  lda #>message_1       ; #> Means high byte of the address of a label.  
  sta STRING_PTR + 1    ; Save to pointer + 1  
  jsr LCD_print_string  ; Go print the string

  lda #$40              ; Second line of LCD display
  jsr LCD_goto_address

  ; Load message_2 into the STRING_PTR
  lda #<message_2        ; #< Means low byte of the address of a label.  
  sta STRING_PTR         ; Save to pointer  
  lda #>message_2        ; #> Means high byte of the address of a label.  
  sta STRING_PTR + 1     ; Save to pointer + 1  
  jsr LCD_print_string   ; Go print the string

  rts

nmi:
  rti
  
irq:
  rti

  .include "lib/lcd.asm"

  .org $fffa    ; Vector Sector
  .word nmi     ; NMI Destination
  .word reset   ; Reset Destination
  .word irq     ; IRQ Destination
