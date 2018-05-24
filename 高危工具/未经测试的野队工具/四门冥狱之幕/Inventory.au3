#include <GWA2.au3>

Func CheckArrayPscon($ModelID)
	For $p = 0 To (UBound($Array_pscon) -1)
		If ($ModelID == $Array_pscon[$p]) Then Return True
	Next
EndFunc

Func idandsell()
   If GetMapLoading() == 2 Then Disconnected()
;	TravelGH()
	WaitMapLoading()
	GoToNpC(GetAgentByName("Merchant"))
	IDKit()
	Identify()
	sell()
EndFunc   ;==>idandsell
#EndRegion

Func CountInvSlots()
	Local $bag
	Local $temp = 0
	$bag = GetBag(1)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(2)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(3)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(4)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	Return $temp
 EndFunc   ;==>CountInvSlots

Local $lBag

Func Identify()
	IdentifyBag(1)
	IdentifyBag(2)
	IdentifyBag(3)
	IdentifyBag(4)
 EndFunc   ;==>Identify

 Func IDKit()
	If FindIDKit() = 0 Then
		If GetGoldCharacter() < 100 Then
			WithdrawGold(100)
			RndSleep(2000)
		EndIf
		BuyItem(5, 1, 100)
		RndSleep(1000)
	EndIf
 EndFunc   ;==>IDKit

 Func sell()
	For $i = 1 To 3
		For $j = 1 To DllStructGetData(GetBag($i), 'slots')
			Local $item = GetItemBySlot($i, $j)
			If canSell($item) Then
				SellItem($item)
				Sleep(GetPing() + 500)
			EndIf
		Next
	Next
 EndFunc   ;==>sell

 Func SellBag($aBag)
	InventoryOut("Selling bag " & $aBag & ".")
	If Not IsDllStruct($aBag) Then $aBag = GetBag($aBag)
	Local $lItem
	Local $lMod

	For $i = 1 To DllStructGetData($aBag, 'Slots')
		$lItem = GetItemBySlot($aBag, $i)
		If DllStructGetData($lItem, 'ID') == 0 Then ContinueLoop
		If DllStructGetData($lItem, 'Customized') <> 0 Then ContinueLoop
		If DllStructGetData($lItem, 'value') <= 0 Then ContinueLoop

		Switch GetRarity($lItem)
			Case 2621
			Case 2623, 2624, 2626
				If Not GetIsIDed($lItem) Then ContinueLoop ;Unidentified
			Case Else
				ContinueLoop
		EndSwitch

		For $j = 0 To UBound($Inv_mModels) - 1
			If DllStructGetData($lItem, 'ModelID') = $Inv_mModels[$j] Then ContinueLoop 2
			Local $lDummy ;Autoit 3.8.8.0 bug - crashes if nothing after continueloop
		Next

		Switch DllStructGetData($lItem, 'type')
			Case 24 ;Shields
				If GetItemReq($lItem) = 8 Then
					$lMod = GetModByIdentifier($lItem, "B8A7")
					If $lMod[1] == 16 Then ContinueLoop
				ElseIf GetItemReq($lItem) = 7 Then
					$lMod = GetModByIdentifier($lItem, "B8A7")
					If $lMod[1] == 15 Then ContinueLoop
				EndIf
			Case 2, 5, 12, 15, 22, 26, 27, 32, 35, 36, 0 ;Weapons & Salvage
			Case 11 ;Materials
				Switch DllStructGetData($lItem, 'ModelID')
					Case 925, 940, 946 ;Cloth, Hide, Wood
					Case Else
						ContinueLoop
				EndSwitch
			Case Else
				ContinueLoop
		EndSwitch
		SellItem($lItem)
		Sleep(GetPing() + Random(1000, 1500, 1))
	Next
 EndFunc   ;==>SellBag

 Func CANSELL($AITEM)
	Local $RARITY_White = 2621, $RARITY_Blue = 2623, $RARITY_Purple = 2626, $RARITY_Gold = 2624, $RARITY_Green = 2627
	Local $m = DllStructGetData($aItem, 'ModelID')
	Local $q = DllStructGetData($aItem, 'Quantity')
	Local $r = GetRarity($aItem)
	Local $Attribute = GetItemAttribute($aItem)
	Local $Requirement = GetItemReq($aItem)
	Local $ModStruct = GetModStruct($aItem)
	Local $Vigor = StringInStr($ModStruct, "0101082403023025C202EA27", 0, 1) ;~String for Sup Vigor.


	If $M = 146 Then ; teintures noires et blanches
		If DllStructGetData($AITEM, "ExtraId") > 9 Then
			Return False
		Else
			Return True
		 EndIf

   ElseIf $M = 22751 Then ; lockpicks
		Return False
   ElseIf $M = 5656 Then ;
		Return False
   ElseIf $M = 18345 Then ;
		Return False
   ElseIf $M = 21491 Then ;
		Return False
   ElseIf $M = 37765 Then ;
		Return False
   ElseIf $M = 21833 Then ;
		Return False
   ElseIf $M = 28433 Then ;
		Return False
   ElseIf $M = 28434 Then ;
		Return False
   ElseIf $M = 778 Then ; bouclier à lame
		Return False
   ElseIf $M = 777 Then ; bouclier à lame
		Return False
   ElseIf $M = 735 Then ; bo staff
		Return False
   ElseIf $M = 945 Then ; Echovald
		Return False
   ElseIf $M = 944 Then ; Echovald
		Return False
   ElseIf $M = 940 Then ; Amber
		Return False
   ElseIf $M = 941 Then ; Amber
		Return False
   ElseIf $M = 950 Then ; Gothic
		Return False
   ElseIf $M = 951 Then ; Gothic
		Return False
   ElseIf $M = 1321 Then ; Hunt Gardien
		Return False
   ElseIf $M = 1320 Then ; Hunt Gardien
		Return False
   ElseIf $M = 736 Then ; Dragon staff
		Return False
   ElseIf $M = 794 Then ;Oni Blade
		Return False
   ElseIf $M = 337 Then ;Skeleton Shield
		Return False
   ElseIf $M = 334 Then ;Shield of the Wing
		Return False
   ElseIf $M = 766 Then ;Oni Daggers
		Return False
   ElseIf $M = 795 Then ;Golden Phenix Blade
		Return False
   ElseIf $M = 744 Then ;Shinobi Blade
		Return False
   ElseIf $M = 742 Then ;Katana
		Return False
   ElseIf $M = 741 Then ;Jitte
		Return False
   ElseIf $M = 866 Then ;Paper Fan
		Return False
   ElseIf $M = 775 Then ;Paper Fan
		Return False
   ElseIf $M = 776 Then ;Paper Fan
		Return False
   ElseIf $M = 789 Then ;Paper Fan
		Return False
   ElseIf $M = 858 Then ;Paper Fan
		Return False
   ElseIf $M = 866 Then ;Paper Fan
		Return False
   ElseIf $M = 947 Then ;Emblazoned
		Return False
   ElseIf $M = 955 Then ;Ornate Shield
		Return False
   ElseIf $M = 5899 Then ; necessaire d'id
		Return False
   ElseIf $M = 400 Then ; FellBlade
		Return False
   ElseIf $M = 405 Then ; Falchion
		Return False
   ElseIf $M = 2250 Then ; Flamberge
		Return False
   ElseIf $M = 1556 Then ; Colossal Scimitar
		Return False
   ElseIf $M = 791 Then ; Crenellated
		Return False
   ElseIf $M = 1197 Then ; Tatooed Scimitar
		Return False
   ElseIf $M = 1612 Then ; Fiery Dragon Sword
		Return False
   ElseIf $M = 397 Then ; Butterlfy Sword
		Return False
   ElseIf $M = 323 Then ; Aegis
		Return False
   ElseIf $M = 331 Then ; Defender
		Return False
   ElseIf $M = 343 Then ; Tall Shield
		Return False
   ElseIf $M = 326 Then ; Ornate Buckler
		Return False
   ElseIf $M = 338 Then ; Skull Shield
		Return False
   ElseIf $M = 327 Then ; Reinforced Buckler
		Return False
   ElseIf $M = 345 Then ; Tower Shield
		Return False
   ElseIf $M = 871 Then ; Spiked Targe
		Return False
   ElseIf $M = 872 Then ; Spiked Targe
		Return False
   ElseIf $M = 2299 Then ; Irridescent Aegis
		Return False
   ElseIf $M = 2294 Then ; Diamond Aegis
		Return False
   ElseIf $M = 896 Then ; Paper Lantern
		Return False
   ElseIf $M = 603 Then ; Orr Staff
		Return False
   ElseIf $M = 887 Then ; Baton Feu Skin Cantha
		Return False
   ElseIf $M = 5899 Then ; necessaire d'id
		Return False
  	ElseIf $m > 21785 And $m < 21806 Then ;Tomes not for sale
		Return False
   	 ElseIf $Attribute = 20 And $Requirement = 8 And GetItemMaxDmg($aItem) = 22 Then ; req8 Swords - Swordsmanship
		Return False
	 ElseIf $Attribute = 17 And $Requirement = 8 And GetItemMaxDmg($aItem) = 16 Then ; req8 Shields - Strength
		Return False
     ElseIf $Attribute = 21 And $Requirement = 8 And GetItemMaxDmg($aItem) = 16 Then ; Req8 Shields - Tactics
		Return False
	 ElseIf $Requirement = 8 Then
		Return False
	 Else
		Return True
	EndIf
 EndFunc