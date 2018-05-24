#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include "GWA2.au3"

Global $maxAllowdEnergy = 70
Global $useScroll = True

;HotKeySet("{home}","toTownPause")

Global $boolRun = False
Global $intRuns = 0
Global $intAdrenaline[7] = [0, 0, 0, 100, 250, 175, 0]
Global $ALE = 5585
Global $AGED_ALE = 24593

Opt("GUIOnEventMode", 1)
$cGUI = GUICreate("GWA² - Kilroy Stonekin", 270, 142, 200, 180)
;$cbxHideGW = GUICtrlCreateCheckbox("Disable Graphics", 10, 8, 105, 17)
$lblRuns = GUICtrlCreateLabel("Total Runs: 0", 115, 9, 132, 17, $SS_CENTER)
GUICtrlCreateLabel("Password:", 8, 32, 80, 17, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$txtPW = GUICtrlCreateInput("", 100, 32, 162, 20, BitOR($ES_CENTER, $ES_AUTOHSCROLL,$ES_PASSWORD))
$cbxPack = GUICtrlCreateCheckbox("Pack", 10, 56, 50, 17)
GUICtrlSetState(-1, $GUI_Checked)
$cbxPouch = GUICtrlCreateCheckbox("Pouch", 75, 56, 50, 17)
GUICtrlSetState(-1, $GUI_Checked)
$cbxBag1 = GUICtrlCreateCheckbox("Bag 1", 140, 56, 50, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$cbxBag2 = GUICtrlCreateCheckbox("Bag 2", 205, 56, 50, 17)
GUICtrlSetState(-1, $GUI_UNCHECKED )
$lblStatus = GUICtrlCreateLabel("Ready to begin", 8, 84, 256, 17, $SS_CENTER)
$btnStart = GUICtrlCreateButton("Start", 7, 108, 256, 25, $WS_GROUP)

GUISetOnEvent($GUI_Event_Close, "EventHandler", $cGUI)
;GUICtrlSetOnEvent($cbxHideGW, "EventHandler")
GUICtrlSetOnEvent($btnStart, "EventHandler")
GUISetState(@SW_SHOW)
While 1
	Sleep(100)
	If $boolRun Then
		GoToTown()
		If CountFreeSpace() Then ContinueLoop
		AdlibRegister ("CrashCheck",500)
		TakeQuest()
		If RunQuest() Then
			GoToTown()
			Update("Energy was too high, run aborted")
			RndSleep(3000)
		EndIf

		$intRuns += 1
		GUICtrlSetData($lblRuns, "Total Runs: " & $intRuns)

		If NOT $boolRun Then
			AdlibUnRegister("CrashCheck")
			Update("Bot paused by user")
			;GUICtrlSetState($txtName, $GUI_Enable)
			GUICtrlSetData($btnStart, "Start")
			GUICtrlSetState($btnStart, $GUI_Enable)
		EndIf
	EndIf
WEnd

Func toTownPause()
	GoToTown()
	MsgBox(0,"","Stopped")
	Exit
EndFunc

Func EventHandler()
	Switch (@GUI_CtrlId)
		Case $btnStart
			Initialize(ProcessExists("gw.exe"),True,True)
			EnsureEnglish(1)
			$boolRun = NOT $boolRun
			If $boolRun Then
				GUICtrlSetData($btnStart, "Pause")
				;GUICtrlSetState($txtName, $GUI_Disable)
			Else
				GUICtrlSetData($btnStart, "BOT WILL HALT AFTER THIS RUN")
				GUICtrlSetState($btnStart, $GUI_Disable)
			EndIf
		;Case $cbxHideGW
		Case $GUI_Event_Close
			Exit
	EndSwitch
EndFunc



Func TakeQuest()
	Do
		Update("Taking quest")
		GoNearestNPCToCoords(17320, -4900)
		RndSleep(250)
		AcceptQuest(856)
		RndSleep(1000)
		GoNPC(GetNearestNPCToCoords(17320, -4900))
		RndSleep(1000)
		Dialog(0x00000085)
		WaitForLoad()
		RndSleep(250)
	Until GetMapID() = 704
EndFunc

Func RunQuest()
	If $useScroll Then UseScroll()
	RndSleep(1500)
	If AggroMoveToEx(-11040, -16400) Then Return 1
	If AggroMoveToEx(-3585, -15915) Then Return 1
	If AggroMoveToEx(-1081, -14387) Then Return 1
	If AggroMoveToEx(3788, -16406) Then Return 1
	MoveTo(5724,-15148)
	MoveTo(5053,-15835)
	Do
		RndSleep(300)
		GetNearestEnemyToAgent(-2)
		$distance = @extended
	Until $distance < 700
	If AggroMoveToEx(8913, -16174) Then Return 1
	If AggroMoveToEx(12900, -16065) Then Return 1

	Update("Opening final chest")
	RndSleep(100)
	$agent = GetNearestSignpostToCoords(13275,-16039)
	ChangeTarget($agent)
	MoveTo(DllStructGetData($agent, 'X'),DllStructGetData($agent, 'Y'))
	RndSleep(500)
	GoSignpost($agent)
	RndSleep(2000)
	Update("Picking up ale")
	PickupItems()
	RndSleep(2000)
	GoToTown()
	Update("Accepting quest reward")
	$count = 0
	Do
		GoNearestNPCToCoords(17320, -4900)
		RndSleep(1000)
		;Dialog(0x00835807)
		QuestReward(856)
		RndSleep(500)
		$count+=1
	Until GetQuestByID(856) = 0 or $count>5
	RndSleep(500)
	$oldRegion = GetRegion()
	Do
		$region = $oldRegion
		If $region = 4294967294 Then $region = -1
		$region += 1
		If $region > 4 Then $region = -2
		ChangeRegion($region)
		RndSleep(1000)
	Until $oldRegion <> GetRegion()
EndFunc

Func Fight($z, $s = "enemies")
	Update("Fighting " & $s & "!")
	RndSleep(500)
	$target = 0
	$distance = 99999999
	;Do
	;	RndSleep(250)
	;	$enemyId = GetNearestAliveEnemyToAgent()
	;Until $enemyId[0] <> 0
	$skillbar = GetSkillbar()
	$bar = 7
	$skillId = DllStructGetData($skillbar, 'Id7')
	If $skillId = 0 Then $bar = 6
	Do
		$skillbar = GetSkillbar()
		$skillRecharge = DllStructGetData($skillbar, 'Recharge8')
		If $skillRecharge = 0 Or GetEnergy() = 0 Then
			Update("Standing back up!")
			Do
				$skillbar = GetSkillbar()
				$Me = GetAgentByID()
				$maxEnergy = DllStructGetData($Me, 'MaxEnergy')
				If $maxEnergy > $maxAllowdEnergy Then Return 1
				If $maxEnergy <> GetEnergy() Then UseSkill(8,$Me)
				$skillRecharge = DllStructGetData($skillbar, 'Recharge8')
				RndSleep(50)
			Until $skillRecharge <> 0
			Update("Fighting " & $s & "!")
		EndIf

		; Update to priority attack Ettins
		$ettinID = GetNearestEttin()
		If $ettinID <> 0 Then
			$Me = GetAgentByID(-2)
			$ettinDistance = ComputeDistance(DllStructGetData($Me, 'X'),DllStructGetData($Me, 'Y'),DllStructGetData($ettinID, 'X'),DllStructGetData($ettinID, 'Y'))
			If $ettinDistance<$z Then
				$target = $ettinID
				$distance = $ettinDistance
			EndIf
		EndIf

		$dead = false
		$target = GetAgentByID(DllStructGetData($target, 'Id'))
		If (DllStructGetData($target, 'HP') < 0.005) Then
			$dead = true
		EndIf
		If DllStructGetData($target, 'Id') = 0 OR $distance > $z OR $dead Then
			$target = GetLowestEnemyToAgent(-2)
			$distance = @extended
			;ConsoleWrite("New target: " & DllStructGetData($target, 'Id') & " distance= " & $distance & " dead=" & $dead  & @CRLF)
		EndIf
		; Update to fight Lt. Maghma last
		If GetAgentName($target) = "Lieutenant Mahgma" Then
			$possibleTarget = GetLowestEnemyToAgentExcludingMaghma()
			$targetDistance = @extended
			If $targetDistance<$z Then
				$target = $possibleTarget
				$distance = $targetDistance
			EndIf
		EndIf

		; Update to use blocking skills
		$block = 0
		$skillbar = GetSkillbar()
		$skillRecharge = DllStructGetData($skillbar, 'Recharge1')
		If $skillRecharge = 0 Then $block = 1

		$useSkill = -1
		For $i = $bar To 2 Step -1
			$recharged = DllStructGetData($skillbar, 'Recharge'& $i)
			$strikes = DllStructGetData($skillbar, 'AdrenalineB'& $i)
			If $recharged = 0 AND $intAdrenaline[$i-1] <= $strikes Then
				$useSkill = $i
				ExitLoop
			EndIf
		Next

		If ($useSkill <> -1 OR $block) AND $target <> 0 AND $distance < $z Then
			ChangeTarget($target)
			RndSleep(150)
			If $dead = True Then
				If DllStructGetData(GetSkillbar(), 'Recharge8') = 0 Or GetEnergy() = 0 Then ContinueLoop
				Attack($target)
			EndIf
			RndSleep(150)
			If $block Then
				If DllStructGetData(GetSkillbar(), 'Recharge8') = 0 Or GetEnergy() = 0 Then ContinueLoop
				UseSkill(1,$target)
				RndSleep(500)
			EndIf
			$skillbar = GetSkillbar()
			If DllStructGetData($skillbar, 'Recharge8') = 0 Or GetEnergy() = 0 Then ContinueLoop
			UseSkill($useSkill,$target)
		EndIf
		RndSleep(500)
		;ConsoleWrite($target & " " & $distance & @CRLF)
	Until DllStructGetData($target, 'Id') = 0 OR $distance > $z

	Update("Picking up items")
	PickupItems(-1,$z * 1.5)
	Return 0
EndFunc

Func IDAndSell()
	Update("Cleaning inventory")
	MoveTo(17967, -7522)
	GoNearestNPCToCoords(17800, -7600)
	If GUICtrlRead($cbxPack) = 1 Then Ident(1)
	If GUICtrlRead($cbxPouch) = 1 Then Ident(2)
	If GUICtrlRead($cbxBag1) = 1 Then Ident(3)
	If GUICtrlRead($cbxBag2) = 1 Then Ident(4)

	;Identify twice to prevent selling unid items
	If GUICtrlRead($cbxPack) = 1 Then Ident(1)
	If GUICtrlRead($cbxPouch) = 1 Then Ident(2)
	If GUICtrlRead($cbxBag1) = 1 Then Ident(3)
	If GUICtrlRead($cbxBag2) = 1 Then Ident(4)

	If GUICtrlRead($cbxPack) = 1 Then Sell(1)
	If GUICtrlRead($cbxPouch) = 1 Then Sell(2)
	If GUICtrlRead($cbxBag1) = 1 Then Sell(3)
	If GUICtrlRead($cbxBag2) = 1 Then Sell(4)
EndFunc

Func CanSell($q, $m)
	If $m = 0 OR $q > 1 Then
		Return False
	ElseIf $m = 146 OR $m = 22751 Then				;Dyes/Lockpicks
		Return False
	ElseIf $m = 2991 OR $m = 2992 Or $m = 2989 Or $m = 5899 Then				;ID/Salvage
		Return False
	ElseIf $m = $ALE OR $m = $AGED_ALE Then				;Dwarven Ale/Aged Dwarven Ale
		Return False
	ElseIf $m = 5594 OR $m = 5595 OR $m = 5611 OR $m = 5853 OR $m = 5975 OR $m = 5976 OR $m = 21233 Then
		Return False
	Else
		Return True
	EndIf
EndFunc

Func GoToTown()
	TravelTo(644)
	RndSleep(1000)
EndFunc

Func Update($text)
	GUICtrlSetData($lblStatus, $text)
EndFunc

Func WaitForLoad($s = "Loading map")
	Local $lMe
	Update($s)
	Do
		Sleep(200)
		$lMe = GetAgentByID(-2)
	Until DllStructGetData($lMe, 'X') <> 0 Or DllStructGetData($lMe, 'Y') <> 0
	RndSleep(4000)
	Update("Load complete")
EndFunc

Func Ident($bagIndex)
	$bag = GetBag($bagIndex)
	For $i = 0 To DllStructGetData($bag, 'slots')-1
		Update("Identifying item: " & $bagIndex & ", " & $i)
		If FindIDKit() = 0 Then
			If GetGoldCharacter() < 500 AND GetGoldStorage() > 499 Then
				WithdrawGold(500)
				Sleep(Random(200,300))
			EndIf
			Do
				BuyIDKit()
				RndSleep(500)
			Until FindIDKit() <> 0
			RndSleep(500)
		EndIf
		$aitem = GetItemBySlot($bagIndex, $i)
		If DllStructGetData($aItem, 'ID') = 0 Then ContinueLoop
		IdentifyItem($aItem)
		Sleep(Random(500,750))
	Next
EndFunc

Func Sell($bagIndex)
	$bag = GetBag($bagIndex)
	$numOfSlots = DllStructGetData($bag, 'slots')-1
	For $i = 0 To $numOfSlots
		Update("Selling item: " & $bagIndex & ", " & $i)
		$item = GetItemBySlot($bagIndex, $i)
		If CanSell( DllStructGetData($item, 'quantity'), DllStructGetData($item, 'ModelID')) Then
			SellItem($item)
		EndIf
		RndSleep(250)
	Next
EndFunc

Func AggroMoveToEx($x, $y, $s = "enemies", $z = 2000)
	Update("Hunting " & $s)

	Move($x, $y)

	$iBlocked = 0
	$cbType = "float"
	Local $coords[2]
	$Me = GetAgentByID()
	$coords[0] = DllStructGetData($Me, 'X')
	$coords[1] = DllStructGetData($Me, 'Y')
	Do
		RndSleep(250)
		$oldCoords = $coords

		$enemy = GetLowestEnemyToAgent(-2)
		$Me = GetAgentByID()
		$distance = ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), DllStructGetData($enemy, 'X'), DllStructGetData($enemy, 'Y'))
		If $distance < $z AND $enemy <> 0 Then
			If Fight($z, $s) Then Return 1
			Update("Hunting " & $s)
		EndIf
		$Me = GetAgentByID()
		$coords[0] = DllStructGetData($Me, 'X')
		$coords[1] = DllStructGetData($Me, 'Y')
		If $oldCoords[0] = $coords[0] AND $oldCoords[1] = $coords[1] Then
			$iBlocked += 1
			Move($coords[0], $coords[1], 1500)
			RndSleep(1500)
			Move($x, $y)
		EndIf
	Until ComputeDistance($coords[0], $coords[1], $x, $y) < 250 OR $iBlocked > 20
	;ConsoleWrite("Reached destination: " & $x & "," & $y & @CRLF)
