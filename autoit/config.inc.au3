
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