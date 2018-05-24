#include-once
#RequireAdmin

Func CacheSkillbar_()
   If Not $mSkillbarCache[0] Then
	  $mSkillbar = GetSkillbar()
	  $mSkillbarPtr = GetSkillbarPtr()
	  For $i = 1 To 8
		 $mSkillbarCache[$i] = DllStructGetData($mSkillbar, 'Id' & $i)
		 $mSkillbarCacheStruct[$i] = GetSkillByID($mSkillbarCache[$i])
		 $mSkillbarCachePtr[$i] = GetSkillPtr($mSkillbarCache[$i])
		 If DllStructGetData($mSkillbarCacheStruct[$i], 'Adrenaline') > 0 Then
			$SkillAdrenalineReq[$i] = DllStructGetData($mSkillbarCacheStruct[$i], 'Adrenaline')
			$SkillAdrenalineReq[0] = True
			$mSkillbarCacheEnergyReq[$i] = 0
			Update("Skill " & $i & " requires " & DllStructGetData($mSkillbarCacheStruct[$i], 'Adrenaline') & " Adrenaline.", "Skills")
		 Else
			$SkillAdrenalineReq[$i] = 0
			Switch DllStructGetData($mSkillbarCacheStruct[$i], 'EnergyCost')
			   Case 0
				  $mSkillbarCacheEnergyReq[$i] = 0
			   Case 1
				  $mSkillbarCacheEnergyReq[$i] = 1
			   Case 5
				  $mSkillbarCacheEnergyReq[$i] = 5
			   Case 10
				  $mSkillbarCacheEnergyReq[$i] = 10
			   Case 11
				  $mSkillbarCacheEnergyReq[$i] = 15
			   Case 12
				  $mSkillbarCacheEnergyReq[$i] = 25
			   Case Else
			EndSwitch
			Update("Skill " & $i & " requires " & $mSkillbarCacheEnergyReq[$i] & " energy.")
		 EndIf
		 $mSkillPriorityRating[$i][1] = 0
		 $SkillDamageAmount[$i] = SkillDamageAmount($mSkillbarCacheStruct[$i])
		 $mSkillPriorityRating[$i][0] = $i
		 If IsEliteSkill($mSkillbarCacheStruct[$i]) Then $mSkillPriorityRating[$i][1] = 30
		 ; YMLAD ; 1
		 If $mSkillbarCache[$i] = $You_Move_Like_a_Dwarf Then
			$IsYMLAD[$i] = True
			$IsYMLAD[0] = True
			$YMLADSlot = $i
			$mSkillPriorityRating[$i][1] = 120 - $i
			$mSkillPriorityRating[$i][2] = 1
			Update("Skill " & $i & " is YMLAD! Priority: " & $mSkillPriorityRating[$i][1] & ".")
			ContinueLoop
		 EndIf
		 ; Interrupt ; 2
		 If IsInterruptSkill($mSkillbarCacheStruct[$i]) Then
			$mSkillPriorityRating[$i][1] += 110 - $i
			$mSkillPriorityRating[$i][2] = 2
			$IsInterrupt[$i] = True
			$IsInterrupt[0] = True
			Update("Skill " & $i & " is an Interrupt Skill, Priority: " & $mSkillPriorityRating[$i][1] & ".")
			ContinueLoop
		 EndIf
		 ; Heal ; 3
		 If IsHealSkill($mSkillbarCacheStruct[$i]) And Not IsResSkill($mSkillbarCacheStruct[$i]) And Not IsHexRemovalSkill($mSkillbarCacheStruct[$i]) And IsConditionRemovalSkill($mSkillbarCacheStruct[$i]) == False And Not TargetOtherAllySkill($mSkillbarCacheStruct[$i]) Then
			$IsHealingSpell[$i] = True
			$IsHealingSpell[0] = True
			$mSkillPriorityRating[$i][1] += 80 - $i + $SkillDamageAmount[$i]
			$mSkillPriorityRating[$i][2] = 3
			Update("Skill " & $i & " heals ally for " & $SkillDamageAmount[$i] & ", Priority: " & $mSkillPriorityRating[$i][1] & ".")
			ContinueLoop
		 EndIf
		 ; Heal Other ; 4
		 If TargetOtherAllySkill($mSkillbarCacheStruct[$i]) == True And IsResSkill($mSkillbarCacheStruct[$i]) == False And IsHexRemovalSkill($mSkillbarCacheStruct[$i]) == False And IsConditionRemovalSkill($mSkillbarCacheStruct[$i]) == False Then
			$mSkillPriorityRating[$i][1] += 75 - $i
			$mSkillPriorityRating[$i][2] = 4
			Update("Skill " & $i & " heals other ally for " & $SkillDamageAmount[$i] & ", Priority: " & $mSkillPriorityRating[$i][1] & ".")
			ContinueLoop
		 EndIf
		 ; AOE Skills ; 5
		 If SkillAOERange($mSkillbarCacheStruct[$i]) > 0 Then
			If TargetEnemySkill($mSkillbarCacheStruct[$i]) == True Or TargetGroundSkill($mSkillbarCacheStruct[$i]) == True Then
			   $mSkillPriorityRating[$i][1] += 70 - $i
			   $mSkillPriorityRating[$i][2] = 5
			   Update("Skill " & $i & " does AOE damage of " & $SkillDamageAmount[$i] & ", Priority: " & $mSkillPriorityRating[$i][1] & ".")
			   ContinueLoop
			EndIf
		 EndIf
		 ; Soul Twisting ; 6
		 If $mSkillbarCache[$i] == $Soul_Twisting Then
			$IsSoulTwistingSpell[$i] = True
			$IsSoulTwistingSpell[0] = True
			$mSkillPriorityRating[$i][1] = 65 - $i
			$mSkillPriorityRating[$i][2] = 6
			Update("Skill " & $i & " is Soul Twisting, Priority: " & $mSkillPriorityRating[$i][1] & ".")
			ContinueLoop
		 EndIf
		 ; Spirits ; 7
		 If IsSpiritSkill($mSkillbarCacheStruct[$i]) == True Then
			$mSkillPriorityRating[$i][1] += 60 - $i
			$mSkillPriorityRating[$i][2] = 7
			Update("Skill " & $i & " is a Spirit Skill, Priority: " & $mSkillPriorityRating[$i][1] & ".")
			ContinueLoop
		 EndIf
		 ; Hex Removal ; 8
		 If IsHexRemovalSkill($mSkillbarCacheStruct[$i]) == True Then
			$mSkillPriorityRating[$i][1] = 55 - $i
			$mSkillPriorityRating[$i][2] = 8
			Update("Skill " & $i & " is a Hex Remover, Priority: " & $mSkillPriorityRating[$i][1] & ".")
			ContinueLoop
		 EndIf
		 ; Condition Removal ; 9
		 If IsConditionRemovalSkill($mSkillbarCacheStruct[$i]) == True Then
			$mSkillPriorityRating[$i][1] = 50 - $i
			$mSkillPriorityRating[$i][2] = 9
			Update("Skill " & $i & " is a Condition Remover, Priority: " & $mSkillPriorityRating[$i][1] & ".")
			ContinueLoop
		 EndIf
		 ; Weapon Spell ; 10
		 If IsWeaponSpell($mSkillbarCache[$i]) == True Then
			$IsWeaponSpell[$i] = True
			$IsWeaponSpell[0] = True
			$mSkillPriorityRating[$i][1] += 40 - $i
			$mSkillPriorityRating[$i][2] = 10
			Update("Skill " & $i & " is a Weapon Skill, Priority: " & $mSkillPriorityRating[$i][1] & ".")
			ContinueLoop
		 EndIf
		 ; Enchantment Strip ; 11
		 If IsEnchantmentStrip($mSkillbarCacheStruct[$i]) Then
			$mSkillPriorityRating[$i][1] += 35 - $i
			$mSkillPriorityRating[$i][2] = 11
			Update("Skill " & $i & " is a Enchantment Strip, Priority: " & $mSkillPriorityRating[$i][1] & ".")
			ContinueLoop
		 EndIf
		 ; General Attack ; 12
		 If SkillAOERange($mSkillbarCacheStruct[$i]) <= 0 And TargetEnemySkill($mSkillbarCacheStruct[$i]) == True And IsInterruptSkill($mSkillbarCacheStruct[$i]) == False Then
			$mSkillPriorityRating[$i][1] += 30 - $i
			If IsPvESkill($mSkillbarCacheStruct[$i]) Then $mSkillPriorityRating[$i][1] += 100
			$mSkillPriorityRating[$i][2] = 12
			Update("Skill " & $i & " Vs. enemies for " & $SkillDamageAmount[$i] & " damage, Priority: " & $mSkillPriorityRating[$i][1] & ".")
			ContinueLoop
		 EndIf
		 ; Res Skill ; 13
		 If IsResSkill($mSkillbarCacheStruct[$i]) == True Then
			$mSkillPriorityRating[$i][1] = 20 - $i
			$mSkillPriorityRating[$i][2] = 13
			Update("Skill " & $i & " is a Rez, Priority: " & $mSkillPriorityRating[$i][1] & ".")
			ContinueLoop
		 EndIf
		 ; Self-Target, Summon spirits, enchantments ; 14
		 If TargetSelfSkill($mSkillbarCacheStruct[$i]) == True And IsHealSkill($mSkillbarCacheStruct[$i]) == False And IsSpiritSkill($mSkillbarCacheStruct[$i]) == False And IsSummonSkill($mSkillbarCache[$i]) == False And $mSkillbarCache[$i] <> $Soul_Twisting Then
			$IsSelfCastingSpell[$i] = True
			$IsSelfCastingSpell[0] = True
			$mSkillPriorityRating[$i][1] += 10 - $i
			$mSkillPriorityRating[$i][2] = 14
			Update("Skill " & $i & " is a Self Targeting Skill, Priority: " & $mSkillPriorityRating[$i][1] & ".")
			ContinueLoop
		 EndIf
		 ; Asuran Summon ; 15
		 If IsSummonSkill($mSkillbarCache[$i]) == True Then
			$IsSummonSpell[$i] = True
			$IsSummonSpell[0] = True
			$mSkillPriorityRating[$i][1] = 0 - $i
			$mSkillPriorityRating[$i][2] = 15
			Update("Skill " & $i & " is a Summon, Priority: " & $mSkillPriorityRating[$i][1] & ".")
			ContinueLoop
		 EndIf
	  Next
	  $lMyProfession = GetHeroProfession(0)
	  $lAttrPrimary = GetProfPrimaryAttribute($lMyProfession)
	  _ArraySort($mSkillPriorityRating, 0, 0, 0, 1)
   EndIf
   $mSkillbarCache[0] = True
   $mSkillbarCachePtr[0] = True
   $mSkillbarCacheStruct[0] = True
