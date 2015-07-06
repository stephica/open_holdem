#include "func_lib.au3"
#include "config.inc.au3"


Local $AmIConnected
TestConnection()

Run("C:\Program Files\PokerTracker 4\PokerTracker 4.exe")
WinWaitActive("PokerTracker")
 Send("{TAB}{TAB}{TAB}{ENTER}")