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

Global $Outpost = 159 ;Outpost: Copperhammer Mines
Global $Area1 = 98 ;Area: Frozen Forest

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
			clearmemory()
		WEnd

	EndIf
	sleep(50)
WEnd

Func FastWayOut()
	RndSleep(250)
	CurrentAction("Going out")
	MoveTo(-18009.95, 11219.18)
	Move(-17980, 9545.86)
	WaitMapLoading($Area1)
	sleep(1500)

	Move(-17865.34, 9461.10)
	WaitMapLoading($Outpost)
EndFunc

Func GoOut()
	RndSleep(1250)
	CurrentAction("Going out")
	MoveTo(-18009.95, 11219.18)
	Move(-17980, 9545.86)
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
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-17104.35, 8796.36)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-15415.88, 8108.52)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-15180.29, 5011.22)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-16503.80, 3910.32)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11765.31, 2246.08)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-8055.87, 856.61)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4374.63, 452.26)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2725.04, -927.86)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3216.61, -3933.16)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2026.34, -3830.08)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(700.50, -3071.44)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(1515.99, -1802.27)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(2765.57, -96.28)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(4209.64, -246.97)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7076.71, 1981.86)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(9465.69, 5637.44)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8994.33, 10696.91)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(12840.27, 12964.52)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(15607.42, 9883.58)

	
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