EndFunc   ;==>CacheSkillbar

;~ Description: Returns current target.
Func GetCurrentTarget()
   Return GetAgentByID(GetCurrentTargetID())
EndFunc   ;==>GetCurrentTarget

;~ Description: Picks up an item.
Func PickUpItem_($aItem)
	Local $lAgentID

	If IsDllStruct($aItem) = 0 Then
		$lAgentID = $aItem
	ElseIf DllStructGetSize($aItem) < 400 Then
		$lAgentID = DllStructGetData($aItem, 'AgentID')
	Else
		$lAgentID = DllStructGetData($aItem, 'ID')
	EndIf
	Return SendPacket(0xC, 0x39, $lAgentID, 0)
EndFunc   ;==>PickUpItem

;~ Description: Returns item by slot.
Func GetItemBySlot($aBag, $aSlot)
	Local $lBag

	If IsDllStruct($aBag) = 0 Then
		$lBag = GetBag($aBag)
	Else
		$lBag = $aBag
	EndIf

	Local $lItemPtr = DllStructGetData($lBag, 'ItemArray')
	Local $lBuffer = DllStructCreate('ptr')
	Local $lItemStruct = DllStructCreate('long id;long agentId;byte unknown1[4];ptr bag;ptr modstruct;long modstructsize;ptr customized;byte unknown2[4];byte type;byte unknown3;short extraId;short value;byte unknown4[2];short interaction;long modelId;ptr modString;byte unknown5[4];ptr NameString;byte unknown6[15];byte quantity;byte equipped;byte unknown7[1];byte slot')
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', DllStructGetData($lBag, 'ItemArray') + 4 * ($aSlot - 1), 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', DllStructGetData($lBuffer, 1), 'ptr', DllStructGetPtr($lItemStruct), 'int', DllStructGetSize($lItemStruct), 'int', '')
	Return $lItemStruct
EndFunc   ;==>GetItemBySlot

;~ Description: Returns item struct.
Func GetItemByItemID($aItemID)
	Local $lItemStruct = DllStructCreate('long id;long agentId;byte unknown1[4];ptr bag;ptr modstruct;long modstructsize;ptr customized;byte unknown2[4];byte type;byte unknown3;short extraId;short value;byte unknown4[2];short interaction;long modelId;ptr modString;byte unknown5[4];ptr NameString;byte unknown6[15];byte quantity;byte equipped;byte unknown7[1];byte slot')
	Local $lOffset[5] = [0, 0x18, 0x40, 0xB8, 0x4 * $aItemID]
	Local $lItemPtr = MemoryReadPtr($mBasePointer, $lOffset)
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lItemPtr[1], 'ptr', DllStructGetPtr($lItemStruct), 'int', DllStructGetSize($lItemStruct), 'int', '')
	Return $lItemStruct
EndFunc   ;==>GetItemByItemID

