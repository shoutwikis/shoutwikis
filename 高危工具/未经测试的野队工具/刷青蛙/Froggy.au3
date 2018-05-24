#include-once
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "GWA².au3"
#include "GWAAddsOn.au3"


Global $client = "Guild Wars - Globeul Froggy Farm"
WinSetTitle("Guild Wars", "", $client)
If WinExists($client) Then
	Initialize(WinGetProcess($client))
Else
	MsgBox("", "", "Erreur, existe pas ...")
	Exit
EndIf

Opt("GUIOnEventMode", 1)
Global $boolRun = False
Global $File = @ScriptDir & "\Trace\Traça du " & @MDAY & "-" & @MON & " a " & @HOUR & "h et " & @MIN & "minutes.txt"
Global $NumberRun = 0
Global $GWA_CONST_SUCCOR = 308
Global $GWA_CONST_SPOREEXPLOSIONS = 2496
Global $TargetHeroToBuff = 7
Global $HeroWhoGotBond = 6
Global $SkillSlotOnHero6 = 8
Global $GWA_CONST_UnyieldingAura = 268
Global $UseClovers = 0
Global $WeAreDead = 0
Global $DeadParty = 0
Global $NumberOfWipe = 0
Global $enemy, $iBlocked




Global $win = GUICreate("Status Window Globeul", 274, 270, 500, 1)
GUICtrlCreateLabel("Globeul", 190, 180 - 70 - 30, 50)
GUICtrlSetFont(-1, 15)
$btnStart = GUICtrlCreateButton("Start", 178, 250 - 90 - 50, 75, 25, $WS_GROUP)
GUICtrlCreateGroup("Status: Runs", 275 - 265, 8, 255, 90 - 35)
GUICtrlCreateLabel("Total Runs:", 285 - 265, 28, 70, 17)
Global $gui_status_runs = GUICtrlCreateLabel("0", 355 - 265, 28, 40, 17, $SS_RIGHT)
GUICtrlCreateLabel("Num Of Wipe:", 410 - 265, 28, 70, 17)
Global $gui_status_wipe = GUICtrlCreateLabel("0", 480 - 265, 28, 40, 17, $SS_RIGHT)
GUICtrlCreateLabel("Successful:", 285 - 265, 43, 70, 17)
GUICtrlSetColor(-1, 0x008000)
Global $gui_status_successful = GUICtrlCreateLabel("0", 355 - 265, 43, 40, 17, $SS_RIGHT)
GUICtrlSetColor(-1, 0x008000)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Status: Items", 275 - 265, 235 - 132 - 35, 150, 195 - 80 - 40)
GUICtrlCreateLabel("Item:", 285 - 265, 255 - 132 - 35, 27, 17)
GUICtrlCreateLabel("Number:", 380 - 265, 255 - 132 - 35, 40, 17)
GUICtrlCreateLabel("Gold", 285 - 265, 285 - 132 - 35, 70, 17)
GUICtrlSetColor(-1, 0x808000)
Global $gui_status_gold_label = GUICtrlCreateLabel("0", 370 - 265, 285 - 132 - 35, 40, 17, $SS_RIGHT)
GUICtrlSetColor(-1, 0x808000)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Status: Time", 10, 310 - 90 - 75, 255, 60)
GUICtrlCreateLabel("Total:", 20, 330 - 90 - 75, 50, 17)
Global $label_stat = GUICtrlCreateLabel("min: 000  sec: 00", 70, 330 - 90 - 75)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Status: Current Action", 10, 375 - 90 - 75, 255, 55)
Global $STATUS = GUICtrlCreateLabel("Script not started yet", 20, 390 - 90 - 75, 235, 35)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)

GUICtrlSetOnEvent($btnStart, "EventHandler")
Global $TimerTotal = TimerInit()
AdlibRegister("status", 1000)
FileOpen($File)

While 1
	Sleep(100)
	If $boolRun = True Then
		$WeAreDead = 0
		$NumberRun = $NumberRun + 1
		$UseClovers = 0
		$DeadParty = 0
		GoOutside()
		RunningToDungeon()
		If $WeAreDead = 0 Then Firstlvl()
		If $WeAreDead = 0 Then Secondlvl()
		If Not $boolRun Then
			Update("Bot was paused")
		EndIf
	EndIf
WEnd

Func status()
	$time = TimerDiff($TimerTotal)
	$string = StringFormat("min: %03u  sec: %02u ", $time / 1000 / 60, Mod($time / 1000, 60))
	GUICtrlSetData($label_stat, $string)
	GUICtrlSetData($gui_status_runs, $NumberRun)
	GUICtrlSetData($gui_status_wipe, $NumberOfWipe)
EndFunc   ;==>status

Func Update($text)
	GUICtrlSetData($STATUS, $text)
	FileWriteLine($File, "Run : " & $NumberRun & " à : " & @HOUR & ":" & @MIN & "." & @SEC & "   " & $text & @CRLF)
EndFunc   ;==>Update

Func EventHandler()
	Switch (@GUI_CtrlId)
		Case $btnStart
			$boolRun = Not $boolRun
			If $boolRun = True Then
				ConsoleWrite("Check point 1" & @CRLF)
				GUICtrlSetData($btnStart, "Stop")
			Else
				ConsoleWrite("Check point 2" & @CRLF)
				GUICtrlSetData($btnStart, "BOT WILL HALT AFTER THIS RUN")
				GUICtrlSetState($btnStart, $GUI_DISABLE)
			EndIf
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
EndFunc   ;==>EventHandler

