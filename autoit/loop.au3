#include <MsgBoxConstants.au3>
#include "func_lib.au3"
#include "config.inc.au3"

Global $IsRegistered = False
Global $IsPlaying = False

;start_oh_turbo_sng()
;Run($watchdog_path)
;start_888()
;spam_killer()
;register_sng()

While 0 <> 1
   if WinExists("User Message") Then
	  WinActivate("User Message")
	  Sleep(500)
	  Send("{ENTER}")
   EndIf

   if WinExists("Member Message") Then
	  Sleep(5000); giving OH time to close the window if it isnt the finished message
	  if WinExists("Member Message") Then
		 WinActivate("Member Message")
		 MouseClick("Left",163,269,1)
		 Sleep(1000)
		 WinClose("SNG NLH","")
		 WinWait("Sit & Go")
		 WinMove("Sit & Go",0,0)
		 MouseClick("Left",821,22,1)
		 Sleep(1000)
		 confirm_registration()
	  EndIf
   EndIf
WEnd