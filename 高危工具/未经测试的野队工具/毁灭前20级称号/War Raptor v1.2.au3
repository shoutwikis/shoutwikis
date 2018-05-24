#include "GWA2.au3"
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <GuiEdit.au3>
Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Opt("TrayIconHide", 1)
Opt("MustDeclareVars", True)

;MAPIDS
Global Const $MAP_ID_RATA = 640
Global Const $MAP_ID_RIVEN = 501

;RARITY
Global Const $RARITY_GOLD = 2624
Global Const $RARITY_PURPLE = 2626
Global Const $RARITY_BLUE = 2623
Global Const $RARITY_WHITE = 2621

;CONSUMABLES
Global Const $ITEM_ID_LOCKPICKS = 22751
Global Const $ITEM_ID_SALVAGE_KIT = 2992
Global Const $ITEM_ID_ID_KIT = 2989

;DYES
Global Const $ITEM_ID_DYES = 146
Global Const $ITEM_EXTRAID_BLACKDYE = 10
Global Const $ITEM_EXTRAID_WHITEDYE = 12

;SCROLLS
Global Const $ITEM_ID_UWSCROLL = 3746
Global Const $ITEM_ID_FOWSCROLL = 22280

;MATS
Global $ITEM_ID_DUST = 244

;SAURIAN BONE
Global Const $ITEM_SAURIAN_BONE = 27035

;PCONS
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

;GREAT CONCH VARIABLE
Global $CanSalvageShields = False
Global Const $ITEM_ID_CONCH = 2415

;Skill Setup
Global Const $ds = 1
Global Const $pd = 2
Global Const $hb = 3
Global Const $ws = 4
Global Const $MoP = 5
Global Const $ss = 6
Global Const $sb = 7
Global Const $wa = 8

Global $SuccessfulRunCount = 0
Global $FailedRunCount = 0
Global $ShieldCount = 0

Global $RenderingEnabled = True

Global $Return

#Region GUI
Global $BotRunning = False
Global $BotInitialized = False

Global Const $mainGUI = GUICreate("Raptor Bot", 400, 200)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
Global $Input = GUICtrlCreateInput("character name", 8, 8, 150, 25)

GUICtrlCreateLabel("Runs:", 8, 40, 130, 20)
Global Const $RunsLabel = GUICtrlCreateLabel($successfulruncount, 140, 40, 50, 17)
GUICtrlCreateLabel("Fails:", 8, 60, 130, 20)
Global Const $FailsLabel = GUICtrlCreateLabel($FailedRunCount, 140, 60, 50, 17)
GUICtrlCreatelabel("Shields Salvaged:", 8, 80, 130, 20)
Global Const $ShieldsLabel = GUICtrlCreateLabel($ShieldCount, 140, 80, 50, 17)

Global Const $Checkbox = GUICtrlCreateCheckbox("Disable Rendering", 8, 110, 129, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "ToggleRendering")

Global Const $SalvageCheckbox = GUICtrlCreateCheckbox("Salvage Conch Shells?", 8, 130, 129, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)

Global Const $Button = GUICtrlCreateButton("Start", 8, 170, 131, 25)
	GUICtrlSetOnEvent(-1, "GuiButtonHandler")

Global $GLOGBOX = GUICtrlCreateEdit("", 180, 8, 220, 186, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL))

GUICtrlSetColor($GLOGBOX, 65280)
GUICtrlSetBkColor($GLOGBOX, 0)
GUISetState(@SW_SHOW)

