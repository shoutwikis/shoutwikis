#include-once

;~ Description: Updates all the information you need for combat.
;~ Required functions: GetMyID, GetAgentPtr, GetIsDead, GetMapLoading, MemoryReadStruct, MemoryRead,
;~ UpdateAgentPosPtr, MemoryReadAgentPtrStruct, GetHasHex, GetHasCondition, GetNumberOfFoesInRangeOfAgent_,
;~ GetIsBoss, GetIsHealer, GetIsEnchanted
Func UpdateWorld(ByRef $aAgentArray, $aRange = 1350, $aMyID = GetMyID(), $aMe = GetAgentPtr($aMyID))
   Local $lX, $lY, $lHP, $lDistance, $lCountAOE = 1, $TeamCount = 1
   $aRange = $aRange ^ 2
   $mSelfID = $aMyID
   $mSelf = $aMe
   If GetIsDead($mSelf) Then Return False
   If GetMapLoading() <> 1 Then Return True ; not explorable
   Local $lEnergyStruct = MemoryReadStruct($mSelf + 284,'float EnergyPercent;long MaxEnergy')
   $mEnergy = DllStructGetData($lEnergyStruct, 'EnergyPercent') * DllStructGetData($lEnergyStruct, 'MaxEnergy')
   $mEffects = GetEffectsPtr()
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
   If IsArray($mEffects) <> 0 Then
	  For $i = 1 To $mEffects[0]
		 Switch MemoryRead($mEffects[$i], 'long') ; SkillID
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
   EndIf
   $lTeamSize = GetPartySize()
   If $mTeam[0] <> $lTeamSize Then
	  $mTeam[0] = $lTeamSize
	  ReDim $mTeam[$lTeamSize + 1]
   EndIf
   Dim $mTeamOthers[1] = [0]
   Dim $mTeamDead[1] = [0]
   Dim $mSpirits[1] = [0]
   Dim $mMinions[1] = [0]
   $mHighestAlly = $mSelf
   $mHighestAllyHP = 2
   $mLowestAlly = $mSelf
   $mLowestAllyHP = 2
   $mLowestOtherAlly = 0
   $mLowestOtherAllyHP = 2
   $mLowestEnemy = 0
   $mLowestEnemyHP = 2
   $mClosestEnemyDist = $aRange
   $mAverageTeamHP = 0
   $BestAOETarget = 0
   $HexedAlly = 0
   $ConditionedAlly = 0
   $EnemyHexed = 0
   $EnemyNonHexed = 0
   $EnemyConditioned = 0
   $EnemyNonConditioned = 0
   $EnemyNonEnchanted = 0
   $EnemyEnchanted = 0
   $EnemyHealer = 0
   $LowHPEnemy = 0
   $NumberOfFoesInAttackRange = 0
   $NumberOfFoesInSpellRange = 0
   UpdateAgentPosByPtr($mSelf, $lX, $lY)
