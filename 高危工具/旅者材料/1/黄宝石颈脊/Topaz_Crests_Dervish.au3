#Region About
;~		Based of COF Farmer from Carryboy Cyrano

#EndRegion About

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
#NoTrayIcon

#Region Constants
; === Maps ===
Global Const $MAP_ID_DOOMLORE = 118
Global Const $MAP_ID_COF = 110

; === Dialogs ===
Global Const $FIRST_DIALOG = 0x832105
Global Const $SECOND_DIALOG = 0x88

; === Build ===
Global Const $SkillBarTemplate = "OgCjkqqLrSihdftXYijhOXhX0kA"

; === Skills ===
Global Const $pious = 1
Global Const $grenths = 2
Global Const $vos = 3
Global Const $mystic = 4
Global Const $crippling = 5
Global Const $reap = 6
Global Const $vop = 7
Global Const $iau = 8

; === Skill Cost ===
Global Const $skillCost[9] = [0, 5, 10, 5, 0, 0, 0, 15, 5]

; === Materials and usefull Items ===
Global Const $ITEM_ID_BONES = 921
Global Const $ITEM_ID_DUST = 929
Global Const $ITEM_ID_DIESSA = 24353
Global Const $ITEM_ID_RIN = 24354
Global Const $ITEM_ID_LOCKPICKS = 22751
Global Const $ITEM_ID_DYES = 146
Global Const $ITEM_EXTRAID_BLACKDYE = 10
Global Const $ITEM_EXTRAID_WHITEDYE = 12

; === Pcons ===
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
#EndRegion Constants

#Region Declarations
Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Global Const $WEAPON_SLOT_SCYTHE = 1
Global Const $WEAPON_SLOT_STAFF = 2
Global $Runs = 0
Global $Fails = 0
Global $Drops = 0
Global $BotRunning = False
Global $BotInitialized = False
Global $TotalSeconds = 0
Global $Seconds = 0
Global $Minutes = 0
Global $Hours = 0
Global $MerchOpened = False
Global $HWND
#EndRegion Declarations

