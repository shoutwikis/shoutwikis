#include "../../¼¤Õ½½Ó¿Ú.au3"
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

;;;;; Variables globales ;;;;;

Global $Kaineng = 194
Global $Kaineng2 = 817

Global $nbFails = 0
Global $nbRuns = 0
Global $nbCitations = 0
Global $bRunning = False
Global $bInitialized = False
Global $bCanContinue = True

Global $RENDERING = True
Global $GWPID = -1

Global $dunkoro = "Dunkoro"
Global $gwen = "Gwen"
Global $miku = "Miku"
Global $zhed = "Zhed Shadowhoof"


Global $skill_bar_justice=1
global $skill_bar_100b=2
Global $skill_bar_exLimite=3
Global $skill_bar_toubillon=4
global $skill_bar_stab=5
global $skill_bar_echap=6
Global $skill_bar_EBON=7
Global $skill_bar_sceau=8

;;;;; Interface ;;;;

Opt("GUIOnEventMode", True)

$GUI = GUICreate("Assa", 200, 165)

$gSettings = GUICtrlCreateGroup("Settings", 5, 2, 190, 70)
$txtName = GUICtrlCreateCombo("", 20, 20, 160, 20)
		   GUICtrlSetData(-1, GetLoggedCharNames())
$disableGraph = GUICtrlCreateCheckbox("Disable Graphics", 20, 45)
$gStats = GUICtrlCreateGroup("Stats", 5, 75, 190, 60)
$lblCitations = GUICtrlCreateLabel("Citations : ", 20, 93, 160, 20)
$stCitations = GUICtrlCreateLabel($nbCitations, 100, 93, 50, 20, $SS_CENTER)
$lblRuns = GUICtrlCreateLabel("Nombre de Runs : ", 20, 113, 160, 20)
$stRuns = GUICtrlCreateLabel("", 100, 113, 50, 20, $SS_CENTER)
$bStart = GUICtrlCreateButton("Start", 5, 138, 190, 25, $WS_GROUP)

GUISetState(@SW_SHOW)

