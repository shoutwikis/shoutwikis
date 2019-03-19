Global $nMerchant[8] = ["雜貨商人","Merchant", "Marchand", "Kaufmann", "Mercante", "asdf", "Kupiec", "Merchunt"]
Global $nXunlai[8] = ["桑萊保險箱","Xunlai Chest", "Coffre Xunlai", "Xunlai-Truhe", "Forziere Xunlai", "asdf", "Skrzynia Xunlai", "Xoonlaeee Chest"]

Global $Inv_TempStorage[1][2] = [[0, 0]]
Global $Inv_mLog = False
;~ ["Modstruct Identifier", "Description", ModIndex]
;~ Model IDs to ignore
Global Const $Inv_mModels[15] = [400, 749, 773, 790, 793, 211, 946, 951, 958, 962, 1045, 1900, 1973, 2071, 2206]

SetInventoryLogFunction("Upd")

Func SetInventoryLogFunction($aLogFunction = False)
	$Inv_mLog = $aLogFunction
EndFunc   ;==>SetInventoryLogFunction

Func InventoryUpd($aString)
	If $Inv_mLog Then Call($Inv_mLog, $aString)
EndFunc   ;==>InventoryOut

Func Inventory()


;~ Opening the Merchant
	Upd("前往商人处")
	MERCHANT()

	Upd("正在鉴定")
;~ Identifies each bag
	Ident(1)
	Ident(2)
	Ident(3)
	Ident(4)

	;~ Opening the Chest
	Upd("走向储存箱.")
	RndSleep(1000)
	MoveTo(-22636,10340,250)
	RndSleep(1000)
	CHEST()

	If GetGoldCharacter() > 90000 Then
		Upd("存款于箱")
		DepositGold()
	EndIf

;~ Storing things I want to keep
	Upd("正在储存其他物品于箱")
	StoreItems()
	StoreMaterials()
;	StoreReqs()
	StoreMods()
;	StoreUNIDGolds()
	StoreDaggersAndShields() ;存匕首和盾

	Upd("再往商人处")
	MERCHANT()
	Upd("正在卖")
;~ Sells each bag

	;DO NOT SELL DAGGERS OR SHIELDS HERE
	Sell(1)
	Sell(2)
	Sell(3)
	Sell(4)

	If GetGoldCharacter() > 90000 Then
		;空
	EndIf

	If (CountSlots() < 5) Then
		$BotRunning = False
		Upd("包内空间少于五格， 暂停")
	EndIf

EndFunc

Func CHECKAREA($AX, $AY)
	Local $RET = False
	Local $PX = DllStructGetData(GetAgentByID(-2), "X")
	Local $PY = DllStructGetData(GetAgentByID(-2), "Y")
	If ($PX < $AX + 500) And ($PX > $AX - 500) And ($PY < $AY + 500) And ($PY > $AY - 500) Then
		$RET = True
	EndIf
	Return $RET
EndFunc   ;==>CHECKAREA