Func GuiButtonHandler()
	If $BotRunning Then
		GUICtrlSetData($Button, "Will pause after this run")
		GUICtrlSetState($Button, $GUI_DISABLE)
		$BotRunning = False
	ElseIf $BotInitialized Then
		GUICtrlSetData($Button, "Pause")
		$BotRunning = True
	Else
		Out("Initializing")
		Local $CharName = GUICtrlRead($Input)
		If $CharName=="" Then
			If Initialize(ProcessExists("gw.exe"), True, True, False) = False Then
				MsgBox(0, "Error", "Guild Wars is not running.")
				Exit
			EndIf
		Else
			If Initialize($CharName, True, True, False) = False Then
				MsgBox(0, "Error", "Could not find a Guild Wars client with a character named '"&$CharName&"'")
				Exit
			EndIf
		EndIf
		EnsureEnglish(True)
		GUICtrlSetState($Checkbox, $GUI_ENABLE)
		GUICtrlSetState($SalvageCheckbox, $GUI_ENABLE)
		GUICtrlSetState($Input, $GUI_DISABLE)
		GUICtrlSetData($Button, "Pause")
		WinSetTitle($mainGui, "", "RaptorBot-" & GetCharname())
		$BotRunning = True
		$BotInitialized = True
	EndIf
EndFunc
#EndRegion GUI

While Not $BotRunning
	Sleep(100)
WEnd


While 1
   Global $Me = GetAgentByID(-2)

   Checkmap()

	If $SuccessfulRunCount = 0 Then
		SetUpFastWay()
		DisableHeroSkills()
	Else
		MoveTo(18323, 14946)
		MoveTo(18027, 16867)
		Move(19419, 16838)
		Sleep(6000)
	EndIf


   While CountFreeSlots() > 4
	  Main()
   WEnd

   Merchant()
   Sleep(Random(500, 1000))

WEnd

Func Main()
	$Return = 0
	Sleep(2000)
	Move(20084, 16854)
	Sleep(4000)
	WaitMapLoading($MAP_ID_RIVEN)

	CheckRep()
	MoveToBaseOfCave()
	KillHero()
	GetRaptors()
	KillRaptors()
	PickUpLoot()
	BackToTown()
EndFunc

Func Checkmap()
	If GetMapID() <> $MAP_ID_RATA Then
		Out("Mapping to Rata")
		TravelTo($MAP_ID_RATA)
	EndIf
EndFunc


Func SetUpFastWay()
	Sleep(Random(300, 500))
	Sleep(3000)
	SwitchMode(1)
	Out("Setting up resign")
	MoveTo(19649, 16791)
	Move(20084, 16854)
	Sleep(3000)
	WaitMapLoading($MAP_ID_RIVEN)
	Move(-26309, -4112)
	Sleep(4000)
	WaitMapLoading($MAP_ID_RATA)
EndFunc

#Region Main
Func DisableHeroSkills()
	For $i = 1 to 8
		DisableHeroSkillSlot(1, $i)
	Next
EndFunc

Func CheckRep()
	If GetMapID() <> $MAP_ID_RIVEN Then Return

	Local $Asura = GetAsuraTitle()
	If $Asura > 160000 Then
		Sleep(200)
	Else
		GetBlessing()
	EndIf
	UseHeroSkill(1, 1)
	Sleep(200)
	UseHeroSkill(1, 2)
EndFunc

Func MoveToBaseOfCave()
	If GetMapID() <> $MAP_ID_RIVEN Then Return

	If GetIsDead(-2) Then Return
	Out("Moving to cave")
	Move(-21975, -7372)
	RndSleep(Random(1800, 2200))
	UseHeroSkill(1, 3)
	Moveto(-21213, -8134)
	UseHeroSkill(1, 4, -2)
	Sleep(1500)
	Rndsleep(Random(900, 1200))
	UseHeroSkill(1, 5, -2)
	Rndsleep(Random(20, 50))
	UseHeroSkill(1, 6)
	Rndsleep(Random(20, 50))
	UseHeroSkill(1, 7)
	Rndsleep(Random(20, 50))
	UseHeroSkill(1, 8, -2)
	Move(-20613, -9529, 40)
EndFunc

Func KillHero()
	If GetMapID() <> $MAP_ID_RIVEN Then Return

	CommandAll(-19972, -6728)
	Sleep(Random(150, 350))
EndFunc