GUICtrlSetOnEvent($bStart, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")
GUICtrlSetOnEvent($disableGraph, "EventHandler")



Do
   Sleep(100)
Until $bInitialized

While 1
;~ 	If INVENTORYCHECK() Then IDANDSELL()

	If GetMapID() <> $Kaineng And GetMapID() <> $Kaineng2 Then
		TravelTo($Kaineng)
	EndIf

	GUICtrlSetData($stRuns, $nbRuns & "  (" & $nbFails & ")")

	$bCanContinue = True

;~ 	ClearMemory()

;~ 	If $RENDERING Then
;~ 		DISABLERENDERING()
;~ 	EndIf

	logFile("Start run")

	DoJob()
WEnd

 Func EventHandler()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			Exit
		Case $bStart
			If $bRunning Then
				GUICtrlSetData($bStart, "Resume")
				$bRunning = False
			ElseIf $bInitialized Then
				GUICtrlSetData($bStart, "Pause")
				$bRunning = True
			Else
				$bRunning = True
				GUICtrlSetData($bStart, "Initializing...")
				GUICtrlSetState($bStart, $GUI_DISABLE)
				GUICtrlSetState($txtName, $GUI_DISABLE)
				WinSetTitle($GUI, "", GUICtrlRead($txtName))
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
				$bInitialized = True
				$GWPID = $mGWHwnd
			 EndIf
		 Case $disableGraph
			 ClearMemory()
			TOGGLERENDERING()
	EndSwitch
EndFunc

Func DoJob()
	GoToQuest()
	EnterQuest()
	PrepareToFight()
	Fight()
	If $bCanContinue Then
		GoToStairs()
	Else
		logFile("Fail at Miku")
	EndIf
	If $bCanContinue Then Survive()
	If $bCanContinue Then PickUpLoot()

	If $bCanContinue Then
		$nbRuns += 1
	Else
		$nbFails += 1
	EndIf

	_PURGEHOOK()
EndFunc

Func GoToQuest()
	Local $lMe, $coordsX, $coordsY

	$lMe = GetAgentByID(-2)
	$coordsX = DllStructGetData($lMe, 'X')
	$coordsY = DllStructGetData($lMe, 'Y')

	If -1400 < $coordsX And $coordsX < -550 And -2000 < $coordsY And $coordsY < -1100 Then
		MoveTo(1474, -1197, 0)
	EndIf
;~ 	If 2300 < $coordsX And $coordsX < 3000 And -4000 < $coordsY and $coordsY < -3500 Then
;~ 	ElseIf 2800 < $coordsX and $coordsX < 3500 And -1700 < $coordsY And $coordsY < -1100 Then
;~ 	ElseIf 2300 < $coordsX And $coordsX < 2800 And 300 < $coordsY And $coordsY < 1000 Then
EndFunc

Func EnterQuest()
	Local $NPC = GetNearestNPCToCoords(2240,-1264)
	GoToNPC($NPC)
	Dialog(0x8565)
	Sleep(1050)
	Dialog(0x00000084)
	Sleep(500)
	WaitMapLoading()
EndFunc

Func PrepareToFight()
	Local $lDunko, $lGwen, $lMiku, $lZhed
	Local $lDeadLock, $lDeadLock2

	$lDunko = GetAgentByName($dunkoro)
	$lGwen = GetAgentByName($gwen)
	$lMiku = GetAgentByName($miku)

	UseHeroSkill(4,1)
	Sleep(2000)
	UseHeroSkill(4,8, $lDunko)
	Sleep(3500)
	UseHeroSkill(4,8,$lMiku)
	Sleep(3500)
	UseHeroSkill(4,8,$lGwen)
	Sleep(3500)

	CommandAll(-5536,-4765)

	CommandHero(1,-5399,-4965)
	CommandHero(2,-5877,-4479)
	CommandHero(3,-5669,-4640)

	MoveTo(-6030,-5292)

	$lDeadLock = TimerInit()
	Do
		Sleep(250)
	Until GetNumberOfFoesInRangeOfAgent(-2, 4250)<>0 Or TimerDiff($lDeadLock) > 60000

	$lDeadLock2 = TimerInit()

	Do
		$lMiku=GetAgentByName($miku)
		HelpMiku($lMiku)
		Sleep(500)
	Until TimerDiff($lDeadLock2) > 15000

	UseSkillEx(7)
EndFunc

Func Fight()
	Local $lMiku, $lMob
	Local $lDeadLock, $lDeadLock2

;~ 	Do
;~ 		$lMiku=GetAgentByName($miku)

;~ 		HelpMiku($lMiku)

;~ 		If GetIsDead($lMiku) Then $bCanContinue = False

;~ 	Until GetNumberOfFoesInRangeOfAgent(-2, 8000) <= 5 Or $bCanContinue = False

	CancelAll()
	CancelHero(1)
	CancelHero(2)
	CancelHero(3)

	$lDeadLock = TimerInit()
	Do
		$lMob = GetNearestEnemyToAgent(-2)
		$lMiku=GetAgentByName($miku)
		Attack($lMob)
		HelpMiku($lMiku)
		Sleep(250)
		PickUpLoot()
		If GetisDead($lMiku) Then $bCanContinue = False
	Until GetNumberOfFoesInRangeOfAgent(-2, 2000) = 0 Or $bCanContinue = False Or TimerDiff($lDeadLock) > 180000

	If $bCanContinue Then
		MoveTo(-5961, -5082)

		$lDeadLock2 = TimerInit()

		Do
			Sleep(50)
		Until GetNumberOfFoesInRangeOfAgent(-2, 3000) <= 20 Or TimerDiff($lDeadLock2) > 60000
		Sleep(3000)
	EndIf
EndFunc


Func HelpMiku($aMiku)
   If DllStructGetData($aMiku, 'HP')< 0.3 Then
	  UseHeroSkill(4,4 , $aMiku)
	  UseHeroSkill(2,1 , $aMiku)
   EndIf
EndFunc

Func GoToStairs()
	CommandAll(-6707,-5242)

	MoveTo(-4790, -3441)
	MoveTo(-4608, -2120)
	MoveTo(-4222, -1545)
	MoveTo(-4664, -672)
	MoveTo(-3825, 134)
	MoveTo(-3067, 633)
	MoveTo(-2663, 644)
	MoveTo(-2214, -334)
	MoveTo(-878, -1877)
	MoveTo(-770, -3052)
	MoveTo(-699, -3773)
	MoveTo( -1070, -4192, 0)

	CommandHero(1,-5798,-5272)
EndFunc

Func Survive()
	Local $lDeadLock
	Local $lMe, $lNrj

	$lDeadLock = TimerInit()
	Do
		Sleep(250)
	Until GetNumberOfFoesInRangeOfAgent(-2,200) <> 0 Or TimerDiff($lDeadLock) > 60000

	$lDeadLock = TimerInit()
	Do
		$lMe = GetAgentByID(-2)
		If IsDllStruct(GetEffect(480)) Then UseHeroSkill(1, 1)
		If DllStructGetData($lMe, "HP") < 0.8 Then
			If IsRecharged($skill_bar_stab) Then UseSkillEx($skill_bar_stab)
			If IsRecharged($skill_bar_echap) Then UseSkillEx($skill_bar_echap)
		EndIf

		If IsRecharged($skill_bar_sceau) Then UseSkillEx($skill_bar_sceau)

	Until GetisDead(-2) Or GetNumberOfFoesInRangeOfAgentbis(-2,200) = 60 Or TimerDiff($lDeadLock) > 45000

	Do
		$lNrj = GetEnergy(-2)
		Sleep(250)
	Until $lNrj > 15 Or GetIsDead(-2)

	CommandHero(1,-6707,-5242)

	UseSkillEx($skill_bar_EBON)
	UseSkillEx($skill_bar_justice)

	Do
		$lNrj = GetEnergy(-2)
		Sleep(250)
	Until $lNrj > 10 Or GetIsDead(-2)

	UseSkillEx($skill_bar_100b)
	UseSkillEx($skill_bar_exLimite)

	Sleep(250)

	UseSkillEx($skill_bar_toubillon, GetNearestEnemyToAgent(-2))

	If GetIsDead(-2) Then
		$bCanContinue = False
		logFile("Fail at the end")
	EndIf

	Sleep(3000)
EndFunc

Func IsRecharged($lSkill)
	Return GetSkillBarSkillRecharge($lSkill)==0
EndFunc

Func PickUpLoot()
	Local $lAgent
	Local $aitem
	Local $lDeadlock
	For $i = 1 To GetMaxAgents()
		If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
		$aitem = GetItemByAgentID($i)
		If CanPickUp2($aitem) Then
			PickUpItem($aitem)
			$lDeadlock = TimerInit()
			While GetAgentExists($i)
				Sleep(100)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
			WEnd
		EndIf
	Next
EndFunc   ;==>PickUpLoot

Func CanPickUp2($aitem)
   $m = DllStructGetData(($aitem), 'ModelID')
   $lRarity = GetRarity($aItem)
   If $m == 36985 Then
		$nbCitations += 1
		GUICtrlSetData($stCitations, $nbCitations)
        Return True
;~ 	ElseIf $lRarity = 2624 Then
;~ 		Return True
	ElseIf $M = 146 Then
		If DllStructGetData($AITEM, "ExtraId") > 9 Then
			Return True
		Else
			Return False
		EndIf
	ElseIf $m = 22751 Then
		Return True
	Else
        Return False
   EndIf
EndFunc

Func UseSkillEx($lSkill, $lTgt=-2, $aTimeout = 3000)
	If GetIsDead(-2) Then Return
	If Not IsRecharged($lSkill) Then Return

	Local $lDeadlock = TimerInit()
	UseSkill($lSkill, $lTgt)
	Do
		Sleep(50)
		If GetIsDead(-2) = 1 Then Return
	Until (Not IsRecharged($lSkill)) Or (TimerDiff($lDeadlock) > $aTimeout)
   Sleep(50)
EndFunc

Func TOGGLERENDERING()
	If $RENDERING Then
		DISABLERENDERING()
		$RENDERING = False
		Sleep(Random(1000, 3000))
		_REDUCEMEMORY()
		AdlibRegister("_ReduceMemory", 20000)
	Else
		AdlibUnRegister("_ReduceMemory")
		ENABLERENDERING()
		$RENDERING = True
	EndIf
EndFunc

Func DISABLEREND()
	DISABLERENDERING()
	$RENDERING = False
	Sleep(Random(1000, 3000))
	_REDUCEMEMORY()
	AdlibRegister("_ReduceMemory", 20000)
EndFunc

Func _REDUCEMEMORY()
	If $GWPID <> -1 Then
		Local $AI_HANDLE = DllCall("kernel32.dll", "int", "OpenProcess", "int", 2035711, "int", False, "int", $GWPID)
		Local $AI_RETURN = DllCall("psapi.dll", "int", "EmptyWorkingSet", "long", $AI_HANDLE[0])
		DllCall("kernel32.dll", "int", "CloseHandle", "int", $AI_HANDLE[0])
	Else
		Local $AI_RETURN = DllCall("psapi.dll", "int", "EmptyWorkingSet", "long", -1)
	EndIf
	Return $AI_RETURN[0]
EndFunc

Func _PURGEHOOK()
	TOGGLERENDERING()
	Sleep(Random(2000, 2500))
	TOGGLERENDERING()
EndFunc

Func GetNumberOfFoesInRangeOfAgent($aAgent = -2, $aRange = 1250)
	Local $lAgent, $lDistance
	Local $lCount = 0

	If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)

	For $i = 1 To GetMaxAgents()
		$lAgent = GetAgentByID($i)
		If BitAND(DllStructGetData($lAgent, 'typemap'), 262144) Then ContinueLoop
		If DllStructGetData($lAgent, 'Type') <> 0xDB Then ContinueLoop
		If DllStructGetData($lAgent, 'Allegiance') <> 3 Then ContinueLoop

		     If DllStructGetData($lAgent, 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) > 0 Then ContinueLoop
		$lDistance = GetDistance($lAgent)

		If $lDistance > $aRange Then ContinueLoop
		$lCount += 1
	Next
	Return $lCount
 EndFunc   ;==>GetNumberOfFoesInRangeOfAgent
 Func GetNumberOfFoesInRangeOfAgentbis($aAgent = -2, $aRange = 1250)
	Local $lAgent, $lDistance
	Local $lCount = 0

	If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)

	For $i = 1 To GetMaxAgents()
		$lAgent = GetAgentByID($i)
		If BitAND(DllStructGetData($lAgent, 'typemap'), 262144) Then ContinueLoop
		If DllStructGetData($lAgent, 'Type') <> 0xDB Then ContinueLoop
		If DllStructGetData($lAgent, 'Allegiance') <> 3 Then ContinueLoop

		     If DllStructGetData($lAgent, 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) > 0 Then ContinueLoop
		$lDistance = GetDistance($lAgent)
		$agenty=DllStructGetData($lAgent, 'Y')
		if $agenty <-4500 Then
			$lCount += 1
		EndIf
		If $lDistance > $aRange Then ContinueLoop
		$lCount += 1
	Next
	Return $lCount