Func CHEST()
	#cs
	Dim $Waypoints_by_XunlaiChest[16][3] = [ _
			[$BURNINGISLE, -5469, -2593], _
			[$DRUIDISLE, -1826, 5567], _
			[$FROZENISLE, -282, 3769], _
			[$HUNTERISLE, 4747, 7376], _
			[$ISLEOFDEAD, -4688, -1446], _
			[$NOMADISLE, 4630, 4724], _
			[$WARRIORISLE, 4229, 6798], _
			[$WIZARDISLE, 4865, 9834], _
			[$IMPERIALISLE, 2403, 13211], _
			[$ISLEOFJADE, 8737, 2647], _
			[$ISLEOFMEDITATION, -817, 7773], _
			[$ISLEOFWEEPING, -1713, 7169], _
			[$CORRUPTEDISLE, -5031, 6113], _
			[$ISLEOFSOLITUDE, 4610, 3059], _
			[$ISLEOFWURMS, 8735, 3747], _
			[$UNCHARTEDISLE, 4508, -4597]]
	For $i = 0 To (UBound($Waypoints_by_XunlaiChest) - 1)
		If ($Waypoints_by_XunlaiChest[$i][0] == True) Then
			Do
				GENERICRANDOMPATH($Waypoints_by_XunlaiChest[$i][1], $Waypoints_by_XunlaiChest[$i][2], Random(60, 80, 2))
	Until CHECKAREA($Waypoints_by_XunlaiChest[$i][1], $Waypoints_by_XunlaiChest[$i][2])
	#ce
   For $i = 1 To 8 ; Open chest
	  Local $lChest = GetAgentByName($nXunlai[$i-1])
	  If IsDllStruct($lChest) Then
		 Upd("找到储存箱 !")
		 GoToNPC($lChest)
		 ExitLoop
	  ElseIf $i = 8 Then
		 Upd("无法找到储存箱")
	  EndIf
   Next
		;EndIf
	;Next
EndFunc   ;~ Xunlai Chest

Func MERCHANT()
	#cs
	Dim $Waypoints_by_Merchant[16][3] = [ _
			[$BURNINGISLE, -2515, 1109], _
			[$DRUIDISLE, -2037, 2964], _
			[$FROZENISLE, -299, 79], _
			[$HUNTERISLE, 4253, 6392], _
			[$ISLEOFDEAD, -4061, -1059], _
			[$NOMADISLE, 5129, 4748], _
			[$WARRIORISLE, 5608, 9137], _
			[$WIZARDISLE, 3468, 8993], _
			[$IMPERIALISLE, 1891, 11729], _
			[$ISLEOFJADE, 10275, 3114], _
			[$ISLEOFMEDITATION, -2112, 8014], _
			[$ISLEOFWEEPING, -3892, 6709], _
			[$CORRUPTEDISLE, -4764, 5521], _
			[$ISLEOFSOLITUDE, 2970, 1532], _
			[$ISLEOFWURMS, 8133, 3583], _
			[$UNCHARTEDISLE, 1503, -2830]]
	For $i = 0 To (UBound($Waypoints_by_Merchant) - 1)
		If ($Waypoints_by_Merchant[$i][0] == True) Then
			Do
				GENERICRANDOMPATH($Waypoints_by_Merchant[$i][1], $Waypoints_by_Merchant[$i][2], Random(60, 80, 2))
			Until CHECKAREA($Waypoints_by_Merchant[$i][1], $Waypoints_by_Merchant[$i][2])
			#ce

			   For $i = 1 To 8 ; Open Merchant
					Local $lMerchant = GetAgentByName($nMerchant[$i-1])
					If IsDllStruct($lMerchant) Then
						Upd("找到商人 !")
						GoToNPC($lMerchant)
						ExitLoop
					ElseIf $i = 8 Then
						Upd("无法找到商人")
					EndIf
				Next
		;EndIf
	;Next
EndFunc   ;~ Merchant

Func SELL($BAGINDEX)
	Local $AITEM
	Local $BAG = GETBAG($BAGINDEX)
	Local $NUMOFSLOTS = DllStructGetData($BAG, "slots")
	For $I = 1 To DllStructGetData(GetBag($BAGINDEX), 'Slots')
		Upd("正在卖: " & $BAGINDEX & ", " & $I)
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

	; 卖金色物品
	If $LRARITY == $RARITY_GOLD Then
		Return True
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

	Return True
