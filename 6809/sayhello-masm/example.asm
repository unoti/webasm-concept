;-----------------------------------------------------------------------
; 6811 interface for a dual-axis wind sensor
; G. Forrest Cook	October 18, 1994
; Licensed under the Gnu General Public License (GPL)
;
; Chip: 68HC11A1FN 8Mhz 
;
; This code reads two quadrature inputs from spinning wind
; sensors, tallies the counts, and outputs the results in ASCII via
; the serial port.
;
; This program has C preprocessor #defines embedded in it to support
; a standalone EPROM version and a test version that runs under the
; Motorola Buffalo monitor program, you must run the C preprocessor
; on the source to produce code that assembles correctly.
; The following will run the C preprocessor and assemble the code:
; gcc -x c -E wind.asm > windcpp.asm
; as11 windcpp.asm
;
;-----------------------------------------------------------------------
#ifdef BUFFALO
;	Buffalo Interrupt Vector address locations in RAM
VSCI	EQU	$00C4		; SCI
VSPI	EQU	$00C7		; SPI
VPAIE	EQU	$00CA		; pulse accum input edge
VPAO	EQU	$00CD		; pulse accum overflow
VTOF	EQU	$00D0		; timer overflow
VTOC5	EQU	$00D3		; output compare timers
VTOC4	EQU	$00D6
VTOC3	EQU	$00D9
VTOC2	EQU	$00DC
VTOC1	EQU	$00DF
VTIC3	EQU	$00E2		; input compare timers
VTIC2	EQU	$00E5
VTIC1	EQU	$00E8
VRTI	EQU	$00EB		; real time interrupt
VIRQ	EQU	$00EE		; IRQ
VXIRQ	EQU	$00F1		; Ext IRQ
VSWI	EQU	$00F4		; software interrupt
VILLOP	EQU	$00F7		; illegal opcode interrupt
VCOP	EQU	$00FA		; cop timer interrupt
VCLM	EQU	$00FD		; clock monitor interrupt
#else
INTVEC  EQU     $FFC0           ; interrupt vector locations in EPROM
SCIVEC  EQU     $FFD6
SPIVEC  EQU     $FFD8
PAEVEC  EQU     $FFDA
PAOVEC  EQU     $FFDC
TOVVEC  EQU     $FFDE
TO5VEC  EQU     $FFE0
TO4VEC  EQU     $FFE2
TO3VEC  EQU     $FFE4
TO2VEC  EQU     $FFE6
TO1VEC  EQU     $FFE8
TI3VEC  EQU     $FFEA
TI2VEC  EQU     $FFEC
TI1VEC  EQU     $FFEE
RTIVEC  EQU     $FFF0
IRQVEC  EQU     $FFF2
XIRVEC  EQU     $FFF4
SWIVEC  EQU     $FFF6
IOPVEC  EQU     $FFF8
COPVEC  EQU     $FFFA
CLMVEC  EQU     $FFFC
RESVEC  EQU     $FFFE
#endif

;	68HC11A8 Special Control/Status Registers

PORTA	EQU	$1000		; Port A
PIOC	EQU	$1002
PORTC	EQU	$1003		; Port C
PORTB	EQU	$1004		; Port B
PORTCL	EQU	$1005
DDRC	EQU	$1007
PORTD	EQU	$1008		; Port D
DDRD	EQU	$1009
PORTE	EQU	$100A		; Port E
CFORC	EQU	$100B
OC1M	EQU	$100C
OC1D	EQU	$100D
TCNT	EQU	$100E
TIC1	EQU	$1010
TIC2	EQU	$1012
TIC3	EQU	$1014
TOC1	EQU	$1016
TOC2	EQU	$1018
TOC3	EQU	$101A
TOC4	EQU	$101C
TOC5	EQU	$101E
TCTL1	EQU	$1020
TCTL2	EQU	$1021
TMSK1	EQU	$1022
TFLG1	EQU	$1023
TMSK2	EQU	$1024
TFLG2	EQU	$1025
PACTL	EQU	$1026
PACNT	EQU	$1027
SPCR	EQU	$1028
SPSR	EQU	$1029
SPDR	EQU	$102A
BAUD	EQU	$102B
SCCR1	EQU	$102C
SCCR2	EQU	$102D
SCSR	EQU	$102E
SCDR	EQU	$102F
ADCTL	EQU	$1030
ADR1	EQU	$1031
ADR2	EQU	$1032
ADR3	EQU	$1033
ADR4	EQU	$1034
OPTION	EQU	$1039
COPRST	EQU	$103A
PROG	EQU	$103B
HPRIO	EQU	$103C
INIT	EQU	$103D
TEST1	EQU	$103E
CONFIG	EQU	$103F

