#NoTrayIcon
#include-once
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>

#include "常数.au3"
#include "../../激战接口.au3"
#include "任务副件.au3"

Global $SpawnpointToA1 = False
Global $pcons_Slot[2]
Global $pconQuantity=0
$pcons_Slot[0]=0
$pcons_Slot[1]=0

Opt("MustDeclareVars", True)
Opt("GUIOnEventMode", True)

Global Const $template = "Owpi8xrMNBhA5yYTi7gFGTydBA"
Global Const $Dash = 1
Global Const $HoS = 2
Global Const $ShadowSanctuary = 3
Global Const $YMLaD = 4
Global Const $DeathsCharge = 5
Global Const $smokepowderdefense = 6
Global Const $FinishHim = 7
Global Const $BaneSignet = 8

Global Const $MainGui = GUICreate("刷骷髅 - 领队", 172, 190)
	GUICtrlCreateLabel("刷骷髅 - 领队", 8, 6, 156, 17, $SS_CENTER)
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

MapCheckToa()
Out("装载技能")
LoadSkillTemplate($template)

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

	while getmaploading() == $INSTANCETYPE_LOADING and GetMapID() <> $TOA_ID
		rndsleep(1000)
	WEnd

	If Not GoldCheck() Then Return

	If $TOA_ID Then
		SpawnpointToA()
		Sleep(GetPing()+500)
		If $SpawnpointToA1 Then
			Out("起始点 1")
			MoveToVoG(-4170, 19759)
		EndIf
	EndIf

	Local $Avatar

	$Avatar = GetNearestNPCToCoords(-4124, 19829)

	If DllStructGetData($Avatar, "PlayerNumber") <> $MODELID_AVATAR_OF_GRENTH Then
		Out("激活游戏人物")
		SendChat("kneel", "/")
		Local $lDeadlock = TimerInit()
		Local $lFailPops = 0
		Do
			Sleep(1500)

			$Avatar = GetNearestNPCToCoords(-4124, 19829)

			If TimerDiff($lDeadlock) > 5000 Then
				MoveToVoG(-4170, 19759)
				SendChat("kneel", "/")
				$lDeadlock = TimerInit()
				$lFailPops += 1
			EndIf

			If $lFailPops >= 3 Then
				MoveToVoG(-3243, 18426)
				MoveToVoG(-4170, 19759)
				$lFailPops = 0
			EndIf

		Until DllStructGetData($Avatar, "PlayerNumber") == $MODELID_AVATAR_OF_GRENTH

	EndIf

	Out("与游戏人物对话")
	GoNpc($Avatar)
    Sleep(500)
	;Dialog(0x85)
	Sleep(300)
	DIALOG(0x86)

	Out("等待进入地下")

	InitMapLoad()
	Local $enterUWLimit = TimerInit()
	Do
		Sleep(GetPing()+200)
		Local $lMapLoading = GetMapLoading()
	Until $lMapLoading <> 2 And GetMapIsLoaded() And GetMapID() == $UW_ID or TimerDiff($enterUWLimit)>180*1000
	RndSleep(1500)

	If GetMapID() == $TOA_ID Then Return


	capSkele()

	InitMapLoad()
	Local $lDeadlock = TimerInit()
	Do
		Sleep(GetPing() + 200)
		Local $lMapLoading = GetMapLoading()

		If $lDeadlock <> 0 And TimerDiff($lDeadlock) > 8*1000 And GetMapLoading()=$INSTANCETYPE_EXPLORABLE Then
			Out("等待回城|再次退出|测试")
			Resign()
			RndSleep(1000)

			if DllStructGetData(GetAgentByID(-2), "PlayerNumber") == 1 then
				Out("试图回城")
				ReturnToOutpost()
				$lDeadlock = TimerDiff($lDeadlock)
			endif
		EndIf

		if GetMapLoading() = $INSTANCETYPE_OUTPOST Then exitloop
	Until $lMapLoading <> 2 And GetMapIsLoaded() And GetMapID() = $TOA_ID
	RndSleep(1500)

	UpdateStatistics()
EndFunc

Func GoldCheck()
	Local $lGold = GetGoldCharacter()
	If $lGold < 1000 Then
		If GetGoldStorage() < 20000 Then
			Out("金不足")
			$boolRunning = False
			Return False
		EndIf
		Out("取钱")
		WithdrawGold(20000)
	EndIf
	Return True
EndFunc

