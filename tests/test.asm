; Tests of libraries to make sure they stay functional as modifications are made

.macro run_test subroutine
  jsr subroutine
  jsr TEST_wait_and_clear
.endmacro
  
  .include "tests/math/math.asm"

TEST_suite_all:
  jsr TEST_suite_math_all
  jmp TEST_suite_all

TEST_wait_and_clear:
  lda #1
  jsr TIME_delay_s
  jsr LCD_clear_display
  rts
