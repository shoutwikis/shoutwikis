#include <ButtonConstants.au3>
#include <GWA2.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ScrollBarsConstants.au3>
#include <Misc.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
#RequireAdmin
#NoTrayIcon

#Region Declarations
Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Global $chestOpen = false
Global $Runs = 0
Global $1runs = 0
Global $Fails = 0
Global $Bones = 0
Global $TotalSeconds = 0
Global $Seconds = 0
Global $Minutes = 0
Global $Hours = 0
Global $MerchOpened = False
Global $RenderingEnabled = True
Global $BotRunning = False
Global $BotInitialized = False

; ==== Constants ====
Global Enum $DIFFICULTY_NORMAL, $DIFFICULTY_HARD
Global Enum $INSTANCETYPE_OUTPOST, $INSTANCETYPE_EXPLORABLE, $INSTANCETYPE_LOADING
Global Enum $RANGE_ADJACENT=156, $RANGE_NEARBY=240, $RANGE_AREA=312, $RANGE_EARSHOT=1000, $RANGE_SPELLCAST = 1085, $RANGE_SPIRIT = 2500, $RANGE_COMPASS = 5000
Global Enum $RANGE_ADJACENT_2=156^2, $RANGE_NEARBY_2=240^2, $RANGE_AREA_2=312^2, $RANGE_EARSHOT_2=1000^2, $RANGE_SPELLCAST_2=1085^2, $RANGE_SPIRIT_2=2500^2, $RANGE_COMPASS_2=5000^2
Global Enum $PROF_NONE, $PROF_WARRIOR, $PROF_RANGER, $PROF_MONK, $PROF_NECROMANCER, $PROF_MESMER, $PROF_ELEMENTALIST, $PROF_ASSASSIN, $PROF_RITUALIST, $PROF_PARAGON, $PROF_DERVISH
Global $BAG_SLOTS[18] = [0, 20, 5, 10, 10, 20, 41, 12, 20, 20, 20, 20, 20, 20, 20, 20, 20, 9]

Global Const $MAP_ID_BJORA = 482
Global Const $MAP_ID_JAGA = 546
Global Const $MAP_ID_LONGEYE = 650

Global Const $SKILL_ID_SHROUD = 1031
Global Const $SKILL_ID_CHANNELING = 38
Global Const $SKILL_ID_ARCHANE_ECHO = 75
Global Const $SKILL_ID_WASTREL_DEMISE = 1335

Global Const $RARITY_GOLD = 2624
Global Const $RARITY_PURPLE = 2626
Global Const $RARITY_BLUE = 2623
Global Const $RARITY_WHITE = 2621

Global Const $ITEM_ID_LOCKPICKS = 22751
Global Const $ITEM_ID_SALVAGE_KIT = 2992
Global Const $ITEM_ID_ID_KIT = 2989

Global Const $ITEM_ID_DYES = 146
Global Const $ITEM_EXTRAID_BLACKDYE = 10
Global Const $ITEM_EXTRAID_WHITEDYE = 12

Global Const $ITEM_ID_GLACIAL_STONES = 27047
Global Const $ITEM_ID_TOTS = 28434
Global Const $ITEM_ID_GOLDEN_EGGS = 22752
Global Const $ITEM_ID_BUNNIES = 22644
Global Const $ITEM_ID_GROG = 30855
Global Const $ITEM_ID_CLOVER = 22191
Global Const $ITEM_ID_PIE = 28436
Global Const $ITEM_ID_CIDER = 28435
Global Const $ITEM_ID_POPPERS = 21810
Global Const $ITEM_ID_ROCKETS = 21809
Global Const $ITEM_ID_CUPCAKES = 22269
Global Const $ITEM_ID_SPARKLER = 21813
Global Const $ITEM_ID_HONEYCOMB = 26784
Global Const $ITEM_ID_VICTORY_TOKEN = 18345
Global Const $ITEM_ID_LUNAR_TOKEN = 21833
Global Const $ITEM_ID_HUNTERS_ALE = 910
Global Const $ITEM_ID_LUNAR_TOKENS = 28433
Global Const $ITEM_ID_KRYTAN_BRANDY = 35124
Global Const $ITEM_ID_BLUE_DRINK = 21812
Global Const $ITEM_ID_Shamrock_Ale = 22190
#EndRegion Declarations

