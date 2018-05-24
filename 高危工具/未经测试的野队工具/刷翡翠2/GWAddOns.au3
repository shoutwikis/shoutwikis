#include-once
#RequireAdmin
#include "GWBible.au3"

Func Follow()
	Local $i = 1
	Local $j = 1

	While 1
		If GetMapLoading() == $INSTANCETYPE_EXPLORABLE Then
;~ 			ChangeLoot()
			ResignAfterSpawn()

			While 1 ;;;;;;;;;; FOLLOWER LOOP
				If $i = 3000 Then Main() ; Infinite Loop Check
				$i += 1
				Sleep(Abs(1500 - ($NumberOfFoesInSpellRange*200)))
				If Not UpdateWorld() Then Death()
				If Not SmartCast() Then Death()
				If Not MoveIfHurt() Then Death()
				If Not AttackRange() Then Death()
				If Not PickUpLoot() Then Death()
				If Not GrabAllBounties() Then Death()
				If Not FollowLeader() Then Death()
				If Not $boolRun Then ExitLoop
				If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then ExitLoop
			WEnd
		EndIf

		OutpostCheck()

		If $j = 3000 Then ExitLoop ; Infinite Loop Check
	WEnd

	Main()

EndFunc   ;==>Follow

Func FollowLeader()
	If GetIsDead() Then Return False
	$LeaderLocation = XandYLocation($SavedLeaderID) ; returns array
	$MyLocation = XandYLocation() ; returns array
	$DistanceToLeader = ComputeDistance($LeaderLocation[0], $LeaderLocation[1], $MyLocation[0], $MyLocation[1])
	If $DistanceToLeader <= 250 Then Return True
	If $DistanceToLeader > 1200 Then
		If MoveToLeader() == False Then Return False
		$LeaderLocation = XandYLocation($SavedLeaderID) ; returns array
		$MyLocation = XandYLocation() ; returns array
		$DistanceToLeader = ComputeDistance($LeaderLocation[0], $LeaderLocation[1], $MyLocation[0], $MyLocation[1])
	EndIf
	If $DistanceToLeader > 250 Then
		If $LeaderLocation[0] <> 0 And $LeaderLocation[1] <> 0 Then
			If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return True
			If $NumberOfFoesInAttackRange <= 0 Then
				$theta = $MyPlayerNumber * 51.42857
				Move(50 * Cos($theta * 0.01745) + $LeaderLocation[0], 50 * Sin($theta * 0.01745) + $LeaderLocation[1], 0)
			EndIf
		EndIf
	EndIf
EndFunc

Func ResignAfterSpawn()
	Local $k = 0
	If $Resigned == False Then
		$Resigned = True
		Update("Loading Explorable")
		Do
			RndSleep(1000)
			If $k = 3000 Then Main() ; Infinite Loop Check
		Until GetPartyLeader() == True
		Sleep(2000)
		Update("Resigning", 5)
		Resign()
		Local $Me = GetAgentByID(-2)
		$MyPlayerNumber = DllStructGetData($Me, 'PlayerNumber')
	EndIf
EndFunc

Func OutpostCheck()
	If GetMapLoading() == $INSTANCETYPE_OUTPOST Then
		$CurrentMap = 0
		If GetMapID() > 0 Then $CurrentMap = GetMapID()
		$CurrentMapState = 0
		$GetSkillBar = False
		If $CurrentMap > 0 Then
			$MyMaxHP = GetHealth()
			Update("Hanging in "  & $MAP_ID[$CurrentMap] & " with " & $MyMaxHP & " HP.", 7)
			$mSkillbar = GetSkillbar()
			Sleep(200)
			CacheSkillbar()
		EndIf
		ClearMemory()
	EndIf
EndFunc

Func AttackRange($Distance = 1350) ; Cast Range
	If GetIsDead() Then Return False
	If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return True
	If $mLowestEnemy <> 0 Then
		Update("Attack " & GetAgentID($mLowestEnemy))
		Attack($mLowestEnemy)
	Else
		$VIP = GetVIP($Distance)
		$VIPsTarget = GetTarget($VIP)
		If $VIPsTarget > 0 Then
			Update("Attack " & GetAgentID($VIPsTarget))
			Attack($VIPsTarget)
		EndIf
	EndIf
EndFunc   ;==>AttackRange

Func TurnInterruptsOn()
	If $NumberOfFoesInAttackRange > 0 Then SetEvent("CheckRupt", "", "", "", "") ; Interrupt skill starting now
EndFunc

Func TurnInterruptsOff()
	SetEvent("", "", "", "", "")
EndFunc

