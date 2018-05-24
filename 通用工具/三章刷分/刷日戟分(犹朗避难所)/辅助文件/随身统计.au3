
#Region Display/Counting Things
#CS
Each section can be commented out entirely or each individual line. Basically put here for reference and use.

I put the Display > 0 so that it won't list everything. Better for each event I think.

CountSlots and CountSlotsChest are used by the Storage and the bot to know how much it can put in there
and when to start an inventory cycle.

GetxxxxxxCount() are to count what is in your Inventory at that time. Say if you want to track each of these items
either by the Message display or a section of your GUI.

Does Not track how many you put in the storage chest!!!
#CE
Func DisplayCounts()
;	Standard Vaettir Drops excluding Map Pieces
	Local $CurrentGold = GetGoldCharacter()
	Local $GlacialStones = GetGlacialStoneCount()
	Local $MesmerTomes = GetMesmerTomeCount()
	Local $Lockpicks = GetLockpickCount()
	Local $BlackDye = GetBlackDyeCount()
	Local $WhiteDye = GetWhiteDyeCount()
;	Event Items
	Local $AgedDwarvenAle = GetAgedDwarvenAleCount()
	Local $AgedHuntersAle = GetAgedHuntersAleCount()
	Local $BattleIslandIcedTea = GetIcedTeaCount()
	Local $BirthdayCupcake = GetBirthdayCupcakeCount()
	Local $BlueDrink = GetBlueDrinkCount()
	Local $CandyCaneShards = GetCandyCaneShards()
	Local $ChampagnePopper = GetPopperCount()
	Local $ChocolateBunny = GetBunnyCount()
	Local $DwarvenAle = GetDwarvenAleCount()
	Local $GoldenEgg = GetGoldenEggCount()
	Local $HardCider = GetHardCiderCount()
	Local $HuntersAle = GetHuntersAleCount()
	Local $Clovers = GetFourLeafCloverCount()
	Local $Eggnog = GetEggnogCount()
	Local $FrostyTonic = GetFrostyTonicCount()
	Local $Fruitcake = GetFruitcakeCount()
	Local $Grog = GetBottleOfGrogCount()
	Local $HoneyCombs = GetHoneyCombCount()
	Local $KrytanBrandy = GetKrytanBrandyCount()
	Local $MischieviousTonic = GetMischieviousTonicCount()
	Local $PartyBeacon = GetPartyBeaconCount()
	Local $PumpkinPies = GetPumpkinPieCount()
	Local $Rocket = GetRocketCount()
	Local $ShamrockAle = GetShamrockAleCount()
	Local $SnowmanSummoner = GetSnowmanSummonerCount()
	Local $Sparklers = GetSparklersCount()
	Local $SpikedEggnog = GetSpikedEggnogCount()
	Local $TransmogrifierTonic = GetTransTonicCount()
	Local $TokenCount = GetLunarTokenCount()
	Local $TrickOrTreats = GetTrickOrTreatCount()
	Local $VictoryToken = GetVictoryTokenCount()
	Local $WayfarerMark = GetWayfarerMarkCount()
	Local $YuletideTonic = GetYuletideTonicCount()
;	RareMaterials
	Local $EctoCount = GetEctoCount()
	Local $ObShardCount = GetObsidianShardCount()
	Local $FurCount = GetFurCount()
	Local $LinenCount = GetLinenCount()
	Local $DamaskCount = GetDamaskCount()
	Local $SilkCount = GetSilkCount()
	Local $SteelCount = GetSteelCount()
	Local $DSteelCount = GetDeldSteelCount()
	Local $MonClawCount = GetMonClawCount()
	Local $MonEyeCount = GetMonEyeCount()
	Local $MonFangCount = GetMonFangCount()
	Local $RubyCount = GetRubyCount()
	Local $SapphireCount = GetSapphireCount()
	Local $DiamondCount = GetDiamondCount()
	Local $OnyxCount = GetOnyxCount()
	Local $CharcoalCount = GetCharcoalCount()
	Local $GlassVialCount = GetGlassVialCount()
	Local $LeatherCount = GetLeatherCount()
	Local $ElonLeatherCount = GetElonLeatherCount()
	Local $VialInkCount = GetVialInkCount()
	Local $ParchmentCount = GetParchmentCount()
	Local $VellumCount = GetVellumCount()
	Local $SpiritwoodCount = GetSpiritwoodCount()
	Local $AmberCount = GetAmberCount()
	Local $JadeCount = GetJadeCount()
