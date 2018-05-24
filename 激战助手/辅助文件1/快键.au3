﻿#include-once
#include <Misc.au3>
#include <ColorConstants.au3>
#include <../辅助文件2/激战常数.au3>
#include <../辅助文件2/辅助功能.au3>
#include <../../激战接口.au3>
#include <../辅助文件1/一般常数.au3>
#include <../辅助文件1/界面框.au3>
#include <../辅助文件1/快键绑定.au3>

#cs
this file contains everything related to the hotkeys tab and hotkeys functionality

#ce

Global $hotkeyCount = 25 ;23
Global $hotkeyLegitCount = 25 ;15
Global Enum $HOTKEY_STUCK, $HOTKEY_RECALL, $HOTKEY_UA, $HOTKEY_RESIGN, $HOTKEY_TEAMRESIGN, _
$HOTKEY_CLICKER, $HOTKEY_RES, $HOTKEY_AGE, $HOTKEY_AGEPM, $HOTKEY_PSTONE, $HOTKEY_GHOSTTARGET, _
$HOTKEY_GHOSTPOP, $HOTKEY_GSTONEPOP, $HOTKEY_LEGIOPOP, $HOTKEY_RAINBOWUSE, _
$HOTKEY_LOOTER, $HOTKEY_IDENTIFIER, $HOTKEY_FOCUS, $HOTKEY_HIDEGW, _
$HOTKEY_RUPT, $HOTKEY_MOVEMENT, $HOTKEY_DROP1COIN, $HOTKEY_DROPCOINS, $HOTKEY_OPENCHEST, $HOTKEY_TARGET

Local $clickerToggle = False
Local $dropCoinToggle = False
Local $dropCoinTimer = TimerInit()

Global $hotkeyCheckbox[$hotkeyCount]
Global $hotkeyInput[$hotkeyCount]
Global $targetIDinput

Local $ruptSkill, $ruptSlot, $ruptActive = False
Local $movementXcoord, $movementYcoord


Global $hotkeyName[$hotkeyCount]
$hotkeyName[$HOTKEY_STUCK] = "stuck"
$hotkeyName[$HOTKEY_RECALL] = "recall"
$hotkeyName[$HOTKEY_UA] = "ua"
$hotkeyName[$HOTKEY_RESIGN] = "resign"
$hotkeyName[$HOTKEY_TEAMRESIGN] = "teamresign"
$hotkeyName[$HOTKEY_CLICKER] = "clicker"
$hotkeyName[$HOTKEY_RES] = "res"
$hotkeyName[$HOTKEY_AGE] = "age"
$hotkeyName[$HOTKEY_AGEPM] = "agepm"
$hotkeyName[$HOTKEY_PSTONE] = "pstone"
$hotkeyName[$HOTKEY_GHOSTTARGET] = "ghosttarget"
$hotkeyName[$HOTKEY_GHOSTPOP] = "ghostpop"
$hotkeyName[$HOTKEY_GSTONEPOP] = "gstonepop"
$hotkeyName[$HOTKEY_LEGIOPOP] = "legiopop"
$hotkeyName[$HOTKEY_RAINBOWUSE] = "rainbowpop"
; from here will be hidden by default
$hotkeyName[$HOTKEY_LOOTER] = "looter"
$hotkeyName[$HOTKEY_IDENTIFIER] = "identifier"
$hotkeyName[$HOTKEY_FOCUS] = "focus"
$hotkeyName[$HOTKEY_HIDEGW] = "hidegw"
$hotkeyName[$HOTKEY_RUPT] = "rupt"
$hotkeyName[$HOTKEY_MOVEMENT] = "movement"
$hotkeyName[$HOTKEY_DROP1COIN] = "drop1coin"
$hotkeyName[$HOTKEY_DROPCOINS] = "dropcoins"
$hotkeyName[$HOTKEY_OPENCHEST] = "openchest"
$hotkeyName[$HOTKEY_TARGET] = "lockontarget"