#Region GUI
$Gui = GUICreate("Iron Farmer", 299, 174, -1, -1)
$CharInput = GUICtrlCreateCombo("", 6, 6, 103, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
   GUICtrlSetData(-1, GetLoggedCharNames())
$StartButton = GUICtrlCreateButton("Start", 5, 146, 105, 23)
   GUICtrlSetOnEvent(-1, "GuiButtonHandler")
$RunsLabel = GUICtrlCreateLabel("Runs:", 6, 31, 31, 17)
$RunsCount = GUICtrlCreateLabel("0", 34, 31, 75, 17, $SS_RIGHT)
$FailsLabel = GUICtrlCreateLabel("Fails:", 6, 50, 31, 17)
$FailsCount = GUICtrlCreateLabel("0", 30, 50, 79, 17, $SS_RIGHT)
$IronLabel = GUICtrlCreateLabel("Iron:", 6, 69, 33, 17)
$IronCount = GUICtrlCreateLabel("0", 52, 69, 57, 17, $SS_RIGHT)
$AvgTimeLabel = GUICtrlCreateLabel("Average time:", 6, 88, 65, 17)
$AvgTimeCount = GUICtrlCreateLabel("-", 71, 88, 38, 17, $SS_RIGHT)
$TotTimeLabel = GUICtrlCreateLabel("Total time:", 6, 107, 50, 17)
$TotTimeCount = GUICtrlCreateLabel("00:00:00", 61, 107, 48, 17, $SS_RIGHT)
$StatusLabel = GUICtrlCreateEdit("", 115, 6, 178, 162, 2097220)
$RenderingBox = GUICtrlCreateCheckbox("Disable Rendering", 6, 124, 103, 17)
   GUICtrlSetOnEvent(-1, "ToggleRendering")
   GUICtrlSetState($RenderingBox, $GUI_DISABLE)
GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
GUISetState(@SW_SHOW)
#EndRegion GUI

#Region Loops
Out("Ready.")
While Not $BotRunning
   Sleep(100)
WEnd

AdlibRegister("TimeUpdater", 1000)
While 1
   If Not $BotRunning Then
	  AdlibUnRegister("TimeUpdater")
	  Out("Bot is paused.")
	  GUICtrlSetState($StartButton, $GUI_ENABLE)
	  GUICtrlSetData($StartButton, "Start")
	  While Not $BotRunning
		 Sleep(500)
	  WEnd
	  Out("Bot resumed.")
	  AdlibRegister("TimeUpdater", 1000)
   EndIf
   MainLoop()
WEnd
#EndRegion Loops

#Region Functions
Func GuiButtonHandler()
   If $BotRunning Then
	  Out("Will pause after this run.")
	  GUICtrlSetState($StartButton, $GUI_DISABLE)
	  $BotRunning = False
   ElseIf $BotInitialized Then
	  GUICtrlSetData($StartButton, "Pause")
	  $BotRunning = True
   Else
	  Out("Initializing...")
	  Local $CharName = GUICtrlRead($CharInput)
	  If $CharName == "" Then
		 If Initialize(ProcessExists("gw.exe"),True,True) = False Then
			   MsgBox(0, "Error", "Guild Wars is not running.")
			   Exit
		 EndIf
	  Else
		 If Initialize($CharName,True,True) = False Then
			   MsgBox(0, "Error", "Could not find a Guild Wars client with a character named '" & $CharName & "'")
			   Exit
		 EndIf
	  EndIf
	  GUICtrlSetState($RenderingBox, $GUI_ENABLE)
	  GUICtrlSetState($CharInput, $GUI_DISABLE)
	  GUICtrlSetData($StartButton, "Pause")
	  $BotRunning = True
	  $BotInitialized = True
	  SetMaxMemory()
   EndIf
EndFunc

Func Setup()
   If GetMapLoading() == 0 Then
	  If GetMapID() <> 32 Then
		 Out("Travelling to Nolani.")
		 RndTravel(32)
	  EndIf
   ElseIf GetMapLoading() == 1 Then
	  Out("Travelling to Nolani.")
	  RndTravel(32)
   EndIf
   Out("Loading skillbar.")
   LoadSkillTemplate("OwZTgmE/Z6ASnR6rUYRkAytMgBA")
   LeaveGroup()
   SwitchMode(1)
   RndSleep(500)
EndFunc

Func MainLoop()
	If GetDistance(-2,-1) > 200 Then
	Do
ActionInteract() ; approach the target cautiously
	Until GetDistance(-2,-1) < 200
EndIf
While GetDistance(-2, -1) > 200
	Do
	ActionInteract() ; follow the bitch
	Until GetDistance(-2,-1) < 200
WEnd
While GetDistance(-2,-1) < 200
SendChat("point", '/')
sleep(750)
SendChat("laugh", '/')
sleep(2500)
WEnd
EndFunc

Func Kill()
   If GetIsDead(-2) Then Return
   Out("Killing charr.")
   Local $Target
   While GetNumberOfFoesInRangeOfAgent(-2,250) > 1
	  If GetIsDead(-2) Then Return
	  UseSF()
	  If IsRecharged(5) And GetEnergy(-2) >= 10 Then UseSkillEx(5,-2)
	  UseSF()
	  If IsRecharged(6) And GetEnergy(-2) >= 10 Then UseSkillEx(6,-2)
	  UseSF()
	  If GetEffectTimeRemaining(165) < 3000 And GetEnergy(-2) >= 15 Then UseSkillEx(4,-2)
	  UseSF()
	  If GetEffectTimeRemaining(1031) <= 10000 And IsRecharged(1) And GetEnergy(-2) >= 15 Then UseSkillEx(1,-2)
	  UseSF()
	  If IsRecharged(7) And GetEnergy(-2) >= 20 Then UseSkillEx(7,-2)
   	  UseSF()
	  If IsRecharged(8) And GetEnergy(-2) >= 10 Then UseSkillEx(8, GetNearestEnemyToCoords(-517, 11829))
	  UseSF()
	  TargetNearestEnemy()
	  Attack(-1)
	  RndSleep(50)
   WEnd
   RndSleep(250)
EndFunc

Func WaitForSettle($FarRange,$CloseRange,$Timeout = 10000)
   Local $Target
   Local $Deadlock = TimerInit()
   While GetNumberOfFoesInRangeOfAgent(-2,200) And TimerDiff($Deadlock) < $Timeout < 4
	  If GetIsDead(-2) Then Return
	  UseSF()
	  If GetEffectTimeRemaining(165) < 3000  And GetEnergy(-2) >= 15 Then UseSkillEx(4,-2)
	  UseSF()
	  If IsRecharged(5) Then UseSkillEx(5,-2)
	  UseSF()
	  If IsRecharged(5) Then UseSkillEx(6,-2)
	  Sleep(50)
   WEnd
   Do
	  If GetIsDead(-2) Then Return
	  UseSF()
	  If GetEffectTimeRemaining(165) < 3000  And GetEnergy(-2) >= 15 Then UseSkillEx(4,-2)
	  UseSF()
	  If IsRecharged(5) Then UseSkillEx(5,-2)
	  UseSF()
	  Sleep(50)
	  $Target = GetFarthestEnemyToAgent(-2,$FarRange)
   Until (GetDistance(-2, $Target) < $CloseRange) Or (TimerDiff($Deadlock) > $Timeout)
EndFunc

Func UseSF()
   If GetEffectTimeRemaining(826) < 5000 And GetEnergy(-2) >= 9 Then
	  UseSkillEx(3,-2)
	  UseSkillEx(2,-2)
   EndIf
EndFunc

Func GetGoodTarget()
   Local $lMe = GetAgentByID(-2)
   Local $lAgentArray = GetAgentArray(0xDB)
   For $i = 1 To $lAgentArray[0]
	  If DllStructGetData($lAgentArray[$i], "Allegiance") <> 0x3 Then ContinueLoop
	  If DllStructGetData($lAgentArray[$i], "HP") <= 0 Then ContinueLoop
	  If GetDistance($lMe, $lAgentArray[$i]) > 250 Then ContinueLoop
	  If GetHasHex($lAgentArray[$i]) Then ContinueLoop
	  Return DllStructGetData($lAgentArray[$i], "ID")
   Next
EndFunc

Func GetNearestEnemyToCoords($aX, $aY)
   Local $lNearestAgent, $lNearestDistance = 100000000
   Local $lDistance, $lAgent, $lAgentArray = GetAgentArray(0xDB)

   For $i = 1 To $lAgentArray[0]
	  $lAgent = $lAgentArray[$i]
	  If BitAND(DllStructGetData($lAgent, 'typemap'), 262144) Then ContinueLoop
	  If DllStructGetData($lAgent, 'Allegiance') <> 3 Then ContinueLoop
	  If DllStructGetData($lAgent, 'HP') <= 0 Then ContinueLoop
	  If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) > 0 Then ContinueLoop

	  $lDistance = ($aX - DllStructGetData($lAgent, 'X')) ^ 2 + ($aY - DllStructGetData($lAgent, 'Y')) ^ 2
	  If $lDistance < $lNearestDistance Then
		 $lNearestAgent = $lAgent
		 $lNearestDistance = $lDistance
	  EndIf
   Next

   Return $lNearestAgent
