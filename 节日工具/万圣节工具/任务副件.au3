#include-once
#include "常数.au3"
#include "../../激战接口.au3"

Global $boolRunning = False
Global $boolInitialized = False
Global $Rendering = True

Global Const $USED_CITY = $CHANTRY_ID
Global Const $POSITION_NEAR_AVATAR = $POSITION_NEAR_AVATAR_CHANTRY
Global Const $POSITION_AVATAR = $POSITION_AVATAR_CHANTRY

Global $runs = 0
Global $fails = 0

Func EventHandler()
	Switch (@GUI_CtrlId)
		Case $btnStart
			If $boolRunning Then
				GUICtrlSetData($btnStart, "此轮过后暂停")
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
					If Initialize("", True, True, True) = False Then
						MsgBox(0, "提示", "激战未开")
						Exit
					EndIf
				Else
					If Initialize(GUICtrlRead($inputCharName), True, True, True) = False Then
						MsgBox(0, "提示", "角色失寻")
						Exit
					EndIf
				EndIf
				GUICtrlSetData($btnStart, "暂停")
				GUICtrlSetState($btnStart, $GUI_ENABLE)
				$boolInitialized = True
			EndIf

		Case $cbxHideGW
			ClearMemory()
			ToggleRendering()

		Case $cbxOnTop
			WinSetOnTop($MainGui, "", GUICtrlRead($cbxOnTop)==$GUI_CHECKED)

		Case $GUI_EVENT_CLOSE
			Exit
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
EndFunc

Func MapCheckToa()
	If GetMapID() <> $TOA_ID Then
		Out("前往世纪")
		TravelTo($TOA_ID)
	EndIf
EndFunc

Func MapCheckZinKu()
	If GetMapID() <> $Zin_Ku_Corridor_ID Then
		Out("前往辛库走廊")
		TravelTo($Zin_Ku_Corridor_ID)
	EndIf
EndFunc

Func MapCheckChantry()
	If GetMapID() <> $USED_CITY Then
		Out("前往隐密教堂")
		TravelTo($USED_CITY)
	EndIf
EndFunc

Func PickUpLoot()
    Local $lAgent
	Local $lMe
	Local $lBlockedTimer
	Local $lBlockedCount = 0
	Local $lItemExists = True

	For $i = 1 To GetMaxAgents()

		$lMe = GetAgentByID(-2)

		If DllStructGetData($lMe, 'HP') <= 0.0 Then Return -1

		$lAgent = GetAgentByID($i)
		local $tAgentID = DllStructGetData($lAgent, 'Id')
		If Not GetIsMovable($lAgent) Then ContinueLoop
		If Not GetCanPickUp($lAgent) Then ContinueLoop

		Local $lItem = GetItemByAgentID($i)

		If CanPickUp($lItem) Then
			Out("正在拾起 " & GetAgentName($lAgent))
			Do

				PickUpItem($tAgentID)
				Sleep(GetPing())
				Do
					Sleep(100)

					$lMe = GetAgentByID(-2)

				Until DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0

				$lBlockedTimer = TimerInit()
				Do
					Sleep(3)
					$lItemExists = IsDllStruct(GetAgentByID($i))

				Until Not $lItemExists Or TimerDiff($lBlockedTimer) > Random(5000, 7500, 1)
				If $lItemExists Then $lBlockedCount += 1
			Until Not $lItemExists Or $lBlockedCount > 5
		EndIf
	Next
EndFunc

Func CanPickUp($aItem)

	Local $m = DllStructGetData($aItem, 'ModelID')

	Local $c = DllStructGetData($aItem, 'ExtraID')

	If ($m == 146 And ($c == 10 Or $c == 12 )) Then ;Black and White Dye
		Return True
	ElseIf $m == 3746 Or $m == 930 Or $m == 937 Or $m == 938 Then ;UW Scrolls and Ectos
		Return True
	Else
		Return False
	EndIf
EndFunc

Func GetCallerID()

	For $j=1 To 5

		Local $lAgentArray = GetAgentArray(0xDB)

		For $i = 1 To $lAgentArray[0]

			If DllStructGetData($lAgentArray[$i], 'Allegiance') == 1 and _
				DllStructGetData($lAgentArray[$i], 'Secondary') == $PROF_DERVISH and _
				DllStructGetData($lAgentArray[$i], 'Primary') == $PROF_ASSASSIN Then

				Return DllStructGetData($lAgentArray[$i], 'ID')

			EndIf
		Next
	Next
	WriteChat("提示: 领队角色/账号失寻")
	Return -1
EndFunc

Func GetSkeleID()

	For $j=1 To 5

		Local $lAgentArray = GetAgentArray(0xDB)

		Local $lMe = GetAgentByID(-2)

		Local $lSkeleID = -1
		Local $lClosestSkeleDistance = 25000000
		For $i = 1 To $lAgentArray[0]

			If DllStructGetData($lAgentArray[$i], 'PlayerNumber') == $MODELID_SKELETON_OF_DHUUM Then

				Local $lDistance = GetPseudoDistance($lMe, $lAgentArray[$i])
				If $lDistance < $lClosestSkeleDistance Then

					$lSkeleID = DllStructGetData($lAgentArray[$i], "ID")
					$lClosestSkeleDistance = $lDistance
				EndIf
			EndIf
		Next
	Next
	If $lSkeleID == -1 Then WriteChat("提示: 地下骷髅失寻")
	Return $lSkeleID
EndFunc

Func WaitForPartyWipe()
	Local $lDeadlock = TimerInit()
	Local $everyoneDead
	Do
		Sleep(1000)
		$everyoneDead = True
		Local $lParty = GetParty()
		For $i=1 To $lParty[0]
			If Not GetIsDead($lParty[$i]) Then
				$everyoneDead = False
			EndIf
		Next

		If TimerDiff($lDeadlock) > 10*1000 Then Resign()

		If TimerDiff($lDeadlock) > 70*1000 Then ExitLoop
	Until $everyoneDead == True
EndFunc

Func UpdateStatistics()
	$runs += 1
	GUICtrlSetData($lblRunsCount, $runs)
	GUICtrlSetData($lblFailsCount, $fails)
EndFunc

Func WaitMapLoadingNoDeadlock($aMapID = 0, $aSleep = 1500)
	Local $lMapLoading

	InitMapLoad()

	Do
		Sleep(200)
		$lMapLoading = GetMapLoading()
	Until $lMapLoading <> 2 And GetMapIsLoaded() And (GetMapID() == $aMapID Or $aMapID == 0)

	RndSleep($aSleep)

	Return True
EndFunc