INTRAM	EQU	$0000		; Internal RAM beginning
INTSTK	EQU	$0080		; Internal Stack (works with Buf vecs)
INTRTP	EQU	$00FF		; Internal RAM end
EEPROM	EQU	$B600		; EEPROM beginning
EXTRAM	EQU	$2000		; External Ram on proto board
EXTRTP	EQU	$3FFF		; Top of External Ram on proto board
EXTROM	EQU	$E000		; External ROM address
BUFALO	EQU	$E000		; Buffalo Monitor Entry Point

JMPOP	EQU	$7E		; 6811 jump opcode for interrupt vectors

CSET	EQU	$C0		; DDR C setup
DSET	EQU	$FE		; DDR D setup
PACSET	EQU	$80		; PACTL initial state
PIOSET	EQU	$86		; PIOC initial state
SPISET	EQU	$50		; SPI initial state
SCISE1	EQU	$00		; SCI setup 1
SCITOF	EQU	$2C		; SCI setup 2, !TIE RIE TE RE
SCITON	EQU	$AC		; SCI setup 2, TIE RIE TE RE
ITM1	EQU	$00		; TMSK1 set for all timers off
ITM2    EQU     $03             ; set timer prescale to /1
ITC1	EQU	$00		; Timer outputs off, PORTA on
T5ON	EQU	$08		; TMSK1 set for timer 5 on

T5CON	EQU	40000		; T5 initial time constant (5 seconds)
T5SVAL	EQU	249		; T5 slow time constant (N-1)

RDRF	EQU	$20		; Receiver Data Register Full bit
TC	EQU	$40		; SCI Transmit Complete bit
TDRE	EQU	$80		; Transmit Data Register Empty bit
SPIF	EQU	$80		; SPI Transmit Complete bit
COP1	EQU	$55		; cop reset sequence #1
COP2	EQU	$AA		; cop reset sequence #2
OPTINI	EQU	$12		; option init, ad off, sysclk, 1/4 sec cop
LO4ADC	EQU	$10		; ADCTL start word for low 4 chans
HI4ADC	EQU	$14		; ADCTL start word for high 4 chans
CCF	EQU	$80		; A/D Conversion Complete Flag

B9600	EQU	$30		; 9600 Baud
B4800	EQU	$31		; 4800 Baud
B2400	EQU	$32		; 2400 Baud
B1200	EQU	$33		; 1200 Baud
B600	EQU	$34		; 600 Baud
B300	EQU	$35		; 300 Baud

; Que data structure offsets
QLEN	EQU	0		; Universal Queue data structure def
QFRONT	EQU	1
QREAR	EQU	2
QEMPTY	EQU	3
QFULL	EQU	4
QDATA	EQU	5
QDSIZ	EQU	6		; size of this data structure

SIQLEN	EQU	128		; length of Serial in Queue
SOQLEN	EQU	128		; length of Serial out Queue

UEMASK	EQU	$01		; U event mask
UDMASK	EQU	$02		; U direction mask
VEMASK	EQU	$04		; U event mask
VDMASK	EQU	$08		; U direction mask

;-----------------------------------------------------------------------
; Variables

	ORG	INTRAM

T5CONS:	RMB	2		; Timer 5 time constant
T5SLOW:	RMB	1		; Slow timer reg.
UPSUM:	RMB	2		; U pulse sum
VPSUM:	RMB	2		; V pulse sum
CHKSUM:	RMB	1		; SIO Output Checksum
ULSUM:	RMB	1		; U LED sum reg
VLSUM:	RMB	1		; V LED sum reg

;-----------------------------------------------------------------------
; main ()
#ifdef BUFFALO
	ORG	EXTRAM
#else
	ORG	EXTROM
#endif

START:
	LDS	#INTSTK		; set up the stack (below int vecs)

#ifdef NOTDEF
	LDAA	#ITM2		; set up timer prescaler (before 64 Ecyc)
	STAA	TMSK2		; Note: buffalo screws this up.
#endif

	LDAA	#ITM1		; mask all timers
	STAA	TMSK1
	LDAA	#ITC1		; set up timer modes
	STAA	TCTL1

	LDAA	#PIOSET		; set up parallel port modes
	STAA	PIOC

	LDAA	#CSET		; set up ports c and d
	STAA	DDRC
	LDAA	#DSET
	STAA	DDRD

