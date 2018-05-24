#include-once

#Region Ptr
#Region Items
;~ Description: Returns PtrArray of an item.
Func GetItemPtrArray($aItemID)
   Local $lOffset[6] = [0, 0x18, 0x40, 0xB8, 0x4 * $aItemID, 0]
   Local $lItemStructAddress = MemoryReadPtr($mBasePointer, $lOffset, 'ptr')
   Return $lItemStructAddress
EndFunc   ;==>GetItemPtrArray

;~ Description: Returns ptr of an item.
Func GetItemPtr($aItemID)
   Local $lOffset[5] = [0, 0x18, 0x40, 0xB8, 0x4 * $aItemID]
   Local $lItemStructAddress = MemoryReadPtr($mBasePointer, $lOffset, 'ptr')
   Return $lItemStructAddress[1]
EndFunc   ;==>GetItemPtr

;~ Description: Returns Itemptr by Bag- and Slotnumber.
Func GetItemPtrBySlot($aBag, $aSlot)
   If IsPtr($aBag) Then
	  $lBagPtr = $aBag
   Else
	  If $aBag < 1 Or $aBag > 17 Then Return 0
	  If $aSlot < 1 Or $aSlot > GetMaxSlots($aBag) Then Return 0
	  Local $lBagPtr = GetBagPtr($aBag)
   EndIf
   Local $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
   Return MemoryRead($lItemArrayPtr + 4 * ($aSlot - 1), 'ptr')
EndFunc   ;==>GetItemPtrBySlot

;~ Description: Returns Itemptr by agentid.
Func GetItemPtrByAgentID($aAgentID)
   Local $lOffset[4] = [0, 0x18, 0x40, 0xC0]
   Local $lItemArraySize = MemoryReadPtr($mBasePointer, $lOffset)
   Local $lItemPtr, $lItemID
   For $lItemID = 1 To $lItemArraySize[1]
	  $lItemPtr = GetItemPtr($lItemID)
	  $lAgentID = MemoryRead($lItemPtr + 4, 'long')
	  If $lAgentID = $aAgentID Then
		 $ItemPtr = GetItemPtr($lItemID)
		 Return $ItemPtr
	  EndIf
   Next
EndFunc   ;==>GetItemPtrByAgentID

;~ Description: Returns Item ptr via ModelID.
Func GetItemPtrByModelID($aModelID, $aBagsOnly = False)
   Local $lOffset[4] = [0, 0x18, 0x40, 0xC0]
   Local $lItemArraySize = MemoryReadPtr($mBasePointer, $lOffset)
   Local $lItemPtr, $lItemID
   For $lItemID = 1 To $lItemArraySize[1]
	  $lItemPtr = GetItemPtr($lItemID)
	  If MemoryRead($lItemPtr + 44, 'long') = $aModelID Then
		 If Not $aBagsOnly Then Return $lItemPtr
		 If MemoryRead($lItemPtr + 12, 'ptr') = 0 Then ContinueLoop
		 Return $lItemPtr
	  EndIf
   Next
EndFunc   ;==>GetItemPtrByModelID

;~ Description: Returns agentID of item on the ground with ModelID.
Func GetAgentIDByModelID($aModelID)
   Local $lOffset[4] = [0, 0x18, 0x40, 0xC0]
   Local $lItemArraySize = MemoryReadPtr($mBasePointer, $lOffset)
   Local $lOffset[5] = [0, 0x18, 0x40, 0xB8, 0]
   Local $lItemPtr, $lItemID
   For $lItemID = 1 To $lItemArraySize[1]
	  $lOffset[4] = $lItemID * 0x4
	  $lItemPtr = MemoryReadPtr($mBasePointer, $lOffset, 'ptr')
	  If MemoryRead($lItemPtr[1] + 44, 'long') = $aModelID Then
		 $lAgentID = MemoryRead($lItemPtr[1] + 4, 'long')
		 If $lAgentID <> 0 Then Return $lAgentID
	  EndIf
   Next
EndFunc

;~ Description: Returns first itemptr in Bags with correct ModelID.
;~ Bags to be searched are stored in $aBagNrArray, with first Element being the amount of bags.
Func GetBagItemPtrByModelID($aModelID, ByRef Const $aBagNumberArray)
   Local $lLastQuantity = 0
   Local $lReturn = 0
   For $i = 1 to $aBagNumberArray[0]
	  Local $lBagPtr = GetBagPtr($aBagNumberArray[$i])
	  Local $lSlots = MemoryRead($lBagPtr + 32, 'long')
	  For $slot = 1 To $lSlots
		 Local $lItemPtr = GetItemPtrBySlot($lBagPtr, $slot)
		 If MemoryRead($lItemPtr + 44, 'long') = $aModelID Then Return $lItemPtr
	  Next
   Next
EndFunc   ;==>GetBagItemPtrByModelID
#EndRegion Items

#Region Bags
;~ Description: Returns ptr of an inventory bag.
Func GetBagPtr($aBagNumber)
   Local $lOffset[5] = [0, 0x18, 0x40, 0xF8, 0x4 * $aBagNumber]
   Local $lItemStructAddress = MemoryReadPtr($mBasePointer, $lOffset, 'ptr')
   Return $lItemStructAddress[1]
EndFunc   ;==>GetBagPtr

;~ Description: Returns array with existing bag's ptrs, first entry is amount of existing bags.
Func GetExistingBagPtrArray()
   Local $lBagArray[18]
   Local $lBagCount = 0
   For $i = 1 to 17
	  $lBagPtr = GetBagPtr($i)
	  If $lBagPtr <> 0 Then
		 $lBagCount += 1
		 $lBagArray[$lBagCount] = $lBagPtr
	  EndIf
   Next
   $lBagArray[0] = $lBagCount
   ReDim $lBagArray[$lBagCount+1]
   Return $lBagArray
EndFunc   ;==>GetExistingBagPtrArray
#EndRegion Bags
#EndRegion

#Region Inventory and Storage
;~ Description: Returns amount of slots of bag.
Func GetMaxSlots($aBag)
   If IsPtr($aBag) Then
	  Return MemoryRead($aBag + 32, 'long')
   Else
	  Return MemoryRead(GetBagPtr($aBag) + 32, 'long')
   EndIf
EndFunc   ;==>GetMaxSlots

;~ Description: Returns amount of slots available to character.
Func GetMaxTotalSlots()
   Local $SlotCount = 0
   For $Bag = 1 to 5
	  Local $lBagPtr = GetBagPtr($Bag)
	  $SlotCount += MemoryRead($lBagPtr + 32, 'long')
   Next
   For $Bag = 8 to 17
	  Local $lBagPtr = GetBagPtr($Bag)
	  $SlotCount += MemoryRead($lBagPtr + 32, 'long')
   Next
   Return $SlotCount
EndFunc   ;==>GetMaxTotalSlots

;~ Description: Returns first empty slotnumber found or, if no empty slot is found, returns 0.
Func FindEmptySlot($aBagIndex)
   If IsPtr($aBagIndex) <> 0 Then
	  $lSlots = MemoryRead($aBagIndex + 32, 'long')
   ElseIf IsDllStruct($aBagIndex) <> 0 Then
	  $lSlots = DllStructGetData($aBagIndex, 'slots')
   Else
	  $lSlots = MemoryRead(GetBagPtr($aBagIndex) + 32, 'long')
   EndIf
   For $i = 1 To $lSlots
	  $lItemPtr = GetItemPtrBySlot($aBagIndex, $i)
	  If $lItemPtr = 0 Then Return $i
   Next
EndFunc   ;==>FindEmptySlot

;~ Description: Returns number of free slots in inventory.
Func CountSlots()
   Local $lCount = 0
   For $lBag = 1 To 4
	  $lBagPtr = GetBagPtr($lBag)
	  If $lBagPtr = 0 Then ContinueLoop
	  $lCount += MemoryRead($lBagPtr + 32, 'long') - MemoryRead($lBagPtr + 16, 'long')
   Next
   Return $lCount
EndFunc   ;==>CountSlots

;~ Description: Returns number of free slots in storage.
Func CountSlotsChest()
   Local $lCount = 0
   For $lBag = 8 To 16
	  $lBagPtr = GetBagPtr($lBag)
	  If $lBagPtr = 0 Then ContinueLoop
	  $lCount += MemoryRead($lBagPtr + 32, 'long') - MemoryRead($lBagPtr + 16, 'long')
   Next
   Return $lCount
EndFunc   ;==>CountSlotsChest

;~ Description: Returns amount of items in inventory with $aModelID.
Func CountInventoryItem($aModelID)
   Local $lCount = 0
   For $i = 1 To 4
	  $lBagPtr = GetBagPtr($i)
	  For $j = 1 To MemoryRead($lBagPtr + 32, 'long')
		 $lItemPtr = GetItemPtrBySlot($lBagPtr, $j)
		 If $lItemPtr = 0 Then ContinueLoop
		 If MemoryRead($lItemPtr + 44, 'long') = $aModelID Then $lCount += MemoryRead($lItemPtr + 75, 'byte')
	  Next
   Next
   Return $lCount
EndFunc   ;==>CountInventoryItem

;~ Description: Returns array with itemIDs of Items in Bags with correct ModelID.
Func GetBagItemIDArrayByModelID($aModelID)
   Local $lRetArr[291][3]
   Local $lCount = 0
   For $bag = 1 to 17
	  Local $lBagPtr = GetBagPtr($bag)
	  Local $lSlots = MemoryRead($lBagPtr + 32, 'long')
	  For $slot = 1 To $lSlots
		 Local $lItemPtr = GetItemPtrBySlot($lBagPtr, $slot)
		 Local $lItemMID = MemoryRead($lItemPtr + 44, 'long')
		 If $lItemMID = $aModelID Then
			Local $lItemID = MemoryRead($lItemPtr, 'long')
			$lRetArr[$lCount][0] = $lItemID
			$lRetArr[$lCount][1] = $bag
			$lRetArr[$lCount][2] = $slot
			$lCount += 1
		 EndIf
	  Next
   Next
   ReDim $lRetArr[$lCount][3]
   Return $lRetArr
EndFunc   ;==>GetBagItemIDArrayByModelID

;~ Description: Returns item ID of salvage kit in inventory.
Func FindSalvageKit($aStart = 1, $aFinish = 16)
   Local $lUses = 101
   Local $lKit = 0
   For $bag = $aStart to $aFinish
	  Local $lBagPtr = GetBagPtr($bag)
	  Local $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
	  For $slot = 0 To MemoryRead($lBagPtr + 32, 'long') - 1
		 Local $lItemPtr = MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr')
		 If $lItemPtr = 0 Then ContinueLoop
		 Local $lItemMID = MemoryRead($lItemPtr + 44, 'long')
		 Switch $lItemMID
			Case 2992, 2993
			   Local $lValue = MemoryRead($lItemPtr + 36, 'short')
			   If $lValue / 2 < $lUses Then
				  $lUses = $lValue / 2
				  $lKit = MemoryRead($lItemPtr, 'long')
			   EndIf
			Case 2991
			   Local $lValue = MemoryRead($lItemPtr + 36, 'short')
			   If $lValue / 8 < $lUses Then
				  $lUses = $lValue / 8
				  $lKit = MemoryRead($lItemPtr, 'long')
			   EndIf
			Case 5900
			   Local $lValue = MemoryRead($lItemPtr + 36, 'short')
			   If $lValue / 10 < $lUses Then
				  $lUses = $lValue / 10
				  $lKit = MemoryRead($lItemPtr, 'long')
			   EndIf
		 EndSwitch
	  Next
   Next
   Return $lKit
