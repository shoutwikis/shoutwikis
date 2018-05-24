#include-once
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <ColorConstants.au3>
#include <一般常数.au3>


Func MyGuiCtrlCreateButton($sText, $iX, $iY, $iW, $iH, $iColor = 0xFFFFFF, $iBgColor = 0x222222, $iPenSize = 1, $iStyle = -1, $iStyleEx = 0)
	Return GuiCtrlCreateBorderLabel($sText, $iX, $iY, $iW, $iH, $iColor, $iBgColor, $iPenSize, ($iStyle = -1 ? BitOR($SS_CENTER, $SS_CENTERIMAGE) : $iStyle), $iStyleEx)
EndFunc



Func MyGuiMsgBox($iFlag, $sTitle, $sText, $hParent = 0, $iWidth = 300, $iHeight = 150, $bCenteredText = False)
	If $hParent Then GUISetState(@SW_DISABLE, $hParent)
	Opt("GUIOnEventMode", False)
	Local $lGui = GUICreate($sTitle, $iWidth, $iHeight, Default, Default, $WS_POPUP, Default, $hParent)
	GUISetBkColor($COLOR_BLACK)
	GUICtrlSetDefBkColor($COLOR_BLACK)
	GUICtrlSetDefColor($COLOR_WHITE)
	GUICtrlCreateLabel($sTitle, 0, 0, $iWidth, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
		GUICtrlSetFont(-1, 14)
	GUICtrlCreateLabel($sText, 20, 50, $iWidth-40, $iHeight-100, ($bCenteredText ? -1: $SS_CENTER), $GUI_WS_EX_PARENTDRAG)
	If IsDeclared("Transparency") And $Transparency > 50 Then WinSetTrans($lGui, "", $Transparency)

	Local $lOkButton = -1
	Local $lCancelButton = -1
	Local $lYesButton = -1
	Local $lNoButton = -1
	Local $lRet = -1

	Switch $iFlag
		Case 0
			$lOkButton = MyGuiCtrlCreateButton("Ok", $iWidth - 130, $iHeight - 40, 110, 25)
		Case 1
			$lCancelButton = MyGuiCtrlCreateButton("Cancel", $iWidth - 200, $iHeight - 40, 80, 25)
			$lOkButton = MyGuiCtrlCreateButton("Ok", $iWidth - 100, $iHeight - 40, 80, 25)
		Case 4
			$lNoButton = MyGuiCtrlCreateButton("No", $iWidth - 200, $iHeight - 40, 80, 25)
			$lYesButton = MyGuiCtrlCreateButton("Yes", $iWidth - 100, $iHeight - 40, 80, 25)
		Case Else
			Return
	EndSwitch

	GUISetState(@SW_SHOW, $lGui)

	While True
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $lCancelButton
				$lRet = 2
				ExitLoop
			Case $lOkButton
				$lRet = 1
				ExitLoop
			Case $lNoButton
				$lRet = 7
				ExitLoop
			Case $lYesButton
				$lRet = 6
				ExitLoop
		EndSwitch
	WEnd

	GUIDelete($lGui)
	if $hParent Then GUISetState(@SW_ENABLE, $hParent)
	if $hParent Then WinActivate($hParent)
	Opt("GUIOnEventMode", True)
	Return $lRet
EndFunc


Func GuiCtrlCreateBorderLabel($sText, $iX, $iY, $iW, $iH, $iColor, $iBgColor, $iPenSize = 1, $iStyle = -1, $iStyleEx = 0)
    GUICtrlCreateLabel("", $iX - $iPenSize, $iY - $iPenSize, $iW + 2 * $iPenSize, $iH + 2 * $iPenSize, 0)
	GUICtrlSetState(-1, $GUI_DISABLE)
    GUICtrlSetBkColor(-1, $iColor)
    Local $nID = GUICtrlCreateLabel($sText, $iX, $iY, $iW, $iH, $iStyle, $iStyleEx)
	GUICtrlSetBkColor(-1, $iBgColor)
    Return $nID
EndFunc   ;==>CreateBorderLabel


Func GuiCtrlCreateRect($x, $y, $width, $height, $color = $COLOR_WHITE)
	Local $ret = GUICtrlCreateLabel("", $x, $y, $width, $height)
	GUICtrlSetBkColor(-1, $color)
	GUICtrlSetState(-1, $GUI_DISABLE)
	Return $ret
EndFunc

Func GuiCtrlUpdateData($hCtrl, $data)
	If GUICtrlRead($hCtrl) <> $data Then GUICtrlSetData($hCtrl, $data)
EndFunc

Func _GuiRoundCorners($h_win, $iSize)
	Local $XS_pos, $XS_ret
	$XS_pos = WinGetPos($h_win)
	$XS_ret = DllCall("gdi32.dll", "long", "CreateRoundRectRgn", "long", 0, "long", 0, "long", $XS_pos[2]+1, "long", $XS_pos[3]+1, "long", $iSize, "long", $iSize)
	If $XS_ret[0] Then
		DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $XS_ret[0], "int", 1)
	EndIf
EndFunc   ;==>_GuiRoundCorners
