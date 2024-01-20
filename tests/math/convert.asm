; TEST - MATH - Convert

;;; Test Suites ;;;
TEST_suite_math_convert:
  jsr TEST_hex_to_string
  jsr TEST_wait_and_clear
  ; return
  rts

;;; Convert ;;;
hex_to_string_message: .asciiz "= $FAF0"
TEST_hex_to_string:
  lda #<hex_to_string_message
  sta LCD_STRING_PTR
  lda #>hex_to_string_message
  sta LCD_STRING_PTR + 1
  jsr LCD_print_string   

  lda #$f0
  sta MATH_CONVERT_VAL
  lda #$fa
  sta MATH_CONVERT_VAL + 1
  jsr MATH_hex_to_string
  
  lda #$40
  jsr LCD_goto_address

  jsr LCD_display_math_convert_out
  ; return
  rts
