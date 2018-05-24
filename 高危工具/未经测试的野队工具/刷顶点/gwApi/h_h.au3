#include-once

#Region PartyCommands
;~ Description: Adds a hero to the party.
Func AddHero($aHeroId)
   Return SendPacket(0x8, 0x17, $aHeroId)
EndFunc   ;==>AddHero

;~ Description: Kicks a hero from the party.
Func KickHero($aHeroId)
   Return SendPacket(0x8, 0x18, $aHeroId)
EndFunc   ;==>KickHero

;~ Description: Kicks all heroes from the party.
Func KickAllHeroes()
   Return SendPacket(0x8, 0x18, 0x26)
EndFunc   ;==>KickAllHeroes

;~ Description: Add a henchman to the party.
Func AddNpc($aNpcId)
   Return SendPacket(0x8, 0x99, $aNpcId)
EndFunc   ;==>AddNpc

;~ Description: Kick a henchman from the party.
Func KickNpc($aNpcId)
   Return SendPacket(0x8, 0xA2, $aNpcId)
EndFunc   ;==>KickNpc

;~ Description: Clear the position flag from a hero.
Func CancelHero($aHeroNumber, $aAgentID = GetHeroID($aHeroNumber))
   Return SendPacket(0x14, 0x13, $aAgentID, 0x7F800000, 0x7F800000, 0)
EndFunc   ;==>CancelHero

;~ Description: Clear the position flag from all heroes.
Func CancelAll()
   Return SendPacket(0x10, 0x14, 0x7F800000, 0x7F800000, 0)
EndFunc   ;==>CancelAll

;~ Description: Place a hero's position flag.
Func CommandHero($aHeroNumber, $aX, $aY, $aHeroID = GetHeroID($aHeroNumber))
   Return SendPacket(0x14, 0x13, $aHeroID, FloatToInt($aX), FloatToInt($aY), 0)
EndFunc   ;==>CommandHero

;~ Description: Place the full-party position flag.
Func CommandAll($aX, $aY)
   Return SendPacket(0x10, 0x14, FloatToInt($aX), FloatToInt($aY), 0)
EndFunc   ;==>CommandAll

;~ Description: Lock a hero onto a target.
Func LockHeroTarget($aHeroNumber, $aAgentID = 0, $aHeroID = GetHeroID($aHeroNumber)) ;$aAgentID=0 Cancels Lock
   Return SendPacket(0xC, 0xF, $aHeroID, $aAgentID)
EndFunc   ;==>LockHeroTarget

;~ Description: Change a hero's aggression level.
Func SetHeroAggression($aHeroNumber, $aAggression, $aHeroID = GetHeroID($aHeroNumber)) ;0=Fight, 1=Guard, 2=Avoid
   Return SendPacket(0xC, 0xE, $aHeroID, $aAggression)
EndFunc   ;==>SetHeroAggression

;~ Description: Clear all hero flags.
Func ClearPartyCommands()
   Return PerformAction(0xDB, 0x18)
EndFunc   ;==>ClearPartyCommands
#EndRegion

#Region Hero Skillbar Interaction
;~ Description: Disable a skill on a hero's skill bar.
Func DisableHeroSkillSlot($aHeroNumber, $aSkillSlot, $aPtr = GetSkillbarPtr($aHeroNumber), $aHeroID = GetHeroID($aHeroNumber))
   $lDeadlock = TimerInit()
   While Not GetIsHeroSkillSlotDisabled($aHeroNumber, $aSkillSlot, $aPtr)
	  ChangeHeroSkillSlotState($aHeroNumber, $aSkillSlot, $aHeroID)
	  Sleep(500)
	  If TimerDiff($lDeadlock) > 5000 Then Return False
   WEnd
   Return True
EndFunc   ;==>DisableHeroSkillSlot

;~ Description: Enable a skill on a hero's skill bar.
Func EnableHeroSkillSlot($aHeroNumber, $aSkillSlot, $aPtr = GetSkillbarPtr($aHeroNumber), $aHeroID = GetHeroID($aHeroNumber))
   $lDeadlock = TimerInit()
   While GetIsHeroSkillSlotDisabled($aHeroNumber, $aSkillSlot, $aPtr)
	  ChangeHeroSkillSlotState($aHeroNumber, $aSkillSlot, $aHeroID)
	  Sleep(500)
	  If TimerDiff($lDeadlock) > 5000 Then Return False
   WEnd
   Return True
EndFunc   ;==>EnableHeroSkillSlot

