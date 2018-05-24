#RequireAdmin
#NoTrayIcon

#include "辅助文件\常数.au3";1
#include "../../激战接口.au3";2
#include "辅助文件\界面.au3";3
#include "辅助文件\辅助功能.au3";4
#include "辅助文件\随身统计.au3";10
#include "辅助文件\行走.au3";11
#include "辅助文件\修补.au3";12
#include "辅助文件\野外操作.au3";12
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <GuiEdit.au3>

Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Opt("MustDeclareVars", True)

;WAITMAPLOADING
;115, 293
Global $language = 0
Global $SnowmanTimer = 0
Global $MapRepeat = 0
Global $master_Timer=TimerInit()
While Not $BotRunning
	Sleep(100)
WEnd

; 装技能表
If GetMapLoading() == $INSTANCETYPE_OUTPOST Then LoadSkillTemplate($SkillBarTemplate)

While True

	While (CountSlots() > 4)

		If Not $BotRunning Then
			Out("已暂停")
			GUICtrlSetState($Button, $GUI_ENABLE)
			GUICtrlSetData($Button, "开始")
			While Not $BotRunning
				Sleep(100)
			WEnd
		EndIf
		$SnowmanTimer = TimerInit()
			if TimerDiff($master_Timer) > 60000*30 Then
			Local $loop_Timer = TimerInit()
			out("每半小时暂停十分钟")
			while TimerDiff($loop_Timer) < -1 ;60000*10 ;节日后改回
				local $sleeper=random(60000*10, 60000*15)
				sleep($sleeper)
			WEnd
			$master_Timer = TimerInit()
			EndIf
		CombatLoop()
		Out("此圈耗时" & Round(TimerDiff($SnowmanTimer)/1000) & "秒")
	WEnd

	If (CountSlots() < 5) Then
		If Not $BotRunning Then
			Out("已暂停")
			GUICtrlSetState($Button, $GUI_ENABLE)
			GUICtrlSetData($Button, "开始")
			While Not $BotRunning
				Sleep(100)
			WEnd
		EndIf
		RndSleep(4500)
		PLACE_FOR_INVENTORY()
	EndIf

WEnd

Func CombatLoop()

	If Not $RenderingEnabled Then ClearMemory()

	$language = GetDisplayLanguage() ;中文=6 字母=0

	; 等待装载地图
	If (GetMapLoading() = 2) Then
		Do
			Sleep(100)
		Until WaitMapLoading()
		RndSleep(GetPing()+2000)
	EndIf

	If GetMapID() <> $MAP_ID_UMBRAL Then
		Out("前往石穴")
		$MapRepeat = 0
		RndSleep(5500)
		RndTravel($MAP_ID_UMBRAL)
	EndIf

	If GetMapID() = $MAP_ID_UMBRAL Then
		$MapRepeat += 1
	EndIf

	CheckRealPlayerIsInOutPost()

	if $DifficultyNormal = True Then
		SwitchMode($DIFFICULTY_NORMAL)
		Sleep(GetPing()+500)
	elseif $DifficultyNormal = False Then
		SwitchMode($DIFFICULTY_HARD)
		Sleep(GetPing()+500)
	EndIf

	RndSleep(3500)
	Out("-------------------------")
	Out("正在进入任务")
	GoNearestNPCToCoords(-23884, 13954)
	Dialog(132)
	WaitMapLoading(701)

	SetDisplayedTitle(0x27)
	;Sleep(GetPing()+1000)

	UseSkillEx($DS)
	RndSleep(GetPing()+500)
	UseSkillEx($SC)
	RndSleep(GetPing()+500)

	Local $Koris = 0
	if $language = 6 then $Koris = GetAgentByName("深奔 高利斯")
	if $language = 0 then $Koris = GetAgentByName("Koris Deeprunner")
	;Local $Glimmering = GetAgentByName("Glimmering Snowman")

	If GetDeldrimorTitle() < 160000 Then
		Out("拿取赐福")
		GoNearestNPCToCoords(-14078, 15449)
		Dialog(132)
	EndIf

	Out("-------------------------")
	DisplayCounts()
	Out("-------------------------")

	Sleep(GetPing()+1500)

	ChangeTarget($Koris)

	;MoveTo(-14532, 12443);备用
	MoveTo(-14351, 12974)

	UseSkillEx($SQ)
	RndSleep(GetPing()+500)
	UseSkillEx($SF)
	RndSleep(GetPing()+500)
	UseSkillEx($SD)
	RndSleep(GetPing()+500)

	TargetNearestEnemy()

	MoveAggroing(-15254, 10699) ;第一点

	RndSleep(6000)
	;WaitForNpcDeath() ;Corpse of Koris Deeprunner

	MoveAggroing(-15658, 10144);测试 ;最远点/中间点
	;MoveAggroing(-15840, 9873); 备用
	;MoveAggroing(-15553, 10358)

	WaitForNoMotion(15000)     ; 等待=======================================================

	If GetIsDead(-2) Then
		$FailCount += 1
		GUICtrlSetData($FailsLabel, $FailCount)
		Out("开始下一轮")
		Leave()
		Return 0
	EndIf


	WaitForNpcDeath() ; 等出现npc尸体

	If GetIsDead(-2) Then
		$FailCount += 1
		GUICtrlSetData($FailsLabel, $FailCount)
		Out("开始下一轮")
		Leave()
		Return 0
	EndIf

	MoveAggroing(-15268, 12668) ;角落点

	WaitForNpcDeath() ; 等出现npc尸体, 未等, 或许因已有尸体
	WaitFor(4000)

	If GetIsDead(-2) Then
		$FailCount += 1
		GUICtrlSetData($FailsLabel, $FailCount)
		Out("开始下一轮")
		Leave()
		Return 0
	EndIf

	; 或用UseSkillEx2
	If DllStructGetData(GetEffect($SKILL_ID_DS), "SkillID") == 0 Then
		UseSkillEx($DS)
	EndIf

	Do
		WaitFor(50)
	until (IsRecharged($WD) and (GetEnergy(-2) >= $skillCost[$WD]))
	; 或用UseSkillEx2
	If GetIsDead(-2) Then
		$FailCount += 1
		GUICtrlSetData($FailsLabel, $FailCount)
		Out("开始下一轮")
		Leave()
		Return 0
	EndIf

	UseSkillEx($WD)
	RndSleep(GetPing()+500)

	Out("杀")
	UseSkillEx($DC, SelectEnemy()) ; 第二个参数:人物体或人物号都行
	;TargetNearestEnemy()
	;UseSkillEx($DC, -1)

	WaitFor(6000)

	If GetIsDead(-2) Then
		$FailCount += 1
		GUICtrlSetData($FailsLabel, $FailCount)
		Out("开始下一轮")
		Leave()
		Return 0
	EndIf

	#cs
	If DllStructGetData($Glimmering,"HP") == 0 Then
		$BossKills += 1
		GUICtrlSetData($BossLabel, $BossKills)
	EndIf
	#ce
	Out("捡")
	PickUpLoot()

	UpdateAndRestart()

