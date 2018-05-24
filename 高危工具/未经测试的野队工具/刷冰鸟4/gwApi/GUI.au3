#include-once

;~ Description: Gregs pretty GUIs.
Func _GuiRoundCorners($h_win, $iSize)
   Local $XS_pos, $XS_ret
   $XS_pos = WinGetPos($h_win)
   $XS_ret = DllCall("gdi32.dll", "long", "CreateRoundRectRgn", "long", 0, "long", 0, "long", $XS_pos[2] + 1, "long", $XS_pos[3] + 1, "long", $iSize, "long", $iSize)
   If $XS_ret[0] Then
	  DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $XS_ret[0], "int", 1)
   EndIf
EndFunc   ;==>_GuiRoundCorners