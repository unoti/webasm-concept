; Say hello.
; Load our executable at $F000.
; Our executable will write 'RICO' to memory addresses starting at $0.

.MEMORYMAP
   DEFAULTSLOT     0
   ; RAM area
   SLOTSIZE $10000
   SLOT 0 $0000
.ENDME

.ROMBANKMAP
BANKSTOTAL 1
BANKSIZE $10000
BANKS 1
.ENDRO

.EMPTYFILL $AA

.BANK 0 SLOT 0
.ORGA $F000

.SECTION "MAIN" FORCE
Main:	
    LDA #$52 ; 'R
    STA $0000
    LDA #$49 ; 'I
    STA $0001
    LDA #$43 ; 'C
    STA $0002
    LDA #$4f ; 'O
    STA $0003
.ENDS

; On reset, the 6809 processor reads address $FFFE
; and starts executing there.  This puts the address of Main ($F000) into that vector.
.ORGA $FFFE
.SECTION "VECTORS" FORCE
.DW Main
.ENDS

