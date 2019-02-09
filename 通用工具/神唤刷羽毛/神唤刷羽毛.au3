#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ScrollBarsConstants.au3>
#include <Misc.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
#include <Array.au3>
#include "../../激战接口.au3"
#NoTrayIcon

#Region Declarations
Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Global Const $RARITY_GOLD = 2624
Global Const $RARITY_PURPLE = 2626
Global Const $RARITY_BLUE = 2623
Global Const $RARITY_WHITE = 2621

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
Global $Rendering = True
Global $firstTime = True
#EndRegion Declarations

#Region GUI
$Gui = GUICreate("刷羽毛", 299, 174, -1, -1)
$CharInput = GUICtrlCreateCombo("", 6, 6, 103, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
   GUICtrlSetData(-1, GetLoggedCharNames())
$StartButton = GUICtrlCreateButton("开始", 5, 146, 105, 23)
   GUICtrlSetOnEvent(-1, "GuiButtonHandler")
$RunsLabel = GUICtrlCreateLabel("总圈数:", 6, 31, 31, 17)
$RunsCount = GUICtrlCreateLabel("0", 34, 31, 75, 17, $SS_RIGHT)
$FailsLabel = GUICtrlCreateLabel("失败:", 6, 50, 31, 17)
$FailsCount = GUICtrlCreateLabel("0", 30, 50, 79, 17, $SS_RIGHT)
$DropsLabel = GUICtrlCreateLabel("羽毛冠:", 6, 69, 76, 17)
$DropsCount = GUICtrlCreateLabel("0", 82, 69, 27, 17, $SS_RIGHT)
$AvgTimeLabel = GUICtrlCreateLabel("均耗时:", 6, 88, 65, 17)
$AvgTimeCount = GUICtrlCreateLabel("-", 71, 88, 38, 17, $SS_RIGHT)
$TotTimeLabel = GUICtrlCreateLabel("总耗时:", 6, 107, 49, 17)
$TotTimeCount = GUICtrlCreateLabel("-", 55, 107, 54, 17, $SS_RIGHT)
$StatusLabel = GUICtrlCreateEdit("", 115, 6, 178, 162, 2097220)
$RenderingBox = GUICtrlCreateCheckbox("停止成像", 6, 124, 103, 17)
   GUICtrlSetOnEvent(-1, "ToggleRendering")
   GUICtrlSetState($RenderingBox, $GUI_DISABLE)
GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
GUISetState(@SW_SHOW)
#EndRegion GUI

#Region Loops
Out("准备就绪")
While Not $BotRunning
   Sleep(100)
WEnd

AdlibRegister("TimeUpdater", 1000)
Setup()
While 1
   If Not $BotRunning Then
	  AdlibUnRegister("TimeUpdater")
	  Out("已暂停")
	  GUICtrlSetState($StartButton, $GUI_ENABLE)
	  GUICtrlSetData($StartButton, "开始")
	  While Not $BotRunning
		 Sleep(500)
	  WEnd
	  AdlibRegister("TimeUpdater", 1000)
	  $firstTime = True
   EndIf
   MainLoop()
WEnd
#EndRegion Loops

#Region Functions
Func GuiButtonHandler()
   If $BotRunning Then
	  Out("此圈后暂停")
	  GUICtrlSetState($StartButton, $GUI_DISABLE)
	  $BotRunning = False
   ElseIf $BotInitialized Then
	  GUICtrlSetData($StartButton, "暂停")
	  $BotRunning = True
   Else
	  Out("正在启动...")
	  Local $CharName = GUICtrlRead($CharInput)
	  ;If $CharName == "" Then
		 If Initialize("") = False Then
			   MsgBox(0, "错误", "激战未开")
			   Exit
		   EndIf
		   #cs
	  Else
		 If Initialize("", True, True) = False Then
			   MsgBox(0, "错误", "角色失寻: '" & $CharName & "'")
			   Exit
		 EndIf
	  EndIf
	  #ce
	  GUICtrlSetState($RenderingBox, $GUI_ENABLE)
	  GUICtrlSetState($CharInput, $GUI_DISABLE)
	  GUICtrlSetData($StartButton, "暂停")
	  $BotRunning = True
	  $BotInitialized = True
	  SetMaxMemory()
   EndIf
EndFunc

Func Setup()
   If GetMapID() <> 250 Then
	  Out("前往青函港")
	  RndTravel(250)
   EndIf

   LeaveGroup()
   Out("装载技能表")
   LoadSkillTemplate("OgejkirMrOm3vt2t5OB/uEY2LA")

   SwitchMode(0)
   ChangeWeaponSet(2)
   RndSleep(500)
EndFunc

Func MainLoop()
   If GetMapID() <> 250 Then RndTravel(250)
   Out("换图")
   ChangeWeaponSet(2)
   Zone()
   Out("走向圣沙利")
   MoveRun(7588, -10609)
   MoveRun(3821, -8984)
   MoveRun(2681, -8922)
   MoveRun(1540, -5995)
   MoveRun(-472, -4342)
   Out("杀圣沙利")
   MoveKill(-1536, -1686)
   MoveKill(586, -76)
   MoveKill(-1556, 2786)
   MoveKill(-2229, -815)
   MoveKill(-5247, -3290)
   MoveKill(-6994, -2273)
   MoveKill(-5042, -6638)
   MoveKill(-11040, -8577)
   MoveKill(-10232, -3820)
   If GetIsDead(-2) Then
	  $Fails += 1
	  Out("角色已死")
	  GUICtrlSetData($FailsCount,$Fails)
   Else
	  $Runs += 1
	  Out("耗时: " & GetTime() & ".")
	  GUICtrlSetData($RunsCount,$Runs)
	  GUICtrlSetData($AvgTimeCount,AvgTime())
   EndIf
   PurgeEngineHook()
   Out("回青函港")

   ;RndTravel(250)
      ;If GetItemCountByID(835) >= 50 Then
	  ;Out("Salvaging crests.")
	  ;SalvageStuff()
	GUICtrlSetData($DropsCount,GetItemCountByID(835));  GUICtrlSetData($DropsCount,GetItemCountByID(933))
      ;EndIf

	leave()
EndFunc

Func Leave()
	Sleep(Random(3000,5000))
	Resign()
	Sleep(Random(5000,6000))
	ReturnToOutpost()
	;TravelTo($MAP_ID_Rata)
	WaitMapLoading(250)
EndFunc

Func Zone()
   If GetMapLoading() == 2 Then Disconnected()
   Local $Me = GetAgentByID(-2)
   Local $X = DllStructGetData($Me, 'X')
   Local $Y = DllStructGetData($Me, 'Y')

	;CheckRealPlayerIsInOutPost()

   if $firstTime then

	   If ComputeDistance($X, $Y, 18383, 11202) < 750 Then
		  MoveTo(18127, 11740)
		  MoveTo(18987, 13500)
		  MoveTo(17288, 17243)
		  Move(16800, 17550)
		  WaitMapLoading(196)


	   elseIf ComputeDistance($X, $Y, 18786, 9415) < 750 Then
		  MoveTo(20556, 11582)
		  MoveTo(18987, 13500)
		  MoveTo(17288, 17243)
		  Move(16800, 17550)
		  WaitMapLoading(196)

	   elseIf ComputeDistance($X, $Y, 16669, 11862) < 750 Then
		  MoveTo(17912, 13531)
		  MoveTo(18987, 13500)
		  MoveTo(17288, 17243)
		  Move(16800, 17550)
		  WaitMapLoading(196)
	   elseif ComputeDistance($X, $Y, 16800, 17550) < 750 Then
		   Move(16800, 17550)
		   WaitMapLoading(196)
	   else
		   MoveTo(18987, 13500)
		   MoveTo(17288, 17243)
		   Move(16800, 17550)
		   WaitMapLoading(196)
	   EndIf

	   out("回城: 以固定起点")
		Do
			Move(10800, -13300)
		Until WaitMapLoading(250)
		;RndSleep(1000)
		Do
			Move(16800, 17550)
		Until WaitMapLoading(196)
		;$reZone = 0
		$firstTime = False
   Else
	   Move(16800, 17550)
	   WaitMapLoading(196)

   endif


EndFunc

Func MoveRun($DestX, $DestY)
   If GetMapLoading() == 2 Then Disconnected()
   If GetIsDead(-2) Then Return
   Local $Me
   Move($DestX, $DestY)
   Do
	  If GetMapLoading() == 2 Then Disconnected()
	  If IsRecharged(5) Then UseSkillEx(5)
	  $Me = GetAgentByID(-2)
	  If DllStructGetData($Me, "HP") < 0.95 Then
		 If GetEffectTimeRemaining(1516) <= 0 Then UseSkillEx(8)
	  EndIf
	  If GetIsDead(-2) Then Return
	  If DllStructGetData($Me, 'MoveX') == 0 Or DllStructGetData($Me, 'MoveY') == 0 Then Move($DestX, $DestY)
	  RndSleep(250)
   Until ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), $DestX, $DestY) < 250
