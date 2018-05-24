#NoTrayIcon
#include-once
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>
#include "../../激战接口.au3"
 
Opt("MustDeclareVars", True)
Opt("GUIOnEventMode", True)
 
Global Enum $PROF_NONE, $PROF_WARRIOR, $PROF_RANGER, $PROF_MONK, $PROF_NECROMANCER, $PROF_MESMER, $PROF_ELEMENTALIST, $PROF_ASSASSIN, $PROF_RITUALIST, $PROF_PARAGON, $PROF_DERVISH
 
Global Enum $INSTANCETYPE_OUTPOST, $INSTANCETYPE_EXPLORABLE, $INSTANCETYPE_LOADING
 
Global Const $lRegion[12] = 	[-2, 0, 2, 2, 2, 2, 2, 2,  2, 1, 3, 4]
Global Const $lLanguage[12] = 	[0,  0, 0, 2, 3, 4, 5, 9, 10, 0, 0, 0]
 
Global $boolRunning = False
Global $boolInitialized = False
Global $Rendering = True
 
Global $runs = 0
Global $fails = 0
 
Global Const $MainGui = GUICreate("天神雪仗自动退出", 172, 190)
GUICtrlCreateLabel("天神雪仗自动退出", 8, 6, 156, 17, $SS_CENTER)
Global Const $inputCharName = GUICtrlCreateCombo("", 8, 24, 150, 22)
GUICtrlSetData(-1, GetLoggedCharNames())
Global Const $cbxHideGW = GUICtrlCreateCheckbox("停止成像", 8, 48)
Global Const $cbxOnTop = GUICtrlCreateCheckbox("置窗口于前", 8, 68)
GUICtrlCreateLabel("总圈数:", 8, 92)
Global Const $lblRunsCount = GUICtrlCreateLabel(0, 80, 92, 30)
GUICtrlCreateLabel("失败次数:", 8, 112)
Global Const $lblFailsCount = GUICtrlCreateLabel(0, 80, 112, 30)
Global Const $lblLog = GUICtrlCreateLabel("", 8, 130, 154, 30)
Global Const $btnStart = GUICtrlCreateButton("开始", 8, 162, 154, 25)
 
GUICtrlSetOnEvent($cbxOnTop, "EventHandler")
GUICtrlSetOnEvent($cbxHideGW, "EventHandler")
GUICtrlSetOnEvent($btnStart, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")
GUISetState(@SW_SHOW)
 
Out("准备就绪")
 
Do
	Sleep(100)
Until $boolInitialized
 
While 1
	If $boolRunning Then
		Main()
	Else
		Out("暂停")
		GUICtrlSetState($btnStart, $GUI_ENABLE)
		GUICtrlSetData($btnStart, "开始")
		While Not $boolRunning
			Sleep(100)
		WEnd
	EndIf
WEnd
 
Func Main()
   
   ;空转，直到装图完毕
   Do
	  Sleep(18000)
	  ;如坐标位置上有位 Priest of Balthazar，则点击进入任务
   if (GetAgentName(GetNearestAgentToCoords(-10792, 11796)) == "Priest of Balthazar") then EnterChallenge()
 
   Until zhuangZaiWanBi(855, 60000) ;装图完毕   
 
   ;开始计时
   local $shiJian = TimerInit()
 
   ;等待换图，只要未遇到换图，就作以下循环
   While GetMapLoading() <> $INSTANCETYPE_LOADING
	  ;时间超过5:00-5:09后，退出循环，退出函数 Main()，从头开始
	  if TimerDiff($shiJian) > (Random(300, 309, 1)*1000) then
		 
		 Resign() ;游戏内输入退出
		 Return
         While GetMapLoading() <> $INSTANCETYPE_LOADING
              Sleep(100)
		 WEnd
		 Return
	  EndIf
   WEnd
   
EndFunc
 
Func EventHandler()
	Switch (@GUI_CtrlId)
		Case $btnStart
			If $boolRunning Then
				GUICtrlSetData($btnStart, "此轮过后暂停")
				GUICtrlSetState($btnStart, $GUI_DISABLE)
				$boolRunning = False
			ElseIf $boolInitialized Then
				GUICtrlSetData($btnStart, "暂停")
				$boolRunning = True
			Else
				$boolRunning = True
				GUICtrlSetData($btnStart, "启动...")
				GUICtrlSetState($btnStart, $GUI_DISABLE)
				GUICtrlSetState($inputCharName, $GUI_DISABLE)
				WinSetTitle($MainGui, "", GUICtrlRead($inputCharName))
				If GUICtrlRead($inputCharName) = "" Then
					If Initialize("", True, True, True) = False Then
						MsgBox(0, "提示", "激战未开")
						Exit
					EndIf
				Else
					If Initialize(GUICtrlRead($inputCharName), True, True, True) = False Then
						MsgBox(0, "提示", "角色失寻")
						Exit
					EndIf
				EndIf
				GUICtrlSetData($btnStart, "暂停")
				GUICtrlSetState($btnStart, $GUI_ENABLE)
				$boolInitialized = True
			EndIf
 
		Case $cbxHideGW
			ClearMemory()
			ToggleRendering()
 
		Case $cbxOnTop
			WinSetOnTop($MainGui, "", GUICtrlRead($cbxOnTop)==$GUI_CHECKED)
 
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
EndFunc
 
Func ToggleRendering()
	If $Rendering Then
		DisableRendering()
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
		ClearMemory()
	Else
		EnableRendering()
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
	EndIf
	$Rendering = Not $Rendering
EndFunc
 
Func Out($aString)
	Local $timestamp = "[" & @HOUR & ":" & @MIN & "] "
	GUICtrlSetData($lblLog, $timestamp & $aString)
EndFunc
 
Func zhuangZaiWanBi($aMapID = 0, $aDeadlock = 15000)
;~ 	Waits $aDeadlock for load to start, and $aDeadLock for agent to load after map is loaded.
	Local $lMapLoading
	Local $lDeadlock = TimerInit()
    
    if ((GetMapLoading <> $INSTANCETYPE_LOADING) and (GetMapID() = $aMapID)) then return True
    
	InitMapLoad()
 
	Do
		Sleep(200)
		$lMapLoading = GetMapLoading()
		If $lMapLoading == 2 Then $lDeadlock = TimerInit()
		If TimerDiff($lDeadlock) > $aDeadlock And $aDeadlock > 0 Then Return False
	Until $lMapLoading <> 2 And GetMapIsLoaded() And (GetMapID() = $aMapID Or $aMapID = 0)
    
	Sleep(3000)
    
	Return True
EndFunc   ;==>zhuangZaiWanBi