EndFunc

Func ChangeRegion($aRegion)
	;returns true if successful
	;-2 = international, 0 = america, 1 = asia korean, 2 = europe, 3 = asia chinese, 4 = asia japanese
	If ($aRegion <-1 Or $aRegion >4) And $aRegion <> -2 Then Return False
	If GetRegion() = $aRegion Then Return True
	MoveMap(GetMapID(), $aRegion, 0, GetLanguage());
	Return WaitMapLoading()
EndFunc   ;==>ChangeRegion

Func UseScroll()
	$item = GetItemByModelID(21233)
	If DllStructGetData($item, 'Bag') <> 0 Then
		Update("Using Lightbringer Scroll")
		UseItem($item)
		Return
	EndIf
	$item = GetItemByModelID(5595)
	If DllStructGetData($item, 'Bag') <> 0 Then
		Update("Using Berserkers Insight")
		UseItem($item)
		Return
	EndIf
	$item = GetItemByModelID(5611)
	If DllStructGetData($item, 'Bag') <> 0 Then
		Update("Using Slayers Insight")
		UseItem($item)
		Return
	EndIf
	$item = GetItemByModelID(5594)
	If DllStructGetData($item, 'Bag') <> 0 Then
		Update("Using Heros Insight")
		UseItem($item)
		Return
	EndIf
	$item = GetItemByModelID(5975)
	If DllStructGetData($item, 'Bag') <> 0 Then
		Update("Using Rampagers Insight")
		UseItem($item)
		Return
	EndIf
	$item = GetItemByModelID(5976)
	If DllStructGetData($item, 'Bag') <> 0 Then
		Update("Using Hunters Insight")
		UseItem($item)
		Return
	EndIf
	$item = GetItemByModelID(5853)
	If DllStructGetData($item, 'Bag') <> 0 Then
		Update("Using Adventurers Insight")
		UseItem($item)
		Return
	EndIf
	Update("No scrolls found")