EndFunc   ;==>FindSalvageKit

;~ Description: Returns amount of salvage uses.
Func SalvageUses($aStart = 1, $aFinish = 16)
   Local $lCount = 0
   For $bag = $aStart to $aFinish
	  Local $lBagPtr = GetBagPtr($bag)
	  Local $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
	  For $slot = 0 To MemoryRead($lBagPtr + 32, 'long') - 1
		 Local $lItemPtr = MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr')
		 If $lItemPtr = 0 Then ContinueLoop
		 Local $lItemMID = MemoryRead($lItemPtr + 44, 'long')
		 Switch $lItemMID
			Case 2992, 2993
			   $lCount += MemoryRead($lItemPtr + 36, 'short') / 2
			Case 2991
			   $lCount += MemoryRead($lItemPtr + 36, 'short') / 8
			Case 5900
			   $lCount += MemoryRead($lItemPtr + 36, 'short') / 10
		 EndSwitch
	  Next
   Next
   Return $lCount
EndFunc   ;==>SalvageUses

;~ Description: Returns item ID of ID kit in inventory.
Func FindIDKit($aStart = 1, $aFinish = 16)
   Local $lUses = 101
   Local $lKit = 0
   For $bag = $aStart to $aFinish
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
				  $lKit = MemoryRead($lItemPtr, 'long')
			   EndIf
			Case 5899
			   Local $lValue = MemoryRead($lItemPtr + 36, 'short')
			   If $lValue / 2.5 < $lUses Then
				  $lUses = $lValue / 2.5
				  $lKit = MemoryRead($lItemPtr, 'long')
			   EndIf
		 EndSwitch
	  Next
   Next
   Return $lKit
EndFunc   ;==>FindIDKit

;~ Description: Returns amount of ID kit uses.
Func FindIDKitUses($aStart = 1, $aFinish = 16)
   Local $lUses = 0
   For $bag = $aStart to $aFinish
	  Local $lBagPtr = GetBagPtr($bag)
	  Local $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
	  For $slot = 0 To MemoryRead($lBagPtr + 32, 'long') - 1
		 Local $lItemPtr = MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr')
		 If $lItemPtr = 0 Then ContinueLoop
		 Local $lItemMID = MemoryRead($lItemPtr + 44, 'long')
		 Switch $lItemMID
			Case 2989
			   $lUses += MemoryRead($lItemPtr + 36, 'short') / 2
			Case 5899
			   $lUses += MemoryRead($lItemPtr + 36, 'short') / 2.5
			Case Else
			   ContinueLoop
		 EndSwitch
	  Next
   Next
   Return $lUses
EndFunc   ;==>FindIDKitUses

;~ Description: Starts a salvaging session of an item.
Func StartSalvage($aItem, $aSalvageKitID = 0)
   If IsPtr($aItem) <> 0 Then
	  Local $lItemID = MemoryRead($aItem, 'long')
   ElseIf IsDllStruct($aItem) <> 0 Then
	  Local $lItemID = DllStructGetData($aItem, 'ID')
   Else
	  Local $lItemID = $aItem
   EndIf
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x690]
   Local $lSalvageSessionID = MemoryReadPtr($mBasePointer, $lOffset)
   If $aSalvageKitID = 0 Then
	  Local $lSalvageKitID = FindSalvageKit()
   Else
	  $lSalvageKitID = $aSalvageKitID
   EndIf
   If $lSalvageKitID = 0 Then Return False
   DllStructSetData($mSalvage, 2, $lItemID)
   DllStructSetData($mSalvage, 3, $lSalvageKitID)
   DllStructSetData($mSalvage, 4, $lSalvageSessionID[1])
   Enqueue($mSalvagePtr, 16)
   Return $lSalvageKitID
EndFunc   ;==>StartSalvage

;~ Description: Salvage the materials out of an item.
Func SalvageMaterials()
   Return SendPacket(0x4, 0x74)
EndFunc   ;==>SalvageMaterials

;~ Description: Salvages a mod out of an item.
;~ ModIndex: 0 -> Insignia, 1 -> Rune for armor upgrades.
Func SalvageMod($aModIndex)
   Return SendPacket(0x8, 0x75, $aModIndex)
EndFunc   ;==>SalvageMod

;~ Description: Returns amount of items of ModelID in inventory.
Func CountItemInBagsByModelID($aItemModelID)
   Local $lCount = 0
   For $bag = 1 To 4
	  Local $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then ContinueLoop
	  Local $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
	  For $slot = 0 To MemoryRead($lBagPtr + 32, 'long') - 1
		 Local $lItemPtr = MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr')
		 If $lItemPtr = 0 Then ContinueLoop
		 If MemoryRead($lItemPtr + 44, 'long') = $aItemModelID Then $lCount += MemoryRead($lItemPtr + 75, 'byte')
	  Next
   Next
   Return $lCount
EndFunc   ;==>CountItemInBagsByModelID

;~ Description: Returns amount of items of ModelID in storage.
Func CountItemInStorageByModelID($aItemModelID) ; Bag 6 is Material Storage, which is not included
   Local $lCount = 0
   For $bag = 8 To 16
	  Local $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then ContinueLoop
	  Local $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
	  For $slot = 0 To MemoryRead($lBagPtr + 32, 'long') - 1
		 Local $lItemPtr = MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr')
		 If $lItemPtr = 0 Then ContinueLoop
		 If MemoryRead($lItemPtr + 44, 'long') = $aItemModelID Then $lCount += MemoryRead($lItemPtr + 75, 'byte')
	  Next
   Next
   Return $lCount
EndFunc   ;==>CountItemInStorageByModelID

;~ Description: Returns amount of items of ModelID.
Func CountItemTotalByModelID($aItemModelID, $aIncludeMats = true)
   Local $lCount = 0
   If $aIncludeMats Then
	  Local $lBagSearch[15] = [14,1,2,3,4,5,6,8,10,11,12,13,14,15,16]
   Else
	  Local $lBagSearch[14] = [13,1,2,3,4,5,8,10,11,12,13,14,15,16]
   EndIf
   For $i = 1 To $lBagSearch[0]
	  Local $lBagPtr = GetBagPtr($lBagSearch[$i])
	  If $lBagPtr = 0 Then ContinueLoop
	  Local $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
	  For $slot = 0 To MemoryRead($lBagPtr + 32, 'long') - 1
		 Local $lItemPtr = MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr')
		 If $lItemPtr = 0 Then ContinueLoop
		 If MemoryRead($lItemPtr + 44, 'long') = $aItemModelID Then $lCount += MemoryRead($lItemPtr + 75, 'byte')
	  Next
   Next
   Return $lCount
EndFunc   ;==>CountItemTotalByModelID

;~ Description: Identifies an item.
Func IdentifyItem($aItem, $aIDKit = 0)
   If IsPtr($aItem) <> 0 Then
	  Local $lItemID = MemoryRead($aItem, 'long')
   ElseIf IsDllStruct($aItem) <> 0 Then
	  Local $lItemID = DllStructGetData($aItem, 'ID')
   Else
	  Local $lItemID = $aItem
   EndIf
   While Not GetIsIDed($aItem)
	  If $aIDKit = 0 Then
		 Local $lIDKit = FindIDKit()
	  Else
		 Local $lIDKit = $aIDKit
	  EndIf
	  If $lIDKit = 0 Then Return False
	  SendPacket(0xC, 0x66, $lIDKit, $lItemID)
	  Local $lDeadlock = TimerInit()
	  Do
		 Sleep(20)
	  Until GetIsIDed($aItem) Or TimerDiff($lDeadlock) > 5000
   WEnd
EndFunc   ;==>IdentifyItem

;~ Description: Identifies all items in a bag.
Func IdentifyBag($aBag = 1, $aWhites = True, $aGolds = True)
   If IsDllStruct($aBag) <> 0 Then $aBag = DllStructGetData($aBag, 'Index') + 1
   Local $lBagPtr = GetBagPtr($aBag)
   Local $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
   For $slot = 0 To MemoryRead($lBagPtr + 32, 'long') - 1
	  Local $lItemPtr = MemoryRead($lItemArrayPtr + 4 * ($slot), 'ptr')
	  If $lItemPtr = 0 Then ContinueLoop
	  If GetRarity($lItemPtr) = 2621 And $aWhites = False Then ContinueLoop
	  If GetRarity($lItemPtr) = 2624 And $aGolds = False Then ContinueLoop
	  IdentifyItem($lItemPtr)
	  Sleep(GetPing())
	Next
EndFunc   ;==>IdentifyBag

;~ Description: Identifies all gold items in a bag and drops them.
Func IdentifyBagAndDrop($aBag)
   If IsPtr($aBag) Then
	  $lSlots = MemoryRead($aBag + 32, 'long')
   ElseIf IsDllStruct($aBag) <> 0 Then
	  $lSlots = DllStructGetData($aBag, 'slots')
	  $aBag = DllStructGetData($aBag, 'index')
   Else
	  $lSlots = MemoryRead(GetBagPtr($aBag) + 32, 'long')
   EndIf
   For $i = 1 To $lSlots
	  $lItemPtr = GetItemPtrBySlot($aBag, $i)
	  If $lItemPtr = 0 Then ContinueLoop
	  If GetRarity($lItemPtr) <> 2624 Then ContinueLoop
	  If FindIDKit() <> 0 Then
		 IdentifyItem($lItemPtr)
		 PingSleep(200)
	  EndIf
	  DropItem($lItemPtr)
	  PingSleep(50)
   Next
EndFunc   ;==>IdentifyBagAndDrop

;~ Description: Drops all gold items on the ground without identifying them first.
Func DropUnIDGolds($aBag)
   If IsPtr($aBag) Then
	  $lSlots = MemoryRead($aBag + 32, 'long')
   ElseIf IsDllStruct($aBag) <> 0 Then
	  $lSlots = DllStructGetData($aBag, 'slots')
	  $aBag = DllStructGetData($aBag, 'index')
   Else
	  $lSlots = MemoryRead(GetBagPtr($aBag) + 32, 'long')
   EndIf
   For $i = 1 To $lSlots
	  $lItemPtr = GetItemPtrBySlot($aBag, $i)
	  If $lItemPtr = 0 Then ContinueLoop
	  If GetRarity($lItemPtr) <> 2624 Then ContinueLoop
	  If GetIsIDed($lItemPtr) Then ContinueLoop
	  DropItem($lItemPtr)
	  PingSleep(400)
   Next
