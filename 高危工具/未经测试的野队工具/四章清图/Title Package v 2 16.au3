#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include "GWA².au3"
#include "AddsOn.au3"
#include "CommonFunction.au3"

global $DeadOnTheRun = 0
Global $GWA_CONST_UnyieldingAura=268
Global $SS_begin, $LB_begin, $Asura_begin, $Deldrimor_begin, $Norn_begin, $Vanguard_begin, $Kurzick_begin, $Luxon_begin
Global $Map_To_Zone, $Map_To_Farm
Global $SS_Outpost = 396
Global $Deldrimor_Outpost = 639
Global $Asura_Outpost = 640
Global $Norn_Outpost = 645
Global $Vanguard_Outpost = 648
Global $SS_LB_Outpost = 545
Global $Kurzick_Outpost = 77
Global $Luxon_Outpost = 389
Global $areaFerndale = 210
Global $what_we_donate = 0
Global $Abandonquest = False
Global $SS_Map = 395
Global $Deldrimor_Map = 781
Global $Asura_Map = 569
Global $Norn_Map = 553
Global $Vanguard_Map = 647
Global $SS_LB_Map = 444
Global $Kurzick_Map = 210
Global $Luxon_Map = 200




While 1
	If $boolrun = true Then
		If $NumberRun = 0 Then ;first run
			AdlibRegister("status", 1000)
			$TimerTotal = TimerInit()
			FileOpen($File)
			$SS_begin = GetSunspearTitle()
			$LB_begin = GetLightbringerTitle()
			$Asura_begin = GetAsuraTitle()
			$Deldrimor_begin = GetDeldrimorTitle()
			$Norn_begin = GetNornTitle()
			$Vanguard_begin = GetVanguardTitle()
			$Kurzick_begin =  GetKurzickFaction()
			$Luxon_begin = GetLuxonFaction()

			If $Title = "Asura" Then
				$Map_To_Zone = $Asura_Outpost
				$Map_To_Farm = $Asura_Map
			ElseIf $Title = "Deldrimor" Then
				$Map_To_Zone = $Deldrimor_Outpost
				$Map_To_Farm = $Deldrimor_Map
			ElseIf $Title = "Vanguard" Then
				$Map_To_Zone = $Vanguard_Outpost
				$Map_To_Farm = $Vanguard_Map
			ElseIf $Title = "Norn" Then
				$Map_To_Zone = $Norn_Outpost
				$Map_To_Farm = $Norn_Map
			ElseIf $Title = "Kurzick" Then
				$Map_To_Zone = $Kurzick_Outpost
				$Map_To_Farm = $Kurzick_Map
			ElseIf $Title = "Luxon" Then
				$Map_To_Zone = $Luxon_Outpost
				$Map_To_Farm = $Luxon_Map
			ElseIf $Title = "SS and LB" Then
				$Map_To_Zone = $SS_LB_Outpost
				$Map_To_Farm = $SS_LB_Map
				$totalskills = 6
			ElseIf $Title = "SS" Then
				$Map_To_Zone = $SS_Outpost
				$Map_To_Farm = $SS_Map
			EndIf

			If $Title = "Luxon" and $Bool_Donate Then
				MsgBox(48, "Warnning", "You tick donate button, be sure you are in a Luxon guild and you are also able to speak to the merchant in the outpost.")
			ElseIf $Title = "Kurzick" and $Bool_Donate Then
				MsgBox(48, "Warnning", "You tick donate button, be sure you are in a Kurzick guild and you are also able to speak to the merchant in the outpost.")
			ElseIf $Title = "SS and LB" Then
				MsgBox(48, "Warnning", "You choose SS and LB bot, dont forget that you need the 2 quest for that and rune of doom in inventory.")
			EndIf
		EndIf

		If GetMapID() <> $Map_To_Zone Then
			CurrentAction("Moving to Outpost")
			local $out = 0
			Do
				TravelTo($Map_To_Zone)
				WaitForLoad()
				rndslp(500)
				CurrentAction("Waiting to really complete load")
				rndslp(5000)
				$out = $out + 1
			Until GetMapID() = $Map_To_Zone or $out = 6
		EndIf
		rndslp(3000)
		If $Title = "Kurzick" Then
			If FactionCheckKurzick() Then TurnInFactionKurzick()
		ElseIf $Title = "Luxon" Then
			If FactionCheckLuxon() Then TurnInFactionLuxon()
		EndIf

		CurrentAction("Begin run number " & $NumberRun)
		If $Bool_HM Then
			SwitchMode(1)
		Else
			SwitchMode(0)
		EndIf

		If CheckIfInventoryIsFull() then SellItemToMerchant()

		GoOut()

		VQ()

		$NumberRun = $NumberRun +1
	EndIf
	sleep(50)
WEnd

Func FactionCheckKurzick()
	CurrentAction("Checking faction")
	RndSleep(250)
	If GetKurzickFaction() > GetMaxKurzickFaction() - 12000 Then
		Return True
	Else
		Return False
	EndIf
EndFunc

Func TurnInFactionKurzick()
	CurrentAction("Turning in faction")
	RndSleep(1000)
	GoNearestNPCToCoords(5390, 1524)

	$beforedone = GetKurzickFaction()

	If $Bool_Donate Then
		Do
			CurrentAction("Donate")
			DonateFaction("kurzick")
			RndSleep(500)
		Until GetKurzickFaction() < 5000
	Else
		CurrentAction("Donating Kurzick Faction for Amber")
		Dialog(131)
		RndSleep(550)
		$temp = Floor(GetKurzickFaction() / 5000)
		$id = 8388609 + ($temp * 256)
		Dialog($id)
        RndSleep(550)
	EndIf

	$after_donate = GetKurzickFaction()
	$what_we_donate = $beforedone - $after_donate + $what_we_donate
	RndSleep(500)
EndFunc

Func FactionCheckLuxon()
	CurrentAction("Check Luxon point atm")
	RndSleep(250)

	If GetLuxonFaction() > GetMaxLuxonFaction() - 12000 Then
		Return True
	Else
		Return False
	EndIf
EndFunc

