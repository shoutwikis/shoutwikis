#include <../辅助文件1/界面框.au3>
#include <../辅助文件1/一般常数.au3>
#include <../../激战接口.au3>
#include <Misc.au3>



Func dialogsLoadIni()
	Global $DialogHK1 =	(IniRead($iniFullPath, "DialogHK"&"1","active", False) == "True")
	Global $DialogHK2 =	(IniRead($iniFullPath, "DialogHK"&"2","active", False) == "True")
	Global $DialogHK3 =	(IniRead($iniFullPath, "DialogHK"&"3","active", False) == "True")
	Global $DialogHK4 =	(IniRead($iniFullPath, "DialogHK"&"4","active", False) == "True")
	Global $DialogHK5 =	(IniRead($iniFullPath, "DialogHK"&"5","active", False) == "True")

	Global $DialogHK1Hotkey = IniRead($iniFullPath, "DialogHK"&"1", "hotkey", "00")
	Global $DialogHK2Hotkey = IniRead($iniFullPath, "DialogHK"&"2", "hotkey", "00")
	Global $DialogHK3Hotkey = IniRead($iniFullPath, "DialogHK"&"3", "hotkey", "00")
	Global $DialogHK4Hotkey = IniRead($iniFullPath, "DialogHK"&"4", "hotkey", "00")
	Global $DialogHK5Hotkey = IniRead($iniFullPath, "DialogHK"&"5", "hotkey", "00")

	Global $DialogHK1Number = IniRead($iniFullPath, "DialogHK"&"1", "number", 0)
	Global $DialogHK2Number = IniRead($iniFullPath, "DialogHK"&"2", "number", 0)
	Global $DialogHK3Number = IniRead($iniFullPath, "DialogHK"&"3", "number", 0)
	Global $DialogHK4Number = IniRead($iniFullPath, "DialogHK"&"4", "number", 0)
	Global $DialogHK5Number = IniRead($iniFullPath, "DialogHK"&"5", "number", 0)
EndFunc