EndFunc   ;==>DropUnIDGolds

;~ Description: Identifies and Salvages all items in a bag.
Func IdentifyBagAndSalvage($aBag = 1)
   If IsPtr($aBag) <> 0 Then
	  Local $lBagPtr = $aBag
   ElseIf IsDllStruct($aBag) <> 0 Then
	  Local $lBagPtr = GetBagPtr(DllStructGetData($aBag, 'Index') + 1)
   Else
	  Local $lBagPtr = GetBagPtr($aBag)
   EndIf
   Local $lItemArrayPtr = MemoryRead($lBagPtr + 24, 'ptr')
   For $i = 1 To MemoryRead($lBagPtr + 32, 'long')
	  Local $lItemPtr = MemoryRead($lItemArrayPtr + 4 * ($i - 1), 'ptr')
	  If $lItemPtr = 0 Then ContinueLoop
	  If MemoryRead($lItemPtr + 24, 'ptr') <> 0 Then ContinueLoop ; customized
	  If MemoryRead($lItemPtr + 76, 'byte') <> 0 Then ContinueLoop ; equipped
	  If MemoryRead($lItemPtr + 36, 'short') = 0 Then ContinueLoop ; value 0
	  Local $lItemMID = MemoryRead($lItemPtr + 44, 'long')
	  If GetIsIronItem($lItemMID) Or $lItemMID = 522 Then ; 522 = Dark Remains
		 If GetIsRareWeapon($lItemPtr) Then ContinueLoop
		 Update("ID bag " & $aBag & " and slot " & $i)
		 If $lItemMID <> 522 Then IdentifyItem($lItemPtr)
		 Update("Salvage bag " & $aBag & " and slot " & $i)
		 Local $lSalvKitID = StartSalvage($lItemPtr)
		 Local $lSalvKitPtr = GetItemPtr($lSalvKitID)
		 Local $lSalvKitValue = MemoryRead($lSalvKitPtr + 36, 'short')
		 Local $lDeadlock = TimerInit()
		 Do
			Sleep(20)
			$SalvKitValue2 = MemoryRead($lSalvKitPtr + 36, 'short')
		 Until $lSalvKitValue > $SalvKitValue2 Or TimerDiff($lDeadlock) > 5000
		 $lItemPtr = MemoryRead($lItemArrayPtr + 4 * ($i - 1), 'ptr')
		 If $lItemPtr = 0 Then ContinueLoop
		 If GetRarity($lItemPtr) <> 2621 And $lItemMID <> 522 Then
			RndSleep(500)
			Update("Salvage Material Special from bag " & $aBag & " and slot " & $i)
			SalvageMaterials()
		 EndIf
	  EndIf
   Next
EndFunc   ;==>IdentifyBagAndSalvage

;~ Description: Equips an item.
Func EquipItem($aItem)
   If IsPtr($aItem) <> 0 Then
	  Return SendPacket(0x8, 0x2A, MemoryRead($aItem, 'long'))
   ElseIf IsDllStruct($aItem) <> 0 Then
	  Return SendPacket(0x8, 0x2A, DllStructGetData($aItem, 'ID'))
   Else
	  Return SendPacket(0x8, 0x2A, $aItem)
   EndIf
EndFunc   ;==>EquipItem

;~ Description: Uses an item.
Func UseItem($aItem)
   If IsPtr($aItem) <> 0 Then
	  Return SendPacket(0x8, 0x78, MemoryRead($aItem, 'long'))
   ElseIf IsDllStruct($aItem) <> 0 Then
	  Return SendPacket(0x8, 0x78, DllStructGetData($aItem, 'ID'))
   Else
	  Return SendPacket(0x8, 0x78, $aItem)
   EndIf
EndFunc   ;==>UseItem

;~ Description: Drops an item.
Func DropItem($aItem, $aAmount = 0)
   If IsPtr($aItem) <> 0 Then
	  If $aAmount = 0 Then $aAmount = MemoryRead($aItem + 75, 'byte')
	  Return SendPacket(0xC, 0x26, MemoryRead($aItem, 'long'), $aAmount)
   ElseIf IsDllStruct($aItem) <> 0 Then
	  If $aAmount = 0 Then $aAmount = DllStructGetData($aItem, 'Quantity')
	  Return SendPacket(0xC, 0x26, DllStructGetData($aItem, 'ID'), $aAmount)
   Else
	  If $aAmount = 0 Then $aAmount = MemoryRead(GetItemPtr($aItem) + 75, 'byte')
	  Return SendPacket(0xC, 0x26, $aItem, $aAmount)
   EndIf
EndFunc   ;==>DropItem

;~ Description: Moves an item.
Func MoveItem($aItem, $aBag, $aSlot)
   If IsPtr($aItem) <> 0 Then
	  Local $lItemID = MemoryRead($aItem, 'long')
   ElseIf IsDllStruct($aItem) <> 0 Then
	  Local $lItemID = DllStructGetData($aItem, 'ID')
   Else
	  Local $lItemID = $aItem
   EndIf
   If IsPtr($aBag) <> 0 Then
	  Local $lBagID = MemoryRead($aBag + 8, 'long')
   ElseIf IsDllStruct($aBag) <> 0 Then
	  Local $lBagID = DllStructGetData($aBag, 'ID')
   Else
	  Local $lBagID = MemoryRead(GetBagPtr($aBag) + 8, 'long')
   EndIf
   Return SendPacket(0x10, 0x6C, $lItemID, $lBagID, $aSlot - 1)
EndFunc   ;==>MoveItem

;~ Description: Moves an item, with amount to be moved.
Func MoveItemEx($aItem, $aBag, $aSlot, $aAmount)
   If IsPtr($aItem) <> 0 Then
	  Local $lItemID = MemoryRead($aItem, 'long')
	  Local $lQuantity = MemoryRead($aItem + 75, 'byte')
   ElseIf IsDllStruct($aItem) <> 0 Then
	  Local $lItemID = DllStructGetData($aItem, 'ID')
	  Local $lQuantity = DllStructGetData($aItem, 'Quantity')
   Else
	  Local $lItemID = $aItem
	  Local $lQuantity = MemoryRead(GetItemPtr($aItem) + 75, 'byte')
   EndIf
   If IsPtr($aBag) <> 0 Then
	  Local $lBagID = MemoryRead($aBag + 8, 'long')
   ElseIf IsDllStruct($aBag) <> 0 Then
	  Local $lBagID = DllStructGetData($aBag, 'ID')
   Else
	  Local $lBagID = MemoryRead(GetBagPtr($aBag) + 8, 'long')
   EndIf
   If $lQuantity > $aAmount Then $lQuantity = $aAmount
   Return SendPacket(0x14, 0x6F, $lItemID, $lQuantity, $lBagID, $aSlot - 1)
EndFunc   ;==>MoveItemEx

;~ Description: Unequips item to $abag, $aslot (1-based).
;~ Equipmentslots:	1 -> Mainhand/Two-hand
;~ 			    	2 -> Offhand
;~ 					3 -> Chestpiece
;~ 					4 -> Leggings
;~ 					5 -> Headpiece
;~ 					6 -> Boots
;~ 					7 -> Gloves
Func UnequipItem($aEquipmentSlot, $aBag, $aSlot)
   If IsPtr($aBag) Then
	  $lBagID = MemoryRead($aBag + 8, 'long')
   ElseIf IsDllStruct($aBag) Then
	  $lBagID = DllStructGetData($aBag, 'ID')
   Else
	  $lBagID = MemoryRead(GetBagPtr($aBag) + 8, 'long')
   EndIf
   Return SendPacket(0x10, 0x49, $aEquipmentSlot - 1, $lBagID, $aSlot - 1)
EndFunc   ;==>UnequipItem

;~ Description: Destroys an item.
Func DestroyItem($aItem)
   If IsPtr($aItem) <> 0 Then
	  Return SendPacket(0x8, 0x63, MemoryRead($aItem, 'long'))
   ElseIf IsDllStruct($aItem) <> 0 Then
	  Return SendPacket(0x8, 0x63, DllStructGetData($aItem, 'ID'))
   Else
	  Return SendPacket(0x8, 0x63, $aItem)
   EndIf
EndFunc   ;==>DestroyItem

;~ Description: Accepts unclaimed items after a mission.
Func AcceptAllItems()
   Return SendPacket(0x8, 0x6D, MemoryRead(GetBagPtr(7) + 8, 'long'))
EndFunc   ;==>AcceptAllItems

;~ Description: Returns True if Inventory is full.
Func IsInventoryFull()
   Return CountSlots() < 2
EndFunc   ;==>IsInventoryFull
#EndRegion

#Region Merchants
;~ Description: Sells an item.
Func SellItem($aItem, $aQuantity = 0)
   If IsPtr($aItem) <> 0 Then
	  Local $lItemID = MemoryRead($aItem, 'long')
	  Local $lQuantity = MemoryRead($aItem + 75, 'byte')
	  Local $lValue = MemoryRead($aItem + 36, 'short')
   ElseIf IsDllStruct($aItem) <> 0 Then
	  Local $lItemID = DllStructGetData($aItem, 'ID')
	  Local $lQuantity = DllStructGetData($aItem, 'Quantity')
	  Local $lValue = DllStructGetData($aItem, 'Value')
   Else
	  Local $lItemID = $aItem
	  Local $lItemPtr = GetItemPtr($aItem)
	  Local $lQuantity = MemoryRead($lItemPtr + 75, 'byte')
	  Local $lValue = MemoryRead($lItemPtr + 36, 'short')
   EndIf
   If $aQuantity = 0 Or $aQuantity > $lQuantity Then $aQuantity = $lQuantity
   DllStructSetData($mSellItem, 2, $aQuantity * $lValue)
   DllStructSetData($mSellItem, 3, $lItemID)
   Enqueue($mSellItemPtr, 12)
EndFunc   ;==>SellItem

;~ Description: Buys an item.
Func BuyItem($aItemRow, $aQuantity, $aValue)
   Local $lMerchantItemsBase = GetMerchantItemsBase()
   If Not $lMerchantItemsBase Then Return
   If $aItemRow < 1 Or $aItemRow > GetMerchantItemsSize() Then Return
   DllStructSetData($mBuyItem, 2, $aQuantity)
   DllStructSetData($mBuyItem, 3, MemoryRead($lMerchantItemsBase + 4 * ($aItemRow - 1)))
   DllStructSetData($mBuyItem, 4, $aQuantity * $aValue)
   Enqueue($mBuyItemPtr, 16)
EndFunc   ;==>BuyItem

;~ Description: Buys an item by modelid instead of row.
Func BuyItemByModelID($aModelID, $aQuantity, $aValue)
   Local $lItemIDRow = GetItemRowByModelID($aModelID)
   DllStructSetData($mBuyItem, 2, $aQuantity)
   DllStructSetData($mBuyItem, 3, $lItemIDRow)
   DllStructSetData($mBuyItem, 4, $aQuantity * $aValue)
   Enqueue($mBuyItemPtr, 16)
