#include <MsgBoxConstants.au3>
#include "func_lib.au3"
#include "config.inc.au3"


start_oh_sng()
Sleep(10000)
start_888()
Sleep(10000)

While 1 = 1
   if $IsRegistered = True Then
	  WinWait("SNG","",300)
	  $IsRegistered = False
   Else
	  register_sng()
	  Sleep(500)
	  confirm_registration()
   EndIf
   While WinExists("SNG","")
	  oh_watchdog()
	  Sleep(5000)
	  if WinExists("Member Message") Then
		 Sleep(5000)
		 if WinExists("Member Message") Then
			WinActivate("Member Message")
			Sleep(1500)
			Send("{TAB}")
			Send("{TAB}")
			Send("{ENTER}")
			WinClose("SNG")
			if WinExists("User Message") Then
			   WinActivate("User Message")
			   Sleep(1500)
			   Send("{TAB}")
			   Send("{TAB}")
			   Send("{ENTER}")
			EndIf
		 EndIf
	  EndIf
   WEnd
   Sleep(3000)
WEnd

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


