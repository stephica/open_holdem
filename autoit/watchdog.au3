Local $888path = "C:\Program Files\PacificPoker\bin\888Poker.exe"
Local $ohpath = "C:\Documents and Settings\freroller\Desktop\OpenHoldem_7.7.2\OpenHoldem.exe"
Local $y = 233
Local $entry = 0


While Sleep(5000)
   oh_watchdog()
   spam_killer()
   ;table_watchdog()
if register_freeroll() == true Then
   WinWait("Tour NLH")
EndIf
WEnd


Func start_888()
   if WinExists("Lobby") Then
	  WinActivate("Lobby")
	  Sleep(1500)
	  WinMove("Lobby","",0,0)
   Else
	  Run($888path)
   EndIf
EndFunc

Func oh_watchdog()
  If WinExists("OpenHoldem.exe") Then
	  WinActivate("OpenHoldem.exe")
	  Send("{TAB}{TAB}{TAB}{ENTER}")
	  Sleep(3000)
	  Run($ohpath)
   EndIf
EndFunc

Func spam_killer()
   if WinExists("User Message") Then
	  WinActivate("User Message")
	  Send("{ENTER}")
   EndIf
EndFunc


Func table_watchdog()
	  If WinExists("Ahmadabad") Then
	  ElseIf WinExists("Astana") Then
	  ElseIf WinExists("Kimpo") Then

	  Else
		 sitin()
	  EndIf

   EndFunc

   Func sitin()
	  If WinExists("Lobby") Then
		 WinActivate("Lobby")
		 WinMove("Lobby","",0,0)
		 Sleep(500)
		 MouseClick("left",681,151,1)
		 Sleep(500)
		 MouseClick("left",650,260,1)
		 WinWaitActive("Choose your buy-in amount")
		 Send("{Enter}")
	  Else
		 Run("C:\Program Files\PacificPoker\bin\888Poker.exe")
		 Sleep(500)
		 WinWaitActive("Login")
		 Sleep(500)
		 Send("{Enter}")
	  EndIf
   EndFunc

Func register_freeroll()
   start_888()
   WinActivate("Lobby")
   MouseClick("left",424,153,1)
   Sleep(1500)
  While confirm_registration() <> true
   WinActivate("Lobby")
   MouseClick("left",390,$y+$entry,1)
   Sleep(1500)
   MouseClick("left",815,605,1)
   Sleep(1500)
   $entry = $entry + 20
   if $entry > 160 Then
	  $entry = 0
	  Sleep(60000)
   EndIf
  WEnd
Return True
EndFunc

Func confirm_registration()
   if WinExists("Tournament Registration: ") Then
	  WinActivate("Tournament Registration: ")
	  Send("{Enter}")
	  Sleep(500)
	  if WinExists("Tournament ID :") Then
		 Send("{Enter}")
		 Return True
	  EndIf
   EndIf
EndFunc
