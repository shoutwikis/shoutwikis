#include-once
#RequireAdmin
#include "GWA².au3"


;GENERAL THNX to miracle444 for his work with GWA2

;=================================================================================================
; Function:
; Description:		Globals from GWCA still working in GWA2
; Parameter(s):
;
; Requirement(s):
; Return Value(s):
; Author(s):		GWCA team
;=================================================================================================
Global Enum $RARITY_White = 0x3D, $RARITY_Blue = 0x3F, $RARITY_Purple = 0x42, $RARITY_Gold = 0x40, $RARITY_Green = 0x43

Global Enum $BAG_Backpack = 1, $BAG_BeltPouch, $BAG_Bag1, $BAG_Bag2, $BAG_EquipmentPack, $BAG_UnclaimedItems = 7, $BAG_Storage1, $BAG_Storage2, _
		$BAG_Storage3, $BAG_Storage4, $BAG_StorageAnniversary, $BAG_Storage5, $BAG_Storage6, $BAG_Storage7, $BAG_Storage8

Global Enum $HERO_Norgu = 1, $HERO_Goren, $HERO_Tahlkora, $HERO_MasterOfWhispers, $HERO_AcolyteJin, $HERO_Koss, $HERO_Dunkoro, $HERO_AcolyteSousuke, $HERO_Melonni, _
		$HERO_ZhedShadowhoof, $HERO_GeneralMorgahn, $HERO_MargridTheSly, $HERO_Olias = 14, $HERO_Razah, $HERO_MOX, $HERO_Jora = 18, $HERO_PyreFierceshot, _
		$HERO_Livia = 21, $HERO_Hayda, $HERO_Kahmu, $HERO_Gwen, $HERO_Xandra, $HERO_Vekk, $HERO_Ogden
Global Enum $HEROMODE_Fight, $HEROMODE_Guard, $HEROMODE_Avoid

Global Enum $DYE_Blue = 2, $DYE_Green, $DYE_Purple, $DYE_Red, $DYE_Yellow, $DYE_Brown, $DYE_Orange, $DYE_Silver, $DYE_Black, $DYE_Gray, $DYE_White

Global Enum $ATTRIB_FastCasting, $ATTRIB_IllusionMagic, $ATTRIB_DominationMagic, $ATTRIB_InspirationMagic, _
		$ATTRIB_BloodMagic, $ATTRIB_DeathMagic, $ATTRIB_SoulReaping, $ATTRIB_Curses, _
		$ATTRIB_AirMagic, $ATTRIB_EarthMagic, $ATTRIB_FireMagic, $ATTRIB_WaterMagic, $ATTRIB_EnergyStorage, _
		$ATTRIB_HealingPrayers, $ATTRIB_SmitingPrayers, $ATTRIB_ProtectionPrayers, $ATTRIB_DivineFavor, _
		$ATTRIB_Strength, $ATTRIB_AxeMastery, $ATTRIB_HammerMastery, $ATTRIB_Swordsmanship, $ATTRIB_Tactics, _
		$ATTRIB_BeastMastery, $ATTRIB_Expertise, $ATTRIB_WildernessSurvival, $ATTRIB_Marksmanship, _
		$ATTRIB_DaggerMastery, $ATTRIB_DeadlyArts, $ATTRIB_ShadowArts, _
		$ATTRIB_Communing, $ATTRIB_RestorationMagic, $ATTRIB_ChannelingMagic, _
		$ATTRIB_CriticalStrikes, _
		$ATTRIB_SpawningPower, _
		$ATTRIB_SpearMastery, $ATTRIB_Command, $ATTRIB_Motivation, $ATTRIB_Leadership, _
		$ATTRIB_ScytheMastery, $ATTRIB_WindPrayers, $ATTRIB_EarthPrayers, $ATTRIB_Mysticism

Global Enum $EQUIP_Weapon, $EQUIP_Offhand, $EQUIP_Chest, $EQUIP_Legs, $EQUIP_Head, $EQUIP_Feet, $EQUIP_Hands

Global Enum $SKILLTYPE_Stance = 3, $SKILLTYPE_Hex, $SKILLTYPE_Spell, $SKILLTYPE_Enchantment, $SKILLTYPE_Signet, $SKILLTYPE_Well = 9, _
		$SKILLTYPE_Skill, $SKILLTYPE_Ward, $SKILLTYPE_Glyph, $SKILLTYPE_Attack = 14, $SKILLTYPE_Shout, $SKILLTYPE_Preparation = 19, _
		$SKILLTYPE_Trap = 21, $SKILLTYPE_Ritual, $SKILLTYPE_ItemSpell = 24, $SKILLTYPE_WeaponSpell, $SKILLTYPE_Chant = 27, $SKILLTYPE_EchoRefrain

Global Enum $REGION_International = -2, $REGION_America = 0, $REGION_Korea, $REGION_Europe, $REGION_China, $REGION_Japan

Global Enum $LANGUAGE_English = 0, $LANGUAGE_French = 2, $LANGUAGE_German, $LANGUAGE_Italian, $LANGUAGE_Spanish, $LANGUAGE_Polish = 9, $LANGUAGE_Russian

Global Const $FLAG_RESET = 0x7F800000; unflagging heores


Global $intSkillEnergy[8] = [5, 0, 5, 5, 0, 10, 0, 0]
; Change the next lines to your skill casting times in milliseconds. use ~250 for shouts/stances, ~1000 for attack skills:
Global $intSkillCastTime[8] = [0, 0, 0, 0, 0, 1000, 0, 0]
; Change the next lines to your skill adrenaline count (1 to 8). leave as 0 for skills without adren
Global $intSkillAdrenaline[8] = [0, 5, 0, 0, 6, 0, 4, 8]
Global $totalskills = 7


