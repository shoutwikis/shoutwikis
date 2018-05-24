#include-once

#Region Windows
;~ Description: Close all in-game windows.
Func CloseAllPanels()
   Return PerformAction(0x85, 0x18)
EndFunc   ;==>CloseAllPanels

;~ Description: Toggle hero window.
Func ToggleHeroWindow()
   Return PerformAction(0x8A, 0x18)
EndFunc   ;==>ToggleHeroWindow

;~ Description: Toggle inventory window.
Func ToggleInventory()
   Return PerformAction(0x8B, 0x18)
EndFunc   ;==>ToggleInventory

;~ Description: Toggle all bags window.
Func ToggleAllBags()
   Return PerformAction(0xB8, 0x18)
EndFunc   ;==>ToggleAllBags

;~ Description: Toggle world map.
Func ToggleWorldMap()
   Return PerformAction(0x8C, 0x18)
EndFunc   ;==>ToggleWorldMap

;~ Description: Toggle options window.
Func ToggleOptions()
   Return PerformAction(0x8D, 0x18)
EndFunc   ;==>ToggleOptions

;~ Description: Toggle quest window.
Func ToggleQuestWindow()
   Return PerformAction(0x8E, 0x18)
EndFunc   ;==>ToggleQuestWindow

;~ Description: Toggle skills window.
Func ToggleSkillWindow()
   Return PerformAction(0x8F, 0x18)
EndFunc   ;==>ToggleSkillWindow

;~ Description: Toggle mission map.
Func ToggleMissionMap()
   Return PerformAction(0xB6, 0x18)
EndFunc   ;==>ToggleMissionMap

;~ Description: Toggle friends list window.
Func ToggleFriendList()
   Return PerformAction(0xB9, 0x18)
EndFunc   ;==>ToggleFriendList

;~ Description: Toggle guild window.
Func ToggleGuildWindow()
   Return PerformAction(0xBA, 0x18)
EndFunc   ;==>ToggleGuildWindow

;~ Description: Toggle party window.
Func TogglePartyWindow()
   Return PerformAction(0xBF, 0x18)
EndFunc   ;==>TogglePartyWindow

;~ Description: Toggle score chart.
Func ToggleScoreChart()
   Return PerformAction(0xBD, 0x18)
EndFunc   ;==>ToggleScoreChart

;~ Description: Toggle layout window.
Func ToggleLayoutWindow()
   Return PerformAction(0xC1, 0x18)
EndFunc   ;==>ToggleLayoutWindow

;~ Description: Toggle minions window.
Func ToggleMinionList()
   Return PerformAction(0xC2, 0x18)
EndFunc   ;==>ToggleMinionList

;~ Description: Toggle a hero panel.
Func ToggleHeroPanel($aHeroNumber)
   If $aHeroNumber < 4 Then
	  Return PerformAction(0xDB + $aHeroNumber, 0x18)
   ElseIf $aHeroNumber < 8 Then
	  Return PerformAction(0xFE + $aHeroNumber, 0x18)
   EndIf
EndFunc   ;==>ToggleHeroPanel

;~ Description: Toggle hero's pet panel.
Func ToggleHeroPetPanel($aHeroNumber)
   If $aHeroNumber < 4 Then
	  Return PerformAction(0xDF + $aHeroNumber, 0x18)
   ElseIf $aHeroNumber < 8 Then
	  Return PerformAction(0xFA + $aHeroNumber, 0x18)
   EndIf
EndFunc   ;==>ToggleHeroPetPanel

;~ Description: Toggle pet panel.
Func TogglePetPanel()
   Return PerformAction(0xDF, 0x18)
EndFunc   ;==>TogglePetPanel

;~ Description: Toggle help window.
Func ToggleHelpWindow()
   Return PerformAction(0xE4, 0x18)
EndFunc   ;==>ToggleHelpWindow
#EndRegion Windows

#Region Display
;~ Description: Enable graphics rendering.
Func EnableRendering($aSetState = True)
   If $aSetState Then WinSetState($mGWHwnd, "", @SW_SHOW)
   $mRendering = True
   MemoryWrite($mDisableRendering, 0)
EndFunc   ;==>EnableRendering

;~ Description: Disable graphics rendering.
Func DisableRendering($aSetState = True)
   If $aSetState Then WinSetState($mGWHwnd, "", @SW_HIDE)
   $mRendering = False
   MemoryWrite($mDisableRendering, 1)
EndFunc   ;==>DisableRendering

;~ Description: Enable graphics rendering.
Func _EnableRendering()
   MemoryWrite($mDisableRendering, 0)
   WinSetState($mGWHwnd, "", @SW_SHOW)
   $mRendering = True
