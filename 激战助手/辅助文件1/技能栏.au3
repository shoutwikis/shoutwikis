#include-once
#include <../辅助文件1/界面框.au3>
#include <../辅助文件1/一般常数.au3>
#include <../../激战接口.au3>

Local Const $buildsNumber = 16
Local Const $buildsPartySize = 12
Global Const $buildsMaxScroll = ($buildsNumber + 1) * 32 - 269 ;$buildsNumber * 32 - 269

Func buildsBuildUI()
	Local $buildsX = 10

	Global $buildsEdit[$buildsNumber]
	Global $buildsLabel[$buildsNumber]

	Global $rowy = 10

	MyGuiCtrlCreateButton("滚动鼠标轮以视界面全貌", 10, 10, 177, 17, 0xAAAAAA, 0x222222, 1)

	$rowy = 35

	For $i = 0 To $buildsNumber-1

		$buildsEdit[$i] = MyGuiCtrlCreateButton("修改", $buildsX, 		$rowy, 25, 20)
		$buildsLabel[$i] = GUICtrlCreateLabel("", 	$buildsX + 30,  $rowy+3, 160, 20)
			GUICtrlSetTip($buildsLabel[$i], "击此发送团技能表")
			GUICtrlSetOnEvent($buildsEdit[$i], "customTeambuild")
			GUICtrlSetData($buildsLabel[$i], IniRead($iniFullPath, "builds"&($i+1), "buildname", "<空缺>"))
			GUICtrlSetOnEvent($buildsLabel[$i], "sendTeamBuilds")
		$rowy += 32
	Next
EndFunc