EndFunc   ;==>BuyItemByModelID

;~ Description: Crafts an item.
Func CraftItem($aModelID, $aQuantity, $aGold, $aMat1ModelID = 0, $aMat2ModelID = 0, $aMat3ModelID = 0, $aMat4ModelID = 0)
   Local $SearchBag[5] = [4, 1, 2, 3, 4] ; only mats from inventory
   Local $MatCount = 0
   Local $lItemIDRow = GetItemRowByModelID($aModelID)
   If $lItemIDRow = 0 Then Return False
   Local $ItemIDMats1 = 0
   Local $ItemIDMats2 = 0
   Local $ItemIDMats3 = 0
   Local $ItemIDMats4 = 0
   Local $lItemPtr
   If $aMat1ModelID <> 0 Then
	  $lItemPtr = GetBagItemPtrByModelID($aMat1ModelID, $SearchBag)
	  $ItemIDMats1 = MemoryRead($lItemPtr, 'long')
	  $MatCount += 1
	  If $aMat2ModelID <> 0 Then
		 $lItemPtr = GetBagItemPtrByModelID($aMat2ModelID, $SearchBag)
		 $ItemIDMats2 = MemoryRead($lItemPtr, 'long')
		 $MatCount += 1
		 If $aMat3ModelID <> 0 Then
			$lItemPtr = GetBagItemPtrByModelID($aMat3ModelID, $SearchBag)
			$ItemIDMats3 = MemoryRead($lItemPtr, 'long')
			$MatCount += 1
			If $aMat4ModelID <> 0 Then
			   $lItemPtr = GetBagItemPtrByModelID($aMat4ModelID, $SearchBag)
			   $ItemIDMats4 = MemoryRead($lItemPtr, 'long')
			   $MatCount += 1
			EndIf
		 EndIf
	  EndIf
   EndIf
   DllStructSetData($mCraftItem, 2, $aQuantity)
   DllStructSetData($mCraftItem, 3, $lItemIDRow)
   DllStructSetData($mCraftItem, 4, $ItemIDMats1)
   DllStructSetData($mCraftItem, 5, $ItemIDMats2)
   DllStructSetData($mCraftItem, 6, $ItemIDMats3)
   DllStructSetData($mCraftItem, 7, $ItemIDMats4)
   DllStructSetData($mCraftItem, 8, $MatCount)
   DllStructSetData($mCraftItem, 9, $aQuantity * $aGold)
   Enqueue($mCraftItemPtr, 36)
EndFunc   ;==>CraftItem

;~ Description: Crafts an item. Crafter merchant window has to be opened and mats and gold have to be in inventory/on character.
;~ Return 0: prerequisites not met ($aMatsarray not an array, ItemModelID not part of merchantbase, not enough memory)
;~ Return ModelID: of missing mats -> @extended = amount of missing mats
;~ Return True: function finished -> @extended = 0 if items got crafted, <> 0 if crafting failed
;~ Parameter 1: ModelID of item to be crafted
;~ Parameter 2: Amount of items to craft
;~ Parameter 3: Amount of gold needed to craft one item
;~ Parameter 4: MatsArray[ [Mat1ModelID, Mat1Amount], _
;~ 						   [Mat2ModelID, Mat2Amount], _
;~ 						   [Mat3ModelID, Mat3Amount], _
;~ 						   [MatNModelID, MatNAmount]]
;~ Requires: gwAPI_basics.au3, items.au3
;~ Part of: items.au3
;~ Author: Testytest.
Func CraftItemEx($aModelID, $aQuantity, $aGold, ByRef $aMatsArray)
   Local $lItemIDRow = GetItemRowByModelID($aModelID)
   If $lItemIDRow = 0 Then Return 0 ; modelID not found in merchantbase
   Local $lMatString = ''
   Local $lMatCount = 0
   If IsArray($aMatsArray) = 0 Then Return 0 ; mats are not in an array
   Local $lMatsArraySize = UBound($aMatsArray) - 1
   For $i = $lMatsArraySize To 0 Step -1
	  $lCheckQuantity = CountItemInBagsByModelID($aMatsArray[$i][0])
	  If $aMatsArray[$i][1] * $aQuantity > $lCheckQuantity Then  ; not enough mats in inventory
		 Return SetExtended($aMatsArray[$i][1] * $aQuantity - $lCheckQuantity, $aMatsArray[$i][0]) ; amount of missing mats in @extended
	  EndIf
   Next
   $lCheckGold = GetGoldCharacter()
   For $i = 0 To $lMatsArraySize
	  $lMatString &= GetCraftMatsString($aMatsArray[$i][0], $aQuantity * $aMatsArray[$i][1])
	  $lMatCount += @extended
   Next
   $CraftMatsType = 'dword'
   For $i = 1 to $lMatCount - 1
	  $CraftMatsType &= ';dword'
   Next
   $CraftMatsBuffer = DllStructCreate($CraftMatsType)
   $CraftMatsPointer = DllStructGetPtr($CraftMatsBuffer)
   For $i = 1 To $lMatCount
	  $lSize = StringInStr($lMatString, ';')
	  DllStructSetData($CraftMatsBuffer, $i, StringLeft($lMatString, $lSize - 1))
	  $lMatString = StringTrimLeft($lMatString, $lSize)
   Next
   Local $lMemSize = $lMatCount * 4
   Local $lBufferMemory = DllCall($mKernelHandle, 'ptr', 'VirtualAllocEx', 'handle', $mGWProcHandle, 'ptr', 0, 'ulong_ptr', $lMemSize, 'dword', 0x1000, 'dword', 0x40)
   If $lBufferMemory = 0 Then Return 0 ; couldnt allocate enough memory
   Local $lBuffer = DllCall($mKernelHandle, 'int', 'WriteProcessMemory', 'int', $mGWProcHandle, 'int', $lBufferMemory[0], 'ptr', $CraftMatsPointer, 'int', $lMemSize, 'int', '')
   If $lBuffer = 0 Then Return
   DllStructSetData($mCraftItemEx, 2, $aQuantity)
   DllStructSetData($mCraftItemEx, 3, $lItemIDRow)
   DllStructSetData($mCraftItemEx, 4, $lBufferMemory[0])
   DllStructSetData($mCraftItemEx, 5, $lMatCount)
   DllStructSetData($mCraftItemEx, 6, $aQuantity * $aGold)
   Enqueue($mCraftItemExPtr, 24)
   $lDeadlock = TimerInit()
   Do
	  Sleep(250)
	  $lCurrentQuantity = CountItemInBagsByModelID($aMatsArray[0][0])
   Until $lCurrentQuantity <> $lCheckQuantity Or $lCheckGold <> GetGoldCharacter() Or TimerDiff($lDeadlock) > 5000
   DllCall($mKernelHandle, 'ptr', 'VirtualFreeEx', 'handle', $mGWProcHandle, 'ptr', $lBufferMemory[0], 'int', 0, 'dword', 0x8000)
   Return SetExtended($lCheckQuantity - $lCurrentQuantity - $aMatsArray[0][1] * $aQuantity, True) ; should be zero if items were successfully crafter
EndFunc   ;==>CraftItemEx

;~ Description: Internal use CraftItemEx. Returns item IDs of ModelIDs found in inventory as string, separate by ';'.
;~ Return: String of ItemIDs, separated by ';'
;~ @Extended: Amount of ItemIDs
;~ Parameter 1: ModelID
;~ Parameter 2: Amount needed
;~ Requires: gwAPI_basics.au3, items.au3
;~ Part of: items.au3
;~ Author: Testytest.
Func GetCraftMatsString($aModelID, $aAmount)
   Local $lCount = 0
   Local $lQuantity = 0
   Local $lMatString = ''
   For $bag = 1 to 4
	  $lBagPtr = GetBagPtr($bag)
	  If $lBagPtr = 0 Then ContinueLoop ; no valid bag
	  For $slot = 1 To MemoryRead($lBagPtr + 32, 'long')
		 $lSlotPtr = GetItemPtrBySlot($lBagPtr, $slot)
		 If $lSlotPtr = 0 Then ContinueLoop ; empty slot
		 If MemoryRead($lSlotPtr + 44, 'long') = $aModelID Then
			$lMatString &= MemoryRead($lSlotPtr, 'long') & ';'
			$lCount += 1
			$lQuantity += MemoryRead($lSlotPtr + 75, 'byte')
			If $lQuantity >= $aAmount Then
			   Return SetExtended($lCount, $lMatString)
			EndIf
		 EndIf
	  Next
   Next
EndFunc   ;==>GetCraftMatsString

;~ Description: Internal Use CraftItem and BuyItemByModelID.
Func GetItemRowByModelID($aModelID)
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x28]
   Local $lItemArraySize = MemoryReadPtr($mBasePointer, $lOffset)
   $lOffset[3] = 0x24
   Local $lMerchantBase = MemoryReadPtr($mBasePointer, $lOffset)
   For $i = 0 To $lItemArraySize[1] - 1
	  $lItemID = MemoryRead($lMerchantBase[1] + 4 * $i)
	  $lItemPtr = GetItemPtr($lItemID)
	  If $lItemPtr = 0 Then ContinueLoop
	  If MemoryRead($lItemPtr + 44, 'long') = $aModelID And MemoryRead($lItemPtr + 4, 'long') = 0 And MemoryRead($lItemPtr + 12, 'ptr') = 0 Then
		 Return MemoryRead($lItemPtr, 'long')
	  EndIf
   Next
EndFunc   ;==>GetItemRowByModelID

;~ Description: Internal Use CraftItem and BuyItemByModelID.
Func GetItemRowsByModelID($lModelID)
   Local $lOffset[4] = [0, 0x18, 0x40, 0xC0]
   Local $lItemArraySize = MemoryReadPtr($mBasePointer, $lOffset)
   Local $lReturnArray[$lItemArraySize[1]]
   Local $lReturnCount = 0
   For $lItemID = 1 To $lItemArraySize[1]
	  Local $lItemPtr = GetItemPtr($lItemID)
	  If $lItemPtr = 0 Then ContinueLoop
	  Local $lItemMID = MemoryRead($lItemPtr + 44, 'long')
	  If $lItemMID = $lModelID And MemoryRead($lItemPtr + 4, 'long') = 0 And MemoryRead($lItemPtr + 12, 'ptr') = 0 Then
		 $lReturnCount += 1
		 $lReturnArray[$lReturnCount] = $lItemID
	  EndIf
   Next
   If $lReturnCount = 0 Then Return 0
   $lReturnArray[0] = $lReturnCount
   ReDim $lReturnArray[$lReturnCount+1]
   Return $lReturnArray
EndFunc   ;==>GetItemRowsByModelID