EndFunc   ;==>CANSELL


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
				For $BAG = 8 To 12
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
				For $BAG = 8 To 12
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
				For $BAG = 8 To 12
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
				For $BAG = 8 To 12
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
				For $BAG = 8 To 12
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
				For $BAG = 8 To 12
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
				For $BAG = 8 To 12
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
				For $BAG = 8 To 12
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
				For $BAG = 8 To 12
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
				For $BAG = 8 To 12
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
				For $BAG = 8 To 12
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
				For $BAG = 8 To 12
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
				For $BAG = 8 To 12
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
				For $BAG = 8 To 12
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
				For $BAG = 8 To 12
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
				For $BAG = 8 To 12
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

 Func Salvage()
   Local $Chest
   Local $Merchant

   For $i = 1 To 8 ; Open chest
	  $Chest = GetAgentByName($nXunlai[$i-1])
	  If IsDllStruct($Chest) Then
		 Upd("找到储存箱 !")
		 GoToNPC($Chest)
		 ExitLoop
	  ElseIf $i = 8 Then
		 Upd("无法找到储存箱")
	  EndIf
   Next

   For $i = 1 To 8 ; Open Merchant
	  $Merchant = GetAgentByName($nMerchant[$i-1])
	  If IsDllStruct($Merchant) Then
		 Upd("找到商人 !")
		 GoToNPC($Merchant)
		 ExitLoop
	  ElseIf $i = 8 Then
		 Upd("无法找到商人")
	  EndIf
   Next

   For $i = 1 To 4
	  If Not SalvageBag($i) Then ExitLoop
   Next

 EndFunc

 Func SalvageKit()
   If FindSalvageKit() = 0 Then
	  Upd("需要拆解器.")
	  If GetGoldCharacter() < 100 Then
		 Upd("需要金.")
		 WithdrawGold(100)
		 RndSleep(2000)
	  EndIf
	  BuyItem(2, 1, 100)
	  RndSleep(1000)
   EndIf
 EndFunc

Func SalvageBag($lBag)
	Upd("正在拆解第 " & $lBag & "包.")
	Local $aBag
	If Not IsDllStruct($lBag) Then $aBag = GetBag($lBag)
	Local $lItem
	Local $lSalvageType
	Local $lSalvageCount
	For $i = 1 To DllStructGetData($aBag, 'Slots')

		If $boolRunning = False Then
			ExitLoop
		EndIf

		$lItem = GetItemBySlot($aBag, $i)

		SalvageKit()

		$r = GetRarity($lItem)
		$m = DllStructGetData($lItem, 'ModelID')

		If (DllStructGetData($lItem, 'ID') == 0) Then ContinueLoop
		If _ArraySearch($ArraySalvageRarity, $r) = -1 And _ArraySearch($ArraySalvageModelID, $m) = -1 Then ContinueLoop

		$lSalvageCount = SalvageUses($lBag)
		$lSalvageType = GetCanSalvage($lItem, True)
		Switch $lSalvageType
			Case -1
				ContinueLoop
			Case 0, 1, 2
				StartSalvage($lItem)
				While (GetPing() > 1250)
					RndSleep(250)
					Upd("太卡了" & GetPing())
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
					Upd("太卡了" & GetPing())
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
					Upd("太卡了" & GetPing())
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
	Next
	Return True
EndFunc   ;==>SalvageBag

 #region Salvage
 Func GetCanSalvage($aItem, $aMerchant)
	If DllStructGetData($aItem, 'Customized') <> 0 Then Return -1

	Switch DllStructGetData($aItem, 'type')
		Case 0, 2, 5, 12, 15, 22, 24, 26, 27, 32, 35, 36
		Case 30
			If DllStructGetData($aItem, 'value') <= 0 Then Return -1
		Case Else
			Return -1
	EndSwitch

   $r = GetRarity($aItem)

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
;~ 				  Upd("Salvaging " & $Inv_mMods[$i][1] & " from item.")
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
	Upd("剩余次数:" & $lCount)
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

