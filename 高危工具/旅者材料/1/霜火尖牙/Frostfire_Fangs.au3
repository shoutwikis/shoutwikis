#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include "GWA2.au3"
#include "AddsOn.au3"
#include "CommonFunction.au3"

global $SS_title_at_begining, $LB_title_at_begining
global $DeadOnTheRun = 0,$tpspirit = 0
Global $SSOutpost = 396
Global $GWA_CONST_UnyieldingAura=268

While 1
	If $boolrun = true Then
		If $NumberRun = 0 Then ;first run
			AdlibRegister("status", 1000)
			$TimerTotal = TimerInit()
			$SS_title_at_begining = GetAsuraTitle()
		EndIf
		If GetMapID() <> 132 Then ;Outpost: Ice Tooth Cave
			CurrentAction("Moving to Outpost")
			TravelTo(132)
			WaitMapLoading(132)
		EndIf;
		rndslp(500)
		CurrentAction("Begin run number " & $NumberRun)
		SwitchMode(0) ;Normal Mode

		GoOut()	
		MoveToArea()
		
		While (CountSlots() > 4)
			$NumberRun = $NumberRun +1
			VQ()
		WEnd

	EndIf
	sleep(50)
WEnd

Func GoOut()
	RndSleep(250)
	CurrentAction("Going out")
	MoveTo(-11580, 11684)
	Move(-12090, 11625)
	WaitMapLoading(89)
EndFunc

Func MoveToArea()
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-13691, 12948)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-9124, 16185)		
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4780, 16294)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-574, 14221)		
	If $DeadOnTheRun = 0 Then AggroMoveToEx(4538, 17396)		
	If $DeadOnTheRun = 0 Then AggroMoveToEx(10065, 16043)		
	If $DeadOnTheRun = 0 Then AggroMoveToEx(11350, 12982)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(14284, 10723)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(14181, 8983)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(16968, 8760)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(18401, 7792)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(20485, 16799)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(19369, 18841)
	Move(20370, 20300)
	WaitMapLoading(88);Iron Horse Mine
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
		If $DeadParty >= 6 Then
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
	WaitMapLoading(108)
	$DeadOnTheRun = 0
	AdlibRegister("CheckPartyDead", 2000)
	AdlibRegister("SSpoint", 5000)
	AdlibRegister("HeroBuff", 5000)
	
	CurrentAction("Farming.")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-22761, 6620)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-18454, 6136)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-15971, 7989)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-17909, 2505)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-19150, -353)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-17968, -3181)		
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-15618, -3329)		
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-12671, -4831)		
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-9175, -2707)		
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-8907, -4046)		

	If $DeadOnTheRun = 0 Then AggroMoveToEx(-12671, -4831)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-15618, -3329)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-17968, -3181)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-19150, -353)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-17552, 4711)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-24300, 6249)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-24078, 2695)
	
	;Zone: Anvil Rock
	MoveTo(-24384, 2693)
	Move(-25680, 1920)
	WaitMapLoading(89)
	
	;Zone: Iron Horse Mine	
	Move(20370, 20300)
	WaitMapLoading(88);Iron Horse Mine
	
	If $DeadOnTheRun = 0 Then $RunSuccess = $RunSuccess + 1	
	
	GUICtrlSetData($gui_status_successful, $RunSuccess)
	AdlibUnRegister("CheckPartyDead")
	AdlibUnRegister("SSpoint")
	AdlibUnRegister("HeroBuff")
EndFunc