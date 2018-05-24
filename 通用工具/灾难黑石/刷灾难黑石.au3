#include-once
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "../../激战接口.au3"

#Region declarations
Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)

Global Const $RangerSkillBarTemplate = "OgcTc5+8Z6ASn5uU4ABimsBKuEA"
Global $bag_slots[5] = [0, 20, 5, 10, 10]
Global $spawned = False
Global $ensuresafety = false
Global Const $warrsupply = 35121
Global Const $champion = 1943
Global Const $fow = 34
Global Const $grog = 30885
Global Const $chantry = 393
Global Const $embark = 857
Global Const $toa = 138
Global Const $shard = 945
Global Const $scroll = 22280
Global Const $scrollitem = GetItemByModelID($scroll)
Global Const $darkremains = 522
Global Const $ruby = 937
Global Const $saph = 938
Global Const $obbykey = 5971
Global $Array_Store_ModelIDs[77] = [910, 2513, 5585, 6366, 6375, 22190, 24593, 28435, 30855, 31145, 36682 _ ; Alcohol
		, 21492, 21812, 22269, 22644, 22752, 28436, 36681 _ ; FruitCake, Blue Drink, Cupcake, Bunnies, Eggs, Pie, Delicious Cake
		, 6376, 21809, 21810, 21813, 36683 _ ; Party Spam
		, 6370, 21488, 21489, 22191, 26784, 28433 _ ; DP Removals
		, 15837, 21490, 30648, 31020 _ ; Tonics
		, 556, 18345, 21491, 37765, 21833, 28433, 28434, 522 _ ; CC Shards, Victory Token, Wayfarer, Lunar Tokens, ToTs, Dark Remains, Obby keys
		, 921, 922, 923, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943, 944, 945, 946, 948, 949, 950, 951, 952, 953, 954, 955, 956, 6532, 6533] ; All Materials
Global Const $RARITY_GOLD = 2624
Global Const $RARITY_PURPLE = 2626
Global Const $RARITY_BLUE = 2623
Global Const $RARITY_WHITE = 2621
Global $town = $chantry ;start town
Global $shardcount = 0
Global $wins = 0
Global $fails = 0
Global $shardcount = 0
Global $RenderingEnabled = True
Global $BotRunning = False
Global $BotInitialized = False
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Global Const $skill_id_shroud = 1031
Global Const $skill_id_iau = 2356
Global Const $skill_id_wd = 450
Global Const $skill_id_mb = 2417
Global Const $ds = 3
Global Const $sf = 2
Global Const $shroud = 1
Global Const $hos = 5
Global Const $wd = 4
Global Const $iau = 6
Global Const $de = 7
Global Const $mb = 8
; Store skills energy cost
Global $skillCost[9]
$skillCost[$ds] = 5
$skillCost[$sf] = 5
$skillCost[$shroud] = 10
$skillCost[$wd] = 4
$skillCost[$hos] = 5
$skillCost[$iau] = 5
$skillCost[$de] = 5
$skillCost[$mb] = 10

$Form1 = GUICreate("灾难", 125, 215)
$Combo1 = GUICtrlCreateCombo("", 8, 8, 105, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, GetLoggedCharNames())
$Label1 = GUICtrlCreateLabel("成功 :", 13, 37, 31, 17)
$winlabel = GUICtrlCreateLabel("0", 48, 37, 20, 17)
$Label2 = GUICtrlCreateLabel("失败 : ", 13, 59, 31, 17)
$faillabel = GUICtrlCreateLabel("0", 48, 59, 20, 17)
$Label3 = GUICtrlCreateLabel("黑石 : ", 13, 81, 31, 17)
$shardlabel = GUICtrlCreateLabel("0", 48, 81, 20, 17)
$Checkbox1 = GUICtrlCreateCheckbox("由无人区出发", 8, 105, 97, 17)
GUICtrlSetState(-1, $gui_unchecked)
GUICtrlSetOnEvent(-1, "safety")
$Checkbox2 = GUICtrlCreateCheckbox("不成像", 8, 129, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "ToggleRendering")
$slabel = GUICtrlCreateLabel("准备就绪", 13, 153, 131, 17)
$Button1 = GUICtrlCreateButton("启动", 8, 178, 105, 25)
GUICtrlSetOnEvent(-1, "GuiButtonHandler")

GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
GUISetState(@SW_SHOW)

#Region funcs
Func _exit()
	Exit
EndFunc   ;==>_exit

Func GuiButtonHandler()
	If $BotRunning Then
		GUICtrlSetData($Button1, "此轮过后结束")
		GUICtrlSetState($Button1, $GUI_DISABLE)
		$BotRunning = False
	ElseIf $BotInitialized Then
		GUICtrlSetData($Button1, "暂停")
		$BotRunning = True
	Else
		Out("正在启动")
		Local $CharName = GUICtrlRead($Combo1)
		;If $CharName == "" Then
			If Initialize("") = False Then
				MsgBox(0, "失败", "未开启激战.")
				Exit
			EndIf
			#cs
		Else
			If Initialize($CharName) = False Then
				MsgBox(0, "失败", "角色失寻 '" & $CharName & "'")
				Exit
			EndIf
		EndIf
		#ce
		GUICtrlSetState($Checkbox2, $GUI_ENABLE)
		GUICtrlSetState($Combo1, $GUI_DISABLE)
		GUICtrlSetData($Button1, "暂停")
		$BotRunning = True
		$BotInitialized = True
		setmaxmemory()
	EndIf
EndFunc   ;==>GuiButtonHandler

Func safety()
	If GUICtrlRead($Checkbox1) = $gui_checked Then
		$ensuresafety = True
		out("限无人区")
	Else
		$ensuresafety = False
		out("有人区无碍")
	EndIf
EndFunc   ;==>safety

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

Func Out($msg)
	GUICtrlSetData($slabel, "[" & @HOUR & ":" & @MIN & "]" & $msg)
EndFunc   ;==>Out

Func UseSkillEx($lSkill, $lTgt = -2, $aTimeout = 3000)
	$mSkillbar = GetSkillbar()
	If GetIsDead(-2) Then Return
	If Not IsRecharged($lSkill) Then Return
	If GetEnergy(-2) < $skillCost[$lSkill] Then Return
	Local $Skill = GetSkillByID(DllStructGetData($mSkillbar, 'Id' & $lSkill))
	If DllStructGetData($mSkillbar, 'AdrenalineA' & $lSkill) < DllStructGetData($lSkill, 'Adrenaline') Then Return False
	Local $lDeadlock = TimerInit()
	UseSkill($lSkill, $lTgt)
	Do
		Sleep(50)
		If GetIsDead(-2) = 1 Then Return
	Until (Not IsRecharged($lSkill)) Or (TimerDiff($lDeadlock) > $aTimeout)

	If $lSkill > 1 Then RndSleep(350)
EndFunc   ;==>UseSkillEx

Func IsRecharged($lSkill)
	Return GetSkillBarSkillRecharge($lSkill) == 0
EndFunc   ;==>IsRecharged

Func UseSF()
	If IsRecharged($sf) Then
		UseSkillEx($sf)
	EndIf
	If isrecharged($shroud) And GetEffectTimeRemaining($skill_id_iau) > 1 Then
		useSkillEx($shroud)
	EndIf
	If GetEffectTimeRemaining($skill_id_shroud) < 10 Then
		useSkillEx($shroud)
	EndIf
EndFunc   ;==>UseSF

Func MoveRunning($lDestX, $lDestY)
	If GetIsDead(-2) Then Return False

	Local $lMe, $lTgt
	Local $lBlocked = 0
	Local $ChatStuckTimer = TimerInit()

	Move($lDestX, $lDestY)

	Do
		RndSleep(500)

		TargetNearestEnemy()
		$lMe = GetAgentByID(-2)
		$lTgt = GetAgentByID(-1)

		If GetIsDead($lMe) Then Return False
		If $lBlocked > 1 Then
			If TimerDiff($ChatStuckTimer) > 3000 Then
				SendChat("stuck", "/")
				$ChatStuckTimer = TimerInit()
			EndIf
		EndIf
		UseSF()
		If $lBlocked = 5 Then
			UseSkillEx($hos, -1)
			Sleep(100)
			Move($lDestX, $lDestY)
			If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
				$lBlocked = 1
			Else
				$lBlocked = 0
			EndIf
		EndIf
		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			$lBlocked += 1
			Move($lDestX, $lDestY)
		EndIf

		If DllStructGetData($lMe, 'hp') < 0.2 Then
			UseSkillEx($hos)
		EndIf
		If gethascondition($lMe) And DllStructGetData($lMe, 'hp') < 0.4 Then
			UseSkillEx($hos)
		EndIf
		If GetDistance() > 1100 Then ;
			If TimerDiff($ChatStuckTimer) > 3000 Then ;
				SendChat("stuck", "/")
				$ChatStuckTimer = TimerInit()
				RndSleep(GetPing())
			EndIf
		EndIf

	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < 250
	Return True
