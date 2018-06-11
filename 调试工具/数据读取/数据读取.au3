#include <ListviewConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <Array.au3>
#include <GuiEdit.au3>
#include <Constants.au3>
#include <Misc.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include "../../激战接口.au3"

$math_pi = 3.1415926535897932384626

$aCharName = GetParam("角色名")

If $aCharName= "" Then
	If Not Initialize(WinGetProcess("Guild Wars"), True, True, False) Then
		MsgBox(0, "失败", "未打开激战.")
		Exit
	EndIf
Else
	If Not Initialize($aCharName, True, True, False) Then
		MsgBox(0, "失败", "找不到角色.")
		Exit
	EndIf
EndIf

Const $gWindowTitle = "激战自动化助手"
Opt("GUICoordMode", 0)

$gGUI = GUICreate($gWindowTitle, 570, 650)
$gCredits = GuiCtrlCreateLabel("             (卡时或需重启工具, 不可完成的指令或使角色退出或重启)", 100, 8, 450, 20)
;GUICtrlSetColor(-1, 0x0000CD)
GUICtrlSetFont(-1, 7.5, 300, 0, "Arial")

$gMainMenu = GUICtrlCreateMenu("功能")
	$gExitMenu = GUICtrlCreateMenuItem("退出", $gMainMenu)

$gOthersMenu = GUICtrlCreateMenu("其他功能")
	$gGetSkillBar = GUICtrlCreateMenuItem("显示现有技能号码", $gOthersMenu)
	$gGetEffects = GUICtrlCreateMenuItem("显示效应", $gOthersMenu)
;	$gDummyVariable = GUICtrlCreateMenuItem("Tormiasz, GameRevision,  kaps1500", $gOthersMenu)

$gCharInfoGroup = GUICtrlCreateGroup("角色数据", -92, 20, 161, 113)
	$gName = GUICtrlCreateLabel("角色名称: X", 8, 20, 141, 19)
	$gID = GUICtrlCreateLabel("号码: X", 0, 15, 140, 19)

	$gCurrentTarGet = GUICtrlCreateLabel("现有目标号: X", 0, 15, 133, 19)

	$gChanGetarGet = GUICtrlCreateButton("更换目标", 8, 20, 81, 21, 0)
	$gAttack = GUICtrlCreateButton("攻击", 80, 0, 41, 21, $WS_GROUP)


$gMapInfoGroup = GUICtrlCreateGroup("所在地数据", 80, -65, 201, 113)
	$gMapID = GUICtrlCreateLabel("地图号码: X", 8, 15, 125, 21) ;125 was about 80 for this and the next two
	$gRegion = GUICtrlCreateLabel("地区(洲)号: X", 0, 15, 125, 21)
	$gLang = GUICtrlCreateLabel("语言号: X", 0, 15, 125, 21)
	$gMapLoading = GUICtrlCreateLabel("地图：正载入: X", 0, 30, 120, 21);120 was 103
	$gMapIsLoaded = GUICtrlCreateLabel("地图:已载入 X", 0, 15, 120, 21);120 was 82
	$gInitMapLoading = GUICtrlCreateButton("归零", 100, 0, 58, 20, 0); 100 was 88, 58 was 89
;	$gTravelTo = GUICtrlCreateButton("TravelTo", 34, -75, 62, 21, $WS_GROUP);34 was 28
;	$gZoneMap = GUICtrlCreateButton("ZoneMap", 0, 20, 62, 21, $WS_GROUP)
	$gMoveMap = GUICtrlCreateButton("换图", 34, -75, 48, 21, $WS_GROUP) ;(34, -75, 62) was (0,20,62)


$gPositionGroup = GUICtrlCreateGroup("所在坐标", 81, -15, 153, 113) ;80 was 100, -15 was -55
	$gX = GUICtrlCreateLabel("X: X", 8, 20, 112, 21)
	$gY = GUICtrlCreateLabel("Y: X", 0, 20, 128, 21)
	$gRotation = GUICtrlCreateLabel("面向: X", 0, 25, 121, 21)
	$gMove = GUICtrlCreateButton("前往坐标", 0, 25, 70, 21, $WS_GROUP);70was49
	$gGetCoords = GUICtrlCreateButton("复制坐标", 71, 0, 70, 21, $WS_GROUP) ;71was50, 70 was 81


$gParameterlessGroup = GUICtrlCreateGroup('无需参数指令', -478, 30, 265, 135) ;-478was -458
	$gTravelGH = GUICtrlCreateButton("前往公会大厅", 8, 22, 121, 21, 0)
	$gLeaveGH = GUICtrlCreateButton("离开公会大厅", 0, 22, 121, 21, 0)
;	$gEnterChallenge = GUICtrlCreateButton("进入挑战任务", 0, 22, 121, 21, 0)
;	$gEnterChallengeForeign = GUICtrlCreateButton("进入挑战任务(异国)", 0, 22, 135, 21, 0)
;	$gReturnToOutpost = GUICtrlCreateButton("回城", 0, 22, 121, 21, $WS_GROUP)
	$gCancelAction = GUICtrlCreateButton("取消操作", 128, -22, 121, 21, $WS_GROUP);-22was-88
	$gLeaveGroup = GUICtrlCreateButton("离开小组", 0, 22, 121, 21, $WS_GROUP)
	$gSkipSinematic = GUICtrlCreateButton("越过任务动画", 0, 22, 121, 21, $WS_GROUP)


