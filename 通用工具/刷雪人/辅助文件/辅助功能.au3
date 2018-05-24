Func GenericRandomPath($aPosX, $aPosY, $aRandom = 50, $STOPSMIN = 1, $STOPSMAX = 5, $NUMBEROFSTOPS = -1)
	If $NUMBEROFSTOPS = -1 Then $NUMBEROFSTOPS = Random($STOPSMIN, $STOPSMAX, 1)
	Local $lAgent = GetAgentByID(-2)
	Local $MYPOSX = DllStructGetData($lAgent, "X")
	Local $MYPOSY = DllStructGetData($lAgent, "Y")
	Local $DISTANCE = ComputeDistance($MYPOSX, $MYPOSY, $aPosX, $aPosY)
	If $NUMBEROFSTOPS = 0 Or $DISTANCE < 200 Then
		MoveTo($aPosX, $aPosY, $aRandom)
	Else
		Local $M = Random(0, 1)
		Local $N = $NUMBEROFSTOPS - $M
		Local $STEPX = (($M * $aPosX) + ($N * $MYPOSX)) / ($M + $N)
		Local $STEPY = (($M * $aPosY) + ($N * $MYPOSY)) / ($M + $N)
		MoveTo($STEPX, $STEPY, $aRandom)
		GENERICRANDOMPATH($aPosX, $aPosY, $aRandom, $STOPSMIN, $STOPSMAX, $NUMBEROFSTOPS - 1)
	EndIf
EndFunc   ;==>GENERICRANDOMPATH


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
		$Me = GetAgentByID(-2)
	Until ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y')) < 250
	RndSleep(1000)
EndFunc   ;==>GoNearestNPCToCoords

Func WaitForLoad()               ;used
	Out("正在载入")
	InitMapLoad()
	Local $deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100
		Local $load = GetMapLoading()
		Local $lMe = GetAgentByID(-2)

	Until $load == 2 And DllStructGetData($lMe, 'X') == 0 And DllStructGetData($lMe, 'Y') == 0 Or $deadlock > 10000

	$deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100
		$load = GetMapLoading()
		$lMe = GetAgentByID(-2)

	Until $load <> 2 And DllStructGetData($lMe, 'X') <> 0 And DllStructGetData($lMe, 'Y') <> 0 Or $deadlock > 30000
	Out("装载完毕")
EndFunc   ;==>WaitForLoad

; 没有再次刷新人员数据， 因为使用此功能时怪已不动
Func SelectEnemy()

	Local $lAgentArray = GetAgentArray(0xDB)
	Local $lMe = GetAgentByID(-2)

	Local $ClosestToMe = 5000
	Local $FarthestToMe = 0
	Local $MiddleToMe = 0
	Local $DistanceFromMid = 5000


	Local $tempDistance = 0
	Local $BestIndex = 0

	For $i=1 To $lAgentArray[0]
		$tempDistance = GetDistance($lMe, $lAgentArray[$i])
		If DllStructGetData($lAgentArray[$i], "Allegiance") <> 0x3 Then ContinueLoop
		If ($language=0) and (StringInStr(GetAgentName($lAgentArray[$i]),"Snowman") = 0) Then ContinueLoop
		if ($language=6) and (StringInStr(GetAgentName($lAgentArray[$i]),"雪人") = 0) Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], "HP") <= 0 Then ContinueLoop
		If $tempDistance > 2000 Then ContinueLoop
		If $tempDistance < $ClosestToMe Then
			$ClosestToMe = $tempDistance
		EndIf
		If $TempDistance > $FarthestToMe Then
			$FarthestToMe = $TempDistance
		EndIf
	Next

	$MiddleToMe = ($ClosestToMe + $FarthestToMe) / 2
	; 没有再次刷新人员数据， 因为使用此功能时怪已不动
	out("")
	out("选怪:")
	out("近怪: " & Round($ClosestToMe))
	out("远怪: " & Round($FarthestToMe))
	out("中点: " & Round($MiddleToMe))

	For $i=1 To $lAgentArray[0]
		$tempDistance = GetDistance($lMe, $lAgentArray[$i])
		If DllStructGetData($lAgentArray[$i], "Allegiance") <> 0x3 Then ContinueLoop
		If ($language=0) and (StringInStr(GetAgentName($lAgentArray[$i]),"Snowman") = 0) Then ContinueLoop
		if ($language=6) and (StringInStr(GetAgentName($lAgentArray[$i]),"雪人") = 0) Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], "HP") <= 0 Then ContinueLoop
		If $tempDistance > 2000 Then ContinueLoop
		If abs($tempDistance-$MiddleToMe)<$DistanceFromMid Then
			$DistanceFromMid = abs($tempDistance-$MiddleToMe)
			$BestIndex = $i
		EndIf
	Next

	out("目标与中点距: " & Round($DistanceFromMid))
	out("")

	Return DllStructGetData($lAgentArray[$BestIndex], "ID")

EndFunc