; the function to call when an hotkey is pressed. the function MUST be named "action" and then the name, e.g. actionstuck, actionrecall, etc
Global $hotkeyAction[$hotkeyCount]
For $i = 0 To $hotkeyCount-1
	$hotkeyAction[$i] = "action" & $hotkeyName[$i]
Next

Local $hotkeyPressed[$hotkeyCount]
For $i = 0 To $hotkeyCount-1
	$hotkeyPressed[$i] = False
Next

Global $hotkeyShow[$hotkeyCount]
For $i = 0 To $hotkeyCount-1
	$hotkeyShow[$i] = ($i < $hotkeyLegitCount)
Next

Global $hotkeyActive[$hotkeyCount]
Global $hotkeyKey[$hotkeyCount]

Func hotkeyGetMaxScroll()
	Local $lRet = - 269
	For $i = 0 To $hotkeyCount-1
		If $hotkeyShow[$i] Then $lRet += 31
	Next
	Return $lRet
EndFunc

Func hotkeyLoadIni()
	For $i = 0 To $hotkeyCount-1
		$hotkeyActive[$i] = (IniRead($iniFullPath, $hotkeyName[$i], "active", False) == "True")
		$hotkeyKey[$i] = IniRead($iniFullPath, $hotkeyName[$i], "hotkey", "00")
	Next

	For $i = $hotkeyLegitCount To $hotkeyCount-1
		IniReadSection($iniFullPath, $hotkeyName[$i])
		If Not @error Then $hotkeyShow[$i] = True
	Next

	$ruptSkill = IniRead($iniFullPath, $hotkeyName[$HOTKEY_RUPT], "skill", 0)
	$ruptSlot = IniRead($iniFullPath, $hotkeyName[$HOTKEY_RUPT], "slot", 0)

	$movementXcoord = IniRead($iniFullPath, $hotkeyName[$HOTKEY_MOVEMENT], "x", 0)
	$movementYcoord = IniRead($iniFullPath, $hotkeyName[$HOTKEY_MOVEMENT], "y", 0)
EndFunc

Func hotkeyMakeGroup($Title, $index, $tip)
	If Not $hotkeyShow[$index] Then Return

	Static Local $y = 36
	Local Const $x = 10

	$hotkeyCheckbox[$index] = GUICtrlCreateCheckbox("", $x, $y + 2, 17, 17)
	GUICtrlSetTip(-1, "启用")
	GUICtrlSetOnEvent($hotkeyCheckbox[$index], "hotkeyToggleActive")
	If $hotkeyActive[$index] Then GUICtrlSetState($hotkeyCheckbox[$index], $GUI_CHECKED)

	if $Title <> "瞄准" then
		GUICtrlCreateLabel($Title, $x + 20, $y+3, 80, 20)
		GUICtrlSetFont(-1, 9.5)
		GUICtrlSetTip(-1, $tip)
	else
		GUICtrlCreateLabel($Title, $x + 20, $y+3, 30, 20)
		GUICtrlSetFont(-1, 9.5)
		GUICtrlSetTip(-1, $tip)
	endif

	if $Title == "瞄准" then
		$targetIDinput = GUICtrlCreateInput(IniRead($iniFullPath, "targetModelID", "ID", "-1"), $x+52, $y, 50, 20)
		GUICtrlSetColor ($targetIDinput, $COLOR_BLACK)
		GUICtrlSetTip(-1, "输入目标型号，-1以瞄准最近的友军")
	endif

	$hotkeyInput[$index] = MyGuiCtrlCreateButton("", $x + 110, $y, 64, 20)
	GUICtrlSetTip(-1, "点击选择快键")
	GUICtrlSetOnEvent($hotkeyInput[$index], "setHotkey")
	GUICtrlSetData($hotkeyInput[$index], IniRead($keysIniFullPath, "idToKey", $hotkeyKey[$index], ""))

	GuiCtrlCreateRect($x + 10, $y + 25, 155, 1)

	$y += 31
EndFunc

