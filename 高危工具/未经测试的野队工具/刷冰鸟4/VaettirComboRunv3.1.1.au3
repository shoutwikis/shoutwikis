#cs
#################################
#                               #
#          Vaettir Bot          #
#                               #
#           by gigi             #
#                               #
#################################

The Following mods were added:
	- Autodetect what Guild Hall you are in
	- Buy rare materials finally fixed also added Amber and Jade
	- Deleted quantity or price. It buys until gold on character is <20k
	- Updated lists of items in game
	- Deleted a bunch of Counting/Displaying specific drops ** still working on the bugs in that
	- Skaldish helped fix my Array for Chest, Merchant, RareTrader. I messed up what Ralle sent me.
	- Changed naming structure for Towns, Explorables, Guild Halls
	- Added a check box for Store UNID golds
	- Modified to work with gwAPI 2.0
	- Changed Inventory management
    - GoToMerchant now playernumber based, so no stringlog needed.

#ce

#RequireAdmin
#NoTrayIcon

#include "gwApi.au3"
#include <GuiEdit.au3>
#include <GuiComboBox.au3>

Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)

; ==== Constants ====

Global $RANGE_ADJACENT_2 = 24336

Global $RANGE_AREA_2 = 97344

Global $RANGE_SPELLCAST_2 = 1177225

Global Const $MAP_ID_Bjora = 482
Global Const $MAP_ID_Jaga = 546
Global Const $Town_ID_Longeye = 650
Global Const $Town_ID_Sifhalla = 643

#Region Global Items
Global $Array_pscon[39] =  [910, 5585, 6366, 6375, 22190, 24593, 28435, 30855, _
						   31145, 35124, 36682, 6376, 21809, 21810, 21813, 36683, _
						   21492, 21812, 22269, 22644, 22752, 28436,15837, 21490, _
						   30648, 31020, 6370, 21488, 21489, 22191, 26784, 28433, _
						   5656, 18345, 21491, 37765, 21833, 28433, 28434]

Global $PIC_MATS[25][2] =  [["Fur Square", 941],["Bolt of Linen", 926],["Bolt of Damask", 927], _
						   ["Bolt of Silk", 928],["Glob of Ectoplasm", 930],["Steel of Ignot", 949], _
						   ["Deldrimor Steel Ingot", 950],["Monstrous Claws", 923],["Monstrous Eye", 931], _
						   ["Monstrous Fangs", 932],["Rubies", 937],["Sapphires", 938],["Diamonds", 935], _
						   ["Onyx Gemstones", 936],["Lumps of Charcoal", 922],["Obsidian Shard", 945], _
						   ["Tempered Glass Vial", 939],["Leather Squares", 942],["Elonian Leather Square", 943], _
						   ["Vial of Ink", 944],["Rolls of Parchment", 951],["Rolls of Vellum", 952], _
						   ["Spiritwood Planks", 956],["Amber Chunk", 6532],["Jadeite Shard", 6533]]
#EndRegion Global Items

; ================== CONFIGURATION ==================
; True or false to load the list of logged in characters or not
Global Const $doLoadLoggedChars = True
; ================ END CONFIGURATION ================

; ==== Bot global variables ====
Global $RenderingEnabled = True
Global $RunCount = 0
Global $FailCount = 0
Global $BotRunning = False
Global $BotInitialized = False
Global $ChatStuckTimer = TimerInit()
Global $Me
Global $failRun

;~ Any pcons you want to use during a run
Global $pconsCupcake_slot[2]
Global $useCupcake = True ; set it on true and he use it

; ==== Build ====
Global Const $SkillBarTemplate = "OwVUI2h5lPP8Id2BkAiAvpLBTAA"
; declare skill numbers to make the code WAY more readable (UseSkill($sf) is better than UseSkill(2))
Global Const $paradox = 1
Global Const $sf = 2
Global Const $shroud = 3
Global Const $wayofperf = 4
Global Const $hos = 5
Global Const $wastrel = 6
Global Const $echo = 7
Global Const $channeling = 8
; Store skills energy cost
Global $skillCost[9]
$skillCost[$paradox] = 15
$skillCost[$sf] = 5
$skillCost[$shroud] = 10
$skillCost[$wayofperf] = 5
$skillCost[$hos] = 5
$skillCost[$wastrel] = 5
$skillCost[$echo] = 15
$skillCost[$channeling] = 5
;~ Skill IDs
Global Const $SKILL_ID_SHROUD = 1031
Global Const $SKILL_ID_CHANNELING = 38
Global Const $SKILL_ID_ARCHANE_ECHO = 75
Global Const $SKILL_ID_WASTREL_DEMISE = 1335

#Region GUI
Global $RAREMATSBUY = False
Global $SELECT_MAT = "Fur Square|Bolt of Linen|Bolt of Damask|Bolt of Silk|Glob of Ectoplasm|Steel of Ignot|Deldrimor Steel Ingot|Monstrous Claws|Monstrous Eye|Monstrous Fangs|Rubies|Sapphires|Diamonds|Onyx Gemstones|Lumps of Charcoal|Obsidian Shard|Tempered Glass Vial|Leather Squares|Elonian Leather Square|Vial of Ink|Rolls of Parchment|Rolls of Vellum|Spiritwood Planks|Amber Chunk|Jadeite Shard"
Global $SELECT_TOWN = "Longeye's Ledge|Sifhalla|Already There"
Global $LONGEYE = False
Global $SIFHALLA = False
Global $NoRunning = False

Global Const $mainGui = GUICreate("Vaettir Bot", 375, 300)
   GUISetOnEvent(-3, "_exit")
Global $Input
If $doLoadLoggedChars Then
   $Input = GUICtrlCreateCombo("", 8, 8, 129, 21)
   GUICtrlSetData(-1, GetLoggedCharnames())
Else
   $Input = GUICtrlCreateInput("character name", 8, 8, 129, 21)