#cs
;~ Description: Returns item ID of salvage kit in inventory.
Func FindSalvageKit()
	Local $lItem
	Local $lKit = 0
	Local $lUses = 101
	For $i = 1 To 21
		For $j = 1 To DllStructGetData(GetBag($i), 'Slots')
			$lItem = GetItemBySlot($i, $j)
			Switch DllStructGetData($lItem, 'ModelID')
				Case 2991, expert
					If DllStructGetData($lItem, 'Value') / 8 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 8
					EndIf
				Case 2992, normal
					If DllStructGetData($lItem, 'Value') / 2 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 2
					EndIf
				Case 2993
					If DllStructGetData($lItem, 'Value') / 2 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 2
					EndIf
				Case 5900, superior
					If DllStructGetData($lItem, 'Value') / 10 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 10
					EndIf
				Case Else
					ContinueLoop
			EndSwitch
		Next
	Next
	Return $lKit
EndFunc   ;==>FindSalvageKit
#ce

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
			Sleep(GetPing()+500)
		EndIf
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		IDENTIFYITEM($AITEM)
		Sleep(GetPing()+500)
	Next
EndFunc


; This searches for empty slots in your storage
Func FindEmptySlot($BAGINDEX)
	Local $LITEMINFO, $ASLOT
	For $ASLOT = 1 To DllStructGetData(GETBAG($BAGINDEX), "Slots")
		Sleep(40)
		$LITEMINFO = GETITEMBYSLOT($BAGINDEX, $ASLOT)
		If DllStructGetData($LITEMINFO, "ID") = 0 Then
			SetExtended($ASLOT)
			ExitLoop
		EndIf
	Next
	Return 0
EndFunc

Func CHECKGOLD()
	Local $GCHARACTER = GetGoldCharacter()
	Local $GSTORAGE = GetGoldStorage()
	Local $GDIFFERENCE = ($GSTORAGE - $GCHARACTER)
	If $GCHARACTER <= 1000 Then
		Switch $GSTORAGE
			Case 100000 To 1000000
				WithdrawGold(100000 - $GCHARACTER)
				Sleep(500 + 3 * GetPing())
			Case 1 To 99999
				WithdrawGold($GDIFFERENCE)
				Sleep(500 + 3 * GetPing())
			Case 0
				OUT("没钱，开始刷怪")
				Return False
		EndSwitch
	EndIf
	Return True
EndFunc   ;==>CHECKGOLD

#cs
Func SetDisplayedTitle($aTitle = 0)
	If $aTitle Then
		Return SendPacket(0x8, $SetDisplayedTitleHeader, $aTitle)
	Else
		Return SendPacket(0x4, $RemoveDisplayedTitleHeader)
	EndIf
EndFunc   ;==>SetDisplayedTitle

Func RndTravel($aMapID)
	Local $UseDistricts = 11 ; 7=eu, 8=eu+int, 11=all(incl. asia)
	; Region/Language order: eu-en, eu-fr, eu-ge, eu-it, eu-sp, eu-po, eu-ru, int, asia-ko, asia-ch, asia-ja
	Local $Region[11] = [2, 2, 2, 2, 2, 2, 2, -2, 1, 3, 4]
	Local $Language[11] = [0, 2, 3, 4, 5, 9, 10, 0, 0, 0, 0]
	Local $Random = Random(0, $UseDistricts - 1, 1)
	MoveMap($aMapID, $Region[$Random], 0, $Language[$Random])
	WaitMapLoading($aMapID, 30000)
	Sleep(GetPing()+3000)