;~ Description: Returns item by agent ID.
Func GetItemByAgentID($aAgentID)
	Local $lItemStruct = DllStructCreate('long id;long agentId;byte unknown1[4];ptr bag;ptr modstruct;long modstructsize;ptr customized;byte unknown2[4];byte type;byte unknown3;short extraId;short value;byte unknown4[2];short interaction;long modelId;ptr modString;byte unknown5[4];ptr NameString;byte unknown6[15];byte quantity;byte equipped;byte unknown7[1];byte slot')
	Local $lOffset[4] = [0, 0x18, 0x40, 0xC0]
	Local $lItemArraySize = MemoryReadPtr($mBasePointer, $lOffset)
	Local $lOffset[5] = [0, 0x18, 0x40, 0xB8, 0]
	Local $lItemPtr, $lItemID
	Local $lAgentID = ConvertID($aAgentID)

	For $lItemID = 1 To $lItemArraySize[1]
		$lOffset[4] = 0x4 * $lItemID
		$lItemPtr = MemoryReadPtr($mBasePointer, $lOffset)
		If $lItemPtr[1] = 0 Then ContinueLoop

		DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lItemPtr[1], 'ptr', DllStructGetPtr($lItemStruct), 'int', DllStructGetSize($lItemStruct), 'int', '')
		If DllStructGetData($lItemStruct, 'AgentID') = $lAgentID Then Return $lItemStruct
	Next
EndFunc   ;==>GetItemByAgentID

;~ Description: Returns item by model ID.
Func GetItemByModelID($aModelID, $BagsOnly = False)
   If $BagsOnly Then
	  For $i = 1 to 17
		 For $slot = 1 To DllStructGetData(GetBag($i), 'Slots')
			$lItemStruct = GetItemBySlot($i, $Slot)
			If DllStructGetData($lItemStruct, 'ID') = 0 Then ContinueLoop
			If DllStructGetData($lItemStruct, 'ModelID') == $aModelID Then Return $lItemStruct
		 Next
	  Next
   Else
	  Local $lItemStruct = DllStructCreate('long id;long agentId;byte unknown1[4];ptr bag;ptr modstruct;long modstructsize;ptr customized;byte unknown2[4];byte type;byte unknown3;short extraId;short value;byte unknown4[2];short interaction;long modelId;ptr modString;byte unknown5[4];ptr NameString;byte unknown6[15];byte quantity;byte equipped;byte unknown7[1];byte slot')
	  Local $lOffset[4] = [0, 0x18, 0x40, 0xC0]
	  Local $lItemArraySize = MemoryReadPtr($mBasePointer, $lOffset)
	  Local $lOffset[5] = [0, 0x18, 0x40, 0xB8, 0]
	  Local $lItemPtr, $lItemID

	  For $lItemID = 1 To $lItemArraySize[1]
		 $lOffset[4] = 0x4 * $lItemID
		 $lItemPtr = MemoryReadPtr($mBasePointer, $lOffset)
		 If $lItemPtr[1] = 0 Then ContinueLoop

		 DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lItemPtr[1], 'ptr', DllStructGetPtr($lItemStruct), 'int', DllStructGetSize($lItemStruct), 'int', '')
		 If DllStructGetData($lItemStruct, 'ModelID') = $aModelID Then Return $lItemStruct
	  Next
   EndIf
   Return False
EndFunc   ;==>GetItemByModelID

Func GetNumberOfFoesInRangeOfAgent_($aAgent = -2, $fMaxDistance = 4000, $ModelID = 0)
	Local $lDistance, $lCount = 0, $lAgentToCompare

	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	For $i = 1 To GetMaxAgents()
		$lAgentToCompare = GetAgentByID($i)
		If DllStructGetData($lAgentToCompare, 'Type') <> 0xDB Then ContinueLoop
		If DllStructGetData($lAgentToCompare, 'Allegiance') <> 3 Then ContinueLoop
		If DllStructGetData($lAgentToCompare, 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgentToCompare, 'Effects'), 0x0010) > 0 Then ContinueLoop
		If $ModelID <> 0 And DllStructGetData($lAgentToCompare, 'ModelID') == $ModelID Then ContinueLoop
		$lDistance = GetDistance_($lAgentToCompare, $aAgent)
		If $lDistance < $fMaxDistance Then
			$lCount += 1
		EndIf
	Next
	Return $lCount
EndFunc   ;==>GetNumberOfFoesInRangeOfAgent

Func GetDistance_($aAgent1 = -1, $aAgent2 = -2)
	If IsDllStruct($aAgent1) = 0 Then $aAgent1 = GetAgentByID($aAgent1)
	If IsDllStruct($aAgent2) = 0 Then $aAgent2 = GetAgentByID($aAgent2)
	Return Sqrt((DllStructGetData($aAgent1, 'X') - DllStructGetData($aAgent2, 'X')) ^ 2 + (DllStructGetData($aAgent1, 'Y') - DllStructGetData($aAgent2, 'Y')) ^ 2)
EndFunc   ;==>GetDistance

Func GetNumberOfAlliesInRangeOfAgent_($aAgent = -2, $fMaxDistance = 4000)
	Local $lDistance, $lCount = 0, $lAgentToCompare

	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	For $i = 1 To GetMaxAgents()
		$lAgentToCompare = GetAgentByID($i)
		If DllStructGetData($lAgentToCompare, 'Type') <> 0xDB Then ContinueLoop
		If DllStructGetData($lAgentToCompare, 'Allegiance') <> 1 Then ContinueLoop
		If DllStructGetData($lAgentToCompare, 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgentToCompare, 'Effects'), 0x0010) > 0 Then ContinueLoop
		$lDistance = GetDistance_($lAgentToCompare, $aAgent)
		If $lDistance < $fMaxDistance Then
			$lCount += 1
		EndIf
	Next
	Return $lCount
EndFunc   ;==>GetNumberOfAlliesInRangeOfAgent

;~ Returns player with most enemies around them within range $fMaxDistance
Func GetVIP_($fMaxDistance = 1350)
	Local $lCount = 0, $lAgentToCompare, $VIP = 0, $Enemies = 0

	For $i = 1 To GetMaxAgents()
		$lAgentToCompare = GetAgentByID($i)
		If DllStructGetData($lAgentToCompare, 'Type') <> 0xDB Then ContinueLoop
		If DllStructGetData($lAgentToCompare, 'Allegiance') <> 1 Then ContinueLoop
		If DllStructGetData($lAgentToCompare, 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgentToCompare, 'Effects'), 0x0010) > 0 Then ContinueLoop
		$Enemies = GetNumberOfFoesInRangeOfAgent_($lAgentToCompare, $fMaxDistance)
		If $Enemies > $lCount Then
			$VIP = $lAgentToCompare
			$lCount = $Enemies
		EndIf
	Next
	Return $VIP
EndFunc   ;==>GetVIP

