#region Includes
#include "激战接口.au3"
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>
#include <ScrollBarsConstants.au3>
#include <Date.au3>
#endregion Includes
#region stuff
; Make sure you dont bring any skills that "jump" i.e Deaths Charge, Vipers Defense etc or it will drop the torch.
; Need a good hero team, if you die it will probably get stuck somewhere
; Will retry at level 2 if it fails since it sometimes gets stuck there
; Most runs I have completed without fail is 23~
; Average run time is: 32minutes.
; Average run time in HM is: 25minutes (Because of cons).
; Eaglecrest drop rate is decent. Only took a day or 2 of pretty inconsistent botting to get one.
; MAKE SURE TO SET WHAT PCONS ETC YOU WANT TO USE.
; ####################################################################################################################
; Bot written by Underavelvetmoon. All credits to those who originally created similar bots since I took work from   #
; various sources from Gamerevision (Rip). However the majority is my own.                                           #
; Enjoy!                                                                                                             #
; ####################################################################################################################
#region GUI

; Create GUI

Opt("GUIOnEventMode", True)

$GUI = GUICreate("Ravens Point v1.2 - Public release", 251, 256, 192, 124)
$txtName = GUICtrlCreateCombo("", 8, 8, 145, 25)
GUICtrlSetData(-1, GetLoggedCharNames())
$bStart = GUICtrlCreateButton("Start", 176, 8, 67, 49)
$lblRuns = GUICtrlCreateLabel("Runs: ", 8, 40, 76, 17)
$lblFails = GUICtrlCreateLabel("Fails: ", 104, 40, 68, 17)
Global $Out = GUICtrlCreateEdit("", 8, 64, 233, 185)

