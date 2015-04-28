Local $AmIConnected
TestConnection()

RunWait("D:\sync.bat")
FileChangeDir("D:\oh\open_holdem\table_maps\")
FileDelete("D:\oh\scraper\*")
FileCopy ( "D:\oh\open_holdem\table_maps\*", "D:\oh\scraper\" , 1)



Run("D:\oh\OpenHoldem")
RunWait("C:\Programme\PacificPoker\bin\888Poker")
;RunWait("D:\software\betcoin\Betcoin Poker\BetcoinPoker")

Local $Lobby = WinWaitActive ( "Lobby" , "" )
Local $y = 0
Send("{ENTER}")
;Sitin()
While (WinExists($Lobby))
	if (RegisterTournament($y) == True) Then
		WinWaitActive("Member Message")
		WinKill("Member Message")
		Sleep(2500)
		WinClose("Tour")
		WinActivate($Lobby)
	Else
		if ($y < 80) Then
			$y+= 20
		Else
			$y = 0
		Sleep(60000)
		EndIf
	EndIf
WEnd


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

Func SpamKiller()
	WinClose("888poker - Windows Internet Explorer")
	Sleep(500)
	WinClose("Cashier")
	Sleep(500)
	WinClose("888poker - Windows Internet Explorer")

	Return True
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