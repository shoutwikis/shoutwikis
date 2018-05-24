#include-once
Func Main()

EndFunc

Func CustomCastEngine($MyID, $MyPtr, $Skillbar, $aRange, $aSkipCinematic)

EndFunc

#Region Move
;~ Description: Move to a location.
Func Move($aX, $aY, $aRandom = 50)
   ;returns true if successful
   If $aX = 0 Or $aY = 0 Then Return
   If $AOEDanger And TimerDiff($AOEDangerTimer) < $AOEDangerDuration * 1000 Then
	  If ComputeDistance($AOEDangerXLocation, $AOEDangerYLocation, $aX, $aY) < 200 Then $aRandom = $AOEDangerRange + 50
   EndIf
   If GetAgentExists(-2) Then
	  DllStructSetData($mMove, 2, $aX + Random(-$aRandom, $aRandom))
	  DllStructSetData($mMove, 3, $aY + Random(-$aRandom, $aRandom))
	  Enqueue($mMovePtr, 16)
	  Return True
   Else
	  Return False
   EndIf
EndFunc   ;==>Move

;~ Description: Move to exact location, no random number added.
Func Move_($aX, $aY)
   If $aX = 0 Or $aY = 0 Then Return
   If GetAgentExists(-2) Then
	  DllStructSetData($mMove, 2, $aX)
	  DllStructSetData($mMove, 3, $aY)
	  Enqueue($mMovePtr, 16)
	  Return True
   Else
	  Return False
   EndIf
EndFunc   ;==>Move_

;~ Description: Move function with disconnect check
Func MoveEx($x, $y, $random = 50)
   If GetMapLoading() <> 1 Then Return Main()
   Move($x, $y, $random)
EndFunc   ;==>MoveEx

;~ Description: Move to a location and wait until you reach it.
Func MoveTo($aX, $aY, $aRandom = 50, $aMe = GetAgentPtr(-2))
   If GetIsDead($aMe) Then Return False
   If $aRandom = Default Then $aRandom = 50
   Local $lBlocked = 0
   Local $lMoveX, $lMoveY, $lMeX, $lMeY
   UpdateAgentPosByPtr($aMe, $lMeX, $lMeY)
   If ComputeDistance($lMeX, $lMeY, $aX, $aY) <= $aRandom Then Return True
   Local $lMapLoading = GetMapLoading(), $lMapLoadingOld
   Local $lDestX = $aX + Random(-$aRandom, $aRandom)
   Local $lDestY = $aY + Random(-$aRandom, $aRandom)
   Do
	  Move($lDestX, $lDestY, 0)
	  Sleep(250)
	  If MemoryRead($aMe + 304, 'float') <= 0 Then Return False
	  $lMapLoadingOld = $lMapLoading
	  $lMapLoading = GetMapLoading()
	  If $lMapLoading <> $lMapLoadingOld Then Return False
	  If $lMapLoading = 2 Then Return False
	  UpdateAgentMoveByPtr($aMe, $lMoveX, $lMoveY)
	  If $lMoveX = 0 And $lMoveY = 0 Then
		 UpdateAgentPosByPtr($aMe, $lMeX, $lMeY)
		 If ComputeDistance($lMeX, $lMeY, $lDestX, $lDestY) < $aRandom Then Return True
		 $lBlocked += 1
		 $lDestX = $aX + Random(-$aRandom, $aRandom)
		 $lDestY = $aY + Random(-$aRandom, $aRandom)
		 Move($lDestX, $lDestY, 0)
		 If $lBlocked > 14 Then Return False
	  EndIf
	  UpdateAgentPosByPtr($aMe, $lMeX, $lMeY)
	  $lDistance = ComputeDistance($lMeX, $lMeY, $lDestX, $lDestY)
	  Until $lDistance < $aRandom
   Return True
EndFunc   ;==>MoveTo

;~ Description: Move to a location and wait until you reach it, will cast on enemies in range.
Func MoveToAlert($aX, $aY, $aRandom = 0, $aMe = GetAgentPtr(-2))
   Local $lBlocked = 0
   Local $lMoveX, $lMoveY, $lMeX, $lMeY
   Local $lMapLoading = GetMapLoading(), $lMapLoadingOld
   Local $lDestX = $aX + Random(-$aRandom, $aRandom)
   Local $lDestY = $aY + Random(-$aRandom, $aRandom)
   Local $lAngle
   Move($lDestX, $lDestY, 0)
   Do
	  Sleep(100)
	  If MemoryRead($aMe + 304, 'float') <= 0 Then ExitLoop
	  $lMapLoadingOld = $lMapLoading
	  $lMapLoading = GetMapLoading()
	  If $lMapLoading <> $lMapLoadingOld Then ExitLoop
	  Local $lAgentArray = GetAgentPtrArray(1)
	  If GetNumberOfFoesInRangeOfAgent_($lAgentArray, $aMe, 5000) > 0 Then
		 Do
			UpdateWorld($lAgentArray, Default, Default, $aMe)
			If IsDeclared("UseCustomCastEngine") Then
			   CustomCastEngine(False, False, False, False, False)
			Else
			   SmartCast()
			EndIf
		 Until GetNumberOfFoesInRangeOfAgent_($lAgentArray, $aMe, 1250) = 0
		 PickUpLoot()
	  EndIf
	  UpdateAgentMoveByPtr($aMe, $lMoveX, $lMoveY)
	  If $lMoveX = 0 And $lMoveY = 0 Then
		 $lDestX = $aX + Random(-$aRandom, $aRandom)
		 $lDestY = $aY + Random(-$aRandom, $aRandom)
		 $lAngle += 40
		 Move(XLocation($aMe) + 300 * Sin($lAngle), YLocation($aMe) + 300 * Cos($lAngle))
		 PingSleep(500)
		 Move($lDestX, $lDestY, 0)
	  EndIf
	  UpdateAgentPosByPtr($aMe, $lMeX, $lMeY)
   Until ComputeDistance($lMeX, $lMeY, $lDestX, $lDestY) < 25