Func Running()
	If DllStructGetData(GetSkillbar(), 'Recharge6') = 0 And DllStructGetData(GetAgentByID(-2), 'EnergyPercent') >= 0.45 Then
		UseSkill(6, 0)
		RndSleep(500)
	EndIf
	If DllStructGetData(GetSkillbar(), 'Recharge4') = 0 And DllStructGetData(GetAgentByID(-2), 'EnergyPercent') >= 0.45 Then
		UseSkill(4, 0)
	EndIf
	If DllStructGetData(GetSkillbar(), 'Recharge8') = 0 And DllStructGetData(GetAgentByID(-2), 'EnergyPercent') >= 0.45 Then
		UseSkill(8, 0)
	EndIf
EndFunc   ;==>Running

Func CheckPartyDead()
	$DeadParty = 0
	For $i = 1 To GetHeroCount()
		If GetIsDead(GetHeroID($i)) = True Then
			$DeadParty += 1
		EndIf
		If $DeadParty >= 6 Then
			$DeadOnTheRun = 1
			Update("We Wipe, Waiting For Rez")
		EndIf
	Next
EndFunc   ;==>CheckPartyDead

Func HeroBuff()
	$mSkillBar = GetSkillbar(7)
	$mHeroInfo = GetAgentByID(GetHeroID(7))
	If DllStructGetData($mSkillBar, 'Recharge1') == 0 And GetIsDead($mHeroInfo) == False Then
		UseHeroSkill(7, 1)
	EndIf
	$mSkillBar = GetSkillbar(6)
	$mHeroInfo = GetAgentByID(GetHeroID(6))
	$mHeroInfo2 = GetAgentByID(GetHeroID(7))
	If GetIsTargetBuffed($GWA_CONST_SUCCOR, GetHeroID($TargetHeroToBuff), $HeroWhoGotBond) == 0 And DllStructGetData($mSkillBar, 'Recharge8') == 0 And GetIsDead($mHeroInfo) == False And GetIsDead($mHeroInfo2) == False Then
		UseHeroSkill($HeroWhoGotBond, $SkillSlotOnHero6, GetHeroID($TargetHeroToBuff))
	EndIf
	$mSkillBar = GetSkillbar(3)
	$mHeroInfo = GetAgentByID(GetHeroID(3))
	If GetIsTargetBuffed($GWA_CONST_UnyieldingAura, GetHeroID(3), 3) == 0 And DllStructGetData($mSkillBar, 'Recharge1') == 0 And GetIsDead($mHeroInfo) == False Then
		UseHeroSkill(3, 1, GetHeroID(3))
	EndIf
EndFunc   ;==>HeroBuff

Func Clovers()
	$PlayerLife = DllStructGetData(GetAgentByID(-2), 'MaxHP')
	$HeroLife1 = DllStructGetData(GetAgentByID(GetHeroID(1)), 'MaxHP')
	$HeroLife2 = DllStructGetData(GetAgentByID(GetHeroID(2)), 'MaxHP')
	$HeroLife3 = DllStructGetData(GetAgentByID(GetHeroID(3)), 'MaxHP')
	$HeroLife4 = DllStructGetData(GetAgentByID(GetHeroID(4)), 'MaxHP')
	$HeroLife5 = DllStructGetData(GetAgentByID(GetHeroID(5)), 'MaxHP')
	$HeroLife6 = DllStructGetData(GetAgentByID(GetHeroID(6)), 'MaxHP')
	$HeroLife7 = DllStructGetData(GetAgentByID(GetHeroID(7)), 'MaxHP')
	If $PlayerLife < 350 And $PlayerLife <> 0 Then
		$UseClovers = 1
	ElseIf $HeroLife1 < 350 And $HeroLife1 <> 0 Then
		$UseClovers = 1
	ElseIf $HeroLife2 < 350 And $HeroLife2 <> 0 Then
		$UseClovers = 1
	ElseIf $HeroLife3 < 350 And $HeroLife3 <> 0 Then
		$UseClovers = 1
	ElseIf $HeroLife4 < 350 And $HeroLife4 <> 0 Then
		$UseClovers = 1
	ElseIf $HeroLife5 < 350 And $HeroLife5 <> 0 Then
		$UseClovers = 1
	ElseIf $HeroLife6 < 350 And $HeroLife6 <> 0 Then
		$UseClovers = 1
	ElseIf $HeroLife7 < 350 And $HeroLife7 <> 0 Then
		$UseClovers = 1
	EndIf
	If $UseClovers = 1 Then
		For $i = 0 To 6
			$aItem = GetItemBySlot(4, 1)
			UseItem($aItem)
			rndslp(400)
		Next
		$UseClovers = 0
	EndIf
EndFunc   ;==>Clovers

Func IfGotBlock($x, $y)
	If $iBlocked > 14 Then
		RNDSLP(1000)
		MoveTo($x, $y)
		If $iBlocked > 14 Then
			RNDSLP(1000)
			MoveTo($x, $y)
			If $iBlocked > 14 Then
				$WeAreDead = 1
			EndIf
		EndIf
	EndIf
EndFunc   ;==>IfGotBlock

