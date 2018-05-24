#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <TabConstants.au3>
#include <ComboConstants.au3>
#include "../../激战接口.au3"

Global $BotRunning = False
Global $Runs = 0
Global $BoolRun = False
Global $Rendering = True
Global $FirstRun = True
Global $ntokens = 0

Const $Rock = 13
Const $Paper = 64
Const $Scissors = 198
Const $DialogID = 0x84

$mainGui = GUICreate("猜拳工具", 145, 120)
$Input = GUICtrlCreateCombo("", 8, 8, 129, 21, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL, $ES_CENTER))
GUICtrlSetData(-1, GetLoggedCharNames())
GUICtrlCreateLabel("所剩年代币:", 8, 35, 70, 17)
$EventItemLabel = GUICtrlCreateLabel($ntokens, 80, 35, 50, 17)
GUICtrlSetBkColor(-1, -2)
GUICtrlCreateLabel("次数:", 8, 50, 70, 17)
$RunsLabel = GUICtrlCreateLabel($Runs, 80,50, 50, 17)
GUICtrlSetBkColor(-1, -2)
$Checkbox = GUICtrlCreateCheckbox("不成像", 8, 65, 120, 17)
$Button = GUICtrlCreateButton("开始", 8, 85, 131, 25)
GUISetState(@SW_SHOW)

Opt("GUIOnEventMode", 1)
GUICtrlSetOnEvent($Button, "EventHandler")
GUICtrlSetOnEvent($Checkbox, "EventHandler")
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
				TravelTo(55)
			Else
				GUICtrlSetData($Button, "开始")
				$BotRunning = False
			EndIf
	    Case $Checkbox
			If $mGWProcHandle <> 0 Then ToggleRendering()
	    Case $GUI_EVENT_CLOSE
			If Not $Rendering Then ToggleRendering()
			Exit
	EndSwitch
 EndFunc

While 1
   If Not $BotRunning Then ContinueLoop
   If Not CountTokens() Then
	  Exit MsgBox(0x40030, '完毕', '年代币已耗尽')
   EndIf
   If $FirstRun = True Then
	  GoNearestNPCToCoords(4890, 10280)
	  $Firstrun = False
   EndIf
   Local $Target = GetAgentByID(-1)
   GoNPC($Target)
   Sleep(Random(400, 500, 1))
   Dialog($DialogID)
   $Runs += 1
   GUICtrlSetData($Runslabel, $runs)
   Local $NpcAnimation
   Local $StuckTimer = TimerInit()
   Do
	  Sleep(50)
	  $Target = GetAgentByID(-1)
	  $NpcAnimation = DllStructGetData($Target, 'ModelAnimation')
	  If TimerDiff($StuckTimer) > 320000 Then ExitLoop
   Until $NpcAnimation == $Rock
   If TimerDiff($StuckTimer) > 320000 Then ContinueLoop
   Local $LastAnimation, $PlayTimer = TimerInit()
   Do
	  Sleep(50)
	  $Target = GetAgentByID(-1)
	  Local $bLastAnimation = DllStructGetData($Target, 'ModelAnimation')
	  If $bLastAnimation == $Rock Or $bLastAnimation == $Paper Or $bLastAnimation == $Scissors Then
		 $LastAnimation = $bLastAnimation
	  EndIf
   Until TimerDiff($PlayTimer) > Random(8400, 8600, 1)
   Switch $LastAnimation
	  Case $Rock
		 SendChat('paper', '/')
	  Case $Paper
		 SendChat('scissors', '/')
	  Case $Scissors
		 SendChat('rock', '/')
   EndSwitch
   Do
	  $Target = GetAgentByID(-1)
	  $NpcAnimation = DllStructGetData($Target, 'ModelAnimation')
	  If TimerDiff($StuckTimer) > 320000 Then ExitLoop
	  Sleep(50)
   Until $NpcAnimation <> $Rock And $NpcAnimation <> $Paper And $NpcAnimation <> $Scissors
   If TimerDiff($StuckTimer) > 320000 Then ContinueLoop
   $Playtimer = TimerInit()
   Do
	  Sleep(50)
   Until TimerDiff($PlayTimer) > Random(4900, 5100, 1)
WEnd

Func CountTokens()
   Local $aBag, $aItem, $nTokens
   Const $LunarTokens = 21833

   For $b = 1 To 4
	  $aBag = GetBag($b)
	  For $s = 1 To DllStructGetData($aBag, 'Slots')
		 $aItem = GetItemBySlot($b, $s)
		 If DllStructGetData($aItem, 'ModelID') == $LunarTokens Then
			$nTokens += DllStructGetData($aItem, 'Quantity')
		 EndIf
		 GUICtrlSetData($EventItemLabel, $ntokens - 1)
	  Next
   Next
   Return $nTokens
EndFunc

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

Func ToggleRendering()
	If $Rendering Then
		DisableRendering()
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
		$Rendering = False
	Else
		EnableRendering()
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
		$Rendering = True
	EndIf
EndFunc

While Not $BotRunning
	Sleep(100)
 WEnd