TIME_init:
  lda #0
  sta VIA_ACR
  rts

TIME_delay_ts:      ; Delay for 0.1s times the value in the A register (max 25.5s)
  sta TIME_TS_COUNT
delay_ts_loop:      ; Delay for 0.1s
  lda #100
  jsr TIME_delay_ms
  lda TIME_TS_COUNT
  beq delay_ts_end
  dec TIME_TS_COUNT
  jmp delay_ts_loop
delay_ts_end:
  rts

TIME_delay_ms:      ; Delay for 1ms times the value in the A register (max 255ms)
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