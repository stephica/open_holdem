#include <MsgBoxConstants.au3>
#include "func_lib.au3"
#include "config.inc.au3"

While Sleep(5000)
   oh_watchdog()
WEnd

Func oh_watchdog()
  If WinExists("OpenHoldem.exe") Then
	  WinActivate("OpenHoldem.exe")
	  Send("{TAB}{TAB}{TAB}{ENTER}")
	  Sleep(3000)
	  Run($ohpath)
   EndIf
EndFunc
