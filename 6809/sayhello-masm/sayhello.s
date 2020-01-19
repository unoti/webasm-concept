ROMSTART EQU $F000
STARTVEC EQU $FFFE  ; On reset CPU reads a word here and starts executing at that address.
;
    ORG ROMSTART
START:
    LDA #$52 ; 'R
    STA $0000
    LDA #$49 ; 'I
    STA $0001
    LDA #$43 ; 'C
    STA $0002
    LDA #$4f ; 'O
    STA $0003
;
;   This is to make the 6809 emulator stop executing.
;   It will stop with "Illegal addressing mode".
HALT:
    FDB $AAAA
    FDB $AAAA
;
; On reset, the 6809 processor reads address $FFFE
; and starts executing there.  This puts the address of Main ($F000) into that vector.
    ORG STARTVEC
    FDB ROMSTART
;
; I'd love to also execute this code, but wla-dx can't handle it.
;    ; Now do some counting at $1000.
;.16BIT
;    LDX #$1000.W
;    LDA #10
;Countlp:
;    STA ,X+
;    DECA
;    BNE Countlp
;    ORG $FFFE
;.SECTION "VECTORS" FORCE
;.DW Main
;.ENDS
