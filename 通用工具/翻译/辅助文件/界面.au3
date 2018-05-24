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
#include <Misc.au3>
#include <File.au3>

Global $Files = _FileListToArray(@ScriptDir,"*.log",1)
If Not @error then
	For $Index = 1 To $Files[0]
		FileDelete($Files[$Index])
	Next
endif
Global $FileNameConsole=@Mon&"-"&@MDAY&" "&"翻译数据 "&@HOUR&"-"&@MIN&".log"
Global $hFileOpen = FileOpen($FileNameConsole, 130)
If $hFileOpen = -1 Then
	MsgBox($MB_SYSTEMMODAL, "", "无法创建文件")
EndIf

Global Const $mainGui =  GUICreate("", 395, 185, 1000, 700, BitOR($WS_MINIMIZEBOX, $WS_DLGFRAME, $WS_POPUP, $WS_GROUP, $WS_CLIPSIBLINGS, $WS_EX_LAYERED)) ;365
GUICtrlSetDefColor(0x000000)
WinSetTrans($mainGui, "", 150)
WinSetOnTop($maingui, "", 1)
_guiroundcorners($mainGui, 10)
Global $ssource = "en"
GUISetBkColor(0)
GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "WindowDrag", $mainGui)

Global $Input = GUICtrlCreateCombo("选角色名", 8, 8, 92, 21)
	GUICtrlSetData(-1,GetLoggedCharNames())

Global $tAll = GUICtrlCreateCheckbox("", 115, 12, 15, 17)
GUICtrlSetTip(-1, "翻译地区频道")

Global $tGuild = GUICtrlCreateCheckbox("", 140, 12, 15, 17)
GUICtrlSetTip(-1, "翻译公会频道")

Global $tTeam = GUICtrlCreateCheckbox("", 165, 12, 15, 17)
GUICtrlSetTip(-1, "翻译队伍频道")

Global $tTrade = GUICtrlCreateCheckbox("", 190, 12, 15, 17)
GUICtrlSetTip(-1, "翻译交易频道")

Global $tAlly = GUICtrlCreateCheckbox("", 215, 12, 15, 17)
GUICtrlSetTip(-1, "翻译同盟频道")

Global $tWhisper = GUICtrlCreateCheckbox("", 240, 12, 15, 17)
GUICtrlSetTip(-1, "翻译私聊频道")

;本国语言，输出语言, 频道语言,
Global $yuYan_xuanZe[3] = ["zh", "en", "en"]
;arabic, chinese, english, filipino, finish, french, german, greek, hebrew, italian, maori, mongolian, persian, russian, spanish, swahili, turkish
;ar, zh, en, fl, fi, fr, de, el, he, it, mi, mn, fa, ru, es, sw, tr
Global $yuYan_jieMian[3]
;本国语言
$yuYan_jieMian[0] = GUICtrlCreateCombo("", 252, 159, 65, 20) ;加 $SS_CENTER 消除下拉按钮
GUICtrlSetTip(-1, "选择本国语言")
GUICtrlSetData(-1,"阿拉伯语|中文|英语|菲律宾语|芬兰语|法语|德语|希腊语|希伯来语|意大利语|毛利语|蒙古语|波斯语|俄语|西班牙语|斯瓦希里语|土耳其语")
GUICtrlSetOnEvent(-1, "returnFocusX")
_GUICtrlComboBox_SelectString(-1, "中文")
;输出语言
$yuYan_jieMian[1] = GUICtrlCreateCombo("", 320, 159, 65, 20) ;加 $SS_CENTER 消除下拉按钮
GUICtrlSetTip(-1, "选择输出语言")
GUICtrlSetData(-1,"阿拉伯语|中文|英语|菲律宾语|芬兰语|法语|德语|希腊语|希伯来语|意大利语|毛利语|蒙古语|波斯语|俄语|西班牙语|斯瓦希里语|土耳其语")
GUICtrlSetOnEvent(-1, "returnFocusX")
_GUICtrlComboBox_SelectString(-1, "英语")
;频道语言
$yuYan_jieMian[2] = GUICtrlCreateCombo("", 265, 8, 65, 20) ;加 $SS_CENTER 消除下拉按钮
GUICtrlSetTip(-1, "选择频道语言")
GUICtrlSetData(-1,"阿拉伯语|中文|英语|菲律宾语|芬兰语|法语|德语|希腊语|希伯来语|意大利语|毛利语|蒙古语|波斯语|俄语|西班牙语|斯瓦希里语|土耳其语")
GUICtrlSetOnEvent(-1, "returnFocusX")
_GUICtrlComboBox_SelectString(-1, "英语")