EndFunc   ;==>RndTravel
#ce
Func GenericRandomPath($aPosX, $aPosY, $aRandom = 50, $STOPSMIN = 1, $STOPSMAX = 5, $NUMBEROFSTOPS = -1)
	If $NUMBEROFSTOPS = -1 Then $NUMBEROFSTOPS = Random($STOPSMIN, $STOPSMAX, 1)
	Local $lAgent = GetAgentByID(-2)
	Local $MYPOSX = DllStructGetData($lAgent, "X")
	Local $MYPOSY = DllStructGetData($lAgent, "Y")
	Local $DISTANCE = ComputeDistance($MYPOSX, $MYPOSY, $aPosX, $aPosY)
	If $NUMBEROFSTOPS = 0 Or $DISTANCE < 200 Then
		MoveTo($aPosX, $aPosY, $aRandom)
	Else
		Local $M = Random(0, 1)
		Local $N = $NUMBEROFSTOPS - $M
		Local $STEPX = (($M * $aPosX) + ($N * $MYPOSX)) / ($M + $N)
		Local $STEPY = (($M * $aPosY) + ($N * $MYPOSY)) / ($M + $N)
		MoveTo($STEPX, $STEPY, $aRandom)
		GENERICRANDOMPATH($aPosX, $aPosY, $aRandom, $STOPSMIN, $STOPSMAX, $NUMBEROFSTOPS - 1)
	EndIf
EndFunc   ;==>GENERICRANDOMPATH
#cs
Func GetItemInscr($aItem)
	If Not IsDllStruct($aItem) Then $aItem = GetItemByItemID($aItem)
	Local $lModString = GetModStruct($aItem)
	Local $lMods = ""
	Local $lSearch = "3225"
	Local $lPos = StringInStr($lModString, $lSearch)
	If $lPos = 0 Then
		$lSearch = "32A5"
		$lPos = StringInStr($lModString, $lSearch)
	EndIf
	If $lPos = 0 Then Return 0
	$lMods = StringMid($lModString, $lPos - 4, 8) & "|" & StringMid($lModString, $lPos + 4, 8)
	Do
		$lPos = StringInStr($lModString, $lSearch, 0, 1, $lPos + 1)
		If $lPos = 0 Then ExitLoop
		$lMods = $lMods & "|" & StringMid($lModString, $lPos + 4, 8)
	Until false
	If $lMods = "" Then Return 0
	Local $lModArr = StringSplit($lMods, "|")
	$lModArr[0] -= 1
	Return $lModArr
EndFunc   ;==>GetItemInscr
#ce
Func GoNearestNPCToCoords($x, $y)
	Local $guy, $Me
	Do
		RndSleep(250)
		$guy = GetNearestNPCToCoords($x, $y)
	Until DllStructGetData($guy, 'Id') <> 0
	ChangeTarget($guy)
	RndSleep(250)
	GoNPC($guy)
	RndSleep(250)
	Do
		RndSleep(500)
		Move(DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y'), 40)
		RndSleep(500)
		GoNPC($guy)
		RndSleep(250)
		$Me = GetAgentByID(-2)
	Until ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y')) < 250
	RndSleep(1000)
EndFunc   ;==>GoNearestNPCToCoords
#cs
Func WaitForLoad()               ;used
	Out("正在载入")
	InitMapLoad()
	Local $deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100
		Local $load = GetMapLoading()
		Local $lMe = GetAgentByID(-2)

	Until $load == 2 And DllStructGetData($lMe, 'X') == 0 And DllStructGetData($lMe, 'Y') == 0 Or $deadlock > 10000

	$deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100
		$load = GetMapLoading()
		$lMe = GetAgentByID(-2)

	Until $load <> 2 And DllStructGetData($lMe, 'X') <> 0 And DllStructGetData($lMe, 'Y') <> 0 Or $deadlock > 30000
	Out("装载完毕")
EndFunc   ;==>WaitForLoad
#ce
; 没有再次刷新人员数据， 因为使用此功能时怪已不动
Func SelectEnemy()

	Local $lAgentArray = GetAgentArray(0xDB)
	Local $lMe = GetAgentByID(-2)

	Local $ClosestToMe = 5000
	Local $FarthestToMe = 0
	Local $MiddleToMe = 0
	Local $DistanceFromMid = 5000


	Local $tempDistance = 0
	Local $BestIndex = 0

	For $i=1 To $lAgentArray[0]
		$tempDistance = GetDistance($lMe, $lAgentArray[$i])
		If DllStructGetData($lAgentArray[$i], "Allegiance") <> 0x3 Then ContinueLoop
		If StringInStr(GetAgentName($lAgentArray[$i]),"雪人") = 0 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], "HP") <= 0 Then ContinueLoop
		If $tempDistance > 2000 Then ContinueLoop
		If $tempDistance < $ClosestToMe Then
			$ClosestToMe = $tempDistance
		EndIf
		If $TempDistance > $FarthestToMe Then
			$FarthestToMe = $TempDistance
		EndIf
	Next

	$MiddleToMe = ($ClosestToMe + $FarthestToMe) / 2
	; 没有再次刷新人员数据， 因为使用此功能时怪已不动
	out("")
	out("选怪:")
	out("近怪: " & Round($ClosestToMe))
	out("远怪: " & Round($FarthestToMe))
	out("中点: " & Round($MiddleToMe))

	For $i=1 To $lAgentArray[0]
		$tempDistance = GetDistance($lMe, $lAgentArray[$i])
		If DllStructGetData($lAgentArray[$i], "Allegiance") <> 0x3 Then ContinueLoop
		If StringInStr(GetAgentName($lAgentArray[$i]),"雪人") = 0 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], "HP") <= 0 Then ContinueLoop
		If $tempDistance > 2000 Then ContinueLoop
		If abs($tempDistance-$MiddleToMe)<$DistanceFromMid Then
			$DistanceFromMid = abs($tempDistance-$MiddleToMe)
			$BestIndex = $i
		EndIf
	Next

	out("目标与中点距: " & Round($DistanceFromMid))
	out("")

	Return DllStructGetData($lAgentArray[$BestIndex], "ID")