Global $lItemExtraStruct = DllStructCreate( _ ; haha obsolete and wrong^^
		"byte rarity;" & _  ;Display Color $RARITY_White = 0x3D, $RARITY_Blue = 0x3F, $RARITY_Purple = 0x42, $RARITY_Gold = 0x40, $RARITY_Green = 0x43
		"byte unknown1[3];" & _
		"byte modifier;" & _ ;Display Mods (hex values): 30 = Display first mod only (Insignia, 31 = Insignia + "of" Rune, 32 = Insignia + [Rune], 33 = ...
		"byte unknown2[13];" & _ ;[13]
		"byte lastModifier")
Global $lItemExtraStructPtr = DllStructGetPtr($lItemExtraStruct)
Global $lItemExtraStructSize = DllStructGetSize($lItemExtraStruct)
#comments-start
	Global $lItemNameStruct = DllStructCreate("byte rarity;"& _; Colour of the item (can be used as rarity); follow $lItemExtraStruct ->same pointer
	"byte ModMode;" & _;
	"byte ModCount;" & _;Number of Mods in the item
	"byte Name[4];" & _;Name ID of the item
	"byte Prefix[4];" & _; Depending on Item, Insignia, Axe Haft, Sword Hilt etc.
	"byte Suffix1[4];" & _; Depending on Item, Rune, Axe Grip, Sword Pommel etc.
	"byte Suffix2[4]"); (Runes Only) Quality of the Suffix (e.g. superior)

	Global $lItemNameStructPtr = DllStructGetPtr($lItemNameStruct)
	Global $lItemNameStructSize = DllStructGetSize($lItemNameStruct)
#comments-end

;-------> Item Extra Req Struct Definition
Global $lItemExtraReqStruct = DllStructCreate( _
		"byte requirement;" & _
		"byte attribute");Skill Template Format
Global $lItemExtraReqStructPtr = DllStructGetPtr($lItemExtraReqStruct)
Global $lItemExtraReqStructSize = DllStructGetSize($lItemExtraReqStruct)
;-------> Item Mod Struct definition
Global $lItemModStruct = DllStructCreate( _
		"byte unknown1[28];" & _
		"byte armor")
Global $lItemModStructPtr = DllStructGetPtr($lItemModStruct)
Global $lItemModStructSize = DllStructGetSize($lItemModStruct)

Global $iItems_Picked = 0
Global $lReturn = 0





#Region H&H

Func MoveHero($aX, $aY, $HeroID, $Random = 75); Parameter1 = heroID (1-7) reset flags $aX = 0x7F800000, $aY = 0x7F800000

	Switch $HeroID
		Case "All"
			CommandAll(_FloatToInt($aX) + Random(-$Random, $Random), _FloatToInt($aY) + Random(-$Random, $Random))
		Case 1
			CommandHero1(_FloatToInt($aX) + Random(-$Random, $Random), _FloatToInt($aY) + Random(-$Random, $Random))
		Case 2
			CommandHero2(_FloatToInt($aX) + Random(-$Random, $Random), _FloatToInt($aY) + Random(-$Random, $Random))
		Case 3
			CommandHero3(_FloatToInt($aX) + Random(-$Random, $Random), _FloatToInt($aY) + Random(-$Random, $Random))
		Case 4
			CommandHero4(_FloatToInt($aX) + Random(-$Random, $Random), _FloatToInt($aY) + Random(-$Random, $Random))
		Case 5
			CommandHero5(_FloatToInt($aX) + Random(-$Random, $Random), _FloatToInt($aY) + Random(-$Random, $Random))
		Case 6
			CommandHero6(_FloatToInt($aX) + Random(-$Random, $Random), _FloatToInt($aY) + Random(-$Random, $Random))
		Case 7
			CommandHero7(_FloatToInt($aX) + Random(-$Random, $Random), _FloatToInt($aY) + Random(-$Random, $Random))
	EndSwitch
EndFunc   ;==>MoveHero

Func CommandHero1($aX = 0x7F800000, $aY = 0x7F800000)
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x520]
	Local $lHeroStruct = MemoryReadPtr($mBasePointer, $lOffset)
	SendPacket(0x14, 0x12, MEMORYREAD($lHeroStruct[1] + 0x4), $aX, $aY, 0)
EndFunc   ;==>CommandHero1

Func CommandHero2($aX = 0x7F800000, $aY = 0x7F800000)
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x520]
	Local $lHeroStruct = MemoryReadPtr($mBasePointer, $lOffset)
	SendPacket(0x14, 0x12, MEMORYREAD($lHeroStruct[1] + 0x28), $aX, $aY, 0)
EndFunc   ;==>CommandHero2

Func CommandHero3($aX = 0x7F800000, $aY = 0x7F800000)
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x520]
	Local $lHeroStruct = MemoryReadPtr($mBasePointer, $lOffset)
	SendPacket(0x14, 0x12, MEMORYREAD($lHeroStruct[1] + 0x4C), $aX, $aY, 0)
EndFunc   ;==>CommandHero3

Func CommandHero4($aX = 0x7F800000, $aY = 0x7F800000)
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x520]
	Local $lHeroStruct = MemoryReadPtr($mBasePointer, $lOffset)
	SendPacket(0x14, 0x12, MEMORYREAD($lHeroStruct[1] + 0x70), $aX, $aY, 0)
EndFunc   ;==>CommandHero4

Func CommandHero5($aX = 0x7F800000, $aY = 0x7F800000)
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x520]
	Local $lHeroStruct = MemoryReadPtr($mBasePointer, $lOffset)
	SendPacket(0x14, 0x12, MEMORYREAD($lHeroStruct[1] + 0x94), $aX, $aY, 0)
EndFunc   ;==>CommandHero5

Func CommandHero6($aX = 0x7F800000, $aY = 0x7F800000)
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x520]
	Local $lHeroStruct = MemoryReadPtr($mBasePointer, $lOffset)
	SendPacket(0x14, 0x12, MEMORYREAD($lHeroStruct[1] + 0xB8), $aX, $aY, 0)
EndFunc   ;==>CommandHero6

Func CommandHero7($aX = 0x7F800000, $aY = 0x7F800000)
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x520]
	Local $lHeroStruct = MemoryReadPtr($mBasePointer, $lOffset)
	SendPacket(0x14, 0x12, MEMORYREAD($lHeroStruct[1] + 0xDC), $aX, $aY, 0)
EndFunc   ;==>CommandHero7

#Region Trade with Players

