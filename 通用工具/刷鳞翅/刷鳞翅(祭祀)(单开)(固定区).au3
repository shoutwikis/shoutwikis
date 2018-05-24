#RequireAdmin
#NoTrayIcon

#include-once
#include "../../激战接口.au3"
#include "常数.au3"
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <MsgBoxConstants.au3>
#include <GuiEdit.au3>
#include "修补.au3"

Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Opt("MustDeclareVars", True)

#cs
Astralrium 502
npc coord -1662, 3961

kamadan 449
-8147, 9551
-8441, 11975
npc coord -11254 15220
#ce
;~ ==== 常数 ====

;~ 技能码
Global Const $JiNengMa = "OAmjIyks5Q0gXTlT+geT7YNTOTA" ;OACiIykMRDeNVO5D6NtW2M5MB ;OAej8NiMJTlTXTdiMTeTOTHQNQA

;~ 各技能 技能栏内 位置
Global Const $zhaoHuan = 1 ;召唤
Global Const $wenZhang = 2 ;纹章
Global Const $xueGe = 3 ;血歌
Global Const $liXue = 4 ;沥血
Global Const $shengNu = 5 ;盛怒
Global Const $xinZhi = 6 ;心智
Global Const $baoZhang = 7 ;爆长
Global Const $enCi = 8 ;恩赐

;~ 各技能 能量需求
Global $haoNeng[9];耗能
$haoNeng[$zhaoHuan] = 5 ;召唤
$haoNeng[$wenZhang] = 0 ;纹章
$haoNeng[$xueGe] = 5 ;血歌
$haoNeng[$liXue] = 10 ;沥血
$haoNeng[$shengNu] = 5 ;盛怒
$haoNeng[$xinZhi] = 5 ;心智
$haoNeng[$baoZhang] = 5 ;爆长
$haoNeng[$enCi] = 10 ;恩赐

;~ 技能号码 ： 用以检测 技能 所剩 有效时间
;~ 技能号码来源: http://wiki.guildwars.com/wiki/Guild_Wars_Wiki:Game_integration
Global Const $JI_NENG_HAO_XINZHI = 2411
Global Const $JI_NENG_HAO_BAOZHANG = 1229
Global Const $JI_NENG_HAO_ENCI = 1230

;~ ==============

#Region 界面设置
Global Const $mainGui = GUICreate("刷鳞翅", 350, 143)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
Global $Input
If $doLoadLoggedChars Then
	$Input = GUICtrlCreateCombo("", 8, 8, 129, 21)
		GUICtrlSetData(-1, GetLoggedCharNames())
Else
	$Input = GUICtrlCreateInput("character name", 8, 8, 129, 21)
EndIf
Global $makePcons = GUICtrlCreateCheckbox("做补品", 8, 35, 80, 25)
GUICtrlSetState($makePcons, $GUI_DISABLE)

GUICtrlCreateLabel("成功次数:", 8, 60, 70, 17)
Global Const $RunsLabel = GUICtrlCreateLabel($RunCount, 80, 60, 50, 17)
GUICtrlCreateLabel("失败次数:", 8, 75, 70, 17)
Global Const $FailsLabel = GUICtrlCreateLabel($FailCount, 80, 75, 50, 17)
Global Const $Checkbox = GUICtrlCreateCheckbox("停止激战成像", 8, 95, 129, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "ToggleRendering")
Global Const $Button = GUICtrlCreateButton("开始", 8, 115, 131, 25)
	GUICtrlSetOnEvent(-1, "GuiButtonHandler")
Global Const $StatusLabel = GUICtrlCreateLabel("", 8, 148, 125, 17)

