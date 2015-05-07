Local $AmIConnected
TestConnection()
Run("D:\oh\OpenHoldem")
Sleep(5000)
Send("{CTRLDOWN}o{CTRLUP}")
WinWaitActive("Select Formula file to OPEN","&Suchen in:")
Send("freeroller.ohf{ENTER}")
RunWait("D:\software\betcoin\Betcoin Poker\BetcoinPoker.exe")
Local $Lobby = WinWait( "Betcoin Poker Lobby Logged in as harrybotya" , "" )
Local $y = 0

While $y == 0
If WinExists("$10 Freeroll") Then
    WinMove("$10 Freeroll","",0,0,508,387)
	 if WinExists("Player Finished") Then
		WinActivate("Player Finished")
		 Send("{ENTER}")
		 WinClose("$10 Freeroll")
	  Elseif WinExists("OpenHoldem.exe") Then
		 WinActivate("D:\oh\OpenHoldem")
		 Send("{TAB}{TAB}{ENTER}")
		 Sleep(500)
		 Run("D:\oh\OpenHoldem")
	  EndIf
 ElseIf register_freeroll()== 1 Then
 EndIf
 Sleep(5000)
WEnd


Func register_freeroll()
if (WinExists($Lobby)) Then
	WinActivate($Lobby)
	Sleep(1000)
	WinMove($Lobby,"",0,0)
   Sleep(5000)
	MouseClick("left",364,162,2,10)
	Sleep(5000)
	MouseClick("left",507,270,1,10)
	Sleep(5000)
    MouseClick("left",803,520,1,10)
	Sleep(5000)
	MouseClick("left",506,380,1,10)
	Sleep(5000)
If WinExists("Betcoin Poker","OK You are successfully registered.") Then
   WinActivate("Betcoin Poker","OK You are successfully registered.")
   Send("{ENTER}")
   Return 1
EndIf
EndIf
EndFunc

Func RegisterTournament($y)
	WinActivate($Lobby)
	MouseClick("left",677,233,1,10)
	MouseClick("left",780,(604 + $y),1,10)
	Sleep(1000)
	WinActivate("Tournament")
	Send("{ENTER}")
	Sleep(1000)
if WinExists("Registration") Then
	Send("{ENTER}")
	Return False
Else
	Send("{ENTER}")
	Return True
EndIf

EndFunc



Func Sitin()
	WinActivate($Lobby)
	WinMove($Lobby,"",0,0)
	MouseClick("left",677,264,2,10)
	WinWaitActive("Choose your buy-in amount", "")
	Sleep(3000)
	Send("{ENTER}")

	WinWaitActive("Astana")
	WinWaitClose("Astana")
	Sitin()
	Return True
EndFunc

Func TestConnection()
While $AmIConnected <> "True"
$ping = Ping("www.github.com")
If $ping > 0 then
    $AmIConnected = "True"
EndIf
WEnd
EndFunc