Global Const $ButtonSpeak = GUICtrlCreateButton("开始", 333, 6, 45, 24)
	GUICtrlSetOnEvent(-1, "GuiButtonHandler")
	GUICtrlSetColor(-1, 0xCC0000)

GUICtrlCreateLabel("x", 380, 0, 15, 15, BitOR(1, 0x00000200))
GUICtrlSetOnEvent(-1, "_exit")
GUICtrlSetColor(-1, 0xFFFFFF)

Global $GLOGBOX = GUICtrlCreateEdit("", 8, 35, 377, 120, BitOR($ES_AUTOVSCROLL, $ES_WANTRETURN, $WS_VSCROLL, $ES_MULTILINE))
GUICtrlSetColor($GLOGBOX, 65280)
GUICtrlSetBkColor($GLOGBOX, 0)

Global $messageInput = GUICtrlCreateInput("<输入 - 完整句子或提高翻译效果>", 8, 160, 240, 20)
GUICTrlSetOnEvent($messageInput, "messagesend")

GUISetState(@SW_SHOW)

Func returnFocusX()
	For $i = 0 to 2
		switch GuictrlRead($yuYan_jieMian[$i])
			Case "阿拉伯语"
				$yuYan_xuanZe[$i] = "ar"
			Case "中文"
				$yuYan_xuanZe[$i] = "zh"
			Case "英语"
				$yuYan_xuanZe[$i] = "en"
			Case "菲律宾语"
				$yuYan_xuanZe[$i] = "fl"
			Case "芬兰语"
				$yuYan_xuanZe[$i] = "fi"
			Case "法语"
				$yuYan_xuanZe[$i] = "fr"
			Case "德语"
				$yuYan_xuanZe[$i] = "de"
			Case "希腊语"
				$yuYan_xuanZe[$i] = "el"
			Case "希伯来语"
				$yuYan_xuanZe[$i] = "he"
			Case "意大利语"
				$yuYan_xuanZe[$i] = "it"
			Case "毛利语"
				$yuYan_xuanZe[$i] = "mi"
			Case "蒙古语"
				$yuYan_xuanZe[$i] = "mn"
			Case "波斯语"
				$yuYan_xuanZe[$i] = "fa"
			Case "俄语"
				$yuYan_xuanZe[$i] = "ru"
			Case "西班牙语"
				$yuYan_xuanZe[$i] = "es"
			Case "斯瓦希里语"
				$yuYan_xuanZe[$i] = "sw"
			Case "土耳其语"
				$yuYan_xuanZe[$i] = "tr"
			Case Else
				$yuYan_xuanZe[$i] = "en"
		EndSwitch
	Next
	ControlFocus($mainGui,"",$GLOGBOX)
	if (BitAND(WinGetState($mGWHwnd),2) and NOT BitAND(WinGetState($mGWHwnd),16)) then WinActivate($mGWHwnd) ;visible and not minimized; since we need $mGWHwnd, this won't work till gwa2 initialized
EndFunc

;GUICtrlSetState(-1, $GUI_CHECKED)


#cs
Global $oFrench = GUICtrlCreateCheckbox("", 253, 163, 15, 17)
GUICtrlSetTip($oFrench, "输出：法语")
GUICtrlSetOnEvent($oFrench, "SelectFrench")
Global $oEnglish = GUICtrlCreateCheckbox("", 273, 163, 15, 17)
GUICtrlSetTip($oEnglish, "输出：英语")
GUICtrlSetState($oEnglish, $GUI_CHECKED)
GUICtrlSetOnEvent(-1, "SelectEnglish")
Global $oGerman = GUICtrlCreateCheckbox("", 293, 163, 15, 17)
GUICtrlSetTip($oGerman, "输出：德语")
GUICtrlSetOnEvent($oGerman, "SelectGerman")

