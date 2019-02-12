#include-once
#include <Array.au3>
#cs
Olafstead MapID: 645

Xunlai Chest: X: 1253 Y: 755

Merchant: X: 1582, Y:-1025

EOTN: raremat operations

Nodelid 2991 for expert salvage

$item_type = DllStructGetData($item, 'Type')
Type:
cane: 22
sword: 27

$item_insc = GetItemInscr($item)
$item_insc = _ArrayToString($item_insc, "-")
Measure for Measure:
1-3E043225-1D000826
1-3E043225-1E000826

waitmaploading in gwa2gigi now has 25 second deadlock

#ce
;---------------------------------------------------------------------------------------------------------------------
Global Const $RARITY_GREEN = 2627
Global Const $My_Array[30]=[29, 30855, 2513, 5899, 27583,    28432, 22752, 22269, 28431, 35121,   30647, 36442, 36452, 36447, 30641, 31143, 36457, 36456, 32520, 30615,  _
							28436, 29422, 29419, 26501, 22190, 22191, 32526, 3746,22280,3256]

Func TFprint($temp)
	if $temp then
		return "开"
	else
		return "关"
	EndIf
EndFunc

;---------------------------------------------------------------------------------------------------------------------

Func PLACE_FOR_INVENTORY()
				TravelTo(645)
				Inventory()
				Return True
EndFunc   ;==>PLACE_FOR_INVENTORY

Func Inventory()
#cs
	If GetMapID() <> $MAP_ID_RATA Then
		Out("前往顶点")
		$MapRepeat = 0
		RndSleep(5500)
		RndTravel($MAP_ID_RATA)
		$reZone = 1
	EndIf
#ce

;~ Opening the Merchant
	Out("前往商人处")
	MERCHANT()

	Out("正在鉴定")
;~ Identifies each bag
	Ident(1)
	Ident(2)
	Ident(3)
	Ident(4)

	;~ Opening the Chest
	Out("走向储存箱.")
	RndSleep(1000)
	;MoveTo(-22636,10340,250)
	;RndSleep(1000)
	CHEST()

	If GetGoldCharacter() > 90000 Then
		Out("存款于箱")
		DepositGold()
	EndIf

;~ Storing things I want to keep
	StoreItems()
	StoreMaterials()
;	StoreReqs()
	StoreMods()
	StoreRetainedItems()
;	StoreUNIDGolds()
	StoreDaggersAndShields() ;存匕首和盾


	Out("再往商人处")
	MERCHANT()
	Out("正在卖")
