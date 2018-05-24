;~ Description: Make sure to have enough gold on character, but not too much.
Func MinMaxGold()
   $lGoldCharacter = GetGoldCharacter()
   $lGoldStorage = GetGoldStorage()
   $lGold = $lGoldCharacter + $lGoldStorage
   OpenStorageWindow()
   If $lGoldCharacter < 10000 And $lGoldStorage > 10000 Then
	  WithdrawGold(10000 - $lGoldCharacter)
	  Return 10000
   ElseIf $lGoldCharacter > 50000 And $lGold < 1000000 Then
	  DepositGold($lGoldCharacter - 10000)
	  Return 10000
   Else
	  Return $lGoldCharacter
   EndIf
EndFunc   ;==>MinMaxGold

;~ Description: Buy Ident and Salvage Kits for inventory session.
Func BuyKits($aAmount = 40, $aExpertSalv = True)
   ; identification kits
   $lIDKitUses = FindIDKitUses(1, 4)
   If $lIDKitUses < $aAmount Then
	  $lItemIDRow = GetItemRowByModelID(2989)
	  $lKitUses = 25
	  If $lItemIDRow = 0 Then
		 $lItemIDRow = GetItemRowByModelID(5899)
		 $lKitUses = 100
		 If $lItemIDRow = 0 Then Return ; no id kit
	  EndIf
	  $lBuyAmount = Ceiling(($aAmount - $lIDKITUses) / $lKitUses)
	  Update("Buying ID Kits: " & $lBuyAmount)
	  BuyIdentKit($lItemIDRow, $lBuyAmount)
	  Sleep(250 + GetPing())
   EndIf
   ; salvage kits
   $lSalvKitUses = CheapSalvageUses(1, 4)
   If $lSalvKitUses < $aAmount Then
	  $lItemIDRow = GetItemRowByModelID(2992)
	  $lKitUses = 25
	  If $lItemIDRow = 0 Then
		 $lItemIDRow = GetItemRowByModelID(2993)
		 $lKitUses = 10
		 If $lItemIDRow = 0 Then Return
	  EndIf
	  $lBuyAmount = Ceiling(($aAmount - $lSalvKitUses) / $lKitUses)
	  Update("Buying Salvage Kits: " & $lBuyAmount)
	  BuySalvKit(False, $lItemIDRow, $lBuyAmount)
	  Sleep(250 + GetPing())
   EndIf
   ; expert salvage kits
   If $aExpertSalv Then
	  $lExperSalvKitUses = ExpertSalvageUses(1, 4)
	  If $lExperSalvKitUses < $aAmount Then
		 $lItemIDRow = GetItemRowByModelID(2991)
		 $lKitUses = 25
		 If $lItemIDRow = 0 Then
			$lItemIDRow = GetItemRowByModelID(5900)
			$lKitUses = 100
			If $lItemIDRow = 0 Then Return
		 EndIf
		 $lBuyAmount = Ceiling(($aAmount - $lExperSalvKitUses) / $lKitUses)
		 Update("Buying Expert Salv Kits: " & $lBuyAmount)
		 BuySalvKit(True, $lItemIDRow, $lBuyAmount)
		 Sleep(250 + GetPing())
	  EndIf
   EndIf
EndFunc   ;==>BuyKits

;~ Description: Returns amount of salvage uses.
Func CheapSalvageUses($aStart = 1, $aFinish = 16)
   Local $lCount = 0
   For $bag = $aStart to $aFinish
	  Local $lBagPtr = GetBagPtr($bag)
	  Local $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
	  For $slot = 0 To MemoryRead($lBagPtr + 32, 'long') - 1
		 Local $lItemPtr = MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr')
		 If $lItemPtr = 0 Then ContinueLoop
		 Local $lItemMID = MemoryRead($lItemPtr + 44, 'long')
		 If $lItemMID = 2992 Or $lItemMID = 2993 Then $lCount += MemoryRead($lItemPtr + 36, 'short') / 2
	  Next
   Next
   Return $lCount
EndFunc   ;==>SalvageUses

;~ Description: Buys Ident kit.
Func BuyIdentKit($aItemIDRow = 0, $aAmount = 1)
   If $aItemIDRow = 0 Then
	  $lItemIDRow = GetItemRowByModelID(2989)
	  If $lItemIDRow = 0 Then
		 $lItemIDRow = GetItemRowByModelID(5899)
		 If $lItemIDRow = 0 Then Return ; no id kit
	  EndIf
   Else
	  $lItemIDRow = $aItemIDRow
   EndIf
   $lItemPtr = GetItemPtr($lItemIDRow)
   $lValue = MemoryRead($lItemPtr + 36, 'short') * 2
   DllStructSetData($mBuyItem, 2, $aAmount)
   DllStructSetData($mBuyItem, 3, $lItemIDRow)
   DllStructSetData($mBuyItem, 4, $lValue * $aAmount)
   Enqueue($mBuyItemPtr, 16)
   Return $lItemPtr
EndFunc   ;==>BuyIdentKit

;~ Description: Buys salvage kit.
Func BuySalvKit($aExpert = False, $aItemIDRow = 0, $aAmount = 1)
   If $aItemIDRow = 0 Then
	  If $aExpert Then
		 $lItemIDRow = GetItemRowByModelID(2991)
		 If $lItemIDRow = 0 Then
			$lItemIDRow = GetItemRowByModelID(5900)
			If $lItemIDRow = 0 Then Return
		 EndIf
	  Else
		 $lItemIDRow = GetItemRowByModelID(2992)
		 If $lItemIDRow = 0 Then
			$lItemIDRow = GetItemRowByModelID(2993)
			If $lItemIDRow = 0 Then Return
		 EndIf
	  EndIf
   Else
	  $lItemIDRow = $aItemIDRow
   EndIf
   $lItemPtr = GetItemPtr($lItemIDRow)
   $lValue = MemoryRead($lItemPtr + 36, 'short') * 2
   DllStructSetData($mBuyItem, 2, $aAmount)
   DllStructSetData($mBuyItem, 3, $lItemIDRow)
   DllStructSetData($mBuyItem, 4, $aAmount * $lValue)
   Enqueue($mBuyItemPtr, 16)
   Return $lItemPtr
EndFunc   ;==>BuySalvKit

;~ Description: Identify all unident items in inventory.
Func Ident()
   For $bag = 1 to 4 ; inventory only
	  $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then ContinueLoop
	  For $slot = 1 to MemoryRead($lBagPtr + 32, 'long')
		 $lItemPtr = GetItemPtrBySlot($lBagPtr, $slot)
		 If $lItemPtr = 0 Then ContinueLoop
		 If GetIsUnIDed($lItemPtr) Then
			Update("Identify: " & $bag & ", " & $slot)
			IdentifyItem($lItemPtr)
		 EndIf
	  Next
   Next
EndFunc   ;==>Ident

