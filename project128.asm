.device ATmega128             
.INCLUDE "m128def.inc"
;.include "m103def.inc"

.def scan=R18;   
.def cpg=R19;  
.def keyRow=R20;
.def menuModes=R21;������� ����� �������� �� ������ ����, ������� - �� ���������
.def acc=R16;�����������
.def programFlags=R22; 0|0|0|0|0|updateDisplay|DebouncingEnd|keyPress
.def RTTFlags=R23; real-time timer programFlags  0|0|0|0|0|0|keyScan|msAdd|0
.def prK=R5; pressed key
.def keyboardPointer=R24

.dseg
RTT_mS: .BYTE 1; �����������
RTT_qS: .BYTE 1; quarterS, �������� �������
RTT_1S: .BYTE 1;�������
RTT_10S: .BYTE 1;������� ������
RTT_1M: .BYTE 1;������
RTT_10M: .BYTE 1;������� �����
RTT_1H: .BYTE 1;����
RTT_10H: .BYTE 1;������� �����
RTT_24H: .BYTE 1;������� ����� � �����

KeyScanTimer: .BYTE 1; ������ ��� �������� ���������� 

KeyTablePointer: .BYTE 1; ��������� �� ������� � �����������
SevSegPointer: .BYTE 1; ��������� �� ������� �� ���������� ��������������� ���������� //TODO: �������

.cseg

.org 0x00
	jmp start
.org 0x02
	jmp keyboardPressInt; ��������� ���������� ����.
.org 0x14
	jmp keyboardDebouncingInt;  ������� �� ��������� ���������� ������� ��������  
.org 0x18
	jmp RTT_1msInt; 
.org 0x20
	;jmp rop;��������� �� ���������� ������� ������� ���������
.org 0x30
	jmp start

KeyTable:
.DB 0x0C,0x03,0x02,0x01 ; 1, 2, 3, C
.DB 0x0D,0x06,0x05,0x04 ; 4, 5, 6, D
.DB 0x0E,0x09,0x08,0x07 ; 7, 8, 9, E
.DB 0x0F,0x0A,0x00,0x0B ; B, 0, A, F

; dp|g|f|e| d|c|b|a|
SevenSegmentValues:
.DB 0xC0,0xF9,0xA4,0xB0 ; 0, 1, 2, 3  |-a-|
.DB 0x99,0x92,0x82,0xF8 ; 4, 5, 6, 7  f   b
.DB 0x80,0x90,0x88,0x83 ; 8, 9, A. B  |-g-|
.DB 0xC6,0xA1,0x86,0x8E ; C, D, E, F  e   c
						;             |-d-| dp