Func GoOutside()
	Update("Going to gadd")
	Do
		RndSlp(500)
		If GetMapID() <> 638 Then
			TravelTo(638)
			WaitForLoad()
		EndIf
	Until (CheckArea(-9488, -24420) Or CheckArea(-10287, -21653) Or CheckArea(-8832, -22215)) And GetMapID() = 638
	rndslp(5000)
	Update("Gadd loaded")
	Update("HM")
	SwitchMode(1)
	rndslp(500)
	Update("Abandon quest")
	AbandonQuest(802)
	Update("Going outside")
	If CheckArea(-9488, -24420) Then
		MoveTo(-9756, -22408)
	ElseIf CheckArea(-10287, -21653) Then
		MoveTo(-9718, -20931)
	ElseIf CheckArea(-8832, -22215) Then
		MoveTo(-9472, -21404)
	EndIf
	Move(-9520, -19809)
	Move(-9520, -19809)
	Move(-9520, -19809)
	WaitForLoad()
	Update("End Loading Map")
	rndslp(5000)
EndFunc   ;==>GoOutside

Func TransfertGH()
	TravelGH()
	$timer = TimerInit()
	Do
		Local $t = 0
		RndSlp(300)
		Update("Loading going gh")
		If TimerDiff($timer) > 30000 Then
			TravelGH()
			$t = 1
			$timer = TimerInit()
		EndIf
	Until CheckArea(-584, 7426) Or $t = 1
	Update("GH load")
	RNDSLP(9000)
	LeaveGH()
	$timer = TimerInit()
	Do
		RndSlp(300)
		Update("Loading leaving gh")
		If TimerDiff($timer) > 30000 Then
			TravelGH()
			$timer = TimerInit()
		EndIf
	Until CheckArea(-10287, -21653) Or CheckArea(-8832, -22215) Or CheckArea(-9488, -24420)
	Update("Outpost load")
	RNDSLP(9000)
EndFunc   ;==>TransfertGH

Func WaitForLoad()
	Update("Loading zone")
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
	Update("Load complete")
EndFunc   ;==>WaitForLoad

Func Firstlvl()
	MoveTo(15211, 1588) ; a test de pas les mettres
	MoveTo(14938, 3299)
	MoveTo(17096, 5494)
	AdlibRegister("Running", 1000)
	AdlibRegister("HeroBuff", 5000)
	AdlibRegister("Clovers", 10000)

	$enemy = "First to kill"
	AggroMoveToEx2(17096, 5494, $enemy, 2000)
	MoveTo(17114, 8175)

	$enemy = "2 First Boss Group"
	AggroMoveToEx2(13799, 11138, $enemy)

	$enemy = "Big Room 1"
	AggroMoveToEx2(5942, 7449, $enemy)
	MoveTo(4280, 6328)

	$enemy = "Group near shrine"
	AggroMoveToEx2(5455, 2723, $enemy)

	$enemy = "Big Party With Boss"
	AggroMoveToEx2(976, -1489, $enemy)

	$enemy = "Group on the disease way"
	AggroMoveToEx2(-1289, -5495, $enemy)

	$enemy = "Group on the disease way 1"
	AggroMoveToEx2(-104, -8341, $enemy)

	$enemy = "Group on the disease way 2"
	AggroMoveToEx2(2043, -11431, $enemy)

	$enemy = "Group near gate"
	AggroMoveToEx2(1582, -15289, $enemy)

	$enemy = "Group near gate"
	AggroMoveToEx2(7134, -17106, $enemy)

	AdlibUnRegister("Running")
	AdlibUnRegister("HeroBuff")
	AdlibUnRegister("Clovers")
	Move(7679, -19540)
	Update("Loading second lvl")
	WaitForLoad()
	Update("Loaded")
EndFunc   ;==>Firstlvl

