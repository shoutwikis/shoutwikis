#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.0
 Author:         Maverick

 Script Function:

Simple LDoA bot for levels 2 to 10. You need to have the quest "Charr at the Gate" given by Prince Rurik active! The bot follows him
and waits until he kills all Charr but 1, so that you don't need to abandon/retake quest. Afterwards it travels back to Ascalon and
repeats. Credits to the GWA² team (TheArkanaProject and miracle444), the GWCA team, bl4ck3lit3 and all those whose functions I am using.

#ce ----------------------------------------------------------------------------

#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
#include <GUIConstantsEx.au3> ;for GUI stuff
#include <WindowsConstants.au3> ;for $SS_CENTER
#include <StaticConstants.au3> ;for $WS_GROUP
#include <ComboConstants.au3>
#include <TabConstants.au3>
#include "GWA2.au3"

#region Globals
Global Const $MapAscalon = 148
Global $CharName = ""
Global $boolRun = False
Global $boolIgneous = True ; Change that to True if you want to use igneous stone and put the stone in 1st backpack slot
Global $boolSurvivor = False ; Change that to True if you want to try and get survivor - not perfect
Global $Rendering = True
Global $intRuns = 0
Global $intDeaths = 0
Global $intExperience = 0
Global $intXP = -1
Global $strName = GetCharname()
Global $proRuns = 5
Global $GOLD = GetGoldCharacter()
Global $EXP = GetExperience()
Global $lPlayer = GetAgentByID(-2)
Global $level = GetLevel()
Global $booligneous = True
Global $lvlprogbar = BarUpdate(1)
Global $experienceleft = BarUpdate(2)
#endregion Globals



#region GUI
Opt("GUIOnEventMode", 1)
$cGUI = GUICreate("GWA² - LDoA Helper v1.2", 270, 280, 200, 180)
$cbxigneous = GUICtrlCreateCheckbox("Use Igneous", 8, 8, 110, 17)
$cbxHideGW = GUICtrlCreateCheckbox("Disable Graphics", 135, 8, 110, 17)
$lblName = GUICtrlCreateLabel("Character Name:", 8, 34, 80, 17, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$txtName = GUICtrlCreateLabel($strName, 105, 34, 150, 20, $SS_CENTER)
$lblR2D2 = GUICtrlCreateLabel("Total Runs:", 8, 60, 130, 17)
$lblRuns = GUICtrlCreateLabel("-", 140, 60, 100, 17, $SS_CENTER)
$lblCash = GUICtrlCreateLabel("Total Gold On Player:", 8, 84, 130, 17)
$lblGold = GUICtrlCreateLabel($GOLD, 140, 84, 100, 17, $SS_CENTER)
$lblXP = GUICtrlCreateLabel("Total Experience:", 8, 108, 130, 17)
$lblExperience = GUICtrlCreateLabel($EXP, 140, 108, 100, 17, $SS_CENTER)
$lblLvl = GUICtrlCreateLabel("Character Level:", 8, 128, 130, 17)
$lblLevel = GUICtrlCreateLabel($level, 140, 128, 100, 17, $SS_CENTER)
$statexpleft = GUICtrlCreateLabel("XP Left until next Level:", 8, 148, 140, 17)
$lblexpleft = GUICtrlCreateLabel($experienceleft, 140, 148, 100, 17, $SS_CENTER)
$lvlbar = GUICtrlCreateProgress(8, 195, 256, 10)
$lblpercent = GUICtrlCreateLabel("Percent:" , 8, 176, 100, 17)
$percent = GUICtrlCreateLabel(Round($lvlprogbar,1) & "%", 144, 176, 100, 17, $SS_CENTER)
$lblStatus = GUICtrlCreateLabel("Ready to begin", 8, 219, 256, 17, $SS_CENTER)
$btnStart = GUICtrlCreateButton("Start", 7, 242, 256, 25, $WS_GROUP)

GUICtrlSetOnEvent($cbxigneous, "EventHandler")
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
				Initialize(WinGetProcess("Guild Wars"))
				GUICtrlSetData($btnStart, "Initializing...")
				GUICtrlSetState($btnStart, $GUI_DISABLE)

				If GUICtrlRead($cbxHideGW) = 1 Then ToggleRendering()

				GUICtrlSetData($btnStart, "Stop")
				GUICtrlSetState($btnStart, $GUI_ENABLE)
				GUICtrlSetState($txtName, $GUI_DISABLE)
			Else
				GUICtrlSetData($btnStart, "Continue")
				GUICtrlSetState($txtName, $GUI_ENABLE)
			EndIf
		Case $cbxHideGW
			ToggleRendering()
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
			If GetMapID() <> $MapAscalon Then RndTravel($MapAscalon)

			$boolRun = True

			Bot()

			$intRuns += 1

			GUICtrlSetData($lblRuns, $intRuns & " (" & $intDeaths & ")")
			Refresh()
			Update("Stats updated")
			PingSleep(500)
		EndIf
	WEnd
EndFunc   ;==>Main

Func Bot()
PingSleep(1000)
;RandomBreak()
Update("Going outside")
RandomPath(7428, 5870, 7000, 5350, 50, 1, 4, -1)
WaitMapLoading()
PingSleep(2000)
If $boolIgneous Then
	UseItem(GetItemBySlot(1, 1)) ; If you want to use igneous stone, change global $Igneous to True and equip it in 1st slot of backpack
	PingSleep(500)
EndIf
MoveTo(6220, 4470, 30)
PingSleep(2000)
Update("Going to the gate")
PingSleep(200)
MoveTo(3180, 6468, 30)
PingSleep(200)
MoveTo(360, 6575, 30)
PingSleep(200)
MoveTo(-3140, 9610, 30)
PingSleep(200)
MoveTo(-3640, 10930, 30)
Update("Waiting for Rurik to kill mobs")
PingSleep(3000)
If GetIsDead(-2) Then $intDeaths += 1
MoveTo(-4870, 11470, 30)
$lDeadlock = TimerInit()
Do
	If GetIsDead(-2) Then $intDeaths += 1
	PingSleep(200)
Until GetNumberOfFoesInRangeOfAgent(-2, 2000) = 1 Or TimerDiff($lDeadlock) > 120000 ; 2 min
PingSleep(200)
RndTravel($MapAscalon) ; Reduces detectability, I used only EU districts, but u can change that.
EndFunc

Func GetNumberOfFoesInRangeOfAgent($aAgent = -2, $aRange = 1250)
	Local $lAgent, $lDistance
	Local $lCount = 0

	If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)

	For $i = 1 To GetMaxAgents()
		$lAgent = GetAgentByID($i)
		If BitAND(DllStructGetData($lAgent, 'typemap'), 262144) Then ContinueLoop
		If DllStructGetData($lAgent, 'Type') <> 0xDB Then ContinueLoop
		If DllStructGetData($lAgent, 'Allegiance') <> 3 Then ContinueLoop
		If DllStructGetData($lAgent, 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) > 0 Then ContinueLoop
		$lDistance = GetDistance($lAgent)
		If $lDistance > $aRange Then ContinueLoop
		$lCount += 1
	Next
	Return $lCount
