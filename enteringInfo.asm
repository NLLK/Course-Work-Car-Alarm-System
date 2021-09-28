;-----���� ����������-----;
enteringInfo:
	sbrs programFlags, 4
	ret
	call enteringInfoMenuSwitch
	cbr programFlags, 16
	ret

enteringInfoMenuSwitch:
	mov acc, menuModes
	andi acc, 0xf0
	lsr acc	
	lsr acc
	lsr acc
	lsr acc

	ldi ZH, high(enteringInfoMenuSwitchTable)
	ldi ZL, low(enteringInfoMenuSwitchTable)
	dec acc
	ldi acc2, 3
	mul acc, acc2
	add r30, r0
	brcs enteringInfoMenuSwitchOverflow

enteringInfoMenuSwitchContinue:
	ijmp

enteringInfoMenuSwitchOverflow:
	ldi acc, 1
	add r31, acc
	jmp enteringInfoMenuSwitchContinue

enteringInfoMenuSwitchTable:
enteringInfoMenu1SwitchCalling: call enteringInfoMenu1Switch
	ret
enteringInfoMenu2SwitchCalling: ;call enteringInfoMenu2Switch
	ret
enteringInfoMenu3SwitchCalling: ;call enteringInfoMenu3Switch
	ret
enteringInfoMenu4SwitchCalling: ;call enteringInfoMenu4Switch
	ret
enteringInfoMenu5SwitchCalling: ;call enteringInfoMenu5Switch
	ret

enteringInfoMenu1Switch:
	mov acc, menuModes
	andi acc, 0x0f

	ldi ZH, high(enteringInfoMenu1SwitchTable)
	ldi ZL, low(enteringInfoMenu1SwitchTable)
	dec acc
	ldi acc2, 3
	mul acc, acc2
	add r30, r0
	brcs enteringInfoMenu1SwitchOverflow

enteringInfoMenu1SwitchContinue:
	ijmp

enteringInfoMenu1SwitchOverflow:
	ldi acc, 1
	add r31, acc
	jmp enteringInfoMenu1SwitchContinue

enteringInfoMenu1SwitchTable:
enteringInfoMenu1Submenu1Calling: call enteringInfoSettingsTimeCursorPosSwitch
	ret
enteringInfoMenu1Submenu2Calling: ;call modeSettingsSetTankVolume
	ret
enteringInfoMenu1Submenu3Calling: ;call modeSettingsSetAvgSpending
	ret


enteringInfoSettingsTimeCursorPosSwitch:
	;������� �������� ������� � ����� ������������ �� �������
	lds acc, pressedKey
	cpi acc, 0x0A
	brge enteringInfoSettingsTimeKeysLettersCalling

	lds acc, cursorCoords
	LDI YL, low(keyboardInputBuffer)
	LDI YH, high(keyboardInputBuffer)
	
	add YL, acc
	brcs enteringInfoSettingsTimeRow0SwitchkeyboardInputBufferEnteringOverflow
	jmp enteringInfoSettingsTimeRow0SwitchkeyboardInputBufferEnteringContinue
enteringInfoSettingsTimeRow0SwitchkeyboardInputBufferEnteringOverflow:
	ldi acc, 1
	add r31, acc
enteringInfoSettingsTimeRow0SwitchkeyboardInputBufferEnteringContinue:
	lds acc, pressedKey
	ST y, acc
	;� ����������� �� ��������� ������� ���� �������� ������
	lds acc, cursorCoords
	ldi ZH, high(enteringInfoSettingsTimeCursorPosSwitchTable)
	ldi ZL, low(enteringInfoSettingsTimeCursorPosSwitchTable)
	ldi acc2, 3
	mul acc, acc2
	add r30, r0
	brcs enteringInfoSettingsTimeCursorPosSwitchOverflow

enteringInfoSettingsTimeCursorPosSwitchContinue:
	ijmp

enteringInfoSettingsTimeKeysLettersCalling: call enteringInfoSettingsTimeKeysLetters
	ret

enteringInfoSettingsTimeCursorPosSwitchOverflow:
	ldi acc, 1
	add r31, acc
	jmp enteringInfoSettingsTimeCursorPosSwitchContinue

enteringInfoSettingsTimeCursorPosSwitchTable:
enteringInfoSettingsTimeCursorPos0Calling: call enteringInfoSettingsTimeCursorPos0
	ret
enteringInfoSettingsTimeCursorPos1Calling: call enteringInfoSettingsTimeCursorPos1
	ret
enteringInfoSettingsTimeCursorPos2Calling: call enteringInfoSettingsTimeCursorPos2
	ret
enteringInfoSettingsTimeCursorPos3Calling: call enteringInfoSettingsTimeCursorPos3
	ret
enteringInfoSettingsTimeCursorPos4Calling: call enteringInfoSettingsTimeCursorPos4
	ret
enteringInfoSettingsTimeCursorPos5Calling: call enteringInfoSettingsTimeCursorPos5
	ret
enteringInfoSettingsTimeCursorPos6Calling: call enteringInfoSettingsTimeCursorPos6
	ret

enteringInfoSettingsTimeCursorPos0:
	lds acc2, pressedKey	
	cpi acc2, 3
	brge enteringInfoSettingsTimeError
	ldi acc, 0x30
	add acc2, acc
	RCALL DATA_WR

	jmp enteringInfoSettingsTimeIncCursor	;���������� ������ �������� �������

enteringInfoSettingsTimeError:
	ret