Func hotkeyBuildUI()
GUICtrlCreateTabItem("Hotkeys")

	MyGuiCtrlCreateButton("滚动鼠标轮以视界面全貌", 10, 10, 180, 17, 0xAAAAAA, 0x222222, 1)

	hotkeyMakeGroup("开箱", $HOTKEY_OPENCHEST, _
		"远程开箱")

	hotkeyMakeGroup("瞄准", $HOTKEY_TARGET, _
		"瞄准特定目标 (也适用于雷达区内尚未现身的目标)")

	hotkeyMakeGroup("验位", $HOTKEY_STUCK, _
		"发送同步指令/stuck， 呈现角色确切位置. 工具将同时密送指令, 以表明指令已发出")

	hotkeyMakeGroup("回归", $HOTKEY_RECALL, _
		"上'回归'加持; 若已上回归加持, 此键将除去回归")

	hotkeyMakeGroup("坚毅(复活)", $HOTKEY_UA, _
		"上坚毅加持; 若正在维持坚毅, 此键将除去坚毅")

	hotkeyMakeGroup("退出", $HOTKEY_RESIGN, _
		"发送退出指令/resign; 工具将同时密送指令, 以表明指令已然发出")

	hotkeyMakeGroup("提示退出", $HOTKEY_TEAMRESIGN, _
		"督促他人使用退出指令")

	hotkeyMakeGroup("复活卷", $HOTKEY_RES, _
		"使用复活卷")

	hotkeyMakeGroup("历时", $HOTKEY_AGE, _
		"显示区内滞留时间")

	hotkeyMakeGroup("耗时|提示", $HOTKEY_AGEPM, _
		"显示时间"&@CRLF& _
		"尔果内将同时显示门的状态")

	hotkeyMakeGroup("点击器开关", $HOTKEY_CLICKER, _
		"不断点击鼠标目标")

	hotkeyMakeGroup("粉石", $HOTKEY_PSTONE, _
		"使用粉石")

	hotkeyMakeGroup("彩糖", $HOTKEY_RAINBOWUSE, _
		"用绿，蓝，和红糖"&@CRLF& _
		"相应效应下，不会重复使用/浪费")

	hotkeyMakeGroup("瞄准'波'", $HOTKEY_GHOSTTARGET, _
		"瞄准盒中魂所开出的'波'"&@CRLF& _
		"可对'波'使用适用于队友的技能")

	hotkeyMakeGroup("盒中魂", $HOTKEY_GHOSTPOP, _
		"使用盒中魂")

	hotkeyMakeGroup("骑士召唤石", $HOTKEY_GSTONEPOP, _
		"用骑士召唤石")

	hotkeyMakeGroup("夏尔召唤石", $HOTKEY_LEGIOPOP, _
		"用夏尔召唤石")

	hotkeyMakeGroup("前往坐标", $HOTKEY_MOVEMENT, _
		"走向坐标位置"&@CRLF& _
		"需在辅助文件1\'激战助手.ini'或'hotkeys.au3'内预设坐标")

	hotkeyMakeGroup("打断", $HOTKEY_RUPT, _
		"用某预设的技能 打断 某预设的技能" & @CRLF & _
		"需在辅助文件1\'激战助手.ini'或'hotkeys.au3'内预设技能位置和技能号")

	hotkeyMakeGroup("抛钱(循环)", $HOTKEY_DROPCOINS, _
		"每400毫秒向抛1g")

	hotkeyMakeGroup("抛钱", $HOTKEY_DROP1COIN, _
		"抛1g")

	hotkeyMakeGroup("拾起", $HOTKEY_LOOTER, _
		"捡起附近属于角色的物品")

	hotkeyMakeGroup("鉴定", $HOTKEY_IDENTIFIER, _
		"鉴定包内物品")

	hotkeyMakeGroup("成像", $HOTKEY_HIDEGW, _
		"停止激战及工具成像,"&@CRLF& _
		"可用右下角工具图标复原")

	hotkeyMakeGroup("切换", $HOTKEY_FOCUS, _
		"交替突显(置前)激战/工具窗口")
EndFunc

