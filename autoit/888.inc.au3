

Func start_888()
   if WinExists("Lobby") = False Then
   RunWait($888path)
   WinWaitActive("Login")
   Send("{ENTER}")
   WinActivate("Lobby")
   WinMove("Lobby","",0,0)
EndIf
EndFunc

Func close_888()
   if WinExists("Lobby") Then
	  WinClose("Lobby")
   EndIf
EndFunc

Func lookup_tournaments()
   WinActivate("Lobby")
   WinMove("Lobby","",0,0)
   MouseClick("left",424,153,1)
   Sleep(2000)
  	 ;$position = Util_FindImage ($tournaments[$i][1],$tournaments[$i][2], $tournaments[$i][3], $tournaments[$i][4],0, 0, 600, 600)

	  $position = Util_FindImage (3697987311,3157807,36,11,0, 0, 600, 600)
   ;If  $position [1] > 0 Then
	  register_tournament($position[1],$position[2])
   ;EndIf
   Sleep(1000)
EndFunc

Func register_tournament($width, $height)
   MouseClick("left",$width,$height,1)
   Sleep(1500)
   MouseClick("left",815,605,1)
   Sleep(1500)
EndFunc