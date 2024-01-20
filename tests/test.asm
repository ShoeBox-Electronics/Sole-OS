; Tests of libraries to make sure they stay functional as modifications are made

  .include "tests/math/math.asm"

TEST_suite:
  jsr TEST_suite_math

  jmp TEST_suite

TEST_wait_and_clear:
  lda #2
  jsr TIME_delay_s
  jsr LCD_clear_display
  ; return
  rts