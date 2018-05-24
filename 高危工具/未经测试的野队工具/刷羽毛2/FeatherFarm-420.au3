#include "GWA².au3"
#include "AddsOn.au3"
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>


;~ WinSetTitle("Guild Wars", "", $client)
;~ If WinExists($client) Then
;~ 	Initialize(WinGetProcess($client))
;~ Else
;~ 	MsgBox("", "", "Erreur, existe pas ...")
;~ 	Exit
;~ EndIf

Global $NumberRun = 0, $GoldStored = 0, $IDKitBought = 0, $RunSucces = 0
Global $L_BAGSLOTS
Global $variabledego, $REMPLISAGETOTAL, $L_ITEMINFO, $StoragePlace
Global $File = @ScriptDir & "\Trace\Traça du " & @MDAY & "-" & @MON & " a " & @HOUR & "h et " & @MIN & "minutes.txt"
Global $StorageY = 60,  $StorageX1 = 303,  $StorageX2 = 322,  $StorageX3 = 341, $StorageX4 = 361  ; cordonnée onglet storage

Global $ErrDead = False, $iBlocked
Global $ErrCity = False
Global $strName = ""

Func bot()
    While 1
		$ErrDead = False
		$ErrCity = False
		$NumberRun = $NumberRun +1
		CurrentAction("Begin new run, run number : " & $NumberRun)
		gosell()
		If Not $ErrCity Then Farm()
		CurrentAction("End of run, run number : " & $NumberRun)
	WEnd
EndFunc

#Region ### START Koda GUI section ### Form=C:\Bot GW\Feather Farm\Storage version \Form1.kxf
Global $win = GUICreate("Status Window", 274, 270, 500, 1)
GUICtrlCreateLabel("Globeul", 190, 180-70-30,50)
GUICtrlSetFont(-1, 15)
$Start = GUICtrlCreateButton("Start", 178, 250-90-50, 75, 25, $WS_GROUP)
GUICtrlCreateGroup("Status: Runs", 275-265, 8, 255, 90-35)
GUICtrlCreateLabel("Total Runs:", 285-265, 28, 70, 17)
global $gui_status_runs = GUICtrlCreateLabel("0", 355-265, 28, 40, 17, $SS_RIGHT)
GUICtrlCreateLabel("Kits Bought:", 410-265, 28, 70, 17)
global $gui_status_kit = GUICtrlCreateLabel("0", 480-265, 28, 40, 17, $SS_RIGHT)
GUICtrlCreateLabel("Successful:", 285-265, 43, 70, 17)
GUICtrlSetColor(-1, 0x008000)
global $gui_status_successful = GUICtrlCreateLabel("0", 355-265, 43, 40, 17, $SS_RIGHT)
GUICtrlSetColor(-1, 0x008000)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Status: Items", 275-265, 235-132-35, 150, 195-80-40)
GUICtrlCreateLabel("Item:", 285-265, 255-132-35, 27, 17)
GUICtrlCreateLabel("Number:", 380-265, 255-132-35, 40, 17)
GUICtrlCreateLabel("Gold", 285-265, 285-132-35, 70, 17)
GUICtrlSetColor(-1, 0x808000)
global $gui_status_gold_label = GUICtrlCreateLabel("0", 370-265, 285-132-35, 40, 17, $SS_RIGHT)
GUICtrlSetColor(-1, 0x808000)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Status: Time", 10, 310 - 90 - 75, 255, 43)
GUICtrlCreateLabel("Total:", 20, 330 - 90 - 75, 50, 17)
Global $label_stat = GUICtrlCreateLabel("min: 000  sec: 00", 70, 330 - 90 - 75)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$txtName = GUICtrlCreateCombo($strName, 60, 330 - 90 - 45, 150, 20)
$Config = IniReadSection("Name.ini", "Name")
For $i = 1 To $Config[0][0]
	GUICtrlSetData($txtName, $Config[$i][1] )
