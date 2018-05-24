#include-once

#Region MapLoad
;~ Description: Sets value of GetMapIsLoaded() to 0.
Func InitMapLoad()
   MemoryWrite($mMapIsLoaded, 0)
EndFunc   ;==>InitMapLoad

;~ Description: Returns current load-state.
Func GetMapLoading()
   Return MemoryRead($mMapLoading)
EndFunc   ;==>GetMapLoading

;~ Description: Returns if map has been loaded. Reset with InitMapLoad().
Func GetMapIsLoaded()
   Return MemoryRead($mMapIsLoaded) And GetAgentExists(-2)
EndFunc   ;==>GetMapIsLoaded

;~ Description: Wait for map to load. Returns true if successful.
Func WaitMapLoading($aMapID = 0, $aDeadlock = 15000)
   InitMapLoad()
   Local $lDeadlock = TimerInit()
   While GetMapLoading() <> 2
	  Sleep(200)
	  If TimerDiff($lDeadlock) > $aDeadlock Then Return
   WEnd
   Do
	  Sleep(1000)
	  If TimerDiff($lDeadlock) > $aDeadlock Then Return
   Until GetMapLoading <> 2 And GetAgentPtr(-2) <> 0 And GetInstanceTimestamp() > 5000
   Sleep($mSleepAfterPort)
   If GetMapLoading() = 1 Then
	  $mPartyArray = GetAgentPtrArray(2, 0xDB, 1)
   Else
	  $CurrentMapID = $aMapID
	  $mMaxPartySize = GetMaxPartySize(GetMapID())
   EndIf
   Return True
EndFunc

;~ Description: Wait for map to load. Returns true if successful. Only works when rendering enabled.
Func WaitMapLoadingRenderingEnabled($aMapID = 0, $aDeadlock = 15000)
   InitMapLoad()
   Local $lDeadlock = TimerInit()
   While GetMapLoadStatus() <> 1
	  Sleep(100)
	  If DetectCinematic() Then SkipCinematic()
	  If TimerDiff($lDeadlock) > $aDeadlock Then Return ; port didnt happen
   WEnd
   Local $lDeadlock = TimerInit() ; new timer
   While GetMapLoadStatus() <> 0
	  Sleep(1000)
	  If TimerDiff($lDeadlock) > $aDeadlock Then Return ; we seem to be stuck in loading screen
   WEnd
   If GetMapLoading() = 1 Then
	  $mPartyArray = GetAgentPtrArray(3, 0xDB, 1, True)
   Else
	  $CurrentMapID = $aMapID
	  $mMaxPartySize = GetMaxPartySize(GetMapID())
   EndIf
   Return True
EndFunc

;~ Descriptions: Returns timestamp for instance.
Func GetInstanceTimestamp()
   Local $lOffset[4] = [0, 0x18, 0x8, 0x1AC]
   Local $lTimer = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lTimer[1]
EndFunc

Func Travel($aMapID, $aDistrict = 0, $aRegion = 0, $aLanguage = 0)
   ; check if already in map
   If GetMapID() = $aMapID And $aDistrict = 0 And GetMapLoading() = 0 Then Return True
   ; Region
   If $aRegion = 0 Then
	  $lRegion = GetRegion()
   Else
	  $lRegion = $aRegion
   EndIf
   ; Language
   If $aLanguage = 0 Then
	  $lLanguage = GetRegion()
   Else
	  $lLanguage = GetLanguage()
   EndIf
   InitMapLoad()
   If Not SendPacket(0x18, 0xAB, $aMapID, $lRegion, $aDistrict, $lLanguage, 0) Then Return
   Do
	  Sleep(250)
   Until GetMapLoading() = 2
EndFunc

;~ Description: Map travel to an outpost.
Func TravelTo($aMapID, $aDis = 0)
   ;returns true if successful
   If GetMapID() = $aMapID And $aDis = 0 And GetMapLoading() = 0 Then Return True
   ZoneMap($aMapID, $aDis)
   Update("Travel to map " & $aMapID)
   Return WaitMapLoading($aMapID)
EndFunc   ;==>TravelTo

;~ Description: Internal use for map travel.
Func ZoneMap($aMapID, $aDistrict = 0)
   MoveMap($aMapID, GetRegion(), $aDistrict, GetLanguage())
EndFunc   ;==>ZoneMap

;~ Description: Internal use for map travel.
Func MoveMap($aMapID, $aRegion, $aDistrict, $aLanguage)
   Return SendPacket(0x18, 0xAB, $aMapID, $aRegion, $aDistrict, $aLanguage, False)
EndFunc   ;==>MoveMap

;~ Description: Returns to outpost after resigning/failure.
Func ReturnToOutpost()
   Return SendPacket(0x4, 0xA1)
EndFunc   ;==>ReturnToOutpost

;~ Description: Enter a challenge mission/pvp.
Func EnterChallenge()
   Return SendPacket(0x8, 0x9F, 1)
EndFunc   ;==>EnterChallenge

;~ Description: Enter a foreign challenge mission/pvp.
Func EnterChallengeForeign()
   Return SendPacket(0x8, 0x9F, 0)
