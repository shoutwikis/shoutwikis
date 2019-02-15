#include-once
#include "激战常数.au3"
#include "../../激战接口.au3"

Func UseItemByModelID($aModelID)
	Local $lItem
	For $lBag=1 To 4
		For $lSlot=1 To DllStructGetData(GetBag($lBag), 'Slots')
			$lItem = GetItemBySlot($lBag, $lSlot)
			If DllStructGetData($lItem, "ModelID") == $aModelID Then Return SendPacket(0x8, $UseItemHeader, DllStructGetData($lItem, "ID"))
		Next
	Next
	Return False
EndFunc

Func pingSleep($additionalTime=500, $random=100)
	Sleep(GetPing()+$additionalTime+Random(0, $random, 1))
EndFunc

Func getSkillPosition($skillID, $skillBar = 0)
	If $skillBar == 0 Then $skillBar = getSkillBar()
	For $i = 1 To 8 Step 1
		If DllStructGetData($skillBar, "ID" & $i) == $skillID Then
			Return $i
		EndIf
	Next
	Return 0
EndFunc   ;==>getSkillPosition

Func GetProfessionByAttribute($aAttr)
	Switch $aAttr
		Case $ATTR_FAST_CASTING, $ATTR_ILLUSION_MAGIC, $ATTR_DOMINATION_MAGIC, $ATTR_INSPIRATION_MAGIC
			Return $PROF_MESMER
		Case $ATTR_BLOOD_MAGIC, $ATTR_DEATH_MAGIC, $ATTR_SOUL_REAPING, $ATTR_CURSES
			Return $PROF_NECROMANCER
		Case $ATTR_AIR_MAGIC, $ATTR_EARTH_MAGIC, $ATTR_FIRE_MAGIC, $ATTR_WATER_MAGIC, $ATTR_ENERGY_STORAGE
			Return $PROF_ELEMENTALIST
		Case $ATTR_HEALING_PRAYERS, $ATTR_PROTECTION_PRAYERS, $ATTR_DIVINE_FAVOR, $ATTR_SMITING_PRAYERS
			Return $PROF_MONK
		Case $ATTR_STRENGTH, $ATTR_AXE_MASTERY, $ATTR_HAMMER_MASTERY, $ATTR_SWORDSMANSHIP, $ATTR_TACTICS
			Return $PROF_WARRIOR
		Case $ATTR_BEAST_MASTERY, $ATTR_EXPERTISE, $ATTR_WILDERNESS_SURVIVAL, $ATTR_MARKSMANSHIP
			Return $PROF_RANGER
		Case $ATTR_DAGGER_MASTERY, $ATTR_DEADLY_ARTS, $ATTR_SHADOW_ARTS, $ATTR_CRITICAL_STRIKES
			Return $PROF_ASSASSIN
		Case $ATTR_COMMUNING, $ATTR_RESTORATION_MAGIC, $ATTR_CHANNELING_MAGIC, $ATTR_SPAWNING_POWER
			Return $PROF_RITUALIST
		Case $ATTR_SPEAR_MASTERY, $ATTR_COMMAND, $ATTR_MOTIVATION, $ATTR_LEADERSHIP
			Return $PROF_PARAGON
		Case $ATTR_SCYTHE_MASTERY, $ATTR_WIND_PRAYERS, $ATTR_EARTH_PRAYERS, $ATTR_MYSTICISM
			Return $PROF_DERVISH
		Case Else
			Return $PROF_NONE
	EndSwitch
EndFunc

