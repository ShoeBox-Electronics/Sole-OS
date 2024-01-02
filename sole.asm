MESSAGE_PTR = $00		; a zeropage address pointer  

  .org $8000

reset:
  ; Init Stack
  ldx #$ff
  txs
  ; Main
  jsr lcd_init

  lda #<message_1         ; #< means low byte of the address of a label.  
  sta MESSAGE_PTR         ; save to pointer  
  lda #>message_1         ; #> means high byte of the address of a label.  
  sta MESSAGE_PTR + 1     ; save to pointer + 1  
  jsr print_message

; load message_2 location to be printed  
  lda #<message_2  
  sta MESSAGE_PTR  
  lda #>message_2  
  sta MESSAGE_PTR + 1  
  jsr print_message

loop:
  jmp loop

message_1:      .asciiz "This is ShoeBox                         "  
message_2:      .asciiz "Running Sole OS"

print_message:
  ldy #0
print_next_char:
  lda (MESSAGE_PTR),y
  beq end_print_message
  jsr lcd_print_char
  iny
  jmp print_next_char
end_print_message:
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