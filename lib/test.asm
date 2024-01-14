; Tests of libraries to make sure they stay functional as modifications are made

TEST_add_pos: ; 50 + 50 => 100
  jsr MATH_clear_inputs
  jsr MATH_clear_output
  
  lda #50
  sta MATH_INPUT_1
  sta MATH_INPUT_2

  jsr MATH_add
  jsr TEST_print
  ; return
  rts

TEST_add_neg: ; -30584 + 30484 => -100
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
  jsr TEST_print
  ; return
  rts

TEST_mult: ; 5 x -10 => -50
  jsr MATH_clear_inputs
  jsr MATH_clear_output

  lda #5
  sta MATH_INPUT_1
  lda #$f6
  sta MATH_INPUT_2
  lda #$ff
  sta MATH_INPUT_2 + 1
  
  jsr MATH_mlt
  jsr TEST_print
  ; return
  rts

TEST_hexstring: ; => $fafo
  lda #$f0
  sta MATH_CONVERT_VAL
  lda #$fa
  sta MATH_CONVERT_VAL + 1
  jsr MATH_hex_to_hexstring

  jsr LCD_display_math_convert_out
  ; return
  rts

TEST_print:
  lda MATH_OUTPUT
  sta MATH_CONVERT_VAL
  lda MATH_OUTPUT + 1
  sta MATH_CONVERT_VAL + 1

  jsr MATH_hex_to_decstring
  jsr LCD_display_math_convert_out
  ; return
  rts