Func dialogsBuildUI()
	Local $y = 4
	GUICtrlCreateGroup("地下传送", 10, $y, 95, 228)
		Global Const $dialogsTelePlains = 	MyGuiCtrlCreateButton("浑浊平原", 20, $y + 21, 75, 23)
		Global Const $dialogsTeleWastes = 	MyGuiCtrlCreateButton("荒凉冰地", 20, $y + 50, 75, 23)
		Global Const $dialogsTeleLab =		MyGuiCtrlCreateButton("迷宫", 	20, $y + 79,75, 23)
		Global Const $dialogsTeleMnt = 		MyGuiCtrlCreateButton("双头龙山", 20, $y + 108, 75, 23)
		Global Const $dialogsTelePits = 	MyGuiCtrlCreateButton("骷髅墓穴", 	20, $y + 137, 75, 23)
		Global Const $dialogsTelePools = 	MyGuiCtrlCreateButton("孵化之池", 	20, $y + 166, 75, 23)
		Global Const $dialogTeleVale = 		MyGuiCtrlCreateButton("遗忘谷", 	20, $y + 195, 75, 23)
			GUICtrlSetOnEvent($dialogsTelePlains, "guiDialogsEventHandler")
			GUICtrlSetOnEvent($dialogsTeleWastes, "guiDialogsEventHandler")
			GUICtrlSetOnEvent($dialogsTeleLab, "guiDialogsEventHandler")
			GUICtrlSetOnEvent($dialogsTeleMnt, "guiDialogsEventHandler")
			GUICtrlSetOnEvent($dialogsTelePits, "guiDialogsEventHandler")
			GUICtrlSetOnEvent($dialogsTelePools, "guiDialogsEventHandler")
			GUICtrlSetOnEvent($dialogTeleVale, "guiDialogsEventHandler")

	Global Const $dialogsCustom = MyGuiCtrlCreateButton("自定 "&@CR&"窗口号...", 12, $y + 235, 92, 34, 0xFFFFFF, 0x222222, 1, $SS_CENTER)
		GUICtrlSetOnEvent(-1, "customDialogGui")

	Global Const $dialogsTake4H = 		MyGuiCtrlCreateButton("地下 - 四骑士任务", 110, $y + 9, 135, 22)
	Global Const $dialogsTakeDemonAss = MyGuiCtrlCreateButton("地下 - 龙山任务", 110, $y + 37, 135, 22)
	Global Const $dialogsTakeToS = 		MyGuiCtrlCreateButton("灾难 - 力量塔任务", 250, $y + 9, 135, 22)
	Global Const $dialogsTakeFury = 	MyGuiCtrlCreateButton("四门 - 铸造厂奖励", 250, $y + 37, 135, 22)
		GUICtrlSetOnEvent($dialogsTake4H, "guiDialogsEventHandler")
		GUICtrlSetOnEvent($dialogsTakeDemonAss, "guiDialogsEventHandler")
		GUICtrlSetOnEvent($dialogsTakeToS, "guiDialogsEventHandler")
		GUICtrlSetOnEvent($dialogsTakeFury, "guiDialogsEventHandler")

	Local $lDialogs = ""
	For $i=1 To $DIALOGS_NAME[0]
		$lDialogs = $lDialogs & "|" & $DIALOGS_NAME[$i]
	Next
	Local $rowY = $y + 57
	Local $rowX = 110
	Local $groupHeight = 45
	Local $groupWidth = 280
	Local $activeX = $rowX+8
	Local $hotkeyX = $activeX+55
	Local $comboX = $hotkeyX+60
	GUICtrlCreateGroup("", $rowX, $rowY, $groupWidth, $groupHeight)
	Global Const $DialogHK1Active = GUICtrlCreateCheckbox("启用", $activeX, $rowY+20, 53, 17)
	Global Const $DialogHK1Label = GUICtrlCreateLabel("快键:", $hotkeyX, $rowY+10, 41, 17)
	Global $DialogHK1Input = MyGuiCtrlCreateButton("", $hotkeyX, $rowY+25, 55, 15)
	Global Const $DialogHK1Combo = GUICtrlCreateCombo("", $comboX, $rowY+15, 150, 24, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL, $CBS_SORT))
		GUICtrlSetData(-1, $lDialogs)
		If $DialogHK1Number > 0 Then GUICtrlSetData(-1, $DIALOGS_NAME[$DialogHK1Number])
		GUICtrlSetBkColor(-1, $COLOR_BLACK)
		GUICtrlSetOnEvent($DialogHK1Active, "dialogsToggleActive")
		GUICtrlSetOnEvent($DialogHK1Input, "setHotkey")
		GUICtrlSetOnEvent($DialogHK1Combo, "setDialogID")
		If $DialogHK1 Then GUICtrlSetState($DialogHK1Active, $GUI_CHECKED)
		GUICtrlSetData($DialogHK1Input, IniRead($keysIniFullPath, "idToKey", $DialogHK1Hotkey, ""))
		GUICtrlSetFont($DialogHK1Active, 9.5)
		GUICtrlSetFont($DialogHK1Label, 9.5)

	$rowY += 42
	GUICtrlCreateGroup("", $rowX, $rowY, $groupWidth, $groupHeight)
	Global Const $DialogHK2Active = GUICtrlCreateCheckbox("启用", $activeX, $rowY+20, 53, 17)
	Global Const $DialogHK2Label = GUICtrlCreateLabel("快键:", $hotkeyX, $rowY+10, 41, 17)
	Global $DialogHK2Input = MyGuiCtrlCreateButton("", $hotkeyX, $rowY+25, 55, 15)
	Global Const $DialogHK2Combo = GUICtrlCreateCombo("", $comboX, $rowY+15, 150, 24, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL, $CBS_SORT))
		GUICtrlSetData(-1, $lDialogs)
		If $DialogHK2Number > 0 Then GUICtrlSetData(-1, $DIALOGS_NAME[$DialogHK2Number])
		GUICtrlSetBkColor(-1, $COLOR_BLACK)
		GUICtrlSetOnEvent($DialogHK2Active, "dialogsToggleActive")
		GUICtrlSetOnEvent($DialogHK2Input, "setHotkey")
		GUICtrlSetOnEvent($DialogHK2Combo, "setDialogID")
		If $DialogHK2 Then GUICtrlSetState($DialogHK2Active, $GUI_CHECKED)
		GUICtrlSetData($DialogHK2Input, IniRead($keysIniFullPath, "idToKey", $DialogHK2Hotkey, ""))
		GUICtrlSetFont($DialogHK2Active, 9.5)
		GUICtrlSetFont($DialogHK2Label, 9.5)

	$rowY += 42
	GUICtrlCreateGroup("", $rowX, $rowY, $groupWidth, $groupHeight)
	Global Const $DialogHK3Active = GUICtrlCreateCheckbox("启用", $activeX, $rowY+20, 53, 17)
	Global Const $DialogHK3Label = GUICtrlCreateLabel("快键:", $hotkeyX, $rowY+10, 41, 17)
	Global $DialogHK3Input = MyGuiCtrlCreateButton("", $hotkeyX, $rowY+25, 55, 15)
	Global Const $DialogHK3Combo = GUICtrlCreateCombo("", $comboX, $rowY+15, 150, 24, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL, $CBS_SORT))
		GUICtrlSetData(-1, $lDialogs)
		If $DialogHK3Number > 0 Then GUICtrlSetData(-1, $DIALOGS_NAME[$DialogHK3Number])
		GUICtrlSetBkColor(-1, $COLOR_BLACK)
		GUICtrlSetOnEvent($DialogHK3Active, "dialogsToggleActive")
		GUICtrlSetOnEvent($DialogHK3Input, "setHotkey")
		GUICtrlSetOnEvent($DialogHK3Combo, "setDialogID")
		If $DialogHK3 Then GUICtrlSetState($DialogHK3Active, $GUI_CHECKED)
		GUICtrlSetData($DialogHK3Input, IniRead($keysIniFullPath, "idToKey", $DialogHK3Hotkey, ""))
		GUICtrlSetFont($DialogHK3Active, 9.5)
		GUICtrlSetFont($DialogHK3Label, 9.5)

	$rowY += 42
	GUICtrlCreateGroup("", $rowX, $rowY, $groupWidth, $groupHeight)
	Global Const $DialogHK4Active = GUICtrlCreateCheckbox("启用", $activeX, $rowY+20, 53, 17)
	Global Const $DialogHK4Label = GUICtrlCreateLabel("快键:", $hotkeyX, $rowY+10, 41, 17)
	Global $DialogHK4Input = MyGuiCtrlCreateButton("", $hotkeyX, $rowY+25, 55, 15)
	Global Const $DialogHK4Combo = GUICtrlCreateCombo("", $comboX, $rowY+15, 150, 24, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL, $CBS_SORT))
		GUICtrlSetData(-1, $lDialogs)
		If $DialogHK4Number > 0 Then GUICtrlSetData(-1, $DIALOGS_NAME[$DialogHK4Number])
		GUICtrlSetBkColor(-1, $COLOR_BLACK)
		GUICtrlSetOnEvent($DialogHK4Active, "dialogsToggleActive")
		GUICtrlSetOnEvent($DialogHK4Input, "setHotkey")
		GUICtrlSetOnEvent($DialogHK4Combo, "setDialogID")
		If $DialogHK4 Then GUICtrlSetState($DialogHK4Active, $GUI_CHECKED)
		GUICtrlSetData($DialogHK4Input, IniRead($keysIniFullPath, "idToKey", $DialogHK4Hotkey, ""))
		GUICtrlSetFont($DialogHK4Active, 9.5)
		GUICtrlSetFont($DialogHK4Label, 9.5)

	$rowY += 42
	GUICtrlCreateGroup("", $rowX, $rowY, $groupWidth, $groupHeight)
	Global Const $DialogHK5Active = GUICtrlCreateCheckbox("启用", $activeX, $rowY+20, 53, 17)
	Global Const $DialogHK5Label = GUICtrlCreateLabel("快键:", $hotkeyX, $rowY+10, 41, 17)
	Global $DialogHK5Input = MyGuiCtrlCreateButton("", $hotkeyX, $rowY+25, 55, 15)
	Global Const $DialogHK5Combo = GUICtrlCreateCombo("", $comboX, $rowY+15, 150, 24, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL, $CBS_SORT))
	GUICtrlSetData(-1, $lDialogs)
	If $DialogHK5Number > 0 Then GUICtrlSetData(-1, $DIALOGS_NAME[$DialogHK5Number])
	GUICtrlSetBkColor(-1, $COLOR_BLACK)
	GUICtrlSetOnEvent($DialogHK5Active, "dialogsToggleActive")
	GUICtrlSetOnEvent($DialogHK5Input, "setHotkey")
	GUICtrlSetOnEvent($DialogHK5Combo, "setDialogID")
	If $DialogHK5 Then GUICtrlSetState($DialogHK5Active, $GUI_CHECKED)
	GUICtrlSetData($DialogHK5Input, IniRead($keysIniFullPath, "idToKey", $DialogHK5Hotkey, ""))
	GUICtrlSetFont($DialogHK5Active, 9.5)
	GUICtrlSetFont($DialogHK5Label, 9.5)