EndFunc   ;==>MoveToAlert

;~ Description: Skip everything and run to leader before attacking/looting.
Func MoveToLeader($aDistance = 1200, $aMe = GetAgentPtr(-2))
   If $SavedLeaderID = 0 Then Return True
   Update("Running to Leader")
   $AOEDanger = False
   Local $lDistance = $aDistance - 300
   Local $lBlocked = 0
   Local $lAngle = 0
   Local $lLeaderPtr = GetAgentPtr($SavedLeaderID)
   Local $lLeaderX, $lLeaderY, $lMeX, $lMeY
   UpdateAgentPosByPtr($lLeaderPtr, $lLeaderX, $lLeaderY)
   UpdateAgentPosByPtr($aMe, $lMeX, $lMeY)
   If $lLeaderX = 0 Then Return True
   Move($lLeaderX, $lLeaderY, 0)
   PingSleep(500)
   For $i = 1 To 3000
	  Sleep(300)
	  If $lBlocked > 50 Then Return True
	  If GetMapLoading() <> 1 Then Return True
	  If GetIsDead($aMe) Then Return False
	  If Not GetIsMoving($aMe) Then
		 $lBlocked += 1
		 GoPlayer($SavedLeaderID)
		 Sleep(200)
		 If Mod($lBlocked, 2) = 0 And Not GetIsMoving(-2) Then
			UpdateAgentPosByPtr($aMe, $lMeX, $lMeY)
			$lAngle += 40
			Move($lMeX + 200 * Sin($lAngle), $lMeY + 200 * Cos($lAngle))
			PingSleep(500)
		 EndIf
	  EndIf
	  UpdateAgentPosByPtr($lLeaderPtr, $lLeaderX, $lLeaderY)
	  Move($lLeaderX, $lLeaderY, 0)
	  If ComputeDistance($lMeX, $lMeY, $lLeaderX, $lLeaderY) < $lDistance Then Return True
   Next
   Return True
EndFunc   ;==>MoveToLeader

#Region MoveAggroing
;~ Description: Params: MoveX, MoveY, Sleep after moving. Requires UpdateWorld() variables.
Func MoveAggroing($MoveToX, $MoveToY, $SleepTime = Default, $aMyID = GetMyID(), $aMe = GetAgentPtr($aMyID))
   If $SleepTime = Default Then $SleepTime = 3600000
   Local Static $WaypointCounter = 1
   $Blocked = 0
   $lBlocked = 0
   $lAngle = 0
   Update("Move to waypoint #" & $WaypointCounter)
   $WaypointCounter += 1
   MoveEx($MoveToX, $MoveToY)
   $SleepTimer = TimerInit()
   Do ;;;;;;;;;; Leader LOOP
	  PingSleep(200)
	  $Blocked += 1
	  Local $lAgentArray = GetAgentPtrArray(1) ; all living
	  If $Blocked > 400 Then ResignAndReturn()
	  If Not UpdateWorld($lAgentArray, 1350, $aMyID, $aMe) Then Death_($lAgentArray, $aMe)
	  If Not MoveIfHurt($aMe) Then Death_($lAgentArray, $aMe)
	  If Not AttackRange($lAgentArray, 1350, $aMe) Then Death_($lAgentArray, $aMe)
	  If Not SmartCast($aMe) Then Death_($lAgentArray, $aMe)
	  If Not PickUpLoot(2, $aMe) Then Death_($lAgentArray, $aMe)
	  If Not $boolRun Then ExitLoop
	  GetHealthCheck($lAgentArray)
	  If GetMapLoading() <> 1 Then ExitLoop
	  If MemoryRead($aMe + 44, 'long') <> $aMyID Then ExitLoop
	  $MyLocation = XandYLocation($aMe) ; returns array
	  If $mLowestEnemy = 0 And Not GetIsMoving($aMe) Then
		 $lBlocked += 1
		 Move($MoveToX, $MoveToY)
		 Sleep(200)
		 If Mod($lBlocked, 2) = 0 And Not GetIsMoving($aMe) Then
			$lAngle += 40
			Move($MyLocation[0] + 200 * Sin($lAngle), $MyLocation[1] + 200 * Cos($lAngle))
			PingSleep(500)
		 EndIf
	  EndIf
	  OutpostCheck()
	  Sleep(100)
	  If ComputeDistance($MoveToX, $MoveToY, $MyLocation[0], $MyLocation[1]) < 200 And $EnemyAttacker = 0 Then Return True
   Until TimerDiff($SleepTimer) > $SleepTime
