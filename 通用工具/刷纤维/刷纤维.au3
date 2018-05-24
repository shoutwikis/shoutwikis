#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.8.0
	GWA2 version: 3.6.9 Modified
	Author:         4D 1

	Script Function:
	Farm Dyes and shiot/.aefd

#ce ----------------------------------------------------------------------------
Global $version = "4.4"
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

Global $mSelf
Global $mSelfID
Global $mLowestAlly
Global $mLowestAllyHP
Global $mLowestOtherAlly
Global $mLowestOtherAllyHP
Global $mLowestEnemy
Global $mLowestEnemyHP
Global $mClosestEnemy
Global $mClosestEnemyDist
Global $mAverageTeamHP
Global $mAverageTeamEnergy

Global $mTeam[1] ;Array of living members
Global $mTeamOthers[1] ;Array of living members other than self
Global $mTeamDead[1] ;Array of dead teammates
Global $mEnemies[1] ;Array of living enemy team
Global $mEnemiesRange[1] ;Array of living enemy team in range of waypoint
Global $mEnemiesSpellRange[1] ;Array of living enemy team in spell range
Global $mSpirits[1] ;Array of your spirits
Global $mPets[1] ;Array of your/your hero's pets
Global $mMinions[1] ;Array of your minions
Global Const $BoneHorrorID = 2198

Global $mEffects
Global $mSkillbar
Global $mEnergy

#endregion BotGlobals


#region GUIGlobals
Global $GUITitle = "刷纤维(龙根)"
Global $NewGUITitle
Global $boolrun = False
Global $WeakCounter = 0
Global $Sec = 0
Global $Min = 0
Global $Hour = 0
Global $Runs = 0
Global $GoodRuns = 0
Global $BadRuns = 0
Global $Option1 = False
Global $Option2 = False
Global $Option3 = False
#endregion GUIGlobals

#region GUI
Opt("GUIOnEventMode", 1)
$cGUI = GUICreate($GUITitle&" ", 436, 301, 191, 196)

