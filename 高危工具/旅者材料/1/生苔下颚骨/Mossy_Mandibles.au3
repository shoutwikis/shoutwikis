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

Global $Outpost = 139 ;Outpost: Ventaris Refuge
Global $Area1 = 44 ;Area: Ettins Back
Global $Area2 = 45 ;Area: Reed Bog

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
	MoveTo(-14776, 613)
	Move(-15150, 380)
	WaitMapLoading($Area1)
EndFunc

Func MoveToArea()
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-17170, -1121)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-14955, -3674)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-14183, -7128)				
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-12715, -7820)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-12869, -9792)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-15781, -10138)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-19496, -8186)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-21120, -11460)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-22648, -11461)	
	If $DeadOnTheRun = 0 Then Move(-22800, -11440)
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
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5723, 5598)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(4706, 4472)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(2273, 5328)				
	If $DeadOnTheRun = 0 Then AggroMoveToEx(799, 6516)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-584, 7443)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2466, 6166)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5623, 5609)	

	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2466, 6166)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-584, 7443)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-584, 7443)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(799, 6516)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(2273, 5328)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(4706, 4472)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5723, 5598)
	If $DeadOnTheRun = 0 Then MoveTo(7563, 6934)
	If $DeadOnTheRun = 0 Then Move(7900, 6875)
	
	WaitMapLoading($Area1)
	If $DeadOnTheRun = 0 Then Move(-22800, -11440)
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