; Uses a skill
; It will not use if I am dead, if the skill is not recharged, or if I don't have enough energy for it
; It will sleep until the skill is cast, then it will wait for aftercast.
Func UseSkillEx($lSkill, $lTgt=-2, $aTimeout = 3000)
	If GetIsDead(-2) Then Return
	If Not IsRecharged($lSkill) Then Return
	If GetEnergy(-2) < $skillCost[$lSkill] Then Return

	Local $lDeadlock = TimerInit()
	UseSkill($lSkill, $lTgt)
	Do
		Sleep(100)
		If GetIsDead(-2) = 1 Then Return
	Until (Not IsRecharged($lSkill)) Or (TimerDiff($lDeadlock) > $aTimeout)

	If $lSkill > 1 Then RndSleep(750)
EndFunc

; Checks if skill given (by number in bar) is recharged. Returns True if recharged, otherwise False.
Func IsRecharged($lSkill)
	Return GetSkillBarSkillRecharge($lSkill)==0
EndFunc

Func GetItemMaxDmg($aItem)
	If Not IsDllStruct($aItem) Then $aItem = GetItemByItemID($aItem)
	Local $lModString = GetModStruct($aItem)
	Local $lPos = 0

	$lPos = StringInStr($lModString, "A8A7") ; Weapon Damage
	;If $lPos = 0 Then $lPos = StringInStr($lModString, "C867") ; Energy (focus)
	;If $lPos = 0 Then $lPos = StringInStr($lModString, "B8A7") ; Armor (shield)
	If $lPos = 0 Then Return 0

	Return Int("0x" & StringMid($lModString, $lPos - 2, 2))

EndFunc



Func DISCONNECTED()
	OUT("断线")
	OUT("试着重接.")
	ControlSend(GetWindowHandle(), "", "", "{Enter}")
	Local $LCHECK = False
	Local $lDeadlock = TimerInit()
	Do
		Sleep(200)
		$LCHECK = GetMapLoading() <> 2 And GetAgentExists(-2)
	Until $LCHECK Or TimerDiff($lDeadlock) > 60000
	If $LCHECK = False Then
		OUT("重接失败")
		OUT("继续重接")
		ControlSend(GetWindowHandle(), "", "", "{Enter}")
		$lDeadlock = TimerInit()
		Do
			Sleep(200)
			$LCHECK = GetMapLoading() <> 2 And GetAgentExists(-2)
		Until $LCHECK Or TimerDiff($lDeadlock) > 60000
		If $LCHECK = False Then
			OUT("无法重接")
			OUT("退出")
			Exit 1
		EndIf
	EndIf
	OUT("重接成功!")
	Sleep(8000)
EndFunc   ;==>DISCONNECTED


Global $DifficultyNormal = True
Func ToggleDifficulty()
	$DifficultyNormal = NOT $DifficultyNormal
EndFunc

;~ Description: Toggle rendering and also hide or show the gw window
Func ToggleRendering()
	$RenderingEnabled = Not $RenderingEnabled
	If $RenderingEnabled Then
		EnableRendering()
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
	Else
		DisableRendering()
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
		ClearMemory()
	EndIf
EndFunc   ;==>ToggleRendering

;~ Description: Print to console with timestamp
Func Out($TEXT)
	;If $BOTRUNNING Then FileWriteLine($FLOG, @CRLF & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " & $TEXT)
	Local $TEXTLEN = StringLen($TEXT)
	Local $CONSOLELEN = _GUICtrlEdit_GetTextLen($GLOGBOX)
	If $TEXTLEN + $CONSOLELEN > 30000 Then GUICtrlSetData($GLOGBOX, StringRight(_GUICtrlEdit_GetText($GLOGBOX), 30000 - $TEXTLEN - 1000))
	_GUICtrlEdit_AppendText($GLOGBOX, @CRLF & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " & $TEXT)
	_GUICtrlEdit_Scroll($GLOGBOX, 1)
EndFunc   ;==>OUT

; This searches for empty slots in your storage
Func FindEmptySlot($BAGINDEX)
	Local $LITEMINFO, $ASLOT
	For $ASLOT = 1 To DllStructGetData(GETBAG($BAGINDEX), "Slots")
		Sleep(40)
		$LITEMINFO = GETITEMBYSLOT($BAGINDEX, $ASLOT)
		If DllStructGetData($LITEMINFO, "ID") = 0 Then
			SetExtended($ASLOT)
			ExitLoop
		EndIf
	Next
	Return 0
EndFunc

Func CHECKGOLD()
	Local $GCHARACTER = GetGoldCharacter()
	Local $GSTORAGE = GetGoldStorage()
	Local $GDIFFERENCE = ($GSTORAGE - $GCHARACTER)
	If $GCHARACTER <= 1000 Then
		Switch $GSTORAGE
			Case 100000 To 1000000
				WithdrawGold(100000 - $GCHARACTER)
				Sleep(500 + 3 * GetPing())
			Case 1 To 99999
				WithdrawGold($GDIFFERENCE)
				Sleep(500 + 3 * GetPing())
			Case 0
				OUT("没钱，开始刷怪")
				Return False
		EndSwitch
	EndIf
	Return True
EndFunc   ;==>CHECKGOLD