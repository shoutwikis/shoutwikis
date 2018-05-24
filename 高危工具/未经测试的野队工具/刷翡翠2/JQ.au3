#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****


#Region
#include-once
#include <Date.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include "GWBible.au3"
#include "GWAddOns.au3"
#include <file.au3>
#Include <WinAPI.au3>
#EndRegion

#Region - Vars
Global $iTotalRuns = 0
Global $iTotalImperial = 0
Global $iMaxTotalImperial = 0
Global $iTotalFaction = 0
Global $iMaxTotalFaction = 0
Global $iTotalBalthazar = 0
Global $iMaxTotalBalthazar = 0
Global $CharNameVal = ""
Global $GuildVal = "Kurzick"
Global $ImperialForVal = "Balthazar"
Global $FactionForVal = "Alliance"
Global $BalthazarForVal = "Zaishen Keys"
Global $FirstPortal = True
Global $PlayingFor = "Kurzick"
Global $CapThisQuarry
Global $PurpleCapped
Global $YellowCapped
Global $GreenCapped
Global $MID_Zkey = 28517
Global $MyTotalZkeys = 0
Global $LastPortal = 10
Global $GWVersion = 0
Global $RenderCounter = 0
Global $IAmCaster
Global $ChatTimer = TimerInit()

Global $sMsg, $hProgress, $aRet[2]

Enum	$SKILL_Contagion = 1, _
		$SKILL_DarkAura, _
		$SKILL_DeathNova, _
		$SKILL_PutridBile, _
		$SKILL_ShadowWalk, _
		$SKILL_SignetOfAgony, _
		$SKILL_TouchOfAgony, _
		$SKILL_Dash

Enum	$SHRINE_PurpleQuarry = 1, _
		$SHRINE_YellowQuarry, _
		$SHRINE_GreenQuarry, _
		$SHRINE_PurpleGuard, _
		$SHRINE_YellowKurzGuard, _
		$SHRINE_MiddleKurzGuard, _
		$SHRINE_MiddleLuxGuard, _
		$SHRINE_YellowLuxGuard, _
		$SHRINE_GreenGuard, _
		$SHRINE_LuxBase, _
		$SHRINE_KurzBase

Dim $aShrines[11][2] = [[1579.7390, -2295.26], _      ;purplequarry
					    [-3034.230, 6240.510], _	  ;yellowquarry
					    [5249.4785, 1231.989], _ 	  ;greenquarry
					    [-542.4951, -2066.41], _	  ;purpleguard
					    [-4836.251, 4633.272], _	  ;yellowkurzguard
					    [-1044.872, 2163.458], _      ;middlekurzguard
					    [864.0032, 4244.3945], _	  ;middleluxguard
					    [-1182.46, 8126.49]  , _      ;yellowluxguard
						[5239.0000, 3847.000], _      ;greenguard
						[0.0, 0.0]               , _      ;luxbase
						[0.0, 0.0] ]                   ;kurzbase

Enum	$PORTAL_KurzLeft = 0, _
		$PORTAL_KurzMid, _
		$PORTAL_KurzRight, _
		$PORTAL_LuxLeft, _
		$PORTAL_LuxMid, _
		$PORTAL_LuxRight

Dim $aPortals[6][2] = [	[-4894, -1619], _; oku
						[-3680, -1760], _; -3680 -1761
						[-3244, -2430], _; -3244 -2429
						[5206, 6622], _;
						[4611, 6885], _;
						[4119, 8289]	];

Dim $aTeleports[6][2] = [	[-3290, 2400], _; -3290, 2399
							[-295, 1125], _; -295 1124
							[-650, -720], _; -654 -719
							[3806, 3731], _;
							[1777, 3312], _;
							[667, 6432]	];


#EndRegion


#Region - GUI

Global $boolRun = True
Global $NeedToChangeMap = False
Global $OldGuiText

Initialize2UH()

Opt("TrayMenuMode", 3)
Opt("TrayAutoPause", 0)
Opt("TrayOnEventMode", 1)
#NoTrayIcon ; no tray icon
TraySetIcon(@ScriptDir & "\Leader.ico")

Global $StartProgram = TrayCreateItem("Stop After Match")
TrayItemSetOnEvent(-1, "TrayHandler")