Func TurnInFactionLuxon()
	TravelTo(193)
	WaitForLoad()
	CurrentAction("grabing")
	GoNearestNPCToCoords(9076, -1111)

	$beforedone = GetLuxonFaction()

	If $Bool_Donate Then
		Do
			CurrentAction("Donate")
			DonateFaction(1)
			RndSleep(250)
		Until GetLuxonFaction() < 5000
	Else
		CurrentAction("Grabbing Jade Shards")
		Dialog(131)
		RndSleep(500)
		$temp = Floor(GetLuxonFaction() / 5000)
		$id = 8388609 + ($temp * 256)
		Dialog($id)
	EndIf
	RndSleep(500)
	$after_donate = GetLuxonFaction()
	$what_we_donate = $beforedone - $after_donate + $what_we_donate
	RndSleep(500)
	TravelTo(389)
	WaitForLoad()
EndFunc

Func GoOut()
	RndSleep(250)

	If GetGoldCharacter() < 100 AND GetGoldStorage() > 100 Then
		CurrentAction("Grabbing gold for shrine")
		RndSleep(250)
		WithdrawGold(100)
		RndSleep(250)
	EndIf

	CurrentAction("Going out")

	If $Title = "Deldrimor" Then
		TakeQuestDeldrimor()
		WaitForLoad()
	Else
		Do
			If $Title = "Asura" Then
				MoveTo(16342, 13855)
				Move(16450, 13300)
				WaitForLoad()
			ElseIf $Title = "Vanguard" Then
				MoveTo(-16009, 14596)
				Move(-15200, 13500)
				WaitForLoad()
			ElseIf $Title = "Norn" Then
				MoveTo(-141, 1416)
				Move(-1448, 1171)
				WaitForLoad()
			ElseIf $Title = "Kurzick" Then
				MoveTo(7810,-726)
				Do
					MoveTo(10042,-1173)
					RndSleep(500)
					Move(10446, -1147, 5)
					WaitForLoad()
				Until GetMapID() = $areaFerndale
			ElseIf $Title = "Luxon" Then
				MoveTo(-4268, 11628)
				MoveTo(-4980, 12425)
				Move(-5493, 13712)
				WaitForLoad()
			ElseIf $Title = "SS and LB" Then
				MoveTo(235, -3610)
				Move(2314, -4560)
				WaitForLoad()
			ElseIf $Title = "SS" Then
				MoveTo(-204, 3665)
				Move(-490, 4995)
				WaitForLoad()
			EndIf
			rndslp(2000)
		Until GetMapID() = $Map_To_Farm
	EndIf

EndFunc

Func TakeQuestDeldrimor()
	CurrentAction("Taking quest")
	GoNearestNPCToCoords(-23818, 13931)
	RndSleep(750)
	Dialog(8618497)
	RndSleep(750)
	GoNearestNPCToCoords(-23818, 13931)
	RndSleep(750)
	Dialog(0x00000083)
	Dialog(0x00000084)
	rndslp(200)
EndFunc

Func status()
	$time = TimerDiff($TimerTotal)
	$string = StringFormat("min: %03u  sec: %02u ", $time/1000/60, Mod($time/1000,60))
	GUICtrlSetData($label_stat, $string)
EndFunc    ;==>status

Func CheckDeath()
	If Death() = 1 Then
		CurrentAction("We Are Dead")
	EndIf
EndFunc   ;==>CheckDeath

Func CheckPartyDead()
	$DeadParty = 0
	For $i =1 to GetHeroCount()
		If GetIsDead(GetHeroID($i)) = True Then
			$DeadParty +=1
		EndIf
		If $DeadParty >= 5 Then
			$DeadOnTheRun = 1
			CurrentAction("We Wipe, going back oupost to save time")
		EndIf
	Next
EndFunc

Func HeroBuff()
	$mSkillBar = GetSkillbar(3)
	$mHeroInfo = GetAgentByID(GetHeroID(3))
	If GetIsTargetBuffed($GWA_CONST_UnyieldingAura,  GetHeroID(3), 3) == 0 AND DllStructGetData($mSkillBar, 'Recharge1') == 0 AND GetIsDead($mHeroInfo) == False Then
		UseHeroSkill(3, 1,  GetHeroID(3))
	EndIf
EndFunc

Func VQ()
	CurrentAction("Waiting to really complete load")
	rndslp(5000)
	$DeadOnTheRun = 0

	If $Title = "Asura" Then
		AdlibRegister("HeroBuff", 3000)
		AdlibRegister("CheckPartyDead", 2000)
		AdlibRegister("AsuraPoint", 5000)
		VQAsura()
		AdlibUnRegister("CheckPartyDead")
		AdlibUnRegister("AsuraPoint")
		AdlibUnRegister("HeroBuff")
	ElseIf $Title = "Deldrimor" Then
		AdlibRegister("HeroBuff", 3000)
		AdlibRegister("DeldrimorPoint", 5000)
		VQDeldrimor()
		AdlibUnRegister("DeldrimorPoint")
		AdlibUnRegister("HeroBuff")
	ElseIf $Title = "Vanguard" Then
		AdlibRegister("HeroBuff", 3000)
		AdlibRegister("CheckPartyDead", 2000)
		AdlibRegister("Vanguardpoint", 5000)
		VQVanguard()
		AdlibUnRegister("CheckPartyDead")
		AdlibUnRegister("Vanguardpoint")
		AdlibUnRegister("HeroBuff")
	ElseIf $Title = "Norn" Then
		AdlibRegister("HeroBuff", 3000)
		AdlibRegister("CheckPartyDead", 2000)
		AdlibRegister("Nornpoint", 5000)
		VQNorn()
		AdlibUnRegister("CheckPartyDead")
		AdlibUnRegister("Nornpoint")
		AdlibUnRegister("HeroBuff")
	ElseIf $Title = "Kurzick" Then
		AdlibRegister("HeroBuff", 3000)
		AdlibRegister("CheckPartyDead", 2000)
		AdlibRegister("Kurzickpoint", 5000)
		VQKurzick()
		AdlibUnRegister("CheckPartyDead")
		AdlibUnRegister("Kurzickpoint")
		AdlibUnRegister("HeroBuff")
	ElseIf $Title = "Luxon" Then
		AdlibRegister("HeroBuff", 3000)
		AdlibRegister("CheckPartyDead", 2000)
		AdlibRegister("Luxonpoint", 5000)
		VQLuxon()
		AdlibUnRegister("CheckPartyDead")
		AdlibUnRegister("Luxonpoint")
		AdlibUnRegister("HeroBuff")
	ElseIf $Title = "SS and LB" Then
		AdlibRegister("CheckPartyDead", 2000)
		AdlibRegister("SSLBpoint", 5000)
		VQSSLB()
		AdlibUnRegister("CheckPartyDead")
		AdlibUnRegister("SSLBpoint")
	ElseIf $Title = "SS" Then
		AdlibRegister("HeroBuff", 3000)
		AdlibRegister("CheckPartyDead", 2000)
		AdlibRegister("SSpoint", 5000)
		VQSS()
		AdlibUnRegister("CheckPartyDead")
		AdlibUnRegister("SSpoint")
		AdlibUnRegister("HeroBuff")
	EndIf
	CurrentAction("Waiting...")
	rndslp(5000)
