#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include "GWA2.au3"
#include "AddsOn.au3"
#include "CommonFunction.au3"

global $DeadOnTheRun = 0
Global $FarmOutpostID = 130
Global $FarmAreaID = 128
Global $GWA_CONST_UnyieldingAura=268

While 1
	If $boolrun = true Then
		If $NumberRun = 0 Then ;first run
			AdlibRegister("status", 1000)
			$TimerTotal = TimerInit()
		EndIf
		If GetMapID() <> $FarmOutpostID Then ;Outpost: Vashburg
			CurrentAction("Moving to Outpost")
			TravelTo($FarmOutpostID)
			WaitMapLoading($FarmOutpostID)
		EndIf;
		rndslp(500)
		CurrentAction("Begin run number " & $NumberRun)
		SwitchMode(0) ;Normal Mode

		;Fast way out
		FastWayOut()

		While (CountSlots() > 4)
			$NumberRun = $NumberRun +1
			GoOut()
			VQ()
		WEnd

	EndIf
	sleep(50)
WEnd

Func GoOut()
	RndSleep(250)
	CurrentAction("Going out")
	MoveTo(18650, 2100)
	Move(18500, 2000)
	WaitMapLoading($FarmAreaID)
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
		If $DeadParty >= 5 Then
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

Func FastWayOut()
	CurrentAction("Setting Fast Way Out")
	MoveTo(19434, 5552)
	GoOut()
	MoveTo(18208, 2075)
	Move(18300,2150)
	WaitMapLoading($FarmOutpostID)
EndFunc

Func VQ()
	$DeadOnTheRun = 0
	AdlibRegister("CheckPartyDead", 2000)
	AdlibRegister("SSpoint", 5000)
	AdlibRegister("HeroBuff", 5000)

	CurrentAction("Farming.")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(17763, 1543)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(19340, -4157)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(18585, -5017)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(20727, -5865)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(17338, -3043)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(11881, 211)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(11938, -3758)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8383, -2596)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(4877, -2142)

	If $DeadOnTheRun = 0 Then $RunSuccess = $RunSuccess + 1

	GUICtrlSetData($gui_status_successful, $RunSuccess)
	AdlibUnRegister("CheckPartyDead")
	AdlibUnRegister("SSpoint")
	AdlibUnRegister("HeroBuff")

	;Resign and return to outpost
	ResignAndReturn($FarmOutpostID)
EndFunc

Func ResignAndReturn($imapId)
	Resign()
	rndsleep(5000)
	returntooutpost()
	WaitMapLoading($imapId)
EndFunc