EndFunc

Func GetItemCountByID($ID)
   Local $Item
   Local $Quantity = 0

   For $Bag = 1 to 4
	  For $Slot = 1 to DllStructGetData(GetBag($Bag), 'Slots')
		 $Item = GetItemBySlot($Bag,$Slot)
		 If DllStructGetData($Item,'ModelID') = $ID Then
			$Quantity += DllStructGetData($Item, 'Quantity')
		 EndIf
	  Next
   Next

   Return $Quantity
EndFunc

Func FindItem($ID)
   Local $Item
   For $Bag = 1 to 4
	  For $Slot = 1 to DllStructGetData(GetBag($Bag), 'Slots')
		 $Item = GetItemBySlot($Bag,$Slot)
		 If DllStructGetData($Item,'ModelID') = $ID Then
			Return $Item
		 EndIf
	  Next
   Next
EndFunc

Func CountFreeSlots($NumOfBags = 4)
   Local $FreeSlots, $Slots = 0, $Items = 0
   For $Bag = 1 to $NumOfBags
	  $Slots += DllStructGetData(GetBag($Bag), 'Slots')
	  $Items += DllStructGetData(GetBag($Bag), 'ItemsCount')
   Next
   $FreeSlots = $Slots - $Items
   Return $FreeSlots
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

