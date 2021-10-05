
;=========================================��������� ������=========================================
keyBindings:
	;��� �����-�� ������ ��� ������	
	cbr programFlags, 16; �� ���������, ������� � ������ ����� �� �����������
	sbrc programFlags, 3
	jmp keyBindingsEnteringInModes
	mov acc, r0
	cpi acc, 10
	brge keyBindingsLetters
	call keyBindingsNumbers

keyBindingsRet:	ret

keyBindingsNumbers:
	mov acc, menuModes
	andi acc, 0xF0
	cpi acc, 0; ���� ����� ����� (�����) == 0, �� ������ ���
	breq keyBindingsEnterMode
	
	mov acc, menuModes
	andi acc, 0x0F
	cpi acc, 0;���� ������ ����� (�������) == 0, �� ������ ���
	breq keyBindingsEnterSubMode
	; ����� - ��� ���� ������ �������
	ret

keyBindingsEnterMode: 			;���� ������ ����
	mov acc, r0
	cpi acc, 0x06; ���������� �������, �� +1
	brge keyBindingsRet; ��� ������ ������, ������
	mov acc, r0
	andi menuModes, 0x0F
	lsl acc
	lsl acc
	lsl acc
	lsl acc
	add menuModes, acc	;�������� �����
	ret
keyBindingsEnterSubMode:		;���� ������ �������
	mov acc, r0
	andi menuModes, 0xF0
	add menuModes, acc			;����� ����� �������
	ret
	
keyBindingsLetters: ;������ �����
	mov acc, r0
	subi acc, 10; --10
	ldi ZH, high(keyBindingsLetterCallingTable)
	ldi ZL, low(keyBindingsLetterCallingTable)
	ldi acc2, 3
	mul acc, acc2
	add r30, r0
	;�������� �� �������� �������
	brcs keyBindingsLettersOverflow

keyBindingsLettersContinue:
	ijmp

keyBindingsLettersOverflow:
	inc r31
	jmp keyBindingsLettersContinue

keyBindingsLetterCallingTable:	
keyBindingsLetterACalling: call keyBindingsLetterA
	ret
keyBindingsLetterBCalling: call keyBindingsLetterB
	ret
keyBindingsLetterCCalling: call keyBindingsLetterC
	ret
keyBindingsLetterDCalling: call keyBindingsLetterD
	ret
keyBindingsLetterECalling: call keyBindingsLetterE
	ret
keyBindingsLetterFCalling: call keyBindingsLetterF
	ret

keyBindingsLetterA:
	;���� ������� ���� - ������ �� ������
	mov acc, menuModes
	andi acc, 0xF0
	cpi acc, 0
	breq keyBindingsLetterAEnterFirst;//TODO: �������� � ���������
	;���� ������ �����, �� ������� ������ ��������
	mov acc, menuModes
	andi acc, 0x0F
	cpi acc, 0
	breq keyBindingLetterASubMode
	;���� ������ ��������, �� ���� � �������
	sbr programFlags, 8;	��������� ����� �������� � ��������
	sbr programFlags, 4; ��������� ����� "�������� �������"
	ret
keyBindingsRet2: ret
keyBindingsLetterAEnterFirst:
	ldi menuModes, 0x10//TODO: �������� � ���������
	ret//TODO: �������� � ���������
keyBindingLetterASubMode:	;��� ����� � ����� ����������, ������� ����� ������ �� ���
	mov acc, menuModes
	andi acc, 0xF0
	inc acc
	mov menuModes, acc
	ret

keyBindingsLetterB:
	mov acc, menuModes
	cpi acc, 0				;���� ������� ���� - �� ������ �� ������
	breq keyBindingsRet2

	mov acc, menuModes
	andi acc, 0x0f			
	cpi acc, 0				;���� �������� �� ������, �� ����� � ������� ����
	breq keyBindingsBackFromMode
	;������ ��� �������
		
	andi menuModes, 0xf0	;����� ������� �� ������ ���������� ������� � ������ ������� ����	
	ret

keyBindingsBackFromMode:
	ldi menuModes, 0x00		;����� � ������� ����
	ret

keyBindingsLetterC:
	mov acc, menuModes
	andi acc, 0x0f
	cpi acc, 0
	breq keyBindingsLetterCDecMode
	jmp keyBindingsLetterCDecSubMode

keyBindingsLetterCDecMode:
	mov acc, menuModes
	andi acc, 0xf0
	cpi acc, 0
	breq keyBindingsLetterCDecModeLast;//TODO: �������� � ���������
	subi menuModes, 0x10
	ret

keyBindingsLetterCDecSubMode:
	dec menuModes
	ret
keyBindingsLetterCDecModeLast://TODO: �������� � ���������
	ldi menuModes, 0x20//TODO: �������� � ���������
	ret//TODO: �������� � ���������

keyBindingsLetterD:
	mov acc, menuModes
	andi acc, 0x0f
	cpi acc, 0
	breq keyBindingsLetterDIncMode
	jmp keyBindingsLetterDIncSubMode

keyBindingsLetterDIncMode:
	mov acc, menuModes
	andi acc, 0xf0
	cpi acc, 0x20
	brge keyBindingsBackFromMode

	mov acc, menuModes
	ldi acc2, 0x10
	add acc, acc2
	mov menuModes, acc
	ret

keyBindingsLetterDIncSubMode:
	inc menuModes
	ret

keyBindingsLetterE:	ret
keyBindingsLetterF:	ret
keyBindingsEnteringInModes:
	sbr programFlags, 16
	STS pressedKey, r0
	ret

;=========================================/��������� ������=========================================
