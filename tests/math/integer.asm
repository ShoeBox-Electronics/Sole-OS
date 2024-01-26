; TEST - MATH - Integer
.macro test_for_prime numL, numH
.ifnblank numH
  set_int_input numL, numH, 0, 0
.endif
.ifblank numH
  set_int_input numL, 0, 0, 0
.endif
  print_int MATH_INT_INPUT_1
  jsr LCD_to_home_bottom
  jsr MATH_is_prime
  print_int MATH_INT_OUTPUT
  jsr TEST_wait_and_clear
.endmacro

;;; Test Suites ;;;
TEST_suite_math_int_all:
  jsr TEST_suite_math_int_basic
  jsr TEST_suite_math_int_primes
  jsr TEST_suite_math_int_comparisons
  rts

TEST_suite_math_int_basic:
  run_test TEST_sqrt_int
  run_test TEST_opp_int
  run_test TEST_add_int
  run_test TEST_sub_int
  run_test TEST_mult_int
  run_test TEST_div_int
  run_test TEST_mod_int
  rts

TEST_suite_math_int_primes:
  test_for_prime $ed, $7f ; 32749, prime (longest test, takes ~34.5s)

  test_for_prime $25, $01 ; 293, prime
  test_for_prime $db, $fe ; -293, prime
  
  test_for_prime 0
  test_for_prime 1
  test_for_prime 2
  test_for_prime 3
  test_for_prime 4
  test_for_prime 5
  test_for_prime 6
  test_for_prime 7
  test_for_prime 8
  test_for_prime 9
  test_for_prime 10
  rts

TEST_suite_math_int_comparisons:
  run_test TEST_eq_int
  run_test TEST_neq_int

  run_test TEST_lt_int_1
  run_test TEST_lt_int_2
  run_test TEST_lt_int_3

  run_test TEST_lte_int_1
  run_test TEST_lte_int_2
  run_test TEST_lte_int_3
  
  run_test TEST_gt_int_1
  run_test TEST_gt_int_2
  run_test TEST_gt_int_3
  
  run_test TEST_gte_int_1
  run_test TEST_gte_int_2
  run_test TEST_gte_int_3
  rts

;;; Basic Math ;;;
sqrt_int_message:     .asciiz "sqrt(25)==5"
TEST_sqrt_int:
  print sqrt_int_message          
  set_int_input 25, 0, 0, 0
  jsr LCD_to_home_bottom
  jsr MATH_sqrt_int
  print_int MATH_INT_OUTPUT
  rts

opp_int_message:     .asciiz "-(50)=-50"
TEST_opp_int:
  print opp_int_message          
  set_int_input 50, 0, 50, 0
  jsr LCD_to_home_bottom
  jsr MATH_opp_int
  print_int MATH_INT_OUTPUT
  rts

add_int_message:     .asciiz "50+50==100"
TEST_add_int:
  print add_int_message          
  set_int_input 50, 0, 50, 0
  jsr LCD_to_home_bottom
  jsr MATH_add_int
  print_int MATH_INT_OUTPUT
  rts

sub_int_message:     .asciiz "50-100==-50"
TEST_sub_int:
  print sub_int_message
  set_int_input 50, 0, 100, 0
  jsr LCD_to_home_bottom
  print_int MATH_INT_OUTPUT
  rts

mlt_int_message: .asciiz "5x10==50"
TEST_mult_int: 
  print mlt_int_message
  set_int_input 5, 0, 10, 0
  jsr LCD_to_home_bottom
  jsr MATH_mlt_int
  print_int MATH_INT_OUTPUT
  rts

div_int_message: .asciiz "170/13==13r1"
TEST_div_int: 
  print div_int_message
  set_int_input 170, 0, 13, 0
  jsr LCD_to_home_bottom
  jsr MATH_div_int
  print_int MATH_INT_OUTPUT
  lda #'r'
  jsr LCD_print_char
  print_int MATH_INT_MISC
  rts

mod_int_message: .asciiz "170%13==1"
TEST_mod_int: 
  print mod_int_message
  set_int_input 170, 0, 13, 0
  jsr LCD_to_home_bottom
  jsr MATH_mod_int
  print_int MATH_INT_OUTPUT
  rts

