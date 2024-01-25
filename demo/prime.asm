.macro test_for_prime num
  set_int_input num, 0, 0, 0
  print_int MATH_INT_INPUT_1

  jsr LCD_to_home_bottom

  jsr check_prime
  print_int MATH_INT_OUTPUT

  lda #1
  jsr TIME_delay_s
  jsr LCD_clear_display
.endmacro

demo:
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
  test_for_prime 11
  test_for_prime 12
  test_for_prime 13
  test_for_prime 14
  test_for_prime 15
  test_for_prime 16
  test_for_prime 17
  test_for_prime 18
  test_for_prime 19
  test_for_prime 20
  test_for_prime 21
  test_for_prime 22
  test_for_prime 23
  test_for_prime 24
  test_for_prime 25
  test_for_prime 26
  test_for_prime 27
  test_for_prime 28
  test_for_prime 29
  test_for_prime 30
  test_for_prime 31
  test_for_prime 32
  test_for_prime 33
  test_for_prime 34
  test_for_prime 35
  test_for_prime 36
  test_for_prime 37
  test_for_prime 38
  test_for_prime 39
  test_for_prime 40
  test_for_prime 41
  test_for_prime 42
  test_for_prime 43
  test_for_prime 44
  test_for_prime 45
  test_for_prime 46
  test_for_prime 47
  test_for_prime 48
  test_for_prime 49
  test_for_prime 50
  test_for_prime 51
  test_for_prime 52
  test_for_prime 53
  test_for_prime 54
  test_for_prime 55
  test_for_prime 56
  test_for_prime 57
  test_for_prime 58
  test_for_prime 59
@halt:
  jmp @halt

check_prime:
  ; check weird cases
  sec
  lda MATH_INT_INPUT_1
  cmp #1
  beq @not_prime ; 1 is not prime
  cmp #2
  beq @prime ; 2 is prime
  lda #2 ; start checking with 2
  sta MATH_INT_INPUT_2
@loop:
  ; check if there's a remainder when dividing by x
  jsr MATH_mod_int
  lda MATH_INT_OUTPUT
  beq @not_prime
  ; increment our divisor and compare it to our number to check
  ;  if zero, we're done checking and it's prime
  inc MATH_INT_INPUT_2
  lda MATH_INT_INPUT_2
  cmp MATH_INT_INPUT_1
  beq @prime
  jmp @loop
@not_prime:
  lda #0
  jmp @return
@prime:
  lda #1
@return:
  sta MATH_INT_OUTPUT
  rts
