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

;Arkjok Ward ID = 380
;Yohlon Haven ID = 381
;return: -20011, -14498
;exit: 4362, 831
;shrine: -17223, -12543
;point 1
;point 2
;point 3
;point 4
;point 5

Global $reZone = 0

While Not $BotRunning
	Sleep(100)
WEnd

While True
		If Not $BotRunning Then
			;Out("已暂停")
			AdlibUnRegister("TimeUpdater")
			GUICtrlSetState($Button, $GUI_ENABLE)
			GUICtrlSetData($Button, "开始")
			While Not $BotRunning
				Sleep(100)
			WEnd
		EndIf

		CombatLoop()
WEnd

Func CombatLoop()

	Local $looptimer

	If Not $RenderingEnabled Then ClearMemory()

	; 等待装载地图
	If (GetMapLoading() = 2) Then
		Do
			Sleep(100)
		Until WaitMapLoading()
		RndSleep(GetPing()+2000)
	EndIf

	If GetMapID() <> 381 Then ;go to yohlon
		;Out("前往刷怪地")
		RndSleep(1500)
		RndTravel(381)
		$reZone = 1
	EndIf

	SwitchMode($DIFFICULTY_NORMAL)

	RndSleep(1000)
	;Out("-------------------------")
	;Out("出城")
	Do
		MoveX(4410, 901)
	Until WaitMapLoading(380) ;arkjok

	If $reZone = 1 Then
		;out("回城: 以固定起点")
		Do
			MoveX(-20081, -14560)
		Until WaitMapLoading(381)
		;RndSleep(1000)
		Do
			MoveX(4410, 901)
		Until WaitMapLoading(380)
		$reZone = 0
	EndIf

	SetDisplayedTitle(0x11)

	;Out("拿取赐福")
	UseSkill(6,-2)
	GoNearestNPCToCoords(-17223, -12543)
	RndSleep(1000)
	Dialog(133)

	UseSkill(7,-2)
	MoveTo(-18478, -11428, 100)

	$looptimer = timerinit()
	Do
		sleep(300)
		if timerdiff($looptimer) > 50000 Then
			ExitLoop
		EndIf
	until GetNumberOfFoesInRangeOfAgent() = 0

	UseSkill(6,-2)
	MoveTo(-18554, -10125, 100)

	$looptimer = timerinit()
	Do
		sleep(300)
		if timerdiff($looptimer) > 50000 Then
			ExitLoop
		EndIf
	until GetNumberOfFoesInRangeOfAgent() = 0

	UseSkill(7,-2)
	MoveTo(-17366,-15066,100)

	$looptimer = timerinit()
	Do
		sleep(300)
		if timerdiff($looptimer) > 50000 Then
			ExitLoop
		EndIf
	until GetNumberOfFoesInRangeOfAgent() = 0

	UseSkill(6,-2)
	MoveTo(-17119,-16472, 100) ;-16598, -17185

	$looptimer = timerinit()
	Do
		sleep(300)
		if timerdiff($looptimer) > 50000 Then
			ExitLoop
		EndIf
	until GetNumberOfFoesInRangeOfAgent() = 0


	leave()


EndFunc

Func MoveX($aX, $aY, $aRandom = 50)
	;returns true if successful
	Local $rX
	Local $rY
	$rX = Random(-$aRandom, $aRandom)
	$rY = Random(-$aRandom, $aRandom)
	;Out("")
	;Out($rX)
	;Out($rY)
	;Out($aX+$rX)
	;Out($aY+$rY)
	;Out("")
	If GetAgentExists(-2) Then
		DllStructSetData($mMove, 2, $aX + $rX)
		DllStructSetData($mMove, 3, $aY + $rY)
		Enqueue($mMovePtr, 16)
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>Move

Func GetNumberOfFoesInRangeOfAgent($aAgent = -2, $fMaxDistance = 1012)
	Local $lDistance, $lCount = 0
	Local $lAgentToCompare

	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)

	Local $lAgentArray = GetAgentArray(0xDB)

	For $i = 1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], 'Allegiance') <> 3 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgentArray[$i], 'Effects'), 0x0010) > 0 Then ContinueLoop

		$lAgentToCompare = $lAgentArray[$i]

		$lDistance = GetDistance($lAgentToCompare, $aAgent)
		If $lDistance < $fMaxDistance Then
				$lCount += 1
		EndIf
	Next
	Return $lCount
EndFunc   ;==>GetNumberOfFoesInRangeOfAgent

Func UpdateAndRestart()

	; GetIsDead 似不能检测微光雪人生死， DllStructGetData($agentStruct, "HP")也不行
	;If GetIsDead(-2) Then
	;	$FailCount += 1
	;	GUICtrlSetData($FailsLabel, $FailCount)
	;Else
		$RunCount += 1
		if $RunCount <> 0 then
			GUICtrlSetData($RunsLabel, $RunCount)
			$SuccessRate = $SuccessCount/$RunCount*100
			GUICtrlSetData($RateLabel, $SuccessRate)
		Endif
	;EndIf

	;Out("开始下一轮")
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