;~ Checks if I'm Dead
Func Death()
	If GetIsDead() Then
		Local $i = 1
		Do
			$i += 1
			Update("Rez Me!")
			RndSleep(1000)
			If $i = 3000 Then Follow() ; Infinite Loop Check
		Until Not GetIsDead() Or GetMapLoading() <> $INSTANCETYPE_EXPLORABLE
		If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then ; If not in explorable
			Update("Map loading after death")
			WaitForLoad()
			Follow()
		Else
			Update("I'm alive!")
			Follow() ; If is in explorable.
		EndIf
	EndIf
EndFunc   ;==>Death

Func GetPartyLeader()
	Local $lReturnArray[1] = [0]
	Local $LeaderSet = False
	Local $lAgentArray = GetAgentArray(0xDB)
	For $i = 1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], 'Allegiance') == 1 Then
			If BitAND(DllStructGetData($lAgentArray[$i], 'TypeMap'), 131072) Then
;~ 				If DllStructGetData($lAgentArray[$i], 'Primary') == $Paragon Then ;
				If DllStructGetData($lAgentArray[$i], 'PlayerNumber') == 1 Then
					$SavedLeader = $lAgentArray[$i]
					$SavedLeaderID = DllStructGetData($lAgentArray[$i], 'ID')
					$LeaderSet = True
					ExitLoop
				EndIf
			EndIf
		EndIf
	Next

	If $LeaderSet == True Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>GetPartyLeader

Func Update($text,$flag = 0)
	If $OldGuiText == $text Then Return
	$MyName = GetCharname()
;~ 	TraySetToolTip($MyName & @CRLF & $text)
	$OldGuiText = $text
	WriteChat($text, "JQ Bot Base")
	;Write new line at begining of file
