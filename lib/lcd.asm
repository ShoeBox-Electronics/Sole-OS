; 16x2 LCD Display model: HD44780

; VIA/LCD bitcodes
E  = %10000000  ; Enable pin 
RW = %01000000  ; Read/Write pin
RS = %00100000  ; Register Select pin

LCD_init: 
  ; VIA init
  lda #%11111111    ; Set all pins on port B to output (for LCD data)
  sta VIA_DDRB
  lda #%11100000    ; Set top 3 pins on port A to output (for LCD signals)
  sta VIA_DDRA
  ; LCD true init
  lda #%00111000    ; Set 8-bit mode, 2-line display, 5x8 font
  jsr LCD_send_instruction
  lda #%00001110    ; Display on, cursor on, blink off
  jsr LCD_send_instruction
  lda #%00000110    ; Increment and shift cursor, don't shift display
  jsr LCD_send_instruction
  jsr LCD_clear_display
  rts

LCD_wait_until_free: ; Make sure the LCD is ready to take a new command
  pha
  lda #%00000000    ; Port B is input
  sta VIA_DDRB
LCD_busy:
  lda #RW
  sta VIA_PORTA
  lda #(RW | E)
  sta VIA_PORTA
  lda VIA_PORTB
  and #%10000000
  bne LCD_busy      ; Checking the busy flag from the LCD
  lda #RW
  sta VIA_PORTA
  lda #%11111111    ; Port B is back to output
  sta VIA_DDRB
  pla
  rts

LCD_send_instruction:
  ; Store instruction in the A register before running
  jsr LCD_wait_until_free
  sta VIA_PORTB
  lda #0            ; Clear RS/RW/E bits
  sta VIA_PORTA
  lda #E            ; Set E bit to send instruction
  sta VIA_PORTA
  lda #0            ; Clear RS/RW/E bits
  sta VIA_PORTA
  rts

LCD_print_char:
  ; Store character in the A register before running
  jsr LCD_wait_until_free
  sta VIA_PORTB
  lda #RS           ; Set RS, Clear RW/E bits
  sta VIA_PORTA
  lda #(RS | E)     ; Set E bit with RS to send character
  sta VIA_PORTA
  lda #RS           ; Clear E bits
  sta VIA_PORTA
  rts

LCD_print_string:         ; Print a null-terminated string from memory to the LCD
  ; Store the string memory address in LCD_STRING_PTR before running
  ldy #0
string_loop:
  lda (LCD_STRING_PTR),y
  beq end_print_string    ; If we find the null-terminator, exit
  jsr LCD_print_char
  iny
  jmp string_loop
end_print_string:
  rts

LCD_goto_address:
  ; Store destination address in the A register before running
  ora #%10000000    ; OR the "goto address" command with the address we want to go to
  jsr LCD_send_instruction
  rts

LCD_cursor_left:
  lda #%00010000
  jsr LCD_send_instruction
  rts

LCD_cursor_right:
  lda #%00010100
  jsr LCD_send_instruction
  rts

LCD_backspace:
  jsr LCD_cursor_left
  lda #" "
  jsr LCD_print_char
  rts

LCD_clear_display:
  lda #%00000001    ; Clear display
  jsr LCD_send_instruction
  lda #0
  jsr LCD_goto_address
  rts
