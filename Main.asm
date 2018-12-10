; Main.asm
; Name: RYAN KROGFOSS and Jonas Traweek
; UTEid: RK25457 and JTT2279
; Continuously reads from x4600 making sure its not reading duplicate
; symbols. Processes the symbol based on the program description
; of mRNA processing.
               .ORIG x4000
; initialize the stack pointer
		LEA R6, -1	

; set up the keyboard interrupt vector table entry
		LD R0, IVT
		LD R3, InterruptAddress
		STR R3, R0, 0
		AND R3, R3, #0		

; enable keyboard interrupts
		LD R2, KBSR	
		LD R1, SetInterrupt
		STR R1, R2, 0		

; start of actual program
LOOP		LDI R4, Offset4600A
		BRZ LOOP

		LDI R5, DSR
		STI R4, DDR
	
		AND R5, R5, #0
		STI R5, Offset4600A

; start of FSM
FSM		ADD R3, R3, #-3
		BRZP FSM2
		ADD R3, R3, #3
		LD R5, ASCIIA
		LD R6, Num32
	
		ADD R3, R3, #-1
		BRZ CheckU
		BRP CheckG
	
		ADD R3, R3, #1
		ADD R5, R4, R5
		BRZ Add1
		ADD R5, R5, R6
		BRZ Add1
		AND R3, R3, #0
		BR LOOP

CheckU		ADD R3, R3, #1
		ADD R5, R5, #-10
		ADD R5, R5, #-10
		ADD R5, R4, R5
		BRZ Add1
		ADD R5, R5, R6
		BRZ Add1
		AND R3, R3, #0
		BR FSM

CheckG		ADD R3, R3, #1
		ADD R5, R5, #-6
		ADD R5, R4, R5
		BRZ Start
		ADD R5, R5, R6
		BRZ Start
		AND R3, R3, #0
		BR FSM	

Add1		ADD R3, R3, #1
		BR LOOP

Start		LD R0, ASCIIBar
		TRAP X21
		ADD R3, R3, #1
		BR LOOP

FSM2		ADD R3, R3, #3 ; start of FSM2 finding the end codon
		LD R5, ASCIIU
		LD R6, Num32

		ADD R3, R3, #-4
		BRZ CheckAG
		BRP CheckEnd	
		ADD R3, R3, #4			
		ADD R5, R4, R5
		BRZ CheckNext
		ADD R5, R5, R6
		BRZ CheckNext
		BR LOOP

CheckNext	ADD R3, R3, #1
		BR LOOP
		
CheckAG		ADD R3, R3, #4
		LD R5, ASCIIA
		ADD R5, R4, R5
		BRZ Check2ndA
		ADD R5, R5, R6
		BRZ Check2ndA
		ADD R5, R5, #-6
		BRZ Check2ndG
		NOT R6, R6
		ADD R6, R6, #1
		ADD R5, R5, R6
		BRZ Check2ndG
		AND R3, R3, #0
		ADD R3, R3, #3
		BR FSM

Check2ndA	ADD R3, R3, #10
		BR LOOP


Check2ndG	ADD R3, R3, #1
		BR LOOP

CheckEnd	LD R5, ASCIIA
		ADD R5, R4, R5
		BRZ End
		ADD R5, R5, R6
		BRZ End
		ADD R5, R5, #-6
		BRZ CheckLastG
		NOT R6, R6
		ADD R6, R6, #1
		ADD R5, R5, R6
		BRZ CheckLastG
		AND R3, R3, #0
		ADD R3, R3, #3
		BR FSM
		
CheckLastG	ADD R3, R3, #-5
		BRP End
		AND R3, R3, #0
		ADD R3, R3, #3
		BR LOOP

End		TRAP X25

KBSR	.FILL	XFE00
DSR	.FILL	XFE04
DDR	.FILL	XFE06
SetInterrupt	.FILL	X4000
InterruptAddress .FILL	X2600
IVT	.FILL	X0180
Offset4600A	.FILL	X4600
ASCIIA	.FILL	-65
ASCIIU	.FILL	-85
ASCIIBar	.FILL	124
Num32	.FILL	-32
		.END