;	Standard Vaettir Drops excluding Map Pieces
	If GetGoldCharacter() > 0 Then
		Out("随身现金值:" & $CurrentGold)
	EndIf
	If GetGlacialStoneCount() > 0 Then
		Out("冰河石:" & $GlacialStones)
	EndIf
	If GetMesmerTomeCount() > 0 Then
		Out("幻术书:" & $MesmerTomes)
	EndIf
	If GetLockpickCount() > 0 Then
		Out ("钥匙:" & $Lockpicks)
	EndIf
	If GetBlackDyeCount() > 0 Then
		Out ("黑染:" & $BlackDye)
	EndIf
	If GetWhiteDyeCount() > 0 Then
		Out ("白染:" & $WhiteDye)
	EndIf
;	Rare Materials
	If GetFurCount() > 0 Then
		Out ("Fur Squares:" & $FurCount)
	EndIf
	If GetLinenCount() > 0 Then
		Out ("Linen:" & $LinenCount)
	EndIf
	If GetDamaskCount() > 0 Then
		Out ("Damask:" & $DamaskCount)
	EndIf
	If GetSilkCount() > 0 Then
		Out ("Silk:" & $SilkCount)
	EndIf
	If GetEctoCount() > 0 Then
		Out("玉:" & $EctoCount)
	EndIf
	If GetSteelCount() > 0 Then
		Out ("刚:" & $SteelCount)
	EndIf
	If GetDeldSteelCount() > 0 Then
		Out ("Deldrimor Steel:" & $DSteelCount)
	EndIf
	If GetMonClawCount() > 0 Then
		Out ("Monstrous Claw:" & $MonClawCount)
	EndIf
	If GetMonEyeCount() > 0 Then
		Out ("Monstrous Eye:" & $MonEyeCount)
	EndIf
	If GetMonFangCount() > 0 Then
		Out ("Monstrous Fang:" & $MonFangCount)
	EndIf
	If GetRubyCount() > 0 Then
		Out ("红宝石:" & $RubyCount)
	EndIf
	If GetSapphireCount() > 0 Then
		Out ("蓝宝石:" & $SapphireCount)
	EndIf
	If GetDiamondCount() > 0 Then
		Out ("Diamond:" & $DiamondCount)
	EndIf
	If GetOnyxCount() > 0 Then
		Out ("Onyx:" & $OnyxCount)
	EndIf
	If GetCharcoalCount() > 0 Then
		Out ("Charcoal:" & $CharcoalCount)
	EndIf
	If GetObsidianShardCount() > 0 Then
		Out("Obby Count:" & $ObShardCount)
	EndIf
	If GetGlassVialCount() > 0 Then
		Out ("Glass Vial:" & $GlassVialCount)
	EndIf
	If GetLeatherCount() > 0 Then
		Out ("Leather Square:" & $LeatherCount)
	EndIf
	If GetElonLeatherCount() > 0 Then
		Out ("Elonian Leather:" & $ElonLeatherCount)
	EndIf
	If GetVialInkCount() > 0 Then
		Out ("Vials of Ink:" & $VialInkCount)
	EndIf
	If GetParchmentCount() > 0 Then
		Out ("Parchment:" & $ParchmentCount)
	EndIf
	If GetVellumCount() > 0 Then
		Out ("Vellum:" & $VellumCount)
	EndIf
	If GetSpiritwoodCount() > 0 Then
		Out ("Spiritwood Planks:" & $SpiritwoodCount)
	EndIf
	If GetAmberCount() > 0 Then
		Out ("Amber:" & $AmberCount)
	EndIf
	If GetSpiritwoodCount() > 0 Then
		Out ("Jade:" & $JadeCount)
	EndIf