Func TradePlayer($aAgent)
	Local $lAgentID

	If IsDllStruct($aAgent) = 0 Then
		$lAgentID = ConvertID($aAgent)
	Else
		$lAgentID = DllStructGetData($aAgent, 'ID')
	EndIf
	SendPacket(0x08, 0x42, $lAgentID)
EndFunc   ;==>TradePlayer


Func FIGHT($x, $s = "enemies")

	Do
		Sleep(250)
		$nearestenemy = GetNearestEnemyToAgent(-2)
	Until DllStructGetData($nearestenemy, 'ID') <> 0

	Do
		$useSkill = -1
		$target = GetNearestEnemyToAgent(-2)
		$distance = GetDistance($target, -2)
		If DllStructGetData($target, 'ID') <> 0 And $distance < $x Then
			ChangeTarget($target)
			Sleep(150)
			Attack($target)
			Sleep(150)
		ElseIf DllStructGetData($target, 'ID') = 0 Or $distance > $x Then
			ExitLoop
		EndIf

		For $i = 0 To $totalskills

			$targetHP = DllStructGetData(GetCurrentTarget(), 'HP')
			If $targetHP = 0 Then ExitLoop

			$distance = GetDistance($target, -2)
			If $distance > $x Then ExitLoop

			$energy = GetEnergy(-2)
			$recharge = DllStructGetData(GetSkillBar(), "Recharge" & $i + 1)
			$adrenaline = DllStructGetData(GetSkillBar(), "Adrenaline" & $i + 1)

			If $recharge = 0 And $energy >= $intSkillEnergy[$i] And $adrenaline >= ($intSkillAdrenaline[$i] * 25 - 25) Then
				$useSkill = $i + 1
				PingSleep(250)
				UseSkill($useSkill, $target)
				Sleep($intSkillCastTime[$i] + 1000)
			EndIf
			If $i = $totalskills Then $i = 0
		Next

	Until DllStructGetData($target, 'ID') = 0 Or $distance > $x
	;PickupItems(-1, $x)
	Sleep(2000)
EndFunc   ;==>Fight

Func AggroMoveToEx($x, $y, $s = "", $z = 1250)
	$Random = 50
	$iBlocked = 0

	Move($x, $y, $Random)


	$lMe = GetAgentByID(-2)
	$coordsX = DllStructGetData($lMe, "X")
	$coordsY = DllStructGetData($lMe, "Y")

	Do
		Sleep(250)
		$oldCoordsX = $coordsX
		$oldCoordsY = $coordsY
		$nearestenemy = GetNearestEnemyToAgent(-2)
		$lDistance = GetDistance($nearestenemy, -2)
		If $lDistance < $z And DllStructGetData($nearestenemy, 'ID') <> 0 Then
			FIGHT($z, $s)

		EndIf
		Sleep(250)
		$lMe = GetAgentByID(-2)
		$coordsX = DllStructGetData($lMe, "X")
		$coordsY = DllStructGetData($lMe, "Y")
		If $oldCoordsX = $coordsX And $oldCoordsY = $coordsY Then
			$iBlocked += 1
			Move($coordsX, $coordsY, 500)
			Sleep(350)
			Move($x, $y, $Random)
		EndIf
	Until ComputeDistanceEx($coordsX, $coordsY, $x, $y) < 250 Or $iBlocked > 20
EndFunc   ;==>AggroMoveToEx


Func SubmitOffer($aAmount);Parameter = gold amount to offer. Like pressing the "Submit Offer" button, but also including the amount of gold offered.
	SendPacket(0x08, 0xAF, $aAmount)
EndFunc   ;==>SubmitOffer

Func ChangeOffer();No parameters. Like pressing the "Change Offer" button.
	SendPacket(0x04, 0xB2)
EndFunc   ;==>ChangeOffer

Func OfferItem($aItem, $aAmount = 0); not tested! need feedback
	Local $lItemID, $lAmount

	If IsDllStruct($aItem) = 0 Then
		$lItemID = $aItem
		If $aAmount > 0 Then
			$lAmount = $aAmount
		Else
			$lAmount = DllStructGetData(GetItemByItemID($aItem), 'Quantity')
		EndIf
	Else
		$lItemID = DllStructGetData($aItem, 'ID')
		If $aAmount > 0 Then
			$lAmount = $aAmount
		Else
			$lAmount = DllStructGetData($aItem, 'Quantity')
		EndIf
	EndIf
	SendPacket(0xC, 0xAE, $lItemID, $lAmount)
EndFunc   ;==>OfferItem

Func CancelTrade();No parameters. Like pressing the "Cancel" button in a trade.
	SendPacket(0x04, 0xAD)
EndFunc   ;==>CancelTrade

Func AcceptTrade();No parameters. Like pressing the "Accept" button in a trade. Can only be used after both players have submitted their offer.
	SendPacket(0x04, 0xB3)
EndFunc   ;==>AcceptTrade

#EndRegion Trade with Players

#Region Action-related commands


#Region Item related commands

;=================================================================================================
; Function:			PickUpItems($iItems = -1, $fMaxDistance = 1012)
; Description:		PickUp defined number of items in defined area around default = 1012
; Parameter(s):		$iItems:	number of items to be picked
;					$fMaxDistance:	area within items should be picked up
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	On Success - Returns $iItemsPicked (number of items picked)
; Author(s):		GWCA team, recoded by ddarek, thnx to The ArkanaProject
;=================================================================================================
Func PickupItems($iItems = -1, $fMaxDistance = 1012)
	Local $aItemID, $lNearestDistance, $lDistance
	$tDeadlock = TimerInit()
	Do
		$aItem = GetNearestItemToAgent(-2)
		$lDistance = @extended

		$aItemID = DllStructGetData($aItem, 'ID')
		If $aItemID = 0 Or $lDistance > $fMaxDistance Or TimerDiff($tDeadlock) > 30000 Then ExitLoop
		PickUpItem($aItem)
		$tDeadlock2 = TimerInit()
		Do
			Sleep(500)
			If TimerDiff($tDeadlock2) > 5000 Then ContinueLoop 2
		Until DllStructGetData(GetAgentById($aItemID), 'ID') == 0
		$iItems_Picked += 1
		;UpdateStatus("Picked total " & $iItems_Picked & " items")
	Until $iItems_Picked = $iItems