EndFunc

Func AsuraPoint()
	$Temp = GetAsuraTitle()
	$point_earn = $Temp - $Asura_begin
	GUICtrlSetData($Pt_Asura, $point_earn)
EndFunc

Func DeldrimorPoint()
	$Temp = GetDeldrimorTitle()
	$point_earn = $Temp - $Deldrimor_begin
	GUICtrlSetData($Pt_Deldrimor, $point_earn)
EndFunc

Func Vanguardpoint()
	$Temp = GetVanguardTitle()
	$point_earn = $Temp - $Vanguard_begin
	GUICtrlSetData($Pt_Vanguard, $point_earn)
EndFunc

Func Nornpoint()
	$Temp = GetNornTitle()
	$point_earn = $Temp - $Norn_begin
	GUICtrlSetData($Pt_Norn, $point_earn)
EndFunc

Func Kurzickpoint()
	$Temp = GetKurzickFaction()
	$point_earn = $Temp - $Kurzick_begin + $what_we_donate
	GUICtrlSetData($Pt_Kurzick, $point_earn)
EndFunc

Func Luxonpoint()
	$Temp = GetLuxonFaction()
	$point_earn = $Temp - $Luxon_begin + $what_we_donate
	GUICtrlSetData($Pt_Luxon, $point_earn)
EndFunc

Func SSLBpoint()
	$Temp = GetSunspearTitle()
	$point_earn = $Temp - $SS_begin
	GUICtrlSetData($Pt_SS, $point_earn)
	$Temp = GetLightbringerTitle()
	$point_earn = $Temp - $LB_begin
	GUICtrlSetData($Pt_LB, $point_earn)
EndFunc

Func SSpoint()
	$Temp = GetSunspearTitle()
	$point_earn = $Temp - $SS_begin
	GUICtrlSetData($Pt_SS, $point_earn)
EndFunc

Func VQLuxon() ;
	CurrentAction("Taking blessing")
	$deadlock = 0
	Do
		GoNearestNPCToCoords(-8394, -9801)
		;Dialog(0x83)
;	rndslp(1000)
	Dialog(0x85)
	rndslp(1000)
	Dialog(0x86)
	rndslp(1000)
		$deadlock+=1
	Until DllStructGetData(geteffect(1947), 'skillid') = 1947 or DllStructGetData(geteffect(1946), 'skillid') = 1946 or $deadlock = 10 ; luxon = 1947


	If $DeadOnTheRun = 0 Then $enemy = "Yeti"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-13046, -9347, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Yeti"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-17348, -9895, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Oni and Wallows"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-14702, -6671, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Oni and Wallows"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11080, -6126, $enemy, 2000)

	If $DeadOnTheRun = 0 Then $enemy = "Yeti"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-13426, -2344, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "TomTom"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-15055, -3226, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Guardian and Wallows"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-9448, -283, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Yeti"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-9918, 2826, $enemy, 2000)

	If $DeadOnTheRun = 0 Then $enemy = "Yeti"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-8721, 7682, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Yeti"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3749, 8053, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Guardian and Wallows"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-7474, -1144, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Guardian and Wallows"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-9666, 2625, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Guardian and Wallows"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5895, -3959, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Patrol"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3509, -8000, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Oni"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-195, -9095, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Oni"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6298, -8707, $enemy)
	If $DeadOnTheRun = 0 Then rndslp(2000)

	If $DeadOnTheRun = 0 Then $enemy = "bridge"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(3981, -3295, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Naga"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(496, -2581, $enemy, 2000)

	If $DeadOnTheRun = 0 Then $enemy = "Guardian and Wallows"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(2069, 1127, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Guardian and Wallows"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5859, 1599, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Guardian and Wallows"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6412, 6572, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Naga"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(10507, 8140, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Oni"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(14403, 6938, $enemy)
	If $DeadOnTheRun = 0 Then $enemy = "Oni"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(18080, 3127, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Naga"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(13518, -35, $enemy)

	If $DeadOnTheRun = 0 Then $enemy = "Naga"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(13450, -6084, $enemy, 4000)

	If $DeadOnTheRun = 0 Then $enemy = "Naga"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(13764, -4816, $enemy, 4000)

	If $DeadOnTheRun = 0 Then $enemy = "Naga"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(13450, -6084, $enemy, 4000)

	If $DeadOnTheRun = 0 Then $enemy = "Naga"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(13764, -4816, $enemy, 4000)


	If $DeadOnTheRun = 0 Then CurrentAction("Waiting to get reward")
	If $DeadOnTheRun = 0 Then rndslp(6000)
EndFunc

Func VQVanguard();
	CurrentAction("Taking Blessing")

	$deadlock = 0
	Do
		GoNearestNPCToCoords(-14903, 11023)
		rndslp(1000)
		Dialog(0x00000084)
		rndslp(1000)
		$deadlock+=1
	Until DllStructGetData(geteffect(2550), 'skillid') = 2550 or DllStructGetData(geteffect(2578), 'skillid') = 2578 or $deadlock = 10 ; luxon = 1947

	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
	If $DeadOnTheRun = 0 Then MoveTo(-12373, 12899)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-9464, 15937, "Charr Group")
	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
	If $DeadOnTheRun = 0 Then MoveTo(-9130, 13535)
	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
	If $DeadOnTheRun = 0 Then MoveTo(-5532, 11281)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3979, 9184, "Mantid Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-355, 9296, "Again mantid Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(836, 12171, "Charr Patrol")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(884, 15641, "Charr Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(2956, 10496, "Mantid Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5160, 11032, "Moving")

	If $DeadOnTheRun = 0 Then CurrentAction("Taking Blessing")
	If $DeadOnTheRun = 0 Then GoNearestNPCToCoords(5816, 11687)
	If $DeadOnTheRun = 0 Then rndslp(1000)
	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
	If $DeadOnTheRun = 0 Then MoveTo(5848, 11086)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7639, 11839, "Charr Patrol")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6494, 15729, "Charr Patrol")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5704, 17469, "Charr Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8572, 12365, "Moving Back")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(13960, 13432, "Charr Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(15385, 9899, "Going Charr")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(17089, 6922, "Charr Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(16363, 3809, "Moving Gain")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(15635, 710, "Charr Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(12754, 2740, "Charr Seeker")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(10068, 3790, "Skale")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7663, 3236, "Charr Seeker")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6152, 1706, "Charr Seeker")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5086, -2187, "Charr on the way")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(3449, -3693, "Charr Patrol")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7170, -4037, "Moving")

	If $DeadOnTheRun = 0 Then CurrentAction("Taking Blessing")
	If $DeadOnTheRun = 0 Then GoNearestNPCToCoords(8565, -3974)
	If $DeadOnTheRun = 0 Then rndslp(1000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6790, -6124, "Moving")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8031, -10361, "Charr on the way")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(9282, -12837, "Moving")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8817, -16314, "Charr Patrol")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(13337, -14025, "Charr Patrol 2")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(15290, -13688, "Charr Seeker")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(17500, -11685, "Charr Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(15932, -14104, "Moving Back")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(14934, -17261, "Moving")

	If $DeadOnTheRun = 0 Then CurrentAction("Taking Blessing")
	If $DeadOnTheRun = 0 Then GoNearestNPCToCoords(14891, -18146)
	If $DeadOnTheRun = 0 Then rndslp(1000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(11509, -17586, "Moving")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6031, -17582, "Moving")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(2846, -17340, "Charr Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-586, -16529, "Charr Seeker")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4099, -14897, "Moving")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4217, -12620, "Moving")

	If $DeadOnTheRun = 0 Then CurrentAction("Taking Blessing")
	If $DeadOnTheRun = 0 Then GoNearestNPCToCoords(-4014, -11504)
	If $DeadOnTheRun = 0 Then rndslp(1000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-8023, -13970, "Charr Seeker")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-9808, -15103, "Moving")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10902, -16356, "Skale Place")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11917, -18111, "Skale Place")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-13425, -16930, "Skale Boss")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-15218, -17460, "Skale Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-16084, -14159, "Skale Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-17395, -12851, "Skale Place")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-18157, -9785, "Skale On the Way")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-18222, -6263, "Finish Skale")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-17239, -1933, "Moving")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-17509, 202, "Moving")

	If $DeadOnTheRun = 0 Then CurrentAction("Taking Blessing")
	If $DeadOnTheRun = 0 Then GoNearestNPCToCoords(-17546, 341)
	If $DeadOnTheRun = 0 Then rndslp(1000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-13853, -2427, "Charr Seeker")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-13228, 2083, "Charr Seeker")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-12909, 6403, "Mantid on the way")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10699, 5105, "Mantid Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-9016, 6958, "Mantid Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-8889, 9446, "Mantid Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-8190, 6872, "Mantid")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-6869, 4604, "Mantid Monk Boss")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-6181, 2977, "Mantid Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4125, 2789, "Mantid Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2875, 985, "Moving")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-769, 2047, "Charr Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(1114, 1765, "Mantid and Charr")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(1606, 22, "Charr Patrol")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-276, -2566, "Going to Molotov")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3337, -4323, "Molotov")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4700, -4943, "Molotov")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5561, -5483, "Molotov")
