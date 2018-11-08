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
HotKeySet("{ESC}", "test")

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
	;sleep(3000)
EndFunc   ;==>main

Func test()
	;splashtexton("提示", "跑图工具：需要手动操作"&@CRLF&@CRLF&"(完成操作后，窗口会自动关闭)", 200, 150, default, default, 16)  savage shot 426
	;MsgBox(0, "0", GetIsKnocked(-1)&" | " & DllStructGetData(GetAgentByID(-1), 'ModelState'))
	;msgbox(0, "test", "MemberLoaded: "&MemberLoaded()[0]&" | MemberCount Value: "&MemberCount())
EndFunc


;~ Description: Returns array of party members
;~ Param: an array returned by GetAgentArray. This is totally optional, but can greatly improve script speed.
Func MemberLoaded()
	;GetMapLoading() == 0 (城镇) == 1 (郊外) == 2 (正在读图)
	Local $lReturnArray[1] = [0]
	Local $aAgentArray = GetAgentArray(0xDB) ;0xDB 生物
	For $i = 1 To $aAgentArray[0]
		if GetMapLoading() == 0 and DllStructGetData($aAgentArray[$i], 'TypeMap') == 131072 then continueloop ;城内类别2为131072的人，包括英雄和佣兵 (都应是131072)，皆不算队员 ;GetDistance($aAgentArray[$i]) > 150
		if GetMapLoading() == 0 and DllStructGetData($aAgentArray[$i], 'WeaponType') <> 0 then continueloop ;城内有手持可鉴别的武器，皆不算队员
		If DllStructGetData($aAgentArray[$i], 'Allegiance') == 1 Then
			;在此或许需测试任务人物是否会被算为队员，即，它们是否也效忠于 1 号队
				$lReturnArray[0] += 1
				ReDim $lReturnArray[$lReturnArray[0] + 1]
				$lReturnArray[$lReturnArray[0]] = $aAgentArray[$i]
		EndIf
	Next
	Return $lReturnArray
EndFunc   ;==>GetParty

Func MemberCount()
	Local $lSize = 0, $lReturn
	Local $lOffset[5] = [0, 0x18, 0x4C, 0x54, 0]
	Local $term = 2
	if GetMapLoading() == 0 then
		$term = 0
	elseif GetMapLoading() == 1 then
		$term = 2
	endif

	For $i=0 To $term ;城内时，只记录玩家，不计英雄和佣兵
		$lOffset[4] = $i * 0x10 + 0xC
		$lReturn = MemoryReadPtr($mBasePointer, $lOffset)
		$lSize += $lReturn[1]
	Next
	Return $lSize
EndFunc

#cs
;~ Description: Returns partysize.
Func MemberCount1()
   Local $lOffset[5] = [0, 0x18, 0x4C, 0x64, 0x24]
   Local $lPartyPtr = MemoryReadPtr($mBasePointer, $lOffset)
   $lOffset[3] = 0x54
   $lOffset[4] = 0xC
   Local $lPartyPlayerPtr = MemoryReadPtr($mBasePointer, $lOffset)
   Local $Party1 = MemoryRead($lPartyPtr[0], 'long') ; henchmen
   Local $Party2 = MemoryRead($lPartyPtr[0] + 0x10, 'long') ; heroes
   Local $Party3 = MemoryRead($lPartyPlayerPtr[0], 'long') ; players
   Local $lReturn = $Party1 + $Party2 + $Party3
   ;If $lReturn > 12 or $lReturn < 1 Then $lReturn = 8
   Return $lReturn
EndFunc   ;==>GetPartySize
#ce

Func ChatReceived($Channel, $Sender, $Message)

EndFunc

Func SkillActivate($castID, $targetID, $skillID, $skillActivate)

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