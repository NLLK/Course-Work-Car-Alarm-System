
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
	rcall getTemperature
	mov acc2, acc
	andi acc, 0x80
	cpi acc, 0x80	;���� �������������, �� ��������� �����
	breq AutoHeatingTimeChecking
	;���� �� �������������, �� ���� ����������� ������ ������������ - ���������
	pop acc
	cp acc2, acc
	brge autoHeatingTurnOff

	;����� - ��������� �����
AutoHeatingTimeChecking:
	sbrc acc, 7
	pop acc
	

	ret

autoHeatingTempChecking:
	lds acc, AutoHeatingTempMin10
	ldi acc2, 10
	mul acc, acc2
	mov acc, r0
	lds acc2, AutoHeatingTempMin1
	add acc, acc2
	push acc
	rcall getTemperature
	mov acc2, acc
	andi acc2, 0b01111111
	pop acc
	cp acc2, acc
	brge autoHeatingTurnOn
	ret
autoHeatingTurnOn:
	;//TODO:�������� ������� ����� � ����������
	lds acc, RTT_10H
	STS AutoHeatingPreviousStartTime_10h, acc
	lds acc, RTT_1H
	STS AutoHeatingPreviousStartTime_1h, acc
	lds acc, RTT_10m
	STS AutoHeatingPreviousStartTime_10m, acc
	lds acc, RTT_1m
	STS AutoHeatingPreviousStartTime_1m, acc

	sbi portD, 0
	sbr functionsFlags,1
	ret
autoHeatingTurnOff:
	cbi portD, 0
	cbr functionsFlags,1
	ret
autoHeatingGetTemps:
	
;=========================================/������������=========================================