Func IsRecharged($lSkill)
   Return GetSkillBarSkillRecharge($lSkill) == 0
EndFunc

Func GetFarthestEnemyToAgent($aAgent = -2, $aDistance = 1250)
   Local $lFarthestAgent, $lFarthestDistance = 0
   Local $lDistance, $lAgent, $lAgentArray = GetAgentArray(0xDB)
   If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)

   For $i = 1 To $lAgentArray[0]
	  $lAgent = $lAgentArray[$i]
	  If BitAND(DllStructGetData($lAgent, 'typemap'), 262144) Then ContinueLoop
	  If DllStructGetData($lAgent, 'Allegiance') <> 3 Then ContinueLoop
	  If DllStructGetData($lAgent, 'HP') <= 0 Then ContinueLoop
	  If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) > 0 Then ContinueLoop
	  $lDistance = GetDistance($lAgent)
	  If $lDistance > $lFarthestDistance And $lDistance < $aDistance Then
		 $lFarthestAgent = $lAgent
		 $lFarthestDistance = $lDistance
	  EndIf
   Next

   Return $lFarthestAgent
EndFunc

Func GetNumberOfFoesInRangeOfAgent($aAgent = -2, $aRange = 1250)
   Local $lAgent, $lDistance
   Local $lCount = 0, $lAgentArray = GetAgentArray(0xDB)
   If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)

   For $i = 1 To $lAgentArray[0]
	  $lAgent = $lAgentArray[$i]
	  If BitAND(DllStructGetData($lAgent, 'typemap'), 262144) Then ContinueLoop
	  If DllStructGetData($lAgent, 'Allegiance') <> 3 Then ContinueLoop
	  If DllStructGetData($lAgent, 'HP') <= 0 Then ContinueLoop
	  If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) > 0 Then ContinueLoop
	  $lDistance = GetDistance($lAgent)
	  If $lDistance > $aRange Then ContinueLoop
	  $lCount += 1
   Next

   Return $lCount
