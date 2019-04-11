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

Global $Outpost = 250 ;Outpost: Seitung Harbor
Global $Area1 = 196 ;Area: Jaya Bluffs

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
	MoveTo(17700, 16979)
	Move(16800, 17550)
	WaitMapLoading($Area1)
	sleep(1500)

	Move(10900, -13350)
	WaitMapLoading($Outpost)
EndFunc

Func GoOut()
	RndSleep(1250)
	CurrentAction("Going out")
	MoveTo(17700, 16979)
	Move(16800, 17550)
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
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8888, -12615)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7761, -9349)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8560, -6618)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7820, -5765)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7923, -4100)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8340, -6928)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(11357, -7966)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(13443, -6892)			
	If $DeadOnTheRun = 0 Then AggroMoveToEx(14718, -8450)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(17473, -7688)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(19615, -9285)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(20102, -7377)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(19147, -7656)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(18942, -6299)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(19698, -5831)
	
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