.include "LCD_macro.inc"
.include "LCD.asm"
.include "symToHexConverter.asm"
start:
	ldi acc,low(ramend)
	out spl,acc
	ldi acc,high(ramend)
	out sph,acc;������������ ���������
	ldi scan, 0b00010001
	ldi cpg, 0x00
	ldi keyRow, 0x04; �� ���-�� ����� - 4
	ldi programFlags, 0x04
	ldi RTTFlags, 0x00
	ldi commands, 0x00
	ldi acc,0xF0
	out ddrc, acc; ������� ������� ����� C �� ����,������� - �� �����
	ldi acc, 0xFF
	out ddra, acc; port a assigned to output
	ldi acc,0xFF
	out ddre, acc
	;ldi acc,0x01
	;out eimsk,acc;���������� ���������� ���������� �� int0
	ldi acc,0xF8
	out ddrd,acc;���� �� ���� int0, int1, int2
	ldi acc, 0x50; ��� timer2 �� ������������ + OCF1A
	out timsk,acc;���������� ��������� ���������� ��� ��������

	ldi acc, 0x0F
	out OCR1AH, acc
	ldi acc, 0xA0
	out OCR1AL, acc; � ������� ��������� ��������� 4000 ����� �������� 1ms
	ldi acc, 0x01
	out TCCR1B, acc;
	
	ldi acc, 0x0; ������������� ����������
	STS RTT_mS, acc
	STS RTT_qS, acc
	STS RTT_1S, acc
	STS RTT_10S, acc
	STS RTT_1M, acc
	STS RTT_10M, acc
	STS RTT_1H, acc
	STS RTT_10H, acc
	STS RTT_24H, acc

	STS KeyScanTimer, acc

	ldi acc, LOW(KeyTable<<1)
	STS KeyTablePointer, acc	
	
	ldi acc, LOW(SevenSegmentValues<<1)
	STS SevSegPointer, acc		

	ldi acc, 0x01
	out pind, acc;  ���� 1 � ������� ����, �� �� ������	  	

	LDI r16, 0xff
	OUT DDRE, r16
	
	LDI r16, 0xff
	OUT DDRB, r16	
	;������������� �������
	LDI		R17,0x38;(1<<LCD_F)|(1<<LCD_F_8B)|(1<<LCD_F_2L)	;��������� ������, 8-�������� �����, 2 ������
	RCALL	CMD_WR
	LDI		R17,0x01;(1<<LCD_CLR); ������� �������
	RCALL	CMD_WR
	LDI		R17,0x06;(1<<LCD_ENTRY_MODE)|(1<<LCD_ENTRY_INC); ����� �����, ����� ����� �����������
	RCALL	CMD_WR
	LDI		R17,0x0C;(1<<LCD_ON)|(1<<LCD_ON_DISPLAY)|(0<<LCD_ON_CURSOR)|(0<<LCD_ON_BLINK); �������� �������: ���, ������, �������� �������
	RCALL	CMD_WR
	LDI		R17,0x02;(1<<LCD_HOME)	
	RCALL	CMD_WR

	sei; ���������� ����������   

;��� ���������� �����
backdoor:
	ldi r16, 0x00
	cpi r16, 0x00
	;brne backgroundLoop

bkdr:
	jmp backgroundLoop

;-----������� ���� ��������� ������-----;
backgroundLoop:
	jmp carScanning;������������ �������� ������ � ��

backLoopAfterCarScan:
	sbrc programFlags, 0; ���� 1, ����� ��������� ������, ����� ����������
	jmp backLoopAfterKeyScan;���� ������ ��������

	sbrc programFlags, 1; ���� 1, �� ���������.; ���� ����� ��������, �� ���������� ������
	jmp keyboardColumnDetection

	sbrc RTTFlags, 1; ���� 1, �� ������� 
	call keyboardScanning; �������� ������ �� �������

backLoopAfterKeyScan:
	sbrc programFlags, 1
	jmp keyboardColumnDetection; ����������� ������

backLoopFlag2:
	;jmp displaySigments;����������� �������� �� �����������

backLoopAfterDispSigms:
	;cpi commands, 0; ���� 0, �� �� ���� ������� �� �������
	;brne operationScanning; ��������� ������

backLoopAfterOpScan:
	sbrc RTTFlags, 0; ���� 0, �� ����� �� �����������, ����������
	jmp RTT_main

backLoopAfterRTTFlagsScan:
	sbrc programFlags, 2
	call updateDisplay
	jmp backgroundLoop

;-----����� ��������� ������-----;

;������� ����� ��������� ������
;operationScanning:
	;cpi commands, 1
	;breq displayNumber;
	;jmp backLoopAfterOpScan

updateDisplay:
	cbr programFlags,4; ������� ����� "�������� �������"

	LDI R17,(1<<0)
	RCALL CMD_WR	

	;LDI	R17,(1<<LCD_DDRAM)|(0+0x40*1); x, y
	;RCALL CMD_WR
	
	ldi acc, LOW(_labelTest<<1)
	mov ZL, acc
	ldi acc, HIGH(_labelTest<<1)
	mov ZH, acc