;~ Description: Creates an array of agents of a given type
Func GetAgentArray($aType = 0)
	Local $lStruct
	Local $lCount
	Local $lBuffer = ''
	DllStructSetData($mMakeAgentArray, 2, $aType)
	MemoryWrite($mAgentCopyCount, -1, 'long')
	Enqueue($mMakeAgentArrayPtr, 8)
	Local $lDeadlock = TimerInit()
	Do
		Sleep(1)
		$lCount = MemoryRead($mAgentCopyCount, 'long')
	Until $lCount >= 0 Or TimerDiff($lDeadlock) > 5000
	If $lCount < 0 Then $lCount = 0
	For $i = 1 To $lCount
		$lBuffer &= 'Byte[448];'
	Next
	$lBuffer = DllStructCreate($lBuffer)
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $mAgentCopyBase, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
	Local $lReturnArray[$lCount + 1] = [$lCount]
	For $i = 1 To $lCount
		$lReturnArray[$i] = DllStructCreate('ptr vtable;byte unknown1[24];byte unknown2[4];ptr NextAgent;byte unknown3[8];long Id;float Z;byte unknown4[8];float BoxHoverWidth;float BoxHoverHeight;byte unknown5[8];float Rotation;byte unknown6[8];long NameProperties;byte unknown7[24];float X;float Y;byte unknown8[8];float NameTagX;float NameTagY;float NameTagZ;byte unknown9[12];long Type;float MoveX;float MoveY;byte unknown10[28];long Owner;byte unknown30[8];long ExtraType;byte unknown11[24];float AttackSpeed;float AttackSpeedModifier;word PlayerNumber;byte unknown12[6];ptr Equip;byte unknown13[10];byte Primary;byte Secondary;byte Level;byte Team;byte unknown14[6];float EnergyPips;byte unknown[4];float EnergyPercent;long MaxEnergy;byte unknown15[4];float HPPips;byte unknown16[4];float HP;long MaxHP;long Effects;byte unknown17[4];byte Hex;byte unknown18[18];long ModelState;long TypeMap;byte unknown19[16];long InSpiritRange;byte unknown20[16];long LoginNumber;float ModelMode;byte unknown21[4];long ModelAnimation;byte unknown22[32];byte LastStrike;byte Allegiance;word WeaponType;word Skill;byte unknown23[4];word WeaponItemId;word OffhandItemId')
		$lStruct = DllStructCreate('byte[448]', DllStructGetPtr($lReturnArray[$i]))
		DllStructSetData($lStruct, 1, DllStructGetData($lBuffer, $i))
	Next
	Return $lReturnArray
EndFunc   ;==>GetAgentArray

;~ Description: Returns an agent struct.
Func GetAgentByID($aAgentID = -2)
	;returns dll struct if successful
	Local $lAgentPtr = GetAgentPtr($aAgentID)
	If $lAgentPtr = 0 Then Return 0
	;Offsets: 0x2C=AgentID 0x9C=Type 0xF4=PlayerNumber 0114=Energy Pips
	Local $lAgentStruct = DllStructCreate('ptr vtable;byte unknown1[24];byte unknown2[4];ptr NextAgent;byte unknown3[8];long Id;float Z;byte unknown4[8];float BoxHoverWidth;float BoxHoverHeight;byte unknown5[8];float Rotation;byte unknown6[8];long NameProperties;byte unknown7[24];float X;float Y;byte unknown8[8];float NameTagX;float NameTagY;float NameTagZ;byte unknown9[12];long Type;float MoveX;float MoveY;byte unknown10[28];long Owner;byte unknown30[8];long ExtraType;byte unknown11[24];float AttackSpeed;float AttackSpeedModifier;word PlayerNumber;byte unknown12[6];ptr Equip;byte unknown13[10];byte Primary;byte Secondary;byte Level;byte Team;byte unknown14[6];float EnergyPips;byte unknown[4];float EnergyPercent;long MaxEnergy;byte unknown15[4];float HPPips;byte unknown16[4];float HP;long MaxHP;long Effects;byte unknown17[4];byte Hex;byte unknown18[18];long ModelState;long TypeMap;byte unknown19[16];long InSpiritRange;byte unknown20[16];long LoginNumber;float ModelMode;byte unknown21[4];long ModelAnimation;byte unknown22[32];byte LastStrike;byte Allegiance;word WeaponType;word Skill;byte unknown23[4];word WeaponItemId;word OffhandItemId')
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lAgentPtr, 'ptr', DllStructGetPtr($lAgentStruct), 'int', DllStructGetSize($lAgentStruct), 'int', '')
	Return $lAgentStruct
EndFunc   ;==>GetAgentByID

;~ Description: Returns agent by player name.
Func GetAgentByPlayerName($aPlayerName)
	For $i = 1 To GetMaxAgents()
		If GetPlayerName($i) = $aPlayerName Then
			Return GetAgentByID($i)
		EndIf
	Next
EndFunc   ;==>GetAgentByPlayerName

;~ Description: Returns agent by name.
Func GetAgentByName($aName)
	If $mUseStringLog = False Then Return

	Local $lName, $lAddress

	For $i = 1 To GetMaxAgents()
		$lAddress = $mStringLogBase + 256 * $i
		$lName = MemoryRead($lAddress, 'wchar [128]')
		$lName = StringRegExpReplace($lName, '[<]{1}([^>]+)[>]{1}', '')
		If StringInStr($lName, $aName) > 0 Then Return GetAgentByID($i)
	Next

	DisplayAll(True)
	Sleep(100)
	DisplayAll(False)
	DisplayAll(True)
	Sleep(100)
	DisplayAll(False)

	For $i = 1 To GetMaxAgents()
		$lAddress = $mStringLogBase + 256 * $i
		$lName = MemoryRead($lAddress, 'wchar [128]')
		$lName = StringRegExpReplace($lName, '[<]{1}([^>]+)[>]{1}', '')
		If StringInStr($lName, $aName) > 0 Then Return GetAgentByID($i)
	Next
EndFunc   ;==>GetAgentByName

;~ Description: Returns the nearest agent to an agent.
Func GetNearestAgentToAgent($aAgent = -2)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance
	Local $lAgentArray = GetAgentArray()

	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)

	Local $lID = DllStructGetData($aAgent, 'ID')

	For $i = 1 To $lAgentArray[0]
		$lDistance = (DllStructGetData($aAgent, 'X') - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + (DllStructGetData($aAgent, 'Y') - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2

		If $lDistance < $lNearestDistance Then
			If DllStructGetData($lAgentArray[$i], 'ID') == $lID Then ContinueLoop
			$lNearestAgent = $lAgentArray[$i]
			$lNearestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance))
	Return $lNearestAgent
EndFunc   ;==>GetNearestAgentToAgent

;~ Description: Returns the nearest enemy to an agent.
Func GetNearestEnemyToAgent($aAgent = -2)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance
	Local $lAgentArray = GetAgentArray(0xDB)

	If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)

	Local $lID = DllStructGetData($aAgent, 'ID')

	For $i = 1 To $lAgentArray[0]
		$lDistance = (DllStructGetData($aAgent, 'X') - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + (DllStructGetData($aAgent, 'Y') - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2
		If DllStructGetData($lAgentArray[$i], 'Allegiance') <> 3 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgentArray[$i], 'Effects'), 0x0010) > 0 Then ContinueLoop

		$lDistance = (DllStructGetData($aAgent, 'X') - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + (DllStructGetData($aAgent, 'Y') - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2
		If $lDistance < $lNearestDistance Then
			If DllStructGetData($lAgentArray[$i], 'ID') == $lID Then ContinueLoop
			$lNearestAgent = $lAgentArray[$i]
			$lNearestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance))
	Return $lNearestAgent
EndFunc   ;==>GetNearestEnemyToAgent