;~ Description: Store full stacks, unident golds and mods.
Func StoreItems()
   UpdateEmptyStorageSlot($mEmptyBag, $mEmptySlot)
   Update("Empty Spot: " & $mEmptyBag & ", " & $mEmptySlot)
   If $mEmptySlot = 0 Then Return ; no more empty slots found
   OpenStorageWindow()
   For $bag = 1 To 4 ; inventory only
	  $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then ContinueLoop ; empty bag slot
	  $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
	  For $slot = 0 To MemoryRead($lBagPtr + 32, 'long') - 1
		 $lItemPtr = MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr')
		 If $lItemPtr = 0 Then ContinueLoop ; empty slot
		 $lItemID = MemoryRead($lItemPtr, 'long')
		 $lItemType = MemoryRead($lItemPtr + 32, 'byte')
		 $lItemQuantity = MemoryRead($lItemPtr + 75, 'byte')
		 If $lItemType = 11 And $lItemQuantity = 250 And $mStoreMaterials Then ; materials
			Update("Store Materials: " & $bag & ", " & $slot & " -> " & $mEmptyBag & ", " & $mEmptySlot)
			MoveItem($lItemID, $mEmptyBag, $mEmptySlot)
			Do
			   Sleep(250)
			Until MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr') = 0
			UpdateEmptyStorageSlot($mEmptyBag, $mEmptySlot)
			If $mEmptySlot = 0 Then Return
			ContinueLoop
		 EndIf
		 $lItemMID = MemoryRead($lItemPtr + 44, 'long')
		 If StackableItems($lItemMID) And $lItemQuantity = 250 Then ; only full stacks
			Update("Store Stack: " & $bag & ", " & $slot & " -> " & $mEmptyBag & ", " & $mEmptySlot)
			MoveItem($lItemID, $mEmptyBag, $mEmptySlot)
			Do
			   Sleep(250)
			Until MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr') = 0
			UpdateEmptyStorageSlot($mEmptyBag, $mEmptySlot)
			If $mEmptySlot = 0 Then Return
			ContinueLoop
		 EndIf
		 If Keepers($lItemMID) Then
			Update("Store Keepers: " & $bag & ", " & $slot & " -> " & $mEmptyBag & ", " & $mEmptySlot)
			MoveItem($lItemID, $mEmptyBag, $mEmptySlot)
			Do
			   Sleep(250)
			Until MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr') = 0
			UpdateEmptyStorageSlot($mEmptyBag, $mEmptySlot)
			If $mEmptySlot = 0 Then Return ; no more empty slots
			ContinueLoop
		 EndIf
		 If $mStoreGold And GetRarity($lItemPtr) = 2624 Then ; store unident golds if possible
			Update("Store Golds: " & $bag & ", " & $slot & " -> " & $mEmptyBag & ", " & $mEmptySlot)
			MoveItem($lItemID, $mEmptyBag, $mEmptySlot)
			Do
			   Sleep(250)
			Until MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr') = 0
			UpdateEmptyStorageSlot($mEmptyBag, $mEmptySlot)
			If $mEmptySlot = 0 Then Return ; no more empty slots
			ContinueLoop
		 EndIf
	  Next
   Next
EndFunc   ;==>StoreItems

;~ Description: Return true of item is a stackable item.
Func StackableItems($aModelID)
   Switch $aModelID
	  ; stackable drops
	  Case 460,474,476,486,504,522,525,811,819,822,835,1610,2994,19185,22751,24629,24630,24631,24632,27033,27035,27044,27046,27047,27052,35123
		 Return True
	  ; tomes
	  Case 21786 to 21805
		 Return True
	  ; alcohol
	  Case 910,2513,5585,6049,6366,6367,6375,15477,19171,22190,24593,28435,30855,31145,31146,35124,36682
		 Return True
	  ; party
	  Case 6376,6368,6369,21809,21810,21813,29436,29543,36683,4730,15837,21490,22192,30626,30630,30638,30642,30646,30648,31020,31141,31142,31144,31172
		 Return True
	  ; sweets
	  Case 15528,15479,19170,21492,21812,22269,22644,22752,28431,28432,28436,31150,35125,36681
		 Return True
	  ; scrolls
	  Case 3256,3746,5594,5595,5611,21233,22279,22280
		 Return True
	  ; DPRemoval
	  Case 6370,21488,21489,22191,35127,26784,28433
		 Return True
	  ; special drops
	  Case 18345,21491,21833,28434,35121
		 Return True
	  Case Else
		 Return False
   EndSwitch
EndFunc   ;==>StackableItems

;~ Description: Returns next empty slot, start at $aBag, $aSlot. Returns 0 if there's no empty slot in this bag.
Func UpdateEmptySlot(ByRef $aBagNr, ByRef $aSlot)
   If $aBagNr = 0 Then
	  $lBagNr = 1
   Else
	  $lBagNr = $aBagNr
   EndIf
   If $aSlot = 0 Then
	  $lSlot = 1
   Else
	  $lSlot = $aSlot
   EndIf
   $aBagNr = 0
   $aSlot = 0
   For $bag = $lBagNr To 4
	  $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then Return 0 ; no bag
	  For $slot = $lSlot To MemoryRead($lBagPtr + 32, 'long')
		 $lSlotPtr = GetItemPtrBySlot($lBagPtr, $slot)
		 If $lSlotPtr = 0 Then
			$aBagNr = $bag
			$aSlot = $slot
			Return True
		 EndIf
	  Next
	  $lSlot = 1
   Next
EndFunc   ;==>UpdateEmptySlot

;~ Description: Returns next empty slot, start at $aBag, $aSlot. Returns 0 if there's no empty slot in this bag.
Func UpdateEmptyStorageSlot(ByRef $aBagNr, ByRef $aSlot)
   If $aBagNr = 0 Then
	  $lBagNr = 8
   Else
	  $lBagNr = $aBagNr
   EndIf
   If $aSlot = 0 Then
	  $lSlot = 1
   Else
	  $lSlot = $aSlot
   EndIf
   $aBagNr = 0
   $aSlot = 0
   For $bag = $lBagNr To 16
	  $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then Return 0 ; no bag
	  For $slot = $lSlot To 20
		 $lSlotPtr = GetItemPtrBySlot($lBagPtr, $slot)
		 If $lSlotPtr = 0 Then
			$aBagNr = $bag
			$aSlot = $slot
			Return True
		 EndIf
	  Next
	  $lSlot = 1
   Next
EndFunc   ;==>UpdateEmptyStorageSlot

;~ Description: Returns true for all ModelIDs specified.
Func Keepers($aModelID)
   Switch $aModelID
	  ; mods
	  Case 896,908,15554,15551,15552,894,906,897,909,893,905,6323,6331,895,907,15543,15553,15544,15555,15540,15541,15542,17059,19122,19123
		 Return True
	  Case 5551 ; Rune of Superior Vigor
		 Return True
	  Case 460 ; White Mantle Emblem
		 Return $mWhiteMantleEmblem
	  Case 461 ; White Mantle Badge
		 Return $mWhiteMantleBadge
	  Case Else
		 Return False
   EndSwitch
EndFunc   ;==>Keepers