EndFunc

Func CountFreeSpace()
	If CountSlots() < 18 Then
		IDAndSell()
	Else
		Return False
	EndIf

	$gold = GetGoldCharacter()
	If $gold > 75000 Then DepositGold()

	If CountSlots() < 10 Then
		Update("Low on free space")
		$boolRun = False
		;GUICtrlSetState($txtName, $GUI_Enable)
		GUICtrlSetData($btnStart, "Start")
		GUICtrlSetState($btnStart, $GUI_Enable)
		Return True
	EndIf
EndFunc

Func CountSlots()
	$temp = 0

	If GUICtrlRead($cbxPack) = 1 Then
		$bag = GetBag(1)
		$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	EndIf
	If GUICtrlRead($cbxPouch) = 1 Then
		$bag = GetBag(2)
		$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	EndIf
	If GUICtrlRead($cbxBag1) = 1 Then
		$bag = GetBag(3)
		$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	EndIf
	If GUICtrlRead($cbxBag2) = 1 Then
		$bag = GetBag(4)
		$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	EndIf
	Return $temp
EndFunc

Func GoNearestNPCToCoords($x, $y)
	Do
		RndSleep(250)
		$guy = GetNearestNPCToCoords($x, $y)
	Until DllStructGetData($guy, 'Id') <> 0
	ChangeTarget($guy)
	RndSleep(250)
	Move(DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y'))
	GoNPC($guy)
	RndSleep(250)
	Do
		RndSleep(750)
		Move(DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y'))
		GoNPC($guy)
		RndSleep(250)
		$Me = GetAgentByID(-2)
	Until ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y')) < 250
	RndSleep(1000)
EndFunc

Func CrashCheck()
	If WinExists("Gw.exe") Then
		Update("Crashed")
		$GWPath = _ProcessGetLocation(ProcessExists("gw.exe"))
		MemoryClose()
		ProcessClose("gw.exe")
		RndSleep(250)
		Run($GWPath & " -password " & GUICtrlRead($txtPW))
		WinWait("Guild Wars")
		Sleep(2000)
		Global $mLabels[1][2]
		Initialize(ProcessExists("gw.exe"))
		Do
			ControlSend("[CLASS:ArenaNet_Dx_Window_Class]","","","y") ;Send "y" to accept reconnect if you've dced outside. It won't reconnect if you dc'ed in an outpost
			RndSleep(500)
			$me = GetAgentByID(-2)
		Until DllStructGetData($me, 'X') <> 0 Or DllStructGetData($me, 'Y') <> 0
		RndSleep(3000)
		GoToTown()
		MsgBox(0,"Error","Crashed please restart")
		Exit
	EndIf
EndFunc


Func _ProcessGetLocation($iPID)
    Local $aProc = DllCall('kernel32.dll', 'hwnd', 'OpenProcess', 'int', BitOR(0x0400, 0x0010), 'int', 0, 'int', $iPID)
    If $aProc[0] = 0 Then Return SetError(1, 0, '')
    Local $vStruct = DllStructCreate('int[1024]')
    DllCall('psapi.dll', 'int', 'EnumProcessModules', 'hwnd', $aProc[0], 'ptr', DllStructGetPtr($vStruct), 'int', DllStructGetSize($vStruct), 'int_ptr', 0)
    Local $aReturn = DllCall('psapi.dll', 'int', 'GetModuleFileNameEx', 'hwnd', $aProc[0], 'int', DllStructGetData($vStruct, 1), 'str', '', 'int', 2048)
    If StringLen($aReturn[3]) = 0 Then Return SetError(2, 0, '')
    Return $aReturn[3]
EndFunc

Func GetNearestEttin()
	Local $lNearestAgent = 0, $lNearestDistance = 100000000
	Local $lDistance, $lAgentToCompare
	Local $aAgent = GetAgentByID(-2)

	For $i = 1 To GetMaxAgents()
		$lAgentToCompare = GetAgentByID($i)
		If DllStructGetData($lAgentToCompare, 'HP') < 0.005 Or DllStructGetData($lAgentToCompare, 'Allegiance') <> 0x3 Or DllStructGetData($lAgentToCompare, 'Type') <> 0xDB Or GetAgentName($lAgentToCompare) <> "Enslaved Ettin" Then ContinueLoop

		$lDistance = (DllStructGetData($aAgent, 'X') - DllStructGetData($lAgentToCompare, 'X')) ^ 2 + (DllStructGetData($aAgent, 'Y') - DllStructGetData($lAgentToCompare, 'Y')) ^ 2
		If  $lDistance < $lNearestDistance Then
			$lNearestAgent = $lAgentToCompare
			$lNearestDistance = $lDistance
		EndIf
	Next
	Return $lNearestAgent
EndFunc   ;==>GetNearestEttin


Func GetLowestEnemyToAgent($aAgent)
	Local $lNearestAgent = 0, $lNearestDistance = 100000000
	Local $lDistance, $lAgentToCompare
	Local $lLowestHP = 100,$lHP

	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)

	For $i = 1 To GetMaxAgents()
		$lAgentToCompare = GetAgentByID($i)
		$lHP = DllStructGetData($lAgentToCompare, 'HP')
		If $lHP < 0.005 Or DllStructGetData($lAgentToCompare, 'Allegiance') <> 0x3 Or DllStructGetData($lAgentToCompare, 'Type') <> 0xDB Then ContinueLoop

		$lDistance = (DllStructGetData($aAgent, 'X') - DllStructGetData($lAgentToCompare, 'X')) ^ 2 + (DllStructGetData($aAgent, 'Y') - DllStructGetData($lAgentToCompare, 'Y')) ^ 2
		If $lHP<$lLowestHP Or ($lHP=$lLowestHP And $lDistance < $lNearestDistance ) Then
			$lNearestAgent = $lAgentToCompare
			$lNearestDistance = $lDistance
			$lLowestHP = $lHP
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance)) ;this could be used to retrieve the distance also
	Return $lNearestAgent
