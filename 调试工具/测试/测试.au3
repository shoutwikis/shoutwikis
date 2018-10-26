#include "../../激战接口.au3"

; Constant Globals/Data
Global Const $PLAYERNUM_Casey_Carpenter = 6040

Global Const $DIALOGID_Snowball_Dominance_Take = 0x83A601
Global Const $DIALOGID_Snowball_Dominance_Reward = 0x83A607
Global Const $DIALOGID_Snowball_Dominance_Enter = 0x84
Global Const $QUESTID_Snowball_Dominance = 0x3A6

Global Const $SKILLID_Yellow_Snow = 1007
Global Const $SKILLID_Hidden_Rock = 1008
Global Const $SKILLID_Snowball = 1002
Global Const $SKILLID_Mega_Snowball = 1003
Global Const $SKILLID_Ice_Fort = 1006

Global Const $MAPID_EOTN_Wintersday = 821
Global Const $MAPID_EOTN_Snowballs = 793

Global Const $Hero_Flag_Coords[2] = [5011.7041015625, -603.1650390625]

;Globalz
Global $totalRuns = 0
Global $failedRuns = 0
Global $bRun = False

Opt("GUIOnEventMode", 1)

Global $g_fMain = GUICreate("测试", 151, 170, 192, 124)
Global $g_gSetup = GUICtrlCreateGroup("设置", 8, 6, 135, 69)
Global $g_cName = GUICtrlCreateCombo("", 16, 25, 118, 25, 3)
SetClientNames($g_cName)
;Global $g_cbRendering = GUICtrlCreateCheckbox("成像", 16, 52, 97, 17)
Global $g_gRuns = GUICtrlCreateGroup("统计", 8, 80, 135, 53)
Global $g_lblTotal = GUICtrlCreateLabel("总数:", 20, 94, 31, 17)
Global $g_lblFail = GUICtrlCreateLabel("失败:", 20, 111, 35, 17)
Global $g_numTotal = GUICtrlCreateLabel("-", 69, 91, 67, 17, 1)
Global $g_numFail = GUICtrlCreateLabel("-", 69, 109, 67, 17, 1)
Global $g_bRun = GUICtrlCreateButton("开始", 10, 136, 131, 25)

;GUICtrlSetOnEvent($g_cbRendering, 'ToggleRendering')
GUICtrlSetOnEvent($g_bRun, 'ToggleBot')
GUISetOnEvent(-3, '_exit')

GUISetState(1)

Do
	Sleep(100)
Until $bRun

GUICtrlSetState($g_cName, 128)
GUICtrlSetState($g_bRun, 128)

Initialize(GUICtrlRead($g_cName))
SetEvent('SkillActivate', 'SkillCancel', 'SkillComplete', 'ChatReceived', 'LoadFinished')

While 1

	; 等待装载地图
	If (GetMapLoading() == 2) Then
		Do
			Sleep(350)
		Until WaitMapLoading()
		;RndSleep(GetPing()+2000)
		ContinueLoop
	EndIf

	main()
WEnd

Func main()
	sleep(3000)
	;MsgBox(0, "0", GetIsKnocked(-1)&" | " & DllStructGetData(GetAgentByID(-1), 'ModelState'))
EndFunc   ;==>main

Func ChatReceived($Channel, $Sender, $Message)

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

Func ToggleBot()
	$bRun = Not $bRun
EndFunc   ;==>ToggleBot

Func _exit()
	Exit
EndFunc   ;==>_exit