EndIf
Global $LOCATION = GUICtrlCreateCombo("Location", 8, 35, 125, 25, BitOR(0x0002, 0x0040))
GUICtrlCreateLabel("Runs:", 8, 65, 70, 17)
Global Const $RunsLabel = GUICtrlCreateLabel($RunCount, 80, 65, 50, 17)
GUICtrlCreateLabel("Fails:", 8, 80, 70, 17)
Global Const $FailsLabel = GUICtrlCreateLabel($FailCount, 80, 80, 50, 17)
Global Const $Checkbox = GUICtrlCreateCheckbox("Disable Rendering", 8, 98, 129, 17)
   GUICtrlSetState(-1, 128)
   GUICtrlSetOnEvent(-1, "ToggleRendering")
Global Const $Button = GUICtrlCreateButton("Start", 8, 120, 131, 25)
   GUICtrlSetOnEvent(-1, "GuiButtonHandler")
Global Const $StatusLabel = GUICtrlCreateLabel("", 8, 148, 125, 17)
GUICtrlCreateLabel("Select Rare Mats", 8, 155, 100, 17)
Global $SELECTMAT = GUICtrlCreateCombo("Rare Mats", 8, 175, 125,  25, BitOR(0x0002, 0x0040))

Global $GLOGBOX = GUICtrlCreateEdit("", 140, 8, 225, 240, BitOR(0x0040, 0x0080, 0x1000, 0x00200000))
GUICtrlSetColor($GLOGBOX, 65280)
GUICtrlSetBkColor($GLOGBOX, 0)
GUISetState(@SW_SHOW)
Global Const $Leeching = GUICtrlCreateCheckbox("Leech Bot Present", 8, 253, 110, 17)
Global Const $MapPieces = GUICtrlCreateCheckbox("Map Pieces", 8, 228, 75, 17)
Global Const $Tomes = GUICtrlCreateCheckbox("Mesmer Tomes", 8, 203, 90, 17)
Global Const $keep_mDustFeatherFiber = GUICtrlCreateCheckbox("Keep Dust, Feather, Fibers", 8, 278, 150, 17)
Global Const $keep_mGraniteIronBone = GUICtrlCreateCheckbox("Keep Granite, Iron, Bones", 220, 278, 150, 17)
Global Const $StoreGolds = GUICtrlCreateCheckbox("Store Golds", 220, 253, 90, 17)
GUICtrlSetData($LOCATION, $SELECT_TOWN)
GUICtrlSetData($SELECTMAT, $SELECT_MAT)
GUICtrlSetOnEvent($SELECTMAT, "START_STOP")

;~ Description: Handles the button presses
Func GuiButtonHandler()
   If $BotRunning Then
	  GUICtrlSetData($Button, "Will pause after this run")
	  GUICtrlSetState($Button, 128)
	  $BotRunning = False
   ElseIf $BotInitialized Then
	  GUICtrlSetData($Button, "Pause")
	  $BotRunning = True
   Else
	  Out("Initializing")
	  Local $CharName = GUICtrlRead($Input)
	  If $CharName = "" Then
		 If Not Initialize(ProcessExists("gw.exe")) Then
			MsgBox(0, "Error", "Guild Wars is not running.")
			Exit
		 EndIf
	  Else
		 If Not Initialize($CharName) Then
			MsgBox(0, "Error", "Could not find a Guild Wars client with a character named '"&$CharName&"'")
			Exit
		 EndIf
	  EndIf
	  MemoryWrite($mEnsureEnglish, 1) ; EnsureEnglish(True)
	  GUICtrlSetState($Checkbox, 64)
	  GUICtrlSetState($Leeching, 64)
	  GUICtrlSetState($MapPieces, 64)
	  GUICtrlSetState($Tomes, 64)
	  GUICtrlSetState($keep_mDustFeatherFiber, 64)
	  GUICtrlSetState($keep_mGraniteIronBone, 64)
	  GUICtrlSetState($StoreGolds, 64)
	  GUICtrlSetState($Input, 128)
	  GUICtrlSetData($Button, "Pause")
	  WinSetTitle($mainGui, "", "VBot-" & GetCharname())
	  $BotRunning = True
	  $BotInitialized = True
   EndIf
EndFunc

;~ Description: guess what?
Func _exit()
   Exit
EndFunc

Func START_STOP()
   Switch (@GUI_CtrlId)
	  Case $SELECTMAT
		 MatSwitcher()
   EndSwitch
EndFunc   ;==>START_STOP

Func MatSwitcher()
   $RAREMATSBUY = False
   Out("$RareMatsBuy" & $RAREMATSBUY)
   For $i = 0 To UBound($PIC_MATS) - 1
	  If (GUICtrlRead($SELECTMAT, "") == $PIC_MATS[$i][0]) Then
		 $mMatExchangeGold = $PIC_MATS[$i][1]
		 $RAREMATSBUY = True
		 Out("$RareMatsBuy" & $RAREMATSBUY)
		 Out("You Select - " & $PIC_MATS[$i][0])
		 Out("Mat Model ID == " & "" & $mMatExchangeGold)
	  EndIf
   Next
EndFunc   ;==>MATSWITCHER
#EndRegion GUI

Out("Waiting for input")

While Not $BotRunning
   Sleep(100)
WEnd

; load template if we're in town
If GetMapLoading() = 0 Then LoadSkillTemplate($SkillBarTemplate)

