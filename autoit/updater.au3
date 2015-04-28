Local $AmIConnected
TestConnection()

RunWait("D:\oh\open_holdem\autoit\sync.bat")
FileChangeDir("D:\oh\open_holdem\table_maps\")
FileCopy ( "D:\oh\open_holdem\table_maps\*", "D:\oh\scraper\" , 1)

;FileCopy( "D:\oh\autoit\autostarter.exe*", "C:\Documents and Settings\All Users\Start Menu\Programs\Startup" , 1)

Func TestConnection()
While $AmIConnected <> "True"
$ping = Ping("www.github.com")
If $ping > 0 then
    $AmIConnected = "True"
EndIf
WEnd
EndFunc