#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Danylia

 Script Function:
	Storage Manager v3.0.2

#ce ----------------------------------------------------------------------------

#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <GuiComboBox.au3>
#include <Array.au3>
#include <GWA2.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

#region Variables

Global Const $SC_DRAGMOVE = 0xF012

Global $version = "3.0.2"

Global $mIron = 948
Global $mDust = 929
Global $mGranite = 955
Global $mFiber = 934
Global $mBone = 921
Global $mFeather = 933
Global $mChitin = 954
Global $mCloth = 925
Global $mScale = 953
Global $mTannedHides = 940
Global $mWood = 946

Global $mFeatherCrest = 835
Global $mGlacialStone = 27047
Global $mSaurianBone = 27035
Global $mDarkRemain = 522
Global $mDragonRoot = 819

Global $rWhite = 2621
Global $rBlue = 2623
Global $rPurple = 2626
Global $rGold = 2624
Global $rGreen = 2627

Global $mJoker = 0

Global Enum $mFur = 941, $mLinen = 926,  $mDamask = 927,  $mSilk = 928,  $mEctoplasm = 930, $mSteel = 949,  $mDeldrimorSteel = 950,  $mClaw = 923, $mEye = 931, $mFang = 932
Global Enum	$mRuby = 937, $mSapphire = 938,  $mDiamond = 935, $mOnyx = 936, $mCharcoal = 922, $mObsidian = 945, $mGlass = 939, $mLeather = 942, $mEloLeather = 943, $mInk = 944
Global Enum	$mParchment = 951, $mVellum = 952, $mSpiritwood = 956, $mAmber = 6532, $mJadeite = 6533

Global Enum $mApple = 28431, $mCorn = 28432, $mGoldenEgg = 22752, $mPumpkinPie = 28436, $mWarSupply = 35121, $mCupcake = 22269, $mGhostitB = 6368
Global Enum	$mSkalefinSoup = 17061, $mDrakeKabob = 17060, $mPahnaiSalad = 17062, $mArmorOfSalv = 24860, $mEssenceOfCel = 24859, $mGrailOfMight = 2486

Global $mAlcoholArray[19] = [910, 5585, 6049, 6367, 6375, 15477, 19171, 19172, 19173, 22190, 28435, 2513, 6366, 24593, 30855, 31145, 31146, 35124, 36682]
Global $mPartyArray[26] = [6376, 21809, 21810, 21813, 36683, 15837, 21490, 22192, 30624, 30626, 30630, 30632, 30634, 30636, 30638, 30640, 30642, 30646, 30648, 31020, 31141, 31142, 31144, 31172, 37771, 37772]
Global $mSweetArray[12] = [21492, 21812, 22269, 22644, 22752, 28436, 6370, 21488, 21489, 22191, 26784, 28433]

Global $nMerchant[7] = ["Merchant", "Marchand", "Kaufmann", "Mercante", "Mercader", "Kupiec", "Merchunt"]
Global $nXunlai[7] = ["Xunlai Chest", "Coffre Xunlai", "Xunlai-Truhe", "Forziere Xunlai", "Arcón Xunlai", "Skrzynia Xunlai", "Xoonlaeee Chest"]

Global $ArrayModelIDInv[60]
Global $ArraySalvageRarity[5]
Global $ArraySalvageModelID[6]

Global $boolInitialized = False
Global $boolRunning = False
Global $CurrentTab = 0

#endregion Variables

#region Gui

#region MainGui

Opt("GUIOnEventMode", True)