;	Event Items
	If GetAgedDwarvenAleCount() > 0 Then
		Out("Aged Dwarven Ale:" & $AgedDwarvenAle)
	EndIf
	If GetAgedHuntersAleCount() > 0 Then
		Out("Aged Hunter's Ale:" & $AgedHuntersAle)
	EndIf
	If GetIcedTeaCount() > 0 Then
		Out("Iced Tea:" & $BattleIslandIcedTea)
	EndIf
	If GetBirthdayCupcakeCount() > 0 Then
		Out("蛋糕:" & $BirthdayCupcake)
	EndIf
	If GetBlueDrinkCount() > 0 Then
		Out("蓝汽水:" & $BlueDrink)
	EndIf
	If GetCandyCaneShards() > 0 Then
		Out("CC Shards:" & $CandyCaneShards)
	EndIf
	If GetPopperCount() > 0 Then
		Out("Champagne Poppers:" & $ChampagnePopper)
	EndIf
	If GetBunnyCount() > 0 Then
		Out("Chocolate Bunnies:" & $ChocolateBunny)
	EndIf
	If GetDwarvenAleCount() > 0 Then
		Out("Dwarven Ale:" & $DwarvenAle)
	EndIf
	If GetGoldenEggCount() > 0 Then
		Out("金蛋:" & $GoldenEgg)
	EndIf
	If GetHardCiderCount() > 0 Then
		Out("Hard Cider:" & $HardCider)
	EndIf
	If GetHuntersAleCount() > 0 Then
		Out("Hunter's Ale:" & $HuntersAle)
	EndIf
	If GetFourLeafCloverCount() > 0 Then
		Out("三叶草:" & $Clovers)
	EndIf
	If GetEggnogCount() > 0 Then
		Out("Egg Nog:" & $Eggnog)
	EndIf
	If GetFrostyTonicCount() > 0 Then
		Out("Frosty Tonics:" & $FrostyTonic)
	EndIf
	If GetFruitcakeCount() > 0 Then
		Out("Fruitcakes:" & $Fruitcake)
	EndIf
	If GetBottleOfGrogCount() > 0 Then
		Out("Grog Arrr:" & $Grog)
	EndIf
	If GetHoneyCombCount() > 0 Then
		Out("Honeycombs:" & $HoneyCombs)
	EndIf
	If GetKrytanBrandyCount() > 0 Then
		Out("Krytan Brandy:" & $KrytanBrandy)
	EndIf
	If GetMischieviousTonicCount() > 0 Then
		Out("Mischievious Tonics:" & $MischieviousTonic)
	EndIf
	If GetPartyBeaconCount() > 0 Then
		Out("Jesus Beams:" & $PartyBeacon)
	EndIf
	If GetPumpkinPieCount() > 0 Then
		Out("南瓜派:" & $PumpkinPies)
	EndIf
	If GetRocketCount() > 0 Then
		Out("Bottle Rockets:" & $Rocket)
	EndIf
	If GetShamrockAleCount() > 0 Then
		Out("酢浆酒:" & $ShamrockAle)
	EndIf
	If GetSnowmanSummonerCount() > 0 Then
		Out("Snowman Summoners:" & $SnowmanSummoner)
	EndIf
	If GetSparklersCount() > 0 Then
		Out("Sparklers:" & $Sparklers)
	EndIf
	If GetSpikedEggnogCount() > 0 Then
		Out("Spiked Eggnog:" & $SpikedEggnog)
	EndIf
	If GetTransTonicCount() > 0 Then
		Out("Transmogrifier Tonics:" & $TransmogrifierTonic)
	EndIf
	If GetLunarTokenCount() > 0 Then
		Out("Token Count:" & $Tokencount)
	EndIf
	If GetTrickOrTreatCount() > 0 Then
		Out("ToTs:" & $TrickOrTreats)
	EndIf
	If GetVictoryTokenCount() > 0 Then
		Out("Victory Tokens:" & $VictoryToken)
	EndIf
	If GetWayfarerMarkCount() > 0 Then
		Out("Wayfarer Marks:" & $WayfarerMark)
	EndIf
	If GetYuletideTonicCount() > 0 Then
		Out("Yuletide Tonics:" & $YuletideTonic)
	EndIf
EndFunc
;	Standard Vaettir Drops excluding Map Pieces
Func GetGlacialStoneCount()
	Local $AAMOUNTGlacialStone
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_GLACIAL_STONES Then
				$AAMOUNTGlacialStone += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTGlacialStone
EndFunc   ; Counts Glacial Stones in your Inventory

Func GetMesmerTomeCount()
	Local $AAMOUNTMesmerTomes
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_Mesmer_Tome Then
				$AAMOUNTMesmerTomes += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTMesmerTomes
EndFunc   ; Counts Mesmer Tomes in your Inventory

Func GetLockpickCount()
	Local $AAMOUNTLockPick
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_LOCKPICKS Then
				$AAMOUNTLockPick += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTLockPick
EndFunc   ; Counts Lockpicks in your Inventory

Func GetBlackDyeCount()
	Local $AAMOUNTBlackDyes
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_DYES Then
				If DllStructGetData($aitem, "ExtraID") == $ITEM_EXTRAID_BLACKDYE Then
					$AAMOUNTBlackDyes += DllStructGetData($aItem, "Quantity")
				EndIf
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTBlackDyes
EndFunc   ; Counts Black Dyes in your Inventory