;~ Description: Returns the farthest enemy to an agent within given max distance
Func GetFarthestEnemyToAgent($MaxDistance = 1400, $aAgent = -2)
	Local $lFarthestAgent, $lFarthestDistance = 1
	Local $lDistance
	Local $lAgentArray = GetAgentArray(0xDB)

	If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)

	Local $lID = DllStructGetData($aAgent, 'ID')

	For $i = 1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], 'Allegiance') <> 3 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgentArray[$i], 'Effects'), 0x0010) > 0 Then ContinueLoop

		$lDistance = (DllStructGetData($aAgent, 'X') - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + (DllStructGetData($aAgent, 'Y') - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2
		If $lDistance > $lFarthestDistance And $lDistance < ($MaxDistance ^ 2) Then
			If DllStructGetData($lAgentArray[$i], 'ID') == $lID Then ContinueLoop
			$lFarthestAgent = $lAgentArray[$i]
			$lFarthestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lFarthestDistance))
	Return $lFarthestAgent
EndFunc   ;==>GetFarthestEnemyToAgent

;~ Description: Returns the nearest agent to a set of coordinates.
Func GetNearestAgentToCoords($aX, $aY)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance
	Local $lAgentArray = GetAgentArray()

	For $i = 1 To $lAgentArray[0]
		$lDistance = ($aX - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + ($aY - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2
		If $lDistance < $lNearestDistance Then
			$lNearestAgent = $lAgentArray[$i]
			$lNearestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance))
	Return $lNearestAgent
EndFunc   ;==>GetNearestAgentToCoords

;~ Description: Returns the nearest signpost to an agent.
Func GetNearestSignpostToAgent($aAgent = -2)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance
	Local $lAgentArray = GetAgentArray(0x200)

	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)

	Local $lID = DllStructGetData($aAgent, 'ID')

	For $i = 1 To $lAgentArray[0]
		$lDistance = (DllStructGetData($lAgentArray[$i], 'Y') - DllStructGetData($aAgent, 'Y')) ^ 2 + (DllStructGetData($lAgentArray[$i], 'X') - DllStructGetData($aAgent, 'X')) ^ 2
		If $lDistance < $lNearestDistance Then
			If DllStructGetData($lAgentArray[$i], 'ID') == $lID Then ContinueLoop
			$lNearestAgent = $lAgentArray[$i]
			$lNearestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance))
	Return $lNearestAgent
EndFunc   ;==>GetNearestSignpostToAgent

;~ Description: Returns the nearest signpost to a set of coordinates.
Func GetNearestSignpostToCoords($aX, $aY)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance
	Local $lAgentArray = GetAgentArray(0x200)

	For $i = 1 To $lAgentArray[0]
		$lDistance = ($aX - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + ($aY - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2

		If $lDistance < $lNearestDistance Then
			$lNearestAgent = $lAgentArray[$i]
			$lNearestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance))
	Return $lNearestAgent
EndFunc   ;==>GetNearestSignpostToCoords

;~ Description: Returns the nearest NPC to an agent.
Func GetNearestNPCToAgent($aAgent = -2)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance
	Local $lAgentArray = GetAgentArray(0xDB)

	If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)

	Local $lID = DllStructGetData($aAgent, 'ID')

	For $i = 1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], 'Allegiance') <> 6 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgentArray[$i], 'Effects'), 0x0010) > 0 Then ContinueLoop

		$lDistance = (DllStructGetData($aAgent, 'X') - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + (DllStructGetData($aAgent, 'Y') - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2
		If $lDistance < $lNearestDistance Then
			If DllStructGetData($lAgentArray[$i], 'ID') == $lID Then ContinueLoop
			$lNearestAgent = $lAgentArray[$i]
			$lNearestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance))
	Return $lNearestAgent
EndFunc   ;==>GetNearestNPCToAgent

;~ Description: Returns the nearest NPC to a set of coordinates.
Func GetNearestNPCToCoords($aX, $aY)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance
	Local $lAgentArray = GetAgentArray(0xDB)

	For $i = 1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], 'Allegiance') <> 6 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgentArray[$i], 'Effects'), 0x0010) > 0 Then ContinueLoop

		$lDistance = ($aX - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + ($aY - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2

		If $lDistance < $lNearestDistance Then
			$lNearestAgent = $lAgentArray[$i]
			$lNearestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance))
	Return $lNearestAgent
EndFunc   ;==>GetNearestNPCToCoords

;~ Description: Returns the nearest item to an agent.
Func GetNearestItemToAgent($aAgent = -2, $aCanPickUp = True)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance
	Local $lAgentArray = GetAgentArray(0x400)

	If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)

	Local $lID = DllStructGetData($aAgent, 'ID')

	For $i = 1 To $lAgentArray[0]

		If $aCanPickUp And Not GetCanPickUp($lAgentArray[$i]) Then ContinueLoop
		$lDistance = (DllStructGetData($aAgent, 'X') - DllStructGetData($lAgentArray[$i], 'X')) ^ 2 + (DllStructGetData($aAgent, 'Y') - DllStructGetData($lAgentArray[$i], 'Y')) ^ 2
		If $lDistance < $lNearestDistance Then
			If DllStructGetData($lAgentArray[$i], 'ID') == $lID Then ContinueLoop
			$lNearestAgent = $lAgentArray[$i]
			$lNearestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance))
	Return $lNearestAgent
EndFunc   ;==>GetNearestItemToAgent

;~ Description: Returns array of party members
Func GetParty()
	Local $lReturnArray[1] = [0]
	Local $lAgentArray = GetAgentArray(0xDB)
	For $i = 1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], 'Allegiance') == 1 Then
			If BitAND(DllStructGetData($lAgentArray[$i], 'TypeMap'), 131072) Then ; An agent who's health can be viewed through the party, minion, or pet menus.
				$lReturnArray[0] += 1
				ReDim $lReturnArray[$lReturnArray[0] + 1]
				$lReturnArray[$lReturnArray[0]] = $lAgentArray[$i]
			EndIf
		EndIf
	Next
	Return $lReturnArray
EndFunc   ;==>GetParty

; Returns number of party members, works in explorable only
Func GetPartySize_()
   Return UBound(GetParty())
EndFunc   ;==>GetPartySize

;~ Description: Returns array of Enemy members
Func GetEnemyParty()
	Local $lReturnArray[1] = [0]
	Local $lAgentArray = GetAgentArray(0xDB)
	For $i = 1 To $lAgentArray[0]
		If BitAND(DllStructGetData($lAgentArray[$i], 'TypeMap'), 131072) Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], 'Allegiance') == 3 Then
			$lReturnArray[0] += 1
			ReDim $lReturnArray[$lReturnArray[0] + 1]
			$lReturnArray[$lReturnArray[0]] = $lAgentArray[$i]
		EndIf
	Next
	Return $lReturnArray
EndFunc   ;==>GetEnemyParty

; Returns agent of requested player number in party
Func GetPlayerByPlayerNumber($PlayerNumber)
	Local $lReturnArray[1] = [0]
	Local $lAgentArray = GetAgentArray(0xDB)
	For $i = 1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], 'Allegiance') == 1 Then
			If BitAND(DllStructGetData($lAgentArray[$i], 'TypeMap'), 131072) Then
				If DllStructGetData($lAgentArray[$i], 'PlayerNumber') == $PlayerNumber Then
					Return $lAgentArray[$i]
				EndIf
			EndIf
		EndIf
	Next
	Return 0
