#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include "GWA².au3"
#include "AddsOn.au3"
#include "CommonFunction.au3"

global $DeadOnTheRun = 0
Global $SSOutpost = 396

While 1
	If $boolrun = true Then
		If $NumberRun = 0 Then ;first run
			AdlibRegister("status", 1000)
			$TimerTotal = TimerInit()
			FileOpen($File)
		EndIf
		If GetMapID() <> 164 Then
			CurrentAction("Moving to Outpost")
			Do
				TravelTo(164)
;~ 				WaitForLoad()
				rndslp(500)
			Until GetMapID() = 164
		EndIf;
		rndslp(3000)
		CurrentAction("Begin run number " & $NumberRun)
		If CheckIfInventoryIsFull() then SellItemToMerchant()
;~ 		SellItemToMerchant()
		GoOut()
		VQ()
		$NumberRun = $NumberRun +1
	EndIf
	sleep(50)
WEnd

Func GoOut()
	RndSleep(250)
	CurrentAction("Going out")
	MoveTo(-12243, -6161)
	MoveTo(-11889, -6248)
	MoveTo(-11447, -6229)
	Move(-11005, -6210)
	WaitForLoad()
EndFunc

Func status()
	$time = TimerDiff($TimerTotal)
	$string = StringFormat("min: %03u  sec: %02u ", $time/1000/60, Mod($time/1000,60))
	GUICtrlSetData($label_stat, $string)
EndFunc    ;==>status

Func CheckDeath()
	If Death() = 1 Then
		CurrentAction("We Are Dead")
		$DeadOnTheRun = 1
	EndIf
EndFunc   ;==>CheckDeath

Func VQ()
	$DeadOnTheRun = 0
	rndslp(3000)
	AdlibRegister("CheckDeath", 1000)
	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
	If $DeadOnTheRun = 0 Then MoveTo(-10203, -6232)
	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
	If $DeadOnTheRun = 0 Then MoveTo(-9177, -6111)
	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
	If $DeadOnTheRun = 0 Then MoveTo(-8236, -5490)
	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
	If $DeadOnTheRun = 0 Then MoveTo(-7341, -4437)
	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
	If $DeadOnTheRun = 0 Then MoveTo(-6719, -4256)
	If $DeadOnTheRun = 0 Then UseSkill(5, -2)
	If $DeadOnTheRun = 0 Then sleep(random(2000, 3000, 1))
	If $DeadOnTheRun = 0 Then UseSkill(6, -2)
	If $DeadOnTheRun = 0 Then sleep(random(300, 500, 1))
	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
	If $DeadOnTheRun = 0 Then MoveTo(-6038, -3717)
;~ 	If $DeadOnTheRun = 0 Then CurrentAction("Moving")
;~ 	If $DeadOnTheRun = 0 Then MoveTo(-5043, -3143)
	If $DeadOnTheRun = 0 Then CurrentAction("Wait They Ball")
	If $DeadOnTheRun = 0 Then sleep(random(3000, 4000, 1))
	If $DeadOnTheRun = 0 Then CurrentAction("Smaashhhhhhh")
	If $DeadOnTheRun = 0 Then $target = GetNearestEnemyToAgent(-2)
	If $DeadOnTheRun = 0 Then Attack($target)

	If $DeadOnTheRun = 0 Then UseSkill(2, $target)
	If $DeadOnTheRun = 0 Then sleep(random(2000, 2500, 1))
	If $DeadOnTheRun = 0 Then UseSkill(3, $target)
	If $DeadOnTheRun = 0 Then sleep(random(2000, 2500, 1))
	If $DeadOnTheRun = 0 Then UseSkill(4, -2)
	$timer1 = TimerInit()
	If $DeadOnTheRun = 0 Then
		Do
			sleep(100)
			$target = GetNearestEnemyToAgent(-2)
		Until DllStructGetData($target, 'HP') < 0.005 or $DeadOnTheRun = 1 or TimerDiff($timer1) > 8000
	EndIf
	If $DeadOnTheRun = 0 Then sleep(random(300, 500, 1))
	If $DeadOnTheRun = 0 Then
		If CountSlots() = 0 then
			CurrentAction("Inventory full")
		Else
			CurrentAction("Picking up items")
			PickupItems(-1, 500)
		EndIf
	EndIf
	AdlibUnRegister("CheckDeath")
EndFunc