Global Const $MainGui = GUICreate("ITool v" & $version, 220, 300)

   GUICtrlCreateLabel("Character", 8, 6, 202, 17, $SS_CENTER)
   Global Const $inputCharName = GUICtrlCreateCombo("", 5, 24, 208, 22)
	  GUICtrlSetData(-1, GetLoggedCharNames())

   Global Const $lblLog = GUICtrlCreateLabel("", 8, 240, 202, 30)
   Global Const $btnStart = GUICtrlCreateButton("Start", 8, 270, 202, 25)

   Global Const $tab = GUICtrlCreateTab(5, 50, 210, 190, $TCS_BUTTONS) ;$TCS_BUTTONS

   GUICtrlCreateTabItem("Storage")

   GUICtrlCreateLabel("Action : ", 20, 85)
   Global $aCombo = GUICtrlCreateCombo("", 70, 80, 130, 20)
   GUICtrlSetData($aCombo, "Inventory -> Chest|Chest -> Inventory", "Inventory -> Chest")

   Global Const $Iron = GUICtrlCreateCheckbox("Iron", 20, 105)
   GUICtrlSetOnEvent(-1, "GUIBoxChecked")
   Global Const $Dust = GUICtrlCreateCheckbox("Dust", 20,125)
   GUICtrlSetOnEvent(-1, "GUIBoxChecked")
   Global Const $Bone = GUICtrlCreateCheckbox("Bone", 20,145)
   GUICtrlSetOnEvent(-1, "GUIBoxChecked")
   Global Const $Granite = GUICtrlCreateCheckbox("Granite", 80, 105)
   GUICtrlSetOnEvent(-1, "GUIBoxChecked")
   Global Const $Fiber = GUICtrlCreateCheckbox("Fiber", 80, 125)
   GUICtrlSetOnEvent(-1, "GUIBoxChecked")
   Global Const $Feather = GUICtrlCreateCheckbox("Feather", 80, 145)
   GUICtrlSetOnEvent(-1, "GUIBoxChecked")

   Global Const $bMore = GUICtrlCreateCheckbox("More", 20, 205)

   Global Const $FeatherCrest = GUICtrlCreateCheckbox("F-Crest", 145, 105)
   Global Const $GlacialStone = GUICtrlCreateCheckbox("G-Stone", 145, 125)
   Global Const $SaurianBone = GUICtrlCreateCheckbox("S-Bone", 145, 145)
   Global Const $DarkRemain = GUICtrlCreateCheckbox("DRemain", 145, 165)
   Global Const $DragonRoot = GUICtrlCreateCheckbox("D-Root", 145, 185)
   Global Const $iGold = GUICtrlCreateCheckbox("Gold", 145, 205)
   Global Const $Joker = GUICtrlCreateCheckbox("Joker", 80, 205)

   GUICtrlCreateTabItem("Identify")

   GUICtrlCreateLabel("Rarity", 30, 85)
   Global Const $White = GUICtrlCreateCheckbox("White", 20, 105)
   Global Const $Blue = GUICtrlCreateCheckbox("Blue", 20, 125)
   Global Const $Purple = GUICtrlCreateCheckbox("Purple", 20, 145)
   Global Const $Gold = GUICtrlCreateCheckbox("Gold", 20, 165)
   Global Const $Green = GUICtrlCreateCheckbox("Green", 20, 185)

   GUICtrlCreateLabel("Bags", 130, 85)
   Global Const $Backpack = GUICtrlCreateCheckbox("Backpack", 110, 105)
   GUICtrlSetState(-1, $GUI_CHECKED)
   Global Const $BeltPouch = GUICtrlCreateCheckbox("BeltPouch", 110, 125)
   GUICtrlSetState(-1, $GUI_CHECKED)
   Global Const $Bag1 = GUICtrlCreateCheckbox("Bag 1", 110, 145)
   GUICtrlSetState(-1, $GUI_CHECKED)
   Global Const $Bag2 = GUICtrlCreateCheckbox("Bag 2", 110, 165)
   GUICtrlSetState(-1, $GUI_CHECKED)

   GUICtrlCreateTabItem("Salvage")

   GUICtrlCreateLabel("Bot drops", 30, 85)
   Global Const $sFeatherCrest = GUICtrlCreateCheckbox("Feathered Crests", 20, 105)
   Global Const $sGlacialStone = GUICtrlCreateCheckbox("Glacial Stones", 20, 125)
   Global Const $sSaurianBone = GUICtrlCreateCheckbox("Surian Bones", 20, 145)
   Global Const $sDarkRemain = GUICtrlCreateCheckbox("Dark Remains", 20, 165)
   Global Const $sDragonRoot = GUICtrlCreateCheckbox("Dragon Root", 20, 185)

   Global Const $sJoker = GUICtrlCreateCheckbox("Joker", 20, 205)

   GUICtrlCreateLabel("Weapons", 130, 85)
   Global Const $sWhite = GUICtrlCreateCheckbox("White", 130, 105)
   GUICtrlSetState(-1, $GUI_DISABLE)
   Global Const $sBlue = GUICtrlCreateCheckbox("Blue", 130, 125)
   GUICtrlSetState(-1, $GUI_DISABLE)
   Global Const $sPurple = GUICtrlCreateCheckbox("Purple", 130, 145)
   GUICtrlSetState(-1, $GUI_DISABLE)
   Global Const $sGold = GUICtrlCreateCheckbox("Gold", 130, 165)
   GUICtrlSetState(-1, $GUI_DISABLE)
   Global Const $sGreen = GUICtrlCreateCheckbox("Green", 130, 185)
	GUICtrlSetState(-1, $GUI_DISABLE)

   GUICtrlCreateTabItem("Extras")

   Global Const $drop = GUICtrlCreateCheckbox("Drop on floor", 20, 83)
   GUICtrlCreateLabel("Nb Stacks : ", 110, 88)
   Global Const $qty = GUICtrlCreateInput("", 170, 85, 20, 16)

   Global Const $gJoker = GUICtrlCreateGroup("Joker", 10, 110, 200, 120)
   GUICtrlCreateLabel("Model ID : ", 22, 130)
   Global Const $inputName = GUICtrlCreateInput("", 75, 128, 120, 18)
   GUICtrlCreateLabel("Item Slot : ", 22, 158)
   Global $cBag = GUICtrlCreateCombo("", 75, 155, 40, 18)
   GUICtrlSetData($cBag, "1|2|3|4", "1")
   Global $cSlot = GUICtrlCreateCombo("", 135, 155, 40, 18)
   GUICtrlSetData($cSlot, "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20", "1")
   Global Const $bJoker = GUICtrlCreateButton("Go !", 130, 198, 60, 20)
   GUICtrlCreateLabel("Model ID : ", 22, 200)
   Global $lModelID = GUICtrlCreateLabel("0", 75, 200, 50, 20)

#endregion MainGui

#region MoreGui