$gOtherInfoGroup = GUICtrlCreateGroup("其他数据", 140, -66, 193, 135)
	$gGoldChar = GUICtrlCreateLabel("随身现金值: X", 8, 20, 151, 21)
	$gGoldStorage = GUICtrlCreateLabel("储存箱内现金值: X", 0, 20, 167, 21)
	$gPing = GUICtrlCreateLabel("延迟: X", 0, 20, 158, 21)
	$gDepositGold = GUICtrlCreateButton("储存现金", -3, 23, 81, 21, $WS_GROUP)
	$gWithdrawGold = GUICtrlCreateButton("抽取现金", 1, 23, 81, 21, $WS_GROUP)
	$gDropGold = GUICtrlCreateButton("扔下现金", 88, -12, 89, 21, $WS_GROUP)


$gParameterGroup = GUICtrlCreateGroup("需参数指令", -370, 50, 449, 145)
	$gUseSkill = GUICtrlCreateButton("用技能", 8, 20, 137, 21, 0)
	$gChangeSecProf = GUICtrlCreateButton("换副职业", 144, 0, 137, 21, $WS_GROUP)
	$gSetSkill = GUICtrlCreateButton("更换技能表", 144, 0, 137, 21, $WS_GROUP)

	$gGoNPC = GUICtrlCreateButton("走向游戏人物", -288, 20, 137, 21, $WS_GROUP)
	$gGoPlayer = GUICtrlCreateButton("走向他人", 144, 0, 137, 21, $WS_GROUP)
	$gGoSignpost = GUICtrlCreateButton("走向指示牌", 144, 0, 137, 21, $WS_GROUP)

	$gAcceptQuest = GUICtrlCreateButton("接受任务", -288, 20, 137, 21, $WS_GROUP)
	$gAbandonQuest = GUICtrlCreateButton("放弃任务", 144, 0, 137, 21, $WS_GROUP)
	$gQuestReward = GUICtrlCreateButton("任务奖励", 144, 0, 137, 21, $WS_GROUP)

	$gAddHero = GUICtrlCreateButton("加英雄", -288, 20, 137, 21, $WS_GROUP)
	$gCommandHero = GUICtrlCreateButton("命令英雄", 144, 0, 137, 21, $WS_GROUP)
	$gKickHero = GUICtrlCreateButton("踢英雄", 144, 0, 137, 21, $WS_GROUP)

	$gDialog = GUICtrlCreateButton("打开对话窗口", -288, 20, 137, 21, $WS_GROUP)
	$gAddNPC = GUICtrlCreateButton("加游戏人物", 144, 0, 137, 21, $WS_GROUP)
	$gKickNPC = GUICtrlCreateButton("踢游戏人物", 144, 0, 137, 21, $WS_GROUP)

	$gSwitchMode = GUICtrlCreateButton("更换模式", -288, 20, 137, 21, $WS_GROUP)
	$gCommandAll = GUICtrlCreateButton("控制全队", 144, 0, 137, 21, $WS_GROUP)
	$gChangeWeaponSet = GUICtrlCreateButton("更换武器组", 144, 0, 137, 21, 0)

$gOptionsGroup = GUICtrlCreateGroup("选择", 165, -120, 85, 81)
	$gOnTopCheckbox = GUICtrlCreateCheckbox("置前", 8, 20, 73, 21)
	$gHideGW = GUICtrlCreateCheckbox("不成像", 0, 25, 73, 21)


$gItemGroup = GUICtrlCreateGroup("货物指令", -469, 120, 449, 65)
	$gPickUpItem = GUICtrlCreateButton("捡起", 8, 20, 105, 21, $WS_GROUP)
	$gMoveItem = GUICtrlCreateButton("移动", 110, 0, 105, 21, $WS_GROUP)
	$gSellItem = GUICtrlCreateButton("卖", 110, 0, 105, 21, $WS_GROUP)
	$gIdentifyItem = GUICtrlCreateButton("鉴定", 110, 0, 105, 21, $WS_GROUP)
	$gSalvageItem = GUICtrlCreateButton("拆解", -330, 20, 105, 21, $WS_GROUP)
	$gUseItem = GUICtrlCreateButton("使用", 110, 0, 105, 21, $WS_GROUP)
	$gEquipItem = GUICtrlCreateButton("穿戴", 110, 0, 105, 21, $WS_GROUP)
	$gDropItem = GUICtrlCreateButton("扔", 110, 0, 105, 21, $WS_GROUP)


$gStructsGroup = GUICtrlCreateGroup("数据采集", -338, 40, 449, 65)
	$gCurrentTarGetButton = GUICtrlCreateButton("现有目标数据", 8, 20, 105, 21, $WS_GROUP)
	$gAllAgentsInfo = GUICtrlCreateButton("区内人员数据", 110, 0, 105, 21, $WS_GROUP)
	$gAllBagsInfo = GUICtrlCreateButton("所有物品数据", 110, 0, 105, 21, $WS_GROUP)
	$gSkillByIDInfo = GUICtrlCreateButton("技能数据", 110, 0, 105, 21, $WS_GROUP)

AdLibRegister("Refresh", 1000)
GUISetState(@SW_SHOW)
OnAutoItExitRegister("DeveloperShutdown")