Func GetRaptors()
	If GetMapID() <> $MAP_ID_RIVEN Then Return

	Out("Gathering raptors")
	Local $lMoPTarget = GetNearestEnemyToAgent(-2)
	Local $lme = GetAgentByID(-2)
	Local $CheckTarget

	MoveTo(-20962, -9510, 50)
	$lMoPTarget = GetNearestEnemyToAgent(-2)
	UseSkill($sb, -2)
	UseSkillEx($MoP, $lMoPTarget)

	$CheckTarget = TargetNearestEnemy()
	MoveTo(-21116, -9267, 50)
	MoveTo(-20887, -9066, 50)
	MoveAggroing(-20002, -10281, 50, $CheckTarget)
	MoveAggroing(-19750, -10735, 50, $CheckTarget)
	MoveAggroing(-19766, -11315, 50, $CheckTarget)
	MoveAggroing(-20572, -12201, 50, $CheckTarget)
	MoveAggroing(-21010, -12151, 50, $CheckTarget)
	MoveAggroing(-22000, -11877, 50, $CheckTarget)
	MoveAggroing(-22780, -11949, 20, $CheckTarget)
	MoveAggroing(-22978, -12120, 15, $CheckTarget)
EndFunc

Func KillRaptors()
	Local $lMoPTarget
	Local $lMe = GetAgentByID(-2)
	Local $lRekoff

	If GetMapID() <> $MAP_ID_RIVEN Then Return

	If GetIsDead($lme) Then Return

	UseSkill($ds, $lMe)
	Rndsleep(Random(30, 60))
	UseSkill($pd, $lMe)
	Rndsleep(Random(30, 60))
	UseSkill($hb, $lMe)
	Sleep(1000)
	UseSkill($ws, $lMe)

	$lRekoff = (GetAgentByName("Rekoff Broodmother"))

	If ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), DllStructGetData($lRekoff, 'X'), DllStructGetData($lRekoff, 'Y')) > 1500 Then
		$lMoPTarget = GetNearestEnemyToAgent(-2)
	Else
		$lMoPTarget = GetNearestEnemyToAgent($lRekoff)
	EndIf

	If GetHasHex($lMoPTarget) Then
		TargetNextEnemy()
		$lMoPTarget = GetCurrentTarget()
	EndIf

	Local $lDistance
	Local $RANGE_SPELLCAST_2 = 1085^2
	Local $lSpellCastCount
	Local $lAgentArray

	$lAgentArray = GetAgentArray(0xDB)

	For $i=1 To $lAgentArray[0]
	$lDistance = GetPseudoDistance($lMe, $lAgentArray[$i])
		If $lDistance < $RANGE_SPELLCAST_2 Then
			$lSpellCastCount += 1
		EndIf
	Next

	If $lSpellCastCount	> 20 Then
		Sleep(1500)
	Elseif $lSpellCastCount < 21 Then
		Sleep(3500)
	EndIf

	UseSkill($MoP, $lMoPTarget)
	Sleep(1500)
	UseSkill($ss, $lMe)
	Sleep(2000)
	UseSkill($sb, $lMe)
	UseSkill($wa, GetNearestEnemyToAgent(-2))
	Sleep(3000)

EndFunc

Func PickUpLoot()
	Local $lAgent
	Local $lItem
	Local $lDeadlock

	If GetMapID() <> $MAP_ID_RIVEN Then Return

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
				If GetIsDead($Me) Then Return
				If TimerDiff($lDeadlock) > 25000 Then ExitLoop
			WEnd
		EndIf
	Next
EndFunc   ;==>PickUpLoot

Func BackToTown()

	UpdateStats()

	_PurgeHook()

	If GetMapID() = $MAP_ID_RIVEN Then
		Resign()
		Sleep(3500)
		ReturnToOutpost()
		Sleep(8000)
	EndIf
EndFunc

#EndRegion Main

Func CountFreeSlots()
   Local $temp = 0
   Local $bag
   $bag = GetBag(1)
   $temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
   $bag = GetBag(2)
   $temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
   $bag = GetBag(3)
   $temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
   Return $temp
