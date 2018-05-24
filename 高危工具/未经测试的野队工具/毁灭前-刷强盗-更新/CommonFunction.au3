#include-once

Global $strName = ""
Global $NumberRun = 0, $IDKitBought = 0, $RunSuccess = 0
global $boolrun = False
Global $strName = ""
Global $coords[2]

Global $File = @ScriptDir & "\Trace\Traça du " & @MDAY & "-" & @MON & " a " & @HOUR & "h et " & @MIN & "minutes.txt"

Opt("GUIOnEventMode", 1)

#Region ### START Koda GUI section ### Form=C:\Bot GW\Feather Farm\Storage version\Form1.kxf
Global $win = GUICreate("Status Window Globeul", 274, 270 + 20, 500, 1)
GUICtrlCreateLabel("Globeul", 180, 180-70-30,80)
GUICtrlSetFont(-1, 15)
$Start = GUICtrlCreateButton("Start", 178, 250-90-50, 75, 25, $WS_GROUP)
GUICtrlSetOnEvent(-1, "gui_eventHandler")
GUICtrlCreateGroup("Status: Runs", 275-265, 8, 255, 90-35)
GUICtrlCreateLabel("Total Runs:", 285-265, 28, 70, 17)
global $gui_status_runs = GUICtrlCreateLabel("0", 355-265, 28, 40, 17, $SS_RIGHT)
GUICtrlCreateLabel("Kits Bought:", 410-265, 28, 70, 17)
global $gui_status_kit = GUICtrlCreateLabel("0", 480-265, 28, 40, 17, $SS_RIGHT)
GUICtrlCreateLabel("Successful:", 285-265, 43, 70, 17)
GUICtrlSetColor(-1, 0x008000)
global $gui_status_successful = GUICtrlCreateLabel("0", 355-265, 43, 40, 17, $SS_RIGHT)
GUICtrlSetColor(-1, 0x008000)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Status: Time", 10, 310 - 90 - 75 + 20, 255, 43)
GUICtrlCreateLabel("Total:", 20, 330 - 90 - 75 + 20, 50, 17)
Global $label_stat = GUICtrlCreateLabel("min: 000  sec: 00", 70, 330 - 90 - 75 + 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$txtName = GUICtrlCreateInput($strName, 60, 330 - 90 - 45 + 20, 150 , 20)
GUICtrlCreateGroup("Status: Current Action", 10, 375 - 90 - 65 + 20, 255, 45)
Global $STATUS = GUICtrlCreateLabel("Script not started yet", 20, 390 - 90 - 65 + 20, 235, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetOnEvent($GUI_EVENT_CLOSE, "gui_eventHandler")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

func gui_eventHandler()
	switch (@GUI_CtrlId)
		case $GUI_EVENT_CLOSE
			exit
		case $Start
			$NumberRun = 0
			$IDKitBought = 0
			$RunSuccess = 0
			$boolrun = True

			GUICtrlSetState($Start, $GUI_DISABLE)
			GUICtrlSetState($txtName, $GUI_DISABLE)
			If GUICtrlRead($txtName) = "" Then
				If Initialize(ProcessExists("gw.exe")) = False Then
					MsgBox(0, "Error", "Guild Wars it not running.")
					Exit
				EndIf
			Else
				If Initialize(GUICtrlRead($txtName), "Guild Wars - " & GUICtrlRead($txtName)) = False Then
					MsgBox(0, "Error", "Can't find a Guild Wars client with that character name.")
					Exit
				EndIf
			EndIf
	endswitch
endfunc


Func CurrentAction($MSG)
	GUICtrlSetData($STATUS, $MSG)
	GUICtrlSetData($gui_status_runs, $NumberRun)
	GUICtrlSetData($gui_status_kit, $IDKitBought)
	GUICtrlSetData($gui_status_successful, $RunSuccess)
	FileWriteLine($File, "Run : " & $NumberRun + 1 & " à : " & @Hour & ":" & @MIN & "." & @Sec & "   " & $MSG & @CRLF)
EndFunc   ;==>CurrentAction

Func SellItemToMerchant()
	CurrentAction("Going to merchant")
	MoveTo(-12569, -6312)
	$merchant = GetNearestNPCToCoords(-11467, -6444)
	RNDSLP(1000)
	GoToNPC($merchant)
;~ 	BuyIDKit()
;~ 	$IDKitBought = $IDKitBought + 1
;~ 	RNDSLP(1000)
;~ 	CurrentAction("Ident inventory")
;~ 	Ident(1)
;~ 	Ident(2)
;~ 	Ident(3)
	CurrentAction("Sell inventory")
	Sell(1)
	Sell(2)
	Sell(3)
EndFunc  ;==>SellItemToMerchant

Func IDENT($bagIndex)
	$bag = GetBag($bagIndex)
	For $i = 1 To DllStructGetData($bag, 'slots')
;~ 		If FindIDKit() = 0 Then
			If GetGoldCharacter() < 500 And GetGoldStorage() > 499 Then
				WithdrawGold(500)
				Sleep(Random(200, 300))
			EndIf
			local $J = 0
;~ 			Do
;~ 				BuyIDKit()
;~ 				RndSleep(500)
;~ 				$J = $J+1
;~ 			Until FindIDKit() <> 0 OR $J = 3
			If $J = 3 Then ExitLoop
			RndSleep(500)
;~ 		EndIf
		$aitem = GetItemBySlot($bagIndex, $i)
		If DllStructGetData($aitem, 'ID') = 0 Then ContinueLoop
		IdentifyItem($aitem)
		Sleep(Random(400, 750))
	Next
EndFunc   ;==>IDENT

Func Sell($bagIndex)
	$bag = GetBag($bagIndex)
	$numOfSlots = DllStructGetData($bag, 'slots')
	For $i = 1 To $numOfSlots
		CurrentAction("Selling item: " & $bagIndex & ", " & $i)
		$aitem = GetItemBySlot($bagIndex, $i)
		If DllStructGetData($aitem, 'ID') = 0 Then ContinueLoop
		If CanSell($aitem) Then
			SellItem($aitem)
		EndIf
		RndSleep(250)
	Next
EndFunc   ;==>Sell

Func GetExtraItemInfo($aitem)
    If IsDllStruct($aitem) = 0 Then $aAgent = GetItemByItemID($aitem)
    $lItemExtraPtr = DllStructGetData($aitem, "namestring")

    DllCall($mHandle[0], 'int', 'ReadProcessMemory', 'int', $mHandle[1], 'int', $lItemExtraPtr, 'ptr', $lItemExtraStructPtr, 'int', $lItemExtraStructSize, 'int', '')
    Return $lItemExtraStruct
EndFunc   ;==>GetExtraItemInfo

Func CanSell($aitem)
	local $m = DllStructGetData($aitem, 'ModelID')
	local $i = DllStructGetData($aitem, 'extraId')
	If $m = 0 Then
		Return False
	ElseIf $m > 21785 And $m < 21806 Then ;Elite/Normal Tomes
		Return False
	ElseIf $m = 146 Then
		If $i = 10 OR $i = 12 Then ;black and white
			Return False
		Else
			Return True
		EndIf
	ElseIf $m =  6533 Then
		Return False    ;jade
	ElseIf $m =  19198 Then
		Return False    ;jade
	ElseIf $m =  934 Then
		Return False    ;jade
	ElseIf $m =  929 Then
		Return False    ;jade
	Else
		Return True
	EndIf
EndFunc   ;==>CanSell

Func GoMerchant($id_merchant, $xmerchant, $ymerchant)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance, $lAgentToCompare

	For $i = 1 To GetMaxAgents()
		$lAgentToCompare = GetAgentByID($i)
		If DllStructGetData($lAgentToCompare, 'PlayerNumber') <> $id_merchant then ContinueLoop
		rndslp(150)
		ChangeTarget($lAgentToCompare)
		rndslp(150)
		GoNPC($lAgentToCompare)
		ExitLoop
	Next
	Do
		rndslp(100)
	Until CheckArea($xmerchant, $ymerchant)
	rndslp(2000)
EndFunc

Func StoreGolds()
	GoldIs(1, 20)
	GoldIs(2, 5)
	GoldIs(3, 10)
	GoldIs(4, 10)
EndFunc

Func GoldIs($bagIndex, $numOfSlots)
	For $i = 1 To $numOfSlots
		$aItem = GetItemBySlot($bagIndex, $i)
		ConsoleWrite("Checking items: " & $bagIndex & ", " & $i & @CRLF & DllStructGetData(GetExtraItemInfo($aItem), 'rarity') & @crlf)
		If DllStructGetData($aItem, 'ID') <> 0 And DllStructGetData(GetExtraItemInfo($aItem), 'rarity') = $RARITY_Gold Then
				Do
					For $bag = 8 To 12; Storage panels are form 8 till 16 (I have only standard amount plus aniversary one)
						$slot = FindEmptySlot($bag)
						$slot = @extended
						If $slot <> 0 Then
							$FULL = False
							$nSlot = $slot
							ExitLoop 2; finding first empty $slot in $bag and jump out
						Else
							$FULL = True; no empty slots :(
						EndIf
						Sleep(400)
					Next
				Until $FULL = True
				If $FULL = False Then
					MoveItem($aItem, $bag, $nSlot)
					ConsoleWrite("Gold item moved ...."& @CRLF)
					Sleep(Random(450, 550))
				EndIf
		EndIf
	Next
EndFunc   ;==>GoldIs

Func CheckIfInventoryIsFull()
	If CountSlots() = 0 Then
		return true
	Else
		return false
	EndIf
EndFunc   ;==>CheckIfInventoryIsFull

Func WaitForLoad()
	CurrentAction("Loading zone")
	InitMapLoad()
	$deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100
		$load = GetMapLoading()
		$lMe = GetAgentByID(-2)

	Until $load = 2 And DllStructGetData($lMe, 'X') = 0 And DllStructGetData($lMe, 'Y') = 0 Or $deadlock > 10000

	$deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100

		$deadlock += 100
		$load = GetMapLoading()
		$lMe = GetAgentByID(-2)

	Until $load <> 2 And DllStructGetData($lMe, 'X') <> 0 And DllStructGetData($lMe, 'Y') <> 0 Or $deadlock > 30000
	CurrentAction("Load complete")
	rndslp(3000)
EndFunc   ;==>WaitForLoad

Func CountSlots()
	Local $bag
	Local $temp = 0
	$bag = GetBag(1)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(2)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	Return $temp
EndFunc   ;==>CountSlots


Func AggroMoveToEx($x, $y, $s = "", $z = 1300)

	local $TimerToKill = TimerInit()
	If $DeadOnTheRun = 0 Then CurrentAction("Hunting " & $s)
	$random = 50
	$iBlocked = 0

	If $DeadOnTheRun = 0 Then Move($x, $y, $random)
	$Me = GetAgentByID()
	$coords[0] = DllStructGetData($Me, 'X')
	$coords[1] = DllStructGetData($Me, 'Y')
	If $DeadOnTheRun = 0 Then
		Do
			If $DeadOnTheRun = 0 Then RndSleep(250)
			$oldCoords = $coords

			$enemy = GetNearestEnemyToAgent(-2)
			$distance = ComputeDistance(DllStructGetData($enemy, 'X'),DllStructGetData($enemy, 'Y'),DllStructGetData(GetAgentByID(-2), 'X'),DllStructGetData(GetAgentByID(-2), 'Y'))
			If $distance < $z AND $enemy <> 0 and $DeadOnTheRun = 0 Then
				If $DeadOnTheRun = 0 Then Fight($z, $s)
				If $DeadOnTheRun = 0 Then CurrentAction("Hunting " & $s)
			EndIf
			If $DeadOnTheRun = 0 Then RndSleep(250)
			$Me = GetAgentByID()
			$coords[0] = DllStructGetData($Me, 'X')
			$coords[1] = DllStructGetData($Me, 'Y')
			If $oldCoords[0] = $coords[0] AND $oldCoords[1] = $coords[1] and $DeadOnTheRun = 0 Then
				$iBlocked += 1
				If $DeadOnTheRun = 0 Then MoveTo($coords[0], $coords[1], 300)
				If $DeadOnTheRun = 0 Then RndSleep(350)
				If $DeadOnTheRun = 0 Then Move($x, $y)
			EndIf

		Until ComputeDistance($coords[0], $coords[1], $x, $y) < 250 OR $iBlocked > 20 or $DeadOnTheRun = 1
	EndIf
	$TimerToKillDiff = TimerDiff($TimerToKill)
	$Text = StringFormat("min: %03u  sec: %02u ", $TimerToKillDiff/1000/60, Mod($TimerToKillDiff/1000,60))
	FileWriteLine($File, $s & " en ================================== >   " & $Text & @CRLF)
EndFunc

Func Fight($x, $s = "enemies")
	Local $lastId = 99999, $coordinate[2],$timer
	If $DeadOnTheRun = 0 Then CurrentAction("Fighting " & $s & " !")
	If $DeadOnTheRun = 0 Then
		Do
			$Me = GetAgentByID(-2)
			$energy = GetEnergy()
			$skillbar = GetSkillbar()
			$useSkill = -1
			If $DeadOnTheRun = 0 Then
				For $i = 0 To 7
					$recharged = DllStructGetData($skillbar, 'Recharge' & ($i + 1))
					$strikes = DllStructGetData($skillbar, 'AdrenalineA' & ($i + 1))
					If $recharged = 0 AND $intSkillEnergy[$i] <= $energy  AND $strikes >= ($intSkillAdrenaline[$i]*25 - 25)Then
						$useSkill = $i + 1
						ExitLoop
					EndIf
				Next
			EndIf

			$target = GetNearestEnemyToAgent(-2)
			$distance = ComputeDistance(DllStructGetData($target, 'X'),DllStructGetData($target, 'Y'),DllStructGetData(GetAgentByID(-2), 'X'),DllStructGetData(GetAgentByID(-2), 'Y'))
			If $useSkill <> -1 AND $target <> 0 AND $distance < $x AND $DeadOnTheRun = 0 Then
				If DllStructGetData($target, 'Id') <> $lastId Then
					If $DeadOnTheRun = 0 Then ChangeTarget($target)
					If $DeadOnTheRun = 0 Then RndSleep(150)
					If $DeadOnTheRun = 0 Then CallTarget($target)
					If $DeadOnTheRun = 0 Then RndSleep(150)
					If $DeadOnTheRun = 0 Then Attack($target)
					$lastId = DllStructGetData($target, 'Id')
					$coordinate[0] = DllStructGetData($target, 'X')
					$coordinate[1] = DllStructGetData($target, 'Y')
					$timer = TimerInit()
					If $DeadOnTheRun = 0 Then
						Do
							Move($coordinate[0],$coordinate[1])
							rndsleep(500)
							$Me = GetAgentByID(-2)
							$distance = ComputeDistance($coordinate[0],$coordinate[1],DllStructGetData($Me, 'X'),DllStructGetData($Me, 'Y'))
						Until $distance < 1100 or TimerDiff($timer) > 10000 Or $DeadOnTheRun = 1
					EndIf
				EndIf
				If $DeadOnTheRun = 0 Then RndSleep(150)
				$timer = TimerInit()
				If $DeadOnTheRun = 0 Then
					Do
						$target = GetNearestEnemyToAgent(-2)
						$distance = ComputeDistance(DllStructGetData($target, 'X'),DllStructGetData($target, 'Y'),DllStructGetData(GetAgentByID(-2), 'X'),DllStructGetData(GetAgentByID(-2), 'Y'))
						If $distance < 1250 Then
							If $DeadOnTheRun = 0 Then UseSkill($useSkill, $target)
							If $DeadOnTheRun = 0 Then RndSleep(500)
						EndIf
						If $DeadOnTheRun = 0 Then Attack($target)
						$Me = GetAgentByID(-2)
						$target = GetAgentByID(DllStructGetData($target, 'Id'))
						$coordinate[0] = DllStructGetData($target, 'X')
						$coordinate[1] = DllStructGetData($target, 'Y')
						$distance = ComputeDistance($coordinate[0],$coordinate[1],DllStructGetData($Me, 'X'),DllStructGetData($Me, 'Y'))
					Until DllStructGetData(GetSkillbar(), 'Recharge' & $useSkill) >0 or DllStructGetData($target, 'HP') < 0.005 Or $distance > $x Or TimerDiff($timer) > 5000 Or $DeadOnTheRun = 1
				EndIf
			EndIf
			$target = GetNearestEnemyToAgent(-2)
			$distance = ComputeDistance(DllStructGetData($target, 'X'),DllStructGetData($target, 'Y'),DllStructGetData(GetAgentByID(-2), 'X'),DllStructGetData(GetAgentByID(-2), 'Y'))
		Until DllStructGetData($target, 'ID') = 0 OR $distance > $x Or $DeadOnTheRun = 1
	EndIf
	If $DeadOnTheRun = 0 Then
		If CountSlots() = 0 then
			CurrentAction("Inventory full")
		Else
			CurrentAction("Picking up items")
			PickupItems(-1, $x)
		EndIf
	EndIf
EndFunc


;~ Func AggroMoveToEx($x, $y, $s = "", $z = 1450)
;~ 	local $TimerToKill = TimerInit()
;~ 	CurrentAction("Hunting " & $s)
;~ 	$random = 50
;~ 	$iBlocked = 0

;~ 	If $DeadOnTheRun = 0 Then Move($x, $y, $random)

;~ 	$lMe = GetAgentByID(-2)
;~ 	$coordsX =DllStructGetData($lMe, "X")
;~ 	$coordsY = DllStructGetData($lMe, "Y")

;~ 	If $DeadOnTheRun = 0 Then
;~ 		Do
;~ 			rndslp(50)
;~ 			If $DeadOnTheRun = 1 Then ExitLoop
;~ 			;If $DeadOnTheRun = 0 Then RndSlp(250) //////
;~ 			$oldCoordsX = $coordsX
;~ 			$oldCoordsY = $coordsY
;~ 			$nearestenemy = GetNearestEnemyToAgent(-2)
;~ 			$lDistance = GetDistance($nearestenemy, -2)
;~ 			If $DeadOnTheRun = 1 Then ExitLoop
;~ 			If $lDistance > $z AND DllStructGetData($nearestenemy, 'ID') <> 0 AND $DeadOnTheRun = 0 Then
;~ 				$coordinateX = DllStructGetData($nearestenemy, 'X')
;~ 				$coordinateY = DllStructGetData($nearestenemy, 'Y')
;~ 				$timer = TimerInit()
;~ 				Do
;~ 					Move($coordinateX,$coordinateY)
;~ 					rndsleep(500)
;~ 					$Me = GetAgentByID(-2)
;~ 					$distance = ComputeDistance($coordinateX,$coordinateY,DllStructGetData($Me, 'X'),DllStructGetData($Me, 'Y'))
;~ 				Until $distance < 1000 or TimerDiff($timer) > 10000
;~ 			EndIf
;~ 			If $lDistance < $z AND DllStructGetData($nearestenemy, 'ID') <> 0 AND $DeadOnTheRun = 0 Then
;~ 			;If $lDistance < $z AND DllStructGetData($nearestenemy, 'ID') <> 0 Then
;~ 				If $DeadOnTheRun = 0 Then Fight($z, $s)
;~ 				If $DeadOnTheRun = 0 Then CurrentAction("Hunting " & $s)
;~ 			EndIf
;~ 			;If $DeadOnTheRun = 0 Then RndSlp(250) /////
;~ 			$lMe = GetAgentByID(-2)
;~ 			$coordsX =DllStructGetData($lMe, "X")
;~ 			$coordsY = DllStructGetData($lMe, "Y")
;~ 			If $oldCoordsX = $coordsX AND $oldCoordsY = $coordsY Then
;~ 				$iBlocked += 1
;~ 				If $DeadOnTheRun = 0 Then Move($coordsX, $coordsY, 500)
;~ 				If $DeadOnTheRun = 0 Then RndSlp(350)
;~ 				If $DeadOnTheRun = 0 Then Move($x, $y, $random)
;~ 			EndIf
;~ 		Until ComputeDistanceEx($coordsX, $coordsY, $x, $y) < 250 OR $iBlocked > 20 OR $DeadOnTheRun = 1
;~ 	EndIf
;~ 	$TimerToKillDiff = TimerDiff($TimerToKill)
;~ 	$Text = StringFormat("min: %03u  sec: %02u ", $TimerToKillDiff/1000/60, Mod($TimerToKillDiff/1000,60))
;~ 	FileWriteLine($File, $s & " en ================================== >   " & $Text & @CRLF)
;~ EndFunc

;~ Func Fight($x, $s = "enemies")
;~ 	If $DeadOnTheRun = 0 Then
;~ 		local $TimerToGetOut = TimerInit()
;~ 		Do
;~ 			If $DeadOnTheRun = 0 Then $useSkill = -1
;~ 			If $DeadOnTheRun = 0 Then $target = GetNearestEnemyToAgent(-2)
;~ 			;$target = GetNearestEnemyToAgent(GetHeroID(7))
;~ 			$distance = GetDistance($target, -2)
;~ 			If DllStructGetData($target, 'ID') <> 0 AND $distance < $x AND $DeadOnTheRun = 0 Then
;~ 				If $DeadOnTheRun = 0 Then ChangeTarget($target)
;~ 				If $DeadOnTheRun = 0 Then RndSlp(150)
;~ 				If $DeadOnTheRun = 0 Then CallTarget($target)
;~ 				If $DeadOnTheRun = 0 Then RndSlp(150)
;~ 				If $DeadOnTheRun = 0 Then Attack($target)
;~ 				If $DeadOnTheRun = 0 Then RndSlp(150)
;~ 			ElseIf DllStructGetData($target, 'ID') = 0 OR $distance > $x OR $DeadOnTheRun = 1 Then
;~ 				exitloop
;~ 			EndIf
;~ 			If $DeadOnTheRun = 0 Then
;~ 				For $i = 0 To $totalskills

;~ 					$targetHP = DllStructGetData(GetCurrentTarget(),'HP')
;~ 					if $targetHP = 0 then ExitLoop

;~ 					$distance = GetDistance($target, -2)
;~ 					if $distance > $x then ExitLoop

;~ 					$TargetAllegiance = DllStructGetData(GetCurrentTarget(),'Allegiance')
;~ 					if $TargetAllegiance = 0x1 OR $TargetAllegiance = 0x4 OR $TargetAllegiance = 0x5 OR $TargetAllegiance = 0x6 Then ExitLoop

;~ 					$TargetIsDead = DllStructGetData(GetCurrentTarget(), 'Effects')
;~ 					If $TargetIsDead = 0x0010 Then ExitLoop

;~ 					$TargetItem = DllStructGetData(GetCurrentTarget(),'Type')
;~ 					if $TargetItem = 0x400 then ExitLoop

;~ 					$energy = GetEnergy(-2)
;~ 					$recharge = DllStructGetData(GetSkillBar(), "Recharge" & $i+1)
;~ 					$adrenaline = DllStructGetData(GetSkillBar(), "Adrenaline" & $i+1)

;~ 					If $recharge = 0 And $energy >= $intSkillEnergy[$i] And $adrenaline >= ($intSkillAdrenaline[$i]*25 - 25) Then
;~ 						$useSkill = $i + 1
;~ 						;PingSleep(250)
;~ 						$variabletosort = 0
;~ 						;UseSkill($useSkill, $target)
;~ 						UseSkill($useSkill, $target)
;~ 						RndSlp($intSkillCastTime[$i]+500)
;~ 					EndIf
;~ 					if $i = $totalskills then $i = -1 ; change -1
;~ 					If $DeadOnTheRun = 1 Then ExitLoop
;~ 				Next
;~ 			EndIf
;~ 			$TargetAllegiance = DllStructGetData(GetCurrentTarget(),'Allegiance')
;~ 			$TargetIsDead = DllStructGetData(GetCurrentTarget(), 'Effects')
;~ 			$targetHP = DllStructGetData(GetCurrentTarget(),'HP')
;~ 			$TargetItem = DllStructGetData(GetCurrentTarget(),'Type')
;~ 		Until DllStructGetData($target, 'ID') = 0 OR $distance > $x OR $DeadOnTheRun = 1 OR $TargetAllegiance = 0x1 OR $TargetAllegiance = 0x4 OR $TargetAllegiance = 0x5 OR $TargetAllegiance = 0x6 OR $TargetIsDead = 0x0010 OR $targetHP = 0 OR $TargetItem = 0x400 OR TimerDiff($TimerToGetOut) > 240000
;~ 		PickupItems(-1, $x)
;~ 	EndIf
;~ EndFunc