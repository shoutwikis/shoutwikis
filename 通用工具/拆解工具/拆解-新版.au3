#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <GuiComboBox.au3>
#include <Array.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include '../../激战接口.au3'


#region Variables

Global Const $SC_DRAGMOVE = 0xF012

Global $jiange = 250

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
Global $mSTEELINGOT = 949

Global $rWhite = 2621
Global $rBlue = 2623
Global $rPurple = 2626
Global $rGold = 2624
Global $rGreen = 2627

Global Enum $mFur = 941, $mLinen = 926,  $mDamask = 927,  $mSilk = 928,  $mEctoplasm = 930, $mSteel = 949,  $mDeldrimorSteel = 950,  $mClaw = 923, $mEye = 931, $mFang = 932
Global Enum	$mRuby = 937, $mSapphire = 938,  $mDiamond = 935, $mOnyx = 936, $mCharcoal = 922, $mObsidian = 945, $mGlass = 939, $mLeather = 942, $mEloLeather = 943, $mInk = 944
Global Enum	$mParchment = 951, $mVellum = 952, $mSpiritwood = 956, $mAmber = 6532, $mJadeite = 6533

Global Enum $mApple = 28431, $mCorn = 28432, $mGoldenEgg = 22752, $mPumpkinPie = 28436, $mWarSupply = 35121, $mCupcake = 22269, $mGhostitB = 6368
Global Enum	$mSkalefinSoup = 17061, $mDrakeKabob = 17060, $mPahnaiSalad = 17062, $mArmorOfSalv = 24860, $mEssenceOfCel = 24859, $mGrailOfMight = 2486

Global $nMerchant[7] = ["雜貨商人", "Merchant", "Marchand", "Kaufmann", "Mercante",  "Kupiec", "Merchunt"]
Global $nXunlai[7] = ["桑萊保險箱", "Xunlai Chest", "Coffre Xunlai", "Xunlai-Truhe", "Forziere Xunlai", "Skrzynia Xunlai", "Xoonlaeee Chest"]

Global $ArrayModelIDInv[60]
Global $ArraySalvageRarity[5]
Global $ArraySalvageModelID[7]

Global $boolInitialized = False
Global $boolRunning = False
Global $CurrentTab = 0

#endregion Variables

#region Gui

#region MainGui

Opt("GUIOnEventMode", True)

Global Const $MainGui = GUICreate("拆解", 290, 300)

   GUICtrlCreateLabel("角色名称", 8, 6, 280, 17, $SS_CENTER)
   Global Const $inputCharName = GUICtrlCreateCombo("", 5, 24, 280, 22)
	  GUICtrlSetData(-1, GetLoggedCharNames())

   Global Const $lblLog = GUICtrlCreateLabel("", 8, 240, 280, 30)
   Global Const $btnStart = GUICtrlCreateButton("开始", 8, 270, 280, 25)

   Global Const $info = GUICtrlCreateLabel("- 商人名 须含 '杂货商人' 字样 -", 72, 53, 200, 17)

   Global Const $tab = GUICtrlCreateTab(5, 50, 280, 190)

   GUICtrlCreateTabItem("拆解")

   Global Const $sFeatherCrest = GUICtrlCreateCheckbox("羽毛冠", 20, 105)
   Global Const $sGlacialStone = GUICtrlCreateCheckbox("冰河石", 20, 125)
   Global Const $sSaurianBone = GUICtrlCreateCheckbox("蜥蜴骨", 20, 145)
   Global Const $sDarkRemain = GUICtrlCreateCheckbox("黑残余物", 130, 125)
   Global Const $sDragonRoot = GUICtrlCreateCheckbox("龙根", 130, 145)

   Global Const $sSTEELINGOT = GUICtrlCreateCheckbox("钢铁", 130, 105)

   Global Const $sJoker = GUICtrlCreateCheckbox("自定, 型号:", 20, 175)

   Global Const $inputName = GUICtrlCreateInput("", 20, 200, 120, 18)

GUISetState(@SW_SHOW, $MainGui)

