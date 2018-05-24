#include-once

Global $ClostestX[1]
Global $ClostestY[1]
Global $SpiritAverageXLocation = 0
Global $SpiritAverageYLocation = 0
Global $EnemyAverageXLocation = 0

;~ Description: Gregs circle trig. Returns Array for X,Y location of closest safe point.
Func GetClosestSafeZone($aX, $aY, $radius = 300, $aMe = GetAgentPtr(-2))
   Local $d2r = 3.141592653589 / 180
   Local $coords[2]
   Local $MyLocation = XandYLocation($aMe)
   Local $theta = 0, $TempX, $TempY, $ClostestLocation = 5000
   For $i = 0 To 17
	  $theta += 20
	  $TempX = ($radius * Cos($theta * $d2r)) + $aX
	  $TempY = ($radius * Sin($theta * $d2r)) + $aY
	  If ComputeDistance($TempX, $TempY, $MyLocation[0], $MyLocation[1]) < $ClostestLocation Then
		 $ClostestLocation = ComputeDistance($TempX, $TempY, $MyLocation[0], $MyLocation[1])
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
	  $TempX = (($radius - UBound($mEnemyCorpesSpellRange) * 50) * Cos($theta * $d2r)) + $aX
	  $TempY = (($radius - UBound($mEnemyCorpesSpellRange) * 50) * Sin($theta * $d2r)) + $aY
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

;~ Description: Calculates a safe spot and moves to it.
Func MoveToSafeSpot($radius = 100)
   If $EnemyAverageXLocation = 0 Or $SpiritAverageXLocation = 0 Then Return
   Local $d2r = 3.141592653589 / 180
   Local $coords[2], $TestDistance
   Local $theta = 0, $TempX, $TempY, $SafeDistance = 0
   Local $SafeX, $SafeY
   For $i = 0 To 99
	  $theta += 3.6
	  $TempX = ($radius * Cos($theta * $d2r)) + $SpiritAverageXLocation
	  $TempY = ($radius * Sin($theta * $d2r)) + $SpiritAverageYLocation
	  $TestDistance = ComputeDistance($TempX, $TempY, $EnemyAverageXLocation, $EnemyAverageYLocation)
	  If $TestDistance > $SafeDistance Then
		 $SafeDistance = $TestDistance
		 $SafeX = $TempX
		 $SafeY = $TempY
	  EndIf
   Next
   Move($SafeX, $SafeY)
EndFunc   ;==>MoveToSafeSpot