;~ Description: Salvages all items in all bags.
Func SalvageBags()
   ; Search for ID kit
   Local $lIDKit = FindIDKitPtr()
   If $lIDKit = 0 Then
	  Local $lIdentify = False
   Else
	  Local $lIDKitID = MemoryRead($lIDKit, 'long')
	  Local $lIdentify = True
   EndIf
   ; Search for expert salvage kit
   Local $lExpertKit = FindExpertSalvageKit()
   If $lExpertKit = 0 Then
	  Return
   Else
	  $lExpertKitID = MemoryRead($lExpertKit, 'long')
   EndIf
   ; Search for normal salvage kit
   Local $lCheapKit = FindCheapSalvageKit()
   If $lCheapKit = 0 Then
	  Return
   Else
	  $lCheapKitID = MemoryRead($lCheapKit, 'long')
   EndIf
   ; Start processing
   For $bag = 1 To 4 ; inventory only
	  $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then ContinueLoop
	  For $slot = 1 To MemoryRead($lBagPtr + 32, 'long') ; slots
		 $lItem = GetItemPtrBySlot($lBagPtr, $slot)
		 If IgnoreItem($lItem) Then ContinueLoop
		 If MemoryRead($lItem + 32, 'byte') = 31 Then ContinueLoop ; scrolls
		 $lQuantity = MemoryRead($lItem + 75, 'byte')
		 If $lQuantity > 1 And Not $mSalvageStacks Then ContinueLoop ; dont process stacks
		 $ItemMID = MemoryRead($lItem + 44, 'long') ; modelID
		 If $ItemMID = 504 Then ContinueLoop ; Decayed Orr Emblems
		 If $ItemMID = 460 Or $ItemMID = 461 Then ContinueLoop ; White Mantle Emblem and Badge
		 If Keepers($ItemMID) Then ContinueLoop ; dont salvage keepers
		 $ItemRarity = GetRarity($lItem)
		 If $ItemRarity = 2624 And GetIsRareWeapon($lItem) Then ContinueLoop ; no salvaging rare weapons
		 ; Identify item if necessary and id kit available
		 If $lIdentify And GetIsUnIDed($lItem) Then
			If MemoryRead($lIDKit + 12, 'ptr') = 0 Then
			   $lIDKit = FindIDKitPtr()
			   If $lIDKit = 0 Then
				  $lIdentify = False
				  ContinueLoop
			   Else
				  $lIDKitID = MemoryRead($lIDKit, 'long')
			   EndIf
			EndIf
			Update("Identify: " & $bag & ", " & $slot)
			IdentifyItem($lItem, $lIDKitID)
			Sleep(250)
			Do
			   Sleep(250)
			Until Not GetIsUnIDed($lItem)
		 EndIf
		 ; salvage white items
		 If $ItemRarity = 2621 Then
			For $i = 1 To $lQuantity
			   If MemoryRead($lCheapKit + 12, 'ptr') = 0 Then
				  $lCheapKit = FindCheapSalvageKit()
				  If $lCheapKit = 0 Then
					 Return -1 ; no more normal salvage kits
				  Else
					 $lCheapKitID = MemoryRead($lCheapKit, 'long')
				  EndIf
			   EndIf
			   Update("Salvaging (white): " & $bag & ", " & $slot)
			   $lQuantityOld = $lQuantity
			   StartSalvage($lItem, $lCheapKitID)
			   Local $lDeadlock = TimerInit()
			   Do
				  Sleep(20)
				  $lQuantity = MemoryRead($lItem + 75, 'byte')
			   Until $lQuantity <> $lQuantityOld Or MemoryRead($lItem + 12, 'ptr') = 0 Or TimerDiff($lDeadlock) > 2500
			   Sleep(250)
			Next
		 ; salvage non-whites
		 ElseIf $ItemRarity = 2623 Or $ItemRarity = 2626 Or $ItemRarity = 2624 Then ; blue or purple or gold
			$ItemType = MemoryRead($lItem + 32, 'byte')
			; armor salvage items
			If $ItemType = 0 Then
			   $lMod = Upgrades($lItem)
			   While $lMod <> 0
				  If MemoryRead($lExpertKit + 12, 'ptr') = 0 Then
					 $lExpertKit = FindExpertSalvageKit()
					 If $lExpertKit = 0 Then
						Return -1
					 Else
						$lExpertKitID = MemoryRead($lExpertKit, 'long')
					 EndIf
				  EndIf
				  Update("Salvage (" & $lMod - 1 & "): " & $bag & ", " & $slot)
				  $lValue = MemoryRead($lExpertKit + 36, 'short')
				  StartSalvage($lItem, $lExpertKitID)
				  Sleep(100)
				  SalvageMod($lMod - 1)
				  Local $lDeadlock = TimerInit()
				  Do
					 Sleep(50)
				  Until $lValue <> MemoryRead($lExpertKit + 36, 'short') Or TimerDiff($lDeadlock) > 2500
				  Sleep(250 + GetPing())
				  $lMod = Upgrades($lItem)
			   WEnd
			; weapons
			ElseIf IsWeapon($ItemType) Then
			   $lMod = WeaponMods($lItem)
			   While $lMod <> 0
				  If MemoryRead($lExpertKit + 12, 'ptr') = 0 Then
					 $lExpertKit = FindExpertSalvageKit()
					 If $lExpertKit = 0 Then
						Return -1
					 Else
						$lExpertKitID = MemoryRead($lExpertKit, 'long')
					 EndIf
				  EndIf
				  Update("Salvage (" & $lMod - 1 & "): " & $bag & ", " & $slot)
				  $lValue = MemoryRead($lExpertKit + 36, 'short')
				  StartSalvage($lItem, $lExpertKitID)
				  Sleep(100)
				  SalvageMod($lMod - 1)
				  Local $lDeadlock = TimerInit()
				  Do
					 Sleep(50)
				  Until $lValue <> MemoryRead($lExpertKit + 36, 'short') Or TimerDiff($lDeadlock) > 2500
				  Sleep(250 + GetPing())
				  $lMod = WeaponMods($lItem)
			   WEnd
			EndIf
			Sleep(500)
			; salvage materials if item not destroyed
			If $ItemRarity <> 2624 And MemoryRead($lItem + 12, 'ptr') <> 0 Then
			   If MemoryRead($lCheapKit + 12, 'ptr') = 0 Then
				  $lCheapKit = FindCheapSalvageKit()
				  If $lCheapKit = 0 Then
					 Return -1 ; no more normal salvage kits
				  Else
					 $lCheapKitID = MemoryRead($lCheapKit, 'long')
				  EndIf
			   EndIf
			   Update("Salvage (Materials): " & $bag & ", " & $slot)
			   StartSalvage($lItem, $lCheapKitID)
			   Sleep(1000 + GetPing())
			   SalvageMaterials()
			   Local $lDeadlock = TimerInit()
			   Do
				  Sleep(20)
			   Until MemoryRead($lItem + 12, 'ptr') = 0 Or TimerDiff($lDeadlock) > 2500
			   Sleep(250 + GetPing())
			EndIf
		 EndIf
		 Sleep(500)
	  Next
   Next
EndFunc   ;==>SalvageBags

