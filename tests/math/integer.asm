; TEST - MATH - Integer

.macro test subroutine
  jsr subroutine
  jsr TEST_wait_and_clear
.endmacro

;;; Test Suites ;;;
TEST_suite_math_int:
  jsr TEST_suite_math_int_comparisons
  jsr TEST_suite_math_int_basic
  ; return
  rts

TEST_suite_math_int_basic:
  test TEST_add_int
  test TEST_sub_int
  test TEST_mult_int
  test TEST_div_int
  ; return
  rts

TEST_suite_math_int_comparisons:
  test TEST_gt_int_1
  test TEST_gt_int_2
  test TEST_gt_int_3
  test TEST_gt_int_4
  test TEST_gt_int_5
  
  test TEST_eq_int
  test TEST_neq_int
  
  test TEST_gte_int_1
  test TEST_gte_int_2
  test TEST_gte_int_3
  test TEST_gte_int_4
  test TEST_gte_int_5

  test TEST_lt_int_1
  test TEST_lt_int_2
  test TEST_lt_int_3
  test TEST_lt_int_4
  test TEST_lt_int_5
  ; return
  rts

;;; Basic Math ;;;
add_int_message:     .asciiz "50+50==100"
TEST_add_int:
  print add_int_message          

  jsr TEST_math_prep
  
  lda #50
  sta MATH_INT_INPUT_1
  sta MATH_INT_INPUT_2
  jsr MATH_add_int

  jsr TEST_print_math_int_output
  ; return
  rts

sub_int_message:     .asciiz "50-100==-50"
TEST_sub_int:
  print sub_int_message

  jsr TEST_math_prep

  lda #50
  sta MATH_INT_INPUT_1
  lda #100
  sta MATH_INT_INPUT_2
  jsr MATH_sub_int

  jsr TEST_print_math_int_output
  ; return
  rts

mlt_int_message: .asciiz "5x-10==-50"
TEST_mult_int: 
  print mlt_int_message

  jsr TEST_math_prep

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

div_int_message: .asciiz "170/13==13r1"
TEST_div_int: 
  print div_int_message

  jsr TEST_math_prep

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

;;; Comparisons ;;;
eq_int_message:  .asciiz "50==50==1"
TEST_eq_int:
  print eq_int_message

  jsr TEST_math_prep
  
  lda #50
  sta MATH_INT_INPUT_1
  sta MATH_INT_INPUT_2
  jsr MATH_eq_int

  jsr TEST_print_math_int_output
  ; return
  rts

neq_int_message:  .asciiz "50!=50==0"
TEST_neq_int:
  print neq_int_message

  jsr TEST_math_prep
  
  lda #50
  sta MATH_INT_INPUT_1
  sta MATH_INT_INPUT_2
  jsr MATH_neq_int

  jsr TEST_print_math_int_output
  ; return
  rts

gte_int_message_1: .asciiz "50>=50==1"
TEST_gte_int_1:
  print gte_int_message_1

  jsr TEST_math_prep
  
  lda #50
  sta MATH_INT_INPUT_1
  sta MATH_INT_INPUT_2
  jsr MATH_gte_int

  jsr TEST_print_math_int_output
  ; return
  rts

gte_int_message_2: .asciiz "50>=60==0"
TEST_gte_int_2:
  print gte_int_message_2

  jsr TEST_math_prep
  
  lda #50
  sta MATH_INT_INPUT_1
  lda #60
  sta MATH_INT_INPUT_2
  jsr MATH_gte_int

  jsr TEST_print_math_int_output
  ; return
  rts

gte_int_message_3: .asciiz "60>=50==1"
TEST_gte_int_3:
  print gte_int_message_3

  jsr TEST_math_prep
  
  lda #60
  sta MATH_INT_INPUT_1
  lda #50
  sta MATH_INT_INPUT_2
  jsr MATH_gte_int

  jsr TEST_print_math_int_output
  ; return
  rts

gte_int_message_4: .asciiz "-50>=-60==1"
TEST_gte_int_4:
  print gte_int_message_4

  jsr TEST_math_prep
  
  lda #$ce
  sta MATH_INT_INPUT_1
  lda #$c4
  sta MATH_INT_INPUT_2
  lda #$ff
  sta MATH_INT_INPUT_1 + 1
  sta MATH_INT_INPUT_2 + 1
  jsr MATH_gte_int

  jsr TEST_print_math_int_output
  ; return
  rts