;~ Description: Request a quote to buy an item from a trader. Returns true if successful.
Func TraderRequest($aModelID, $aExtraID = -1)
   Local $lOffset[4] = [0, 0x18, 0x40, 0xC0]
   Local $lItemArraySize = MemoryReadPtr($mBasePointer, $lOffset)
   Local $lFound = False
   Local $lQuoteID = MemoryRead($mTraderQuoteID)
   For $lItemID = 1 To $lItemArraySize[1]
	  Local $lItemPtr = GetItemPtr($lItemID)
	  If $lItemPtr = 0 Then ContinueLoop
	  If MemoryRead($lItemPtr + 44, 'long') = $aModelID Then
		 If MemoryRead($lItemPtr + 12, 'ptr') = 0 And MemoryRead($lItemPtr + 4, 'long') = 0 Then
			If $aExtraID = -1 Or MemoryRead($lItemPtr + 34, 'short') = $aExtraID Then
			   $lFound = True
			   ExitLoop
			EndIf
		 EndIf
	  EndIf
   Next
   If Not $lFound Then Return False
   DllStructSetData($mRequestQuote, 2, $lItemID)
   Enqueue($mRequestQuotePtr, 8)
   Local $lDeadlock = TimerInit()
   $lFound = False
   Do
	  Sleep(20)
	  $lFound = MemoryRead($mTraderQuoteID) <> $lQuoteID
   Until $lFound Or TimerDiff($lDeadlock) > GetPing() + 5000
   Return $lFound
EndFunc   ;==>TraderRequest

;~ Description: Request a quote to buy a rune from a trader. Returns true if successful.
Func RuneRequestBuy($aModelID, $aModStruct)
   Local $lOffset[4] = [0, 0x18, 0x40, 0xC0]
   Local $lItemArraySize = MemoryReadPtr($mBasePointer, $lOffset)
   Local $lItemID
   Local $lFound = False
   Local $lQuoteID = MemoryRead($mTraderQuoteID)
   For $lItemID = 1 To $lItemArraySize[1]
	  Local $lItemPtr = GetItemPtr($lItemID)
	  Local $lItemMID = MemoryRead($lItemPtr + 44, 'long')
	  If $lItemMID == $aModelID Then
		 Local $lModStructPtr = MemoryRead($lItemPtr + 16, 'ptr')
		 Local $lModStructSize = MemoryRead($lItemPtr + 20)
		 $lModStruct = MemoryRead($lModStructPtr, 'Byte[' & $lModStructSize * 4 & ']')
		 If StringInStr($lModStruct, $aModStruct) <> 0 Then
			$ItemID = MemoryRead($lItemPtr, 'long')
			$lFound = True
			ExitLoop
		 EndIf
	  EndIf
   Next
   If Not $lFound Then Return False
   DllStructSetData($mRequestQuote, 2, $ItemID)
   Enqueue($mRequestQuotePtr, 8)
   Local $lDeadlock = TimerInit()
   $lFound = False
   Do
	  Sleep(20)
	  $lFound = MemoryRead($mTraderQuoteID) <> $lQuoteID
   Until $lFound Or TimerDiff($lDeadlock) > GetPing() + 5000
   Return $lFound
EndFunc   ;==>RuneRequestBuy

;~ Description: Buy the requested item.
Func TraderBuy()
   If Not GetTraderCostID() Or Not GetTraderCostValue() Then Return False
   Enqueue($mTraderBuyPtr, 4)
   Return True
EndFunc   ;==>TraderBuy

;~ Description: Request a quote to sell an item to the trader.
Func TraderRequestSell($aItem)
   If IsPtr($aItem) <> 0 Then
	  Local $lItemID = MemoryRead($aItem, 'long')
   ElseIf IsDllStruct($aItem) <> 0 Then
	  Local $lItemID = DllStructGetData($aItem, 'ID')
   Else
	  Local $lItemID = $aItem
   EndIf
   Local $lFound = False
   Local $lQuoteID = MemoryRead($mTraderQuoteID)
   DllStructSetData($mRequestQuoteSell, 2, $lItemID)
   Enqueue($mRequestQuoteSellPtr, 8)
   Local $lDeadlock = TimerInit()
   Do
	  Sleep(20)
	  $lFound = MemoryRead($mTraderQuoteID) <> $lQuoteID
   Until $lFound Or TimerDiff($lDeadlock) > GetPing() + 5000
   Return $lFound
EndFunc   ;==>TraderRequestSell

;~ Description: ID of the item item being sold.
Func TraderSell()
   If Not GetTraderCostID() Or Not GetTraderCostValue() Then Return False
   Enqueue($mTraderSellPtr, 4)
   Return True
EndFunc   ;==>TraderSell

;~ Description: Returns the item ID of the quoted item.
Func GetTraderCostID()
   Return MemoryRead($mTraderCostID)
EndFunc   ;==>GetTraderCostID

;~ Description: Returns the cost of the requested item.
Func GetTraderCostValue()
   Return MemoryRead($mTraderCostValue)
EndFunc   ;==>GetTraderCostValue

;~ Description: Internal use for BuyItem()
Func GetMerchantItemsBase()
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x24]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetMerchantItemsBase

;~ Description: Internal use for BuyItem()
Func GetMerchantItemsSize()
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x28]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetMerchantItemsSize

;~ Description: Buys an ID kit.
Func BuyIDKit()
   BuyItem(5, 1, 100)
EndFunc   ;==>BuyIDKit

;~ Description: Buys a superior ID kit.
Func BuySuperiorIDKit()
   BuyItem(6, 1, 500)
EndFunc   ;==>BuySuperiorIDKit

;~ Description: Buys 3 Salvage Kits.
Func BuySalvageKitThree()
   BuyItem(2, 3, 100)
EndFunc   ;==>BuySalvageKitThree

;~ Description: Buys 2 Salvage Kits.
Func BuySalvageKitTwo()
   BuyItem(2, 2, 100)
EndFunc   ;==>BuySalvageKitTwo

;~ Description: Buys 1 Salvage Kits.
Func BuySalvageKit()
   BuyItem(2, 1, 100)
EndFunc   ;==>BuySalvageKit
#EndRegion

#Region PickingUp
;~ Description: Picks up an item, requires AgentID.
Func PickUpItem($aAgentID)
   If IsPtr($aAgentID) <> 0 Then
	  Return SendPacket(0xC, 0x39, MemoryRead($aAgentID + 44, 'long'), 0)
   ElseIf IsDllStruct($aAgentID) <> 0 Then
	  Return SendPacket(0xC, 0x39, DllStructGetData($aAgentID, 'ID'), 0)
   Else
	  Return SendPacket(0xC, 0x39, ConvertID($aAgentID), 0)
   EndIf
EndFunc   ;==>PickUpItem

;~ Description: Picks up loot that has been specified in PickUpList().
Func PickUpLoot($aMinSlots = 2, $aMe = GetAgentPtr(-2))
   Local $lMeX, $lMeY, $lAgentX, $lAgentY
   Local $lSlots = CountSlots()
   Local $lAgentArray = GetAgentPtrArray(1, 0x400)
   For $i = 1 To $lAgentArray[0]
	  If GetIsDead($aMe) Then Return False ; died, cant pick up items dead
	  If GetMapLoading() <> 1 Then Return True ; not in explorable -> no items to pick up
	  $lAgentID = MemoryRead($lAgentArray[$i] + 44, 'long')
	  $lItemPtr = GetItemPtrByAgentID($lAgentID)
	  If $lItemPtr = 0 Then ContinueLoop
	  $lItemType = MemoryRead($lItemPtr + 32, 'byte')
	  If $lItemType = 20 Then ; coins
		 UpdateAgentPosByPtr($lAgentArray[$i], $lAgentX, $lAgentY)
		 UpdateAgentPosByPtr($aMe, $lMeX, $lMeY)
		 $lDistance = Sqrt(($lMeX - $lAgentX) ^ 2 + ($lMeY - $lAgentY) ^ 2)
		 PickUpItems($lAgentArray[$i], $lAgentID, $lAgentX, $lAgentY, $lDistance, $aMe)
	  EndIf
	  If $lItemType = 6 Then ; quest items / bundles
		 If $mPickUpBundles Then
			UpdateAgentPosByPtr($lAgentArray[$i], $lAgentX, $lAgentY)
			UpdateAgentPosByPtr($aMe, $lMeX, $lMeY)
			$lDistance = Sqrt(($lMeX - $lAgentX) ^ 2 + ($lMeY - $lAgentY) ^ 2)
			PickUpItems($lAgentArray[$i], $lAgentID, $lAgentX, $lAgentY, $lDistance, $aMe)
		 Else
			ContinueLoop
		 EndIf
	  EndIf
	  If $lSlots < $aMinSlots Then ; inventory is full
		 If $lItemType <> 6 And $lItemType <> 20 Then Return False ; quest items and coins
	  EndIf
	  Local $lOwner = MemoryRead($lAgentArray[$i] + 196, 'long')
	  If $lOwner <> 0 And $lOwner <> GetMyID() Then ContinueLoop ; assigned to someone else
	  UpdateAgentPosByPtr($aMe, $lMeX, $lMeY)
	  UpdateAgentPosByPtr($lAgentArray[$i], $lAgentX, $lAgentY)
	  $lDistance = Sqrt(($lMeX - $lAgentX) ^ 2 + ($lMeY - $lAgentY) ^ 2)
	  If $lDistance > 2000 Then ContinueLoop ; item is too far away
	  $lItemMID = MemoryRead($lItemPtr + 44, 'long')
	  If $mEventModelID <> 0 Then
		 If $lItemMID = $mEventModelID Then $mEventCount += 1
	  EndIf
	  If Not $mMapPieces Then
		 If $lItemMID = 24629 Or $lItemMID = 24630 Or $lItemMID = 24631 Or $lItemMID = 24632 Then ContinueLoop ; no map pieces please
	  EndIf
	  If $lItemMID = 27977 And Not $mBattlePlans Then ContinueLoop ; no charr battle plans
	  If $lItemMID = 21797 And Not $mMesmerTomes Then ContinueLoop ; no mesmer tomes
	  If $lItemMID = 21799 And Not $mElementalistTomes Then ContinueLoop ; no elementalist tomes
	  If $mPickUpAll Or PickUpList($lItemPtr) Then
		 PickUpItems($lAgentArray[$i], $lAgentID, $lAgentX, $lAgentY, $lDistance, $aMe)
	  EndIf
   Next
EndFunc   ;==>PickUpLoot

Func PickUpItems($aPtr, $aAgentID, $aX, $aY, $aDistance, $aMe)
   Local $lBlocked = 0
   If $aDistance > 150 Then
	  Do
		 Move_($aX, $aY)
		 Sleep(250)
		 $lBlocked += 1
	  Until GetDistance($aPtr, $aMe) <= 150 Or $lBlocked > 20
   EndIf
   $lTimer = TimerInit()
   Do
	  PickUpItem($aAgentID)
	  Sleep(250)
   Until GetAgentPtr($aAgentID) <> $aPtr Or TimerDiff($lTimer) > 3000
EndFunc