;~ Description: Salvages all items in all bags. Modified for explorable.
Func SalvageBagsExplorable()
   If CountSlots() < 2 Then Return
   Local $lSalvKitUses = 0, $lIDKitUses = 0, $lSalvKitMID
   $lSalvKit = FindSalvKitExplorable($lSalvKitUses)
   If $lSalvKit = 0 Then Return
   $lSalvKitMID = @extended
   For $bag = 1 To 4 ; inventory only
	  $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then ContinueLoop
	  For $slot = 1 To MemoryRead($lBagPtr + 32, 'long') ; slots
		 $lItem = GetItemPtrBySlot($lBagPtr, $slot)
		 If IgnoreItem($lItem) Then ContinueLoop
		 If MemoryRead($lItem + 32, 'byte') = 31 Then ContinueLoop ; scrolls
		 If MemoryRead($lItem + 75, 'byte') > 1 Then ContinueLoop ; dont process stacks in explorable
		 $ItemMID = MemoryRead($lItem + 44, 'long') ; modelID
		 If $ItemMID = 504 Then ContinueLoop ; Decayed Orr Emblems
		 If $ItemMID = 460 Or $ItemMID = 461 Then ContinueLoop ; White Mantle Emblem and Badge
		 If Keepers($ItemMID) Then ContinueLoop ; dont salvage keepers
		 $ItemRarity = GetRarity($lItem)
		 If $ItemRarity = 2624 And GetIsRareWeapon($lItem) Then ContinueLoop ; no salvaging rare weapons
		 If GetIsUnIDed($lItem) And $ItemRarity <> 2624 Then
			If $ItemRarity = 2623 Or $ItemRarity = 2626 Then ; only ID blue and purple items in explorable
			   If $lIDKitUses = 0 Then
				  $lIDKit = FindIDKitExplorable($lIDKitUses)
				  If $lIDKitUses = 0 Then ContinueLoop ; ran out of ID kits
			   EndIf
			   $lIDKitValue = MemoryRead($lIDKit + 36, 'short')
			   Update("Identify: " & $bag & ", " & $slot)
			   IdentifyItem($lItem, MemoryRead($lIDKit, 'long'))
			   $lIDKitUses -= 1
			   Sleep(250)
			   Do
				  Sleep(250)
			   Until MemoryRead($lIDKit + 36, 'short') <> $lIDKitValue Or MemoryRead($lIDKit + 12, 'ptr') = 0
			   Sleep(GetPing() + 100)
			EndIf
		 EndIf
		 If MemoryRead($lSalvKit + 12, 'ptr') = 0 Then ; check SalvageKit before salvaging
			$lSalvKit = FindSalvKitExplorable($lSalvKitUses)
			If $lSalvKit = 0 Then Return ; no more salvage kits
			$lSalvKitMID = @extended
		 EndIf
		 If $ItemRarity = 2621 Then ; white
			Update("Salvaging (white): " & $bag & ", " & $slot)
			StartSalvage($lItem, MemoryRead($lSalvKit, 'long'))
			Local $lDeadlock = TimerInit()
			Do
			   Sleep(20)
			Until MemoryRead($lItem + 12, 'ptr') = 0 Or TimerDiff($lDeadlock) > 2500
			$lSalvKitUses -= 1
			Sleep(250 + GetPing())
		 ElseIf $ItemRarity = 2623 Or $ItemRarity = 2626 Then ; blue or purple
			$ItemType = MemoryRead($lItem + 32, 'byte')
			If $ItemType = 0 And Upgrades($lItem) <> 0 Then
			   ContinueLoop
			ElseIf IsWeapon($ItemType) And WeaponMods($lItem) <> 0 Then
			   ContinueLoop
			Else
			   Update("Salvaging (" & $lSalvKitMID & "): " & $bag & ", " & $slot)
			   StartSalvage($lItem, MemoryRead($lSalvKit, 'long'))
			   Sleep(1000 + GetPing())
			   SalvageMaterials()
			   Local $lDeadlock = TimerInit()
			   Do
				  Sleep(20)
			   Until MemoryRead($lItem + 12, 'ptr') = 0 Or TimerDiff($lDeadlock) > 2500
			   $lSalvKitUses -= 1
			   Sleep(250 + GetPing())
			EndIf
		 EndIf
		 Sleep(250)
	  Next
   Next
EndFunc   ;==>SalvageBagsExplorable

;~ Description: Limits bags to inventory to work in explorable, @extended returns ModelID of Kit.
Func FindSalvKitExplorable(ByRef $aUses)
   Local $lUses = 101
   Local $lKit = 0
   Local $lKitMID = 0
   $aUses = 0
   For $bag = 1 to 4
	  Local $lBagPtr = GetBagPtr($bag)
	  Local $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
	  For $slot = 0 To MemoryRead($lBagPtr + 32, 'long') - 1
		 Local $lItemPtr = MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr')
		 If $lItemPtr = 0 Then ContinueLoop
		 Local $lItemMID = MemoryRead($lItemPtr + 44, 'long')
		 If $lItemMID = 2992 Or $lItemMID = 2993 Then
			Local $lValue = MemoryRead($lItemPtr + 36, 'short')
			$aUses =  $lValue / 2
			Return SetExtended($lItemMID, $lItemPtr)
		 EndIf
	  Next
   Next
EndFunc   ;==>FindSalvKitExplorable

;~ Description: Limits bags to inventory to work in explorable, @extended returns ModelID of Kit.
Func FindIDKitExplorable(ByRef $aUses)
   Local $lUses = 101
   Local $lKit = 0
   Local $lKitMID = 0
   $aUses = 0
   For $bag = 1 to 4
	  Local $lBagPtr = GetBagPtr($bag)
	  Local $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
	  For $slot = 0 To MemoryRead($lBagPtr + 32, 'long') - 1
		 Local $lItemPtr = MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr')
		 If $lItemPtr = 0 Then ContinueLoop
		 Local $lItemMID = MemoryRead($lItemPtr + 44, 'long')
		 Switch $lItemMID
			Case 2989
			   Local $lValue = MemoryRead($lItemPtr + 36, 'short')
			   If $lValue / 2 < $lUses Then
				  $lUses = $lValue / 2
				  $lKit = $lItemPtr
				  $lKitMID = $lItemMID
				  $aUses = $lUses
			   EndIf
			Case 5899
			   Local $lValue = MemoryRead($lItemPtr + 36, 'short')
			   If $lValue / 2.5 < $lUses Then
				  $lUses = $lValue / 2.5
				  $lKit = $lItemPtr
				  $lKitMID = $lItemMID
				  $aUses = $lUses
			   EndIf
			Case Else
			   ContinueLoop
		 EndSwitch
	  Next
   Next
   Return SetExtended($lKitMID, $lKit)
EndFunc   ;==>FindIDKitExplorable

;~ Description: Ignore these items while processing inventory bags.
Func IgnoreItem($aItemPtr)
   If $aItemPtr = 0 Then Return True ; not a valid item
   If MemoryRead($aItemPtr + 24, 'ptr') <> 0 Then Return True ; customized
   If MemoryRead($aItemPtr + 76, 'byte') <> 0 Then Return True ; equipped
   If MemoryRead($aItemPtr + 36, 'short') = 0 Then Return True ; value 0
   If MemoryRead($aItemPtr + 12, 'ptr') = 0 Then Return True ; not in a bag
   Switch MemoryRead($aItemPtr + 32, 'byte')
	  Case 11 ; Materials
		 Return True
	  Case 8 ; Upgrades
		 Return True
	  Case 9 ; Usable
		 Return True
	  Case 10 ; Dyes
		 Return True
	  Case 29 ; Kits
		 Return True
	  Case 34 ; Minipet
		 Return True
	  Case 18 ; Keys
		 Return True
   EndSwitch
EndFunc   ;==>IgnoreItem

;~ Description: Returns item ptr of expert salvage kit in inventory with least uses.
Func FindExpertSalvageKit($aStart = 1, $aFinish = 16)
   Local $lUses = 101
   Local $lKit = 0
   For $bag = $aStart to $aFinish
	  Local $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then ContinueLoop
	  Local $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
	  For $slot = 0 To MemoryRead($lBagPtr + 32, 'long') - 1
		 Local $lItemPtr = MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr')
		 If $lItemPtr = 0 Then ContinueLoop
		 Local $lItemMID = MemoryRead($lItemPtr + 44, 'long')
		 If $lItemMID = 2991 Or $lItemMID = 5900 Then Return $lItemPtr
		 Switch $lItemMID
			Case 2991
			   Local $lValue = MemoryRead($lItemPtr + 36, 'short')
			   If $lValue / 8 < $lUses Then
				  $lUses = $lValue / 8
				  $lKit = $lItemPtr
			   EndIf
			Case 5900
			   Local $lValue = MemoryRead($lItemPtr + 36, 'short')
			   If $lValue / 10 < $lUses Then
				  $lUses = $lValue / 10
				  $lKit = $lItemPtr
			   EndIf
		 EndSwitch
	  Next
   Next
   Return $lKit