Func GetSecondaryAttributesByProfession($aProf)
	Local $ret[5]
	Switch $aProf
		Case $PROF_NONE
			$ret[0] = 1
		Case $PROF_MESMER
			$ret[0] = 3
			$ret[1] = $ATTR_DOMINATION_MAGIC
			$ret[2] = $ATTR_ILLUSION_MAGIC
			$ret[3] = $ATTR_INSPIRATION_MAGIC
		Case $PROF_NECROMANCER
			$ret[0] = 3
			$ret[1] = $ATTR_BLOOD_MAGIC
			$ret[2] = $ATTR_DEATH_MAGIC
			$ret[3] = $ATTR_CURSES
		Case $PROF_ELEMENTALIST
			$ret[0] = 4
			$ret[1] = $ATTR_AIR_MAGIC
			$ret[2] = $ATTR_EARTH_MAGIC
			$ret[3] = $ATTR_FIRE_MAGIC
			$ret[4] = $ATTR_WATER_MAGIC
		Case $PROF_MONK
			$ret[0] = 3
			$ret[1] = $ATTR_HEALING_PRAYERS
			$ret[2] = $ATTR_PROTECTION_PRAYERS
			$ret[3] = $ATTR_SMITING_PRAYERS
		Case $PROF_WARRIOR
			$ret[0] = 4
			$ret[1] = $ATTR_AXE_MASTERY
			$ret[2] = $ATTR_HAMMER_MASTERY
			$ret[3] = $ATTR_SWORDSMANSHIP
			$ret[4] = $ATTR_TACTICS
		Case $PROF_RANGER
			$ret[0] = 3
			$ret[1] = $ATTR_BEAST_MASTERY
			$ret[2] = $ATTR_WILDERNESS_SURVIVAL
			$ret[3] = $ATTR_MARKSMANSHIP
		Case $PROF_ASSASSIN
			$ret[0] = 3
			$ret[1] = $ATTR_DAGGER_MASTERY
			$ret[2] = $ATTR_DEADLY_ARTS
			$ret[3] = $ATTR_SHADOW_ARTS
		Case $PROF_RITUALIST
			$ret[0] = 3
			$ret[1] = $ATTR_COMMUNING
			$ret[2] = $ATTR_RESTORATION_MAGIC
			$ret[3] = $ATTR_CHANNELING_MAGIC
		Case $PROF_PARAGON
			$ret[0] = 3
			$ret[1] = $ATTR_SPEAR_MASTERY
			$ret[2] = $ATTR_COMMAND
			$ret[3] = $ATTR_MOTIVATION
		Case $PROF_DERVISH
			$ret[0] = 3
			$ret[1] = $ATTR_SCYTHE_MASTERY
			$ret[2] = $ATTR_WIND_PRAYERS
			$ret[3] = $ATTR_EARTH_PRAYERS
	EndSwitch
	Return $ret
EndFunc

