Func Inventory()
#cs
	If GetMapID() <> $MAP_ID_RATA Then
		Out("前往顶点")
		$MapRepeat = 0
		RndSleep(5500)
		RndTravel($MAP_ID_RATA)
		$reZone = 1
	EndIf
#ce

;~ Opening the Merchant
	Out("前往商人处")
	MERCHANT()

	Out("正在鉴定")
;~ Identifies each bag
	Ident(1)
	Ident(2)
	Ident(3)
	Ident(4)

	;~ Opening the Chest
	Out("走向储存箱.")
	RndSleep(1000)
	MoveTo(-22636,10340,250)
	RndSleep(1000)
	CHEST()

	If GetGoldCharacter() > 90000 Then
		Out("存款于箱")
		DepositGold()
	EndIf

;~ Storing things I want to keep
	Out("正在储存其他物品于箱")
	StoreItems()
	StoreMaterials()
;	StoreReqs()
	StoreMods()
;	StoreUNIDGolds()
	StoreDaggersAndShields() ;存匕首和盾

	Out("再往商人处")
	MERCHANT()
	Out("正在卖")
;~ Sells each bag

	;DO NOT SELL DAGGERS OR SHIELDS HERE
	Sell(1)
	Sell(2)
	Sell(3)
	Sell(4)

	If GetGoldCharacter() > 90000 Then
		;空
	EndIf
#cs
	If (CountSlots() < 5) Then
		$BotRunning = False
		out("包内空间少于五格， 暂停")
	EndIf
#ce
EndFunc

Func CHECKAREA($AX, $AY)
	Local $RET = False
	Local $PX = DllStructGetData(GetAgentByID(-2), "X")
	Local $PY = DllStructGetData(GetAgentByID(-2), "Y")
	If ($PX < $AX + 500) And ($PX > $AX - 500) And ($PY < $AY + 500) And ($PY > $AY - 500) Then
		$RET = True
	EndIf
	Return $RET
EndFunc   ;==>CHECKAREA
#cs
Func CHEST()

	Do
		GENERICRANDOMPATH(19184, 14105);Random(60, 80, 2)
	Until CHECKAREA(19184, 14105)

	Local $aChestName = "Xunlai Chest"
	Local $lChest = GetAgentByName($aChestName)

	If IsDllStruct($lChest)Then
		OUT("前往 " & $aChestName)
		GoToNPC($lChest)
		RndSleep(Random(3000, 4200))
	EndIf

EndFunc   ;~ Xunlai Chest

Func MERCHANT()

	Do
		GENERICRANDOMPATH(19575, 14751);Random(60, 80, 2)
	Until CHECKAREA(19575, 14751)

	Local $aMerchName = "Gni Neproc"
	Local $lMerch = GetAgentByName($aMerchName)
	If IsDllStruct($lMerch)Then
		OUT("前往 " & $aMerchName)
		GoToNPC($lMerch)
		RndSleep(Random(3000, 4200))
	EndIf

EndFunc   ;~ Merchant
#ce
;-------------------------------------------------------------------------------------------------------

Func PLACE_FOR_INVENTORY()
	Dim $GH_CHECK[16][5] = [ _
			[$DRUIDISLE, $Druid_GH_ID, "前往公会厅： 德鲁伊之岛", "已在公会厅： 德鲁伊之岛", "德鲁伊之岛"], _
			[$ISLEOFDEAD, $IsleOFDead_GH_ID, "前往公会厅： 死亡之岛", "已在公会厅： 死亡之岛", "死亡之岛"], _
			[$ISLEOFMEDITATION, $Meditation_GH_ID, "前往公会厅： 冥想之岛", "已在公会厅： 冥想之岛", "冥想之岛"], _
			[$ISLEOFSOLITUDE, $Solitude_GH_ID, "前往公会厅： 神隐之岛", "已在公会厅： 神隐之岛", "神隐之岛"], _
			[$UNCHARTEDISLE, $Ucharted_GH_ID, "前往公会厅： 迷样之岛", "已在公会厅： 迷样之岛", "迷样之岛"], _
			[$HUNTERISLE, $Hunter_GH_ID, "前往公会厅： 猎人之岛", "已在公会厅： 猎人之岛", "猎人之岛"], _
			[$IMPERIALISLE, $Imperial_GH_ID, "前往公会厅： 帝国之岛", "已在公会厅： 帝国之岛", "帝国之岛"], _
			[$ISLEOFWURMS, $IsleOfWurm_GH_ID, "前往公会厅： 巨虫之岛", "已在公会厅： 巨虫之岛", "巨虫之岛"], _
			[$WIZARDISLE, $WizardsIsle_GH_ID, "前往公会厅： 巫师之岛", "已在公会厅： 巫师之岛", "巫师之岛"], _
			[$BURNINGISLE, $BurningIsle_GH_ID, "前往公会厅： 燃烧之岛", "已在公会厅： 燃烧之岛", "燃烧之岛"], _
			[$WARRIORISLE, $WarriorsIsle_GH_ID, "前往公会厅： 战士之岛", "已在公会厅： 战士之岛", "战士之岛"], _
			[$ISLEOFWEEPING, $IsleOfWeepingStone_GH_ID, "前往公会厅： 泣石之岛", "已在公会厅： 泣石之岛", "泣石之岛"], _
			[$FROZENISLE, $FrozenIsle_GH_ID, "前往公会厅： 冰冻之岛", "已在公会厅： 冰冻之岛", "冰冻之岛"], _
			[$NOMADISLE, $NomadIsle_GH_ID, "前往公会厅： 流浪之岛", "已在公会厅： 流浪之岛", "流浪之岛"], _
			[$CORRUPTEDISLE, $Corrupted_GH_ID, "前往公会厅： 坠落之岛", " 已在公会厅： 坠落之岛", "坠落之岛"], _
			[$ISLEOFJADE, $IsleOfJade_GH_ID, "前往公会厅： 翡翠之岛", "已在公会厅： 翡翠之岛", "翡翠之岛"]]

	For $i = 0 To (UBound($GH_CHECK) - 1)
		If ($GH_CHECK[$i][0] == True) Then
			OUT($GH_CHECK[$i][2])
			If (GetMapID() <> $GH_CHECK[$i][1]) Then
				TravelGH()
				WaitMapLoading($GH_CHECK[$i][1], 10000)
				Inventory()
				Return True
			Else
				OUT($GH_CHECK[$i][3])
				Inventory()
				Return True
			EndIf
		EndIf
	Next
	Return False
