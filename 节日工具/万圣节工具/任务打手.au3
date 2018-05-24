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

Global Const $MainGui = GUICreate("刷骷髅 - 野队打手", 172, 190)
	GUICtrlCreateLabel("刷骷髅 - 野队打手", 8, 6, 156, 17, $SS_CENTER)
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

	while getmaploading() == $INSTANCETYPE_LOADING

	WEnd
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

	Out("等待回城")

	InitMapLoad()
	Local $lDeadlock = TimerInit()
	Do
		Sleep(GetPing() + 200)
		Local $lMapLoading = GetMapLoading()
		If $lDeadlock <> 0 And TimerDiff($lDeadlock) > 8*1000 And GetMapLoading()==$INSTANCETYPE_EXPLORABLE Then
			writechat("|等待回城|再次退出|")
			writechat(TimerDiff($lDeadlock))
			writechat("|等待回城|再次退出|")
			SoundSetWaveVolume(100)
			SoundPlay("铃响-注意.wave")
			writechat("|等待回城|再次退出|")

			out("|等待回城|再次退出|")

			RndSleep(7500)
			if getmaploading() == $INSTANCETYPE_EXPLORABLE and GetInstanceUpTime() > 7000 then Resign()
			RndSleep(1000)
			if DllStructGetData(GetAgentByID(-2), "PlayerNumber") == 1 then
				SoundPlay("铃响-领队回城.wav")
				Out("试图回城")
				RndSleep(2500)
				if getmaploading() == $INSTANCETYPE_EXPLORABLE and GetInstanceUpTime() > 7000 then ReturnToOutpost()
				$lDeadlock = TimerDiff($lDeadlock)
			endif
		EndIf
	Until $lMapLoading <> 2 And GetMapIsLoaded() And GetMapID() == $TOA_ID
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
	out("瞄准骷髅")

	ChangeTarget($lSkeleID)

	;calltarget($lSkeleID)

	Out("拉骷髅...")

	UseSkill($Dash, -2)

	Out("攻击...")

	Sleep(100)
	UseSkill($DeathsCharge, $lSkeleID, false)
	Do
		Sleep(150)
	Until GetSkillbarSkillRecharge($DeathsCharge) > 0  Or GetIsDead(-2)

	UseSkill($smokepowderdefense, -2)
	Sleep(100)

	#cs
	;UseSkill($HoS, $lSkeleID)
	Do
		Sleep(300)
	Until GetSkillbarSkillRecharge($HoS) > 0  Or GetIsDead(-2)
	#ce

	UseSkill($YMLaD, $lSkeleID)
	Sleep(100)

 	UseSkill($BaneSignet, $lSkeleID)
	Sleep(GetPing()+400)
	UseSkill($ShadowSanctuary, -2)
	Sleep(750)

	Do
		Sleep(200)
	Until DllStructGetData(GetAgentByID($lSkeleID), 'HP') < .5 Or GetIsDead(-2) Or GetIsDead($lSkeleID)

	UseSkill($FinishHim, $lSkeleID)

	Do
		Sleep(200)
	Until GetIsDead($lSkeleID) or DllStructGetData(GetAgentByID($lSkeleID), 'HP') < .25 Or GetIsDead(-2)


	If Not GetIsDead(-2) Then
		Out("抓骷髅")

		UseItem(GetItemByModelID($MODEL_ID_MOBSTOPPER))

		Out("寻找玉等.")
		PickUpLoot()
	Else
		$fails += 1
	EndIf

	Out("退出")
	Sleep(1500)
	Resign()

	WaitForPartyWipe()

    Sleep(2000)

	if getmaploading() <> $INSTANCETYPE_EXPLORABLE then return

	Out("回城")

	If DllStructGetData(GetAgentByID(-2), "PlayerNumber") == 1 Then ReturnToOutpost()

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