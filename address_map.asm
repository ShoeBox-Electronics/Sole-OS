; COMPONENTS AND LIBRARIES
; MATH: General Mathematics
; LCD:  LCD Screen: HD44780 (https://www.sparkfun.com/datasheets/LCD/HD44780.pdf)
; VIA:  Versatile Interface Chip: W65C22 (https://eater.net/datasheets/w65c22.pdf)

; ADDRESS MAP
; 0 Block ($0000-$0fff) | RAM
  ; 00 Page (Special uses, use sparingly)
LCD_STRING_PTR = $00                    ; LCD  ; Location of a string to print  ; 2 bytes
  ; 01 Page (Reserved by CPU Stack)
  ; 02 Page
    ; Convert
MATH_CONVERT_VAL = $0200                 ; MATH ; Conversion Value     ; 2 bytes
MATH_CONVERT_MOD = $0202                 ; MATH ; Conversion Modulus   ; 2 bytes
MATH_CONVERT_OUT = $0204                 ; MATH ; Conversion Output    ; 7 bytes (6 for hex)
    ; General
MATH_INPUT_1    = $0210                 ; MATH ; Math Input 1                   ; 2 bytes
MATH_INPUT_2    = $0212                 ; MATH ; Math Input 2                   ; 2 bytes
MATH_OUTPUT     = $0214                 ; MATH ; Math Output                    ; 4 bytes
MATH_MISC       = $0218                 ; MATH ; Math Misc/Flag                 ; 2 bytes
  ; 03 Page
    ; Fib
FIB_LIMIT = $0300                       ; MATH ; Fibonacci Counter Limit        ; 1 byte
  ; 04 Page
    ; Time delays
TIME_MS_COUNT  = $0400                  ; TIME ; Milliseconds                   ; 1 byte
TIME_TS_COUNT  = $0401                  ; TIME ; Tenths of seconds              ; 1 byte
TIME_S_COUNT   = $0402                  ; TIME ; Seconds                        ; 1 byte

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
VIA_T1CL  = $6004                       ; VIA  ; Timer 1 High-Order Counter
VIA_T1CH  = $6005                       ; VIA  ; Timer 1 Low-Order Counter
VIA_ACR   = $600b                       ; VIA  ; Auxiliary Control Reigister
VIA_IFR   = $600d                       ; VIA  ; Interrupt Flag Register

; 7 Block ($7000-$7fff) | Unallocated

; 8-f Block ($8000-$8fff) | ROM (allocated by compiler and linker)