EndFunc

Func MoveKill($DestX, $DestY)
   If GetMapLoading() == 2 Then Disconnected()
   If GetIsDead(-2) Then Return
   Local $Me, $Angle
   Local $Blocked = 0
   Move($DestX, $DestY)
   Do
	  If GetMapLoading() == 2 Then Disconnected()
	  If IsRecharged(5) Then UseSkillEx(5)
	  If DllStructGetData($Me, "HP") < 0.95 Then
		 If GetEffectTimeRemaining(1516) <= 0 Then UseSkillEx(8)
		 If GetEffectTimeRemaining(1540) <= 0 Then UseSkillEx(7)
	  EndIf
	  TargetNearestEnemy()
	  $Me = GetAgentByID(-2)
	  If GetIsDead(-2) Then Return
	  If GetNumberOfFoesInRangeOfAgent(-2,900) > 1 Then Kill()
	  If DllStructGetData($Me, 'MoveX') == 0 Or DllStructGetData($Me, 'MoveY') == 0 Then
		 $Blocked += 1
		 If $Blocked <= 5 Then
			Move($DestX, $DestY)
		 Else
			$Me = GetAgentByID(-2)
			$Angle += 40
			Move(DllStructGetData($Me, 'X')+300*sin($Angle), DllStructGetData($Me, 'Y')+300*cos($Angle))
			Sleep(2000)
			Move($DestX, $DestY)
		 EndIf
	  EndIF
	  RndSleep(250)
   Until ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), $DestX, $DestY) < 250