;~ Description: Internal use PickUpLoot().
Func PickUpList($aItemPtr)
   Local $lRarity = GetRarity($aItemPtr)
   If $lRarity = 2624 Or $lRarity = 2626 And $mLeecher Then Return False ; leecher present to pick up loot
   If $lRarity = 2627 Then Return $mRarityGreen ; green items
   If $lRarity = 2624 Then Return $mRarityGold ; gold items
   Local $lModelID = MemoryRead($aItemPtr + 44, 'long')
   If $lModelID = 27977 Then Return $mBattlePlans ; charr battle plans
   If $lModelID = 24629 Then Return $mMapPieces ; map top left
   If $lModelID = 24630 Then Return $mMapPieces ; map top right
   If $lModelID = 24631 Then Return $mMapPieces ; map bottom left
   If $lModelID = 24632 Then Return $mMapPieces ; map bottom right
   If $lModelID = 6104 Then Return $mQuestItems ; Quest item: Urn
   If $lModelID = 6102 Then Return $mQuestItems ; Quest item: Spear
   Local $lType = MemoryRead($aItemPtr + 32, 'byte')
   Switch $lType
	  Case 9, 11, 18, 20, 31 ; consumables, materials and z-coins, keys, gold coins, scrolls
		 Return True
	  Case 10 ; dyes
		 $lExtraID = MemoryRead($aItemPtr + 34, 'short')
		 If $lExtraID = 10 Or $lExtraID = 12 Then
			Return True ; black and white dye
		 Else
			Return $mDyes
		 EndIf
	  Case 21 ; quest items
		 Return $mQuestItems
   EndSwitch
   Switch $lModelID
	  Case 1953, 1956 to 1975 ; froggys
		 Return True
	  Case 21786 to 21795 ; elite tomes
		 Return $mEliteTomes
	  Case 21796 ;  assassin tomes
		 Return $mTomes
	  Case 21797 ; mesmer tomes
		 Return $mMesmerTomes
	  Case 21798 ; necromancer tomes
		 Return $mTomes
	  Case 21799 ; elementalist tomes
		 Return $mElementalistTomes
	  Case 21800 ; monk tomes
		 Return $mTomes
	  Case 21801 ; warrior tomes
		 Return $mTomes
	  Case 21802 ; ranger tomes
		 Return $mTomes
	  Case 21803 ; dervish tomes
		 Return $mTomes
	  Case 21804 ; ritualist tomes
		 Return $mTomes
	  Case 21805 ; paragon tomes
		 Return $mTomes
	  Case 21127 to 21131 ; gems
		 Return True
	  Case 522, 835, 476, 525, 444, 27047 ; dark remains, feathered scalp, demonic remains, umbral skeletal limb, feathered caromi scalp, glacial stones
		 Return $mSalvageTrophies
	  Case 27033, 27035, 27036, 27050, 27974 ; destroyer core, saurian bone, amphibian tongue, elemental dust, undead bone
		 Return True
	  Case 28434, 18345, 21491, 37765, 30855, 22191, 22190 ; Event items
		 Return True
   EndSwitch
   If GetIsIronItem($lModelID) Then Return True
   Return GetIsRareWeapon($aItemPtr)
EndFunc   ;==>PickUpList

;~ Description: Finds items on ground, used for Pick Up Loot fuction.
Func GetNearestItemPtrTo($aAgent = GetAgentPtr(-2))
   Local $lAgentX, $lAgentY
   If IsPtr($aAgent) <> 0 Then
	  UpdateAgentPosByPtr($aAgent, $lAgentX, $lAgentY)
   ElseIf IsDllStruct($aAgent) <> 0 Then
	  $lAgentX = DllStructGetData($aAgent, 'X')
	  $lAgentY = DllStructGetData($aAgent, 'Y')
   Else
	  UpdateAgentPosByPtr(GetAgentPtr($aAgent), $lAgentX, $lAgentY)
   EndIf
   Local $lNearestAgent = 0, $lNearestDistance = 100000000
   Local $lDistance, $lAgentToCompare, $lAgentToCompareX, $lAgentToCompareY
   For $i = 1 To GetMaxAgents()
	  $lAgentToCompare = GetAgentPtr($i)
	  If MemoryRead($lAgentToCompare + 156, 'long') <> 0x400 Then ContinueLoop
	  UpdateAgentPosByPtr($lAgentToCompare, $lAgentToCompareX, $lAgentToCompareY)
	  $lDistance = ($lAgentToCompareY - $lAgentY) ^ 2 + ($lAgentToCompareX - $lAgentX) ^ 2
	  If $lDistance < $lNearestDistance Then
		 $lNearestAgent = $lAgentToCompare
		 $lNearestDistance = $lDistance
	  EndIf
   Next
   SetExtended(Sqrt($lNearestDistance)) ;this could be used to retrieve the distance also
   Return $lNearestAgent
EndFunc   ;==>GetNearestItemPtrTo
#EndRegion

#Region Itemstats
;~ Description: Returns rarity (name color) of an item.
Func GetRarity($aItem)
   If IsPtr($aItem) <> 0 Then
	  Local $lNameString = MemoryRead($aItem + 56, 'ptr')
   ElseIf IsDllStruct($aItem) <> 0 Then
	  Local $lNameString = DllStructGetData($aItem, 'Namestring')
   Else
	  Local $lNameString = MemoryRead(GetItemPtr($aItem) + 56, 'ptr')
   EndIf
   If $lNameString = 0 Then Return
   Return MemoryRead($lNameString, 'ushort')
EndFunc   ;==>GetRarity

;~ Description: Tests if an item is identified.
Func GetIsIDed($aItem)
   If IsPtr($aItem) <> 0 Then
	  Return BitAND(MemoryRead($aItem + 40, 'short'), 1) > 0
   ElseIf IsDllStruct($aItem) <> 0 Then
	  Return BitAND(DllStructGetData($aItem, 'interaction'), 1) > 0
   Else
	  Return BitAND(MemoryRead(GetItemPtr($aItem) + 40, 'short'), 1) > 0
   EndIf
EndFunc   ;==>GetIsIDed

;~ Descriptions: Tests if an item is unidentfied and can be identified.
Func GetIsUnIDed($aItem)
   If IsPtr($aItem) <> 0 Then
	  Return BitAND(MemoryRead($aItem + 40, 'long'), 8388608) > 0
   ElseIf IsDllStruct($aItem) <> 0 Then
	  Return BitAND(DllStructGetData($aItem, 'interaction'), 8388608) > 0
   Else
	  Return BitAND(MemoryRead(GetItemPtr($aItem) + 40, 'long'), 8388608) > 0
   EndIf
EndFunc   ;==>GetIsUnIDed

;~ Description: Returns a weapon or shield's minimum required attribute.
Func GetItemReq($aItem)
   Local $lMod = GetModByIdentifier($aItem, "9827")
   Return $lMod[0]
EndFunc   ;==>GetItemReq

;~ Description: Returns a weapon or shield's required attribute.
Func GetItemAttribute($aItem)
   Local $lMod = GetModByIdentifier($aItem, "9827")
   Return $lMod[1]
EndFunc   ;==>GetItemAttribute

;~ Description: Returns an array of the requested mod.
Func GetModByIdentifier($aItem, $aIdentifier)
   Local $lReturn[2]
   Local $lString = StringTrimLeft(GetModStruct($aItem), 2)
   For $i = 0 To StringLen($lString) / 8 - 2
	  If StringMid($lString, 8 * $i + 5, 4) == $aIdentifier Then
		 $lReturn[0] = Int("0x" & StringMid($lString, 8 * $i + 1, 2))
		 $lReturn[1] = Int("0x" & StringMid($lString, 8 * $i + 3, 2))
		 ExitLoop
	  EndIf
   Next
   Return $lReturn
EndFunc   ;==>GetModByIdentifier

;~ Description: Returns modstruct of an item.
Func GetModStruct($aItem)
   Local $lModstruct
   Local $lModSize
   If IsPtr($aItem) <> 0 Then
	  $lModstruct = MemoryRead($aItem + 16, 'ptr')
	  $lModSize = MemoryRead($aItem + 20, 'long')
   ElseIf IsDllStruct($aItem) <> 0 Then
	  $lModstruct = DllStructGetData($aItem, 'modstruct')
	  $lModSize = DllStructGetData($aItem, 'modstructsize')
   Else
	  Local $lItemPtr = GetItemPtr($aItem)
	  $lModstruct = MemoryRead($lItemPtr + 16, 'ptr')
	  $lModSize = MemoryRead($lItemPtr + 20, 'long')
   EndIf
   If $lModstruct = 0 Then Return False
   Return MemoryRead($lModstruct, 'Byte[' & $lModSize * 4 & ']')
EndFunc   ;==>GetModStruct

;~ Description: Tests if an item is assigned to you.
Func GetAssignedToMe($aAgent)
   If IsPtr($aAgent) <> 0 Then
	  Local $lOwner = MemoryRead($aAgent + 196, 'long')
   ElseIf IsDllStruct($aAgent) <> 0 Then
	  Local $lOwner = DllStructGetData($aAgent, 'Owner')
   Else
	  Local $lOwner = MemoryRead(GetAgentPtr($aAgent) + 196, 'long')
   EndIf
   If $lOwner = 0 Or $lOwner = GetMyID() Then
	  Return True
   Else
	  Return False
   EndIf
EndFunc   ;==>GetAssignedToMe

;~ Description: Tests if you can pick up an item.
Func GetCanPickUp($aAgent)
   Return GetAssignedToMe($aAgent)
EndFunc   ;==>GetCanPickUp

