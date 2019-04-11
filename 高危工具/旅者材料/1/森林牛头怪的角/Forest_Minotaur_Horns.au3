#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include "GWA2.au3"
#include "AddsOn.au3"
#include "CommonFunction.au3"

;Modifications:
; - Added disable rendering function
; - Dropdown menu for character selection
; - Disabled log function
; - Removed some unnecessary code
; - Other small improvements

global $SS_title_at_begining, $LB_title_at_begining
global $DeadOnTheRun = 0,$tpspirit = 0
Global $SSOutpost = 396
Global $GWA_CONST_UnyieldingAura=268

While 1
	If $boolrun = true Then
		If $NumberRun = 0 Then ;first run
			AdlibRegister("status", 1000)
			$TimerTotal = TimerInit()
			$SS_title_at_begining = GetAsuraTitle()
		EndIf
		If GetMapID() <> 137 Then ;Outpost: Fishermens Haven
			CurrentAction("Moving to Outpost")
			TravelTo(137)
			WaitMapLoading(137)
		EndIf;
		rndslp(3000)
		CurrentAction("Begin run number " & $NumberRun)
		SwitchMode(0) ;Normal Mode

;		Uncomment the line below, if you want to pick up items
;		If CheckIfInventoryIsFull() then SellItemToMerchant()
		
		GoOut()
		MoveToArea()
		
		While (CountSlots() > 4)
		VQ()
		WEnd
		
;		VQ()
		$NumberRun = $NumberRun +1
	EndIf
	sleep(50)
WEnd

Func GoOut()
	RndSleep(250)
	CurrentAction("Going out")
	MoveTo(2228.00, 10850.00)
	Move(2005.00, 11289.00)
	WaitMapLoading()	
EndFunc

Func MoveToArea()
	If $DeadOnTheRun = 0 Then AggroMoveToEx(1393, 13273)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1528, 15541)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5056, 18718)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-5722, 20362)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-9724, 20326)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10937, 18910)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-12405, 21009)
	MoveTo(-12405, 21009)
	Move(-12999, 20940)
	WaitMapLoading(53) ;Tears of the Fallen
	
	
						
	If $DeadOnTheRun = 0 Then AggroMoveToEx(4032, -7204)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(2679, -5045)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(3684, -4007)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(5760, -3101)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6185, -1344)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6458, 2282)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(3118, 5607)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(6589, 6844)
	MoveTo(7093, 7485)
	Move(7399, 7699)
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

;Func SSpoint()
;	$SS_title = GetAsuraTitle()
;	$point_earn = $SS_title - $SS_title_at_begining
;	GUICtrlSetData($gui_status_point, $point_earn)
;EndFunc

Func HeroBuff()
	$mSkillBar = GetSkillbar(3)
	$mHeroInfo = GetAgentByID(GetHeroID(3))
	If GetIsTargetBuffed($GWA_CONST_UnyieldingAura,  GetHeroID(3), 3) == 0 AND DllStructGetData($mSkillBar, 'Recharge1') == 0 AND GetIsDead($mHeroInfo) == False Then
		UseHeroSkill(3, 1,  GetHeroID(3))
	EndIf
EndFunc

Func VQ()
	CurrentAction("Waiting to really complete load")
	WaitMapLoading(17)
	$DeadOnTheRun = 0
	AdlibRegister("CheckPartyDead", 2000)
	AdlibRegister("SSpoint", 5000)
	AdlibRegister("HeroBuff", 5000)
	
	;Wald-Minotauren farmen
	CurrentAction("Farming Minotaurs.")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(213.32, -18544.21)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-849.12, -14602.22)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4477.05, -12884.84)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-6749.70, -14532.16)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-9442.90, -14303.07)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-12241.00, -10995.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-14176.00, -8318.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-13590.00, -6161.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-12395.00, -5431.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11040.00, -3380.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-10782.00, 2385.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-7582.00, 2614.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3893.00, 1545.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1077.00, -2445.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-192.00, -3658.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-1341.00, -2101.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-2600.00, -1991.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-3189.00, -4036.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-6709.00, -5453.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11018.00, -2376.00)
	
	CurrentAction("Moving back. Preparing next run.")
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-11040.00, -3380.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-12395.00, -5431.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-13590.00, -6161.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-14176.00, -8318.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-12241.00, -10995.00)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-9442.90, -14303.07)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-6749.70, -14532.16)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-4477.05, -12884.84)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(-849.12, -14602.22)
	If $DeadOnTheRun = 0 Then AggroMoveToEx(213.32, -18544.21)
	
	;Zone: Tears of the Fallen
	MoveTo(-1234, -19420)
	Move(-1655, -19770)
	WaitMapLoading(53)
	Sleep(1000)
	
	;Zone: Talmark Wilderness
	MoveTo(7093, 7485)
	Move(7399, 7699)
	

	
	If $DeadOnTheRun = 0 Then $RunSuccess = $RunSuccess + 1
	GUICtrlSetData($gui_status_successful, $RunSuccess)
	AdlibUnRegister("CheckPartyDead")
	AdlibUnRegister("SSpoint")
	AdlibUnRegister("HeroBuff")
EndFunc