EndFunc   ;==>FindExpertSalvageKit

;~ Description: Returns item ptr of expert salvage kit in inventory with least uses.
Func FindCheapSalvageKit($aStart = 1, $aFinish = 16)
   Local $lUses = 101
   Local $lKit = 0
   For $bag = $aStart to $aFinish
	  Local $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then ContinueLoop
	  Local $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
	  For $slot = 0 To MemoryRead($lBagPtr + 32, 'long') - 1
		 Local $lItemPtr = MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr')
		 If $lItemPtr = 0 Then ContinueLoop
		 Local $lItemMID = MemoryRead($lItemPtr + 44, 'long')
		 If $lItemMID = 2992 Or $lItemMID = 2993 Then Return $lItemPtr
		 Switch $lItemMID
			Case 2992, 2993
			   Local $lValue = MemoryRead($lItemPtr + 36, 'short')
			   If $lValue / 2 < $lUses Then
				  $lUses = $lValue / 2
				  $lKit = $lItemPtr
			   EndIf
		 EndSwitch
	  Next
   Next
   Return $lKit
EndFunc   ;==>FindExpertSalvageKit

;~ Description: Returns item ptr of ID kit in inventory.
Func FindIDKitPtr($aStart = 1, $aFinish = 16)
   Local $lUses = 101
   Local $lKit = 0
   For $bag = $aStart to $aFinish
	  Local $lBagPtr = GetBagPtr($bag)
	  Local $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
	  For $slot = 0 To MemoryRead($lBagPtr + 32, 'long') - 1
		 Local $lItemPtr = MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr')
		 If $lItemPtr = 0 Then ContinueLoop
		 Local $lItemMID = MemoryRead($lItemPtr + 44, 'long')
		 If $lItemMID = 2989 Or $lItemMID = 5899 Then Return $lItemPtr
	  Next
   Next
EndFunc   ;==>FindIDKitPtr

;~ Description: Returns amount of available expert salvage kit uses to salvage mods.
Func ExpertSalvageUses($aStart = 1, $aFinish = 16)
   Local $lCount = 0
   For $bag = $aStart to $aFinish
	  Local $lBagPtr = GetBagPtr($bag)
	  Local $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
	  For $slot = 0 To MemoryRead($lBagPtr + 32, 'long') - 1
		 Local $lItemPtr = MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr')
		 If $lItemPtr = 0 Then ContinueLoop
		 Local $lItemMID = MemoryRead($lItemPtr + 44, 'long')
		 Switch $lItemMID
			Case 2991
			   $lCount += MemoryRead($lItemPtr + 36, 'short') / 8
			Case 5900
			   $lCount += MemoryRead($lItemPtr + 36, 'short') / 10
		 EndSwitch
	  Next
   Next
   Return $lCount
EndFunc   ;==>ExpertSalvageUses

;~ Description: Returns true if item is a weapon.
Func IsWeapon($aType)
   Switch $aType
	  Case 2,5,12,15,22,24,26,27,32,35,36
		 Return True
	  Case Else
		 Return False
   EndSwitch
EndFunc   ;==>IsWeapon

;~ Description: Returns 1 if item contains insignia to keep, 2 if item contains rune to keep.
Func Upgrades($aItemPtr)
   Local $lInsigniaArray[8] = [ _
						'FB010824', _ ; Sentinel's Insignia
						'0A020824', _ ; Bloodstained Insignia
						'E1010824', _ ; Nightstalker's Insignia
						'04020824', _ ; Shaman's Insignia
	  					'02020824', _ ; Windwalker Insignia
	  					'07020824', _ ; Centurion's Insignia
	  					'E6010824', _ ; Survivor Insignia
	  					'E9010824'] ; Blessed Insignia
   Local $lRuneArray[17] = [ _
						'0111E821', _ ; Warrior Rune of Minor Strength
						'010DE821', _ ; Monk Rune of Minor Healing Prayers
						'0110E821', _ ; Monk Rune of Minor Divine Favor
						'0106E821', _ ; Necromancer Rune of Minor Soul Reaping
						'0100E821', _ ; Mesmer Rune of Minor Fast Casting
						'0302E8217701', _ ; Mesmer Rune of Superior Domination Magic
						'010CE821', _ ; Elementalist Rune of Minor Energy Storage
						'030AE8217B01', _ ; Elementalist Rune of Superior Fire Magic
						'0124E821', _ ; Ritualist Rune of Minor Spawning Power
	  					'0322E8218102', _ ; Ritualist Rune of Superior Channeling Magic
	  					'012CE821', _ ; Dervish Rune of Minor Mysticism
	  					'0129E821', _ ; Dervish Rune of Minor Scythe Mastery
	  					'C202E827', _ ; Rune of Minor Vigor
	  					'000A4823', _ ; Rune of Vitae
	  					'0200D822', _ ; Rune of Attunement
	  					'C202E927', _ ; Rune of Major Vigor
	  					'C202EA27'] ; Rune of Superior Vigor
   $lModStruct = MemoryReadStruct($aItemPtr + 16, 'ptr;long')
   $lMod = MemoryRead(DllStructGetData($lModStruct, 1), 'byte[' & DllStructGetData($lModStruct, 2) * 4 & ']')
   For $i = 0 To 7
	  If StringInStr($lMod, $lInsigniaArray[$i]) <> 0 Then Return 1
   Next
   For $i = 0 To 16
	  If StringInStr($lMod, $lRuneArray[$i]) <> 0 Then Return 2
   Next
EndFunc   ;==>Upgrades

;~ Description: Returns 3 for inscription, 1 and 2 for weapon mods.
Func WeaponMods($aItemPtr)
   Local $lPrefixArray[4][2] = [ _
						['1414F823',5], _ ; Sundering (bow)
						['01001825',26], _ ; Zealous (sword)
						['01001825',32], _ ; Zealous (daggers)
						['01001825',35]] ; Zealous (scythe)
   Local $lSuffixArray[6][2] = [ _
						['05000821',5], _ ; of defense (bow)
						['1400B822',26], _ ; perfect enchanting (staff)
						['1400B822',27], _ ; perfect enchanting (sword)
						['1400B822',32], _ ; perfect enchanting (daggers)
						['1400B822',35], _ ; perfect enchanting (scythe)
						['001E4823',24]] ; of fortitude (shield)
   Local $lInscriptionArray[3] = [ _
						'0A0118A1', _ ; +10 armor vs piercing dmg
						'0500D822', _ ; +5 energy inscription
						'0500B820'] ; +dmg, -energy Brawn over Brains
   $lModStruct = MemoryReadStruct($aItemPtr + 16, 'ptr;long')
   $lMod = MemoryRead(DllStructGetData($lModStruct, 1), 'byte[' & DllStructGetData($lModStruct, 2) * 4 & ']')
   $lType = MemoryRead($aItemPtr + 32, 'byte')
   For $i = 0 To 1
	  If StringInStr($lMod, $lPrefixArray[$i][0]) <> 0 And $lType = $lPrefixArray[$i][1] Then Return 1
   Next
   For $i = 0 To 1
	  If StringInStr($lMod, $lSuffixArray[$i][0]) <> 0 And $lType = $lSuffixArray[$i][1] Then Return 2
   Next
   For $i = 0 To 0
	  If StringInStr($lMod, $lInscriptionArray[$i]) <> 0 Then Return 3
   Next