Func hotkeyMainLoop($hDLL)
	Local $pressed

	For $i = 0 To $hotkeyCount-1
		If $hotkeyActive[$i] Then
			$pressed = _IsPressed($hotkeyKey[$i], $hDLL)
			If (Not $hotkeyPressed[$i]) And $pressed Then
				$hotkeyPressed[$i] = True
				Call($hotkeyAction[$i])
			ElseIf $hotkeyPressed[$i] And (Not $pressed) Then
				$hotkeyPressed[$i] = False
			EndIf
		EndIf
	Next

	If $ruptActive And GetMapLoading()==$INSTANCETYPE_EXPLORABLE And (Not GetIsDead(-2)) Then
		Local $lTgt = GetAgentByID(-1)
		Local $skill = DllStructGetData($lTgt, "Skill")
		If $skill == $ruptSkill And (DllStructGetData(GetSkillBar(), "Recharge" & $ruptSlot)==0) Then
			UseSkill($ruptSlot, -1)
			pingSleep()
		EndIf
	EndIf

	If $clickerToggle Then
		For $i=1 To 10
			MouseClick("left")
		Next
	EndIf

	If $dropCoinToggle And GetMapLoading()==$INSTANCETYPE_EXPLORABLE And (Not GetIsDead(-2)) Then
		If TimerDiff($dropCoinTimer) > 400 Then
			DropGold(1)
			$dropCoinTimer = TimerInit()
		EndIf
	EndIf
EndFunc

Func isGwOnTop()
	Return WinActive($gwHWND) Or WinActive($mainGui) Or WinActive($dummyGui)
EndFunc

Func actionstuck()
	If GetMapLoading() == $INSTANCETYPE_LOADING Then Return
	If Not isGwOnTop() Then Return

	SendChat("stuck", "/")
	WriteChat("/stuck", "激战助手")
EndFunc

Func actionrecall()
	If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return
	If Not isGwOnTop() Then Return

	Local $hasRecall = GetIsTargetBuffed($SKILL_ID_RECALL, -2)
	If $hasRecall Then
		DropBuff($SKILL_ID_RECALL, -2)
	Else
		Local $skillBar = getSkillBar()
		Local $skillNo = getSkillPosition($SKILL_ID_RECALL, $skillBar)
		If $skillNo > 0 And DllStructGetData($skillBar, "Recharge" & $skillNo) == 0 Then
			useSkill($skillNo, -1)
		EndIf
	EndIf
EndFunc

Func actionua()
	If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return
	If Not isGwOnTop() Then Return

	Local $hasUA = GetIsTargetBuffed($SKILL_ID_UA, -2)
	If $hasUA Then
		DropBuff($SKILL_ID_UA, -2)
	Else
		Local $skillBar = getSkillBar()
		Local $skillNo = getSkillPosition($SKILL_ID_UA, $skillBar)
		If $skillNo > 0 And DllStructGetData($skillBar, "Recharge" & $skillNo) == 0 Then
			useSkill($skillNo, -1)
		EndIf
	EndIf
EndFunc

Func actionhidegw()
	WinSetState($gwHWND, "", @SW_HIDE)
	GUISetState(@SW_HIDE, $mainGui)
	GUISetState(@SW_HIDE, $dummyGui)
	Opt("TrayIconHide", False)
	Opt("GUIOnEventMode", False)

	Local $restore = TrayCreateItem("还原助手界面")
	TrayCreateItem("")
	Local $close = TrayCreateItem("关闭激战和野队激战助手")

	TraySetState()

	Local $hDLL = DllOpen("user32.dll")

	While 1
		Local $msg = TrayGetMsg()
		Local $pressed = _IsPressed($hotkeyKey[$HOTKEY_HIDEGW], $hDLL)
		If ($hotkeyActive[$HOTKEY_HIDEGW] And $pressed) Or $msg = $restore Then
			If $pressed Then
				While _IsPressed($hotkeyKey[$HOTKEY_HIDEGW], $hDLL)
					Sleep(10)
				WEnd
			EndIf

			WinSetState($gwHWND, "", @SW_SHOW)
			GUISetState(@SW_SHOW, $mainGui)
			GUISetState(@SW_SHOW, $dummyGui)
			Opt("TrayIconHide", True)
			Opt("GUIOnEventMode", True)
			Return

		ElseIf $msg = $close Then
			WinClose($gwHWND)
			Exit
		EndIf
	WEnd