EndFunc

Func MovePrecise($aX, $aY)
	Local $lBlocked = 0
	Local $lMe
	Local $lMapLoading = GetMapLoading(), $lMapLoadingOld

	Move($aX,$aY)
	Do
		Sleep(100)
		$lMe = GetAgentByID(-2)

		If DllStructGetData($lMe, 'HP') <= 0 Then ExitLoop

		$lMapLoadingOld = $lMapLoading
		$lMapLoading = GetMapLoading()
		If $lMapLoading <> $lMapLoadingOld Then ExitLoop

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			$lBlocked += 1
			Move($aX, $aY, 0)
		EndIf
	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $aX, $aY) < 15 Or $lBlocked > 14
EndFunc

;~ Description: standard pickup function, only modified to increment a custom counter when taking stuff with a particular ModelID
Func PickUpLoot()
	Local $lAgent
	Local $lItem
	Local $lDeadlock
	For $i = 1 To GetMaxAgents()
		If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If CanPickup($lItem) Then
			PickUpItem($lItem)
			$lDeadlock = TimerInit()
			While GetAgentExists($i)
				Sleep(100)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
			WEnd
		EndIf
	Next
EndFunc   ;==>PickUpLoot

; Checks if should pick up the given item. Returns True or False
Func CanPickUp($aItem)
	Local $lModelID = DllStructGetData(($aItem), 'ModelID')
	Local $lRarity = GetRarity($aItem)
	If $lModelID == 2511 And GetGoldCharacter() < 99000 Then Return True	; gold coins (only pick if character has less than 99k in inventory)
	If $lModelID > 21785 And $lModelID < 21806 Then Return True	; Elite/Normal Tomes
	If $lModelID == $ITEM_ID_DYES Then	; if dye
				Return False

	EndIf
	If $lRarity == $RARITY_GOLD 			Then Return False		; gold items
	If $lRarity == $RARITY_WHITE			Then Return True	; white
	If $lModelID == $ITEM_ID_LOCKPICKS 		Then Return True ; Lockpicks
	If $lModelID == $ITEM_ID_GLACIAL_STONES Then Return True	; glacial stones
	; ==== Pcons ====
	If $lModelID == $ITEM_ID_TOTS 			Then Return True
	If $lModelID == $ITEM_ID_GOLDEN_EGGS 	Then Return True
	If $lModelID == $ITEM_ID_BUNNIES 		Then Return True
	If $lModelID == $ITEM_ID_GROG 			Then Return True
	If $lModelID == $ITEM_ID_CLOVER 		Then Return True
	If $lModelID == $ITEM_ID_PIE			Then Return True
	If $lModelID == $ITEM_ID_CIDER			Then Return True
	If $lModelID == $ITEM_ID_POPPERS		Then Return False
	If $lModelID == $ITEM_ID_ROCKETS		Then Return False
	If $lModelID == $ITEM_ID_CUPCAKES		Then Return True
	If $lModelID == $ITEM_ID_SPARKLER		Then Return False
	If $lModelID == $ITEM_ID_HONEYCOMB		Then Return True
	If $lModelID == $ITEM_ID_VICTORY_TOKEN	Then Return True
	If $lModelID == $ITEM_ID_LUNAR_TOKEN	Then Return True
	If $lModelID == $ITEM_ID_HUNTERS_ALE	Then Return True
	If $lModelID == $ITEM_ID_LUNAR_TOKENS	Then Return True
	If $lModelID == $ITEM_ID_KRYTAN_BRANDY	Then Return True
	If $lModelID == $ITEM_ID_BLUE_DRINK		Then Return True
	If $lModelID == $ITEM_ID_Shamrock_Ale	Then Return True

	; If you want to pick up more stuff add it here
	Return False
