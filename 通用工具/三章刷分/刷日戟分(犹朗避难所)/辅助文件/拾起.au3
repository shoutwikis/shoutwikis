;~ Description: standard pickup function, only modified to increment a custom counter when taking stuff with a particular ModelID

Func PickUpLoot()
	Local $lAgent
	Local $lItem
	Local $lDeadlock
	Local $lBlocklock

	;DELETE NEXT 2 FOR-BLOCK BELOW TO RETURN TO NORMAL=======================================================
#cs
	For $i = 1 To GetMaxAgents() ;merge 435 and 436 to return to normal
		If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If (DllStructGetData($lItem, 'ModelID') = 22269) Then ;910
			PickUpItem($lItem)
			$lDeadlock = TimerInit()
			$lBlocklock = TimerInit()
			While GetAgentExists($i)
				Sleep(100)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
				If TimerDiff($lBlocklock) > 4000 Then
					MoveTo(DllStructGetData(GetAgentByID(-2),'X'),DllStructGetData(GetAgentByID(-2),'Y'), 70)
					PickUpLoot()
					$lBlocklock = TimerInit()
				EndIf
			WEnd
		EndIf
	Next

	For $i = 1 To GetMaxAgents() ;merge 435 and 436 to return to normal
		If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If (DllStructGetData($lItem, 'ModelID') = 28435) Then ;or (DllStructGetData($lItem, 'ModelID') = 22269)
			PickUpItem($lItem)
			$lDeadlock = TimerInit()
			$lBlocklock = TimerInit()
			While GetAgentExists($i)
				Sleep(100)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
				If TimerDiff($lBlocklock) > 4000 Then
					MoveTo(DllStructGetData(GetAgentByID(-2),'X'),DllStructGetData(GetAgentByID(-2),'Y'), 70)
					PickUpLoot()
					$lBlocklock = TimerInit()
				EndIf
			WEnd
		EndIf
	Next
	#ce
;#cs UNCOMMENT TO RETURN TO NORMAL======================================================================
	;Local $maxAgent = GetMaxAgents()
	;~ 加了不常见的以函数为序号的部分: getmaxagent
	For $i = 1 To GetMaxAgents() ;merge 435 and 436 to return to normal
		If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If FirstPickup($lItem) Then
			PickUpItem($lItem)
			$lDeadlock = TimerInit()
			$lBlocklock = TimerInit()
			While GetAgentExists($i)
				Sleep(100)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
				If TimerDiff($lBlocklock) > 4000 Then
					MoveTo(DllStructGetData(GetAgentByID(-2),'X'),DllStructGetData(GetAgentByID(-2),'Y'), 70)
					PickUpLoot()
					$lBlocklock = TimerInit()
				EndIf
			WEnd
		EndIf
		;$maxAgent = GetMaxAgents();delete this line to return to normal
	Next

	;~ 加了不常见的以函数为序号的部分
	For $i = 1 To GetMaxAgents() ;merge 435 and 436 to return to normal
		If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If CanPickup($lItem) Then
			PickUpItem($lItem)
			$lDeadlock = TimerInit()
			$lBlocklock = TimerInit()
			While GetAgentExists($i)
				Sleep(100)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
				If TimerDiff($lBlocklock) > 4000 Then
					MoveTo(DllStructGetData(GetAgentByID(-2),'X'),DllStructGetData(GetAgentByID(-2),'Y'), 70)
					PickUpLoot()
					$lBlocklock = TimerInit()
				EndIf
			WEnd
		EndIf
		;$maxAgent = GetMaxAgents();delete this line to return to normal
	Next
;#ce END UNCOMMENT TO RETURN TO NORMAL======================================================================
EndFunc   ;==>PickUpLoot