While 1
	$gMSG = GUIGetMsg()
	Switch $gMSG
		Case $GUI_EVENT_CLOSE
			Exit
		Case $gExitMenu
			Exit
		Case $gGetSkillBar
			$gSkillBar = ""
			For $i = 1 To 8
				$SkillID = DllStructGetData(GetSkillbar(), "Id" & $i)
				$gSkillBar = $gSkillBar & StringFormat("技能 %d 的号码: %s", $i, $SkillID) & @CRLF
			Next
			MsgBox(0, $gWindowTitle, $gSkillBar)
		Case $gGetEffects
			$gEfffects = ""
			$EffectArray = GetEffect()
			For $i = 1 To $EffectArray[0]
				$EffectID = DllStructGetData($EffectArray[$i], 'SkillID')
				$gEfffects = $gEfffects & StringFormat("效应 %d 的号码: %s", $i, $EffectID) & @CRLF
			Next
			MsgBox(0, $gWindowTitle, $gEfffects)
		Case $gInitMapLoading
			InitMapLoad()
		Case $gGetCoords
			$cbcontent = StringFormat("%s, %s", StringReplace(GUICtrlRead($gX), "X: ", ""), StringReplace(GUICtrlRead($gY), "Y: ", ""))
			_TooltipMouseExit(StringFormat("已把 '%s' 发送到剪贴板.", $cbcontent), 2000)
			ClipPut($cbcontent)
		Case $gTravelGH
			TravelGH()
		Case $gLeaveGH
			LeaveGH()
	;	Case $gEnterChallenge
	;		EnterChallenge()
	;	Case $gEnterChallengeForeign
	;		EnterChallengeForeign()
		Case $gMove
			Move(GetParam("X 坐标"), GetParam("Y 坐标"))
		Case $gChanGetarGet
			ChanGetarGet(GetParam("新目标 号码"))
		Case $gChangeWeaponSet
			Changeweaponset(GetParam("武器搭配栏号 [1-4]"))
		Case $gUseSkill
			UseSkill(GetParam("现有技能表里的位置 [1-8]"), GetParam("目标号码 [-2 => 自己]"))
		Case $gMoveItem
			MoveItem(GetParam("物品 号"), GetParam("包号"), GetParam("新位置"))
		Case $gGoPlayer
			GoPlayer(GetParam("目标号码"))
		Case $gGoNPC
			GoNPC(GetParam("目标号码"))
		Case $gAbandonQuest
			AbandonQuest(GetParam("任务 ID号码"))
		Case $gMoveMap
			MoveMap(GetParam("地图号码"), GetParam("地区(洲）号"), GetParam("子地区号, 如1, 2, 3, 4..., 子区号最低为1"), GetParam("语言号"))
		Case $gAttack
			Attack(GetParam("目标号码"))
	;	Case $gZoneMap
	;		ZoneMap(GetParam("地图 ID号码"), GetParam("子地区号, 如1, 2, 3, 4..., 子区号最低为1"))
		Case $gCancelAction
			CancelAction()
		Case $gDialog
			Dialog(GetParam("对话窗口ID号码"))
		Case $gSalvageItem
			StartSalvage(GetParam("物品 ID号"))
		Case $gIdentifyItem
			IdentifyItem(GetParam("物品 ID"))
		Case $gSellItem
			SellItem(GetParam("物品 ID"))
		Case $gAcceptQuest
			AcceptQuest(GetParam("任务 ID号码"))
	;	Case $gTravelTo
	;		TravelTo(GetParam("地图 ID号码"), GetParam("子地区, 如1, 2, 3, 4..., 子区号最低为1"))
		Case $gEquipItem
			EquipItem(GetParam("物品 ID"))
		Case $gUseItem
			UseItem(GetParam("物品 ID"))
		Case $gPickUpItem
			PickupItem(GetParam("物品 ID"))
		Case $gDropItem
			DropItem(GetParam("物品 ID"), GetParam("物品 ID [0]"))
		Case $gAddHero
			AddHero(GetParam("英雄 ID号码"))
		Case $gKickHero
			KickHero(GetParam("英雄 ID号码"))
		Case $gAddNPC
			AddNPC(GetParam("NPC ID号码"))
		Case $gKickNPC
			KickNPC(GetParam("NPC ID号码"))
		Case $gCommandHero
			CommandHero(GetParam("英雄 人物号"), GetParam("X 坐标"), GetParam("Y 坐标"))
		Case $gCommandAll
			CommandAll(GetParam("X 坐标"), GetParam("Y 坐标"))
		Case $gGoSignpost
			GoSignpost(GetParam("指示牌 人物号"))
		Case $gSetSkill
			SetSkillbarSkill(GetParam("现有技能表里的位置 [1-8]"), GetParam("技能 ID号码"))
	;	Case $gReturnToOutpost
	;		ReturnToOutpost()
		Case $gSkipSinematic
			SkipCinematic()
		Case $gLeaveGroup
			LeaveGroup()
		Case $gChangeSecProf
			ChangeSecondProfession(GetParam("职业 ID号码"))
		Case $gSwitchMode
			SwitchMode(GetParam("正常模式 => 0 || 困难模式 => 1"))
		Case $gDropGold
			DropGold(GetParam("数量"))
		Case $gDepositGold
			DepositGold(GetParam("数量"))
		Case $gWithdrawGold
			WithdrawGold(GetParam("数量"))
		Case $gQuestReward
			QuestReward(GetParam("任务 ID号码"))
		Case $gOnTopCheckbox
				If GUICtrlRead($gOnTopCheckbox) = 1 Then
					WinSetOnTop($gWindowTitle, "", 1)
				Else
					WinSetOnTop($gWindowTitle, "", 0)
				EndIf
		Case $gHideGW
			If GUICtrlRead($gHideGW) = 1 Then WinSetState(GetWindowHandle(), "", @SW_HIDE)
			If GUICtrlRead($gHideGW) = 4 Then
				WinSetState(GetWindowHandle(), "", @SW_SHOW)
				WinSetOnTop($gWindowTitle, "", 1)
				If GUICtrlRead($gOnTopCheckbox) <> 1 Then WinSetOnTop($gWindowTitle, "", 0)
			EndIf
		Case $gCurrentTarGetButton
			Local $gAgentInfo_row[1], $agentcount = 0
			GUISetState(@SW_DISABLE, $gGUI)
			Opt("GuiOnEventMode", 1)
			$gAgentInfoGUI = GUICreate("人物数据", 850, 70) ;agent info  , type=类别
			$gAgentInfo = GUICtrlCreateListView("人物|人物号|型号|坐标|距离|类别|类别2|组|效忠于|效应|咒|职业|等级|血|武器|面向|目标", 0, 0, 850, 70, -1)
			GUICtrlSetOnEvent(-1, "BoxEventHandler")
			_GUICtrlListView_RegisterSortCallBack($gAgentInfo)
			_GUICtrlListView_DeleteAllItems($gAgentInfo)
			$aAgent = GetAgentByID(-1)
			AgentTable($aAgent)
			GUISetState()
			GUISetOnEvent($GUI_EVENT_CLOSE, "BoxEventHandler", $gAgentInfoGUI)
		Case $gAllAgentsInfo
			Local $gAgentInfo_row[1], $agentcount = 0
			GUISetState(@SW_DISABLE, $gGUI)
			Opt("GuiOnEventMode", 1)
			$gAgentInfoGUI = GUICreate("人物数据", 850, 250) ;agent info , type=类别
			$gAgentInfo = GUICtrlCreateListView("人物|人物号|型号|坐标|距离|类别|类别2|组|效忠于|效应|咒|职业|等级|血|武器|面向|目标", 0, 0, 850, 250, -1)
			GUICtrlSetOnEvent(-1, "BoxEventHandler")
			_GUICtrlListView_RegisterSortCallBack($gAgentInfo)
			_GUICtrlListView_DeleteAllItems($gAgentInfo)
			GUISetState()
			GUISetOnEvent($GUI_EVENT_CLOSE, "BoxEventHandler", $gAgentInfoGUI)
			;msgbox(0,"test","here")
			$lAgentArray = GetAgentArray() ;Creating agent's struct
			;msgbox(0,"test","here2")
			If $lAgentArray[0] < 1 Then ContinueLoop
			For $i = 1 To $lAgentArray[0] ;Loop around all agent's
				$aAgent = $lAgentArray[$i]
				AgentTable($aAgent)
			Next
		Case $gAllBagsInfo
			ItemsTable()
		Case $gSkillByIDInfo
			SkillTable(GetParam("技能 ID号"))
	EndSwitch