Global $GLOGBOX = GUICtrlCreateEdit("", 140, 8, 200, 132, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
GUICtrlSetColor($GLOGBOX, 65280)
GUICtrlSetBkColor($GLOGBOX, 0)
GUISetState(@SW_SHOW)

;~ 功能: 处理“开始/暂停”键
Func GuiButtonHandler()
	If $BotRunning Then
		GUICtrlSetData($Button, "此圈后暂停")
		GUICtrlSetState($Button, $GUI_DISABLE)
		$BotRunning = False
	ElseIf $BotInitialized Then
		GUICtrlSetData($Button, "暂停")
		$BotRunning = True
	Else
		Out("正在启动")
		Local $CharName = GUICtrlRead($Input)
		If $CharName=="" Then
			If Initialize(ProcessExists("gw.exe"), True, True, True) = False Then
				MsgBox(0, "失败", "激战未打开.")
				Exit
			EndIf
		Else
			If Initialize($CharName, True, True, True) = False Then ;
				MsgBox(0, "失败", "未找到角色: '"&$CharName&"'")
				Exit
			EndIf
		EndIf
		GUICtrlSetState($Checkbox, $GUI_ENABLE)
		GUICtrlSetData($Button, "暂停")
		WinSetTitle($mainGui, "", "刷鳞翅-" & GetCharname())
		$BotRunning = True
		$BotInitialized = True
	EndIf
EndFunc
#EndRegion 界面设置结束

Global $GuDing = 1 ;是否需要固定起点 (1:是, 0:否)
Global $StuckTimeLimit = 200000
Global $SkaleFinTimer

Out("等待输入")

While Not $BotRunning
	Sleep(100)
WEnd

SwitchMode(0) ;正常模式，1为困难模式
Global $master_Timer = TimerInit()
;自动装载技能
If GetMapLoading() == $INSTANCETYPE_OUTPOST Then LoadSkillTemplate($JiNengMa)
Sleep(100)

While True

	TravelTo(491) ;城内地图号: 491

	$GuDing = 1 ;是否需要固定起点 (1:是, 0:否)

	While (CountSlots() > 4)
		If Not $BotRunning Then
			Out("已暂停")
			GUICtrlSetState($Button, $GUI_ENABLE)
			GUICtrlSetData($Button, "开始")
			While Not $BotRunning
				Sleep(100)
			WEnd
		EndIf

		CombatLoop()
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
		PLACE_FOR_INVENTORY()
		$GuDing = 1
	EndIf
WEnd

Func CombatLoop()

	If Not $RenderingEnabled Then ClearMemory()

	; 等待地图装载
	If (GetMapLoading() = 2) Then
		Do
			Sleep(100)
		Until WaitMapLoading()
		RndSleep(GetPing()+100)
	EndIf

	Out("")
	Out("出城")

	;MoveTo(3647, 3677)
	Do
		Move(4590, 4490)
	Until WaitMapLoading(483) ;城外地图号

	if $GuDing = 1 then
		Out("固定起点")
		Do
			Move(-19993, -20197)
		Until WaitMapLoading(491) ;城内地图号
		Do
			Move(4590, 4490)
		Until WaitMapLoading(483) ;城外地图号
		$GuDing = 0
	EndIf

	if TimerDiff($master_Timer) > 60000*30 Then
		Local $loop_Timer = TimerInit()
		Local $pause_time = 60000*Random(15,20)
		out("每半小时暂停，暂停"&Round($pause_time/60000)&"分钟")
		while TimerDiff($loop_Timer) < -1
			sleep(500)
		WEnd
		$master_Timer = TimerInit()
	EndIf

	Out("前往第一点")
	Zou_Xiang(-18823, -12793) ;走向敌人
	WaitUntilInRangeFoesDie() ;等待敌人死去; 等待时用技能1-5
	PickUpLoot()              ;捡起物品

	Out("前往第二点")
	Zou_Xiang(-17895, -8945)
	WaitUntilInRangeFoesDie()
	PickUpLoot()

	Out("前往第三点")
	Zou_Xiang(-12139, -9637)
	WaitUntilInRangeFoesDie()
	PickUpLoot()

	Out("前往第四点")
	Zou_Xiang(-9448, -12896)
	WaitUntilInRangeFoesDie()
	PickUpLoot()

	Out("前往第五点")
	Zou_Xiang(-8326, -15258)
	WaitUntilInRangeFoesDie()
	PickUpLoot()

	If GetIsDead(-2) Then
		$FailCount += 1
		GUICtrlSetData($FailsLabel, $FailCount)
	Else
		$RunCount += 1
		GUICtrlSetData($RunsLabel, $RunCount)
	EndIf

	Out("开始下一轮")
	Out("")
	Sleep(Random(200,300))
	Resign()
	Sleep(Random(5000,6000))
	ReturnToOutpost()
	WaitMapLoading()

	ClearMemory()
	_REDUCEMEMORY()
EndFunc

;~ 功能: 维持加持。
Func WeiChi_JiaChi()

	;时间单位为: 微秒。 例: 2000=2秒
	if GetEffectTimeRemaining($JI_NENG_HAO_XINZHI)<2000 then useSkillEx($xinZhi) ;如加持所剩有效时间小于两秒，则重上加持


EndFunc

;~ 功能: 用技能1, 7, 8, 2, 3, 4, 5
Func Sha()
	if YouRen() then useSkillEx($zhaoHuan) ;如周身有敌人，则用技能，否则不用
	if YouRen() and GetEffectTimeRemaining($JI_NENG_HAO_BAOZHANG)<2000 then useSkillEx($baoZhang)
	;if YouRen() and GetEffectTimeRemaining($JI_NENG_HAO_ENCI)<2000 then useSkillEx($enCi)
	if YouRen() then useSkillEx($wenZhang)
	if YouRen() then useSkillEx($xueGe)
	if YouRen() then useSkillEx($liXue)
	if YouRen() then useSkillEx($shengNu)
EndFunc


;~ 功能: 行走; 限野外行走， 定义内会 边走边用技能/加持
Func Zou_Xiang($aX, $aY, $aRandom = 50)
	Local $lBlocked = 0
	Local $lMe
	Local $lMapLoading = GetMapLoading(), $lMapLoadingOld
	Local $lDestX = $aX + Random(-$aRandom, $aRandom)
	Local $lDestY = $aY + Random(-$aRandom, $aRandom)
	Local $lAngle = 40

	WeiChi_JiaChi() ;维持加持

	Move($lDestX, $lDestY, 0)

	Do
		Sleep(100)
		$lMe = GetAgentByID(-2)

		If DllStructGetData($lMe, 'HP') <= 0 Then ExitLoop

		$lMapLoadingOld = $lMapLoading
		$lMapLoading = GetMapLoading()
		If $lMapLoading <> $lMapLoadingOld Then ExitLoop

		WeiChi_JiaChi() ;维持加持

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			$lBlocked += 1
			If $lBlocked < 5 Then
				$lDestX = $aX + Random(-$aRandom, $aRandom)
				$lDestY = $aY + Random(-$aRandom, $aRandom)
				Move($lDestX, $lDestY, 0)
			ElseIf $lBlocked < 10 Then
				$lAngle += 40
				Move(DllStructGetData($lMe, 'X') + 240 * Sin($lAngle), DllStructGetData($lMe, 'Y') + 240 * Cos($lAngle))
			EndIf
		Else
			$lBlocked = 0
		EndIf
	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < 25 Or $lBlocked > 14
EndFunc

;~ 检测一定范围内是否有 活的敌人， 范围默认为1500
Func YouRen($lrange = 1500)
	Local $lAgentArray
	Local $lDistance

	$lAgentArray = GetAgentArray(0xDB) ;收集区内所有人物

	For $i=1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], 'Allegiance') <> 3 Then ContinueLoop ;如不是敌人,则跳过
		If DllStructGetData($lAgentArray[$i], 'HP') <= 0 Then ContinueLoop ;如已死,则跳过
		If BitAND(DllStructGetData($lAgentArray[$i], 'Effects'), 0x0010) > 0 Then ContinueLoop ;用不同方法检测人物是否已死; 如已死，则跳过
		$lDistance = GetDistance($lAgentArray[$i]) ;获取人物与自己的距离
		If $lDistance < $lrange Then ;如距离小于预定范围，则
			Return True ;回复 有人
		EndIf
	Next

	return false ;如功能到这一步前并未回复有人， 则回复 无人