EndFunc   ;==>CanPickUp

Func goToChest()
if $chestOpen = false Then
	MoveTo(-387, 16604)
	TargetNearestAlly()
	ActionInteract()
	RndSleep(500)
	$chestOpen = True
EndIf
EndFunc

Func SalvageStuff($NumOfBags = 4)
   Out("Salvaging items.")
   Local $Item
   For $Bag = 1 To $NumOfBags
	  For $Slot = 1 To DllStructGetData(GetBag($Bag), 'Slots')
		 $Item = GetItemBySlot($Bag, $Slot)
		 If CanSalvage($Item) Then
			Local $SalvageKit = FindCheapSalvageKit()
			If $SalvageKit = 0 Then
			   goToChest()
			   WithdrawGold(100)
			   GoToMerch()
			   RndSleep(500)
			   BuyItem(2, 1, 100)
			   Do
				  RndSleep(500)
			   Until FindCheapSalvageKit() <> 0
			   $SalvageKit = FindCheapSalvageKit()
			EndIf
			Local $OldValue = DllStructGetData(GetItemByItemID($SalvageKit), 'Value')
			Local $Rarity = GetRarity($Item)
			StartSalvage1($Item, True)
			If $Rarity = 2626 Or $Rarity = 2624 Then
			   Sleep(1200)
			   ControlSend(GetWindowHandle(), "", "", "{y}")
			EndIf
			Local $Timer = TimerInit()
			Do
			   Sleep(200)
			Until FindCheapSalvageKit() <> $SalvageKit Or DllStructGetData(GetItemByItemID($SalvageKit), 'Value') <> $OldValue Or TimerDiff($Timer) > 5000
		 EndIf
	  Next
   Next
EndFunc

Func StartSalvage1($aItem, $aCheap = false)
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x62C]
   Local $lSalvageSessionID = MemoryReadPtr($mBasePointer, $lOffset)
   If IsDllStruct($aItem) = 0 Then
	  Local $lItemID = $aItem
   Else
	  Local $lItemID = DllStructGetData($aItem, 'ID')
   EndIf
   If $aCheap Then
	  Local $lSalvageKit = FindCheapSalvageKit()
   Else
	  Local $lSalvageKit = FindSalvageKit()
   EndIf
   If $lSalvageKit = 0 Then Return
   DllStructSetData($mSalvage, 2, $lItemID)
   DllStructSetData($mSalvage, 3, $lSalvageKit)
   DllStructSetData($mSalvage, 4, $lSalvageSessionID[1])
   Enqueue($mSalvagePtr, 16)
EndFunc

