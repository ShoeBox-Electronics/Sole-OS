  .org $8000

init:
  lda #$ff
  sta $6002

loop:
  lda #$55
  sta $6000

  lda #$aa
  sta $6000

  jmp loop

  .org $fffc
  .word init
  .word $0000
  