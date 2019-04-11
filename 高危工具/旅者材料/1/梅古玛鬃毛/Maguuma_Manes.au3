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
		If GetMapID() <> 142 Then ;Outpost: Thirsty River
			CurrentAction("Moving to Outpost")
			TravelTo(142)
			WaitMapLoading(142)
		EndIf;
		rndslp(500)
		CurrentAction("Begin run number " & $NumberRun)
		SwitchMode(0) ;Normal Mode

	
;		FastWayOut()
		
		While (CountSlots() > 4)
			$NumberRun = $NumberRun +1
			GoOut()
			VQ()
		WEnd

	EndIf
	sleep(50)
WEnd

;Func FastWayOut()
;	RndSleep(250)
;	CurrentAction("Going out")
;	MoveTo(12697, 12769)
;	Move(12960, 13395)
;	WaitMapLoading(108)
;	sleep(500)
;	
;	Move(15950, -23450)
;	WaitMapLoading(117)
;EndFunc

Func GoOut()
	RndSleep(250)
	CurrentAction("Going out")
	MoveTo(1680, -2680)
	Move(1980, -2305)
	WaitMapLoading(108)
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
	If $DeadOnTheRun = 0 Then MoveTo(1514, 184)	
	If $DeadOnTheRun = 0 Then MoveTo(-239, 911)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2606, -2222)
	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4853, -6897)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-7699, -10254)	
	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5213, -12973)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2541, -11790)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-399, -10482)		
	If $DeadOnTheRun = 0 Then AggroMoveToEx(3869, -13836)		
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5093, -9879)		
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5183, -6215)		
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8228, -3137)		
	If $DeadOnTheRun = 0 Then AggroMoveToEx(9392, -5300)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(10243, -10926)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(17659, -9041)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(14823, -1612)
	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(11781, 1778)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(9192, 851)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6367, 2552)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7986, 6977)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6389, 12273)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6222, 14873)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(12098, 16265)


	
	If $DeadOnTheRun = 0 Then $RunSuccess = $RunSuccess + 1	
	
	Resign()
	rndsleep(5000)
	returntooutpost()
	WaitMapLoading(117)
	
	GUICtrlSetData($gui_status_successful, $RunSuccess)
	AdlibUnRegister("CheckPartyDead")
	AdlibUnRegister("SSpoint")
	AdlibUnRegister("HeroBuff")
EndFunc