While Sleep(5000)
   oh_watchdog()
   spam_killer()
WEnd


Func oh_watchdog()
  If WinExists("OpenHoldem.exe") Then
	  WinActivate("OpenHoldem.exe")
	  Send("{TAB}{TAB}{TAB}{ENTER}")
	  Sleep(3000)
	  Run("C:\Documents and Settings\freroller\Desktop\OpenHoldem_7.7.2\OpenHoldem.exe")
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

	  Else
		 sitin()
	  EndIf

   EndFunc

   Func sitin()
	  If WinExists("Lobby") Then
		 WinActivate("Lobby")
		 WinMove("Lobby",0,0)
	  EndIf
   EndFunc