EndFunc   ;==>GetPlayerByPlayerNumber

;~ Description: Updates all the information you need for combat.
Func UpdateWorld_($aRange = 1350)
	Local $LocationCount = 0
	$aRange = $aRange ^ 2
	$mSelfID = GetMyID()
	$mSelf = GetAgentByID($mSelfID)
	If GetIsDead($mSelf) Then Return False
	If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return True
	$mEnergy = DllStructGetData($mSelf, 'EnergyPercent') * DllStructGetData($mSelf, 'MaxEnergy')
	$mEffects = GetEffect()

	$mDazed = False
	$mBlind = False
	$mSkillHardCounter = False
	$mSkillSoftCounter = 0
	$mAttackHardCounter = False
	$mAttackSoftCounter = 0
	$mAllySpellHardCounter = False
	$mEnemySpellHardCounter = False
	$mSpellSoftCounter = 0
	$mBlocking = False

	For $i = 1 To $mEffects[0]
		Switch DllStructGetData($mEffects[$i], 'SkillID')
		 Case 485 ; Dazed
			$mDazed = True
		 Case 479 ; Blind
			$mBlind = True
		 Case 30, 764 ; Diversion, Wail of Doom
			$mSkillHardCounter = True
		 Case 51, 127 ; Shame, Mark of Subversion
			$mAllySpellHardCounter = True
		 Case 46, 979, 3191 ; Guilt, Mistrust
			$mEnemySpellHardCounter = True
		 Case 878, 3234 ; Visions of Regret
			$mSkillSoftCounter += 1
			$mSpellSoftCounter += 1
			$mAttackSoftCounter += 1
		 Case 28, 128 ; Backfire, Soul Leech
			$mSpellSoftCounter += 1
		 Case 47, 43, 1004, 2056, 3195 ; Ineptitude, Clumsiness, Yuletide, Wandering Eye
			$mAttackHardCounter = True
		 Case 123, 26, 3151, 121, 103, 66 ; Insidious Parasite, Empathy, Spiteful Spirit, Price of Failure, Spirit Shackles
			$mAttackSoftCounter += 1
			; Auspicious Parry, Bonetti's Defense, Deadly Riposte, Defensive Stance, Deflect Arrows,
			; Disciplined Stance, Frenzied Defense, Gladiator's Defense, Riposte, Shield Bash, Shield Stance,
			; Soldier's Stance, Wary Stance, Dodge, Dryder's Defenses, Escape, Lightning Reflexes
		 Case 905,380,388,345,373,376,1700,372,387,363,378,1698,377,425,452,448,453
			$mBlocking = True
			; Critical Defenses, Flashing Blades, Weapon of Warding, Burning Shield, Attacker's Insight,
			; Shield of Force, Mental Block, Protector's Defense, Ward Against Melee, Mirage Cloak, Natural Stride
			; Whirling Defense, Zojun's Haste, Distortion, Magnetic Aura, Sliver Armor, Swirling Aura,
		 Case 1027,1042,793,2208,1764,2201,2417,810,176,1500,1727,450,1196,11,168,1084,233
			$mBlocking = True
	  EndSwitch
	Next

	Local $lAgent
	Local $lTeam = DllStructGetData($mSelf, 'Team')
	Local $lX = XLocation()
	Local $lY = YLocation()
	Local $lHP
	Local $lDistance
	Local $lModel
	Local $lCountAOE = 1

	Dim $mTeam[1] = [0]
	Dim $mTeamOthers[1] = [0]
	Dim $mTeamDead[1] = [0]
	Dim $mEnemies[1] = [0]
	Dim $mEnemiesRange[1] = [0]
	Dim $mEnemiesSpellRange[1] = [0]
	Dim $mEnemyCorpesSpellRange[1] = [0]
	Dim $mSpirits[1] = [0]
	Dim $mPets[1] = [0]
	Dim $mMinions[1] = [0]

	$mHighestAlly = $mSelf
	$mHighestAllyHP = 2
	$mLowestAlly = $mSelf
	$mLowestAllyHP = 2
	$mLowestOtherAlly = 0
	$mLowestOtherAllyHP = 2
	$mLowestEnemy = 0
	$mLowestEnemyHP = 2
	$mClosestEnemy = 0
	$mClosestEnemyDist = 25000000
	$mAverageTeamHP = 0
	$BestAOETarget = 0
	$HexedAlly = 0
	$ConditionedAlly = 0
	$HexedEnemy = 0
	$EnemyNonHexed = 0
	$EnemyConditioned = 0
	$EnemyNonConditioned = 0
	$EnemyNonEnchanted = 0
	$EnemyEnchanted = 0
	$EnemyHealer = 0
	$LowHPEnemy = 0
	$NumberOfFoesInAttackRange = 0
	$NumberOfFoesInSpellRange = 0

	Local $lAgentArray = GetAgentArray(0xDB)
	For $i = 1 To $lAgentArray[0]
		$lAgent = $lAgentArray[$i]
		$lHP = DllStructGetData($lAgent, 'HP')
		$lDistance = ($lX - XLocation($lAgent)) ^ 2 + ($lY - YLocation($lAgent)) ^ 2
		Switch DllStructGetData($lAgent, 'Allegiance')
			Case 1, 6 ;Allies
				If Not BitAND(DllStructGetData($lAgent, 'Typemap'), 131072) Then ContinueLoop ;Double check it's not a summon
				If Not BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) Then
;~ 					$mTeam[0] += 1
;~ 					ReDim $mTeam[$mTeam[0] + 1]
;~ 					$mTeam[$mTeam[0]] = $lAgent

					$mAverageTeamHP += $lHP

;~ 					Lowest Ally
					If $lHP < $mLowestAllyHP Then
						$mLowestAlly = $lAgent
						$mLowestAllyHP = $lHP
					ElseIf $lHP = $mLowestAllyHP Then
						If $lDistance < ($lX - DllStructGetData($mLowestAlly, 'X')) ^ 2 + ($lY - DllStructGetData($mLowestAlly, 'Y')) ^ 2 Then
							$mLowestAlly = $lAgent
							$mLowestAllyHP = $lHP
						EndIf
					ElseIf $lHP > $mHighestAllyHP Then ; Highest Ally
						$mHighestAlly = $lAgent
						$mHighestAllyHP = $lHP
					EndIf

					If GetHasHex($lAgent) == True Then $HexedAlly = $lAgent
					If GetHasCondition($lAgent) == True Then $ConditionedAlly = $lAgent

;~ 					Other Allies
					If $i <> $mSelfID Then
						$mTeamOthers[0] += 1
						ReDim $mTeamOthers[$mTeamOthers[0] + 1]
						$mTeamOthers[$mTeamOthers[0]] = $lAgent

;~ 						Lowest Other Ally
						If $lHP < $mLowestOtherAllyHP Then
							$mLowestOtherAlly = $lAgent
							$mLowestOtherAllyHP = $lHP
						ElseIf $lHP = $mLowestOtherAllyHP Then
							If $lDistance < ($lX - DllStructGetData($mLowestOtherAlly, 'X')) ^ 2 + ($lY - DllStructGetData($mLowestOtherAlly, 'Y')) ^ 2 Then
								$mLowestOtherAlly = $lAgent
								$mLowestOtherAllyHP = $lHP
							EndIf
						EndIf
					EndIf
				Else
