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
Global $GWA_CONST_UnyieldingAura=268

Global $Outpost = 206 ;Outpost: Deldrimor Warcamp
Global $Area1 = 191 ;Area: Grenth's Footprint
Global $Area2 = 190 ;Area: Sorrows Furnace

While 1
	If $boolrun = true Then
		If $NumberRun = 0 Then ;first run
			AdlibRegister("status", 1000)
			$TimerTotal = TimerInit()
			$SS_title_at_begining = GetAsuraTitle()
		EndIf
		If GetMapID() <> $Outpost Then
			CurrentAction("Moving to Outpost")
			TravelTo($Outpost)
			WaitMapLoading($Outpost)
		EndIf;
		rndslp(500)
		CurrentAction("Begin run number " & $NumberRun)
		SwitchMode(0) ;Normal Mode

;		FastWayOut()
		GoOut()	
		MoveToArea()
		While (CountSlots() > 4)
			$NumberRun = $NumberRun +1
			VQ()
			_PurgeHook()
			clearmemory()
		WEnd
		
	EndIf
	sleep(50)
WEnd

;Func FastWayOut()
;	RndSleep(250)
;	CurrentAction("Going out")
;	MoveTo(16782, 19563)
;	Move(17000, 19850)
;	WaitMapLoading($Area1)
;	sleep(500)
;	
;	Move(-19980, -1800)
;	WaitMapLoading($Outpost)
;EndFunc

Func GoOut()
	RndSleep(250)
	CurrentAction("Going out")
	MoveTo(-2920, -4681)
	Move(-2800, -4550)
	WaitMapLoading($Area1)
EndFunc

Func MoveToArea()
	If $DeadOnTheRun = 0 Then GoNearestNPCToCoords(-2822, -3405)
	If $DeadOnTheRun = 0 Then Dialog(0x80EA01) ;Quest: To Sorrows Furnace
;	If $DeadOnTheRun = 0 Then Dialog(0x2) ;Select Killroy Stoneskin
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3316, -2836)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-466, -342)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3722, -1193)				
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-6106, -4419)	
;	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5258, -6663)	
;	If $DeadOnTheRun = 0 Then GoNearestNPCToCoords(-5841, -7599)
;	If $DeadOnTheRun = 0 Then Dialog(0x1) ;Killroy Quest
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5908, -5709)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-8460, -6063)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-8520, -470)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-6474, -531)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-8325, 2856)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-8377, 6104)
	If $DeadOnTheRun = 0 Then Move(-9150, 7400)
	WaitMapLoading($Area2)
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
;	WaitMapLoading($Area1)
	$DeadOnTheRun = 0
	AdlibRegister("CheckPartyDead", 2000)
	AdlibRegister("SSpoint", 5000)
	AdlibRegister("HeroBuff", 5000)
	
	CurrentAction("Farming.")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-17004, 16469)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-16470, 14179)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-14542, 13925)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11773, 14899)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-9689, 16235)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-9473, 14764)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10097, 12305)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-9481, 11976)
	
	;Move back to Grenth's Footprint
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11820, 14879)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-14999, 13693)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-16641, 14404)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-16955, 16252)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-15469, 17504)
	If $DeadOnTheRun = 0 Then Move (-15100, 17850)
	
	WaitMapLoading($Area1)
	If $DeadOnTheRun = 0 Then Move(-9150, 7400)
	WaitMapLoading($Area2)
	
	If $DeadOnTheRun = 0 Then $RunSuccess = $RunSuccess + 1	
	
;	Resign()
;	rndsleep(5000)
;	returntooutpost()
;	WaitMapLoading($Outpost)
	
	GUICtrlSetData($gui_status_successful, $RunSuccess)
	AdlibUnRegister("CheckPartyDead")
	AdlibUnRegister("SSpoint")
	AdlibUnRegister("HeroBuff")
EndFunc

Func _PurgeHook()
	If not $RenderingEnabled then
		ClearMemory()
		enableRendering()
		WinSetState(getWindowHandle(), "", @SW_SHOW)
		Sleep(1000)
		disableRendering()
		WinSetState(getWindowHandle(), "", @SW_HIDE)
   EndIf
EndFunc