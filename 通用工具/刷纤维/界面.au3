#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once
#include <String.au3>
#include <GuiComboBox.au3>
#include <ComboConstants.au3>


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
;WinSetTrans($cGUI,"",200)
;_GuiRoundCorners($cGUI,35)
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

Func _GuiRoundCorners($h_win, $iSize)
	Local $XS_pos, $XS_ret
	$XS_pos = WinGetPos($h_win)
	$XS_ret = DllCall("gdi32.dll", "long", "CreateRoundRectRgn", "long", 0, "long", 0, "long", $XS_pos[2] + 1, "long", $XS_pos[3] + 1, "long", $iSize, "long", $iSize)
	If $XS_ret[0] Then
		DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $XS_ret[0], "int", 1)
	EndIf
EndFunc   ;==>_GuiRoundCorners

Func SecureInitSetCharnames()
$File = "Fiber.lic"
$Password = "YoloSwag420"
Local $FileRead = FileRead($File)
Local $DecryptedCharnames = _StringEncrypt(0,$FileRead,$Password,7)
Local $CharArray = StringSplit($DecryptedCharnames,'|')
GUICtrlSetData($cCharname, $DecryptedCharnames,$CharArray[1])
EndFunc
#endregion GUIFuncs