;~     _FileWriteLog(@ScriptDir & "\" & $MyName & ".log",$text,0)
;~     Sleep(300)
;~     If FileGetSize(@ScriptDir & "\" & $MyName & ".log") > 2048 Then
;~         $hFile = _WinAPI_CreateFile(@ScriptDir & "\" & $MyName & ".log", 2, 6,6)
;~         _WinAPI_SetFilePointer($hFile, 2048)  ; make the value a bit smaller than the max size if writing to log very frequently
;~         _WinAPI_SetEndOfFile($hFile)
;~         _WinAPI_CloseHandle($hFile)
;~     EndIf

	$RestTimer = TimerInit()
EndFunc   ;==>Update

Func LogWeapon($text,$flag = 0)
	$MyName = GetCharname()
	WriteChat($text, "Follower")
	;Write new line at begining of file
    _FileWriteLog(@ScriptDir & "\" & $MyName & ".log",$text,0)
    Sleep(1000)
    If FileGetSize(@ScriptDir & "\" & $MyName & ".log") > 2048 Then
        $hFile = _WinAPI_CreateFile(@ScriptDir & "\" & $MyName & ".log", 2, 6,6)
        _WinAPI_SetFilePointer($hFile, 4096)  ; make the value a bit smaller than the max size if writing to log very frequently
        _WinAPI_SetEndOfFile($hFile)
        _WinAPI_CloseHandle($hFile)
    EndIf

	$RestTimer = TimerInit()
EndFunc   ;==>Update

;~ Func EventHandler()
;~ 	Switch (@GUI_CtrlId)
;~ 	    Case $btnStart
;~ 			$boolRun = Not $boolRun
;~ 			If $boolRun Then
;~ 				If GUICtrlRead($txtName) <> $strName Then
;~ 				   Update("Wrong Player")
;~ 				   Sleep(5000)
;~ 				   Exit
;~ 			   Else
;~ 				   If GUICtrlRead($txtName) = "" Then

;~ 					If Initialize(ProcessExists("gw.exe")) = False Then
;~ 						MsgBox(0, "Error", "Guild Wars it not running.")
;~ 						Exit
;~ 					EndIf
;~ 					_InjectDll(ProcessExists("gw.exe"),"Graphics.dll")
;~ 				Else
;~ 					If Initialize(GUICtrlRead($txtName), True, True) = False Then
;~ 						MsgBox(0, "Error", "Can't find a Guild Wars client with that character name.")
;~ 						Exit
;~ 					EndIf
;~ 				 EndIf
;~ 				 EnsureEnglish(1)
;~ 				GUICtrlSetData($btnStart, "Pause")
;~ 				GUICtrlSetState($txtName, $GUI_DISABLE)
;~ 			Else
;~ 				GUICtrlSetData($btnStart, "Start Up Again")
;~ 			EndIf
;~ 		Case $GUIExit
;~ 			If Not $RENDERING Then TOGGLERENDERING()
;~ 			Exit
;~ 	EndSWitch
;~ EndFunc   ;==>EventHandler

Func GetBountyFromCoords($aX, $aY, $BountyCode)
	If ComputeDistance(XLocation(), YLocation(), $aX, $aY) < 1400 Then
		Local $BountyMan = GetNearestNPCToCoords($aX, $aY)
		Update("Getting bounty from " & GetAgentName($BountyMan) & ".")
		GrabBounty($aX, $aY, $BountyCode)
		$GotBounty = True
	EndIf
EndFunc

;~ Searches for all possible bounties.
Func GrabAllBounties()
   If $GotBounty == True Then Return True
   If GetIsDead() Then Return False

   $CurrentMapID = GetMapID()

	Switch $CurrentMapID
		Case 553
			GetBountyFromCoords(-1822, -4488, "132")
		Case 501
			GetBountyFromCoords(-24272, -5719, "132")
		Case 647
			GetBountyFromCoords(-14971, 11013, "132")
		Case 560
			GetBountyFromCoords(-18314, -8890, "132")
		Case 567
			GetBountyFromCoords(5170, 12100, "132")
		Case 568
			GetBountyFromCoords(17147, 1057, "132")
		Case 701
			GetBountyFromCoords(-14078, 15449, "132")
		Case 200
			GetBountyFromCoords(-8394, -9801, "0x84|0x85|0x86")
		Case 199
			GetBountyFromCoords(19030, 10970, "0x84|0x85|0x86")
		Case 195
			GetBountyFromCoords(-5522, -16246, "0x84|0x85|0x86")
		Case 205
			GetBountyFromCoords(22146, 12161, "0x84|0x85|0x86")
		Case 380
			GetBountyFromCoords(16301, -16198, "0x84|0x85")
		Case Else
	EndSwitch

EndFunc   ;==>GrabAllBounties

;~ Uses EL Tonic in first slot of 4th bag
Func UseEverlastingTonic()
	 Update("Using Everlasting Hero")
	 UseItem(GetItemBySlot(4, 1))
	 RndSleep(200)
 EndFunc   ;==>UseEverlastingKuunavang

 ;~ Uses rez skill if has rez
Func RezParty($RezSkill) ;  Don't Continue on while anyone has low health, Returns TRUE if all have good HP
	Local $Me = GetAgentByID(-2)
	Local $lBlocked = 0
	Local $i = 1

	Do
		Move(XLocation($mTeamDead[1]), YLocation($mTeamDead[1]), 0)
		$Me = GetAgentByID(-2)
		RndSleep(500)
		If GetIsMoving($Me) == False Then
			$lBlocked += 1
			Move(XLocation($mTeamDead[1]), YLocation($mTeamDead[1]), 0)
			Sleep(200)
			If Mod($lBlocked, 5) = 0 And GetIsMoving($Me) == False Then
				$theta = Random(0, 360)
				Move(200 * Cos($theta * 0.01745) + XLocation(), 200 * Sin($theta * 0.01745) + YLocation(), 0)
				PingSleep(500)
			EndIf
		EndIf
		If $i = 3000 Then ExitLoop ; This is where we break the infinite recursive loop <<<<<<<<<<<<<<<<<<<<<<<<<<
	Until ComputeDistance(XLocation(), YLocation(), XLocation($mTeamDead[1]), YLocation($mTeamDead[1])) < 600 Or $lBlocked > 50
	UseRezSkillEx($RezSkill, $mTeamDead[1]) ; Res agent with hard rez
 EndFunc   ;==>RezParty

 ;~ Move function with disconnect check
Func MoveEx($x, $y, $random = 50)
   If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return Main()
   Move($x, $y, $random)
EndFunc   ;==>MoveEx

 ;~ Attack function with disconnect check
Func AttackEx($Target)
   If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return Main()
   Attack($Target)
EndFunc   ;==>AttackEx

Func CanDrop($Item)
	Switch DllStructGetData($Item, 'ModelID')
		Case $Ectoplasm, $ObsidianShards, $DiessaChalice, $GoldenRinRelics, $Lockpicks
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc

Func GoSellLoot()
   Local $CurrentGold = GetGoldCharacter() + GetGoldStorage()
   GUICtrlSetData($lblGold, $intGold)

   If MerchTime() And GetMapID() = $GUILDHALL Then
		  RndSleep(5000)
		  Update("Selling bags stuff")
		  RndSleep(1000)
		  inventory()
		  $intGold = GetGoldCharacter() + GetGoldStorage() - $CurrentGold
		  GUICtrlSetData($lblGold, $intGold)
	  EndIf

EndFunc   ;==>SellAndBack

Func WaitForLoad()
	Update("Loading zone")
	InitMapLoad()
	$deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100
		$load = GetMapLoading()
		$lMe = GetAgentByID(-2)

	Until $load = 2 And DllStructGetData($lMe, 'X') = 0 And DllStructGetData($lMe, 'Y') = 0 Or $deadlock > 10000

	$deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100
		$load = GetMapLoading()
		$lMe = GetAgentByID(-2)

	Until $load <> 2 And DllStructGetData($lMe, 'X') <> 0 And DllStructGetData($lMe, 'Y') <> 0 Or $deadlock > 30000
	Update("Load complete")
 EndFunc   ;==>WaitForLoad