Next
GUICtrlCreateGroup("Status: Current Action", 10, 375 - 90 - 65, 255, 45)
Global $STATUS = GUICtrlCreateLabel("Script not started yet", 20, 390 - 90 - 65, 235, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Start
				If GUICtrlRead($txtName) = "" Then
					If Initialize(ProcessExists("gw.exe")) = False Then
						MsgBox(0, "Error", "Guild Wars it not running.")
						Exit
					EndIf
				Else
					If Initialize(GUICtrlRead($txtName), "Guild Wars - " & GUICtrlRead($txtName)) = False Then
						MsgBox(0, "Error", "Can't find a Guild Wars client with that character name.")
						Exit
					EndIf
				EndIf
				Global $client = "Guild Wars - " & GUICtrlRead($txtName)
				AdlibRegister("status", 1000)
				$TimerTotal = TimerInit()
				AdlibRegister("CheckDeath", 1000)
				GUICtrlSetData($Start, "Exit")
				FileOpen($File)
				bot()
	EndSwitch
WEnd

Func CurrentAction($MSG)
	GUICtrlSetData($STATUS, $MSG)
	GUICtrlSetData($gui_status_runs, $NumberRun)
	GUICtrlSetData($gui_status_kit, $IDKitBought)
	GUICtrlSetData($gui_status_gold_label, $GoldStored)
	GUICtrlSetData($gui_status_successful, $RunSucces)
	;FileWriteLine($File, "Run : " & $NumberRun & " à : " & @Hour & ":" & @MIN & "." & @Sec & "   " & $MSG & @CRLF)
EndFunc   ;==>CurrentAction

Func status()
	$time = TimerDiff($TimerTotal)
	$string = StringFormat("min: %03u  sec: %02u ", $time/1000/60, Mod($time/1000,60))
	GUICtrlSetData($label_stat, $string)
EndFunc    ;==>status

Func CheckDeath()
	If Death() = 1 Then
		CurrentAction("We Are Dead")
		$ErrDead = True
	EndIf
EndFunc   ;==>CheckDeath

Func Death2()
	CurrentAction("Death2 Function Active, GotBlocked Somewhere")
	$ErrDead = True
EndFunc   ;==>Death2

Func Death3()
	CurrentAction("Death3 Function Active, Inventory is full")
	$ErrDead = True
EndFunc   ;==>Death2

Func IfGotBlock()
	If $iBlocked > 14 Then
		TransfertGH()
		CurrentAction("Erreur City True")
		$ErrCity = True
	EndIf
EndFunc   ;==>IfGotBlock

Func TransfertGH()
	Currentaction("Going to Gh")
	TravelGH()
	WaitForLoad()
	RNDSLP(2000)
	LeaveGH()
	WaitForLoad()
	RNDSLP(2000)
EndFunc   ;==>TransfertGH

Func IfGotBlockArea($x, $y)
	If Not $ErrDead AND $iBlocked > 14 Then
		If Not $ErrDead Then RNDSLP(2000)
		If Not $ErrDead Then MoveTo($x, $y)
		If Not $ErrDead AND $iBlocked > 14 Then
			If Not $ErrDead Then RNDSLP(2000)
			If Not $ErrDead Then MoveTo($x, $y)
			If Not $ErrDead AND $iBlocked > 14 Then
				Death2()
			EndIf
		EndIf
	EndIf
EndFunc   ;==>IfGotBlockArea

Func SellItemToMerchant()  ; A VERIFIER
;~ 	ControlSend($client,"","","v")
;~ 	RNDSLP(1000)
;~ 	ControlSend($client,"","","{SPACE}")
;~ 	RNDSLP(1000)
	;GoMerchant()
	$merchant = GetNearestNPCToCoords(17290, 12426)
	RNDSLP(1000)
	GoToNPC($merchant)
	BuyIDKit() ; A VERIFIER; A VERIFIER; A VERIFIER; A VERIFIER; A VERIFIER; A VERIFIER
	$IDKitBought = $IDKitBought + 1
	RNDSLP(1000)
	Ident(1)
	Ident(2)
	Ident(3)
	Ident(4)
	Sell(1)
	Sell(2)
	Sell(3)
	Sell(4)
EndFunc  ;==>SellItemToMerchant

Func GoMerchant()
	Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance, $lAgentToCompare

	For $i = 1 To GetMaxAgents()
		$lAgentToCompare = GetAgentByID($i)
		If DllStructGetData($lAgentToCompare, 'PlayerNumber') <> 3246 then ContinueLoop
		rndslp(150)
		ChangeTarget($lAgentToCompare)
		rndslp(150)
		GoNPC($lAgentToCompare)
		ExitLoop
	Next
	Do
		rndslp(100)
	Until CheckArea(17290, 12426)
	rndslp(3000)
EndFunc

Func IDENT($bagIndex)
	$bag = GetBag($bagIndex)
	For $i = 1 To DllStructGetData($bag, 'slots')
		If FindIDKit() = 0 Then
			If GetGoldCharacter() < 500 And GetGoldStorage() > 499 Then
				WithdrawGold(500)
				Sleep(Random(200, 300))
			EndIf
			local $J = 0
			Do
				BuyIDKit()
				RndSleep(500)
				$J = $J+1
			Until FindIDKit() <> 0 OR $J = 3
			If $J = 3 Then ExitLoop
			RndSleep(500)
		EndIf
		$aitem = GetItemBySlot($bagIndex, $i)
		If DllStructGetData($aitem, 'ID') = 0 Then ContinueLoop
		IdentifyItem($aitem)
		Sleep(Random(400, 750))
	Next
EndFunc   ;==>IDENT

Func Sell($bagIndex)
	$bag = GetBag($bagIndex)
	$numOfSlots = DllStructGetData($bag, 'slots')
	For $i = 1 To $numOfSlots
		CurrentAction("Selling item: " & $bagIndex & ", " & $i)
		$aitem = GetItemBySlot($bagIndex, $i)
		If DllStructGetData($aitem, 'ID') = 0 Then ContinueLoop
		If CanSell($aitem) Then
			SellItem($aitem)
		EndIf
		RndSleep(250)
	Next
EndFunc   ;==>Sell

Func CanSell($aitem)
	local $m = DllStructGetData($aitem, 'ModelID')
	local $i = DllStructGetData($aitem, 'extraId')
	If $m = 0 Then
		Return False
	ElseIf $m > 21785 And $m < 21806 Then ;Elite/Normal Tomes
		Return False
	ElseIf $m = 146 Then
		If $i = 10 OR $i = 12 Then ;black and white
			Return False
		Else
			Return True
		EndIf
	ElseIf $m = 933  or $m = 835 Then ;plumes / crest
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>CanSell

Func GetExtraItemInfo($aitem)
    If IsDllStruct($aitem) = 0 Then $aAgent = GetItemByItemID($aitem)
    $lItemExtraPtr = DllStructGetData($aitem, "namestring")

    DllCall($mHandle[0], 'int', 'ReadProcessMemory', 'int', $mHandle[1], 'int', $lItemExtraPtr, 'ptr', $lItemExtraStructPtr, 'int', $lItemExtraStructSize, 'int', '')
    Return $lItemExtraStruct
EndFunc   ;==>GetExtraItemInfo

Func Ident2($bagIndex, $numOfSlots)
	For $i = 1 To $numOfSlots
		If FindIDKit() = False Then ExitLoop
		$aItem = GetItemBySlot($bagIndex, $i)
		If DllStructGetData($aItem, 'ID') = 0 Then ContinueLoop
		IdentifyItem($aItem)
		Sleep(Random(400, 550))
	Next
EndFunc   ;==>Ident2

Func WaitForLoad()
	CurrentAction("Loading zone")
	InitMapLoad()
	$deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100
		$load = GetMapLoading()
		$lMe = GetAgentByID(-2)

	Until $load = 2 And DllStructGetData($lMe, 'X') = 0 And DllStructGetData($lMe, 'Y') = 0 Or $deadlock > 10000

	$deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100

		$deadlock += 100
		$load = GetMapLoading()
		$lMe = GetAgentByID(-2)

	Until $load <> 2 And DllStructGetData($lMe, 'X') <> 0 And DllStructGetData($lMe, 'Y') <> 0 Or $deadlock > 30000
	CurrentAction("Load complete")
	rndslp(3000)
EndFunc   ;==>WaitForLoad

Func WaitForLoad2()
	CurrentAction("Loading zone")
	$deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100
		$load = GetMapLoading()
		$lMe = GetAgentByID(-2)

	Until $load = 2 And DllStructGetData($lMe, 'X') = 0 And DllStructGetData($lMe, 'Y') = 0 Or $deadlock > 10000

	$deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100

		$deadlock += 100
		$load = GetMapLoading()
		$lMe = GetAgentByID(-2)

	Until $load <> 2 And DllStructGetData($lMe, 'X') <> 0 And DllStructGetData($lMe, 'Y') <> 0 Or $deadlock > 30000
	CurrentAction("Load complete")
	rndslp(3000)
EndFunc   ;==>WaitForLoad

Func CheckIfInventoryIsFull()
	If CountSlots() = 0 Then
		CurrentAction("Inventory is full, going to sell and store")
 		Death3()
	Else
		CurrentAction("Inventory is full")
	EndIf
EndFunc   ;==>CheckIfInventoryIsFull

Func CountSlots()
	Local $bag
	Local $temp = 0
	$bag = GetBag(1)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(2)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(3)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(4)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	Return $temp
EndFunc   ;==>CountSlots

Func gosell()
	Do
		RndSlp(500)
		If GetMapID() <> 250 Then
			TravelTo(250)
			WaitForLoad2()
		EndIf
	Until GetMapID() = 250
	$ErrDead = False
	$ErrCity = False
	Local $I
	Local $J
	$variabledego = 0
	$bag = GetBag(1)
	$temp = DllStructGetData($bag, 'ItemsCount')
	If $temp <= 10 Then
		$variabledego = 1
	EndIf
	For $I = 1 To 3
		RndSlp(100)
		$L_BAGSLOTS = DllStructGetData(GetBag($i), 'Slots')
		For $J = 1 To $L_BAGSLOTS
			$aItem = GetItemBySlot($I, $J)
			If DllStructGetData($aItem, 'ID') <> 0 And DllStructGetData(GetExtraItemInfo($aItem), 'rarity') = $RARITY_Gold Then
				$variabledego = 2
			EndIf
		Next
	Next
	If $variabledego = 0 Then
		$variabledego = 3
	EndIf
	If $variabledego = 1 Then
		CurrentAction("Moving Out Cause we are not full (<10)")
		If CheckArea(18383, 11200) Then
			WayOut1()
		ElseIf CheckArea(18855, 9479) then
			WayOut11()
		ElseIf CheckArea(16669, 11862) Then
			WayOut21()
		Else
			TransfertGH()
			CurrentAction("Erreur City True")
			$ErrCity = True
		EndIf
	ElseIf $variabledego = 2 Then ;on va au stock
		CurrentAction("Moving To storage")
		If CheckArea(18855, 9479) Then
			If Not $ErrCity Then MoveTo(18502, 9449)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(17592, 9669)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(17088, 9848)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(16910, 9681)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(17011, 9412)
			If Not $ErrCity Then IfGotBlock()
		ElseIf CheckArea(18383, 11200) Then
			If Not $ErrCity Then MoveTo(18640, 10971)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(19273, 10310)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(19333, 9937)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18813, 9492)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(17291, 9814)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(16942, 9734)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(17065, 9389)
			If Not $ErrCity Then IfGotBlock()
		ElseIf CheckArea(16669, 11862) Then
			If Not $ErrCity Then MoveTo(16627, 11365)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(16812, 9999)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(17158, 9450)
			If Not $ErrCity Then IfGotBlock()
		EndIf
		If Not $ErrCity Then RndSlp(500)
		If Not $ErrCity Then MoveTo(17590,8899)
		If Not $ErrCity Then $GUY = DllStructGetData(GetNearestAgentToCoords(17590,8899), 'ID')
		If Not $ErrCity Then RndSlp(250)
		If Not $ErrCity Then GoNPC($GUY)
		If Not $ErrCity Then RndSlp(1000)
		If Not $ErrCity Then StoreGolds()
		If Not $ErrCity Then RndSlp(1000)
		If Not $ErrCity Then CurrentAction("Moving to Merchant")
		If Not $ErrCity Then MoveTo(17232, 12373)
		If Not $ErrCity Then $GUY = DllStructGetData(GetNearestAgentToCoords(17223,12362), 'ID')
		If Not $ErrCity Then RndSlp(250)
		If Not $ErrCity Then GoNPC($GUY)
		If Not $ErrCity Then RndSlp(450)
		If Not $ErrCity Then CurrentAction("Selling items to merchant")
		If Not $ErrCity Then SellItemToMerchant()
		If Not $ErrCity Then CurrentAction("Going out of Seitung Harbor")
		If Not $ErrCity Then RndSlp(1000)
		$GOOUTT1 = Random(1, 2, 1)
		If $GOOUTT1 = 1 Then
			If Not $ErrCity Then CurrentAction("Going to run use 1")
			If Not $ErrCity Then MoveTo(17374, 12064)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(17631, 11745)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(17938, 11722)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18684, 12292)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(19161, 12959)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18883, 13817)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18385, 14686)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18367, 15167)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18653,16222)
			If Not $ErrCity Then MoveTo(17502,17034)
			If Not $ErrCity Then Move(16248,17882)
			;pareil, need un genre de keepMoveToo
		ElseIf $GOOUTT1 = 2 Then
			If Not $ErrCity Then CurrentAction("Going to run use 2")
			If Not $ErrCity Then MoveTo(17098, 12463)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(17183, 12887)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(17672, 13411)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18227, 13451)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18669, 13276)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(19019, 13277)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(19015, 13680)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18542, 14428)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18334, 14948)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18653,16222)
			If Not $ErrCity Then MoveTo(17502,17034)
			If Not $ErrCity Then Move(16248,17882)
			;pareil, need un genre de keepMoveToo
		EndIf
	ElseIf $variabledego = 3 Then ; direct au marchand
		If Not $ErrCity Then CurrentAction("Moving to Merchant")
		If Not $ErrCity Then MoveTo(17232, 12373)
		If Not $ErrCity Then $GUY = DllStructGetData(GetNearestAgentToCoords(17223,12362), 'ID')
		If Not $ErrCity Then RndSlp(250)
		If Not $ErrCity Then GoNPC($GUY)
		If Not $ErrCity Then RndSlp(450)
		If Not $ErrCity Then CurrentAction("Selling items to merchant")
		If Not $ErrCity Then SellItemToMerchant()
		If Not $ErrCity Then CurrentAction("Going out of Seitung Harbor")
		If Not $ErrCity Then RndSlp(1000)
		If Not $ErrCity Then $GOOUTT1 = Random(1, 2, 1)
		If $GOOUTT1 = 1 Then
			If Not $ErrCity Then CurrentAction("Going to run use 3")
			If Not $ErrCity Then MoveTo(17374, 12064)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(17631, 11745)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(17938, 11722)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18684, 12292)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(19161, 12959)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18883, 13817)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18385, 14686)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18367, 15167)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18653,16222)
			If Not $ErrCity Then MoveTo(17502,17034)
			If Not $ErrCity Then Move(16248,17882)
			;pareil, need un genre de keepMoveToo
		ElseIf $GOOUTT1 = 2 Then
			If Not $ErrCity Then CurrentAction("Going to run use 4")
			If Not $ErrCity Then MoveTo(17098, 12463)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(17183, 12887)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(17672, 13411)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18227, 13451)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18669, 13276)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(19019, 13277)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(19015, 13680)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18542, 14428)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18334, 14948)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18594, 15644)
			If Not $ErrCity Then IfGotBlock()
			If Not $ErrCity Then MoveTo(18653,16222)
			If Not $ErrCity Then MoveTo(17502,17034)
			If Not $ErrCity Then Move(16248,17882)
			;pareil, need un genre de keepMoveToo
		EndIf
	EndIf
	If Not $ErrCity Then
		WaitForLoad()
	EndIf
	If Not $ErrCity Then RndSlp(2200)
