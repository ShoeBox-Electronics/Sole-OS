TIME_init:
  lda #0
  sta VIA_ACR
  rts

TIME_delay_s:       ; Delay for 1s times the value in the A register (max 255s, 4.25m)
  sta TIME_S_COUNT
@loop:       ; Delay for 1s
  lda #10
  jsr TIME_delay_ts
  lda TIME_S_COUNT
  beq @end
  dec TIME_S_COUNT
  jmp @loop
@end:
  rts

TIME_delay_ts:      ; Delay for 0.1s times the value in the A register (max 25.5s)
  sta TIME_TS_COUNT
@loop:      ; Delay for 0.1s
  lda #100
  jsr TIME_delay_ms
  lda TIME_TS_COUNT
  beq @end
  dec TIME_TS_COUNT
  jmp @loop
@end:
  rts

TIME_delay_ms:      ; Delay for 1ms times the value in the A register (max 255ms)
  sta TIME_MS_COUNT ; Load the ms to wait
@loop:      
  lda #$e8 ; 1000 (lb)
  sta VIA_T1CL
  lda #$03 ; 1000 (hb)
  sta VIA_T1CH      ; Load the clocks to wait (this line starts the clock)
  lda TIME_MS_COUNT
  beq @end  ; Jump to the end if the remaining ms is zero
  dec TIME_MS_COUNT
@delay:      ; Wait until the VIA tells us we waited the right number of cycles
  bit VIA_IFR
  bvc @delay
  lda VIA_T1CL
  jmp @loop
@end:
  rts
  