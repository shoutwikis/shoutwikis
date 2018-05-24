#Region Include #
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GWA².au3>
#include <ComboConstants.au3>
#EndRegion Include #



#Region ### START Koda GUI section ### Form=I:\Autoit GUI Maker\koda_1.7.2.0\Forms\SnowmenLair.kxf
$Form1 = GUICreate("Snowmen Lair Bot", 340, 326, 192, 124)
$Group1 = GUICtrlCreateGroup("Bot WIndow", 0, 0, 337, 321)
$Group2 = GUICtrlCreateGroup("Drops ", 16, 168, 305, 137)
$Label5 = GUICtrlCreateLabel("Event Items Dropped :", 32, 200, 110, 17)
$eventitem = GUICtrlCreateLabel("      -", 152, 200, 25, 17)
$Label7 = GUICtrlCreateLabel("Golden Items Dropped : ", 32, 232, 119, 17)
$Label8 = GUICtrlCreateLabel("-", 176, 232, 7, 17)
$Label9 = GUICtrlCreateLabel("Gold On Character : ", 32, 272, 101, 17)
global $gui_status_gold_label  = GUICtrlCreateLabel("-", 152, 272, 7, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("Settings", 160, 24, 161, 137)
;$Combo1 = GUICtrlCreateCombo("Combo1", 176, 48, 129, 25)
$txtConfig = GUICtrlCreateCombo("Choose Your Name", 168, 48, 113, 25)
$Config = IniReadSection("Config.ini", "Name")
For $i = 1 To $Config[0][0]
   GUICTRLSetData($txtConfig, $Config[$i][1] )
   Next
$CheckboxRendering = GUICtrlCreateCheckbox("Checkbox1", 168, 88, 17, 17)
$CheckboxPickup = GUICtrlCreateCheckbox("Checkbox2", 168, 120, 17, 17)
$Label1 = GUICtrlCreateLabel("Disable Graphics", 192, 88, 84, 17)
$Label2 = GUICtrlCreateLabel("Pickup all", 192, 120, 114, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group4 = GUICtrlCreateGroup("Status", 16, 24, 137, 137)
$Label3 = GUICtrlCreateLabel("   Current Action :", 40, 48, 86, 17)
$LabelCurrentAction = GUICtrlCreateLabel("Ready To Start ! ", 24, 80, 117, 33)
$btnstart = GUICtrlCreateButton("Start", 24, 128, 121, 25, $WS_GROUP)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#Region Global#
$Outpost = 639
$FarmArea = 701
Global $paradox = 1
Global $sf = 2
Global $shroud = 3
Global $dwarenstability = 4
Global $whirling = 5
Global $MDR = 0
Global $darkescape = 6
Global $shadowsanctuary = 7
Global $deathcharge = 8
;$BountyNPCCoords = -14078,1544
;$SafeCast = -14492,1261)
;$SecondAggro = -17283,8758
;$Merchant = -21052,10919
;$Storage = -22136,11719


#Region Main#
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
   Exit
Case $btnstart
   GUICtrlSetState($CheckboxRendering, $GUI_ENABLE)
   Initialize(GUICtrlRead($txtConfig), True, True)
   Do
   EnterDungeon()
   FarmDungeon()
   pickuploot()
Until $MDR = 1
	EndSwitch
WEnd



#EndRegion Main#

#Region Inventory#

Func ManageInventory()
	CurrentAction("Cleaning inventory")
	RndSleep(1000)
	MoveTo(-21935,10288)
	MoveTo(-21089,10776)
	GoNearestNPCToCoords(-20948, 10858)
	Ident(1)
	Ident(2)
	Ident(3)
	Sell(1)
	Sell(2)
	Sell(3)
    $Goldz  = GetGoldCharacter()
	If GetGoldCharacter() > 70000 Then
		DepositGold(60000)
		Sleep(Random(1000, 2000))

	 EndIf
	 $Goldz = GetGoldCharacter()
	 GUICtrlSetData($gui_status_gold_label,$Goldz)
EndFunc


Func CanPickUp($aitem)
	$m = DllStructGetData(($aitem), 'ModelID')
	If $m == 835 Or $m == 933 Or $m == 921 Or $m == 28434 Or $m == 30855 Or $m = 2511 Then
		Return True
	ElseIf $m = 146 Or $m = 22751 Then ;Dyes/Lockpicks
		Return True
	ElseIf $m > 21785 And $m < 21806 Then ;Elite/Normal Tomes
		Return True
	Else
		Return True
	EndIf
EndFunc   ;==>CanPickUp

Func PickUpLoot()
		Local $lme
		Local $lblockedtimer
		Local $lblockedcount = 0
		Local $litemexists = True
		For $i = 1 To getmaxagents()
			$lme = getagentbyid(-2)
			If DllStructGetData($lme, "HP") <= 0 Then Return -1
			$lagent = getagentbyid($i)
			If NOT getismovable($lagent) Then ContinueLoop
			If NOT getcanpickup($lagent) Then ContinueLoop
			$litem = getitembyagentid($i)
			If canpickup($litem) Then
				Do
					pickupitem($litem)
					Sleep(getping())
					Do
						Sleep(100)
						$lme = getagentbyid(-2)
					Until DllStructGetData($lme, "MoveX") == 0 AND DllStructGetData($lme, "MoveY") == 0
					$lblockedtimer = TimerInit()
					Do
						Sleep(3)
						$litemexists = IsDllStruct(getagentbyid($i))
					Until NOT $litemexists OR TimerDiff($lblockedtimer) > Random(5000, 7500, 1)
					If $litemexists Then $lblockedcount += 1
				Until NOT $litemexists OR $lblockedcount > 5
			EndIf
		Next
	EndFunc

 Func CanSell($aitem)
	local $m = DllStructGetData($aitem, 'ModelID')
	local $i = DllStructGetData($aitem, 'extraId')
	If $m = 0 Then
		Return False
	ElseIf $m > 21785 And $m < 21806 Then ;Elite/Normal Tomes
		Return False
	ElseIf $m = 146 Then
		If $i = 10 OR $i = 12 Then ;black and white
			Return False
		Else
			Return True
		EndIf
	ElseIf $m =  6533 Then
		Return False    ;jade
	ElseIf $m =  19198 Then
		Return False    ;jade
	ElseIf $m =  934 Then
		Return False    ;jade
	ElseIf $m =  929 Then
		Return False
         ElseIf $m = 2991 Or $m = 2992 Or $m = 2989 Or $m = 5899 Then ;Sup ID/Salvage
		Return False		;jade
	Else
		Return True
	EndIf
     EndFunc



Func Sell($bagIndex)
	$bag = GetBag($bagIndex)
	$numOfSlots = DllStructGetData($bag, 'slots')
	For $i = 1 To $numOfSlots
		CurrentAction("Selling item: " & $bagIndex & ", " & $i)
		$aitem = GetItemBySlot($bagIndex, $i)
		If DllStructGetData($aitem, 'ID') = 0 Then ContinueLoop
		If CanSell($aitem) Then
			SellItem($aitem)
		EndIf
		RndSleep(250)
	Next
EndFunc

Func GetExtraItemInfo($aitem)
    If IsDllStruct($aitem) = 0 Then $aAgent = GetItemByItemID($aitem)
    $lItemExtraPtr = DllStructGetData($aitem, "namestring")

    DllCall($mHandle[0], 'int', 'ReadProcessMemory', 'int', $mHandle[1], 'int', $lItemExtraPtr, 'ptr', $lItemExtraStructPtr, 'int', $lItemExtraStructSize, 'int', '')
    Return $lItemExtraStruct
EndFunc   ;==>GetExtraItemInfo


     Func IDENT($bagIndex)
	$bag = GetBag($bagIndex)
	For $i = 1 To DllStructGetData($bag, 'slots')
		If FindIDKit() = 0 Then
			If GetGoldCharacter() < 500 And GetGoldStorage() > 499 Then
				WithdrawGold(500)
				Sleep(Random(200, 300))
			EndIf
			local $J = 0
			Do
				BuySuperiorIDKit()
				RndSleep(500)
				$J = $J+1
			Until FindIDKit() <> 0 OR $J = 3
			If $J = 3 Then ExitLoop
			RndSleep(500)
		EndIf
		$aitem = GetItemBySlot($bagIndex, $i)
		If DllStructGetData($aitem, 'ID') = 0 Then ContinueLoop
		IdentifyItem($aitem)
		Sleep(Random(400, 750))
	Next
 EndFunc

 Func EventItemNumber()
		Local $eventitem
		For $j = 1 To 16
			$abag = getbag($j)
			If NOT IsDllStruct($abag) Then $abag = getbag($abag)
			For $i = 1 To DllStructGetData($abag, "Slots")
				$litem = getitembyslot($abag, $i)
				If DllStructGetData($litem, "id") == 0 Then ContinueLoop
				$m = DllStructGetData($litem, "ModelID")
				$q = DllStructGetData($litem, "Quantity")
				If $m == 22752 or $m == 22269 or $m == 28436 or $m == 31152 or $m == 26784 or $m == 28434 Then
					$eventitem += $q
				EndIf
			Next
		Next
		Return $eventitem
	EndFunc

#EndRegion Inventory

#Region Misc#
Func CurrentAction($text)
	GUICtrlSetData($LabelCurrentAction, $text)
     EndFunc


     Func GoNearestNPCToCoords($x, $y)
	Do
		RndSleep(250)
		$guy = GetNearestNPCToCoords($x, $y)
	Until DllStructGetData($guy, 'Id') <> 0
	ChangeTarget($guy)
	RndSleep(250)
	GoNPC($guy)
	RndSleep(250)
	Do
		RndSleep(500)
		MoveEx(DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y'), 40)
		RndSleep(500)
		GoNPC($guy)
		RndSleep(250)
		$Me = GetAgentByID(-2)
	Until ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y')) < 250
	RndSleep(1000)
     EndFunc


#ENdRegion Misc


#Region Farm Func #





Func EnterDungeon()
   If GetMapID <> 639 Then
      TravelTo(639)
      CurrentAction("Going To Oupost")
      WaitMapLoading(639)
   EndIf
   If CountSlots() = 0 Then
   ManageInventory()
   EndIf
   GUICtrlSetData($eventitem, eventitemnumber())
   CurrentAction("Entering Dungeon")
   SwitchMode(1)
   GoNearestNPCToCoords(-23818, 13931)
   RndSleep(750)
   Dialog(0x00000083)
   Dialog(0x00000084)
   WaitMapLoading(701)
   RndSleep(450)
EndFunc

Func FarmDungeon()
MoveTo(-14078,15449)
GoNearestNPCToCoords(-14078,15449)
Dialog(0x84)
CurrentAction("Bounty Taken !")
RndSleep(450)
CurrentAction("Aggroing First Group")
MoveTo(-14226, 13953)
 MoveTo(-14329, 13538)
 StayAlive()
	        MoveTo(-14538, 12241)
		UseSkill(4,-2)
		Sleep(500)
		UseSkill(6,-2)
		StayAlive()
		MoveTo(-14933, 11317)
		StayAlive()
		MoveTo(-15702, 10671)
		StayAlive()
		MoveTo(-16285, 9854)
		StayAlive()
		MoveTo(-16847, 9017)
		StayAlive()
		MoveTo(-17348, 8122)
		StayAlive()
		MoveTo(-16666, 8858)
		StayAlive()
		MoveTo(-15994, 9609)
		StayAlive()
		MoveTo(-15598, 10528)
		StayAlive()
		MoveTo(-14603, 10644)
		StayAlive()
		MoveTo(-14522, 9645)
		StayAlive()
		Heal()
		;MoveTo(-16666, 8858)
		StayAlive()
		Spike()
		Sleep(3200)
		StayAlive()
		pickuploot()
		EndFunc

   Func MoveEx($x, $y, $random = 150)
	Move($x, $y, $random)
EndFunc

Func Spike()
   CurrentAction("Killing Foes")
   $target = GetNearestEnemyToAgent(-2)
   UseSkill(8,$target)
   Sleep(760)
   UseSkill(4,-2)
   RndSleep(1000)
   UseSkill(5,$target)
   RndSleep(450)
   StayAlive()
   Sleep(4200)
   pickuploot()
EndFunc

Func LaunchSF()
   UseSkill(1,-2)
   RndSleep(450)
   UseSkill(2,-2)
   Sleep(1200)
   UseSkill(3,-2)
EndFunc

Func SpeedBuff()
   UseSkill(4,-2)
   Sleep(500)
   UseSkill(6,-2)
EndFunc

Func Heal()
    UseSkill(7,2)
	RndSleep(450)
EndFunc

Func StayAlive()
   Local $lMe = GetAgentByID(-2)
	Local $lEnergy = GetEnergy($lMe)
	Local $lAdjCount, $lAreaCount, $lSpellCastCount, $lProximityCount
	Local $lDistance
	If IsRecharged($sf) Then
		UseSkillEx($paradox)
		UseSkillEx($sf)
	EndIf

	If GetHealth(-2) < 150 Then
		UseSkillEx($shadowsanctuary, -2)
	EndIf


	UseSF($lProximityCount)

	If IsRecharged($shroud) Then
		UseSkillEx($shroud)
	     EndIf


	UseSF($lProximityCount)

	UseSF($lProximityCount)

	UseSF($lProximityCount)
     EndFunc


     Func IsRecharged($lSkill)
   Return GetSkillBarSkillRecharge($lSkill) == 0
EndFunc

Func MoveLive($lDestX, $lDestY, $lRandom = 50)

	Move($lDestX, $lDestY, 0)

        StayAlive()

	Move($lDestX, $lDestY, 0)
	     EndFunc



Func UseSF($lProximityCount)
	If IsRecharged($sf) Then
		UseSkillEx($paradox)
		UseSkillEx($sf)
	EndIf
     EndFunc



     Func UseSkillEx($lSkill, $lTgt = -2, $aTimeout = 3000)
   Local $mSkillbar = GetSkillbar()
   If GetIsDead(-2) Then Return
   If Not IsRecharged($lSkill) Then Return
   Local $Skill = GetSkillByID(DllStructGetData($mSkillbar, 'Id' & $lSkill))
   If DllStructGetData($mSkillbar, 'AdrenalineA' & $lSkill) < DllStructGetData($lSkill, 'Adrenaline') Then Return False
   Local $lDeadlock = TimerInit()
   UseSkill($lSkill, $lTgt)
   Do
	  Sleep(50)
	  If GetIsDead(-2) = 1 Then Return
	  Until (Not IsRecharged($lSkill)) Or (TimerDiff($lDeadlock) > $aTimeout)
   If $lSkill = 2 Or $lSkill = 6 Or $lSkill = 8 Then Sleep(750)
EndFunc

Func CountSlots()
	Local $bag
	Local $temp = 0
	$bag = GetBag(1)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(2)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(3)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(4)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	Return $temp
     EndFunc

Func Coord()
		MoveTo(-14538, 12241)
		StayAlive()
		MoveTo(-14933, 11317)
		StayAlive()
		MoveTo(-15702, 10671)
		StayAlive()
		MoveTo(-16285, 9854)
		StayAlive()
		MoveTo(-16847, 9017)
		StayAlive()
		MoveTo(-17348, 8122)
		StayAlive()
		MoveTo(-16666, 8858)
		StayAlive()
		MoveTo(-15994, 9609)
		StayAlive()
		MoveTo(-15598, 10528)
		StayAlive()
		MoveTo(-14603, 10644)
		StayAlive()
		MoveTo(-14522, 9645)
		StayAlive()
		Spike(3200)
		StayAlive()
		pickuploot()
EndFunc