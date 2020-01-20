ROMSTART EQU $F000
STARTVEC EQU $FFFE  ; On reset CPU reads a word here and starts executing at that address.
;
    ORG ROMSTART
START
    LDA #$52 ; 'R
    STA $0000
    LDA #$49 ; 'I
    STA $0001
    LDA #$43 ; 'C
    STA $0002
    LDA #$4f ; 'O
    STA $0003
;
; Put the numbers from 10 counting down to 1 starting at $1000.
    LDX #$1000
    LDA #10
;
LP  STA ,X+
    ;DECA ; Why doesn't this assemble?
    SUBA #1
    BNE LP
;
HALT BRA HALT
;
;   This is to make the 6809 emulator stop executing.
;   It will stop with "Illegal addressing mode".
;HALT
;    FDB $AAAA
;    FDB $AAAA
;
; On reset, the 6809 processor reads address $FFFE
; and starts executing there.  This puts the address of Main ($F000) into that vector.
    ORG STARTVEC
    FDB ROMSTART
    END