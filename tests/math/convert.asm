; TEST - MATH - Convert

;;; Test Suites ;;;
TEST_suite_math_convert:
  run_test TEST_hex_to_string
  rts

;;; Convert ;;;
hex_to_string_message: .asciiz "= $FAF0"
TEST_hex_to_string:
  print hex_to_string_message

  lda #$f0
  sta MATH_CONVERT_VAL
  lda #$fa
  sta MATH_CONVERT_VAL + 1
  jsr MATH_hex_to_string

  jsr LCD_to_home_bottom
  jsr LCD_display_math_convert_out
  rts