EndFunc

Func GetBlessing()
	Local $KreweMemberID = 36
	Out("Getting blessing")
	UseHeroSkill(1, 1)
	Sleep(200)
	UseHeroSkill(1, 2)
	GonearestNPCtoCoords(-24259, -5602)
	Dialog(0x84)
	Sleep(200)
EndFunc

Func GoNearestNPCToCoords($aX, $aY)
	Local $NPC
	MoveTo($aX, $aY)
	$NPC = GetNearestNPCToCoords($aX, $aY)
	Do
		RndSleep(250)
		GoNPC($NPC)
	Until GetDistance($NPC, -2) < 250
	RndSleep(500)
EndFunc

Func UseSkillEx($lSkill, $lTgt=-2, $aTimeout = 10000)
	Local $lme = GetAgentByID(-2)
	If GetIsDead($lme) Then Return
	If Not IsRecharged($lSkill) Then Return

	Local $lDeadlock = TimerInit()
	UseSkill($lSkill, $lTgt)

	Do
		Sleep(50)
		If GetIsDead($lme) = 1 Then Return
	Until (Not IsRecharged($lSkill)) Or (TimerDiff($lDeadlock) > $aTimeout)

	If $lSkill > 1 Then RndSleep(750)
EndFunc


Func IsRecharged($lSkill)
	Return GetSkillBarSkillRecharge($lSkill)==0
EndFunc

Func MoveAggroing($lDestX, $lDestY, $lRandom, $CheckTarget)
	Local $lMe
	Local $ChatStuckTimer
	Local $lBlocked
	Local $RANGE_ADJACENT_2 = 156^2
	Local $lAdjacentCount, $lDistance
	Local $lAgentArray


	Move($lDestX, $lDestY, $lRandom)

	$lAgentArray = GetAgentArray(0xDB)

	For $i=1 To $lAgentArray[0]
	$lDistance = GetPseudoDistance($lMe, $lAgentArray[$i])
		If $lDistance < $RANGE_ADJACENT_2 Then
			$lAdjacentCount += 1
		EndIf
	Next

	If $lAdjacentCount > 10 Then
		$Return += 1
	EndIf

	Do
		Sleep(50)

		$lMe = GetAgentByID(-2)

		If GetIsDead($lMe) Then Return

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			$lBlocked += 1
			Move($lDestX, $lDestY, $lRandom)
		EndIf

		If $lBlocked > 3 Then
			If TimerDiff($ChatStuckTimer) > 3000 Then	; use a timer to avoid spamming /stuck
				SendChat("stuck", "/")
				$ChatStuckTimer = TimerInit()
				$Return += 1
			EndIf
		EndIf

		If GetDistance() > 1500 Then ; target is far, we probably got stuck.
			If TimerDiff($ChatStuckTimer) > 3000 Then ; dont spam
				SendChat("stuck", "/")
				$ChatStuckTimer = TimerInit()
				RndSleep(GetPing())
				Attack($CheckTarget)
				$Return += 1
			EndIf
		EndIf

		If $Return > 0 Then Return

	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < $lRandom*1.5
EndFunc


Func CanPickUp($aItem)
	Local $lModelID = DllStructGetData(($aItem), 'ModelID')
	Local $lRarity = GetRarity($aItem)
	If $lModelID == 2511 And GetGoldCharacter() < 99000 Then Return True	; gold coins (only pick if character has less than 99k in inventory)
	If $lModelID > 21785 And $lModelID < 21806 Then Return True	; Elite/Normal Tomes
    If $lRarity == $RARITY_GOLD 			Then Return True
	If $lModelID == $ITEM_ID_DYES Then	; if dye
		Switch DllStructGetData($aItem, "ExtraID")
			Case $ITEM_EXTRAID_BLACKDYE, $ITEM_EXTRAID_WHITEDYE ; only pick white and black ones
				Return True
			Case Else
				Return False
		EndSwitch
	 EndIf
	 If StackableReturnTrue($lModelID) Then Return True

	Return False