;~ 					Dead Allies
					$mTeamDead[0] += 1
					ReDim $mTeamDead[$mTeamDead[0] + 1]
					$mTeamDead[$mTeamDead[0]] = $lAgent
				EndIf
			Case 3 ;Enemies
				If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) Then ; Dead Enemies
;~ 					;Dead Enemies in spell range
;~ 					If $lDistance <= 1537600 Then ;1240
;~ 						$mEnemyCorpesSpellRange[0] += 1
;~ 						ReDim $mEnemyCorpesSpellRange[$mEnemyCorpesSpellRange[0] + 1]
;~ 						$mEnemyCorpesSpellRange[$mEnemyCorpesSpellRange[0]] = $lAgent
;~ 					EndIf
				Else

;~ 				ModelID BlackList
					$lModel = DllStructGetData($lAgent, 'PlayerNumber')
;~ 					Switch $lModel
;~ 						Case $BoneHorrorID To $BoneHorrorID + 2, $BoneHorrorID + 644 To $BoneHorrorID + 658, $BoneHorrorID + 1979 To $BoneHorrorID + 2009, $BoneHorrorID + 3483 To $BoneHorrorID + 3493, $BoneHorrorID + 3623 To $BoneHorrorID + 3624
;~ 							ContinueLoop
;~ 					EndSwitch

;~ 					$mEnemies[0] += 1
;~ 					ReDim $mEnemies[$mEnemies[0] + 1]
;~ 					$mEnemies[$mEnemies[0]] = $lAgent

;~ 				Enemies in waypoint range
					If $lDistance <= $aRange Then
						$NumberOfFoesInAttackRange += 1
;~ 						$mEnemiesRange[0] += 1
;~ 						ReDim $mEnemiesRange[$mEnemiesRange[0] + 1]
;~ 						$mEnemiesRange[$mEnemiesRange[0]] = $lAgent

;~ 					Lowest Enemy
						If $lHP < $mLowestEnemyHP Then
							$mLowestEnemy = $lAgent
							$mLowestEnemyHP = $lHP
						ElseIf $lHP = $mLowestEnemyHP Then
							If $lDistance < ($lX - DllStructGetData($mLowestEnemy, 'X')) ^ 2 + ($lY - DllStructGetData($mLowestEnemy, 'Y')) ^ 2 Then
								$mLowestEnemy = $lAgent
								$mLowestEnemyHP = $lHP
							EndIf
						EndIf

						If GetNumberOfFoesInRangeOfAgent($lAgent, 256) > $lCountAOE Then
							$BestAOETarget = $lAgent
							$lCountAOE += 1
						EndIf

						If GetIsBoss($lAgent) == True Then
							$BestAOETarget = $lAgent
							$lCountAOE += 5
						EndIf

						If GetHasHex($lAgent) == True Then
							$EnemyHexed = $lAgent
						Else
							$EnemyNonHexed = $lAgent
						EndIf
						If GetHasCondition($lAgent) == True Then
							$EnemyConditioned = $lAgent
						Else
							$EnemyNonConditioned = $lAgent
						EndIf
						If GetIsHealer($lAgent) Then $EnemyHealer = $lAgent

						If GetIsEnchanted($lAgent) Then
							$EnemyNonEnchanted = $lAgent
						Else
							$EnemyEnchanted = $lAgent
						EndIf


;~ 					Closest Enemy
;~ 						If $lDistance < $mClosestEnemyDist Then
;~ 							$mClosestEnemyDist = $lDistance
;~ 							$mClosestEnemy = $lAgent
;~ 							$mLowestEnemy = $lAgent
;~ 						EndIf
					EndIf

;~ 				Enemies in spell range
					If $lDistance <= 1440000 Then ;1200
						$NumberOfFoesInSpellRange += 1
						If DllStructGetData($lAgent, 'HP') * DllStructGetData($lAgent, 'MaxHP') < 0.5 Then
							$LowHPEnemy = $lAgent
						EndIf
;~ 						$mEnemiesSpellRange[0] += 1
;~ 						ReDim $mEnemiesSpellRange[$mEnemiesSpellRange[0] + 1]
;~ 						$mEnemiesSpellRange[$mEnemiesSpellRange[0]] = $lAgent
					EndIf
				EndIf
			Case 4 ;Allied Pets/Spirits
				If Not BitAND(DllStructGetData($lAgent, 'Typemap'), 131072) Then ContinueLoop
				If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) Then ContinueLoop
				If BitAND(DllStructGetData($lAgent, 'Typemap'), 262144) Then
					$mSpirits[0] += 1
					ReDim $mSpirits[$mSpirits[0] + 1]
					$mSpirits[$mSpirits[0]] = $lAgent
;~ 				Else
;~ 					$mPets[0] += 1
;~ 					ReDim $mPets[$mPets[0] + 1]
;~ 					$mPets[$mPets[0]] = $lAgent
				EndIf
			Case 5 ;Allied Minions
				If Not BitAND(DllStructGetData($lAgent, 'Typemap'), 131072) Then ContinueLoop
				If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) Then ContinueLoop
				$mMinions[0] += 1
				ReDim $mMinions[$mMinions[0] + 1]
				$mMinions[$mMinions[0]] = $lAgent
			Case Else
		EndSwitch
	Next
	$mClosestEnemyDist = Sqrt($mClosestEnemyDist)
	$mAverageTeamHP /= $mTeam[0]
	If $NumberOfFoesInSpellRange <= 0 Then $EnemyAttacker = 0

EndFunc   ;==>UpdateWorld


;~ Description: Returns buff struct.
Func GetBuffByIndex($aBuffNumber, $aHeroNumber = 0)
	Local $lBuffStruct = DllStructCreate('long SkillId;byte unknown1[4];long BuffId;long TargetId')
	Local $lOffset[4]
	$lOffset[0] = 0
	$lOffset[1] = 0x18
	$lOffset[2] = 0x2C
	$lOffset[3] = 0x4AC
	Local $lCount = MemoryReadPtr($mBasePointer, $lOffset)
	ReDim $lOffset[5]
	$lOffset[3] = 0x4A4
	Local $lBuffer
	For $i = 0 To $lCount[1] - 1
		$lOffset[4] = 0x24 * $i
		$lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
		If $lBuffer[1] == GetHeroID($aHeroNumber) Then
			$lOffset[4] = 0x4 + 0x24 * $i
			ReDim $lOffset[6]
			$lOffset[5] = 0 + 0x10 * ($aBuffNumber - 1)
			$lBuffStructAddress = MemoryReadPtr($mBasePointer, $lOffset)
			DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lBuffStructAddress[0], 'ptr', DllStructGetPtr($lBuffStruct), 'int', DllStructGetSize($lBuffStruct), 'int', '')
			Return $lBuffStruct
		EndIf
	Next
	Return 0
EndFunc   ;==>GetBuffByIndex