;~ Sells each bag

	;DO NOT SELL DAGGERS OR SHIELDS HERE

	;NEED TO IMPLEMENT NOT SELL CANE OR SWORD (done) OR "MEASURE FOR MEASURE" (not done, b/c there's no way to apply it yet anyway, might overflow storage)
	Sell(1)
	Sell(2)
	Sell(3)
	Sell(4)

    ;NEED TO IMPLEMENT, SALVAGE CANE SWORD (done) MEASURE FOR MEASURE (not done, b/c there's no way to apply it yet anyway, might overflow storage)
	Salvage()

	Out("二次买卖")
	Sell(1)
	Sell(2)
	Sell(3)
	Sell(4)

	;make sure you have >100 id and salvage
	NumIDKit()
	NumSalvageKit()

	Out("鉴定器剩: "&$IdentTotalUse)
	Out("拆解器剩: "&$SalvageTotalUse)

	if $SalvageTotalUse < 100 then
		 Out("需要拆解器百+")
	  If GetGoldCharacter() < 2000 Then
		 Out("需要金")
		 WithdrawGold(2000)
		 RndSleep(2000)
	  EndIf
	  BuyItem(4, 1, 2000)
	  NumSalvageKit()
	  if $SalvageTotalUse >= 100 then
		$SalvagedValueTotal+=2000
		GUICtrlSetData($SalvageLabel, $SalvagedValueTotal)
	  EndIf
	  RndSleep(1000)
	EndIf

	if $IdentTotalUse < 100 then
		    Out("需要鉴定器百+")
			If GETGOLDCHARACTER() < 500 And GETGOLDSTORAGE() > 499 Then
				Out("需要金")
				WITHDRAWGOLD(500)
				Sleep(GetPing()+500)
			EndIf
			Local $J = 0
			Do
				BuyItem(6, 1, 500)
				Sleep(GetPing()+500)
				$J = $J + 1
				NumIDKIT()
			Until $IdentTotalUse >= 100 Or $J = 3
			if $J<>3 Then
				$SalvagedValueTotal+=500
				GUICtrlSetData($SalvageLabel, $SalvagedValueTotal)
			EndIf

			Sleep(GetPing()+500)
	EndIf

	Out("二次存放")
	CHEST()
	StoreMaterials()

	If GetGoldCharacter() > 90000 Then
		Out("购买稀有材料")
		RareMaterialTrader()
	EndIf

	If (CountSlots() < 5) Then
		$BotRunning = False
		out("包内空间少于五格， 暂停")
	EndIf

EndFunc


Func RAREMATERIALTRADER()

	TravelTo(642)
	OUT("前往稀物商人")
	GoToNPC(GetNearestNPCToCoords(-2079, 1046))
	RndSleep(3000)

	MATSWITCHER()

	;~This section does the buying
	Local $Z = 0
			Do
				TraderRequest($MATID)
				Sleep(500 + 3 * GetPing())
				Local $LPRICE = GetTraderCostValue()
				Local $PRICE = GUICtrlRead($INPUTPRICEFORRARE, "")
				OUT($MATID&"号现价为: "&$LPRICE)
				OUT("价限为: "&$PRICE)
				$Z = $Z + 1
			Until ($PRICE >= 0) Or $Z = 10
			CHECKGOLD()
			Local $HOWMANYDATAINPUT = GUICtrlRead($HOWMANY, "")
			Local $HOWMANYDATA = $HOWMANYDATAINPUT - 1
			If ($PRICE >= 0) Then
				Local $q = 0
				While ($q <= $HOWMANYDATA)
					Sleep(500)
					TraderRequest($MATID)
					Sleep(500 + 3 * GetPing())
					Local $LPRICE = GetTraderCostValue()
					OUT($MATID&"号现价为: "&$LPRICE)
					OUT("价限为: "&$PRICE)
					If ($LPRICE < $PRICE) Or ($LPRICE == $PRICE) Then
						TraderBuy()
						$q = $q + 1
					Else
						OUT("超过价限，不买")
						ExitLoop
					EndIf
					If (CHECKGOLD() == False) Then ExitLoop
				WEnd
			EndIf
    RndSleep(2000)

EndFunc   ;~ Rare Material trader

Func IDENT($BAGINDEX)
	Local $bag
	Local $I
	Local $AITEM
	$BAG = GETBAG($BAGINDEX)
	For $I = 1 To DllStructGetData($BAG, "slots")
		If FINDIDKIT() = 0 Then
			If GETGOLDCHARACTER() < 500 And GETGOLDSTORAGE() > 499 Then
				WITHDRAWGOLD(500)
				Sleep(GetPing()+500)
			EndIf
			Local $J = 0
			Do
				BuyItem(6, 1, 500)
				Sleep(GetPing()+500)
				$J = $J + 1
			Until FINDIDKIT() <> 0 Or $J = 3
			If $J = 3 Then ExitLoop
			if $J<>3 Then
				$SalvagedValueTotal+=500
				GUICtrlSetData($SalvageLabel, $SalvagedValueTotal)
			EndIf
			Sleep(GetPing()+500)
		EndIf
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		IDENTIFYITEM($AITEM)
		Sleep(GetPing()+500)
	Next
EndFunc


; Big function that calls the smaller functions below
Func StoreItems()
	StackableDrops(1, 20)
	StackableDrops(2, 10)
	StackableDrops(3, 15)
	StackableDrops(4, 15)
	Alcohol(1, 20)
	Alcohol(2, 10)
	Alcohol(3, 15)
	Alcohol(4, 15)
	Party(1, 20)
	Party(2, 10)
	Party(3, 15)
	Party(4, 15)
	Sweets(1, 20)
	Sweets(2, 10)
	Sweets(3, 15)
	Sweets(4, 15)
	Scrolls(1, 20)
	Scrolls(2, 10)
	Scrolls(3, 15)
	Scrolls(4, 15)
	EliteTomes(1, 20)
	EliteTomes(2, 10)
	EliteTomes(3, 15)
	EliteTomes(4, 15)
	Tomes(1, 20)
	Tomes(2, 10)
	Tomes(3, 15)
	Tomes(4, 15)
	DPRemoval(1, 20)
	DPRemoval(2, 10)
	DPRemoval(3, 15)
	DPRemoval(4, 15)
	SpecialDrops(1, 20)
	SpecialDrops(2, 10)
	SpecialDrops(3, 15)
	SpecialDrops(4, 15)
EndFunc ;~ Includes event items broken down by type

Func StoreMaterials()
	Materials(1, 20)
	Materials(2, 10)
	Materials(3, 15)
	Materials(4, 15)
EndFunc ;~ Common and Rare Materials

Func StoreUNIDGolds()
	UNIDGolds(1, 20)
	UNIDGolds(2, 10)
	UNIDGolds(3, 15)
	UNIDGolds(4, 15)
EndFunc ;~ UNID Golds

Func StoreDaggersAndShields()
	sDaggerShield(1, 20)
	sDaggerShield(2, 10)
	sDaggerShield(3, 15)
	sDaggerShield(4, 15)
EndFunc


Func StoreReqs()
	Reqs(1, 20)
	Reqs(2, 10)
	Reqs(3, 15)
	Reqs(4, 15)
EndFunc ;~ Gold weapons that I like that are req9

Func StoreMods()
	Mods(1, 20)
	Mods(2, 10)
	Mods(3, 15)
	Mods(4, 15)
EndFunc ;~ Mods I want to keep

Func StoreRetainedItems()
	Retained(1, 20)
	Retained(2, 10)
	Retained(3, 15)
	Retained(4, 15)
EndFunc


Func StackableDrops($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To DllStructGetData(GetBag($BAGINDEX), 'Slots')
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 460 Or $M = 474 Or $M = 476 Or $M = 486 Or $M = 522 Or $M = 525 Or $M = 811 Or $M = 819 Or $M = 822 Or $M = 835 Or $M = 1610 Or $M = 2994 Or $M = 19185 Or $M = 22751 Or $M = 24629 Or $M = 24630 Or $M = 24631 Or $M = 24632 Or $M = 27033 Or $M = 27035 Or $M = 27044 Or $M = 27046 Or $M = 27047 Or $M = 27052 Or $M = 35123) And $Q = 250 Then
			Do
				For $BAG = 8 to 21
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc ;~ like Suarian Bones, lockpicks, Glacial Stones, etc

Func EliteTomes($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To DllStructGetData(GetBag($BAGINDEX), 'Slots')
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 21796 Or $M = 21797 Or $M = 21798 Or $M = 21799 Or $M = 21800 Or $M = 21801 Or $M = 21802 Or $M = 21803 Or $M = 21804 Or $M = 21805) And $Q = 250 Then
			Do
				For $BAG = 8 to 21
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc ;~ non-Elite tomes only

Func Tomes($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To DllStructGetData(GetBag($BAGINDEX), 'Slots')
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 21796 Or $M = 21797 Or $M = 21798 Or $M = 21799 Or $M = 21800 Or $M = 21801 Or $M = 21802 Or $M = 21803 Or $M = 21804 Or $M = 21805) And $Q = 250 Then
			Do
				For $BAG = 8 to 21
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc ;~ non-Elite tomes only

Func Alcohol($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To DllStructGetData(GetBag($BAGINDEX), 'Slots')
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 910 Or $M = 2513 Or $M = 5585 Or $M = 6049 Or $M = 6366 Or $M = 6367 Or $M = 6375 Or $M = 15477 Or $M = 19171 Or $M = 22190 Or $M = 24593 Or $M = 28435 Or $M = 30855 Or $M = 31145 Or $M = 31146 Or $M = 35124 Or $M = 36682) And $Q = 250 Then
			Do
				For $BAG = 8 to 21
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

Func Party($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To DllStructGetData(GetBag($BAGINDEX), 'Slots')
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 6376 Or $M = 6368 Or $M = 6369 Or $M = 21809 Or $M = 21810 Or $M = 21813 Or $M = 29436 Or $M = 29543 Or $M = 36683 Or $M = 4730 Or $M = 15837 Or $M = 21490 Or $M = 22192 Or $M = 30626 Or $M = 30630 Or $M = 30638 Or $M = 30642 Or $M = 30646 Or $M = 30648 Or $M = 31020 Or $M = 31141 Or $M = 31142 Or $M = 31144 Or $M = 31172) And $Q = 250 Then
			Do
				For $BAG = 8 to 21
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

Func Sweets($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To DllStructGetData(GetBag($BAGINDEX), 'Slots')
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 15528 Or $M = 15479 Or $M = 19170 Or $M = 21492 Or $M = 21812 Or $M = 22269 Or $M = 22644 Or $M = 22752 Or $M = 28431 Or $M = 28432 Or $M = 28436 Or $M = 31150 Or $M = 35125 Or $M = 36681) And $Q = 250 Then
			Do
				For $BAG = 8 to 21
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

Func Scrolls($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To DllStructGetData(GetBag($BAGINDEX), 'Slots')
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 3256 Or $M = 3746 Or $M = 5594 Or $M = 5595 Or $M = 5611 Or $M = 5853 Or $M = 5975 Or $M = 5976 Or $M = 21233 Or $M = 22279 Or $M = 22280) And $Q = 250 Then
			Do
				For $BAG = 8 to 21
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

Func DPRemoval($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To DllStructGetData(GetBag($BAGINDEX), 'Slots')
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 6370 Or $M = 21488 Or $M = 21489 Or $M = 22191 Or $M = 35127 Or $M = 26784 Or $M = 28433) And $Q = 250 Then
			Do
				For $BAG = 8 to 21
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

Func SpecialDrops($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To DllStructGetData(GetBag($BAGINDEX), 'Slots')
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 18345 Or $M = 21491 Or $M = 21833 Or $M = 28434 Or $M = 35121) And $Q = 250 Then
			Do
				For $BAG = 8 to 21
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

Func Materials($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To DllStructGetData(GetBag($BAGINDEX), 'Slots')
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 921 Or $M = 922 Or $M = 923 Or $M = 925 Or $M = 926 Or $M = 927 Or $M = 928 Or $M = 929 Or $M = 930 Or $M = 931 Or $M = 932 Or $M = 933 Or $M = 934 Or $M = 935 Or $M = 936 Or $M = 937 Or $M = 938 Or $M = 939 Or $M = 940 Or $M = 941 Or $M = 942 Or $M = 943 Or $M = 944 Or $M = 945 Or $M = 946 Or $M = 948 Or $M = 949 Or $M = 950 Or $M = 951 Or $M = 952 Or $M = 953 Or $M = 954 Or $M = 955 Or $M = 956 Or $M = 6532 Or $M = 6533) And $Q = 250 Then
			Do
				For $BAG = 8 to 21
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

; Keeps all Golds
Func UNIDGolds($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $R
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To DllStructGetData(GetBag($BAGINDEX), 'Slots')
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$R = GetRarity($AITEM)
		$M = DllStructGetData($AITEM, "ModelID")
		If $R = 2624 Then
			Do
				For $BAG = 8 to 21
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc ;~ UNID golds

Func Retained($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $R
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To DllStructGetData(GetBag($BAGINDEX), 'Slots')
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$R = GetRarity($AITEM)
		$M = DllStructGetData($AITEM, "ModelID")
		If retainThis($AITEM) Then
			Do
				For $BAG = 8 To 21
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc ;~ Retained

Func sDaggerShield($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $R
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To DllStructGetData(GetBag($BAGINDEX), 'Slots')
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$R = GetRarity($AITEM)
		$M = DllStructGetData($AITEM, "ModelID")
		If ($M <> 146) and ((GetItemReq($AITEM) = 5) or (GetItemReq($AITEM) = 6)) and (GetItemAttribute($AITEM) = 29) and (GetItemMaxDmg($AITEM) > 12) and (GetItemInscr($AITEM) <> 0) Then
			Do
				For $BAG = 8 to 21
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf

		If ($M <> 146) and (((GetItemReq($AITEM) = 5) and (GetIsShield($AITEM) > 12)) or _
							((GetItemReq($AITEM) = 6) and (GetIsShield($AITEM) > 13)) or _
							((GetItemReq($AITEM) = 7) and (GetIsShield($AITEM) > 14))) and _
							(GetItemInscr($AITEM) <> 0) Then
			Do
				For $BAG = 8 to 21
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf

		If ($M <> 146) and (DllStructGetData($aItem, 'Type') == 35) and (GetScytheMinDmg($aItem) > 6) and (GetScytheMaxDmg($aItem) > 11) and (GetItemInscr($aItem) <> 0) Then
			Do
				For $BAG = 8 to 21
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc ;~ sDaggerShield

; Keeping only the Skins I like
Func Reqs($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $R
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	Local $Requirement
	For $I = 1 To DllStructGetData(GetBag($BAGINDEX), 'Slots')
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$R = GetRarity($AITEM)
		$M = DllStructGetData($AITEM, "ModelID")
		$Requirement = GetItemReq($aItem)
		If $R = 2624 And (($m = $OakenAegisTactics Or $m = $ShieldoftheLion Or $m = $EquineAegisCommand Or $m = $EquineAegisTactics Or $m = $MaplewoodLongbow Or $m = $DragonHornbow) And $Requirement <= 9) Then
			Do
				For $BAG = 8 to 21
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf

		If $R = 2624 And $m = $RubyMaul Then
			Do
				For $BAG = 8 to 21
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc ;~ Req9s golds

; Stores the mods that I am salvaging out to keep for Hero weapons
Func Mods($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To DllStructGetData(GetBag($BAGINDEX), 'Slots')
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 896 Or $M = 908 Or $M = 15554 Or $M = 15551 Or $M = 15552 Or $M = 894 Or $M = 906 Or $M = 897 Or $M = 909 Or $M = 893 Or $M = 905 Or $M = 6323 Or $M = 6331 Or $M = 895 Or $M = 907 Or $M = 15543 Or $M = 15553 Or $M = 15544 Or $M = 15555 Or $M = 15540 Or $M = 15541 Or $M = 15542 Or $M = 17059 Or $M = 19122 Or $M = 19123) Then
			Do
				For $BAG = 8 to 21
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc

 #region Salvage
 Func Salvage()
   Local $Chest
   Local $Merchant

   ;CHEST() ;not needed for this curreent bot due to previous steps

   ;MERCHANT();not needed b/c previous action was sell

   For $i = 1 To 4
	  If countslots()<1 then exitloop
	  If Not SalvageBag($i) Then ExitLoop
	  If countslots()<1 then exitloop
   Next

 EndFunc


Func SalvageBag($lBag)
	Out("正在拆解第 " & $lBag & "包.")
	Local $aBag
	If Not IsDllStruct($lBag) Then $aBag = GetBag($lBag)
	Local $lItem
	Local $lSalvageType
	Local $lSalvageCount
	For $i = 1 To DllStructGetData($aBag, 'Slots')

		If countslots()<1 then
			out("剩余空间不够")
			return false;no space left
		EndIf

		$lItem = GetItemBySlot($aBag, $i)

		SalvageKit()

		Local $r = GetRarity($lItem)
		Local $m = DllStructGetData($lItem, 'ModelID')

		If (DllStructGetData($lItem, 'ID') == 0) Then ContinueLoop
		if retainThis($lItem) Then ContinueLoop

		;If (DllStructGetData($lItem, 'Type') <> 22) AND (DllStructGetData($lItem, 'Type') <> 27) then continueloop
		;If _ArraySearch($ArraySalvageRarity, $r) = -1 And _ArraySearch($ArraySalvageModelID, $m) = -1 Then ContinueLoop
		$lSalvageCount = SalvageUses($lBag)
		Local $Requirement = GetItemReq($lItem)
		Local $tempValue=DllStructGetData($lItem, 'Value')
		If (((DllStructGetData($lItem, 'Type') == 22) or (DllStructGetData($lItem, 'Type') == 27) or (DllStructGetData($lItem, 'Type') == 15)) and (DllStructGetData($lItem, 'Value')<= $gateValue)) or _
		(GetIsShield($lItem) and (DllStructGetData($lItem, 'Value')<= $gateValue) and (NOT _
							   (((($Requirement = 5) and (GetIsShield($lITEM) > 12)) or _
							   (($Requirement = 6) and (GetIsShield($lITEM) > 13)) or _
							   (($Requirement = 7) and (GetIsShield($lITEM) > 14))) and _
							   (GetItemInscr($lItem) <> 0))  ) ) or _
		((GetItemAttribute($lItem) = 29) and (DllStructGetData($lItem, 'Value')<= $gateValue) and _
		  (NOT ((($Requirement = 5) or ($Requirement = 6))  and (GetItemMaxDmg($lItem) > 12) and (GetItemInscr($lItem) <> 0)) ) ) then

				if NOT StartSalvage($lItem) then
				    out("拆解器用尽")
					return false ;no salvage left
				EndIf

				While (GetPing() > 1250)
					RndSleep(250)
					OUT("太卡了" & GetPing())
				WEnd
				Sleep(GetPing() * 3 + 800)
				out("拆解： "&$lBag&", "&$i) ;uses $lBag b/c $aBag is a struct
				SalvageMaterials()
				Sleep(GetPing() * 3)
				Local $lDeadlock = TimerInit()
				Do
					Sleep(100)
					If (TimerDiff($lDeadlock) > 10000) Then ExitLoop ;was 20000
				Until (SalvageUses($lBag) <> $lSalvageCount)
				if (SalvageUses($lBag) <> $lSalvageCount) then
					$SalvagedValueTotal+=$tempValue
					GUICtrlSetData($SalvageLabel, $SalvagedValueTotal)
					$tempValue=0
				EndIf

		EndIf

		#cs
		$lSalvageType = GetCanSalvage($lItem, True)
		Switch $lSalvageType
			Case -1
				ContinueLoop
			Case 0, 1, 2
				StartSalvage($lItem)
				While (GetPing() > 1250)
					RndSleep(250)
					Out("太卡了" & GetPing())
				WEnd
				Sleep(GetPing() * 3 + 800)
				SalvageMaterials()
				Sleep(GetPing() * 3)
				Local $lDeadlock = TimerInit()
				Do
					Sleep(100)
					If (TimerDiff($lDeadlock) > 20000) Then ExitLoop
				Until (SalvageUses($lBag) <> $lSalvageCount)
				$i -= 1
			Case 3 ; white qty = 1
				StartSalvage($lItem)
				While (GetPing() > 1250)
					RndSleep(250)
					OUT("太卡了" & GetPing())
				WEnd
				Sleep(GetPing() * 3 + 800)
				SalvageMaterials()
				Sleep(GetPing() * 3)
				Local $lDeadlock = TimerInit()
				Do
					Sleep(100)
					If (TimerDiff($lDeadlock) > 20000) Then ExitLoop
				Until (SalvageUses($lBag) <> $lSalvageCount)
			Case 4 ; qty > 1
				StartSalvage($lItem)
				While (GetPing() > 1250)
					RndSleep(250)
					Out("太卡了" & GetPing())
				WEnd
				Sleep(GetPing() + 800)
				SalvageMaterials()
				Local $lDeadlock = TimerInit()
				Do
					Sleep(100)
					If (TimerDiff($lDeadlock) > 20000) Then ExitLoop
				Until (SalvageUses($lBag) <> $lSalvageCount)
				$i -= 1
		EndSwitch
		#ce
	Next
	Return True
EndFunc   ;==>SalvageBag


 Func SalvageKit()
   If FindSalvageKit() = 0 Then
	  Out("需要拆解器")
	  If GetGoldCharacter() < 2000 Then
		 Out("需要金")
		 WithdrawGold(2000)
		 RndSleep(2000)
	  EndIf
	  BuyItem(4, 1, 2000)
	  if FindSalvageKit() <> 0 then
		  $SalvagedValueTotal+=2000
		  GUICtrlSetData($SalvageLabel, $SalvagedValueTotal)
	  EndIf
	  RndSleep(1000)
   EndIf
 EndFunc


 Func GetCanSalvage($aItem, $aMerchant)
	If DllStructGetData($aItem, 'Customized') <> 0 Then Return -1

	Switch DllStructGetData($aItem, 'type')
		Case 0, 2, 5, 12, 15, 22, 24, 26, 27, 32, 35, 36
		Case 30
			If DllStructGetData($aItem, 'value') <= 0 Then Return -1
		Case Else
			Return -1
	EndSwitch

   Local $r = GetRarity($aItem)

   Switch $r
	    Case 2621
			If DllStructGetData($aItem, 'Quantity') > 1 Then
			   If Not $aMerchant Then Return -1
			   Return 4
			EndIf
			Return 3
		Case 2623, 2624, 2626
;~ 			If Not $aMerchant Then Return -1
;~ 			$lModString = GetModStruct($aItem)
;~ 			For $i = 0 To UBound($Inv_mMods) - 1
;~ 				If StringInStr($lModString, $Inv_mMods[$i][0]) Then
;~ 				  Out("Salvaging " & $Inv_mMods[$i][1] & " from item.")
;~ 				  Return $Inv_mMods[$i][2]
;~ 				EndIf
;~ 			Next
			Return -1
		Case Else
			Return -1
	EndSwitch

EndFunc   ;==>GetCanSalvage

Func SalvageUses($aBags)

	Local $lBag
	Local $lItem
	Local $lCount = 0
	For $i = 1 To 21 ;;;;;;16 was $aBags      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;mistake
		$lBag = GetBag($i)
		For $j = 1 To DllStructGetData($lBag, 'Slots')
			$lItem = GetItemBySlot($lBag, $j)
			Switch DllStructGetData($lItem, 'ModelID')
				Case 2991
					$lCount += DllStructGetData($lItem, 'Value') / 8
				Case 5900
					$lCount += DllStructGetData($lItem, 'Value') / 10
				Case 2992
					$lCount += DllStructGetData($lItem, 'Value') / 2
				Case 2993
					$lCount += DllStructGetData($lItem, 'Value') / 2
			EndSwitch
		Next
	Next
	Out("剩余次数:" & $lCount)
	Return $lCount
EndFunc   ;==>SalvageUses

Func SalvageCount($aBags)
	Local $lBag
	Local $lItem
	Local $lModString
	Local $lCount = 0

	For $i = 1 To $aBags
		$lBag = GetBag($i)
		For $j = 1 To DllStructGetData($lBag, 'Slots')
			$lItem = GetItemBySlot($lBag, $j)
			If DllStructGetData($lItem, 'ID') == 0 Then ContinueLoop

			If GetCanSalvage($lItem, False) <> -1 Then $lCount += 1
		Next
	Next
	Return $lCount
EndFunc   ;==>SalvageCount
#endregion Salvage

Func CHEST()
				OUT("前往储存箱")
				GoToNPC(GetNearestNPCToCoords(1253, 755))
				RndSleep(3000)
EndFunc   ;~ Xunlai Chest

Func MERCHANT()
				OUT("前往商人")
				GoToNPC(GetNearestNPCToCoords(1582, -1025))
				RndSleep(3000)
EndFunc   ;~ Merchant


Func CHECKAREA($AX, $AY)
	Local $RET = False
	Local $PX = DllStructGetData(GetAgentByID(-2), "X")
	Local $PY = DllStructGetData(GetAgentByID(-2), "Y")
	If ($PX < $AX + 500) And ($PX > $AX - 500) And ($PY < $AY + 500) And ($PY > $AY - 500) Then
		$RET = True
	EndIf
	Return $RET
EndFunc   ;==>CHECKAREA


;==>Pickup
;~ Description: standard pickup function, only modified to increment a custom counter when taking stuff with a particular ModelID

Func PickUpLoot()
	Local $lAgent
	Local $lItem
	Local $lDeadlock
	Local $lBlocklock

	;DELETE NEXT 2 FOR-BLOCK BELOW TO RETURN TO NORMAL=======================================================
#cs
	For $i = 1 To GetMaxAgents() ;merge 435 and 436 to return to normal
		If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If (DllStructGetData($lItem, 'ModelID') = 22269) Then ;910
			PickUpItem($lItem)
			$lDeadlock = TimerInit()
			$lBlocklock = TimerInit()
			While GetAgentExists($i)
				Sleep(100)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
				If TimerDiff($lBlocklock) > 4000 Then
					MoveTo(DllStructGetData(GetAgentByID(-2),'X'),DllStructGetData(GetAgentByID(-2),'Y'), 70)
					PickUpLoot()
					$lBlocklock = TimerInit()
				EndIf
			WEnd
		EndIf
	Next

	For $i = 1 To GetMaxAgents() ;merge 435 and 436 to return to normal
		If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If (DllStructGetData($lItem, 'ModelID') = 28435) Then ;or (DllStructGetData($lItem, 'ModelID') = 22269)
			PickUpItem($lItem)
			$lDeadlock = TimerInit()
			$lBlocklock = TimerInit()
			While GetAgentExists($i)
				Sleep(100)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
				If TimerDiff($lBlocklock) > 4000 Then
					MoveTo(DllStructGetData(GetAgentByID(-2),'X'),DllStructGetData(GetAgentByID(-2),'Y'), 70)
					PickUpLoot()
					$lBlocklock = TimerInit()
				EndIf
			WEnd
		EndIf
	Next
	#ce
;#cs UNCOMMENT TO RETURN TO NORMAL======================================================================
	;Local $maxAgent = GetMaxAgents()
	;~ 加了不常见的以函数为序号的部分: getmaxagent
	local $PickUpIndex1 = GetMaxAgents()
	For $i = 1 To $PickUpIndex1 ;merge 435 and 436 to return to normal
		If (CountSlots() < 1) then return
		If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If FirstPickup($lItem) Then
			PickUpItem($lItem)
			$lDeadlock = TimerInit()
			$lBlocklock = TimerInit()
			While GetAgentExists($i)
				Sleep(100)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
				If TimerDiff($lBlocklock) > 4000 Then
					MoveTo(DllStructGetData(GetAgentByID(-2),'X'),DllStructGetData(GetAgentByID(-2),'Y'), 70)
					PickUpLoot()
					$lBlocklock = TimerInit()
				EndIf
			WEnd
		EndIf
		;$maxAgent = GetMaxAgents();delete this line to return to normal
	Next

	;~ 加了不常见的以函数为序号的部分
	local $PickUpIndex2 = GetMaxAgents()
	For $i = 1 To $PickUpIndex2 ;merge 435 and 436 to return to normal
		If (CountSlots() < 1) then return
		If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If CanPickup($lItem) Then
			PickUpItem($lItem)
			$lDeadlock = TimerInit()
			$lBlocklock = TimerInit()
			While GetAgentExists($i)
				Sleep(100)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
				If TimerDiff($lBlocklock) > 4000 Then
					MoveTo(DllStructGetData(GetAgentByID(-2),'X'),DllStructGetData(GetAgentByID(-2),'Y'), 70)
					PickUpLoot()
					$lBlocklock = TimerInit()
				EndIf
			WEnd
		EndIf
		;$maxAgent = GetMaxAgents();delete this line to return to normal
	Next
;#ce END UNCOMMENT TO RETURN TO NORMAL======================================================================
EndFunc   ;==>PickUpLoot

Func FirstPickUp($aItem)
	Local $lModelID = DllStructGetData(($aItem), 'ModelID')
	Local $aExtraID = DllStructGetData($aItem, "ExtraID")
	Local $lRarity = GetRarity($aItem)
	Local $Requirement = GetItemReq($aItem)
	If($lModelID == $ITEM_ID_GOLDEN_EGGS)Then
		Return True
	elseif ($lModelID == $ITEM_ID_CUPCAKES) Then
		Return True
	elseif ($lModelID == $ITEM_ID_PIE)Then
		Return True
	elseif ($lModelID == $ITEM_ID_TOTS)Then
		Return True
	elseif ($lModelID == $ITEM_ID_LUNAR_TOKEN)Then
		Return True
	elseif ($lModelID == $ITEM_ID_LUNAR_TOKENS) Then
		Return True
	elseIf ($lModelID == $ITEM_ID_DYES) Then	; if dye
		If (($aExtraID == $ITEM_EXTRAID_BLACKDYE) Or ($aExtraID == $ITEM_EXTRAID_WHITEDYE))Then ; only pick white and black ones
			Return True
		EndIf
	else
		return False
	EndIf
EndFunc

; Checks if should pick up the given item. Returns True or False
Func CanPickUp($aItem)
	Local $lModelID = DllStructGetData(($aItem), 'ModelID')
	Local $aExtraID = DllStructGetData($aItem, "ExtraID")
	Local $lRarity = GetRarity($aItem)
	Local $Requirement = GetItemReq($aItem)

	;节日后擦掉
	#cs
	if $LMODELID == 22752 or $LMODELID == 22751 or $LMODELID == 22644 or $LMODELID == 27035 or _
	   $LMODELID == 36681 or $LMODELID == $ITEM_ID_PARTY_BEACON or  $LMODELID == $ITEM_ID_BATTLE_ISLE_ICED_TEA or _
	   $LMODELID == $ITEM_ID_CIDER or $LMODELID == $ITEM_ID_KRYTAN_BRANDY or $LMODELID == $ITEM_ID_HUNTERS_ALE or $LMODELID == $ITEM_ID_HONEYCOMB or _
	   $LMODELID ==	$ITEM_ID_VICTORY_TOKEN or $LMODELID = 21786 or $LMODELID = 21796 Then
		return True
	elseif (($lModelID == 2511) And (GetGoldCharacter() < 99000)) Then
		return true
	Else
		return False
	EndIf
	#ce


	If (($lModelID == 2511) And (GetGoldCharacter() < 99000)) Then
		Return True	; gold coins (only pick if character has less than 99k in inventory)
	Elseif ($lModelID == 19184) then ;如是鳞翅, 则:
		Return True ;要求捡起
	Elseif ($lModelID == 19185) then ;如非鳞翅，但是兽肉， 则:
		Return True ;要求捡起
	Elseif (DllStructGetData($aItem, 'Type') == 35) and (GetScytheMinDmg($aItem) > 6) and (GetScytheMaxDmg($aItem) > 11) and ($lRarity <> $RARITY_WHITE) then ;如武器为镰刀类, 并且最低伤害大于等于7, 同时最高伤害大于等于12, 且非白色, 则:
		Return True ;要求捡起
	ElseIf (DllStructGetData($aItem, 'Type') == 22) or (DllStructGetData($aItem, 'Type') == 27) or (DllStructGetData($aItem, 'Type') == 15) then
		Return True ; gets cane and sword of any color to be salvaged
	ElseIf ($lModelID=27035) Then
		Return True ;saurian bone
	ElseIf ($PickUpTomes = True) AND (($lModelID == $ITEM_ID_Mesmer_Tome) Or ($lModelID=21786) Or ($lModelID=21787) Or ($lModelID=21788) Or ($lModelID=21789) Or ($lModelID=21790) Or ($lModelID=21791) Or ($lModelID=21792) Or ($lModelID=21793) Or ($lModelID=21794) Or ($lModelID=21795) Or ($lModelID=21796) Or ($lModelID=21797) Or ($lModelID=21798) Or ($lModelID=21799) Or ($lModelID=21800) Or ($lModelID=21801) Or ($lModelID=21802) Or ($lModelID=21803) Or ($lModelID=21804) Or ($lModelID=21805)) Then
		Return True	; all tomes, not just mesmer
	ElseIf ($lModelID == $ITEM_ID_DYES) Then	; if dye
		If (($aExtraID == $ITEM_EXTRAID_BLACKDYE) Or ($aExtraID == $ITEM_EXTRAID_WHITEDYE))Then ; only pick white and black ones
			Return True
		EndIf
	ElseIf ($lRarity == $RARITY_GOLD) And $PickUpAll Then ; gold items
		Return True
	ElseIf ($lRarity == $RARITY_GREEN) And $PickUpAll Then ; 拿绿
		Return False

;#cs 若蓝/紫中只要达标的匕首和盾
	; use getattribute from helper for list
	elseif ($LMODELID <> 146) and (($Requirement = 5) or ($Requirement = 6)) and (GetItemAttribute($aItem) = 29) and (GetItemMaxDmg($aItem) > 12)  Then

		Return True


	elseIf ($LMODELID <> 146) and ((($Requirement = 5) and (GetIsShield($aItem) > 12)) or _
							   (($Requirement = 6) and (GetIsShield($aItem) > 13)) or _
							   (($Requirement = 7) and (GetIsShield($aItem) > 14))) Then
		Return True

	elseif GetIsShield($aItem) <> 0 Then
		return True ;PICK UP ALL SHIELD
	elseif (GetItemAttribute($aItem) = 29) Then
		return True ;PICK UP ALL DAGGERS
;#ce

	ElseIf ($lRarity == $RARITY_PURPLE) And $PickUpAll Then ;拿紫   ;$lModelID, $Requirement
		Return False
	ElseIf ($lRarity == $RARITY_BLUE) And $PickUpAll Then ;拿蓝
		Return False
	ElseIf($lModelID == $ITEM_ID_LOCKPICKS)Then
		Return True ; Lockpicks
	ElseIf($lModelID == $ITEM_ID_GLACIAL_STONES)Then
		Return True ; glacial stones
	ElseIf CheckArrayPscon($lModelID)Then ; ==== Pcons ==== or all event items
		Return True
	ElseIf CheckArrayMapPieces($lModelID) And ($PickUpMapPieces = True) Then ; ==== Map Pieces ====
		Return True
;	ElseIf CheckArrayWeapons($lModelID)Then ; ==== Weapons ====
;		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>CanPickUp

Func CheckArrayPscon($lModelID)
For $p = 0 To (UBound($Array_pscon) -1)
	If ($lModelID == $Array_pscon[$p]) Then Return True
Next
EndFunc


Func SELL($BAGINDEX)
	Local $AITEM
	Local $BAG = GETBAG($BAGINDEX)
	Local $NUMOFSLOTS = DllStructGetData($BAG, "slots")
	For $I = 1 To DllStructGetData(GetBag($BAGINDEX), 'Slots')
		Out("正在卖: " & $BAGINDEX & ", " & $I)
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		If CANSELL($AITEM) Then
			SELLITEM($AITEM)
		EndIf
		Sleep(GetPing()+250)
	Next
EndFunc

Func CANSELL($aItem)
	Local $LMODELID = DllStructGetData($aitem, "ModelID")
	Local $LRARITY = GETRARITY($aitem)
	Local $Requirement = GetItemReq($aItem)

	#cs Reference for inscription
			$item_type = DllStructGetData($item, 'Type') ;32 is dagger
			$item_ModStruct = GetModStruct($item)
			$item_insc = GetItemInscr($item)
			$item_insc = _ArrayToString($item_insc, "-")
			$item_mod1 = GetItemMod1($item)
			$item_mod1 = _ArrayToString($item_mod1, "-")
			$item_mod2 = GetItemMod2($item)
			$item_mod2 = _ArrayToString($item_mod2, "-")
			$itemcount += 1
	#ce
	If ($lModelID == 19184) then ;如是鳞翅，则:
		Return False
	EndIf

	If ($lModelID == 19185) then ;如是兽肉， 则:
		Return False
	EndIf

	If ($LMODELID=946) Then
		Return True ;Wood, it will be sold every time; code for storing wood does not need to be changed b/c there won't be a stack to store
	EndIf

	if (DllStructGetData($aItem, 'Type') == 35) and (GetScytheMinDmg($aItem) > 6) and (GetScytheMaxDmg($aItem) > 11) and (GetItemInscr($aItem) <> 0) then ;如鉴定后 此物亦有铸印, 则:
		Return False ;要求买卖功能 勿 卖
	EndIf

	if retainThis($aItem) Then
		Return False
	EndIf

	If ((DllStructGetData($aItem, 'Type') == 22) and (DllStructGetData($aItem, 'Value') <= $gateValue)) or _
	   ((DllStructGetData($aItem, 'Type') == 27) and (DllStructGetData($aItem, 'Value') <= $gateValue)) or _
	   ((DllStructGetData($aItem, 'Type') == 15) and (DllStructGetData($aItem, 'Value') <= $gateValue)) or _
	   ((GetIsShield($aItem)<>0) and (DllStructGetData($aItem, 'Value') <= $gateValue)) or _
	   ((GetItemAttribute($aItem) = 29) and (DllStructGetData($aItem, 'Value') <= $gateValue)) then
		Return False ; gets cane and sword, hammer of any color, and shield and dagger to be salvaged
	EndIf

	; use getattribute from helper for list
	if ($LMODELID <> 146) and (($Requirement = 5) or ($Requirement = 6)) and (GetItemAttribute($aItem) = 29) and (GetItemMaxDmg($aItem) > 12) and (GetItemInscr($aItem) <> 0) Then
		Return False
	EndIf

	If ($LMODELID <> 146) and ((($Requirement = 5) and (GetIsShield($AITEM) > 12)) or _
							   (($Requirement = 6) and (GetIsShield($AITEM) > 13)) or _
							   (($Requirement = 7) and (GetIsShield($AITEM) > 14))) and _
							   (GetItemInscr($aItem) <> 0) Then
		Return False
	EndIf

	If ($LMODELID=27035) Then
		Return False ;saurian bone
	EndIf

	; 卖紫色物品
	If $LRARITY == $RARITY_PURPLE Then
		Return True
	EndIf
	; 卖蓝色物品
	If $LRARITY == $RARITY_BLUE Then
		Return True
	EndIf
	; 不要卖白色， 因为既不捡白色，又不该卖掉鉴定等不该卖的白色物品
	If $LRARITY == $RARITY_WHITE Then
		Return FALSE
	EndIf
	; 卖非黑和非白的染
	If $LMODELID == $ITEM_ID_DYES Then
		Switch DllStructGetData($aitem, "ExtraID")
			Case $ITEM_EXTRAID_BLACKDYE, $ITEM_EXTRAID_WHITEDYE
				Return False
			Case Else
				Return True
		EndSwitch
	EndIf


	If $lModelID > 21785 And $lModelID < 21806 			Then Return False ; Elite/Normal Tomes
	If $lModelID > 920 And $lModelID < 957				Then Return False ; Materials
	If $lModelID > 6531 And $lModelID < 6534			Then Return False ; Amber and Jade
; Inscriptions
	If $lModelID == $ITEM_ID_INSCRIPTIONS_MARTIAL		Then Return False ; Martial Weapons
	If $lModelID == $ITEM_ID_INSCRIPTIONS_FOCUS_SHIELD	Then Return False ; Focus Items or Shields
	If $lModelID == $ITEM_ID_INSCRIPTIONS_ALL			Then Return False ; All Weapons
	If $lModelID == $ITEM_ID_INSCRIPTIONS_GENERAL		Then Return False ; General
	If $lModelID == $ITEM_ID_INSCRIPTIONS_SPELLCASTING	Then Return False ; Spellcasting Weapons
	If $lModelID == $ITEM_ID_INSCRIPTIONS_FOCUS_ITEMS	Then Return False ; Focus Items
	; ==== Weapon Mods ====
	If $lModelID == $ITEM_ID_STAFF_HEAD					Then Return False ; All Staff heads
	If $lModelID == $ITEM_ID_STAFF_WRAPPING				Then Return False ; All Staff wrappings
	If $lModelID == $ITEM_ID_SHIELD_HANDLE				Then Return False ; All Shield Handles
	If $lModelID == $ITEM_ID_FOCUS_CORE					Then Return False ; All Focus Cores
	If $lModelID == $ITEM_ID_WAND						Then Return False ; All Wands
	If $lModelID == $ITEM_ID_BOW_STRING					Then Return False ; All Bow strings
	If $lModelID == $ITEM_ID_BOW_GRIP					Then Return False ; All Bow grips
	If $lModelID == $ITEM_ID_SWORD_HILT					Then Return False ; All Sword hilts
	If $lModelID == $ITEM_ID_SWORD_POMMEL				Then Return False ; All Sword pommels
	If $lModelID == $ITEM_ID_AXE_HAFT					Then Return False ; All Axe hafts
	If $lModelID == $ITEM_ID_AXE_GRIP					Then Return False ; All Axe grips
	If $lModelID == $ITEM_ID_DAGGER_TANG				Then Return False ; All Dagger tangs
	If $lModelID == $ITEM_ID_DAGGER_HANDLE				Then Return False ; All Dagger handles
	If $lModelID == $ITEM_ID_HAMMER_HAFT				Then Return False ; All Hammer hafts
	If $lModelID == $ITEM_ID_HAMMER_GRIP				Then Return False ; All Hammer grips
	If $lModelID == $ITEM_ID_SCYTHE_SNATHE				Then Return False ; All Scythe snathes
	If $lModelID ==	$ITEM_ID_SCYTHE_GRIP				Then Return False ; All Scythe grips
	If $lModelID == $ITEM_ID_SPEARHEAD					Then Return False ; All Spearheads
	If $lModelID == $ITEM_ID_SPEAR_GRIP					Then Return False ; All Spear grips
	; ==== General ====
	If $lModelID == $ITEM_ID_ID_KIT						Then Return False
	If $lModelID == $ITEM_ID_SUP_ID_KIT					Then Return False
	If $lModelID == $ITEM_ID_SALVAGE_KIT				Then Return False
	If $lModelID == $ITEM_ID_EXP_SALVAGE_KIT			Then Return False
	If $lModelID == $ITEM_ID_SUP_SALVAGE_KIT			Then Return False
	If $lModelID == $ITEM_ID_LOCKPICKS 					Then Return False
	If $lModelID == $ITEM_ID_GLACIAL_STONES 			Then Return False
	; ==== Alcohol ====
	If $lModelID == $ITEM_ID_HUNTERS_ALE				Then Return False
	If $lModelID == $ITEM_ID_DWARVEN_ALE				Then Return False
	If $lModelID == $ITEM_ID_SPIKED_EGGNOG				Then Return False
	If $lModelID == $ITEM_ID_EGGNOG						Then Return False
	If $lModelID == $ITEM_ID_SHAMROCK_ALE				Then Return False
	If $lModelID == $ITEM_ID_AGED_DWARVEN_ALE			Then Return False
	If $lModelID == $ITEM_ID_CIDER						Then Return False
	If $lModelID == $ITEM_ID_GROG 						Then Return False
	If $lModelID == $ITEM_ID_AGED_HUNTERS_ALE			Then Return False
	If $lModelID == $ITEM_ID_KRYTAN_BRANDY				Then Return False
	If $lModelID == $ITEM_ID_BATTLE_ISLE_ICED_TEA		Then Return False
	; ==== Party ====
	If $lModelID == $ITEM_ID_SNOWMAN_SUMMONER			Then Return False
	If $lModelID == $ITEM_ID_ROCKETS					Then Return False
	If $lModelID == $ITEM_ID_POPPERS					Then Return False
	If $lModelID == $ITEM_ID_SPARKLER					Then Return False
	If $lModelID == $ITEM_ID_PARTY_BEACON				Then Return False
	; ==== Sweets ====
	If $lModelID == $ITEM_ID_FRUITCAKE					Then Return False
	If $lModelID == $ITEM_ID_BLUE_DRINK					Then Return False
	If $lModelID == $ITEM_ID_CUPCAKES					Then Return False
	If $lModelID == $ITEM_ID_BUNNIES 					Then Return False
	If $lModelID == $ITEM_ID_GOLDEN_EGGS 				Then Return False
	If $lModelID == $ITEM_ID_PIE						Then Return False
	; ==== Tonics ====
	If $lModelID == $ITEM_ID_TRANSMOGRIFIER				Then Return False
	If $lModelID == $ITEM_ID_YULETIDE					Then Return False
	If $lModelID == $ITEM_ID_FROSTY						Then Return False
	If $lModelID == $ITEM_ID_MISCHIEVIOUS				Then Return False
	; ==== DP Removal ====
	If $lModelID == $ITEM_ID_PEPPERMINT_CC				Then Return False
	If $lModelID == $ITEM_ID_WINTERGREEN_CC				Then Return False
	If $lModelID == $ITEM_ID_RAINBOW_CC					Then Return False
	If $lModelID == $ITEM_ID_CLOVER 					Then Return False
	If $lModelID == $ITEM_ID_HONEYCOMB					Then Return False
	If $lModelID == $ITEM_ID_PUMPKIN_COOKIE				Then Return False
	; ==== Special Drops =
	If $lModelID == $ITEM_ID_CC_SHARDS					Then Return False
	If $lModelID == $ITEM_ID_VICTORY_TOKEN				Then Return False
	If $lModelID == $ITEM_ID_WINTERSDAY_GIFT			Then Return False
	If $lModelID == $ITEM_ID_TOTS 						Then Return False
	If $lModelID == $ITEM_ID_LUNAR_TOKEN				Then Return False
	If $lModelID == $ITEM_ID_LUNAR_TOKENS				Then Return False
	If $lModelID == $ITEM_ID_WAYFARER_MARK				Then Return False
	; ==== Stupid Drops =
	If $lModelID == $ITEM_ID_MAP_PIECE_TL				Then Return False
	If $lModelID == $ITEM_ID_MAP_PIECE_TR				Then Return False
	If $lModelID == $ITEM_ID_MAP_PIECE_BL				Then Return False
	If $lModelID == $ITEM_ID_MAP_PIECE_BR				Then Return False
	; ==== MISC ====
	If arrayContains($My_Array, $lModelID)				Then Return False
	If CheckArrayPscon($lModelID)						Then Return False

	; 卖金色物品
	If $LRARITY == $RARITY_GOLD Then
		Return True
	EndIf

	Return True
EndFunc   ;==>CANSELL