Func SelectFrench()
	if GUICtrlRead($oFrench) = $GUI_UNCHECKED then GUICtrlSetState($oFrench, $GUI_CHECKED)
	if GUICtrlRead($oFrench) = $GUI_CHECKED Then
		$tLang = "fr"
		GUICtrlSetState($oEnglish, $GUI_UNCHECKED)
		GUICtrlSetState($oGerman, $GUI_UNCHECKED)
	EndIf
	return 1
EndFunc

Func SelectEnglish()
	if GUICtrlRead($oEnglish) = $GUI_UNCHECKED then GUICtrlSetState($oEnglish, $GUI_CHECKED)
	if GUICtrlRead($oEnglish) = $GUI_CHECKED Then
		$tLang = "en"
		GUICtrlSetState($oFrench, $GUI_UNCHECKED)
		GUICtrlSetState($oGerman, $GUI_UNCHECKED)
	EndIf
	return 1
EndFunc

Func SelectGerman()
	if GUICtrlRead($oGerman) = $GUI_UNCHECKED then GUICtrlSetState($oGerman, $GUI_CHECKED)
	if GUICtrlRead($oGerman) = $GUI_CHECKED Then
		$tLang = "de"
		GUICtrlSetState($oEnglish, $GUI_UNCHECKED)
		GUICtrlSetState($oFrench, $GUI_UNCHECKED)
	EndIf
	return 1
EndFunc
#ce

Func _guiroundcorners($h_win, $isize)
		Local $xs_pos, $xs_ret
		$xs_pos = WinGetPos($h_win)
		$xs_ret = DllCall("gdi32.dll", "long", "CreateRoundRectRgn", "long", 0, "long", 0, "long", $xs_pos[2] + 1, "long", $xs_pos[3] + 1, "long", $isize, "long", $isize)
		If $xs_ret[0] Then
			DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $xs_ret[0], "int", 1)
		EndIf
EndFunc

Func WindowDrag()

    Local $MouseOffset = WinGetPos($mainGui)
    Local $MousePos = MouseGetPos()
    $MouseOffset[0] -= $MousePos[0]
    $MouseOffset[1] -= $MousePos[1]
    ConsoleWrite("Offset [0] = " & $MouseOffset[0] & "  [1] = " & $MouseOffset[1] & @LF)
    While _IsPressed("01")
        $MousePos = MouseGetPos()
        $MousePos[0] += $MouseOffset[0]
        $MousePos[1] += $MouseOffset[1]
        ConsoleWrite("Move [0] = " & $MousePos[0] & "  [1] = " & $MousePos[1] & @LF)
        WinMove($mainGui, "", $MousePos[0], $MousePos[1])
        Sleep(20)
    WEnd

EndFunc

Func GuiButtonHandler()
	If $BotRunning Then
		GUICtrlSetData($ButtonSpeak, "")
		GUICtrlSetState($ButtonSpeak, $GUI_DISABLE)
		GUICtrlSetState($ButtonSpeak, $GUI_HIDE)
		$BotRunning = False
	ElseIf $BotInitialized Then
		GUICtrlSetData($ButtonSpeak, "")
		GUICtrlSetState($ButtonSpeak, $GUI_HIDE)
		$BotRunning = True
		$reZone = 1
	Else
		Local $CharName = GUICtrlRead($Input)
		If Initialize("") = False Then
			MsgBox(0, "失败", "激战未打开.")
			Exit
		EndIf
		GUICtrlSetState($Input, $GUI_DISABLE)
		GUICtrlSetData($ButtonSpeak, "")
		GUICtrlSetState($ButtonSpeak, $GUI_HIDE)
		$BotRunning = True
		$BotInitialized = True
		$reZone = 1
	EndIf
EndFunc

Func _exit()
	FileClose($hFileOpen)
	Exit
EndFunc