loop:
	lpm
	mov acc, r0
	cpi acc, 0
	breq exitLoop

	RCALL symToHex
	mov r17, acc

	RCALL	DATA_WR
	adiw ZL, 1

	jmp loop
	
exitLoop:
	ret

;-----����������-----;

;������� ����� �������� ����� ����������
keyboardScanning:
	;�������������� �������������
	cbr RTTFlags,2
	cpi keyRow, 0; ���� 0, �� �����   
	breq keyScanRestoreNumberRow;  
keyScanAfterRestore:
	dec keyRow; keyRow--

	mov acc, scan
	andi acc, 0b11110000
	out portC, acc
	nop
	
	in acc, pinC
	andi acc, 0x0F
	cpi acc, 0x00
	breq keyAfterInt
	jmp keyboardPressInt

keyAfterInt:
	ldi acc, 0xFF
	out portE, acc
	lsl scan ;����� ���������� �����
	brcc keyScanSkipInc; ���� �������� ������� = 0, �� ����������
	inc scan; scan++
keyScanSkipInc:
	;���� ����
	ret
;������������ ���-�� �����
keyScanRestoreNumberRow:
	ldi keyRow, 0x04
	jmp keyScanAfterRestore;
	
;���������� �� ������� �� �������
keyboardPressInt:
	sbr programFlags,1
	in cpg, pinC;���������� ������ � �������

	;������������� ������� ��������
	ldi acc, 0xB1
	out tcnt2, acc;  ����� ������� = ff - tcnt0
	ldi acc, 0x05; 20 �c ��� 0�B1 � 0�05, 256uS - 1 ���
	out tccr2, acc; �������� ������� ��� �������
	
	jmp keyAfterInt

;���������� �� ������� ��������
keyboardDebouncingInt:; ��������� ��������

	ldi acc, 0x0
	out tccr2, acc; ��������� �������
	cbr programFlags, 1; ��������� ����� ������� �������

	sbr programFlags,2
	reti

;������� ����� ����������� �������
keyboardColumnDetection:
	
	lds acc, KeyTablePointer
	clr ZH
	mov ZL, acc
	
	mov acc, keyRow

	cpi acc, 4
	brne keyColDecLoop;
	dec acc;

keyColDecLoop:
	;����������� ������
	cpi acc, 0; ���� 0, �� �����   
	breq keyRowFound; 

	adiw ZL, 4; ���������� ������ �� 4 
	dec acc; keyRow--

	jmp keyColDecLoop

keyRowFound:
	;������ ������� 

	mov acc, cpg
keyRowFoundLoop:
	;����������� ������

	lsr acc
	brcs keyFound
	adiw ZL, 1;   ���������� ������

	rjmp keyRowFoundLoop

keyFound:
	;������ �������
	lpm
	mov prK, r0

	;��� �����-�� ������ ��� ������
	ldi commands, 1; ������� ������ �� ���������

	;ldi scan, 0b00010001
	cbr programFlags, 2

	ldi acc, 0
	STS KeyScanTimer, acc
	cbr RTTFlags, 2
	nop	

	jmp backgroundLoop
;-----����������-----;

RTT_1msInt:
	ldi acc, 0x00
	CLI; ������ ����������
	out TCNT1H, acc
	out TCNT1L, acc; ��������� �������
	SEI; ���������� ����������

	sbr RTTFlags,1;��������� ����� "���������� ��������"
	ldi acc, 0
	out OCF1A,acc;
	reti

RTT_main:
	;��� �����-�� ������ ��� ����������� �������� � �� ������
	;����������� ������ ������ ����������
	lds acc, KeyScanTimer
	SUBI acc, (-1)
	STS KeyScanTimer, acc
	cpi acc, 10
	brne RTT_ProgrammTimer

RTT_KeyDebouncingTimer:
	sbr RTTFlags, 2; ��������� ����� �� ������������� ������ ����������
	ldi acc, 0
	STS KeyScanTimer, acc
			