Func capSkele()

	Local $lSkeleID = GetSkeleID()

	ChangeTarget($lSkeleID)

	;calltarget($lSkeleID)

	Out("拉骷髅...")
	UseSkill($Dash, -2)
	UseSkill($HoS, $lSkeleID)
	Do
		Sleep(300)
	Until GetSkillbarSkillRecharge($HoS) > 0  Or GetIsDead(-2)
	UseSkill($ShadowSanctuary, -2)
	Sleep(750)
	Out("攻击...")
	UseSkill($smokepowderdefense, -2)
	Sleep(100)
	UseSkill($DeathsCharge, $lSkeleID, True)
	Do
		Sleep(150)
	Until GetSkillbarSkillRecharge($DeathsCharge) > 0  Or GetIsDead(-2)
	UseSkill($YMLaD, $lSkeleID)
	Sleep(100)
 	UseSkill($BaneSignet, $lSkeleID)
	Do
		Sleep(200)
	Until DllStructGetData(GetAgentByID($lSkeleID), 'HP') < .5 Or GetIsDead(-2) Or GetIsDead($lSkeleID)

	UseSkill($FinishHim, $lSkeleID)
	Do
		Sleep(200)
	Until DllStructGetData(GetAgentByID($lSkeleID), 'HP') < .25 Or GetIsDead(-2) Or GetIsDead($lSkeleID);


	If Not GetIsDead(-2) Then
		Out("抓骷髅")

		UseItem(GetItemByModelID($MODEL_ID_MOBSTOPPER))

		Out("寻找玉等.")
		PickUpLoot()
	Else
		$fails += 1
	EndIf

	Out("退出")
	Resign()

	WaitForPartyWipe()

    Sleep(2000)

	Out("回城")

	If DllStructGetData(GetAgentByID(-2), "PlayerNumber") == 1 Then ReturnToOutpost()

EndFunc

Func SpawnpointToA()

	Local $lMe = GetAgentByID(-2)

	Out((Round(DllStructGetData($lMe, 'X')) & "  " & Round(DllStructGetData($lMe, 'Y'))) & "  " & "ToA")

	If (DllStructGetData($lMe, 'X') > -5000 And DllStructGetData($lMe, 'X') < -4000) And (DllStructGetData($lMe, 'Y') > 18000 And DllStructGetData($lMe, 'Y') < 19000) Then
		$SpawnpointToA1 = True
		OUT("起始点1" & $SpawnpointToA1)
	Else
		Out("起点不妥，躲避障碍物")
		MoveToVoG(-4852, 18929)
		MoveToVoG(-4170, 19759)
	EndIf
EndFunc


Func getLoadedSize()
	Local $returnvalue = 0, $lreturn
	Local $lOffset[5] = [0, 0x00000018, 0x0000004c, 0x00000054, 0]
	For $i = 0 To 2
		$lOffset[4] = $i * 0x00000010 + 12
		$lreturn = memoryreadptr($mbasepointer, $lOffset)
		$returnvalue += $lreturn[1]
	Next
	Return $returnvalue
EndFunc


Func GetPartySizeEx()
   Local $lOffset[5] = [0, 0x18, 0x4C, 0x64, 0x24]
   Local $lPartyPtr = MemoryReadPtr($mBasePointer, $lOffset)
   $lOffset[3] = 0x54
   $lOffset[4] = 0xC
   Local $lPartyPlayerPtr = MemoryReadPtr($mBasePointer, $lOffset)
   Local $Party1 = MemoryRead($lPartyPtr[0], 'long')
   Local $Party2 = MemoryRead($lPartyPtr[0] + 0x10, 'long')
   Local $Party3 = MemoryRead($lPartyPlayerPtr[0], 'long')
   Return $Party1 + $Party2 + $Party3
EndFunc

Func MoveToVoG($aX, $aY, $aRandom = 50)
	Local $lBlocked = 0
	Local $lMe
	Local $lMapLoading = GetMapLoading(), $lMapLoadingOld
	Local $lDestX = $aX + Random(-$aRandom, $aRandom)
	Local $lDestY = $aY + Random(-$aRandom, $aRandom)
	Local $lAngle = 40

	Move($lDestX, $lDestY, 0)

	Do
		Sleep(100)

		$lMe = GetAgentByID(-2)

		If DllStructGetData($lMe, 'HP') <= 0 Then ExitLoop

		$lMapLoadingOld = $lMapLoading
		$lMapLoading = GetMapLoading()
		If $lMapLoading <> $lMapLoadingOld Then ExitLoop

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

Func pconsScanInventory($ItemID)
	Local $bag
	Local $size
	Local $slot
	Local $item
	Local $ModelID
	$pcons_Slot[0] = $pcons_Slot[1] = 0
	$pconQuantity = 0
	For $bag = 1 To 4 Step 1
		If $bag == 1 Then $size = 20
		If $bag == 2 Then $size = 5
		If $bag == 3 Then $size = 10
		If $bag == 4 Then $size = 10
		For $slot = 1 To $size Step 1

			$item = GetItemBySlot($bag, $slot)

			$ModelID = DllStructGetData($item, "ModelID")

			Switch $ModelID
				Case 0
					ContinueLoop
				Case $ItemID
					$pcons_Slot[0] = $bag
					$pcons_Slot[1] = $slot
					$pconQuantity += DllStructGetData($item, 'Quantity')
			EndSwitch
		Next
	Next
EndFunc