EndFunc   ;==>sendToggleHide

Func actionclicker()
	$clickerToggle = Not $clickerToggle
	If GetMapLoading()<>$INSTANCETYPE_LOADING Then WriteChat("点击器: " & ($clickerToggle ? "开" : "关"), "激战助手")
EndFunc

Func actiondrop1coin()
	If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return
	If Not isGwOnTop() Then Return
	If GetIsDead(-2) Then Return
	DropGold(1)
EndFunc

Func actiondropcoins()
	If Not isGwOnTop() Then Return
	$dropCoinToggle = Not $dropCoinToggle
	If GetMapLoading()<>$INSTANCETYPE_LOADING Then WriteChat("抛钱: " & ($dropCoinToggle ? "开" : "关"), "激战助手")
EndFunc

Func actionopenchest()
	If Not isGwOnTop() Then Return
	If GetMapLoading() == $INSTANCETYPE_LOADING Then Return
	WriteChat("正试图开箱", "激战助手")
	if GetMapLoading() == $INSTANCETYPE_EXPLORABLE then
		Local $lArr = GetAgentArray(0x200)
		For $i=1 To $lArr[0]
			if StringInStr(GetAgentName($lArr[$i]),"寶箱") > 0 or StringInStr(GetAgentName($lArr[$i]),"Locked Chest") > 0 then
				GoSignpost($lArr[$i])
				OpenChest()
				ChangeTarget($lArr[$i])
			endif
		Next
	endif
EndFunc

Func actionlockontarget()
	If Not isGwOnTop() Then Return
	If GetMapLoading() == $INSTANCETYPE_LOADING Then Return

	Local $lMe = GetAgentByID(-2)
	Local $lDistance = 10000000
	Local $lClosest = -1
	Local $lArr = GetAgentArray()
	Local $lTmp
	For $i=1 To $lArr[0]
		if GUICtrlRead($targetIDinput) == -1 then
			if DllStructGetData($lArr[$i], 'Allegiance') == 6 then
				$lTmp = GetPseudoDistance($lMe, $lArr[$i])
				If $lTmp < $lDistance Then
					$lClosest = $i
					$lDistance = $lTmp
				EndIf
			EndIf
		else
			If DllStructGetData($lArr[$i], 'PlayerNumber') == GUICtrlRead($targetIDinput) then ;And DllStructGetData($lArr[$i], 'HP') > 0 Then
				$lTmp = GetPseudoDistance($lMe, $lArr[$i])
				If $lTmp < $lDistance Then
					$lClosest = $i
					$lDistance = $lTmp
				EndIf
			EndIf
		endif
	Next
	If $lClosest > 0 Then ChangeTarget($lArr[$lClosest])
	WriteChat("已瞄准目标", "激战助手")
EndFunc

Func actionresign()
	If Not isGwOnTop() Then Return
	If GetMapLoading() == $INSTANCETYPE_LOADING Then Return
	SendChat("resign", "/")
	WriteChat("/resign", "激战助手")
EndFunc

Func actionteamresign()
	If Not isGwOnTop() Then Return
	If GetMapLoading() == $INSTANCETYPE_LOADING Then Return
	SendChat("[/resign;xx]", "#")
EndFunc

Func actionres()
	If Not isGwOnTop() Then Return
	If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return
	If Not UseItemByModelID($ITEM_ID_RES_SCROLLS) Then WriteChat("[提示] 复活卷已尽!", "激战助手")
EndFunc

Func actionage()
	If Not isGwOnTop() Then Return
	If GetMapLoading() == $INSTANCETYPE_LOADING Then Return
	SendChat("age", "/")
EndFunc