EndFunc


Local $pressedDialogHK1 = False
Local $pressedDialogHK2 = False
Local $pressedDialogHK3 = False
Local $pressedDialogHK4 = False
Local $pressedDialogHK5 = False
Func dialogsMainLoop($hDLL)
	Local $pressed
	If $DialogHK1 Then
		$pressed = _IsPressed($DialogHK1Hotkey, $hDLL)
		If (Not $pressedDialogHK1) And $pressed Then
			$pressedDialogHK1 = True
			Dialog($DIALOGS_ID[$DialogHK1Number])
		ElseIf $pressedDialogHK1 And (Not $pressed) Then
			$pressedDialogHK1 = False
		EndIf
	EndIf

	If $DialogHK2 Then
		$pressed = _IsPressed($DialogHK2Hotkey, $hDLL)
		If (Not $pressedDialogHK2) And $pressed Then
			$pressedDialogHK2 = True
			Dialog($DIALOGS_ID[$DialogHK2Number])
		ElseIf $pressedDialogHK2 And (Not $pressed) Then
			$pressedDialogHK2 = False
		EndIf
	EndIf

	If $DialogHK3 Then
		$pressed = _IsPressed($DialogHK3Hotkey, $hDLL)
		If (Not $pressedDialogHK3) And $pressed Then
			$pressedDialogHK3 = True
			Dialog($DIALOGS_ID[$DialogHK3Number])
		ElseIf $pressedDialogHK3 And (Not $pressed) Then
			$pressedDialogHK3 = False
		EndIf
	EndIf

	If $DialogHK4 Then
		$pressed = _IsPressed($DialogHK4Hotkey, $hDLL)
		If (Not $pressedDialogHK4) And $pressed Then
			$pressedDialogHK4 = True
			Dialog($DIALOGS_ID[$DialogHK4Number])
		ElseIf $pressedDialogHK4 And (Not $pressed) Then
			$pressedDialogHK4 = False
		EndIf
	EndIf

	If $DialogHK5 Then
		$pressed = _IsPressed($DialogHK5Hotkey, $hDLL)
		If (Not $pressedDialogHK5) And $pressed Then
			$pressedDialogHK5 = True
			Dialog($DIALOGS_ID[$DialogHK5Number])
		ElseIf $pressedDialogHK5 And (Not $pressed) Then
			$pressedDialogHK5 = False
		EndIf
	EndIf