Func GetWhiteDyeCount()
	Local $AAMOUNTWhiteDyes
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_DYES Then
				If DllStructGetData($aitem, "ExtraID") == $ITEM_EXTRAID_WHITEDYE Then
					$AAMOUNTWhiteDyes += DllStructGetData($aItem, "Quantity")
				EndIf
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTWhiteDyes
EndFunc   ; Counts White Dyes in your Inventory
;	Rare Materials
Func GetFurCount()
	Local $AAMOUNTFurSquares
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 941 Then
				$AAMOUNTFurSquares += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTFurSquares
EndFunc   ; Counts Fur Squares in your Inventory

Func GetLinenCount()
	Local $AAMOUNTLinen
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 926 Then
				$AAMOUNTLinen += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTLinen
EndFunc   ; Counts Linen in your Inventory

Func GetDamaskCount()
	Local $AAMOUNTDamask
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 927 Then
				$AAMOUNTDamask += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTDamask
EndFunc   ; Counts Damask in your Inventory

Func GetSilkCount()
	Local $AAMOUNTSilk
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 928 Then
				$AAMOUNTSilk += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTSilk
EndFunc   ; Counts Silk in your Inventory

Func GetEctoCount()
	Local $AAMOUNTEctos
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 930 Then
				$AAMOUNTEctos += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTEctos
EndFunc   ; Counts Ectos in your Inventory

Func GetSteelCount()
	Local $AAMOUNTSteel
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 949 Then
				$AAMOUNTSteel += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTSteel
EndFunc   ; Counts Steel in your Inventory

Func GetDeldSteelCount()
	Local $AAMOUNTDelSteel
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 950 Then
				$AAMOUNTDelSteel += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTDelSteel
EndFunc   ; Counts Deldrimor Steel in your Inventory

Func GetMonClawCount()
	Local $AAMOUNTMonClaw
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 923 Then
				$AAMOUNTMonClaw += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTMonClaw
EndFunc   ; Counts Monstrous Claws in your Inventory

Func GetMonEyeCount()
	Local $AAMOUNTMonEyes
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 931 Then
				$AAMOUNTMonEyes += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTMonEyes
EndFunc   ; Counts Montrous Eyes in your Inventory

Func GetMonFangCount()
	Local $AAMOUNTMonFangs
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 932 Then
				$AAMOUNTMonFangs += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTMonFangs
EndFunc   ; Counts Montrous Fangs in your Inventory

Func GetRubyCount()
	Local $AAMOUNTRubies
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 937 Then
				$AAMOUNTRubies += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTRubies
EndFunc   ; Counts Rubies in your Inventory

Func GetSapphireCount()
	Local $AAMOUNTSapphires
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 938 Then
				$AAMOUNTSapphires += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTSapphires
EndFunc   ; Counts Sapphires in your Inventory

Func GetDiamondCount()
	Local $AAMOUNTDiamonds
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 935 Then
				$AAMOUNTDiamonds += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTDiamonds
EndFunc   ; Counts Diamonds in your Inventory

Func GetOnyxCount()
	Local $AAMOUNTOnyx
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 936 Then
				$AAMOUNTOnyx += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTOnyx
EndFunc   ; Counts Onyx in your Inventory

Func GetCharcoalCount()
	Local $AAMOUNTCharcoal
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 922 Then
				$AAMOUNTCharcoal += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTCharcoal
EndFunc   ; Counts Charcoal in your Inventory

Func GetObsidianShardCount()
	Local $AAMOUNTObbyShards
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 945 Then
				$AAMOUNTObbyShards += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTObbyShards
EndFunc   ; Counts Obsidian Shards in your Inventory

Func GetGlassVialCount()
	Local $AAMOUNTGlassVials
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 939 Then
				$AAMOUNTGlassVials += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTGlassVials
EndFunc   ; Counts Glass Vials in your Inventory

Func GetLeatherCount()
	Local $AAMOUNTLeather
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 942 Then
				$AAMOUNTLeather += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTLeather
EndFunc   ; Counts Leather Squares in your Inventory

Func GetElonLeatherCount()
	Local $AAMOUNTElonLeather
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 943 Then
				$AAMOUNTElonLeather += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTElonLeather
EndFunc   ; Counts Elonian LEather in your Inventory

Func GetVialInkCount()
	Local $AAMOUNTVialsInk
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 944 Then
				$AAMOUNTVialsInk += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTVialsInk
EndFunc   ; Counts Vials of Ink in your Inventory

Func GetParchmentCount()
	Local $AAMOUNTParchment
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 951 Then
				$AAMOUNTParchment += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTParchment
EndFunc   ; Counts Parchment in your Inventory

Func GetVellumCount()
	Local $AAMOUNTVellum
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 952 Then
				$AAMOUNTVellum += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTVellum
EndFunc   ; Counts Vellum in your Inventory

Func GetSpiritwoodCount()
	Local $AAMOUNTSpiritWood
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 956 Then
				$AAMOUNTSpiritWood += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTSpiritWood
EndFunc   ; Counts Spiritwood Planks in your Inventory

Func GetAmberCount()
	Local $AAMOUNTAmber
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 6532 Then
				$AAMOUNTAmber += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTAmber
EndFunc   ; Counts Chunks of Amber in your Inventory

Func GetJadeCount()
	Local $AAMOUNTJade
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 6533 Then
				$AAMOUNTJade += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTJade
EndFunc   ; Counts Jadeite Shards in your Inventory
;	Event Items
Func GetAgedDwarvenAleCount()
	Local $AAMOUNTAgedDwarven
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_AGED_DWARVEN_ALE Then
				$AAMOUNTAgedDwarven += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTAgedDwarven
EndFunc   ; Counts Aged Dwarven Ales in your Inventory

Func GetAgedHuntersAleCount()
	Local $AAMOUNTAgedHunters
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_AGED_HUNTERS_ALE Then
				$AAMOUNTAgedHunters += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTAgedHunters
EndFunc   ; Counts Aged Dwarven Ales in your Inventory

Func GetIcedTeaCount()
	Local $AAMOUNTIcedTea
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_BATTLE_ISLE_ICED_TEA Then
				$AAMOUNTIcedTea += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTIcedTea
EndFunc   ; Counts Battle Isle Iced teas in your Inventory

Func GetBirthdayCupcakeCount()
	Local $AAMOUNTCupcakes
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_Cupcakes Then
				$AAMOUNTCupcakes += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTCupcakes
EndFunc   ; Counts Birthday Cupcakes in your Inventory

Func GetBlueDrinkCount()
	Local $AAMOUNTBlueDrink
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_BLUE_DRINK Then
				$AAMOUNTBlueDrink += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTBlueDrink
EndFunc   ; Counts Sugary Blue Drinks in your Inventory

Func GetCandyCaneShards()
	Local $AAMOUNTCCShards
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_CC_SHARDS Then
				$AAMOUNTCCShards += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTCCShards
EndFunc   ; Counts Candy Cane Shards in your Inventory

Func GetPopperCount()
	Local $AAMOUNTPoppers
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_POPPERS Then
				$AAMOUNTPoppers += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTPoppers
EndFunc   ; Counts Champagne Poppers in your Inventory

Func GetBunnyCount()
	Local $AAMOUNTBunnies
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_BUNNIES Then
				$AAMOUNTBunnies += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTBunnies
EndFunc   ; Counts Chocolate Bunnies in your Inventory

Func GetDwarvenAleCount()
	Local $AAMOUNTDwarvenAles
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_DWARVEN_ALE Then
				$AAMOUNTDwarvenAles += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTDwarvenAles
EndFunc   ; Counts Dwarven Ales in your Inventory

Func GetGoldenEggCount()
	Local $AAMOUNTEggs
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_GOLDEN_EGGS Then
				$AAMOUNTEggs += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTEggs
EndFunc   ; Counts Golden Eggs in your Inventory

Func GetHardCiderCount()
	Local $AAMOUNTCider
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_CIDER Then
				$AAMOUNTCider += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTCider
EndFunc   ; Counts Hard Ciders in your Inventory

Func GetHuntersAleCount()
	Local $AAMOUNTHuntersAles
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_HUNTERS_ALE Then
				$AAMOUNTHuntersAles += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTHuntersAles
EndFunc   ; Counts Hunter's Ales in your Inventory

Func GetFourLeafCloverCount()
	Local $AAMOUNTClovers
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_CLOVER Then
				$AAMOUNTClovers += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTClovers
EndFunc   ; Counts 4-Leaf Clovers in your Inventory

Func GetEggnogCount()
	Local $AAMOUNTEggnogs
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_EGGNOG Then
				$AAMOUNTEggnogs += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTEggnogs
EndFunc   ; Counts Eggnogs in your Inventory