EndFunc

Func logFile($string)
	Local $timestamp = "[" & @HOUR & ":" & @MIN & "] "
    $file = FileOpen("log - " & GUICtrlRead($txtName) & ".txt", 1)
	Sleep(250)
	FileWrite($file, $timestamp & $string & @CRLF)
    FileClose($file)
EndFunc


Func INVENTORYCHECK()
	If CountInvSlots() < 3 Then
		Return True
	Else
		Return False
	EndIf
EndFunc
Func CountInvSlots()
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
Func IDANDSELL()
	TravelGH()
	logFile("Cleaning inventory")
	GONEARESTNPCTOCOORDS(-4061, -1059)
	IDENT(1)
	IDENT(2)
	IDENT(3)
	IDENT(4)
	SELL(1)
	SELL(2)
	SELL(3)
	SELL(4)
	StoreBag(1)
	StoreBag(2)
	StoreBag(3)
	StoreBag(4)
	SECUREIDKIT()
	If GETGOLDCHARACTER() > 70000 Then DepositGold()
EndFunc
Func IDENT($BAGINDEX)
	$BAG = GETBAG($BAGINDEX)
	Local $R = 0
	For $I = 1 To DllStructGetData($BAG, "slots")
		SECUREIDKIT()
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		If Not GETISIDED($AITEM) Then IDENTIFYITEM($AITEM)
		Sleep(Random(400, 750))
	Next
