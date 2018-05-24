Func AssassinRun()
	Local $enemyID, $enemy
	GoOutside()
	RndSleep(2000)
	upd("前往龙苔处")
	UseSkillEx(5, -2)
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
	UseSkillEx(3, -2)
	RndSleep(1025);;


	UseSkillEx(4, -2)
	upd("引龙苔")
	MoveToEx(-5234, 15574)
	upd("围龙苔")
	MoveToEx(-6131, 17952)

	UseSkillEx(4, -2)
	TolSleep(450)

	MoveToEx(-6483, 18291)
	upd("准备")
	Update(2000)
	UseSkillEx(5, -2)
	UseSkillEx(4, -2)

	Do
		Sleep(50)
	Until DllStructGetData(GetSkillbar(), 'Recharge2') == 0

	UseSkillEx(2, -2)
	UseSkillEx(6, -2)
	;RndSleep(2025);;
	;RndSleep(1550)
	;RndSleep(225);;
	;UseSkillEx(5, -2)



	;Do
	;	Sleep(50)
	;Until DllStructGetData(GetSkillbar(), 'Recharge4') == 0
	UseSkillEx(4, -2)

	upd("杀")
	$enemyID = GetBestAoETarget(365)
	UseSkillEx(7, $enemyID)
	Do
		Sleep(500)
	Until GetEnergy() >= 10
	RndSleep(300)
	UseSkillEx(8, -2)
	Do
		UseSkillEx(2, -2);;
		Sleep(500)
	Until GetNumberOfFoesInRangeOfAgent(-2, 200) < 3 Or GetIsDead(-2)
	UseSkillEx(2, -2);;
	UseSkillEx(4, -2);;
	PickUpLoot()
	RndSleep(2500)
	RndTravel(349)
EndFunc   ;==>AssassinRun