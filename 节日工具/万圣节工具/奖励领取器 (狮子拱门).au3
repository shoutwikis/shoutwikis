#NoTrayIcon
#include-once
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>
#include <Math.au3>

#include "常数.au3"
#include "../../激战接口.au3"

Opt("MustDeclareVars", True)
Opt("GUIOnEventMode", True)

Global $boolInitialized = False
Global $boolRunning = False

Global $lastDistrict = -1
Global $Rendering = True

Global Const $MainGui = GUICreate("刷骷髅 - 领奖励", 172, 190)
	GUICtrlCreateLabel("刷骷髅 - 领奖励", 8, 6, 156, 17, $SS_CENTER)
	Global Const $inputCharName = GUICtrlCreateCombo("", 8, 24, 150, 22)
		GUICtrlSetData(-1, GetLoggedCharNames())
   Global Const $cbxHideGW = GUICtrlCreateCheckbox("停止成像", 8, 48)
   Global Const $cbxOnTop = GUICtrlCreateCheckbox("置窗口于前", 8, 68)
	Global Const $lblLog = GUICtrlCreateLabel("", 8, 130, 154, 30)
	Global Const $btnStart = GUICtrlCreateButton("开始", 8, 162, 154, 25)

GUICtrlSetOnEvent($btnStart, "EventHandler")
GUICtrlSetOnEvent($cbxOnTop, "EventHandler")
GUICtrlSetOnEvent($cbxHideGW, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")
GUISetState(@SW_SHOW)

Do
	Sleep(100)
Until $boolInitialized

If GetMapID() <> $LA_ID Then
	TravelTo($LA_ID)
EndIf

If DllStructGetData(GetQuestByID($EVERY_BIT_HELPS), "ID") <> 0 Then
	AbandonQuest($EVERY_BIT_HELPS)
	Sleep(GetPing()+100)
EndIf

While 1
	If $boolRunning Then
		If GetGoldCharacter() >= 97*1000  Then
		   If GetGoldStorage() < 900*1000 Then
				DepositGold(_Min(1000*1000 - GetGoldStorage(), 100*1000))
			Else
				EctoBuy()
			EndIf
		 EndIf

		MergeStackLeftOver($MODEL_ID_CAPTURED_SKELETON, 3)

		Out("走向游戏人物")
		MoveTo(5240, 9082)

		Local $Steward = GetNearestNPCToCoords(5332, 9048)

		Sleep(100)
		GoNPC($Steward)
		Sleep(400)
		Out("接任务")
		AcceptQuest($EVERY_BIT_HELPS)
		Sleep(400)
		Out("领奖励")
		QuestReward($EVERY_BIT_HELPS)

		Sleep(2050);3500, 2750
		Out("换区")
		Local $lDistrict = nextRandomDis()
		MoveMap($LA_ID, $lRegion[$lDistrict], 0, $lLanguage[$lDistrict])
		WaitMapLoading($LA_ID) ; zone, wait 2.5 sec at the end

	Else
		Sleep(100)
	EndIf
WEnd


Func nextRandomDis()
	Local $tmp
	While 1
		$tmp = Random(1, 11, 1)
		If $tmp <> $lastDistrict Then
			$lastDistrict = $tmp
			Return $tmp
		EndIf
	WEnd
EndFunc

Func EventHandler()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			Exit
		Case $cbxHideGW
			ClearMemory()
			ToggleRendering()
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
					If Initialize("", True, True, True) = False Then	; don't need string logs or event system ;ProcessExists("gw.exe")
						MsgBox(0, "Error", "Guild Wars it not running.")
						Exit
					EndIf
				Else
					If Initialize(GUICtrlRead($inputCharName), True, True, True) = False Then ; don't need string logs or event system
						MsgBox(0, "Error", "Can't find a Guild Wars client with that character name.")
						Exit
					EndIf
				EndIf
				GUICtrlSetData($btnStart, "暂停")
				GUICtrlSetState($btnStart, $GUI_ENABLE)
				$boolInitialized = True
			EndIf
		Case $cbxOnTop
			WinSetOnTop($MainGui, "", GUICtrlRead($cbxOnTop)==$GUI_CHECKED)
	EndSwitch
EndFunc

Func ToggleRendering()
	If $Rendering Then
		DisableRendering()
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
		ClearMemory()
	Else
		EnableRendering()
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
	EndIf
	$Rendering = Not $Rendering
EndFunc

Func Out($aString)
	Local $timestamp = "[" & @HOUR & ":" & @MIN & "] "
	GUICtrlSetData($lblLog, $timestamp & $aString)
 EndFunc   ;==>Out


 Func EctoBuy()
	Local $EctoID = 930
	If GetGoldCharacter() > 97000 Then
		Sleep(GetPing()+200)
		MoveTo(7536, 5859)

		Local $Trader = GetNearestNPCToCoords(7527, 5773)

;		$Trader = GetAgentByName("Argus[Rare Material Trader]")
		GOTONPC($Trader)
		TraderRequest($EctoID)
		Sleep(GetPing()+1000)
		While GetGoldCharacter() > 20*1000
			TraderRequest($EctoID)
			Sleep(GetPing()+100)
			TraderBuy()
		WEnd
	EndIf
 EndFunc   ;==>EctoBuy


 #Region ToT Storage
 Func StoreTricks()
	TrickOrTreat(1, 20)
	TrickOrTreat(2, 10)
	TrickOrTreat(3, 15)
	TrickOrTreat(4, 15)
 EndFunc

Func TrickOrTreat($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To $NUMOFSLOTS

		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)

		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop

		$M = DllStructGetData($AITEM, "ModelID")

		$Q = DllStructGetData($AITEM, "quantity")

		If $M = 28434 And $Q = 250 Then
			Do
				For $BAG = 8 To 12
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(Random(450, 550))
			EndIf
		EndIf
	Next
EndFunc

Func FINDEMPTYSLOT($BAGINDEX)
	Local $LITEMINFO, $ASLOT
	For $ASLOT = 1 To DllStructGetData(GETBAG($BAGINDEX), "Slots")

		Sleep(40)

		$LITEMINFO = GETITEMBYSLOT($BAGINDEX, $ASLOT)

		If DllStructGetData($LITEMINFO, "ID") = 0 Then
			SetExtended($ASLOT)
			ExitLoop
		EndIf
	Next
	Return 0
EndFunc
#cs
Func COUNTSLOTS($ANUMBAGS = 4)
	Local $LFREESLOTS = 0
	Local $LBAGSLOTS = 0
	For $i = 1 To $ANUMBAGS
		$LBAGSLOTS = DllStructGetData(GETBAG($i), "slots")
		$LFREESLOTS += $LBAGSLOTS
		For $SLOT = 1 To $LBAGSLOTS
			If DllStructGetData(GETITEMBYSLOT($i, $SLOT), "ModelID") <> 0 Then
				$LFREESLOTS -= 1
			EndIf
		Next
	Next
	Return $LFREESLOTS
EndFunc   ;==>COUNTSLOTS
#ce
#EndRegion Store Tots