Wend

Func SkillTable($SkillID)
$aSkill = GetSkillByID($SkillID)
$aSkillID = $SkillID
$aCampaign = DllStructGetData($aSkill, 'Campaign')
$aType = DllStructGetData($aSkill, 'Type')
$aSpecial = DllStructGetData($aSkill, 'Special')
$aComboReq = DllStructGetData($aSkill, 'ComboReq')
$aEffect1 = DllStructGetData($aSkill, 'Effect1')
$aCondition = DllStructGetData($aSkill, 'Condition')
$aEffect2 = DllStructGetData($aSkill, 'Effect2')
$aWeaponReq = DllStructGetData($aSkill, 'WeaponReq')
$aProfession = DllStructGetData($aSkill, 'Profession')
$aAttribute = DllStructGetData($aSkill, 'Attribute')
$aPvPID  = DllStructGetData($aSkill, 'PvPID')
$aCombo = DllStructGetData($aSkill, 'Combo')
$aTarget = DllStructGetData($aSkill, 'Target')
$aEquipType = DllStructGetData($aSkill, '')
$aAdrenaline = DllStructGetData($aSkill, 'EquipType')
$aActivation = DllStructGetData($aSkill, 'Activation')
$aAftercast = DllStructGetData($aSkill, 'Aftercast')
$aDuration0 = DllStructGetData($aSkill, 'Duration0')
$aDuration15 = DllStructGetData($aSkill, 'Duration15')
$aRecharge = DllStructGetData($aSkill, 'Recharge')
$aScale0 = DllStructGetData($aSkill, 'Scale0')
$aScale15 = DllStructGetData($aSkill, 'Scale15')
$aBonusScale0 = DllStructGetData($aSkill, 'BonusScale0')
$aBonusScale15 = DllStructGetData($aSkill, 'BonusScale15')
$aAoERange = DllStructGetData($aSkill, 'AoERange')
$aConstEffect = DllStructGetData($aSkill, 'ConstEffect')

Switch $aCampaign
	Case 0
		$aCampaign = "核心"
	Case 1
		$aCampaign = "一章"
	Case 2
		$aCampaign = "二章"
	Case 3
		$aCampaign = "三章"
	Case 4
		$aCampaign = "四章"
EndSwitch

Switch $aType
	Case 1
		$aType = "Bounty"
	Case 2
		$aType = "Scroll"
	Case 3
		$aType = "Stance"
	Case 4
		$aType = "Hex"
	Case 5
		$aType = "Spell"
	Case 6
		$aType = "Enchantment"
	Case 7
		$aType = "Signet"
	Case 8
		$aType = "Condition"
	Case 9
		$aType = "Well"
	Case 10
		$aType = "Skill"
	Case 11
		$aType = "Ward"
	Case 12
		$aType = "Glyph"
	Case 13
		$aType = "Title"
	Case 14
		$aType = "Attack"
	Case 15
		$aType = "Shout"
	Case 16
		$aType = "Skill2"
	Case 17
		$aType = "Passive"
	Case 18
		$aType = "Environmental"
	Case 19
		$aType = "Preparation"
	Case 20
		$aType = "Pet Attack"
	Case 21
		$aType = "Trap"
	Case 22
		$aType = "Ritual"
	Case 23
		$aType = "Environmental Trap"
	Case 24
		$aType = "Item Spell"
	Case 25
		$aType = "Weapon Spell"
	Case 26
		$aType = "Form"
	Case 27
		$aType = "Chant"
	Case 28
		$aType = "Echo Refrain"
	Case 29
		$aType = "Disguise"
