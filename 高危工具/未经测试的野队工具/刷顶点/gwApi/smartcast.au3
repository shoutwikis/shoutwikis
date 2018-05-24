#include-once
#include <array.au3>

;~ Description: Internal use Smartcast().
Func CanUseSkill($aSkillSlot, $aSkillbar, $aEnergy = 0, $aSoftCounter = 0)
   If $mSkillSoftCounter > $aSoftCounter Then Return False
   If $mEnergy < $aEnergy Then Return False
   Local $lSkillPtr = $mSkillbarCachePtr[$aSkillSlot]
   If GetSkillbarSkillRecharge($aSkillSlot, 0, $aSkillbar) = 0 Then
	  If GetSkillbarSkillAdrenaline($aSkillSlot, 0, $aSkillbar) < $mSkillbarCacheArray[$aSkillSlot][7] Then Return False
	  Switch $mSkillbarCacheArray[$aSkillSlot][1]
		 Case 14
			If $mBlind Then Return False
			If $mAttackHardCounter Then Return False
			If $mAttackSoftCounter > $aSoftCounter Then Return False
		 Case 4, 5, 6, 9, 11, 24, 25
			If $mSpellSoftCounter > $aSoftCounter Then Return False
			If $mDazed Then
			   If $mSkillbarCacheArray[$aSkillSlot][8] > .25 Then Return False ; activation
			EndIf
			Switch $mSkillbarCacheArray[$aSkillSlot][5] ; target
			   Case 3, 4
				  If $mAllySpellHardCounter Then Return False
			   Case 5, 16
				  If $mEnemySpellHardCounter Then Return False
			EndSwitch
	  EndSwitch
	  Return True
   EndIf
   Return False
EndFunc   ;==>CanUseSkill

;~ Description: Use Rez skill. Internal use Smartcast().
Func RezParty($RezSkill, $aMe = GetAgentPtr(-2))
   Local $lAgentX, $lAgentY, $lMeX, $lMeY
   Local $lBlocked = 0
   If MemoryRead($mTeamDead[1] + 433, 'byte') = 1 Then
   Do
	  Death()
	  UpdateAgentPosByPtr($mTeamDead[1], $lAgentX, $lAgentY)
	  Move($lAgentX, $lAgentY, 250)
	  RndSleep(500)
	  If Not GetIsMoving($aMe) Then
		 $lBlocked += 1
		 UpdateAgentPosByPtr($mTeamDead[1], $lAgentX, $lAgentY)
		 Move($lAgentX, $lAgentY, 250)
		 Sleep(200)
		 If Mod($lBlocked, 5) = 0 And Not GetIsMoving($aMe) Then
			$theta = Random(0, 360)
			UpdateAgentPosByPtr($aMe, $lMeX, $lMeY)
			Move(200 * Cos($theta * 0.01745) + $lMeX, 200 * Sin($theta * 0.01745) + $lMeY, 0)
			PingSleep(500)
		 EndIf
	  EndIf
	  UpdateAgentPosByPtr($aMe, $lMeX, $lMeY)
   Until ComputeDistance($lMeX, $lMeY, $lAgentX, $lAgentY) < 600 Or $lBlocked > 50
   UseRezSkillEx($RezSkill, $mTeamDead[1])
   EndIf
EndFunc   ;==>RezParty

;~ Description: Returns TRUE if skillbars are identical.
Func CheckSkillbarCache()
   For $i = 1 To 8
	  If $mSkillbarCache[$i] <> GetSkillbarSkillID($i) Then
		 $mSkillbarCache[0] = False
		 Return False
	  EndIf
   Next
   Return True
EndFunc   ;==>CheckSkillbarCache

