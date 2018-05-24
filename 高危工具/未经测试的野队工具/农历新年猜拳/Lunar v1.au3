#include "GWA².au3"

Global $Char = ""

If Not Initialize($Char) Then
	MsgBox(0, "Error", "Guild Wars Window/Character name not found.")
	Exit
EndIf

While 1
	Local $ThatAgent = GetAgentByID(-1)

	Local $LunarTokens = GetItemBySlot(1, 1)
	Local $OldQ = DllStructGetData($LunarTokens, 'Quantity')
	Do
		GoNPC(-1)
		Sleep(59)
		Dialog(0x84)
		Sleep(500)
		$LunarTokens = GetItemBySlot(1, 1)
	Until DllStructGetData($LunarTokens, 'Quantity') < $OldQ

	Local $NpcAnimation = DllStructGetData($ThatAgent, 'ModelAnimation')

	Do
		Sleep(100)
		$ThatAgent = GetAgentByID(-1)
		$NpcAnimation = DllStructGetData($ThatAgent, 'ModelAnimation')
	Until $NpcAnimation == 0xD

	Local $Playtimer = TimerInit()

	Do
		Sleep(100)
	Until TimerDiff($PlayTimer) > 8500

	$ThatAgent = GetAgentByID(-1)
	$NpcAnimation = DllStructGetData($ThatAgent, 'ModelAnimation')

	Switch ($NpcAnimation)
		Case 0x40
			SendChat('scissors', '/')
		Case 0xD
			SendChat('paper', '/')
		Case 0xC6
			SendChat('rock', '/')
	EndSwitch

	$Playtimer = TimerInit()

	Do
		Sleep(100)
	Until TimerDiff($PlayTimer) > 15000
WEnd