EndFunc
#cs
; Uses a skill
; It will not use if I am dead, if the skill is not recharged, or if I don't have enough energy for it
; It will sleep until the skill is cast, then it will wait for aftercast.
Func UseSkillEx($lSkill, $lTgt=-2, $aTimeout = 3000)
	If GetIsDead(-2) Then Return
	If Not IsRecharged($lSkill) Then Return
	If GetEnergy(-2) < $skillCost[$lSkill] Then Return

	Local $lDeadlock = TimerInit()
	UseSkill($lSkill, $lTgt)
	Do
		Sleep(100)
		If GetIsDead(-2) = 1 Then Return
	Until (Not IsRecharged($lSkill)) Or (TimerDiff($lDeadlock) > $aTimeout)

	If $lSkill > 1 Then RndSleep(750)
EndFunc
#ce
; Checks if skill given (by number in bar) is recharged. Returns True if recharged, otherwise False.
Func IsRecharged($lSkill)
	Return GetSkillBarSkillRecharge($lSkill)==0
EndFunc

Func GetItemMaxDmg($aItem)
	If Not IsDllStruct($aItem) Then $aItem = GetItemByItemID($aItem)
	Local $lModString = GetModStruct($aItem)
	Local $lPos = 0

	$lPos = StringInStr($lModString, "A8A7") ; Weapon Damage
	;If $lPos = 0 Then $lPos = StringInStr($lModString, "C867") ; Energy (focus)
	;If $lPos = 0 Then $lPos = StringInStr($lModString, "B8A7") ; Armor (shield)
	If $lPos = 0 Then Return 0

	Return Int("0x" & StringMid($lModString, $lPos - 2, 2))

EndFunc

#EndRegion Counting Things

Global $DifficultyNormal = True
Func ToggleDifficulty()
	$DifficultyNormal = NOT $DifficultyNormal
EndFunc

;~ Description: Toggle rendering and also hide or show the gw window
Func ToggleRendering()
	$RenderingEnabled = Not $RenderingEnabled
	If $RenderingEnabled Then
		EnableRendering()
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
	Else
		DisableRendering()
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
		ClearMemory()
	EndIf
EndFunc   ;==>ToggleRendering


#endregion Storage
