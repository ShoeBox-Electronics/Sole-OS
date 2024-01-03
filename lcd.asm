; VIA Registers
PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

; VIA/LCD pins
E  = %10000000  ; Enable pin bitcode 
RW = %01000000  ; Read/Write pin bitcode
RS = %00100000  ; Register Select pin bitcode

; MEMORY RESERVATIONS
STRING_PTR = $00    ; 2-byte pointer for the location of our string to print

lcd_init: 
  ; VIA init
  lda #%11111111    ; Set all pins on port B to output
  sta DDRB
  lda #%11100000    ; Set top 3 pins on port A to output
  sta DDRA

  ; LCD true init
  lda #%00111000    ; Set 8-bit mode, 2-line display, 5x8 font
  jsr lcd_send_instruction
  lda #%00001110    ; Display on, cursor on, blink off
  jsr lcd_send_instruction
  lda #%00000110    ; Increment and shift cursor, don't shift display
  jsr lcd_send_instruction
  lda #$00000001    ; Clear display
  jsr lcd_send_instruction
  rts

lcd_wait_until_free:
  pha
  lda #%00000000    ; Port B is input
  sta DDRB
lcd_busy:
  lda #RW
  sta PORTA
  lda #(RW | E)
  sta PORTA
  lda PORTB
  and #%10000000
  bne lcd_busy
lcd_free:
  lda #RW
  sta PORTA
  lda #%11111111    ; Port B is output
  sta DDRB
  pla
  rts

lcd_send_instruction:
  jsr lcd_wait_until_free
  sta PORTB
  lda #0            ; Clear RS/RW/E bits
  sta PORTA
  lda #E            ; Set E bit to send instruction
  sta PORTA
  lda #0            ; Clear RS/RW/E bits
  sta PORTA
  rts

lcd_print_char:
  jsr lcd_wait_until_free
  sta PORTB
  lda #RS           ; Set RS, Clear RW/E bits
  sta PORTA
  lda #(RS | E)     ; Set E bit with RS to send character
  sta PORTA
  lda #RS           ; Clear E bits
  sta PORTA
  rts

lcd_print_string:
  ldy #0
print_next_char:
  lda (STRING_PTR),y
  beq end_print_string
  jsr lcd_print_char
  iny
  jmp print_next_char
end_print_string:
  rts

lcd_go_home: ; TODO: test
  lda #%10000000
  jsr lcd_send_instruction
  rts

lcd_go_home_second_row:
  lda #(%10000000|$40)
  jsr lcd_send_instruction
  rts
