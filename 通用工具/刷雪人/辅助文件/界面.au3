#include-once
#include <String.au3>
#include <GuiComboBox.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <GuiEdit.au3>
;77, 82

#Region GUI
Global $HOWMANYDATA = "", $MATID, $RAREMATSBUY = False, $mFoundChest = False, $mFoundMerch = False, $Bags = 4, $PICKUP_GOLDS = False

Global Const $mainGui = GUICreate("刷雪人2 - 测试", 350, 260)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")

Global $Input = GUICtrlCreateCombo("从列表中选本名", 8, 8, 152, 21)
	GUICtrlSetData(-1,GetLoggedCharNames())

;----------------addition begins------------------------------------------------------
Global $GUILDHALL ;= GUICtrlCreateCombo("所属公会厅", 8, 40, 125, 25)
Global $SELECT_GH = "燃烧之岛|德鲁伊之岛|冰冻之岛|猎人之岛|死亡之岛|流浪之岛|战士之岛|巫师之岛|帝国之岛|翡翠之岛|冥想之岛|泣石之岛|坠落之岛|神隐之岛|巨虫之岛|迷样之岛"
GUICtrlSetData($GUILDHALL, $SELECT_GH)
GUICtrlSetOnEvent($GUILDHALL, "START_STOP")
Func START_STOP()
	Switch (@GUI_CtrlId)
		;Case $SELECTMAT
		;	MATSWITCHER()

		Case $GUILDHALL
			GHSWITCHER()
	EndSwitch
EndFunc   ;==>START_STOP
Func GhSwitcher()
	If GUICtrlRead($GUILDHALL, "") == "迷样之岛" Then
		$UNCHARTEDISLE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "帝国之岛" Then
		$IMPERIALISLE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "德鲁伊之岛" Then
		$DRUIDISLE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "猎人之岛" Then
		$HUNTERISLE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "巨虫之岛" Then
		$ISLEOFWURMS = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "冥想之岛" Then
		$ISLEOFMEDITATION = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "神隐之岛" Then
		$ISLEOFSOLITUDE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "坠落之岛" Then
		$CORRUPTEDISLE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "死亡之岛" Then
		$ISLEOFDEAD = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "燃烧之岛" Then
		$BURNINGISLE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "战士之岛" Then
		$WARRIORISLE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "泣石之岛" Then
		$ISLEOFWEEPING = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "冰冻之岛" Then
		$FROZENISLE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "流浪之岛" Then
		$NOMADISLE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "翡翠之岛" Then
		$ISLEOFJADE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "巫师之岛" Then
		$WIZARDISLE = True
	EndIf
EndFunc
;----------------addition ends------------------------------------------------------

GUICtrlCreateLabel("圈数:", 8, 72, 70, 17)
Global Const $RunsLabel = GUICtrlCreateLabel($RunCount, 80, 72, 50, 17)
;GUICtrlCreateLabel("杀王次数:", 8, 55, 70, 17)
;Global Const $BossLabel = GUICtrlCreateLabel($BossKills, 80, 55, 50, 17)
GUICtrlCreateLabel("死亡次数:", 8, 90, 70, 17)
Global Const $FailsLabel = GUICtrlCreateLabel($FailCount, 80, 90, 50, 17)


Global Const $CheckHard = GUICtrlCreateCheckbox("下圈用困难模式", 8, 112, 129, 17)
	GUICtrlSetOnEvent(-1, "ToggleDifficulty")
;-----------------------------------------------------------------------------------
;Global $InputMes = GUICtrlCreateCombo("主队幻术", 8, 62, 152, 21)


;Global $InputLT = GUICtrlCreateCombo("主队暗杀", 8, 94, 152, 21)


;Global $InputRanger = GUICtrlCreateCombo("挡多姆游侠", 8, 126, 152, 21)

Global Const $Checkbox = GUICtrlCreateCheckbox("停止激战成像", 8, 178, 129, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "ToggleRendering")

Global Const $Button = GUICtrlCreateButton("开始", 8, 200, 131, 25)
	GUICtrlSetOnEvent(-1, "GuiButtonHandler")

Global $GLOGBOX = GUICtrlCreateEdit("", 162, 8, 200, 240, BitOR($ES_AUTOVSCROLL, $ES_WANTRETURN, $WS_VSCROLL, $ES_MULTILINE)) ;BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL)

GUICtrlSetColor($GLOGBOX, 65280)
GUICtrlSetBkColor($GLOGBOX, 0)

GUISetState(@SW_SHOW)

;~ Description: Handles the button presses
Func GuiButtonHandler()
	If $BotRunning Then
		GUICtrlSetData($Button, "此圈过后暂停")
		GUICtrlSetState($Button, $GUI_DISABLE)
		$BotRunning = False
	ElseIf $BotInitialized Then
		GUICtrlSetData($Button, "暂停")
		$BotRunning = True
		Out("已启动")
	Else
		Out("已启动")
		Local $CharName = GUICtrlRead($Input)
		;$nameMes = GUICtrlRead($InputMes)
		;$nameLT = GUICtrlRead($InputLT)
;		$nameDT = GUICtrlRead($InputRanger)
		If $CharName=="" Then
			If Initialize("", True, True, True) = False Then ;ProcessExists("gw.exe")
				MsgBox(0, "失败", "激战未打开.")
				Exit
			EndIf
		Else
			If Initialize($CharName, True, True, True) = False Then
				MsgBox(0, "失败", "未找到角色: '"&$CharName&"'")
				Exit
			EndIf
		EndIf
		;EnsureEnglish(True)
		GUICtrlSetState($Checkbox, $GUI_ENABLE)
		GUICtrlSetState($Input, $GUI_DISABLE)
		GUICtrlSetState($GUILDHALL, $GUI_DISABLE)
		;GUICtrlSetState($InputMes, $GUI_DISABLE)
		;GUICtrlSetState($InputLT, $GUI_DISABLE)
		;GUICtrlSetState($InputRanger, $GUI_DISABLE)
		GUICtrlSetData($Button, "暂停")
		WinSetTitle($mainGui, "", "刷雪人2-" & GetCharname())
		$BotRunning = True
		$BotInitialized = True
	EndIf
EndFunc
#EndRegion GUI

Out("===>  提示  <===      请勿把贵重稀有物品留存随身包, 以防无意被卖                    ")
Out("所用技能码: OgcTcVM+ZC5Qn5ACB6u84Q4A3BA")
;Out("等待输入")

Func _exit()
	Exit
EndFunc