EndFunc   ;==>PickupItems

;=================================================================================================
; Function:			GetNearestItemToAgent($aAgent)
; Description:		Get nearest item lying on floor around $aAgent ($aAgent = -2 ourself), necessary to work with PickUpItems func
; Parameter(s):		$aAgent: ID of Agent
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	On Success - Returns ID of nearest item
;					@extended  - distance to item
; Author(s):		GWCA team, recoded by ddarek
;=================================================================================================
Func GetNearestItemToAgent($aAgent)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance, $lAgentToCompare

	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	For $i = 1 To GetMaxAgents()
		$lAgentToCompare = GetAgentByID($i)

		If DllStructGetData($lAgentToCompare, 'Type') <> 0x400 Then ContinueLoop
		$lDistance = (DllStructGetData($lAgentToCompare, 'Y') - DllStructGetData($aAgent, 'Y')) ^ 2 + (DllStructGetData($lAgentToCompare, 'X') - DllStructGetData($aAgent, 'X')) ^ 2
		If $lDistance < $lNearestDistance Then
			$lNearestAgent = $lAgentToCompare
			$lNearestDistance = $lDistance
		EndIf
	Next
	SetExtended(Sqrt($lNearestDistance)) ;this could be used to retrieve the distance also
	Return $lNearestAgent
EndFunc   ;==>GetNearestItemToAgent

;=================================================================================================
; Function:			GetNearestItemByModelId($ModelId, $aAgent = -2 )
; Description:		Get nearest item lying on floor with proper ModelID around $aAgent ($aAgent = -2 ourself)
; Parameter(s):		$aAgent: ID of Agent
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	On Success - Returns ID of nearest item with valid ModelID
;
; Author(s):		GWCA team, recoded by ddarek
;=================================================================================================

Func GetNearestItemByModelId($ModelId, $aAgent = -2)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance, $lAgentToCompare

	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)

	For $i = 1 To GetMaxAgents()
		$lAgentToCompare = GetAgentByID($i)
		If DllStructGetData($lAgentToCompare, 'Type') <> 0x400 Then ContinueLoop
		If DllStructGetData(GetItemByAgentID($i), 'ModelID') <> $ModelId Then ContinueLoop
		$lDistance = (DllStructGetData($lAgentToCompare, 'Y') - DllStructGetData($aAgent, 'Y')) ^ 2 + (DllStructGetData($lAgentToCompare, 'X') - DllStructGetData($aAgent, 'X')) ^ 2
		If $lDistance < $lNearestDistance Then
			$lNearestAgent = $lAgentToCompare
			$lNearestDistance = $lDistance
		EndIf

	Next
	Return $lNearestAgent; return struct of Agent not item!
EndFunc   ;==>GetNearestItemByModelId

;=================================================================================================
; Function:			GetNumberOfFoesInRangeOfAgent($aAgent = -2, $fMaxDistance = 1012)
; Description:		Get number of foeas around $aAgent ($aAgent = -2 ourself) within declared range ($fMaxDistance = 1012)
; Parameter(s):		$aAgent: ID of Agent, fMaxDistance: distance to check
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	On Success - Returns count of foes
;
; Author(s):		GWCA team, recoded by ddarek
;=================================================================================================
;Func GetNumberOfFoesInRangeOfAgent($aAgent = -2, $fMaxDistance = 1012)
;	Local $lDistance, $lCount = 0
;
;	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
;	For $i = 1 To GetMaxAgents()
;		$lAgentToCompare = GetAgentByID($i)
;		If GetIsDead($lAgentToCompare) <> 0 Then ContinueLoop
;		If DllStructGetData($lAgentToCompare, 'Allegiance') = 0x3 Then
;			$lDistance = GetDistance($lAgentToCompare, $aAgent)
;			If $lDistance < $fMaxDistance Then
;				$lCount += 1
;				;ConsoleWrite("Counts: " &$lCount & @CRLF)
;			EndIf
;		EndIf
;	Next
;	Return $lCount
;EndFunc   ;==>GetNumberOfFoesInRangeOfAgent
;
;=================================================================================================
; Function:			GetNumberOfAlliesInRangeOfAgent($aAgent = -2, $fMaxDistance = 1012)
; Description:		Get number of allies around $aAgent ($aAgent = -2 ourself) within declared range ($fMaxDistance = 1012)
; Parameter(s):		$aAgent: ID of Agent, fMaxDistance: distance to check
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	On Success - Returns count of allies
;
; Author(s):		GWCA team, recoded by ddarek
;=================================================================================================
Func GetNumberOfAlliesInRangeOfAgent($aAgent = -2, $fMaxDistance = 1012)
	Local $lDistance, $lCount = 0

	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	For $i = 1 To GetMaxAgents()
		$lAgentToCompare = GetAgentByID($i)
		If GetIsDead($lAgentToCompare) <> 0 Then ContinueLoop
		If DllStructGetData($lAgentToCompare, 'Allegiance') = 0x1 Then
			$lDistance = GetDistance($lAgentToCompare, $aAgent)
			If $lDistance < $fMaxDistance Then
				$lCount += 1
				;ConsoleWrite("Counts: " &$lCount & @CRLF)
			EndIf
		EndIf
	Next
	Return $lCount
EndFunc   ;==>GetNumberOfAlliesInRangeOfAgent

;=================================================================================================
; Function:			GetNumberOfItemsInRangeOfAgent($aAgent = -2, $fMaxDistance = 1012)
; Description:		Get number of items around $aAgent ($aAgent = -2 ourself) within declared range ($fMaxDistance = 1012)
; Parameter(s):		$aAgent: ID of Agent, fMaxDistance: distance to check
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	On Success - Returns count of items
;
; Author(s):		GWCA team, recoded by ddarek
;=================================================================================================
Func GetNumberOfItemsInRangeOfAgent($aAgent = -2, $fMaxDistance = 1012)
	Local $lDistance, $lCount = 0

	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	For $i = 1 To GetMaxAgents()
		$lAgentToCompare = GetAgentByID($i)
		If DllStructGetData($lAgentToCompare, 'Type') = 0x400 Then
			$lDistance = GetDistance($lAgentToCompare, $aAgent)
			If $lDistance < $fMaxDistance Then
				$lCount += 1
				;ConsoleWrite("Counts: " &$lCount & @CRLF)
			EndIf
		EndIf
	Next
	Return $lCount