EndFunc
Func SECUREIDKIT()
	If FINDIDKIT() = 0 Then
		If GETGOLDCHARACTER() < 500 And GETGOLDSTORAGE() > 499 Then
			WITHDRAWGOLD(500)
			Sleep(Random(200, 300))
		EndIf
		Do
			BUYITEM(6, 1, 500)
			RNDSLEEP(500)
		Until FINDIDKIT() <> 0
		RNDSLEEP(500)
	EndIf
EndFunc
Func SELL($BAGINDEX)
	$BAG = GETBAG($BAGINDEX)
	$NUMOFSLOTS = DllStructGetData($BAG, "slots")
	For $I = 1 To $NUMOFSLOTS
		logFile("Selling item: " & $BAGINDEX & ", " & $I)
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		If CANSELL($AITEM) Then
			SELLITEM($AITEM)
		EndIf
		RNDSLEEP(250)
	Next
EndFunc
Func CANSELL($AITEM)
	$Q = DllStructGetData($AITEM, "quantity")
	$M = DllStructGetData($AITEM, "ModelID")
	$R = GETRARITY($AITEM)
	If $M = 146 Then ; teintures noires et blanches
		If DllStructGetData($AITEM, "ExtraId") > 9 Then
			Return False
		Else
			Return True
		EndIf
	ElseIf $M = 22751 Then ; lockpicks
		Return False
	ElseIf $M = 778 Then
		Return False
	ElseIf $M = 5899 Then
		Return False
	Else
		Return True
	EndIf