EndFunc

Func StackableReturnTrue($lModelID)
	If $lModelID == $ITEM_ID_DUST			Then Return True
	If $lModelID == $ITEM_SAURIAN_BONE		Then Return True
	If $lModelID == $ITEM_EXTRAID_BLACKDYE	Then Return True
	If $lModelID == $ITEM_EXTRAID_WHITEDYE	Then Return True
    If $lModelID == 854						Then Return True
    If $lModelID == $ITEM_ID_LOCKPICKS 		Then Return True
    If $lModelID == $ITEM_ID_ID_KIT			Then Return True
	; ==== Pcons ====
	If $lModelID == $ITEM_ID_TOTS 			Then Return True
	If $lModelID == $ITEM_ID_GOLDEN_EGGS 	Then Return True
	If $lModelID == $ITEM_ID_BUNNIES 		Then Return True
	If $lModelID == $ITEM_ID_GROG 			Then Return True
	If $lModelID == $ITEM_ID_CLOVER 		Then Return True
	If $lModelID == $ITEM_ID_PIE			Then Return True
	If $lModelID == $ITEM_ID_CIDER			Then Return True
	If $lModelID == $ITEM_ID_POPPERS		Then Return True
	If $lModelID == $ITEM_ID_ROCKETS		Then Return True
	If $lModelID == $ITEM_ID_CUPCAKES		Then Return True
	If $lModelID == $ITEM_ID_SPARKLER		Then Return True
	If $lModelID == $ITEM_ID_HONEYCOMB		Then Return True
	If $lModelID == $ITEM_ID_VICTORY_TOKEN	Then Return True
	If $lModelID == $ITEM_ID_LUNAR_TOKEN	Then Return True
	If $lModelID == $ITEM_ID_HUNTERS_ALE	Then Return True
	If $lModelID == $ITEM_ID_LUNAR_TOKENS	Then Return True
	If $lModelID == $ITEM_ID_KRYTAN_BRANDY	Then Return True
	If $lModelID == $ITEM_ID_BLUE_DRINK		Then Return True
EndFunc

Func Merchant()
	GoToMerchant()
	Out("Identifying Items")
	Ident(1)
	Ident(2)
	Ident(3)
	Out("Depositing Gold")
	DepositGold()
	Out("Selling Items")
	Sell(1)
	Sell(2)
	Sell(3)

	MoveTo(18323, 14946)
	MoveTo(18027, 16867)
	Sleep(6000)
EndFunc

Func GoToMerchant()
	MoveTo(19332, 14715)
	MoveTo(19273, 14557)
	GoNearestNPCtoCoords(18574, 13983)
EndFunc

Func Ident($bagIndex)
	Local $bag = GetBag($bagIndex)
	For $i = 1 To DllStructGetData($bag, 'slots')
		If FindIDKit() = 0 Then
			If GetGoldCharacter() < 500 AND GetGoldStorage() > 499 Then
				WithdrawGold(500)
				Sleep(Random(200,300))
			EndIf
			Do
				BuyIDKit()
				RndSleep(500)
			Until FindIDKit() <> 0
			RndSleep(500)
		EndIf
		Local $aitem = GetItemBySlot($bagIndex, $i)
		If DllStructGetData($aItem, 'ID') = 0 Then ContinueLoop
		IdentifyItem($aItem)
		Sleep(Random(500,750))
	Next
EndFunc

Func Sell($BAGINDEX)
	Local $AITEM
	Local $BAG = GETBAG($BAGINDEX)
	Local $NUMOFSLOTS = DllStructGetData($BAG, "slots")
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop

		If CANSELL($AITEM) Then
			SELLITEM($AITEM)
		EndIf
		Sleep(GetPing()+250)
	Next
EndFunc