GUISetState(@SW_SHOW)
GUICtrlSetOnEvent($bStart, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")
#endregion GUI
#region Globals

; Define variables to be used throughout the script

Global $g_hTimer, $g_iSecs, $g_iMins, $g_iHour, $g_sTime
Global $aTotalTime = 0

Global $Template = '' ; Any utility build will work. Bring skills to help against destroyers (Alkars Acid, Blind etc)
Global $bRunning = False
Global $bInitialized = False
Global $bCanContinue = False
Global $GWPID = -1

Global $Runs = 0
Global $Fails = 0

Global $Main = 645 ; Olofstead
Global $Explorable = 553 ; Outside Olofstead
Global $Level1 = 617
Global $Level2 = 618
Global $Level3 = 619
Global $TenguFlare = 30209 ; Flare ID
Global $UseFlare = False ; Really helps in HM
Global $UseCons = False ; If HM - recommended!
Global $UseCupcake = True ; For NM to run Torch - needed for level 2!
Global $UseZaishen = True ; For the poor man
Global $UseLegion = False ; For the poor smart man

Global $DefendingTheBreach = 835 ; Quest ID
Global $Eaglecrest = 1985 ; Model ID
Global $Wingcrest = 2048 ; Model ID

; Skillbar locations - Any skillset will work as long as you update cast engine.
; This is just the build I was using. I cant remember if the names matter,
; just dont worry about touching it xD

Global Const $SkillBar_WA = 1
Global Const $SkillBar_EA = 2
Global Const $SkillBar_BV = 3
Global Const $SkillBar_SS = 4
Global Const $SkillBar_IS = 5
Global Const $SkillBar_PI = 6
Global Const $SkillBar_EVAS = 7
Global Const $SkillBar_AOM = 8 ; Use a run skill here. It helps!

; Cast engine - Change with your skills cost/adren/casttime

Global $intSkillEnergy[8] = [10, 10, 10, 10, 15, 10, 10, 0]
Global $intSkillAdrenaline[8] = [0, 0, 0,0, 0, 0, 0, 0]
Global $intSkillCastTime[8] = [100, 100, 100, 100, 125, 100, 100, 0]
Global $totalskills = 7

#endregion Globals
#region Initialize
Do
   Sleep(100)
Until $bInitialized

; Handle to keep the script looping and manage inventory

While 1
   If $bRunning = True Then
	  MainLoop()
   EndIf
   WEnd

   ; Typical event handler to pass Initialize

   Func EventHandler()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			Exit
		Case $bStart
			If $bRunning = True Then
				GUICtrlSetData($bStart, "Will pause after this run")
				GUICtrlSetState($bStart, $GUI_DISABLE)
				$bRunning = False
			ElseIf $bInitialized Then
				GUICtrlSetData($bStart, "Pause")
				$bRunning = True
			Else
				$bRunning = True
				GUICtrlSetData($bStart, "Initializing...")
				GUICtrlSetState($bStart, $GUI_DISABLE)
				GUICtrlSetState($txtName, $GUI_DISABLE)
;~ 				WinSetTitle($GUI, "", GUICtrlRead($txtName))
				If GUICtrlRead($txtName) = "" Then
					If Initialize(ProcessExists("gw.exe"), True, True, False) = False Then
						MsgBox(0, "Error", "Guild Wars it not running.")
						Exit
					EndIf
				Else
					If Initialize(GUICtrlRead($txtName), True, True, False) = False Then
						MsgBox(0, "Error", "Can't find a Guild Wars client with that character name.")
						Exit
					EndIf
				EndIf
				GUICtrlSetData($bStart, "Pause")
				GUICtrlSetState($bStart, $GUI_ENABLE)
				WinSetTitle($GUI, "", GetCharname() & " - Ravens Point v1.0")
				$bInitialized = True
				$GWPID = $mGWHwnd
			EndIf
	EndSwitch
EndFunc
#endregion Initialize
#region
Func Merchant()
   Local $lMerch = GetAgentByName("Galmann [Merchant]")
   GoToNPC($lMerch)

   Ident(1)
   Sell(1)
EndFunc
 Func CanPickUp2($aItem) ; For Torch/Key
	Local $R = GetRarity($aItem)
	Local $M = DllStructGetData($aItem, "ModelID")
	Local $E = DllStructGetData($aItem, "ExtraID")

    Return True
 EndFunc
 Func CanPickUp3($aItem) ; For general Battles
    Local $M = DllStructGetData($aItem, "ModelID")
	Local $R = GetRarity($aItem)
	Local $ModStruct = GetModStruct($aItem)
	Local $SupVigor = StringInStr($ModStruct, "C202EA27", 0, 1) ; Mod struct for Sup vigor rune
	Local $Attribute = GetItemAttribute($aItem)
	Local $Req = GetItemReq($aItem)
	Local $E = DllStructGetData($aItem, "ExtraID")

	Switch $M
    Case 22751
	   Return True ; Lockpicks
    Case 146
	   If $E = 10 Or $E = 12 Then
		  Return True ; Black & White Dyes
	   EndIf
    Case 937, 938, 935, 931, 932, 936
	   Return True ; Rare Mats
    Case 27033
	   Return True ; Destroyer Cores
    Case 1052, 2237
	   If $Req = 9 Then
		  Return True ; Darkwing Defender Str & Tact(?)
	   EndIf
    EndSwitch

	Switch $R
    Case 2624
	   Return True
	EndSwitch
	Return False
 EndFunc
 Func CanDrop($aItem)
    Local $M = DllStructGetData($aItem, "ModelID")
	Local $ModStruct = GetModStruct($aItem)
	Local $SupVigor = StringInStr($ModStruct, "C202EA27", 0, 1) ; Mod struct for Sup vigor rune
	Local $Attribute = GetItemAttribute($aItem)
	Local $Req = GetItemReq($aItem)
	Local $E = DllStructGetData($aItem, "ExtraID")
	Local $R = GetRarity($aItem)

	Switch $M
    Case 22751
	   Return False ; Lockpicks
    Case 146
	   If $E = 10 Or $E = 12 Then
		  Return False ; Black & White Dyes
	   EndIf
    Case 937, 938, 935, 931, 932, 936
	   Return False ; Rare Mats
    Case 27033
	   Return False ; Destroyer Cores
    Case 1052, 2237
	   If $Req = 9 Then
		  Return False ; Darkwing Defender Str & Tact(?)
	   EndIf
    Case 2124
	   If $Req = 9 Then
		  Return False ; Aurate Blade
	   EndIf
    Case 2252
	   If $Req = 9 Then
		  Return False ; Shining Gladius
	   EndIf
    Case $Eaglecrest
	   Return False
    Case $Wingcrest
	   Return False
    EndSwitch

	Switch $R
    Case 2624
	   Return False
	EndSwitch
	Return True
 EndFunc
 Func CanSalvage($aItem) ; Cause game to crash atm
	Local $R = GetRarity($aItem)
	Local $Attribute = GetItemAttribute($aItem)
	Local $M = DllStructGetData($aItem, "ModelID")

	Switch $M
    Case 937, 938, 935, 931, 932, 6532
	   Return False
	EndSwitch

	Switch $R
    Case 2624
	   If $Attribute = 18 Or $Attribute = 19 Then
		  Return False
	   EndIf
    EndSwitch
	Return True
 EndFunc
 Func CanSell($aItem)
	Local $M = DllStructGetData($aItem, "ModelID")
	Local $ModStruct = GetModStruct($aItem)
	Local $SupVigor = StringInStr($ModStruct, "C202EA27", 0, 1) ; Mod struct for Sup vigor rune
	Local $Attribute = GetItemAttribute($aItem)
	Local $Req = GetItemReq($aItem)
	Local $E = DllStructGetData($aItem, "ExtraID")
	Local $R = GetRarity($aItem)

	Switch $M
    Case 22751
	   Return False ; LockPicks
    Case 937, 938, 935, 931, 932, 6532
	   Return False ; Rare Mats
    Case 146 ; Dyes
	   If $E = 10 Or $E = 12 Then ; Black & White
		  Return False
	   EndIf
    Case $TenguFlare
	   Return False
    Case 26784
	   Return False
    Case 24859, 24860, 24861
	   Return False ; Conset
    Case 27033
	   Return False ; Destroyer Cores
    Case 1052, 2237
	   If $Req = 9 Then
		  Return False ; Darkwing Defender Str & Tact(?)
	   EndIf
    Case 2124
	   If $Req = 9 Then
		  Return False ; Aurate Blade
	   EndIf
    Case 2252
	   If $Req = 9 Then
		  Return False ; Shining Gladius
	   EndIf
    Case $Eaglecrest
	   Return False
    Case $Wingcrest
	   Return False
    EndSwitch

	Switch $R
    Case 2624
	   If $Attribute = 18 Or $Attribute = 19 Then
		  Return False
	   EndIf
    EndSwitch
	Return True
 EndFunc
 Func CanID($aItem)
    Local $R = GetRarity($aItem)
	Local $M = DllStructGetData($aItem, "ModelID")

    Return True
 EndFunc
 Func PickUpLootEx() ; For Torch/Key
	Local $lAgent
	Local $lItem
	Local $lDeadlock
	For $i = 1 To GetMaxAgents()
	If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If Not GetIsMovable($lAgent) Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If CanPickUp2($lItem) Then
			MoveToItem($lAgent)
			Sleep(500)
			Do
			PickUpItem($lItem)
			Until GetAgentExists($lAgent) = False
			$lDeadlock = TimerInit()
			While GetAgentExists($i)
				sleep(50)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
			WEnd
		EndIf
	Next
 EndFunc
Func PickUpLootEx2() ; For general Loot
	Local $lAgent
	Local $lItem
	Local $lDeadlock
	For $i = 1 To GetMaxAgents()
	If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If Not GetIsMovable($lAgent) Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If CanPickUp3($lItem) Then
			MoveToItem($lAgent)
			Sleep(500)
			Do
			PickUpItem($lItem)
			Until GetAgentExists($lAgent) = False
			$lDeadlock = TimerInit()
			While GetAgentExists($i)
				sleep(50)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
			WEnd
		EndIf
	Next
 EndFunc
 Func MoveToItem($agent) ; Carries on staying alive while collecting item
	Local $lMe
	If GetIsDead(-2) Then Return
	$x = DllStructGetData($agent, "x")
	$y = DllStructGetData($agent, "y")
    _Run($x, $y)
 EndFunc
 Func _Run($lDestX, $lDestY, $lRandom = 750, $s = "", $z = 1450) ; Run and aggro management
	Local $lMe, $lTgt
	Local $stuckTimer = TimerInit()
	$iBlocked = 0
    If GetMapID() = $Main Then Return -1
	If GetIsDead(-2) Then Return

	Move($lDestX, $lDestY)
	$lMe = GetAgentByID(-2)
    $coordsX = DllStructGetData($lMe, "X")
	$coordsY = DllStructGetData($lMe, "Y")
	Do
        $oldCoordsX = $coordsX
		$oldCoordsY = $coordsY
		$nearestenemy = GetNearestEnemyToAgent(-2)
		$lDistance = GetDistance($nearestenemy, -2)
		If $lDistance < $z AND DllStructGetData($nearestenemy, 'ID') <> 0 Then
			Fight($z, $s)

		EndIf
		RndSleep(250)
		$lMe = GetAgentByID(-2)
		$coordsX = DllStructGetData($lMe, "X")
		$coordsY = DllStructGetData($lMe, "Y")
		If $oldCoordsX = $coordsX And $oldCoordsY = $coordsY Then
			$iBlocked += 1
			Move($lDestX, $lDestY, 500)
			RndSleep(350)
			Move($lDestX, $lDestY, $lRandom)
		EndIf
	If GetIsDead(-2) Then Return
	Until ComputeDistance($coordsX, $coordsY, $lDestX, $lDestY) < 250 OR $iBlocked > 20
	Return True
 EndFunc
 Func Fight($x, $s = "") ; Fighting mechanics
	;Update("Fighting enemies!")
	Do
		RndSleep(250)
		$nearestenemy = GetNearestEnemyToAgent(-2)
	Until DllStructGetData($nearestenemy, 'ID') <> 0

	Do
		$useSkill = -1
		$target = GetNearestEnemyToAgent(-2)
		$distance = GetDistance($target, -2)
		If DllStructGetData($target, 'ID') <> 0 AND $distance < $x Then
			ChangeTarget($target)
			RndSleep(150)
			CallTarget($target)
			RndSleep(150)
			Attack($target)
			RndSleep(150)
		ElseIf DllStructGetData($target, 'ID') = 0 OR $distance > $x Then
			exitloop
		EndIf

		For $i = 0 To $totalskills

			$targetHP = DllStructGetData(GetCurrentTarget(),'HP')
			if $targetHP = 0 then ExitLoop

			$distance = GetDistance($target, -2)
			if $distance > $x then ExitLoop

			$energy = GetEnergy(-2)
			$recharge = DllStructGetData(GetSkillBar(), "Recharge" & $i+1)
			$adrenaline = DllStructGetData(GetSkillBar(), "Adrenaline" & $i+1)

			If $recharge = 0 And $energy >= $intSkillEnergy[$i] And $adrenaline >= ($intSkillAdrenaline[$i]*25 - 25) Then
				$useSkill = $i + 1
				RndSleep(250)
				UseSkill($useSkill, $target)
				RndSleep($intSkillCastTime[$i]+1000)
			EndIf
			if $i = $totalskills then $i = 0
		Next

	Until DllStructGetData($target, 'ID') = 0 OR $distance > $x
	PickUpLootEx2()
 EndFunc
 Func OpenTorchChest($x, $y) ; Open torch chest - needs a bit of work
	Local $lDeadlock
	$lDeadlock = TimerInit()
	Do
	   RndSleep(250)
	   $TorchChest = GetNearestSignpostToCoords($x, $y)
    Until DllStructGetData($TorchChest, 'Id') <> 0 Or TimerDiff($lDeadlock) > 300000
	ChangeTarget($TorchChest)
	RndSleep(250)
	GoToSignpost($TorchChest)
	RndSleep(250)
	ActionInteract()
 EndFunc
 Func PickUpTorch() ; Cause it doesnt have any useable ID's
    PickUpLootEx()
 EndFunc
 Func LiteBrazier($x, $y) ; Lights brazier then relights our own torch
	Local $lDeadlock
	$lDeadlock = TimerInit()
    Do
	   RndSleep(250)
	   $Brazier = GetNearestSignpostToCoords($x, $y)
    Until DllStructGetData($Brazier, 'Id') <> 0 Or TimerDiff($lDeadlock) > 300000
	ChangeTarget($Brazier)
	RndSleep(250)
    GoToSignpost($Brazier)
	RndSleep(5000)
	ActionInteract()
	Sleep(5000)
	ActionInteract()
	Sleep(500)
 EndFunc
 Func GoToLock($x, $y) ; Open dungeon lock
	Local $lDeadlock
	$lDeadlock = TimerInit()
	Do
	   RndSleep(250)
	   $lock = GetNearestSignpostToCoords($x, $y)
    Until DllStructGetData($lock, 'Id') <> 0 Or TimerDiff($lDeadlock) > 300000
	ChangeTarget($lock)
	RndSleep(250)
	GoToSignpost($lock)
	RndSleep(250)
	Sleep(5000)
	ActionInteract()
	Sleep(5000)
	ActionInteract()
	Sleep(500)
 EndFunc
 Func PickUpKey() ; Cause it doesnt have any useable ID's
    PickUpLootEx()
 EndFunc
 Func UseFlare() ; Helps a lot with Hard mode
   Local $aBag
   Local $aItem
   Sleep(200)
   For $i = 1 To 4
	  $aBag = GetBag($i)
	  For $j = 1 To DllStructGetData($aBag, "Slots")
		 $aItem = GetItemBySlot($aBag, $j)
		 If DllStructGetData($aItem, "ModelID") == $TenguFlare Then
			UseItem($aItem)
			Return True
		 EndIf
	  Next
   Next
EndFunc
 Func UseZaishen() ; I am noob
   Local $aBag
   Local $aItem
   Sleep(200)
   For $i = 1 To 4
	  $aBag = GetBag($i)
	  For $j = 1 To DllStructGetData($aBag, "Slots")
		 $aItem = GetItemBySlot($aBag, $j)
		 If DllStructGetData($aItem, "ModelID") == 31156 Then
			UseItem($aItem)
			Return True
		 EndIf
	  Next
   Next
EndFunc
 Func UseLegion() ; Helps a lot with Hard mode
   Local $aBag
   Local $aItem
   Sleep(200)
   For $i = 1 To 4
	  $aBag = GetBag($i)
	  For $j = 1 To DllStructGetData($aBag, "Slots")
		 $aItem = GetItemBySlot($aBag, $j)
		 If DllStructGetData($aItem, "ModelID") == 37810 Then ; Legion
			UseItem($aItem)
			Return True
		 EndIf
	  Next
   Next
EndFunc
Func UseHoneycomb()
   Local $aBag
   Local $aItem
   Sleep(200)
   For $i = 1 To 4
	  $aBag = GetBag($i)
	  For $j = 1 To DllStructGetData($aBag, "Slots")
		 $aItem = GetItemBySlot($aBag, $j)
		 If DllStructGetData($aItem, "ModelID") == 26784 Then
			UseItem($aItem)
			Return True
		 EndIf
	  Next
   Next
EndFunc
Func UseCupcake()
   Local $aBag
   Local $aItem
   Sleep(200)
   For $i = 1 To 4
	  $aBag = GetBag($i)
	  For $j = 1 To DllStructGetData($aBag, "Slots")
		 $aItem = GetItemBySlot($aBag, $j)
		 If DllStructGetData($aItem, "ModelID") == 22269 Then
			UseItem($aItem)
			Return True
		 EndIf
	  Next
   Next
EndFunc
Func UseEssence()
   Local $aBag
   Local $aItem
   Sleep(200)
   For $i = 1 To 4
	  $aBag = GetBag($i)
	  For $j = 1 To DllStructGetData($aBag, "Slots")
		 $aItem = GetItemBySlot($aBag, $j)
		 If DllStructGetData($aItem, "ModelID") == 24859 Then
			UseItem($aItem)
			Return True
		 EndIf
	  Next
   Next
EndFunc
Func UseGrail()
   Local $aBag
   Local $aItem
   Sleep(200)
   For $i = 1 To 4
	  $aBag = GetBag($i)
	  For $j = 1 To DllStructGetData($aBag, "Slots")
		 $aItem = GetItemBySlot($aBag, $j)
		 If DllStructGetData($aItem, "ModelID") == 24861 Then
			UseItem($aItem)
			Return True
		 EndIf
	  Next
   Next
EndFunc
Func UseArmor()
   Local $aBag
   Local $aItem
   Sleep(200)
   For $i = 1 To 4
	  $aBag = GetBag($i)
	  For $j = 1 To DllStructGetData($aBag, "Slots")
		 $aItem = GetItemBySlot($aBag, $j)
		 If DllStructGetData($aItem, "ModelID") == 24860 Then
			UseItem($aItem)
			Return True
		 EndIf
	  Next
   Next
EndFunc
#endregion Setup & Merch
#region main
 Func MainLoop()
	If $bCanContinue = False Then
	   If GetMapID() <> $Main Then
		  TravelTo($Main) ; Incase we get stuck outside
	   EndIf
	   GoOutside()
	   RunToDungeon()
	   TakeQuest()
	EndIf
	EnterDungeon()
	Level1()
	Level2()
	Level3()
    ResetQuest()
    If CountFreeSlots() < 6 Then
	   If GetMapID() <> $Main Then
		  TravelTo($Main)
	   EndIf
	   Out("Inventory Full..")
	   Out("Going to Merchant")
	   Merchant()
	   $bCanContinue = False
    EndIf
    GUICtrlSetData($lblRuns, "Runs: " & $Runs)
    GUICtrlSetData($lblFails, "Fails: " & $Fails)
 EndFunc
 Func GoOutside()
	Out("Going outside")

    $lDeadlock = TimerInit() ; Can sometimes get stuck on corner
	Do
       MoveTo(76, 796)
       MoveTo(-357, 1291)
	   MoveTo(-1024, 1265)
       Move(-1350, 1200)

	   If TimerDiff($lDeadlock) > 40000 And GetMapID() = $Main Then
		  Out("Failed to leave town")
		  Out("Attempting to reset")
		  TravelTo(642) ; EOTN
		  Sleep(1000)
		  TravelTo($Main)

		  Return -1
	   EndIf

    Until WaitMapLoading($Explorable) = True
 EndFunc
 Func RunToDungeon()
	Local $lTimer, $lTime
    Out("Running to dungeon")
	If $UseFlare = True Then
	   UseFlare()
	EndIf
    If $UseZaishen = True Then
	   UseZaishen()
	EndIf
	If $UseLegion = True Then
	   UseLegion()
	EndIf
    For $i = 0 To 4
	   UseHoneycomb()
    Next
    If GetMapID() = $Main Then $bCanContinue = False
    If GetMapID() = $Explorable Then $bCanContinue = True
    If $bCanContinue = True Then
	$lTimer = TimerInit()
	_Run(-2974, -242)
	_Run(-3286, -787)
	_Run(-4213, -4199)
	_Run(-3887, -4239)
	_Run(-4340, -1861)
	_Run(-4898, 610)
	_Run(-5190, 2589)
	_Run(-5475, 3665)
	_Run(-7219, 4553)
	_Run(-9947, 5020)
	_Run(-11446, 6872)
	_Run(-13695, 8270)
	_Run(-15513, 8834)
    Out("At dungeon")
    $lTime = _TicksToTime(Int(TimerDiff($lTimer)), $g_iHour, $g_iMins, $g_iSecs)
    $g_sTime = StringFormat("%02i:%02i:%02i", $g_iHour, $g_iMins, $g_iSecs)
	Out("Took " & $g_sTime & " to get there")
	EndIf
 EndFunc
 Func TakeQuest()
	Local $lOlrun = GetAgentByName("Olrun Olafdottir")
	If $bCanContinue = True Then
	Out("Taking Quest")
	GoToNPC($lOlrun)
	Sleep(500)
	AcceptQuest($DefendingTheBreach)
	Sleep(500)
    EndIf
 EndFunc
 Func EnterDungeon()
	Out("Entering Dungeon")
	If $bCanContinue = True Then
	_Run(-16008, 9559)
	_Run(-16672, 10873)
	_Run(-16773, 12251)
	_Run(-16969, 13781)
	_Run(-18507, 14214)
	_Run(-19874, 14566)
	_Run(-23354, 15309)
	_Run(-24733, 15762)
	_Run(-25632, 16198)
	Move(-25900, 16250)
	Do
	   Sleep(50)
    Until WaitMapLoading($Level1) = True
	$bCanContinue = True
	EndIf
 EndFunc
 Func Level1()
	Local $lTimer, $lTime
	Local $lDeadlock
	If $bCanContinue = True Then
    $lTimer = TimerInit()
	Out("Begin Level1")
	If $UseFlare = True Then
	   UseFlare()
	EndIf
    If $UseZaishen = True Then
	   UseZaishen()
	EndIf
    If $UseLegion = True Then
	   UseLegion()
	EndIf
	If $UseCons = True Then
	   UseEssence()
	   UseGrail()
	   UseArmor()
	EndIf
	For $i = 0 To 4
	   UseHoneycomb()
    Next
    If CountFreeSlots() < 10 Then
	   Out("Not enough Invent space")
	   Out("Dropping items...")
	   Ident(1)
	   DropUnwantedItems(1)
    EndIf
	_Run(-15787, -14135)
	_Run(-13357, -15014)
	_Run(-12887, -14981)
	_Run(-11717, -16108)
	_Run(-10457, -16288)
	_Run(-8632, -15026)
	_Run(-7691, -14720)
	_Run(-6836, -14751)
	Out("Ancient Vaettir #1")
	_Run(-6487, -15714)
	Out("Open Chest")
	OpenTorchChest(-6422, -15801)
	Sleep(3000)
	PickUpTorch()
	Sleep(2000)
    OpenTorchChest(-6422, -15801) ; Sometimes it fails to open
	Sleep(3000)
	PickUpTorch()
	Sleep(1000)
	UseSkillEx(8, -2) ; If using run skill
	_Run(-8391, -17290)
	LiteBrazier(-8391, -17290)
	Out("Light torch #1")
	_Run(-7569, -14944)
	LiteBrazier(-7569, -14944)
	Out("Light Brazier #1")
	_Run(-5386, -15721)
	LiteBrazier(-5386, -15721)
	Out("Light Brazier #2")
	DropBundle()
	_Run(-6486, -14069)
	_Run(-6623, -11971)
	_Run(-5292, -8444)
	_Run(-6484, -7534)
	_Run(-8057, -7329)
	_Run(-8740, -6321)
	OpenTorchChest(-8740, -6321)
	Sleep(2000)
	PickUpTorch()
	Sleep(2000)
    OpenTorchChest(-8740, -6321) ; Sometimes it fails to open
	Sleep(2000)
	PickUpTorch()
	Sleep(1000)
	_Run(-8961, -5545)
	_Run(-7851, -3451)
	_Run(-5428, -2884)
	_Run(-4148, -2442)
	_Run(-4064, 269)
	_Run(-5276, 1120)
	_Run(-6201, 1681)
	_Run(-6259, 2887)
	Sleep(2000)
	OpenTorchChest(-6259, 2887)
	Sleep(2000)
	PickUpTorch()
	Sleep(2000)
	OpenTorchChest(-6259, 2887)
	Sleep(2000)
	PickUpTorch()
	Sleep(2000)
	_Run(-6684, 1248)
	_Run(-8064, 1398)
	UseSkillEx(8, -2) ; If using run skill
	_Run(-7944, 1955)
	LiteBrazier(-7944, 1955)
	Out("Light Torch #2")
	_Run(-7607, 1307)
	_Run(-6542, 1370)
	_Run(-6558, 2845)
	LiteBrazier(-6558, 2845)
	Out("Light Brazier #3")
	_Run(-6020, 2896)
	LiteBrazier(-6020, 2896)
	Out("Light Brazier #4")
	_Run(-6138, 5344)
	Out("Reaper")
	_Run(-6203, 6432)
	_Run(-6070, 7740)
	Sleep(4000)
	_Run(-6203, 6432)
	Sleep(5000)
	PickUpKey()
	_Run(-6246, 3379)
	_Run(-6643, 1382)
	_Run(-8288, 1049)
	_Run(-10859, 906)
	_Run(-12221, 1024)
	_Run(-13714, 2270)
	_Run(-14654, 2455)
	_Run(-14603, 3853)
	_Run(-14608, 5942)
	_Run(-15629, 6043)
	Out("Opening gate @ level1")
	GoToLock(-15629, 6128)
	_Run(-15138, 5962)
	_Run(-15751, 7842)
	_Run(-18087, 9132)
	_Run(-19171, 9709)
	_Run(-19287, 9711)

	Move(-19500, 9750)
	$lDeadlock = TimerInit()
	Do
	   Sleep(50)
	   If TimerDiff($lDeadlock) > 25000 Then
		  Out("Failed to load level2")
		  Out("Restarting run")
		  $bCanContinue = False
	   EndIf
	Until WaitMapLoading($Level2) = True Or $bCanContinue = False
    Out("Entering Level2")
    $lTime = _TicksToTime(Int(TimerDiff($lTimer)), $g_iHour, $g_iMins, $g_iSecs)
    $g_sTime = StringFormat("%02i:%02i:%02i", $g_iHour, $g_iMins, $g_iSecs)
	Out("Level1 took " & $g_sTime)
	$aTotalTime = $aTotalTime + $g_sTime
 EndIf
 EndFunc
 Func Level2()
	Local $lTimer, $lTime
	Local $lDeadlock
	If GetMapID() = $Level1 Then $bCanContinue = False
    If $bCanContinue = True Then
    $lTimer = TimerInit()
	Out("Begin Level2")
	If $UseFlare = True Then
	   UseFlare()
	EndIf
    If $UseZaishen = True Then
	   UseZaishen()
	EndIf
    If $UseLegion = True Then
	   UseLegion()
	EndIf
    If $UseCons = True Then
	   UseEssence()
	   UseGrail()
	   UseArmor()
	EndIf
	For $i = 0 To 4
	   UseHoneycomb()
    Next
    If CountFreeSlots() < 10 Then
	   Out("Not enough Invent space")
	   Out("Dropping items...")
	   Ident(1)
	   DropUnwantedItems(1)
    EndIf
	_Run(17211, 2316)
	_Run(16205, 1193)
	_Run(14576, 868)
	Out("Ancient Vat.")
	_Run(13666, 1193)
	Out("Grab Torch")
	_Run(12528, 1727)
	OpenTorchChest(12454, 1759)
	Sleep(3000)
	PickUpTorch()
	Sleep(2000)
    OpenTorchChest(12454, 1759)
	Sleep(3000)
	PickUpTorch()
	Sleep(1000)
	_Run(14540, 977)
	LiteBrazier(14540, 977)
	Out("Light Torch #1")
	_Run(11781, 2681)
	LiteBrazier(11781, 2681)
	Out("Light Brazier #1")
	_Run(12244, 2805)
	LiteBrazier(12244, 2805)
	Out("Light Brazier #2")
	_Run(12454, 1759)
	DropBundle() ; Drop Torch out of range
	_Run(12244, 2805)
	_Run(11486, 5368)
	_Run(8893, 6746)
	Out("Ancient Vat. #2")
	_Run(7423, 5139)
	_Run(7069, 5680)
	OpenTorchChest(7069, 5680)
	Sleep(2000)
	PickUpTorch()
	Sleep(2000)
    OpenTorchChest(7069, 5680)
	Sleep(2000)
	PickUpTorch()
	Sleep(1000)
	_Run(7594, 7502)
	Out("Clearing path")
	_Run(3664, 8246)
	_Run(2344, 7320)
	_Run(4398, 10494)
	_Run(7082, 7737)
	_Run(7913, 6517)
	_Run(7341, 6044)
	If $UseCupcake = True Then UseCupcake() ; if not using cons or run skill
    UseSkillEx(8, -2) ; If using run skill
	LiteBrazier(7341, 6044)
	Out("Light Torch #2")
	_Run(8086, 6026)
	_Run(7082, 7737)
	_Run(7749, 7428)
	_Run(4007, 7990)
	_Run(2344, 7320)
	LiteBrazier(2344, 7320)
	Out("Light Brazier #3")
	_Run(1612, 6652)
	LiteBrazier(1612, 6652)
	Out("Light Brazier #4")
	DropBundle() ; Drop torch out of range
	_Run(1691, 6608)
    _Run(433, 6304)
	_Run(-1783, 7542)
	_Run(-2759, 9004)
	_Run(-3005, 9449)
	Out("Clearing path")
	_Run(-4043, 10007)
	_Run(-5026, 11987)
	_Run(-4164, 13034)
	_Run(-5026, 11987)
	_Run(-4043, 10007)
	_Run(-3005, 9449)
	_Run(-2759, 9004)
	_Run(-1755, 8122)
	_Run(-1292, 8142)
	_Run(1112, 6469)
	_Run(751, 6442)
	_Run(-1501, 6770)
	_Run(-1818, 6634)
	_Run(-3463, 5641)
	_Run(-4866, 6146)
	_Run(-5747, 6007)
	_Run(-5768, 6120)
	OpenTorchChest(-5768, 6120)
	Sleep(2000)
	PickUpTorch()
	Sleep(2000)
    OpenTorchChest(-5768, 6120)
	Sleep(2000)
	PickUpTorch()
	Sleep(1000)
	_Run(-5662, 5736)
	If $UseCupcake = True Then UseCupcake() ; if not using cons or run skill
	UseSkillEx(8, -2) ; If using run skill
	LiteBrazier(-5662, 5736)
	Out("Light Torch #3")
	_Run(-5916, 5992)
	_Run(-5747, 6007)
	_Run(-4866, 6146)
	_Run(-4503, 6111)
	_Run(-4598, 7086)
	_Run(-4779, 7803)
	_Run(-4483, 8070)
	_Run(-4491, 8342)
	_Run(-5113, 8791)
	_Run(-4583, 9443)
	_Run(-4807, 11437)
	_Run(-5414, 12120)
	LiteBrazier(-5414, 12120)
	Out("Light Brazier #5")
	_Run(-5070, 12623)
	LiteBrazier(-5070, 12623)
	Out("Light Brazier #6")
	_Run(-5226, 12461)
	_Run(-7993, 14454)
	_Run(-10557, 16390)
	Out("Reaper")
	_Run(-12618, 15281)
	_Run(-12893, 15111)
	_Run(-13484, 14722)
	_Run(-12893, 15111)
	Out("Picking up Key")
	Sleep(2000)
    PickUpKey()
	_Run(-12618, 15281)
	_Run(-10557, 16390)
	_Run(-7993, 14454)
	_Run(-5226, 12461)
	_Run(-5026, 11987)
	_Run(-3005, 9449)
	_Run(-2759, 9004)
	_Run(-1755, 8122)
	_Run(-1292, 8142)
	_Run(433, 6304)
	_Run(1612, 6652)
	_Run(2343, 7357)
	_Run(4178, 9558)
	_Run(3752, 12087)
	_Run(3670, 12145)
	Out("Open dungeon lock")
	GoToLock(3670, 12145)

	$lDeadlock = TimerInit()

	Do

	_Run(4769, 13230)
	_Run(6379, 14228)
	_Run(5911, 16485)
	_Run(4021, 17364)
	_Run(3663, 17558)
	Out("Enter Level3")
	_Run(3549, 17620)
	_Run(3454, 17671)
	Move(3300, 17670)

	If TimerDiff($lDeadlock) > 300000 Then
	   Out("Failed to light braziers")
	   Out("Attempting again")
	   RedoBraziers()

	   Return -1
	EndIf

    Until WaitMapLoading($Level3) = True
	$bCanContinue = True
	EndIf
    $lTime = _TicksToTime(Int(TimerDiff($lTimer)), $g_iHour, $g_iMins, $g_iSecs)
    $g_sTime = StringFormat("%02i:%02i:%02i", $g_iHour, $g_iMins, $g_iSecs)
	Out("Level2 took " & $g_sTime)
	$aTotalTime = $aTotalTime + $g_sTime
 EndFunc
 Func Level3()
	Local $lTimer, $lTime
	Local $lDeadlock
	If GetMapID() = $Level2 Or GetMapID() = $Level1 Then $bCanContinue = False
	If $bCanContinue = True Then
    $lTimer = TimerInit()
	Out("Begin Level3")
	If $UseFlare = True Then
	   UseFlare()
	EndIf
    If $UseZaishen = True Then
	   UseZaishen()
	EndIf
    If $UseLegion = True Then
	   UseLegion()
	EndIf
    ;If $UseCons = True Then - Not needed on level 3
	 ;  UseEssence()
	  ; UseGrail()
	   ;UseArmor()
	;EndIf
	For $i = 0 To 4
	   UseHoneycomb()
    Next
	_Run(7568, 16898)
	_Run(9970, 16785)
	_Run(10521, 14333)
	_Run(10843, 11911)
	_Run(11972, 10310)
	Out("Begin Defense")
	_Run(12255, 9791)
	_Run(13815, 9581)
	_Run(14668, 9800)
	_Run(14292, 9666)
	_Run(13498, 9435)
	_Run(11399, 9449)
	_Run(10388, 9017)
	_Run(11766, 10540)
	_Run(11743, 11298)
	If GetIsDead(-2) = False And GetMapID() = $Level3 Then
	   Out("Run complete")
	   $Runs += 1
	   $bCanContinue = True
    EndIf
	If GetIsDead(-2) = True Or GetMapID() = $Level2 Or GetMapID() = $Level1 Then
	   Out("Run Failed")
	   $Runs += 1
	   $Fails += 1
	   $bCanContinue = False
	EndIf
	If $bCanContinue = True Then
	   If CountFreeSlots() < 2 Then
          Out("Not enough Invent space")
		  Out("Dropping items...")
		  Ident(1)
		  DropUnwantedItems(1)
    EndIf
	Out("Opening Chest")
	_Run(12071, 9626)
	Move(12150, 9545)
	Sleep(5000)
	$lChest = GetNearestSignpostToCoords(12150, 9545)
    ChangeTarget($lChest)
	Sleep(500)
	GoToSignpost($lChest)
	Sleep(1000)
	ActionInteract()
	Sleep(2000)
	PickUpLootEx2()
    $lDeadlock = TimerInit()
    $lTime = _TicksToTime(Int(TimerDiff($lTimer)), $g_iHour, $g_iMins, $g_iSecs)
    $g_sTime = StringFormat("%02i:%02i:%02i", $g_iHour, $g_iMins, $g_iSecs)
	Out("Level3 took " & $g_sTime)
	;$aTotalTime = $aTotalTime + $g_sTime
	;Out("Total time: " & $aTotalTime)
	Out("Waiting for timer")
	Sleep(160000)
	Do
	   Sleep(100)
    Until WaitMapLoading($Explorable) = True Or GetMapID($Explorable) Or TimerDiff($lDeadlock) > 250000
	;$aTotalTime = 0
	EndIf
    EndIf
 EndFunc
 Func ResetQuest()
	Local $lOlrun = GetAgentByName("Olrun Olafdottir")
	If $bCanContinue = True Then
	Out("Taking Reward")
	GoToNPC($lOlrun)
	Sleep(2000)
	QuestReward($DefendingTheBreach)
	Sleep(2000)
 EndIf
    If $bCanContinue = True Then
	   Out("Run Successful!")
	Else
	   Out("Run failed!")
	   $Fails = $Fails + 1
	EndIf
	Out("Going back to town")
	$bCanContinue = False
	TravelTo($Main)
 EndFunc
 Func RedoBraziers() ; In case we got stuck
	If $UseCupcake = True Then UseCupcake()
	_Run(3752, 12087)
	_Run(4178, 9558)
	_Run(2343, 7357)
	_Run(1612, 6652)
	_Run(433, 6304)
    _Run(751, 6442)
	_Run(-1501, 6770)
	_Run(-1818, 6634)
	_Run(-3463, 5641)
	_Run(-4866, 6146)
	_Run(-5747, 6007)
	_Run(-5768, 6120)
	OpenTorchChest(-5768, 6120)
	Sleep(2000)
	PickUpTorch()
	Sleep(2000)
    OpenTorchChest(-5768, 6120)
	Sleep(2000)
	PickUpTorch()
	Sleep(1000)
	_Run(-5662, 5736)
    UseSkillEx(8, -2) ; If using run skill
	LiteBrazier(-5662, 5736)
	Out("Light Torch #3 try 2")
	_Run(-5916, 5992)
	_Run(-5747, 6007)
	_Run(-4866, 6146)
	_Run(-4503, 6111)
	_Run(-4598, 7086)
	_Run(-4779, 7803)
	_Run(-4483, 8070)
	_Run(-4491, 8342)
	_Run(-5113, 8791)
	_Run(-4583, 9443)
	_Run(-4807, 11437)
	_Run(-5414, 12120)
	LiteBrazier(-5414, 12120)
	Out("Light Brazier #5 try 2")
	_Run(-5070, 12623)
	LiteBrazier(-5070, 12623)
	Out("Light Brazier #6 try 2")
	_Run(-5226, 12461)
	_Run(-7993, 14454)
	_Run(-10557, 16390)
	Out("Reaper try 2")
	_Run(-12618, 15281)
	_Run(-12893, 15111)
	_Run(-13484, 14722)
	_Run(-12893, 15111)
	Out("Picking up Key try 2")
	Sleep(2000)
    PickUpKey()
	_Run(-12618, 15281)
	_Run(-10557, 16390)
	_Run(-7993, 14454)
	_Run(-5226, 12461)
	_Run(-5026, 11987)
	_Run(-3005, 9449)
	_Run(-2759, 9004)
	_Run(-1755, 8122)
	_Run(-1292, 8142)
	_Run(433, 6304)
	_Run(1612, 6652)
	_Run(2343, 7357)
	_Run(4178, 9558)
	_Run(3752, 12087)
	_Run(3670, 12145)
	Out("Open dungeon lock try 2")
	GoToLock(3670, 12145)
 EndFunc
#endregion Main
#region extra funcs
Func GetItemMaxDmg($aItem)
	If Not IsDllStruct($aItem) Then $aItem = GetItemByItemID($aItem)
	Local $lModString = GetModStruct($aItem)
	Local $lPos = StringInStr($lModString, "A8A7") ; Weapon Damage
	If $lPos = 0 Then $lPos = StringInStr($lModString, "C867") ; Energy (focus)
	If $lPos = 0 Then $lPos = StringInStr($lModString, "B8A7") ; Armor (shield)
	If $lPos = 0 Then Return 0
	Return Int("0x" & StringMid($lModString, $lPos - 2, 2))
 EndFunc
 Func Ident($bagIndex)
	For $i = 1 To $bagIndex
		Local $lBag = GetBag($i)
		For $ii = 1 To DllStructGetData($lBag, 'slots')
			If FindIDKit() = 0 Then
				If GetGoldCharacter() < 500 And GetGoldStorage() > 499 Then
					WithdrawGold(500)
					Sleep(Random(200, 300))
				EndIf
				Do
					BuyIDKit()
					RndSleep(500)
				Until FindIDKit() <> 0
				RndSleep(500)
			EndIf
			$aItem = GetItemBySlot($i, $ii)
			If DllStructGetData($aItem, 'ID') = 0 Then ContinueLoop
			If CanID($aItem) Then
			   IdentifyItem($aItem)
		    EndIf
			RndSleep(250)
		Next
	Next
EndFunc
Func Sell($bagIndex)
	$bag = GetBag($bagIndex)
	$numOfSlots = DllStructGetData($bag, "slots")
	For $i = 1 To $numOfSlots
		; Out("Selling item: " & $bagIndex & ", " & $i)
		$aItem = GetItemBySlot($bagIndex, $i)
		If DllStructGetData($aItem, "ID") = 0 Then ContinueLoop
		If CanSell($aItem) Then
			SellItem($aItem)
		EndIf
		RndSleep(250)
	Next
 EndFunc
 Func DropUnwantedItems($bagIndex)
	Local $lQuantity = 0
	$bag = GetBag($bagIndex)
	$numOfSlots = DllStructGetData($bag, "slots")
	For $i = 1 To $numOfSlots
		; Out("Selling item: " & $bagIndex & ", " & $i)
		$aItem = GetItemBySlot($bagIndex, $i)
		If DllStructGetData($aItem, "ID") = 0 Then ContinueLoop
		If CanDrop($aItem) Then
		   If DllStructGetData($aItem, "Quantity") > 1 Then
			  $lQuantity = DllStructGetData($aItem, "Quantity")
			  DropItem($aItem, $lQuantity)
		   Else
			  DropItem($aItem)
		   EndIf
		EndIf
		RndSleep(250)
	Next
  EndFunc
   Func Out($msg)
	GUICtrlSetData($Out, GUICtrlRead($Out) & $msg & @CRLF)
	_GUICtrlEdit_Scroll($Out, $SB_SCROLLCARET)
	_GUICtrlEdit_Scroll($Out, $SB_LINEUP)
 EndFunc
 Func CountFreeSlots()
	Local $temp = 0
	Local $bag
	$bag = GetBag(1)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(2)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(3)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	Out($temp & " slots free")
	Return $temp
 EndFunc
   Func UseSkillEx($lSkill, $lTgt = -2, $aTimeout = 3000)
	If GetIsDead(-2) Then Return
	If Not IsRecharged($lSkill) Then Return

	Local $lDeadLock = TimerInit()
	UseSkill($lSkill, $lTgt)
	Do
		Sleep(50)
		If GetIsDead(-2) = 1 Then Return
	Until (Not IsRecharged($lSkill)) Or (TimerDiff($lDeadLock) > $aTimeout)
	Sleep(50)
 EndFunc
 #endregion extra funcs
 #region REPLACE IN YOUR GWA2
 ;~ Description: Returns a list of logged characters
Func GetLoggedCharNames()
    Local $array = ScanGW()
	If $array[0] <= 0 Then Return ''
	Local $ret = $array[1]
	For $i=2 To $array[0]
		$ret &= "|"
		$ret &= $array[$i]
	Next
	Return $ret
 EndFunc
 Func ScanGW()
	Local $lWinList = WinList("Guild Wars")
	Local $lReturnArray[1] = [0]
	Local $lPid

	For $i = 1 To $lWinList[0][0]

		$mGWHwnd = $lWinList[$i][1]
		$lPid = WinGetProcess($mGWHwnd)
		If __ProcessGetName($lPid) <> "gw.exe" Then ContinueLoop
		MemoryOpen(WinGetProcess($mGWHwnd))

		If $mGWProcHandle Then
			$lReturnArray[0] += 1
			ReDim $lReturnArray[$lReturnArray[0] + 1]
			$lReturnArray[$lReturnArray[0]] = ScanForCharname()
		EndIf

		MemoryClose()

		$mGWProcHandle = 0
	Next
	Return $lReturnArray
 EndFunc   ;==>ScanGW
 #endregion REPLACE IN YOUR GWA2