; Tests of libraries to make sure they stay functional as modifications are made

TEST_suite:
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

  jmp TEST_suite

eq_int_message:  .asciiz "50==50=1"
TEST_eq_int:
  lda #<eq_int_message
  sta LCD_STRING_PTR
  lda #>eq_int_message
  sta LCD_STRING_PTR + 1
  jsr LCD_print_string                  

  jsr TEST_prep
  
  lda #50
  sta MATH_INT_INPUT_1
  sta MATH_INT_INPUT_2
  jsr MATH_eq_int

  jsr TEST_print_math_int_output
  ; return
  rts

neq_int_message:  .asciiz "50!=50=0"
TEST_neq_int:
  lda #<neq_int_message
  sta LCD_STRING_PTR
  lda #>neq_int_message
  sta LCD_STRING_PTR + 1
  jsr LCD_print_string                  

  jsr TEST_prep
  
  lda #50
  sta MATH_INT_INPUT_1
  sta MATH_INT_INPUT_2
  jsr MATH_neq_int

  jsr TEST_print_math_int_output
  ; return
  rts

gt_int_message:  .asciiz "50>50=0"
TEST_gt_int:
  lda #<gt_int_message
  sta LCD_STRING_PTR
  lda #>gt_int_message
  sta LCD_STRING_PTR + 1
  jsr LCD_print_string                  

  jsr TEST_prep
  
  lda #50
  sta MATH_INT_INPUT_1
  sta MATH_INT_INPUT_2
  jsr MATH_gt_int

  jsr TEST_print_math_int_output
  ; return
  rts

add_int_pos_message: .asciiz "50+50=100"
TEST_add_int_pos:
  lda #<add_int_pos_message
  sta LCD_STRING_PTR
  lda #>add_int_pos_message
  sta LCD_STRING_PTR + 1
  jsr LCD_print_string                  

  jsr TEST_prep
  
  lda #50
  sta MATH_INT_INPUT_1
  sta MATH_INT_INPUT_2
  jsr MATH_add_int

  jsr TEST_print_math_int_output
  ; return
  rts

add_int_neg_message: .asciiz "-50+-50=-100"
TEST_add_int_neg:
  lda #<add_int_neg_message
  sta LCD_STRING_PTR
  lda #>add_int_neg_message
  sta LCD_STRING_PTR + 1
  jsr LCD_print_string                  

  jsr TEST_prep
  
  lda #$ce
  sta MATH_INT_INPUT_1
  sta MATH_INT_INPUT_2
  lda #$ff
  sta MATH_INT_INPUT_1 + 1
  sta MATH_INT_INPUT_2 + 1
  jsr MATH_add_int

  jsr TEST_print_math_int_output
  ; return
  rts

sub_int_pos_message: .asciiz "100-50=50"
TEST_sub_int_pos:
  lda #<sub_int_pos_message
  sta LCD_STRING_PTR
  lda #>sub_int_pos_message
  sta LCD_STRING_PTR + 1
  jsr LCD_print_string                  

  jsr TEST_prep

  lda #100
  sta MATH_INT_INPUT_1
  lda #50
  sta MATH_INT_INPUT_2
  jsr MATH_sub_int

  jsr TEST_print_math_int_output
  ; return
  rts

sub_int_neg_message: .asciiz "50-100=-50"
TEST_sub_int_neg:
  lda #<sub_int_neg_message
  sta LCD_STRING_PTR
  lda #>sub_int_neg_message
  sta LCD_STRING_PTR + 1
  jsr LCD_print_string                  

  jsr TEST_prep

  lda #50
  sta MATH_INT_INPUT_1
  lda #100
  sta MATH_INT_INPUT_2
  jsr MATH_sub_int

  jsr TEST_print_math_int_output
  ; return
  rts

mlt_int_message: .asciiz "5x-10=-50"
TEST_mult_int: 
  lda #<mlt_int_message
  sta LCD_STRING_PTR
  lda #>mlt_int_message
  sta LCD_STRING_PTR + 1
  jsr LCD_print_string                

  jsr TEST_prep

  lda #5
  sta MATH_INT_INPUT_1
  lda #$f6
  sta MATH_INT_INPUT_2
  lda #$ff
  sta MATH_INT_INPUT_2 + 1
  jsr MATH_mlt_int
  
  jsr TEST_print_math_int_output
  ; return
  rts

div_int_message: .asciiz "170/13=13r1"
TEST_div_int: 
  lda #<div_int_message
  sta LCD_STRING_PTR
  lda #>div_int_message
  sta LCD_STRING_PTR + 1
  jsr LCD_print_string               

  jsr TEST_prep

  lda #170
  sta MATH_INT_INPUT_1
  lda #13
  sta MATH_INT_INPUT_2
  jsr MATH_div_int

  jsr TEST_print_math_int_output

  lda #'r'
  jsr LCD_print_char

  lda MATH_INT_MISC
  sta MATH_CONVERT_VAL
  lda MATH_INT_MISC + 1
  sta MATH_CONVERT_VAL + 1
  jsr MATH_int_to_string

  jsr LCD_display_math_convert_out
  ; return
  rts

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

  jsr TEST_prep

  jsr LCD_display_math_convert_out
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

TEST_prep:
  jsr MATH_clear_int_inputs
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