RTT_ProgrammTimer:
	cbr RTTFlags,1;������ ����� "���������� ��������"

	lds acc, RTT_mS
	SUBI acc, (-1)
	STS RTT_mS, acc
	;�������� �� �������� �������
	cpi acc, 250
	brne RTT_end
	ldi acc, 0
	STS RTT_mS, acc
	;��� ����� ��������� �����-������ ����

	lds acc, RTT_qS
	SUBI acc, (-1)
	STS RTT_qS, acc
	;�������� �� �������
	cpi acc, 4
	brne RTT_end
	
	sbr programFlags, 4; ��������� ����� "�������� �������" ��� � �������

	ldi acc, 0
	STS RTT_qS, acc

	lds acc, RTT_1S
	SUBI acc, (-1)
	STS RTT_1S, acc
	;�������� �� ���������� ������
	cpi acc, 10
	brne RTT_end
	ldi acc, 0
	STS RTT_1S, acc

	lds acc, RTT_10S
	SUBI acc, (-1)
	STS RTT_10S, acc
	;�������� �� ���������� �������� ������
	cpi acc, 6
	brne RTT_end
	ldi acc, 0
	STS RTT_10S, acc

	lds acc, RTT_1M
	SUBI acc, (-1)
	STS RTT_1M, acc
	;�������� �� ���������� �����
	cpi acc, 10
	brne RTT_end
	ldi acc, 0
	STS RTT_1M, acc
	rjmp RTT_continue;
RTT_end:
	jmp backLoopAfterRTTFlagsScan
RTT_continue:
	lds acc, RTT_10M
	SUBI acc, (-1)
	STS RTT_10M, acc
	;�������� �� ���������� �������� �����
	cpi acc, 6
	brne RTT_end2
	ldi acc, 0
	STS RTT_10M, acc

	lds acc, RTT_24H
	SUBI acc, (-1)
	STS RTT_24H, acc
	;�������� �����
	cpi acc, 24
	brne RTT_end2
	ldi acc, 0
	STS RTT_24H, acc

	lds acc, RTT_1H
	SUBI acc, (-1)
	STS RTT_1H, acc
	;�������� �����
	cpi acc, 10
	brne RTT_end2
	ldi acc, 0
	STS RTT_1H, acc

	lds acc, RTT_10H
	SUBI acc, (-1)
	STS RTT_10H, acc
	;�������� �� ���������� �������� �����
	cpi acc, 6
	brne RTT_end2
	ldi acc, 0
	STS RTT_10H, acc

RTT_end2:
	jmp backLoopAfterRTTFlagsScan

carScanning:
	jmp backLoopAfterCarScan
	in acc, pinA; CentralLock|GlassBreaking|Bumper|LeftFront|RightFront|LeftBack|RightBack|Trunk
	lsl acc ;����� ���������� �����
	brcc carScanCL1; ���� �������� ������� = 1
carScanCL1:
	lsl acc;
	brcc carScanGB0; ���� �������� ������� = 0
carScanGB0:
	
carScanAlarm:
	ldi acc, 0;pass

	;����� ��� ����� ����� ���������������� �����, �� ��� �� ����������� ������ �����
	;ldi acc, (1<<0)|(1<<1)|(1<<2)
	;out DDRB, acc
;	ldi acc, (1<<SPE)|(1<<MSTR);|(1<<SPR0) 
	;out SPCR, acc
	;ldi acc, 0xF9
	;out SPDR, acc

;bkdr1:
	;sbis SPSR, SPIF
	;rjmp bkdr1
	;ldi acc, 0x01
	;out PINB, acc
	
_labelHelloWorld:
.DB '�','�','�','�','�','�',',',' ','�','�','�', 0
_labelTest:
.DB '�', '�', '�', '�', '�', '�', '�', '�', ' ','1', ' ', 'L' , 'O', 'V', 'E', 0