Endfunc   ;==>gosell

Func checkalldeath()
	Local $nearest
	local $TimerDeath = TimerInit()
	Do
		$nearest = GetNearestEnemyToAgent(-2)
		$distance = @extended
		If Not $ErrDead Then RNDSLP(500)
	Until ($distance > 1020) OR (TimerDiff($TimerDeath)) > 40000 OR $ErrDead
EndFunc

Func Ench()
	If Not $ErrDead Then CurrentAction("Putting up enchantments")
	If Not $ErrDead Then UseSkill(7, -2)
	If Not $ErrDead Then RNDSLP(2700)
	If Not $ErrDead Then UseSkill(8, -2)
	If Not $ErrDead Then RndSlp(2700)
EndFunc   ;==>Ench

Func Fight()
	If Not $ErrDead Then UseSkill(1, -2)
	If Not $ErrDead Then RNDSLP(2000)
	If Not $ErrDead Then UseSkill(2, -2)
	If Not $ErrDead Then RNDSLP(1500)
	If Not $ErrDead Then UseSkill(3, -2)
	If Not $ErrDead Then RNDSLP(1500)
	If Not $ErrDead Then UseSkill(4, -2)
	If Not $ErrDead Then RNDSLP(1500)
	If Not $ErrDead Then UseSkill(5, -2)
	If Not $ErrDead Then RNDSLP(1500)
	If Not $ErrDead Then UseSkill(6, -2)
	If Not $ErrDead Then RndSlp(1500)
	If Not $ErrDead Then checkalldeath()
