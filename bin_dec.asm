; Math
value = $0200   ; 2 bytes
mod10 = $0202   ; 2 bytes
message = $0204 ; 6 bytes

  .org $8000

reset:
  ; Init Stack
  ldx #$ff
  txs
  ; Main
  jsr lcd_init

  lda #0
  sta message
  ; Initialize the value to be the number to convert
  lda number
  sta value
  lda number + 1
  sta value + 1

divide:
  ; Initialize the remainder to be zero
  lda #0
  sta mod10
  sta mod10 + 1

  ldx #16
  clc

div_loop:
  ; Rotate quotient and remainder
  rol value
  rol value + 1
  rol mod10
  rol mod10 + 1

  ; a,y = dividend - divisor
  sec
  lda mod10
  sbc #10
  tay ; save low byte in y
  lda mod10+1
  bcc ignore_result ; branching if dividend < divisor

  sty mod10
  sta mod10+1

ignore_result
  dex 
  bne div_loop
  rol value ; shift in the last bit of the quotient
  rol value + 1

  lda mod10
  clc
  adc #"0"
  jsr push_char

  ; if value != 0, then continue dividing
  lda value
  ora value + 1
  bne divide ; branch if value not zero

  ldx #0
print:
  lda message,x
  beq loop
  jsr lcd_print_char
  inx
  jmp print

loop:
  jmp loop

nmi:
  rti
  
irq:
  rti

; Add the caracter in the A register to the beginning of the null-terminated string `message`
push_char:
  pha ; Push first character onto the stack
  ldy #0
char_loop:
  lda message,y ; Get char from the string and push it into x
  tax
  pla 
  sta message,y ; Pull char off stack and add it onto the string
  iny
  txa
  pha           ; Push char from string onto stack
  bne char_loop
  
  pla
  sta message,y ; Pull the null off the stack and add to the end of the string

  rts

number: .word $B520 ; largest 2-byte Fibonacci number

  .include "lcd.asm"

  .org $fffa    ; Vector Sector
  .word nmi     ; NMI Destination
  .word reset   ; Reset Destination
  .word irq     ; IRQ Destination