Func FirstPickUp($aItem)
	Local $lModelID = DllStructGetData(($aItem), 'ModelID')
	Local $aExtraID = DllStructGetData($aItem, "ExtraID")
	Local $lRarity = GetRarity($aItem)
	Local $Requirement = GetItemReq($aItem)
	If($lModelID == $ITEM_ID_GOLDEN_EGGS)Then
		Return True
	elseif ($lModelID == $ITEM_ID_CUPCAKES) Then
		Return True
	elseif ($lModelID == $ITEM_ID_PIE)Then
		Return True
	elseif ($lModelID == $ITEM_ID_TOTS)Then
		Return True
	elseif ($lModelID == $ITEM_ID_LUNAR_TOKEN)Then
		Return True
	elseif ($lModelID == $ITEM_ID_LUNAR_TOKENS) Then
		Return True
	elseIf ($lModelID == $ITEM_ID_DYES) Then	; if dye
		If (($aExtraID == $ITEM_EXTRAID_BLACKDYE) Or ($aExtraID == $ITEM_EXTRAID_WHITEDYE))Then ; only pick white and black ones
			Return True
		EndIf
	else
		return False
	EndIf
EndFunc

; Checks if should pick up the given item. Returns True or False
Func CanPickUp($aItem)
	Local $lModelID = DllStructGetData(($aItem), 'ModelID')
	Local $aExtraID = DllStructGetData($aItem, "ExtraID")
	Local $lRarity = GetRarity($aItem)
	Local $Requirement = GetItemReq($aItem)
	If (($lModelID == 2511) And (GetGoldCharacter() < 99000)) Then
		Return True	; gold coins (only pick if character has less than 99k in inventory)
	ElseIf ($lModelID=27035) Then
		Return True ;saurian bone
	ElseIf (($lModelID == $ITEM_ID_Mesmer_Tome) Or ($lModelID=21786) Or ($lModelID=21787) Or ($lModelID=21788) Or ($lModelID=21789) Or ($lModelID=21790) Or ($lModelID=21791) Or ($lModelID=21792) Or ($lModelID=21793) Or ($lModelID=21794) Or ($lModelID=21795) Or ($lModelID=21796) Or ($lModelID=21797) Or ($lModelID=21798) Or ($lModelID=21799) Or ($lModelID=21800) Or ($lModelID=21801) Or ($lModelID=21802) Or ($lModelID=21803) Or ($lModelID=21804) Or ($lModelID=21805)) Then
		Return True	; all tomes, not just mesmer
	ElseIf ($lModelID == $ITEM_ID_DYES) Then	; if dye
		If (($aExtraID == $ITEM_EXTRAID_BLACKDYE) Or ($aExtraID == $ITEM_EXTRAID_WHITEDYE))Then ; only pick white and black ones
			Return True
		EndIf
	ElseIf ($lRarity == $RARITY_GOLD) Then ; gold items
		Return True
	ElseIf ($lRarity == $RARITY_GREEN) Then ; 拿绿
		Return False

;#cs 若蓝/紫中只要达标的匕首和盾
	; use getattribute from helper for list
	elseif ($LMODELID <> 146) and (($Requirement = 5) or ($Requirement = 6)) and (GetItemAttribute($aItem) = 29) and (GetItemMaxDmg($aItem) > 12)  Then

		Return True


	elseIf ($LMODELID <> 146) and ((($Requirement = 5) and (GetIsShield($aItem) > 12)) or _
							   (($Requirement = 6) and (GetIsShield($aItem) > 13)) or _
							   (($Requirement = 7) and (GetIsShield($aItem) > 14))) Then
		Return True

;#ce

	ElseIf ($lRarity == $RARITY_PURPLE) Then ;拿紫   ;$lModelID, $Requirement
		Return False
	ElseIf ($lRarity == $RARITY_BLUE) Then ;拿蓝
		Return False
	ElseIf($lModelID == $ITEM_ID_LOCKPICKS)Then
		Return True ; Lockpicks
	ElseIf($lModelID == $ITEM_ID_GLACIAL_STONES)Then
		Return True ; glacial stones
	ElseIf CheckArrayPscon($lModelID)Then ; ==== Pcons ==== or all event items
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>CanPickUp

Func CheckArrayPscon($lModelID)
For $p = 0 To (UBound($Array_pscon) -1)
	If ($lModelID == $Array_pscon[$p]) Then Return True
Next
EndFunc