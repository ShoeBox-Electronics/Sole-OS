; Tests of libraries to make sure they stay functional as modifications are made

TEST_add:
  jsr MATH_clear_inputs
  jsr MATH_clear_output
  
  lda #50
  sta MATH_INPUT_1
  sta MATH_INPUT_2

  jsr MATH_add
  jsr TEST_print ; 50 + 50 = 100
  ; return
  rts

TEST_add_2:
  jsr MATH_clear_inputs
  jsr MATH_clear_output
  
  lda #$88
  sta MATH_INPUT_1
  sta MATH_INPUT_1 + 1
  lda #$14
  sta MATH_INPUT_2
  lda #$77
  sta MATH_INPUT_2 + 1

  jsr MATH_add
  jsr TEST_print ; -30584 + 30484 = -100
  ; return
  rts

TEST_mult:
  jsr MATH_clear_inputs
  jsr MATH_clear_output

  lda #5
  sta MATH_INPUT_1
  lda #$f6
  sta MATH_INPUT_2
  lda #$ff
  sta MATH_INPUT_2 + 1
  
  jsr MATH_mlt
  jsr TEST_print ; 5 x -10 = -50
  ; return
  rts

TEST_print:
  lda MATH_OUTPUT
  sta MATH_HEXDEC_VAL
  lda MATH_OUTPUT + 1
  sta MATH_HEXDEC_VAL + 1

  jsr MATH_hex_to_decstring
  jsr LCD_display_decstring
  ; return
  rts