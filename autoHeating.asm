autoHeatingMain:
	ldi acc, 0x01
	out portD, acc
	ret