EndFunc

;~ 功能: 等待一定范围内的敌人死去， 范围默认为 1500, 等待期间用技能杀敌
Func WaitUntilInRangeFoesDie($lrange = 1500)
	Local $lAgentArray
	Local $lMe
	Local $lDistance
	Local $lShouldExit = FALSE
	Local $Deadlock = TimerInit()
	While NOT $lShouldExit

		If TimerDiff($Deadlock) > 60000 Then
			Out("等待超一分钟")
			ExitLoop
		EndIf

		;if GetEffectTimeRemaining($JI_NENG_HAO_BAOZHANG)<2000 then useSkillEx($baoZhang) ;维持加持
		;if GetEffectTimeRemaining($JI_NENG_HAO_ENCI)<2000 then useSkillEx($enCi) ;维持加持
		Sha() ;用技能1, 7, 8, 2, 3, 4, 5

		Sleep(300)

		TargetNearestEnemy()
		sleep(500)

		if getisdead(-1) then
			Do
				Out("寻找下一目标")
				TargetNextEnemy()
				If TimerDiff($Deadlock) > 10000 Then
					Out("等待超十秒x")
					ExitLoop
				EndIf
			Until Not GetIsDead(getagentbyid(-1))
		endif

		if GetDistance()<$lrange then
			ChangeTarget(getagentbyid(-1))
			attack(getagentbyid(-1))
		endif

		$lMe = GetAgentByID(-2)
		If GetIsDead($lMe) Then Return
		$lAgentArray = GetAgentArray(0xDB)
		$lShouldExit = TRUE
		For $i=1 To $lAgentArray[0]
			If DllStructGetData($lAgentArray[$i], 'Allegiance') <> 3 Then ContinueLoop
			If DllStructGetData($lAgentArray[$i], 'HP') <= 0 Then ContinueLoop
			If BitAND(DllStructGetData($lAgentArray[$i], 'Effects'), 0x0010) > 0 Then ContinueLoop
			$lDistance = GetDistance($lAgentArray[$i])
			If $lDistance < $lrange Then
				$lShouldExit = FALSE
				ExitLoop
			EndIf
		Next

	WEnd
