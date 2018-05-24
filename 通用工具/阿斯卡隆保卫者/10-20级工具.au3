#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.0
 Author:         Maverick

 Script Function:

	Simple LDoA bot for levels 10 to 20. You need to have the Langmaar quest "Farmer hamnet" active. It kills the
first 2 bandits outside Foibles Fair and repeats.
Credits to the GWA2 team (TheArkanaProject and miracle444), the GWCA team, bl4ck3lit3 for his neat code parts and
all those whose functions I am using.

#ce ----------------------------------------------------------------------------


#include-once
#include <GUIConstantsEx.au3>
#include "../../激战接口.au3"

#region Globals
Global Const $MapFoiblesFair = 165
Global $CharName = ""
Global $boolRun = False
Global $boolIgneous = False ; 如欲用新手召唤石，则在此把False改为True, 另外召唤石需放在第一包左起第一格
Global $boolSurvivor = False ; 如欲同时刷"生存者"称号，则在此把False改为True，但无法保证效果
Global $Rendering = True
Global $intRuns = 0
Global $intDeaths = 0
#endregion Globals

#region GUI
Opt("GUIOnEventMode", 1)
$cGUI = GUICreate("10级-20级", 270, 235, 200, 180)
$cbxHideGW = GUICtrlCreateCheckbox("停止成像", 8, 8, 110, 17)
$lblName = GUICtrlCreateLabel("角色名:", 8, 54, 80, 17, 0x1) ; $SS_CENTER
$txtName = GUICtrlCreateInput($CharName, 105, 54, 150, 20, 0x1) ; $SS_CENTER
$lblR2D2 = GUICtrlCreateLabel("总圈数+(死亡次数):", 8, 80, 130, 17)
$lblRuns = GUICtrlCreateLabel("-", 140, 80, 100, 17, 0x1) ; $SS_CENTER
$lblStatus = GUICtrlCreateLabel("准备就绪", 8, 176, 256, 17, 0x1) ; $SS_CENTER
$btnStart = GUICtrlCreateButton("开始", 7, 202, 256, 25, 0x20000) ; $WS_GROUP

