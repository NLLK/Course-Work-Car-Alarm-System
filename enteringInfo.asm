;-----���� ����������-----;
enteringInfo:
	sbrs programFlags, 4
	ret
	call enteringInfoMain
	cbr programFlags, 16
	ret

enteringInfoMain:
	;��������� ����, ���������� �������

	LDI		R17,(1<<4)|(1<<2); �������� ������ ������
	RCALL	CMD_WR

	
	;LDI		R17,(1<<4); �������� ������ �����
	;RCALL	CMD_WR

	ret
;-----���� ����������-----;