Func CanSalvage($Item)
   Local $ModelID = DllStructGetData($Item, 'ModelID')
   Local $Quantity = DllStructGetData($Item, 'Quantity')
   Local $Attribute = GetItemAttribute($Item)
   If $Attribute = 18 Then Return True
   If $Attribute = 19 Then Return True
   If $Attribute = 20 Then Return True
   Return False
EndFunc

Func FindCheapSalvageKit()
   Local $Item
   Local $Kit = 0
   Local $Uses = 101
   For $Bag = 1 To 16
	  For $Slot = 1 To DllStructGetData(GetBag($Bag), 'Slots')
		 $Item = GetItemBySlot($Bag, $Slot)
		 Switch DllStructGetData($Item, 'ModelID')
			Case 2992
			   If DllStructGetData($Item, 'Value')/2 < $Uses Then
				  $Kit = DllStructGetData($Item, 'ID')
				  $Uses = DllStructGetData($Item, 'Value')/8
			   EndIf
			Case Else
			   ContinueLoop
		 EndSwitch
	  Next
   Next
   Return $Kit
EndFunc

Func GoToMerch()
   If $MerchOpened = False Then
	  Out("Going to merchant.")
	  MoveTo(-163, 16000)
	  MoveTo(-1910, 14777)
	  TargetNearestAlly()
	  ActionInteract()
	  $MerchOpened = True
   EndIf
EndFunc

Func RndTravel($aMapID)
   Local $UseDistricts = 11 ; 7=eu-only, 8=eu+int, 11=all(excluding America)
   ; Region/Language order: eu-en, eu-fr, eu-ge, eu-it, eu-sp, eu-po, eu-ru, us-en, int, asia-ko, asia-ch, asia-ja
   Local $Region[11] = [2, 2, 2, 2, 2, 2, 2, -2, 1, 3, 4]
   Local $Language[11] = [0, 2, 3, 4, 5, 9, 10, 0, 0, 0, 0]
   Local $Random = Random(0, $UseDistricts - 1, 1)
   MoveMap($aMapID, $Region[$Random], 0, $Language[$Random])
   Do
	  Sleep(50)
   Until GetMapLoading() == 2
   WaitMapLoading($aMapID)
EndFunc

Func GetTime()
   Local $Time = GetInstanceUpTime()
   Local $Seconds = Floor($Time/1000)
   Local $Minutes = Floor($Seconds/60)
   Local $Hours = Floor($Minutes/60)
   Local $Second = $Seconds - $Minutes*60
   Local $Minute = $Minutes - $Hours*60
   If $Hours = 0 Then
	  If $Second < 10 Then $InstTime = $Minute&':0'&$Second
	  If $Second >= 10 Then $InstTime = $Minute&':'&$Second
   ElseIf $Hours <> 0 Then
	  If $Minutes < 10 Then
		 If $Second < 10 Then $InstTime = $Hours&':0'&$Minute&':0'&$Second
		 If $Second >= 10 Then $InstTime = $Hours&':0'&$Minute&':'&$Second
	  ElseIf $Minutes >= 10 Then
		 If $Second < 10 Then $InstTime = $Hours&':'&$Minute&':0'&$Second
		 If $Second >= 10 Then $InstTime = $Hours&':'&$Minute&':'&$Second
	  EndIf
   EndIf
   Return $InstTime
EndFunc


Func IdentifyStuff($NumOfBags = 4)
   Out("Identifying items.")
   Local $Item
   For $Bag = 1 To $NumOfBags
	  For $Slot = 1 To DllStructGetData(GetBag($Bag), 'Slots')
		 $Item = GetItemBySlot($Bag, $Slot)
		 If CanIdentify($Item) Then
			Local $IDKit = FindIDKit()
			If $IDKit = 0 Then
				goToChest()
			   WithdrawGold(100)
			   GoToMerch()
			   RndSleep(500)
			   BuyItem(4, 1, 100)
			   Do
				  RndSleep(500)
			   Until FindIDKit() <> 0
			   $IDKit = FindIDKit()
			EndIf
			Local $OldValue = DllStructGetData(GetItemByItemID($IDKit), 'Value')
			IdentifyItem($Item)
			Local $Timer = TimerInit()
			Do
			   Sleep(200)
			Until FindIDKit() <> $IDKit Or DllStructGetData(GetItemByItemID($IDKit), 'Value') <> $OldValue Or TimerDiff($Timer) > 5000
		 EndIf
	 Next
   Next
