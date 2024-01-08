; MATH: General Mathematics

MATH_hexdec_convert:
  ; Store input number in the MATH_HEXDEC_VAL address before running
  lda #0
  sta MATH_HEXDEC_OUT
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
  bcc ignore_result ; branching if dividend < divisor
  sty MATH_HEXDEC_MOD
  sta MATH_HEXDEC_MOD+1
ignore_result:
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
  ; return
  rts

; Add the caracter in the A register to the beginning of the null-terminated string `message`
MATH_append_output:
  pha ; Push first character onto the stack
  ldy #0
append_loop:
  lda MATH_HEXDEC_OUT,y ; Get char from the string and push it into x
  tax
  pla 
  sta MATH_HEXDEC_OUT,y ; Pull char off stack and add it onto the string
  iny
  txa
  pha              ; Push char from string onto stack
  bne append_loop
  pla
  sta MATH_HEXDEC_OUT,y ; Pull the null off the stack and add to the end of the string
  ; return
  rts

MATH_fibonacci:
  ; shift b to a
  lda MATH_INPUT_2
  sta MATH_INPUT_1
  lda MATH_INPUT_2 + 1
  sta MATH_INPUT_1 + 1
  ; shift output to b
  lda MATH_OUTPUT
  sta MATH_INPUT_2
  lda MATH_OUTPUT + 1
  sta MATH_INPUT_2 + 1
  ; do a+b and store it in output
  jsr MATH_add
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
  ; Store one of the factors in the MISC var
  lda MATH_INPUT_2
  sta MATH_MISC
  dec MATH_MISC
  lda MATH_INPUT_2 + 1
  sta MATH_MISC + 1
  ; Set Input 2 to the same as Input 1 for repeated addition
  lda MATH_INPUT_1
  sta MATH_INPUT_2
  lda MATH_INPUT_1 + 1
  sta MATH_INPUT_2 + 1
mult_loop: ; here's where the repeated addition happens
  ; perform addition
  jsr MATH_add
  ; DEC MATH_MISC and check if zero
  dec MATH_MISC
  lda MATH_MISC
  bne no_adl_dec
  ; if zero, check if we're completely done
  lda MATH_MISC + 1
  beq mult_done
  ; borrow from the next byte if needed
  lda #$ff
  sta MATH_MISC
  dec MATH_MISC + 1
no_adl_dec: ; if we don't need to DEC MATH_MISC + 1, we jump here
  ; store our output back into MATH_INPUT_1 to keep performing the addition
  lda MATH_OUTPUT
  sta MATH_INPUT_1
  lda MATH_OUTPUT + 1
  sta MATH_INPUT_1 + 1
  jmp mult_loop
mult_done: ; jump here when we're done repeating our addition
  rts