EndFunc   ;==>WeaponMods

;~ Description: Sell items.
Func Sell()
   For $bag = 1 to 4 ; inventory only
	  $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then ContinueLoop
	  For $slot = 1 to MemoryRead($lBagPtr + 32, 'long')
		 $lItemPtr = GetItemPtrBySlot($lBagPtr, $slot)
		 If $lItemPtr = 0 Then ContinueLoop
		 If IgnoreItem($lItemPtr) Then ContinueLoop
		 $lItemMID = MemoryRead($lItemPtr + 44, 'long')
		 If Keepers($lItemMID) Then ContinueLoop
		 If StackableItems($lItemMID) Then ContinueLoop
		 If GetRarity($lItemPtr) = 2624 And GetIsRareWeapon($lItemPtr) Then ContinueLoop
		 If GetIsUnIDed($lItemPtr) Then IdentifyItem($lItemPtr)
		 Update("Sell Item: " & $bag & ", " & $slot)
		 SellItem($lItemPtr)
		 Sleep(500)
	  Next
   Next
EndFunc   ;==>Sell

;~ Description: Sell materials.
Func SellMaterials($aRare = False)
   For $bag = 1 to 4 ; inventory only
	  $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then ContinueLoop
	  For $slot = 1 to MemoryRead($lBagPtr + 32, 'long')
		 $lItemPtr = GetItemPtrBySlot($lBagPtr, $slot)
		 If $lItemPtr = 0 Then ContinueLoop
		 If MemoryRead($lItemPtr + 32, 'byte') <> 11 Then ContinueLoop ; not materials
		 $lItemMID = MemoryRead($lItemPtr + 44, 'long')
		 $lMatType = CheckMaterial($lItemMID)
		 If $aRare Then
			If $lMatType = 2 Then
			   For $i = 1 To MemoryRead($lItemPtr + 75, 'byte')
				  TraderRequestSell($lItemPtr)
				  Update("Sell rare materials: " & $bag & ", " & $slot)
				  Sleep(250)
				  TraderSell()
			   Next
			EndIf
		 Else
			If $lMatType = 1 Then
			   For $i = 1 To Floor(MemoryRead($lItemPtr + 75, 'byte') / 10)
				  Update("Sell materials: " & $bag & ", " & $slot)
				  TraderRequestSell($lItemPtr)
				  Sleep(250)
				  TraderSell()
			   Next
			EndIf
		 EndIf
	  Next
   Next
EndFunc   ;==>SellMaterials

;~ Description: Returns 1 for normal materials and 2 for rare materials.
;~ 0 if ModelID is not listed or mat should be ignored.
Func CheckMaterial($aModelID)
   Switch $aModelID
	  Case 954, 925 		; Chitin, Cloth
		 Return 1
	  Case 929, 933, 934	; Dust, Feather, Fibers
		 Return $mDustFeatherFiber
	  Case 955, 948, 921	; Granite, Iron, Bones
		 Return $mGraniteIronBone
	  Case 940, 946, 953	; Scale, Tanned Hide, Wood Plank
		 Return 1
	  Case 928, 926, 927	; Silk, Linen, Damask
		 Return 2
	  Case 931, 932, 923	; Monstrous Eye, Monstrous Fang, Monstrous Claw
		 Return 2
	  Case 922, 950, 949	; Charcoal, Deldrimor, Steel Ingot
		 Return 2
	  Case 951, 952, 956	; Parchment, Vellum, Spiritwood
		 Return 2
	  Case 937, 935, 938	; Ruby, Diamond, Sapphire
		 Return 0
	  Case 936, 945, 930	; Onyx, Obsidian Shard, Ectoplasm
		 Return 0
	  Case 941, 942, 943	; Fur, Leather Square, Elonian Leather Square
		 Return 2
	  Case 944, 939		 	; Vial of Ink, Glass Vial
		 Return 2
	  Case 6532, 6533 		; Amber, Jadeite
		 Return 0
   EndSwitch
EndFunc   ;==>CheckMaterial

;~ Description: Sell runes and insignias.
Func SellUpgrades()
   For $bag = 1 to 4 ; inventory only
	  $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then ContinueLoop
	  For $slot = 1 to MemoryRead($lBagPtr + 32, 'long')
		 $lItemPtr = GetItemPtrBySlot($lBagPtr, $slot)
		 If $lItemPtr = 0 Then ContinueLoop
		 If MemoryRead($lItemPtr + 32, 'byte') <> 8 Then ContinueLoop ; not an upgrade
		 If IsRuneOrInsignia(MemoryRead($lItemPtr + 44, 'long')) = 0 Then ContinueLoop ; neither rune, nor insignia
		 TraderRequestSell($lItemPtr)
		 Sleep(250)
		 Update("Sell Upgrade: " & $bag & ", " & $slot)
		 TraderSell()
	  Next
   Next
EndFunc   ;==>SellUpgrades

;~ Description: Sell all dyes to Dye Trader except for black and white.
Func SellDyes()
   For $bag = 1 to 4 ; inventory only
	  $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then ContinueLoop
	  For $slot = 1 to MemoryRead($lBagPtr + 32, 'long')
		 $lItemPtr = GetItemPtrBySlot($lBagPtr, $slot)
		 If $lItemPtr = 0 Then ContinueLoop
		 $lItemMID = MemoryRead($lItemPtr + 44, 'long')
		 If $lItemMID <> 146 Then ContinueLoop ; not a dye
		 If $mBlackWhite Then
			$lItemExtraID = MemoryRead($lItemPtr + 34, 'short')
			If $lItemExtraID = 10 Or $lItemExtraID = 12 Then ContinueLoop ; black or white
		 EndIf
		 For $i = 1 To MemoryRead($lItemPtr + 75, 'byte')
			Update("Sell Dye: " & $bag & ", " & $slot)
			TraderRequestSell($lItemPtr)
			Sleep(250)
			TraderSell()
		 Next
	  Next
   Next
EndFunc   ;==>SellDyes