EndFunc   ;==>GetLowestEnemyToAgent

Func GetLowestEnemyToAgentExcludingMaghma()
	Local $lNearestAgent = 0, $lNearestDistance = 100000000
	Local $lDistance, $lAgentToCompare
	Local $lLowestHP = 100,$lHP
	Local $aAgent = GetAgentByID(-2)

	For $i = 1 To GetMaxAgents()
		$lAgentToCompare = GetAgentByID($i)
		If DllStructGetData($lAgentToCompare, 'HP') < 0.005 Or DllStructGetData($lAgentToCompare, 'Allegiance') <> 0x3 Or DllStructGetData($lAgentToCompare, 'Type') <> 0xDB Or GetAgentName($lAgentToCompare) = "Lieutenant Mahgma" Then ContinueLoop

		$lDistance = (DllStructGetData($aAgent, 'X') - DllStructGetData($lAgentToCompare, 'X')) ^ 2 + (DllStructGetData($aAgent, 'Y') - DllStructGetData($lAgentToCompare, 'Y')) ^ 2
		If $lHP<$lLowestHP Or ($lHP=$lLowestHP And $lDistance < $lNearestDistance ) Then
			$lNearestAgent = $lAgentToCompare
			$lNearestDistance = $lDistance
			$lLowestHP = $lHP
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance)) ;this could be used to retrieve the distance also
	Return $lNearestAgent