Func actionagepm()
	If Not isGwOnTop() Then Return
	If GetMapLoading() == $INSTANCETYPE_LOADING Then Return

	Local $lUptime = GetInstanceUptime()
	Local $sec = Int($lUptime/1000)
	Local $min = Int($sec/60)
	Local $msg = Int($min/60)&":"&StringFormat("%02d", Mod($min, 60))&":"&StringFormat("%02d", Mod($sec, 60))
	If GetMapID() == $MAP_ID_URGOZ And GetMapLoading()==$INSTANCETYPE_EXPLORABLE Then
		Local $temp = Mod($sec, 25)
		If $temp < 1 Then
			$msg &= " - 门: 关闭" & " - 0 秒后开启"
		ElseIf $temp < 16 Then
			$msg &= " - 门: 开启" & " - "&(15-$temp)&" 秒后关闭"
		Else
			$msg &= " - 门: 关闭" & " - "&(25-$temp)&" 秒后开启"
		EndIf
	EndIf
	WriteChat($msg, "激战助手")
EndFunc

Func actionpstone()
	If Not isGwOnTop() Then Return
	If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return
	If Not UseItemByModelID($ITEM_ID_POWERSTONE) Then WriteChat("[提示] 粉石已尽!", "激战助手")
EndFunc

Func actionfocus()
	If WinActive($gwHWND) Then
		WinActivate($mainGui)
	Else
		WinActivate($gwHWND)
	EndIf
EndFunc

Func actionlooter()
	If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return
	If Not isGwOnTop() Then Return

	Local $lMe = GetAgentByID(-2)
	Local $lItemArray[1] = [0]
	Local $lAgentArray = GetAgentArray(0x400)

	For $i=1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], "Owner")==0 Or DllStructGetData($lAgentArray[$i], "Owner")==GetMyID() Then
			If GetDistance($lAgentArray[$i], $lMe) < $RANGE_AREA Then
				$lItemArray[0] += 1
				ReDim $lItemArray[$lItemArray[0]+1]
				$lItemArray[$lItemArray[0]] = $lAgentArray[$i]
			EndIf
		EndIf
	Next

	Local $lPseudoDistance, $lOtherPseudoDistance
	Local $lClosestItemIndex
	Local $lClosestItem
	Local $lItemID
	Local $lDeadlock
	While ($lItemArray[0] > 0)

;~ 		1. Choose the closest item
		$lMe = GetAgentByID(-2)
		$lPseudoDistance = $RANGE_AREA ^ 2
		For $i=1 To $lItemArray[0]
			$lOtherPseudoDistance = GetPseudoDistance($lItemArray[$i], $lMe)
			If $lOtherPseudoDistance < $lPseudoDistance Then
				$lPseudoDistance = $lOtherPseudoDistance
				$lClosestItemIndex = $i
			EndIf
		Next

;~ 		2. remove item from list
		$lClosestItem = __ArrayDelete($lItemArray, $lClosestItemIndex)

;~ 		2. Pick up the item
		$lItemID = DllStructGetData($lClosestItem, "ID")
		If GetAgentExists($lItemID) Then SendPacket(0xC, $PickUpItemHeader, $lItemID, 0)

;~ 		3. Wait until the item has been picked up.
		$lDeadlock = TimerInit()
		While GetAgentExists($lItemID)
			Sleep(50)
			If TimerDiff($lDeadlock) > 2500 Then Return
		WEnd
	WEnd
EndFunc

Func actionidentifier()
	Local $lBag, $lItem

	For $lBagNo = 1 To 4
		$lBag = GetBag($lBagNo)
		For $i = 1 To DllStructGetData($lBag, 'Slots')
			$lItem = GetItemBySlot($lBagNo, $i)
			If DllStructGetData($lItem, 'ModelID') == 0 Then ContinueLoop
			If DllStructGetData($lItem, 'ID') == 0 Then ContinueLoop

			If FindIDKit() == 0 Then
				WriteChat("[提示] 鉴定器已尽!", "激战助手")
				Return
			EndIf

			IdentifyItem($lItem)
			Sleep(GetPing())
		Next
		Sleep(50)
	Next
EndFunc

Func actionghostpop()
	If Not isGwOnTop() Then Return
	If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return
	If Not UseItemByModelID($MODELID_GHOST_IN_THE_BOX) Then WriteChat("[提示] 盒中魂已尽!", "激战助手")
EndFunc

