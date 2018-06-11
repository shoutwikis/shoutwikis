#include-once
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <GuiEdit.au3>
#include <inet.au3>
#include "常数.au3"
#include "买卖.au3"
#include "../../激战接口.au3"


#region BotGlobals
Global $RunProf
Global $Firstrun = True
Global $SFID = 826
Global $Random = 0

Global $build = "OgEUQpaeV8SXF9F8E7g+GHH5iBAA"

Global $Kaineng = 194
Global $Kaineng2 = 817
Global $dunkoro = "Dunkoro"
Global $gwen = "Gwen"
Global $miku = "Miku"
Global $zhed = "Zhed Shadowhoof"

Global $nbFails = 0
Global $nbRuns = 0
Global $nbCitations = 0
Global $bRunning = False
Global $bInitialized = False
Global $bCanContinue = True

Global $RENDERING = True
Global $GWPID = -1

Global $skill_bar_justice=1
global $skill_bar_100b=2
Global $skill_bar_exLimite=3
Global $skill_bar_toubillon=4
global $skill_bar_stab=5
global $skill_bar_echap=6
Global $skill_bar_EBON=7
Global $skill_bar_sceau=8

#endregion BotGlobals


#region GUIGlobals
Global $GUITitle = "刷天狗召唤石"
Global $NewGUITitle
Global $boolrun = False
Global $WeakCounter = 0
Global $Sec = 0
Global $Min = 0
Global $Hour = 0
Global $Runs = 0
Global $GoodRuns = 0
Global $BadRuns = 0

Global $Option2 = False
Global $Option3 = False
#endregion GUIGlobals

#region GUI
Opt("GUIOnEventMode", 1)
$cGUI = GUICreate($GUITitle&" ", 436, 301, 191, 196)