;~ Description: Returns mod's attribute.
Func GetAttributeByMod($aMod)
   Switch $aMod
	  Case "3F" ; $MODSTRUCT_HEADPIECE_DOMINATION_MAGIC
		 Return 3 ; $ATTRIB_DOMINATIONMAGIC
	  Case "40" ; $MODSTRUCT_HEADPIECE_FAST_CASTING
		 Return 1 ; $ATTRIB_FASTCASTING
	  Case "41" ; $MODSTRUCT_HEADPIECE_ILLUSION_MAGIC
		 Return 2 ; $ATTRIB_ILLUSIONMAGIC
	  Case "42" ; $MODSTRUCT_HEADPIECE_INSPIRATION_MAGIC
		 Return 4 ; $ATTRIB_INSPIRATIONMAGIC
	  Case "43" ; $MODSTRUCT_HEADPIECE_BLOOD_MAGIC
		 Return 5 ; $ATTRIB_BLOODMAGIC
	  Case "44" ; $MODSTRUCT_HEADPIECE_CURSES
		 Return 8 ; $ATTRIB_CURSES
	  Case "45" ; $MODSTRUCT_HEADPIECE_DEATH_MAGIC
		 Return 6 ; $ATTRIB_DEATHMAGIC
	  Case "46" ; $MODSTRUCT_HEADPIECE_SOUL_REAPING
		 Return 7 ; $ATTRIB_SOULREAPING
	  Case "47" ; $MODSTRUCT_HEADPIECE_AIR_MAGIC
		 Return 9 ; $ATTRIB_AIRMAGIC
	  Case "48" ; $MODSTRUCT_HEADPIECE_EARTH_MAGIC
		 Return 10 ; $ATTRIB_EARTHMAGIC
	  Case "49" ; $MODSTRUCT_HEADPIECE_ENERGY_STORAGE
		 Return 13 ; $ATTRIB_ENERGYSTORAGE
	  Case "4A" ; $MODSTRUCT_HEADPIECE_FIRE_MAGIC
		 Return 11 ; $ATTRIB_FIREMAGIC
	  Case "4B" ; $MODSTRUCT_HEADPIECE_WATER_MAGIC
		 Return 12 ; $ATTRIB_WATERMAGIC
	  Case "4C" ; $MODSTRUCT_HEADPIECE_DIVINE_FAVOR
		 Return 17 ; $ATTRIB_DIVINEFAVOR
	  Case "4D" ; $MODSTRUCT_HEADPIECE_HEALING_PRAYERS
		 Return 14 ; $ATTRIB_HEALINGPRAYERS
	  Case "4E" ; $MODSTRUCT_HEADPIECE_PROTECTION_PRAYERS
		 Return 16 ; $ATTRIB_PROTECTIONPRAYERS
	  Case "4F" ; $MODSTRUCT_HEADPIECE_SMITING_PRAYERS
		 Return 15 ; $ATTRIB_SMITINGPRAYERS
	  Case "50" ; $MODSTRUCT_HEADPIECE_AXE_MASTERY
		 Return 19 ; $ATTRIB_AXEMASTERY
	  Case "51" ; $MODSTRUCT_HEADPIECE_HAMMER_MASTERY
		 Return 20 ; $ATTRIB_HAMMERMASTERY
	  Case "53" ; $MODSTRUCT_HEADPIECE_SWORDSMANSHIP
		 Return 21 ; $ATTRIB_SWORDSMANSHIP
	  Case "54" ; $MODSTRUCT_HEADPIECE_STRENGTH
		 Return 18 ; $ATTRIB_STRENGTH
	  Case "55" ; $MODSTRUCT_HEADPIECE_TACTICS
		 Return 22 ; $ATTRIB_TACTICS
	  Case "56" ; $MODSTRUCT_HEADPIECE_BEAST_MASTERY
		 Return 23 ; $ATTRIB_BEASTMASTERY
	  Case "57" ; $MODSTRUCT_HEADPIECE_MARKSMANSHIP
		 Return 26 ; $ATTRIB_MARKSMANSHIP
	  Case "58" ; $MODSTRUCT_HEADPIECE_EXPERTISE
		 Return 24 ; $ATTRIB_EXPERTISE
	  Case "59" ; $MODSTRUCT_HEADPIECE_WILDERNESS_SURVIVAL
		 Return 25 ; $ATTRIB_WILDERNESSSURVIVAL
   EndSwitch
EndFunc   ;==>GetAttributeByMod

;~ Description: Returns max dmg of item.
Func GetItemMaxDmg($aItem)
   Local $lModString = GetModStruct($aItem)
   Local $lPos = StringInStr($lModString, "A8A7") ; Weapon Damage
   If $lPos = 0 Then $lPos = StringInStr($lModString, "C867") ; Energy (focus)
   If $lPos = 0 Then $lPos = StringInStr($lModString, "B8A7") ; Armor (shield)
   If $lPos = 0 Then Return 0
   Return Int("0x" & StringMid($lModString, $lPos - 2, 2))
EndFunc   ;==>GetItemMaxDmg

;~ Description: All these salvage into Iron.
Func GetIsIronItem($aItem)
   Local $lItemMID
   If IsPtr($aItem) <> 0 Then
	  $lItemMID = MemoryRead($aItem + 44, 'long')
   ElseIf IsDllStruct($aItem) <> 0 Then
	  $lItemMID = DllStructGetData($aItem, 'ModelID')
   Else
	  $lItemMID = $aItem
   EndIf
   Switch $lItemMID
	  Case 109, 110, 111, 113, 116, 120, 121, 126, 149, 150, 151, 153, 201, 202, 206, 214, 216, 222, 251, 254, 255, 257, 258, 259, 261, 263, 265, 266
		 Return True
	  Case 269, 271, 274, 275, 278, 279, 282, 284, 285, 286, 288, 289, 290, 326, 327, 331, 334, 335, 336, 337, 338, 343, 345, 396, 400, 402, 405, 406
		 Return True
	  Case 407, 408, 412, 418, 419, 421, 1753, 1755, 1757, 1758, 1759, 1765, 1767, 1781, 1785, 1787, 1788, 1790, 1791, 1792, 1793, 1800, 1808, 1810, 1813
		 Return True
	  Case 1815, 1820, 1825, 1827, 1830, 1831, 1832, 1834, 1835, 1837, 1841, 1844, 1850, 1851, 1852, 1857, 1858, 1859, 1860, 1863, 1869, 1871, 1872, 1873
		 Return True
	  Case 1874, 1875, 1876, 1887, 1889, 1892, 1898, 1899, 1901, 1902, 1903, 1904, 1906, 1908, 1910, 1911, 1912, 1913, 1914, 1917, 1928, 1933, 1935, 1937
		 Return True
	  Case 1941, 1944, 1946, 1947, 1954, 2040, 2041, 2042, 2043, 2065, 2072, 2077, 2078, 2104, 2109, 2191, 2200, 2201, 2204, 2211, 2218, 2219, 2220, 2222
		 Return True
	  Case 2224, 2225, 2228, 2231, 2233, 2234, 2251, 2253, 2255, 2403, 2404, 2405, 2406, 2407, 2408, 2411, 2412
		 Return True
	  Case Else
		 Return False
   EndSwitch
EndFunc   ;==>GetIsIronItem

;~ Description: Returns if rare weapon.
Func GetIsRareWeapon($aItem)
   Local $Attribute = GetItemAttribute($aItem)
   Local $Requirement = GetItemReq($aItem)
   Local $Damage = GetItemMaxDmg($aItem)
   If $Attribute = 21 And $Requirement <= 8 And $Damage = 22 Then ; req8 Swords
	  Return True
   ElseIf $Attribute = 18 And $Requirement <= 8 And $Damage = 16 Then ; req8 Shields
	  Return True
   ElseIf $Attribute = 22 And $Requirement <= 8 And $Damage = 16 Then ; Req8 Shields
	  Return True
   ElseIf $Attribute = 36 And $Requirement <= 8 And $Damage = 16 Then ; Req8 Shields
	  Return True
   ElseIf $Attribute = 37 And $Requirement <= 8 And $Damage = 16 Then ; Req Shields
	  Return True
   EndIf
   Return False
EndFunc   ;==>GetIsRareWeapon

;~ Description: Returns true if aItem is a normal material.
Func GetIsNormalMaterial($aItem)
   If IsPtr($aItem) <> 0 Then
	  Local $lItemMID = MemoryRead($aItem + 44, 'long')
   ElseIf IsDllStruct($aItem) <> 0 Then
	  Local $lItemMID = DllStructGetData($aItem, 'ModelID')
   Else
	  Local $lItemMID = $aItem
   EndIf
   Switch $lItemMID
	  Case 921, 954, 925, 929, 933, 934, 955, 948, 953, 940, 946
		 Return True
	  Case Else
		 Return False
   EndSwitch
EndFunc   ;==>GetIsNormalMaterial
#EndRegion

#Region Gold
;~ Description: Returns amount of gold in storage.
Func GetGoldStorage()
   Local $lOffset[5] = [0, 0x18, 0x40, 0xF8, 0x80]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetGoldStorage

;~ Description: Returns amount of gold being carried.
Func GetGoldCharacter()
   Local $lOffset[5] = [0, 0x18, 0x40, 0xF8, 0x7C]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetGoldCharacter

;~ Description: Drop gold on the ground.
Func DropGold($aAmount = 0)
   Local $lAmount
   If $aAmount > 0 Then
	  $lAmount = $aAmount
   Else
	  $lAmount = GetGoldCharacter()
   EndIf
   Return SendPacket(0x8, 0x29, $lAmount)
EndFunc   ;==>DropGold

;~ Description: Deposit gold into storage.
Func DepositGold($aAmount = 0)
   Local $lAmount
   Local $lStorage = GetGoldStorage()
   Local $lCharacter = GetGoldCharacter()
   If $aAmount > 0 And $lCharacter >= $aAmount Then
	  $lAmount = $aAmount
   Else
	  $lAmount = $lCharacter
   EndIf
   If $lStorage + $lAmount > 1000000 Then $lAmount = 1000000 - $lStorage
   ChangeGold($lCharacter - $lAmount, $lStorage + $lAmount)
EndFunc   ;==>DepositGold

;~ Description: Withdraw gold from storage.
Func WithdrawGold($aAmount = 0)
   Local $lAmount
   Local $lStorage = GetGoldStorage()
   Local $lCharacter = GetGoldCharacter()
   If $aAmount > 0 And $lStorage >= $aAmount Then
	  $lAmount = $aAmount
   Else
	  $lAmount = $lStorage
   EndIf
   If $lCharacter + $lAmount > 100000 Then $lAmount = 100000 - $lCharacter
   ChangeGold($lCharacter + $lAmount, $lStorage - $lAmount)
EndFunc   ;==>WithdrawGold

;~ Description: Internal use for moving gold.
Func ChangeGold($aCharacter, $aStorage)
   Return SendPacket(0xC, 0x76, $aCharacter, $aStorage)
EndFunc   ;==>ChangeGold

;~ Description: Checks the amount of gold a character holds and withdraws or stores accordingly.
;~ 		$aWithdraw 	-> max amount to be withdrawn from storage
;~ 		$aDeposit 	-> max amount to be deposited to storage
;~ 		$aMinGold 	-> below that gold will be withdrawn from storage
;~ 		$aMaxGold 	-> above MaxGold plus Variance, gold will be stored in storage, if storage not full
Func CheckGold($aWithdraw = 50000, $aDeposit = 50000, $aMinGold = 20000, $aMaxGold = 65000, $aVariance = 10000)
   Local $Gold = GetGoldCharacter()
   Local $Gold_Storage = GetGoldStorage()
   If $Gold > Random($aMaxGold-$aVariance, $aMaxGold+$aVariance) Then
	  If $Gold_Storage = 1000000 Then Return
	  If $Gold_Storage + $aDeposit > 1000000 Then
		 DepositGold(1000000 - $Gold_Storage)
	  Else
		 DepositGold($aDeposit)
	  EndIf
	  RndSleep(500)
   ElseIf $Gold < $aMinGold Then
	  If $Gold_Storage = 0 Then Return
	  If $Gold_Storage < $aWithdraw Then
		 WithdrawGold($Gold_Storage)
	  Else
		 WithdrawGold($aWithdraw)
	  EndIf
	  RndSleep(500)
   EndIf
EndFunc   ;==>CheckGold
#EndRegion

#Region Misc
;~ Description: Returns ItemID of first minipet found in inventory - searches back to front. UseItem(FindMinipet()) to use it.
Func FindMinipet()
   For $i = 4 To 1 Step -1
	  $lBagPtr = GetBagPtr($i)
	  For $j = MemoryRead($lBagPtr + 32, 'long') To 1 Step -1
		 $lItemPtr = GetItemPtrBySlot($lBagPtr, $j)
		 If MemoryRead($lItemPtr + 32, 'byte') = 34 Then Return MemoryRead($lItemPtr, 'long')
	  Next
   Next
