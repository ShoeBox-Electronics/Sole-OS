; Tests of libraries to make sure they stay functional as modifications are made

TEST_suite:
  jsr TEST_add_pos
  jsr TEST_wait_and_clear

  jsr TEST_add_neg
  jsr TEST_wait_and_clear

  jsr TEST_sub_pos
  jsr TEST_wait_and_clear

  jsr TEST_sub_neg
  jsr TEST_wait_and_clear

  jsr TEST_mult
  jsr TEST_wait_and_clear

  jsr TEST_div
  jsr TEST_wait_and_clear

  jsr TEST_hexstring
  jsr TEST_wait_and_clear

  jmp TEST_suite

add_pos_message: .asciiz "50+50=100"
TEST_add_pos:
  lda #<add_pos_message
  sta LCD_STRING_PTR
  lda #>add_pos_message
  sta LCD_STRING_PTR + 1
  jsr LCD_print_string                  

  jsr TEST_prep
  
  lda #50
  sta MATH_INPUT_1
  sta MATH_INPUT_2
  jsr MATH_add

  jsr TEST_print_math_output
  ; return
  rts

add_neg_message: .asciiz "-50+-50=-100"
TEST_add_neg:
  lda #<add_neg_message
  sta LCD_STRING_PTR
  lda #>add_neg_message
  sta LCD_STRING_PTR + 1
  jsr LCD_print_string                  

  jsr TEST_prep
  
  lda #$ce
  sta MATH_INPUT_1
  sta MATH_INPUT_2
  lda #$ff
  sta MATH_INPUT_1 + 1
  sta MATH_INPUT_2 + 1
  jsr MATH_add

  jsr TEST_print_math_output
  ; return
  rts

sub_pos_message: .asciiz "100-50=50"
TEST_sub_pos:
  lda #<sub_pos_message
  sta LCD_STRING_PTR
  lda #>sub_pos_message
  sta LCD_STRING_PTR + 1
  jsr LCD_print_string                  

  jsr TEST_prep

  lda #100
  sta MATH_INPUT_1
  lda #50
  sta MATH_INPUT_2
  jsr MATH_sub

  jsr TEST_print_math_output
  ; return
  rts

sub_neg_message: .asciiz "50-100=-50"
TEST_sub_neg:
  lda #<sub_neg_message
  sta LCD_STRING_PTR
  lda #>sub_neg_message
  sta LCD_STRING_PTR + 1
  jsr LCD_print_string                  

  jsr TEST_prep

  lda #50
  sta MATH_INPUT_1
  lda #100
  sta MATH_INPUT_2
  jsr MATH_sub

  jsr TEST_print_math_output
  ; return
  rts

mlt_message: .asciiz "5x-10=-50"
TEST_mult: 
  lda #<mlt_message
  sta LCD_STRING_PTR
  lda #>mlt_message
  sta LCD_STRING_PTR + 1
  jsr LCD_print_string                

  jsr TEST_prep

  lda #5
  sta MATH_INPUT_1
  lda #$f6
  sta MATH_INPUT_2
  lda #$ff
  sta MATH_INPUT_2 + 1
  jsr MATH_mlt
  
  jsr TEST_print_math_output
  ; return
  rts

div_message: .asciiz "170/13=13r1"
TEST_div: 
  lda #<div_message
  sta LCD_STRING_PTR
  lda #>div_message
  sta LCD_STRING_PTR + 1
  jsr LCD_print_string               

  jsr TEST_prep

  lda #170
  sta MATH_INPUT_1
  lda #13
  sta MATH_INPUT_2
  jsr MATH_div

  jsr TEST_print_math_output

  lda #'r'
  jsr LCD_print_char

  lda MATH_OUTPUT + 2
  sta MATH_CONVERT_VAL
  lda MATH_OUTPUT + 3
  sta MATH_CONVERT_VAL + 1
  jsr MATH_hex_to_decstring

  jsr LCD_display_math_convert_out
  ; return
  rts

hexstring_message: .asciiz "= $FAF0"
TEST_hexstring:
  lda #<hexstring_message
  sta LCD_STRING_PTR
  lda #>hexstring_message
  sta LCD_STRING_PTR + 1
  jsr LCD_print_string   

  lda #$f0
  sta MATH_CONVERT_VAL
  lda #$fa
  sta MATH_CONVERT_VAL + 1
  jsr MATH_hex_to_hexstring

  jsr LCD_display_math_convert_out
  ; return
  rts

TEST_print_math_output:
  lda MATH_OUTPUT
  sta MATH_CONVERT_VAL
  lda MATH_OUTPUT + 1
  sta MATH_CONVERT_VAL + 1
  jsr MATH_hex_to_decstring

  jsr LCD_display_math_convert_out
  ; return
  rts

TEST_prep:
  jsr MATH_clear_inputs
  jsr MATH_clear_output
  lda #$40
  jsr LCD_goto_address
  ; return
  rts

TEST_wait_and_clear:
  lda #2
  jsr TIME_delay_s
  jsr LCD_clear_display
  ; return
  rts
