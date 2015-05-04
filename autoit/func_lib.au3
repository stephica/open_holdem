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
	  Sleep(3000)
	  ;Run($ohpath)
   EndIf
   If WinExists("6MaxSNGturbo.oppl") == 0 Then
	   Run($ohpath)
   EndIf
   Return True
EndFunc


