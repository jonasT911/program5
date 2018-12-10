; ISR.asm
; Name: RYAN KROGFOSS
; UTEid: RK25457
; Keyboard ISR runs when a key is struck
; Checks for a valid RNA symbol and places it at x4600
               .ORIG x2600
		ST R0, blkwR0
		ST R1, blkwR1
		ST R2, blkwR2
		ST R3, blkwR3			; STORE REGS

		LDI R0, KeyStatusOffset		; LOAD STATUS
		BRZP -1
		LDI R1, KeypressOffset		; LOAD VALUE AT XFE00
		
		LD R2, ASCIIA			; LOAD ASCII 'A' INTO R2
		
		ADD R3, R1, R2
		BRZ InputChar
		ADD R3, R3, #-2
		BRZ InputChar
		ADD R3, R3, #-4
		BRZ InputChar
		ADD R3, R3, #-14		
		BRZ InputChar			; FIND IF INPUT IS A,C,U,G

		ADD R3, R3, #-12
		BRZ InputChar
		ADD R3, R3, #-2
		BRZ InputChar
		ADD R3, R3, #-4
		BRZ InputChar
		ADD R3, R3, #-14		
		BRZ InputChar			; ACCOUNT FOR LOWER CASE A,C,U,G

		BRNZP EndISR

InputChar	LD R3, Offset4600		; LOAD ADDRESS INTO R3
		STR R1, R3, 0			; STORE Character AT X4600
		
		LD R0, blkwR0
		LD R1, blkwR1
		LD R2, blkwR2
		LD R3, blkwR3
		
EndISR		RTI 		

blkwR0	.blkw	1
blkwR1	.blkw	1
blkwR2	.blkw	1
blkwR3	.blkw	1
KeyStatusOffset .FILL XFE00
KeypressOffset .FILL XFE02
ASCIIA	.FILL	-65
Offset4600 .FILL X4600


		.END
