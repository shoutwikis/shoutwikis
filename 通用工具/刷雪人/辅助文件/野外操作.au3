#cs
things to do:

REMEMBER TO BUY ID KIT AND SALVAGE KIT BEFORE YOU LEAVE TOWN


#ce
Global $SalvagedValueTotal=0 ;
Global $gateValue = 335 ;do not salvage above this value

Global $SalvageTotalUse = 0
;~ Description: Returns number of salvage uses left, REMEMBER TO BUY ENOUGH BEFORE LEAVING TOWN
Func NumSalvageKit()
	$SalvageTotalUse = 0
	Local $lItem
	Local $lKit = 0
	Local $lUses = 101
	For $i = 1 To 4 ;only bags on the character counts
		For $j = 1 To DllStructGetData(GetBag($i), 'Slots')
			$lItem = GetItemBySlot($i, $j)
			Switch DllStructGetData($lItem, 'ModelID')
				Case 2991
					$SalvageTotalUse += DllStructGetData($lItem, 'Value') / 8
					If DllStructGetData($lItem, 'Value') / 8 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 8
					EndIf
				Case 5900
					$SalvageTotalUse += DllStructGetData($lItem, 'Value') / 10
					If DllStructGetData($lItem, 'Value') / 10 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 10
					EndIf
				Case Else
					ContinueLoop
			EndSwitch
		Next
	Next
	Return $lKit
EndFunc

Global $IdentTotalUse = 0
;~ Description: Returns number of ID kit uses left, REMEMBER TO BUY ENOUGH BEFORE LEAVING TOWN
Func NumIDKit()
	$IdentTotalUse = 0
	Local $lItem
	Local $lKit = 0
	Local $lUses = 101
	For $i = 1 To 4 ;only bags on the character counts
		For $j = 1 To DllStructGetData(GetBag($i), 'Slots')
			$lItem = GetItemBySlot($i, $j)
			Switch DllStructGetData($lItem, 'ModelID')
				Case 2989
					$IdentTotalUse += DllStructGetData($lItem, 'Value') / 2
					If DllStructGetData($lItem, 'Value') / 2 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 2
					EndIf
				Case 5899
					$IdentTotalUse += DllStructGetData($lItem, 'Value') / 2.5
					If DllStructGetData($lItem, 'Value') / 2.5 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 2.5
					EndIf
				Case Else
					ContinueLoop
			EndSwitch
		Next
	Next
	Return $lKit
EndFunc

;~ Description: Identifies an item.
Func exIdentifyItem($aItem)
	If GetIsIDed($aItem) Then Return

	Local $lItemID
	If IsDllStruct($aItem) = 0 Then
		$lItemID = $aItem
	Else
		$lItemID = DllStructGetData($aItem, 'ID')
	EndIf

	Local $lIDKit = NumIDKit()
	If $lIDKit == 0 Then Return

	SendPacket(0xC, $IdentifyItemHeader, $lIDKit, $lItemID)

	Local $lDeadlock = TimerInit()
	Do
		Sleep(20)
	Until GetIsIDed($lItemID) Or TimerDiff($lDeadlock) > 5000
	If Not GetIsIDed($lItemID) Then IdentifyItem($aItem)
EndFunc

;~ ident in the field, without buying additional ones
Func exIDENT($BAGINDEX)
	Local $bag
	Local $I
	Local $AITEM
	$BAG = GETBAG($BAGINDEX)
	For $I = 1 To DllStructGetData($BAG, "slots")
		NumIDKIT()
		if $IdentTotalUse = 0 then
	        out("鉴定器用尽")
    		return false
		EndIf

		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		exIDENTIFYITEM($AITEM)
		Sleep(GetPing()+500)
	Next
	return true
EndFunc



;~ Description: Starts a salvaging session of an item.
Func exStartSalvage($aItem)
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x62C]
	Local $lSalvageSessionID = MemoryReadPtr($mBasePointer, $lOffset)

	If IsDllStruct($aItem) = 0 Then
		Local $lItemID = $aItem
	Else
		Local $lItemID = DllStructGetData($aItem, 'ID')
	EndIf

	Local $lSalvageKit = NumSalvageKit()
	If $lSalvageKit = 0 Then Return false

	DllStructSetData($mSalvage, 2, $lItemID)
	DllStructSetData($mSalvage, 3, NumSalvageKit())
	DllStructSetData($mSalvage, 4, $lSalvageSessionID[1])

	Enqueue($mSalvagePtr, 16)
	return true