;~    Local $lAgentArray = MemoryReadAgentPtrStruct(1)
   For $i = 1 To $aAgentArray[0]
	  Local $lAgentX, $lAgentY
	  UpdateAgentPosByPtr($aAgentArray[$i], $lAgentX, $lAgentY)
	  $lHP = MemoryRead($aAgentArray[$i] + 304, 'float') ; HP
	  $lAgentEffects = MemoryRead($aAgentArray[$i] + 312, 'long') ; Effects
	  $lDistance = ($lX - $lAgentX) ^ 2 + ($lY - $lAgentY) ^ 2
	  $lAllegiance = MemoryRead($aAgentArray[$i] + 433, 'byte')
	  Switch $lAllegiance ; Allegiance
		 Case 1, 6 ;Allies
			If $lAllegiance = 1 Then
			   $mTeam[$TeamCount] = $aAgentArray[$i]
			   $TeamCount += 1
			EndIf
			If IsSummonedCreature($aAgentArray[$i]) Then ContinueLoop ; necessary?
			If Not BitAND($lAgentEffects, 0x0010) Then ; alive
			   $mAverageTeamHP += $lHP
			   If $lHP < $mLowestAllyHP Then ; Lowest Ally
				  $mLowestAlly = $aAgentArray[$i]
				  $mLowestAllyHP = $lHP
			   ElseIf $lHP = $mLowestAllyHP Then
				  If $lDistance < ($lX - MemoryRead($mLowestAlly + 116, 'float')) ^ 2 + ($lY - MemoryRead($mLowestAlly + 120, 'float')) ^ 2 Then
					 $mLowestAlly = $aAgentArray[$i]
					 $mLowestAllyHP = $lHP
				  EndIf
			   ElseIf $lHP > $mHighestAllyHP Then ; Highest Ally
				  $mHighestAlly = $aAgentArray[$i]
				  $mHighestAllyHP = $lHP
			   EndIf
			   If GetHasHex($aAgentArray[$i]) Then $HexedAlly = $aAgentArray[$i]
			   If GetHasCondition($aAgentArray[$i]) Then $ConditionedAlly = $aAgentArray[$i]
			   If $aAgentArray[$i] <> $mSelf Then ; Other Allies
				  $mTeamOthers[0] += 1
				  ReDim $mTeamOthers[$mTeamOthers[0] + 1]
				  $mTeamOthers[$mTeamOthers[0]] = $aAgentArray[$i]
				  If $lHP < $mLowestOtherAllyHP Then ; Lowest Other Ally
					 $mLowestOtherAlly = $aAgentArray[$i]
					 $mLowestOtherAllyHP = $lHP
				  ElseIf $lHP = $mLowestOtherAllyHP Then
					 If $lDistance < ($lX - MemoryRead($mLowestOtherAlly + 116, 'float')) ^ 2 + ($lY - MemoryRead($mLowestOtherAlly + 120, 'float')) ^ 2 Then
						$mLowestOtherAlly = $aAgentArray[$i]
						$mLowestOtherAllyHP = $lHP
					 EndIf
				  EndIf
			   EndIf
			Else ; Dead Allies
			   $mTeamDead[0] += 1
			   ReDim $mTeamDead[$mTeamDead[0] + 1]
			   $mTeamDead[$mTeamDead[0]] = $aAgentArray[$i]
			EndIf
		 Case 3 ;Enemies
			If BitAND($lAgentEffects, 0x0010) Then ContinueLoop ; Living Enemies only
			If Blacklisted(MemoryRead($aAgentArray[$i] + 244, 'word')) Then ContinueLoop ; ignore blacklisted enemies
			If $lDistance <= $aRange Then ; Enemies in waypoint range
			   $NumberOfFoesInAttackRange += 1
			   If $lHP < $mLowestEnemyHP Then ; Lowest Enemy
				  $mLowestEnemy = $aAgentArray[$i]
				  $mLowestEnemyHP = $lHP
			   ElseIf $lHP = $mLowestEnemyHP Then
				  If $lDistance < ($lX - MemoryRead($mLowestEnemy + 116, 'float')) ^ 2 + ($lY - MemoryRead($mLowestEnemy + 120, 'float')) ^ 2 Then
					 $mLowestEnemy = $aAgentArray[$i]
					 $mLowestEnemyHP = $lHP
				  EndIf
			   EndIf
			   If GetNumberOfFoesInRangeOfAgent_($aAgentArray, $aAgentArray[$i], 256) > $lCountAOE Then
				  $BestAOETarget = $aAgentArray[$i]
				  $lCountAOE += 1
			   EndIf
			   If GetIsBoss($aAgentArray[$i]) Then
				  $BestAOETarget = $aAgentArray[$i]
				  $lCountAOE += 5
			   EndIf
			   If GetHasHex($aAgentArray[$i]) Then
				  $EnemyHexed = $aAgentArray[$i]
			   Else
				  $EnemyNonHexed = $aAgentArray[$i]
			   EndIf
			   If GetHasCondition($aAgentArray[$i]) Then
				  $EnemyConditioned = $aAgentArray[$i]
			   Else
				  $EnemyNonConditioned = $aAgentArray[$i]
			   EndIf
			   If GetIsHealer($aAgentArray[$i]) Then $EnemyHealer = $aAgentArray[$i]
			   If GetIsEnchanted($aAgentArray[$i]) Then
				  $EnemyNonEnchanted = $aAgentArray[$i]
			   Else
				  $EnemyEnchanted = $aAgentArray[$i]
			   EndIf
			EndIf
			If $lDistance <= 1440000 Then ; Enemies in spell range - 1200
			   $NumberOfFoesInSpellRange += 1
			   If MemoryRead($aAgentArray[$i] + 304, 'float') * MemoryRead($aAgentArray[$i] + 308, 'long') < 0.5 Then
				  $LowHPEnemy = $aAgentArray[$i]
			   EndIf
			EndIf
			If $lDistance < $mClosestEnemyDist Then
			   $mClosestEnemyDist = $lDistance
			   $mClosestEnemy = $aAgentArray[$i]
			EndIf
		 Case 4 ; Allied Pets/Spirits
			If BitAND($lAgentEffects, 0x0010) Then ContinueLoop
			$mSpirits[0] += 1
			ReDim $mSpirits[$mSpirits[0] + 1]
			$mSpirits[$mSpirits[0]] = $aAgentArray[$i]
		 Case 5 ; Allied Minions
			If BitAND($lAgentEffects, 0x0010) Then ContinueLoop
			$mMinions[0] += 1
			ReDim $mMinions[$mMinions[0] + 1]
			$mMinions[$mMinions[0]] = $aAgentArray[$i]
	  EndSwitch
   Next
   $mClosestEnemyDist = Sqrt($mClosestEnemyDist)
   $mAverageTeamHP /= $mTeamOthers[0] + 1
   If $NumberOfFoesInSpellRange <= 0 Then
	  $EnemyAttacker = 0
   Else
	  $EnemyAttacker = $NumberOfFoesInSpellRange
   EndIf