$gMain = GUICtrlCreateGroup("", 0, 20, 201, 81)
$cCharname = GUICtrlCreateCombo("", 8, 40, 185, 25, BitOR($GUI_SS_DEFAULT_COMBO,$CBS_SIMPLE))
GuiCtrlSetData($cCharname,GetLoggedCharnames(),GetLoggedCharnames()) ;last term was GetFirstUnhookedLoggedCharname()
$bStart = GUICtrlCreateButton("开始", 8, 64, 89, 33)
$bStahp = GUICtrlCreateButton("停止", 104, 64, 89, 33)
GUICtrlSetState(-1,$GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$gOpt = GUICtrlCreateGroup("选择", 8, 112, 95, 113)
$Opt1 = GUICtrlCreateCheckbox("全捡起", 16, 136, 75, 17)
$Opt2 = GUICtrlCreateCheckbox("卖金器", 16, 160, 75, 17)
$Opt3 = GUICtrlCreateCheckbox("背景运行", 16, 184, 80, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$lTime = GUICtrlCreateLabel("00:00:00", 16, 232, 175, 57, BitOR($SS_CENTER,$SS_CENTERIMAGE), $WS_EX_STATICEDGE)
GUICtrlSetFont(-1, 24, 800, 0, "MS Sans Serif")
$gStats = GUICtrlCreateGroup("统计", 105, 112, 90, 113)
$cRuns = GUICtrlCreateLabel("总数:", 128, 136, 42, 17)
$lRuns = GUICtrlCreateLabel("0", 168, 136, 18, 17)
$cWins = GUICtrlCreateLabel("成功:", 128, 168, 41, 17)
$lWins = GUICtrlCreateLabel("0", 168, 168, 26, 17)
$cFails = GUICtrlCreateLabel("失败:", 128, 200, 45, 17)
$lFails = GUICtrlCreateLabel("0", 168, 200, 10, 17)
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
GUICtrlSetOnEvent($Opt1, "GUIHandler")
GUICtrlSetOnEvent($Opt2, "GUIHandler")
GUICtrlSetOnEvent($Opt3, "GUIHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "GUIHandler")



GUISetState(@SW_SHOW)
#endregion GUI

#region GUIFuncs
Func GUIHandler()
	Switch (@GUI_CtrlId)
		Case $bStart
			Initialize(GUICtrlRead($cCharname), True, True, True)
			WinSetTitle($GUITitle, "", GetCharname() & " - " & $GUITitle)
			$boolrun = True
			GUICtrlSetState($bStahp, $GUI_ENABLE)
			GUICtrlSetState($bStart, $GUI_DISABLE)
			GUICtrlSetState($cCharname, $GUI_DISABLE)
			GUICtrlSetState($Opt3, $GUI_ENABLE)
			AdlibRegister("TimeUpdater", 1000)
			;AdLibRegister("DeathCheck",1000)
		Case $bStahp
			Exit;added to quit the whole thing
			$boolrun = False
			$Firstrun = True
			GUICtrlSetState($bStahp, $GUI_DISABLE)
			GUICtrlSetState($bStart, $GUI_ENABLE)
			AdlibUnRegister("TimeUpdater")
			;AdLibUnRegister("DeathCheck")
			;Reset()
		Case $Opt1
			If GUICtrlRead($Opt1) = $GUI_CHECKED Then
				$Option1 = True
			ElseIf GUICtrlRead($Opt1) = $GUI_UNCHECKED Then
				$Option1 = False
			EndIf
		Case $Opt2
			If GUICtrlRead($Opt2) = $GUI_CHECKED Then
				$Option2 = True
			ElseIf GUICtrlRead($Opt2) = $GUI_UNCHECKED Then
				$Option2 = False
			EndIf
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
	upd("激战运行于背景")
	DisableRendering()
	WinSetState(GetWindowHandle(), "", @SW_HIDE)
EndFunc   ;==>RenderOff

Func RenderOn()
	upd("停止背景运行")
	EnableRendering()
	WinSetState(GetWindowHandle(), "", @SW_SHOW)
EndFunc   ;==>RenderOn

Func Reset()
	$WeakCounter = 0
	$Sec = 0
	$Min = 0
	$Hour = 0
	$Runs = 0
	$GoodRuns = 0
	$BadRuns = 0
	GUICtrlSetData($lTime, "00:00:00")
	GUICtrlSetData($lRuns, "0")
	GUICtrlSetData($lWins, "0")
	GUICtrlSetData($lFails, "0")
EndFunc   ;==>Reset

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
#cs
Func GetLoggedCharnames()
	Local $lWinList = ProcessList("gw.exe")
	Local $CharName[1]
	Local $CharacterName
	Local $Returns[2]

	If $lWinList[0][0] = 0 Then
		$lWinList = ProcessList("gw mc.exe")
		If $lWinList[0][0] = 0 Then
			MsgBox(16, "启动", "激战未打开")
			Exit
		EndIf
	EndIf

	For $i = 1 To $lWinList[0][0]
		MemoryOpen($lWinList[$i][1])
		If $mGWProcHandle Then
			$CharacterName = ScanForCharname2()
			If IsString($CharacterName) Then
				ReDim $CharName[UBound($CharName) + 1]
				$CharName[$i] = $CharacterName
			EndIf
		EndIf
		$mGWProcHandle = 0
	Next


 Return _ArrayToString($CharName, "|")

EndFunc   ;==>InitSetCharnames
#ce

Func GetUnhookedLoggedCharnames()
	Local $lWinList = ProcessList("gw.exe")
	Local $CharName[1]
	Local $CharacterName
	Local $Returns[2]
	Local $timer = 0

	If $lWinList[0][0] = 0 Then
		$lWinList = ProcessList("gw mc.exe")
		If $lWinList[0][0] = 0 Then
			MsgBox(16, "启动", "激战未打开")
			Exit
		EndIf
	EndIf

	For $i = 1 To $lWinList[0][0]
		MemoryOpen($lWinList[$i][1])
		If $mGWProcHandle Then
			;ReDim $CharName[UBound($CharName) + 1]
			If MemoryRead($mBase, 'ptr') = 0 Then
				$CharacterName = ScanForCharname2()
				If IsString($CharacterName) Then
					ReDim $CharName[UBound($CharName) + 1]
					$timer += 1
					$CharName[$timer] = $CharacterName
				EndIf
			EndIf
		EndIf
		$mGWProcHandle = 0
	Next


 Return _ArrayToString($CharName, "|")

EndFunc   ;==>InitSetCharnames

Func GetFirstUnhookedLoggedCharname()
	Local $lWinList = ProcessList("gw.exe")
	Local $CharName[1]
	Local $CharacterName
	Local $Returns[2]
	Local $timer = 0

	If $lWinList[0][0] = 0 Then
		$lWinList = ProcessList("gw mc.exe")
		If $lWinList[0][0] = 0 Then
			MsgBox(16, "启动", "激战未打开")
			Exit
		EndIf
	EndIf

	For $i = 1 To $lWinList[0][0]
		MemoryOpen($lWinList[$i][1])
		If $mGWProcHandle Then
			;ReDim $CharName[UBound($CharName) + 1]
			If MemoryRead($mBase, 'ptr') = 0 Then
				$CharacterName = ScanForCharname2()
				If IsString($CharacterName) Then
					ReDim $CharName[UBound($CharName) + 1]
					$timer += 1
					$CharName[$timer] = $CharacterName
				EndIf
			EndIf
		EndIf
		$mGWProcHandle = 0
	Next


 Return $CharName[1]

EndFunc   ;==>InitSetCharnames

Func GetFirstLoggedCharname()
	Local $lWinList = ProcessList("gw.exe")
	Local $CharName[1]
	Local $CharacterName
	Local $Returns[2]

	If $lWinList[0][0] = 0 Then
		$lWinList = ProcessList("gw mc.exe")
		If $lWinList[0][0] = 0 Then
			MsgBox(16, "启动", "激战未打开")
			Exit
		EndIf
	EndIf

	For $i = 1 To $lWinList[0][0]
		MemoryOpen($lWinList[$i][1])
		If $mGWProcHandle Then
			$CharacterName = ScanForCharname2()
			If IsString($CharacterName) Then
				ReDim $CharName[UBound($CharName) + 1]
				$CharName[$i] = $CharacterName
			EndIf
		EndIf
		$mGWProcHandle = 0
	Next


 Return $CharName[1]

EndFunc   ;==>InitSetCharnames

#endregion GUIFuncs

Start()


Func Start()
While 1
	Sleep(250)
	If $boolrun Then
		If $Option3 = True Then Purge()
		main()
		GUIUpdate()
	EndIf
WEnd
EndFunc


#region BotFuncs //PUT YOUR BOT CODE HERE

Func main() ; MAIN LOOP HERE
	Upd("第 " & ($Runs + 1) & " 轮")
	If $Firstrun Then
		$Firstrun = False
		$RunProf = DllStructGetData(GetAgentByID(-2), 'Primary')
		If $RunProf = 7 Then
			upd("暗杀刷怪")
			Sleep(500)
		ElseIf $RunProf = 2 Then
			upd("游侠刷怪")
			Sleep(500)
			;$boolrun = False
			;main()
			;upd("游侠刷怪")
			;Sleep(500)
		Else
			upd("不能用此职业刷怪")
			Sleep(500)
			$boolrun = False
			main()
		EndIf
		If GetMapID() <> 349 Then
			upd("换城")
			RndTravel(349)
		EndIf
		upd("正在装载技能")
		If $RunProf = 7 Then LoadSkillTemplate("OwJSg5PT8I6MHQNQ3lPH4OCH")
		If $RunProf = 2 Then LoadSkillTemplate("OgcSc5PT8I6MHQsSpG3l4OCH")
		ChangeWeaponSet(2)
	EndIf
	If CountSlots() < 3 Then
		TravelTo(303)
		Inventory()
		$Firstrun = True
		TravelTo(349)
	EndIf

	If $RunProf = 7 Then AssassinRun()
	If $RunProf = 2 Then RangerRun()
EndFunc   ;==>main

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

Func PingSleep($time)
	Sleep($time + GetPing())
EndFunc   ;==>PingSleep

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
				Sleep(GetPing())
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
	If $r = 2624 Then
		Return True
 	ElseIf $m = 146 Then ;Dyes
		$e = DllStructGetData($aitem, 'ExtraID')
 		If $e = 10 Or $e = 12 Or $e = 13 Then ; Black, White, Pink
 			Return True
		Else
		Return False
		EndIf
 	ElseIf $m = 22751 Then
 		Return True
	ElseIf $m = 956 Then
 		Return True
 	ElseIf $m > 21785 And $m < 21806 Then ;Elite/Normal Tomes
		Return False
	ElseIf $m = 819 Or $m = 934 Then ; Roots/Fibers
		Return True
 	ElseIf $m = 22191 Or $m = 22190 Or $m = 20 Then
 		Return True
	ElseIf $m = 22752 Or $m = 22269 Or $m = 28436 Or $m = 31152 Or $m = 31151 Or $m = 31153 Or $m = 35121 Or $m = 28433 Or $m = 26784 Or $m = 6370 Or $m = 21488 Or $m = 21489 Or $m = 22191 Or $m = 24862 Or $m = 21492 Or $m = 22644 Or $m = 30855 Or $m = 5585 Or $m = 24593 Or $m = 6375 Or $m = 22190 Or $m = 6049 Or $m = 910 Or $m = 28435 Or $m = 6369 Or $m = 21809 Or $m = 21810 Or $m = 21813 Or $m = 6376 Or $m = 6368 Or $m = 29436 Or $m = 21491 Or $m = 28434 Or $m = 21812 Or $m = 35124 Then ; Consumables
		Return True
 	ElseIf BitAND(DllStructGetData($aitem, 'Interaction'), 16777216) OR BitAND(DllStructGetData($aitem, 'Interaction'), 131072) Then ;If it is usable, a.k.a, a consumable, or gold (BETA)
		Return True
	Else
		Return $Option1
	EndIf
EndFunc   ;==>CanPickUp

;~ Description: Move to a location and wait until you reach it.
Func MoveToEx($aX, $aY, $aRandom = 50)
	Local $lBlocked = 0
	Local $lMe
	Local $lMapLoading = GetMapLoading(), $lMapLoadingOld
	Local $lDestX = $aX + Random(-$aRandom, $aRandom)
	Local $lDestY = $aY + Random(-$aRandom, $aRandom)

	Move($lDestX, $lDestY, 0)

	Do
		Sleep(100)
		$lMe = GetAgentByID(-2)

		If DllStructGetData($lMe, 'HP') <= 0 Then ExitLoop

		$lMapLoadingOld = $lMapLoading
		$lMapLoading = GetMapLoading()
		If $lMapLoading <> $lMapLoadingOld Then ExitLoop
		If GetMapLoading() == 2 Then Disconnected()
		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			$lBlocked += 1
			$lDestX = $aX + Random(-$aRandom, $aRandom)
			$lDestY = $aY + Random(-$aRandom, $aRandom)
			Move($lDestX, $lDestY, 0)
		EndIf
		If $lBlocked > 9 Then MoveAroundFoe(GetNearestEnemyToAgent(-2))
	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < 25 Or $lBlocked > 20
EndFunc   ;==>MoveTo

Func IsInventoryFull()
	If COUNTSLOTS() < 2 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>IsInventoryFull

Func MoveAroundFoe($agent)
Local $aX = DllStructGetData($agent,'X')
Local $aY = DllStructGetData($agent,'Y')
Local $d2r = 3.141592653589 / 180
Local $coords[2]

	$coords[0] = (300 * Cos(210*$d2r)) + $aX
	$coords[1] = (300 * Sin(210*$d2r)) + $aY

MoveTo($coords[0],$coords[1],100)
Sleep(500)
EndFunc


Func Resignf()
	SendChat("resign", '/')
	Sleep(3000 + GetPing())
	ReturnToOutpost()
	WaitMapLoading(0, 10000)
EndFunc   ;==>Resignf

Func UseSkillEx($aSkillSlot, $aTarget)
	$tDeadlock = TimerInit()
	USESKILL($aSkillSlot, $aTarget)
	Do
		Sleep(50)
		If GetIsDead(-2) = True Then Return Death()
		If GetMapLoading() == 2 Then Disconnected()
	Until GetSkillBarSkillRecharge($aSkillSlot) <> 0 Or TimerDiff($tDeadlock) > 6000
EndFunc   ;==>UseSkillEx

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
;=================================================
; Function:			GetNumberOfFoesInRangeOfAgent($aAgent = -2, $fMaxDistance = 1012)
; Description:		Get number of foes around $aAgent ($aAgent = -2 ourself) within declared range ($fMaxDistance = 1012)
; Parameter(s):		$aAgent: ID of Agent, fMaxDistance: distance to check
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	On Success - Returns count of foes
; Author(s):		GWCA team, recoded by ddarek
;=================================================
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

Func Death()
	$BadRuns += 1
	$Runs += 1
	GUICtrlSetData($lRuns, $Runs)
	GUICtrlSetData($lFails, $BadRuns)
	$Firstrun = True
	main()
EndFunc   ;==>Death
#cs
Func RndTravel($aMapID)
	Local $UseDistricts = 11 ; 7=eu, 8=eu+int, 11=all(incl. asia)
	; Region/Language order: eu-en, eu-fr, eu-ge, eu-it, eu-sp, eu-po, eu-ru, int, asia-ko, asia-ch, asia-ja
	Local $ComboDistrict[11][2]=[[2, 0],[2, 2],[2, 3],[2, 4], [2, 5],[2, 9],[2, 10],[-2, 0],[1, 0], [3, 0], [4, 0]]
	;Local $Region[11] = [2, 2, 2, 2, 2, 2, 2, -2, 1, 3, 4]
	;Local $Language[11] = [0, 2, 3, 4, 5, 9, 10, 0, 0, 0, 0]
	Local $Random = Random(1, $UseDistricts - 1, 1)
	MoveMap($aMapID, $ComboDistrict[$Random][0], 0, $ComboDistrict[$Random][1])
	WaitMapLoading($aMapID, 30000)
	Sleep(GetPing() + 1500)
EndFunc   ;==>RndTravel
#ce
; This func creates a random path for exiting outposts. It needs the coords of a spot
; in front of the exit-portal and the coords of a spot outside the portal for exiting.
; You may need to play around with the $aRandom to see which number fits you best.
Func RandomPath($PortalPosX, $PortalPosY, $OutPosX, $OutPosY, $aRandom = 50, $StopsMin = 1, $StopsMax = 5, $NumberOfStops = -1) ; do not change $NumberOfStops
	If $NumberOfStops = -1 Then $NumberOfStops = Random($StopsMin, $StopsMax, 1)
	Local $lAgent = GetAgentByID(-2)
	Local $MyPosX = DllStructGetData($lAgent, 'X')
	Local $MyPosY = DllStructGetData($lAgent, 'Y')
	Local $Distance = ComputeDistance($MyPosX, $MyPosY, $PortalPosX, $PortalPosY)
	If $NumberOfStops = 0 Or $Distance < 200 Then
		Do
			Move($PortalPosX, $PortalPosY, (2 * $aRandom)) ; Made this last spot a bit broader
			Sleep(100)
		Until WaitMapLoading(195)
		;Move($OutPosX + Random(-$aRandom, $aRandom, 1), $OutPosY + Random(-$aRandom, $aRandom, 1))
	Else
		Local $m = Random(0, 1)
		Local $n = $NumberOfStops - $m
		Local $StepX = (($m * $PortalPosX) + ($n * $MyPosX)) / ($m + $n)
		Local $StepY = (($m * $PortalPosY) + ($n * $MyPosY)) / ($m + $n)
		MoveTo($StepX, $StepY, $aRandom)
		RandomPath($PortalPosX, $PortalPosY, $OutPosX, $OutPosY, $aRandom, $StopsMin, $StopsMax, $NumberOfStops - 1)
	EndIf
EndFunc   ;==>RandomPath

Func DeathCheck()
	If GetIsDead(-2) Then
		RndTravel(349)
		Start()
	EndIf
EndFunc   ;==>DeathCheck

Func GetBestAoETarget($aRange, $aMaxFoes = 0, $aCondition = 0)
	Local $lAgent
	Local $lX, $lY
	Local $lType
	Local $lCount
	Local $lTotalHP
	Local $lOldAverage
	Local $lOldCount = -1

	For $i = 1 To $mEnemiesRange[0]
		$lCount = 0
		$lTotalHP = 0
		$lType = DllStructGetData($mEnemiesRange[$i], 'PlayerNumber')
		$lX = DllStructGetData($mEnemiesRange[$i], 'X')
		$lY = DllStructGetData($mEnemiesRange[$i], 'Y')
		If BitAND($aCondition, 1) > 0 And Not GetIsEnchanted($mEnemiesRange[$i]) Then ContinueLoop
		If BitAND($aCondition, 16) > 0 Then
			If Not GetIsCasting($mEnemiesRange[$i]) Then ContinueLoop
			If ComputeDistance($lX, $lY, DllStructGetData($mSelf, 'X'), DllStructGetData($mSelf, 'Y')) > 1240 Then ContinueLoop
		EndIf
		If BitAND($aCondition, 128) > 0 And GetIsEnchanted($mEnemiesRange[$i]) Then ContinueLoop
		If BitAND($aCondition, 256) > 0 And Not GetHasHex($mEnemiesRange[$i]) Then ContinueLoop
		If BitAND($aCondition, 512) > 0 And Not (GetIsEnchanted($mEnemiesRange[$i]) Or GetHasHex($mEnemiesRange[$i])) Then ContinueLoop
		If BitAND($aCondition, 1024) > 0 And GetIsCasting($mEnemiesRange[$i]) Then ContinueLoop
		For $J = 1 To $mEnemies[0]
			If BitAND($aCondition, 2) > 0 And Not GetIsEnchanted($mEnemies[$J]) Then ContinueLoop
			If BitAND($aCondition, 4) > 0 And Not GetHasHex($mEnemies[$J]) Then ContinueLoop
			If BitAND($aCondition, 8) > 0 And Not GetHasCondition($mEnemies[$J]) Then ContinueLoop
			;If BitAND($aCondition, 32) > 0 And GetIsMartial($mEnemies[$j]) Then ContinueLoop
			If BitAND($aCondition, 64) > 0 And $lType <> DllStructGetData($mEnemies[$J], 'PlayerNumber') Then ContinueLoop
			If ComputeDistance($lX, $lY, DllStructGetData($mEnemies[$J], 'X'), DllStructGetData($mEnemies[$J], 'Y')) <= $aRange Then
				$lCount += 1
				$lTotalHP += DllStructGetData($mEnemies[$J], 'HP')
			EndIf
		Next
		If $aMaxFoes > 0 And $lCount > $aMaxFoes Then $lCount = $aMaxFoes
		If $lCount > $lOldCount Then
			$lOldCount = $lCount
			$lOldAverage = $lTotalHP / $lCount
			$lAgent = $mEnemiesRange[$i]
		ElseIf $lCount = $lOldCount Then
			If $lTotalHP / $lCount < $lOldAverage Then
				$lOldAverage = $lTotalHP / $lCount
				$lAgent = $mEnemiesRange[$i]
			ElseIf $lTotalHP / $lCount == $lOldAverage Then
				If DllStructGetData($mEnemiesRange[$i], 'HP') > DllStructGetData($lAgent, 'HP') Then
					$lAgent = $mEnemiesRange[$i]
				EndIf
			EndIf
		EndIf
	Next
	SetExtended($lOldCount)
	Return $lAgent
EndFunc   ;==>GetBestAoETarget
Func Update($aRange)
	$aRange = $aRange ^ 2
	$mSelfID = GetMyID()
	$mSelf = GetAgentByID($mSelfID)
	$mEnergy = DllStructGetData($mSelf, 'EnergyPercent') * DllStructGetData($mSelf, 'MaxEnergy')
	$mSkillbar = GetSkillbar()
	$mEffects = GetEffect()

	$mDazed = False
	$mBlind = False
	$mSkillHardCounter = False
	$mSkillSoftCounter = 0
	$mAttackHardCounter = False
	$mAttackSoftCounter = 0
	$mAllySpellHardCounter = False
	$mEnemySpellHardCounter = False
	$mSpellSoftCounter = 0
	$mBlocking = False

	For $i = 1 To $mEffects[0]
		Switch DllStructGetData($mEffects[$i], 'SkillID')
			Case 485
				$mDazed = True
			Case 479
				$mBlind = True
			Case 30, 764
				$mSkillHardCounter = True
			Case 51, 127
				$mAllySpellHardCounter = True
			Case 46, 979, 3191
				$mEnemySpellHardCounter = True
			Case 878, 3234
				$mSkillSoftCounter += 1
				$mSpellSoftCounter += 1
				$mAttackSoftCounter += 1
			Case 28, 128
				$mSpellSoftCounter += 1
			Case 47, 43, 1004, 2056, 3195
				$mAttackHardCounter = True
			Case 123, 26, 3151, 121, 103, 66
				$mAttackSoftCounter += 1
			Case 380, 810 ;Not Finished
				$mBlocking = True
		EndSwitch
	Next

	Local $lAgent
	Local $lTeam = DllStructGetData($mSelf, 'Team')
	Local $lX = DllStructGetData($mSelf, 'X')
	Local $lY = DllStructGetData($mSelf, 'Y')
	Local $lHP
	Local $lDistance
	Local $lModel
	Local $lEnergyCount = 0

	Dim $mTeam[1] = [0]
	Dim $mTeamOthers[1] = [0]
	Dim $mTeamDead[1] = [0]
	Dim $mEnemies[1] = [0]
	Dim $mEnemiesRange[1] = [0]
	Dim $mEnemiesSpellRange[1] = [0]
	Dim $mSpirits[1] = [0]
	Dim $mPets[1] = [0]
	Dim $mMinions[1] = [0]

	$mLowestAlly = $mSelf
	$mLowestAllyHP = 2
	$mLowestOtherAlly = 0
	$mLowestOtherAllyHP = 2
	$mLowestEnemy = 0
	$mLowestEnemyHP = 2
	$mClosestEnemy = 0
	$mClosestEnemyDist = 25000000
	$mAverageTeamHP = 0
	$mAverageTeamEnergy = 0

	Local $lAgentArray = GetAgentArray(0xDB)
	For $i = 1 To $lAgentArray[0]
		$lAgent = $lAgentArray[$i]
		$lHP = DllStructGetData($lAgent, 'HP')
		$lDistance = ($lX - DllStructGetData($lAgent, 'X')) ^ 2 + ($lY - DllStructGetData($lAgent, 'Y')) ^ 2
		Switch DllStructGetData($lAgent, 'Allegiance')
			Case 1 ;Allies
				If Not BitAND(DllStructGetData($lAgent, 'Typemap'), 131072) Then ContinueLoop ;Double check it's not a summon
				If Not BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) Then
					$mTeam[0] += 1
					ReDim $mTeam[$mTeam[0] + 1]
					$mTeam[$mTeam[0]] = $lAgent

					$mAverageTeamHP += $lHP
					If DllStructGetData($lAgent, 'MaxEnergy') > 0 Then
						$mAverageTeamEnergy += DllStructGetData($lAgent, 'EnergyPercent')
						$lEnergyCount += 1
					EndIf

;~ 					Lowest Ally
					If $lHP < $mLowestAllyHP Then
						$mLowestAlly = $lAgent
						$mLowestAllyHP = $lHP
					ElseIf $lHP = $mLowestAllyHP Then
						If $lDistance < ($lX - DllStructGetData($mLowestAlly, 'X')) ^ 2 + ($lY - DllStructGetData($mLowestAlly, 'Y')) ^ 2 Then
							$mLowestAlly = $lAgent
							$mLowestAllyHP = $lHP
						EndIf
					EndIf

;~ 					Other Allies
					If $i <> $mSelfID Then
						$mTeamOthers[0] += 1
						ReDim $mTeamOthers[$mTeamOthers[0] + 1]
						$mTeamOthers[$mTeamOthers[0]] = $lAgent

;~ 						Lowest Other Ally
						If $lHP < $mLowestOtherAllyHP Then
							$mLowestOtherAlly = $lAgent
							$mLowestOtherAllyHP = $lHP
						ElseIf $lHP = $mLowestOtherAllyHP Then
							If $lDistance < ($lX - DllStructGetData($mLowestOtherAlly, 'X')) ^ 2 + ($lY - DllStructGetData($mLowestOtherAlly, 'Y')) ^ 2 Then
								$mLowestOtherAlly = $lAgent
								$mLowestOtherAllyHP = $lHP
							EndIf
						EndIf
					EndIf
				Else
;~ 					Dead Allies
					$mTeamDead[0] += 1
					ReDim $mTeamDead[$mTeamDead[0] + 1]
					$mTeamDead[$mTeamDead[0]] = $lAgent
				EndIf
			Case 3 ;Enemies
				If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) Then ContinueLoop

;~ 				ModelID BlackList
				$lModel = DllStructGetData($lAgent, 'PlayerNumber')
				Switch $lModel
					Case $BoneHorrorID To $BoneHorrorID + 2, $BoneHorrorID + 644 To $BoneHorrorID + 658, $BoneHorrorID + 1979 To $BoneHorrorID + 2009, $BoneHorrorID + 3483 To $BoneHorrorID + 3493, $BoneHorrorID + 3623 To $BoneHorrorID + 3624
						ContinueLoop
				EndSwitch

				$mEnemies[0] += 1
				ReDim $mEnemies[$mEnemies[0] + 1]
				$mEnemies[$mEnemies[0]] = $lAgent

;~ 				Enemies in waypoint range
				If $lDistance <= $aRange Then
					$mEnemiesRange[0] += 1
					ReDim $mEnemiesRange[$mEnemiesRange[0] + 1]
					$mEnemiesRange[$mEnemiesRange[0]] = $lAgent

;~ 					Lowest Enemy
					If $lHP < $mLowestEnemyHP Then
						$mLowestEnemy = $lAgent
						$mLowestEnemyHP = $lHP
					ElseIf $lHP = $mLowestEnemyHP Then
						If $lDistance < ($lX - DllStructGetData($mLowestEnemy, 'X')) ^ 2 + ($lY - DllStructGetData($mLowestEnemy, 'Y')) ^ 2 Then
							$mLowestEnemy = $lAgent
							$mLowestEnemyHP = $lHP
						EndIf
					EndIf

;~ 					Closest Enemy
					If $lDistance < $mClosestEnemyDist Then
						$mClosestEnemyDist = $lDistance
						$mClosestEnemy = $lAgent
					EndIf
				EndIf


;~ 				Enemies in spell range
				If $lDistance <= 1537600 Then ;1240
					$mEnemiesSpellRange[0] += 1
					ReDim $mEnemiesSpellRange[$mEnemiesSpellRange[0] + 1]
					$mEnemiesSpellRange[$mEnemiesSpellRange[0]] = $lAgent
				EndIf
			Case 4 ;Allied Pets/Spirits
				If Not BitAND(DllStructGetData($lAgent, 'Typemap'), 131072) Then ContinueLoop
				If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) Then ContinueLoop
				If BitAND(DllStructGetData($lAgent, 'Typemap'), 262144) Then
					$mSpirits[0] += 1
					ReDim $mSpirits[$mSpirits[0] + 1]
					$mSpirits[$mSpirits[0]] = $lAgent
				Else
					$mPets[0] += 1
					ReDim $mPets[$mPets[0] + 1]
					$mPets[$mPets[0]] = $lAgent
				EndIf
			Case 5 ;Allied Minions
				If Not BitAND(DllStructGetData($lAgent, 'Typemap'), 131072) Then ContinueLoop
				If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) Then ContinueLoop
				$mMinions[0] += 1
				ReDim $mMinions[$mMinions[0] + 1]
				$mMinions[$mMinions[0]] = $lAgent
			Case Else
		EndSwitch
	Next
	$mClosestEnemyDist = Sqrt($mClosestEnemyDist)
	$mAverageTeamHP /= $mTeam[0]
	$mAverageTeamEnergy /= $lEnergyCount
