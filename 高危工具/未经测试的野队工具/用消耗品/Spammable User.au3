
#NoTrayIcon
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>
#include "GWA2.au3"


Opt("GUIOnEventMode", True)		; enable gui on event mode

Global $boolInitialized = False
Global $boolRunning = False
Global Const $SleepTime = 50 ; in milliseconds

Global Const $MainGui = GUICreate("Spam", 172, 118)
GUICtrlCreateLabel("Spammable User", 8, 6, 156, 17, $SS_CENTER)
Global Const $inputCharName = GUICtrlCreateInput("", 8, 24, 150, 22)
Global Const $cAlcohol = GUICtrlCreateCheckbox( "Alcohol", 8, 48)
Global Const $cParty = GUICtrlCreateCheckbox("Party", 8, 68)
Global Const $cSweets = GUICtrlCreateCheckbox("Sweets", 8, 88)
Global Const $btnStart = GUICtrlCreateButton("Start", 90, 68, 60)

Global $Alcohol_Array[19] = [910, 2513, 5585, 6049, 6366, 6367, 6375, 15477, 19171, 19172, 19173, 22190, 24593, 28435, 30855, 31145, 31146, 35124, 36682]
Global $Party_Array[6] = [6368, 6369, 6376, 21809, 21810, 21813]
Global $Sweets_Array[9] = [15528, 15479, 19170, 21492, 21812, 22644, 31150, 35125, 36681]

GUICtrlSetOnEvent($btnStart, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")
GUISetState(@SW_SHOW)

Do
	Sleep(100)
Until $boolInitialized

While 1
	If $boolRunning Then
		SpamMore()
	Else
		Sleep(250)
	EndIf
WEnd

Func SpamMore()
	For $bag=1 To 4
		For $slot=1 To DllStructGetData(GetBag($bag), 'Slots')
			Global $item = GetItemBySlot($bag, $slot)
			SpamAlcohol()
			SpamParty()
			SpamSweets()
		Next
	Next
EndFunc

Func SpamAlcohol()
   If GUICtrlRead($cAlcohol) = 1 Then
	  For $j = 0 To 18
		 If DllStructGetData($item, 'ModelID') == $Alcohol_Array[$j] Then
			For $i=1 To DllStructGetData($item, 'Quantity')
			   UseItem($item)
			   Sleep($SleepTime)
			Next
		 EndIf
	  Next
   EndIf
EndFunc

Func SpamParty()
   If GUICtrlRead($cParty) = 1 Then
	  For $j = 0 To 5
		 If DllStructGetData($item, 'ModelID') == $Party_Array[$j] Then
			For $i=1 To DllStructGetData($item, 'Quantity')
			   UseItem($item)
			   Sleep($SleepTime)
			Next
		 EndIf
	  Next
   EndIf
EndFunc

Func SpamSweets()
   If GUICtrlRead($cSweets) = 1 Then
	  For $j = 0 To 8
		 If DllStructGetData($item, 'ModelID') == $Sweets_Array[$j] Then
			For $i=1 To DllStructGetData($item, 'Quantity')
			   UseItem($item)
			   Sleep($SleepTime)
			Next
		 EndIf
	  Next
   EndIf
EndFunc

Func EventHandler()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnStart
			If $boolRunning Then
				GUICtrlSetData($btnStart, "Resume")
				$boolRunning = False
			ElseIf $boolInitialized Then
				GUICtrlSetData($btnStart, "Pause")
				$boolRunning = True
			Else
				$boolRunning = True
				GUICtrlSetData($btnStart, "Initializing...")
				GUICtrlSetState($btnStart, $GUI_DISABLE)
				GUICtrlSetState($inputCharName, $GUI_DISABLE)
				WinSetTitle($MainGui, "", GUICtrlRead($inputCharName))
				If GUICtrlRead($inputCharName) = "" Then
					If Initialize(ProcessExists("gw.exe"), True, False, False) = False Then	; don't need string logs or event system
						MsgBox(0, "Error", "Guild Wars it not running.")
						Exit
					EndIf
				Else
					If Initialize(GUICtrlRead($inputCharName), True, False, False) = False Then ; don't need string logs or event system
						MsgBox(0, "Error", "Can't find a Guild Wars client with that character name.")
						Exit
					EndIf
				EndIf
				GUICtrlSetData($btnStart, "Pause")
				GUICtrlSetState($btnStart, $GUI_ENABLE)
				$boolInitialized = True
			EndIf

	EndSwitch
 EndFunc