;~ Description: Internal use for enabling or disabling hero skills
Func ChangeHeroSkillSlotState($aHeroNumber, $aSkillSlot, $aHeroID = GetHeroID($aHeroNumber))
   Return SendPacket(0xC, 0x12, $aHeroID, $aSkillSlot - 1)
EndFunc   ;==>ChangeHeroSkillSlotState

;~ Description: Tests if a hero's skill slot is disabled.
Func GetIsHeroSkillSlotDisabled($aHeroNumber, $aSkillSlot, $aPtr = GetSkillbarPtr($aHeroNumber))
   Local $lDisabled = MemoryRead($aPtr + 164, 'dword')
   If $aSkillSlot > 1 Then
	  $lBitMask = 2 ^ ($aSkillSlot - 1)
   Else
	  $lBitMask = 1
   EndIf
   Return BitAND($lBitMask, $lDisabled) > 0
EndFunc   ;==>GetIsHeroSkillSlotDisabled

;~ Description: Order a hero to use a skill.
Func UseHeroSkill($aHero, $aSkillSlot, $aTarget = -2)
   If IsPtr($aTarget) <> 0 Then
	  Local $lTargetID = MemoryRead($aTarget + 44, 'long')
   ElseIf IsDllStruct($aTarget) <> 0 Then
	  Local $lTargetID = DllStructGetData($aTarget, 'ID')
   Else
	  Local $lTargetID = ConvertID($aTarget)
   EndIf
   DllStructSetData($mUseHeroSkill, 2, GetHeroID($aHero))
   DllStructSetData($mUseHeroSkill, 3, $lTargetID)
   DllStructSetData($mUseHeroSkill, 4, $aSkillSlot - 1)
   Enqueue($mUseHeroSkillPtr, 16)
EndFunc   ;==>UseHeroSkill
#EndRegion

#Region Information
;~ Description: Returns number of heroes you control.
Func GetHeroCount()
   Local $lOffset[5] = [0, 0x18, 0x4C, 0x54, 0x2C]
   Local $lHeroCount = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lHeroCount[1]
EndFunc   ;==>GetHeroCount

;~ Description: Returns agent ID of a hero.
Func GetHeroID($aHeroNumber)
   If $aHeroNumber = 0 Then Return GetMyID()
   Local $lOffset[6] = [0, 0x18, 0x4C, 0x54, 0x24, 0x18 * ($aHeroNumber - 1)]
   Local $lAgentID = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lAgentID[1]
EndFunc   ;==>GetHeroID

;~ Description: Returns hero number by agent ID.
Func GetHeroNumberByAgentID($aAgentID)
   $aAgentID = ConvertID($aAgentID)
   Local $lAgentID
   Local $lOffset[6] = [0, 0x18, 0x4C, 0x54, 0x24, 0]
   For $i = 1 To GetHeroCount()
	  $lOffset[5] = 0x18 * ($i - 1)
	  $lAgentID = MemoryReadPtr($mBasePointer, $lOffset)
	  If $lAgentID[1] = $aAgentID Then Return $i
   Next
EndFunc   ;==>GetHeroNumberByAgentID

;~ Description: Returns hero number by hero ID.
Func GetHeroNumberByHeroID($aHeroId)
   $aHeroId = ConvertID($aHeroId)
   Local $lAgentID
   Local $lOffset[6] = [0, 0x18, 0x4C, 0x54, 0x24, 0]
   For $i = 1 To GetHeroCount()
	  $lOffset[5] = 8 + 0x18 * ($i - 1)
	  $lAgentID = MemoryReadPtr($mBasePointer, $lOffset)
	  If $lAgentID[1] = $aHeroId Then Return $i
   Next
EndFunc   ;==>GetHeroNumberByHeroID

;~ Description: Returns my profession when passed 0 ; GetHeroProfession(0)
;~ Returns hero's profession ID (when it can't be found by other means)
Func GetHeroProfession($aHeroNumber, $aSecondary = False)
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x6BC, 0]
   Local $lBuffer
   $aHeroNumber = GetHeroID($aHeroNumber)
   For $i = 0 To GetHeroCount()
	  $lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
	  If $lBuffer[1] = $aHeroNumber Then
		 $lOffset[4] += 4
		 If $aSecondary Then $lOffset[4] += 4
		 $lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
		 Return $lBuffer[1]
	  EndIf
	  $lOffset[4] += 0x14
   Next
EndFunc   ;==>GetHeroProfession
#EndRegion

