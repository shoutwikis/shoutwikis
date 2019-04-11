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

Global $Outpost = 14 ;Outpost: Gates of Kryta
Global $Area1 = 54 ;Area: Scoundrel's Rise
Global $Area2 = 27 ;Area: Griffons Mouth
Global $Area3 = 100 ;Area: Deldrimor Bowl

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

Func GoOut()
	RndSleep(250)
	CurrentAction("Going out")
	MoveTo(-4212, 26608)
	Move(-4400, 26800)
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

Func MoveToArea()
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2252, -4813)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-6, -2627)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(4015, -1619)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5864, 1478)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5933, 3066)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7449, 4733)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7549, 6409)
	If $DeadOnTheRun = 0 Then Move(7550, 7900)
	WaitMapLoading($Area2)
EndFunc

Func VQ()
	CurrentAction("Waiting to really complete load")
;	WaitMapLoading($Area1)
	$DeadOnTheRun = 0
	AdlibRegister("CheckPartyDead", 2000)
	AdlibRegister("SSpoint", 5000)
	AdlibRegister("HeroBuff", 5000)
	
	CurrentAction("Farming.")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-6146, -5953)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3579, -7508)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1770, -7032)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-193, -6646)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1770, -7032)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1354, -5803)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2148, -4617)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1418, -3297)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2659, -1441)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4817, -1160)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-7434, 782)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-6420, 3538)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3824, 5220)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2141, 4237)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1050, 3802)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-232, 6727)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(1217, 6570)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(2393, 7901)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(3294, 8235)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(4801, 7240)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6327, 6320)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7275, 6521)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7565, 7339)
	If $DeadOnTheRun = 0 Then Move(7850, 7900) ;Move into Deldrimor Bowl
	WaitMapLoading($Area3)
	
	If $DeadOnTheRun = 0 Then Move(-13900, -23150) 	;Move back into Griffons Mouth
	WaitMapLoading($Area2)

	If $DeadOnTheRun = 0 Then AggroMoveToEx(7565, 7339)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(7275, 6521)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6327, 6320)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(4801, 7240)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(3294, 8235)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(2393, 7901)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(1217, 6570)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-232, 6727)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1050, 3802)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2141, 4237)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3824, 5220)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-6420, 3538)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-7434, 782)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4817, -1160)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2659, -1441)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1418, -3297)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2148, -4617)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1354, -5803)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1770, -7032)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-193, -6646)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1770, -7032)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3579, -7508)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-6146, -5953)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-7709, -7300)
	If $DeadOnTheRun = 0 Then Move(-7600, -7750)	
	WaitMapLoading($Area1)	
	
	If $DeadOnTheRun = 0 Then Move(7550, 7900)
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