gte_int_message_5: .asciiz "-60>=-50==0"
TEST_gte_int_5:
  print gte_int_message_5

  jsr TEST_math_prep
  
  lda #$c4
  sta MATH_INT_INPUT_1
  lda #$ce
  sta MATH_INT_INPUT_2
  lda #$ff
  sta MATH_INT_INPUT_1 + 1
  sta MATH_INT_INPUT_2 + 1
  jsr MATH_gte_int

  jsr TEST_print_math_int_output
  ; return
  rts

lt_int_message_1: .asciiz "50<50==0"
TEST_lt_int_1:
  print lt_int_message_1

  jsr TEST_math_prep
  
  lda #50
  sta MATH_INT_INPUT_1
  sta MATH_INT_INPUT_2
  jsr MATH_lt_int

  jsr TEST_print_math_int_output
  ; return
  rts

lt_int_message_2: .asciiz "50<60==1"
TEST_lt_int_2:
  print lt_int_message_2

  jsr TEST_math_prep
  
  lda #50
  sta MATH_INT_INPUT_1
  lda #60
  sta MATH_INT_INPUT_2
  jsr MATH_lt_int

  jsr TEST_print_math_int_output
  ; return
  rts

lt_int_message_3: .asciiz "60<50==0"
TEST_lt_int_3:
  print lt_int_message_3

  jsr TEST_math_prep
  
  lda #60
  sta MATH_INT_INPUT_1
  lda #50
  sta MATH_INT_INPUT_2
  jsr MATH_lt_int

  jsr TEST_print_math_int_output
  ; return
  rts

lt_int_message_4: .asciiz "-50<-60==0"
TEST_lt_int_4:
  print lt_int_message_4

  jsr TEST_math_prep
  
  lda #$ce
  sta MATH_INT_INPUT_1
  lda #$c4
  sta MATH_INT_INPUT_2
  lda #$ff
  sta MATH_INT_INPUT_1 + 1
  sta MATH_INT_INPUT_2 + 1
  jsr MATH_lt_int

  jsr TEST_print_math_int_output
  ; return
  rts

lt_int_message_5: .asciiz "-60<-50==1"
TEST_lt_int_5:
  print lt_int_message_5

  jsr TEST_math_prep
  
  lda #$c4
  sta MATH_INT_INPUT_1
  lda #$ce
  sta MATH_INT_INPUT_2
  lda #$ff
  sta MATH_INT_INPUT_1 + 1
  sta MATH_INT_INPUT_2 + 1
  jsr MATH_lt_int

  jsr TEST_print_math_int_output
  ; return
  rts
  

gt_int_message_1: .asciiz "50>50==0"
TEST_gt_int_1:
  print gt_int_message_1

  jsr TEST_math_prep
  
  lda #50
  sta MATH_INT_INPUT_1
  sta MATH_INT_INPUT_2
  jsr MATH_gt_int

  jsr TEST_print_math_int_output
  ; return
  rts

gt_int_message_2: .asciiz "50>60==0"
TEST_gt_int_2:
  print gt_int_message_2

  jsr TEST_math_prep
  
  lda #50
  sta MATH_INT_INPUT_1
  lda #60
  sta MATH_INT_INPUT_2
  jsr MATH_gt_int

  jsr TEST_print_math_int_output
  ; return
  rts

gt_int_message_3: .asciiz "60>50==1"
TEST_gt_int_3:
  print gt_int_message_3

  jsr TEST_math_prep
  
  lda #60
  sta MATH_INT_INPUT_1
  lda #50
  sta MATH_INT_INPUT_2
  jsr MATH_gt_int

  jsr TEST_print_math_int_output
  ; return
  rts

gt_int_message_4: .asciiz "-50>-60==1"
TEST_gt_int_4:
  print gt_int_message_4

  jsr TEST_math_prep
  
  lda #$ce
  sta MATH_INT_INPUT_1
  lda #$c4
  sta MATH_INT_INPUT_2
  lda #$ff
  sta MATH_INT_INPUT_1 + 1
  sta MATH_INT_INPUT_2 + 1
  jsr MATH_gt_int

  jsr TEST_print_math_int_output
  ; return
  rts

gt_int_message_5: .asciiz "-60>-50==0"
TEST_gt_int_5:
  print gt_int_message_5

  jsr TEST_math_prep
  
  lda #$c4
  sta MATH_INT_INPUT_1
  lda #$ce
  sta MATH_INT_INPUT_2
  lda #$ff
  sta MATH_INT_INPUT_1 + 1
  sta MATH_INT_INPUT_2 + 1
  jsr MATH_gt_int

  jsr TEST_print_math_int_output
  ; return
  rts