EndFunc

Func VQSS();
	CurrentAction("Taking blessing")

	$deadlock = 0
	Do
		GoNearestNPCToCoords(15773, -15302)
		rndslp(1000)
		Dialog(0x00000084)
		Dialog(0x00000085)
		rndslp(1000)
		$deadlock+=1
	Until DllStructGetData(geteffect(1974), 'skillid') = 1974 or $deadlock = 10 ; luxon = 1947

	$DeadOnTheRun = 0

	CurrentAction("Avoiding Stuck By Scout")

	MoveTo(16156, -15046)

	CurrentAction("Going To Farm Left Side")

	MoveTo(14627, -15003)
	MoveTo(9897, -15584)
	MoveTo(6995, -14597)

	$enemy = "First Group"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(4543, -12928, $enemy)

	$enemy = "Second Group"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(2361, -10638, $enemy)

	$enemy = "Third Group"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(1218, -9046, $enemy, 1800)

	$enemy = "4 Group"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(825, -5411, $enemy)

	$enemy = "Monk Boss Group"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-599, -3110, $enemy, 1600)

	If $DeadOnTheRun = 0 Then CurrentAction("Moving Other Side")

	If $DeadOnTheRun = 0 Then MoveTo(1785, -5534)

	If $DeadOnTheRun = 0 Then MoveTo(3027, -5764)
	If $DeadOnTheRun = 0 Then MoveTo(6122, -2189)
	If $DeadOnTheRun = 0 Then MoveTo(9346, -3097)

	$enemy = "First Group"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(10874, -5008, $enemy)

	$enemy = "Second Group"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(10970, -7779, $enemy)

	$enemy = "Third Group"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(14262, -7000, $enemy)

	$enemy = "E Boss Group"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(16338, -6716, $enemy)
EndFunc