EndFunc

Func Kill()
   If GetMapLoading() == 2 Then Disconnected()
   If GetIsDead(-2) Then Return
   If GetEffectTimeRemaining(1516) <= 0 Then UseSkillEx(8,-2)
   If GetEffectTimeRemaining(1540) <= 0 Then UseSkillEx(7,-2)
   If GetEffectTimeRemaining(1510) <= 0 Then UseSkillEx(1,-2)
   TargetNearestEnemy()
   WaitForSettle(800, 210)
   ChangeWeaponSet(1)
   If IsRecharged(2) Then UseSkillEx(2,-2)
   If GetEnergy(-2) >= 10 Then
	  UseSkillEx(3,-2)
	  UseSkillEx(4,-1)
   EndIf
   While GetNumberOfFoesInRangeOfAgent(-2,900) > 0
	  If GetMapLoading() == 2 Then Disconnected()
	  If GetIsDead(-2) Then Return
	  TargetNearestEnemy()
	  If GetEffectTimeRemaining(1516) <= 0 Then UseSkillEx(8,-2)
	  If GetEffectTimeRemaining(1540) <= 0 Then UseSkillEx(7,-2)
	  If GetEffectTimeRemaining(1510) <= 0 And GetNumberOfFoesInRangeOfAgent(-2,300) > 1 Then UseSkillEx(1,-2)
	  If GetEffectTimeRemaining(1759) <= 0 Then UseSkillEx(2,-2)
	  Sleep(100)
	  Attack(-1)
   WEnd
   RndSleep(200)
   PickUpLoot()
   ChangeWeaponSet(2)
EndFunc

