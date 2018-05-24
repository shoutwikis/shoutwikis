#include-once

#Region Party Window
#Region Invite
;~ Description: Invite a player to the party.
Func InvitePlayer($aPlayerName)
   SendChat('invite ' & $aPlayerName, '/')
EndFunc   ;==>InvitePlayer

;~ Description: Invites player by playernumber.
Func InvitePlayerByPlayerNumber($lPlayerNumber)
   Return SendPacket(0x8, 0x9A, $lPlayerNumber)
EndFunc   ;==>InvitePlayerByPlayerNumber

;~ Description: Invites player by AgentID.
Func InvitePlayerByID($aAgentID)
   If IsPtr($aAgentID) Then
	  Local $lAgentPlayerNumber = MemoryRead($aAgentID + 244, 'word')
   ElseIf IsDllStruct($aAgentID) <> 0 Then
	  Local $lAgentPlayerNumber = DllStructGetData($aAgentID, 'Playernumber')
   Else
	  Local $lAgentPlayerNumber = MemoryRead(GetAgentPtr($aAgentID) + 244, 'word')
   EndIf
   If $lAgentPlayerNumber <> 0 Then Return SendPacket(0x8, 0x9A, $lAgentPlayerNumber)
EndFunc   ;==>InvitePlayerByID

;~ Description: Invite current target.
Func InviteTarget()
   Local $lpNUM = MemoryRead(GetAgentPtr(-1) + 244, 'word')
   Return SendPacket(0x8, 0x9A, $lpNUM)
EndFunc   ;==>InviteTarget

;~ Description: Accepts pending invite.
Func AcceptInvite()
   Return SendPacket(0x8, 0x96)
EndFunc   ;==>AcceptInvite
#EndRegion

#Region Leave/Kick
;~ Description: Leave your party.
Func LeaveGroup($aKickHeroes = True)
   If $aKickHeroes Then SendPacket(0x8, 0x18, 0x26)
   Return SendPacket(0x4, 0x9C)
EndFunc   ;==>LeaveGroup
#EndRegion

#Region Misc
;~ Description: Switches to/from Hard Mode.
Func SwitchMode($aMode)
   Return SendPacket(0x8, 0x95, $aMode)
EndFunc   ;==>SwitchMode
#EndRegion
#EndRegion

#Region Information
;~ Description: Returns partysize.
Func GetPartySize()
   Local $lOffset[5] = [0, 0x18, 0x4C, 0x64, 0x24]
   Local $lPartyPtr = MemoryReadPtr($mBasePointer, $lOffset)
   $lOffset[3] = 0x54
   $lOffset[4] = 0xC
   Local $lPartyPlayerPtr = MemoryReadPtr($mBasePointer, $lOffset)
   Local $Party1 = MemoryRead($lPartyPtr[0], 'long') ; henchmen
   Local $Party2 = MemoryRead($lPartyPtr[0] + 0x10, 'long') ; heroes
   Local $Party3 = MemoryRead($lPartyPlayerPtr[0], 'long') ; players
   Local $lReturn = $Party1 + $Party2 + $Party3
   If $lReturn > 12 or $lReturn < 1 Then $lReturn = 8
   Return $lReturn
EndFunc   ;==>GetPartySize

;~ Description: Returns max partysize.
;~ Works only in OUTPOST or TOWN.
Func GetMaxPartySize($aMapID)
   Switch $aMapID
	  Case 293 to 296, 721, 368, 188, 467, 497
		 Return 1
	  Case 163 to 166
		 Return 2
	  Case 28 to 30, 32, 36, 39, 40, 81, 131, 135, 148, 189, 214, 242, 249, 251, 281, 282
		 Return 4
	  Case 431, 449, 479, 491, 502, 544, 555, 795, 796, 811, 815, 816, 818 to 820, 855, 856
		 Return 4
	  Case 10 to 12, 14 to 16, 19, 21, 25, 38, 49, 55, 57, 73, 109, 116, 117 to 119
		 Return 6
	  Case 132 to 134, 136, 137, 139 to 142, 152, 153, 154, 213, 250, 385, 808, 809, 810
		 Return 6
	  Case 266, 307
		 Return 12
	  Case Else
		 Return 8
   EndSwitch
EndFunc   ;==>GetMaxPartySize

;~ Description: Checks if all partymembers listed in array are dead and resigns if all are dead.
Func CheckPartyDead(ByRef $aPartyArray)
   For $i = 1 to $aPartyArray[0]
	  Local $lAnimation = MemoryRead($aPartyArray[$i] + 220, 'byte')
	  If $lAnimation <> 61 And $lAnimation <> 62 Then Return False
   Next
   Sleep(1000)
   ResignAndReturn()
EndFunc   ;==>CheckPartyDead

;~ Description: Checks if all partymembers listed in $mPartyArray are dead. No ResignAndReturn().
Func IsPartyArrayDead()
   For $i = 1 to $mPartyArray[0]
	  Local $lAnimation = MemoryRead($mPartyArray[$i] + 220, 'byte')
	  If $lAnimation <> 61 And $lAnimation <> 62 Then Return False
   Next
   Return True
EndFunc   ;==>IsPartyArrayDead
#EndRegion