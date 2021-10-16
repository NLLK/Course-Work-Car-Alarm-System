
;=========================================������������=========================================
autoHeatingMain:
	sbrs functionsFlags,0
	jmp autoHeatingTempChecking; ������������ �� �������, �� ���������, ���� �� ��� �������� �� �����������
	;������������ �������, ��������� � �� ���� �� ���������
	;�� �����������
	lds acc, AutoHeatingTempMax10
	ldi acc2, 10
	mul acc, acc2
	mov acc, r0
	lds acc2, AutoHeatingTempMax1
	add acc, acc2
	push acc
	mov acc2, temperature
	andi acc, 0x80
	cpi acc, 0x80	;���� �������������, �� ��������� �����
	breq AutoHeatingTimeChecking
	;���� �� �������������, �� ���� ����������� ������ ������������ - ���������
	pop acc
	cp acc2, acc
	brge autoHeatingTurnOff

	;����� - ��������� �����
AutoHeatingTimeChecking:
	;

	ret

autoHeatingTempChecking:
	lds acc, AutoHeatingTempMin10
	ldi acc2, 10
	mul acc, acc2
	mov acc, r0
	lds acc2, AutoHeatingTempMin1
	add acc, acc2;�������� �������� ����������� ����-��
	push acc
	mov acc, temperature; �������� �������� ������� ����-��
	cpi acc, 0x80
	brlo autoHeatingTempCheckingPositive; ������������� �������� ����-��
	mov acc2, acc
	andi acc2, 0b01111111
	pop acc
	cp acc2, acc
	brge autoHeatingTurnOn
autoHeatingTempCheckingRet:
	ret

autoHeatingTempCheckingPositive:
	pop acc
	ret

autoHeatingTurnOn:
	;//TODO:�������� ������� ����� � ����������



	sbi portD, 0
	sbr functionsFlags,1
	ret
autoHeatingTurnOff:
	cbi portD, 0
	cbr functionsFlags,1
	ret
autoHeatingGetTemps:
	
;=========================================/������������=========================================
