Local $y = 233
Local $entry = 0


While Sleep(5000)
if register_freeroll() == true Then
WinWait("Member Message")
   WinActivate("Member Message")
   Send("{TAB}{TAB}{ENTER}")
   WinClose("Tour NLH")
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
