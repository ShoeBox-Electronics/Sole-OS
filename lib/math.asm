; MEMORY RESERVATIONS
HEXDEC_VAL = $0200  ; 2 bytes
HEXDEC_MOD = $0202  ; 2 bytes
HEXDEC_OUT = $0204  ; 6 bytes

MATH_hexdec_convert:
  ; Store input number in the HEXDEC_VAL address before running
  lda #0
  sta HEXDEC_OUT
divide:
  ; Initialize the remainder to be zero
  lda #0
  sta HEXDEC_MOD
  sta HEXDEC_MOD + 1
  ldx #16
  clc
div_loop:
  ; Rotate quotient and remainder
  rol HEXDEC_VAL
  rol HEXDEC_VAL + 1
  rol HEXDEC_MOD
  rol HEXDEC_MOD + 1
  ; a,y = dividend - divisor
  sec
  lda HEXDEC_MOD
  sbc #10
  tay ; save low byte in y
  lda HEXDEC_MOD+1
  bcc ignore_result ; branching if dividend < divisor
  sty HEXDEC_MOD
  sta HEXDEC_MOD+1
ignore_result
  dex 
  bne div_loop
  rol HEXDEC_VAL ; shift in the last bit of the quotient
  rol HEXDEC_VAL + 1
  lda HEXDEC_MOD
  clc
  adc #"0"
  jsr MATH_append_output
  ; if value != 0, then continue dividing
  lda HEXDEC_VAL
  ora HEXDEC_VAL + 1
  bne divide ; branch if value not zero
  ldx #0
  rts

; Add the caracter in the A register to the beginning of the null-terminated string `message`
MATH_append_output:
  pha ; Push first character onto the stack
  ldy #0
append_loop:
  lda HEXDEC_OUT,y ; Get char from the string and push it into x
  tax
  pla 
  sta HEXDEC_OUT,y ; Pull char off stack and add it onto the string
  iny
  txa
  pha              ; Push char from string onto stack
  bne append_loop
  pla
  sta HEXDEC_OUT,y ; Pull the null off the stack and add to the end of the string
  rts
