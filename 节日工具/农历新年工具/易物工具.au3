#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <TabConstants.au3>
#include <ComboConstants.au3>
#include "../../激战接口.au3"

Global $BotRunning = False
Global $BoolRun = False

$mainGui = GUICreate("易物", 258, 300)
$Input = GUICtrlCreateCombo("", 8, 8, 240, 21, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL, $ES_CENTER))
GUICtrlSetData(-1, GetLoggedCharNames())

Local $rLabel = GUICtrlCreateLabel("输入上交物型号", 8, 40, 240, 17)
GUICtrlSetTip($rLabel, "默认为年代币型号"&@CRLF&"如需帮助，则在下方打勾，让工具自动填写型号")
Local $rawMat = GUICtrlCreateInput("21833", 8, 60, 240, 17)
GUICtrlSetTip($rawMat, "默认为年代币型号"&@CRLF&"如需帮助，则在下方打勾，让工具自动填写型号")

Local $tLabel = GUICtrlCreateLabel("输入对象物型号", 8, 90, 240, 17)
GUICtrlSetTip($tLabel, "默认为狗年锦囊的型号"&@CRLF&"如需帮助，则在下方打勾，让工具自动填写型号")
Local $targetMat = GUICtrlCreateInput("29435", 8, 110, 240, 17)
GUICtrlSetTip($targetMat, "默认为狗年锦囊的型号"&@CRLF&"如需帮助，则在下方打勾，让工具自动填写型号")

Local $raLabel = GUICtrlCreateLabel("输入兑换比率", 8, 140, 240, 17)
GUICtrlSetTip($raLabel, "默认为 3. 即，3年代币 换 1锦囊")
Local $ratio = GUICtrlCreateInput("3", 8, 160, 240, 17)
GUICtrlSetTip($ratio, "默认为 3. 即，3年代币 换 1锦囊")

Local $tCheckBox = GUICtrlCreateCheckbox("让工具自动填写型号。 见下方二则说明", 8, 190, 240, 20)
Local $cBoxLabel = GUICtrlCreateLabel("(须事先将上交物摆入角色的第一包第一格)", 8, 215, 240, 17)
Local $cBoxLabel2 = GUICtrlCreateLabel("(须事先将对象物摆入角色的第一包第二格)", 8, 235, 240, 17)

$Button = GUICtrlCreateButton("开始", 8, 265, 240, 25)
GUICtrlSetTip($Button, "启动前，先行与相关游戏人物对话")
GUISetState(@SW_SHOW)

Opt("GUIOnEventMode", 1)
GUICtrlSetOnEvent($Button, "EventHandler")

GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")

Func EventHandler()
	Switch (@GUI_CtrlId)
		Case $Button
			$boolRun = Not $boolRun
			If $boolRun Then
				$BotRunning = true
				If GUICtrlRead($Input) = "" Then
					If Initialize(ProcessExists("gw.exe"), True, True, False) = False Then
						MsgBox(0, "故障", "激战未打开")
						Exit
					EndIf
				Else
					If Initialize(GUICtrlRead($Input), True, True, False) = False Then
						MsgBox(0, "故障", "激战角色失寻")
						Exit
					EndIf
				EndIf
				GUICtrlSetData($Button, "停止")
				GUICtrlSetState($Button, $GUI_ENABLE)
				GUICtrlSetState($Input, $GUI_DISABLE)
			 Else
				GUICtrlSetData($Button, "开始")
				$BotRunning = False
			 EndIf
		 Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
 EndFunc

While 1
   If Not $BotRunning Then ContinueLoop

   if _IsChecked($tCheckBox) then
	  GUICtrlSetData($rawMat, DllStructGetData(GetItemBySlot(1, 1), 'ModelID'))
	  GUICtrlSetData($targetMat, DllStructGetData(GetItemBySlot(1, 2), 'ModelID'))
	  GuiCtrlSetState($tCheckBox, $GUI_UNCHECKED)
   EndIf

   while 1
	  CollectItem(GUICtrlRead($rawMat), GUICtrlRead($ratio), GUICtrlRead($targetMat))
	  MergeStackLeftOver(GUICtrlRead($rawMat), GUICtrlRead($ratio))
	  sleep(250)
   wend
WEnd

Func GoNearestNPCToCoords($x, $y)
	Local $guy, $Me
	Do
		RndSleep(250)
		$guy = GetNearestNPCToCoords($x, $y)
	Until DllStructGetData($guy, 'Id') <> 0
	ChangeTarget($guy)
	RndSleep(250)
	GoNPC($guy)
	RndSleep(250)
	Do
		RndSleep(500)
		Move(DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y'), 40)
		RndSleep(500)
		GoNPC($guy)
		RndSleep(250)
		$Me = GetAgentByID(-2)
	Until ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y')) < 250
	RndSleep(1000)
EndFunc

Func _IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

While Not $BotRunning
	Sleep(100)
 WEnd