EndFunc   ;==>GetNumberOfFoesInRangeOfAgent

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
		Update("Performing a random break")
		PingSleep(Random($min, $max))
		Update("Resuming")
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

Func RndTravel($aMapID)
	Local $UseDistricts = 4 ; 7=eu-only, 8=eu+us, 9=eu+us+int, 12=all(incl. asia)
	; Region/Language order: eu-en, eu-fr, eu-ge, eu-it, eu-sp, eu-po, eu-ru, us-en, int, asia-ko, asia-ch, asia-ja
	Local $Region[11] = [2, 2, 2, 2, 0, -2, 1, 3, 4]
	Local $Language[11] = [4, 5, 9, 10, 0, 0, 0, 0, 0]
	Local $Random = Random(0, $UseDistricts - 1, 1)
	MoveMap($aMapID, $Region[$Random], 0, $Language[$Random])
	WaitMapLoading($aMapID, 30000)
	PingSleep(3000)
EndFunc   ;==>RndTravel
#endregion Main


Func GetLevel()

	Local $myXP = GetExperience()

	Select
		Case $myXP < 2000
			Return 1
		Case $myXP >= 2000 And $myXP < 4600
			Return 2
		Case $myXP >= 4600 And $myXP < 7800
			Return 3
		Case $myXP >= 7800 And $myXP < 11600
			Return 4
		Case $myXP >= 11600 And $myXP < 16000
			Return 5
		Case $myXP >= 16000 And $myXP < 21000
			Return 6
		Case $myXP >= 21000 And $myXP < 26600
			Return 7
		Case $myXP >= 26600 And $myXP < 32800
			Return 8
		Case $myXP >= 32800 And $myXP < 39600
			Return 9
		Case $myXP >= 39600 And $myXP < 47000
			Return 10
		Case $myXP >= 47000 And $myXP < 55000
			Return 11
		Case $myXP >= 55000 And $myXP < 63600
			Return 12
		Case $myXP >= 63600 And $myXP < 72800
			Return 13
		Case $myXP >= 72800 And $myXP < 82600
			Return 14
		Case $myXP >= 82600 And $myXP < 93000
			Return 15
		Case $myXP >= 93000 And $myXP < 104000
			Return 16
		Case $myXP >= 104000 And $myXP < 115600
			Return 17
		Case $myXP >= 115600 And $myXP < 127800
			Return 18
		Case $myXP >= 127800 And $myXP < 140600
			Return 19
		Case $myXP >= 140600
			Return 20
	EndSelect
