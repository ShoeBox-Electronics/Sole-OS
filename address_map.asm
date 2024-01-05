; LCD: lib/lcd.asm
; MATH: lib/math.asm
; VIA: W65C22 (chip)

; ADDRESSES MAP

; 0 Block ($0000-$0fff) | RAM
  ; 00 Page (Special uses, use sparingly)
LCD_STRING_PTR = $00                    ; LCD  ; 2 bytes (bust be zero-page)
  ; 01 Page (Reserved by 6502 Stack)
  ; 02 Page
MATH_HEXDEC_VAL = $0200                 ; MATH ; Hex-Dec conversion Value Pointer   ; 2 bytes
MATH_HEXDEC_MOD = $0202                 ; MATH ; Hex-Dec conversion Modulus Pointer ; 2 bytes
MATH_HEXDEC_OUT = $0204                 ; MATH ; Hex-Dec conversion Output Pointer  ; 6 bytes

; 1 Block ($1000-$1fff) | RAM
; 2 Block ($2000-$2fff) | RAM
; 3 Block ($3000-$3fff) | RAM

; 4 Block ($4000-$4fff) | Unallocated
; 5 Block ($5000-$5fff) | Unallocated
; 6 Block ($6000-$6fff) | VIA chip / Unallocated (only needs $6000-$600f)
  ; 60 Page
VIA_PORTB = $6000                       ; VIA  ; Output Register B
VIA_PORTA = $6001                       ; VIA  ; Output Register A
VIA_DDRB  = $6002                       ; VIA  ; Data Direction Register for B
VIA_DDRA  = $6003                       ; VIA  ; Data Direction Register for A

; 7 Block ($7000-$7fff) | Unallocated

; 8 Block ($8000-$8fff) | ROM
  ; 80 Page
    ; The reset vector points here, so our "OS" starts being written at $8000 and continues from here
; 9 Block ($9000-$9fff) | ROM
; A Block ($a000-$afff) | ROM
; B Block ($b000-$bfff) | ROM
; C Block ($c000-$cfff) | ROM
; D Block ($d000-$dfff) | ROM
; E Block ($e000-$efff) | ROM

; F Block ($f000-$ffff) | ROM
  ; FF Page
    ; $fffa-$ffff is reserved for destination vectors nmi, reset, and irq respectively (2-bytes each)