EndSwitch

If $aPvPID == 3396 Then $aPvPID = ""
$aProfession = GetProfession($aProfession)
$aAttribute = GetAttribute($aAttribute)

Switch $aTarget
	Case 0
		$aTarget = "Self/No Target"
	Case 1
		$aTarget = "Conditions, Charm Animal, Putrid Explosion, Spirit Targetting"
	Case 3
		$aTarget = "队友"
	Case 4
		$aTarget = "另一队友"
	Case 5
		$aTarget = "敌人"
	Case 6
		$aTarget = "死去的队友"
	Case 14
		$aTarget = "Minion"
	Case 16
		$aTarget = "Ground (AoE spells)"
EndSwitch

Switch $aCombo
	Case 1
		$aCombo = "1 - Lead Attack"
	Case 2
		$aCombo = "2 - Offhand Attack"
	Case 3
		$aCombo = "3 - Dual Attack"
EndSwitch

Switch $aAoERange
	Case 156
		$aAoERange = "156 - Adjacent"
	Case 240
		$aAoERange = "240 - Nearby"
	Case 312
		$aAoERange = "312 - Area"
	Case 1000
		$aAoERange = "1000 - Earshot"
	Case 2500
		$aAoERange = "2500 - Spirit"
	Case 5000
		$aAoERange = "5000 - Compass"
EndSwitch

GUISetState(@SW_DISABLE, $gGUI)
Opt("GuiOnEventMode", 1)
$gSkillInfoGUI = GUICreate("技能数据", 800, 80)
$gSkillInfo = GUICtrlCreateListView("技能ID|章号|类别|Special|Combo Req|Effect1|Condition|Effect2|Weapon Req|Profession|Attribute|PvP ID|Combo|Target|Equip Type|Adrenaline|Activation|AfterCast|Duration0|Duration15|Recharge|Scale0|Scale15|Bonus Scale0|Bonus Scale15|AoERange|Const Effect", 0, 0, 800, 80, -1)
GUICtrlSetOnEvent(-1, "BoxEventHandler")
_GUICtrlListView_RegisterSortCallBack($gSkillInfo)
_GUICtrlListView_DeleteAllItems($gSkillInfo)
GUISetState()
GUISetOnEvent($GUI_EVENT_CLOSE, "BoxEventHandler", $gSkillInfoGUI)

GUICtrlCreateListViewItem(""&$aSkillID&"|"&$aCampaign&"|"&$aType&"|"&$aSpecial&"|"&$aComboReq&"|"&$aEffect1&"|"&$aCondition&"|"&$aEffect2&"|"&$aWeaponReq&"|"&$aProfession&"|"&$aAttribute&"|"&$aPvPID&"|"&$aCombo&"|"&$aTarget&"|"&$aEquipType&"|"&$aAdrenaline&"|"&$aActivation&"|"&$aAftercast&"|"&$aDuration0&"|"&$aDuration15&"|"&$aRecharge&"|"&$aScale0&"|"&$aScale15&"|"&$aBonusScale0&"|"&$aBonusScale15&"|"&$aAoERange&"|"&$aConstEffect&"", $gSkillInfo)

EndFunc

Func ItemsTable()

	;msgbox(0,"getdistrict",getdistrict())

	Local $itemcount = 0
	Local $bags_names[16] = ["未名仓库1", "背包", "腰带", "袋子1", "袋子2", "武器包", "加工材料仓库", "未名仓库2", "物品仓库1", "物品仓库2", _
	"物品仓库3", "物品仓库4", "周年纪念仓", "未名仓库4"]
	;Local $bags_names[16] = ["Backpack", "Belt Pouch", "Bag 1", "Bag 2", "Equip Pack", "Storage I", "Storage II", "Storage III", "Storage IV", "Storage V", _
	;"Storage VI", "Storage VII", "Storage VIII", "Anv Storage"]
	GUISetState(@SW_DISABLE, $gGUI)
	Opt("GuiOnEventMode", 1)
	$gItemInfoGUI = GUICreate("物品数据", 600, 250)
	$gItemInfo = GUICtrlCreateListView("包:名|包:号|包内位置|序号|型号|颜色码|数量|染色|属性需求|属性|种类|数矩|铸印|组件1|组件2", 0, 0, 600, 250, -1)
	GUICtrlSetOnEvent(-1, "BoxEventHandler")
	_GUICtrlListView_RegisterSortCallBack($gItemInfo)
	_GUICtrlListView_DeleteAllItems($gItemInfo)
	GUISetState()
	GUISetOnEvent($GUI_EVENT_CLOSE, "BoxEventHandler", $gItemInfoGUI)

	For $bag = 1 To 16
		$bag_slots = DllStructGetData(GetBag($bag), 'Slots')
		For $slot = 1 to $bag_slots
			$bag_name = $bags_names[$bag]
			$item_id = ""
			$item_model_id = ""
			$item_rarity = ""
			$item_quantity = ""
			$item_color = ""
			$item_requirement = ""
			$item_attribute = ""
			$item_type = ""

			$item = GetItemBySlot($bag, $slot)
			If DllStructGetData($item, 'ID') = 0 Then ContinueLoop
			$item_id = DllStructGetData($item, 'ID')
			$item_model_id = DllStructGetData($item, 'ModelID')
			$item_rarity = GetRarity($item)
			$item_quantity = DllStructGetData($item, 'Quantity')
			If DllStructGetData($item, 'ModelID') = 146 or DllStructGetData($item, 'ModelID') = 24888 Then
				$item_color = GetColor(DllStructGetData($item, 'ExtraID'))
			Endif
			$item_requirement = GetItemReq($item)
			If DllStructGetData($item, 'ModelID') <> 146 and $item_requirement <=13 and $item_requirement <> 0 or GetItemAttribute($item) > 44 Then
				$item_attribute = GetAttribute(GetItemAttribute($item))
			else
				$item_attribute = GetItemAttribute($item)
			endif
			$item_type = DllStructGetData($item, 'Type')
			$item_ModStruct = GetModStruct($item)
			$item_insc = GetItemInscr($item)
			$item_insc = _ArrayToString($item_insc, "-")
			$item_mod1 = GetItemMod1($item)
			$item_mod1 = _ArrayToString($item_mod1, "-")
			$item_mod2 = GetItemMod2($item)
			$item_mod2 = _ArrayToString($item_mod2, "-")
			$itemcount += 1
			GUICtrlCreateListViewItem(""&$bag_name&"|"&$bag&"|"&$slot&"|"&$item_id&"|"&$item_model_id&"|"&$item_rarity&"|"&$item_quantity&"|"&$item_color&"|"&$item_requirement&"|"&$item_attribute&"|"&$item_type&"|"&$item_ModStruct&"|"&$item_insc&"|"&$item_mod1&"|"&$item_mod2&"", $gItemInfo)
		Next
	Next
