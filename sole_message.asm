; VIA Registers
PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

; VIA/LCD pins
E  = %10000000  ; Enable pin bitcode 
RW = %01000000  ; Read/Write pin bitcode
RS = %00100000  ; Register Select pin bitcode

  .org $8000

reset:
; Init Stack
  ldx #$ff
  txs
; Main
  jsr via_init
  jsr lcd_init
  jsr print_message

loop:
  jmp loop

; FIXME: inefficient, use newline address
message:          .asciiz "This is ShoeBox                         Running Sole OS"

print_message:
  ldx #0                 ; Character index counter init to zero
print_next_char:         ; Print Char
  lda message,x          ; Load message byte with x-value offset
  beq loop               ; If we're done, go to loop
  jsr lcd_print_char     ; Print the currently-addressed Char
  inx                    ; Increment character index counter (x)
  jmp print_next_char    ; print the next char     

via_init:
  lda #%11111111    ; Set all pins on port B to output
  sta DDRB
  lda #%11100000    ; Set top 3 pins on port A to output
  sta DDRA
  rts

lcd_init: 
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
; LCD Free
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
  lda #(RS | E)     ; Set E bit to send instruction
  sta PORTA
  lda #RS           ; Clear E bits
  sta PORTA
  rts

  .org $fffc    ; Reset Vector
  .word reset   ; Reset Destination
  .word $0000   ; Fill last byte