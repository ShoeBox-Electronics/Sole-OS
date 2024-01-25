; TEST - MATH - Index

  .include "tests/math/integer.asm"
  .include "tests/math/convert.asm"

TEST_suite_math_all:
  jsr TEST_suite_math_int_all
  jsr TEST_suite_math_convert
  rts