Global $RenderMode = TrayCreateItem("Change Render")
TrayItemSetOnEvent(-1, "TrayHandler")

TrayCreateItem("")

Global $tExit = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "TrayHandler")


Main()

#Region - Main Funcs

Func Main()
   ConsoleWrite("hi")
	Sleep(5000)

	While 1
		Sleep(100)
		If $boolRun Then
			If GetAgentExists(-2) == False And WinExists(GetWindowHandle()) Then
				Local $Sleeper = 1000
				Do
					Sleep(7000 + $Sleeper)
					$Sleeper += 1000
					ControlSend(GetWindowHandle(), "", "", "{Enter}")
				Until GetAgentExists(-2) == True Or $Sleeper > 10000
			EndIf
			Sleep(Random(1000, 2000, 1))
			$IAmCaster = GetIsCasterProfession()
			While $boolRun
				$aProcessList = ProcessList("Gw.exe") ; Closed Crashed GW
				Sleep(3000)
				_PurgeHook()

				If $ImperialForVal <> "none" Then
					$iTotalImperial = GetImperialFaction()
					ConsoleWrite($iTotalImperial)
					Local $ImperialValOfBalth = $iTotalImperial / 3
					UpdateStatus("Imperial : " & $iTotalImperial)
					$iTotalBalthazar = GetBalthazarFaction()
					If $ImperialValOfBalth + $iTotalBalthazar > 10001 Then
						TradeBalthazarX($BalthazarForVal)
					EndIf
					If ($iTotalImperial >= 12000) Then
						TradeImperialX($ImperialForVal)
					EndIf
				EndIf

				If $BalthazarForVal <> "none" Then
					$iTotalBalthazar = GetBalthazarFaction()
					RndSleep(250)
					UpdateStatus("Balthazar : " & $iTotalBalthazar)
					If ($iTotalBalthazar >= 5000) Then
						TradeBalthazarX($BalthazarForVal)
					EndIf
				EndIf

				RndSleep(500)
				BotLoop()
			WEnd
		Else
			EnableRendering()
			UpdateStatus("Bot Closed.")
			Exit
		EndIf
	WEnd

EndFunc

Func _StopGame($Text)
	$boolRun = Not $boolRun
	If $boolRun Then
		TrayItemSetText($StartProgram, "Stop After Match")
	Else
		TrayItemSetText($StartProgram, "Start JQ Bot")
	EndIf
EndFunc

Func BotLoop()
	Local $RandomPortal
	If GetMapID() == $JadeQuarryKurzickID Then
		$PlayingFor = "Kurzick"
	ElseIf GetMapID() == $JadeQuarryLuxonID Then
		$PlayingFor = "Luxon"
	Else
		TravelTo($JadeQuarryKurzickID)
		$PlayingFor = "Kurzick"
	EndIf
	OutpostCheck()
	ClearMemory()
	Sleep(400)

	UpdateStatus("Entering Battle.")
	If GetEffectTimeRemaining(2546) > 0 Then
		UpdateStatus("Wait for Dishonorable.")
		Sleep(GetEffectTimeRemaining(2546) + 2000) ; Dishonorable
	EndIf
	If GetMapLoading() == $INSTANCETYPE_OUTPOST Then EnterChallenge()
	Do
		Sleep(1000)
	Until GetMapID() == $JadeQuarryArenaID

	Sleep(Random(1000, 5000))
	If GetMapID() = $JadeQuarryArenaID Then
		$PurpleCapped = False
		$YellowCapped = False
		$GreenCapped = False
		Local $Me = GetAgentByID(-2)
		$MyPlayerNumber = DllStructGetData($Me, 'PlayerNumber')

		Do
			If $PlayingFor == "Kurzick" Then
			Do
				$RandomPortal = Random(0, 2, 1)
			Until $LastPortal <> $RandomPortal ; Don't go through same portal twice
			Else
				Do
					$RandomPortal = Random(3, 5, 1)
				Until $LastPortal <> $RandomPortal
			EndIf
			$LastPortal = $RandomPortal
			WaitAlive()
			GameOver()
			GoPortal($RandomPortal)
			RndSleep(250)
			GameOver()
			ShrineSearch()
		Until GameOver()
		UpdateStatus("Loading JQ Match.")
	EndIf