Func VQSSLB();
	CurrentAction("Taking blessing")

	$deadlock = 0
	Do
		GoNearestNPCToCoords(-704, 15988)

		Dialog(0x00000085)
		rndslp(1000)
		$deadlock+=1
	Until DllStructGetData(geteffect(1982), 'skillid') = 1982 or $deadlock = 10 ; luxon = 1947

	$DeadOnTheRun = 0

	MoveTo(-675, 13419)
	CurrentAction("Little Break For Hero To Come")
	RndSleep(6000)
	CurrentAction("Grabbing wurm")
	TargetNearestItem()
	RndSleep(500)
	GoSignpost(-1)
	RndSleep(1000)

	CurrentAction("Going To Farm")


	$enemy = "First Group"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1950, 9871, $enemy)

	$enemy = "Second Group"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3684, 11485, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4705, 11411, $enemy)

	$enemy = "Third Group"
	If $DeadOnTheRun = 0 Then MoveTo(-9661, 12374)
	If $DeadOnTheRun = 0 Then MoveTo(-12856, 9128)
	;If $DeadOnTheRun = 0 Then MoveTo(-12614, 9323)
	If $DeadOnTheRun = 0 Then MoveTo(-13641, 7692)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-13839, 7961, $enemy)

	If $DeadOnTheRun = 0 Then CurrentAction("Taking blessing")
	If $DeadOnTheRun = 0 Then MoveTo(-17247, 5902)
	If $DeadOnTheRun = 0 Then MoveTo(-19610,7037)
	If $DeadOnTheRun = 0 Then
		$deadlock = 0
		Do
			GoNearestNPCToCoords(-20587,7280)
			rndslp(1000)
			Dialog(0x00000085)
			RndSleep(1000)
			$deadlock+=1
		Until DllStructGetData(geteffect(2037), 'skillid') = 2037 or $deadlock = 10 or $DeadOnTheRun = 1
	EndIf

	$enemy = "Djinn"
	If $DeadOnTheRun = 0 Then MoveTo(-19266, 1867)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-22030, -651, $enemy, 2000)

	$enemy = "Rt Boss"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-19332, -9200, $enemy)

	$enemy = "Margonite"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-22748, -10570, $enemy, 2000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-22259, -13719, $enemy, 2000)

	If $DeadOnTheRun = 0 Then CurrentAction("Picking up Tome")
	If $DeadOnTheRun = 0 Then MoveTo(-21219, -13860)
	If $DeadOnTheRun = 0 Then RndSleep(250)
	If $DeadOnTheRun = 0 Then TargetNearestItem()
	If $DeadOnTheRun = 0 Then PickupItem(-1)
	If $DeadOnTheRun = 0 Then RndSleep(250)
	If $DeadOnTheRun = 0 Then PickupItem(-1)
	If $DeadOnTheRun = 0 Then RndSleep(1000)
	If $DeadOnTheRun = 0 Then DropBundle()

	$enemy = "Spawn !"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-22648, -9901, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-18993, -9491, $enemy)

	If $DeadOnTheRun = 0 Then MoveTo(-22858, -9851)
	If $DeadOnTheRun = 0 Then MoveTo(-22035, -13729)


	If $DeadOnTheRun = 0 Then CurrentAction("Spawning")
	If $DeadOnTheRun = 0 Then MoveTo(-18176, -13412)
	If $DeadOnTheRun = 0 Then $shrine = GetNearestSignpostToCoords(-18176, -13412)
	If $DeadOnTheRun = 0 Then RndSleep(1000)
	If $DeadOnTheRun = 0 Then GoSignpost($shrine)
	If $DeadOnTheRun = 0 Then RndSleep(1000)
	If $DeadOnTheRun = 0 Then GoSignpost(-1)
	If $DeadOnTheRun = 0 Then RndSleep(3000)

	$enemy = "Margonite Boss"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-18176, -13412, $enemy)
	If $DeadOnTheRun = 0 Then RndSleep(1000)
EndFunc

