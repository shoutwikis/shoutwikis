#RequireAdmin
#NoTrayIcon
;USESKILLEX WAS CHANGED, also for hero skill template, also for constants.au3
;USESKILLEX WAS CHANGED
;USESKILLEX WAS CHANGED
;USESKILLEX WAS CHANGED
#include "辅助文件\常数.au3";1
#include "../../../激战接口.au3";2
#include "辅助文件\界面.au3";3
#include "辅助文件\辅助功能.au3";4
#include "辅助文件\拾起.au3";5
#include "辅助文件\清箱操作.au3";6
#include "辅助文件\鉴定.au3";7
#include "辅助文件\存放.au3";8
#include "辅助文件\买卖.au3";9
#include "辅助文件\随身统计.au3";10
#include "辅助文件\行走.au3";11
#include "辅助文件\拆解.au3";12
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
Global $totalskills = 7

Global $RaptorTimer = 0
Global $MapRepeat = 0

Global $MopTimer = 0
Global $ShieldStanceTimer = 0


; The bot will cast left to right when recharges, adrenaline, and energy allow
; Change the next line to your skill energy costs
Global $intSkillEnergy[8] = [0, 0, 0, 0, 5, 1000, 1000, 1000]
; Change the next line to your skill adrenaline costs
Global $intSkillAdrenaline[8] = [0, 4, 0,0, 0, 0, 0, 0]
Global $intSkillCastTime[8] = [1000, 0, 1000, 2000, 0, 0,  0, 0]


While Not $BotRunning
	Sleep(100)
WEnd


While True

		If Not $BotRunning Then
			Out("已暂停")
			GUICtrlSetState($Button, $GUI_ENABLE)
			GUICtrlSetData($Button, "开始")
			While Not $BotRunning
				Sleep(100)
			WEnd
		EndIf

		$RaptorTimer = TimerInit()

		CombatLoop()

		Out("此圈耗时" & Round(TimerDiff($RaptorTimer)/1000) & "秒")

WEnd

Func CombatLoop()

	Local $achievedDestination = 0

	If Not $RenderingEnabled Then ClearMemory()

	; 等待装载地图
	If (GetMapLoading() = 2) Then
		Do
			Sleep(100)
		Until WaitMapLoading()
		RndSleep(GetPing()+2000)
	EndIf

	If GetMapID() <> 545 Then
		Out("前往萨拉加遗址")
		RndSleep(2500)
		RndTravel(545)
	EndIf

	SwitchMode($DIFFICULTY_HARD)

	RndSleep(1500)
	Out("-------------------------")
	Out("出城")
	Do
		Move(2027, -4496)
	Until WaitMapLoading(444)

	Out("拿取日戟赐福")
	GoNearestNPCToCoords(-704, 15988)
	RndSleep(1000)
	Dialog(0x85)
	RndSleep(1000)


	MoveTo(-675, 13419)
	RndSleep(5000)
	TargetNearestItem()
	RndSleep(750)
	GoSignpost(-1)
	RndSleep(750)

	Local $enemy = "第一组不死生物"
	AggroMoveTo(-1950, 9871, $enemy)

	$enemy = "第二组不死生物"
	AggroMoveTo(-3684, 11485, $enemy)
	AggroMoveTo(-4705, 11411, $enemy)

	$enemy = "第三组不死生物"
	MoveTo(-9661, 12374)
	MoveTo(-12856, 9128)
	AggroMoveTo(-13839, 7961, $enemy)

	out("拿取光明赐福")
	MoveTo(-17247, 5902)

	MoveTo(-19119,6559)
	Move(-19610,7037)
	GoNearestNPCToCoords(-20587,7280)
	RndSleep(1000)
	Dialog(0x85)
	RndSleep(1000)


	$enemy = "第一组玛骨奈"
	AggroMoveTo(-22716, 11220, $enemy, 500)

	$enemy = "巨灵组"
	MoveTo(-19668, 7022)
	MoveTo(-19266, 1867)
	AggroMoveTo(-22030, -651, $enemy, 2000)

	$enemy = "不死祭祀组"
	AggroMoveTo(-19332, -9200, $enemy)

	$enemy = "第二组玛骨奈"
	AggroMoveTo(-22748, -10570, $enemy, 2000)
	AggroMoveTo(-22259, -13719, $enemy, 2000)

#cs
	out("拾起任务书")
	MoveTo(-21219, -13860)
	RndSleep(250)
	TargetNearestItem()
	Pickupitem(-1)
	RndSleep(250)
	PickupItem(-1)
	RndSleep(250)

	$enemy = "触发出的玛古奈"
	AggroMoveTo(-22648, -9901, $enemy)
	AggroMoveTo(-18993, -9491, $enemy)

	out("走向庙宇")
	MoveTo(-22858, -9851)
	MoveTo(-22035, -13729)
#ce

	$enemy = "庙宇怪"
	AggroMoveTo(-18239, -13084, $enemy)


	out("触发玛古奈领队")
	MoveTo(-18176, -13412)
	Local $shrine = GetNearestSignpostToCoords(-18176, -13412)
	RndSleep(1000)
	GoSignpost($shrine)    ;trigger shrine
	RndSleep(1000)
	GoSignpost(-1)    ;trigger shrine
	RndSleep(3000)

	$enemy = "玛古奈领队组"
	AggroMoveTo(-18176, -13412, $enemy)
	RndSleep(1000)

	UpdateAndRestart()

EndFunc