EndFunc

Func AgentTable($aAgent)
	$agent_name = "Unnamed"
	$agent_id = ""
	$agent_model_id = ""
	$agent_coords = ""
	$agent_distance = ""
	$agent_type = ""
	$agent_type2 = ""
	$agent_allegiance = ""
	$agent_effects = ""
	$agent_hexes = ""
	$agent_professions = ""
	$agent_level = ""
	$agent_health = ""
	$agent_weapon = ""
	$agent_rotation = ""
	$agent_target = ""

	; Get player name
	$this_name = GetPlayerName($aAgent)
	if $this_name <> "" Then
		$agent_name = $this_name
	Else
		$agent_name = GetAgentName($aAgent)
	Endif
	$agent_id = DllStructGetData($aAgent, 'ID')
	$agent_model_id = DllStructGetData($aAgent, 'PlayerNumber')
	$agent_coords = "X: " & Round(DllStructGetData($aAgent, 'X')) & ", Y: " & Round(DllStructGetData($aAgent, 'Y')) & ", Z: " & Round(DllStructGetData($aAgent, 'Z'))
	$agent_distance = Round(GetDistance($aAgent))
	$agent_type = DllStructGetData($aAgent, 'Type')
	$agent_type2 = DllStructGetData($aAgent, 'TypeMap')
	$agent_team = DllStructGetData($aAgent, 'Team')
	$agent_allegiance = DllStructGetData($aAgent, 'Allegiance')
	$agent_effects = DllStructGetData($aAgent, 'Effects')
	$agent_hexes = DllStructGetData($aAgent, 'Hex')
	If DllStructGetData($aAgent, 'Primary') <> 0 Then $agent_professions = GetProfession(DllStructGetData($aAgent, 'Primary'))&"/"& GetProfession(DllStructGetData($aAgent, 'Secondary'))
	$agent_level = DllStructGetData($aAgent, 'Level')
	$agent_health = round(DllStructGetData($aAgent, 'HP')*100)&"%"
	$agent_weapon = GetWeapon(DllStructGetData($aAgent, 'WeaponType'))
	$agent_rotation = round(DllStructGetData($aAgent, 'Rotation') * 180 / $math_pi, 1) & "°"
	$agent_target = GetTarget($agent_id)
	$agentcount += 1
	ReDim $gAgentInfo_row[$agentcount + 1]
	$gAgentInfo_row[$agentcount] = GUICtrlCreateListViewItem(""&$agent_name&"|"&$agent_id&"|"&$agent_model_id&"|"&$agent_coords&"|"&$agent_distance&"|"&$agent_type&"|"&$agent_type2&"|"&$agent_team&"|"&$agent_allegiance&"|"&$agent_effects&"|"&$agent_hexes&"|"&$agent_professions&"|"&$agent_level&"|"&$agent_health&"|"&$agent_weapon&"|"&$agent_rotation&"|"&$agent_target&"", $gAgentInfo)
EndFunc

Func BoxEventHandler()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			GUIDelete()
			GUISetState(@SW_ENABLE, $gGUI)
			Opt("GuiOnEventMode", 0)
			WinSetOnTop($gWindowTitle, "", 1)
			If GUICtrlRead($gOnTopCheckbox) <> 1 Then WinSetOnTop($gWindowTitle, "", 0)
	EndSwitch
EndFunc

; @Func		GetProfession
; @action	Get profession abbreviation from index
; @param	$prof (int)		= profession index
; @return	string
; ------------------------------------------------------------------- ;
Func GetProfession($prof)
	$Ret = $prof
	Switch $prof
		Case 0
			$Ret = ""
		Case 1
			$Ret = "战士"
		Case 2
			$Ret = "游侠"
		Case 3
			$Ret = "僧侣"
		Case 4
			$Ret = "死灵"
		Case 5
			$Ret = "幻术"
		Case 6
			$Ret = "元素"
		Case 7
			$Ret = "暗杀"
		Case 8
			$Ret = "祭祀"
		Case 9
			$Ret = "圣言"
		Case 10
			$Ret = "神唤"
	EndSwitch
	return $Ret
EndFunc