Func CanSell($aItem)
	Local $LMODELID = DllStructGetData($aitem, "ModelID")
	Local $LRARITY = GetRarity($aitem)
	Local $Requirement = GetItemReq($aItem)
	If StackableReturnTrue = True Then Return False
	If $Requirement == 8 Then Return False

	If GUICtrlRead($SalvageCheckBox) = 1 Then
		$CanSalvageShields = True
	Else
		$CanSalvageShields = False
	EndIf

	If $LMODELID == $ITEM_ID_CONCH AND $CanSalvageShields = True Then
		SalvageShields($aItem)
	EndIf

	If $LMODELID == $ITEM_ID_FOWSCROLL Then Return False
	If $LMODELID == $ITEM_ID_UWSCROLL Then Return False
	If $LRARITY == $RARITY_Gold Then
		Return True
	EndIf
	If $LRARITY == $RARITY_Purple Then
		Return True
	EndIf
	If $LMODELID == $ITEM_ID_Dyes Then
		Switch DllStructGetData($aitem, "ExtraID")
			Case $ITEM_ExtraID_BlackDye, $ITEM_ExtraID_WhiteDye
				Return False
			Case Else
				Return True
		EndSwitch
	EndIf

EndFunc   ;==>CanSell

Func SalvageShields($aitem)

	If FindSalvageKit() = 0 Then
		If GetGoldCharacter() < 2000 AND GetGoldStorage() > 1999 Then
			WithdrawGold(2000)
			Sleep(Random(200,300))
		EndIf

		Do
			BuySuperiorSalvageKit()
			RndSleep(500)
		Until FindIDKit() <> 0

		RndSleep(500)
	EndIf

	Local $LMODELID = DllStructGetData($aitem, "ModelID")
	Local $Requirement = GetItemReq($aItem)

	If $Requirement == 8 Then Return
	If $LMODELID == $ITEM_ID_CONCH Then
		StartSalvage($aitem)
		Sleep(Random(800, 1200))
		SalvageMaterials()
		Sleep(Random(800, 1200))

		$ShieldCount += 1
		GUICtrlSetData($ShieldsLabel, $ShieldCount)
	EndIf

EndFunc

Func BuySuperiorSalvageKit()
	BuyItem(4, 1, 2000)
	Sleep(Random(300, 500))
EndFunc

Func Out($TEXT)
	Local $TEXTLEN = StringLen($TEXT)
	Local $CONSOLELEN = _GUICtrlEdit_GetTextLen($GLOGBOX)
	If $TEXTLEN + $CONSOLELEN > 30000 Then GUICtrlSetData($GLOGBOX, StringRight(_GUICtrlEdit_GetText($GLOGBOX), 30000 - $TEXTLEN - 1000))
	_GUICtrlEdit_AppendText($GLOGBOX, @CRLF & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " & $TEXT)
	_GUICtrlEdit_Scroll($GLOGBOX, 1)
EndFunc   ;==>OUT

Func UpdateStats()
	Local $lMe
	Local $RANGE_ADJACENT_2 = 156^2
	Local $lAdjacentCount, $lDistance
	Local $lAgentArray

	$lAgentArray = GetAgentArray(0xDB)

	For $i=1 To $lAgentArray[0]
	$lDistance = GetPseudoDistance($lMe, $lAgentArray[$i])
		If $lDistance < $RANGE_ADJACENT_2 Then
			$lAdjacentCount += 1
		EndIf
	Next

	If GetIsDead(-2) Or $lAdjacentCount > 7 Then
		$FailedRunCount += 1
		GUICtrlSetData($FailsLabel, $FailedRunCount)
	Else
		$SuccessfulRunCount += 1
		GUICtrlSetData($RunsLabel, $SuccessfulRunCount)
	EndIf
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
EndFunc   ;==>ToggleRendering

Func _PurgeHook()
	Out("Purging engine hook")
	ToggleRendering()
	Sleep(Random(2000, 2500))
	ClearMemory()
	Sleep(Random(2000, 2500))
	ToggleRendering()
EndFunc   ;==>

Func _Exit()
	Exit
EndFunc