EndFunc   ;==>FIGHT

Func CollectObject()
	Do
		If Not $ErrDead Then RndSlp(500)
	Until DllStructGetData(GetAgentByID(-2), 'EnergyPercent') >= 0.7 OR $ErrDead
	PickupItems()
	CheckIfInventoryIsFull()
 	Do
 		If Not $ErrDead Then RndSlp(500)
		CurrentAction("Waiting for skill 3 to recast")
 	Until DllStructGetData(GetSkillbar(), 'Recharge3') = 0 OR $ErrDead
EndFunc   ;==>CollectObject

Func Engage()
	local $NearestAgent = GetNearestEnemyToAgent(-2)
	$distance = @extended
	If $distance < 3500 Then
		local $timer = TimerInit()
		If Not $ErrDead Then Attack(DllStructGetData($NearestAgent,'ID'))
		Do
			If Not $ErrDead Then RNDSLP(100)
			$NearestAgent = GetNearestEnemyToAgent(-2)
			$distance = @extended
;~ 		Until (GetIsAttacking(-2) = 1 AND (DllStructGetData($NearestAgent,'HP') <> DllStructGetData($NearestAgent,'MaxHP'))) OR (TimerDiff($timer) > 15000) OR $ErrDead
		Until $distance < 900 OR TimerDiff($timer) > 15000 OR $ErrDead
		If TimerDiff($timer) < 15000 Then
			If Not $ErrDead Then FIGHT()
		EndIf
	EndIf
