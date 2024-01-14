; Tests of libraries to make sure they stay functional as modifications are made

TEST_suite:
  jsr TEST_add_pos
  lda #2
  jsr TIME_delay_s
  jsr LCD_clear_display

  jsr TEST_add_neg
  lda #2
  jsr TIME_delay_s
  jsr LCD_clear_display

  jsr TEST_sub_pos
  lda #2
  jsr TIME_delay_s
  jsr LCD_clear_display

  jsr TEST_sub_neg
  lda #2
  jsr TIME_delay_s
  jsr LCD_clear_display

  jsr TEST_mult
  lda #2
  jsr TIME_delay_s
  jsr LCD_clear_display

  jsr TEST_div
  lda #2
  jsr TIME_delay_s
  jsr LCD_clear_display

  jsr TEST_hexstring
  lda #2
  jsr TIME_delay_s
  jsr LCD_clear_display

  jmp TEST_suite

add_pos_message: .asciiz "50+50=100"
TEST_add_pos:
  lda #<add_pos_message    ; #< Means low byte of the address of a label.  
  sta LCD_STRING_PTR       ; Save to pointer  
  lda #>add_pos_message    ; #> Means high byte of the address of a label.  
  sta LCD_STRING_PTR + 1   ; Save to pointer + 1  
  jsr LCD_print_string

  lda #$40
  jsr LCD_goto_address

  jsr MATH_clear_inputs
  jsr MATH_clear_output
  
  lda #50
  sta MATH_INPUT_1
  sta MATH_INPUT_2

  jsr MATH_add
  jsr TEST_print_math_output
  ; return
  rts

add_neg_message: .asciiz "-50+-50=-100"
TEST_add_neg:
  lda #<add_neg_message    ; #< Means low byte of the address of a label.  
  sta LCD_STRING_PTR       ; Save to pointer  
  lda #>add_neg_message    ; #> Means high byte of the address of a label.  
  sta LCD_STRING_PTR + 1   ; Save to pointer + 1  
  jsr LCD_print_string

  lda #$40
  jsr LCD_goto_address

  jsr MATH_clear_inputs
  jsr MATH_clear_output
  
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
  lda #<sub_pos_message    ; #< Means low byte of the address of a label.  
  sta LCD_STRING_PTR       ; Save to pointer  
  lda #>sub_pos_message    ; #> Means high byte of the address of a label.  
  sta LCD_STRING_PTR + 1   ; Save to pointer + 1  
  jsr LCD_print_string

  lda #$40
  jsr LCD_goto_address

  jsr MATH_clear_inputs
  jsr MATH_clear_output

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
  lda #<sub_neg_message    ; #< Means low byte of the address of a label.  
  sta LCD_STRING_PTR       ; Save to pointer  
  lda #>sub_neg_message    ; #> Means high byte of the address of a label.  
  sta LCD_STRING_PTR + 1   ; Save to pointer + 1  
  jsr LCD_print_string

  lda #$40
  jsr LCD_goto_address

  jsr MATH_clear_inputs
  jsr MATH_clear_output

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
  lda #<mlt_message    ; #< Means low byte of the address of a label.  
  sta LCD_STRING_PTR       ; Save to pointer  
  lda #>mlt_message    ; #> Means high byte of the address of a label.  
  sta LCD_STRING_PTR + 1   ; Save to pointer + 1  
  jsr LCD_print_string

  lda #$40
  jsr LCD_goto_address

  jsr MATH_clear_inputs
  jsr MATH_clear_output

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
  lda #<div_message    ; #< Means low byte of the address of a label.  
  sta LCD_STRING_PTR       ; Save to pointer  
  lda #>div_message    ; #> Means high byte of the address of a label.  
  sta LCD_STRING_PTR + 1   ; Save to pointer + 1  
  jsr LCD_print_string

  lda #$40
  jsr LCD_goto_address

  jsr MATH_clear_inputs
  jsr MATH_clear_output

  lda #170
  sta MATH_INPUT_1
  lda #13
  sta MATH_INPUT_2

  jsr MATH_div
  jsr TEST_print_math_output
  
  lda #'r'
  jsr LCD_print_char

  jsr MATH_swap_output
  jsr TEST_print_math_output
  ; return
  rts

hexstring_message: .asciiz "= $FAF0"
TEST_hexstring:
  lda #<hexstring_message    ; #< Means low byte of the address of a label.  
  sta LCD_STRING_PTR       ; Save to pointer  
  lda #>hexstring_message    ; #> Means high byte of the address of a label.  
  sta LCD_STRING_PTR + 1   ; Save to pointer + 1  
  jsr LCD_print_string

  lda #$40
  jsr LCD_goto_address

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