EndFunc   ;==>MoveAggroing

;~ Description: Same as MoveAggroing, but requires $MyID, $MyPtr, $Skillbar to be set before use. Use InitPointers() after zoning.
Func MoveAggroing_($aX, $aY, $aSleepTime = Default, $aSkipCinematic = False, $aRange = 1350)
   If $aSleepTime = Default Then $SleepTime = 3600000
   Local Static $WaypointCounter = 1
   Local $lMeX, $lMeY
   $Blocked = 0
   $lBlocked = 0
   $lAngle = 0
   Update("Move to waypoint #" & $WaypointCounter & " (" & $aX & ", " & $aY & ")")
   $WaypointCounter += 1
   MoveEx($aX, $aY)
   $SleepTimer = TimerInit()
   Do ;;;;;;;;;; Leader LOOP
	  PingSleep(200)
	  $Blocked += 1
	  If $Blocked > 400 Then ResignAndReturn()
	  Local $lAgentArray = GetAgentPtrArray(1) ; all living
	  If IsDeclared("UseCustomCastEngine") Then
		 If Not CustomCastEngine($MyID, $MyPtr, $Skillbar, $aRange, $aSkipCinematic) Then Death_($lAgentArray, $MyPtr)
	  Else
		 If Not UpdateWorld($lAgentArray, 1350, $MyID, $MyPtr) Then Death_($lAgentArray, $MyPtr)
		 If Not MoveIfHurt($MyPtr) Then Death($MyPtr)
		 If Not AttackRange($lAgentArray, 1350, $MyPtr) Then Death_($lAgentArray, $MyPtr)
		 If Not SmartCast($MyPtr) Then Death_($lAgentArray, $MyPtr)
	  EndIf
	  If $aSkipCinematic And DetectCinematic() Then
		 SkipCinematic()
		 Do
			Sleep(1000)
		 Until Not DetectCinematic()
		 $MyID = GetMyID()
		 $MyPtr = GetAgentPtr($MyID)
		 $Skillbar = GetSkillbarPtr()
		 $SkippedCinematic = True
	  EndIf
	  If Not PickUpLoot(2, $MyPtr) Then Death_($lAgentArray, $MyPtr)
	  GetHealthCheck($lAgentArray)
	  If GetMapLoading() <> 1 Then ExitLoop
	  UpdateAgentPosByPtr($MyPtr, $lMeX, $lMeY)
	  If $mLowestEnemy = 0 And Not GetIsMoving($MyPtr) Then
		 $MyID = GetMyID()
		 $MyPtr = GetAgentPtr($MyID)
		 $Skillbar = GetSkillbarPtr()
		 If GetIsMoving($MyPtr) Then ContinueLoop
		 $lBlocked += 1
		 Move($aX, $aY)
		 Sleep(200)
		 If Mod($lBlocked, 2) = 0 And Not GetIsMoving($MyPtr) Then
			$lAngle += 40
			Move($lMeX + 200 * Sin($lAngle), $lMeY + 200 * Cos($lAngle))
			PingSleep(500)
		 EndIf
	  EndIf
	  OutpostCheck()
	  Sleep(100)
	  UpdateAgentPosByPtr($MyPtr, $lMeX, $lMeY)
	  If ComputeDistance($aX, $aY, $lMeX, $lMeY) < 200 And $EnemyAttacker = 0 Then Return True
   Until TimerDiff($SleepTimer) > $aSleepTime
EndFunc

;~ Description: Sets $MyID, $MyPtr and $Skillbar.
Func InitPointers()
   Do
	  Sleep(1000)
	  $MyID = GetMyID()
   Until $MyID > 0 And $MyID <= 300
   $MyPtr = GetAgentPtr($MyID)
   $Skillbar = GetSkillbarPtr(0, $MyID)
   $mSkillbarCache[0] = False
   Update("Me: " & $MyPtr & " - " & $MyID)
EndFunc

;~ Description: Returns true if agent and party is dead.
Func Death($aAgent = GetAgentPtr(-2), $aResign = True)
   If IsPtr($aAgent) <> 0 Then
	  Local $lAgentPtr = $aAgent
   Else
	  Local $lAgentPtr = GetAgentPtr($aAgent)
   EndIf
   Local $lPartyDead = False
   If BitAND(MemoryRead($lAgentPtr + 312, 'long'), 0x0010) Then
	  Local $lPartyArray = GetAgentPtrArray(3, 0xDB, 1, True)
	  If $lPartyArray[0] <> 0 Then
		 For $i = 1 to 5
			If GetMapLoading() <> 1 Then
			   $lPartyDead = True
			   ExitLoop
			EndIf
			For $j = 1 To $lPartyArray[0]
			   If BitAND(MemoryRead($lPartyArray[$j] + 312, 'long'), 0x0010) Then
				  $lPartyDead = True
			   Else
				  $lPartyDead = False
			   EndIf
			Next
			RndSleep(100)
		 Next
	  Else
		 $lPartyDead = True
	  EndIf
	  If $lPartyDead And $aResign Then ResignAndReturn()
	  Return $lPartyDead
   EndIf
EndFunc   ;==>Death