EndFunc   ;==>Update

Func AssassinRun()
	Local $enemyID, $enemy
	GoOutside()
	RndSleep(2000)
	upd("前往龙苔处")
	UseSkillEx(5, -2)
	UseSkillEx(4, -2)
	MoveToEx(-8498, 18548)
	MoveToEx(-6858, 17713)
	Do
		Move(-5348, 16085)
		Sleep(100)
	Until GetNumberOfFoesInRangeOfAgent(-2, 1300) > 0
	upd("上加持")
	UseSkillEx(1, -2)
	UseSkillEx(2, -2)
	UseSkillEx(3, -2)
	RndSleep(1025);;


	UseSkillEx(4, -2)
	upd("引龙苔")
	MoveToEx(-5234, 15574)
	upd("围龙苔")
	MoveToEx(-6131, 17952)

	UseSkillEx(4, -2)
	TolSleep(450)

	MoveToEx(-6483, 18291)
	upd("准备")
	Update(2000)
	UseSkillEx(5, -2)
	UseSkillEx(4, -2)

	Do
		Sleep(50)
	Until DllStructGetData(GetSkillbar(), 'Recharge2') == 0

	UseSkillEx(2, -2)
	UseSkillEx(6, -2)
	;RndSleep(2025);;
	;RndSleep(1550)
	;RndSleep(225);;
	;UseSkillEx(5, -2)



	;Do
	;	Sleep(50)
	;Until DllStructGetData(GetSkillbar(), 'Recharge4') == 0
	UseSkillEx(4, -2)

	upd("杀")
	$enemyID = GetBestAoETarget(365)
	UseSkillEx(7, $enemyID)
	Do
		Sleep(500)
	Until GetEnergy() >= 10
	RndSleep(300)
	UseSkillEx(8, -2)
	Do
		UseSkillEx(2, -2);;
		Sleep(500)
	Until GetNumberOfFoesInRangeOfAgent(-2, 200) < 3 Or GetIsDead(-2)
	UseSkillEx(2, -2);;
	UseSkillEx(4, -2);;
	PickUpLoot()
	RndSleep(2500)
	RndTravel(349)
 EndFunc   ;==>AssassinRun