Func GetAttributeByMod($aMod)
	Switch $aMod
		Case $MODSTRUCT_HEADPIECE_DOMINATION_MAGIC
			Return $ATTR_DOMINATION_MAGIC
		Case $MODSTRUCT_HEADPIECE_FAST_CASTING
			Return $ATTR_FAST_CASTING
		Case $MODSTRUCT_HEADPIECE_ILLUSION_MAGIC
			Return $ATTR_ILLUSION_MAGIC
		Case $MODSTRUCT_HEADPIECE_INSPIRATION_MAGIC
			Return $ATTR_INSPIRATION_MAGIC
		Case $MODSTRUCT_HEADPIECE_BLOOD_MAGIC
			Return $ATTR_BLOOD_MAGIC
		Case $MODSTRUCT_HEADPIECE_CURSES
			Return $ATTR_CURSES
		Case $MODSTRUCT_HEADPIECE_DEATH_MAGIC
			Return $ATTR_DEATH_MAGIC
		Case $MODSTRUCT_HEADPIECE_SOUL_REAPING
			Return $ATTR_SOUL_REAPING
		Case $MODSTRUCT_HEADPIECE_AIR_MAGIC
			Return $ATTR_AIR_MAGIC
		Case $MODSTRUCT_HEADPIECE_EARTH_MAGIC
			Return $ATTR_EARTH_MAGIC
		Case $MODSTRUCT_HEADPIECE_ENERGY_STORAGE
			Return $ATTR_ENERGY_STORAGE
		Case $MODSTRUCT_HEADPIECE_FIRE_MAGIC
			Return $ATTR_FIRE_MAGIC
		Case $MODSTRUCT_HEADPIECE_WATER_MAGIC
			Return $ATTR_WATER_MAGIC
		Case $MODSTRUCT_HEADPIECE_DIVINE_FAVOR
			Return $ATTR_DIVINE_FAVOR
		Case $MODSTRUCT_HEADPIECE_HEALING_PRAYERS
			Return $ATTR_HEALING_PRAYERS
		Case $MODSTRUCT_HEADPIECE_PROTECTION_PRAYERS
			Return $ATTR_PROTECTION_PRAYERS
		Case $MODSTRUCT_HEADPIECE_SMITING_PRAYERS
			Return $ATTR_SMITING_PRAYERS
		Case $MODSTRUCT_HEADPIECE_AXE_MASTERY
			Return $ATTR_AXE_MASTERY
		Case $MODSTRUCT_HEADPIECE_HAMMER_MASTERY
			Return $ATTR_HAMMER_MASTERY
		Case $MODSTRUCT_HEADPIECE_SWORDSMANSHIP
			Return $ATTR_SWORDSMANSHIP
		Case $MODSTRUCT_HEADPIECE_STRENGTH
			Return $ATTR_STRENGTH
		Case $MODSTRUCT_HEADPIECE_TACTICS
			Return $ATTR_TACTICS
		Case $MODSTRUCT_HEADPIECE_BEAST_MASTERY
			Return $ATTR_BEAST_MASTERY
		Case $MODSTRUCT_HEADPIECE_MARKSMANSHIP
			Return $ATTR_MARKSMANSHIP
		Case $MODSTRUCT_HEADPIECE_EXPERTISE
			Return $ATTR_EXPERTISE
		Case $MODSTRUCT_HEADPIECE_WILDERNESS_SURVIVAL
			Return $ATTR_WILDERNESS_SURVIVAL
		Case Else
			Return $ATTR_NONE
	EndSwitch
EndFunc

Func GetAgentPrimaryProfession($aAgent = -2)
	Return DllStructGetData(GetAgentByID($aAgent()), "Primary")
EndFunc

Func GetAgentSecondaryProfession($aAgent = -2)
	Return DllStructGetData(GetAgentByID($aAgent()), "Secondary")
EndFunc

Func GetAgentProfessionsName($aAgent = -2)
	Return GetProfessionName(GetAgentPrimaryProfession($aAgent))&"/"&GetProfessionName(GetAgentSecondaryProfession($aAgent))
EndFunc
#cs
Func GetProfessionName($aProf)
	Switch $aProf
		Case $PROF_NONE
			Return "x"
		Case $PROF_WARRIOR
			Return "W"
		Case $PROF_RANGER
			Return "R"
		Case $PROF_MONK
			Return "Mo"
		Case $PROF_NECROMANCER
			Return "N"
		Case $PROF_MESMER
			Return "Me"
		Case $PROF_ELEMENTALIST
			Return "E"
		Case $PROF_ASSASSIN
			Return "A"
		Case $PROF_RITUALIST
			Return "Rt"
		Case $PROF_PARAGON
			Return "P"
		Case $PROF_DERVISH
			Return "D"
	EndSwitch
EndFunc
#ce
Func GetProfessionFullName($aProf)
	Switch $aProf
		Case $PROF_NONE
			Return "x"
		Case $PROF_WARRIOR
			Return "Warrior"
		Case $PROF_RANGER
			Return "Ranger"
		Case $PROF_MONK
			Return "Monk"
		Case $PROF_NECROMANCER
			Return "Necromancer"
		Case $PROF_MESMER
			Return "Mesmer"
		Case $PROF_ELEMENTALIST
			Return "Elementalist"
		Case $PROF_ASSASSIN
			Return "Assassin"
		Case $PROF_RITUALIST
			Return "Ritualist"
		Case $PROF_PARAGON
			Return "Paragon"
		Case $PROF_DERVISH
			Return "Dervish"
	EndSwitch
EndFunc

Func GetTeam($iTeam)
	Switch $iTeam
		Case 1
			Return "Blue"
		Case 2
			Return "Red"
		Case 3
			Return "Yellow"
		Case Else
			Return ""
	EndSwitch
EndFunc