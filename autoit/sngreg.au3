#include <MsgBoxConstants.au3>

Local $888path = "C:\Program Files\PacificPoker\bin\888Poker.exe"

If FileExists("C:\Program Files\PacificPoker\bin\888Poker.exe") Then
   Local $888path = "C:\Program Files\PacificPoker\bin\888Poker.exe"
ElseIf FileExists("C:\Programme\PacificPoker\bin\888Poker.exe") Then
     Local $888path = "C:\Programme\PacificPoker\bin\888Poker.exe"
EndIf

If FileExists("C:\Documents and Settings\freroller\Desktop\OpenHoldem_7.7.2\OpenHoldem.exe") Then
   Local $ohpath = "C:\Documents and Settings\freroller\Desktop\OpenHoldem_7.7.2\OpenHoldem.exe"
ElseIf FileExists("D:\oh\OpenHoldem.exe") Then
   Local $ohpath = "D:\oh\OpenHoldem.exe"
EndIf

Local $y = 233
Local $entry = 0
Run($ohpath)
init_loop()

Func init_loop()
if register_sng() == true Then
   WinWait("SNG")
While WinExists("SNG")
	  oh_watchdog
	  Sleep(5000)
   if WinExists("Member Message") Then
	  WinActivate("Member Message")
	  Send("{TAB}{TAB}{ENTER}")
	  WinClose("SNG")
   EndIf
    if WinExists("Member Message") Then
	  WinActivate("Player")
	  Send("{ENTER}")
   EndIf
WEnd
EndIf
Sleep(3000)
init_loop()
EndFunc

Func start_888()
   if WinExists("Lobby") Then
	  WinActivate("Lobby")
	  Sleep(500)
	  WinMove("Lobby","",0,0)
	  If WinExists("Login") Then
		 WinActivate("Login")
		 Send("{ENTER}")
	  EndIf
   Else
	  Run($888path)
	  WinWait("Login")
	  WinActivate("Login")
	  Send("{ENTER}")
	  Sleep(5000)
	  start_888()
   EndIf
EndFunc

Func oh_watchdog()
  If WinExists("OpenHoldem.exe") Then
	  WinActivate("OpenHoldem.exe")
	  Send("{TAB}{TAB}{TAB}{ENTER}")
	  Sleep(3000)
	  Run($ohpath)
   EndIf
   If WinExists("6MaxSNGturbo.oppl") == 0 Then
	   Run($ohpath)
   EndIf

   Return True
EndFunc


Func register_sng()
   start_888()
   MouseClick("left",424,153,1)
   Sleep(500)

   WinActivate("Lobby")
   MouseClick("left",390,$y+$entry,1)
   Sleep(500)
   MouseClick("left",815,605,1)
   confirm_registration()
Return True
EndFunc


Func confirm_registration()
   if WinExists("Tournament Registration: ") Then
	  WinActivate("Tournament Registration: ")
	  Send("{Enter}")
	 if WinExists("Tournament ID :") Then
		 WinActivate("Tournament ID :")
		 Send("{Enter}")
		 Return True
	  EndIf
   EndIf
   If WinExists("Registration to tournament ") Then
	  WinActivate("Registration to tournament ")
		 Send("{Enter}")
	  Return False
   EndIf
   Return True
EndFunc

Func find_oh()
	  FileChangeDir ( "c:\" )
      ; Assign a Local variable the search handle of all files in the current directory.
    Local $hSearch = FileFindFirstFile("c:\*OpenHoldem.exe")

    ; Check if the search was successful, if not display a message and return False.
    If $hSearch = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "Error: No files/directories matched the search pattern.")
        Return False
    EndIf

    ; Assign a Local variable the empty string which will contain the files names found.
    Local $sFileName = "", $iResult = 0

    While 1
        $sFileName = FileFindNextFile($hSearch)
        ; If there is no more file matching the search.
        If @error Then ExitLoop

    ; Display the file name.
        $iResult = MsgBox(BitOR($MB_SYSTEMMODAL, $MB_OKCANCEL), "", "File: " & $sFileName)
        If $iResult <> $IDOK Then ExitLoop ; If the user clicks on the cancel/close button.

	  WEnd
    ; Close the search handle.
    FileClose($hSearch)
EndFunc   ;==>Example


