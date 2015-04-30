Func TestConnection()
While $AmIConnected <> "True"
$ping = Ping("www.github.com")
If $ping > 0 then
    $AmIConnected = "True"
EndIf
WEnd
EndFunc



Func start_888()
   if WinExists("Lobby") = False Then
   RunWait($888path)
   WinWaitActive("Login")
   Send("{ENTER}")
Else
   WinActivate("Lobby")
   WinMove("Lobby","",0,0)
EndIf
EndFunc