Func Secondlvl()
	RndSlp(5000)
	AdlibRegister("Running", 1000)
	AdlibRegister("HeroBuff", 5000)
	AdlibRegister("Clovers", 10000)
	AdlibRegister("CheckPartyDead", 500)
	Do
		$DeadOnTheRun = 0
		If $DeadOnTheRun = 0 Then $enemy = "Pass lagon"
		If $DeadOnTheRun = 0 Then AggroMoveToEx2(-8937, 311, $enemy)

		If $DeadOnTheRun = 0 Then $enemy = "Begin Incubus"
		If $DeadOnTheRun = 0 Then AggroMoveToEx2(-6272, 3193, $enemy)

		If $DeadOnTheRun = 0 Then $enemy = "Continue Incubus"
		If $DeadOnTheRun = 0 Then AggroMoveToEx2(-4210, 5479, $enemy)

		If $DeadOnTheRun = 0 Then $enemy = "Continue Incubus 1"
		If $DeadOnTheRun = 0 Then AggroMoveToEx2(-2968, 7549, $enemy)

		If $DeadOnTheRun = 0 Then $enemy = "Continue Incubus 2"
		If $DeadOnTheRun = 0 Then AggroMoveToEx2(-480, 8281, $enemy)

		If $DeadOnTheRun = 0 Then $enemy = "Shrine"
		If $DeadOnTheRun = 0 Then AggroMoveToEx2(-145, 10806, $enemy)
		If $DeadOnTheRun = 1 Then RndSlp(15000)
		If $DeadOnTheRun = 1 Then $NumberOfWipe = $NumberOfWipe + 1
	Until CheckArea(-145, 10806) Or CheckArea(-832, 11096)
	$DeadOnTheRun = 0

	Do
		$DeadOnTheRun = 0
		If $DeadOnTheRun = 0 Then $enemy = "Begin sable"
		If $DeadOnTheRun = 0 Then AggroMoveToEx2(2975, 12718, $enemy)

		If $DeadOnTheRun = 0 Then $enemy = "Finish sable"
		If $DeadOnTheRun = 0 Then AggroMoveToEx2(5827, 11499, $enemy)

		If $DeadOnTheRun = 0 Then $enemy = "Begin Frog first group"
		If $DeadOnTheRun = 0 Then AggroMoveToEx2(8159, 6031, $enemy)
		If $DeadOnTheRun = 1 Then RndSlp(15000)
		If $DeadOnTheRun = 1 Then $NumberOfWipe = $NumberOfWipe + 1
	Until CheckArea(8159, 6031)
	$DeadOnTheRun = 0

	MoveTo(8698, 1228)

	Do
		$DeadOnTheRun = 0
		If $DeadOnTheRun = 0 Then $enemy = "Boss group for key"
		If $DeadOnTheRun = 0 Then AggroMoveToEx2(9771, -1758, $enemy)
		If $DeadOnTheRun = 0 Then MoveTo(9771, -1758)
		If $DeadOnTheRun = 0 Then Update("Grabbing Key")
		If $DeadOnTheRun = 0 Then PickupItems(-1, 3000)

		If $DeadOnTheRun = 0 Then $enemy = "Killing Way 1"
		If $DeadOnTheRun = 0 Then AggroMoveToEx2(11831, -6275, $enemy)


		If $DeadOnTheRun = 0 Then $enemy = "Killing Way 2"
		If $DeadOnTheRun = 0 Then AggroMoveToEx2(17740, -6150, $enemy)
		If $DeadOnTheRun = 1 Then RndSlp(15000)
		If $DeadOnTheRun = 1 Then $NumberOfWipe = $NumberOfWipe + 1
	Until CheckArea(17740, -6150)
	$DeadOnTheRun = 0

	$Door = GetNearestSignpostToAgent(-2)
	GoSignpost($Door)

	rndslp(2000)
	$timerdoor = TimerInit()
	Local $key = 0
	MoveTo(18073, -8102)
	Do
		rndslp(200)
		If TimerDiff($timerdoor) > 15000 Then
			$Door = GetNearestSignpostToAgent(-2)
			GoSignpost($Door)
			rndslp(5000)
			$timerdoor = TimerInit()
			MoveTo(18073, -8102)
			$key = $key + 1
		EndIf
		If $key = 5 Then
			MoveTo(12145, -6241)
			MoveTo(9822, -3238)
			;place 1
			MoveTo(9413, -824)
			PickupItems(-1, 1020)
			;place 2
			MoveTo(10833, -1112)
			PickupItems(-1, 1020)
			;place 3
			MoveTo(10338, -2398)
			PickupItems(-1, 1020)
			;place 4
			MoveTo(9123, -2130)
			PickupItems(-1, 1020)
			;going back
			MoveTo(11371, -5783)
			MoveTo(17740, -6150)
			$Door = GetNearestSignpostToAgent(-2)
			GoSignpost($Door)
			rndslp(2000)
			MoveTo(18073, -8102)
			$key = 0
		EndIf
	Until checkarea(18073, -8102)


	Update("shrine and boss")

	MoveTo(17977, -9137)
	MoveTo(16664, -11272)
	MoveTo(19379, -11745)
	MoveTo(14582, -15226)
	Do
		$DeadOnTheRun = 0
		If $DeadOnTheRun = 0 Then Update("Pulling First Group")
		If $DeadOnTheRun = 0 Then $enemy = "First Group"
		AdlibUnRegister("Running")
		If $DeadOnTheRun = 0 Then PullGroup(14971, -15652, 15089, -16120)

		If $DeadOnTheRun = 0 Then Update("Pulling Second Group")
		If $DeadOnTheRun = 0 Then $enemy = "Second Group"
		If $DeadOnTheRun = 0 Then PullGroup(13739, -16407, 13646, -17387)

		If $DeadOnTheRun = 0 Then CancelAll()
		If $DeadOnTheRun = 0 Then AdlibRegister("Running", 2000)
		If $DeadOnTheRun = 0 Then $enemy = "Boss And Chest"
		If $DeadOnTheRun = 0 Then AggroMoveToEx2(15090, -19292, $enemy, 3000)
		If $DeadOnTheRun = 1 Then RndSlp(15000)
		If $DeadOnTheRun = 1 Then $NumberOfWipe = $NumberOfWipe + 1
	Until CheckArea(15090, -19292)
	$DeadOnTheRun = 0

	Update("Getting Chest :D")

	;MoveTo(15153, -19216) ; soit moveto, soit getnearestsignposttocoord
	$Chest = GetNearestSignpostToCoords(15090, -19292) ; mettre les coordonée du coffre, sinon coffre trop proche = pas de drop
	GoSignpost($Chest)

	RndSlp(10000)

;~ 	$Chest = GetNearestSignpostToAgent(-2)
;~ 	GoSignpost($Chest)

