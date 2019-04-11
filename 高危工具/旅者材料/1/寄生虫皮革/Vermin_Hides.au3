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

Global $Outpost = 51 ;Outpost: Senji's Corner
Global $Area1 = 31 ;Area: Xaquang Skyway

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
	MoveTo(8574.81, -14036.81)
	Move(6236.82, -12936.38)
	WaitMapLoading($Area1)
	sleep(1500)

	Move(6187, -12941)
	WaitMapLoading($Outpost)
EndFunc


Func GoOut()
	RndSleep(1250)
	CurrentAction("Going out")
	MoveTo(6937.75, -13726.41)
	Move(6236.82, -12936.38)
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
	If $DeadOnTheRun = 0 Then AggroMoveToEx(3045.32, -10249.77)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(582.92, -8535.72)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1234.38, -8201.78)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2054.08, -5418.10)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4880.74, -8352.55)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5908.17, -7215.08)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5913.48, -5436.12)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-6467.49, -3823.27)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10029.52, -3062.08)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11892.77, -3522.72)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-12191.40, -62.79)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-12293.42, 4940.91)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-14162.66, 5891.73)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-14380.24, 3695.14)
	
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