GUICtrlSetOnEvent($btnStart, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")

GUICtrlSetOnEvent($tab, "ReadCurrentTab")


Do
   Sleep(100)
Until $boolInitialized

While 1
   If $boolRunning Then
		Switch $CurrentTab
			Case 0,1,2,3
				Salvage()
				$boolRunning = False
				GUICtrlSetData($btnStart, "开始")
			case else
				Salvage()
				$boolRunning = False
				GUICtrlSetData($btnStart, "开始")
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
			GUICtrlSetData($btnStart, "继续")
			$boolRunning = False
		 ElseIf $boolInitialized Then
			GUICtrlSetData($btnStart, "暂停")
			$boolRunning = True
		 Else
			$boolRunning = True
			GUICtrlSetData($btnStart, "正在启动...")
			GUICtrlSetState($btnStart, $GUI_DISABLE)
			GUICtrlSetState($inputCharName, $GUI_DISABLE)
			WinSetTitle($MainGui, "", GUICtrlRead($inputCharName))
			If GUICtrlRead($inputCharName) = "" Then
			   If Initialize(ProcessExists("gw.exe"), True, True, True) = False Then
				  MsgBox(0, "失败", "激战未打开.")
				  Exit
			   EndIf
			Else
			   If Initialize(GUICtrlRead($inputCharName), True, True, True) = False Then
				  MsgBox(0, "失败", "无法找到角色.")
				  Exit
			   EndIf
			EndIf
			GUICtrlSetData($btnStart, "暂停")
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

 Func Salvage()
   Local $Chest
   Local $Merchant

   For $i = 1 To 7 ; Open chest
	  $Chest = GetAgentByName($nXunlai[$i-1])
	  If IsDllStruct($Chest) Then

		 Out("前往储存箱")
		 GoToNPC($Chest)
		 ExitLoop
	  ElseIf $i = 7 Then
		 Out("储存箱失寻")
	  EndIf
   Next

   For $i = 1 To 7 ; Open Merchant
	  $Merchant = GetAgentByName($nMerchant[$i-1])
	  If IsDllStruct($Merchant) Then

		 Out("前往商人处")
		 GoToNPC($Merchant)
		 ExitLoop
	  ElseIf $i = 7 Then
		 Out("商人失寻")
	  EndIf
   Next

   For $i = 1 To 4
	  If Not SalvageBag($i) Then ExitLoop
   Next

 EndFunc

 Func SalvageKit()
   If FindSalvageKit() = 0 Then
	  Out("需要拆解器.")
	  If GetGoldCharacter() < 100 Then
		 Out("取金买拆解器")
		 WithdrawGold(100)
		 RndSleep(2000)
	  EndIf

	  For $i = 1 To 7 ; Open Merchant
		$Merchant = GetAgentByName($nMerchant[$i-1])
		If IsDllStruct($Merchant) Then

			 Out("前往商人处")
			 GoToNPC($Merchant)
			 RndSleep(1000)
			 BuyItem(2, 1, 100)
			 RndSleep(2000+GetPing())
			 if FindSalvageKit() = 0 then
				 BuyItem(3, 1, 100)
				 RndSleep(2000+GetPing())
			 EndIf
			 RndSleep(2000+GetPing())
			 if FindSalvageKit() = 0 then
				 BuyItem(2, 1, 40)
				 RndSleep(2000+GetPing())
			 EndIf
			 ExitLoop
		ElseIf $i = 7 Then
			Out("商人失寻，暂停5秒")
			sleep(5000)
		EndIf
	  Next
   EndIf
 EndFunc

Func SalvageBag($lBag)
	Out("正在拆解第 " & $lBag & "包.")
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

		$lSalvageCount = SalvageUsesEx($lBag)
		$lSalvageType = GetCanSalvage($lItem, True)

		Switch $lSalvageType
			Case -1
				ContinueLoop
			Case 0, 1, 2
				StartSalvage($lItem)
				While (GetPing() > 1250)
					RndSleep(250)
					Out("延迟过高，正空转等待" & GetPing())
				WEnd
				Sleep(GetPing() * 3 + 800)

				SalvageMaterials()
				Sleep(GetPing() * 3)
				Local $lDeadlock = TimerInit()
				Do
					RndSleep($jiange)
					If (TimerDiff($lDeadlock) > 20000) Then ExitLoop
				Until (SalvageUsesEx($lBag) <> $lSalvageCount)
				$i -= 1
			Case 3 ; white qty = 1
				StartSalvage($lItem)
				While (GetPing() > 1250)
					RndSleep(250)
					OUT("延迟过高, 正空转等待" & GetPing())
				WEnd
				Sleep(GetPing() * 3 + 800)
				SalvageMaterials()
				Sleep(GetPing() * 3)
				Local $lDeadlock = TimerInit()
				Do
					RndSleep($jiange)
					If (TimerDiff($lDeadlock) > 20000) Then ExitLoop
				Until (SalvageUsesEx($lBag) <> $lSalvageCount)
			Case 4 ; qty > 1
				StartSalvage($lItem)
				While (GetPing() > 1250)
					RndSleep(250)
					Out("延迟过高, 正空转等待" & GetPing())
				WEnd
				Sleep(GetPing() + 800)
				SalvageMaterials()
				Local $lDeadlock = TimerInit()
				Do
					RndSleep($jiange)
					If (TimerDiff($lDeadlock) > 20000) Then ExitLoop
				Until (SalvageUsesEx($lBag) <> $lSalvageCount)
				$i -= 1
		EndSwitch
	Next
	Return True
EndFunc   ;==>SalvageBag

 #region Salvage
 Func GetCanSalvage($aItem, $aMerchant)

	If DllStructGetData($aItem, 'Customized') <> 0 Then Return -1

	Switch DllStructGetData($aItem, 'type')
		Case 0, 2, 5, 12, 15, 22, 24, 26, 27, 32, 35, 36, 11 ;added type 11 for steel ingot and other probably rare materials
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
			Return -1
		Case Else
			Return -1
	EndSwitch

EndFunc   ;==>GetCanSalvage

Func SalvageUsesEx($aBags)

	Local $lBag
	Local $lItem
	Local $lCount = 0
	For $i = 1 To 16
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
EndFunc   ;==>SalvageUsesEx

#endregion Salvage

Func BuildArrays()

   Global $ArraySalvageModelID[7]
   If getchecked($sJoker) Then _ArrayAdd($ArraySalvageModelID, Number(GUICtrlRead($inputName)))
   If getchecked($sFeatherCrest) Then _ArrayAdd($ArraySalvageModelID, $mFeatherCrest)
   If getchecked($sGlacialStone) Then _ArrayAdd($ArraySalvageModelID, $mGlacialStone)
   If getchecked($sSaurianBone) Then _ArrayAdd($ArraySalvageModelID, $mSaurianBone)
   If getchecked($sDarkRemain) Then _ArrayAdd($ArraySalvageModelID, $mDarkRemain)
   If getchecked($sDragonRoot) Then _ArrayAdd($ArraySalvageModelID, $mDragonRoot)
   If getchecked($sSTEELINGOT) Then _ArrayAdd($ArraySalvageModelID, $mSTEELINGOT)

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

Func ReadCurrentTab()
   $CurrentTab = GUICtrlRead ($tab) ; 0 = Storage / 1 = Identify / 2 = Salvage / 3 = Extra
EndFunc