While True
   If CountSlots() < 8 Then Inventory()
   If GUICtrlRead($LOCATION, "") == "Longeye's Ledge" Then
	  $LONGEYE = True
   ElseIf GUICtrlRead($LOCATION, "") == "Sifhalla" Then
	  $SIFHALLA = True
   ElseIf GUICtrlRead($LOCATION, "") == "Already There" Then
	  $NoRunning = True
	  _GUICtrlComboBox_SetCurSel($LOCATION, 1)
   EndIf
   If Not $NoRunning Then
	  If $SIFHALLA Then MapS()
	  If $LONGEYE Then MapL()
	  If $SIFHALLA Then RunThereSifhalla()
	  If $LONGEYE Then RunThereLongeyes()
   Else
	  $NoRunning = False
   EndIf
   If GetIsDead(-2) Then ContinueLoop

   If GUICtrlRead($Leeching) = 1 Then
	  $mLeecher = True
   Else
	  $mLeecher = False
   EndIf

   If GUICtrlRead($keep_mDustFeatherFiber) = 1 Then
	  $mDustFeatherFiber = 0
   Else
	  $mDustFeatherFiber = 1
   EndIf
   
   If GUICtrlRead($keep_mGraniteIronBone) = 1 Then
	  $mGraniteIronBone = 0
   Else
	  $mGraniteIronBone = 1
   EndIf
   
   If GUICtrlRead($MapPieces) = 1 Then
	  $mMapPieces = True
   Else
	  $mMapPieces = False
   EndIf

   If GUICtrlRead($Tomes) = 1 Then
	  $mMesmerTomes = True
   Else
	  $mMesmerTomes = False
   EndIf

   If GUICtrlRead($StoreGolds) = 1 Then
	  $mStoreGold = True
   Else
	  $mStoreGold = False
   EndIf

   While CountSlots() > 7
	  If Not $BotRunning Then
		 Out("Bot Paused")
		 GUICtrlSetState($Button, 64)
		 GUICtrlSetData($Button, "Start")
		 While Not $BotRunning
			Sleep(100)
		 WEnd
	  EndIf
	  CombatLoop()
   WEnd

   If CountSlots() < 8 Then
	  If Not $BotRunning Then
		 Out("Bot Paused")
		 GUICtrlSetState($Button, 64)
		 GUICtrlSetData($Button, "Start")
		 While Not $BotRunning
			Sleep(100)
		 WEnd
	  EndIf
	  Inventory()
   EndIf
WEnd

#Region Getting There
Func MapL()
;~ Checks if you are already in Longeye's Ledge, if not then you travel to Longeye's Ledge
   If GetMapID() <> $Town_ID_Longeye Then
	  Out("Travelling to longeye")
	  RndTravel($Town_ID_Longeye)
   EndIf
;~ Hardmode
   SwitchMode(1)
   Out("Exiting Outpost")
   Move(-26472, 16217)
   WaitMapLoading($MAP_ID_Bjora)
   Sleep(1500)
   ClearMemory()
   _PurgeHook()
   Sleep(1500)
   $Me = GetAgentPtr(-2)
;~ Scans your bags for Cupcakes and uses one to make the run faster.
   pconsScanInventory(22269)
   Sleep(GetPing()+500)
   ;UseCupcake(22269)
   Sleep(GetPing()+500)
;~ Displays your Norn Title for the Health boost.
   SetDisplayedTitle(0x29)
   Sleep(GetPing()+500)
EndFunc

Func MapS()
;~ Checks if you are already in Sifhalla, if not then you travel to Sifhalla
   If (GetMapID() <> $Town_ID_Sifhalla) Then
	  Out("Travelling to Sifhalla")
	  RndTravel($Town_ID_Sifhalla)
   EndIf
;~ Hardmode
   SwitchMode(1)
   Out("Exiting Outpost")
   MoveTo(16197, 22825)
   Move(16800, 22867)
   WaitMapLoading($MAP_ID_Jaga)
   $Me = GetAgentPtr(-2)
;~ Scans your bags for Cupcakes and uses one to make the run faster.
   pconsScanInventory(22269)
   Sleep(GetPing()+500)
   UseCupcake(22269)
   Sleep(GetPing()+500)
;~ Displays your Norn Title for the Health boost.
   SetDisplayedTitle(0x29)
   Sleep(GetPing()+500)
EndFunc

;~ Description: zones to longeye if we're not there, and travel to Jaga Moraine
Func RunThereLongeyes()
   Out("Running to farm spot")
   DIM $array_Longeyes[31][3] = [ _
									[1, 15003.8, -16598.1], _
									[1, 15003.8, -16598.1], _
									[1, 12699.5, -14589.8], _
									[1, 11628,   -13867.9], _
									[1, 10891.5, -12989.5], _
									[1, 10517.5, -11229.5], _
									[1, 10209.1, -9973.1], _
									[1, 9296.5,  -8811.5], _
									[1, 7815.6,  -7967.1], _
									[1, 6266.7,  -6328.5], _
									[1, 4940,    -4655.4], _
									[1, 3867.8,  -2397.6], _
									[1, 2279.6,  -1331.9], _
									[1, 7.2,     -1072.6], _
									[1, 7.2,     -1072.6], _
									[1, -1752.7, -1209], _
									[1, -3596.9, -1671.8], _
									[1, -5386.6, -1526.4], _
									[1, -6904.2, -283.2], _
									[1, -7711.6, 364.9], _
									[1, -9537.8, 1265.4], _
									[1, -11141.2,857.4], _
									[1, -12730.7,371.5], _
									[1, -13379,  40.5], _
									[1, -14925.7,1099.6], _
									[1, -16183.3,2753], _
									[1, -17803.8,4439.4], _
									[1, -18852.2,5290.9], _
									[1, -19250,  5431], _
									[1, -19968, 5564], _
									[2, -20076,  5580]]
   Out("Running to Jaga")
   For $i = 0 To UBound($array_Longeyes) - 1
	  Switch $array_Longeyes[$i][0]
		 Case 1
			If Not MoveRunning($array_Longeyes[$i][1], $array_Longeyes[$i][2]) Then ExitLoop
		 Case 2
			Move($array_Longeyes[$i][1], $array_Longeyes[$i][2], 30)
			WaitMapLoading($MAP_ID_JAGA)
	  EndSwitch
   Next
EndFunc

Func RunThereSifhalla()
   Out("Running to farm spot")
   DIM $array_Sifhalla[31][3] = [ _
								    [1, -11059,	-23401], _
								    [1, -8524,	-21590], _
								    [1, -8870,	-21818], _
									[1, -6979,	-21705], _
									[1, -4144,	-25480], _
									[1, -456,	-25575], _
									[1, 2362,	-23315], _
									[1, 1877,	-21862], _
									[1, 914,	-21159], _
									[1, 1303,	-18593], _
									[1, 2092,	-16943], _
									[1, 2909,	-15487], _
									[1, 2757,	-13745], _
									[1, 1280,	-11243], _
									[1, -217,	-10112], _
									[1, -1201,	-8855], _
									[1, -2022,	-8535], _
									[1, -2383,	-7170], _
									[1, -332,	-5391], _
									[1, 1726,	-5463], _
									[1, 3465,	-5999], _
									[1, 4130,	-8139], _
									[1, 5170,	-9609], _
									[1, 7922,	-11222], _
									[1, 9600,	-11614], _
									[1, 11818,	-13547], _
									[1, 12911,	-15538], _
									[1, 14199,	-18786], _
									[1, 15201,	-20293], _
									[2, 15865, -20531], _
									[3, -20076,  5580]]

   For $i = 0 To UBound($array_Sifhalla) - 1
	  Switch $array_Sifhalla[$i][0]
		 Case 1
			If Not MoveRunning($array_Sifhalla[$i][1], $array_Sifhalla[$i][2]) Then ExitLoop
		 Case 2
			Move($array_Sifhalla[$i][1], $array_Sifhalla[$i][2], 30)
			WaitMapLoading($MAP_ID_BJORA)
		 Case 3
			Move($array_Sifhalla[$i][1], $array_Sifhalla[$i][2], 30)
			WaitMapLoading($MAP_ID_JAGA)
	  EndSwitch
   Next
