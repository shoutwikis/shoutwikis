#NoTrayIcon
#include-once
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>

#include "常数.au3"
#include "../../激战接口.au3"

Opt("GUIOnEventMode", True)

Global $boolInitialized = False
Global $boolRunning = False
Global Const $SleepTime = 470 ;毫秒

Global Const $MainGui = GUICreate("刷骷髅 - 节日袋点击器", 172, 190)
	GUICtrlCreateLabel("刷骷髅 - 节日袋点击器", 8, 6, 156, 17, $SS_CENTER)
	Global Const $inputCharName = GUICtrlCreateInput("", 8, 24, 150, 22)
	Global Const $lblLog = GUICtrlCreateLabel("", 8, 130, 154, 30)
	Global Const $btnStart = GUICtrlCreateButton("开始", 8, 162, 154, 25)

GUICtrlSetOnEvent($btnStart, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")
GUISetState(@SW_SHOW)

Do
	Sleep(100)
Until $boolInitialized

While 1
	If $boolRunning Then
		RapeATot()
	Else
		Sleep(250)
	EndIf
WEnd

Func RapeATot()
	For $bag=1 To 4
		For $slot=1 To DllStructGetData(GetBag($bag), 'Slots')
			Local $item = GetItemBySlot($bag, $slot)
			If DllStructGetData($item, 'ModelID') == $MODEL_ID_TOT_BAGS Then
				For $i=1 To DllStructGetData($item, 'Quantity')

					UseItem($item)
					RndSleep($SleepTime)
				Next
				Return
			EndIf
		Next
	Next
EndFunc

Func EventHandler()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnStart
			If $boolRunning Then
				GUICtrlSetData($btnStart, "继续")
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
					If Initialize(ProcessExists("gw.exe"), True, False, False) = False Then
						MsgBox(0, "失败", "激战未开.")
						Exit
					EndIf
				Else
					If Initialize(GUICtrlRead($inputCharName), True, False, False) = False Then
						MsgBox(0, "失败", "角色失寻.")
						Exit
					EndIf
				EndIf
				GUICtrlSetData($btnStart, "暂停")
				GUICtrlSetState($btnStart, $GUI_ENABLE)
				$boolInitialized = True
			EndIf

	EndSwitch
 EndFunc

Func Out($aString)
	Local $timestamp = "[" & @HOUR & ":" & @MIN & "] "
	GUICtrlSetData($lblLog, $timestamp & $aString)
 EndFunc