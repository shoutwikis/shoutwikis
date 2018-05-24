Func StayAlive()

	Local $lMe = GetAgentByID(-2)
	Local $lEnergy = GetEnergy($lMe)

	If IsRecharged($SF) Then
		UseSkillEx($SF)
	EndIf

	If IsRecharged($SD) Then
		If DllStructGetData(GetEffect($SKILL_ID_SD), "SkillID") == 0 Then
			UseSkillEx($SD)
		EndIf
	EndIf

	If IsRecharged($SQ) and IsRecharged($SF) Then
		If DllStructGetData(GetEffect($SKILL_ID_SQ), "SkillID") == 0 Then
			UseSkillEx($SQ)
		EndIf
	EndIf

	If IsRecharged($DS) Then
		If DllStructGetData(GetEffect($SKILL_ID_DS), "SkillID") == 0 Then
			UseSkillEx($DS)
		EndIf
	EndIf

EndFunc

;~ Description: Move to destX, destY, while staying alive vs vaettirs
Func MoveAggroing($lDestX, $lDestY, $lRandom = 150)

	TargetNearestEnemy()

	If GetIsDead(-2) Then Return

	Local $lMe, $lAgentArray
	Local $lBlocked
	Local $lHosCount
	Local $lAngle
	Local $stuckTimer = TimerInit()

	Move($lDestX, $lDestY, $lRandom)

	Do
		RndSleep(50)

		$lMe = GetAgentByID(-2)

		$lAgentArray = GetAgentArray(0xDB)

		If GetIsDead($lMe) Then Return False

		; 平时不应进入以下范围
		If Round(TimerDiff($SnowmanTimer)/1000) > 180 Then
			UseSkillEx($HOS, -1)
			RndSleep(1250)
			UseSkillEx($HOS, -2)
			Out("XXXXXXX")
			Out("滞留， 或因卡等不明原因， 试跳")
			Out("滞留， 或因卡等不明原因， 试跳")
			Out("滞留， 或因卡等不明原因， 试跳")
			Out("XXXXXXX")
		EndIf

		StayAlive()

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			If $lHosCount > 10 Then
				Do	; suicide
					Sleep(100)
				Until GetIsDead(-2)
				Return False
			EndIf

			$lBlocked += 1
			If $lBlocked < 5 Then
				Move($lDestX, $lDestY, $lRandom)
			ElseIf IsRecharged($HOS) Then
				If $lHosCount==0 And GetDistance() < 1000 Then
					TargetNextEnemy()
					UseSkillEx($HOS, -1)
				Else
					UseSkillEx($HOS, -2)
				EndIf
				$lBlocked = 0
				$lHosCount += 1
			ElseIf $lBlocked < 10 Then ; 绕道顺序更改， 这段原在hos上
				$lAngle += 40
				Move(DllStructGetData($lMe, 'X')+300*sin($lAngle), DllStructGetData($lMe, 'Y')+300*cos($lAngle))
			EndIf
		Else
			If $lBlocked > 0 Then
				If TimerDiff($ChatStuckTimer) > 3000 Then	; use a timer to avoid spamming /stuck
					SendChat("stuck", "/")
					$ChatStuckTimer = TimerInit()
				EndIf
				$lBlocked = 0
				$lHosCount = 0
			EndIf

			If GetDistance() > 1100 Then ; target is far, we probably got stuck.
				If TimerDiff($ChatStuckTimer) > 3000 Then ; dont spam
					SendChat("stuck", "/")
					$ChatStuckTimer = TimerInit()
					RndSleep(GetPing())
					If GetDistance() > 1100 Then ; we werent stuck, but target broke aggro. select a new one.
						TargetNearestEnemy()
					EndIf
				EndIf
			EndIf
		EndIf

	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < $lRandom*1.5
	Return True
EndFunc

;~ Description: Wait and stay alive at the same time (like Sleep(..), but without the letting yourself die part)
Func WaitFor($lMs)
	If GetIsDead(-2) Then Return
	Local $lTimer = TimerInit()
	Do
		Sleep(75)
		If GetIsDead(-2) Then Return
		StayAlive()
	Until TimerDiff($lTimer) > $lMs
EndFunc