updatingDisplay:	
	LDI R17,(1<<0)
	RCALL CMD_WR; ������� �������
	
	;���-�� � ���� ������� ���� ������ ���� inMode (8) � ���������� ����, ������� ��� ���� ������� ��� �����

	mov acc, menuModes
	andi acc, 0xf0
	lsr acc
	lsr acc
	lsr acc
	lsr acc
	cpi acc, 0
	breq udpDisp0
	cpi acc, 1
	breq updDisp1
	cpi acc, 2
	breq updDisp2
	ret
	
udpDisp0:
	call modeMain
	ret
updDisp1:
	call modeSettings
	ret
updDisp2:
	call modeAutoHeatingSettings
	ret

modeMain:	;������� ����
	ldi acc, LOW(_labelMainMenu<<1)
	mov ZL, acc
	ldi acc, HIGH(_labelMainMenu<<1)
	mov ZH, acc
	call DATA_WR_from_Z
	
	LDI		R17,(1<<7)|(0+0x40*0)
	RCALL	CMD_WR

	lds acc2, RTT_10H
	ldi acc, 0x30
	adc acc2, acc
	RCALL DATA_WR

	lds acc2, RTT_1H
	ldi acc, 0x30
	adc acc2, acc
	RCALL DATA_WR

	LDI		R17,(1<<7)|(3+0x40*0)
	RCALL	CMD_WR

	lds acc2, RTT_10M
	ldi acc, 0x30
	adc acc2, acc
	RCALL DATA_WR

	lds acc2, RTT_1M
	ldi acc, 0x30
	adc acc2, acc
	RCALL DATA_WR

	LDI		R17,(1<<7)|(6+0x40*0)
	RCALL	CMD_WR

	lds acc2, RTT_10S
	ldi acc, 0x30
	adc acc2, acc
	RCALL DATA_WR

	lds acc2, RTT_1S
	ldi acc, 0x30
	adc acc2, acc
	RCALL DATA_WR

	ret
;-----1. ���������-----;
modeSettings:
	mov acc, menuModes
	andi acc, 0x0f
	cpi acc, 0
	brne modeSettingsSubsLabels

	ldi acc, LOW(_labelMenu1<<1)
	mov ZL, acc
	ldi acc, HIGH(_labelMenu1<<1)
	mov ZH, acc
	call DATA_WR_from_Z
	ret

modeSettingsSubsLabels:
	sbrc programFlags, 3; ???????????????????
	jmp modeSettingsSubsCalling
	cpi acc, 1
	breq modeSettingsSetTimeLabelCalling
	cpi acc, 2
	breq modeSettingsSetTankVolumeLabelCalling
	cpi acc, 3
	breq modeSettingsSetAvgSpendingLabelCalling

	ret
modeSettingsSubsCalling: call modeSettingsSubs
	ret
modeSettingsSetTimeLabelCalling:	call modeSettingsSetTimeLabel
	ret
modeSettingsSetTankVolumeLabelCalling: call modeSettingsSetTankVolumeLabel
	ret
modeSettingsSetAvgSpendingLabelCalling: call modeSettingsSetAvgSpendingLabel
	ret


modeSettingsSetTimeLabel:			;����������� ��������� �������� ������� � ��� ������ 
	ldi acc, LOW(_labelMenu11<<1)
	mov ZL, acc
	ldi acc, HIGH(_labelMenu11<<1)
	mov ZH, acc
	call DATA_WR_from_Z
	ret

modeSettingsSetTankVolumeLabel:		;����������� ��������� ��������� ������ ����

	ret

modeSettingsSetAvgSpendingLabel:	;����������� ��������� ��������� �������� ��������

	ret

modeSettingsSubs:					;������� � ������� ����
	cpi acc, 1
	breq modeSettingsSetTimeCalling
	cpi acc, 2
	breq modeSettingsSetTankVolumeCalling
	cpi acc, 3
	breq modeSettingsSetAvgSpendingCalling
	ret

modeSettingsSetTimeCalling: call modeSettingsSetTime
	ret
modeSettingsSetTankVolumeCalling: call modeSettingsSetTankVolume
	ret
modeSettingsSetAvgSpendingCalling: call modeSettingsSetAvgSpending
	ret

modeSettingsSetTime:
	ldi acc, LOW(_labelMenu11In<<1)
	mov ZL, acc
	ldi acc, HIGH(_labelMenu11In<<1)
	mov ZH, acc
	call DATA_WR_from_Z
	ret
modeSettingsSetTankVolume:
	ret
modeSettingsSetAvgSpending:
	ret

;-----2. ������������-----;
modeAutoHeatingSettings:
	ldi acc, LOW(_labelMenu2<<1)
	mov ZL, acc
	ldi acc, HIGH(_labelMenu2<<1)
	mov ZH, acc
	call DATA_WR_from_Z
	ret
