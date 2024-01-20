; MATH: Integers (2 byte signed)

.macro set_int_input l1, h1, l2, h2
.ifnblank l2
  lda #l1
  sta MATH_INT_INPUT_1
  lda #l2
  sta MATH_INT_INPUT_2
  lda #h1
  sta MATH_INT_INPUT_1 + 1
  lda #h2
  sta MATH_INT_INPUT_2 + 1
.endif
.ifblank l2
  lda #l1
  sta MATH_INT_INPUT_1
  lda #h1
  sta MATH_INT_INPUT_2
  lda #0
  sta MATH_INT_INPUT_1 + 1
  sta MATH_INT_INPUT_2 + 1
.endif
.endmacro

;;; Helpers ;;;
MATH_clear_int_inputs:
  lda #0
  sta MATH_INT_INPUT_1
  sta MATH_INT_INPUT_1 + 1
  sta MATH_INT_INPUT_2
  sta MATH_INT_INPUT_2 + 1
  ; return
  rts

MATH_clear_int_output:
  lda #0
  sta MATH_INT_OUTPUT
  sta MATH_INT_OUTPUT + 1
  ; return
  rts

MATH_clear_int_misc:
  lda #0
  sta MATH_INT_MISC
  sta MATH_INT_MISC + 1
  ; return
  rts

;;; Basic Math ;;;
MATH_add_int: ; Input1 + Input2 = Output
  ; clear carry flag for addition
  clc
  ; add first byte
  lda MATH_INT_INPUT_1
  adc MATH_INT_INPUT_2
  sta MATH_INT_OUTPUT
  ; add second byte
  lda MATH_INT_INPUT_1 + 1
  adc MATH_INT_INPUT_2 + 1
  sta MATH_INT_OUTPUT + 1
  ; return
  rts

MATH_sub_int: ; Input1 - Input2 = Output
  ; clear carry flag for subtraction
  sec
  ; subtract first byte
  lda MATH_INT_INPUT_1
  sbc MATH_INT_INPUT_2
  sta MATH_INT_OUTPUT
  ; subtract second byte
  lda MATH_INT_INPUT_1 + 1
  sbc MATH_INT_INPUT_2 + 1
  sta MATH_INT_OUTPUT + 1
  ; return
  rts 

; https://codebase64.org/doku.php?id=base:16bit_multiplication_32-bit_product
MATH_mlt_int: ; Input1 x Input2 = Output, uses X register
  jsr MATH_clear_int_output 
  jsr MATH_clear_int_misc 
  ldx	#16		; set binary count to 16 
@shift_r:
  lsr	MATH_INT_INPUT_1 + 1	; divide MATH_INT_INPUT_1 by 2 
  ror	MATH_INT_INPUT_1
  bcc	rotate_r 

  lda	MATH_INT_MISC	; get upper half of product and add multiplicand
  clc
  adc	MATH_INT_INPUT_2
  sta	MATH_INT_MISC
  lda	MATH_INT_MISC + 1 
	adc	MATH_INT_INPUT_2 + 1
@rotate_r:
  ror			; rotate partial product 
  sta	MATH_INT_MISC + 1 
  ror	MATH_INT_MISC
  ror	MATH_INT_OUTPUT + 1 
  ror	MATH_INT_OUTPUT 
  dex
  bne	shift_r 

  ; return
  rts

; https://codebase64.org/doku.php?id=base:16bit_division_16-bit_result
MATH_div_int:
  jsr MATH_clear_int_output 
  jsr MATH_clear_int_misc 
	ldx #16	                               ; repeat for each bit: ...
@loop:
	asl MATH_INT_INPUT_1                   ; dividend lb & hb*2, msb -> Carry
	rol MATH_INT_INPUT_1 + 1	
	rol MATH_INT_MISC	                     ; remainder lb & hb * 2 + msb from carry
	rol MATH_INT_MISC + 1
	lda MATH_INT_MISC
	sec
	sbc MATH_INT_INPUT_2	                  ; substract divisor to see if it fits in
	tay	                                    ; lb result -> Y, for we may need it later
	lda MATH_INT_MISC + 1
	sbc MATH_INT_INPUT_2 + 1
	bcc @continue	                          ; if carry=0 then divisor didn't fit in yet

	sta MATH_INT_MISC + 1	                  ; else save substraction result as new remainder,
	sty MATH_INT_MISC	
	inc MATH_INT_INPUT_1	                  ; and INCrement result cause divisor fit in 1 times
@continue:
	dex
	bne @loop	

  lda MATH_INT_INPUT_1
  sta MATH_INT_OUTPUT
  lda MATH_INT_INPUT_1 + 1
  sta MATH_INT_OUTPUT + 1
  ; return
	rts

;;; Comparisons ;;; (VERY ROUGH AND UNTESTED)
MATH_eq_int: ; a == b
  jsr MATH_clear_int_output
  lda MATH_INT_INPUT_1
  cmp MATH_INT_INPUT_2
  bne @not_equal
  lda MATH_INT_INPUT_1 + 1
  cmp MATH_INT_INPUT_2 + 1
  bne @not_equal
; @equal:
  lda #1
  jmp @return
@not_equal:
  lda #0
@return:
  sta MATH_INT_OUTPUT
  ; return
  rts

MATH_lt_int: ; a < b, a: MATH_INT_INPUT_1, b: MATH_INT_INPUT_2
  jsr MATH_sub_int
  lda MATH_INT_OUTPUT + 1
  bmi @less_than
@not_less_than:
  lda #0
  jmp @return
@less_than:
  lda #1
@return:
  sta MATH_INT_OUTPUT
  lda #0
  sta MATH_INT_OUTPUT + 1
  ; return
  rts

MATH_gt_int: ; a > b, a: MATH_INT_INPUT_1, b: MATH_INT_INPUT_2
  jsr MATH_gte_int
  lda MATH_INT_OUTPUT
  beq @not_greater_than
@greater_than_maybe_equal:
  jsr MATH_eq_int
  lda MATH_INT_OUTPUT
  bne @not_greater_than
  jmp @greater_than
@not_greater_than:
  lda #0
  jmp @return
@greater_than:
  lda #1
@return:
  sta MATH_INT_OUTPUT
  ; return
  rts

MATH_gte_int:
  jsr MATH_lt_int
  jsr MATH_invert_comparison
  ; return
  rts

MATH_lte_int:
  jsr MATH_gt_int
  jsr MATH_invert_comparison
  ; return
  rts

MATH_neq_int:
  jsr MATH_eq_int
  jsr MATH_invert_comparison
  ; return
  rts

MATH_invert_comparison:
  lda MATH_INT_OUTPUT
  eor #%00000001
  sta MATH_INT_OUTPUT
  ; return
  rts  