EndFunc

Func GoPortal($iPortal)
	UpdateStatus("Moving to portal: #" & $iPortal)

	Local $lBlocked = 0
	Local $lMe
	Local $lAngle = 0
	Local $tEscape = TimerInit()
	Local $lMapLoading = GetMapLoading(), $lMapLoadingOld
	Local $distance = 1000
	Local $MadeToPortal = False
	Local $DistanceToPortal
	$lMe = GetAgentByID(-2)
	$Random = Random(1, 1500)
	Sleep($Random)

	Move($aPortals[$iPortal][0], $aPortals[$iPortal][1], 30)

	Do
		Sleep(250)

		If GetIsDead($lMe) Then ExitLoop
		$lMapLoadingOld = $lMapLoading
		$lMapLoading = GetMapLoading()
		If $lMapLoading <> $lMapLoadingOld Then ExitLoop

		If GetIsMoving(-2) = False AND TimerDiff($tEscape) > 40000 Then
			Move($aPortals[$iPortal][0], $aPortals[$iPortal][1], 5)
			If TimerDiff($tEscape) > 60000 Then
				$lAngle += 40
				Move(XLocation() + 200 * Sin($lAngle), YLocation() + 200 * Cos($lAngle))
				Sleep(2000)
				Move($aPortals[$iPortal][0], $aPortals[$iPortal][1], 5)
				Sleep(500)
			EndIf
		EndIf
		$lMe = GetAgentByID(-2)
		$distance = ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $aTeleports[$iPortal][0], $aTeleports[$iPortal][1])
	Until  $distance < 400
	Return 1
EndFunc

Func CheckQuarry() ; Return non captured quarries
	Local $target
	Local $distance
	Local $MyDistance
	For $iShrine = 0 To 2
		If $iShrine == 0 And $PurpleCapped == True Then ContinueLoop
		If $iShrine == 1 And $YellowCapped == True Then ContinueLoop
		If $iShrine == 2 And $GreenCapped == True Then ContinueLoop
		$distance = GetNearestQuarryAgentToCoords($aShrines[$iShrine][0], $aShrines[$iShrine][1])
		$MyDistance = ComputeDistance(XLocation(), YLocation(), $aShrines[$iShrine][0], $aShrines[$iShrine][1])
		If $distance[1] > 1420 And $MyDistance < 4500 And $MyDistance > 1000 Then
			If $iShrine + 1 == $SHRINE_PurpleQuarry Then $PurpleCapped = True
			If $iShrine + 1 == $SHRINE_YellowQuarry Then $YellowCapped = True
			If $iShrine + 1 == $SHRINE_GreenQuarry Then $GreenCapped = True
			Return $iShrine
		EndIf
	Next

	Return 50
EndFunc

Func CloseToQuarry() ; checks my distance to quarries
	Local $MyDistance
	For $iShrine = 0 To 2
		$MyDistance = ComputeDistance(XLocation(), YLocation(), $aShrines[$iShrine][0], $aShrines[$iShrine][1])
		If $MyDistance < 1500 Then
			Return True
		EndIf
	Next
	Return False
EndFunc

