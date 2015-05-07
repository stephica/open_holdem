Func TestConnection()
While $AmIConnected <> "True"
$ping = Ping("www.github.com")
If $ping > 0 then
    $AmIConnected = "True"
EndIf
WEnd
EndFunc

Func oh_watchdog()
  If WinExists("OpenHoldem.exe") Then
	  WinActivate("OpenHoldem.exe")
	  Send("{TAB}{TAB}{TAB}{ENTER}")
	  Sleep(2000)
	  Run($ohpath)
   EndIf
   Return True
EndFunc

Func start_oh_turbo_sng()
   Run($ohpath)
   Sleep(2000)
   Send("{CTRLDOWN}o{CTRLUP}")
   WinWait("Select Formula file to OPEN","")
   Send("6MaxSNGturbo.oppl{ENTER}")
   Sleep(3000)
   WinClose("6MaxSNGturbo.oppl","")
   Sleep(3000)
   Run($ohpath)
   WinWait("6MaxSNGturbo.oppl")
   WinMove("6MaxSNGturbo.oppl","",0,360)
EndFunc

Func start_888()
   if WinExists("Lobby") Then
	  WinActivate("Lobby")
	  WinMove("Lobby","",0,0)
   Else
	  Run($888path)
	  WinWaitActive("Login")
	  Send("{ENTER}")
	  Sleep(5000)
	  WinActivate("Lobby")
	  WinMove("Lobby","",0,0)
	  Sleep(3000)
	  EndIf
EndFunc

Func spam_killer()
	WinClose("888poker - Windows Internet Explorer")
	Sleep(500)
	WinClose("Cashier")
	Sleep(500)
	WinClose("888poker - Windows Internet Explorer")
	Return True
EndFunc

Func register_sng()
     WinActivate("Lobby")
	  MouseClick("left",424,153,1)
	  Sleep(500)
	  WinActivate("Lobby")
	  MouseClick("left",390,265,1)
	  Sleep(500)
	  MouseClick("left",815,605,1)
	  Sleep(500)
	  confirm_registration()
EndFunc

Func confirm_registration()
   if WinExists("Tournament Registration: ") Then
	  WinActivate("Tournament Registration: ")
	  Send("{Enter}")
	 Sleep(500)
	 if WinExists("Tournament ID :") Then
		 WinActivate("Tournament ID :")
		 Send("{Enter}")
		 $IsRegistered = True
	  ElseIf WinExists("Registration to") Then
		 WinActivate("Registration to")
		 Send("{Enter}")
	  EndIf
   EndIf
EndFunc