;~ Description: Returns skillbar struct.
Func GetSkillbar($aHeroNumber = 0)
	Local $lSkillbarStruct = DllStructCreate('long AgentId;long AdrenalineA1;long AdrenalineB1;dword Recharge1;dword Id1;dword Event1;long AdrenalineA2;long AdrenalineB2;dword Recharge2;dword Id2;dword Event2;long AdrenalineA3;long AdrenalineB3;dword Recharge3;dword Id3;dword Event3;long AdrenalineA4;long AdrenalineB4;dword Recharge4;dword Id4;dword Event4;long AdrenalineA5;long AdrenalineB5;dword Recharge5;dword Id5;dword Event5;long AdrenalineA6;long AdrenalineB6;dword Recharge6;dword Id6;dword Event6;long AdrenalineA7;long AdrenalineB7;dword Recharge7;dword Id7;dword Event7;long AdrenalineA8;long AdrenalineB8;dword Recharge8;dword Id8;dword Event8;dword disabled;byte unknown[8];dword Casting')
	Local $lOffset[5]
	$lOffset[0] = 0
	$lOffset[1] = 0x18
	$lOffset[2] = 0x2C
	$lOffset[3] = 0x68C
	For $i = 0 To GetHeroCount()
		$lOffset[4] = $i * 0xBC
		Local $lSkillbarStructAddress = MemoryReadPtr($mBasePointer, $lOffset)
		DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lSkillbarStructAddress[0], 'ptr', DllStructGetPtr($lSkillbarStruct), 'int', DllStructGetSize($lSkillbarStruct), 'int', '')
		If DllStructGetData($lSkillbarStruct, 'AgentId') == GetHeroID($aHeroNumber) Then Return $lSkillbarStruct
	Next
 EndFunc   ;==>GetSkillbar

;~ Description: Returns skill struct.
Func GetSkillByID($aSkillID)
	Local $lSkillStruct = DllStructCreate('long ID;byte Unknown1[4];long campaign;long Type;long Special;long ComboReq;long Effect1;long Condition;long Effect2;long WeaponReq;byte Profession;byte Attribute;byte Unknown2[2];long PvPID;byte Combo;byte Target;byte unknown3;byte EquipType;byte Unknown4a;byte EnergyCost;byte HealthCost;byte Unknown4c;dword Adrenaline;float Activation;float Aftercast;long Duration0;long Duration15;long Recharge;byte Unknown5[12];long Scale0;long Scale15;long BonusScale0;long BonusScale15;float AoERange;float ConstEffect;byte unknown6[44]')
	Local $lSkillStructAddress = $mSkillBase + 160 * $aSkillID
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lSkillStructAddress, 'ptr', DllStructGetPtr($lSkillStruct), 'int', DllStructGetSize($lSkillStruct), 'int', '')
	Return $lSkillStruct
EndFunc   ;==>GetSkillByID

;~ Description: Returns effect struct or array of effects.
Func GetEffect($aSkillID = 0, $aHeroNumber = 0)
	Local $lEffectCount, $lEffectStructAddress
	Local $lReturnArray[1] = [0]

	Local $lOffset[4]
	$lOffset[0] = 0
	$lOffset[1] = 0x18
	$lOffset[2] = 0x2C
	$lOffset[3] = 0x4AC
	Local $lCount = MemoryReadPtr($mBasePointer, $lOffset)
	ReDim $lOffset[5]
	$lOffset[3] = 0x4A4
	Local $lBuffer

	For $i = 0 To $lCount[1] - 1
		$lOffset[4] = 0x24 * $i
		$lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
		If $lBuffer[1] == GetHeroID($aHeroNumber) Then
			$lOffset[4] = 0x1C + 0x24 * $i
			$lEffectCount = MemoryReadPtr($mBasePointer, $lOffset)
			ReDim $lOffset[6]
			$lOffset[4] = 0x14 + 0x24 * $i
			$lOffset[5] = 0
			$lEffectStructAddress = MemoryReadPtr($mBasePointer, $lOffset)

			If $aSkillID = 0 Then
				ReDim $lReturnArray[$lEffectCount[1] + 1]
				$lReturnArray[0] = $lEffectCount[1]

				For $i = 0 To $lEffectCount[1] - 1
					$lReturnArray[$i + 1] = DllStructCreate('long SkillId;long EffectType;long EffectId;long AgentId;float Duration;long TimeStamp')
					$lEffectStructAddress[1] = $lEffectStructAddress[0] + 24 * $i
					DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lEffectStructAddress[1], 'ptr', DllStructGetPtr($lReturnArray[$i + 1]), 'int', 24, 'int', '')
				Next

				ExitLoop
			Else
				Local $lReturn = DllStructCreate('long SkillId;long EffectType;long EffectId;long AgentId;float Duration;long TimeStamp')

				For $i = 0 To $lEffectCount[1] - 1
					DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lEffectStructAddress[0] + 24 * $i, 'ptr', DllStructGetPtr($lReturn), 'int', 24, 'int', '')
					If DllStructGetData($lReturn, 'SkillID') = $aSkillID Then Return $lReturn
				Next
			EndIf
		EndIf
	Next
	Return $lReturnArray
EndFunc   ;==>GetEffect

;~ Description: Returns quest struct.
Func GetQuestByID($aQuestID = 0)
	Local $lQuestStruct = DllStructCreate('long id;long LogState;byte unknown1[12];long MapFrom;float X;float Y;byte unknown2[8];long MapTo')
	Local $lQuestPtr, $lQuestLogSize, $lQuestID
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x4D0]

	$lQuestLogSize = MemoryReadPtr($mBasePointer, $lOffset)

	If $aQuestID = 0 Then
		$lOffset[1] = 0x18
		$lOffset[2] = 0x2C
		$lOffset[3] = 0x4C4
		$lQuestID = MemoryReadPtr($mBasePointer, $lOffset)
		$lQuestID = $lQuestID[1]
	Else
		$lQuestID = $aQuestID
	EndIf

	Local $lOffset[5] = [0, 0x18, 0x2C, 0x4C8, 0]
	For $i = 0 To $lQuestLogSize[1]
		$lOffset[4] = 0x34 * $i
		$lQuestPtr = MemoryReadPtr($mBasePointer, $lOffset)
		DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lQuestPtr[0], 'ptr', DllStructGetPtr($lQuestStruct), 'int', DllStructGetSize($lQuestStruct), 'int', '')
		If DllStructGetData($lQuestStruct, 'ID') = $lQuestID Then Return $lQuestStruct
	Next
EndFunc   ;==>GetQuestByID

Func FindItemToSalvage()
	Local $lItemInfo
	Local $ItemToSalvage[2] = [0, 0]

	For $i = 1 To 4
		For $j = 0 To DllStructGetData(GetBag($i), 'Slots') - 1
			$lItemInfo = GetItemBySlot($i, $j)
			If GetIsIDed($lItemInfo) == False Then
				$ItemToSalvage[0] = $i
				$ItemToSalvage[1] = $j
				Return $ItemToSalvage
			EndIf
		Next
	Next
	Return $ItemToSalvage
EndFunc   ;==>FindItemToSalvage