;;; Comparisons ;;;
eq_int_message:  .asciiz "50==50==1"
TEST_eq_int:
  print eq_int_message
  set_int_input 50, 0, 50, 0
  jsr LCD_to_home_bottom
  jsr MATH_eq_int
  print_int MATH_INT_OUTPUT
  rts

neq_int_message:  .asciiz "50!=50==0"
TEST_neq_int:
  print neq_int_message
  set_int_input 50, 0, 50, 0
  jsr LCD_to_home_bottom
  jsr MATH_neq_int
  print_int MATH_INT_OUTPUT
  rts

gte_int_message_1: .asciiz "50>=50==1"
TEST_gte_int_1:
  print gte_int_message_1
  set_int_input 50, 0, 50, 0
  jsr LCD_to_home_bottom
  jsr MATH_gte_int
  print_int MATH_INT_OUTPUT
  rts

gte_int_message_2: .asciiz "50>=60==0"
TEST_gte_int_2:
  print gte_int_message_2
  set_int_input 50, 0, 60, 0
  jsr LCD_to_home_bottom
  jsr MATH_gte_int
  print_int MATH_INT_OUTPUT
  rts

gte_int_message_3: .asciiz "60>=50==1"
TEST_gte_int_3:
  print gte_int_message_3
  set_int_input 60, 0, 50, 0
  jsr LCD_to_home_bottom
  jsr MATH_gte_int
  print_int MATH_INT_OUTPUT
  rts

lt_int_message_1: .asciiz "50<50==0"
TEST_lt_int_1:
  print lt_int_message_1
  set_int_input 50, 0, 50, 0
  jsr LCD_to_home_bottom
  jsr MATH_lt_int
  print_int MATH_INT_OUTPUT
  rts

lt_int_message_2: .asciiz "50<60==1"
TEST_lt_int_2:
  print lt_int_message_2
  set_int_input 50, 0, 60, 0
  jsr LCD_to_home_bottom
  jsr MATH_lt_int
  print_int MATH_INT_OUTPUT
  rts

lt_int_message_3: .asciiz "60<50==0"
TEST_lt_int_3:
  print lt_int_message_3
  set_int_input 60, 0, 50, 0
  jsr LCD_to_home_bottom
  jsr MATH_lt_int
  print_int MATH_INT_OUTPUT
  rts

gt_int_message_1: .asciiz "50>50==0"
TEST_gt_int_1:
  print gt_int_message_1
  set_int_input 50, 0, 50, 0
  jsr LCD_to_home_bottom
  jsr MATH_gt_int
  print_int MATH_INT_OUTPUT
  rts

gt_int_message_2: .asciiz "50>60==0"
TEST_gt_int_2:
  print gt_int_message_2
  set_int_input 50, 0, 60, 0
  jsr LCD_to_home_bottom
  jsr MATH_gt_int
  print_int MATH_INT_OUTPUT
  rts

gt_int_message_3: .asciiz "60>50==1"
TEST_gt_int_3:
  print gt_int_message_3
  set_int_input 60, 0, 50, 0
  jsr MATH_gt_int
  jsr LCD_to_home_bottom
  print_int MATH_INT_OUTPUT
  rts

lte_int_message_1: .asciiz "50<=50==1"
TEST_lte_int_1:
  print lte_int_message_1
  set_int_input 50, 0, 50, 0
  jsr LCD_to_home_bottom
  jsr MATH_lte_int
  print_int MATH_INT_OUTPUT
  rts

lte_int_message_2: .asciiz "50<=60==1"
TEST_lte_int_2:
  print lte_int_message_2
  set_int_input 50, 0, 60, 0
  jsr LCD_to_home_bottom
  jsr MATH_lte_int
  print_int MATH_INT_OUTPUT
  rts

lte_int_message_3: .asciiz "60<=50==0"
TEST_lte_int_3:
  print lte_int_message_3
  set_int_input 60, 0, 50, 0
  jsr LCD_to_home_bottom
  jsr MATH_lte_int
  print_int MATH_INT_OUTPUT
  rts
