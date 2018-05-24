#include-once

#Region Ptr
;~ Description: Returns questptr by questid.
Func GetQuestPtrByID($aQuestID)
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x534]
   $lQuestLogSize = MemoryReadPtr($mBasePointer, $lOffset)
   Local $lQuestID
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x52C, 0]
   If $aQuestID = 0 Then
	  $lOffset[3] = 0x528
	  $lQuestID = MemoryReadPtr($mBasePointer, $lOffset)
	  Return Ptr($lQuestID[0])
   EndIf
   For $i = 0 To $lQuestLogSize[1]
	  $lOffset[4] = 0x34 * $i
	  $lQuestPtr = MemoryReadPtr($mBasePointer, $lOffset, 'long')
	  If $lQuestPtr[1] = $aQuestID Then Return Ptr($lQuestPtr[0])
   Next
EndFunc   ;==>GetQuestPtrByID

;~ Description: Returns questptr by number of quest in questlog.
Func GetQuestPtrByLogNumber($aLogNumber)
   $aLogNumber -= 1 ; Questlog starts at 0
   Local $lOffset[5] = [0, 0x18, 0x2C, 0x52C, 0x34 * $aLogNumber]
   $lQuestPtr = MemoryReadPtr($mBasePointer, $lOffset, 'ptr')
   Return $lQuestPtr[0]
EndFunc   ;==>GetQuestPtrByLogNumber
#EndRegion Ptr

#Region Dialogs
;~ Description: Accept a quest from an NPC.
Func AcceptQuest($aQuestID)
   Return SendPacket(0x8, 0x35, '0x008' & Hex($aQuestID, 3) & '01')
EndFunc   ;==>AcceptQuest

;~ Description: Accept the reward for a quest.
Func QuestReward($aQuestID)
   Return SendPacket(0x8, 0x35, '0x008' & Hex($aQuestID, 3) & '07')
EndFunc   ;==>QuestReward

;~ Description: Abandon a quest.
Func AbandonQuest($aQuestID)
   Return SendPacket(0x8, 0xA, $aQuestID)
EndFunc   ;==>AbandonQuest
#EndRegion

#Region QuestState
;~ Description: Request quest data.
Func UpdateQuest($aQuestID)
   ToggleQuestWindow()
   ToggleQuestWindow()
;~    SendPacket(0x8, 0xB, $aQuestID)
;~    SendPacket(0xC, 0xD, $aQuestID, 0x1)
EndFunc   ;==>UpdateQuest
#EndRegion