Func VQNorn();
	CurrentAction("Taking blessing")
	MoveTo(-2034, -4512)
	$deadlock = 0
	Do
		GoNearestNPCToCoords(-2034, -4512)
		RndSleep(1000)
		Dialog(0x00000084)
		RndSleep(1000)
		$deadlock+=1
	Until DllStructGetData(geteffect(2591), 'skillid') = 2591 or DllStructGetData(geteffect(2469), 'skillid') = 2469 or $deadlock = 10 ; luxon = 1947


	Do
		$DeadOnTheRun = 0
		If $DeadOnTheRun = 0 Then $enemy = "Berzerker"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-5278, -5771, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-5456, -7921, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-8793, -5837, $enemy)

		If $DeadOnTheRun = 0 Then $enemy = "Vaettir and Berzerker"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-14092, -9662, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-17260, -7906, $enemy)

		If $DeadOnTheRun = 0 Then $enemy = "Jotun "
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-21964, -12877, $enemy, 2500)
		If  $DeadOnTheRun = 1 then RndSlp(15000)
	Until CheckArea(-21964, -12877)

	CurrentAction("Taking blessing")
	GoNearestNPCToCoords(-25274, -11970)
	RndSleep(1000)

	Do
		$DeadOnTheRun = 0
		If $DeadOnTheRun = 0 Then MoveTo(-22275, -12462)

		If $DeadOnTheRun = 0 Then $enemy = "Berzerker"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-21671, -2163, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-19592, 772, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-13795, -751, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-17012, -5376, $enemy)
		If  $DeadOnTheRun = 1 then RndSlp(15000)
	Until CheckArea(-17012, -5376)

	CurrentAction("Taking blessing")
	GoNearestNPCToCoords(-12071, -4274)

	Do
		$DeadOnTheRun = 0
		If $DeadOnTheRun = 0 Then $enemy = "Berzerker"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-8351, -2633, $enemy)
		If $DeadOnTheRun = 0 Then MoveTo(-4362, -1610)

		If $DeadOnTheRun = 0 Then $enemy = "Lake"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-4316, 4033, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-8809, 5639, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-14916, 2475, $enemy)
		If  $DeadOnTheRun = 1 then RndSlp(15000)
	Until CheckArea(-14916, 2475)

	CurrentAction("Taking blessing")
	GoNearestNPCToCoords(-11282, 5466)

	Do
		$DeadOnTheRun = 0
		If $DeadOnTheRun = 0 Then $enemy = "Elemental"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-16051, 6492, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-16934, 11145, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-19378, 14555, $enemy)
		If  $DeadOnTheRun = 1 then RndSlp(15000)
	Until CheckArea(-19378, 14555)

		CurrentAction("Taking blessing")
		GoNearestNPCToCoords(-22751, 14163)

	Do
		$DeadOnTheRun = 0
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-15932, 9386, $enemy)
		If $DeadOnTheRun = 0 Then MoveTo(-13777, 8097)

		If $DeadOnTheRun = 0 Then $enemy = "Lake"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-4729, 15385, $enemy)
		If  $DeadOnTheRun = 1 then RndSlp(15000)
	Until CheckArea(-4729, 15385)

	CurrentAction("Taking blessing")
	GoNearestNPCToCoords(-2290, 14879)

	Do
		$DeadOnTheRun = 0
		If $DeadOnTheRun = 0 Then $enemy = "Modnir"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-1810, 4679, $enemy)

		If $DeadOnTheRun = 0 Then $enemy = "Boss"
		If $DeadOnTheRun = 0 Then MoveTo(-6911, 5240)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-15471, 6384, $enemy)
		If $DeadOnTheRun = 0 Then moveTo(-411, 5874)

		If $DeadOnTheRun = 0 Then $enemy = "Modniir "
		If $DeadOnTheRun = 0 Then AggroMoveToEx(2859, 3982, $enemy)

		If $DeadOnTheRun = 0 Then $enemy = "Ice Imp"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(4909, -4259, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(7514, -6587, $enemy)

		If $DeadOnTheRun = 0 Then $enemy = "Berserker"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(3800, -6182, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(7755, -11467, $enemy)

		If $DeadOnTheRun = 0 Then $enemy = "Elementals and Griffins"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(15403, -4243, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(21597, -6798, $enemy)
		If  $DeadOnTheRun = 1 then RndSlp(15000)
	Until CheckArea(21597, -6798)

	CurrentAction("Taking blessing")
	GoNearestNPCToCoords(24522, -6532)

	Do
		$DeadOnTheRun = 0
		If $DeadOnTheRun = 0 Then AggroMoveToEx(22883, -4248, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(18606, -1894, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(14969, -4048, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(13599, -7339, $enemy)

		If $DeadOnTheRun = 0 Then $enemy = "Ice Imp"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(10056, -4967, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(10147, -1630, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(8963, 4043, $enemy)
		If  $DeadOnTheRun = 1 then RndSlp(15000)
	Until CheckArea(8963, 4043)

	CurrentAction("Taking blessing")
	GoNearestNPCToCoords(8963, 4043)

	Do
		$DeadOnTheRun = 0
		If $DeadOnTheRun = 0 Then $enemy = ""
		If $DeadOnTheRun = 0 Then AggroMoveToEx(15576, 7156, $enemy)

		If $DeadOnTheRun = 0 Then $enemy = "Berserker"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(22838, 7914, $enemy, 2500)
		If  $DeadOnTheRun = 1 then RndSlp(15000)
	Until CheckArea(22838, 7914)

	CurrentAction("Taking blessing")
	;GoNearestNPCToCoords(-22961, 12757)
	GoNearestNPCToCoords(22961, 12757)

	Do
		$DeadOnTheRun = 0
		If $DeadOnTheRun = 0 Then $enemy = "Modniir and Elemental"
		If $DeadOnTheRun = 0 Then MoveTo(18067, 8766)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(13311, 11917, $enemy)
		If  $DeadOnTheRun = 1 then RndSlp(15000)
	Until CheckArea(13311, 11917)

	CurrentAction("Taking blessing")
	GoNearestNPCToCoords(13714, 14520)

	Do
		$DeadOnTheRun = 0
		If $DeadOnTheRun = 0 Then $enemy = "Modniir and Elemental"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(11126, 10443, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(5575, 4696, $enemy, 2500)

		If $DeadOnTheRun = 0 Then $enemy = "Modniir and Elemental 2"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-503, 9182, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(1582, 15275, $enemy, 2500)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(7857, 10409, $enemy, 2500)
		If  $DeadOnTheRun = 1 then RndSlp(15000)
	Until CheckArea(7857, 10409)
EndFunc

Func VQKurzick();
	CurrentAction("Taking blessing")
	$deadlock = 0
	Do
		GoNearestNPCToCoords(-12909, 15616)
		Dialog(0x85)
		RndSleep(1000)
		Dialog(0x86)
		RndSleep(1000)
		$deadlock+=1
	Until DllStructGetData(geteffect(593), 'skillid') = 593 or DllStructGetData(geteffect(912), 'skillid') = 912 or $deadlock = 10 ; luxon = 1947

	$enemy = "Mantis Group"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11733, 16729, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11942, 18468, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11178,20073, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11008, 16972, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11238, 15226, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10965, 13496, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10570, 11789, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10138, 10076, $enemy)

	$enemy = "Dredge Boss Warrior"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10289, 8329, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-8587, 8739, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-6853, 8496, $enemy)

	$enemy = "Dredge Patrol"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5211, 7841, $enemy)

	$enemy = "Missing Dredge Patrol"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4059, 11325, $enemy)

	$enemy = "Oni and Dredge Patrol"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4328, 6317, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4454, 4558, $enemy)

	$enemy = "Dredge Patrol Again"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4650, 2812, $enemy)

	$enemy = "Missing Patrol"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-9326,1601, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11000,2219, $enemy,5000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-6313,2778, $enemy)

	$enemy = "Dreadge Patrol"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4447, 1055, $enemy,3000)

	$enemy = "Warden and Dredge Patrol"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3832, -586, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3143, -2203, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5780, -4665, $enemy,3000)

	$enemy = "Warden Group / Mesmer Boss"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2541, -3848, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2108, -5549, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1649, -7250, $enemy,2500)

	$enemy = "Dredge Patrol and Mesmer Boss"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-666, -8708, $enemy,2500)

	$enemy = "Warden Group"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(526, -10001, $enemy)

	$enemy = "Warden Group"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(1947, -11033, $enemy)

	$enemy = "Warden Group"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(3108, -12362, $enemy)

	$enemy = "Kirin Group"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(2932, -14112, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(2033, -15621, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(1168, -17145, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-254, -18183, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1934, -18692, $enemy)

	$enemy = "Warden Patrol"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3676, -18939, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5433, -18839, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3679, -18830, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1925, -18655, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-274, -18040, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(1272, -17199, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(2494, -15940, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(3466, -14470, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(4552, -13081, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6279, -12777, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7858, -13545, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8396, -15221, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(9117, -16820, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(10775, -17393, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(9133, -16782, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8366, -15202, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8083, -13466, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6663, -12425, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5045, -11738, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(4841, -9983, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5262, -8277, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5726, -6588, $enemy)

	$enemy = "Dredge Patrol / Bridge / Boss"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5076, -4955, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(4453, -3315, $enemy,3000)

	$enemy = "Dedge Patrol"
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5823, -2204, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7468, -1606, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8591, -248, $enemy, 3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8765, 1497, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(9756, 2945, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(11344, 3722, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(12899, 2912, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(12663, 4651, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(13033, 6362, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(13018, 8121, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(11596, 9159, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(11880, 10895, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(11789, 12648, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(10187, 13369, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8569, 14054, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8641, 15803, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(10025, 16876, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(11318, 18944, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8621, 15831, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7382, 14594, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6253, 13257, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5531, 11653, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6036, 8799, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(4752, 7594, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(3630, 6240, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(4831, 4966, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6390, 4141, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(4833, 4958, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(3167, 5498, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(2129, 4077, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(3151, 5502, $enemy)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2234, 311, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(2474, 4345, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(3294, 5899, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(3072, 7643, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(1836, 8906, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(557, 10116, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-545, 11477, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1413, 13008, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2394, 14474, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3986, 15218, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5319, 16365, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5238, 18121, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-7916, 19630, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3964, 19324, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2245, 19684, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-802, 18685, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(74, 17149, $enemy,3000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(611, 15476, $enemy,4000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(2139, 14618, $enemy,4000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(3883, 14448, $enemy,4000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5624, 14226, $enemy,4000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7384, 14094, $enemy,4000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8223, 12552, $enemy,4000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7148, 11167, $enemy,4000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5427, 10834, $enemy,10000)
EndFunc

Func VQDeldrimor();
	CurrentAction("Taking blessing")

	$deadlock = 0
	Do
		GoNearestNPCToCoords(-14103, 15457)
		RndSleep(1000)
		Dialog(0x00000084)
		RndSleep(1000)
		$deadlock+=1
	Until DllStructGetData(geteffect(2565), 'skillid') = 2565 or DllStructGetData(geteffect(2445), 'skillid') = 2445 or $deadlock = 10 ; luxon = 1947

	Do
		$DeadOnTheRun = 0
		If $DeadOnTheRun = 0 Then $enemy = "Snowmen at begining"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-15988, 10018, $enemy)

		If $DeadOnTheRun = 0 Then CurrentAction("Avoiding snowball")
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-17986, 6483)
		If $DeadOnTheRun = 0 Then RndSleep(1000)

		If $DeadOnTheRun = 0 Then $enemy = "Snowmen"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-17574, 2190, $enemy)

		If $DeadOnTheRun = 0 Then $enemy = "Cleaning way"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-15361, 2551, $enemy)

		If $DeadOnTheRun = 0 Then $enemy = "Going to shrine"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-14596, 2612, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-14506, 3963, $enemy)
		If  $DeadOnTheRun = 1 then RndSlp(15000)
	Until CheckArea(-14506, 3963)

	CurrentAction("Taking blessing")
	GoNearestNPCToCoords(-12512, 3919)
	RndSleep(500)

	Do
		$DeadOnTheRun = 0
		If $DeadOnTheRun = 0 Then $enemy = "Snowman on the way"
		If $DeadOnTheRun = 0 Then CurrentAction("Moving away")
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-14556, 4065)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-14596, 2612)
		If $DeadOnTheRun = 0 Then CurrentAction("Avoiding Icy")
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-14583, 1896)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-14262, 974)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-13759, -552)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-13306, -1211)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-12570, -2997)


		If $DeadOnTheRun = 0 Then $enemy = "Snowman"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-13114, -6255, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-14367, -9244, $enemy)
		If  $DeadOnTheRun = 1 then RndSlp(15000)
	Until CheckArea(-14367, -9244)

	CurrentAction("Taking blessing")
	GoNearestNPCToCoords(-16025, -10702)
	RndSleep(500)

	Do
		$DeadOnTheRun = 0
		If $DeadOnTheRun = 0 Then $enemy = "Ennemy near door"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-15396, -10850, $enemy)
		If $DeadOnTheRun = 0 Then Moveto(-13970, -9719)
		If $DeadOnTheRun = 0 Then Moveto(-13047, -10683)
		If $DeadOnTheRun = 0 Then $enemy = "Angry Snowman"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-10097, -11373, $enemy)
		If  $DeadOnTheRun = 1 then RndSlp(15000)
	Until CheckArea(-10097, -11373)

	$enemy = "Grabing Key"
	Moveto(-9852, -11078)
	RndSleep(500)
	PickupItems(-1, 1500)
	RndSleep(2000)
	MoveTo(-9547, -10960)
;~ 	For $i = 1 To GetMaxAgents()
;~ 		$lAgentToCompare = GetAgentByID($i)
;~ 		If DllStructGetData($lAgentToCompare, 'PlayerNumber') <> 116 then ContinueLoop
;~ 		rndslp(1000)
;~ 		ChangeTarget($lAgentToCompare)
;~ 		rndslp(500)
;~ 		PickUpItem($lAgentToCompare)
;~ 	Next
	RndSleep(500)
	PickupItems(-1, 1500)
	rndslp(1000)

	CurrentAction("Going to open the door")
	Moveto(-11464, -11034)
	Moveto(-14162, -9527)
	Moveto(-15284, -10824)
	Moveto(-15454, -12245)
	RndSleep(500)
	$door = GetNearestSignpostToAgent()
	RndSleep(500)
	GoSignpost($door)
	RndSleep(500)
	Moveto(-15869, -12119)

	Do
		$DeadOnTheRun = 0
		If $DeadOnTheRun = 0 Then $enemy = "Snowman"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-17287, -13895, $enemy)

		If $DeadOnTheRun = 0 Then $enemy = "Boss and others"
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-15483, -16565, $enemy)
		If $DeadOnTheRun = 0 Then AggroMoveToEx(-13362, -17430, $enemy)
		If  $DeadOnTheRun = 1 then RndSlp(15000)
	Until CheckArea(-13362, -17430)

	CurrentAction("Grabing boss key")
	Moveto(-12974, -17414)
	RndSleep(500)
	PickupItems(-1, 3500)

	CurrentAction("Going to open door")
	Moveto(-11215, -18002)
	$door = GetNearestSignpostToAgent()
	RndSleep(500)
	GoSignpost($door)
	RndSleep(500)

	Moveto(-11300, -18290)
	CurrentAction("Going in")
	Moveto(-9618, -19271)
	CurrentAction("Move to chest")
	Moveto(-7856, -19136)
	Moveto(-7730, -18648)

	EnsureEnglish(True)

	CurrentAction("Waiting on Chest")
	local $chestspawn = False
	local $TimerGuynotThere = TimerInit()
	Do
		TargetNearestItem()
		rndslp(500)
		If GetAgentName(GetCurrentTarget()) = "Chest of Wintersday Past" Then $chestspawn = True
		If TimerDiff($TimerGuynotThere) > 240000 Then
			CurrentAction("Apparently, Koris is stuck somewhere on the dungeon, go again")
			rndslp(2000)
			Return
		EndIf
	Until $chestspawn = True

	RndSleep(500)


	CurrentAction("Opening Chest")
	$chest = GetNearestSignpostToAgent()
	RndSleep(500)
	GoSignpost($chest)
	RndSleep(1000)


	CurrentAction("Picking")
	PickupItems(-1,1500)
	RndSleep(500)
	TravelTo($Map_To_Zone)
	WaitForLoad()
	CurrentAction("Waiting to really complete load")
	rndslp(5000)

	;GoNearestNPCToCoords(-23823, 13889)
	;rndslp(750)
	;Dialog(8618503)
	;rndslp(500)
	CurrentAction("Drop Quest")
	rndslp(5000)
	AbandonQuest(898)
	rndslp(500)
	SwapDistricts()
EndFunc

Func SwapDistricts()
	CurrentAction("Moving GH")

	TravelGH()
	RndSleep(3000)
	CurrentAction("Leaving GH")
	LeaveGH()
;~ 	$region = GetRegion()
;~ 	If $region = 3 Then ; si Asie
;~ 		$intDist = 2 ; europe
;~ 		MoveMap($Map_To_Zone, $intDist, 1, 5) ; spanish
;~ 		WaitForLoad()
;~ 	Else ;sinon
;~ 		$intDist = 3 ;asie
;~ 		MoveMap($Map_To_Zone, $intDist, 1, 0) ;tradChine
;~ 		WaitForLoad()
;~ 	EndIf

;~ 	CurrentAction("District changed")
	RndSleep(3000)
EndFunc

Func VQAsura();
	CurrentAction("Taking Blessing")
	$deadlock = 0
	Do
		GoNearestNPCToCoords(14796, 13170)
		rndslp(1000)
		Dialog(0x00000084)
		rndslp(1000)
		$deadlock+=1
	Until DllStructGetData(geteffect(2552), 'skillid') = 2552 or DllStructGetData(geteffect(2481), 'skillid') = 2481 or $deadlock = 10 ; luxon = 1947


	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
	If $DeadOnTheRun = 0 Then MoveTo(16722, 11774)
	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
	If $DeadOnTheRun = 0 Then MoveTo(17383, 8685)

	If $DeadOnTheRun = 0 Then AggroMoveToEx(18162, 6670, "First Spider Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(18447, 4537, "Second Spider Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(18331, 2108, "Spider Pop")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(17526, 143, "Spider Pop 2")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(17205, -1355, "Third Spider Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(17366, -5132, "Krait Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(18111, -8030, "Krait Group")

	If $DeadOnTheRun = 0 Then CurrentAction("Taking Blessing")
	If $DeadOnTheRun = 0 Then GoNearestNPCToCoords(18409, -8474)
	If $DeadOnTheRun = 0 Then rndslp(1000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(18613, -11799, "Froggy Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(17154, -15669, "Krait Patrol")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(14250, -16744, "Second Patrol")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(12186, -14139, "Krait Patrol")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(12540, -13440, "Krait Patrol")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(13234, -9948, "Krait Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8875, -9065, "Krait Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(4671, -8699, "Krait Patrol")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(1534, -5493, "Krait Group")
	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
	If $DeadOnTheRun = 0 Then MoveTo(1052, -7074)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1029, -8724, "Spider Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3439, -10339, "Krait Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2797, -13645, "Spider Cave")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3393, -15633, "Spider Cave")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4635, -16643, "Spider Pop")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-7814, -17796, "Spider Group")

	If $DeadOnTheRun = 0 Then CurrentAction("Taking Blessing")
	If $DeadOnTheRun = 0 Then GoNearestNPCToCoords(-10109, -17520)
	If $DeadOnTheRun = 0 Then rndslp(1000)
	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
	If $DeadOnTheRun = 0 Then MoveTo(-9111, -17237)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10963, -15506, "Ranger Boss Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-12885, -14651, "Froggy Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11912, -10641, "Froggy Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10760, -9933, "Krait Boss Warrior")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-14030, -9780, "Froggy Coing Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-12368, -7330, "Froggy Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-16527, -8175, "Froggy Patrol")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-17391, -5984, "Froggy Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-15704, -3996, "Froggy Patrol")
	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
	If $DeadOnTheRun = 0 Then MoveTo(-16609, -2607)
	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
	If $DeadOnTheRun = 0 Then MoveTo(-15476, 186)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-16480, 2522, "Krait Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-17090, 5252, "Krait Group")

	If $DeadOnTheRun = 0 Then CurrentAction("Taking Blessing")
	If $DeadOnTheRun = 0 Then GoNearestNPCToCoords(-19292, 8994)
	If $DeadOnTheRun = 0 Then rndslp(1000)
	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
	If $DeadOnTheRun = 0 Then MoveTo(-18640, 8724)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-18484, 12021, "Krait Patrol")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-17180, 13093, "Krait Patrol")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-15072, 14075, "Froggy Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11888, 15628, "Froggy Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-12043, 18463, "Froggy Boss Warrior")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-8876, 17415, "Froggy Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5778, 19838, "Froggy Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10970, 16860, "Moving Back")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-9301, 15054, "Moving")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5379, 16642, "Krait Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4430, 17268, "Krait Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2974, 14197, "Krait Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5228, 12475, "Boss Patrol")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3468, 10837, "Lonely Patrol")

	If $DeadOnTheRun = 0 Then CurrentAction("Taking Blessing")
	If $DeadOnTheRun = 0 Then GoNearestNPCToCoords(-2037, 10758)
	If $DeadOnTheRun = 0 Then rndslp(1000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3804, 8017, "Krait Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1346, 12360, "Moving")
	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
	If $DeadOnTheRun = 0 Then MoveTo(874, 14367)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(3572, 13698, "Krait Group Standing")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5899, 14205, "Moving")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7407, 11867, "Krait Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(9541, 9027, "Rider")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(12639, 7537, "Rider Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(9064, 7312, "Rider")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7986, 4365, "Krait group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6341, 3029, "Krait Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7097, 92, "Krait Group")

	If $DeadOnTheRun = 0 Then CurrentAction("Taking Blessing")
	If $DeadOnTheRun = 0 Then GoNearestNPCToCoords(4893, 445)
	If $DeadOnTheRun = 0 Then rndslp(1000)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8943, -985, "Krait Boss")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(10949, -2056, "Krait Patrol")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(11870, -4403, "Rider Patrol")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8193, -841, "Moving Back")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(3284, -1599, "Krait Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-76, -1498, "Krait Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(578, 719, "Krait Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(316, 2489, "Krait Group")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1018, -1235, "Moving Back")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3195, -1538, "Krait Patrol")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-6322, -2565, "Krait Group")

	If $DeadOnTheRun = 0 Then CurrentAction("Taking Blessing")
	If $DeadOnTheRun = 0 Then GoNearestNPCToCoords(-9231, -2629)
	If $DeadOnTheRun = 0 Then rndslp(1000)
EndFunc