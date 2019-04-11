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
;~ Global $GWA_CONST_UnyieldingAura=268

Global $Outpost = 638 ;Outpost: Gadd's Encampment
Global $Area1 = 558 ;Area: Sparkfly Swamp

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
	MoveTo(-9687.34, -21318.19)
	Move(-9610, -20150)
	WaitMapLoading($Area1)
	sleep(1500)

	Move(-9500, -20400)
	WaitMapLoading($Outpost)
EndFunc

Func GoOut()
	RndSleep(1250)
	CurrentAction("Going out")
	MoveTo(-9687.34, -21318.19)
	Move(-9610, -20150)
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

;~ Func HeroBuff()
;~ 	$mSkillBar = GetSkillbar(3)
;~ 	$mHeroInfo = GetAgentByID(GetHeroID(3))
;~ 	If GetIsTargetBuffed($GWA_CONST_UnyieldingAura,  GetHeroID(3), 3) == 0 AND DllStructGetData($mSkillBar, 'Recharge1') == 0 AND GetIsDead($mHeroInfo) == False Then
;~ 		UseHeroSkill(3, 1,  GetHeroID(3))
;~ 	EndIf
;~ EndFunc

Func VQ()
	CurrentAction("Waiting to really complete load")
;	WaitMapLoading($Area1)
	$DeadOnTheRun = 0
	AdlibRegister("CheckPartyDead", 2000)
;~ 	AdlibRegister("SSpoint", 5000)
;~ 	AdlibRegister("HeroBuff", 5000)

	CurrentAction("Farming.")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11007.70, -17393.77)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10739.70, -14456.50)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11104.98, -11254.47)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-9806.15, -7910.73)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10107.76, -4975.58)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10604.46, -2672.81)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10741.31, -1255.74)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10010.21, 306.43)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-7247.71, 337.38)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5654.51, 3120.60)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-7180.38, 4636.34)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5523.31, 7539.05)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-8092.21, 8495.93)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10194.71, 10308.22)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11227.45, 14163.96)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10897.41, 15866.70)


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