EndFunc   ;==>UpdateWorld

;~ Description: Blacklist for UpdateWorld(), internal use.
Func Blacklisted($aPlayernumber)
   Switch $aPlayernumber
	  Case 4116 ; Shiro Tagachi
		 Return True
	  Case 1383 ; elder wolf
		 Return True
	  Case 2226 to 2228 ; bone minions
		 Return True
	  Case 2870 to 2878 ; spirits
		 Return True
	  Case 2881 to 2884 ; spirits
		 Return True
	  Case 3962, 3963, 4205, 4206 ; corrupted scale, corrupted spore, flesh golem, vampiric horror
		 Return True
	  Case 4209 to 4228 ; spirits
		 Return True
	  Case 4230 to 4235 ; spirits
		 Return True
	  Case 5709, 5710 ; shambling horror, jagged horror
		 Return True
	  Case 5711 to 5719 ; spirits
		 Return True
	  Case 5848 to 5850 ; EVA, spirits
		 Return True
	  Case Else
		 Return False
   EndSwitch
EndFunc   ;==>Blacklisted

;~ Description: Checks number of enemies in range, can check specific Enemies with ModelID, modified to re-use agentarray.
Func GetNumberOfFoesInRangeOfAgent_(ByRef $aAgentArray, $aAgent = GetAgentPtr(-2), $aMaxDistance = 4000, $ModelID = 0)
   If IsPtr($aAgent) <> 0 Then
	  Local $lAgentPtr = $aAgent
   ElseIf IsDllStruct($aAgent) <> 0 Then
	  Local $lAgentID = DllStructGetData($aAgent, 'ID')
	  Local $lAgentPtr = GetAgentPtr($lAgentID)
   Else
	  Local $lAgentID = $aAgent
	  Local $lAgentPtr = GetAgentPtr($lAgentID)
   EndIf
   Local $lDistance, $lCount = 0
   For $i = 1 To $aAgentArray[0]
	  If $ModelID <> 0 And MemoryRead($aAgentArray[$i] + 244, 'word') <> $ModelID Then ContinueLoop
	  $lDistance = GetDistance($aAgentArray[$i], $lAgentPtr)
	  If $lDistance < $aMaxDistance Then
		 $lCount += 1
	  EndIf
   Next
   Return $lCount
EndFunc   ;==>GetNumberOfFoesInRangeOfAgent_