EndFunc   ;==>MoveRunning

Func WaitFor($lMs, $class = 1) ;class cause we dont want to hos @ rangers
	If GetIsDead(-2) Then Return
	$lMe = GetAgentByID(-2)
	Local $lTimer = TimerInit()
	If $class = 1 Then
		Do
			If GetEffectTimeRemaining($skill_id_wd) < 1 Then Return
			Sleep(100)
			If GetIsDead(-2) Then Return
			If IsRecharged($iau) Then
				UseSkillEx($iau)
			EndIf

			If DllStructGetData($lMe, 'hp') < 0.3 Then
				UseSkillEx($hos)
			EndIf
			If gethascondition($lMe) And DllStructGetData($lMe, 'hp') < 0.4 Then
				UseSkillEx($hos)
			EndIf
			UseSF()
			If isrecharged($mb) And geteffecttimeremaining($skill_id_mb) = 0 Then
				useskillex($mb)
			EndIf
		Until TimerDiff($lTimer) > $lMs Or GetIsDead(-2)
	Else
		Do
			Sleep(100)
			If GetIsDead(-2) Then Return
			If IsRecharged($iau) Then
				UseSkillEx($iau)
			EndIf
			UseSF()
		Until TimerDiff($lTimer) > $lMs
	EndIf
EndFunc   ;==>WaitFor

Func loop()
	If Not $RenderingEnabled Then ClearMemory()
	If getmapid() <> $fow Then Return
	out("前往第一点")
	UseSkillEx($sf)
	UseSkillEx($ds)
	UseSkillEx($de)
	moveto(-21131, -2390)
	MoveRunning(-16494, -3113)
	out("诱巨魔")
	Sleep(1000)
	UseSkillEx($iau)
	If IsRecharged($ds) Then
		UseSkillEx($ds)
	EndIf
	If IsRecharged($ds) Then
		UseSkillEx($ds)
	EndIf
	useskillex($mb)
	MoveRunning(-14453, -3536)
	UseSkillEx($ds)
	UseSkillEx($wd)
	$whirletimer = TimerInit()
	MoveRunning(-13684, -2077)
	MoveRunning(-14113, -418)
	out("杀巨魔")
	waitfor(38000 - TimerDiff($whirletimer))
	out("收集")
	PickUpLoot()
	MoveRunning(-13684, -2077)
	out("诱游侠")
	MoveRunning(-15826, -3046)
	rndsleep(1500)
	moveto(-16002, -3031)
	out("检查技能")
	Do
		If getisdead(-2) Then Return
		WaitFor(1500)
	Until IsRecharged($mb) And isrecharged($wd)
	moveto(-16004, -3202)
	MoveRunning(-15272, -3004)
	UseSkillEx($iau)
	UseSkillEx($ds)
	UseSkillEx($mb)
	If IsRecharged($wd) Then
		UseSkillEx($wd)
	EndIf
	If IsRecharged($mb) Then
		UseSkillEx($mb)
	EndIf
	out("杀游侠")
	MoveRunning(-14453, -3536)
	moverunning(-14209, -2935)
	moverunning(-14535, -2615)
	waitfor(27000, 2)
	moveto(-14506, -2633)
	out("收集")
	PickUpLoot()
	If Not getisdead(-2) Then
		$wins = $wins + 1
		GUICtrlSetData($winlabel, $wins)
	Else
		$fails = $fails + 1
		GUICtrlSetData($faillabel, $fails)
	EndIf
	$spawned = False
EndFunc   ;==>loop