;~ 	RndSlp(5000)

	PickUpItems(-1, 1020)

	rndslp(2000)
	Update("Drop Other Than Gold Items From Inventory")
	DropFromInventory(1, 20)
	DropFromInventory(2, 5)
	DropFromInventory(3, 10)
	rndslp(2000)
	AdlibUnRegister("Running")
	AdlibRegister("HeroBuff")
	AdlibUnRegister("Clovers")
	AdlibUnRegister("CheckPartyDead")
EndFunc   ;==>Secondlvl

Func DropFromInventory($bagIndex, $numOfSlots)
	For $i = 1 To $numOfSlots
		$aItem = GetItemBySlot($bagIndex, $i)
		If DllStructGetData($aItem, 'ID') = 0 Then ContinueLoop
		If DllStructGetData(GetExtraItemInfo($aItem), 'rarity') <> $RARITY_Gold Then DropItem($aItem)
		Sleep(Random(400, 550))
	Next
EndFunc   ;==>DropFromInventory

Func GetExtraItemInfo($aitem)
    If IsDllStruct($aitem) = 0 Then $aAgent = GetItemByItemID($aitem)
    $lItemExtraPtr = DllStructGetData($aitem, "namestring")

    DllCall($mHandle[0], 'int', 'ReadProcessMemory', 'int', $mHandle[1], 'int', $lItemExtraPtr, 'ptr', $lItemExtraStructPtr, 'int', $lItemExtraStructSize, 'int', '')
    Return $lItemExtraStruct
EndFunc   ;==>GetExtraItemInfo

Func PullGroup($xhero, $yhero, $xplace, $yplace)
	CommandAll($xhero, $yhero);CommandAll(14949, -15732)
	ChangeWeaponSet(4) ; switch sur arc
	rndslp(750)
	MoveTo($xplace, $yplace)
	$target = GetNearestEnemyToAgent(-2)
	ChangeTarget($target)
	RndSlp(150)
	CallTarget($target)
	RndSlp(150)
	Attack($target)
	Local $TimerToPull = TimerInit()
	Do
		rndslp(100)
		$target = GetNearestEnemyToAgent(-2)
		$distance = GetDistance($target, -2)
	Until $distance < 1000 Or TimerDiff($TimerToPull) > 20000
	MoveTo($xhero, $yhero)
	ChangeWeaponSet(2)
	CancelAll()
	AggroMoveToEx2($xhero, $yhero)
EndFunc   ;==>PullGroup

Func AggroMoveToEx2($x, $y, $s = "", $z = 1450)
	Local $TimerToKill = TimerInit()
	Update("Hunting " & $s)
	$random = 50
	$iBlocked = 0

	If $DeadOnTheRun = 0 Then Move($x, $y, $random)

	$lMe = GetAgentByID(-2)
	$coordsX = DllStructGetData($lMe, "X")
	$coordsY = DllStructGetData($lMe, "Y")

	If $DeadOnTheRun = 0 Then
		Do
			If $DeadOnTheRun = 1 Then ExitLoop
			;If $DeadOnTheRun = 0 Then RndSlp(250) //////
			$oldCoordsX = $coordsX
			$oldCoordsY = $coordsY
			$nearestenemy = GetNearestEnemyToAgent(-2)
			$lDistance = GetDistance($nearestenemy, -2)
			If $DeadOnTheRun = 1 Then ExitLoop
			If $lDistance < $z And DllStructGetData($nearestenemy, 'ID') <> 0 And $DeadOnTheRun = 0 Then
				;If $lDistance < $z AND DllStructGetData($nearestenemy, 'ID') <> 0 Then
				If $DeadOnTheRun = 0 Then Fight($z, $s)
			EndIf
			;If $DeadOnTheRun = 0 Then RndSlp(250) /////
			$lMe = GetAgentByID(-2)
			$coordsX = DllStructGetData($lMe, "X")
			$coordsY = DllStructGetData($lMe, "Y")
			If $oldCoordsX = $coordsX And $oldCoordsY = $coordsY Then
				$iBlocked += 1
				If $DeadOnTheRun = 0 Then Move($coordsX, $coordsY, 500)
				If $DeadOnTheRun = 0 Then RndSlp(350)
				If $DeadOnTheRun = 0 Then Move($x, $y, $random)
			EndIf
		Until ComputeDistanceEx($coordsX, $coordsY, $x, $y) < 250 Or $iBlocked > 20 Or $DeadOnTheRun = 1
	EndIf
	$TimerToKillDiff = TimerDiff($TimerToKill)
	$text = StringFormat("min: %03u  sec: %02u ", $TimerToKillDiff / 1000 / 60, Mod($TimerToKillDiff / 1000, 60))
	FileWriteLine($File, $enemy & " en ================================== >   " & $text & @CRLF)
EndFunc   ;==>AggroMoveToEx2

Func CheckDeath()
	If Death() = 1 Then
		$WeAreDead = 1
		Update("We Are Dead On The Way To Run TO The Dungeon")
	EndIf
EndFunc   ;==>CheckDeath