EndFunc   ;==>GetLevel

Func BarUpdate($booltoggle)

	Local $getlvl, $progbar, $prog, $expleft

	$getlvl = GetLevel()

	;set up values depending on level
	If $getlvl = 1 Then
		$bar0 = 0
		$bar100 = 2000
	EndIf

	If $getlvl = 2 Then
		$bar0 = 2000
		$bar100 = 4600
	EndIf

	If $getlvl = 3 Then
		$bar0 = 4600
		$bar100 = 7800
	EndIf

	If $getlvl = 4 Then
		$bar0 = 7800
		$bar100 = 11600
	EndIf

	If $getlvl = 5 Then
		$bar0 = 11600
		$bar100 = 16000
	EndIf

	If $getlvl = 6 Then
		$bar0 = 16000
		$bar100 = 21000
	EndIf

	If $getlvl = 7 Then
		$bar0 = 21000
		$bar100 = 26600
	EndIf

	If $getlvl = 8 Then
		$bar0 = 26600
		$bar100 = 32800
	EndIf

	If $getlvl = 9 Then
		$bar0 = 32800
		$bar100 = 39600
	EndIf

	If $getlvl = 10 Then
		$bar0 = 39600
		$bar100 = 47000
	EndIf

	If $getlvl = 11 Then
		$bar0 = 47000
		$bar100 = 55000
	EndIf

	If $getlvl = 12 Then
		$bar0 = 55000
		$bar100 = 63600
	EndIf

	If $getlvl = 13 Then
		$bar0 = 63600
		$bar100 = 72800
	EndIf

	If $getlvl = 14 Then
		$bar0 = 72800
		$bar100 = 82600
	EndIf

	If $getlvl = 15 Then
		$bar0 = 82600
		$bar100 = 93000
	EndIf

	If $getlvl = 16 Then
		$bar0 = 93000
		$bar100 = 104000
	EndIf

	If $getlvl = 17 Then
		$bar0 = 104000
		$bar100 = 115600
	EndIf

	If $getlvl = 18 Then
		$bar0 = 115600
		$bar100 = 127800
	EndIf

	If $getlvl = 19 Then
		$bar0 = 127800
		$bar100 = 140600
	EndIf

	If $getlvl = 20 Then
		$progbar = 100
	EndIf

	;Start The Percentage Equation

	If $progbar = 100 Then
		Sleep(100)
	Else
		$progbar = (GetExperience() - $bar0) / ($bar100 - $bar0) * 100
	EndIf

	$expleft = ($bar100 - $bar0) - (GetExperience() - $bar0)

;What are we giving back?
If $booltoggle = 1 Then
	Return $progbar
ElseIf $booltoggle = 2 AND GetLevel() <> 20 Then
	Return $expleft
Else
	Return 666
EndIf

EndFunc

Func Refresh()
	Local $lAgent = GetAgentByID(-2)
	$GOLD = GetGoldCharacter()
	$EXP = GetExperience()

	$level = GetLevel()
	$intRuns += 1
	$lvlprogbar = BarUpdate(1)
	$experienceleft = BarUpdate(2)
	Sleep(100)

	GuiCtrlSetData($percent, Round($lvlprogbar,1) & "%")
	GUICtrlSetData($lvlbar, $lvlprogbar)
	GUICtrlSetData($lblRuns, $intRuns)
	GUICtrlSetData($lblGold, $GOLD)
	GUICtrlSetData($lblExperience, $EXP)
	GUICtrlSetData($lblexpleft, $experienceleft)
	GUICtrlSetData($lblLevel, $level)
	;ProgressCheck()
EndFunc   ;==>Refresh