Func PickUpLoot()
	Local $lMe
	Local $lBlockedTimer
	Local $lBlockedCount = 0
	Local $lItemExists = True
	For $i = 1 To GetMaxAgents()
		$lMe = GetAgentByID(-2)
		If DllStructGetData($lMe, 'HP') <= 0.0 Then Return -1
		$lAgent = GetAgentByID($i)
		If Not GetIsMovable($lAgent) Then ContinueLoop
		If Not GetCanPickUp($lAgent) Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If canpickup($lItem) Then
			Do
				If $lBlockedCount > 2 Then
					useskillex($hos)
				EndIf
;~ 				If GetDistance($lItem) > 150 Then Move(DllStructGetData($lItem, 'X'), DllStructGetData($lItem, 'Y'), 100)
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
EndFunc   ;==>PickUpLoot

Func canpickup($lItem)
	Local $m = DllStructGetData($lItem, 'ModelId')
	Local $t = DllStructGetData($lItem, 'Type')
	Local $c = DllStructGetData($lItem, 'ExtraID')
	Local $r = GetRarity($lItem)
	Switch $m
		Case $darkremains
			Return True
		Case 910, 2513, 5585, 6366, 6375, 22190, 24593, 28435, 30855, 31145, 36682 _ ; Alcohol
				, 21492, 21812, 22269, 22644, 22752, 28436, 36681 _ ; FruitCake, Blue Drink, Cupcake, Bunnies, Eggs, Pie, Delicious Cake
				, 6376, 21809, 21810, 21813, 36683 _ ; Party Spam
				, 6370, 21488, 21489, 22191, 26784, 28433 _ ; DP Removals
				, 15837, 21490, 30648, 31020 _ ; Tonics
				, 556, 18345, 21491, 37765, 21833, 28433, 28434 _ ; CC Shards, Victory Token, Wayfarer, Lunar Tokens, ToTs
				, 921, 922, 923, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943, 944, 946, 948, 949, 950, 951, 952, 953, 954, 955, 956, 6532, 6533 ; Materials
			Return True
		Case 945
			$shardcount = $shardcount + 1
			GUICtrlSetData($shardlabel, $shardcount)
			Return True
		Case 2511 ; Gold
			Return True
		Case 5971, 22280 ; Obsidian Key and Fissure Scrolls
			Return True
		Case 146 ; Dyes
			Switch $c
				Case 10, 12 ; Only Black/White
					Return True
			EndSwitch
	EndSwitch
#cs
	Switch $r
		Case 2624
			Return True
	EndSwitch
#ce
	Return False
EndFunc   ;==>canpickup

Func enterfow()
	CheckGoldLevel()
	Sleep(GetPing()+500)

    enterkneel()
	WaitMapLoading($fow)

EndFunc   ;==>enterfow

Func enterscroll()
	Out("正在用入场卷(灾难)")
	useitembymodelid($scroll)
	WaitMapLoading($fow)
EndFunc   ;==>enterscroll

Func EnterKneel()
	If $ensuresafety Then
		Do
			rndtravel($town)
			rndsleep(200)
		Until isdisempty()
	Else
		rndtravel($town)
		If GetMapLoading() == 0 Then LoadSkillTemplate($RangerSkillBarTemplate)
	EndIf
	If getmapid() = $chantry Then
		out("前往隐秘教堂")
		rndsleep(400)
		kneel(-9979, 1171)
	ElseIf getmapid() = $toa Then
		out("前往隐秘教堂")
		rndsleep(200)
		kneel(-2522, 18731)
	EndIf
EndFunc   ;==>EnterKneel

#Region Getting Gold

Func CheckGoldLevel()
	If GetGoldCharacter() < 1000 Then
	   If GetGoldStorage() < 1000 Then
			Out("资金不够")
			$BotRunning = False
			Return False
		EndIf
		Out("取金")
		WithdrawGold(1000)
	EndIf
EndFunc   ;==>CheckGoldLevel

Func MoveEx($x, $y, $random = 150)
	Move($x, $y, $random)
EndFunc   ;==>MoveEx
#EndRegion Getting Gold