Func RangerRun()
	Local $SFTimer, $enemyID, $enemy
	GoOutside()
	RndSleep(3000)
	upd("前往龙苔处")
	UseSkillEx(6, -2)
	UseSkillEx(4, -2)
	MoveToEx(-8498, 18548)
	MoveToEx(-6858, 17713)
	Do
		Move(-5348, 16085)
		Sleep(100)
	Until GetNumberOfFoesInRangeOfAgent(-2, 1300) > 0
	upd("上加持")
	UseSkillEx(1, -2)
	UseSkillEx(2, -2)
	$SFTimer = TimerInit()
	UseSkillEx(3, -2)
	upd("引龙苔")
	UseSkillEx(5, -2)
	MoveToEx(-5234, 15574)
	upd("围龙苔")
	MoveToEx(-6131, 17952)
	TolSleep(450)
	MoveToEx(-6570, 18493)
	TolSleep(500)
	Update(2000)
	upd("杀")
	UseSkillEx(6, -2)
	UseSkillEx(4, -2)
	$enemyID = GetBestAoETarget(365)
	UseSkillEx(7, $enemyID)
	;Do
	;	Sleep(500)
	;Until GetDistance(-2, $enemyID) < 500 Or GetIsDead(-2)
	UseSkillEx(8, -2)
	Do
		Sleep(500)
		If TimerDiff($SFTimer) > 18000 Then
			UseSkillEx(2, -2)
			$SFTimer = 0
		EndIf
	Until GetNumberOfFoesInRangeOfAgent(-2, 200) < 3 Or GetIsDead(-2)
	Sleep(Random(250, 1500) + GetPing())
	PickUpLoot()
	RndSleep(2500)
	RndTravel(349)
EndFunc   ;==>RangerRun