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

Global $Outpost = 440 ;Outpost: The Mouth of Torment
Global $Area1 = 439 ;Area: The Ruptured Heart
Global $Area2 = 443 ;Area: Poisoned Outcrops

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
	MoveTo(-411.51, -5821.02)
	MoveTo(1294.60, -2071.13)
	Move(1900, -1805)
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
	If $DeadOnTheRun = 0 Then AggroMoveToEx(2831.78, 97.54)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5403.83, 305.17)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6944.56, -2828.68)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8630.51, -3744.79)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6512.27, -5056.12)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(8232.37, -8433.65)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(11191.99, -8314.89)
    If $DeadOnTheRun = 0 Then AggroMoveToEx(12647.17, -6214.38)
    If $DeadOnTheRun = 0 Then AggroMoveToEx(16498.36, -2324.97)
    If $DeadOnTheRun = 0 Then AggroMoveToEx(17683.25, 738.44)
    If $DeadOnTheRun = 0 Then AggroMoveToEx(15174.68, 7131.87)
    If $DeadOnTheRun = 0 Then AggroMoveToEx(18078.87, 13008.97)
    If $DeadOnTheRun = 0 Then AggroMoveToEx(20453.46, 18019.07)
	If $DeadOnTheRun = 0 Then Move(21500, 18120)
	WaitMapLoading($Area2)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-24945.13, -6440.18)
	If $DeadOnTheRun = 0 Then Move(-25500, -6500)
    WaitMapLoading($Area1)
EndFunc

Func VQ()
	CurrentAction("Waiting to really complete load")
;	WaitMapLoading($Area1)
	$DeadOnTheRun = 0
	AdlibRegister("CheckPartyDead", 2000)
	AdlibRegister("SSpoint", 5000)
;~ 	AdlibRegister("HeroBuff", 5000)

	CurrentAction("Farming.")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(19776.53, 14918.50)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(14855.58, 13359.11)
    If $DeadOnTheRun = 0 Then AggroMoveToEx(13746.65, 10869.85)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(15171.55, 5481.86)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(12390.92, 4429.75)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(12896.89, 1432.04)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(14681.22, 921.32)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(16465.74, -1937.83)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(15412.41, 756.25)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(15296.05, 5183.90)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(13746.65, 10869.85)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(16976.64, 13261.30)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(20453.46, 18019.07)
	If $DeadOnTheRun = 0 Then Move(21500, 18120)
    WaitMapLoading($Area2)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-24945.13, -6440.18)
	If $DeadOnTheRun = 0 Then Move(-25500, -6500)
    WaitMapLoading($Area1)

	If $DeadOnTheRun = 0 Then $RunSuccess = $RunSuccess + 1

;	Resign()
;	rndsleep(5000)
;	returntooutpost()
;	WaitMapLoading($Outpost)

	GUICtrlSetData($gui_status_successful, $RunSuccess)
	AdlibUnRegister("CheckPartyDead")
	AdlibUnRegister("SSpoint")
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