EndFunc

Func UpdateAndRestart()

	; GetIsDead 似不能检测微光雪人生死， DllStructGetData($agentStruct, "HP")也不行
	If GetIsDead(-2) Then
		$FailCount += 1
		GUICtrlSetData($FailsLabel, $FailCount)
	Else
		$RunCount += 1
		GUICtrlSetData($RunsLabel, $RunCount)
	EndIf

	Out("开始下一轮")
	Leave()

EndFunc


Func WaitForNoMotion($lMs)
	If GetIsDead(-2) Then Return
	Local $lTimer = TimerInit()
	Local $MessageInterval = TimerInit()
	Local $lAgentArray = GetAgentArray(0xDB)
	Local $Motion = False ;assume there's no motion
	;Local $StuckTimer = TimerInit()

	RndSleep(10000)
	Do
		Sleep(75)
		If GetIsDead(-2) Then Return
		StayAlive()
		$Motion = False
		$lAgentArray = GetAgentArray(0xDB)
		For $i=1 To $lAgentArray[0]
			If DllStructGetData($lAgentArray[$i], "Allegiance") <> 0x3 Then ContinueLoop
			If ($language=0) and (StringInStr(GetAgentName($lAgentArray[$i]),"Snowman") = 0) Then ContinueLoop
			if ($language=6) and (StringInStr(GetAgentName($lAgentArray[$i]),"雪人") = 0) Then ContinueLoop
			If DllStructGetData($lAgentArray[$i], "HP") <= 0 Then ContinueLoop
			if (DllStructGetData($lAgentArray[$i], 'MoveX') <> 0) or (DllStructGetData($lAgentArray[$i], 'MoveY') <> 0) Then
				if TimerDiff($MessageInterval) > 1500 Then
					out("有怪移动 - 等待")
					$MessageInterval = TimerInit()
				EndIf
				$Motion = True ;there is motion
			EndIf
		Next
		if $Motion = False Then
			out("无怪移动 - 继续")
			out("")
			ExitLoop
		EndIf
	Until TimerDiff($lTimer) > $lMs
EndFunc

Func WaitForNpcDeath()
	If GetIsDead(-2) Then Return
	Do
		Sleep(75)
		If GetIsDead(-2) Then Return
		StayAlive()
	Until (GetAgentByName("Corpse of Koris Deeprunner") <> 0) or (GetAgentByName("的屍體")<>0)
EndFunc

Func Leave()
	Sleep(Random(3000,5000))
	;Resign()
	;Sleep(Random(5000,6000))
	TravelTo($MAP_ID_UMBRAL)
	;WaitForLoad()
EndFunc