;~ Description: Returns true if agent and party is dead. ---
Func Death_(ByRef $aAgentArray, $aAgent = GetAgentPtr(-2), $aResign = True)
   If IsPtr($aAgent) <> 0 Then
	  Local $lAgentPtr = $aAgent
   Else
	  Local $lAgentPtr = GetAgentPtr($aAgent)
   EndIf
   Local $lPartyDead = False
   If BitAND(MemoryRead($lAgentPtr + 312, 'long'), 0x0010) Then
	  If $aAgentArray[0] <> 0 Then
		 For $i = 1 to 5
			If GetMapLoading() <> 1 Then
			   $lPartyDead = True
			   ExitLoop
			EndIf
			For $j = 1 To $aAgentArray[0]
			   If MemoryRead($aAgentArray[$j] + 433, 'byte') <> 1 Then ContinueLoop ; Allegiance
			   If BitAND(MemoryRead($aAgentArray[$j] + 312, 'long'), 0x0010) Then
				  $lPartyDead = True
			   Else
				  $lPartyDead = False
			   EndIf
			Next
			RndSleep(100)
		 Next
	  Else
		 $lPartyDead = True
	  EndIf
	  If $lPartyDead And $aResign Then ResignAndReturn()
	  Return $lPartyDead
   EndIf
EndFunc   ;==>Death

;~ Description: Internal use MoveAggroing(). ---
Func AttackRange(ByRef $aAgentArray, $Distance = 1350, $aMe = GetAgentPtr(-2)) ; Cast Range
   If GetIsDead($aMe) Then Return False
   If GetMapLoading() <> 1 Then Return True
   If $mLowestEnemy <> 0 Then
	  Attack($mLowestEnemy)
   Else
	  $VIP = GetVIP_($aAgentArray, $Distance)
	  $VIPsTarget = GetTarget($VIP)
	  If $VIPsTarget > 0 Then
		 Attack($VIPsTarget)
	  EndIf
   EndIf
EndFunc   ;==>AttackRange

;~ Description: Don't Continue on while anyone has low health, Returns TRUE if all have good HP. Internal use MoveAggroing()
Func GetHealthCheck(ByRef $aAgentArray)
   Local $MoveX, $MoveY
   If $mClosestEnemy <> 0 Then Return True ; Return if someone to fight
   For $i = 1 To $aAgentArray[0]
	  If MemoryRead($aAgentArray[$i] + 433, 'byte') <> 1 Then ContinueLoop ; Allegiance
	  If MemoryRead($aAgentArray[$i] + 304, 'float') < 0.40 Then
		 Update("Waiting for party heal")
		 UpdateAgentPosByPtr($aAgentArray[$i], $MoveX, $MoveY)
		 MoveEx($MoveX, $MoveY)
		 RndSleep(1000)
		 Return False
	  EndIf
   Next
   Return True
EndFunc   ;==>GetHealthCheck

;~ Description: Internal use MoveAggroing().
Func OutpostCheck()
   While GetMapLoading() = 2
	  Sleep(500)
   WEnd
   If GetMapLoading() = 0 Then
	  $CurrentMap = 0
	  If GetMapID() > 0 Then $CurrentMap = GetMapID()
	  $CurrentMapState = 0
	  $Resigned = False
	  $GotBounty = False
	  $GetSkillBar = False
	  $SavedLeader = 0
	  If $CurrentMap > 0 Then
		 Update("Hanging in "  & $CurrentMap, 7)
		 $mSkillbarPtr = GetSkillbarPtr()
		 Sleep(200)
		 CacheSkillbar()
	  EndIf
	  If Not $boolRun Then Main()
	  ClearMemory()
   EndIf
EndFunc   ;==>OutpostCheck

;~ Description: Moves around if health is below 90%.
Func MoveIfHurt($aMe = GetAgentPtr(-2))
   Local $lX, $lY, $lRandom = 300, $lBlocked = 0
   If $NumberOfFoesInAttackRange < 1 Then Return True
   If GetMapLoading() <> 1 Then Return True
   If GetIsDead($aMe) Then Return False
   If $AOEDanger And TimerDiff($AOEDangerTimer) < $AOEDangerDuration * 1000 Then
	  UpdateAgentPosByPtr($aMe, $lX, $lY)
	  $DistanceToAOEZone = ComputeDistance($AOEDangerXLocation, $AOEDangerYLocation, $lX, $lY)
	  If $DistanceToAOEZone <= $AOEDangerRange + 50 Then
		 Update("I'm in AOE Danger zone! RUN!")
		 $SafeSpot = GetClosestSafeZone($AOEDangerXLocation, $AOEDangerYLocation, 500, $aMe)
		 $HurtTimer = TimerInit()
		 Move($SafeSpot[0], $SafeSpot[1], 0)
		 Sleep(200)
		 Do
			If Not GetIsMoving($aMe) Then $lBlocked += 1
			Sleep(100)
			UpdateAgentPosByPtr($aMe, $lX, $lY)
		 Until ComputeDistance($AOEDangerXLocation, $AOEDangerYLocation, $lX, $lY) > $AOEDangerRange Or $lBlocked > 8
	  EndIf
   ElseIf $AOEDanger And TimerDiff($AOEDangerTimer) > $AOEDangerDuration * 1000 Then
	  $AOEDanger = False
   EndIf
   If GetHealth($aMe) < $CurrentHP And Not $AOEDanger Then
	  If TimerDiff($HurtTimer) > 1000 And Not GetHasDegenHex($aMe) Then
		 $theta = Random(0, 360)
		 $HurtTimer = TimerInit()
		 UpdateAgentPosByPtr($mHighestAlly, $lX, $lY)
		 Move(50 * Cos($theta * 0.01745) + $lX, 50 * Sin($theta * 0.01745) + $lY, 0)
		 Sleep(300)
	  EndIf
   EndIf
   $CurrentHP = GetHealth($aMe)