#ifdef BUFFALO
	LDAA	#JMPOP		; set up int vect jump ops
	STAA	VSWI
	STAA	VILLOP
	STAA	VCOP
	STAA	VCLM
	STAA	VTOC3
	STAA	VTOC4
	STAA	VTOC5
	STAA	VIRQ
	STAA	VSCI

	LDD	#START		; interrupts which restart the program
	STD	VSWI+1
	STD	VILLOP+1
	STD	VCOP+1
	STD	VCLM+1

	LDD	#NULINT		; null interrupt routine
	STD	VTOC3+1
	STD	VTOC4+1
	LDD	#TOINT5		; set timer 5 vect jump
	STD	VTOC5+1
	LDD	#IRQINT		; set IRQ (switch) vect jump
	STD	VIRQ+1
	LDD	#SCIINT		; set SCI (Serial i/o) vect jump
	STD	VSCI+1

	LDAA	#B9600		; set SCI baud rate
	STAA	BAUD

	LDAA	#OPTINI		; init the option reg (cop speed)
	STAA	OPTION

	LDAA	#PACSET		; set up the pactl
	STAA	PACTL

	LDAA	#SCISE1		; set up SCI port
	STAA	SCCR1
	LDAA	#SCITOF	
	STAA	SCCR2

	LDAA	#SPISET		; set up SPI port
	STAA	SPCR

	LDD	#T5CON		; timer 5 time constant
	STD	T5CONS

	LDAA	#T5SVAL		; init the slow midi timer
	STAA	T5SLOW

	CLR	PORTB
	CLR	PORTC		; clear wind interrupt ff
	LDAA	#$C0
	STA	PORTC

	LDX	#SIQUE		; init the serial in que
	LDAA	#SIQLEN
	JSR	INITQ

	LDX	#SOQUE		; init the serial out que
	LDAA	#SOQLEN
	JSR	INITQ

	LDD	#0
	STD	UPSUM		; zero the initial wind counts
	STD	VPSUM

	CLI			; enable interrupts

	JSR	TIMRGO		; turn on the timer

MAINLP:
	LDAA	COP1		; ping the cop timer
	STAA	COPRST
	LDAA	COP2
	STAA	COPRST

	BRA	MAINLP
;-----------------------------------------------------------------------
;	Start or stop the general timer
TIMRGO:
	LDX	#TMSK1		; Enable timer
	BSET	0,X T5ON

	RTS

TMRGOF:
	LDX	#TMSK1		; Disable timer
	BCLR	0,X T5ON

	RTS
;-----------------------------------------------------------------------
;	T5 interrupt routine	(general purpose timer)
TOINT5:
	LDD	TOC5		; calculate new timer compare value
	ADDD	T5CONS
	STD	TOC5

	LDAA	#T5ON		; clear timer flag bit
	STAA	TFLG1

	LDAA	T5SLOW		; count down the slow timer, act on 0
	BEQ	T5RECY

	DECA			; decrement and store new slow count
	STAA	T5SLOW		; store new slow value

	RTI

T5RECY:
	LDAA	#T5SVAL		; restart slow counter
	STAA	T5SLOW		; store new slow value

	CLR	CHKSUM		; zero the checksum

	LDAA	#'W'
	JSR	SCIENQ

	LDAA	#' '
	JSR	SCIENQ

	LDD	UPSUM		; output U in hex
	JSR	HEXWOT

	LDAA	#' '
	JSR	SCIENQ

	LDD	VPSUM		; output V in hex
	JSR	HEXWOT

	LDAA	#' '
	JSR	SCIENQ

	LDAA	CHKSUM		; output checksum
	NEGA			;2's complement
	ORAA	#$C0		;convert to psuedo ACSII
	JSR	SCIENQ

	LDAA	#$0d
	JSR	SCIENQ

	LDAA	#$0a
	JSR	SCIENQ

	LDD	#0
	STD	UPSUM		; clear the wind counts
	STD	VPSUM

	RTI
;-----------------------------------------------------------------------
;	IRQ pin interrupt routine (wind sensor input)
IRQINT:
	LDAA	PORTC		; get the wind pulse data, save
	TAB

	ANDA	#UEMASK		; look for U events
	BNE	UEVENT

	TBA
	ANDA	#VEMASK		; look for V events
	BNE	VEVENT
	BRA	IRQEX

