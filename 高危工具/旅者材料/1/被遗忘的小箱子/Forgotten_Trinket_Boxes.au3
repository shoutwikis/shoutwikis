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

Global $Outpost = 251 ;Outpost: Dunes Of Despair
Global $Area1 = 111 ;Area: Vulture Drifts

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

		FastWayOut()
		
		While (CountSlots() > 4)
			$NumberRun = $NumberRun +1
			GoOut()
			VQ()
		WEnd

		_PurgeHook()
		clearmemory()
		
	EndIf
	sleep(50)
WEnd

Func FastWayOut()
	RndSleep(250)
	CurrentAction("Going out")
	MoveTo(16782, 19563)
	Move(17000, 19850)
	WaitMapLoading($Area1)
	sleep(500)
	
	Move(-19980, -1800)
	WaitMapLoading($Outpost)
EndFunc

Func GoOut()
	RndSleep(250)
	CurrentAction("Going out")
	MoveTo(16782, 19563)
	Move(17000, 19850)
	WaitMapLoading($Area1)
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
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-17942, -1124)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-15453, -2773)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-13719, -2407)				
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-13764, -621)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-13180, -556)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-13180, -849)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-14480, 1257)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-14651, 3620)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-15316, 4944)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-14358, 4856)	
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-12634, 3390)	

	
	If $DeadOnTheRun = 0 Then $RunSuccess = $RunSuccess + 1	
	
	Resign()
	rndsleep(5000)
	returntooutpost()
	WaitMapLoading($Outpost)
	
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