; MATH: Conversions

;;; Hex to Hexstring Conversion ;;; 
MATH_hex_to_string: ; converts 2 bytes into a hex/ASCII string stored at MATH_CONVERT_OUT 
  ldx #1
  lda #'$' ; preface with a $
  sta MATH_CONVERT_OUT
  ldy #1
@loop:        ; convert a byte into ASCII
  lda MATH_CONVERT_VAL,x
  ; shift the upper nibble down
  lsr 
  lsr
  lsr
  lsr
  and #$0f ; mask the nibble
  jsr hex_to_ascii  
  sta MATH_CONVERT_OUT,y  
  iny

  lda MATH_CONVERT_VAL,x  
  and #$0f ; mask the nibble
  jsr hex_to_ascii 
  sta MATH_CONVERT_OUT,y 
  iny
  txa
  beq @return

  dex
  jmp @loop

@return:
  lda #0
  sta MATH_CONVERT_OUT,y ; null terminator for string
  rts

hex_to_ascii: ; converts whatever's in the A register from hex to ASCII
  cmp #10
  bcc digit
  adc #'A' - 11
  jmp ascii_done
digit:
  adc #'0'
ascii_done:
  rts

;;; Hex To Decstring Conversion ;;;
; https://www.youtube.com/watch?v=v3-a-zqKfgA&list=PLowKtXNTBypFbtuVMUVXNR0z1mu7dp7eH&index=10
MATH_int_to_string: ; converts an integer into a dec/ASCII string stored at MATH_CONVERT_OUT
  lda #0
  sta MATH_FLAG
  sta MATH_CONVERT_OUT
  ; check if negative
  lda MATH_CONVERT_VAL + 1
  and #%10000000
  beq @loop

  ; flag that it was negative
  lda #1
  sta MATH_FLAG ; negative status
  lda MATH_CONVERT_VAL
  jsr MATH_twos_complement_plus_one
@loop:
  jsr MATH_hexdec
  adc #'0'
  jsr MATH_prepend_decstring
  ; if value != 0, then continue dividing
  lda MATH_CONVERT_VAL
  ora MATH_CONVERT_VAL + 1
  bne @loop         ; branch if value not zero
  
  lda MATH_FLAG ; negative status
  beq @return

  ; if it was negative, we need this negative sign too
  lda #'-'
  jsr MATH_prepend_decstring
@return:
  rts

MATH_twos_complement_plus_one:
  clc
  lda MATH_CONVERT_VAL
  eor #$ff
  adc #1
  sta MATH_CONVERT_VAL
  lda MATH_CONVERT_VAL + 1
  eor #$ff
  adc #0
  sta MATH_CONVERT_VAL + 1
  ; return 
  rts

MATH_hexdec:
  ; Initialize the remainder to be zero
  lda #0
  sta MATH_CONVERT_MOD
  sta MATH_CONVERT_MOD + 1
  ldx #16
  clc
@loop:
  ; Rotate quotient and remainder
  rol MATH_CONVERT_VAL
  rol MATH_CONVERT_VAL + 1
  rol MATH_CONVERT_MOD
  rol MATH_CONVERT_MOD + 1
  ; a,y = dividend - divisor
  sec
  lda MATH_CONVERT_MOD
  sbc #10
  tay ; save low byte in y
  lda MATH_CONVERT_MOD+1
  bcc @continue     ; branching if dividend < divisor

  sty MATH_CONVERT_MOD
  sta MATH_CONVERT_MOD+1
@continue:
  dex 
  bne @loop

  rol MATH_CONVERT_VAL ; shift in the last bit of the quotient
  rol MATH_CONVERT_VAL + 1
  lda MATH_CONVERT_MOD
  clc
  rts

; Add the caracter in the A register to the beginning of the null-terminated string `message`
MATH_prepend_decstring:
  pha                                   ; Push first character onto the stack
  ldy #0
@loop:
  lda MATH_CONVERT_OUT,y                 ; Get char from the string and push it into x
  tax
  pla 
  sta MATH_CONVERT_OUT,y                 ; Pull char off stack and add it onto the string
  iny
  txa
  pha                                   ; Push char from string onto stack
  bne @loop

  pla
  sta MATH_CONVERT_OUT,y                 ; Pull the null off the stack and add to the end of the string
  rts