Func AggroMoveTo($x, $y, $s = "", $z = 1450)
	out("前往 " & $s)
	Local $random = 50
	Local $iBlocked = 0

	Move($x, $y, $random)


	Local $lMe = GetAgentByID(-2)
	Local $coordsX =DllStructGetData($lMe, "X")
	Local $coordsY = DllStructGetData($lMe, "Y")
	Local $oldCoordsX
	Local $oldCoordsY
	Local $nearestenemy
	Local $lDistance
	Local $lMe

	Do
		RndSleep(250)
		$oldCoordsX = $coordsX
		$oldCoordsY = $coordsY
		$nearestenemy = GetNearestEnemyToAgent(-2)
		$lDistance = GetDistance($nearestenemy, -2)
		If $lDistance < $z AND DllStructGetData($nearestenemy, 'ID') <> 0 Then
			Fight($z, $s)

		EndIf
		RndSleep(250)
		$lMe = GetAgentByID(-2)
		$coordsX =DllStructGetData($lMe, "X")
		$coordsY = DllStructGetData($lMe, "Y")
		If $oldCoordsX = $coordsX AND $oldCoordsY = $coordsY Then
			$iBlocked += 1
			Move($coordsX, $coordsY, 500)
			RndSleep(350)
			Move($x, $y, $random)
		EndIf
	Until ComputeDistanceEx($coordsX, $coordsY, $x, $y) < 250 OR $iBlocked > 20
EndFunc


Func Fight($x, $s = "")
	out("打击 " & $s & "!")
	Local $nearestenemy, $useSkill, $target, $distance, $targetHP, $recharge, $energy, $adrenaline
	Do
		RndSleep(250)
		$nearestenemy = GetNearestEnemyToAgent(-2)
	Until DllStructGetData($nearestenemy, 'ID') <> 0

	Do
		$useSkill = -1
		$target = GetNearestEnemyToAgent(-2)
		$distance = GetDistance($target, -2)
		If DllStructGetData($target, 'ID') <> 0 AND $distance < $x Then
			ChangeTarget($target)
			RndSleep(150)
			CallTarget($target)
			RndSleep(150)
			Attack($target)
			RndSleep(150)
		ElseIf DllStructGetData($target, 'ID') = 0 OR $distance > $x Then
			exitloop
		EndIf

		For $i = 0 To $totalskills

			$targetHP = DllStructGetData(GetCurrentTarget(),'HP')
			if $targetHP = 0 then ExitLoop

			$distance = GetDistance($target, -2)
			if $distance > $x then ExitLoop

			$energy = GetEnergy(-2)
			$recharge = DllStructGetData(GetSkillBar(), "Recharge" & $i+1)
			$adrenaline = DllStructGetData(GetSkillBar(), "Adrenaline" & $i+1)

			If $recharge = 0 And $energy >= $intSkillEnergy[$i] And $adrenaline >= ($intSkillAdrenaline[$i]*25 - 25) Then
				$useSkill = $i + 1
				rndsleep(250)
				UseSkill($useSkill, $target)
				RndSleep($intSkillCastTime[$i]+1000)
			EndIf
			if $i = $totalskills then $i = 0
		Next

	Until DllStructGetData($target, 'ID') = 0 OR $distance > $x
	If GetHealth(-2) < 2400 Then UseSkill(7, -2)
		rndsleep(3000)
		;PickupItems2(-1, $x)
EndFunc

Func MoveX($aX, $aY, $aRandom = 50)
	;returns true if successful
	Local $rX
	Local $rY
	$rX = Random(-$aRandom, $aRandom)
	$rY = Random(-$aRandom, $aRandom)
	Out("")
	Out($aX+$rX)
	Out($aY+$rY)
	Out("")
	If GetAgentExists(-2) Then
		DllStructSetData($mMove, 2, $aX + $rX)
		DllStructSetData($mMove, 3, $aY + $rY)
		Enqueue($mMovePtr, 16)
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>Move



Func ComputeDistanceEx($x1, $y1, $x2, $y2)
	Return Sqrt(($y2 - $y1) ^ 2 + ($x2 - $x1) ^ 2)
	$dist = Sqrt(($y2 - $y1) ^ 2 + ($x2 - $x1) ^ 2)
	;ConsoleWrite("Distance: " & $dist & @CRLF)

EndFunc   ;==>ComputeDistanceEx


Func UpdateAndRestart()

	; GetIsDead 似不能检测微光雪人生死， DllStructGetData($agentStruct, "HP")也不行
	;If GetIsDead(-2) Then
	;	$FailCount += 1
	;	GUICtrlSetData($FailsLabel, $FailCount)
	;Else
	;	$RunCount += 1
;		if $RunCount <> 0 then
;			GUICtrlSetData($RunsLabel, $RunCount)
;			$SuccessRate = $SuccessCount/$RunCount*100
;			GUICtrlSetData($RateLabel, $SuccessRate)
;		Endif
	;EndIf

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
			If StringInStr(GetAgentName($lAgentArray[$i]),"Snowman") = 0 Then ContinueLoop
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
	Until (GetAgentByName("Corpse of Koris Deeprunner") <> 0)
EndFunc

Func Leave()
	Sleep(Random(3000,5000))
	Resign()
	Sleep(Random(5000,6000))
	ReturnToOutpost()
	WaitForLoad()
EndFunc

Func AggroCount()
	Local $lAgentArray = GetAgentArray(0xDB)
	Local $lCount = 0

	For $i = 1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], 'Allegiance') <> 3 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgentArray[$i], 'Effects'), 0x0010) > 0 Then ContinueLoop
		If StringInStr(GetAgentName($lAgentArray[$i]), "Raptor Nestling") = 0 Then ContinueLoop
		If GetDistance($lAgentArray[$i])<1070 Then
			$lCount += 1
		EndIf
	Next
	Return $lCount
EndFunc

Func TFDisplay($TF=False)
	local $lvalue
	if $TF = True Then
		$lvalue = "有效"
	Else
		$lvalue = "失效"
	EndIf
	return $lvalue
EndFunc