Global $MoreGui = GUICreate("More Window", 600, 340, -1, -1, $WS_POPUP, $WS_EX_LAYERED)
   Global Const $MoreGuiChild = GUICreate("", 600, 340, 0, 0, $WS_POPUP, $WS_EX_MDICHILD + $WS_EX_LAYERED + $WS_EX_TOOLWINDOW, $MoreGui)
   GUISetBkColor(0xABCDE, $MoreGuiChild)
   GUISwitch($MoreGuiChild)
   GUICtrlSetDefColor(0xF0F0FD, $MoreGuiChild)
   _WinAPI_SetLayeredWindowAttributes($MoreGuiChild, 0xABCDEF, 0xFF)

   GUIRegisterMsg($WM_LBUTTONDOWN, "_WM_LBUTTONDOWN")

   GUICtrlCreateLabel("Materials", 120, 20)

   GUICtrlCreateLabel("Common", 30, 40)
   Global Const $mcBone = GUICtrlCreateCheckbox("Bone", 20, 60)
   GUICtrlSetOnEvent(-1, "GUIBoxCheckedMc")
   Global Const $mcIron = GUICtrlCreateCheckbox("Iron", 20, 80)
   GUICtrlSetOnEvent(-1, "GUIBoxCheckedMc")
   Global Const $mcTannedHides = GUICtrlCreateCheckbox("T_Hides", 20, 100)
   Global Const $mcScale = GUICtrlCreateCheckbox("Scale", 20, 120)
   Global Const $mcChitin = GUICtrlCreateCheckbox("Chitin", 20, 140)
   Global Const $mcCloth = GUICtrlCreateCheckbox("Cloth", 20, 160)
   Global Const $mcWood = GUICtrlCreateCheckbox("Wood", 20, 180)
   Global Const $mcGranite = GUICtrlCreateCheckbox("Granite", 20, 200)
   GUICtrlSetOnEvent(-1, "GUIBoxCheckedMc")
   Global Const $mcDust = GUICtrlCreateCheckbox("Dust", 20, 220)
   GUICtrlSetOnEvent(-1, "GUIBoxCheckedMc")
   Global Const $mcFiber = GUICtrlCreateCheckbox("Fiber", 20, 240)
   GUICtrlSetOnEvent(-1, "GUIBoxCheckedMc")
   Global Const $mcFeather = GUICtrlCreateCheckbox("Feather", 20, 260)
   GUICtrlSetOnEvent(-1, "GUIBoxCheckedMc")

   GUICtrlCreateLabel("Rare", 170, 40)
   Global Const $mcFur = GUICtrlCreateCheckbox("Fur", 120, 60)
   Global Const $mcLinen = GUICtrlCreateCheckbox("Linen", 120, 80)
   Global Const $mcDamask = GUICtrlCreateCheckbox("Damask", 120, 100)
   Global Const $mcSilk = GUICtrlCreateCheckbox("Silk", 120, 120)
   Global Const $mcEctoplasm = GUICtrlCreateCheckbox("Ectoplasm", 120, 140)
   Global Const $mcSteel = GUICtrlCreateCheckbox("Steel", 120, 160)
   Global Const $mcDeldrimorSteel = GUICtrlCreateCheckbox("D-Steel", 120, 180)
   Global Const $mcClaw = GUICtrlCreateCheckbox("Claw", 120, 200)
   Global Const $mcEye = GUICtrlCreateCheckbox("Eye", 120, 220)
   Global Const $mcFang = GUICtrlCreateCheckbox("Fang", 120, 240)
   Global Const $mcRuby = GUICtrlCreateCheckbox("Ruby", 120, 260)
   Global Const $mcSapphire = GUICtrlCreateCheckbox("Sapphire", 120, 280)
   Global Const $mcDiamond = GUICtrlCreateCheckbox("Diamond", 120, 300)

   Global Const $mcOnyx = GUICtrlCreateCheckbox("Onyx", 220, 60)
   Global Const $mcCharcoal = GUICtrlCreateCheckbox("Charcoal", 220, 80)
   Global Const $mcObsidian = GUICtrlCreateCheckbox("Obsidian", 220, 100)
   Global Const $mcGlass = GUICtrlCreateCheckbox("Glass", 220, 120)
   Global Const $mcLeather = GUICtrlCreateCheckbox("Leather", 220, 140)
   Global Const $mcEloLeather = GUICtrlCreateCheckbox("E_Leather", 220, 160)
   Global Const $mcInk = GUICtrlCreateCheckbox("Ink", 220, 180)
   Global Const $mcParchment = GUICtrlCreateCheckbox("Parchment", 220, 200)
   Global Const $mcVellum = GUICtrlCreateCheckbox("Vellum", 220, 220)
   Global Const $mcSpiritwood = GUICtrlCreateCheckbox("SWood", 220, 240)
   Global Const $mcAmber = GUICtrlCreateCheckbox("Amber", 220, 260)
   Global Const $mcJadeite = GUICtrlCreateCheckbox("Jadeite", 220, 280)

   GUICtrlCreateLabel("P-Cons", 330, 40)
   Global Const $mcApple = GUICtrlCreateCheckbox("Apple", 320, 60)
   Global Const $mcCorn = GUICtrlCreateCheckbox("Corn", 320, 80)
   Global Const $mcGoldenEgg = GUICtrlCreateCheckbox("Golden Egg", 320, 100)
   Global Const $mcPumpkinPie = GUICtrlCreateCheckbox("Pumpkin Pie", 320, 120)
   Global Const $mcWarSupply = GUICtrlCreateCheckbox("War Supply", 320, 140)
   Global Const $mcCupcake = GUICtrlCreateCheckbox("Cupcake", 320, 160)
   Global Const $mcGhostitB = GUICtrlCreateCheckbox("Ghost", 320, 180)
   Global Const $mcSkalefinSoup = GUICtrlCreateCheckbox("Skalefin Soup", 320, 200)
   Global Const $mcDrakeKabob = GUICtrlCreateCheckbox("Drake Kabob", 320, 220)
   Global Const $mcPahnaiSalad = GUICtrlCreateCheckbox("Pahnai Salad", 320, 240)
   Global Const $mcLunarFortunes = GUICtrlCreateCheckbox("Lunar Fortunes", 320, 260)

   GUICtrlCreateLabel("Conset", 430, 40)
   Global Const $mcArmorOfSalv = GUICtrlCreateCheckbox("Armor Of Salv", 420, 100)
   Global Const $mcEssenceOfCel = GUICtrlCreateCheckbox("Essence Of Cel", 420, 60)
   Global Const $mcGrailOfMight = GUICtrlCreateCheckbox("Grail Of Might", 420, 80)

   GUICtrlCreateLabel("Title Points", 430, 180)
   Global Const $mcAlcohol = GUICtrlCreateCheckbox("Alcohol", 420, 200)
   Global Const $mcParty = GUICtrlCreateCheckbox("Party", 420, 220)
   Global Const $mcSweet = GUICtrlCreateCheckbox("Sweet", 420, 240)

