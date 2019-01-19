;Koala95's Bot CDX
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>
#include "../../激战接口.au3"

Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Opt("TrayIconHide", 1)

Global Enum $INSTANCETYPE_OUTPOST, $INSTANCETYPE_EXPLORABLE, $INSTANCETYPE_LOADING
Global $Map_Codex = 796
Global $BotRunning = False
Global $BotInitialized = False
Global $RenderingEnabled = True
Global $RunCount = 0
Global $successfulruncount = 0
Global $FailedRunCount = 0
Global $TotalSeconds = 0
Global $Seconds = 0
Global $Minutes = 0
Global $Hours = 0
Global $TotTimeCount = 0
Global Const $Dishonorable = 2546

#Region GUI
Global Const $mainGUI = GUICreate("柯达竞赛场", 180, 250)
GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
Global $Input = GUICtrlCreateCombo("", 10, 8, 160, 25)
SetClientNames($Input)
GUICtrlCreateLabel("圈数:", 10, 150, 130, 20)
$RunsLabel = GUICtrlCreateLabel("0", 70, 150, 50, 17)
GUICtrlCreatelabel("时间:", 10, 170, 130, 17)
Global Const $Timer = GUICtrlCreatelabel("00:00:00", 70, 170, 50, 17)
Global Const $Checkbox = GUICtrlCreateCheckbox("成像", 10, 190, 129, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "ToggleRendering")
Global Const $Button = GUICtrlCreateButton("开始", 10, 215, 160, 30)
	GUICtrlSetOnEvent(-1, "GuiButtonHandler")
Global $statuslbl = GUICtrlCreateLabel("", 140, 184, 204, 17, $SS_CENTER)

Global $GLOGBOX = GUICtrlCreateEdit("柯达竞赛场", 10, 40, 160, 100, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL))

GUICtrlSetColor($GLOGBOX, 65280)
GUICtrlSetBkColor($GLOGBOX, 0)
GUISetState(@SW_SHOW)

While Not $BotRunning
	Sleep(100)
WEnd


While 1
    Global $Me = GetAgentByID(-2)
	AdlibRegister("TimeUpdater", 1000)
	Sleep(GetPing() + 100)
	If $BotRunning Then
		Checkmap()
		Sleep(2000)
		Disp("在加兵")
		AddHench()
		waitDishonor()
		Enter()
		Main()
	EndIf
WEnd

Func GuiButtonHandler()
	If $BotRunning Then
		GUICtrlSetData($Button, "此轮过后暂停")
		GUICtrlSetState($Button, $GUI_DISABLE)
		$BotRunning = False
	ElseIf $BotInitialized Then
		GUICtrlSetData($Button, "暂停")
		$BotRunning = True
	Else
		Disp("启动...")
		Local $CharName = GUICtrlRead($Input)
		If $CharName=="" Then
			If Initialize("", True, True, True) = False Then ;Initialize(ProcessExists("gw.exe"), True, True, False) = False Then
				MsgBox(0, "故障", "未开激战.")
				Exit
			EndIf
		Else
			If Initialize("", True, True, True) = False Then ;Initialize($CharName, True, True, False) = False Then
				MsgBox(0, "故障", "角色失寻： '"&$CharName&"'")
				Exit
			EndIf
		EndIf
		EnsureEnglish(True)
		GUICtrlSetState($Checkbox, $GUI_ENABLE)
		GUICtrlSetState($Input, $GUI_DISABLE)
		GUICtrlSetData($Button, "暂停")
		WinSetTitle($mainGui, "", "柯达-" & GetCharname())
		AdlibRegister("GetTime")
		$BotRunning = True
		$BotInitialized = True
	EndIf
EndFunc
#EndRegion GUI

Func Main()
	Disp("待自杀")
	Do
	 Sleep(Random(750, 1250, 1))
	Until GetMapLoading() = $INSTANCETYPE_OUTPOST And GetAgentExists(-2)
	$RunCount += 1
	GUICtrlSetData($RunsLabel, $RunCount)
EndFunc

Func AddHench()
   AddNpc(1)
   sleep(400)
   AddNpc(2)
   sleep(400)
   AddNpc(4)
   sleep(400)
EndFunc


Func waitDishonor()
	If GetMapLoading() = $INSTANCETYPE_LOADING Then Disconnected()
	While DllStructGetData(GetEffect($Dishonorable), 'SkillID') == $Dishonorable
		Out("等待耻效应的结束")
		Sleep(Random(60000, 900000, 1))
	WEnd
EndFunc

Func Disconnected() ;Ralle's Disconnect ;
	Disp("掉线!")
	Disp("正在重连.")
	Static Local $gs_obj = GetValue('PacketLocation')
	Local $State = MemoryRead($gs_obj)
	If $State = 0 Then
		Do
			ControlSend($mGWHwnd, '', '', '{ENTER}{ENTER}') ; Hit enter key until you log back in
			Sleep(Random(5000, 10000, 1))
		Until MemoryRead($gs_obj) <> 0
		RndSleep(500)
		Resign()
		Return True
	EndIf
	Return False
EndFunc
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
EndFunc
#ce
 Func Enter()
    Disp("开始竞赛")
    EnterChallenge()
    Disp("等待比赛开始")
    Do
		Sleep(Random(750, 1250, 1))
    Until GetMapLoading() = $INSTANCETYPE_EXPLORABLE And GetAgentExists(-2)
 EndFunc

Func SetClientNames($aCombo)
	Local $lGWList = WinList("[CLASS:ArenaNet_Dx_Window_Class; REGEXPTITLE:^\D+$]")
	Local $lFirstChar
	Local $lStr = ''
	For $i = 1 To $lGWList[0][0]
		MemoryOpen(WinGetProcess($lGWList[$i][1]))
		$lStr &= ScanForCharname()
		If $i = 1 Then $lFirstChar = GetCharname()
		MemoryClose()
		If $i <> $lGWList[0][0] Then $lStr &= '|'
	Next
	Return GUICtrlSetData($aCombo, $lStr, $lFirstChar)
EndFunc   ;==>SetClientNames

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
	GUICtrlSetData($Timer, $L_Hour & ":" & $L_Min & ":" & $L_Sec)
EndFunc

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
EndFunc

Func _Exit()
	Exit
EndFunc

Func Checkmap()
	If GetMapID() <> $Map_Codex Then
		Disp("前往: 柯达城")
		RndTravel($Map_Codex)
		Disp("已达: 柯达城")
	EndIf
EndFunc

Func Disp($TEXT)
	Local $TEXTLEN = StringLen($TEXT)
	Local $CONSOLELEN = _GUICtrlEdit_GetTextLen($GLOGBOX)
	If $TEXTLEN + $CONSOLELEN > 30000 Then GUICtrlSetData($GLOGBOX, StringRight(_GUICtrlEdit_GetText($GLOGBOX), 30000 - $TEXTLEN - 1000))
	_GUICtrlEdit_AppendText($GLOGBOX, @CRLF & $TEXT)
	_GUICtrlEdit_Scroll($GLOGBOX, 1)
EndFunc