EndFunc   ;==>MoveIfHurt

;~ Description: Gregs circle trig. Returns Array for X,Y location of closest safe point.
Func GetClosestSafeZone($aX, $aY, $radius = 300, $aMe = GetAgentPtr(-2))
   Local $d2r = 3.141592653589 / 180
   Local $coords[2]
   Local $lMeX, $lMeY
   UpdateAgentPosByPtr($aMe, $lMeX, $lMeY)
   Local $theta = 0, $TempX, $TempY, $ClostestLocation = 5000
   For $i = 0 To 17
	  $theta += 20
	  $TempX = ($radius * Cos($theta * $d2r)) + $aX
	  $TempY = ($radius * Sin($theta * $d2r)) + $aY
	  If ComputeDistance($TempX, $TempY, $lMeX, $lMeY) < $ClostestLocation Then
		 $ClostestLocation = ComputeDistance($TempX, $TempY, $lMeX, $lMeY)
		 $coords[0] = $TempX
		 $coords[1] = $TempY
	  EndIf
   Next
   Return $coords
EndFunc   ;==>GetClosestSafeZone

;~ Description: Gregs circle trig.
Func GetClosestCoordAroundAgent($Agent, $radius = 1000)
   Local $d2r = 3.141592653589 / 180
   Local $coords[2]
   Local $aX = XLocation($Agent)
   Local $aY = YLocation($Agent)
   Local $MyaX = XLocation()
   Local $MyaY = YLocation()
   Local $theta = 0, $TempX, $TempY, $ClostestLocation = 500
   Dim $ClostestX[1] = [0]
   Dim $ClostestY[1] = [0]
   For $i = 0 To 99
	  $theta += 3.6
	  $TempX = (($radius - Random(0,5) * 50) * Cos($theta * $d2r)) + $aX
	  $TempY = (($radius - Random(0,5) * 50) * Sin($theta * $d2r)) + $aY
	  If ComputeDistance($TempX, $TempY, $MyaX, $MyaY) > $ClostestLocation Then
		 $ClostestLocation = ComputeDistance($TempX, $TempY, $MyaX, $MyaY)
		 $ClostestX[0] += 1
		 ReDim $ClostestX[$ClostestX[0] + 1]
		 $ClostestX[$ClostestX[0]] = $TempX
		 $ClostestY[0] += 1
		 ReDim $ClostestY[$ClostestY[0] + 1]
		 $ClostestY[$ClostestY[0]] = $TempY
	  EndIf
   Next
EndFunc   ;==>GetClosestCoordAroundAgent

;~ Description: Gregs circle trig.
Func GetAttackPositionAroundAgent($Agent, $radius = 700)
   Local $d2r = 3.141592653589 / 180
   Local $coords[2]
   Local $EnemyLocation = XandYLocation($Agent)
   Local $LeaderLocation = XandYLocation($SavedLeaderID)
   Local $MyLocation = XandYLocation()
   Local $theta = 0, $TempX, $TempY, $ClostestLocation = 5000
   Local $PlayerNum = MemoryRead(GetAgentPtr(-2) + 244, 'word')
   For $i = 0 To 17
	  $theta += 20
	  $PlayerTheta = $theta - 20 + $PlayerNum * 20
	  $TempX = ($radius * Cos($PlayerTheta * $d2r)) + $EnemyLocation[0]
	  $TempY = ($radius * Sin($PlayerTheta * $d2r)) + $EnemyLocation[1]
	  If ComputeDistance($TempX, $TempY, $LeaderLocation[0], $LeaderLocation[1]) < $ClostestLocation Then
		 $ClostestLocation = ComputeDistance($TempX, $TempY, $LeaderLocation[0], $LeaderLocation[1])
		 $coords[0] = $TempX
		 $coords[1] = $TempY
	  EndIf
   Next
   Return $coords
EndFunc   ;==>GetAttackPositionAroundAgent
#EndRegion MoveAggroing
#EndRegion

#Region GoTo
;~ Description: Run to or follow a player.
Func GoPlayer($aAgent)
   If IsPtr($aAgent) <> 0 Then
	  Return SendPacket(0x8, 0x2D, MemoryRead($aAgent + 44, 'long'))
   ElseIf IsDllStruct($aAgent) <> 0 Then
	  Return SendPacket(0x8, 0x2D, DllStructGetData($aAgent, 'ID'))
   Else
	  Return SendPacket(0x8, 0x2D, ConvertID($aAgent))
   EndIf
EndFunc   ;==>GoPlayer

