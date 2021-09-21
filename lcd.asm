
CMD_WR:		; ������ ������� � �������. ��� ������� � R17
			CLI
			RCALL	BusyWait

			CBI		PORTB,6; ������ E
			RJMP	WR_END

DATA_WR:	; ������ ������ � �������. ��� ������ � R17
			CLI
			RCALL	BusyWait
			
			SBI		PORTB,6; ��������� RW;SBI		PORTB,6; ��������� RW
WR_END:		
			CBI		PORTB,5; ������ �
			SBI		PORTB,7; ��������� ����� ������ � DDRAM 
			
			LDI		R16,0xFF
			OUT		DDRE,R16; ��������� ����� �� �����
			OUT		PORTE,R17; ��������

			RCALL	LCD_Delay

			CBI		PORTB,7

			LDI		R16,0		; LCD Data Port
			OUT		DDRE,R16	; ��������� �� ����

			LDI		R16,0xFF	; ���������� ��������
			OUT		PORTE,R16

			SEI
			RET
BusyWait:	
			CBI		PORTB,6
			SBI		PORTB,5

BusyLoop:	SBI		PORTB,7
			
			RCALL	LCD_Delay

			IN		R16,PINE   ; ������ � R16 �� ����� B

            CBI		PORTB,7    ; ������� E
                      	
            ANDI	R16,0x80   ; �������� ����� BF �� 0
			BRNE	BusyLoop
			RET
		
LCD_Delay:	LDI		R16,6
L_loop:		DEC		R16
			BRNE	L_loop
			RET

DATA_WR_from_Z:	;� Z ����� ������� � �������
DATA_WR_from_Z_loop:
			lpm
			mov 	acc, r0
			cpi 	acc, 'e'
			breq 	DATA_WR_from_Z_exit
	
			cpi 	acc, 0x0f
			brlo 	DATA_WR_from_Z_coords
	
			RCALL 	symToHex
			mov		r17, acc

			RCALL	DATA_WR
			adiw 	ZL, 1

			jmp 	DATA_WR_from_Z_loop

DATA_WR_from_Z_coords:	
			adiw 	ZL, 1
			lpm

			mov 	R17, r0
			ORI		R17,(1<<7)
	
			cpi 	acc, 1
			breq 	DATA_WR_from_Z_row1

DATA_WR_from_Z_coodsDone: 
			RCALL 	CMD_WR
			adiw 	ZL, 1
			jmp 	DATA_WR_from_Z_loop

DATA_WR_from_Z_exit:
			ret

DATA_WR_from_Z_row1:
			ORI 	R17, 0x40
			jmp 	DATA_WR_from_Z_coodsDone


	
