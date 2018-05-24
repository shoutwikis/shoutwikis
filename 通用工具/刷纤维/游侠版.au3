
Func RangerRun()
	Local $SFTimer, $enemyID, $enemy
	GoOutside()
	RndSleep(3000)
	upd("前往龙苔处")
	UseSkillEx(6, -2)
	UseSkillEx(4, -2)
	MoveToEx(-8498, 18548)
	MoveToEx(-6858, 17713)
	Do
		Move(-5348, 16085)
		Sleep(100)
	Until GetNumberOfFoesInRangeOfAgent(-2, 1300) > 0
	upd("上加持")
	UseSkillEx(1, -2)
	UseSkillEx(2, -2)
	$SFTimer = TimerInit()
	UseSkillEx(3, -2)
	upd("引龙苔")
	UseSkillEx(5, -2)
	MoveToEx(-5234, 15574)
	upd("围龙苔")
	MoveToEx(-6131, 17952)
	TolSleep(450)
	MoveToEx(-6570, 18493)
	TolSleep(500)
	Update(2000)
	upd("杀")
	UseSkillEx(6, -2)
	UseSkillEx(4, -2)
	$enemyID = GetBestAoETarget(365)
	UseSkillEx(7, $enemyID)
	;Do
	;	Sleep(500)
	;Until GetDistance(-2, $enemyID) < 500 Or GetIsDead(-2)
	UseSkillEx(8, -2)
	Do
		Sleep(500)
		If TimerDiff($SFTimer) > 18000 Then
			UseSkillEx(2, -2)
			$SFTimer = 0
		EndIf
	Until GetNumberOfFoesInRangeOfAgent(-2, 200) < 3 Or GetIsDead(-2)
	Sleep(Random(250, 1500) + GetPing())
	PickUpLoot()
	RndSleep(2500)
	RndTravel(349)
EndFunc   ;==>RangerRun