;~ Description: Similar to original CacheSkillbar, but instead of storing whole skillstruct, this one only stores a few values in a 2D array.
;~ $CacheSkillArray[9][11] = [['ID', 'Type', 'Special', 'Effect1', 'Condition', 'Target', 'EnergyCost', 'Adrenaline', 'Activation', 'Aftercast', 'Recharge']]
;~ Use: $CacheSkillArray[7][2] -> 'Special' of skill in skillslot 7.
Func CacheSkillbar()
   If $mSkillbarCache[0] Then Return ; already cached
   If $mSkillbarCacheStruct[0] Then Return ; dont mix up your cacheskillbar functions
   $mSkillbarPtr = GetSkillbarPtr()
   For $i = 1 To 8
	  $mSkillbarCache[$i] = GetSkillbarSkillID($i)
	  $mSkillbarCachePtr[$i] = GetSkillPtr($mSkillbarCache[$i])
	  Local $lSkillStruct1 = MemoryReadStruct($mSkillbarCachePtr[$i] + 12, 'long Type;long Special;long Effect1;long Condition')
	  Local $lSkillStruct2 = MemoryReadStruct($mSkillbarCachePtr[$i] + 56, 'dword Adrenaline;float Activation;float Aftercast')
	  $mSkillbarCacheArray[$i][0] = $mSkillbarCache[$i] ; ID
	  $mSkillbarCacheArray[$i][1] = DllStructGetData($lSkillStruct1, 'Type') ; Type
	  $mSkillbarCacheArray[$i][2] = DllStructGetData($lSkillStruct1, 'Special') ; Special
	  $mSkillbarCacheArray[$i][3] = DllStructGetData($lSkillStruct1, 'Effect1') ; Effect1
	  $mSkillbarCacheArray[$i][4] = DllStructGetData($lSkillStruct1, 'Condition') ; Condition
	  $mSkillbarCacheArray[$i][5] = MemoryRead($mSkillbarCachePtr[$i] + 49, 'byte') ; Target
	  $mSkillbarCacheArray[$i][7] = DllStructGetData($lSkillStruct2, 'Adrenaline') ; Adrenaline
	  $mSkillbarCacheArray[$i][8] = DllStructGetData($lSkillStruct2, 'Activation') ; Activation
	  $mSkillbarCacheArray[$i][9] = DllStructGetData($lSkillStruct2, 'Aftercast') ; Aftercast
	  $mSkillbarCacheArray[$i][10] = MemoryRead($mSkillbarCachePtr[$i] + 79, 'long') ; Recharge
	  If $mSkillbarCacheArray[$i][7] > 0 Then
		 $SkillAdrenalineReq[$i] = $mSkillbarCacheArray[$i][7]
		 $SkillAdrenalineReq[0] = True
		 $mSkillbarCacheEnergyReq[$i] = 0
		 Update("Skill " & $i & " requires " & $mSkillbarCacheArray[$i][7] & " Adrenaline.", "Skills")
	  Else
		 $SkillAdrenalineReq[$i] = 0
		 Local $lEnergy = MemoryRead($mSkillbarCachePtr[$i] + 53, 'byte') ; EnergyCost
		 Switch $lEnergy
			Case 11
			   $mSkillbarCacheArray[$i][6] = 15
			Case 12
			   $mSkillbarCacheArray[$i][6] = 25
			Case Else
			   $mSkillbarCacheArray[$i][6] = $lEnergy
			EndSwitch
			$mSkillbarCacheEnergyReq[$i] = $mSkillbarCacheArray[$i][6]
		 Update("Skill " & $i & " requires " & $mSkillbarCacheEnergyReq[$i] & " energy.", "Skills")
	  EndIf
	  $mSkillPriorityRating[$i][1] = 0
	  $SkillDamageAmount[$i] = SkillDamageAmount($mSkillbarCachePtr[$i])
	  $mSkillPriorityRating[$i][0] = $i
	  If IsEliteSkill($mSkillbarCachePtr[$i]) Then $mSkillPriorityRating[$i][1] = 30
	  If $mSkillbarCache[$i] = 2358 Then ; YMLAD - 1
		 $IsYMLAD[$i] = True
		 $IsYMLAD[0] = True
		 $YMLADSlot = $i
		 $mSkillPriorityRating[$i][1] = 120 - $i
		 $mSkillPriorityRating[$i][2] = 1
		 Update("Skill " & $i & " is YMLAD! Priority: " & $mSkillPriorityRating[$i][1] & ".", "Skills")
		 ContinueLoop
	  EndIf
	  If IsInterruptSkill($mSkillbarCachePtr[$i]) Then ; Interrupt - 2
		 $mSkillPriorityRating[$i][1] += 110 - $i
		 $mSkillPriorityRating[$i][2] = 2
		 $IsInterrupt[$i] = True
		 $IsInterrupt[0] = True
		 Update("Skill " & $i & " is an Interrupt Skill, Priority: " & $mSkillPriorityRating[$i][1] & ".", "Skills")
		 ContinueLoop
	  EndIf
	  If IsHexRemovalSkill($mSkillbarCachePtr[$i]) Then ; Hex Removal ; 8
		 $mSkillPriorityRating[$i][1] = 55 - $i
		 $mSkillPriorityRating[$i][2] = 8
		 Update("Skill " & $i & " is a Hex Remover, Priority: " & $mSkillPriorityRating[$i][1] & ".", "Skills")
		 ContinueLoop
	  EndIf
	  ; Condition Removal ; 9
	  If IsConditionRemovalSkill($mSkillbarCachePtr[$i]) Then
		 $mSkillPriorityRating[$i][1] = 50 - $i
		 $mSkillPriorityRating[$i][2] = 9
		 Update("Skill " & $i & " is a Condition Remover, Priority: " & $mSkillPriorityRating[$i][1] & ".", "Skills")
		 ContinueLoop
	  EndIf
	  ; Res Skill ; 13
	  If IsResSkill($mSkillbarCachePtr[$i]) Then
		 $mSkillPriorityRating[$i][1] = 20 - $i
		 $mSkillPriorityRating[$i][2] = 13
		 Update("Skill " & $i & " is a Rez, Priority: " & $mSkillPriorityRating[$i][1] & ".", "Skills")
		 ContinueLoop
	  EndIf
	  ; Heal ; 3
	  If IsHealSkill($mSkillbarCachePtr[$i]) Then
		 ; Heal Other ; 4
		 If TargetOtherAllySkill($mSkillbarCachePtr[$i]) Then
			$mSkillPriorityRating[$i][1] += 75 - $i
			$mSkillPriorityRating[$i][2] = 4
			Update("Skill " & $i & " heals other ally for " & $SkillDamageAmount[$i] & ", Priority: " & $mSkillPriorityRating[$i][1] & ".", "Skills")
			ContinueLoop
		 EndIf
		 $IsHealingSpell[$i] = True
		 $IsHealingSpell[0] = True
		 $mSkillPriorityRating[$i][1] += 80 - $i + $SkillDamageAmount[$i]
		 $mSkillPriorityRating[$i][2] = 3
		 Update("Skill " & $i & " heals ally for " & $SkillDamageAmount[$i] & ", Priority: " & $mSkillPriorityRating[$i][1] & ".", "Skills")
		 ContinueLoop
	  EndIf
	  ; AOE Skills ; 5
	  If SkillAOERange($mSkillbarCachePtr[$i]) > 0 Then
		 If TargetEnemySkill($mSkillbarCachePtr[$i]) Or TargetGroundSkill($mSkillbarCachePtr[$i]) Then
			$mSkillPriorityRating[$i][1] += 70 - $i
			$mSkillPriorityRating[$i][2] = 5
			Update("Skill " & $i & " does AOE damage of " & $SkillDamageAmount[$i] & ", Priority: " & $mSkillPriorityRating[$i][1] & ".", "Skills")
			ContinueLoop
		 EndIf
	  EndIf
	  ; Soul Twisting ; 6
	  If $mSkillbarCache[$i] = 1240 Then ; $SKILLID_Soul_Twisting
		 $IsSoulTwistingSpell[$i] = True
		 $IsSoulTwistingSpell[0] = True
		 $mSkillPriorityRating[$i][1] = 65 - $i
		 $mSkillPriorityRating[$i][2] = 6
		 Update("Skill " & $i & " is Soul Twisting, Priority: " & $mSkillPriorityRating[$i][1] & ".", "Skills")
		 ContinueLoop
	  EndIf
	  ; Spirits ; 7
	  If IsSpiritSkill($mSkillbarCachePtr[$i]) Then
		 $mSkillPriorityRating[$i][1] += 60 - $i
		 $mSkillPriorityRating[$i][2] = 7
		 Update("Skill " & $i & " is a Spirit Skill, Priority: " & $mSkillPriorityRating[$i][1] & ".", "Skills")
		 ContinueLoop
	  EndIf
	  ; Weapon Spell ; 10
	  If IsWeaponSpell($mSkillbarCachePtr[$i]) Then
		 $IsWeaponSpell[$i] = True
		 $IsWeaponSpell[0] = True
		 $mSkillPriorityRating[$i][1] += 40 - $i
		 $mSkillPriorityRating[$i][2] = 10
		 Update("Skill " & $i & " is a Weapon Skill, Priority: " & $mSkillPriorityRating[$i][1] & ".", "Skills")
		 ContinueLoop
	  EndIf
	  ; Enchantment Strip ; 11
	  If IsEnchantmentStrip($mSkillbarCachePtr[$i]) Then
		 $mSkillPriorityRating[$i][1] += 35 - $i
		 $mSkillPriorityRating[$i][2] = 11
		 Update("Skill " & $i & " is a Enchantment Strip, Priority: " & $mSkillPriorityRating[$i][1] & ".", "Skills")
		 ContinueLoop
	  EndIf
	  ; General Attack ; 12
	  If TargetEnemySkill($mSkillbarCachePtr[$i]) Then
		 $mSkillPriorityRating[$i][1] += 30 - $i
		 If IsPvESkill($mSkillbarCacheStruct[$i]) Then $mSkillPriorityRating[$i][1] += 100
		 $mSkillPriorityRating[$i][2] = 12
		 Update("Skill " & $i & " Vs. enemies for " & $SkillDamageAmount[$i] & " damage, Priority: " & $mSkillPriorityRating[$i][1] & ".", "Skills")
		 ContinueLoop
	  EndIf
	  ; Asuran Summon ; 15
	  If IsSummonSkill($mSkillbarCache[$i]) Then
		 $IsSummonSpell[$i] = True
		 $IsSummonSpell[0] = True
		 $mSkillPriorityRating[$i][1] = 0 - $i
		 $mSkillPriorityRating[$i][2] = 15
		 Update("Skill " & $i & " is a Summon, Priority: " & $mSkillPriorityRating[$i][1] & ".", "Skills")
		 ContinueLoop
	  EndIf
	  ; Self-Target, Summon spirits, enchantments ; 14
	  If TargetSelfSkill($mSkillbarCachePtr[$i]) Then
		 $IsSelfCastingSpell[$i] = True
		 $IsSelfCastingSpell[0] = True
		 $mSkillPriorityRating[$i][1] += 10 - $i
		 $mSkillPriorityRating[$i][2] = 14
		 Update("Skill " & $i & " is a Self Targeting Skill, Priority: " & $mSkillPriorityRating[$i][1] & ".", "Skills")
		 ContinueLoop
	  EndIf
   Next
   $lMyProfession = GetHeroProfession(0)
   $lAttrPrimary = GetProfPrimaryAttribute($lMyProfession)
   _ArraySort($mSkillPriorityRating, 0, 0, 0, 1)
   $mSkillbarCache[0] = True
   $mSkillbarCachePtr[0] = True
