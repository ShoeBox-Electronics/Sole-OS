; TEST - MATH - Index

  .include "tests/math/integer.asm"
  .include "tests/math/convert.asm"

TEST_suite_math_all:
  jsr TEST_suite_math_int
  jsr TEST_suite_math_convert
  rts

TEST_print_math_int_output:
  lda MATH_INT_OUTPUT
  sta MATH_CONVERT_VAL
  lda MATH_INT_OUTPUT + 1
  sta MATH_CONVERT_VAL + 1
  jsr MATH_int_to_string

  jsr LCD_display_math_convert_out
  rts