;~ Description: Tries to make room by selling in different order and selling stuff that wasnt expressly forbidden / defined in Junk().
Func ClearInventorySpace($aMapID)
   ; first stage: sell dyes, runes, rare mats, mats, scrolls to try to make room
   If GoToMerchant(GetDyeTrader($aMapID)) <> 0 Then SellDyes()
   If GoToMerchant(GetRuneTrader($aMapID)) <> 0 Then SellUpgrades()
   If GoToMerchant(GetMaterialTrader($aMapID)) <> 0 Then SellMaterials()
   If GoToMerchant(GetScrollTrader($aMapID)) <> 0 Then SellScrolls()
   If GoToMerchant(GetRareMaterialTrader($aMapID)) <> 0 Then SellMaterials(True)
   $lSlots = CountSlots()
   If $lSlots > 3 Then Return True ; enough room to proceed as planned
   ; second stage: try selling identified purple and gold and everything else thats not expressly forbidden
   GoToMerchant(GetMerchant($aMapID))
   For $bag = 1 to 4 ; inventory only
	  $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then ContinueLoop
	  For $slot = 1 to MemoryRead($lBagPtr + 32, 'long')
		 $lItemPtr = GetItemPtrBySlot($lBagPtr, $slot)
		 If $lItemPtr = 0 Then ContinueLoop
		 If MemoryRead($lItemPtr + 24, 'ptr') <> 0 Then ContinueLoop ; customized
		 If MemoryRead($lItemPtr + 76, 'byte') <> 0 Then ContinueLoop ; equipped
		 If MemoryRead($lItemPtr + 36, 'short') = 0 Then ContinueLoop ; value 0
		 If MemoryRead($lItemPtr + 12, 'ptr') = 0 Then ContinueLoop ; not in a bag
		 $lItemMID = MemoryRead($lItemPtr + 44, 'long')
		 If Junk($lItemMID) Then
			Update("Sell Item: " & $bag & ", " & $slot)
			SellItem($lItemPtr)
			Sleep(500)
			$lSlots += 1
			If $lSlots > 3 Then Return True
			ContinueLoop
		 EndIf
		 If Keepers($lItemMID) Then ContinueLoop
		 If StackableItems($lItemMID) Then ContinueLoop
		 $lItemRarity = GetRarity($lItemPtr)
		 If GetIsUnIDed($lItemPtr) Then
			If $lItemRarity = 2624 Or $lItemRarity = 2626 Then ; only gold and purple
			   $lIDKit = FindIDKitPtr()
			   $lIDKitID = MemoryRead($lIDKit, 'long')
			   If $lIDKitID = 0 Then ContinueLoop
			   Update("Identify: " & $bag & ", " & $slot)
			   IdentifyItem($lItemPtr, $lIDKitID)
			   Sleep(250)
			   Do
				  Sleep(250)
			   Until Not GetIsUnIDed($lItemPtr)
			Else
			   ContinueLoop
			EndIf
		 EndIf
		 Switch MemoryRead($lItemPtr + 32, 'byte')
			Case 0
			   If Upgrades($lItemPtr) Then ContinueLoop
			Case 2, 5, 12, 15, 19, 22, 24, 26, 27, 32, 35, 36
			   If $lItemRarity = 2621 Then ContinueLoop ; try to keep whites for salvaging
			   If $mRarityGreen And $lItemRarity = 2627 Then ContinueLoop ; dont sell greens
			   If WeaponMods($lItemPtr) Then ContinueLoop
			Case 4, 7, 13, 16, 19 ; no selling armor pieces
			   ContinueLoop
			Case 11 ; Materials
			   ContinueLoop
			Case 8 ; Upgrades
			   ContinueLoop
			Case 9 ; Usable
			   ContinueLoop
			Case 10 ; Dyes
			   ContinueLoop
			Case 29 ; Kits
			   ContinueLoop
			Case 34 ; Minipet
			   ContinueLoop
			Case 18 ; Keys
			   Switch $lItemMID
				  Case 5962 ; Shiverpeak
					 ContinueLoop
				  Case 5963 ; Darkstone
					 ContinueLoop
				  Case 5961 ; Miners Key
					 ContinueLoop
				  Case 6535 ; Kurzick
					 ContinueLoop
				  Case 6536 ; Stoneroot
					 ContinueLoop
				  Case 6538 ; Luxon
					 ContinueLoop
				  Case 6539 ; Deep Jade
					 ContinueLoop
				  Case 6534 ; Forbidden
					 ContinueLoop
				  Case 15558 ; Vabbian
					 ContinueLoop
				  Case 15556 ; Ancient Elonian
					 ContinueLoop
				  Case 15560 ; Margonite
					 ContinueLoop
				  Case 19174 ; Demonic
					 ContinueLoop
				  Case 5882 ; Phantom
					 ContinueLoop
				  Case 5971 ; Obsidian
					 ContinueLoop
				  Case 22751 ; Lockpick
					 ContinueLoop
			   EndSwitch
		 EndSwitch
		 Update("Sell Item: " & $bag & ", " & $slot)
		 SellItem($lItemPtr)
		 Sleep(500)
		 $lSlots += 1
		 If $lSlots > 3 Then Return True
	  Next
   Next
   Return $lSlots > 3
EndFunc

;~ Description: Contains all modelIDs of items that could be sold if storage space is low. Use with caution.
Func Junk($aModelID)
   Switch $aModelID
	  Case 460 ; White Mantle Emblem
		 Return True
	  Case 461 ; White Mantle Badge
		 Return True
	  Case 504 ; Decayed Orr Emblem
		 Return True
   EndSwitch
EndFunc

;~ Description: Sell all gold rarity scrolls to scroll trader.
Func SellScrolls()
   For $bag = 1 to 4 ; inventory only
	  $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then ContinueLoop
	  For $slot = 1 to MemoryRead($lBagPtr + 32, 'long')
		 $lItemPtr = GetItemPtrBySlot($lBagPtr, $slot)
		 If $lItemPtr = 0 Then ContinueLoop
		 If MemoryRead($lItemPtr + 32, 'byte') <> 31 Then ContinueLoop ; not a scroll
		 If GetRarity($lItemPtr) <> 2624 Then ContinueLoop ; not a scrolltrader scroll
		 TraderRequestSell($lItemPtr)
		 Sleep(250)
		 Update("Sell Scroll: " & $bag & ", " & $slot)
		 TraderSell()
	  Next
   Next
EndFunc   ;==>SellScrolls

;~ Description: Go to merchant and co, if playernumber wasnt found go to xunlai chest and try again.
Func GoToMerchant($aPlayernumber)
   ; first try
   $lAgentArray = GetAgentPtrArray()
   For $i = 1 To $lAgentArray[0]
	  If MemoryRead($lAgentArray[$i] + 244, 'word') = $aPlayernumber Then
		 GoToNPC($lAgentArray[$i])
		 Sleep(500)
		 Return Dialog(0x7F)
	  EndIf
   Next
   ; merchant wasnt found, next try, but first... go to chest
   For $i = 1 To $lAgentArray[0]
	  If MemoryRead($lAgentArray[$i] + 244, 'word') = 4991 Then
		 GoToNPC($lAgentArray[$i])
		 ExitLoop
	  EndIf
   Next
   ; aaaaand... try again to find merchant
   $lAgentArray = GetAgentPtrArray()
   For $i = 1 To $lAgentArray[0]
	  If MemoryRead($lAgentArray[$i] + 244, 'word') = $aPlayernumber Then
		 GoToNPC($lAgentArray[$i])
		 Sleep(500)
		 Return Dialog(0x7F)
	  EndIf
   Next
EndFunc   ;==>GoToMerchant

