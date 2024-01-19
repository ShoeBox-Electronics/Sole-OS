; TEST - MATH - Index

  .include "tests/math/integer.asm"
  .include "tests/math/convert.asm"

TEST_suite_math:
  jsr TEST_eq_int
  jsr TEST_wait_and_clear

  jsr TEST_neq_int
  jsr TEST_wait_and_clear

  jsr TEST_gt_int
  jsr TEST_wait_and_clear

  jsr TEST_add_int_pos
  jsr TEST_wait_and_clear

  jsr TEST_add_int_neg
  jsr TEST_wait_and_clear

  jsr TEST_sub_int_pos
  jsr TEST_wait_and_clear

  jsr TEST_sub_int_neg
  jsr TEST_wait_and_clear

  jsr TEST_mult_int
  jsr TEST_wait_and_clear

  jsr TEST_div_int
  jsr TEST_wait_and_clear

  jsr TEST_hex_to_string
  jsr TEST_wait_and_clear
  ; return
  rts

TEST_print_math_int_output:
  lda MATH_INT_OUTPUT
  sta MATH_CONVERT_VAL
  lda MATH_INT_OUTPUT + 1
  sta MATH_CONVERT_VAL + 1
  jsr MATH_int_to_string

  jsr LCD_display_math_convert_out
  ; return
  rts

TEST_math_prep:
  jsr MATH_clear_int_inputs
  lda #$40
  jsr LCD_goto_address
  ; return
  rts
