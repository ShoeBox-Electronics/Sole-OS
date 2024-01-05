TIME_init:
  lda #0
  sta VIA_ACR
  rts

TIME_delay_s:
  sta TIME_SEC_COUNT
delay_s_loop:
  lda #250
  jsr TIME_delay_ms
  lda #250
  jsr TIME_delay_ms
  lda #250
  jsr TIME_delay_ms
  lda #250
  jsr TIME_delay_ms
  lda TIME_SEC_COUNT
  beq delay_s_end
  dec TIME_SEC_COUNT
  jmp delay_s_loop
delay_s_end:
  rts

TIME_delay_ms:
  sta TIME_MS_COUNT ; Load the ms to wait
delay_ms_loop:      
  lda #$e8
  sta VIA_T1CL
  lda #$03
  sta VIA_T1CH      ; Load the clocks to wait (this line starts the clock)
  lda TIME_MS_COUNT
  beq delay_ms_end  ; Jump to the end if the remaining ms is zero
  dec TIME_MS_COUNT
wait_for_flag:      ; Wait until the VIA tells us we waited the right number of cycles
  bit VIA_IFR
  bvc wait_for_flag
  lda VIA_T1CL
  jmp delay_ms_loop
delay_ms_end:
  rts