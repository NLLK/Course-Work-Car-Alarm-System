
;=========================================���������� ��������=========================================
;pb5 - rw, pb6 - rs,  pb7 - e
CMD_WR:		; ������ ������� � �������. ��� ������� � R17
			CLI
			RCALL	BusyWait

			CBI		PORTB,6; ������ RS
			RJMP	WR_END

DATA_WR:	; ������ ������ � �������. ��� ������ � R17
			CLI
			RCALL	BusyWait
			
			SBI		PORTB,6; ��������� RS;SBI		PORTB,6; ��������� RS
WR_END:		
			CBI		PORTB,5; ������ rw
			SBI		PORTB,7; ��������� e
			
			LDI		R16,0xFF
			OUT		DDRE,R16; ��������� ����� �� �����
			OUT		PORTE,R17; ����� �������

			RCALL	LCD_Delay

			CBI		PORTB,7

			LDI		R16,0		; LCD Data Port
			OUT		DDRE,R16	; ��������� �� ����

			LDI		R16,0xFF	; ���������� ��������
			OUT		PORTE,R16

			SEI
			RET
BusyWait:	
			CBI		PORTB,6; ������ RS
			SBI		PORTB,5; ��������� RW

BusyLoop:	SBI		PORTB,7; ��������� E
			
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

symToHex:;sym in acc (r16)
			mov XH, ZH
			mov XL, ZL
			cpi acc, '�'
			breq brYoFix
			cpi 	acc, 192
			brlo 	brOther; ���� ������ ���� ����� A, �� ��� ���������� ������� ����� ���� ��� ������ �� �������				
			
			subi 	acc, '�'
			;subi acc, -1

			ldi acc2, LOW(displayRecodingTable<<1)
			mov ZL, acc2
			ldi acc2, HIGH(displayRecodingTable<<1)
			mov ZH, acc2		
			add 	r30, acc
			brcs 	symToHexOverflow
			rjmp brContinue

brContinue:
			lpm
			mov 	acc, r0

			mov ZH, XH
			mov ZL, XL
brOther:	ret

symToHexOverflow:
			inc 	r31
			rjmp 	brContinue
brYoFix:
			ldi acc, 0xA2
			ret

shiftCursorRight:;���-�� ��� � r16
			push r16
			LDI		R17,(1<<4)|(1<<2); �������� ������ ������
			RCALL	CMD_WR
			pop r16

			dec acc
			cpi acc, 0
			brne shiftCursorRight

			ret

shiftCursorLeft:;���-�� ��� � r16
			push r16
			LDI		R17,(1<<4); �������� ������ �����
			RCALL	CMD_WR
			pop r16

			dec acc
			cpi acc, 0
			brne shiftCursorLeft

			ret

shiftCursorLeftRet:			
			ret
shiftCursorSecondRow:
			LDI		R17,(1<<7)|(0+0x40*1)
			RCALL	CMD_WR
			ret

LCD_blinkOn:
			LDI		R17,0b00000010; 
			RCALL	CMD_WR

			LDI		R17,0b00001111; 
			RCALL	CMD_WR
			ret
LCD_blinkOff:
			LDI		R17,0b00001100; ��������� ������� � ��������� �������
			RCALL	CMD_WR
			ret
;=========================================/���������� ��������=========================================