EndFunc

Func StoreBag($aBag)
	logFile("Storing bag " & $aBag)
	If Not IsDllStruct($aBag) Then $aBag = GetBag($aBag)
	Local $lItem
	Local $lSlot

	If IsChestFull() Then Return

	For $i = 1 To DllStructGetData($aBag, 'Slots')

		$lItem = GetItemBySlot($aBag, $i)
		If DllStructGetData($lItem, 'id') == 0 Then ContinueLoop
		$r = GetRarity($lItem)

		If $r = 2624 Then
			$lSlot = OpenStorageSlot()
			If IsArray($lSlot) Then
				MoveItem($lItem, $lSlot[0], $lSlot[1])
				Sleep(GetPing() + Random(500, 750, 1))
			EndIf
		EndIf
	Next
EndFunc   ;==>StoreBag

Func IsChestFull()
   If CountChestSlots() = 0 Then
	  logFile("Chest Full")
	  Return True
   EndIf
   Return False
EndFunc

Func CountChestSlots()
   Local $bag
   Local $temp = 0
   For $i = 8 to 16
	  $bag = GetBag($i)
	  $temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
   Next
   Return $temp
EndFunc

Func OpenStorageSlot()
   Local $lBag
   Local $lReturnArray[2]

   For $i = 8 To 16
	  $lBag = GetBag($i)
	  For $j = 1 To DllStructGetData($lBag, 'Slots')
		 If DllStructGetData(GetItemBySlot($lBag, $j), 'ID') == 0 Then
			   $lReturnArray[0] = $i
			   $lReturnArray[1] = $j
			   Return $lReturnArray
		 EndIf
	  Next
   Next
EndFunc   ;==>OpenStorageSlot

Func GONEARESTNPCTOCOORDS($X, $Y)
	Do
		RNDSLEEP(250)
		$GUY = GETNEARESTNPCTOCOORDS($X, $Y)
	Until DllStructGetData($GUY, "Id") <> 0
	CHANGETARGET($GUY)
	RNDSLEEP(250)
	GONPC($GUY)
	RNDSLEEP(250)
	Do
		RNDSLEEP(500)
		MOVETO(DllStructGetData($GUY, "X"), DllStructGetData($GUY, "Y"), 40)
		RNDSLEEP(500)
		GONPC($GUY)
		RNDSLEEP(250)
		$ME = GETAGENTBYID(-2)
	Until COMPUTEDISTANCE(DllStructGetData($ME, "X"), DllStructGetData($ME, "Y"), DllStructGetData($GUY, "X"), DllStructGetData($GUY, "Y")) < 250
	RNDSLEEP(1000)
EndFunc