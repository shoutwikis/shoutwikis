#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#NoTrayIcon
#RequireAdmin
#include-once
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include "gwApi.au3"


Opt("GUIOnEventMode", 1)
Global $boolRun = False
Global $intStarted = -1
Global $intRuns = 0
Global $RenderingEnabled = True
Global $Runs = 0
Global $NornTitle
Global $ToMax
Global $Rank = 0
Global $ToNext = 0
Global $strName

$cGUI = GUICreate("Vaettir Farm Leecher", 270, 235, 200, 180)
$cbxHideGW = GUICtrlCreateCheckbox("Disable Rendering", 8, 54, 110, 17)
 	GUICtrlSetOnEvent(-1, "ToggleRendering")
$lblName = GUICtrlCreateLabel("Character Name:", 8, 8, 80, 17, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$txtName = GUICtrlCreateCombo("", 105, 8, 150, 20)
   GUICtrlSetData(-1, GetLoggedCharnames())
$lblR2D2 = GUICtrlCreateLabel("Total Runs:", 8, 80, 130, 17)
$lblRuns = GUICtrlCreateLabel("-", 140, 80, 100, 17, $SS_CENTER)
$lblNorn = GUICtrlCreateLabel("Norn Rank:", 8, 104, 130, 17)
$lblTitle = GUICtrlCreateLabel("-", 140, 104, 100, 17, $SS_CENTER)
$lblNeedToMax = GUICtrlCreateLabel("Points To Max:", 8, 128, 130,17)
$lblToMax = GUICtrlCreateLabel("-", 140, 128, 100, 17, $SS_CENTER)
$lblNeedToNext = GUICtrlCreateLabel("Points To Next:", 8, 152, 130,17)
$lblToNext = GUICtrlCreateLabel("-", 140, 152, 100, 17, $SS_CENTER)
$lblStatus = GUICtrlCreateLabel("Ready to begin", 8, 176, 256, 17, $SS_CENTER)
$btnStart = GUICtrlCreateButton("Start", 7, 202, 256, 25, $WS_GROUP)



GUICtrlSetOnEvent($btnStart, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")

GUISetState(@SW_SHOW)



While 1
	Sleep(100)
	If $boolRun Then

		SwitchMode(1)
		LetHimFarm()

		$intRuns += 1
		$Runs += 1

		GUICtrlSetData($lblRuns, $intRuns)
		ConsolGuiUpdate("Stats ConsolGuiUpdated")
		ConsolGuiUpdate2()
		RndSleep(250)

		If Not $boolRun Then
			ConsolGuiUpdate("Bot was paused")
			GUICtrlSetData($btnStart, "Start")
			GUICtrlSetState($btnStart, $GUI_ENABLE)
			GUICtrlSetState($txtName, $GUI_ENABLE)
		EndIf
	EndIf
WEnd

Func ConsolGuiUpdate($text)
	GUICtrlSetData($lblStatus, $text)
	ConsolGuiUpdate2()
EndFunc   ;==>ConsolGuiUpdate

Func ConsolGuiUpdate2()
   Local $NornATM = GetNornTitle()
   Local $MaxNorn = 160000
   Local $Next = PointsToNext()
	  $NornTitle = DisplayNorn()
	  $ToMax = $MaxNorn-$NornATM
	  GUICtrlSetData($lblTitle, $NornTitle)
	  GUICtrlSetData($lblToMax, $ToMax)
	  GUICtrlSetData($lblToNext, $ToNext)
   EndFunc

Func EventHandler()
	Switch (@GUI_CtrlId)
		Case $btnStart
			$boolRun = Not $boolRun
			If $boolRun Then
				GUICtrlSetData($btnStart, "Initializing...")
				GUICtrlSetState($btnStart, $GUI_DISABLE)
				GUICtrlSetState($txtName, $GUI_DISABLE)
				If GUICtrlRead($txtName) = "" Then
					If Initialize(ProcessExists("gw.exe")) = False Then
						MsgBox(0, "Error", "Guild Wars it not running.")
						Exit
					EndIf
				Else
					If Initialize(GUICtrlRead($txtName), True, True) = False Then
						MsgBox(0, "Error", "Can't find a Guild Wars client with that character name: "&$txtName&".")
						Exit
					EndIf
				EndIf
				GUICtrlSetState($btnStart, $GUI_ENABLE)
				GUICtrlSetData($btnStart, "Pause")

				$lMe = GetAgentPtr(-2)
				$hp_start = DllStructGetData($lMe, 'MaxHP')

				If $intStarted = -1 Then
					$intStarted = GetNornTitle()
				EndIf

			Else
				GUICtrlSetData($btnStart, "BOT WILL HALT AFTER THIS RUN")
				GUICtrlSetState($btnStart, $GUI_DISABLE)
			EndIf
		 Case $cbxHideGW
			If GUICtrlRead($cbxHideGW) = 1 Then ToggleRendering()

		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
EndFunc   ;==>EventHandler

Func LetHimFarm()

	If GetMapID() = 650 Then
	   ConsolGuiUpdate ("Waiting for Farmer to start!")
	   WaitForZoneing(482)

	    $intRuns -= 1
		$Runs -= 1

	ElseIf GetMapID() = 482 Then
	   ConsolGuiUpdate ("Waiting for farmarea!")
	   sleep(3000)
	   SendChat("resign",'/')
	   WaitForZoneing(546)
	     $intRuns -= 1
		 $Runs -= 1


	ElseIf GetMapID() = 546 Then
	WaitForLoad()
	ConsolGuiUpdate("Resign and Taking blessing")
	SendChat("resign",'/')


	  GoToNPCNearestCoords(13318, -20826)
	  Dialog(132)



 EndIf

EndFunc

Func Die()
 MoveTo (10531, -24451)
 While GetIsDead(-2) = 0
	PingSleep(1000)
 WEnd

EndFunc

Func WaitForZoneing($aZone)
   While GetMapID() <> $aZone
		 Sleep(1000)
   WEnd
EndFunc

Func DisplayNorn()
 Local $Norn = GetNornTitle()
 If $Norn > 1000 Then
	  If $Norn > 4000 Then
		 If $Norn > 8000 Then
			If $Norn > 16000 Then
			   If $Norn > 26000 Then
				  If $Norn > 40000 Then
					 If $Norn > 56000 Then
						If $Norn > 80000 Then
						   If $Norn > 110000 Then
							  If $Norn > 160000 Then
							   $Rank = 10
							   Return $Rank
							  Else
								$Rank = 9
								 Return $Rank
							  EndIf
						   Else
						     $Rank = 8
							 Return $Rank
						  EndIf
						Else
						   $Rank = 7
						   Return $Rank
						EndIf
					 Else
						$Rank = 6
						Return $Rank
					 EndIf
				  Else
				    $Rank = 5
					Return $Rank
				  EndIf
			   Else
				  $Rank = 4
				  Return $Rank
			    EndIf
			Else
				$Rank = 3
				Return $Rank
			EndIf
		 Else
			$Rank = 2
			 Return $Rank
		  EndIf
	  Else
		 $Rank = 1
	     Return $Rank
	  EndIf
   Else
	 $Rank = 0
	  Return $Rank

 EndIf
EndFunc

Func PointsToNext()
Local $NRank = DisplayNorn()
Local $Pnts = GetNornTitle()
Switch $NRank
   Case 0
    $ToNext = 1000-$Pnts
	Return $ToNext

   Case 1
    $ToNext = 4000 - $Pnts
	Return $ToNext

   Case 2
    $ToNext =  8000 - $Pnts
	Return $ToNext

   Case 3
    $ToNext =  16000 - $Pnts
	Return $ToNext

   Case 4
    $ToNext =  26000 - $Pnts
	Return $ToNext

   Case 5
    $ToNext =  40000 - $Pnts
	Return $ToNext

   Case 6
    $ToNext =  56000 - $Pnts
	Return $ToNext

   Case 7
    $ToNext =  80000 - $Pnts
	Return $ToNext

   Case 8
    $ToNext =  110000 - $Pnts
	Return $ToNext

   Case 9
    $ToNext =  160000 - $Pnts
	Return $ToNext

   EndSwitch
EndFunc

Func WaitForLoad()
	ConsolGuiUpdate("Loading zone")
	InitMapLoad()
	$deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100
		$load = GetMapLoading()
		$lMe = GetAgentPtr(-2)

	Until $load = 2 And DllStructGetData($lMe, 'X') = 0 And DllStructGetData($lMe, 'Y') = 0 Or $deadlock > 10000

	$deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100
		$load = GetMapLoading()
		$lMe = GetAgentPtr(-2)

	Until $load <> 2 And DllStructGetData($lMe, 'X') <> 0 And DllStructGetData($lMe, 'Y') <> 0 Or $deadlock > 30000
	ConsolGuiUpdate("Load complete")
EndFunc	;==>WaitForLoad

Func GoNearestNPCToCoords($x, $y)
   	Local $guy, $Me
	Do
		RndSleep(250)
		$guy = GetNearestNPCToCoords($x, $y)
	Until DllStructGetData($guy, 'Id') <> 0
	ChangeTarget($guy)
	RndSleep(250)
	GoNPC($guy)
	RndSleep(250)
	Do
		RndSleep(500)
		Move(DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y'), 40)
		RndSleep(500)
		GoNPC($guy)
		RndSleep(250)
		$Me = GetAgentPtr(-2)
	Until ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y')) < 250
	RndSleep(1000)
 EndFunc

