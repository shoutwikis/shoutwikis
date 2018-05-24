#NoTrayIcon
#include-once
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>

#include "常数.au3"
#include "../../激战接口.au3"

Opt("MustDeclareVars", True)
Opt("GUIOnEventMode", True)

Global $boolInitialized = False
Global $boolRunning = False


Global Const $MainGui = GUICreate("刷骷髅 - 囤积笼子", 172, 190)
	GUICtrlCreateLabel("刷骷髅 - 囤积笼子", 8, 6, 156, 17, $SS_CENTER)
	Global Const $inputCharName = GUICtrlCreateCombo("", 8, 24, 150, 22)
		GUICtrlSetData(-1, GetLoggedCharNames())
	Global Const $lblLog = GUICtrlCreateLabel("", 8, 130, 154, 30)
	Global Const $btnStart = GUICtrlCreateButton("开始", 8, 162, 154, 25)

GUICtrlSetOnEvent($btnStart, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")
GUISetState(@SW_SHOW)

Do
	Sleep(100)
Until $boolInitialized

If GetMapID() <> $LA_ID Then
	TravelTo($LA_ID)
EndIf

MoveTo(5240, 9082)

Global $Steward = GetNearestNPCToCoords(5332, 9048)

GoNPC($Steward)

Sleep(250)


If DllStructGetData(GetQuestByID($EVERY_BIT_HELPS), "ID") <> 0 Then
	AbandonQuest($EVERY_BIT_HELPS)
	Sleep(GetPing()+100)
EndIf

While 1
	If $boolRunning Then
		AcceptQuest($EVERY_BIT_HELPS)
		Sleep(GetPing()+600)
		AbandonQuest($EVERY_BIT_HELPS)
		Sleep(GetPing()+600)
	Else
		Sleep(250)
	EndIf
WEnd

Func EventHandler()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnStart
			If $boolRunning Then
				GUICtrlSetState($btnStart, $GUI_DISABLE)
				$boolRunning = False
			ElseIf $boolInitialized Then
				GUICtrlSetData($btnStart, "暂停")
				$boolRunning = True
			Else
				$boolRunning = True
				GUICtrlSetData($btnStart, "启动...")
				GUICtrlSetState($btnStart, $GUI_DISABLE)
				GUICtrlSetState($inputCharName, $GUI_DISABLE)
				WinSetTitle($MainGui, "", GUICtrlRead($inputCharName))
				If GUICtrlRead($inputCharName) = "" Then
					If Initialize(ProcessExists("gw.exe"), True, False, False) = False Then	; don't need string logs or event system
						MsgBox(0, "失败", "激战未开")
						Exit
					EndIf
				Else
					If Initialize(GUICtrlRead($inputCharName), True, False, False) = False Then ; don't need string logs or event system
						MsgBox(0, "失败", "角色失去寻")
						Exit
					EndIf
				EndIf
				GUICtrlSetData($btnStart, "暂停")
				GUICtrlSetState($btnStart, $GUI_ENABLE)
				$boolInitialized = True
			EndIf

	EndSwitch
EndFunc