EndFunc   ;==>GetNumberOfItemsInRangeOfAgent


;=================================================================================================
; Function:			GetNearestEnemyToCoords($aX, $aY)
; Description:		Get nearest Enemy to coords
; Parameter(s):		coords  aX , aY
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	On Success - Returns ID of enemy nearest to declared coords
;
; Author(s):		GWCA team, recoded by ddarek
;=================================================================================================
Func GetNearestEnemyToCoords($aX, $aY)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance, $lAgentToCompare

	For $i = 1 To GetMaxAgents()
		$lAgentToCompare = GetAgentByID($i)
		If DllStructGetData($lAgentToCompare, 'HP') < 0.005 Or DllStructGetData($lAgentToCompare, 'Allegiance') <> 0x3 Then ContinueLoop

		$lDistance = ($aX - DllStructGetData($lAgentToCompare, 'X')) ^ 2 + ($aY - DllStructGetData($lAgentToCompare, 'Y')) ^ 2
		If $lDistance < $lNearestDistance Then
			$lNearestAgent = $lAgentToCompare
			$lNearestDistance = $lDistance
		EndIf
	Next

	Return $lNearestAgent
EndFunc   ;==>GetNearestEnemyToCoords

;=================================================================================================
; Function:			GetNextAlly($aAgent = -2)
; Description:		Returns the agent id of the next valid ally
; Parameter(s):		Agent ID or (-1/-2)
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	On Success - Returns ID of next ally
;
; Author(s):		GWCA team, recoded by ddarek
;=================================================================================================
Func GetNextAlly($aAgent = -2)
	Local $lReturn, $lAgentID, $lAgentToCompare

	If IsDllStruct($aAgent) = 0 Then
		$lAgentID = ConvertID($aAgent)
	Else
		$lAgentID = DllStructGetData($aAgent, 'ID')
	EndIf

	If $lAgentID + 1 < GetMaxAgents() Then
		$lAgentID += 1
		For $i = $lAgentID To GetMaxAgents()
			$lAgentToCompare = GetAgentByID($i)
			If DllStructGetData($lAgentToCompare, 'Type') = 0xDB And DllStructGetData($lAgentToCompare, 'Allegiance') = 0x1 Then
				ConsoleWrite("Found Next Ally " & $i & @CRLF)
				$lReturn = $i
				ExitLoop
			EndIf
		Next
	Else
		Return False
	EndIf

	Return $lReturn

EndFunc   ;==>GetNextAlly

;=================================================================================================
; Function:			GetNextFoe($aAgent = -2)
; Description:		Returns the agent id of the next valid foe
; Parameter(s):		Agent ID or (-1/-2)
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	On Success - Returns ID of next foe
;
; Author(s):		GWCA team, recoded by ddarek
;=================================================================================================
Func GetNextFoe($aAgent = -2)
	Local $lReturn, $lAgentID, $lAgentToCompare

	If IsDllStruct($aAgent) = 0 Then
		$lAgentID = ConvertID($aAgent)
	Else
		$lAgentID = DllStructGetData($aAgent, 'ID')
	EndIf

	If $lAgentID + 1 < GetMaxAgents() Then
		$lAgentID += 1
		For $i = $lAgentID To GetMaxAgents()
			$lAgentToCompare = GetAgentByID($i)
			If DllStructGetData($lAgentToCompare, 'Type') = 0xDB And DllStructGetData($lAgentToCompare, 'Allegiance') = 0x3 Then
				ConsoleWrite("Found Next Foe " & $i & @CRLF)
				$lReturn = $i
				ExitLoop
			EndIf
		Next
	Else
		Return False
	EndIf

	Return $lReturn

EndFunc   ;==>GetNextFoe

;=================================================================================================
; Function:			GetNextItem($aAgent = -2)
; Description:		Returns the agent id of the next valid item
; Parameter(s):		Agent ID or (-1/-2)
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	On Success - Returns ID of next item
;
; Author(s):		GWCA team, recoded by ddarek
;=================================================================================================
Func GetNextItem($aAgent = -2)
	Local $lReturn, $lAgentID, $lAgentToCompare

	If IsDllStruct($aAgent) = 0 Then
		$lAgentID = ConvertID($aAgent)
	Else
		$lAgentID = DllStructGetData($aAgent, 'ID')
	EndIf

	If $lAgentID + 1 < GetMaxAgents() Then
		$lAgentID += 1
		For $i = $lAgentID To GetMaxAgents()
			$lAgentToCompare = GetAgentByID($i)
			If DllStructGetData($lAgentToCompare, 'Type') = 0x400 Then
				ConsoleWrite("Found Next Item " & $i & @CRLF)
				$lReturn = $i
				ExitLoop
			EndIf
		Next
	Else
		Return False
	EndIf

	Return $lReturn

EndFunc   ;==>GetNextItem

;=================================================================================================
; Function:			GetNextAgent($aAgent = -2)
; Description:		Returns the agent id of the next valid agent
; Parameter(s):		Agent ID or (-1/-2)
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	On Success - Returns ID of next agent
;
; Author(s):		GWCA team, recoded by ddarek
;=================================================================================================
Func GetNextAgent($aAgent = -2)
	Local $lReturn, $lAgentID, $lAgentToCompare

	If IsDllStruct($aAgent) = 0 Then
		$lAgentID = ConvertID($aAgent)
	Else
		$lAgentID = DllStructGetData($aAgent, 'ID')
	EndIf

	If $lAgentID + 1 < GetMaxAgents() Then
		$lAgentID += 1
		For $i = $lAgentID To GetMaxAgents()
			$lAgentToCompare = GetAgentByID($i)
			If DllStructGetData($lAgentToCompare, 'ID') <> 0 Then
				ConsoleWrite("Found Next Agent " & $i & @CRLF)
				$lReturn = $i
				ExitLoop
			EndIf
		Next
	Else
		Return False
	EndIf

	Return $lReturn

