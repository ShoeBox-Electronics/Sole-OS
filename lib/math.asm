; MATH: General Mathematics

;;; Hex to Hexstring Conversion ;;; 
MATH_hex_to_hexstring: ; converts 2 bytes into a hex/ASCII string stored at MATH_CONVERT_OUT 
  ldx #1
  lda #'$' ; preface with a $
  sta MATH_CONVERT_OUT
  ldy #1
convert_byte: ; convert a byte into ASCII
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
  beq hex_convert_done

  dex
  jmp convert_byte

hex_convert_done:
  lda #0
  sta MATH_CONVERT_OUT,y ; null terminator for string
  ; return
  rts

hex_to_ascii: ; converts whatever's in the A register from hex to ASCII
  cmp #10
  bcc digit
  adc #'A' - 11
  jmp ascii_done
digit:
  adc #'0'
ascii_done:
  ; return
  rts

;;; Hex To Decstring Conversion ;;;

; https://www.youtube.com/watch?v=v3-a-zqKfgA&list=PLowKtXNTBypFbtuVMUVXNR0z1mu7dp7eH&index=10
MATH_hex_to_decstring: ; converts 2 bytes into a dec/ASCII string stored at MATH_CONVERT_OUT
  lda #0
  sta MATH_FLAG
  sta MATH_CONVERT_OUT
  ; check if negative
  lda MATH_CONVERT_VAL + 1
  and #%10000000
  beq convert_next

  ; flag that it was negative
  lda #1
  sta MATH_FLAG ; negative status
  lda MATH_CONVERT_VAL
  jsr MATH_twos_complement_plus_one
convert_next:
  jsr MATH_hexdec
  adc #'0'
  jsr MATH_prepend_decstring
  ; if value != 0, then continue dividing
  lda MATH_CONVERT_VAL
  ora MATH_CONVERT_VAL + 1
  bne convert_next  ; branch if value not zero
  
  lda MATH_FLAG ; negative status
  beq convert_done

  ; if it was negative, we need this negative sign too
  lda #'-'
  jsr MATH_prepend_decstring
convert_done:
  ; return
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
div_loop:
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
  bcc continue_loop ; branching if dividend < divisor

  sty MATH_CONVERT_MOD
  sta MATH_CONVERT_MOD+1
continue_loop:
  dex 
  bne div_loop

  rol MATH_CONVERT_VAL ; shift in the last bit of the quotient
  rol MATH_CONVERT_VAL + 1
  lda MATH_CONVERT_MOD
  clc
  ; return
  rts

; Add the caracter in the A register to the beginning of the null-terminated string `message`
MATH_prepend_decstring:
  pha                                   ; Push first character onto the stack
  ldy #0
prepend_loop:
  lda MATH_CONVERT_OUT,y                 ; Get char from the string and push it into x
  tax
  pla 
  sta MATH_CONVERT_OUT,y                 ; Pull char off stack and add it onto the string
  iny
  txa
  pha                                   ; Push char from string onto stack
  bne prepend_loop

  pla
  sta MATH_CONVERT_OUT,y                 ; Pull the null off the stack and add to the end of the string
  ; return
  rts

;;; General Section ;;; 

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
  sta MATH_MISC
  sta MATH_MISC + 1
  ; return
  rts

MATH_add: ; Input1 + Input2 = Output
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
  sta MATH_MISC
  ; return
  rts

MATH_sub: ; Input1 - Input2 = Output
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
  sta MATH_MISC
  ; return
  rts 

; https://codebase64.org/doku.php?id=base:16bit_multiplication_32-bit_product
MATH_mlt: ; Input1 x Input2 = Output, uses X register
  lda	#0
  sta	MATH_MISC	; clear upper bits of product
  sta	MATH_MISC + 1 
  ldx	#16		; set binary count to 16 
shift_r:
  lsr	MATH_INPUT_1 + 1	; divide MATH_INPUT_1 by 2 
  ror	MATH_INPUT_1
  bcc	rotate_r 

  lda	MATH_MISC	; get upper half of product and add multiplicand
  clc
  adc	MATH_INPUT_2
  sta	MATH_MISC
  lda	MATH_MISC + 1 
	adc	MATH_INPUT_2 + 1
rotate_r:
  ror			; rotate partial product 
  sta	MATH_MISC + 1 
  ror	MATH_MISC
  ror	MATH_OUTPUT + 1 
  ror	MATH_OUTPUT 
  dex
  bne	shift_r 

  ; return
  rts

; https://codebase64.org/doku.php?id=base:16bit_division_16-bit_result
MATH_div:
	lda #0	        ;preset remainder to 0
	sta MATH_MISC
	sta MATH_MISC + 1
	ldx #16	        ;repeat for each bit: ...
divloop:
	asl MATH_INPUT_1	;dividend lb & hb*2, msb -> Carry
	rol MATH_INPUT_1 + 1	
	rol MATH_MISC	 ;remainder lb & hb * 2 + msb from carry
	rol MATH_MISC + 1
	lda MATH_MISC
	sec
	sbc MATH_INPUT_2	;substract divisor to see if it fits in
	tay	        ;lb result -> Y, for we may need it later
	lda MATH_MISC + 1
	sbc MATH_INPUT_2 + 1
	bcc skip	;if carry=0 then divisor didn't fit in yet

	sta MATH_MISC + 1	;else save substraction result as new remainder,
	sty MATH_MISC	
	inc MATH_INPUT_1	;and INCrement result cause divisor fit in 1 times
skip:
	dex
	bne divloop	

  lda MATH_INPUT_1
  sta MATH_OUTPUT
  lda MATH_INPUT_1 + 1
  sta MATH_OUTPUT + 1
  ; return
	rts