;~ Description: Return merchant depending on MapID.
Func GetMerchant($aMapID)
   Switch $aMapID
	  Case 4, 5, 6, 52, 176, 177, 178, 179 ; proph gh
		 Return 209
	  Case 275, 276, 359, 360, 529, 530, 537, 538 ; factions and nf gh
		 Return 196
	  Case 10, 11, 12, 139, 141, 142, 49, 857
		 Return 2036
	  Case 109, 120, 154
		 Return 1993
	  Case 116, 117, 118, 152, 153, 38
		 Return 1994
	  Case 122, 35
		 Return 2136
	  Case 123, 124
		 Return 2137
	  Case 129, 348, 390
		 Return 3402
	  Case 130, 218, 230, 287, 349, 388
		 Return 3403
	  Case 131, 21, 25, 36
		 Return 2086
	  Case 132, 135, 28, 29, 30, 32, 39, 40
		 Return 2101
	  Case 133, 155, 156, 157, 158, 159, 206, 22, 23, 24
		 Return 2107
	  Case 134, 81
		 Return 2011
	  Case 136, 137, 14, 15, 16, 19, 57, 73
		 Return 1989
	  Case 138
		 Return 1975
	  Case 193, 234, 278, 288, 391
		 Return 3618
	  Case 194, 213, 214, 225, 226, 242, 250, 283, 284, 291, 292
		 Return 3275
	  Case 216, 217, 249, 251
		 Return 3271
	  Case 219, 224, 273, 277, 279, 289, 297, 350, 389
		 Return 3617
	  Case 220, 274, 51
		 Return 3273
	  Case 222, 272, 286, 77
		 Return 3401
	  Case 248
		 Return 1207
	  Case 303
		 Return 3272
	  Case 376, 378, 425, 426, 477, 478
		 Return 5385
	  Case 381, 387, 421, 424, 427, 554
		 Return 5386
	  Case 393, 396, 403, 414, 476
		 Return 5666
	  Case 398, 407, 428, 433, 434, 435
		 Return 5665
	  Case 431
		 Return 4721
	  Case 438, 545
		 Return 5621
	  Case 440, 442, 469, 473, 480, 494, 496
		 Return 5613
	  Case 450, 559
		 Return 4989
	  Case 474, 495
		 Return 5614
	  Case 479, 487, 489, 491, 492, 502, 818
		 Return 4720
	  Case 555
		 Return 4988
	  Case 624
		 Return 6758
	  Case 638
		 Return 6060
	  Case 639, 640
		 Return 6757
	  Case 641
		 Return 6063
	  Case 642
		 Return 6047
	  Case 643, 645, 650
		 Return 6383
	  Case 644
		 Return 6384
	  Case 648
		 Return 6589
	  Case 652
		 Return 6231
	  Case 675
		 Return 6190
	  Case 808
		 Return 7448
	  Case 814
		 Return 104
   EndSwitch
EndFunc   ;==>GetMerchant

;~ Description: Return material trader depending on MapID.
Func GetMaterialTrader($aMapID)
   Switch $aMapID
	  Case 4, 5, 6, 52, 176, 177, 178, 179 ; proph gh
		 Return 204
	  Case 275, 276, 359, 360, 529, 530, 537, 538 ; factions and nf gh
		 Return 191
	  Case 109, 49, 81
		 Return 2017
	  Case 193
		 Return 3624
	  Case 194, 242, 857
		 Return 3285
	  Case 250
		 Return 3286
	  Case 376
		 Return 5391
	  Case 398
		 Return 5671
	  Case 414
		 Return 5674
	  Case 424
		 Return 5392
	  Case 433
		 Return 5672
	  Case 438
		 Return 5624
	  Case 491
		 Return 4726
	  Case 492
		 Return 4727
	  Case 638
		 Return 6763
	  Case 640
		 Return 6764
	  Case 641
		 Return 6065
	  Case 642
		 Return 6050
	  Case 643
		 Return 6389
	  Case 644
		 Return 6390
	  Case 652
		 Return 6233
	  Case 77
		 Return 3415
	  Case 808
		 Return 7452
	  Case 818
		 Return 4729
   EndSwitch
EndFunc   ;==>GetMaterialTrader

;~ Description: Return rare material trader depending on MapID.
Func GetRareMaterialTrader($aMapID)
   Switch $aMapID
	  Case 4, 5, 6, 52, 176, 177, 178, 179 ; proph gh
		 Return 205
	  Case 275, 276, 359, 360, 529, 530, 537, 538 ; factions and nf gh
		 Return 192
	  Case 109
		 Return 2003
	  Case 193
		 Return 3627
	  Case 194, 250, 857
		 Return 3288
	  Case 242
		 Return 3287
	  Case 376
		 Return 5394
	  Case 398, 433
		 Return 5673
	  Case 414
		 Return 5674
	  Case 424
		 Return 5393
	  Case 438
		 Return 5619
	  Case 49
		 Return 2044
	  Case 491, 818
		 Return 4729
	  Case 492
		 Return 4728
	  Case 638
		 Return 6766
	  Case 640
		 Return 6765
	  Case 641
		 Return 6066
	  Case 642
		 Return 6051
	  Case 643
		 Return 6392
	  Case 644
		 Return 6391
	  Case 652
		 Return 6234
	  Case 77
		 Return 3416
	  Case 81
		 Return 2089
   EndSwitch
EndFunc   ;==>GetRareMaterialTrader

;~ Description: Return rune trader depending on MapID.
Func GetRuneTrader($aMapID)
   Switch $aMapID
	  Case 4, 5, 6, 52, 176, 177, 178, 179 ; proph gh
		 Return 203
	  Case 275, 276, 359, 360, 529, 530, 537, 538 ; factions and nf gh
		 Return 190
	  Case 109, 814
		 Return 2005
	  Case 193
		 Return 3630
	  Case 194, 242, 250
		 Return 3291
	  Case 248, 857
		 Return 1981
	  Case 396
		 Return 5678
	  Case 414
		 Return 5677
	  Case 438
		 Return 5626
	  Case 477
		 Return 5396
	  Case 487
		 Return 4732
	  Case 49
		 Return 2045
	  Case 502
		 Return 4733
	  Case 624
		 Return 6770
	  Case 640
		 Return 6769
	  Case 642
		 Return 6052
	  Case 643, 645
		 Return 6395
	  Case 644
		 Return 6396
	  Case 77
		 Return 3421
	  Case 808
		 Return 7456
	  Case 81
		 Return 2091
	  Case 818
		 Return 4711
   EndSwitch
EndFunc   ;==>GetRuneTrader

;~ Description: Return dye trader depending on MapID.
Func GetDyeTrader($aMapID)
   Switch $aMapID
	  Case 4, 5, 6, 52, 176, 177, 178, 179 ; proph gh
		 Return 206
	  Case 275, 276, 359, 360, 529, 530, 537, 538 ; factions and nf gh
		 Return 193
	  Case 109, 49, 81, 857
		 Return 2016
	  Case 193
		 Return 3623
	  Case 194, 242
		 Return 3284
	  Case 250
		 Return 3283
	  Case 286
		 Return 3408
	  Case 381, 477
		 Return 5389
	  Case 403
		 Return 5669
	  Case 414
		 Return 5670
	  Case 640
		 Return 6762
	  Case 642
		 Return 6049
	  Case 644
		 Return 6388
	  Case 77
		 Return 3407
	  Case 812
		 Return 2113
	  Case 818
		 Return 4725
   EndSwitch
EndFunc   ;==>GetDyeTrader

;~ Description: Return scroll trader depending on MapID.
Func GetScrollTrader($aMapID)
   Switch $aMapID
	  Case 4, 5, 6, 52, 176, 177, 178, 179 ; proph gh
		 Return 207
	  Case 275, 276, 359, 360, 529, 530, 537, 538 ; factions and nf gh
		 Return 194
	  Case 109
		 Return 2004
	  Case 193
		 Return 3629
	  Case 194
		 Return 3289
	  Case 287
		 Return 3419
	  Case 396, 414
		 Return 5675
	  Case 426, 857
		 Return 5398
	  Case 442, 480
		 Return 5627
	  Case 49
		 Return 2046
	  Case 624
		 Return 6767
	  Case 638
		 Return 6062
	  Case 639, 640
		 Return 6768
	  Case 643, 644
		 Return 6393
	  Case 645
		 Return 6394
	  Case 77
		 Return 3418
	  Case 808
		 Return 7454
   EndSwitch
EndFunc   ;==>GetScrollTrader