EndFunc   ;==>EnterChallengeForeign

;~ Description: Tries to travel to GH. Checks first if already in gh and returns false if not successful.
Func TravelGuildHall()
   Local $array_GH[16] = [4, 5, 6, 52, 176, 177, 178, 179, 275, 276, 359, 360, 529, 530, 537, 538]
   Local $lInGH = False
   Local $lMapID = GetMapID()
   For $i = 0 To 15
	  If $lMapID = $array_GH[$i] Then
		 $lInGH = True
		 ExitLoop
	  EndIf
   Next
   If Not $lInGH Then
	  TravelGH()
	  Sleep(1000)
	  $lMapID = GetMapID()
	  For $i = 0 To 15
		 If $lMapID = $array_GH[$i] Then
			$lInGH = True
			ExitLoop
		 EndIf
	  Next
   EndIf
   Return $lInGH
EndFunc   ;==>TravelGuildHall

;~ Description: Travel to your guild hall.
Func TravelGH()
   Local $lOffset[3] = [0, 0x18, 0x3C]
   Local $lGH = MemoryReadPtr($mBasePointer, $lOffset)
   SendPacket(0x18, 0xAA, MemoryRead($lGH[1] + 0x64), MemoryRead($lGH[1] + 0x68), MemoryRead($lGH[1] + 0x6C), MemoryRead($lGH[1] + 0x70), 1)
   Return WaitMapLoading()
EndFunc   ;==>TravelGH

;~ Description: Leave your guild hall.
Func LeaveGH()
   SendPacket(0x8, 0xAC, 1)
   Return WaitMapLoading()
EndFunc   ;==>LeaveGH
#EndRegion

#Region MapInfo
;~ Description: Returns current map ID.
Func GetMapID()
   Return MemoryRead($mMapID)
EndFunc   ;==>GetMapID

;~ Description: Returns maploading status.
;~ Author: 4D1.
Func GetMapLoadStatus()
   Return MemoryRead($mMapID + 4)
EndFunc

;~ Description: Tests if an area has been vanquished.
Func GetAreaVanquished()
   Return GetFoesToKill() = 0
EndFunc   ;==>GetAreaVanquished

;~ Description: Returns number of foes that have been killed so far.
Func GetFoesKilled()
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x84C]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetFoesKilled

;~ Description: Returns number of enemies left to kill for vanquish.
Func GetFoesToKill()
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x850]
   Local $lReturn = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lReturn[1]
EndFunc   ;==>GetFoesToKill
#EndRegion

#Region District, Region
;~ Description: Returns current district.
Func GetDistrict()
   Local $lOffset[4] = [0, 0x18, 0x44, 0x1B4]
   Local $lResult = MemoryReadPtr($mBasePointer, $lOffset)
   Return $lResult[1]
EndFunc   ;==>GetDistrict

;~ Description: Changes district to randomly chosen one.
Func DistrictChange($aZoneID = 0, $aUseDistricts = 7)
   Local $REGION[12] = [2, 2, 2, 2, 2, 2, 2, 0, -2, 1, 3, 4]
   Local $LANGUAGE[12] = [0, 2, 3, 4, 5, 9, 10, 0, 0, 0, 0, 0]
   Local $random, $OLD_REGION, $OLD_LANGUAGE
   If $AZONEID = 0 Then $AZONEID = GetMapID()
   $OLD_REGION = GetRegion()
   $OLD_LANGUAGE = GetLanguage()
   Do
	  $random = Random(0, $AUSEDISTRICTS - 1, 1)
   Until $LANGUAGE[$random] <> $OLD_LANGUAGE
   $REGION = $REGION[$random]
   $LANGUAGE = $LANGUAGE[$random]
   MoveMap($AZONEID, $REGION, 0, $LANGUAGE)
   Return WaitMapLoading($AZONEID)
EndFunc   ;==>DistrictChange

;~ Description: Changes district depending on day, using DailyDistrict function.
Func DistrictChangeDay($townID = 648) ; Doomlore Shrine : 648
   Local $MyMapRegion = DailyDistrict()
   MoveMap($townID, $MyMapRegion[0], 0, $MyMapRegion[1])
   Return WaitMapLoading($townID)
EndFunc   ;==>DistrictChangeDay

;~ Description: Returns a district depending on the day of the week.
Func DailyDistrict()
   Switch @WDAY ; Numeric day of week.  Range is 1 to 7 which corresponds to Sunday through Saturday.
   Case 1
	  Local $MapRegion[2] = [4, 0]
   Case 2
	  Local $MapRegion[2] = [3, 0]
   Case 3
	  Local $MapRegion[2] = [1, 0]
   Case 4
	  Local $MapRegion[2] = [2, 4]
   Case 5
	  Local $MapRegion[2] = [2, 0]
   Case 6
	  Local $MapRegion[2] = [2, 2]
   Case 7
	  Local $MapRegion[2] = [2, 3]
   EndSwitch
   Return $MapRegion
EndFunc   ;==>DailyDistrict

;~ Description: Internal use for travel functions.
Func GetRegion()
   Return MemoryRead($mRegion)
EndFunc   ;==>GetRegion
#EndRegion