EndFunc   ;==>Engage

Func Farm()
	$ErrDead = False
	If Not $ErrDead Then CurrentAction("Moving to a Yeti group")
	If Not $ErrDead Then MoveTo(9026, -12615)
	If Not $ErrDead Then IfGotBlockArea(9026, -12615)
	If Not $ErrDead Then MoveTo(8626, -12159)
	If Not $ErrDead Then IfGotBlockArea(8626, -12159)
	If Not $ErrDead Then MoveTo(8261, -11149)
	If Not $ErrDead Then IfGotBlockArea(8261, -11149)
	If Not $ErrDead Then ENCH()
	If Not $ErrDead Then CurrentAction("Moving to a Yeti group")
	If Not $ErrDead Then MoveTo(7396, -10291)
	If Not $ErrDead Then IfGotBlockArea(7396, -10291)
	If Not $ErrDead Then MoveTo(3282, -8814)
	If Not $ErrDead Then IfGotBlockArea(3282, -8814)
	If Not $ErrDead Then MoveTo(1737, -6763)
	If Not $ErrDead Then IfGotBlockArea(1737, -6763)
	If Not $ErrDead Then CurrentAction("Killing the Yetis")
	If Not $ErrDead Then FIGHT()
	If Not $ErrDead Then CurrentAction("Collecting Loot from Yetis")
	If Not $ErrDead Then CollectObject()
	If Not $ErrDead Then ENCH()
	If Not $ErrDead Then CurrentAction("Moving to Sensali group 1/12")
	If Not $ErrDead Then MoveTo(1056, -6145)
	If Not $ErrDead Then IfGotBlockArea(1056, -6145)
	If Not $ErrDead Then MoveTo(702, -5244)
	If Not $ErrDead Then IfGotBlockArea(702, -5244)
	If Not $ErrDead Then CurrentAction("Killing Sensali group 1/12")
	If Not $ErrDead Then ENGAGE()
	If Not $ErrDead Then CurrentAction("Collecting Loot from Sensali group 1/12")
	If Not $ErrDead Then CollectObject()
	If Not $ErrDead Then ENCH()
	If Not $ErrDead Then CurrentAction("Moving to Sensali group 2/12")
	If Not $ErrDead Then MoveTo(84, -6503)
	If Not $ErrDead Then IfGotBlockArea(84, -6503)
	If Not $ErrDead Then CurrentAction("Killing Sensali group 2/12")
	If Not $ErrDead Then ENGAGE()
	If Not $ErrDead Then CurrentAction("Collecting Loot from Sensali group 2/12")
	If Not $ErrDead Then CollectObject()
	If Not $ErrDead Then ENCH()
	If Not $ErrDead Then CurrentAction("Moving to Sensali group 3/12")
	If Not $ErrDead Then MoveTo(-1327, -7740)
	If Not $ErrDead Then IfGotBlockArea(-1327, -7740)
	If Not $ErrDead Then MoveTo(-2981, -7971)
	If Not $ErrDead Then IfGotBlockArea(-2981, -7971)
	If Not $ErrDead Then CurrentAction("Killing Sensali group 3/12")
	If Not $ErrDead Then ENGAGE()
	If Not $ErrDead Then CurrentAction("Collecting Loot from Sensali group 3/12")
	If Not $ErrDead Then CollectObject()
	If Not $ErrDead Then ENCH()
	If Not $ErrDead Then CurrentAction("Moving to Sensali group 4/12")
	If Not $ErrDead Then MoveTo(-4793, -7386)
	If Not $ErrDead Then IfGotBlockArea(-4793, -7386)
	If Not $ErrDead Then MoveTo(-4924, -6772)
	If Not $ErrDead Then IfGotBlockArea(-4924, -6772)
	If Not $ErrDead Then MoveTo(-4997, -5348)
	If Not $ErrDead Then IfGotBlockArea(-4997, -5348)
	If Not $ErrDead Then MoveTo(-5061, -4795)
	If Not $ErrDead Then IfGotBlockArea(-5061, -4795)
	If Not $ErrDead Then CurrentAction("Killing Sensali group 4/12")
	If Not $ErrDead Then ENGAGE()
	If Not $ErrDead Then CurrentAction("Collecting Loot from Sensali group 4/12")
	If Not $ErrDead Then CollectObject()
	If Not $ErrDead Then CurrentAction("Moving to Sensali group 5/12")
	If Not $ErrDead Then MoveTo(-5063, -3549)
	If Not $ErrDead Then IfGotBlockArea(-5063, -3549)
	If Not $ErrDead Then ENCH()
	If Not $ErrDead Then CurrentAction("Moving to Sensali group 5/12")
	If Not $ErrDead Then MoveTo(-5570, -3465)
	If Not $ErrDead Then IfGotBlockArea(-5570, -3465)
	If Not $ErrDead Then MoveTo(-6482, -3247)
	If Not $ErrDead Then IfGotBlockArea(-6482, -3247)
	If Not $ErrDead Then MoveTo(-6660, -3003)
	If Not $ErrDead Then IfGotBlockArea(-6660, -3003)
	If Not $ErrDead Then CurrentAction("Killing Sensali group 5/12")
	If Not $ErrDead Then ENGAGE()
	If Not $ErrDead Then CurrentAction("Collecting Loot from Sensali group 5/12")
	If Not $ErrDead Then CheckIfInventoryIsFull()
	If Not $ErrDead Then CollectObject()
	If Not $ErrDead Then CurrentAction("Moving to Sensali group 6/12")
	If Not $ErrDead Then MoveTo(-6660, -3003)
	If Not $ErrDead Then IfGotBlockArea(-6660, -3003)
	If Not $ErrDead Then MoveTo(-6341, -3233)
	If Not $ErrDead Then IfGotBlockArea(-6341, -3233)
	If Not $ErrDead Then MoveTo(-5866, -3363)
	If Not $ErrDead Then IfGotBlockArea(-5866, -3363)
	If Not $ErrDead Then MoveTo(-5337, -3726)
	If Not $ErrDead Then IfGotBlockArea(-5337, -3726)
	If Not $ErrDead Then MoveTo(-5135, -4289)
	If Not $ErrDead Then IfGotBlockArea(-5135, -4289)
	If Not $ErrDead Then MoveTo(-5084, -5184)
	If Not $ErrDead Then IfGotBlockArea(-5084, -5184)
	If Not $ErrDead Then MoveTo(-4973, -6179)
	If Not $ErrDead Then IfGotBlockArea(-4973, -6179)
	If Not $ErrDead Then MoveTo(-4892, -7115)
	If Not $ErrDead Then IfGotBlockArea(-4892, -7115)
	If Not $ErrDead Then MoveTo(-4620, -7443)
	If Not $ErrDead Then IfGotBlockArea(-4620, -7443)
	If Not $ErrDead Then MoveTo(-4143, -7676)
	If Not $ErrDead Then IfGotBlockArea(-4143, -7676)
	If Not $ErrDead Then ENCH()
	If Not $ErrDead Then CurrentAction("Moving to Sensali group 6/12")
	If Not $ErrDead Then MoveTo(-3076, -8012)
	If Not $ErrDead Then IfGotBlockArea(-3076, -8012)
	If Not $ErrDead Then MoveTo(-2353, -8135)
	If Not $ErrDead Then IfGotBlockArea(-2353, -8135)
	If Not $ErrDead Then MoveTo(-2280, -9500)
	If Not $ErrDead Then IfGotBlockArea(-2280, -9500)
	If Not $ErrDead Then MoveTo(-2837, -10490)
	If Not $ErrDead Then IfGotBlockArea(-2837, -10490)
	If Not $ErrDead Then CurrentAction("Killing Sensali group 6/12")
	If Not $ErrDead Then ENGAGE()
	If Not $ErrDead Then CurrentAction("Collecting Loot from Sensali group 6/12")
	If Not $ErrDead Then CheckIfInventoryIsFull()
	If Not $ErrDead Then CollectObject()
	If Not $ErrDead Then ENCH()
	If Not $ErrDead Then CurrentAction("Moving to Sensali group 7/12")
	If Not $ErrDead Then MoveTo(-4875, -10247)
	If Not $ErrDead Then IfGotBlockArea(-4875, -10247)
	If Not $ErrDead Then MoveTo(-6960, -10574)
	If Not $ErrDead Then IfGotBlockArea(-6960, -10574)
	If Not $ErrDead Then CurrentAction("Killing Sensali group 7/12")
	If Not $ErrDead Then ENGAGE()
	If Not $ErrDead Then CurrentAction("Collecting Loot from Sensali group 7/12")
	If Not $ErrDead Then CheckIfInventoryIsFull()
	If Not $ErrDead Then CollectObject()
	If Not $ErrDead Then ENCH()
	If Not $ErrDead Then CurrentAction("Moving to Sensali group 8/12")
	If Not $ErrDead Then MoveTo(-8437, -10309)
	If Not $ErrDead Then IfGotBlockArea(-8437, -10309)
	If Not $ErrDead Then MoveTo(-9419, -9709)
	If Not $ErrDead Then IfGotBlockArea(-9419, -9709)
	If Not $ErrDead Then MoveTo(-10055, -9878)
	If Not $ErrDead Then IfGotBlockArea(-10055, -9878)
	If Not $ErrDead Then CurrentAction("Killing Sensali group 8/12")
	If Not $ErrDead Then ENGAGE()
	If Not $ErrDead Then CurrentAction("Collecting Loot from Sensali group 8/12")
	If Not $ErrDead Then CheckIfInventoryIsFull()
	If Not $ErrDead Then CollectObject()
	If Not $ErrDead Then CurrentAction("Moving to Sensali group 9/12")
	If Not $ErrDead Then MoveTo(-10225, -8861)
	If Not $ErrDead Then IfGotBlockArea(-10225, -8861)
	If Not $ErrDead Then MoveTo(-10862, -8434)
	If Not $ErrDead Then IfGotBlockArea(-10862, -8434)
	If Not $ErrDead Then MoveTo(-12150, -7307)
	If Not $ErrDead Then IfGotBlockArea(-12150, -7307)
	If Not $ErrDead Then ENCH()
	If Not $ErrDead Then CurrentAction("Moving to Sensali group 9/12")
	If Not $ErrDead Then MoveTo(-12792, -6432)
	If Not $ErrDead Then IfGotBlockArea(-12792, -6432)
	If Not $ErrDead Then MoveTo(-13830, -4766)
	If Not $ErrDead Then IfGotBlockArea(-13830, -4766)
	If Not $ErrDead Then MoveTo(-14522, -3763)
	If Not $ErrDead Then IfGotBlockArea(-14522, -3763)
	If Not $ErrDead Then CurrentAction("Killing Sensali group 9/12")
	If Not $ErrDead Then ENGAGE()
	If Not $ErrDead Then CurrentAction("Collecting Loot from Sensali group 9/12")
	If Not $ErrDead Then CheckIfInventoryIsFull()
	If Not $ErrDead Then CollectObject()
	If Not $ErrDead Then CurrentAction("Moving to Sensali group 10/12")
	If Not $ErrDead Then MoveTo(-14362, -2384)
	If Not $ErrDead Then IfGotBlockArea(-14362, -2384)
	If Not $ErrDead Then MoveTo(-13964, -2196)
	If Not $ErrDead Then IfGotBlockArea(-13964, -2196)
	If Not $ErrDead Then ENCH()
	If Not $ErrDead Then CurrentAction("Moving to Sensali group 10/12")
	If Not $ErrDead Then MoveTo(-13000, -1993)
	If Not $ErrDead Then IfGotBlockArea(-13000, -1993)
	If Not $ErrDead Then MoveTo(-12459, -2025)
	If Not $ErrDead Then IfGotBlockArea(-12459, -2025)
	If Not $ErrDead Then MoveTo(-12030, -2341)
	If Not $ErrDead Then IfGotBlockArea(-12030, -2341)
	If Not $ErrDead Then CurrentAction("Killing Sensali group 10/12")
	If Not $ErrDead Then ENGAGE()
	If Not $ErrDead Then CurrentAction("Collecting Loot from Sensali group 10/12")
	If Not $ErrDead Then CheckIfInventoryIsFull()
	If Not $ErrDead Then CollectObject()
	If Not $ErrDead Then ENCH()
	If Not $ErrDead Then CurrentAction("Moving to Sensali group 11/12")
	If Not $ErrDead Then MoveTo(-10570, -2682)
	If Not $ErrDead Then IfGotBlockArea(-10570, -2682)
	If Not $ErrDead Then MoveTo(-9516, 386)
	If Not $ErrDead Then IfGotBlockArea(-9516, 386)
	If Not $ErrDead Then MoveTo(-9400, 718)
	If Not $ErrDead Then IfGotBlockArea(-9400, 718)
	If Not $ErrDead Then MoveTo(-9446, 1194)
	If Not $ErrDead Then IfGotBlockArea(-9446, 1194)
	If Not $ErrDead Then CurrentAction("Killing Sensali group 11/12")
	If Not $ErrDead Then ENGAGE()
	If Not $ErrDead Then CurrentAction("Collecting Loot from Sensali group 11/12")
	If Not $ErrDead Then CheckIfInventoryIsFull()
	If Not $ErrDead Then CollectObject()
	If Not $ErrDead Then CurrentAction("Moving to Sensali group 12/12")
	If Not $ErrDead Then MoveTo(-9413, 1355)
	If Not $ErrDead Then IfGotBlockArea(-9413, 1355)
	If Not $ErrDead Then ENCH()
	If Not $ErrDead Then CurrentAction("Moving to Sensali group 12/12")
	If Not $ErrDead Then MoveTo(-9575, 1955)
	If Not $ErrDead Then IfGotBlockArea(-9575, 1955)
	If Not $ErrDead Then MoveTo(-9771, 2648)
	If Not $ErrDead Then IfGotBlockArea(-9771, 2648)
	If Not $ErrDead Then MoveTo(-9972, 4096)
	If Not $ErrDead Then IfGotBlockArea(-9972, 4096)
	If Not $ErrDead Then MoveTo(-10000, 4477)
	If Not $ErrDead Then IfGotBlockArea(-10000, 4477)
	If Not $ErrDead Then CurrentAction("Killing Sensali group 12/12")
	If Not $ErrDead Then ENGAGE()
	If Not $ErrDead Then CurrentAction("Collecting Loot from Sensali group 12/12")
	If Not $ErrDead Then CollectObject()
