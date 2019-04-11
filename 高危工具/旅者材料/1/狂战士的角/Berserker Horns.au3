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
		If GetMapID() <> 645 Then ;Outpost: Olafsted
			CurrentAction("Moving to Outpost")
			TravelTo(645)
			WaitMapLoading(645)
		EndIf;
		rndslp(500)
		CurrentAction("Begin run number " & $NumberRun)
		SwitchMode(0) ;Normal Mode


		While (CountSlots() > 4)
			$NumberRun = $NumberRun +1
			GoOut()
			VQ()
		WEnd

	EndIf
	sleep(50)
WEnd

Func GoOut()
	RndSleep(250)
	CurrentAction("Going out")
	MoveTo(-141, 1416)
	Move(-1448, 1171)
	WaitMapLoading(553)
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
	$DeadOnTheRun = 0
	AdlibRegister("CheckPartyDead", 2000)
	AdlibRegister("SSpoint", 5000)
	AdlibRegister("HeroBuff", 5000)
	
	CurrentAction("Farming.")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5278, -5771) ;Berserker
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5456, -7921)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-8793, -5837)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-14092, -9662) ;Vaettir and Berserker
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-17260, -7906)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-21964, -12877) ;Jotun
	
	If $DeadOnTheRun = 0 Then MoveTo(-22275, -12462)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-21671, -2163); Berserker
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-19592, 772)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-13795, -751)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-17012, -5376)

	If $DeadOnTheRun = 0 Then AggroMoveToEx(-8351, -2633) ;Berserker
	
	If $DeadOnTheRun = 0 Then $RunSuccess = $RunSuccess + 1	
	
	Resign()
	rndsleep(5000)
	returntooutpost()
	WaitMapLoading(645)
	
	GUICtrlSetData($gui_status_successful, $RunSuccess)
	AdlibUnRegister("CheckPartyDead")
	AdlibUnRegister("SSpoint")
	AdlibUnRegister("HeroBuff")
EndFunc