EndFunc
#EndRegion

#Region Fight
; Description: This is pretty much all, take bounty, do left, do right, kill, rezone
Func CombatLoop()
   If Not $RenderingEnabled Then ClearMemory()
   If GetNornTitle() < 160000 Then
	  Out("Taking Blessing")
	  GoToNPCNearestCoords(13318, -20826)
	  Dialog(132)
   EndIf
   $Me = GetAgentPtr(-2)
   DisplayCounts()
   Sleep(GetPing()+2000)

   Out("Moving to aggro left")
   MoveTo(13501, -20925)
   MoveTo(13172, -22137)
   TargetNearestEnemy()
   MoveAggroingGigi(12496, -22600, 150)
   MoveAggroingGigi(11375, -22761, 150)
   MoveAggroingGigi(10925, -23466, 150)
   MoveAggroingGigi(10917, -24311, 150)
   MoveAggroingGigi(9910, -24599, 150)
   MoveAggroingGigi(8995, -23177, 150)
   MoveAggroingGigi(8307, -23187, 150)
   MoveAggroingGigi(8213, -22829, 150)
   MoveAggroingGigi(8307, -23187, 150)
   MoveAggroingGigi(8213, -22829, 150)
   MoveAggroingGigi(8740, -22475, 150)
   MoveAggroingGigi(8880, -21384, 150)
   MoveAggroingGigi(8684, -20833, 150)
   MoveAggroingGigi(8982, -20576, 150)

   Out("Waiting for left ball")
   WaitFor(12000)
   If GetDistance()<1000 Then
	  UseSkillGigi($hos, -1)
   Else
	  UseSkillGigi($hos, -2)
   EndIf
   WaitFor(6000)
   TargetNearestEnemy()

   Out("Moving to aggro right")
   MoveAggroingGigi(10196, -20124, 150)
   MoveAggroingGigi(9976, -18338, 150)
   MoveAggroingGigi(11316, -18056, 150)
   MoveAggroingGigi(10392, -17512, 150)
   MoveAggroingGigi(10114, -16948, 150)
   MoveAggroingGigi(10729, -16273, 150)
   MoveAggroingGigi(10810, -15058, 150)
   MoveAggroingGigi(11120, -15105, 150)
   MoveAggroingGigi(11670, -15457, 150)
   MoveAggroingGigi(12604, -15320, 150)
   TargetNearestEnemy()
   MoveAggroingGigi(12476, -16157)
   Out("Waiting for right ball")
   WaitFor(15000)
   If GetDistance()<1000 Then
	  UseSkillGigi($hos, -1)
   Else
	  UseSkillGigi($hos, -2)
   EndIf
   WaitFor(5000)

   Out("Blocking enemies in spot")
   MoveAggroingGigi(12920, -17032, 30)
   MoveAggroingGigi(12847, -17136, 30)
   MoveAggroingGigi(12720, -17222, 30)
   WaitFor(300)
   MoveAggroingGigi(12617, -17273, 30)
   WaitFor(300)
   MoveAggroingGigi(12518, -17305, 20)
   WaitFor(300)
   MoveAggroingGigi(12445, -17327, 10)

   Out("Killing")
   Kill()
   WaitFor(1200)

   Out("Looting")
   PickUpLoot()
   If GetIsDead($Me) Then
	  $FailCount += 1
	  GUICtrlSetData($FailsLabel, $FailCount)
   Else
	  $RunCount += 1
	  GUICtrlSetData($RunsLabel, $RunCount)
   EndIf

   Out("Zoning")
   MoveAggroingGigi(12289, -17700)
   MoveAggroingGigi(15318, -20351)
   While GetIsDead($Me)
	  Out("Waiting for res")
	  Sleep(1000)
   WEnd
   Move(15865, -20531)
   WaitMapLoading($MAP_ID_BJORA)
   Sleep(3000)
   Out("Identifying")
   Ident()
   Out("Salvaging")
   SalvageBagsExplorable()
   Sleep(3000)
   MoveTo(-19968, 5564)
   Move(-20076,  5580, 30)
   WaitMapLoading($MAP_ID_JAGA)
   ClearMemory()
   _PurgeHook()
EndFunc

#CS
Description: use whatever skills you need to keep yourself alive.
Take agent array as param to more effectively react to the environment (mobs)
#CE
Func StayAlive(Const ByRef $aAgentArray)
   If IsRecharged($sf) Then
	  UseSkillGigi($paradox)
	  UseSkillGigi($sf)
   EndIf
   Local $lEnergy = GetEnergy($Me)
   Local $lAdjCount, $lAreaCount, $lSpellCastCount, $lProximityCount
   Local $lDistance
   For $i = 1 To $aAgentArray[0]
	  $lDistance = GetPseudoDistance($Me, $aAgentArray[$i])
	  If $lDistance < 1440000 Then
		 $lProximityCount += 1
		 If $lDistance < $RANGE_SPELLCAST_2 Then
			$lSpellCastCount += 1
			If $lDistance < $RANGE_AREA_2 Then
			   $lAreaCount += 1
			   If $lDistance < $RANGE_ADJACENT_2 Then $lAdjCount += 1
			EndIf
		 EndIf
	  EndIf
   Next
   UseSF($lProximityCount)
   If IsRecharged($shroud) Then
	  If $lSpellCastCount > 0 And GetSkillEffectPtr($SKILL_ID_SHROUD) = 0 Then
		 UseSkillGigi($shroud)
	  ElseIf MemoryRead($Me + 304, 'float') < 0.6 Then
		 UseSkillGigi($shroud)
	  ElseIf $lAdjCount > 20 Then
		 UseSkillGigi($shroud)
	  EndIf
   EndIf
   UseSF($lProximityCount)
   If IsRecharged($wayofperf) Then
	  If MemoryRead($Me + 304, 'float') < 0.5 Then
		 UseSkillGigi($wayofperf)
	  ElseIf $lAdjCount > 20 Then
		 UseSkillGigi($wayofperf)
	  EndIf
   EndIf
   UseSF($lProximityCount)
   If IsRecharged($channeling) Then
	  If $lAreaCount > 5 And GetEffectTimeRemaining($SKILL_ID_CHANNELING) < 2000 Then
		 UseSkillGigi($channeling)
	  EndIf
   EndIf
   UseSF($lProximityCount)