Func WaitForSettle($FarRange,$CloseRange,$Timeout = 10000)
   If GetMapLoading() == 2 Then Disconnected()
   Local $Target
   Local $Deadlock = TimerInit()
   Do
	  If GetMapLoading() == 2 Then Disconnected()
	  If GetIsDead(-2) Then Return
	  If DllStructGetData(GetAgentByID(-2), "HP") < 0.4 Then Return
	  If GetEffectTimeRemaining(1516) <= 0 Then UseSkillEx(8,-2)
	  If GetEffectTimeRemaining(1540) <= 0 Then UseSkillEx(7,-2)
	  If GetEffectTimeRemaining(1510) <= 0 Then UseSkillEx(1,-2)
	  Sleep(50)
	  $Target = GetFarthestEnemyToAgent(-2,$FarRange)
   Until GetNumberOfFoesInRangeOfAgent(-2,900) > 0 Or (TimerDiff($Deadlock) > $Timeout)
   Local $Deadlock = TimerInit()
   Do
	  If GetMapLoading() == 2 Then Disconnected()
	  If GetIsDead(-2) Then Return
	  If DllStructGetData(GetAgentByID(-2), "HP") < 0.4 Then Return
	  If GetEffectTimeRemaining(1516) <= 0 Then UseSkillEx(8,-2)
	  If GetEffectTimeRemaining(1540) <= 0 Then UseSkillEx(7,-2)
	  If GetEffectTimeRemaining(1510) <= 0 Then UseSkillEx(1,-2)
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
	  If BitAND(DllStructGetData($lAgent, 'typemap'), 262144) Then ContinueLoop
	  If DllStructGetData($lAgent, 'Allegiance') <> 3 Then ContinueLoop
	  If DllStructGetData($lAgent, 'HP') <= 0 Then ContinueLoop
	  If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) > 0 Then ContinueLoop
	  ;msgbox(0,"test",StringInStr(GetAgentName($lAgent), "聖沙利") == 0)
	  If StringLeft(GetAgentName($lAgent), 7) <> "Sensali" and StringInStr(GetAgentName($lAgent), "聖沙利") == 0 Then ContinueLoop
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
   Local $lMe
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
			If $lBlockedCount > 2 Then UseSkillEx(6,-2)
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
   If $ModelID = 146 And ($ExtraID = 10 Or $ExtraID = 12) Then Return True
   If $ModelID = 933 Then
	  $Drops += DllStructGetData($lItem, 'Quantity')
	  ;GUICtrlSetData($DropsCount,$Drops)
	  Return True
   EndIf
   If $ModelID = 835 Then Return True
   if $ModelID = 22752 then return true
   If $ModelID = 921 Then Return True
   if retainThis($lItem) then return true
   Return False
EndFunc

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

Func StartSalvage1($aItem, $aCheap = false)
   If GetMapLoading() == 2 Then Disconnected()
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
   If DllStructGetData($Item, 'ModelID') == 835 Then Return True
   Return False
EndFunc

Func FindCheapSalvageKit()
   If GetMapLoading() == 2 Then Disconnected()
   Local $Item
   Local $Kit = 0
   Local $Uses = 101
   For $Bag = 1 To 21
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

Func BuySalvageKit()
   WithdrawGold(100)
   GoToMerch()
   RndSleep(500)
   BuyItem(2, 1, 100)
   Sleep(1500)
   If FindCheapSalvageKit() = 0 Then BuySalvageKit()
EndFunc

Func GoToMerch()
   If GetMapLoading() == 2 Then Disconnected()
   If $MerchOpened = False Then
	  Local $Me = GetAgentByID(-2)
	  Local $X = DllStructGetData($Me, 'X')
	  Local $Y = DllStructGetData($Me, 'Y')
	  If ComputeDistance($X, $Y, 18383, 11202) < 750 Then
		 MoveTo(17715, 11773)
		 MoveTo(17174, 12403)
	  EndIf
	  If ComputeDistance($X, $Y, 18786, 9415) < 750 Then
		 MoveTo(17684, 10568)
		 MoveTo(17174, 12403)
	  EndIf
	  If ComputeDistance($X, $Y, 16669, 11862) < 750 Then
		 MoveTo(17174, 12403)
	  EndIf
	  TargetNearestAlly()
	  ActionInteract()
	  $MerchOpened = True
   EndIf
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