EndFunc   ;==>PLACE_FOR_INVENTORY


Func CHEST()
	Dim $Waypoints_by_XunlaiChest[16][3] = [ _
			[$BURNINGISLE, -5469, -2593], _
			[$DRUIDISLE, -1826, 5567], _
			[$FROZENISLE, -282, 3769], _
			[$HUNTERISLE, 4747, 7376], _
			[$ISLEOFDEAD, -4688, -1446], _
			[$NOMADISLE, 4630, 4724], _
			[$WARRIORISLE, 4229, 6798], _
			[$WIZARDISLE, 4865, 9834], _
			[$IMPERIALISLE, 2403, 13211], _
			[$ISLEOFJADE, 8737, 2647], _
			[$ISLEOFMEDITATION, -817, 7773], _
			[$ISLEOFWEEPING, -1713, 7169], _
			[$CORRUPTEDISLE, -5031, 6113], _
			[$ISLEOFSOLITUDE, 4610, 3059], _
			[$ISLEOFWURMS, 8735, 3747], _
			[$UNCHARTEDISLE, 4508, -4597]]
	For $i = 0 To (UBound($Waypoints_by_XunlaiChest) - 1)
		If ($Waypoints_by_XunlaiChest[$i][0] == True) Then
			Do
				GENERICRANDOMPATH($Waypoints_by_XunlaiChest[$i][1], $Waypoints_by_XunlaiChest[$i][2], Random(60, 80, 2))
			Until CHECKAREA($Waypoints_by_XunlaiChest[$i][1], $Waypoints_by_XunlaiChest[$i][2])
			Local $aChestName = "Xunlai Chest"
			Local $lChest = GetAgentByName($aChestName)
			If IsDllStruct($lChest)Then
				OUT("前往 " & $aChestName)
				GoToNPC($lChest)
				RndSleep(Random(3000, 4200))
			EndIf
		EndIf
	Next
EndFunc   ;~ Xunlai Chest

Func MERCHANT()
	Dim $Waypoints_by_Merchant[16][3] = [ _
			[$BURNINGISLE, -2515, 1109], _
			[$DRUIDISLE, -2037, 2964], _
			[$FROZENISLE, -299, 79], _
			[$HUNTERISLE, 4253, 6392], _
			[$ISLEOFDEAD, -4061, -1059], _
			[$NOMADISLE, 5129, 4748], _
			[$WARRIORISLE, 5608, 9137], _
			[$WIZARDISLE, 3468, 8993], _
			[$IMPERIALISLE, 1891, 11729], _
			[$ISLEOFJADE, 10275, 3114], _
			[$ISLEOFMEDITATION, -2112, 8014], _
			[$ISLEOFWEEPING, -3892, 6709], _
			[$CORRUPTEDISLE, -4764, 5521], _
			[$ISLEOFSOLITUDE, 2970, 1532], _
			[$ISLEOFWURMS, 8133, 3583], _
			[$UNCHARTEDISLE, 1503, -2830]]
	For $i = 0 To (UBound($Waypoints_by_Merchant) - 1)
		If ($Waypoints_by_Merchant[$i][0] == True) Then
			Do
				GENERICRANDOMPATH($Waypoints_by_Merchant[$i][1], $Waypoints_by_Merchant[$i][2], Random(60, 80, 2))
			Until CHECKAREA($Waypoints_by_Merchant[$i][1], $Waypoints_by_Merchant[$i][2])
			Local $aMerchName = "Merchant"
			Local $lMerch = GetAgentByName($aMerchName)
			If IsDllStruct($lMerch)Then
				OUT("前往 " & $aMerchName)
				GoToNPC($lMerch)
				RndSleep(Random(3000, 4200))
			EndIf
		EndIf
	Next
EndFunc   ;~ Merchant