EndFunc


Func exSalvageUses($aBags)
	Local $lBag
	Local $lItem
	Local $lCount = 0
	For $i = 1 To 4 ;;;only stuff on character counts;;;;;;;;;;;;;
		$lBag = GetBag($i)
		For $j = 1 To DllStructGetData($lBag, 'Slots')
			$lItem = GetItemBySlot($lBag, $j)
			Switch DllStructGetData($lItem, 'ModelID')
				Case 2991
					$lCount += DllStructGetData($lItem, 'Value') / 8
				Case 5900
					$lCount += DllStructGetData($lItem, 'Value') / 10
				Case 2992
					$lCount += DllStructGetData($lItem, 'Value') / 2
				Case 2993
					$lCount += DllStructGetData($lItem, 'Value') / 2
			EndSwitch
		Next
	Next
	Out("剩余次数:" & $lCount)
	Return $lCount
EndFunc   ;==>SalvageUses

Func exSalvageBag($lBag)
	Out("正在拆解第 " & $lBag & "包.")
	Local $aBag
	If Not IsDllStruct($lBag) Then $aBag = GetBag($lBag)
	Local $lItem
	Local $lSalvageType
	Local $lSalvageCount
	For $i = 1 To DllStructGetData($aBag, 'Slots')

		If countslots()<2 then
			out("剩余空间不够")
			return false;no space left
		EndIf

		$lItem = GetItemBySlot($aBag, $i)
		Local $r = GetRarity($lItem)
		Local $m = DllStructGetData($lItem, 'ModelID')

		If (DllStructGetData($lItem, 'ID') == 0) Then ContinueLoop
		If retainThis($lItem) then ContinueLoop

		;If (DllStructGetData($lItem, 'Type') <> 22) AND (DllStructGetData($lItem, 'Type') <> 27) then continueloop
		;If _ArraySearch($ArraySalvageRarity, $r) = -1 And _ArraySearch($ArraySalvageModelID, $m) = -1 Then ContinueLoop
		$lSalvageCount = exSalvageUses($lBag)
		Local $Requirement = GetItemReq($lItem)
		Local $tempValue=DllStructGetData($lItem, 'Value')
		If (((DllStructGetData($lItem, 'Type') == 22) or (DllStructGetData($lItem, 'Type') == 27) or (DllStructGetData($lItem, 'Type') == 15)) and (DllStructGetData($lItem, 'Value')<= $gateValue)) or _
		(GetIsShield($lItem) and (DllStructGetData($lItem, 'Value')<= $gateValue) and (NOT _
							   (((($Requirement = 5) and (GetIsShield($lITEM) > 12)) or _
							   (($Requirement = 6) and (GetIsShield($lITEM) > 13)) or _
							   (($Requirement = 7) and (GetIsShield($lITEM) > 14))) and _
							   (GetItemInscr($lItem) <> 0))  ) ) or _
		((GetItemAttribute($lItem) = 29) and (DllStructGetData($lItem, 'Value')<= $gateValue) and _
		  (NOT ((($Requirement = 5) or ($Requirement = 6))  and (GetItemMaxDmg($lItem) > 12) and (GetItemInscr($lItem) <> 0)) ) ) then

				if NOT exStartSalvage($lItem) then
				    out("拆解器用尽")
					return false ;no salvage left
				EndIf


			    While (GetPing() > 1250)
					RndSleep(250)
					OUT("太卡了" & GetPing())
				WEnd
				Sleep(GetPing() * 3 + 800)
				out("拆解： "&$lBag&", "&$i) ;uses $lBag b/c $aBag is a struct
				SalvageMaterials()
				Sleep(GetPing() * 3)
				Local $lDeadlock = TimerInit()
				Do
					Sleep(100)
					If (TimerDiff($lDeadlock) > 10000) Then ExitLoop ;was 20000
				Until (exSalvageUses($lBag) <> $lSalvageCount)
				if (SalvageUses($lBag) <> $lSalvageCount) then
					$SalvagedValueTotal+=$tempValue
					GUICtrlSetData($SalvageLabel, $SalvagedValueTotal)
					$tempValue=0
				EndIf

		EndIf
	Next
	Return True
EndFunc