; @Func		GetWeapon
; @action	Get Weapon abbreviation from index
; @param	$weap (int)		= weapon index
; @return	string
; ------------------------------------------------------------------- ;
Func GetWeapon($weap)
	$Ret = $weap
	Switch $weap
		Case 0
			$Ret = ""
		Case 1
			$Ret = "弓箭"
		Case 2
			$Ret = "斧"
		Case 3
			$Ret = "锤"
		Case 4
			$Ret = "匕首"
		Case 5
			$Ret = "镰刀"
		Case 6
			$Ret = "矛"
		Case 7
			$Ret = "剑"
		Case 8
			$Ret = "浊伤"
		Case 9
			$Ret = "冻伤"
		Case 10
			$Ret = "暗伤"
		Case 11
			$Ret = "土伤"
		Case 12
			$Ret = "电伤"
		Case 13
			$Ret = "火伤"
		Case 14
			$Ret = "圣伤"
	EndSwitch
	return $Ret
EndFunc

; @Func		GetColor
; @action	Get color abbreviation from index
; @param	$color (int)		= color index
; @return	string
; ------------------------------------------------------------------- ;
Func GetColor($color)
	$Ret = $color
	Switch $color
		Case 0
			$Ret = ""
		Case 1
			$Ret = ""
		Case 2
			$Ret = "蓝"
		Case 3
			$Ret = "绿"
		Case 4
			$Ret = "紫"
		Case 5
			$Ret = "红"
		Case 6
			$Ret = "黄"
		Case 7
			$Ret = "棕"
		Case 8
			$Ret = "橘"
		Case 9
			$Ret = "银"
		Case 10
			$Ret = "黑"
		Case 12
			$Ret = "白"
		Case 13
			$Ret = "粉红"
	EndSwitch
	return $Ret
EndFunc


Func GetAttribute($attr)
	$Ret = $attr
	Switch $attr
		Case 0
			$Ret = "快速施法"
		Case 1
			$Ret = "幻术魔法"
		Case 2
			$Ret = "支配魔法"
		Case 3
			$Ret = "灵感魔法"
		Case 4
			$Ret = "血魔法"
		Case 5
			$Ret = "死亡魔法"
		Case 6
			$Ret = "灵魂吸取"
		Case 7
			$Ret = "诅咒"
		Case 8
			$Ret = "风系魔法"
		Case 9
			$Ret = "地系魔法"
		Case 10
			$Ret = "火系魔法"
		Case 11
			$Ret = "水系魔法"
		Case 12
			$Ret = "能量储存"
		Case 13
			$Ret = "治疗"
		Case 14
			$Ret = "惩戒"
		Case 15
			$Ret = "防护"
		Case 16
			$Ret = "神恩"
		Case 17
			$Ret = "力量"
		Case 18
			$Ret = "斧术"
		Case 19
			$Ret = "锤术"
		Case 20
			$Ret = "剑术"
		Case 21
			$Ret = "战术"
		Case 22
			$Ret = "野兽术"
		Case 23
			$Ret = "专精"
		Case 24
			$Ret = "求生"
		Case 25
			$Ret = "弓术"
		Case 29
			$Ret = "匕首术"
		Case 30
			$Ret = "暗杀技巧"
		Case 31
			$Ret = "暗影技巧"
		Case 32
			$Ret = "神谕"
		Case 33
			$Ret = "复原"
		Case 34
			$Ret = "导引"
		Case 35
			$Ret = "致命攻击"
		Case 36
			$Ret = "召唤"
		Case 37
			$Ret = "矛术"
		Case 38
			$Ret = "命令"
		Case 39
			$Ret = "激励"
		Case 40
			$Ret = "领导"
		Case 41
			$Ret = "镰刀术"
		Case 42
			$Ret = "风系祷告"
		Case 43
			$Ret = "地系祷告"
		Case 44
			$Ret = "秘法"
		EndSwitch
	return $Ret
EndFunc

Func GetParam($desc)
	Return InputBox("输入", "输入: " & $desc)
EndFunc

Func Refresh()
	UpdateCharInfo()
	UpdateMapInfo()
	UpdatePos()
	UpdateOtherInfos()
EndFunc

Func UpdateOtherInfos()
	$gold = GetGoldCharacter()
	$goldstorage = GetGoldStorage()
	$ping = GetPing()
	GUICtrlSetData($gGoldChar, StringFormat("随身现金值: %d", $gold))
	GUICtrlSetData($gGoldStorage, StringFormat("储存箱内现金值: %d", $goldstorage))
	GUICtrlSetData($gPing, StringFormat("延迟: %d 毫秒", $ping))
EndFunc

Func UpdatePos()
	GUICtrlSetData($gX, StringFormat("X: %d", DllStructGetData(GetAgentByID(-2), "X")))
	GUICtrlSetData($gY, StringFormat("Y: %d", DllStructGetData(GetAgentByID(-2), "Y")))
	GUICtrlSetData($gRotation, StringFormat("面向: %.1f", round(DllStructGetData(GetAgentByID(-2), "Rotation") * 180 / $math_pi, 1))&"°")
EndFunc

Func UpdateCharInfo()
	$me = GetMyID()
	$tarGet = GetCurrentTarGetID()
	$player_number = DllStructGetData(GetAgentByID(-2), "PlayerNumber")
	$agent = GetAgentByID(-2)
	$pname = GetPlayerName($agent)
	GUICtrlSetData($gID, StringFormat("号码: %d", $me))
	GUICtrlSetData($gCurrentTarGet, StringFormat("现有目标号: %d", $tarGet))
	GUICtrlSetData($gName, StringFormat("角色名称: %s", $pname))
EndFunc

