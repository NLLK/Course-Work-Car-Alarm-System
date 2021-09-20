symToHex:;sym in acc (r16)
	cpi acc, 192
	brlo brOther; ���� ������ ���� ����� A, �� ��� ������� ���������� ����� ���� ��� ������ �� �������				
	cpi acc, '�'
	breq brRuA
	cpi acc, '�'
	breq brRuB
	cpi acc, '�'
	breq brRuV
	cpi acc, '�'
	breq brRuG
	cpi acc, '�'
	breq brRuD
	cpi acc, '�'
	breq brRuE
	cpi acc, '�'
	breq brRuYo
	jmp brContinue
brOther: ret
brRuA:	ldi acc, 0x41
	ret
brRuB:	ldi acc, 0xA0
	ret
brRuV:	ldi acc, 0x42
	ret
brRuG:	ldi acc, 0xA1
	ret
brRuD:	ldi acc, 0x44 ;D
	ret
brRuE:	ldi acc, 0x45 ;E
	ret
brRuYo:	ldi acc, 0xA2 ;�
	ret
brContinue:
	cpi acc, '�'
	breq brRuJ
	cpi acc, '�'
	breq brRuZ
	cpi acc, '�'
	breq brRuI
	cpi acc, '�'
	breq brRuJi
	cpi acc, '�'
	breq brRuK
	cpi acc, '�'
	breq brRuL
	cpi acc, '�'
	breq brRuM
	jmp brContinue2

brRuJ:	ldi acc, 0xA3 ;�
	ret
brRuZ:	ldi acc,  0xA4 
	ret
brRuI:	ldi acc, 0xA5
	ret
brRuJi:ldi acc, 0xA6
	ret
brRuK:	ldi acc, 0x4B
	ret
brRuL:	ldi acc, 0xA7
	ret
brRuM:	ldi acc, 0x4D
	ret
brRuN:	ldi acc, 0x48
	ret
brContinue2:
	cpi acc, '�'
	breq brRuN
	cpi acc, '�'
	breq brRuO
	cpi acc, '�'
	breq brRuP
	cpi acc, '�'
	breq brRuR
	cpi acc, '�'
	breq brRuS
	cpi acc, '�'
	breq brRuT
	cpi acc, '�'
	breq brRuU
	jmp brContinue3
brRuO:	ldi acc, 0x4F 
	ret
brRuP:	ldi acc, 0xA8
	ret
brRuR:	ldi acc, 0x50
	ret
brRuS:	ldi acc, 0x43
	ret
brRuT:	ldi acc, 0x54
	ret
brRuU:	ldi acc, 0xA9
	ret
brContinue3:
	cpi acc, '�'
	breq brRuF
	cpi acc, '�'
	breq brRuX
	cpi acc, '�'
	breq brRuCe
	cpi acc, '�'
	breq brRuCh
	cpi acc, '�'
	breq brRuSh
	cpi acc, '�'
	breq brRuSh
	cpi acc, '�'
	breq brRubb
	jmp brContinue4
brRuF:	ldi acc, 0xAA
	ret
brRuX:	ldi acc, 0x58
	ret
brRuCe:	ldi acc, 0x75
	ret
brRuCh:	ldi acc, 0xAB
	ret
brRuSh:	ldi acc, 0xAC 
	ret
brRubb:	ldi acc, 0xAD
	ret
brContinue4:
	cpi acc, '�'
	breq brRubi
	cpi acc, '�'
	breq brRubm
	cpi acc, '�'
	breq brRuYe
	cpi acc, '�'
	breq brRuYu
	cpi acc, '�'
	breq brRuYa
	cpi acc, ' '
	ret

brRubi:	ldi acc, 0xAE
	ret
brRubm:	ldi acc, 0x62
	ret
brRuYe:	ldi acc, 0xAF
	ret
brRuYu:	ldi acc, 0xB0 
	ret
brRuYa:	ldi acc, 0xB1
	ret

