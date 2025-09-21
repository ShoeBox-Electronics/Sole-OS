; Fibonacci Libary
  ; This is a casual library, not to be maintained or prioritized as others
  ; But I would like to keep it as a personal thing

FIB_init:
  jsr MATH_clear_int_inputs
  jsr MATH_clear_int_output
  lda #1
  sta MATH_INT_OUTPUT
  lda #22
  sta FIB_LIMIT
  rts

FIB_display:
  jsr LCD_clear_display
  ; print INPUT_1
  print_int MATH_INT_INPUT_1
  ; print '+'
  lda #'+'
  jsr LCD_print_char
  ; print INPUT_2
  print_int MATH_INT_INPUT_2
  ; print '='
  lda #'='
  jsr LCD_print_char
  ; Second row, second column
  lda #$41
  jsr LCD_goto_address
  ; print OUTPUT
  print_int MATH_INT_OUTPUT
  ; wait one second
  lda #1
  jsr TIME_delay_s
  rts

FIB_shift_and_add:
  ; shift b to a
  lda MATH_INT_INPUT_2
  sta MATH_INT_INPUT_1
  lda MATH_INT_INPUT_2 + 1
  sta MATH_INT_INPUT_1 + 1
  ; shift output to b
  lda MATH_INT_OUTPUT
  sta MATH_INT_INPUT_2
  lda MATH_INT_OUTPUT + 1
  sta MATH_INT_INPUT_2 + 1
  ; do a+b and store it in output
  jsr MATH_add_int
  rts

FIB_progress:
  jsr FIB_shift_and_add
  jsr FIB_display
  ; print out results and increment fib counter
  dec FIB_LIMIT
  rts

FIB_demo:
  jsr FIB_init
@loop:
  jsr FIB_progress
  lda FIB_LIMIT
  beq FIB_demo
  jmp @loop