; Fibonacci Libary
  ; This is a casual library, not to be maintained or prioritized as others
  ; But I would like to keep it as a personal thing

FIB_init:
  jsr MATH_clear_inputs
  jsr MATH_clear_output
  lda #1
  sta MATH_OUTPUT
  lda #22
  sta FIB_LIMIT
  ; return
  rts

FIB_display:
  jsr LCD_clear_display
  ; print INPUT_1
  lda MATH_INPUT_1
  sta MATH_CONVERT_VAL
  lda MATH_INPUT_1 + 1
  sta MATH_CONVERT_VAL + 1
  jsr MATH_hex_to_decstring
  jsr LCD_display_math_convert_out
  ; print '+'
  lda #'+'
  jsr LCD_print_char
  ; print INPUT_2
  lda MATH_INPUT_2
  sta MATH_CONVERT_VAL
  lda MATH_INPUT_2 + 1
  sta MATH_CONVERT_VAL + 1
  jsr MATH_hex_to_decstring
  jsr LCD_display_math_convert_out
  ; print '='
  lda #'='
  jsr LCD_print_char
  ; Second row, second column
  lda #$41
  jsr LCD_goto_address
  ; print OUTPUT
  lda MATH_OUTPUT
  sta MATH_CONVERT_VAL
  lda MATH_OUTPUT + 1
  sta MATH_CONVERT_VAL + 1
  jsr MATH_hex_to_decstring
  jsr LCD_display_math_convert_out
  ; wait one second
  lda #1
  jsr TIME_delay_s
  ; return
  rts

FIB_shift_and_add:
  ; shift b to a
  lda MATH_INPUT_2
  sta MATH_INPUT_1
  lda MATH_INPUT_2 + 1
  sta MATH_INPUT_1 + 1
  ; shift output to b
  lda MATH_OUTPUT
  sta MATH_INPUT_2
  lda MATH_OUTPUT + 1
  sta MATH_INPUT_2 + 1
  ; do a+b and store it in output
  jsr MATH_add
  ; return
  rts

FIB_progress:
  jsr FIB_shift_and_add
  jsr FIB_display
  ; print out results and increment fib counter
  dec FIB_LIMIT
  ; return
  rts

FIB_demo:
  jsr FIB_init
@loop:
  jsr FIB_progress
  lda FIB_LIMIT
  beq FIB_demo
  jmp @loop