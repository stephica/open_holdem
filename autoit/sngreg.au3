#include <MsgBoxConstants.au3>
#include "func_lib.au3"
#include "config.inc.au3"


oh_watchdog()
Sleep(10000)
start_888()
Sleep(10000)


;For $i = 50 To 1 Step -1
if register_sng() = true Then
   WinWait("SNG")
   While 1 = 1
	  Sleep(3000)
	  oh_watchdog()
	  Sleep(3000)
   if WinExists("Member Message") Then
	  WinActivate("Member Message")
	  Send("{ENTER}")
   EndIf
   if WinExists("User") Then
	  WinActivate("User")
	  Send("{ENTER}")
   EndIf
   If WinExists("Sit & Go","") Then
	  WinActivate("Sit & Go")
	  WinMove("Sit & Go","",0,0)
	  Sleep(1500)
	  MouseClick("left",144,213,1)
	  confirm_registration()
	  WinClose("SNG")
   EndIf
   WEnd
Sleep(60000)
EndIf
;Next

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