#Region GUI
$Gui = GUICreate("Topaz Crests Farmer", 299, 174, -1, -1)
$CharInput = GUICtrlCreateCombo("", 6, 6, 103, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
   GUICtrlSetData(-1, GetLoggedCharNames())
$StartButton = GUICtrlCreateButton("Start", 5, 146, 105, 23)
   GUICtrlSetOnEvent(-1, "GuiButtonHandler")
$RunsLabel = GUICtrlCreateLabel("Runs:", 6, 31, 31, 17)
$RunsCount = GUICtrlCreateLabel("0", 34, 31, 75, 17, $SS_RIGHT)
$FailsLabel = GUICtrlCreateLabel("Fails:", 6, 50, 31, 17)
$FailsCount = GUICtrlCreateLabel("0", 30, 50, 79, 17, $SS_RIGHT)
$DropsLabel = GUICtrlCreateLabel("Crests:", 6, 69, 76, 17)
$DropsCount = GUICtrlCreateLabel("0", 82, 69, 27, 17, $SS_RIGHT)
$AvgTimeLabel = GUICtrlCreateLabel("Average time:", 6, 88, 65, 17)
$AvgTimeCount = GUICtrlCreateLabel("-", 71, 88, 38, 17, $SS_RIGHT)
$TotTimeLabel = GUICtrlCreateLabel("Total time:", 6, 107, 49, 17)
$TotTimeCount = GUICtrlCreateLabel("-", 55, 107, 54, 17, $SS_RIGHT)
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
   Sleep(500)
WEnd

AdlibRegister("TimeUpdater", 1000)
Setup()
While 1
   If Not $BotRunning Then
	  AdlibUnRegister("TimeUpdater")
	  Out("Bot is paused.")
	  GUICtrlSetState($StartButton, $GUI_ENABLE)
	  GUICtrlSetData($StartButton, "Start")
	  GUICtrlSetOnEvent($StartButton, "GuiButtonHandler")
	  While Not $BotRunning
		 Sleep(500)
	  WEnd
	  AdlibRegister("TimeUpdater", 1000)
   EndIf
   MainLoop()
WEnd
#EndRegion Loops

#Region Functions
Func GuiButtonHandler()
   If $BotRunning Then
	  Out("Will pause after this run.")
	  GUICtrlSetData($StartButton, "force pause NOW")
	  GUICtrlSetOnEvent($StartButton, "Resign")
	  ;GUICtrlSetState($StartButton, $GUI_DISABLE)
	  $BotRunning = False
   ElseIf $BotInitialized Then
	  GUICtrlSetData($StartButton, "Pause")
	  $BotRunning = True
   Else
	  Out("Initializing...")
	  Local $CharName = GUICtrlRead($CharInput)
	  If $CharName == "" Then
		 If Initialize(ProcessExists("gw.exe"), True) = False Then
			   MsgBox(0, "Error", "Guild Wars is not running.")
			   Exit
		 EndIf
	  Else
		 If Initialize($CharName, True) = False Then
			   MsgBox(0, "Error", "Could not find a Guild Wars client with a character named '" & $CharName & "'")
			   Exit
		 EndIf
	  EndIf
	  $HWND = GetWindowHandle()
	  GUICtrlSetState($RenderingBox, $GUI_ENABLE)
	  GUICtrlSetState($CharInput, $GUI_DISABLE)
	  Local $charname = GetCharname()
	  GUICtrlSetData($CharInput, $charname, $charname)
	  GUICtrlSetData($StartButton, "Pause")
	  WinSetTitle($Gui, "", "Topaz Crests - " & $charname)
	  $BotRunning = True
	  $BotInitialized = True
	  SetMaxMemory()
   EndIf
EndFunc

Func Setup()
   If GetMapID() <> $MAP_ID_DOOMLORE Then
	  Out("Travelling to Elonas Reach.")
	  RndTravel($MAP_ID_DOOMLORE)
   EndIf
   Out("Loading skillbar.")
   LoadSkillTemplate("OgCjkqqLrSihdftXYijhOXhX0kA")
   LeaveGroup()
   SwitchMode(0)
   RndSleep(500)
   SetUpFastWay()
EndFunc

Func SetUpFastWay()
	Out("Setting up resign")
	Zone()
	Move(-7600, 3800)
	WaitMapLoading($MAP_ID_DOOMLORE)
	RndSleep(500)
	Return True
EndFunc

Func Zone()
	Move(17200,6700)
	WaitMapLoading($MAP_ID_COF)
endFunc	

Func MainLoop()
   If GetMapID() == $MAP_ID_DOOMLORE Then
	  Zone_Fast_Way()
   Else
	  Setup()
	  Zone_Fast_Way()
   EndIf
   Out("Enter Area.")
   ; Aggroing
   MoveTo(-4222, 5563)
   UseSkillEx($vop)
   UseSkillEx($grenths)
   UseSkillEx($vos)
   UseSkillEx($mystic)
   MoveTo(-3152, 5904)
   UseSkill($iau, -2)
   Out("Killing Sand Drakes.")
   Kill()
   If GetIsDead(-2) Then
	  $Fails += 1
	  Out("I'm dead.")
	  GUICtrlSetData($FailsCount,$Fails)
   Else
	  $Runs += 1
	  Out("Completed in " & GetTime() & ".")
	  GUICtrlSetData($RunsCount,$Runs)
	  GUICtrlSetData($AvgTimeCount,AvgTime())
   EndIf
   If GUICtrlRead($RenderingBox) == $GUI_CHECKED Then ClearMemory()
   Out("Returning to Elonas Reach")
   Resign()
   RndSleep(5000)
   ReturnToOutpost()
   WaitMapLoading($MAP_ID_DOOMLORE)
EndFunc

Func Zone_Fast_Way()
	Out("Zoning.")
	Move(17200,6700)	
	WaitMapLoading($MAP_ID_COF)
   Return True
EndFunc

Func Kill()
   If GetMapLoading() == 2 Then Disconnected()
   If GetIsDead(-2) Then Return
   CheckVos()
   While GetNumberOfFoesInRangeOfAgent(-2,800) > 0
	  If GetMapLoading() == 2 Then Disconnected()
	  If GetIsDead(-2) Then Return	  
	  If GetSkillbarSkillAdrenaline($crippling) >= 150 Then
		CheckVoS()
		TargetNearestEnemy()
		UseSkill($crippling, -1)
		RndSleep(800)
	  EndIf
	  If GetSkillbarSkillAdrenaline($reap) >= 120 Then 
		 CheckVoS()
		 TargetNearestEnemy()
		 UseSkill($reap, -1)
		 RndSleep(800)
	  EndIf
	  Sleep(100)
	  CheckVos()
	  TargetNearestEnemy()
	  Attack(-1)
   WEnd
   RndSleep(200)
   PickUpLoot()
EndFunc

Func CheckVoS()
	If IsRecharged($vos) Then
		UseSkillEx($pious)
		UseSkillEx($grenths)
		UseSkillEx($vos)
	EndIf
EndFunc

Func WaitForSettle($FarRange,$CloseRange,$Timeout = 10000)
   If GetMapLoading() == 2 Then Disconnected()
   Local $Target
   Local $Deadlock = TimerInit()
   Do
	  If GetMapLoading() == 2 Then Disconnected()
	  If GetIsDead(-2) Then Return
	  CheckVoS()
	  If DllStructGetData(GetAgentByID(-2), "HP") < 0.6 Then Return	; from 0.4 up to 0.6, less chance to die
	  Sleep(50)
	  $Target = GetFarthestEnemyToAgent(-2,$FarRange)
   Until GetNumberOfFoesInRangeOfAgent(-2,900) > 0 Or (TimerDiff($Deadlock) > $Timeout)
   Local $Deadlock = TimerInit()
   Do
	  If GetMapLoading() == 2 Then Disconnected()
	  If GetIsDead(-2) Then Return
	  CheckVoS()
	  If DllStructGetData(GetAgentByID(-2), "HP") < 0.6 Then Return
	  Sleep(50)
	  $Target = GetFarthestEnemyToAgent(-2,$FarRange)
   Until (GetDistance(-2, $Target) < $CloseRange) Or (TimerDiff($Deadlock) > $Timeout)
EndFunc

Func GetFarthestEnemyToAgent($aAgent = -2, $aDistance = 1250)
   If GetMapLoading() == 2 Then Disconnected()
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
   If GetMapLoading() == 2 Then Disconnected()
   Local $lAgent, $lDistance
   Local $lCount = 0, $lAgentArray = GetAgentArray(0xDB)
   If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)
   For $i = 1 To $lAgentArray[0]
	  $lAgent = $lAgentArray[$i]
	  If BitAND(DllStructGetData($lAgent, 'typemap'), 262144) Then
		If StringLeft(GetAgentName($lAgent), 7) <> "Murakai" Then ContinueLoop
	  EndIf
	  If DllStructGetData($lAgent, 'Allegiance') <> 3 Then ContinueLoop
	  If DllStructGetData($lAgent, 'HP') <= 0 Then ContinueLoop
	  If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) > 0 Then ContinueLoop
	  ;If StringLeft(GetAgentName($lAgent), 7) <> "Sensali" Then ContinueLoop
	  $lDistance = GetDistance($lAgent)
	  If $lDistance > $aRange Then ContinueLoop
	  $lCount += 1
   Next
   Return $lCount