EndFunc   ;==>GetLowestEnemyToAgentExcludingMaghma

Func GoGHToTown()
	Do
	TravelGH()
	WaitForLoad()
	RndSleep(2000)
Until GetMapID() <> 0 And GetMapID() <> 644
	Do
	LeaveGH()
	WaitForLoad()
	RndSleep(2000)
	Until GetMapID() = 644
EndFunc

;=================================================================================================
; Function:			PickUpItems($iItems = -1, $fMaxDistance = 1012)
; Description:		PickUp defined number of items in defined area around default = 1012
; Parameter(s):		$iItems:	number of items to be picked
;					$fMaxDistance:	area within items should be picked up
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	On Success - Returns $iItemsPicked (number of items picked)
; Author(s):		GWCA team, recoded by ddarek, thnx to The ArkanaProject
;=================================================================================================
Func PickupItems($iItems = -1, $fMaxDistance = 1012)
	Local $iItemsPicked = 0
	Local $aItemID, $lNearestDistance, $lDistance
	$tDeadlock = TimerInit()
	Do
		$aItem = GetNearestItemToAgent(-2)
		$lDistance = @Extended
		$aItemID = DllStructGetData($aItem, 'ID')
		If $aItemID = 0 Or $lDistance > $fMaxDistance Or TimerDiff($tDeadlock) > 30000 Then ExitLoop
		PickUpItem($aItem)
		$tDeadlock2 = TimerInit()
		Do
			Sleep(500)
		Until DllStructGetData(GetAgentByID($aItemID), 'ID') == 0
		$iItemsPicked += 1
	Until $iItemsPicked = $iItems
EndFunc   ;==>PickupItems

;