;~ Description: Talk to an NPC.
Func GoNPC($aAgent)
   If IsPtr($aAgent) <> 0 Then
	  $lAgentID = MemoryRead($aAgent + 44, 'long')
   ElseIf IsDllStruct($aAgent) <> 0 Then
	  $lAgentID = DllStructGetData($aAgent, 'ID')
   Else
	  $lAgentID = ConvertID($aAgent)
   EndIf
   ChangeTarget($lAgentID)
   Return SendPacket(0xC, 0x33, $lAgentID)
EndFunc   ;==>GoNPC

;~ Description: Talks to NPC and waits until you reach them.
Func GoToNPC($aAgent, $aMe = GetAgentPtr(-2))
   If IsPtr($aAgent) <> 0 Then
	  Local $lAgentID = MemoryRead($aAgent + 44, 'long')
	  Local $lAgentPtr = $aAgent
   ElseIf IsDllStruct($aAgent) <> 0 Then
	  Local $lAgentID = DllStructGetData($aAgent, 'ID')
	  Local $lAgentPtr = GetAgentPtr($lAgentID)
   Else
	  Local $lAgentID = $aAgent
	  Local $lAgentPtr = GetAgentPtr($lAgentID)
   EndIf
   Local $lAgentX, $lAgentY
   UpdateAgentPosByPtr($lAgentPtr, $lAgentX, $lAgentY)
   Local $lDistance = 50
   Do
	  $lDistance += 50
	  If $lDistance > 300 Then Return False ; cant reach
   Until MoveTo($lAgentX, $lAgentY, $lDistance, $aMe)
   Sleep(100)
   GoNPC($lAgentPtr)
   Sleep(500 + $lDistance)
   Return True
EndFunc   ;==>GoToNPC

;~ Description: Talks to NPC and waits until you are in $aRange.
Func GoFindNPC($aAgent, $aRange = 300, $aMe = GetAgentPtr(-2))
   If IsPtr($aAgent) <> 0 Then
	  Local $lPtr = $aAgent
   ElseIf IsDllStruct($aAgent) <> 0 Then
	  Local $lPtr = GetAgentPtr(DllStructGetData($aAgent, 'ID'))
   Else
	  Local $lPtr = GetAgentPtr(ConvertID($aAgent))
   EndIf
   Local $lX, $lY, $lMoveX, $lMoveY, $lMeX, $lMeY
   Local $lBlocked = 0, $lMapLoading = GetMapLoading()
   UpdateAgentPosByPtr($lPtr, $lX, $lY)
   Move($lX, $lY)
   Sleep(100)
   GoNPC($lPtr)
   Do
	  Sleep(100)
	  $lMapLoadingOld = $lMapLoading
	  $lMapLoading = GetMapLoading()
	  If $lMapLoadingOld <> $lMapLoading Then ExitLoop
	  UpdateAgentMoveByPtr($aMe, $lMoveX, $lMoveY)
	  If $lMoveX = 0 And $lMoveY = 0 Then
		 $lBlocked += 1
		 Move($lX, $lY)
		 Sleep(100)
		 GoNPC($lPtr)
	  EndIf
	  UpdateAgentPosByPtr($aMe, $lMeX, $lMeY)
	  If ComputeDistance($lX, $lY, $lMeX, $lMeY) < $aRange Then Return True
   Until $lBlocked > 14
   Sleep(250)
EndFunc   ;==>GoFindNPC

;~ Description: Run to a signpost.
Func GoSignpost($aAgent)
   If IsPtr($aAgent) <> 0 Then
	  Return SendPacket(0xC, 0x4B, MemoryRead($aAgent + 44, 'long'), 0)
   ElseIf IsDllStruct($aAgent) <> 0 Then
	  Return SendPacket(0xC, 0x4B, DllStructGetData($aAgent, 'ID'), 0)
   Else
	  Return SendPacket(0xC, 0x4B, ConvertID($aAgent), 0)
   EndIf
EndFunc   ;==>GoSignpost

;~ Description: Go to signpost and waits until you reach it.
Func GoToSignpost($aAgent, $aMe = GetAgentPtr(-2))
   If IsPtr($aAgent) <> 0 Then
	  Local $lAgentPtr = $aAgent
   ElseIf IsDllStruct($aAgent) <> 0 Then
	  Local $lAgentID = DllStructGetData($aAgent, 'ID')
	  Local $lAgentPtr = GetAgentPtr($lAgentID)
   Else
	  Local $lAgentPtr = GetAgentPtr($aAgent)
   EndIf
   Local $lBlocked = 0, $lMeX, $lMeY, $lAgentX, $lAgentY
   Local $lMapLoading = GetMapLoading(), $lMapLoadingOld
   Local $lMoveX, $lMoveY, $lMeX, $lMeY, $lAgentX, $lAgentY
   UpdateAgentPosByPtr($lAgentPtr, $lAgentX, $lAgentY)
   Local $lDistance = 50
   Do
	  $lDistance += 50
	  If $lDistance > 300 Then Return False ; cant reach
   Until MoveTo($lAgentX, $lAgentY, $lDistance, $aMe)
   Sleep(100)
   GoSignpost($lAgentPtr)
   Sleep($lDistance)
   Return True
EndFunc   ;==>GoToSignpost