GUISetState(@SW_SHOW, $MainGui)

GUICtrlSetOnEvent($btnStart, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")
GUICtrlSetOnEvent($bMore, "EventHandler")

GUICtrlSetOnEvent($drop, "CheckboxDropClick")
GUICtrlSetOnEvent($cBag, "JokerBags")
GUICtrlSetOnEvent($bJoker, "FindTheJoker")
GUICtrlSetOnEvent($tab, "ReadCurrentTab")

#endregion MoreGui

#endregion Gui

#region Loops

Do
   Sleep(100)
Until $boolInitialized

While 1
   If $boolRunning Then
		Switch $CurrentTab
			Case 0
				If getchecked($drop) Then
					Drop()
					$boolRunning = False
					GUICtrlSetData($btnStart, "Start")
				ElseIf GUICtrlRead($aCombo) = "Chest -> Inventory" Then
					UnStore()
					$boolRunning = False
					GUICtrlSetData($btnStart, "Start")
				ElseIf GUICtrlRead($aCombo) = "Inventory -> Chest" Then
					Store()
					$boolRunning = False
					GUICtrlSetData($btnStart, "Start")
				EndIf
			Case 1
				Identify()
				$boolRunning = False
				GUICtrlSetData($btnStart, "Start")
			Case 2
				Salvage()
				$boolRunning = False
				GUICtrlSetData($btnStart, "Start")
			Case 3
				If getchecked($drop) Then
					Drop()
				EndIf
		EndSwitch
	EndIf
WEnd

Func EventHandler()
   Switch @GUI_CtrlId
	  Case $GUI_EVENT_CLOSE
		 Exit
	  Case $btnStart
		 BuildArrays()
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
			   If Initialize(ProcessExists("gw.exe"), True, True, True) = False Then
				  MsgBox(0, "Error", "Guild Wars it not running.")
				  Exit
			   EndIf
			Else
			   If Initialize(GUICtrlRead($inputCharName), True, True, True) = False Then
				  MsgBox(0, "Error", "Can't find a Guild Wars client with that character name.")
				  Exit
			   EndIf
			EndIf
			GUICtrlSetData($btnStart, "Pause")
			GUICtrlSetState($btnStart, $GUI_ENABLE)
			$boolInitialized = True
		 EndIf
	  Case $bMore
		 If getchecked($bMore) Then
			GUISetState(@SW_SHOW, $MoreGuiChild)
		 Else
			GUISetState(@SW_HIDE, $MoreGuiChild)
		 EndIf

   EndSwitch
EndFunc

#endregion Loops

 Func Store()
	StoreBag(1)
	StoreBag(2)
	StoreBag(3)
	StoreBag(4)
 EndFunc

 Func UnStore()
	For $i = 6 To 16
		 StoreChest($i)
	Next
 EndFunc

Func StoreBag($aBag)
   Out("Storing bag " & $aBag)
   If Not IsDllStruct($aBag) Then $aBag = GetBag($aBag)
   Local $lItem
   Local $lSlot

   If IsChestFull() Then
	  $boolRunning = False
   EndIf

   For $i = 1 To DllStructGetData($aBag, 'Slots')

	  If $boolRunning = False Then
		 ExitLoop
	  EndIf

	  $stockable = false
	  $lItem = GetItemBySlot($aBag, $i)
	  If DllStructGetData($lItem, 'id') == 0 Then ContinueLoop
	  $m = DllStructGetData($lItem, 'ModelID')
	  $r = GetRarity($lItem)

	  If _ArraySearch($ArrayModelIDInv, $m) <> -1 Then
		 $stockable = True
	  ElseIf $r = $rGold And getchecked($iGold) Then
		 $stockable = True
	  EndIf

	  If $stockable == True Then
		 $lSlot = FindStorageStack(DllStructGetData($lItem, 'ModelID'), DllStructGetData($lItem, 'ExtraID'))
		 If IsArray($lSlot) And getchecked($iGold) == False Then
			MoveItem($lItem, $lSlot[0], $lSlot[1])
			Sleep(GetPing() + Random(500, 750, 1))
			$i -= 1
		 Else
			$lSlot = OpenStorageSlot()
			If IsArray($lSlot) Then
			   MoveItem($lItem, $lSlot[0], $lSlot[1])
			   Sleep(GetPing() + Random(500, 750, 1))
			EndIf
		 EndIf
	  EndIf
   Next
EndFunc   ;==>StoreBag

Func StoreChest($aBag)
   Out("UnStoring chest " & $aBag & ".")
   If Not IsDllStruct($aBag) Then $aBag = GetBag($aBag)
   Local $lItem
   Local $lSlot

   If IsInvFull() Then
	  $boolRunning = False
   EndIf

   For $i = 1 To DllStructGetData($aBag, 'Slots')

	  If $boolRunning = False Then
		 ExitLoop
	  EndIf

	  $stockable = false
	  $lItem = GetItemBySlot($aBag, $i)
	  $m = DllStructGetData($lItem, 'ModelID')
	  $r = GetRarity($lItem)
	  If DllStructGetData($lItem, 'id') == 0 Then ContinueLoop
	  If _ArraySearch($ArrayModelIDInv, $m) <> -1 Then
		 $stockable = True
	  ElseIf $r = $rGold And getchecked($iGold) Then
		 $stockable = True
	  EndIf

	  If $stockable == True Then
		 $lSlot = FindInventoryStack(DllStructGetData($lItem, 'ModelID'), DllStructGetData($lItem, 'ExtraID'))
		 If IsArray($lSlot) And getchecked($iGold) == False Then
			MoveItem($lItem, $lSlot[0], $lSlot[1])
			Sleep(GetPing() + Random(500, 750, 1))
			$i -= 1
		 Else
			$lSlot = OpenInventorySlot()
			If IsArray($lSlot) Then
			   MoveItem($lItem, $lSlot[0], $lSlot[1])
			   Sleep(GetPing() + Random(500, 750, 1))
			EndIf
		 EndIf
	  EndIf
   Next
EndFunc

Func Drop()
   Out("Dropping")
   Local $lItem
   Local $lSlot
   Local $ldropped = 0

   Local $nbs = GUICtrlRead($qty)

   For $j = 1 To 4
		$aBag = GetBag($j)
		If Not IsDllStruct($aBag) Then $aBag = GetBag($aBag)
		For $i = 1 To DllStructGetData($aBag, 'Slots')

			If $boolRunning = False Then
				ExitLoop
			EndIf

			$canbedropped = false
			$lItem = GetItemBySlot($aBag, $i)
			If DllStructGetData($lItem, 'id') == 0 Then ContinueLoop
			$m = DllStructGetData($lItem, 'ModelID')
			$q = DllStructGetData($lItem, 'Quantity')
			$r = GetRarity($lItem)

			If _ArraySearch($ArrayModelIDInv, $m) <> -1 Then
				$canbedropped = True
			ElseIf $r = $rGold And getchecked($iGold) Then
				$canbedropped = True
			EndIf

			If $canbedropped == True And $ldropped <> $nbs Then
				DropItem($lItem, $q)
				Sleep(GetPing() + Random(500, 750, 1))
				$ldropped += 1
			EndIf

			If $ldropped == $nbs Or ($j = 4 And $i = 10) Then
				$boolRunning = False
				GUICtrlSetData($btnStart, "Start")
				ExitLoop
			EndIf
		Next
	Next
EndFunc

Func OpenBackpackSlot($aBags)
   Local $lBag
   Local $lReturnArray[2]

   For $i = 1 To $aBags
	  $lBag = GetBag($i)
	  For $j = 1 To DllStructGetData($lBag, 'Slots')
		 If DllStructGetData(GetItemBySlot($lBag, $j), 'ID') == 0 Then
			   $lReturnArray[0] = $i
			   $lReturnArray[1] = $j
			   Return $lReturnArray
		 EndIf
	  Next
   Next
EndFunc   ;==>OpenBackpackSlot

Func OpenStorageSlot()
   Local $lBag
   Local $lReturnArray[2]

   For $i = 8 To 16
	  $lBag = GetBag($i)
	  For $j = 1 To DllStructGetData($lBag, 'Slots')
		 If DllStructGetData(GetItemBySlot($lBag, $j), 'ID') == 0 Then
			   $lReturnArray[0] = $i
			   $lReturnArray[1] = $j
			   Return $lReturnArray
		 EndIf
	  Next
   Next
EndFunc   ;==>OpenStorageSlot

Func FindStorageStack($aModelID, $aExtraID)
   Local $lBag
   Local $lReturnArray[2]
   Local $lItem

   For $i = 6 To 16
	  If $i == 7 Then ContinueLoop
	  $lBag = GetBag($i)
	  For $j = 1 To DllStructGetData($lBag, 'Slots')
		 $lItem = GetItemBySlot($lBag, $j)
		 If DllStructGetData($lItem, 'ModelID') == $aModelID And DllStructGetData($lItem, 'ExtraID') == $aExtraID And DllStructGetData($lItem, 'Quantity') < 250 Then
			   $lReturnArray[0] = $i
			   $lReturnArray[1] = $j
			   Return $lReturnArray
		 EndIf
	  Next
   Next
EndFunc

Func FindInventoryStack($aModelID, $aExtraID)
   Local $lBag
   Local $lReturnArray[2]
   Local $lItem

   For $i = 1 To 4
	  $lBag = GetBag($i)
	  For $j = 1 To DllStructGetData($lBag, 'Slots')
		 $lItem = GetItemBySlot($lBag, $j)
		 If DllStructGetData($lItem, 'ModelID') == $aModelID And DllStructGetData($lItem, 'ExtraID') == $aExtraID And DllStructGetData($lItem, 'Quantity') < 250 Then
			   $lReturnArray[0] = $i
			   $lReturnArray[1] = $j
			   Return $lReturnArray
		 EndIf
	  Next
   Next
EndFunc

Func OpenInventorySlot()
   Local $lBag
   Local $lReturnArray[2]

   For $i = 1 To 4
	  $lBag = GetBag($i)
	  For $j = 1 To DllStructGetData($lBag, 'Slots')
		 If DllStructGetData(GetItemBySlot($lBag, $j), 'ID') == 0 Then
			   $lReturnArray[0] = $i
			   $lReturnArray[1] = $j
			   Return $lReturnArray
		 EndIf
	  Next
   Next
EndFunc

Func IsInvFull()
   If CountInvSlots() = 0 Then
	  Out("Inventory Full")
	  GUICtrlSetData($btnStart, "Start")
	  Return True
   EndIf
   Return False
EndFunc

Func CountInvSlots()
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
EndFunc

Func IsChestFull()
   If CountChestSlots() = 0 Then
	  Out("Chest Full")
	  GUICtrlSetData($btnStart, "Start")
	  Return True
   EndIf
   Return False
EndFunc

Func CountChestSlots()
   Local $bag
   Local $temp = 0
   For $i = 8 to 16
	  $bag = GetBag($i)
	  $temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
   Next
   Return $temp
EndFunc


Func Identify()
   Out("Identifying bags ")

   Local $Chest
   Local $Merchant

   For $i = 0 To 6 ; Open chest
	  $Chest = GetAgentByName($nXunlai[$i])
	  If IsDllStruct($Chest) Then
		 Out("Chest found !")
		 GoToNPC($Chest)
		 ExitLoop
	  ElseIf $i = 7 Then
		 Out("Chest not found")
	  EndIf
   Next

   For $i = 0 To 6 ; Open Merchant
	  $Merchant = GetAgentByName($nMerchant[$i])
	  If IsDllStruct($Merchant) Then
		 Out("Merchant found !")
		 GoToNPC($Merchant)
		 ExitLoop
	  ElseIf $i = 7 Then
		 Out("Chest not found")
	  EndIf
   Next

   If getchecked($Backpack) Then IdentBag(1)
   If getchecked($BeltPouch) Then IdentBag(2)
   If getchecked($Bag1) Then IdentBag(3)
   If getchecked($Bag2) Then IdentBag(4)
EndFunc

Func IdentBag($aBag)
   Local $lItem

   Out("Identifying")

   If Not IsDllStruct($aBag) Then $aBag = GetBag($aBag)

   For $i = 0 To DllStructGetData($aBag, "slots")
	  IDKit()
	  $lItem = GetItemBySlot($aBag, $i)
	  If DllStructGetData($lItem, "ID") = 0 Then ContinueLoop
	  $r = GetRarity($lItem)
	  If Not GetIsIDed($lItem) Then
		 If $r = $rWhite And getchecked($White) Then IdentifyItem($lItem)
		 If $r = $rBlue And getchecked($Blue) Then IdentifyItem($lItem)
		 If $r = $rPurple And getchecked($Purple) Then IdentifyItem($lItem)
		 If $r = $rGold And getchecked($Gold) Then IdentifyItem($lItem)
		 If $r = $rGreen And getchecked($Green) Then IdentifyItem($lItem)
	  EndIf
	  RndSleep(500)
   Next
EndFunc

Func IDKit()
   If FindIDKit() = 0 Then
	  Out("Need ID kit.")
	  If GetGoldCharacter() < 100 Then
		 Out("Need gold.")
		 WithdrawGold(100)
		 RndSleep(2000)
	  EndIf
	  BuyItem(5, 1, 100)
	  RndSleep(1000)
   EndIf
EndFunc

 Func _WM_LBUTTONDOWN($hWnd, $iMsg, $wParam, $lParam)
    _SendMessage($MoreGui, $WM_SYSCOMMAND, $SC_DRAGMOVE, 0)
EndFunc ;==>_WM_LBUTTONDOWN

 Func Salvage()
   Local $Chest
   Local $Merchant

   For $i = 0 To 6 ; Open chest
	  $Chest = GetAgentByName($nXunlai[$i])
	  If IsDllStruct($Chest) Then
		 Out("Chest found !")
		 GoToNPC($Chest)
		 ExitLoop
	  ElseIf $i = 7 Then
		 Out("Chest not found")
	  EndIf
   Next

   For $i = 0 To 6 ; Open Merchant
	  $Merchant = GetAgentByName($nMerchant[$i])
	  If IsDllStruct($Merchant) Then
		 Out("Merchant found !")
		 GoToNPC($Merchant)
		 ExitLoop
	  ElseIf $i = 7 Then
		 Out("Chest not found")
	  EndIf
   Next

   For $i = 1 To 4
	  If Not SalvageBag2($i) Then ExitLoop
   Next

 EndFunc

 Func SalvageKit()
   If FindSalvageKit() = 0 Then
	  Out("Need salvage kit")
	  If GetGoldCharacter() < 100 Then
		 Out("Need gold")
		 WithdrawGold(100)
		 RndSleep(2000)
	  EndIf
	  BuyItem(2, 1, 100)
	  RndSleep(1000)
   EndIf
 EndFunc

Func SalvageBag2($lBag)
	Out("Salvaging bag " & $lBag & ".")
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
		$q = DllStructGetData($lItem, 'Quantity')

		If (DllStructGetData($lItem, 'ID') == 0) Then ContinueLoop
		If _ArraySearch($ArraySalvageRarity, $r) = -1 And _ArraySearch($ArraySalvageModelID, $m) = -1 Then ContinueLoop

		If $q >= 1 Then
			For $j = 1 To $q

				If $boolRunning = False Then
					ExitLoop
				EndIf

				SalvageKit()

				StartSalvage($lItem)
				While (GetPing() > 1250)
					RndSleep(250)
					Out("Ping To High" & GetPing())
				WEnd
;~ 				Sleep(GetPing() * 3 + 1000)
				Local $lDeadlock = TimerInit()
				Local $bItem
				Do
					Sleep(300)
					$bItem = GetItemBySlot($aBag, $i)
					If (TimerDiff($lDeadlock) > 20000) Then ExitLoop
				Until (DllStructGetData($bItem, 'Quantity') = $q - $j)
			Next
		EndIf
	Next
	Return True
EndFunc   ;==>SalvageBag

Func SalvageBag($lBag)
	Out("Salvaging bag " & $lBag & ".")
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
					Out("Ping To High" & GetPing())
				WEnd
				Sleep(GetPing() * 3 + 800)
;~ 				SendPacket(0x8, 0x74, $lSalvageType)
				SendPacket(0x4, 0x73)
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
					OUT("Ping To High" & GetPing())
				WEnd
				Sleep(GetPing() * 3 + 800)
				SendPacket(0x4, 0x73)
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
					Out("Ping To High" & GetPing())
				WEnd
				Sleep(GetPing() + 800)
				SendPacket(0x4, 0x73)
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
	For $i = 1 To $aBags
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
			EndSwitch
		Next
	Next
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

Func BuildArrays()

	Global $ArrayModelIDInv[60]
	If getchecked($Iron) Then _ArrayAdd($ArrayModelIDInv, $mIron )
	If getchecked($Dust) Then _ArrayAdd($ArrayModelIDInv, $mDust)
	If getchecked($Bone) Then _ArrayAdd($ArrayModelIDInv, $mBone)
	If getchecked($Granite) Then _ArrayAdd($ArrayModelIDInv, $mGranite)
	If getchecked($Fiber) Then _ArrayAdd($ArrayModelIDInv, $mFiber)
	If getchecked($Feather) Then _ArrayAdd($ArrayModelIDInv, $mFeather)
	If getchecked($FeatherCrest) Then _ArrayAdd($ArrayModelIDInv, $mFeatherCrest)
	If getchecked($GlacialStone) Then _ArrayAdd($ArrayModelIDInv, $mGlacialStone)
	If getchecked($SaurianBone) Then _ArrayAdd($ArrayModelIDInv, $mSaurianBone)
	If getchecked($DarkRemain) Then _ArrayAdd($ArrayModelIDInv, $mDarkRemain)
	If getchecked($Joker) Then _ArrayAdd($ArrayModelIDInv, $mJoker)
	If getchecked($mcTannedHides) Then _ArrayAdd($ArrayModelIDInv, $mTannedHides)
	If getchecked($mcScale) Then _ArrayAdd($ArrayModelIDInv, $mScale)
	If getchecked($mcChitin) Then _ArrayAdd($ArrayModelIDInv, $mChitin)
	If getchecked($mcCloth) Then _ArrayAdd($ArrayModelIDInv, $mCloth)
	If getchecked($mcWood) Then _ArrayAdd($ArrayModelIDInv, $mWood)
	If getchecked($mcFur) Then _ArrayAdd($ArrayModelIDInv, $mFur)
	If getchecked($mcLinen) Then _ArrayAdd($ArrayModelIDInv, $mLinen)
	If getchecked($mcDamask) Then _ArrayAdd($ArrayModelIDInv, $mDamask)
	If getchecked($mcSilk) Then _ArrayAdd($ArrayModelIDInv, $mSilk)
	If getchecked($mcEctoplasm) Then _ArrayAdd($ArrayModelIDInv, $mEctoplasm)
	If getchecked($mcSteel) Then _ArrayAdd($ArrayModelIDInv, $mSteel)
	If getchecked($mcDeldrimorSteel) Then _ArrayAdd($ArrayModelIDInv, $mDeldrimorSteel)
	If getchecked($mcClaw) Then _ArrayAdd($ArrayModelIDInv, $mClaw)
	If getchecked($mcEye) Then _ArrayAdd($ArrayModelIDInv, $mEye)
	If getchecked($mcFang) Then _ArrayAdd($ArrayModelIDInv, $mFang)
	If getchecked($mcRuby) Then _ArrayAdd($ArrayModelIDInv, $mRuby)
	If getchecked($mcSapphire) Then _ArrayAdd($ArrayModelIDInv, $mSapphire)
	If getchecked($mcDiamond) Then _ArrayAdd($ArrayModelIDInv, $mDiamond)
	If getchecked($mcOnyx) Then _ArrayAdd($ArrayModelIDInv, $mOnyx)
	If getchecked($mcCharcoal) Then _ArrayAdd($ArrayModelIDInv, $mCharcoal)
	If getchecked($mcObsidian) Then _ArrayAdd($ArrayModelIDInv, $mObsidian)
	If getchecked($mcGlass) Then _ArrayAdd($ArrayModelIDInv, $mGlass)
	If getchecked($mcLeather) Then _ArrayAdd($ArrayModelIDInv, $mLeather)
	If getchecked($mcEloLeather) Then _ArrayAdd($ArrayModelIDInv, $mEloLeather)
	If getchecked($mcInk) Then _ArrayAdd($ArrayModelIDInv, $mInk)
	If getchecked($mcParchment) Then _ArrayAdd($ArrayModelIDInv, $mParchment)
	If getchecked($mcVellum) Then _ArrayAdd($ArrayModelIDInv, $mVellum)
	If getchecked($mcSpiritwood) Then _ArrayAdd($ArrayModelIDInv, $mSpiritwood)
	If getchecked($mcAmber) Then _ArrayAdd($ArrayModelIDInv, $mAmber)
	If getchecked($mcJadeite) Then _ArrayAdd($ArrayModelIDInv, $mJadeite)
	If getchecked($mcApple) Then _ArrayAdd($ArrayModelIDInv, $mApple)
	If getchecked($mcCorn) Then _ArrayAdd($ArrayModelIDInv, $mCorn)
	If getchecked($mcGoldenEgg) Then _ArrayAdd($ArrayModelIDInv, $mGoldenEgg)
	If getchecked($mcPumpkinPie) Then _ArrayAdd($ArrayModelIDInv, $mPumpkinPie)
	If getchecked($mcWarSupply) Then _ArrayAdd($ArrayModelIDInv, $mWarSupply)
	If getchecked($mcCupcake) Then _ArrayAdd($ArrayModelIDInv, $mCupcake)
	If getchecked($mcGhostitB) Then _ArrayAdd($ArrayModelIDInv, $mGhostitB)
	If getchecked($mcSkalefinSoup) Then _ArrayAdd($ArrayModelIDInv, $mSkalefinSoup)
	If getchecked($mcDrakeKabob) Then _ArrayAdd($ArrayModelIDInv, $mDrakeKabob)
	If getchecked($mcPahnaiSalad) Then _ArrayAdd($ArrayModelIDInv, $mPahnaiSalad)
;~ 	If getchecked($mcLunarFortunes) Then _ArrayAdd($ArrayModelIDInv, $mLunarFortunes)
	If getchecked($mcArmorOfSalv) Then _ArrayAdd($ArrayModelIDInv, $mArmorOfSalv)
	If getchecked($mcEssenceOfCel) Then _ArrayAdd($ArrayModelIDInv, $mEssenceOfCel)
	If getchecked($mcGrailOfMight) Then _ArrayAdd($ArrayModelIDInv, $mGrailOfMight)

   Global $ArraySalvageRarity[5]
   If getchecked($White) Then _ArrayAdd($ArraySalvageRarity, $rWhite)
   If getchecked($Blue) Then _ArrayAdd($ArraySalvageRarity, $rBlue)
   If getchecked($Purple) Then _ArrayAdd($ArraySalvageRarity, $rPurple)
   If getchecked($Gold) Then _ArrayAdd($ArraySalvageRarity, $rGold)
   If getchecked($Green) Then _ArrayAdd($ArraySalvageRarity, $rGreen)

   Global $ArraySalvageModelID[6]
   If getchecked($sJoker) Then _ArrayAdd($ArraySalvageModelID, $mJoker)
   If getchecked($sFeatherCrest) Then _ArrayAdd($ArraySalvageModelID, $mFeatherCrest)
   If getchecked($sGlacialStone) Then _ArrayAdd($ArraySalvageModelID, $mGlacialStone)
   If getchecked($sSaurianBone) Then _ArrayAdd($ArraySalvageModelID, $mSaurianBone)
   If getchecked($sDarkRemain) Then _ArrayAdd($ArraySalvageModelID, $mDarkRemain)
   If getchecked($sDragonRoot) Then _ArrayAdd($ArraySalvageModelID, $mDragonRoot)


	If getchecked($mcAlcohol) Then AddArrayToArray($ArrayModelIDInv, $mAlcoholArray)

	If getchecked($mcParty) Then AddArrayToArray($ArrayModelIDInv, $mPartyArray)

	If getchecked($mcSweet) Then AddArrayToArray($ArrayModelIDInv, $mSweetArray)
EndFunc

Func AddArrayToArray($Array, $ArrayToAdd)
	For $i = 0 To UBound($ArrayToAdd) - 1
		_ArrayAdd($Array, $ArrayToAdd[$i])
	Next
EndFunc

Func Out($aString)
   Local $timestamp = "[" & @HOUR & ":" & @MIN & "] "
   GUICtrlSetData($lblLog, $timestamp & $aString)
EndFunc

Func getchecked($GUICTRL)
   Return (GUICtrlRead($GUICTRL) == $GUI_CHECKED)
EndFunc

Func CheckboxDropClick()
   If getchecked($drop) Then
      GUICtrlSetState($aCombo, $GUI_DISABLE)
   Else
      GUICtrlSetState($aCombo, $GUI_ENABLE)
   EndIf
EndFunc

Func JokerBags()
   _GUICtrlComboBox_ResetContent($cSlot)
   If GUICtrlRead($cBag) == 1 Then GUICtrlSetData($cSlot, "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20", "1")
   If GUICtrlRead($cBag) == 2 Then GUICtrlSetData($cSlot, "1|2|3|4|5", "1")
   If GUICtrlRead($cBag) == 3 Or GUICtrlRead($cBag) == 4 Then GUICtrlSetData($cSlot, "1|2|3|4|5|6|7|8|9|10", "1")
EndFunc

Func FindTheJoker()
   Local $aName = GUICtrlRead($inputName)
   Local $aBag = GUICtrlRead($cBag)
   Local $aSlot = GUICtrlRead($cSlot)

   If $aName == "" Then
	  $lItem = GetItemBySlot($aBag, $aSlot)
	  $mJoker = DllStructGetData($lItem, 'ModelID')
	  GUICtrlSetData($lModelID, $mJoker)
   Else
	  For $i = 1 To 16
		 $aBag = GetBag($i)
		 If Not IsDllStruct($aBag) Then $aBag = GetBag($aBag)
		 For $i = 1 To DllStructGetData($aBag, 'Slots')
			$lItem = GetItemBySlot($aBag, $i)
			If DllStructGetData($lItem, 'id') == 0 Then ContinueLoop
			$m = DllStructGetData($lItem, 'ModelID')
			If $m == $aName Then
			   $mJoker = $m
			   GUICtrlSetData($lModelID, $mJoker)
			EndIf
		 Next
	  Next
   EndIf
EndFunc

Func ReadCurrentTab()
   $CurrentTab = GUICtrlRead ($tab) ; 0 = Storage / 1 = Identify / 2 = Salvage / 3 = Extra
EndFunc

Func GUIBoxCheckedMc()
	GUICtrlSetState($Bone , GUICtrlRead($mcBone))
	GUICtrlSetState($Iron , GUICtrlRead($mcIron))
	GUICtrlSetState($Dust , GUICtrlRead($mcDust))
	GUICtrlSetState($Feather , GUICtrlRead($mcFeather))
	GUICtrlSetState($Granite , GUICtrlRead($mcGranite))
	GUICtrlSetState($Fiber , GUICtrlRead($mcFiber))
EndFunc

Func GUIBoxChecked()
	GUICtrlSetState($mcBone , GUICtrlRead($Bone))
	GUICtrlSetState($mcIron , GUICtrlRead($Iron))
	GUICtrlSetState($mcDust , GUICtrlRead($Dust))
	GUICtrlSetState($mcFeather , GUICtrlRead($Feather))
	GUICtrlSetState($mcGranite , GUICtrlRead($Granite))
	GUICtrlSetState($mcFiber , GUICtrlRead($Fiber))
EndFunc