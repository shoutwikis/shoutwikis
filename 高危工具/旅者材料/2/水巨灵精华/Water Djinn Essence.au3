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

Global $Outpost = 478 ;Outpost: Gate of Desolation
Global $Area1 = 386 ;Area: Turai's Procession

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
	MoveTo(1747.09, -1853.84)
	MoveTo(3838.13, -4557.52)
	Move(4700, -4900)
	WaitMapLoading($Area1)
	sleep(500)

	Move(-14500, 26200)
	WaitMapLoading($Outpost)
EndFunc

Func GoOut()
	RndSleep(250)
	CurrentAction("Going out")
	MoveTo(3838.13, -4557.52)
	Move(4700, -4900)
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
;~ 	AdlibRegister("SSpoint", 5000)
;~ 	AdlibRegister("HeroBuff", 5000)

	CurrentAction("Farming.")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11364.01, 21008.78)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10610.21, 19133.15)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-8604.28, 14941.47)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4543.79, 13381.35)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1517.47, 13976.02)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1451.23, 15942.91)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1057.44, 19112.77)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-296.45, 20848.60)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(4153.44, 19360.10)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5103.99, 21115.26)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8080.92, 20646.09)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8482.01, 24115.99)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(11409.17, 22176.23)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(13722.87, 22851.45)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(15225.65, 18530.23)
    If $DeadOnTheRun = 0 Then AggroMoveToEx(15523.89, 14014.13)
    If $DeadOnTheRun = 0 Then AggroMoveToEx(12206.63, 16835.20)

	If $DeadOnTheRun = 0 Then $RunSuccess = $RunSuccess + 1

	Resign()
	rndsleep(5000)
	returntooutpost()
	WaitMapLoading($Outpost)

	GUICtrlSetData($gui_status_successful, $RunSuccess)
	AdlibUnRegister("CheckPartyDead")
;~ 	AdlibUnRegister("SSpoint")
;~ 	AdlibUnRegister("HeroBuff")
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