EndFunc

Func GetItemCountByID($ID)
   If GetMapLoading() == 2 Then Disconnected()
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

Func PickUpLoot()
   If GetMapLoading() == 2 Then Disconnected()
   Local $lMe, $lAgent, $lItem
   Local $lBlockedTimer
   Local $lBlockedCount = 0
   Local $lItemExists = True
   For $i = 1 To GetMaxAgents()
	  If GetMapLoading() == 2 Then Disconnected()
	  $lMe = GetAgentByID(-2)
	  If DllStructGetData($lMe, 'HP') <= 0.0 Then Return
	  $lAgent = GetAgentByID($i)
	  If Not GetIsMovable($lAgent) Then ContinueLoop
	  If Not GetCanPickUp($lAgent) Then ContinueLoop
	  $lItem = GetItemByAgentID($i)
	  If CanPickUp($lItem) Then
		 Do
			If GetMapLoading() == 2 Then Disconnected()
			;If $lBlockedCount > 2 Then UseSkillEx(6,-2)
			PickUpItem($lItem)
			Sleep(GetPing())
			Do
			   Sleep(100)
			   $lMe = GetAgentByID(-2)
			Until DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0
			$lBlockedTimer = TimerInit()
			Do
			   Sleep(3)
			   $lItemExists = IsDllStruct(GetAgentByID($i))
			Until Not $lItemExists Or TimerDiff($lBlockedTimer) > Random(5000, 7500, 1)
			If $lItemExists Then $lBlockedCount += 1
		 Until Not $lItemExists Or $lBlockedCount > 5
	  EndIf
   Next
EndFunc

Func CanPickUp($lItem)
   If GetMapLoading() == 2 Then Disconnected()
   Local $Quantity
   Local $ModelID = DllStructGetData($lItem, 'ModelID')
   Local $ExtraID = DllStructGetData($lItem, 'ExtraID')
   Local $lType = DllStructGetData($lItem, 'Type')
   Local $lRarity = GetRarity($lItem)
   If $ModelID == 450 Then	; Topaz Crests
	  $Drops += DllStructGetData($lItem, 'Quantity')
	  GUICtrlSetData($DropsCount,$Drops)
	  Return True
   EndIf
   Return False
