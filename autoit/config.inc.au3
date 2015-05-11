
If FileExists("C:\Program Files\PacificPoker\bin\888Poker.exe") Then
   Local $888path = "C:\Program Files\PacificPoker\bin\888Poker.exe"
ElseIf FileExists("C:\Programme\PacificPoker\bin\888Poker.exe") Then
     Local $888path = "C:\Programme\PacificPoker\bin\888Poker.exe"
EndIf

If FileExists("C:\Documents and Settings\freroller\Desktop\OpenHoldem_7.7.2\OpenHoldem.exe") Then
   Local $ohpath = "C:\Documents and Settings\freroller\Desktop\OpenHoldem_7.7.2\OpenHoldem.exe"
ElseIf FileExists("D:\oh\OpenHoldem.exe") Then
   Local $ohpath = "D:\oh\OpenHoldem.exe"
EndIf

Global $watchdog_path = "C:\Documents and Settings\freroller\Desktop\open_holdem\autoit\watchdog.au3"
;Iron
Global $tournaments[2][4] = [[2478387292, 3157807, 25, 12] ,[3865244129, 0, 38, 13] ]
Global $position[8] = [0]
Global $IsRegistered = False