EndFunc   ;==>CacheSkillbar

;~ Description: SmartCast by JCaulton, 4D1, Savsud.
;~ Required functions: CacheSkillbar, DropBundle, RezParty, CanUseSkill, UseSkillEx
;~ GetStatus: GetSkillbarSkillAdrenaline, GetDistance, GetSkillbarSkillRecharge, GetMapLoading, GetIsDead
;~ Skilleffects: IsAntiMeleeSkill, GetHasWeaponSpell, HasEffect, IsHealingSpell, IsHexSpell, IsConditionSpell, IsBelow50PercentEnemySkill
Func SmartCast($aMe = GetAgentPtr(-2))
   #Region Variables
   If GetIsDead($aMe) Then Return False
   If GetMapLoading() <> 1 Then Return True ; $INSTANCETYPE_EXPLORABLE
   If Not $mSkillbarCache[0] Then
;~ 	  $mSkillbarPtr = GetSkillbarPtr()
	  CacheSkillbar()
   EndIf
   #EndRegion Variables

   #Region Specific Skills
   If $IsHealingSpell[0] Then
	  If HasEffect(1219) Then ; $SKILLID_Protective_Was_Kaolai
		 If $mAverageTeamHP < 0.80 Or $mLowestAllyHP < 0.3 Then
			DropBundle()
			Return
		 EndIf
	  EndIf
   EndIf
   #EndRegion Specific Skills

   ; Skill usage
   For $r = 8 To 1 Step -1 ; Skill priority set in Ascending order.
	  $i = $mSkillPriorityRating[$r][0] ;  [0] is skill #, [1] is priority, [2] is SmartCast Type

	  ;; Check Recharge, Energy, and Adrenaline
	  If $SkillAdrenalineReq[$i] = 0 Then
		 If GetSkillbarSkillRecharge($i) Or Not CanUseSkill($i, $mSkillbarPtr, $mSkillbarCacheEnergyReq[$i]) Then ContinueLoop
	  ElseIf $SkillAdrenalineReq[$i] > GetSkillbarSkillAdrenaline($i) Then
		 ContinueLoop
	  EndIf
	  Switch $mSkillPriorityRating[$r][2] ;  [0] is skill #, [1] is priority, [2] is SmartCast Type
		 Case 1 ; YMLAD ; 1
			Switch $NumberOfFoesInAttackRange
			   Case 0
				  ContinueLoop
			   Case 1, 2
				  If GetDistance($mLowestEnemy) < 1200 Then
					 UseSkillEx($i, $mLowestEnemy)
					 Return
				  EndIf
			   Case Else
				  If GetDistance($EnemyNonConditioned) < 1200 Then
					 UseSkillEx($i, $EnemyNonConditioned)
					 Return
				  EndIf
			EndSwitch
		 Case 3 ; Heal ; 3
			If $mSkillbarCache[$i] = 1219 Then ; $SKILLID_Protective_Was_Kaolai
			   If Not HasEffect(1219) Then ; $SKILLID_Protective_Was_Kaolai
				  UseSkillEx($i, $aMe)
				  Return
			   EndIf
			EndIf
			If $mLowestAllyHP < 0.75 Then
			   If $IsWeaponSpell[$i] Then
				  If $NumberOfFoesInAttackRange And Not GetHasWeaponSpell($mLowestAlly) Then
					 UseSkillEx($i, $mLowestAlly)
					 Return
				  EndIf
			   Else
				  UseSkillEx($i, $mLowestAlly)
				  Return
			   EndIf
			EndIf
		 Case 4 ; Heal Other ; 4
			If $mLowestOtherAllyHP < 0.75 Then
			   If $IsWeaponSpell[$i] Then
				  If $NumberOfFoesInAttackRange And Not GetHasWeaponSpell($mLowestOtherAlly) Then
					 UseSkillEx($i, $mLowestOtherAlly)
					 Return
				  EndIf
			   Else
				  UseSkillEx($i, $mLowestOtherAlly)
				  Return
			   EndIf
			EndIf
		 Case 5 ; AOE Skills ; 5
			If Not $NumberOfFoesInAttackRange Then ContinueLoop
			   If $mSkillbarCache[$i] = 1657 Then ; $SKILLID_Signet_of_Clumsiness
				  If $EnemyAttacker <> 0 Then
					 UseSkillEx($i, $EnemyAttacker)
					 Return
				  EndIf
			   Else
				  If $BestAOETarget <> 0 Then
					 UseSkillEx($i, $BestAOETarget)
					 Return
				  EndIf
				  If $EnemyHealer <> 0 Then
					 UseSkillEx($i, $EnemyHealer)
					 Return
				  EndIf
				  If $mLowestEnemy <> 0 Then
					 UseSkillEx($i, $mLowestEnemy)
					 Return
				  EndIf
			   EndIf
		 Case 6 ; Soul Twisting ; 6
			If Not HasEffect(1240) Then ; $SKILLID_Soul_Twisting
			   UseSkillEx($i, $aMe)
			   Return
			EndIf
		 Case 7 ; Spirits ; 7
			If Not $NumberOfFoesInAttackRange Then ContinueLoop
			   If $IsSoulTwistingSpell[0] Then
				  If HasEffect(1240) And Not HasEffect($mSkillbarCache[$i]) Then ; $SKILLID_Soul_Twisting
					 UseSkillEx($i, $aMe)
					 Return
				  EndIf
			   Else
				  UseSkillEx($i, $aMe)
				  Return
			   EndIf
		 Case 8 ; Hex Removal ; 8
			If $HexedAlly <> 0 Then
			   UseSkillEx($i, $HexedAlly)
			   Return
			EndIf
		 Case 9 ; Condition Removal ; 9
			If $ConditionedAlly <> 0 Then
			   UseSkillEx($i, $ConditionedAlly)
			   Return
			EndIf
		 Case 10 ; Weapon Spell ; 10
			If Not $NumberOfFoesInAttackRange Then ContinueLoop
		 Case 11 ; Enchantment Strip ; 11
			If $EnemyEnchanted <> 0 Then
			   UseSkillEx($i, $EnemyEnchanted)
			   Return
			EndIf
		 Case 12 ; General Attack ; 12
			If Not $NumberOfFoesInAttackRange Then ContinueLoop
			If $EnemyHealer <> 0 Then
			   UseSkillEx($i, $EnemyHealer)
			   Return
			EndIf
			$IsAntiMeleeSkill = IsAntiMeleeSkill($mSkillbarCache[$i])
			$IsHexingSpell = IsHexSpell($mSkillbarCachePtr[$i])
			$IsConditioningSpell = IsConditionSpell($mSkillbarCachePtr[$i])
			$IsBelow50 = IsBelow50PercentEnemySkill($mSkillbarCachePtr[$i])
			If $IsAntiMeleeSkill And $EnemyAttacker <> 0 Then
			   UseSkillEx($i, $EnemyAttacker)
			   Return
			EndIf
			If $IsBelow50 And $LowHPEnemy <> 0 Then
			   UseSkillEx($i, $LowHPEnemy)
			   Return
			EndIf
			If $IsHexingSpell And Not $IsConditioningSpell And Not $IsAntiMeleeSkill And $EnemyNonHexed <> 0 Then
			   UseSkillEx($i, $EnemyNonHexed)
			   Return
			EndIf
			If $IsConditioningSpell And Not $IsHexingSpell And Not $IsAntiMeleeSkill And $EnemyConditioned <> 0 Then
			   UseSkillEx($i, $EnemyConditioned)
			   Return
			EndIf
			If $IsConditioningSpell And $EnemyNonConditioned <> 0 Then
			   UseSkillEx($i, $EnemyNonConditioned)
			   Return
			EndIf
			If $IsHexingSpell And $EnemyNonHexed <> 0 Then
			   UseSkillEx($i, $EnemyNonHexed)
			   Return
			EndIf
			If $mLowestEnemy <> 0 And Not $IsBelow50 Then
			   UseSkillEx($i, $mLowestEnemy)
			   Return
			EndIf
		 Case 13 ; Res Skill ; 13
			If $mTeamDead[0] > 0 Then
			   RezParty($i, $aMe)
			   Return
			EndIf
		 Case 14 ; Self-Target, Summon spirits, enchantments ; 14
			If Not $NumberOfFoesInAttackRange Then ContinueLoop
			If UBound($mSpirits) < 3 And $mSkillbarCache[$i] = 2051 Then ContinueLoop ; $SKILLID_Summon_Spirits
			If Not HasEffect($mSkillbarCache[$i]) Then
			   UseSkillEx($i, $aMe)
			   Return
			EndIf
		 Case 15 ; Asuran Summon ; 15
			If $NumberOfFoesInAttackRange < 2 Then
			   UseSkillEx($i, $aMe)
			   Return
			EndIf
		 Case Else
			ContinueLoop
	  EndSwitch
   Next
EndFunc   ;==>SmartCast