EndFunc

;~ Description: Uses sf if there's anything close and if its recharged
Func UseSF($lProximityCount)
   If IsRecharged($sf) And $lProximityCount > 0 Then
	  UseSkillGigi($paradox)
	  UseSkillGigi($sf)
   EndIf
EndFunc

;~ Description: Move to destX, destY, while staying alive vs vaettirs
Func MoveAggroingGigi($aDestX, $aDestY, $aRandom = 150)
   If GetIsDead($Me) Then Return
   Local $lBlocked
   Local $lHosCount
   Local $lCount = 0
   Local $lAngle
   Local $lAgentX, $lAgentY
   Move($aDestX, $aDestY, $aRandom)
   $lAgentArray = GetAgentPtrArray(3)
   Do
	  Sleep(100)
	  If Mod($lCount, 20) = 0 Then $lAgentArray = GetAgentPtrArray(3) ; no need to pull ptrs every 100ms
	  If GetIsDead($Me) Then Return False
	  StayAlive($lAgentArray)
	  If Not GetIsMoving($Me) Then
		 If $lHosCount > 6 Then
			If MemoryRead($Me + 304, 'float') <= 0.6 Then
			   Do	; suicide
				  Sleep(1000)
				  Out("Suicide!")
			   Until GetIsDead($Me)
			   Return False
			Else
			   $lHosCount = 0
			EndIf
		 EndIf
		 $lBlocked += 1
		 If $lBlocked < 5 Then
			Move($aDestX, $aDestY, $aRandom)
		 ElseIf $lBlocked < 10 Then
			$lAngle += 40
			UpdateAgentPosByPtr($Me, $lAgentX, $lAgentY)
			Move($lAgentX + 300 * sin($lAngle), $lAgentY + 300 * cos($lAngle))
		 ElseIf IsRecharged($hos) Then
			If $lHosCount = 0 And GetDistance() < 1000 Then
			   UseSkillGigi($hos, -1)
			Else
			   UseSkillGigi($hos, -2)
			EndIf
			$lBlocked = 0
			$lHosCount += 1
		 EndIf
	  Else
		 If $lBlocked > 0 Then
			$lBlocked = 0
			$lHosCount = 0
		 EndIf
		 If GetDistance() > 1100 Then ; target is far far away, we probably got stuck.
			TargetNearestEnemy()
		 EndIf
	  EndIf
	  UpdateAgentPosByPtr($Me, $lAgentX, $lAgentY)
	  $lCount += 1
   Until ComputeDistance($lAgentX, $lAgentY, $aDestX, $aDestY) < $aRandom * 1.5
   Return True
EndFunc

;~ Description: Move to destX, destY. This is to be used in the run from across Bjora
Func MoveRunning($aDestX, $aDestY)
   If GetIsDead($Me) Then Return False
   Local $lTgt
   Local $lBlocked
   Local $lAgentX, $lAgentY
   Move($aDestX, $aDestY)
   
   Do
	  RndSleep(500)
	  TargetNearestEnemy()
	  $lTgt = GetAgentPtr(-1)
	  If GetIsDead($Me) Then Return False
	  If GetDistance($Me, $lTgt) < 1300 And GetEnergy($Me) > 20 And IsRecharged($paradox) And IsRecharged($sf) Then
		 UseSkillGigi($paradox)
		 UseSkillGigi($sf)
	  EndIf
	  $lHP = MemoryRead($Me + 304, 'float')
	  If $lHP < 0.9 And GetEnergy($Me) > 10 And IsRecharged($shroud) Then
		 UseSkillGigi($shroud)
	  ElseIf $lHP < 0.5 And GetDistance($Me, $lTgt) < 500 And GetEnergy($Me) > 5 And IsRecharged($hos) Then
		 UseSkillGigi($hos, -1)
	  EndIf
	  If Not GetIsMoving($Me) Then
		 $lBlocked += 1
		 out ("blocked: " & $lBlocked)
		 Move($aDestX, $aDestY)
	  EndIf
	  UpdateAgentPosByPtr($Me, $lAgentX, $lAgentY)
   Until ComputeDistance($lAgentX, $lAgentY, $aDestX, $aDestY) < 250
   Return True
EndFunc

;~ Description: Wait and stay alive at the same time (like Sleep(..), but without the letting yourself die part)
Func WaitFor($lMs)
   If GetIsDead($Me) Then Return
   Local $lTimer = TimerInit()
   If $lMS < 10000 Then ; no need to constantly pull agentptrs
	  $lAgentArray = GetAgentPtrArray(3)
	  Do
		 Sleep(500)
		 If GetIsDead($Me) Then Return
		 StayAlive($lAgentArray)
	  Until TimerDiff($lTimer) > $lMs
   Else
	  Do
		 $lAgentArray = GetAgentPtrArray(3)
		 If GetIsDead($Me) Then Return
		 StayAlive($lAgentArray)
		 Sleep(500)
	  Until TimerDiff($lTimer) > $lMs
   EndIf
EndFunc