Func UpdateMapInfo()
	$MapID = GetmapID()
	$Region = GetRegion()
	$sRegion = ""
	$Lang = Getlanguage()
	$MapLoading = GetMapLoading()
	$mapisloaded = Getmapisloaded()
	Switch $Region
		Case 0
			$sRegion = "北美"
		Case 1
			$sRegion = "亚洲"
		Case 2
			$sRegion = "欧洲"
		Case Else
			$sRegion = "国际"
	EndSwitch
	If $Region = 1 Then
		Switch $Lang
			Case 0
				$sLang = "朝鲜文"
			Case 1
				$sLang = "繁体中文"
		EndSwitch
	Else
		Switch $Lang
			Case 0
				$sLang = "英语"
			Case 2
				$sLang = "法语"
			Case 3
				$sLang = "德语"
			Case 4
				$sLang = "意大利语"
			Case 5
				$sLang = "西班牙语"
			Case 9
				$sLang = "波兰语"
			Case 10
				$sLang = "俄语"
			Case Else
				$sLang = "无法检测"
		EndSwitch
	EndIf
	GUICtrlSetData($gMapID, StringFormat("地图号码: %d", $MapID))
	GUICtrlSetData($gRegion, StringFormat("地区(洲)号: %d | %s", $Region, $sRegion))
	GUICtrlSetData($gLang, StringFormat("语言号: %d | %s", $Lang, $sLang))
	GUICtrlSetData($gMapLoading, StringFormat("地图：正载入: %d", $MapLoading))
	GUICtrlSetData($gMapIsLoaded, StringFormat("地图：已载入: %d", $mapisloaded))
EndFunc
#cs
; Returns first Mod and all of its modvalues
;	return: array(modvalcount, mod, modval1, [modval2, modval3 ...])
;	no mod: return 0
Func GetItemMod1($aItem)
	If Not IsDllStruct($aItem) Then $aItem = GetItemByItemID($aItem)
	Local $lModString = GetModStruct($aItem)
	Local $lMods = ""
	Local $lPos = StringInStr($lModString, "3025", 0, 1)
	If $lPos = 0 Then Return 0
	$lMods = StringMid($lModString, $lPos - 4, 8) & "|" & StringMid($lModString, $lPos + 4, 8)
	Do
		$lPos = StringInStr($lModString, StringMid($lModString, $lPos - 4, 8), 0, 1, $lPos + 1)
		If $lPos = 0 Then ExitLoop
		$lMods = $lMods & "|" & StringMid($lModString, $lPos + 8, 8)
	Until false
	If $lMods = "" Then Return 0
	Local $lModArr = StringSplit($lMods, "|")
	$lModArr[0] -= 1
	Return $lModArr
EndFunc   ;==>GetItemMod1

; Returns second Mod and all of its modvalues
;	return: array(modvalcount, mod, modval1, [modval2, modval3 ...])
;	no 2nd mod: return 0
Func GetItemMod2($aItem)
	If Not IsDllStruct($aItem) Then $aItem = GetItemByItemID($aItem)
	Local $lModString = GetModStruct($aItem)
	Local $lMods = ""
	Local $lMod1 = ""
	Local $lPos = StringInStr($lModString, "3025", 0, 1)
	If $lPos = 0 Then Return 0
	$lMod1 = StringMid($lModString, $lPos - 4, 8)
	Do
		$lPos = StringInStr($lModString, "3025", 0, 1, $lPos + 1)
		If $lPos = 0 Then ExitLoop
		If StringMid($lModString, $lPos - 4, 8) = $lMod1 Then ContinueLoop
		If $lMods = "" Then
			$lMods = StringMid($lModString, $lPos - 4, 8)
		EndIf
		$lMods = $lMods & "|" & StringMid($lModString, $lPos + 4, 8)
	Until false
	If $lMods = "" Then Return 0
	Local $lModArr = StringSplit($lMods, "|")
	$lModArr[0] -= 1
	Return $lModArr
EndFunc   ;==>GetItemMod2

; Returns Inscription and all modvalues of the Inscription
;	return: array(modvalcount, inscr, modval1, [modval2, modval3 ...])
;	no inscription: return 0
Func GetItemInscr($aItem)
	If Not IsDllStruct($aItem) Then $aItem = GetItemByItemID($aItem)
	Local $lModString = GetModStruct($aItem)
	Local $lMods = ""
	Local $lSearch = "3225"
	Local $lPos = StringInStr($lModString, $lSearch)
	If $lPos = 0 Then
		$lSearch = "32A5"
		$lPos = StringInStr($lModString, $lSearch)
	EndIf
	If $lPos = 0 Then Return 0
	$lMods = StringMid($lModString, $lPos - 4, 8) & "|" & StringMid($lModString, $lPos + 4, 8)
	Do
		$lPos = StringInStr($lModString, $lSearch, 0, 1, $lPos + 1)
		If $lPos = 0 Then ExitLoop
		$lMods = $lMods & "|" & StringMid($lModString, $lPos + 4, 8)
	Until false
	If $lMods = "" Then Return 0
	Local $lModArr = StringSplit($lMods, "|")
	$lModArr[0] -= 1
	Return $lModArr
EndFunc   ;==>GetItemInscr
#ce
Func _TooltipMouseExit($text, $time = -1, $x = -1, $y = -1, $title = "", $icon = 0, $opt = "")
	If $time = -1 Then $time = 3000
	Local $start = TimerInit(), $pos0 = MouseGetPos()
	If ($x = -1) OR ($y = -1) Then
		ToolTip($text, $pos0[0], $pos0[1], $title, $icon, $opt)
	Else
		ToolTip($text, $x, $y, $title, $icon, $opt)
	EndIf
	Do
		Sleep(50)
		$pos = MouseGetPos()
	Until (TimerDiff($start) > $time) OR (Abs($pos[0] - $pos0[0]) > 10 OR Abs($pos[1] - $pos0[1]) > 10)
	ToolTip("")
EndFunc

Func DeveloperShutdown()
	WinSetTitle(GetWindowHandle(), "", "Guild Wars")
EndFunc