GUICtrlSetOnEvent($cbxHideGW, "EventHandler")
GUICtrlSetOnEvent($btnStart, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")

GUISetState(@SW_SHOW)

Main()

Func EventHandler()
	Switch (@GUI_CtrlId)
		Case $btnStart
			$boolRun = Not $boolRun
			If $boolRun Then
				GUICtrlSetData($btnStart, "正在启动...")
				GUICtrlSetState($btnStart, $GUI_DISABLE)
				If GUICtrlRead($txtName) = "" Then
					If Initialize(ProcessExists("gw.exe"), True, True, False) = False Then
						MsgBox(0, "失败", "激战未开.")
						Exit
					EndIf
				Else
					If Initialize(GUICtrlRead($txtName), True, True, False) = False Then
						MsgBox(0, "失败", "角色失寻.")
						Exit
					EndIf
				EndIf

				If GUICtrlRead($cbxHideGW) = 1 Then ToggleRendering()

				GUICtrlSetData($btnStart, "暂停")
				GUICtrlSetState($btnStart, $GUI_ENABLE)
				GUICtrlSetState($txtName, $GUI_DISABLE)
			Else
				GUICtrlSetData($btnStart, "继续")
				GUICtrlSetState($txtName, $GUI_ENABLE)
			EndIf
		Case $cbxHideGW
			If $mGWProcHandle <> 0 Then ToggleRendering()
		Case $GUI_EVENT_CLOSE
			If Not $Rendering Then ToggleRendering()
			Exit
	EndSwitch
EndFunc   ;==>EventHandler

Func Update($text)
	GUICtrlSetData($lblStatus, $text)
	;WinSetTitle($cGUI, "", $intRuns & " - " & $intGold & "g - ")
EndFunc   ;==>Update

Func ToggleRendering()
	If $Rendering Then
		DisableRendering()
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
		$Rendering = False
	Else
		EnableRendering()
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
		$Rendering = True
	EndIf
EndFunc   ;==>ToggleRendering
#endregion GUI

#region Main
Func Main()
	While 1
		PingSleep(200)
		If $boolRun Then
			If GetMapID() <> $MapFoiblesFair Then RndTravel($MapFoiblesFair)

			$boolRun = True

			Bot()

			$intRuns += 1

			GUICtrlSetData($lblRuns, $intRuns & " (" & $intDeaths & ")")
			Update("数据更新完毕")
			PingSleep(500)
		EndIf
	WEnd
EndFunc   ;==>Main

Func Bot()
PingSleep(1000)
RandomBreak()
Update("出城")
RandomPath(260, 8120, 630, 7270, 30, 1, 4, -1)
WaitMapLoading(161) ;Wizard's Folly
PingSleep(2000)
If $boolIgneous Then
	Update("使用召唤石，召唤石需放在第一包左起第一格")
	UseItem(GetItemBySlot(1, 1)) ; If you want to use igneous stone, change global $Igneous to True and equip it in 1st slot of backpack
	PingSleep(500)
EndIf
MoveTo(2455, 5320, 30)
PingSleep(200)
TargetNearestEnemy()
PingSleep(200)
Update("杀元素怪")
While GetAgentExists(-1) ; Killing Elemental
	If SurvivorCheck() And GetSkillBarSkillRecharge(2, 0) = 0 Then
		UseSkillEx(2, -1) ; Flare
		PingSleep(200)
	EndIf
WEnd
PingSleep(500)
Update("走向敌人")
MoveTo(2580, 4250, 30)
TargetNearestEnemy()
PingSleep()
Attack(-1)
PingSleep(500)
Update("拉敌至僧处")
MoveTo(2455, 5320, 30) ; Move back to bring them closer to the monk
Update("杀敌")
While GetAgentExists(-1) ; Killing first bandit (ele if present)
	ActionInteract()
	CastSpells()
	PingSleep()
WEnd
PingSleep()
TargetNearestEnemy()
PingSleep()
While GetAgentExists(-1) ; Killing second bandit
	ActionInteract()
	CastSpells()
	PingSleep()
WEnd
PingSleep(500)
RandomBreak()
Update("回城")
RndTravel($MapFoiblesFair) ; Reduces detectability, I used only EU districts, but u can change that.
EndFunc

Func CastSpells()

Local $lMe
Local $MyMaxHP
Local $MyCurrentHP
$MyMaxHP = DllStructGetData($lMe, 'MaxHP')
$MyCurrentHP = DllStructGetData($lMe, 'HP')

	If SurvivorCheck() And $MyCurrentHP < ($MyMaxHP / 2) Then
		If GetSkillBarSkillRecharge(5, 0) = 0 Then UseSkillEx(5, -1) ; Ether feast or other heal spell
		PingSleep()
	EndIf

	If SurvivorCheck() And GetSkillBarSkillRecharge(1, 0) = 0 Then
		ActionInteract()
		UseSkillEx(1, -2) ; Aura of restoration
		PingSleep()
	EndIf

	If SurvivorCheck() And GetSkillBarSkillRecharge(2, 0) = 0 Then
		ActionInteract()
		UseSkillEx(2, -1) ; Flare
		PingSleep()
	EndIf

	If SurvivorCheck() And Not GetIsMoving(-1) Then
		If GetSkillBarSkillRecharge(3, 0) = 0 Then UseSkillEx(3, -1) ; Fire storm only on immobile targets, i.e. fire bandit or melee bandit that has stopped moving
		PingSleep()
	EndIf

	If SurvivorCheck() And GetSkillBarSkillRecharge(4, 0) = 0 Then
		UseSkillEx(4, -1) ; Empathy
		PingSleep()
	EndIf
EndFunc   ;==>CastSpells

Func SurvivorCheck()
	Local $lMe
	Local $MyMaxHP
	Local $MyCurrentHP
	$MyMaxHP = DllStructGetData($lMe, 'MaxHP')
	$MyCurrentHP = DllStructGetData($lMe, 'HP')

	If $boolSurvivor = True And ($MyCurrentHP < ($MyMaxHP / 3)) Then
		Return 1
	Else
		Return True
	EndIf
EndFunc

Func UseSkillEx($aSkillSlot, $aTarget)
	Local $lSkillID = GetSkillBarSkillID($aSkillSlot, 0)
	Local $lSkillStruct = GetSkillByID($lSkillID)
	Local $lActivation = DllStructGetData($lSkillStruct, 'Activation')
	Local $lAftercast = DllStructGetData($lSkillStruct, 'Aftercast')

	$lMe = GetAgentByID(-2)
	If DllStructGetData($lMe, 'HP') <= 0 Then Return -1

	UseSkill($aSkillSlot, $aTarget)
	;Sleep(($lAftercast + $lActivation) * 1000 + 25 - GetPing() / 1.75)
	Sleep($lActivation * 1000 + 25 - GetPing() / 1.75)
	Local $lDeadlock = TimerInit()
	Do
		Sleep(20)
		If GetIsDead(-2) Or TimerDiff($lDeadlock) > 3000 Then Return 1
	Until GetSkillBarSkillRecharge($aSkillSlot, 0)
	Sleep(($lAftercast) * 1000 + 25 - GetPing() / 1.75)
	Return 0
EndFunc   ;==>UseSkillEx

Func PingSleep($msExtra = 0)
	$ping = GetPing()
	If $ping > 350 Then ; To deal with larger pings
		Sleep(Random(200, 300, 1) + $msExtra)
	Else
		Sleep($ping + $msExtra)
	EndIf
EndFunc   ;==>PingSleep

Func RandomBreak($percent = .95, $min = 10000, $max = 60000)
	If Random() > $percent Then
		Update("随机暂停10-60秒")
		PingSleep(Random($min, $max))
		Update("暂停完毕")
	EndIf
EndFunc   ;==>RandomBreak

; This func creates a random path for exiting outposts. It needs the coords of a spot
; in front of the exit-portal and the coords of a spot outside the portal for exiting.
; You may need to play around with the $aRandom to see which number fits you best.
Func RandomPath($PortalPosX, $PortalPosY, $OutPosX, $OutPosY, $aRandom = 50, $StopsMin = 1, $StopsMax = 5, $NumberOfStops = -1) ; do not change $NumberOfStops

	If $NumberOfStops = -1 Then $NumberOfStops = Random($StopsMin, $StopsMax, 1)

	Local $lAgent = GetAgentByID(-2)
	Local $MyPosX = DllStructGetData($lAgent, 'X')
	Local $MyPosY = DllStructGetData($lAgent, 'Y')
	Local $Distance = ComputeDistance($MyPosX, $MyPosY, $PortalPosX, $PortalPosY)

	If $NumberOfStops = 0 Or $Distance < 200 Then
		MoveTo($PortalPosX, $PortalPosY, (2 * $aRandom)) ; Made this last spot a bit broader
		Move($OutPosX + Random(-$aRandom, $aRandom, 1), $OutPosY + Random(-$aRandom, $aRandom, 1))
	Else
		Local $m = Random(0, 1)
		Local $n = $NumberOfStops - $m
		Local $StepX = (($m * $PortalPosX) + ($n * $MyPosX)) / ($m + $n)
		Local $StepY = (($m * $PortalPosY) + ($n * $MyPosY)) / ($m + $n)

		MoveTo($StepX, $StepY, $aRandom)
		RandomPath($PortalPosX, $PortalPosY, $OutPosX, $OutPosY,  $aRandom, $StopsMin, $StopsMax, $NumberOfStops - 1)
	EndIf
EndFunc

#endregion Main