$gMain = GUICtrlCreateGroup("", 0, 20, 201, 81)
$cCharname = GUICtrlCreateCombo("", 8, 40, 185, 25, BitOR($GUI_SS_DEFAULT_COMBO,$CBS_SIMPLE))
GuiCtrlSetData($cCharname,GetLoggedCharnames(),GetLoggedCharnames())
$bStart = GUICtrlCreateButton("开始", 8, 64, 89, 33)
$bStahp = GUICtrlCreateButton("停止", 104, 64, 89, 33)
GUICtrlSetState(-1,$GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$gOpt = GUICtrlCreateGroup("选择", 8, 112, 95, 113)
$Opt1 = GUICtrlCreateCheckbox("捡绿武", 16, 136, 75, 17)
GUICtrlSetState($Opt1, $GUI_UNCHECKED)
$Opt2 = GUICtrlCreateCheckbox("卖金器", 16, 160, 75, 17)
GUICtrlSetState($Opt2, $GUI_CHECKED)
$Opt3 = GUICtrlCreateCheckbox("不呈像", 16, 184, 80, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$lTime = GUICtrlCreateLabel("00:00:00", 16, 232, 175, 57, BitOR($SS_CENTER,$SS_CENTERIMAGE), $WS_EX_STATICEDGE)
GUICtrlSetFont(-1, 24, 800, 0, "MS Sans Serif")
$gStats = GUICtrlCreateGroup("统计", 105, 112, 90, 113)
$cRuns = GUICtrlCreateLabel("总数:", 128, 136, 42, 17)
$lRuns = GUICtrlCreateLabel("0", 168, 136, 18, 17)
$cWins = GUICtrlCreateLabel("成功:", 128, 168, 41, 17)
$lWins = GUICtrlCreateLabel("0", 168, 168, 26, 17)
$cFails = GUICtrlCreateLabel("奖章:", 128, 200, 45, 17)
$lFails = GUICtrlCreateLabel("0", 168, 200, 26, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$lAction = GUICtrlCreateEdit("", 209, 24, 225, 275, BitOR($GUI_SS_DEFAULT_EDIT,$ES_READONLY,$WS_BORDER))
GUICtrlSetData(-1, "")
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
GUICtrlSetBkColor(-1,0x000000)
GUICtrlSetColor(-1, 0x00FF00)
GUICtrlSetCursor (-1, 5)
$Label1 = GUICtrlCreateLabel("", 8, 0, 352, 19)
GUICtrlSetFont(-1, 12, 800, 0, "Comic Sans MS")
GUISetState(@SW_SHOW)

GUICtrlSetOnEvent($bStart, "GUIHandler")
GUICtrlSetOnEvent($bStahp, "GUIHandler")
;GUICtrlSetOnEvent($Opt1, "GUIHandler")
;GUICtrlSetOnEvent($Opt2, "GUIHandler")
GUICtrlSetOnEvent($Opt3, "GUIHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "GUIHandler")

GUISetState(@SW_SHOW)
#endregion GUI

Global $startingCount = 0

Func CountItemsInBag($idid)
	Local $countit = 0
	For $bag = 1 To 4
		$bag_slots = DllStructGetData(GetBag($bag), 'Slots')
		For $slot = 1 To $bag_slots
			$item = GetItemBySlot($bag, $slot)
			if DllStructGetData($item, "ModelID") = $idid then $countit += DllStructGetData($item, "Quantity")
		Next
	Next
	return $countit
EndFunc

#region GUIFuncs
Func GUIHandler()
	Switch (@GUI_CtrlId)
		Case $bStart
			Initialize(GUICtrlRead($cCharname), True, True, True)


			$startingCount = CountItemsInBag(36985)

			WinSetTitle($GUITitle, "", GetCharname() & " - " & $GUITitle)
			$boolrun = True
			GUICtrlSetState($bStahp, $GUI_ENABLE)
			GUICtrlSetState($bStart, $GUI_DISABLE)
			GUICtrlSetState($cCharname, $GUI_DISABLE)
			GUICtrlSetState($Opt3, $GUI_ENABLE)
			AdlibRegister("TimeUpdater", 1000)
		Case $bStahp
			Exit
		Case $Opt3
			If GUICtrlRead($Opt3) = $GUI_CHECKED Then
				RenderOff()
				$Option3 = True
			ElseIf GUICtrlRead($Opt3) = $GUI_UNCHECKED Then
				RenderOn()
				$Option3 = False
			EndIf
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
EndFunc   ;==>GUIHandler

Func Purge()
	upd("清除引擎勾")
	EnableRendering()
	Sleep(Random(2000, 2500))
	DisableRendering()
EndFunc   ;==>Purge

Func RenderOff()
	upd("不呈像")
	DisableRendering()
	WinSetState(GetWindowHandle(), "", @SW_HIDE)
EndFunc   ;==>RenderOff

Func RenderOn()
	upd("呈像")
	EnableRendering()
	WinSetState(GetWindowHandle(), "", @SW_SHOW)
EndFunc   ;==>RenderOn

Func GUIUpdate()
	$Runs += 1
	$GoodRuns += 1
	GUICtrlSetData($lRuns, $Runs)
	GUICtrlSetData($lWins, $GoodRuns)
EndFunc   ;==>GUIUpdate

Func TimeUpdater()
	$WeakCounter += 1

	$Sec += 1
	If $Sec = 60 Then
		$Min += 1
		$Sec = $Sec - 60
	EndIf

	If $Min = 60 Then
		$Hour += 1
		$Min = $Min - 60
	EndIf

	If $Sec < 10 Then
		$L_Sec = "0" & $Sec
	Else
		$L_Sec = $Sec
	EndIf

	If $Min < 10 Then
		$L_Min = "0" & $Min
	Else
		$L_Min = $Min
	EndIf

	If $Hour < 10 Then
		$L_Hour = "0" & $Hour
	Else
		$L_Hour = $Hour
	EndIf

	GUICtrlSetData($lTime, $L_Hour & ":" & $L_Min & ":" & $L_Sec)
EndFunc   ;==>TimeUpdater

Func Upd($AMSG)
	Local $LTEXTLEN = StringLen($AMSG)
	Local $LCONSOLELEN = _GUICtrlEdit_GetTextLen($lAction)
	If $LTEXTLEN + $LCONSOLELEN > 30000 Then GUICtrlSetData($lAction, StringRight(_GUICtrlEdit_GetText($lAction), 30000 - $LTEXTLEN - 1000))
	_GUICtrlEdit_AppendText($lAction, @CRLF & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " & $AMSG)
	_GUICtrlEdit_Scroll($lAction, 1)
EndFunc   ;==>Upd

#endregion GUIFuncs

While 1

	Sleep(250)

	If $boolrun Then
		If $Option3 = True Then Purge()

		If GetMapID() <> $Kaineng And GetMapID() <> $Kaineng2 Then
			TravelTo($Kaineng)
		EndIf

		$bCanContinue = True
		LoadSkillTemplate($build)

		If CountSlots() < 5 Then
			TravelTo(303)
			Inventory()
			TravelTo($Kaineng)
		EndIf

		DoJob()
		Local $newCount = CountItemsInBag(36985)

		GUICtrlSetData($lFails, $newCount - $startingCount)

		if $bCanContinue = true then
			GUIUpdate()
		else
			death()
		endif
	EndIf

WEnd


Func DoJob()
	GoToQuest()
	EnterQuest()
	PrepareToFight()
	Fight()
	If $bCanContinue Then
		GoToStairs()
	Else
		Upd("起点处失败")
	EndIf
	If $bCanContinue Then Survive()
	If $bCanContinue Then PickUpLoot()
	sleep(2000)
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
	Dialog(0x84)
	Sleep(500)
	WaitMapLoading()
EndFunc

Func PrepareToFight()
	Local $lDunko, $lGwen, $lMiku, $lZhed
	Local $lDeadLock

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
		If GetMapLoading() == 2 Then Disconnected()
	Until GetNumberOfFoesInRangeOfAgent(-2, 4250)<>0 Or TimerDiff($lDeadLock) > 60000

	Sleep(3000)

	UseSkillEx($skill_bar_EBON)
EndFunc

Func Fight()
	Local $lMiku, $lMob
	Local $lDeadLock, $lDeadLock2

	Do
		$lMiku=GetAgentByName($miku)

		HelpMiku($lMiku)

		If GetIsDead($lMiku) Then $bCanContinue = False
		If IsEveryoneDead() Then $bCanContinue = False
		If IsRecharged($skill_bar_stab) Then UseSkillEx($skill_bar_stab)
		If IsRecharged($skill_bar_sceau) Then UseSkillEx($skill_bar_sceau)

	Until GetNumberOfFoesInRangeOfAgent(-2, 4000) <= 5 Or $bCanContinue = False

	CancelAll()
	CancelHero(1)
	CancelHero(2)
	CancelHero(3)

	Do
		$lMob = GetNearestEnemyToAgent(-2)
		$lMiku=GetAgentByName($miku)
		Attack($lMob)
		HelpMiku($lMiku)
		Sleep(250)
		PickUpLoot()
		If GetMapLoading() == 2 Then Disconnected()
		If GetisDead($lMiku) Then $bCanContinue = False
		If IsEveryoneDead() Then $bCanContinue = False
	Until GetNumberOfFoesInRangeOfAgent(-2, 2000) = 0 Or $bCanContinue = False

	If $bCanContinue Then
		MoveTo(-5961, -5082)

		$lDeadLock2 = TimerInit()

		Do
			Sleep(50)
			If IsEveryoneDead() Then $bCanContinue = False
		Until GetNumberOfFoesInRangeOfAgent(-2, 3000) <= 20 Or TimerDiff($lDeadLock2) > 60000 or $bCanContinue = False
		Sleep(3000)
	EndIf
EndFunc

func IsEveryoneDead()
	Local $result = GetIsDead(-2)
	For $i = 1 To 7
		$result = $result and GetIsDead(GetHeroID($i))
	next
	return $result
EndFunc

Func HelpMiku($aMiku)
   If DllStructGetData($aMiku, 'HP')< 0.4 Then
	  UseHeroSkill(4,4 , $aMiku)
	  UseHeroSkill(2,1 , $aMiku)
	  UseHeroSkill(1, 2, $aMiku)
   EndIf
EndFunc

Func GoToStairs()
	CommandAll(-6707,-5242)

	MoveRunning(-4790, -3441)
	MoveRunning(-4608, -2120)
	MoveRunning(-4222, -1545)
	MoveRunning(-4664, -672)
	MoveRunning(-3825, 134)
	MoveRunning(-3067, 633)
	MoveRunning(-2663, 644)
	MoveRunning(-2214, -334)
	MoveRunning(-878, -1877)
	MoveRunning(-770, -3052)
	MoveRunning(-699, -3773)
	Move(-1090, -4210, 0)

	CommandHero(1,-5798,-5272)
EndFunc

Func MoveRunning($lDestX, $lDestY, $lRandom = 250)
	If GetMapLoading() == 2 Then Disconnected()
    if IsRecharged($skill_bar_echap) then useskillex($skill_bar_echap)
	MoveTo($lDestX, $lDestY)

EndFunc   ;==>MoveRunning

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
#cs
		If DllStructGetData($lMe, "HP") < 0.7 Then
			If IsRecharged($skill_bar_echap) Then UseSkillEx($skill_bar_echap)
		EndIf
#ce
		If IsRecharged($skill_bar_stab) Then UseSkillEx($skill_bar_stab)

		If IsRecharged($skill_bar_sceau) Then UseSkillEx($skill_bar_sceau)
		If GetMapLoading() == 2 Then Disconnected()
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
		Upd("终点失败")
	EndIf


	Sleep(3000)
EndFunc






Func ISUNDEREFFECTOF($ASKILL)
	Local $EFFECTSTRUCT = GETEFFECT($ASKILL)
	Return DllStructGetData($EFFECTSTRUCT, "SkillID") <> 0
EndFunc   ;==>ISUNDEREFFECTOF

Func EmptySlots()
	Local $lBag
	For $i = 1 To 3
		$lBag = GetBag($i)
		If DllStructGetData($lBag, 'Slots') - DllStructGetData($lBag, 'ItemsCount') > 0 Then Return True
	Next
	Return False
EndFunc   ;==>EmptySlots

Func GoOutside()
	upd("出城")
	SwitchMode(1)
	;Do
		Move(-11172, -23105)
		;RndSleep(1000)

	WaitMapLoading(195, 10000);Until
EndFunc   ;==>GoOutside


Func Leave()
	Sleep(Random(3000,5000))
	Resign()
	Sleep(Random(5000,6000))
	ReturnToOutpost()
	WaitForLoad()
EndFunc

Func WaitForLoad()               ;used
	upd("正在载入")
	InitMapLoad()
	Local $deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100
		Local $load = GetMapLoading()
		Local $lMe = GetAgentByID(-2)

	Until $load == 2 And DllStructGetData($lMe, 'X') == 0 And DllStructGetData($lMe, 'Y') == 0 Or $deadlock > 10000

	$deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100
		$load = GetMapLoading()
		$lMe = GetAgentByID(-2)

	Until $load <> 2 And DllStructGetData($lMe, 'X') <> 0 And DllStructGetData($lMe, 'Y') <> 0 Or $deadlock > 30000
	upd("装载完毕")
EndFunc   ;==>WaitForLoad

Func PickUpLoot()
	Local $lMe
	Local $lBlockedTimer
	Local $lBlockedCount = 0
	Local $lItemExists = True
	Local $Distance
	For $i = 1 To GetMaxAgents()
		If GetIsDead(-2) Then Return False
		$lAgent = GetAgentByID($i)
		If Not GetIsMovable($lAgent) Then ContinueLoop
		$lDistance = GetDistance($lAgent)
		If $lDistance > 2000 Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If CanPickUp($lItem) Then
			Upd("正在捡 " & GetAgentName($i))
			Do
				If GetMapLoading() == 2 Then Disconnected()
				If GetDistance($lAgent) > 150 Then Move(DllStructGetData($lAgent, 'X'), DllStructGetData($lAgent, 'Y'), 100)
				PickUpItem($lItem)
				Sleep(1000)
				Do
					Sleep(100)
					$lMe = GetAgentByID(-2)
				Until DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0
				$lBlockedTimer = TimerInit()
				Do
					Sleep(3)
					$lItemExists = IsDllStruct(GetAgentByID($i))
				Until Not $lItemExists Or TimerDiff($lBlockedTimer) > Random(500, 1000, 1)
				If $lItemExists Then $lBlockedCount += 1
			Until Not $lItemExists Or $lBlockedCount > 5
		EndIf
	Next
EndFunc   ;==>PickUpLoot

Func CanPickUp($aitem)
 	$m = DllStructGetData($aitem, 'ModelID')
	$r = GetRarity($aitem)
	If $r = $RARITY_GOLD Then
		Return True
	elseif $r = $RARITY_GREEN and (GUICtrlRead($Opt1) <> $GUI_CHECKED) then
		Return false
 	ElseIf $m = 146 Then ;Dyes
		$e = DllStructGetData($aitem, 'ExtraID')
 		If $e = 10 Or $e = 12 Or $e = 13 Then ; Black, White, Pink
 			Return True
		Else
		Return False
		EndIf
 	ElseIf $m = 22751 Then
 		Return True
	ElseIf $m = 36985 Then
		Return True ;ministry award or something
	ElseIf $m = 956 Then
 		Return True
 	ElseIf $m > 21785 And $m < 21806 Then ;Elite/Normal Tomes
		Return true
	ElseIf $m = 819 Or $m = 934 Then ; Roots/Fibers
		Return True
 	ElseIf $m = 22191 Or $m = 22190 Or $m = 20 Then
 		Return True
	ElseIf $m = 22752 Or $m = 22269 Or $m = 28436 Or $m = 31152 Or $m = 31151 Or $m = 31153 Or $m = 35121 Or $m = 28433 Or $m = 26784 Or $m = 6370 Or $m = 21488 Or $m = 21489 Or $m = 22191 Or $m = 24862 Or $m = 21492 Or $m = 22644 Or $m = 30855 Or $m = 5585 Or $m = 24593 Or $m = 6375 Or $m = 22190 Or $m = 6049 Or $m = 910 Or $m = 28435 Or $m = 6369 Or $m = 21809 Or $m = 21810 Or $m = 21813 Or $m = 6376 Or $m = 6368 Or $m = 29436 Or $m = 21491 Or $m = 28434 Or $m = 21812 Or $m = 35124 Then ; Consumables
		Return True
 	ElseIf BitAND(DllStructGetData($aitem, 'Interaction'), 16777216) OR BitAND(DllStructGetData($aitem, 'Interaction'), 131072) Then ;If it is usable, a.k.a, a consumable, or gold (BETA)
		Return True
	ElseIf $r = $RARITY_BLUE Then
		return false
	ElseIf $r = $RARITY_WHITE then
		return false
	ElseIf $r = $RARITY_PURPLE Then
		return false
	Else
		Return true
	EndIf
EndFunc   ;==>CanPickUp

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


Func Disconnected()
	Upd("断线")
	upd("重接")
	ControlSend(GetWindowHandle(), "", "", "{Enter}")
	Local $lCheck = False
	Local $lDeadLock = TimerInit()
	Do
		Sleep(20)
		$lCheck = GetMapLoading() <> 2 And GetAgentExists(-2)
	Until $lCheck Or TimerDiff($lDeadLock) > 60000
	If $lCheck = False Then
		upd("重接失败")
		upd("再重接")
		ControlSend(GetWindowHandle(), "", "", "{Enter}")
		$lDeadLock = TimerInit()
		Do
			Sleep(20)
			$lCheck = GetMapLoading() <> 2 And GetAgentExists(-2)
		Until $lCheck Or TimerDiff($lDeadLock) > 60000
		If $lCheck = False Then
			upd("无法重接")
			upd("退出")
;~ 			Exit 1
		EndIf
	EndIf
	upd("重新接上!")
	Sleep(5000)
EndFunc   ;==>Disconnected


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

Func Death()
	;$BadRuns += 1
	$Runs += 1
	GUICtrlSetData($lRuns, $Runs)
	;GUICtrlSetData($lFails, $BadRuns)
	;main()
EndFunc   ;==>Death