Func EnterName()

	; Load characters showing EnterName into the scrape character bank

	Local $bankName = "EnterName" 	
	Local $numberCharacters = 0

	; Don't load the bank if it's already loaded with these characters, or if there are too many characters
	If $Char_set_name = $bankName Then
		Return "success"	
	ElseIf $numberCharacters > $Char_maxChars Then
		Return "fail"	
	Else
		; Otherwise, empty the charbank and then refill it
		Util_EmptyCharBank()
		$Char_set_name = $bankName
		$Char_bank_number = $numberCharacters
	EndIf

	Return "success" 	

EndFunc
