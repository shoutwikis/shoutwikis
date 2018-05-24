#include-once

#Region Titles
;~ Description: Returns Hero title progress.
Func GetHeroTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x4]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetHeroTitle

;~ Description: Returns Gladiator title progress.
Func GetGladiatorTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x7C]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetGladiatorTitle

;~ Description: Returns Kurzick title progress.
Func GetKurzickTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0xCC]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetKurzickTitle

;~ Description: Returns Luxon title progress.
Func GetLuxonTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0xF4]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetLuxonTitle

;~ Description: Returns drunkard title progress.
Func GetDrunkardTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x11C]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetDrunkardTitle

;~ Description: Returns survivor title progress.
Func GetSurvivorTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x16C]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetSurvivorTitle

;~ Description: Returns max titles
Func GetMaxTitles()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x194]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetMaxTitles

;~ Description: Returns lucky title progress.
Func GetLuckyTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x25C]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetLuckyTitle

;~ Description: Returns unlucky title progress.
Func GetUnluckyTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x284]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetUnluckyTitle

;~ Description: Returns Sunspear title progress.
Func GetSunspearTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x2AC]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetSunspearTitle

;~ Description: Returns Lightbringer title progress.
Func GetLightbringerTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x324]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetLightbringerTitle

;~ Description: Returns Commander title progress.
Func GetCommanderTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x374]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetCommanderTitle

;~ Description: Returns Gamer title progress.
Func GetGamerTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x39C]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetGamerTitle

;~ Description: Returns Legendary Guardian title progress.
Func GetLegendaryGuardianTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x4DC]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetLegendaryGuardianTitle

;~ Description: Returns sweets title progress.
Func GetSweetTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x554]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetSweetTitle

;~ Description: Returns Asura title progress.
Func GetAsuraTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x5F4]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetAsuraTitle

;~ Description: Returns Deldrimor title progress.
Func GetDeldrimorTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x61C]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetDeldrimorTitle

;~ Description: Returns Vanguard title progress.
Func GetVanguardTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x644]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetVanguardTitle

;~ Description: Returns Norn title progress.
Func GetNornTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x66C]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetNornTitle

;~ Description: Returns mastery of the north title progress.
Func GetNorthMasteryTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x694]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetNorthMasteryTitle

;~ Description: Returns party title progress.
Func GetPartyTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x6BC]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetPartyTitle

;~ Description: Returns Zaishen title progress.
Func GetZaishenTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x6E4]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetZaishenTitle

;~ Description: Returns treasure hunter title progress.
Func GetTreasureTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x70C]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetTreasureTitle

;~ Description: Returns wisdom title progress.
Func GetWisdomTitle()
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x81C, 0x734]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetWisdomTitle

#Region SetTitle
;~ Description:	Set the currently displayed title.
;~ Author: Skaldish
;~ No Title			= 0x00
;~ Spearmarshall 	= 0x11
;~ Lightbringer 	= 0x14
;~ Asuran 			= 0x26
;~ Dwarven 			= 0x27
;~ Ebon Vanguard 	= 0x28
;~ Norn 			= 0x29
Func SetDisplayedTitle($aTitle = 0)
   If $aTitle Then
	  Return SendPacket(0x8, 0x51, $aTitle)
   Else
	  Return SendPacket(0x4, 0x52)
   EndIf
EndFunc   ;==>SetDisplayedTitle
#EndRegion
#EndRegion Titles

#Region Misc
;~ Description: Returns current amount of skillpoints.
Func GetSkillpoints()
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x7A8]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetSkillpoints

;~ Description: Returns amount of experience.
Func GetExperience()
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x740]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetExperience
#EndRegion