EndFunc   ;==>GetNextAgent


;=================================================================================================
; Function:			GoNearestNPCToCoords($aX, $aY)
; Description:		Get nearest NPC to coords and move towards, usefull for blessing
; Parameter(s):		coords  aX , aY
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):
;
; Author(s):		GWCA team, recoded by ddarek
;=================================================================================================
;Func GoNearestNPCToCoords($aX, $aY)
;	Local $NPC
;	MOVETO($aX, $aY)
;	$NPC = GetNearestNPCToCoords($aX, $aY)
;	Do
;		RNDSLEEP(250)
;		GoNPC($NPC)
;	Until GetDistance($NPC, -2) < 250
;	RNDSLEEP(500)
;EndFunc   ;==>GoNearestNPCToCoords

;=================================================================================================
; Function:			GetFirstAgentByPlayerNumber($aNumber)
; Description:		Get first valid agent by PlayerNumber (ModelId of NPC/Mobs)
; Parameter(s):		PlayerNumber(ModelId of NPC/Mobs)
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	First Agent ID
;
; Author(s):		GWCA team, recoded by ddarek
;=================================================================================================

Func GetFirstAgentByPlayerNumber($aNumber)
	Local $lReturn, $lAgentToCompare

	For $i = 1 To GetMaxAgents()
		$lAgentToCompare = GetAgentByID($i)
		If DllStructGetData($lAgentToCompare, 'Type') = 0x2 And DllStructGetData($lAgentToCompare, 'Type') = 0x4 Then ContinueLoop
		If DllStructGetData($lAgentToCompare, 'PlayerNumber') = $aNumber Then
			$lReturn = $i
		EndIf
	Next
	Return $lReturn
EndFunc   ;==>GetFirstAgentByPlayerNumber

;=================================================================================================
; Function:			GetNearestAgentByPlayerNumber($aNumber, $aAgent = -2)
; Description:		Get nearest valid agent by PlayerNumber (ModelId of NPC/Mobs)
; Parameter(s):		PlayerNumber(ModelId of NPC/Mobs)
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	NearestAgent structure
;
; Author(s):		GWCA team, recoded by ddarek
;=================================================================================================
Func GetNearestAgentByPlayerNumber($aNumber, $aAgent = -2)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance, $lAgentToCompare

	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)

	For $i = 1 To GetMaxAgents()
		$lAgentToCompare = GetAgentByID($i)
		If DllStructGetData($lAgentToCompare, 'Type') = 0x2 And DllStructGetData($lAgentToCompare, 'Type') = 0x4 Then ContinueLoop
		If DllStructGetData($lAgentToCompare, 'PlayerNumber') = $aNumber Then
			$lDistance = (DllStructGetData($aAgent, 'X') - DllStructGetData($lAgentToCompare, 'X')) ^ 2 + (DllStructGetData($aAgent, 'Y') - DllStructGetData($lAgentToCompare, 'Y')) ^ 2
			If $lDistance < $lNearestDistance Then
				$lNearestAgent = $lAgentToCompare
				$lNearestDistance = $lDistance
			EndIf
		EndIf
	Next

	Return $lNearestAgent
EndFunc   ;==>GetNearestAgentByPlayerNumber

;=================================================================================================
; Function:			GetNearestAliveAgentByPlayerNumber($aNumber, $aAgent = -2)
; Description:		Get nearest alive valid agent by PlayerNumber (ModelId of NPC/Mobs)
; Parameter(s):		PlayerNumber(ModelId of NPC/Mobs)
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	NearestAgent structure
;
; Author(s):		GWCA team, recoded by ddarek
;=================================================================================================
Func GetNearestAliveAgentByPlayerNumber($aNumber, $aAgent = -2)
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance, $lAgentToCompare

	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)

	For $i = 1 To GetMaxAgents()
		$lAgentToCompare = GetAgentByID($i)
		If DllStructGetData($lAgentToCompare, 'HP') > 0.005 And DllStructGetData($lAgentToCompare, 'Type') = 0x2 And DllStructGetData($lAgentToCompare, 'Type') = 0x4 Then ContinueLoop
		If DllStructGetData($lAgentToCompare, 'PlayerNumber') = $aNumber Then
			$lDistance = (DllStructGetData($aAgent, 'X') - DllStructGetData($lAgentToCompare, 'X')) ^ 2 + (DllStructGetData($aAgent, 'Y') - DllStructGetData($lAgentToCompare, 'Y')) ^ 2
			If $lDistance < $lNearestDistance Then
				$lNearestAgent = $lAgentToCompare
				$lNearestDistance = $lDistance
			EndIf
		EndIf
	Next

	Return $lNearestAgent
EndFunc   ;==>GetNearestAliveAgentByPlayerNumber

;=================================================================================================
; Function:			Ident($bagIndex = 1, $numOfSlots)
; Description:		Idents items in $bagIndex, NEEDS ANY ID kit in inventory!
; Parameter(s):		$bagIndex -> check Global enums
;					$numOfSlots -> correspondend number of slots in $bagIndex
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):
; Author(s):		GWCA team, recoded by ddarek, thnx to The ArkanaProject
;=================================================================================================

;Func IDENT($bagIndex, $numOfSlots)
;	If FindIDKit() = False Then
;		;UpdateStatus("Buying ID Kit..........")
;		BuyIDKit();Buy IDKit
;		Sleep(Random(240, 260))
;	EndIf
;	For $i = 0 To $numOfSlots - 1
;		;UpdateStatus("Identifying item: " & $bagIndex & ", " & $i)
;		$aItem = GetItemBySlot($bagIndex, $i)
;		If DllStructGetData($aItem, 'ID') = 0 Then ContinueLoop
;		IdentifyItem($aItem)
;		Sleep(Random(1000, 1250))
;	Next
;EndFunc   ;==>Ident
;=================================================================================================
; Function:			CanSell($aItem); only part of it can do
; Description:		general precaution not to sell things we want to save; ModelId page = http://wiki.gamerevision.com/index.php/Model_IDs
; Parameter(s):		$aItem-object
;
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	On Success - Returns boolean
; Author(s):		GWCA team, recoded by ddarek, thnx to The ArkanaProject
;=================================================================================================

