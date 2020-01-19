; Say hello.
; Load our executable at $F000.
; Our executable will write 'RICO' to memory addresses starting at $0.

.MEMORYMAP
   DEFAULTSLOT     0
   ; RAM area
   SLOTSIZE $4000
   SLOT 0 $0000
   SLOT 1 $4000
   SLOT 2 $8000
   ; ROM area
   SLOTSIZE $1000
   SLOT 3 $F000
.ENDME

.ROMBANKMAP
BANKSTOTAL 4
BANKSIZE $1000
BANKS 4
.ENDRO

.EMPTYFILL $AA

.BANK 0 SLOT 3
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

.ORGA $FFFE
.SECTION "VECTORS" FORCE
.DW Main
.ENDS

