#include-once
#include <Misc.au3>
#include <一般常数.au3>
#include <../辅助文件2/激战常数.au3>

Func setHotkey()
	IniWrite($iniFullPath, "targetModelID", "ID", GUICtrlRead($targetIDinput))

	GUISetState(@SW_DISABLE, $mainGui)
	Local $hDLL = DllOpen("user32.dll")

	Local $hotkeyGui = GUICreate("", 140, 100, -1, -1, 0x80880000, Default, $mainGui)
	GUISetBkColor(0x00FF00, $hotkeyGui)
	Local $label = GUICtrlCreateLabel("按键", 0, 30, 140, 70, $SS_CENTER)
	GUICtrlSetFont($label, 16)
	GUISetState(@SW_SHOW, $hotkeyGui)

	While True
		For $i = 4 To 221 Step 1
			If $i == 7 Then ContinueLoop
			If _IsPressed(Hex($i), $hDLL) Then
				Local $keyDEC = $i
				Local $keyHEX = StringRight(Hex($keyDEC), 2)
				Local $keyString = IniRead($keysIniFullPath, "idToKey", $keyHEX, "not found")

				; update GUI
				If $keyString == "not found" Then
					GUICtrlSetData($label, "Key not found" & @CRLF & "key code=" & $keyHEX)
				Else
					GUICtrlSetData($label, $keyString)
				EndIf

				; wait until the key is released
				While _IsPressed($keyHEX, $hDLL)
					Sleep(10)
				WEnd

				; set stuff
				GUICtrlSetData(@GUI_CtrlId, $keyString)
				For $i = 0 To $hotkeyCount-1
					If @GUI_CtrlId == $hotkeyInput[$i] Then
						$hotkeyKey[$i] = $keyHEX
						IniWrite($iniFullPath, $hotkeyName[$i], "hotkey", $keyHEX)
					EndIf
				Next
				Switch @GUI_CtrlId
					Case $pconsHotkeyInput
						$pconsHotkeyHotkey = $keyHEX
						IniWrite($iniFullPath, $pconsIniSection, "hotkey", $keyHEX)
					Case $DialogHK1Input
						$DialogHK1Hotkey = $keyHEX
						IniWrite($iniFullPath, "DialogHK"&"1", "hotkey", $keyHEX)
					Case $DialogHK2Input
						$DialogHK2Hotkey = $keyHEX
						IniWrite($iniFullPath, "DialogHK"&"2", "hotkey", $keyHEX)
					Case $DialogHK3Input
						$DialogHK3Hotkey = $keyHEX
						IniWrite($iniFullPath, "DialogHK"&"3", "hotkey", $keyHEX)
					Case $DialogHK4Input
						$DialogHK4Hotkey = $keyHEX
						IniWrite($iniFullPath, "DialogHK"&"4", "hotkey", $keyHEX)
					Case $DialogHK5Input
						$DialogHK5Hotkey = $keyHEX
						IniWrite($iniFullPath, "DialogHK"&"5", "hotkey", $keyHEX)
				EndSwitch

				; we dont want to stay in this function forever, do we?
				GUISetState(@SW_ENABLE, $mainGui)
				GUISetState(@SW_HIDE, $hotkeyGui)
				GUIDelete($hotkeyGui)
				DllClose($hDLL)
				Return
			EndIf
		Next
		Sleep(10)
	WEnd
EndFunc   ;==>setHotkey