;Func CanSell($aItem)
;	$m = DllStructGetData($aItem, 'ModelID')
;	$q = DllStructGetData($aItem, 'Quantity')
;	$r = DllStructGetData(GetEtraItemInfoByItemId(DllStructGetData($aItem, 'id')), 'Rarity')
;	If $m = 0 Or $q > 1 Or $r = $RARITY_Gold Or $r = $RARITY_Green Then
;		Return False
;	ElseIf $m > 21785 And $m < 21806 Then ;Tomes not for sale
;		Return False
;	ElseIf $m = 146 Or $m = 22751 Then ; 146 = dyes, 22751 = lockpick not for sale
;		Return False
;	ElseIf $m = 5899 Or $m = 5900 Then ;Sup ID/Salvage not for sale
;		Return False
;	ElseIf $m = 5594 Or $m = 5595 Or $m = 5611 Or $m = 5853 Or $m = 5975 Or $m = 5976 Or $m = 21233 Then ;scrolls not for sale
;		Return False
;	ElseIf $m = 27033 Then ; D-Cores not for sale
;		Return False
;	Else
;		Return True
;	EndIf
;EndFunc   ;==>CanSell

;=================================================================================================
; Function:			Sell($bagIndex, $numOfSlots)
; Description:		Sell items in $bagIndex, need open Dialog with Trader!
; Parameter(s):		$bagIndex -> check Global enums
;					$numOfSlots -> correspondend number of slots in $bagIndex
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):
; Author(s):		GWCA team, recoded by ddarek, thnx to The ArkanaProject
;=================================================================================================


;Func SELL($bagIndex, $numOfSlots)
;	Sleep(Random(150, 250))
;	For $i = 0 To $numOfSlots - 1
		;UpdateStatus("Selling item: " & $bagIndex & ", " & $i)
;		$aItem = GetItemBySlot($bagIndex, $i)
;		If CanSell($aItem) Then SellItem($aItem)
;		Sleep(Random(350, 550))
;	Next
;EndFunc   ;==>Sell

Func GetExtraItemInfoBySlot($aBag, $aSlot)
	$item = GetItembySlot($aBag, $aSlot)
	$lItemExtraPtr = DllStructGetData($item, "ModPtr")

	DllCall($mHandle[0], 'int', 'ReadProcessMemory', 'int', $mHandle[1], 'int', $lItemExtraPtr, 'ptr', $lItemExtraStructPtr, 'int', $lItemExtraStructSize, 'int', '')
	Return $lItemExtraStruct
	;ConsoleWrite($rarity & @CRLF)
EndFunc   ;==>GetExtraItemInfoBySlot

Func GetEtraItemInfoByItemId($aItem)
	$item = GetItemByItemID($aItem)
	$lItemExtraPtr = DllStructGetData($item, "ModPtr")

	DllCall($mHandle[0], 'int', 'ReadProcessMemory', 'int', $mHandle[1], 'int', $lItemExtraPtr, 'ptr', $lItemExtraStructPtr, 'int', $lItemExtraStructSize, 'int', '')
	Return $lItemExtraStruct
EndFunc   ;==>GetEtraItemInfoByItemId

Func GetEtraItemInfoByAgentId($aItem)
	$item = GetItemByAgentID($aItem)
	$lItemExtraPtr = DllStructGetData($item, "ModPtr")

	DllCall($mHandle[0], 'int', 'ReadProcessMemory', 'int', $mHandle[1], 'int', $lItemExtraPtr, 'ptr', $lItemExtraStructPtr, 'int', $lItemExtraStructSize, 'int', '')
	Return $lItemExtraStruct
EndFunc   ;==>GetEtraItemInfoByAgentId

Func GetEtraItemInfoByModelId($aItem)
	$item = GetItemByModelID($aItem)
	$lItemExtraPtr = DllStructGetData($item, "ModPtr")

	DllCall($mHandle[0], 'int', 'ReadProcessMemory', 'int', $mHandle[1], 'int', $lItemExtraPtr, 'ptr', $lItemExtraStructPtr, 'int', $lItemExtraStructSize, 'int', '')
	Return $lItemExtraStruct
EndFunc   ;==>GetEtraItemInfoByModelId

Func GetExtraItemReqBySlot($aBag, $aSlot)
	$item = GetItembySlot($aBag, $aSlot)
	$lItemExtraReqPtr = DllStructGetData($item, "extraItemReq")

	DllCall($mHandle[0], 'int', 'ReadProcessMemory', 'int', $mHandle[1], 'int', $lItemExtraReqPtr, 'ptr', $lItemExtraReqStructPtr, 'int', $lItemExtraReqStructSize, 'int', '')
	Return $lItemExtraReqStruct
	;ConsoleWrite($rarity & @CRLF)
EndFunc   ;==>GetExtraItemReqBySlot

Func GetEtraItemReqByItemId($aItem)
	$item = GetItemByItemID($aItem)
	$lItemExtraReqPtr = DllStructGetData($item, "extraItemReq")

	DllCall($mHandle[0], 'int', 'ReadProcessMemory', 'int', $mHandle[1], 'int', $lItemExtraReqPtr, 'ptr', $lItemExtraReqStructPtr, 'int', $lItemExtraReqStructSize, 'int', '')
	Return $lItemExtraReqStruct
EndFunc   ;==>GetEtraItemReqByItemId

Func GetEtraItemReqByAgentId($aItem)
	$item = GetItemByAgentID($aItem)
	$lItemExtraReqPtr = DllStructGetData($item, "extraItemReq")

	DllCall($mHandle[0], 'int', 'ReadProcessMemory', 'int', $mHandle[1], 'int', $lItemExtraReqPtr, 'ptr', $lItemExtraReqStructPtr, 'int', $lItemExtraReqStructSize, 'int', '')
	Return $lItemExtraReqStruct