EndFunc   ;==>_EnableRendering

;~ Description: Disable graphics rendering.
Func _DisableRendering()
   MemoryWrite($mDisableRendering, 1)
   WinSetState($mGWHwnd, "", @SW_HIDE)
   $mRendering = False
EndFunc   ;==>_DisableRendering

;~ Description: Emptys Guild Wars client memory
Func ClearMemory()
   DllCall($mKernelHandle, 'int', 'SetProcessWorkingSetSize', 'int', $mGWProcHandle, 'int', -1, 'int', -1)
EndFunc   ;==>ClearMemory

;~ Description: Reduces the amount of available memory.
Func _ReduceMemory($GWPID = WinGetProcess($mGWHwnd))
   If $GWPID <> -1 Then
	  Local $AI_HANDLE = DllCall("kernel32.dll", "int", "OpenProcess", "int", 2035711, "int", False, "int", $GWPID)
	  Local $AI_RETURN = DllCall("psapi.dll", "int", "EmptyWorkingSet", "long", $AI_HANDLE[0])
	  DllCall("kernel32.dll", "int", "CloseHandle", "int", $AI_HANDLE[0])
   Else
	  Local $AI_RETURN = DllCall("psapi.dll", "int", "EmptyWorkingSet", "long", -1)
   EndIf
   Return $AI_RETURN[0]
EndFunc   ;==>_ReduceMemory

; Toggles rendering on and then back off
Func _PurgeHook()
   Update("Purging engine hook")
   ToggleRendering()
   Sleep(Random(4000, 5000))
   ToggleRendering()
EndFunc   ;==>_PurgeHook

;~ Description: Turns rendering On if Off, Off if On
Func ToggleRendering()
   If $mRendering Then
	  DisableRendering()
	  $mRendering = False
   Else
	  EnableRendering()
	  $mRendering = True
   EndIf
EndFunc   ;==>ToggleRendering

;~ Description: Unregisters adlib function _ReduceMemory().
Func CloseHandler()
   If Not $mRendering Then
	  AdlibUnRegister("_ReduceMemory")
   EndIf
   Exit
EndFunc   ;==>CloseHandler

;~ Description: Display all names.
Func DisplayAll($aDisplay)
   DisplayAllies($aDisplay)
   DisplayEnemies($aDisplay)
EndFunc   ;==>DisplayAll

;~ Description: Display the names of allies.
Func DisplayAllies($aDisplay)
   If $aDisplay Then
	  Return PerformAction(0x89, 0x18)
   Else
	  Return PerformAction(0x89, 0x1A)
   EndIf
EndFunc   ;==>DisplayAllies

;~ Description: Display the names of enemies.
Func DisplayEnemies($aDisplay)
   If $aDisplay Then
	  Return PerformAction(0x94, 0x18)
   Else
	  Return PerformAction(0x94, 0x1A)
   EndIf
EndFunc   ;==>DisplayEnemies
#EndRegion Display

#Region Misc
;~ Description: Take a screenshot.
Func MakeScreenshot()
   Return PerformAction(0xAE, 0x18)
EndFunc   ;==>MakeScreenshot

;~ Description: Skip a cinematic.
Func SkipCinematic()
   Return SendPacket(0x4, 0x5D)
EndFunc   ;==>SkipCinematic

;~ Description: Changes game language to english.
Func EnsureEnglish($aEnsure)
   If $aEnsure Then
	  MemoryWrite($mEnsureEnglish, 1)
   Else
	  MemoryWrite($mEnsureEnglish, 0)
   EndIf
EndFunc   ;==>EnsureEnglish

;~ Description: Change game language.
Func ToggleLanguage()
   DllStructSetData($mToggleLanguage, 2, 0x18)
   Enqueue($mToggleLanguagePtr, 8)
EndFunc   ;==>ToggleLanguage

;~ Description: Changes the maximum distance you can zoom out.
Func ChangeMaxZoom($aZoom = 750)
   MemoryWrite($mZoomStill, $aZoom, "float")
   MemoryWrite($mZoomMoving, $aZoom, "float")
EndFunc   ;==>ChangeMaxZoom

;~ Description: Changes the maximum memory Guild Wars can use.
Func SetMaxMemory($aMemory = 15728640)
   DllCall($mKernelHandle, 'int', 'SetProcessWorkingSetSizeEx', 'int', $mGWProcHandle, 'int', 1, 'int', $aMemory, 'int', 6)
EndFunc   ;==>SetMaxMemory
#EndRegion