;~ Description: BOOOOOOOOOOOOOOOOOM
Func Kill()
   If GetIsDead($Me) Then Return
   Local $lDeadlock = TimerInit()
   TargetNearestEnemy()
   Sleep(100)
   Local $lTarget = GetCurrentTargetPtr()
   Local $lAgentArray = GetAgentPtrArray(3)
   While GetAgentExists($lTarget) And MemoryRead($lTarget + 304, 'float') > 0
	  Sleep(50)
	  If GetIsDead($Me) Then Return
	  StayAlive($lAgentArray)
	  ; Use echo if possible
	  If GetSkillbarSkillRecharge($sf) > 5000 And GetSkillbarSkillID($echo) = $SKILL_ID_ARCHANE_ECHO Then
		 If IsRecharged($wastrel) And IsRecharged($echo) Then
			UseSkillGigi($echo)
			UseSkillGigi($wastrel, GetGoodTarget($lAgentArray))
		 EndIf
	  EndIf
	  UseSF(True)
	  ; Use wastrel if possible
	  If IsRecharged($wastrel) Then
		 UseSkillGigi($wastrel, GetGoodTarget($lAgentArray))
	  EndIf
	  UseSF(True)
	  ; Use echoed wastrel if possible
	  If IsRecharged($echo) And GetSkillbarSkillID($echo) = $SKILL_ID_WASTREL_DEMISE Then
		 UseSkillGigi($echo, GetGoodTarget($lAgentArray))
	  EndIf
	  ; Check if target ran away
	  If GetDistance($Me, $lTarget) > $RANGE_EARSHOT Then
		 TargetNearestEnemy()
		 Sleep(GetPing()+100)
		 $lTarget = GetCurrentTargetPtr()
		 If GetAgentExists($lTarget) And MemoryRead($lTarget + 304, 'float') <= 0 Or GetDistance($Me, $lTarget) > $RANGE_AREA Then ExitLoop
	  EndIf
	  If TimerDiff($lDeadlock) > 60000 Then ExitLoop
   WEnd
EndFunc

; Returns a good target for watrels
; Takes the agent array as returned by GetAgentArray(..)
Func GetGoodTarget(Const ByRef $aAgentArray)
   For $i = 1 To $aAgentArray[0]
	  If GetDistance($Me, $aAgentArray[$i]) > $RANGE_NEARBY Then ContinueLoop
	  If GetHasHex($aAgentArray[$i]) Then ContinueLoop
	  If Not GetIsEnchanted($aAgentArray[$i]) Then ContinueLoop
	  Return MemoryRead($aAgentArray[$i] + 44, 'long')
   Next
EndFunc

; Uses a skill
; It will not use if I am dead, if the skill is not recharged, or if I don't have enough energy for it
; It will sleep until the skill is cast, then it will wait for aftercast.
Func UseSkillGigi($lSkill, $lTgt = -2, $aTimeout = 3000)
   If GetIsDead($Me) Then Return
   If Not IsRecharged($lSkill) Then Return
   If GetEnergy(-2) < $skillCost[$lSkill] Then Return
   Local $lDeadlock = TimerInit()
   UseSkill($lSkill, $lTgt)
   Do
	  Sleep(50)
	  If GetIsDead($Me) = 1 Then Return
   Until (Not IsRecharged($lSkill)) Or (TimerDiff($lDeadlock) > $aTimeout)
   If $lSkill > 1 Then RndSleep(750)
EndFunc
#EndRegion

#Region Inventory
Func Inventory()
   If CountSlots() = 0 And CountSlotsChest() = 0 Then  ; no more free slots
	  MsgBox(0,"Error","Inventory full. Please make room and try again.")
	  EnableRendering()
	  Exit
   EndIf
   ;in oder to keep leecher in group
   If $mLeecher = True Then
		Out("Travel to Guild Hall")
		SendChat("resign",'/')
		sleep(1000)
		ReturnToOutpost()
		WaitMapLoading()
	EndIf
   If Not TravelGuildHall() Then TravelTo(642) ; no guild hall... travel to EotN
   Sleep(1000)
   $lGold = MinMaxGold()
   If $lGold < 1000 Then Return ; not enough gold
   Out("Storing Stuff")
   StoreItems()
   $lMapID = GetMapID()
   If GoToMerchant(GetDyeTrader($lMapID)) <> 0 Then SellDyes()
   Out("Buying Kits")
   GoToMerchant(GetMerchant($lMapID))
   BuyKits()
   Out("Identifying")
   Ident()
   Out("Salvaging")
   SalvageBags()
   StoreItems()
   Out("Selling")
   Sell()
   If GoToMerchant(GetRuneTrader($lMapID)) <> 0 Then SellUpgrades()
   If GoToMerchant(GetMaterialTrader($lMapID)) <> 0 Then SellMaterials()
   If GoToMerchant(GetRareMaterialTrader($lMapID)) <> 0 Then SellMaterials(True)
   If MinMaxGold() > 50000 Then
	  Out("Buying Rare Materials")
	  Do
		 TraderRequest($mMatExchangeGold)
		 TraderBuy()
		 Sleep(250)
	  Until GetGoldCharacter() <= 10000
   EndIf
   Out("Buying Kits")
   GoToMerchant(GetMerchant($lMapID))
   BuyKits(40, False) ; stock up on normal salv kits for salvaging in between
   Sleep(1000)
   LeaveGH()
   WaitMapLoading()
EndFunc

#Region Display/Counting Things
#CS
Each section can be commented out entirely or each individual line. Basically put here for reference and use.

I put the Display > 0 so that it won't list everything. Better for each event I think.

CountSlots and CountSlotsChest are used by the Storage and the bot to know how much it can put in there
and when to start an inventory cycle.

GetItemCountInventory() are to count what is in your Inventory at that time. Say if you want to track each of these items
either by the Message display or a section of your GUI.

Does Not track how many you put in the storage chest!!!
#CE
Func DisplayCounts()
;	Standard Vaettir Drops excluding Map Pieces
   Local $CurrentGold = GetGoldCharacter()
   Local $GlacialStones = GetItemCountInventory(27047)
   Local $MesmerTomes = GetItemCountInventory(21797)
   Local $Lockpicks = GetItemCountInventory(22751)
   Local $BlackDye = GetItemCountInventory(146, 10)
   Local $WhiteDye = GetItemCountInventory(146, 12)