UEVENT:
	TBA
	ANDA	#UDMASK		; check U direction
	BNE	UEVUP	

	LDD	UPSUM		; decrement U count
	SUBD	CONWRD
	DEC	ULSUM
	BRA	UEVST

UEVUP:
	LDD	UPSUM		; increment U count
	ADDD	CONWRD
	INC	ULSUM
UEVST:
	STD	UPSUM
	BRA	IRQEX

VEVENT:
	TBA
	ANDA	#VDMASK		; check V direction
	BNE	VEVUP	

	LDD	VPSUM		; decrement V count
	SUBD	CONWRD
	DEC	VLSUM
	BRA	VEVST

VEVUP:
	LDD	VPSUM		; increment V count
	ADDD	CONWRD
	INC	VLSUM
VEVST:
	STD	VPSUM
	BRA	IRQEX

IRQEX:
	LDAB	ULSUM		; Set U and V two LED rolling display.
	ANDB	#3
	LDX	#LEDLTB
	ABX
	LDAA	0,X
	LDAB	VLSUM
	ANDB	#3
	LDX	#LEDHTB
	ABX
	ORAA	0,X
	STAA	PORTB

	CLRA			; clear the wind flip flops
	STAA	PORTC
	LDAA	#$C0
	STAA	PORTC
	RTI
;-----------------------------------------------------------------------
;       OUTPUT A 4 hex digit word to the sio que
HEXWOT:
	PSHB			; save low byte
	JSR	HEXBOT		; output high byte
	PULA
	JSR	HEXBOT		; output low byte

	RTS
;-----------------------------------------------------------------------
;       OUTPUT A 2 hex digit byte to the sio que
HEXBOT:
        PSHA                    ; save low nib
        LSRA
        LSRA
        LSRA
        LSRA
        BSR     HEXNOT          ; output the high nibble
        PULA                    ; unsave
        BSR     HEXNOT          ; output the low nibble

        RTS
;-----------------------------------------------------------------------
;	Convert low nibble in A to ASCII hex value in A, output to sio q
HEXNOT:
	ANDA	#$0F		; mask for low nibble

	CMPA	#$09		; check for alpha or numeric
	BGT	OUTATF

	ADDA	#$30		; add numeric offset
	BRA	HNOTEX

OUTATF:
	ADDA	#$37		; add alpha offset
HNOTEX:
	JSR	SCIENQ
	RTS
;-----------------------------------------------------------------------
;	Output a string to the serial port.
;OUTSTR:
;	LDAA	0,X
;	CMPA	#$00
;	BEQ	OSTREX
;
;	JSR	SCIENQ		; loop until end of string
;
;	INX
;
;	BRA	OUTSTR
;
;OSTREX:
;	RTS
;-----------------------------------------------------------------------
;	Deque one byte (A) from the SCI input que, loop until done
SCIDEQ:
	LDX	#SIQUE		; Point to the sci in  que
GETSLP:
	SEI
	JSR	DEQUE
	CLI

	CMPB	#0
	BEQ	GETSLP		; loop until something shows up

	RTS
;----------------------------------------------------------------------
;	Enque one byte (A) onto the SCI output que
SCIENQ:
	PSHX
	LDX	#SOQUE		; point to sci output que

SCIELP
	SEI
	JSR	ENQUE		; keep trying until it fits
	CLI
	BEQ	SCIELP

	ADDA	CHKSUM		; update the checksum
	STAA	CHKSUM

	LDAA	#SCITON		; enable the tx interrupt
	STAA	SCCR2

	PULX
	RTS
;-----------------------------------------------------------------------
; SCI interrupt (serial I/O)
SCIINT:
	LDX	#SCSR
	BRCLR	0,X RDRF SCITXD	; check rx ready bit

	LDAA	SCDR		; get the data

	LDX	#SIQUE		; Stuff input que from the sio port.
	BSR	ENQUE		; if it doesn't fit, just drop it. (ovf flag?)
	RTI

SCITXD:
	BRCLR	0,X TDRE SCIEX	; check tx ready bit
	LDX	#SOQUE		; Deque output que into port

	BSR	DEQUE
	BEQ	SCIOEM		; output que is empty, turn off ints and exit.

	STAA	SCDR		; output the queued byte
SCIEX:
	RTI

SCIOEM:
	LDAA	#SCITOF		; que empty, disable the tx ints
	STAA	SCCR2
	RTI
;-----------------------------------------------------------------------
;	Init the Que pointed to by X and with length of A
INITQ:
	STAA	QLEN,X
	STAA	QEMPTY,X
	DECA
	STAA	QFRONT,X
	STAA	QREAR,X
	CLR	QFULL,X

	RTS