Func actionghosttarget()
	If Not isGwOnTop() Then Return
	If GetMapLoading() == $INSTANCETYPE_LOADING Then Return

	Local $lMe = GetAgentByID(-2)
	Local $lDistance = 10000000
	Local $lClosest = -1
	Local $lArr = GetAgentArray(0xDB)
	Local $lTmp
	For $i=1 To $lArr[0]
		If DllStructGetData($lArr[$i], 'PlayerNumber') == $MODELID_BOO And DllStructGetData($lArr[$i], 'HP') > 0 Then
			$lTmp = GetPseudoDistance($lMe, $lArr[$i])
			If $lTmp < $lDistance Then
				$lClosest = $i
				$lDistance = $lTmp
			EndIf
		EndIf
	Next
	If $lClosest > 0 Then ChangeTarget($lArr[$lClosest])
EndFunc

Func actiongstonepop()
	If Not isGwOnTop() Then Return
	If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return
	If Not UseItemByModelID($MODELID_GSTONE) Then WriteChat("[提示] 骑士召唤石已尽!", "激战助手")
EndFunc

Func actionlegiopop()
	If Not isGwOnTop() Then Return
	If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return
	If Not UseItemByModelID($MODELID_LEGIONNAIRE_STONE) Then WriteChat("[提示] 夏尔召唤石已尽!", "激战助手")
EndFunc

Func actionrainbowpop()
	If Not isGwOnTop() Then Return
	If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return

	Local $effectStructRed = GetEffect($EFFECT_REDROCK)
	If DllStructGetData($effectStructRed, "SkillID") == 0 Then
		If Not UseItemByModelID($ITEM_ID_RRC) Then
			WriteChat("[提示] 红糖已尽!", "激战助手")
		EndIf
	EndIf

	Local $effectStructBlue = GetEffect($EFFECT_BLUEROCK)
	If DllStructGetData($effectStructBlue, "SkillID") == 0 Then
		If Not UseItemByModelID($ITEM_ID_BRC) Then
			WriteChat("[提示] 蓝糖已尽!", "激战助手")
		EndIf
	EndIf

	Local $effectStructGreen = GetEffect($EFFECT_GREENROCK)
	If DllStructGetData($effectStructGreen, "SkillID") == 0 Then
		If Not UseItemByModelID($ITEM_ID_GRC) Then
			WriteChat("[提示] 绿糖已尽!", "激战助手")
		EndIf
	EndIf
EndFunc

Func actionrupt()
	If Not isGwOnTop() Then Return
	$ruptActive = Not $ruptActive
	If GetMapLoading()<>$INSTANCETYPE_LOADING Then WriteChat("打断功能: " & ($ruptActive ? "开" : "关"), "激战助手")
EndFunc

Func actionmovement()
	If Not isGwOnTop() Then Return
	If GetMapLoading() == $INSTANCETYPE_LOADING Then Return
	If $movementXcoord == 0 And $movementYcoord == 0 Then Return

	Move($movementXcoord, $movementYcoord, 5)
	WriteChat("前往坐标功能已启动", "激战助手")
EndFunc


Func __ArrayDelete(ByRef $aArray, $iElement)
	If $iElement < 1 Then Return
	If $iElement > $aArray[0] Then Return
	Local $ret = $aArray[$iElement]
	For $i = $iElement To $aArray[0]-1
		$aArray[$i] = $aArray[$i+1]
	Next
	ReDim $aArray[$aArray[0]]
	$aArray[0] -= 1
	Return $ret
EndFunc


Func hotkeyToggleActive()
	For $i = 0 To $hotkeyCount-1
		If @GUI_CtrlId == $hotkeyCheckbox[$i] Then
			Local $active = (GUICtrlRead(@GUI_CtrlId) == $GUI_CHECKED)
			$hotkeyActive[$i] = $active
			IniWrite($iniFullPath, $hotkeyName[$i], "active", $active)
			IniWrite($iniFullPath, "targetModelID", "ID", GUICtrlRead($targetIDinput))
			Return
		EndIf
	Next
	MyGuiMsgBox(0, "hotkeyToggleActive", "未落实操作!")
EndFunc




