#include <MsgBoxConstants.au3>
#include "func_lib.au3"
#include "config.inc.au3"

Global $IsRegistered = False
Global $IsPlaying = False

start_oh_turbo_sng()
Run($watchdog_path)
start_888()
spam_killer()
register_sng()

While 0 <> 1
   Sleep(30000)
   if WinExists("SNG NLH", "") Then
	  $IsPlaying = True
   EndIf

   if WinExists("User Message") Then
	 WinActivate("User Message")
	 Send("{Enter}")
  EndIf

   if WinExists("Member Message") Then
	  Sleep(5000); giving OH time to close the window if it isnt the finished message
	  if WinExists("Member Message") Then
		 WinActivate("Member Message")
		 Send("{Tab}{Enter}")
		 Sleep(1000)
		 WinClose("SNG NLH","")
		 $IsPlaying = False
		 $IsRegistered = False
	  EndIf
   EndIf
   If $IsRegistered = False Then
	  $IsRegistered = register_sng()
   EndIf
WEnd