Func ShrineSearch()
	Local $lMe = GetAgentByID(-2)
	Local $BestTarget = 0
	Local $NewShrineTargets
	Local $IAmMoving
	Local $IAmMovingTimer = TimerInit()
	Local $theta
	Local $Blocked = 0
	Local $CurrentTarget = 0
	Local Const $Quarry = 4
	Local Const $SoloShrine = 3
	Local Const $Shrine = 2
	Local Const $EnemyPlayer = 1
	Local $RandomAttackPlayer = Random(30, 100, 1)
	Local $LoopAttackCounter = 0
	Local $RandomSleep = Random(30, 100, 1)
	Local $LoopSleepCounter = 0
	Local $lAgents

    Do
		$LoopSleepCounter += 1
		$LoopAttackCounter += 1
		If $LoopSleepCounter > $RandomSleep And $NearestShrineDist > 1700 Then ;; Random Sleeps every 30-100 loops
			UpdateStatus("Random Nap!")
			Sleep(Random(3000, 5000, 1))
			$RandomSleep = Random(30, 50, 1)
			$LoopSleepCounter = 0
		EndIf
		UpdateWorld()
		$CapThisQuarry = CheckQuarry()
		If GetIsDead() Then Return False
		$IAmMoving = GetIsMoving()
		If ($LoopAttackCounter > $RandomAttackPlayer And $mClosestEnemyDist < 1350 And $NearestShrineDist >= 1500) Or $mClosestCarrier <> 0 Then
			$RandomAttackPlayer = Random(20, 50, 1)
			$LoopAttackCounter = 0
			UpdateStatus("Random Attack Loop!")
			Do
				UpdateWorld()
				GameOver() ; Check
				If $mClosestAllyDist < 180 Then
					$theta = Random(0, 360, 1)
					UpdateStatus("Move, You're in my bubble.")
					Move(200 * Cos($theta * 0.01745) + XLocation($mClosestAlly), 200 * Sin($theta * 0.01745) + YLocation($mClosestAlly), 0)
					Sleep(250)
				Else
					MoveIfHurt()
				EndIf
				If $mClosestCarrier <> 0 Then
					UpdateStatus("Attack closest Closest Carrier.")
					Attack($mClosestCarrier)
				ElseIf $NearestQuarryDist < 1300 Then
					UpdateStatus("Attack closest Nearest Quarry Target.")
					Attack($NearestQuarryTarget)
				ElseIf $NearestShrineDist < 1300 Then
					UpdateStatus("Attack closest Nearest Shrine Target.")
					Attack($NearestShrineTarget)
				elseIf $mClosestEnemy <> 0 Then
					UpdateStatus("Attack closest Enemy.")
					Attack($mClosestEnemy)
				Else
					ExitLoop
				EndIf
				SmartCast()
				PingSleep(250)
				If GetIsDead() Then Return False
			Until $NumberOfFoesInAttackRange <= 0
			UpdateStatus("Random Attack Loop Completed!")
		ElseIf $CapThisQuarry < 3 And $mClosestEnemyDist > 500 Then
			If $CapThisQuarry == 0 Then UpdateStatus("Capping Purple Quarry!")
			If $CapThisQuarry == 1 Then UpdateStatus("Capping Yellow Quarry!")
			If $CapThisQuarry == 2 Then UpdateStatus("Capping Green Quarry!")
			MoveToQuarry($CapThisQuarry)
		ElseIf $NearestShrineDist <= 1500 Or $NearestQuarryDist <= 1500 Then ;; Attack shrines/quarries
			UpdateStatus("Capping Loop.")
			Do
				UpdateWorld()
				GameOver() ; Check
					If $mClosestAllyDist < 180 Then
						$theta = Random(0, 360, 1)
						UpdateStatus("Move, You're in my bubble.")
						Move(200 * Cos($theta * 0.01745) + XLocation($mClosestAlly), 200 * Sin($theta * 0.01745) + YLocation($mClosestAlly), 0)
						Sleep(250)
					Else
						MoveIfHurt()
					EndIf
					If $NearestQuarryDist < 1300 Then
						UpdateStatus("Attack closest Nearest Quarry Target.")
						Attack($NearestQuarryTarget)
					ElseIf $NearestShrineDist < 1300 Then
						UpdateStatus("Attack closest Nearest Shrine Target.")
						Attack($NearestShrineTarget)
					ElseIf $mClosestEnemy <> 0 Then
						UpdateStatus("Attack closest Enemy.")
						Attack($mClosestEnemy)
					Else
						ExitLoop
					EndIf
				SmartCast()
				PingSleep(250)
				If GetIsDead() Then Return False
			Until $NumberOfFoesInAttackRange <= 0
			UpdateStatus("Shrine Loopis clear.")
			;; I'm hurt
		ElseIf $IsSpeedBoostSkill[0] And $SpeedBoostTarget <> 0 Then
			UpdateStatus("Speed Boost!")
			GameOver() ; Check
			SmartCast()
			Sleep(250)
		ElseIf $MyMaxHP - GetHealth() > Random(50, 150, 1) Or $NumberOfFoesInAttackRange > 2 Then
			UpdateStatus("Health Check-up!")
			SmartCast()
			Sleep(250)
			GameOver() ; Check
			If $IAmCaster == False Then
				Attack($mClosestEnemy)
			Else
				MoveIfHurt()
			EndIf
		ElseIf CloseToQuarry() And $NumberOfFoesInAttackRange > 0 Then
			UpdateStatus("Defend Quarry!")
			SmartCast()
			GameOver() ; Check
			If $IAmCaster == False Then
				Attack($mClosestEnemy)
			EndIf
			Sleep(250)
		ElseIf $IAmMoving == True Then
			GameOver() ; Check
			$Blocked = 0
			;; Moving to enemy player or shrine but found quarry
			If $NearestQuarryDist <= 4500 And ($CurrentTarget < $Quarry OR TimerDiff($IAmMovingTimer) > 10000) Then
				UpdateStatus("Moving to Quarry.")
				$IAmMovingTimer = TimerInit()
				$CurrentTarget = $Quarry
				Move(XLocation($NearestQuarryTarget), YLocation($NearestQuarryTarget), 0)
				Sleep(500)
			;; Moving to enemy player but found shrine, or closer shrine
			ElseIf $LeastAttackedShrineDist <= 4000 And ($CurrentTarget < $SoloShrine OR TimerDiff($IAmMovingTimer) > 15000) Then
				UpdateStatus("Moving to Solo Shrine.")
				$IAmMovingTimer = TimerInit()
				$CurrentTarget = $Shrine
				Move(XLocation($LeastAttackedShrine), YLocation($LeastAttackedShrine), 0)
				Sleep(500)
			EndIf
			If $IsCorpseSpell[0] And $NumberOfDeadFoes > 1 Then
				SmartCast()
			EndIf
		Else
			GameOver() ; Check
			$IAmMovingTimer = 0
			;; No Enemies on map
			If $NumPlayersOnMap < 0 Or $Blocked > 6 Then
				UpdateStatus("No enemies found. Moving to center of map.")
				Move($MapCenter[0], $MapCenter[1], 300)
				$CurrentTarget = $EnemyPlayer
				Sleep(1000)
				$Blocked += 1
			;; Player blocking me
			ElseIf $NumPlayersInCloseRange > 0 And $Blocked > 2 Then ;; Attack enemy players that are close.
				UpdateStatus("Blocking me, attack.")
				$CurrentTarget = $EnemyPlayer
				SmartCast()
				If $IAmCaster == False Then
					Attack($mClosestEnemy)
				EndIf
				Sleep(250)
			;; Move to next Quarry
			ElseIf $NearestQuarryDist <= 4500 And $Blocked < 4 Then
				UpdateStatus("Moving to Quarry.")
				$CurrentTarget = $Quarry
				Sleep(Random(10,1500, 1))
				Move(XLocation($NearestQuarryTarget), YLocation($NearestQuarryTarget), 0)
				$Blocked += 1
				Sleep(500)
			ElseIf $LeastAttackedShrineDist	< 4000 And $Blocked < 3 Then
				UpdateStatus("Moving to Solo Shrine.")
				$CurrentTarget = $SoloShrine
				Sleep(Random(10,1500, 1))
				Move(XLocation($LeastAttackedShrine), YLocation($LeastAttackedShrine), 0)
				$Blocked += 1
				Sleep(500)
			;; Move to next shrine
			ElseIf $NearestShrineDist <= 4000 And $Blocked < 3 Then
				UpdateStatus("Moving to Shrine.")
				$CurrentTarget = $Shrine
				Sleep(Random(10,2000, 1))
				Move(XLocation($NearestShrineTarget), YLocation($NearestShrineTarget), 0)
				$Blocked += 1
				Sleep(500)
			;; Blocked and out of range of shrine
			ElseIf $mClosestEnemy <> 0 Then
				UpdateStatus("Moving to enemy player.")
				$CurrentTarget = $EnemyPlayer
				Move(XLocation($mClosestEnemy), YLocation($mClosestEnemy), 500)
				$Blocked += 1
				Sleep(500)
			EndIf
		EndIf
		PingSleep(300)

	Until GetIsDead() Or GameOver()
EndFunc

#EndRegion