EndFunc   ;==>Farm

Func StoreGolds()
	GoldIs(1, 20)
	GoldIs(2, 5)
	GoldIs(3, 10)
	GoldIs(4, 10)
EndFunc

Func GoldIs($bagIndex, $numOfSlots)
	For $i = 1 To $numOfSlots
		ConsoleWrite("Checking items: " & $bagIndex & ", " & $i & @CRLF)
		$aItem = GetItemBySlot($bagIndex, $i)
		If DllStructGetData($aItem, 'ID') <> 0 And DllStructGetData(GetExtraItemInfo($aItem), 'rarity') = $RARITY_Gold Then
			Do
				For $bag = 8 To 12; Storage panels are form 8 till 16 (I have only standard amount plus aniversary one)
					$slot = FindEmptySlot($bag)
					$slot = @extended
					If $slot <> 0 Then
						$FULL = False
						$nSlot = $slot
						ExitLoop 2; finding first empty $slot in $bag and jump out
					Else
						$FULL = True; no empty slots :(
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MoveItem($aItem, $bag, $nSlot)
				ConsoleWrite("Gold item moved ...."& @CRLF)
				Sleep(Random(450, 550))
			EndIf
		EndIf
	Next
EndFunc   ;==>GoldIs

;;PENSER A RAJOUTER UNE VALEUR POUR CONTINUER DE BOUGER KEEPMoveTo
Func WayOut1()
	If Not $ErrCity Then CurrentAction("Going to run use 5")
	If Not $ErrCity Then MoveTo(19182, 12872)
	If Not $ErrCity Then IfGotBlock()
	If Not $ErrCity Then MoveTo(18348, 14835)
	If Not $ErrCity Then IfGotBlock()
	If Not $ErrCity Then MoveTo(18732, 16227)
	If Not $ErrCity Then IfGotBlock()
	If Not $ErrCity Then Move(16248,17882)
EndFunc

Func WayOut11()
	If Not $ErrCity Then CurrentAction("Going to run use 7")
	If Not $ErrCity Then MoveTo(20445, 11641)
	If Not $ErrCity Then IfGotBlock()
	If Not $ErrCity Then MoveTo(18350, 14754)
	If Not $ErrCity Then IfGotBlock()
	If Not $ErrCity Then MoveTo(18776, 16189)
	If Not $ErrCity Then IfGotBlock()
	If Not $ErrCity Then Move(16248,17882)
EndFunc

Func WayOut21()
	If Not $ErrCity Then CurrentAction("Going to run use 9")
	If Not $ErrCity Then MoveTo(17927, 13518)
	If Not $ErrCity Then IfGotBlock()
	If Not $ErrCity Then MoveTo(19060, 13216)
	If Not $ErrCity Then IfGotBlock()
	If Not $ErrCity Then MoveTo(18341, 14932)
	If Not $ErrCity Then IfGotBlock()
	If Not $ErrCity Then MoveTo(18711, 16171)
	If Not $ErrCity Then IfGotBlock()
	If Not $ErrCity Then Move(16248,17882)
EndFunc