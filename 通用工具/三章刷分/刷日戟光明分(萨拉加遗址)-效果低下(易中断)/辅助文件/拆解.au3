Global $nMerchant[8] = ["商人","Merchant", "Marchand", "Kaufmann", "Mercante", "asdf", "Kupiec", "Merchunt"]
Global $nXunlai[8] = ["桑萊保險箱","Xunlai Chest", "Coffre Xunlai", "Xunlai-Truhe", "Forziere Xunlai", "asdf", "Skrzynia Xunlai", "Xoonlaeee Chest"]

 Func Salvage()
   Local $Chest
   Local $Merchant

   For $i = 1 To 8 ; Open chest
	  $Chest = GetAgentByName($nXunlai[$i-1])
	  If IsDllStruct($Chest) Then
		 Out("找到储存箱 !")
		 GoToNPC($Chest)
		 ExitLoop
	  ElseIf $i = 8 Then
		 Out("无法找到储存箱")
	  EndIf
   Next

   For $i = 1 To 8 ; Open Merchant
	  $Merchant = GetAgentByName($nMerchant[$i-1])
	  If IsDllStruct($Merchant) Then
		 Out("找到商人 !")
		 GoToNPC($Merchant)
		 ExitLoop
	  ElseIf $i = 8 Then
		 Out("无法找到商人")
	  EndIf
   Next

   For $i = 1 To 4
	  If Not SalvageBag($i) Then ExitLoop
   Next

 EndFunc

 Func SalvageKit()
   If FindSalvageKit() = 0 Then
	  Out("需要拆解器.")
	  If GetGoldCharacter() < 100 Then
		 Out("需要金.")
		 WithdrawGold(100)
		 RndSleep(2000)
	  EndIf
	  BuyItem(2, 1, 100)
	  RndSleep(1000)
   EndIf
 EndFunc

Func SalvageBag($lBag)
	Out("正在拆解第 " & $lBag & "包.")
	Local $aBag
	If Not IsDllStruct($lBag) Then $aBag = GetBag($lBag)
	Local $lItem
	Local $lSalvageType
	Local $lSalvageCount
	For $i = 1 To DllStructGetData($aBag, 'Slots')

		If $boolRunning = False Then
			ExitLoop
		EndIf

		$lItem = GetItemBySlot($aBag, $i)

		SalvageKit()

		$r = GetRarity($lItem)
		$m = DllStructGetData($lItem, 'ModelID')

		If (DllStructGetData($lItem, 'ID') == 0) Then ContinueLoop
		If _ArraySearch($ArraySalvageRarity, $r) = -1 And _ArraySearch($ArraySalvageModelID, $m) = -1 Then ContinueLoop

		$lSalvageCount = SalvageUses($lBag)
		$lSalvageType = GetCanSalvage($lItem, True)
		Switch $lSalvageType
			Case -1
				ContinueLoop
			Case 0, 1, 2
				StartSalvage($lItem)
				While (GetPing() > 1250)
					RndSleep(250)
					Out("太卡了" & GetPing())
				WEnd
				Sleep(GetPing() * 3 + 800)
				SalvageMaterials()
				Sleep(GetPing() * 3)
				Local $lDeadlock = TimerInit()
				Do
					Sleep(100)
					If (TimerDiff($lDeadlock) > 20000) Then ExitLoop
				Until (SalvageUses($lBag) <> $lSalvageCount)
				$i -= 1
			Case 3 ; white qty = 1
				StartSalvage($lItem)
				While (GetPing() > 1250)
					RndSleep(250)
					OUT("太卡了" & GetPing())
				WEnd
				Sleep(GetPing() * 3 + 800)
				SalvageMaterials()
				Sleep(GetPing() * 3)
				Local $lDeadlock = TimerInit()
				Do
					Sleep(100)
					If (TimerDiff($lDeadlock) > 20000) Then ExitLoop
				Until (SalvageUses($lBag) <> $lSalvageCount)
			Case 4 ; qty > 1
				StartSalvage($lItem)
				While (GetPing() > 1250)
					RndSleep(250)
					Out("太卡了" & GetPing())
				WEnd
				Sleep(GetPing() + 800)
				SalvageMaterials()
				Local $lDeadlock = TimerInit()
				Do
					Sleep(100)
					If (TimerDiff($lDeadlock) > 20000) Then ExitLoop
				Until (SalvageUses($lBag) <> $lSalvageCount)
				$i -= 1
		EndSwitch
	Next
	Return True
EndFunc   ;==>SalvageBag

 #region Salvage
 Func GetCanSalvage($aItem, $aMerchant)
	If DllStructGetData($aItem, 'Customized') <> 0 Then Return -1

	Switch DllStructGetData($aItem, 'type')
		Case 0, 2, 5, 12, 15, 22, 24, 26, 27, 32, 35, 36
		Case 30
			If DllStructGetData($aItem, 'value') <= 0 Then Return -1
		Case Else
			Return -1
	EndSwitch

   $r = GetRarity($aItem)

   Switch $r
	    Case 2621
			If DllStructGetData($aItem, 'Quantity') > 1 Then
			   If Not $aMerchant Then Return -1
			   Return 4
			EndIf
			Return 3
		Case 2623, 2624, 2626
;~ 			If Not $aMerchant Then Return -1
;~ 			$lModString = GetModStruct($aItem)
;~ 			For $i = 0 To UBound($Inv_mMods) - 1
;~ 				If StringInStr($lModString, $Inv_mMods[$i][0]) Then
;~ 				  Out("Salvaging " & $Inv_mMods[$i][1] & " from item.")
;~ 				  Return $Inv_mMods[$i][2]
;~ 				EndIf
;~ 			Next
			Return -1
		Case Else
			Return -1
	EndSwitch

EndFunc   ;==>GetCanSalvage

Func SalvageUses($aBags)

	Local $lBag
	Local $lItem
	Local $lCount = 0
	For $i = 1 To 21 ;;;;;;16 was $aBags      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;mistake
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

Func SalvageCount($aBags)
	Local $lBag
	Local $lItem
	Local $lModString
	Local $lCount = 0

	For $i = 1 To $aBags
		$lBag = GetBag($i)
		For $j = 1 To DllStructGetData($lBag, 'Slots')
			$lItem = GetItemBySlot($lBag, $j)
			If DllStructGetData($lItem, 'ID') == 0 Then ContinueLoop

			If GetCanSalvage($lItem, False) <> -1 Then $lCount += 1
		Next
	Next
	Return $lCount
EndFunc   ;==>SalvageCount
#endregion Salvage

#cs
;~ Description: Returns item ID of salvage kit in inventory.
Func FindSalvageKit()
	Local $lItem
	Local $lKit = 0
	Local $lUses = 101
	For $i = 1 To 21
		For $j = 1 To DllStructGetData(GetBag($i), 'Slots')
			$lItem = GetItemBySlot($i, $j)
			Switch DllStructGetData($lItem, 'ModelID')
				Case 2991, expert
					If DllStructGetData($lItem, 'Value') / 8 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 8
					EndIf
				Case 2992, normal
					If DllStructGetData($lItem, 'Value') / 2 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 2
					EndIf
				Case 2993
					If DllStructGetData($lItem, 'Value') / 2 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 2
					EndIf
				Case 5900, superior
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
EndFunc   ;==>FindSalvageKit
#ce