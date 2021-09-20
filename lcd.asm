;=========== LCD Define ==================================================================
			.equ	DATA_PORT	= PORTE	; LCD Data Port
			.equ	DATA_PIN	= PINE
			.equ	DATA_DDR	= DDRE

			.equ	CMD_PORT	= PORTB	; LCD Control Port
			.equ	CMD_PIN		= PINB
			.equ	CMD_DDR		= DDRB

			.equ	E		= 7
			.equ	RW		= 5
			.equ	RS		= 6

			.equ	SPEED	= 6	; 14 ��� XTAL=16MHz, 10 ��� XTAL=8MHz,  
									; 6 ��� XTAL=4MHz, 5 ��� XTAL<4MHz
;=========================================================================================
;=========== LCD Proc ====================================================================
InitHW:		CBI		CMD_PORT,RS
			CBI		CMD_PORT,RW
			CBI		CMD_PORT,E

			SBI		CMD_DDR,RS
			SBI		CMD_DDR,RW
			SBI		CMD_DDR,E
			
			RCALL PortIn
			RET

;=========================================================================================
BusyWait:	
			CBI		CMD_PORT,RS
			SBI		CMD_PORT,RW
BusyLoop:	SBI		CMD_PORT,E
			
			RCALL	LCD_Delay

			IN		R16,DATA_PIN   ; ������ � R16 �� ����� B

            CBI		CMD_PORT,E     ; ��� ������ ������ ������� E
                      	
            ANDI	R16,0x80               ; �������� ����� BF �� 0
			BRNE	BusyLoop
			RET
;=========================================================================================	
LCD_Delay:	LDI		R16,SPEED
L_loop:		DEC		R16
			BRNE	L_loop
			RET

;=========================================================================================
; ������ ������� � �������. ��� ������� � R17
CMD_WR:		
			CLI
			RCALL	BusyWait

			CBI		CMD_PORT,RS
			RJMP	WR_END

;-----------------------------------------------------------------------------------------
; ������ ������ � �������. ��� ������ � R17
DATA_WR:	
			CLI
			RCALL	BusyWait
			
			SBI		CMD_PORT,RS
WR_END:		
			CBI		CMD_PORT,RW			
			SBI		CMD_PORT,E	
			
			RCALL PortOut
			OUT		DATA_PORT,R17

			RCALL	LCD_Delay

			CBI		CMD_PORT,E
			RCALL PortIn

			SEI
			RET

;=========================================================================================
; ������ ������� �� �������. ��������� � R17
CMD_RD:		CLI
			RCALL	BusyWait

			CBI		CMD_PORT,RS
			
			RJMP	RD_END

;-----------------------------------------------------------------------------------------
; ������ ������� �� �������. ��������� � R17
DATA_RD:	CLI
			RCALL	BusyWait
		;	LCD_PORT_IN					;

			SBI		CMD_PORT,RS
RD_END:		SBI		CMD_PORT,RW

			SBI		CMD_PORT,E
			RCALL	LCD_Delay
			IN		R17,DATA_PIN
			CBI		CMD_PORT,E
			
			SEI
			RET

;=========================================================================================
PortIn:		LDI		R16,0			; LCD Data Port
			OUT		DATA_DDR,R16	; ��������� �� ����

			LDI		R16,0xFF		; ���������� ��������
			OUT		DATA_PORT,R16
			RET		

PortOut:
			LDI		R16,0xFF
			OUT		DATA_DDR,R16
			RET


; Fill Screen ============================================================================
