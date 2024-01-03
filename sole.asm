MESSAGE_PTR = $00	  ; a zeropage address pointer - 2 bytes

  .org $8000

reset:
  ; Init Stack
  ldx #$ff
  txs
  ; Main
  jsr lcd_init

  ; Load message_1 into the MESSAGE_PTR
  lda #<message_1         ; #< means low byte of the address of a label.  
  sta MESSAGE_PTR         ; save to pointer  
  lda #>message_1         ; #> means high byte of the address of a label.  
  sta MESSAGE_PTR + 1     ; save to pointer + 1  
  jsr print_message

  ; Set cursor to the beginning of the second line
  lda #(%10000000|$40)
  jsr lcd_send_instruction

  ; Load message_2 into the MESSAGE_PTR
  lda #<message_2         ; #< means low byte of the address of a label.  
  sta MESSAGE_PTR         ; save to pointer  
  lda #>message_2         ; #> means high byte of the address of a label.  
  sta MESSAGE_PTR + 1     ; save to pointer + 1  
  jsr print_message

loop:
  jmp loop

message_1:      .asciiz "This is ShoeBox"  
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