Func RunningToDungeon()
	Update("Flagging hero")
	CommandAll(-9451, -19766)
	RndSleep(500)
	Update("Begin Running")
	AdlibRegister("Running", 1000)
	AdlibRegister("HeroBuff", 5000)
	AdlibRegister("CheckDeath", 1000)

	If $WeAreDead = 0 Then MoveTo(-9681, -17795)
	If $WeAreDead = 0 Then IfGotBlock(-9681, -17795)
	If $WeAreDead = 0 Then MoveTo(-9726, -17202)
	If $WeAreDead = 0 Then IfGotBlock(-9726, -17202)
	If $WeAreDead = 0 Then MoveTo(-9787, -16598)
	If $WeAreDead = 0 Then IfGotBlock(-9787, -16598)
	If $WeAreDead = 0 Then MoveTo(-9871, -16017)
	If $WeAreDead = 0 Then IfGotBlock(-9871, -16017)
	If $WeAreDead = 0 Then MoveTo(-10021, -15429)
	If $WeAreDead = 0 Then IfGotBlock(-10021, -15429)
	If $WeAreDead = 0 Then MoveTo(-10208, -14867)
	If $WeAreDead = 0 Then IfGotBlock(-10208, -14867)
	If $WeAreDead = 0 Then MoveTo(-10402, -14289)
	If $WeAreDead = 0 Then IfGotBlock(-10402, -14289)
	If $WeAreDead = 0 Then MoveTo(-10588, -13734)
	If $WeAreDead = 0 Then IfGotBlock(-10588, -13734)
	If $WeAreDead = 0 Then MoveTo(-10755, -13164)
	If $WeAreDead = 0 Then IfGotBlock(-10755, -13164)
	If $WeAreDead = 0 Then MoveTo(-10899, -12576)
	If $WeAreDead = 0 Then IfGotBlock(-10899, -12576)
	If $WeAreDead = 0 Then MoveTo(-10992, -11982)
	If $WeAreDead = 0 Then IfGotBlock(-10992, -11982)
	If $WeAreDead = 0 Then MoveTo(-10986, -11363)
	If $WeAreDead = 0 Then IfGotBlock(-10986, -11363)
	If $WeAreDead = 0 Then MoveTo(-10867, -10777)
	If $WeAreDead = 0 Then IfGotBlock(-10867, -10777)
	If $WeAreDead = 0 Then MoveTo(-10600, -10231)
	If $WeAreDead = 0 Then IfGotBlock(-10600, -10231)
	If $WeAreDead = 0 Then MoveTo(-10277, -9731)
	If $WeAreDead = 0 Then IfGotBlock(-10277, -9731)
	If $WeAreDead = 0 Then MoveTo(-9953, -9235)
	If $WeAreDead = 0 Then IfGotBlock(-9953, -9235)
	If $WeAreDead = 0 Then MoveTo(-9630, -8740)
	If $WeAreDead = 0 Then IfGotBlock(-9630, -8740)
	If $WeAreDead = 0 Then MoveTo(-9298, -8231)
	If $WeAreDead = 0 Then IfGotBlock(-9298, -8231)
	If $WeAreDead = 0 Then MoveTo(-9033, -7844)
	If $WeAreDead = 0 Then IfGotBlock(-9033, -7844)
	If $WeAreDead = 0 Then MoveTo(-8614, -7361)
	If $WeAreDead = 0 Then IfGotBlock(-8614, -7361)
	If $WeAreDead = 0 Then MoveTo(-8210, -6911)
	If $WeAreDead = 0 Then IfGotBlock(-8210, -6911)
	If $WeAreDead = 0 Then MoveTo(-7737, -6529)
	If $WeAreDead = 0 Then IfGotBlock(-7737, -6529)
	If $WeAreDead = 0 Then MoveTo(-7224, -6198)
	If $WeAreDead = 0 Then IfGotBlock(-7224, -6198)
	If $WeAreDead = 0 Then MoveTo(-6696, -5863)
	If $WeAreDead = 0 Then IfGotBlock(-6696, -5863)
	If $WeAreDead = 0 Then MoveTo(-6186, -5540)
	If $WeAreDead = 0 Then IfGotBlock(-6186, -5540)
	If $WeAreDead = 0 Then MoveTo(-5672, -5232)
	If $WeAreDead = 0 Then IfGotBlock(-5672, -5232)
	If $WeAreDead = 0 Then MoveTo(-5160, -4925)
	If $WeAreDead = 0 Then IfGotBlock(-5160, -4925)
	If $WeAreDead = 0 Then MoveTo(-4638, -4612)
	If $WeAreDead = 0 Then IfGotBlock(-4638, -4612)
	If $WeAreDead = 0 Then MoveTo(-4122, -4303)
	If $WeAreDead = 0 Then IfGotBlock(-4122, -4303)
	If $WeAreDead = 0 Then MoveTo(-3607, -4004)
	If $WeAreDead = 0 Then IfGotBlock(-3607, -4004)
	If $WeAreDead = 0 Then MoveTo(-3102, -3716)
	If $WeAreDead = 0 Then IfGotBlock(-3102, -3716)
	If $WeAreDead = 0 Then MoveTo(-2608, -3384)
	If $WeAreDead = 0 Then IfGotBlock(-2608, -3384)
	If $WeAreDead = 0 Then MoveTo(-2140, -3045)
	If $WeAreDead = 0 Then IfGotBlock(-2140, -3045)
	If $WeAreDead = 0 Then MoveTo(-1665, -2701)
	If $WeAreDead = 0 Then IfGotBlock(-1665, -2701)
	If $WeAreDead = 0 Then MoveTo(-1197, -2362)
	If $WeAreDead = 0 Then IfGotBlock(-1197, -2362)
	If $WeAreDead = 0 Then MoveTo(-721, -2024)
	If $WeAreDead = 0 Then IfGotBlock(-721, -2024)
	If $WeAreDead = 0 Then MoveTo(-250, -1703)
	If $WeAreDead = 0 Then IfGotBlock(-250, -1703)
	If $WeAreDead = 0 Then MoveTo(241, -1368)
	If $WeAreDead = 0 Then IfGotBlock(241, -1368)
	If $WeAreDead = 0 Then MoveTo(630, -1121)
	If $WeAreDead = 0 Then IfGotBlock(630, -1121)
	If $WeAreDead = 0 Then MoveTo(1113, -787)
	If $WeAreDead = 0 Then IfGotBlock(1113, -787)
	If $WeAreDead = 0 Then MoveTo(1605, -446)
	If $WeAreDead = 0 Then IfGotBlock(1605, -446)
	If $WeAreDead = 0 Then MoveTo(2105, -97)
	If $WeAreDead = 0 Then IfGotBlock(2105, -97)
	If $WeAreDead = 0 Then MoveTo(2540, 312)
	If $WeAreDead = 0 Then IfGotBlock(2540, 312)
	If $WeAreDead = 0 Then MoveTo(2878, 829)
	If $WeAreDead = 0 Then IfGotBlock(2878, 829)
	If $WeAreDead = 0 Then MoveTo(3080, 1416)
	If $WeAreDead = 0 Then IfGotBlock(3080, 1416)
	If $WeAreDead = 0 Then MoveTo(3241, 2038)
	If $WeAreDead = 0 Then IfGotBlock(3241, 2038)
	If $WeAreDead = 0 Then MoveTo(3390, 2616)
	If $WeAreDead = 0 Then IfGotBlock(3390, 2616)
	If $WeAreDead = 0 Then MoveTo(3543, 3206)
	If $WeAreDead = 0 Then IfGotBlock(3543, 3206)
	If $WeAreDead = 0 Then MoveTo(3692, 3784)
	If $WeAreDead = 0 Then IfGotBlock(3692, 3784)
	If $WeAreDead = 0 Then MoveTo(3844, 4373)
	If $WeAreDead = 0 Then IfGotBlock(3844, 4373)
	If $WeAreDead = 0 Then MoveTo(3995, 4956)
	If $WeAreDead = 0 Then IfGotBlock(3995, 4956)
	If $WeAreDead = 0 Then MoveTo(4146, 5542)
	If $WeAreDead = 0 Then IfGotBlock(4146, 5542)
	If $WeAreDead = 0 Then MoveTo(4323, 6120)
	If $WeAreDead = 0 Then IfGotBlock(4323, 6120)
	If $WeAreDead = 0 Then MoveTo(4554, 6663)
	If $WeAreDead = 0 Then IfGotBlock(4554, 6663)
	If $WeAreDead = 0 Then MoveTo(4835, 7202)
	If $WeAreDead = 0 Then IfGotBlock(4835, 7202)
	If $WeAreDead = 0 Then MoveTo(5219, 7657)
	If $WeAreDead = 0 Then IfGotBlock(5219, 7657)
	If $WeAreDead = 0 Then MoveTo(5676, 8014)
	If $WeAreDead = 0 Then IfGotBlock(5676, 8014)
	If $WeAreDead = 0 Then MoveTo(6179, 8312)
	If $WeAreDead = 0 Then IfGotBlock(6179, 8312)
	If $WeAreDead = 0 Then MoveTo(6710, 8536)
	If $WeAreDead = 0 Then IfGotBlock(6710, 8536)
	If $WeAreDead = 0 Then MoveTo(7278, 8663)
	If $WeAreDead = 0 Then IfGotBlock(7278, 8663)
	If $WeAreDead = 0 Then MoveTo(7882, 8694)
	If $WeAreDead = 0 Then IfGotBlock(7882, 8694)
	If $WeAreDead = 0 Then MoveTo(8475, 8679)
	If $WeAreDead = 0 Then IfGotBlock(8475, 8679)
	If $WeAreDead = 0 Then MoveTo(9068, 8660)
	If $WeAreDead = 0 Then IfGotBlock(9068, 8660)
	If $WeAreDead = 0 Then MoveTo(9659, 8656)
	If $WeAreDead = 0 Then IfGotBlock(9659, 8656)
	If $WeAreDead = 0 Then MoveTo(10265, 8686)
	If $WeAreDead = 0 Then IfGotBlock(10265, 8686)
	If $WeAreDead = 0 Then MoveTo(10812, 8883)
	If $WeAreDead = 0 Then IfGotBlock(10812, 8883)
	If $WeAreDead = 0 Then MoveTo(11286, 9254)
	If $WeAreDead = 0 Then IfGotBlock(11286, 9254)
	If $WeAreDead = 0 Then MoveTo(11613, 9771)
	If $WeAreDead = 0 Then IfGotBlock(11613, 9771)
	If $WeAreDead = 0 Then MoveTo(11825, 10332)
	If $WeAreDead = 0 Then IfGotBlock(11825, 10332)
	If $WeAreDead = 0 Then MoveTo(11934, 10785)
	If $WeAreDead = 0 Then IfGotBlock(11934, 10785)
	If $WeAreDead = 0 Then MoveTo(12066, 11338)
	If $WeAreDead = 0 Then IfGotBlock(12066, 11338)
	If $WeAreDead = 0 Then MoveTo(12182, 11939)
	If $WeAreDead = 0 Then IfGotBlock(12182, 11939)
	If $WeAreDead = 0 Then MoveTo(12256, 12578)
	If $WeAreDead = 0 Then IfGotBlock(12256, 12578)
	If $WeAreDead = 0 Then MoveTo(12327, 13177)
	If $WeAreDead = 0 Then IfGotBlock(12327, 13177)
	If $WeAreDead = 0 Then MoveTo(12399, 13795)
	If $WeAreDead = 0 Then IfGotBlock(12399, 13795)
	If $WeAreDead = 0 Then MoveTo(12469, 14395)
	If $WeAreDead = 0 Then IfGotBlock(12469, 14395)
	If $WeAreDead = 0 Then MoveTo(12545, 15046)
	If $WeAreDead = 0 Then IfGotBlock(12545, 15046)
	If $WeAreDead = 0 Then MoveTo(12567, 15461)
	If $WeAreDead = 0 Then IfGotBlock(12567, 15461)
	If $WeAreDead = 0 Then MoveTo(12657, 16069)
	If $WeAreDead = 0 Then IfGotBlock(12657, 16069)
	If $WeAreDead = 0 Then MoveTo(12795, 16664)
	If $WeAreDead = 0 Then IfGotBlock(12795, 16664)
	If $WeAreDead = 0 Then MoveTo(12940, 17236)
	If $WeAreDead = 0 Then IfGotBlock(12940, 17236)
	If $WeAreDead = 0 Then MoveTo(13064, 17803)
	If $WeAreDead = 0 Then IfGotBlock(13064, 17803)
	If $WeAreDead = 0 Then MoveTo(13188, 18398)
	If $WeAreDead = 0 Then IfGotBlock(13188, 18398)
	If $WeAreDead = 0 Then MoveTo(13314, 19051)
	If $WeAreDead = 0 Then IfGotBlock(13314, 19051)
	If $WeAreDead = 0 Then MoveTo(13334, 19657)
	If $WeAreDead = 0 Then IfGotBlock(13334, 19657)
	If $WeAreDead = 0 Then MoveTo(13184, 20232)
	If $WeAreDead = 0 Then IfGotBlock(13184, 20232)
	If $WeAreDead = 0 Then MoveTo(12933, 20781)
	If $WeAreDead = 0 Then IfGotBlock(12933, 20781)
	If $WeAreDead = 0 Then MoveTo(12507, 21162)
	If $WeAreDead = 0 Then IfGotBlock(12507, 21162)
	If $WeAreDead = 0 Then MoveTo(12180, 21586)
	If $WeAreDead = 0 Then IfGotBlock(12180, 21586)
	If $WeAreDead = 0 Then MoveTo(11960, 22132)
	If $WeAreDead = 0 Then IfGotBlock(11960, 22132)
	If $WeAreDead = 0 Then MoveTo(12217, 22800)
	If $WeAreDead = 0 Then Update("Taking Quest")
	If $WeAreDead = 0 Then GetGuyForQuest()
	If $WeAreDead = 0 Then RndSlp(4000)
	If $WeAreDead = 0 Then AcceptQuest(802)
	If $WeAreDead = 0 Then RndSlp(1000)
	If $WeAreDead = 0 Then Update("Going to finish running")
	If $WeAreDead = 0 Then MoveTo(12085, 24868)
	If $WeAreDead = 0 Then IfGotBlock(12085, 24868)
	If $WeAreDead = 0 Then MoveTo(12472, 25297)
	If $WeAreDead = 0 Then IfGotBlock(12472, 25297)
	If $WeAreDead = 0 Then MoveTo(12667, 25653)
	If $WeAreDead = 0 Then Move(13197, 26595)
	AdlibUnRegister("HeroBuff")
	AdlibUnRegister("CheckDeath")
	If $WeAreDead = 0 Then Update("End Running")
	If $WeAreDead = 0 Then Update("Waiting Dungeon load")
	If $WeAreDead = 0 Then WaitForLoad()
	If $WeAreDead = 0 Then Update("Loaded")
	If $WeAreDead = 0 Then RndSlp(5000)
EndFunc   ;==>RunningToDungeon


Func GetGuyForQuest($aAgent = -2)
;~ 	Local $lNearestAgent, $lNearestDistance = 100000000
;~ 	Local $lDistance, $lAgentToCompare

;~ 	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
;~ 	If $WeAreDead = 0 then
;~ 		For $i = 1 To GetMaxAgents()
;~ 			If $WeAreDead = 0 then $lAgentToCompare = GetAgentByID($i)
;~ 			If $WeAreDead = 1 then ExitLoop
;~ 			If DllStructGetData($lAgentToCompare, 'PlayerNumber') <> 6712 then ContinueLoop
;~ 			If $WeAreDead = 0 then rndslp(150)
;~ 			If $WeAreDead = 0 then ChangeTarget($lAgentToCompare)
;~ 			If $WeAreDead = 0 then rndslp(150)
;~ 			If $WeAreDead = 0 then GoNPC($lAgentToCompare)
;~ 			ExitLoop
;~ 		Next
;~ 	EndIf
 	$merchant = GetNearestNPCToCoords(12308,22836)
	RNDSLP(1000)
	;moveto(7603, -27423)
	GoToNPC($merchant)
	rndslp(500)
EndFunc   ;==>GetNearestEnemyToAgent