EndFunc

;Fix after update of 23.03.2018 - START
;~ Description: Use a skill and wait for it to be used.
Func UseSkillEx($lSkill, $lTgt = -2, $aTimeout = 3000)
    If GetIsDead(-2) Then Return
    If Not IsRecharged($lSkill) Then Return
    Local $Skill = GetSkillByID(GetSkillBarSkillID($lSkill, 0))
    Local $Energy = StringReplace(StringReplace(StringReplace(StringMid(DllStructGetData($Skill, 'Unknown4'), 6, 1), 'C', '25'), 'B', '15'), 'A', '10')
    If GetEnergy(-2) < $Energy Then Return
    Local $lAftercast = DllStructGetData($Skill, 'Aftercast')
    Local $lDeadlock = TimerInit()
    UseSkill($lSkill, $lTgt)
    Do
	    Sleep(50)
	    If GetIsDead(-2) = 1 Then Return
	    Until (Not IsRecharged($lSkill)) Or (TimerDiff($lDeadlock) > $aTimeout)
    Sleep($lAftercast * 1000)
EndFunc   ;==>UseSkillEx

;~ Description: Returns is a skill is recharged.
Func IsRecharged($lSkill)
    Return GetSkillBarSkillRecharge($lSkill) == 0
EndFunc   ;==>IsRecharged

;Fix after update of 23.03.2018 - END

Func SalvageStuff()
   If GetMapLoading() == 2 Then Disconnected()
   $MerchOpened = False
   Local $Item
   Local $Quantity
   For $Bag = 1 To 4
	  If GetMapLoading() == 2 Then Disconnected()
	  For $Slot = 1 To DllStructGetData(GetBag($Bag), 'Slots')
		 If GetMapLoading() == 2 Then Disconnected()
		 $Item = GetItemBySlot($Bag, $Slot)
		 If CanSalvage($Item) Then
			$Quantity = DllStructGetData($Item, 'Quantity')
			For $i = 1 To $Quantity
			   If GetMapLoading() == 2 Then Disconnected()
			   If FindCheapSalvageKit() = 0 Then BuySalvageKit()
			   StartSalvage1($Item, True)
			   Do
				  Sleep(10)
			   Until DllStructGetData(GetItemBySlot($Bag, $Slot), 'Quantity') = $Quantity - $i
			   $Item = GetItemBySlot($Bag, $Slot)
			Next
		 EndIf
	  Next
   Next
EndFunc


Func RndTravel($aMapID)
   If GetMapLoading() == 2 Then Disconnected()
#cs   Local $UseDistricts = 11 ; 7=eu-only, 8=eu+int, 11=all(excluding America)
   ; Region/Language order: eu-en, eu-fr, eu-ge, eu-it, eu-sp, eu-po, eu-ru, us-en, int, asia-ko, asia-ch, asia-ja
;~    Local $Region[11] = [2, 2, 2, 2, 2, 2, 2, -2, 1, 3, 4]
;~    Local $Language[11] = [0, 2, 3, 4, 5, 9, 10, 0, 0, 0, 0]
   Local $Region[11] = [0, -2, 1, 3, 4]
   Local $Language[11] = [0, 0, 0, 0, 0]
#ce   Local $Random = Random(0, $UseDistricts - 1, 1)
;   MoveMap($aMapID, $Region[$Random], 0, $Language[$Random])
   TravelTo($aMapID)
;   WaitMapLoading($aMapID)
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

Func ToggleRendering()
   If GUICtrlRead($RenderingBox) == $GUI_UNCHECKED Then
	  EnableRendering()
	  WinSetState($HWND, "", @SW_SHOW)
   Else
	  DisableRendering()
	  WinSetState($HWND, "", @SW_HIDE)
   EndIf
   Return True
EndFunc

Func Out($msg)
   GUICtrlSetData($StatusLabel, GUICtrlRead($StatusLabel) & "[" & @HOUR & ":" & @MIN & "]" & " " & $msg & @CRLF)
   _GUICtrlEdit_Scroll($StatusLabel, $SB_SCROLLCARET)
   _GUICtrlEdit_Scroll($StatusLabel, $SB_LINEUP)
EndFunc

Func _exit()
   If GUICtrlRead($RenderingBox) == $GUI_CHECKED Then
	  EnableRendering()
	  WinSetState($HWND, "", @SW_SHOW)
	  Sleep(500)
   EndIf
   Exit
EndFunc
#EndRegion Functions