EndFunc

Func CanIdentify($Item)
   Local $ModelID = DllStructGetData($Item, 'ModelID')
   Local $Ratiry = GetRarity($Item)
   If $Ratiry == 2623 Then Return True
   If $Ratiry == 2626 Then Return True
   If $Ratiry == 2624 Then Return True
   Return False
EndFunc

Func AvgTime()
   Local $Time = GetInstanceUpTime()
   Local $Seconds = Floor($Time/1000)
   $TotalSeconds += $Seconds
   Local $AvgSeconds = Floor($TotalSeconds/$Runs)
   Local $Minutes = Floor($AvgSeconds/60)
   Local $Hours = Floor($Minutes/60)
   Local $Second = $AvgSeconds - $Minutes*60
   Local $Minute = $Minutes - $Hours*60
   If $Hours = 0 Then
	  If $Second < 10 Then $AvgTime = $Minute&':0'&$Second
	  If $Second >= 10 Then $AvgTime = $Minute&':'&$Second
   ElseIf $Hours <> 0 Then
	  If $Minutes < 10 Then
		 If $Second < 10 Then $AvgTime = $Hours&':0'&$Minute&':0'&$Second
		 If $Second >= 10 Then $AvgTime = $Hours&':0'&$Minute&':'&$Second
	  ElseIf $Minutes >= 10 Then
		 If $Second < 10 Then $AvgTime = $Hours&':'&$Minute&':0'&$Second
		 If $Second >= 10 Then $AvgTime = $Hours&':'&$Minute&':'&$Second
	  EndIf
   EndIf
   Return $AvgTime
EndFunc

Func TimeUpdater()
   $Seconds += 1
   If $Seconds = 60 Then
	  $Minutes += 1
	  $Seconds = $Seconds - 60
   EndIf
   If $Minutes = 60 Then
	  $Hours += 1
	  $Minutes = $Minutes - 60
   EndIf
   If $Seconds < 10 Then
	  $L_Sec = "0" & $Seconds
   Else
	  $L_Sec = $Seconds
   EndIf
   If $Minutes < 10 Then
	  $L_Min = "0" & $Minutes
   Else
	  $L_Min = $Minutes
   EndIf
   If $Hours < 10 Then
	  $L_Hour = "0" & $Hours
   Else
	  $L_Hour = $Hours
   EndIf
   GUICtrlSetData($TotTimeCount, $L_Hour & ":" & $L_Min & ":" & $L_Sec)
EndFunc

Func Out($msg)
   GUICtrlSetData($StatusLabel, GUICtrlRead($StatusLabel) & "[" & @HOUR & ":" & @MIN & "]" & " " & $msg & @CRLF)
   _GUICtrlEdit_Scroll($StatusLabel, $SB_SCROLLCARET)
   _GUICtrlEdit_Scroll($StatusLabel, $SB_LINEUP)
EndFunc

Func ToggleRendering()
   $RenderingEnabled = Not $RenderingEnabled
   If $RenderingEnabled Then
	  EnableRendering()
	  WinSetState(GetWindowHandle(), "", @SW_SHOW)
   Else
	  DisableRendering()
	  WinSetState(GetWindowHandle(), "", @SW_HIDE)
	  ClearMemory()
   EndIf
EndFunc

Func _exit()
   Exit
EndFunc
#EndRegion Functions