;~ Description: Finds NPC nearest given coords and talks to him/her.
Func GoToNPCNearestCoords($aX, $aY, $aMe = GetAgentPtr(-2))
   Local $lAgent
   For $i = 1 To 20 ; about 1 sec time to retrieve npc
	  $lAgent = GetNearestNPCPtrToCoords($aX, $aY)
	  Sleep(125)
	  If $lAgent <> 0 Then
		 ChangeTarget($lAgent)
		 Return GoToNPC($lAgent, $aMe)
	  EndIf
   Next
EndFunc   ;==>GoToNPCNearestCoords

;~ Description: Walks to NPC nearest X, Y location and tries to donate faction. Checks luxon faction first.
Func GoLuxons($XLocation, $YLocation, $aMe = GetAgentPtr(-2))
   If GetLuxonFaction() > 12000 Then
	  Update("Need to donate Luxon Faction")
	  RndSleep(Random(1000, 10000, 1))
	  Update("Talking to Luxon Scavenger")
	  GoToNPC(GetNearestAgentPtrToCoords($XLocation, $YLocation), $aMe)
	  Sleep(1000)
	  Do
		 Update("Donating Faction")
		 DonateFaction(1)
		 RndSleep(500)
	  Until GetLuxonFaction() < 5000
	  RndSleep(5000)
   EndIf
EndFunc   ;==>GoLuxons

;~ Description: Walks to NPC nearest X, Y location and tries to donate faction. Checks kurzick faction first.
Func GoKurzick($XLocation, $YLocation, $aMe = GetAgentPtr(-2))
   If GetKurzickFaction() > 5000 Then
	  RndSleep(Random(1000, 10000, 1))
	  Update("Talking to Kurzick Scavenger")
	  MoveTo(21386, 6547, 200, $aMe)
	  GoToNPC(GetNearestAgentPtrToCoords($XLocation, $YLocation), $aMe)
	  Sleep(1000)
	  Do
		 Update("Donating Faction")
		 DonateFaction("k")
		 RndSleep(500)
	  Until GetKurzickFaction() < 5000
	  RndSleep(2000)
   EndIf
EndFunc   ;==>GoKurzick

;~ Description: Talk to priest for bounty/bonus.
;~ $aDialogs = "0x84|0x85|0x86" Or "132|133"
;~ $aBounties = "0x84|0x85" Or "132|133"
Func GrabBounty($aX, $aY, $aDialogs = False, $aBounties = False, $aMe = GetAgentPtr(-2))
   GoToNPCNearestCoords($aX, $aY, $aMe)
   If $aDialogs <> False Then
	  Local $lDialogs = StringSplit(String($aDialogs), "|")
	  For $i = 1 To $lDialogs[0]
		 Dialog($lDialogs[$i])
		 Sleep(125)
	  Next
   EndIf
   If $aBounties <> False Then
	  Local $lBounties = StringSplit(String($aBounties), "|")
	  For $i = 1 To $lBounties[0]
		 Dialog($lBounties[$i])
		 Sleep(125)
	  Next
   EndIf
EndFunc   ;==>GrabBounty

;~ Description: Talks to Grenth in TOA and pays him 1k.
Func GetInUnderworld($aMe = GetAgentPtr(-2))
   Local $lX, $lY
   Local $GrenthSpawn = 0
   Local $lMyID = GetMyID()
   Update("Move To Grenth")
   MoveTo(-4196, 19781, 50, $aMe)
   PingSleep(250)
   UpdateAgentPosByPtr($aMe, $lX, $lY)
   If ComputeDistance($lX, $lY, -4196, 19781) > 200 Then
	  Do
		 If MemoryRead($aMe + 44, 'long') <> $lMyID Then Return False
		 If Not GetIsMoving($aMe) Then
			MoveTo($lX, $lY, 300, $aMe)
			PingSleep(500)
			MoveTo(-4196, 19781, 50, $aMe)
		 EndIf
		 PingSleep(500)
		 UpdateAgentPosByPtr($aMe, $lX, $lY)
	  Until ComputeDistance($lX, $lY, -4196, 19781) <= 150
   EndIf
   PingSleep(250)
   Local $GrenthPtr = GetAgentPtr(83)
   While $GrenthPtr = 0
	  If Mod($GrenthSpawn, 20) = 0 Then Kneel()
	  Sleep(500)
	  $GrenthSpawn += 1
	  $GrenthPtr = GetAgentPtr(83)
   WEnd
   GoNPC($GrenthPtr)
   Sleep(125)
;~    Dialog(0x84) ; no
;~    Sleep(50) ; risk
;~    Dialog(0x85) ; no
;~    Sleep(50) ; fun
   Dialog(0x86)
   Update("Loading Underworld")
   Return WaitMapLoading(72)
EndFunc   ;==>GetInUnderworld
#EndRegion

#Region GoTo Merchants
;~ Description: Goes to NPC with playernumber and talks to that NPC.
Func GoToNPCbyPlayernumber($aPlayernumber, $aMe = GetAgentPtr(-2))
   $lAgentArray = GetAgentPtrArray(1)
   For $i = 1 To $lAgentArray[0]
	  If MemoryRead($lAgentArray[$i] + 244, 'word') = Int($aPlayernumber) Then
		 GoToNPC($lAgentArray[$i], $aMe)
		 Return Dialog(0x7F)
	  EndIf
   Next