EndFunc   ;==>FindMinipet

;~ Description: Upgrades item with upgrade.
;~ UpgradeType -->
;~ 				  For armor: 	0 -> insignia
;~ 								1 -> rune
;~ 				  For weapons: 	0 -> prefix
;~ 							  	1 -> suffix
;~ 							  	2 -> inscription
Func Upgrade($aItemPtr, $aUpgradePtr, $aUpgradeType)
   Local $lItemID = MemoryRead($aItemPtr, 'long')
   Local $lUpgradeID = MemoryRead($aUpgradePtr, 'long')
   If $lItemID = 0 Or $lUpgradeID = 0 Then Return False
   DllStructSetData($mUpgrade, 2, 0)
   DllStructSetData($mUpgrade, 3, $aUpgradeType)
   DllStructSetData($mUpgrade, 4, $lItemID)
   DllStructSetData($mUpgrade, 5, $lUpgradeID)
   Enqueue($mUpgradePtr, 20)
   Sleep(1000 + GetPing())
   Sendpacket(0x4, 0x7C)
   $lDeadlock = TimerInit()
   Do
	  Sleep(250)
	  If MemoryRead($aUpgradePtr + 12, 'ptr') = 0 Then Return True
   Until TimerDiff($lDeadlock) > 5000
EndFunc   ;==>Upgrade

;~ Description: Checks if Itemptr is armor. Returns 0 if not.
Func IsArmor($aType)
   Switch $aType
	  Case 4, 7, 13, 16, 19
		 Return $aType
	  Case Else
		 Return 0
   EndSwitch
EndFunc   ;==>IsArmor

;~ Description: Returns 1 for Rune, 2 for Insignia, 0 if not found.
Func IsRuneOrInsignia($aModelID)
   Switch $aModelID
	  Case 903, 5558, 5559 ; Warrior Runes
		 Return 1
	  Case 19152 to 19156 ; Warrior Insignias
		 Return 2
	  Case 5560, 5561, 904 ; Ranger Runes
		 Return 1
	  Case 19157 to 19162 ; Ranger Insignias
		 Return 2
	  Case 5556, 5557, 902 ; Monk Runes
		 Return 1
	  Case 19149 to 19151 ; Monk Insignias
		 Return 2
	  Case 5552, 5553, 900 ; Necromancer Runes
		 Return 1
	  Case 19138 to 19143 ; Necromancer Insignias
		 Return 2
	  Case 3612, 5549, 899 ; Mesmer Runes
		 Return 1
	  Case 19128, 19130, 19129 ; Mesmer Insignias
		 Return 2
	  Case 5554, 5555, 901 ; Elementalist Runes
		 Return 1
	  Case 19144 to 19148 ; Elementalist Insignias
		 Return 2
	  Case 6327 to 6329 ; Ritualist Runes
		 Return 1
	  Case 19165 to 19167 ; Ritualist Insignias
		 Return 2
	  Case 6324 to 6326 ; Assassin Runes
		 Return 1
	  Case 19124 to 19127 ; Assassin Insignia
		 Return 2
	  Case 15545 to 15547 ; Dervish Runes
		 Return 1
	  Case 19163 to 19164 ; Dervish Insignias
		 Return 2
	  Case 15548 to 15550 ; Paragon Runes
		 Return 1
	  Case 19168  ; Paragon Insignias
		 Return 2
	  Case 5550, 5551, 898 ; All Profession Runes
		 Return 1
	  Case 19131 to 19137 ; All Profession Insignias
		 Return 2
   EndSwitch
EndFunc   ;==>IsRuneOrInsignia
#EndRegion

#Region TempStorage
;~ Decsription: Tries to clear up one slot. --updated
Func TempStorage()
   For $i = 1 To $mBags
	  $lBagPtr = GetBagPtr($i)
	  For $j = 1 To MemoryRead($lBagPtr + 32, 'long')
		 $lItemPtr = GetItemPtrBySlot($lBagPtr, $j)
		 If $lItemPtr = 0 Then Return True ; empty slot
		 $lType = MemoryRead($lItemPtr + 32, 'byte')
		 If $lType = 29 Then ContinueLoop ; kits
		 $lMapState = GetMapLoading()
		 If $lMapState = 0 Then ; outpost
			If Not $mFoundChest Then Return False
			$lSlot = OpenStorageSlot()
			If $lSlot <> 0 Then
			   ReDim $mTempStorage[$mTempStorage[0][0] + 1][2]
			   $mTempStorage[$mTempStorage[0][0]][0] = $lSlot[0]
			   $mTempStorage[$mTempStorage[0][0]][1] = $lSlot[1]
			   MoveItem($lItemPtr, $lSlot[0], $lSlot[1])
			   Sleep(GetPing() + Random(1000, 1500, 1))
			   Return True
			EndIf
		 ElseIf $lMapState = 1 Then ; explorable
			If SalvageUses() < 2 Then Return False
			If MemoryRead($lItemPtr + 75, 'byte') > 1 Then ContinueLoop
			If GetRarity($lItemPtr) <> 2621 Then ContinueLoop ; no white item
			Switch $lType
			   Case 2, 5, 12, 15, 22, 24, 26, 27, 32, 35, 36, 0
				  DropItem($lItemPtr)
				  Sleep(GetPing() + Random(1000, 1500, 1))
				  Return True
			   Case Else
				  ContinueLoop
			EndSwitch
		 EndIf
	  Next
   Next
EndFunc   ;==>TempStorage

;~ Description: Moves temporarily relocated item back. --updated
Func RestoreStorage()
   For $i = $mTempStorage[0][0] To 1 Step -1
	  $lItemPtr = GetItemPtrBySlot($mTempStorage[$i][0], $mTempStorage[$i][1])
	  $lSlot = OpenBackpackSlot()
	  If $lSlot = 0 Then Return False
	  ReDim $mTempStorage[$mTempStorage[0][0]][2]
	  $mTempStorage[0][0] -= 1
	  MoveItem($lItemPtr, $lSlot[0], $lSlot[1])
	  Sleep(GetPing() + Random(1000, 1500, 1))
   Next
   If $lSlot = 0 Then Return False
   Return True
EndFunc   ;==>RestoreStorage

;~ Description: Returns empty backpack slot as array.
Func OpenBackpackSlot()
   For $i = 1 To $mBags
	  $lBagPtr = GetBagPtr($i)
	  For $j = 1 To MemoryRead($lBagPtr + 32, 'long')
		 If GetItemPtrBySlot($lBagPtr, $j) = 0 Then
			Local $lReturnArray[2] = [$i, $j]
			Return $lReturnArray
		 EndIf
	  Next
   Next
EndFunc   ;==>OpenBackpackSlot

;~ Description: Returns empty storage slot as array.
Func OpenStorageSlot()
   For $i = 8 To 16
	  $lBagPtr = GetBagPtr($i)
	  If $lBagPtr = 0 Then ExitLoop
	  For $j = 1 To MemoryRead($lBagPtr + 32, 'long')
		 If GetItemPtrBySlot($lBagPtr, $j) = 0 Then
			Local $lReturnArray[2] = [$i, $j]
			Return $lReturnArray
		 EndIf
	  Next
   Next
EndFunc   ;==>OpenStorageSlot

;~ Description: Returns bag and slot as array of ModelID, if stack not full (inventory).
Func FindBackpackStack($aModelID)
   For $i = 1 To 4
	  $lBagPtr = GetBagPtr($i)
	  For $j = 1 To MemoryRead($lBagPtr + 32, 'long')
		 $lItemPtr = GetItemPtrBySlot($lBagPtr, $j)
		 If $lItemPtr = 0 Then ContinueLoop
		 If MemoryRead($lItemPtr + 44, 'long') = $aModelID And MemoryRead($lItemPtr + 75, 'byte') < 250 Then
			Local $lReturnArray[2] = [$i, $j]
			Return $lReturnArray
		 EndIf
	  Next
   Next
EndFunc   ;==>FindBackpackStack

;~ Description: Returns bag and slot as array of ModelID, ExtraID, if stack is not full (storage).
Func FindStorageStack($aModelID, $aExtraID = 0)
   For $i = 8 To 16
	  $lBagPtr = GetBagPtr($i)
	  For $j = 1 To MemoryRead($lBagPtr + 32, 'long')
		 $lItemPtr = GetItemPtrBySlot($lBagPtr, $j)
		 If $lItemPtr = 0 Then ContinueLoop
		 If MemoryRead($lItemPtr + 44, 'long') = $aModelID And MemoryRead($lItemPtr + 34, 'short') = $aExtraID And MemoryRead($lItemPtr + 75, 'byte') < 250 Then
			Local $lReturnArray[2] = [$i, $j]
			Return $lReturnArray
		 EndIf
	  Next
   Next
EndFunc   ;==>FindStorageStack

;~ Description: Moves item from storage and onto stack in inventory.
Func MoveItemFromStorageByModelID($aModelID, $aAmount = 250)
   Local $lTotalCount = 0
   If CountItemInBagsByModelID($aModelID) >= $aAmount Then Return True
   For $i = 8 To 16 ; storage
	  $lBagPtr = GetBagPtr($i)
	  For $j = 1 To MemoryRead($lBagPtr + 32, 'long') ; Search all slots in this bag
		 $lBackpackSlot = FindBackpackStack($aModelID) ; Find similar slot
		 If $lBackpackSlot = 0 Then
			$lBackpackSlot = OpenBackpackSlot() ; Open New empty slot
			If $lBackpackSlot = 0 Then Return False ; Can't find empty slot in backpack
		 Else
			$lItemPtr = GetItemPtrBySlot($lBackpackSlot[0], $lBackpackSlot[1])
			$lStartCount = MemoryRead($lItemPtr + 75, 'byte')
		 EndIf
		 $lItemPtr = GetItemPtrBySlot($lBagPtr, $j) ; Get each item in this slot
		 $lStorageCount = MemoryRead($lItemPtr + 75, 'byte')
		 If MemoryRead($lItemPtr + 44, 'long') = $aModelID Then
			$lTotalCount += $lStorageCount
			MoveItem($lItemPtr, $lBackpackSlot[0], $lBackpackSlot[1])
			Sleep(GetPing() + Random(100, 150, 1))
			If $lTotalCount >= $aAmount Then Return True
		 EndIf
	  Next
   Next
   Return True
EndFunc   ;==>MoveItemFromStorageByModelID

;~ Description: Checks if modelID is low in inventory and moves then items from storage.
Func GetItemFromStorageIfLow($aModelID, $MinimumAmount = 250)
   If CountItemInBagsByModelID($aModelID) < $MinimumAmount Then
	  MoveItemFromStorageByModelID($aModelID, $MinimumAmount)
   EndIf
EndFunc   ;==>GetItemFromStorageIfLow
#EndRegion