Func GetFrostyTonicCount()
	Local $AAMOUNTFrosty
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_FROSTY Then
				$AAMOUNTFrosty += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTFrosty
EndFunc   ; Counts Frosty Tonics in your Inventory

Func GetFruitcakeCount()
	Local $AAMOUNTFruitcakes
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_FRUITCAKE Then
				$AAMOUNTFruitcakes += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTFruitcakes
EndFunc   ; Counts Fruitcakes in your Inventory

Func GetBottleOfGrogCount()
	Local $AAMOUNTGrogs
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_GROG Then
				$AAMOUNTGrogs += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTGrogs
EndFunc   ; Counts Bottles of Grog in your Inventory

Func GetHoneyCombCount()
	Local $AAMOUNTHoneycombs
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_HONEYCOMB Then
				$AAMOUNTHoneycombs += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTHoneycombs
EndFunc   ; Counts Honeycombs in your Inventory

Func GetKrytanBrandyCount()
	Local $AAMOUNTBrandy
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_KRYTAN_BRANDY Then
				$AAMOUNTBrandy += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTBrandy
EndFunc   ; Counts Krytan Brandies in your Inventory

Func GetMischieviousTonicCount()
	Local $AAMOUNTMiscTonics
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_MISCHIEVIOUS Then
				$AAMOUNTMiscTonics += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTMiscTonics
EndFunc   ; Counts Mischievious Tonics in your Inventory

Func GetPartyBeaconCount()
	Local $AAMOUNTJesusBeams
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_PARTY_BEACON Then
				$AAMOUNTJesusBeams += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTJesusBeams
EndFunc   ; Counts Party Beacons in your Inventory

Func GetPumpkinPieCount()
	Local $AAMOUNTPies
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_PIE Then
				$AAMOUNTPies += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTPies
EndFunc   ; Counts Slice of Pumpkin Pie in your Inventory

Func GetRocketCount()
	Local $AAMOUNTRockets
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_ROCKETS Then
				$AAMOUNTRockets += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTRockets
EndFunc   ; Counts Bottle Rockets in your Inventory

Func GetShamrockAleCount()
	Local $AAMOUNTShamAles
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_SHAMROCK_ALE Then
				$AAMOUNTShamAles += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTShamAles
EndFunc   ; Counts Shamrock Ales in your Inventory

Func GetSnowmanSummonerCount()
	Local $AAMOUNTSnowman
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_SNOWMAN_SUMMONER Then
				$AAMOUNTSnowman += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTSnowman
EndFunc   ; Counts Snowman Summoners in your Inventory

Func GetSparklersCount()
	Local $AAMOUNTSparklers
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_SPARKLER Then
				$AAMOUNTSparklers += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTSparklers
EndFunc   ; Counts Sparklers in your Inventory

Func GetSpikedEggnogCount()
	Local $AAMOUNTSpikedNog
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_SPIKED_EGGNOG Then
				$AAMOUNTSpikedNog += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTSpikedNog
EndFunc   ; Counts Spiked Eggnogs in your Inventory

Func GetTransTonicCount()
	Local $AAMOUNTTransTonics
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_TRANSMOGRIFIER Then
				$AAMOUNTTransTonics += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTTransTonics
EndFunc   ; Counts Transmogrifier Tonics in your Inventory

Func GetLunarTokenCount();
	Local $AAMOUNTLunarTokens
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_LUNAR_TOKEN Then
				$AAMOUNTLunarTokens += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTLunarTokens
EndFunc   ; Counts Lunar Tokens in your Inventory

Func GetTrickOrTreatCount()
	Local $AAMOUNTToTs
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_TOTS Then
				$AAMOUNTToTs += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTToTs
EndFunc   ; Counts Trick-Or-Treat bags in your Inventory

Func GetVictoryTokenCount()
	Local $AAMOUNTVicTokens
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_VICTORY_TOKEN Then
				$AAMOUNTVicTokens += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTVicTokens
EndFunc   ; Counts Victory Tokens in your Inventory

Func GetWayfarerMarkCount();
	Local $AAMOUNTWayfarerMark
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_WAYFARER_MARK Then
				$AAMOUNTWayfarerMark += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTWayfarerMark
EndFunc   ; Counts Wayfarer Marks in your Inventory

Func GetYuletideTonicCount()
	Local $AAMOUNTYuletides
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_YULETIDE Then
				$AAMOUNTYuletides += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTYuletides
EndFunc   ; Counts Yuletide Tonics in your Inventory