enteringInfoSettingsTimeCursorPos1:
	lds acc2, pressedKey
	ldi acc, 0x30
	add acc2, acc
	RCALL DATA_WR

	ldi acc, 1
	RCALL shiftCursorRight	;����� �������

	jmp enteringInfoSettingsTimeIncCursor	;���������� ������ �������� �������

enteringInfoSettingsTimeCursorPos2:
	lds acc2, pressedKey
	cpi acc2, 6
	brge enteringInfoSettingsTimeError
	ldi acc, 0x30
	add acc2, acc
	RCALL DATA_WR

	jmp enteringInfoSettingsTimeIncCursor	;���������� ������ �������� �������

enteringInfoSettingsTimeCursorPos3:
	lds acc2, pressedKey
	ldi acc, 0x30
	add acc2, acc
	RCALL DATA_WR

	ldi acc, 1
	RCALL shiftCursorRight	;����� �������

	jmp enteringInfoSettingsTimeIncCursor	;���������� ������ �������� �������

enteringInfoSettingsTimeCursorPos4:
	lds acc2, pressedKey
	cpi acc2, 6
	brge enteringInfoSettingsTimeError
	ldi acc, 0x30
	add acc2, acc
	RCALL DATA_WR

	jmp enteringInfoSettingsTimeIncCursor	;���������� ������ �������� �������

enteringInfoSettingsTimeCursorPos5:
	lds acc2, pressedKey
	ldi acc, 0x30
	add acc2, acc
	RCALL DATA_WR

	RCALL shiftCursorSecondRow;����� ������� �� ��������� ������
	jmp enteringInfoSettingsTimeIncCursor;���������� ������ �������� �������

enteringInfoSettingsTimeCursorPos6:
	ldi acc, 1
	RCALL shiftCursorRight;����� �������
	jmp enteringInfoSettingsTimeIncCursor	;���������� ������ �������� �������

enteringInfoSettingsTimeIncCursor:
	lds acc, cursorCoords
	inc acc
	STS cursorCoords, acc
	ret
enteringInfoSettingsTimeKeysLetters:	
	lds acc, pressedKey
	cpi acc, 0x0E
	brge enteringInfoSettingsTimeError

	subi acc, 0x0A
	ldi ZH, high(enteringInfoSettingsTimeKeysLettersSwitchTable)
	ldi ZL, low(enteringInfoSettingsTimeKeysLettersSwitchTable)
	ldi acc2, 3
	mul acc, acc2
	add r30, r0
	brcs enteringInfoSettingsTimeKeysLettersSwitchOverflow

enteringInfoSettingsTimeKeysLettersSwitchContinue:
	ijmp

enteringInfoSettingsTimeKeysLettersSwitchOverflow:
	ldi acc, 1
	add r31, acc
	jmp enteringInfoSettingsTimeKeysLettersSwitchContinue

enteringInfoSettingsTimeKeysLettersSwitchTable:
	call enteringInfoSettingsTimeKeysLettersA
	ret
	call enteringInfoSettingsTimeKeysLettersB
	ret
	call enteringInfoSettingsTimeKeysLettersC
	ret
	call enteringInfoSettingsTimeKeysLettersD
	ret

enteringInfoSettingsTimeKeysLettersA:
	;���� �������� �� ���������� (������ �����������) - �� �� �������� ���

	lds acc, cursorCoords
	cpi acc, 6
	brge enteringInfoSettingsTimeKeysLettersAWeekDay
enteringInfoSettingsTimeKeysLettersAContinue:
	
	LDI YL, low(keyboardInputBuffer)
	LDI YH, high(keyboardInputBuffer)
	LD acc, Y+
	cpi acc, 3
	brge enteringInfoSettingsTimeKeysLettersA1
	STS RTT_10H, acc
enteringInfoSettingsTimeKeysLettersA1:	LD acc, Y+
	STS RTT_1H, acc
	LD acc, Y+
	cpi acc, 3
	brge enteringInfoSettingsTimeKeysLettersA2
	STS RTT_10m, acc
enteringInfoSettingsTimeKeysLettersA2:	LD acc, Y+
	STS RTT_1m	, acc
	LD acc, Y+
	cpi acc, 3
	brge enteringInfoSettingsTimeKeysLettersA3
	STS RTT_10s, acc
enteringInfoSettingsTimeKeysLettersA3:	LD acc, Y+
	STS RTT_1s	, acc

	cbr programFlags, 8
	jmp enteringInfoSettingsTimeKeysLettersB 

enteringInfoSettingsTimeKeysLettersAWeekDay:
	subi acc, 6
	STS RTT_24H, acc
	rjmp enteringInfoSettingsTimeKeysLettersAContinue


enteringInfoSettingsTimeKeysLettersB:
	cbr programFlags, 8
	ret	
enteringInfoSettingsTimeKeysLettersC:
	lds acc, cursorCoords
	cpi acc, 6
	brlo enteringInfoSettingsTimeKeyBindingError

	cpi acc, 12
	brge enteringInfoSettingsTimeKeyBindingError
	
	ldi acc, 1
	RCALL shiftCursorRight

	lds acc, cursorCoords
	inc acc
	STS cursorCoords, acc
	ret	
enteringInfoSettingsTimeKeysLettersD:
	lds acc, cursorCoords
	cpi acc, 7
	brlo enteringInfoSettingsTimeKeyBindingError

	ldi acc, 1
	RCALL shiftCursorLeft

	lds acc, cursorCoords
	dec acc
	STS cursorCoords, acc
	ret	

enteringInfoSettingsTimeKeyBindingError:
	ret
;-----���� ����������-----;