EndFunc


; Returns a good target for watrels
; Takes the agent array as returned by GetAgentArray(..)
Func GetGoodTarget(Const ByRef $lAgentArray)
	Local $lMe = GetAgentByID(-2)
	For $i=1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], "Allegiance") <> 0x3 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], "HP") <= 0 Then ContinueLoop
		If GetDistance($lMe, $lAgentArray[$i]) > $RANGE_NEARBY Then ContinueLoop
		If GetHasHex($lAgentArray[$i]) Then ContinueLoop
		If Not GetIsEnchanted($lAgentArray[$i]) Then ContinueLoop
		Return DllStructGetData($lAgentArray[$i], "ID")
	Next
EndFunc

; Uses a skill
; It will not use if I am dead, if the skill is not recharged, or if I don't have enough energy for it
; It will sleep until the skill is cast, then it will wait for aftercast.
Func UseSkillEx($lSkill, $lTgt=-2, $aTimeout = 3000)
	If GetIsDead(-2) Then Return
	If Not IsRecharged($lSkill) Then Return
	If GetEnergy(-2) < $haoNeng[$lSkill] Then Return

	Local $lDeadlock = TimerInit()
	UseSkill($lSkill, $lTgt)
	Do
		Sleep(50)
		if $lSkill = 1 then ExitLoop
		If GetIsDead(-2) = 1 Then Return
	Until (Not IsRecharged($lSkill)) Or (TimerDiff($lDeadlock) > $aTimeout)

	if $lSkill = 6 then Return

	RndSleep(750)
EndFunc

; Checks if skill given (by number in bar) is recharged. Returns True if recharged, otherwise False.
Func IsRecharged($lSkill)
	Return GetSkillBarSkillRecharge($lSkill)==0
EndFunc

Func CHECKAREA($AX, $AY)
	Local $RET = False
	Local $PX = DllStructGetData(GetAgentByID(-2), "X")
	Local $PY = DllStructGetData(GetAgentByID(-2), "Y")
	If ($PX < $AX + 500) And ($PX > $AX - 500) And ($PY < $AY + 500) And ($PY > $AY - 500) Then
		$RET = True
	EndIf
	Return $RET
EndFunc   ;==>CHECKAREA
;rendering========================================
#cs
Func EnableRendering()
	_EnableRendering()
	;MemoryWrite($mDisableRendering, 0)
EndFunc   ;==>EnableRendering

;~ Description: Disable graphics rendering.
Func DisableRendering()
	_DisableRendering()
	;MemoryWrite($mDisableRendering, 1)
EndFunc   ;==>DisableRendering
#ce
;~ Description: Enable graphics rendering.
Func _EnableRendering()

	WinSetState($mGWHwnd,"",@SW_SHOW)
	;AdLibUnRegister("_REDUCEMEMORY")
	;SetMaxMemory()
	$RenderingEnabled = True
	MemoryWrite($mDisableRendering, 0)
EndFunc   ;==>EnableRendering

;~ Description: Disable graphics rendering.
Func _DisableRendering()

	WinSetState($mGWHwnd,"",@SW_HIDE)
	;ClearMemory()
	;_REDUCEMEMORY()
	$RenderingEnabled = False
	MemoryWrite($mDisableRendering, 1)
	;AdLibRegister("_REDUCEMEMORY",20000)
EndFunc   ;==>DisableRendering

Func _REDUCEMEMORY($GWPID = WinGetProcess($mGWHwnd))
	If $GWPID <> -1 Then
		Local $AI_HANDLE = DllCall("kernel32.dll", "int", "OpenProcess", "int", 2035711, "int", False, "int", $GWPID)
		Local $AI_RETURN = DllCall("psapi.dll", "int", "EmptyWorkingSet", "long", $AI_HANDLE[0])
		DllCall("kernel32.dll", "int", "CloseHandle", "int", $AI_HANDLE[0])
	Else
		Local $AI_RETURN = DllCall("psapi.dll", "int", "EmptyWorkingSet", "long", -1)
	EndIf
	Return $AI_RETURN[0]
EndFunc   ;==>_REDUCEMEMORY