Func customTeambuild()
	GUISetState(@SW_DISABLE, $mainGui)
	Opt("GUIOnEventMode", False)

	; get from which build it is
	Local $buildsNo
	For $i = 0 To $buildsNumber-1
		If @GUI_CtrlId == $buildsEdit[$i] Then
			$buildsNo = $i+1
			ExitLoop
		EndIf
	Next

	; build the interface
	Local $teamBuildGui = GUICreate("设置队伍技能表", 470, 508, Default, Default, $WS_POPUP, Default, $mainGui)
		GUISetBkColor($COLOR_BLACK)
		GUICtrlSetDefBkColor($COLOR_BLACK)
		GUICtrlSetDefColor($COLOR_WHITE)
		WinSetTrans($teamBuildGui, "", $Transparency)
	GUICtrlCreateLabel("设置队伍技能表", 0, 0, 420, 40, BitOR($SS_CENTER, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
		GUICtrlSetFont(-1, 14)
	GUICtrlCreateLabel("技能表名称:", 36, 44)
	Local $buildName = 	GUICtrlCreateInput(IniRead($iniFullPath, "builds" & $buildsNo, "buildname", ""), 110, 42, 190, 21)

	GUICtrlCreateLabel("任务名:", 50, 70, 110, 21)
	GUICtrlCreateLabel("样本号:", 190, 70, 170, 21)
	$rowY = 88
	Local $name[$buildsPartySize]
	Local $template[$buildsPartySize]
	Local $sendButton[$buildsPartySize]

	For $i = 0 To $buildsPartySize-1
		GUICtrlCreateLabel("#"&($i+1), 16, $rowY+2,  20, 21)
		$name[$i] = 	GUICtrlCreateInput(IniRead($iniFullPath, "builds" & $buildsNo, "name"&($i+1),     ""),  45, $rowY, 130, 21)
		$template[$i] =	GUICtrlCreateInput(IniRead($iniFullPath, "builds" & $buildsNo, "template"&($i+1), ""), 185, $rowY, 220, 21)
		$sendButton[$i] = MyGuiCtrlCreateButton("发送", 410, $rowY+1, 40, 19)

		$rowY += 32
	Next

	Local $showNumbers = GUICtrlCreateCheckbox("显示样本号", 16, 468, 150, 25)
		If (IniRead($iniFullPath, "builds" & $buildsNo, "showNumbers", "True")=="True") Then GUICtrlSetState($showNumbers, $GUI_CHECKED)
	Local $cancelButton = MyGuiCtrlCreateButton("取消", 185, 468, 100, 25)
	Local $okButton = MyGuiCtrlCreateButton("完成", 305, 468, 100, 25)

	Local $iENTER = GUICtrlCreateDummy()
	Local $iESC = GUICtrlCreateDummy()
	Local $AccelKeys[2][2] = [["{ENTER}", $iENTER], ["{ESC}", $iESC]]; Set accelerators
	GUISetAccelerators($AccelKeys)

	GUISetState(@SW_SHOW)

	While 1
		Local $msg = GUIGetMsg()

		For $i = 0 To $buildsPartySize-1
			If $msg == $sendButton[$i] Then
				sendBuild(GUICtrlRead($name[$i]), GUICtrlRead($template[$i]), $i+1, GUICtrlRead($showNumbers)==$GUI_CHECKED)
			EndIf
		Next

		Switch $msg
			Case 0
				ContinueLoop
			Case $GUI_EVENT_CLOSE, $cancelButton, $iESC
				ExitLoop

			Case $okButton, $iENTER
				IniWrite($iniFullPath, "builds" & $buildsNo, "buildname", GUICtrlRead($buildName))

				For $i = 0 To $buildsPartySize-1
					IniWrite($iniFullPath, "builds" & $buildsNo, "name"&($i+1), GUICtrlRead($name[$i]))
					IniWrite($iniFullPath, "builds" & $buildsNo, "template"&($i+1), GUICtrlRead($template[$i]))
				Next
				IniWrite($iniFullPath, "builds" & $buildsNo, "showNumbers", GUICtrlRead($showNumbers)==$GUI_CHECKED)

				GUICtrlSetData($buildsLabel[$buildsNo-1], GUICtrlRead($buildName))
				ExitLoop
		EndSwitch
	WEnd

	GUIDelete($teamBuildGui)
	GUISetState(@SW_ENABLE, $mainGui)
	WinActivate($mainGui)
	Opt("GUIOnEventMode", True)
EndFunc   ;==>customTeambuild

; interface button callback
Func sendTeamBuilds()
	For $i = 0 To $buildsNumber
		If @GUI_CtrlId == $buildsLabel[$i] Then Return sendTeamBuild($i+1)
	Next
EndFunc   ;==>sendBuilds

; send a specific teambuild
Func sendTeamBuild($buildsNo, $chat = "#", $delay = 600)
	Local $lName = IniRead($iniFullPath, "builds" & $buildsNo, "buildname", "")
	Local $lShowNumbers = IniRead($iniFullPath, "builds" & $buildsNo, "showNumbers", True)=="True"
	Local $lTemplate
	If ($lName <> "") Then SendChat($lName, $chat)
	Sleep($delay)
	For $i = 1 To $buildsPartySize
		sendBuildIni($buildsNo, $i, $lShowNumbers)
	Next
EndFunc   ;==>sendBuild

; send a specific build (read from ini)
Func sendBuildIni($buildsNo, $partyMember, $showNumbers = True, $chat = "#", $delay = 600)
	Local $lName = IniRead($iniFullPath, "builds" & $buildsNo, "name" & $partyMember, "")
	Local $lTemplate = IniRead($iniFullPath, "builds" & $buildsNo, "template" & $partyMember, "")
	sendBuild($lName, $lTemplate, $partyMember, $showNumbers, $chat, $delay)
EndFunc

; Send a specific build (given)
Func sendBuild($name, $template, $partyMember = 0, $showNumbers = False, $chat = "#", $delay = 600)
	If ($name <> "") Or ($template <> "") Then
		SendChat("[" & ($showNumbers ? ($partyMember & " - ") : "") & $name & ";" & $template & "]", $chat)
		Sleep($delay)
	EndIf
EndFunc