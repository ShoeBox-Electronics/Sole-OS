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
  ; Load message_1 into the LCD_STRING_PTR
  lda #<message_1       ; #< Means low byte of the address of a label.  
  sta LCD_STRING_PTR        ; Save to pointer  
  lda #>message_1       ; #> Means high byte of the address of a label.  
  sta LCD_STRING_PTR + 1    ; Save to pointer + 1  
  jsr LCD_print_string  ; Go print the string

  lda #$40              ; Second line of LCD display
  jsr LCD_goto_address

  ; Load message_2 into the LCD_STRING_PTR
  lda #<message_2        ; #< Means low byte of the address of a label.  
  sta LCD_STRING_PTR         ; Save to pointer  
  lda #>message_2        ; #> Means high byte of the address of a label.  
  sta LCD_STRING_PTR + 1     ; Save to pointer + 1  
  jsr LCD_print_string   ; Go print the string

  rts

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
  