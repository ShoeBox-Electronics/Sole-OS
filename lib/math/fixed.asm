MATH_clear_fxd_inputs:
  lda #0
  sta MATH_FXD_INPUT_1
  sta MATH_FXD_INPUT_1 + 1
  sta MATH_FXD_INPUT_1 + 2
  sta MATH_FXD_INPUT_1 + 3
  sta MATH_FXD_INPUT_2
  sta MATH_FXD_INPUT_2 + 1
  sta MATH_FXD_INPUT_2 + 2
  sta MATH_FXD_INPUT_2 + 3
  rts

MATH_clear_fxd_output:
  lda #0
  sta MATH_FXD_OUTPUT
  sta MATH_FXD_OUTPUT + 1
  sta MATH_FXD_OUTPUT + 2
  sta MATH_FXD_OUTPUT + 3
  rts

MATH_clear_fxd_misc:
  lda #0
  sta MATH_FXD_MISC
  sta MATH_FXD_MISC + 1
  sta MATH_FXD_MISC + 2
  sta MATH_FXD_MISC + 3
  rts

MATH_fxd_move_out_in:
  lda MATH_INT_OUTPUT
  sta MATH_FXD_INPUT_1
  lda MATH_INT_OUTPUT + 1
  sta MATH_FXD_INPUT_1 + 1
  lda MATH_INT_OUTPUT + 2
  sta MATH_FXD_INPUT_1 + 2
  lda MATH_INT_OUTPUT + 3
  sta MATH_FXD_INPUT_1 + 3
  rts