EndFunc   ;==>GetEtraItemReqByAgentId

Func GetEtraItemReqByModelId($aItem)
	$item = GetItemByModelID($aItem)
	$lItemExtraReqPtr = DllStructGetData($item, "extraItemReq")

	DllCall($mHandle[0], 'int', 'ReadProcessMemory', 'int', $mHandle[1], 'int', $lItemExtraReqPtr, 'ptr', $lItemExtraReqStructPtr, 'int', $lItemExtraReqStructSize, 'int', '')
	Return $lItemExtraReqStruct
EndFunc   ;==>GetEtraItemReqByModelId

;=================================================================================================
; Function:			FindEmptySlot($bagIndex)
; Description:		This function also searches the storage
; Parameter(s):		Parameter = bagIndex to start searching from
;
; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	Returns integer with item slot. If any of the returns = 0, then no empty slots were found
; Author(s):		GWCA team, recoded by ddarek
;=================================================================================================
Func FindEmptySlot($bagIndex) ;Parameter = bag index to start searching from. Returns integer with item slot. This function also searches the storage. If any of the returns = 0, then no empty slots were found
	Local $lItemInfo, $aSlot

	For $aSlot = 1 To DllStructGetData(GetBag($bagIndex), 'Slots')
		Sleep(40)
		ConsoleWrite("Checking: " & $bagIndex & ", " & $aSlot & @CRLF)
		$lItemInfo = GetItemBySlot($bagIndex, $aSlot)
		If DllStructGetData($lItemInfo, 'ID') = 0 Then
			ConsoleWrite($bagIndex & ", " & $aSlot & "  <-Empty! " & @CRLF)
			SetExtended($aSlot)
			ExitLoop
		EndIf
	Next
	Return 0
EndFunc   ;==>FindEmptySlot
#Region Misc

; #FUNCTION: Death ==============================================================================================================
; Description ...: Checks the dead
; Syntax.........: Death()
; Parameters ....:
; Author(s):		Syc0n
; ===============================================================================================================================
Func DEATH()
	If DllStructGetData(GetAgentByID(-2), "Effects") = 0x0010 Then
		Return 1 ; Whatever you want to put here in case of death
	Else
		Return 0
	EndIf
EndFunc   ;==>Death

; #FUNCTION: RndSlp =============================================================================================================
; Description ...: RandomSleep (5% Variation) with Deathcheck
; Syntax.........: RndSlp(§wert)
; Parameters ....: $val = Sleeptime
; Author(s):		Syc0n
; ===============================================================================================================================

;Func RNDSLP($val)
;	$wert = Random($val * 0.95, $val * 1.05, 1)
;	If $wert > 45000 Then
;		For $i = 0 To 6
;			Sleep($wert / 6)
;			DEATH()
;		Next
;	ElseIf $wert > 36000 Then
;		For $i = 0 To 5
;			Sleep($wert / 5)
;			DEATH()
;		Next
;	ElseIf $wert > 27000 Then
;		For $i = 0 To 4
;			Sleep($wert / 4)
;			DEATH()
;		Next
;	ElseIf $wert > 18000 Then
;		For $i = 0 To 3
;			Sleep($wert / 3)
;			DEATH()
;		Next
;	ElseIf $wert >= 9000 Then
;		For $i = 0 To 2
;			Sleep($wert / 2)
;			DEATH()
;		Next
;	Else
;		Sleep($wert)
;		DEATH()
;	EndIf
;EndFunc   ;==>RNDSLP

; #FUNCTION: Slp ================================================================================================================
; Description ...: Sleep with Deathcheck
; Syntax.........: Slp(§wert)
; Parameters ....: $wert = Sleeptime
; ===============================================================================================================================

Func SLP($val)
	If $val > 45000 Then
		For $i = 0 To 6
			Sleep($val / 6)
			DEATH()
		Next
	ElseIf $val > 36000 Then
		For $i = 0 To 5
			Sleep($val / 5)
			DEATH()
		Next
	ElseIf $val > 27000 Then
		For $i = 0 To 4
			Sleep($val / 4)
			DEATH()
		Next
	ElseIf $val > 18000 Then
		For $i = 0 To 3
			Sleep($val / 3)
			DEATH()
		Next
	ElseIf $val >= 9000 Then
		For $i = 0 To 2
			Sleep($val / 2)
			DEATH()
		Next
	Else
		Sleep($val)
		DEATH()
	EndIf
EndFunc   ;==>SLP

Func _FloatToInt($fFloat)
	Local $tFloat, $tInt

	$tFloat = DllStructCreate("float")
	$tInt = DllStructCreate("int", DllStructGetPtr($tFloat))
	DllStructSetData($tFloat, 1, $fFloat)
	Return DllStructGetData($tInt, 1)

EndFunc   ;==>_FloatToInt

Func _IntToFloat($fInt)
	Local $tFloat, $tInt

	$tInt = DllStructCreate("int")
	$tFloat = DllStructCreate("float", DllStructGetPtr($tInt))
	DllStructSetData($tInt, 1, $fInt)
	Return DllStructGetData($tFloat, 1)

EndFunc   ;==>_IntToFloat

;Func RNDSLEEP($x)
;	Sleep(Random($x * 0.97, $x * 1.03, 1))
;EndFunc   ;==>RndSleep

Func PingSleep($msExtra = 0)
	$ping = GetPing()
	Sleep($ping + $msExtra)
EndFunc   ;==>PingSleep

Func ComputeDistanceEx($x1, $y1, $x2, $y2)
	Return Sqrt(($y2 - $y1) ^ 2 + ($x2 - $x1) ^ 2)
	$dist = Sqrt(($y2 - $y1) ^ 2 + ($x2 - $x1) ^ 2)
	ConsoleWrite("Distance: " & $dist & @CRLF)

EndFunc   ;==>ComputeDistanceEx

;Func UpdateStatus($text)
	;GUICtrlSetData($labelStatus, $text)
;EndFunc   ;==>UpdateStatus

#EndRegion Misc