Func TOGGLERENDERING()
	If $RenderingEnabled Then
		DisableRendering()
		$RenderingEnabled = False
	Else
		EnableRendering()
		$RenderingEnabled = True
	EndIf
EndFunc   ;==>TOGGLERENDERING
;rendering========================================
#cs
;~ Description: Toggle rendering and also hide or show the gw window
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
EndFunc   ;==>ToggleRendering
#ce
;~ Description: Print to console with timestamp
Func Out($TEXT)
	;If $BOTRUNNING Then FileWriteLine($FLOG, @CRLF & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " & $TEXT)
	Local $TEXTLEN = StringLen($TEXT)
	Local $CONSOLELEN = _GUICtrlEdit_GetTextLen($GLOGBOX)
	If $TEXTLEN + $CONSOLELEN > 30000 Then GUICtrlSetData($GLOGBOX, StringRight(_GUICtrlEdit_GetText($GLOGBOX), 30000 - $TEXTLEN - 1000))
	_GUICtrlEdit_AppendText($GLOGBOX, @CRLF & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " & $TEXT)
	_GUICtrlEdit_Scroll($GLOGBOX, 1)
EndFunc   ;==>OUT

;~ Description: guess what?
Func _exit()
	Exit
EndFunc
#cs

Func arrayContains($array, $item)
	For $i = 1 To $array[0]
		If $array[$i] == $item Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>arrayContains
#ce
#EndRegion Pcons


Func MoveAggroing($lDestX, $lDestY, $lRandom = 150)


	If GetIsDead(-2) Then Return

	if isrecharged(6) and (DllStructGetData(GetEffect(2411), "SkillID") = 0) and (DllStructGetData(GetEffect(1037), "SkillID") = 0) then
		UseSkillEx(6,-2)
	EndIf

	if isrecharged(7) and isrecharged(8) and (DllStructGetData(GetEffect(2411), "SkillID") = 0) and (DllStructGetData(GetEffect(1037), "SkillID") = 0) then
		UseSkillEx(7,-2)
		UseSkillEx(8,-2)
	EndIf

	Local $lMe, $lAgentArray
	Local $lBlocked

	Local $lAngle
	Local $stuckTimer = TimerInit()

	Move($lDestX, $lDestY, $lRandom)



	Do
		RndSleep(50)

		$lMe = GetAgentByID(-2)

		$lAgentArray = GetAgentArray(0xDB)

		If GetIsDead($lMe) Then Return False

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then

			$lBlocked += 1
			If $lBlocked < 4 Then
				Move($lDestX, $lDestY, $lRandom)
			Elseif $lBlocked < 8 then
				$lAngle += 40
				Move(DllStructGetData($lMe, 'X')+300*sin($lAngle), DllStructGetData($lMe, 'Y')+300*cos($lAngle))
			elseif $lBlocked >= 8 Then
				kill()
			EndIf


		elseIf $lBlocked > 0 Then

			If TimerDiff($ChatStuckTimer) > 3000 Then	; use a timer to avoid spamming /stuck
				SendChat("stuck", "/")
				$ChatStuckTimer = TimerInit()
			EndIf
			$lBlocked = 0
			TargetNearestEnemy()
			sleep(1000)
			If GetDistance() > 1100 Then ; target is far, we probably got stuck.
				If TimerDiff($ChatStuckTimer) > 3000 Then ; dont spam
					SendChat("stuck", "/")
					$ChatStuckTimer = TimerInit()
					RndSleep(GetPing())
				EndIf
			EndIf
		EndIf

	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < $lRandom*1.5
	Return True
EndFunc

#cs
Func RndTravel($aMapID)
	Local $UseDistricts = 11 ; 7=eu, 8=eu+int, 11=all(incl. asia)
	; Region/Language order: eu-en, eu-fr, eu-ge, eu-it, eu-sp, eu-po, eu-ru, int, asia-ko, asia-ch, asia-ja
	Local $ComboDistrict[11][2]=[[2, 0],[2, 2],[2, 3],[2, 4], [2, 5],[2, 9],[2, 10],[-2, 0],[1, 0], [3, 0], [4, 0]]
	;Local $Region[11] = [2, 2, 2, 2, 2, 2, 2, -2, 1, 3, 4]
	;Local $Language[11] = [0, 2, 3, 4, 5, 9, 10, 0, 0, 0, 0]
	Local $Random = Random(7, $UseDistricts - 1, 10)
	MoveMap($aMapID, $ComboDistrict[$Random][0], 0, $ComboDistrict[$Random][1])
	WaitMapLoading($aMapID)
	Sleep(GetPing() + 1500)
EndFunc   ;==>RndTravel
#ce