Func moveandcheckdis($ax, $ay, $arandom = 65) ; for noids , replace this with moveto() in kneel,will change dis as soon as it detect s1
	Local $lBlocked = 0
	Local $lMe
	Local $lMapLoading = GetMapLoading(), $lMapLoadingOld
	Local $lDestX = $ax + Random(-$arandom, $arandom)
	Local $lDestY = $ay + Random(-$arandom, $arandom)
	$notalone = False
	Move($lDestX, $lDestY, 0)

	Do
		Sleep(100)
		$lMe = GetAgentByID(-2)

		If DllStructGetData($lMe, 'HP') <= 0 Then ExitLoop

		$lMapLoadingOld = $lMapLoading
		$lMapLoading = GetMapLoading()
		If $lMapLoading <> $lMapLoadingOld Then ExitLoop

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			$lBlocked += 1
			$lDestX = $ax + Random(-$arandom, $arandom)
			$lDestY = $ay + Random(-$arandom, $arandom)
			Move($lDestX, $lDestY, 0)
		EndIf
		If Not isdisempty() Then
			enterfow()
		EndIf
	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < 100 Or $lBlocked > 14

EndFunc   ;==>moveandcheckdis

Func kneel($one, $two)
	$Avatar = GetNearestNPCToCoords($one, $two) ;
	Local $FailPops = 0
	$spawned = False
	If Not $spawned Then
		moveto($one, $two)
		If DllStructGetData($Avatar, "PlayerNumber") <> $champion Then
			If $ensuresafety Then
				If Not isdisempty() Then
					enterfow()
				EndIf
			EndIf
			If getmapid() <> $town Then Return
			Out("激活神像")
			SendChat("kneel", "/")
			Local $lDeadlock = TimerInit()
			Do
				If getmapid() <> $town Then Return
				Sleep(1500) ; .
				$Avatar = GetNearestNPCToCoords($one, $two)

				If TimerDiff($lDeadlock) > 5000 Then
					moveto($one, $two)
					SendChat("kneel", "/")
					$lDeadlock = TimerInit()
					$FailPops += 1
				EndIf
			Until DllStructGetData($Avatar, "PlayerNumber") == $champion Or $FailPops = 2;
		EndIf

		If $FailPops > 2 Then
			$spawned = False
			If $town = $chantry Then
				$town = $chantry;$toa
			Else
				$town = $chantry
			EndIf
			enterfow()
		Else
			$spawned = True
		EndIf
	EndIf
	If getmapid() <> $town Then Return
	If $spawned Then
		Out("前往灾难")
		GoNpc($Avatar)
		Sleep(500)
		Dialog(0x85) ;
		Sleep(400)
		DIALOG(0x86)
		Sleep(100)
	EndIf
EndFunc   ;==>kneel

Func isdisempty()
	Local $peoplecount = -1
	$lAgentArray = GetAgentArray()
	For $i = 1 To $lAgentArray[0]
		$aAgent = $lAgentArray[$i]
		If isagenthuman($aAgent) Then
			$peoplecount += 1
		EndIf
	Next
	If $peoplecount > 0 Then

		If $town = $chantry Then
			out("有人。")
			$town = $chantry;$toa
		Else
			out("有人。")
			$town = $chantry
		EndIf
		Return False
	Else
		out("无人")
		Return True
	EndIf

EndFunc   ;==>isdisempty

Func isagenthuman($aAgent)
	If DllStructGetData($aAgent, 'Allegiance') <> 1 Then Return
	$thename = GetPlayerName($aAgent)
	If $thename = "" Then Return
	Return True
EndFunc   ;==>isagenthuman

#cs
Func RndTravel($aMapID)
	Local $aRegion
	Local $aLang = 0

	Do
		$aRegion = Random(1, 4, 1)
		If $aRegion = 2 Then
			$aLang = Random(2, 7, 1)
			If $aLang = 6 Or $aLang = 7 Then
				$aLang = Random(9, 10, 1)
			EndIf
		EndIf
	Until $aRegion <> GetRegion() And $aLang <> GetLanguage()

	If MoveMap($aMapID, $aRegion, 0, $aLang) Then
		Return WaitMapLoading($aMapID)
	EndIf
EndFunc   ;==>RndTravel
#ce
#EndRegion funcs

While Not $BotRunning
	Sleep(100)
WEnd

While 1
	Sleep(50)
	clearmemory()
;	If CountSlots() < 5 Then
;		_exit()
;	EndIf
	enterfow()
	loop()
WEnd