EndFunc   ;==>GoToNPCbyPlayernumber

;~ Description: Returns Playernumber of merchant in $aMapID, if listed.
Func GetMerchantPlayernumber($aMapID)
   Switch $aMapID
	  Case 10, 12, 137, 138, 139, 141, 142, 19, 49, 73
		 Return 1897
	  Case 109, 116, 117, 118, 152, 153, 154, 38
		 Return 1904
	  Case 11, 136, 140, 16, 57
		 Return 1890
	  Case 120, 155, 156, 158, 159, 22, 24, 812
		 Return 1915
	  Case 131, 135, 29, 30, 40
		 Return 1870
	  Case 132, 134, 21, 25, 32, 36
		 Return 1876
	  Case 133, 14, 808
		 Return 1883
	  Case 28, 39, 81
		 Return 1866
	  Case Else
		 Return False
   EndSwitch
EndFunc   ;==>GetMerchantPlayernumber

;~ Description: Returns Playernumber of Dye Trader in $aMapID, if listed.
Func GetDyeTraderPlayernumber($aMapID)
   Switch $aMapID
	  Case 109, 49, 81, 857
		 Return 2010
	  Case 193
		 Return 3617
	  Case 194, 242
		 Return 3278
	  Case 250
		 Return 3277
	  Case 286
		 Return 3402
	  Case 381, 477
		 Return 5383
	  Case 403
		 Return 5663
	  Case 414
		 Return 5664
	  Case 640
		 Return 6756
	  Case 642
		 Return 6043
	  Case 644
		 Return 6382
	  Case 77
		 Return 3401
	  Case 812
		 Return 2107
	  Case 818
		 Return 4719
	  Case Else
		 Return False
   EndSwitch
EndFunc   ;==>GetDyeTraderPlayernumber

;~ Description: Returns Playernumber of Material Trader in $aMapID, if listed.
Func GetMaterialTraderPlayernumber($aMapID)
   Switch $aMapID
	  Case 109, 49, 81
		 Return 2011
	  Case 193
		 Return 3618
	  Case 194, 242, 857
		 Return 3279
	  Case 250
		 Return 3280
	  Case 376
		 Return 5385
	  Case 398
		 Return 5665
	  Case 414
		 Return 5668
	  Case 424
		 Return 5386
	  Case 433
		 Return 5666
	  Case 438
		 Return 5618
	  Case 491
		 Return 4720
	  Case 492
		 Return 4721
	  Case 638
		 Return 6757
	  Case 640
		 Return 6758
	  Case 641
		 Return 6059
	  Case 642
		 Return 6044
	  Case 643
		 Return 6383
	  Case 644
		 Return 6384
	  Case 652
		 Return 6227
	  Case 77
		 Return 3409
	  Case 808
		 Return 7446
	  Case 818
		 Return 4723
	  Case Else
		 Return False
   EndSwitch
EndFunc   ;==>GetMaterialTraderPlayernumber

;~ Description: Returns Playernumber of Rare Material Trader in $aMapID, if listed.
Func GetRareMaterialTraderPlayernumber($aMapID)
   Switch $aMapID
	  Case 109
		 Return 1997
	  Case 193
		 Return 3621
	  Case 194, 250, 857
		 Return 3282
	  Case 242
		 Return 3281
	  Case 376
		 Return 5388
	  Case 398, 433
		 Return 5667
	  Case 414
		 Return 5668
	  Case 424
		 Return 5387
	  Case 438
		 Return 5613
	  Case 49
		 Return 2038
	  Case 491, 818
		 Return 4723
	  Case 492
		 Return 4722
	  Case 638
		 Return 6760
	  Case 640
		 Return 6759
	  Case 641
		 Return 6060
	  Case 642
		 Return 6045
	  Case 643
		 Return 6386
	  Case 644
		 Return 6385
	  Case 652
		 Return 6228
	  Case 77
		 Return 3410
	  Case 81
		 Return 2083
	  Case Else
		 Return False
   EndSwitch
EndFunc   ;==>GetRareMaterialTraderPlayernumber

;~ Description: Returns Playernumber of Runes Trader in $aMapID, if listed.
Func GetRuneTraderPlayernumber($aMapID)
   Switch $aMapID
	  Case 109, 814
		 Return 1999
	  Case 193
		 Return 3624
	  Case 194, 242, 250
		 Return 3285
	  Case 248, 857
		 Return 1975
	  Case 396
		 Return 5672
	  Case 414
		 Return 5671
	  Case 438
		 Return 5620
	  Case 477
		 Return 5390
	  Case 487
		 Return 4726
	  Case 49
		 Return 2039
	  Case 502
		 Return 4727
	  Case 624
		 Return 6764
	  Case 640
		 Return 6763
	  Case 642
		 Return 6046
	  Case 643, 645
		 Return 6389
	  Case 644
		 Return 6390
	  Case 77
		 Return 3415
	  Case 808
		 Return 7450
	  Case 81
		 Return 2085
	  Case 818
		 Return 4705
	  Case Else
		 Return False
   EndSwitch
EndFunc   ;==>GetRuneTraderPlayernumber
#EndRegion