;   Event Items
   Local $AgedDwarvenAle = GetItemCountInventory(24593)
   Local $AgedHuntersAle = GetItemCountInventory(31145)
   Local $BattleIslandIcedTea = GetItemCountInventory(36682)
   Local $BirthdayCupcake = GetItemCountInventory(22269)
   Local $CandyCaneShards = GetItemCountInventory(556)
   Local $GoldenEgg = GetItemCountInventory(22752)
   Local $Grog = GetItemCountInventory(30855)
   Local $HoneyCombs = GetItemCountInventory(26784)
   Local $KrytanBrandy = GetItemCountInventory(35124)
   Local $PartyBeacon = GetItemCountInventory(36683)
   Local $PumpkinPies = GetItemCountInventory(28436)
   Local $SpikedEggnog = GetItemCountInventory(6366)
   Local $TrickOrTreats = GetItemCountInventory(28434)
   Local $VictoryToken = GetItemCountInventory(18345)
   Local $WayfarerMark = GetItemCountInventory(37765)
;   RareMaterials
   Local $EctoCount = GetItemCountInventory(930)
   Local $ObShardCount = GetItemCountInventory(945)
   Local $FurCount = GetItemCountInventory(941)
   Local $LinenCount = GetItemCountInventory(926)
   Local $DamaskCount = GetItemCountInventory(927)
   Local $SilkCount = GetItemCountInventory(928)
   Local $SteelCount = GetItemCountInventory(949)
   Local $DSteelCount = GetItemCountInventory(950)
   Local $MonClawCount = GetItemCountInventory(923)
   Local $MonEyeCount = GetItemCountInventory(931)
   Local $MonFangCount = GetItemCountInventory(932)
   Local $RubyCount = GetItemCountInventory(937)
   Local $SapphireCount = GetItemCountInventory(938)
   Local $DiamondCount = GetItemCountInventory(935)
   Local $OnyxCount = GetItemCountInventory(936)
   Local $CharcoalCount = GetItemCountInventory(922)
   Local $GlassVialCount = GetItemCountInventory(939)
   Local $LeatherCount = GetItemCountInventory(942)
   Local $ElonLeatherCount = GetItemCountInventory(943)
   Local $VialInkCount = GetItemCountInventory(944)
   Local $ParchmentCount = GetItemCountInventory(951)
   Local $VellumCount = GetItemCountInventory(952)
   Local $SpiritwoodCount = GetItemCountInventory(956)
   Local $AmberCount = GetItemCountInventory(6532)
   Local $JadeCount = GetItemCountInventory(6533)
   Local $YuletideTonic = GetItemCountInventory(21490)
;   Standard Vaettir Drops excluding Map Pieces
   If $CurrentGold > 0 Then
      Out("Current Gold:" & $CurrentGold)
   ElseIf $GlacialStones > 0 Then
      Out("Glacial Count:" & $GlacialStones)
   ElseIf $MesmerTomes > 0 Then
      Out("Mesmer Tomes:" & $MesmerTomes)
   ElseIf $Lockpicks > 0 Then
      Out ("Lockpicks:" & $Lockpicks)
   ElseIf $BlackDye > 0 Then
      Out ("Black Dyes:" & $BlackDye)
   ElseIf $WhiteDye > 0 Then
      Out ("White Dyes:" & $WhiteDye)
   EndIf
;   Rare Materials
   If $FurCount > 0 Then
      Out ("Fur Squares:" & $FurCount)
   ElseIf $LinenCount > 0 Then
      Out ("Linen:" & $LinenCount)
   ElseIf $DamaskCount > 0 Then
      Out ("Damask:" & $DamaskCount)
   ElseIf $SilkCount > 0 Then
      Out ("Silk:" & $SilkCount)
   ElseIf $EctoCount > 0 Then
      Out("Ecto Count:" & $EctoCount)
   ElseIf $SteelCount > 0 Then
      Out ("Steel:" & $SteelCount)
   ElseIf $DSteelCount > 0 Then
      Out ("Deldrimor Steel:" & $DSteelCount)
   ElseIf $MonClawCount > 0 Then
      Out ("Monstrous Claw:" & $MonClawCount)
   ElseIf $MonEyeCount > 0 Then
      Out ("Monstrous Eye:" & $MonEyeCount)
   ElseIf $MonFangCount > 0 Then
      Out ("Monstrous Fang:" & $MonFangCount)
   ElseIf $RubyCount > 0 Then
      Out ("Ruby:" & $RubyCount)
   ElseIf $SapphireCount > 0 Then
      Out ("Sapphire:" & $SapphireCount)
   ElseIf $DiamondCount > 0 Then
      Out ("Diamond:" & $DiamondCount)
   ElseIf $OnyxCount > 0 Then
      Out ("Onyx:" & $OnyxCount)
   ElseIf $CharcoalCount > 0 Then
      Out ("Charcoal:" & $CharcoalCount)
   ElseIf $ObShardCount > 0 Then
      Out("Obby Count:" & $ObShardCount)
   ElseIf $GlassVialCount > 0 Then
      Out ("Glass Vial:" & $GlassVialCount)
   ElseIf $LeatherCount > 0 Then
      Out ("Leather Square:" & $LeatherCount)
   ElseIf $ElonLeatherCount > 0 Then
      Out ("Elonian Leather:" & $ElonLeatherCount)
   ElseIf $VialInkCount > 0 Then
      Out ("Vials of Ink:" & $VialInkCount)
   ElseIf $ParchmentCount > 0 Then
      Out ("Parchment:" & $ParchmentCount)
   ElseIf $VellumCount > 0 Then
      Out ("Vellum:" & $VellumCount)
   ElseIf $SpiritwoodCount > 0 Then
      Out ("Spiritwood Planks:" & $SpiritwoodCount)
   ElseIf $AmberCount > 0 Then
      Out ("Amber:" & $AmberCount)
   ElseIf $JadeCount > 0 Then
      Out ("Jade:" & $JadeCount)
   EndIf