EndFunc


Func customDialogGui()
	GUISetState(@SW_DISABLE, $mainGui)
	Opt("GUIOnEventMode", False)
	Local $customDialogsGui = GUICreate("自定窗口号", 300, 150, Default, Default, $WS_POPUP, Default, $mainGui)
	GUISetBkColor($COLOR_BLACK)
	GUICtrlSetDefBkColor($COLOR_BLACK)
	GUICtrlSetDefColor($COLOR_WHITE)
	WinSetTrans($customDialogsGui, "", $Transparency)

	GUICtrlCreateLabel("自定窗口号", 0, 0, 300, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
		GUICtrlSetFont(-1, 14)

	GUICtrlCreateLabel("请事先确认窗口号仍有效", 10, 50, 300, 20, Default, $GUI_WS_EX_PARENTDRAG)

	Local $lInput = GUICtrlCreateInput("", 20, 70, 170, 25, $ES_RIGHT)
		GUICtrlSetBkColor(-1, $COLOR_BLACK)
		GUICtrlSetFont(-1, 12)

	Local $sendButton = MyGuiCtrlCreateButton("发送", 210, 70, 50, 25)

	Local $doneButton = MyGuiCtrlCreateButton("关闭", 170, 110, 110, 25)

	Local $iENTER = GUICtrlCreateDummy()
	Local $iESC = GUICtrlCreateDummy()
	Local $AccelKeys[2][2] = [["{ENTER}", $iENTER], ["{ESC}", $iESC]]; Set accelerators
	GUISetAccelerators($AccelKeys)

	GUISetState(@SW_SHOW)

	While 1
		Local $msg = GUIGetMsg()
		Switch $msg
			Case 0
				ContinueLoop
			Case $GUI_EVENT_CLOSE, $doneButton, $iESC
				ExitLoop
			Case $iENTER, $sendButton
				Local $lDialogID = GUICtrlRead($lInput)
				Dialog($lDialogID)
				WriteChat("已发送窗口号: "&$lDialogID, $GWToolbox)
		EndSwitch
	WEnd

	GUIDelete($customDialogsGui)
	GUISetState(@SW_ENABLE, $mainGui)
	WinActivate($mainGui)
	Opt("GUIOnEventMode", True)
EndFunc


Func guiDialogsEventHandler()
	Switch @GUI_CtrlId
		Case $dialogsTelePlains
			Dialog($DIALOG_ID_UW_TELE_PLAINS)
		Case $dialogsTeleWastes
			Dialog($DIALOG_ID_UW_TELE_WASTES)
		Case $dialogsTeleLab
			Dialog($DIALOG_ID_UW_TELE_LAB)
		Case $dialogsTeleMnt
			Dialog($DIALOG_ID_UW_TELE_MNT)
		Case $dialogsTelePits
			Dialog($DIALOG_ID_UW_TELE_PITS)
		Case $dialogsTelePools
			Dialog($DIALOG_ID_UW_TELE_POOLS)
		Case $dialogTeleVale
			Dialog($DIALOG_ID_UW_TELE_VALE)
		Case $dialogsTake4H
			AcceptQuest($QUEST_ID_UW_PLAINS)
		Case $dialogsTakeDemonAss
			AcceptQuest($QUEST_ID_UW_MNT)
		Case $dialogsTakeToS
			AcceptQuest($QUEST_ID_FOW_TOS)
		Case $dialogsTakeFury
			QuestReward($QUEST_ID_DOA_FOUNDRY_BREAKOUT)
	EndSwitch
EndFunc

Func setDialogID()
	Local $lDialogString = GUICtrlRead(@GUI_CtrlId)
	Local $lDialogNumber = 0
	For $i=1 To $DIALOGS_NAME[0]
		If $lDialogString == $DIALOGS_NAME[$i] Then
			$lDialogNumber = $i
			ExitLoop
		EndIf
	Next
	Switch @GUI_CtrlId
		Case $DialogHK1Combo
			$DialogHK1Number = $lDialogNumber
			IniWrite($iniFullPath, "DialogHK"&"1", "number", $lDialogNumber)
		Case $DialogHK2Combo
			$DialogHK2Number = $lDialogNumber
			IniWrite($iniFullPath, "DialogHK"&"2", "number", $lDialogNumber)
		Case $DialogHK3Combo
			$DialogHK3Number = $lDialogNumber
			IniWrite($iniFullPath, "DialogHK"&"3", "number", $lDialogNumber)
		Case $DialogHK4Combo
			$DialogHK4Number = $lDialogNumber
			IniWrite($iniFullPath, "DialogHK"&"4", "number", $lDialogNumber)
		Case $DialogHK5Combo
			$DialogHK5Number = $lDialogNumber
			IniWrite($iniFullPath, "DialogHK"&"5", "number", $lDialogNumber)
	EndSwitch
EndFunc


Func dialogsToggleActive()
	Local $active = (GUICtrlRead(@GUI_CtrlId) == $GUI_CHECKED)
	Switch @GUI_CtrlId
		Case $DialogHK1Active
			$DialogHK1 = $active
			IniWrite($iniFullPath, "DialogHK"&"1", "active", $active)
		Case $DialogHK2Active
			$DialogHK2 = $active
			IniWrite($iniFullPath, "DialogHK"&"2", "active", $active)
		Case $DialogHK3Active
			$DialogHK3 = $active
			IniWrite($iniFullPath, "DialogHK"&"3", "active", $active)
		Case $DialogHK4Active
			$DialogHK4 = $active
			IniWrite($iniFullPath, "DialogHK"&"4", "active", $active)
		Case $DialogHK5Active
			$DialogHK5 = $active
			IniWrite($iniFullPath, "DialogHK"&"5", "active", $active)
		Case Else
			MyGuiMsgBox(0, "toggleActive", "not implemented!")
	EndSwitch
EndFunc   ;==>toggleActive