Func Out($msg)
   GUICtrlSetData($StatusLabel, GUICtrlRead($StatusLabel) & "[" & @HOUR & ":" & @MIN & "]" & " " & $msg & @CRLF)
   _GUICtrlEdit_Scroll($StatusLabel, $SB_SCROLLCARET)
   _GUICtrlEdit_Scroll($StatusLabel, $SB_LINEUP)
EndFunc

Func _exit()
   Exit
EndFunc

;~ Description: Toggle rendering and also hide or show the gw window
Func ToggleRendering()
	$Rendering = Not $Rendering
	If $Rendering Then
		EnableRendering()
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
	Else
		DisableRendering()
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
		ClearMemory()
	EndIf
EndFunc   ;==>ToggleRendering

Func PurgeEngineHook()
   If $Rendering = False Then
	  EnableRendering()
	  Sleep(Random(2000, 2500))
	  DisableRendering()
	  ClearMemory()
   EndIf
EndFunc
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
Func IsRecharged($lSkill)
    Return GetSkillBarSkillRecharge($lSkill) == 0
EndFunc   ;==>IsRecharged


Func CheckRealPlayerIsInOutPost()
	Local $Player_Name = true
	$Player_Name = Check_Is_Other_Player_Here()
	Local $rezoneCounter = 0
	while (NOT $Player_Name)
		SoundSetWaveVolume(100)
		Soundplay("铃响.mp3")
		out("因有人而换区")
		$firstTime=True ;THIS VARIABLE IS DECLARED INDEPENDENT OF THIS FILE, MAY NOT BE SIMPLY COPIED TO OTHER PROJECTS

		if $rezoneCounter > 10 Then
			out("上十区皆有人，暂停十五分钟")
			RndSleep(60000*random(15,20))
			$rezoneCounter = 0
		endif
		RndSleep(3500)
		DistrictChange()
		If (GetMapLoading() == 2) Then Disconnected()
		$Player_Name = Check_Is_Other_Player_Here()
		$rezoneCounter = $rezoneCounter+1
	WEnd
EndFunc   ;==>CheckRealPlayerIsInOutPost
Func Check_Is_Other_Player_Here()
	Local $how_many_Agents, $lAgentArray, $n = 0, $Myname, $AgentPlayerNummber, $aAgent, $LAGENT, $modelID_Me, $lAgentArray, $lMe_ = -2
	$lAgentArray = GetAgentArray(0xDB)
	For $i = 0 To (UBound($lAgentArray) -1)
		If (DllStructGetData($lAgentArray[$i], 'Allegiance') == 1) Then
			$LAGENT = GetAgentByID($lMe_)
			$modelID_Me = DllStructGetData($LAGENT, 'PlayerNumber')
			$AgentPlayerNummber = DllStructGetData($lAgentArray[$i], "PlayerNumber")
			If ($AgentPlayerNummber == $modelID_Me) Then ContinueLoop
			If (($AgentPlayerNummber> 0) And ($AgentPlayerNummber < 100)And($AgentPlayerNummber<> $modelID_Me)) and GetDistance($lAgentArray[$i])<4900 Then
				$aAgent = GetPlayerName($lAgentArray[$i])
				$n =+1
;				Upd1($aAgent)
			EndIf
		EndIf
	Next
	If ($n > 0) Then
		;Upd("Fuck the Police!")
		Return False
	EndIf
	Return True
EndFunc   ;==>Check_Is_Other_Player_Here
Func DistrictChange($AZONEID = 0, $AUSEDISTRICTS = 4)
	Local $REGION[4] = [-2, 1, 3, 4]
	Local $LANGUAGE[4] = [0, 0, 0, 0]
	Local $random, $OLD_REGION, $OLD_LANGUAGE
	If $AZONEID = 0 Then $AZONEID = GetMapID()
	$OLD_REGION = GetRegion()
	$OLD_LANGUAGE = GetLanguage()
	Do
		$random = Random(0, $AUSEDISTRICTS - 1, 1)
	Until $REGION[$random] <> $OLD_REGION
	$REGION = $REGION[$random]
	$LANGUAGE = $LANGUAGE[$random]
	MoveMap($AZONEID, $REGION, 0, $LANGUAGE)
	Return WaitMapLoading($AZONEID)
EndFunc   ;==>DISTRICTCHANGE
#EndRegion Functions