;   Event Items
   If $AgedDwarvenAle > 0 Then
      Out("Aged Dwarven Ale:" & $AgedDwarvenAle)
   ElseIf $AgedHuntersAle > 0 Then
      Out("Aged Hunter's Ale:" & $AgedHuntersAle)
   ElseIf $BattleIslandIcedTea > 0 Then
      Out("Iced Tea:" & $BattleIslandIcedTea)
   ElseIf $BirthdayCupcake > 0 Then
      Out("Cupcakes:" & $BirthdayCupcake)
   ElseIf $CandyCaneShards > 0 Then
      Out("CC Shards:" & $CandyCaneShards)
   ElseIf $GoldenEgg > 0 Then
      Out("Golden Eggs:" & $GoldenEgg)
   ElseIf $Grog > 0 Then
      Out("Grog Arrr:" & $Grog)
   ElseIf $HoneyCombs > 0 Then
      Out("Honeycombs:" & $HoneyCombs)
   ElseIf $KrytanBrandy > 0 Then
      Out("Krytan Brandy:" & $KrytanBrandy)
   ElseIf $PartyBeacon > 0 Then
      Out("Jesus Beams:" & $PartyBeacon)
   ElseIf $PumpkinPies > 0 Then
      Out("Pumpkin Pies:" & $PumpkinPies)
   ElseIf $SpikedEggnog > 0 Then
      Out("Spiked Eggnog:" & $SpikedEggnog)
   ElseIf $TrickOrTreats > 0 Then
      Out("ToTs:" & $TrickOrTreats)
   ElseIf $VictoryToken > 0 Then
      Out("Victory Tokens:" & $VictoryToken)
   ElseIf $WayfarerMark > 0 Then
      Out("Wayfarer Marks:" & $WayfarerMark)
   ElseIf $YuletideTonic > 0 Then
	  Out("Yuletide Tonics:" & $YuletideTonic)
   EndIf
EndFunc

;~ Description: Count items in inventory by ModelID and optionally ExtraID.
Func GetItemCountInventory($aModelID, $aExtraID = 0)
   Local $lCount = 0
   For $bag = 1 To 4
	  Local $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then ContinueLoop
	  Local $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
	  For $slot = 0 To MemoryRead($lBagPtr + 32, 'long') - 1
		 Local $lItemPtr = MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr')
		 If $lItemPtr = 0 Then ContinueLoop
		 If MemoryRead($lItemPtr + 44, 'long') = $aModelID Then
			If $aExtraID <> 0 Then
			   If $aExtraID = MemoryRead($lItemPtr + 34, 'short') Then $lCount += MemoryRead($lItemPtr + 75, 'byte')
			Else
			   $lCount += MemoryRead($lItemPtr + 75, 'byte')
			EndIf
		 EndIf
	  Next
   Next
   Return $lCount
EndFunc
#EndRegion Counting Things
#EndRegion Inventory

;~ Description: Print to console with timestamp
Func Out($TEXT)
   Local $TEXTLEN = StringLen($TEXT)
   Local $CONSOLELEN = _GUICtrlEdit_GetTextLen($GLOGBOX)
   If $TEXTLEN + $CONSOLELEN > 30000 Then GUICtrlSetData($GLOGBOX, StringRight(_GUICtrlEdit_GetText($GLOGBOX), 30000 - $TEXTLEN - 1000))
   _GUICtrlEdit_AppendText($GLOGBOX, @CRLF & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " & $TEXT)
   _GUICtrlEdit_Scroll($GLOGBOX, 1)
EndFunc   ;==>OUT

#Region Pcons
Func UseCupcake($aModelID)
   If $useCupcake Then
	  If GetMapLoading() = 1 And Not GetIsDead(-2) Then
		 If $pconsCupcake_slot[0] > 0 And $pconsCupcake_slot[1] > 0 Then
			$lItemPtr = GetItemPtrBySlot($pconsCupcake_slot[0], $pconsCupcake_slot[1])
			If MemoryRead($lItemPtr + 44, 'long') = $aModelID Then UseItem($lItemPtr)
		 EndIf
	  EndIf
   EndIf
EndFunc

;~ This searches the bags for the specific pcon you wish to use.
Func pconsScanInventory($aModelID)
   For $bag = 1 to 4
	  $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then ContinueLoop ; no valid bag
	  For $slot = 1 To MemoryRead($lBagPtr + 32, 'long')
		 $lSlotPtr = GetItemPtrBySlot($lBagPtr, $slot)
		 If $lSlotPtr = 0 Then ContinueLoop ; empty slot
		 If MemoryRead($lSlotPtr + 44, 'long') = $aModelID Then
			$pconsCupcake_slot[0] = $bag
			$pconsCupcake_slot[1] = $slot
		 EndIf
	  Next
   Next
EndFunc   ;==>pconsScanInventory
#EndRegion Pcons

#Region Anti Report
Func RndTravel($aMapID)
   Local $UseDistricts = 11 ; 7=eu, 8=eu+int, 11=all(incl. asia)
   ; Region/Language order: eu-en, eu-fr, eu-ge, eu-it, eu-sp, eu-po, eu-ru, int, asia-ko, asia-ch, asia-ja
   Local $Region[11] = [2, 2, 2, 2, 2, 2, 2, -2, 1, 3, 4]
   Local $Language[11] = [0, 2, 3, 4, 5, 9, 10, 0, 0, 0, 0]
   Local $Random = Random(0, $UseDistricts - 1, 1)
   MoveMap($aMapID, $Region[$Random], 0, $Language[$Random])
   WaitMapLoading($aMapID, 30000)
   Sleep(GetPing()+3000)
EndFunc   ;==>RndTravel
#EndRegion

;~ Description: Return the square of the distance between two agents.
Func GetPseudoDistance($aAgent1, $aAgent2)
   Local $lAgent1X, $lAgent1Y, $lAgent2X, $lAgent2Y
   UpdateAgentPosByPtr($aAgent1, $lAgent1X, $lAgent1Y)
   UpdateAgentPosByPtr($aAgent2, $lAgent2X, $lAgent2Y)
   Return (DllStructGetData($aAgent1, 'X') - DllStructGetData($aAgent2, 'X')) ^ 2 + (DllStructGetData($aAgent1, 'Y') - DllStructGetData($aAgent2, 'Y')) ^ 2
EndFunc   ;==>GetPseudoDistance