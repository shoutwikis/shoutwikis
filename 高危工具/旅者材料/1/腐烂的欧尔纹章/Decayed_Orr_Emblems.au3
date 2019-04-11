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

Global $Outpost = 57 ;Outpost: Bergen Hot Springs
Global $Area1 = 59 ;Area: Nebo Terrace

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
			
			_PurgeHook()
;			clearmemory()
		WEnd

	EndIf
	sleep(50)
WEnd

Func FastWayOut()
	MoveTo(15805, -16320)
	MoveTo(15493, -15469)
	Move(15400, -15000)
	WaitMapLoading($Area1)
	sleep(500)

	Move(15450, -15100)
	WaitMapLoading($Outpost)
EndFunc

Func GoOut()
	RndSleep(250)
	CurrentAction("Going out")
	MoveTo(15493, -15469)
	Move(15400, -15000)
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
	If $DeadOnTheRun = 0 Then AggroMoveToEx(16135.04, -12856.54)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(15266.29, -11781.90)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(13591.32, -14193.14)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(11953.23, -14603.85)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8636.66, -11729.92)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8426.54, -9726.69)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(9657.55, -8717.12)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7801.11, -7802.52)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6336.25, -5988.23)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(1448.43, -7135.33)
;	If $DeadOnTheRun = 0 Then AggroMoveToEx(-192.42, -11619.81)
	
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