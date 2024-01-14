; MATH: General Mathematics
MATH_clear_inputs:
  lda #0
  sta MATH_INPUT_1
  sta MATH_INPUT_1 + 1
  sta MATH_INPUT_2
  sta MATH_INPUT_2 + 1
  ; return
  rts

MATH_clear_output:
  lda #0
  sta MATH_OUTPUT
  sta MATH_OUTPUT + 1
  sta MATH_OUTPUT + 2
  sta MATH_OUTPUT + 3
  ; return
  rts

MATH_twos_complement:
  clc
  lda MATH_HEXDEC_VAL
  eor #$ff
  adc #1
  sta MATH_HEXDEC_VAL
  lda MATH_HEXDEC_VAL + 1
  eor #$ff
  adc #0
  sta MATH_HEXDEC_VAL + 1
  rts

MATH_hex_to_decstring:
  ; Store input number in the MATH_HEXDEC_VAL address before running
  lda #0
  sta MATH_BITMASK
  sta MATH_HEXDEC_OUT
  lda MATH_HEXDEC_VAL + 1
  and #%10000000
  beq divide
negative:
  lda #%00000001
  sta MATH_BITMASK
  jsr MATH_twos_complement
divide:
  ; Initialize the remainder to be zero
  lda #0
  sta MATH_HEXDEC_MOD
  sta MATH_HEXDEC_MOD + 1
  ldx #16
  clc
div_loop:
  ; Rotate quotient and remainder
  rol MATH_HEXDEC_VAL
  rol MATH_HEXDEC_VAL + 1
  rol MATH_HEXDEC_MOD
  rol MATH_HEXDEC_MOD + 1
  ; a,y = dividend - divisor
  sec
  lda MATH_HEXDEC_MOD
  sbc #10
  tay ; save low byte in y
  lda MATH_HEXDEC_MOD+1
  bcc continue_loop ; branching if dividend < divisor
  sty MATH_HEXDEC_MOD
  sta MATH_HEXDEC_MOD+1
continue_loop:
  dex 
  bne div_loop
  rol MATH_HEXDEC_VAL ; shift in the last bit of the quotient
  rol MATH_HEXDEC_VAL + 1
  lda MATH_HEXDEC_MOD
  clc
  adc #'0'
  jsr MATH_append_output
  ; if value != 0, then continue dividing
  lda MATH_HEXDEC_VAL
  ora MATH_HEXDEC_VAL + 1
  bne divide ; branch if value not zero
  ldx #0
  lda MATH_BITMASK
  beq positive
  lda #'-'
  jsr MATH_append_output
positive:
  ; return
  rts

; Add the caracter in the A register to the beginning of the null-terminated string `message`
MATH_append_output:
  pha                                   ; Push first character onto the stack
  ldy #0
append_loop:
  lda MATH_HEXDEC_OUT,y                 ; Get char from the string and push it into x
  tax
  pla 
  sta MATH_HEXDEC_OUT,y                 ; Pull char off stack and add it onto the string
  iny
  txa
  pha                                   ; Push char from string onto stack
  bne append_loop
  pla
  sta MATH_HEXDEC_OUT,y                 ; Pull the null off the stack and add to the end of the string
  ; return
  rts

MATH_add:
  ; clear carry flag for addition
  clc
  ; add first byte
  lda MATH_INPUT_1
  adc MATH_INPUT_2
  sta MATH_OUTPUT
  ; add second byte
  lda MATH_INPUT_1 + 1
  adc MATH_INPUT_2 + 1
  sta MATH_OUTPUT + 1
  ; store carry into third byte
  lda #0
  adc #0
  sta MATH_OUTPUT + 2
  lda #0
  ; return
  rts

MATH_sub:
  ; clear carry flag for subtraction
  sec
  ; subtract first byte
  lda MATH_INPUT_1
  sbc MATH_INPUT_2
  sta MATH_OUTPUT
  ; subtract second byte
  lda MATH_INPUT_1 + 1
  sbc MATH_INPUT_2 + 1
  sta MATH_OUTPUT + 1
  ; store carry in third byte
  lda #0
  sbc #0
  sta MATH_OUTPUT + 2
  ; return
  rts 

MATH_mlt:
  ldx #4
mlt_loop:
  lsr MATH_INPUT_2
  bcc iterate
  clc
  lda MATH_INPUT_1
  adc MATH_OUTPUT
  sta MATH_OUTPUT
iterate:
  asl MATH_INPUT_1
  dex
  bne mlt_loop
  ; return
  rts