;-----------------------------------------------------------------------
;	Store the data in A in the Queue pointed to by X,
;	success in B and flags
ENQUE:
	PSHX
	PSHA			; save the data
	LDAA	QEMPTY,X	; Check for empty space in Q
	BEQ	ENQFULL
	LDAA	QLEN,X		; Get top index
	DECA
	CMPA	QREAR,X		; if QREAR is at top, Wrap
	BEQ	ENQWRP
	INC	QREAR,X		; else increment QREAR
	BRA	ENQPUT

ENQWRP:
	CLR	QREAR,X		; Wrap QREAR

ENQPUT:
	DEC	QEMPTY,X	; bump the empty and full counts
	INC	QFULL,X

	LDAB	QREAR,X		; Get QREAR
	ABX			; offset X with QREAR
	PULA			; get the data
	STAA	QDATA,X		; offset to actual que and stuff the data
	
	PULX
	LDAB	#1		; return B=1 for success
	RTS

ENQFULL:
	PULA			; align the stack
	PULX
	CLRB			; return B=0 for que full
	RTS
;-----------------------------------------------------------------------
;	Retrieve Queue data, Queue -> X into A
;	success in B and flags
DEQUE:
	LDAA	QFULL,X		; Check QFULL to see if Q has any data 
	BEQ	DEQEMP

	LDAA	QLEN,X		; Get top index
	DECA
	CMPA	QFRONT,X	; if QFRONT is at top, Wrap
	BEQ	DEQWRP
	INC	QFRONT,X	; else increment QFRONT
	BRA	DEQGET

DEQWRP:
	CLR	QFRONT,X	; wrap QFRONT

DEQGET:
	INC	QEMPTY,X	; bump the empty and full counts
	DEC	QFULL,X

	LDAB	QFRONT,X	; Get QFRONT
	ABX			; point X to ->QFRONT
	LDAA	QDATA,X		; get data from Q[FRONT]

	LDAB	#1		; return B=1 for success
	RTS

DEQEMP:
	CLRB			; return B=0 for no data
	RTS
;-----------------------------------------------------------------------
;	Retrieve Queue data, Queue -> X into A, success into B
;	Don't bump the pointers
;QSTAR:
;	LDAA	QFULL,X		; Check QFULL to see if Q has any data 
;	BEQ	QSTREM
;
;	LDAA	QLEN,X		; Get top index
;	DECA
;	CMPA	QFRONT,X	; if QFRONT is at top, Wrap
;	BEQ	QSTWRP
;	LDAB	QFRONT,X
;	INCB
;	BRA	QSTGET
;
;QSTWRP:
;	CLRB			; wrap ptr
;
;QSTGET:
;	ABX			; point X to ->QFRONT
;	LDAA	QDATA,X		; get data from Q[FRONT]
;
;	LDAB	#1		; return B=1 for success
;	RTS
;
;QSTREM:
;	CLRB			; return B=0 for no data
;	RTS
;-----------------------------------------------------------------------
;	Retrieve Queue status, Queue -> X into A
;QSTAT:
;	LDAA	QFULL,X		; Check QFULL to see if Q has any data 
;
;	RTS
;------------------------------------------------------------------------
NULINT:
	RTI
;-----------------------------------------------------------------------
; Constants
MSINIT:	FCC	'UV Wind RS-232 interface '
	FCC	'G. Forrest Cook October 24, 1994'
	FCB	$0d, $0a
	FCB	0
CONWRD:	FDB	1			; add subtract constant word
LEDLTB:	FCB	$01, $02, $04, $08	; low nibble LED output table
LEDHTB:	FCB	$10, $20, $40, $80	; high nibble LED output table
;-----------------------------------------------------------------------
; Queue storage

	ORG	EXTRTP-511

SIQUE:	RMB	SIQLEN+QDSIZ	; Serial input Queue
SOQUE:	RMB	SOQLEN+QDSIZ	; Serial output Queue
;-----------------------------------------------------------------------
; interrupt vector table (EPROM Version), done in code for the BUFFALO version

#ifndef BUFFALO
        ORG     SCIVEC

        FDB     SCIINT, NULINT, NULINT, NULINT, NULINT
        FDB     TOINT5, NULINT, NULINT, NULINT, NULINT
        FDB     NULINT, NULINT, NULINT, NULINT, IRQINT
        FDB     NULINT, START, START, START, START, START
#endif
;-----------------------------------------------------------------------

	END
