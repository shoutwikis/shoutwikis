#cs
this file contains everything related to the pcons tab and pcons popping functionality

current pcons categories:
conset
red rock candy
blue rock candy
green rock candy
alcohol
slice of pumpkin pie
birthday cupcake
skalefin soup
panhai salad
candy apple
candy corn
golden egg
drake babob
war supplies
lunar fortunes
res scrolls
mobstoppers
city speedboosts
#ce
#include-once
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <ColorConstants.au3>
#include <GuiComboBox.au3>
#include <Math.au3>

#include <../../激战接口.au3>
#include <../辅助文件2/激战常数.au3>
#include <../辅助文件2/辅助功能.au3>
#include <../辅助文件1/界面框.au3>
#include <../辅助文件1/一般常数.au3>
#include <../辅助文件1/快键绑定.au3>

Global $pcons ; if the whole pcons feature is active or not
Global $pconsHotkey ; if the hotkey to enable / disable pcons is active
Global $pconsHotkeyHotkey ; the actual hotkey to enable / disable pcons
Global $CheckboxPCons ; the checkbox in the main interface

Global $AlcoholUsageTimer = TimerInit()
Global $AlcoholUsageCount = 0

; interface items
Global Const $pconsCount = 18
Global Enum $PCONS_CONS, $PCONS_ALCOHOL, $PCONS_RRC, $PCONS_BRC, $PCONS_GRC, $PCONS_PIE, $PCONS_CUPCAKE, $PCONS_APPLE, _
$PCONS_CORN, $PCONS_EGG, $PCONS_KABOB, $PCONS_WARSUPPLY, $PCONS_LUNARS, $PCONS_RES, $PCONS_SKALESOUP, $PCONS_MOBSTOPPERS, _
$PCONS_PANHAI, $PCONS_CITY
Global $pconsCheckbox[$pconsCount]
Global $pconsActive[$pconsCount]  ; status (active or not)

; ini names
Global $pconsIniSection = "pcons"
Global $pconsName[$pconsCount]
$pconsName[$PCONS_CONS] = "cons"
$pconsName[$PCONS_ALCOHOL] = "alcohol"
$pconsName[$PCONS_RRC] = "RRC"
$pconsName[$PCONS_BRC] = "BRC"
$pconsName[$PCONS_GRC] = "GRC"
$pconsName[$PCONS_PIE] = "pie"
$pconsName[$PCONS_CUPCAKE] = "cupcake"
$pconsName[$PCONS_APPLE] = "apple"
$pconsName[$PCONS_CORN] = "corn"
$pconsName[$PCONS_EGG] = "egg"
$pconsName[$PCONS_KABOB] = "kabob"
$pconsName[$PCONS_WARSUPPLY] = "warsupply"
$pconsName[$PCONS_LUNARS] = "lunars"
$pconsName[$PCONS_RES] = "res"
$pconsName[$PCONS_SKALESOUP] = "skalesoup"
$pconsName[$PCONS_MOBSTOPPERS] = "mobstoppers"
$pconsName[$PCONS_PANHAI] = "panhai"
$pconsName[$PCONS_CITY] = "city"

Global $pconsItemID[$pconsCount]
$pconsItemID[$PCONS_CONS] = -1
$pconsItemID[$PCONS_ALCOHOL] = -1
$pconsItemID[$PCONS_RRC] = $ITEM_ID_RRC
$pconsItemID[$PCONS_BRC] = $ITEM_ID_BRC
$pconsItemID[$PCONS_GRC] = $ITEM_ID_GRC
$pconsItemID[$PCONS_PIE] = $ITEM_ID_PIES
$pconsItemID[$PCONS_CUPCAKE] = $ITEM_ID_CUPCAKES
$pconsItemID[$PCONS_APPLE] = $ITEM_ID_APPLES
$pconsItemID[$PCONS_CORN] = $ITEM_ID_CORNS
$pconsItemID[$PCONS_EGG] = $ITEM_ID_EGGS
$pconsItemID[$PCONS_KABOB] = $ITEM_ID_KABOBS
$pconsItemID[$PCONS_WARSUPPLY] = $ITEM_ID_WARSUPPLIES
$pconsItemID[$PCONS_LUNARS] = -1
$pconsItemID[$PCONS_RES] = $ITEM_ID_RES_SCROLLS
$pconsItemID[$PCONS_SKALESOUP] = $ITEM_ID_SKALEFIN_SOUP
$pconsItemID[$PCONS_MOBSTOPPERS] = $ITEM_ID_MOBSTOPPER
$pconsItemID[$PCONS_PANHAI] = $ITEM_ID_PAHNAI_SALAD
$pconsItemID[$PCONS_CITY] = -1


; effects
Global Enum $pconsConsArmor = 1, $pconsConsGrail, $pconsConsEssence, $pconsRedrock, $pconsBluerock, $pconsGreenrock, _
			$pconsPie, $pconsCupcake, $pconsApple, $pconsCorn, $pconsEgg, $pconsKabob, $pconsWarSupply, $pconsLunars, $pconsSkaleSoup, $pconsMobstoppers, $pconsPahnai
Global $pconsEffects[18]
	$pconsEffects[0] = 17
	$pconsEffects[1] = $EFFECT_CONS_ARMOR
	$pconsEffects[2] = $EFFECT_CONS_GRAIL
	$pconsEffects[3] = $EFFECT_CONS_ESSENCE
	$pconsEffects[4] = $EFFECT_REDROCK
	$pconsEffects[5] = $EFFECT_BLUEROCK
	$pconsEffects[6] = $EFFECT_GREENROCK
	$pconsEffects[7] = $EFFECT_PIE
	$pconsEffects[8] = $EFFECT_CUPCAKE
	$pconsEffects[9] = $EFFECT_APPLE
	$pconsEffects[10] = $EFFECT_CORN
	$pconsEffects[11] = $EFFECT_EGG
	$pconsEffects[12] = $EFFECT_KABOBS
	$pconsEffects[13] = $EFFECT_WARSUPPLIES
	$pconsEffects[14] = $EFFECT_LUNARS
	$pconsEffects[15] = $EFFECT_SKALE_VIGOR
	$pconsEffects[16] = $EFFECT_WEAKENED_BY_DHUUM
	$pconsEffects[17] = $EFFECT_PAHNAI_SALAD

Global $pconsCityEffects[5]
	$pconsCityEffects[0] = 4
	$pconsCityEffects[1] = $EFFECT_BLUE_DRINK
	$pconsCityEffects[2] = $EFFECT_CHOCOLATE_BUNNY
	$pconsCityEffects[3] = $EFFECT_CREME_BRULEE
	$pconsCityEffects[4] = $EFFECT_RED_BEAN_CAKE_FRUITCAKE

Global $pconsCityModels[7]
	$pconsCityModels[0] = 6
	$pconsCityModels[1] = $ITEM_ID_SUGARY_BLUE_DRINK
	$pconsCityModels[2] = $ITEM_ID_CHOCOLATE_BUNNY
	$pconsCityModels[3] = $ITEM_ID_FRUITCAKE
	$pconsCityModels[4] = $ITEM_ID_CREME_BRULEE
	$pconsCityModels[5] = $ITEM_ID_RED_BEAN_CAKE
	$pconsCityModels[6] = $ITEM_ID_JAR_OF_HONEY



Func pconsLoadIni()
	$pcons = (IniRead($iniFullPath, $pconsIniSection, "active", 		False) == "True")
	$pconsHotkey = (IniRead($iniFullPath,  $pconsIniSection, "hkActive", 		False) == "True")
	$pconsHotkeyHotkey = IniRead($iniFullPath, $pconsIniSection, "hotkey", "00")
	For $i = 0 To $pconsCount-1
		$pconsActive[$i] = (IniRead($iniFullPath, $pconsIniSection, $pconsName[$i], 	False) == "True")
	Next
EndFunc

Func pconsBuildUI()
	If $pcons Then GUICtrlSetState($CheckboxPCons, $GUI_CHECKED)

	Local $x = 10, $y = 7
	GUICtrlCreateTabItem("Cons")
	GUICtrlCreateGroup("状态", $x, $y, 130, 50)
	Global Const $pconsStatusLabel = GUICtrlCreateLabel("等待...", $x + 10, $y + 15, 110, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetFont(-1, 15)
		GUICtrlSetData($pconsStatusLabel, ($pcons) ? "已开" : "未开")
		GUICtrlSetColor($pconsStatusLabel, ($pcons) ? $COLOR_GREEN : $COLOR_RED)
	Global Const $pconsToggle = MyGuiCtrlCreateButton("切换状态", $x + 139, $y + 9, 100, 40)
		GUICtrlSetOnEvent(-1, "pconsToggleActive")

	GUICtrlCreateGroup("快键:", $x + 248, $y, 130, 50)
	Global Const $pconsHotkeyActive = GUICtrlCreateCheckbox("启用", 258+$x, $y+25, 50, 17)
		GUICtrlSetOnEvent(-1, "pconsHotkeyToggleActive")
		GUICtrlSetFont(-1, 9.5)
		GUICtrlSetTip(-1, "切换补品使用状态")
		If $pconsHotkey Then GUICtrlSetState($pconsHotkeyActive, $GUI_CHECKED)
	Global $pconsHotkeyInput = MyGuiCtrlCreateButton("", $x + 313, $y+21, 57, 22)
		GUICtrlSetOnEvent($pconsHotkeyInput, "setHotkey")
		GUICtrlSetData($pconsHotkeyInput, IniRead($keysIniFullPath, "idToKey", $pconsHotkeyHotkey, ""))

	Global $pconsX = $x + 5
	Global $pconsY = $y + 55

	GUISetFont(10)
	$pconsCheckbox[$PCONS_CONS] = 		GUICtrlCreateCheckbox("", $pconsX, $pconsY, 190, 18)
		GUICtrlSetTip($pconsCheckbox[$PCONS_CONS], "注意:" & @CRLF & "当全队进入区域后(+未死时)即开药," & @CRLF & "60秒内全队须俱在雷达距内" & @CRLF & "请确认工具可正确识别队伍大小")


	$pconsCheckbox[$PCONS_RRC] = 			GUICtrlCreateCheckbox("", $pconsX, 	$pconsY+20, 190, 18)
	$pconsCheckbox[$PCONS_BRC] = 		GUICtrlCreateCheckbox("", $pconsX, 	$pconsY+40, 190, 18)
	$pconsCheckbox[$PCONS_GRC] = 		GUICtrlCreateCheckbox("", $pconsX, 	$pconsY+60, 190, 18)
	$pconsCheckbox[$PCONS_ALCOHOL] = 	GUICtrlCreateCheckbox("", $pconsX,	$pconsY+80, 190, 18)
		GUICtrlSetTip($pconsCheckbox[$PCONS_ALCOHOL], "此工具可用大部分种类的酒" & @CRLF & "用酒时将使用包内最先遇到的酒" & "一分酒首次使用时将连续用两瓶")
	$pconsCheckbox[$PCONS_PIE] = 		GUICtrlCreateCheckbox("", $pconsX, 	$pconsY+100,190, 18)
	$pconsCheckbox[$PCONS_CUPCAKE] = 	GUICtrlCreateCheckbox("", $pconsX, 	$pconsY+120,190, 18)
	$pconsCheckbox[$PCONS_SKALESOUP] = 	GUICtrlCreateCheckbox("", $pconsX, 	$pconsY+140,190, 18)
		GUICtrlSetTip($pconsCheckbox[$PCONS_SKALESOUP], "活力再生+1, 有效期10分钟")
	$pconsCheckbox[$PCONS_PANHAI] = 	GUICtrlCreateCheckbox("", $pconsX,	$pconsY+160,190, 18)
		GUICtrlSetTip($pconsCheckbox[$PCONS_PANHAI], "活力最高值+20, 有效期10分钟")
	$pconsX = 215
	$pconsCheckbox[$PCONS_APPLE] = 		GUICtrlCreateCheckbox("", $pconsX, 	$pconsY, 	190, 18)
	$pconsCheckbox[$PCONS_CORN] = 		GUICtrlCreateCheckbox("", $pconsX, 	$pconsY+20, 190, 18)
	$pconsCheckbox[$PCONS_EGG] = 		GUICtrlCreateCheckbox("", $pconsX, 	$pconsY+40, 190, 18)
	$pconsCheckbox[$PCONS_KABOB] = 		GUICtrlCreateCheckbox("", $pconsX, 	$pconsY+60, 190, 18)
		GUICtrlSetTip(-1, "防护+5，有效期5分钟")
	$pconsCheckbox[$PCONS_WARSUPPLY] = 	GUICtrlCreateCheckbox("", $pconsX, 	$pconsY+80, 190, 18)
	$pconsCheckbox[$PCONS_LUNARS] = 	GUICtrlCreateCheckbox("", $pconsX, 	$pconsY+100,190, 18)
		GUICtrlSetTip(-1, "工具将持续使用锦囊， 直到获得正确的效果")
	$pconsCheckbox[$PCONS_RES] = 		GUICtrlCreateCheckbox("", $pconsX,	$pconsY+120,190, 18)
		GUICtrlSetTip(-1, "每当周围有死去的队友， 工具将使用复活卷")
	$pconsCheckbox[$PCONS_MOBSTOPPERS] =GUICtrlCreateCheckbox("", $pconsX, 	$pconsY+140,190, 18)
		GUICtrlSetTip(-1, "每当周围存有活着的， 被瞄准的， 血在25%一下的骷髅， 工具将使用骷髅笼")
	$pconsCheckbox[$PCONS_CITY] = GUICtrlCreateCheckbox("", $pconsX,	$pconsY+160,190, 18)
		GUICtrlSetTip(-1, "用城内糖果/甜点(蓝汽水，巧克力兔，水果蛋糕等)") ;+Creme Brulee, Red Bean Cake or Jar of Honey
		For $i = 0 To $pconsCount-1
			If $pconsActive[$i] Then GUICtrlSetState($pconsCheckbox[$i], $GUI_CHECKED)
			GUICtrlSetOnEvent($pconsCheckbox[$i], "pconsToggle")
		Next
	GUISetFont(8.5)

	Global Const $pconsPresetList = GUICtrlCreateCombo("", $x, $y + 234, 125, 20, $CBS_DROPDOWNLIST)
	Global Const $pconsPresetDefault = "选择设置文件"
		GUICtrlSetColor(-1, $COLOR_WHITE)
		GUICtrlSetBkColor(-1, $COLOR_BLACK)
		GUICtrlSetOnEvent(-1, "presetLoad")
		SetPresetCombo($pconsPresetList, $pconsPresetDefault)

	Global Const $pconsPresetNew = MyGuiCtrlCreateButton("储存...", $x + 135, $y + 235, 75, 22)
		GUICtrlSetOnEvent(-1, "presetSave")

	Global Const $pconsPresetDelete = MyGuiCtrlCreateButton("删除...", $x + 220, $y + 235, 75, 22)
		GUICtrlSetOnEvent(-1, "presetDelete")

	Global Const $pconsScan = MyGuiCtrlCreateButton("重新统计", $x + 305, $y + 235, 75, 22)
		GUICtrlSetTip(-1, "重新统计补品数量")
		GUICtrlSetOnEvent(-1, "pconsScanInventory")
EndFunc


Local $pressedPcons = False

; timers for the pcons (prevent more than 1 pcon being used every time)
Local $pconsTimer[$pconsCount]
For $i = 0 To $pconsCount-1
	$pconsTimer[$i] = TimerInit()
Next
Local $currentLoadingState, $currentMap

; Variables that needs to be recomputed everytime
Local $pconsRetArray = GetHasEffects($pconsEffects)
Local $pconsRetArrayVerify = GetHasEffects($pconsEffects)
For $i=1 To $pconsRetArray[0]
	$pconsRetArray[$i] = _Max($pconsRetArray[$i], $pconsRetArrayVerify[$i])
Next

Local $pconsCityRetArray = GetHasEffects($pconsCityEffects)
Local $pconsCityRetArrayVerify = GetHasEffects($pconsCityEffects)
For $i=1 To $pconsCityRetArray[0]
	$pconsCityRetArray[$i] = _Max($pconsCityRetArray[$i], $pconsCityRetArrayVerify[$i])
Next

Func pconsMainLoop($hDLL, Const ByRef $lMe, Const ByRef $lTgt, Const ByRef $lParty)
	Local $pressed

	If $pconsHotkey Then
		$pressed = _IsPressed($pconsHotkeyHotkey, $hDLL)
		If (Not $pressedPcons) And $pressed Then
			$pressedPcons = True
			pconsToggleActive()
			WriteChat("补品功能已 " & ($pcons ? "开" : "关"), $GWToolbox)
		ElseIf $pressedPcons And (Not $pressed) Then
			$pressedPcons = False
		EndIf
	EndIf

	; maploading for alcohol
	If GetMapLoading() <> $currentLoadingState Then
		$currentLoadingState = GetMapLoading()
		If $currentLoadingState == $INSTANCETYPE_EXPLORABLE Or $currentLoadingState == $INSTANCETYPE_OUTPOST Then
			$currentMap = GetMapID()
			pconsScanInventory()
			$AlcoholUsageCount = 0
		EndIf
	ElseIf GetMapID() <> $currentMap Then
		$currentMap = GetMapID()
		pconsScanInventory()
		$AlcoholUsageCount = 0
	EndIf

	If GetAlcoholTimeRemaining() < 0 Then
		$AlcoholUsageTimer = TimerInit()
		$AlcoholUsageCount = 0
	EndIf

	; get stuff
	If ($pcons) Then
		Switch GetMapLoading()
			Case $INSTANCETYPE_EXPLORABLE
				$pconsRetArray = GetHasEffects($pconsEffects)
				$pconsRetArrayVerify = GetHasEffects($pconsEffects)
				For $i=1 To $pconsRetArray[0]
					$pconsRetArray[$i] = _Max($pconsRetArray[$i], $pconsRetArrayVerify[$i])
				Next

			Case $INSTANCETYPE_OUTPOST
				$pconsCityRetArray = GetHasEffects($pconsCityEffects)
				$pconsCityRetArrayVerify = GetHasEffects($pconsCityEffects)
				For $i=1 To $pconsCityRetArray[0]
					$pconsCityRetArray[$i] = _Max($pconsCityRetArray[$i], $pconsCityRetArrayVerify[$i])
				Next
		EndSwitch
	EndIf

	If $pcons Then
		If GetMapLoading()==$INSTANCETYPE_EXPLORABLE And (Not GetIsDead(-2)) And (DllStructGetData($lMe, "HP")>0) Then

			#region cons
			If $pconsActive[$PCONS_CONS] And GetInstanceUptime() < (60*1000) Then
				If $pconsRetArray[$pconsConsEssence] < 1000 And $pconsRetArray[$pconsConsArmor] < 1000 And $pconsRetArray[$pconsConsGrail] < 1000 Then
					If TimerDiff($pconsTimer[$PCONS_CONS]) > 5000 Then				; if timer isnt bad
						Local $lSize = GetPartySize()
						If $lSize > 0 And $lParty[0] == $lSize Then ; if the whole party is in range (and loaded)
							Local $everybodyAliveAndLoaded = True
							For $i=1 To $lParty[0] Step 1
								If DllStructGetData($lParty[$i], "HP") <= 0 Then		; check if everyone is alive
									$everybodyAliveAndLoaded = False
									ExitLoop
								EndIf
							Next
							If $everybodyAliveAndLoaded Then
								If UseItemByModelID($ITEM_ID_CONS_ESSENCE) And UseItemByModelID($ITEM_ID_CONS_GRAIL) And UseItemByModelID($ITEM_ID_CONS_ARMOR) Then
									$pconsTimer[$PCONS_CONS] = TimerInit()
								Else
									pconsScanInventory()
									If Not $pconsActive[$PCONS_CONS] Then WriteChat("[提示] 药已尽", $GWToolbox)
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			#endregion
			#region alcohol
			If $pconsActive[$PCONS_ALCOHOL] Then
				If GetAlcoholTimeRemaining() <= 60 Then
					If TimerDiff($pconsTimer[$PCONS_ALCOHOL]) > 5000 Then
						$AlcoholUsageCount += UseAlcohol()
						If GetAlcoholTimeRemaining() > 60 Then
							$pconsTimer[$PCONS_ALCOHOL] = TimerInit()
						Else
							pconsScanInventory()
							If Not $pconsActive[$PCONS_ALCOHOL] Then WriteChat("[提示] 酒已尽", $GWToolbox)
						EndIf
					EndIf
				EndIf
			EndIf
			#endregion
			#region Redrocks
			If $pconsActive[$PCONS_RRC] Then
				If $pconsRetArray[$pconsRedrock] < 1000 Then
					If TimerDiff($pconsTimer[$PCONS_RRC]) > 5000 Then
						If UseItemByModelID($pconsItemID[$PCONS_RRC]) Then
							$pconsTimer[$PCONS_RRC] = TimerInit()
						Else
							pconsScanInventory()
							If Not $pconsActive[$PCONS_RRC] Then WriteChat("[提示] 红糖已尽", $GWToolbox)
						EndIf
					EndIf
				EndIf
			EndIf
			#endregion
			#region Bluerock
			If $pconsActive[$PCONS_BRC] Then
				If $pconsRetArray[$pconsBluerock] < 1000 Then
					If TimerDiff($pconsTimer[$PCONS_BRC]) > 5000 Then
						If UseItemByModelID($pconsItemID[$PCONS_BRC]) Then
							$pconsTimer[$PCONS_BRC] = TimerInit()
						Else
							pconsScanInventory()
							If Not $pconsActive[$PCONS_BRC] Then WriteChat("[提示] 蓝糖已尽", $GWToolbox)
						EndIf
					EndIf
				EndIf
			EndIf
			#endregion
			#region Greenrock
			If $pconsActive[$PCONS_GRC] Then
				If $pconsRetArray[$pconsGreenrock] < 1000 Then
					If TimerDiff($pconsTimer[$PCONS_GRC]) > 5000 Then
						If UseItemByModelID($pconsItemID[$PCONS_GRC]) Then
							$pconsTimer[$PCONS_GRC] = TimerInit()
						Else
							pconsScanInventory()
							If Not $pconsActive[$PCONS_GRC] Then WriteChat("[提示] 绿糖已尽", $GWToolbox)
						EndIf
					EndIf
				EndIf
			EndIf
			#endregion
			#region pie
			If $pconsActive[$PCONS_PIE] Then
				If $pconsRetArray[$pconsPie] < 1000 Then
					If TimerDiff($pconsTimer[$PCONS_PIE]) > 5000 Then
						If UseItemByModelID($pconsItemID[$PCONS_PIE]) Then
							$pconsTimer[$PCONS_PIE] = TimerInit()
						Else
							pconsScanInventory()
							If Not $pconsActive[$PCONS_PIE] Then WriteChat("[提示] 南瓜派已尽", $GWToolbox)
						EndIf
					EndIf
				EndIf
			EndIf
			#endregion
			#region cupcakes
			If $pconsActive[$PCONS_CUPCAKE] Then
				If $pconsRetArray[$pconsCupcake] < 1000 Then
					If TimerDiff($pconsTimer[$PCONS_CUPCAKE]) > 5000 Then
						If UseItemByModelID($pconsItemID[$PCONS_CUPCAKE]) Then
							$pconsTimer[$PCONS_CUPCAKE] = TimerInit()
						Else
							pconsScanInventory()
							If Not $pconsActive[$PCONS_CUPCAKE] Then WriteChat("[提示] 蛋糕已尽", $GWToolbox)
						EndIf
					EndIf
				EndIf
			EndIf
			#endregion
			#region apples
			If $pconsActive[$PCONS_APPLE] Then
				If $pconsRetArray[$pconsApple] < 1000 Then
					If TimerDiff($pconsTimer[$PCONS_APPLE]) > 5000 Then
						If UseItemByModelID($pconsItemID[$PCONS_APPLE]) Then
							$pconsTimer[$PCONS_APPLE] = TimerInit()
						Else
							pconsScanInventory()
							If Not $pconsActive[$PCONS_APPLE] Then WriteChat("[提示] 苹果已尽", $GWToolbox)
						EndIf
					EndIf
				EndIf
			EndIf
			#endregion
			#region corn
			If $pconsActive[$PCONS_CORN] Then
				If $pconsRetArray[$pconsCorn] < 1000 Then
					If TimerDiff($pconsTimer[$PCONS_CORN]) > 5000 Then
						If UseItemByModelID($pconsItemID[$PCONS_CORN]) Then
							$pconsTimer[$PCONS_CORN] = TimerInit()
						Else
							pconsScanInventory()
							If Not $pconsActive[$PCONS_CORN] Then WriteChat("[提示] 粟米糖已尽", $GWToolbox)
						EndIf
					EndIf
				EndIf
			EndIf
			#endregion
			#region egg
			If $pconsActive[$PCONS_EGG] Then
				If $pconsRetArray[$pconsEgg] < 1000 Then
					If TimerDiff($pconsTimer[$PCONS_EGG]) > 5000 Then
						If UseItemByModelID($pconsItemID[$PCONS_EGG]) Then
							$pconsTimer[$PCONS_EGG] = TimerInit()
						Else
							pconsScanInventory()
							If Not $pconsActive[$PCONS_EGG] Then WriteChat("[提示] 金蛋已尽", $GWToolbox)
						EndIf
					EndIf
				EndIf
			EndIf
			#endregion
			#region kabobs
			If $pconsActive[$PCONS_KABOB] Then
				If $pconsRetArray[$pconsKabob] < 1000 Then
					If TimerDiff($pconsTimer[$PCONS_KABOB]) > 5000 Then
						If UseItemByModelID($pconsItemID[$PCONS_KABOB]) Then
							$pconsTimer[$PCONS_KABOB] = TimerInit()
						Else
							pconsScanInventory()
							If Not $pconsActive[$PCONS_KABOB] Then WriteChat("[提示] 烤龙兽肉已尽", $GWToolbox)
						EndIf
					EndIf
				EndIf
			EndIf
			#endregion
			#region warsupplies
			If $pconsActive[$PCONS_WARSUPPLY] Then
				If $pconsRetArray[$pconsWarSupply] < 1000 Then
					If TimerDiff($pconsTimer[$PCONS_WARSUPPLY]) > 5000 Then
						If UseItemByModelID($pconsItemID[$PCONS_WARSUPPLY]) Then
							$pconsTimer[$PCONS_WARSUPPLY] = TimerInit()
						Else
							pconsScanInventory()
							If Not $pconsActive[$PCONS_WARSUPPLY] Then WriteChat("[提示] 战承物资已尽", $GWToolbox)
						EndIf
					EndIf
				EndIf
			EndIf
			#endregion
			#region lunars
			If $pconsActive[$PCONS_LUNARS] Then
				If $pconsRetArray[$pconsLunars] == 0 Then
					If TimerDiff($pconsTimer[$PCONS_LUNARS]) > GetPing()+500 Then
						If UseItemByModelID($ITEM_ID_LUNARS_DRAGON) Then
							$pconsTimer[$PCONS_LUNARS] = TimerInit()
						ElseIf UseItemByModelID($ITEM_ID_LUNARS_SNAKE) Then
							$pconsTimer[$PCONS_LUNARS] = TimerInit()
						ElseIf UseItemByModelID($ITEM_ID_LUNARS_HORSE) Then
							$pconsTimer[$PCONS_LUNARS] = TimerInit()
						ElseIf UseItemByModelID($ITEM_ID_LUNARS_RABBIT) Then
							$pconsTimer[$PCONS_LUNARS] = TimerInit()
						ElseIf UseItemByModelID($ITEM_ID_LUNARS_SHEEP) Then
							$pconsTimer[$PCONS_LUNARS] = TimerInit()
						ElseIf UseItemByModelID($ITEM_ID_LUNARS_RAT) Then
							$pconsTimer[$PCONS_LUNARS] = TimerInit()
						ElseIf UseItemByModelID($ITEM_ID_LUNARS_OX) Then
							$pconsTimer[$PCONS_LUNARS] = TimerInit()
						ElseIf UseItemByModelID($ITEM_ID_LUNARS_TIGER) Then
							$pconsTimer[$PCONS_LUNARS] = TimerInit()
						ElseIf UseItemByModelID($ITEM_ID_LUNARS_MONKEY) Then
							$pconsTimer[$PCONS_LUNARS] = TimerInit()
						ElseIf UseItemByModelID($ITEM_ID_LUNARS_ROOSTER) Then
							$pconsTimer[$PCONS_LUNARS] = TimerInit()
						ElseIf UseItemByModelID($ITEM_ID_LUNARS_DOG) Then
							$pconsTimer[$PCONS_LUNARS] = TimerInit()
						ElseIf UseItemByModelID($ITEM_ID_LUNARS_PIG_2) Then
							$pconsTimer[$PCONS_LUNARS] = TimerInit()
						ElseIf UseItemByModelID($ITEM_ID_LUNARS_PIG) Then
							$pconsTimer[$PCONS_LUNARS] = TimerInit()
						Else
							pconsScanInventory()
							If Not $pconsActive[$PCONS_LUNARS] Then WriteChat("[提示] 锦囊已尽", $GWToolbox)
						EndIf
					EndIf
				EndIf
			EndIf
			#endregion
			#region res
			If $pconsActive[$PCONS_RES] Then
				If TimerDiff($pconsTimer[$PCONS_RES]) > 250 Then
					For $i=1 To $lParty[0]
						If GetIsDead($lParty[$i]) Then
							If GetDistance($lParty[$i], -2) < $RANGE_EARSHOT Then
								If UseItemByModelID($pconsItemID[$PCONS_RES]) Then
									$pconsTimer[$PCONS_RES] = TimerInit()
								Else
									pconsScanInventory()
									If Not $pconsActive[$PCONS_RES] Then WriteChat("[提示] 复活卷已尽", $GWToolbox)
								EndIf
								ExitLoop
							EndIf
						EndIf
					Next
				EndIf
			EndIf
			#endregion
			#region skalesoup
			If $pconsActive[$PCONS_SKALESOUP] Then
				If $pconsRetArray[$pconsSkaleSoup] < 1000 Then
					If TimerDiff($pconsTimer[$PCONS_SKALESOUP]) > 5000 Then
						If UseItemByModelID($pconsItemID[$PCONS_SKALESOUP]) Then
							$pconsTimer[$PCONS_SKALESOUP] = TimerInit()
						Else
							pconsScanInventory()
							If Not $pconsActive[$PCONS_SKALESOUP] Then WriteChat("[提示] 鳞怪鳍汤已尽", $GWToolbox)
						EndIf
					EndIf
				EndIf
			EndIf
			#endregion
			#region Mobstoppers
			If $pconsActive[$PCONS_MOBSTOPPERS] Then
				If DllStructGetData($lTgt, "PlayerNumber") == $MODELID_SKELETON_OF_DHUUM Then
					If DllStructGetData($lTgt, "HP") > 0 And DllStructGetData($lTgt, "HP") < 0.25 Then
						If GetDistance($lMe, $lTgt) < 400 Then
							If $pconsRetArray[$pconsMobstoppers] == 0 Then
								If TimerDiff($pconsTimer[$PCONS_MOBSTOPPERS]) > 5000 Then
									If UseItemByModelID($pconsItemID[$PCONS_MOBSTOPPERS]) Then
										$pconsTimer[$PCONS_MOBSTOPPERS] = TimerInit()
									Else
										pconsScanInventory()
										If Not $pconsActive[$PCONS_MOBSTOPPERS] Then WriteChat("[提示] 骷髅笼已尽", $GWToolbox)
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			#endregion
			#region Pahnai salad
			If $pconsActive[$PCONS_PANHAI] Then
				If $pconsRetArray[$pconsPahnai] < 1000 Then
					If TimerDiff($pconsTimer[$PCONS_PANHAI]) > 5000 Then
						If UseItemByModelID($pconsItemID[$PCONS_PANHAI]) Then
							$pconsTimer[$PCONS_PANHAI] = TimerInit()
						Else
							pconsScanInventory()
							If Not $pconsActive[$PCONS_PANHAI] Then WriteChat("[提示] 伊波枷沙拉已尽", $GWToolbox)
						EndIf
					EndIf
				EndIf
			EndIf
			#endregion
		EndIf
		If GetMapLoading()==$INSTANCETYPE_OUTPOST Then
			#region City Speedboost
			If $pconsActive[$PCONS_CITY] Then
				If DllStructGetData($lMe, "MoveX") > 0 Or DllStructGetData($lMe, "MoveX") Then

					Local $lShouldUse = True
					For $i=1 To $pconsCityRetArray[0]
						If $pconsCityRetArray[$i] > 1000 Then $lShouldUse = False
					Next

					If $lShouldUse Then
						If TimerDiff($pconsTimer[$PCONS_CITY]) > 5000 Then

							Local $lUsed = False
							For $i=1 To $pconsCityModels[0]
								If UseItemByModelID($pconsCityModels[$i]) Then
									$lUsed = True
									$pconsTimer[$PCONS_CITY] = TimerInit()
									ExitLoop
								EndIf
							Next

							If Not $lUsed Then
								pconsScanInventory()
								If Not $pconsActive[$PCONS_CITY] Then WriteChat("[提示] 城内糖果已尽", $GWToolbox)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			#endregion
		EndIf
	EndIf
EndFunc


Func GetAlcoholTimeRemaining()
	Return Round(60*$AlcoholUsageCount - TimerDiff($AlcoholUsageTimer)/1000)
EndFunc

Func UseAlcohol()
	Local $lItem
	For $lBag=1 To 4
		For $lSlot=1 To DllStructGetData(GetBag($lBag), 'Slots')
			$lItem = GetItemBySlot($lBag, $lSlot)
			For $i=1 To $ITEM_ID_ALCOHOL_1[0]
				If DllStructGetData($lItem, "ModelID") == $ITEM_ID_ALCOHOL_1[$i] Then
					SendPacket(0x8, $UseItemHeader, DllStructGetData($lItem, "ID"))
					Return 1
				EndIf
			Next
			For $i=1 To $ITEM_ID_ALCOHOL_5[0]
				If DllStructGetData($lItem, "ModelID") == $ITEM_ID_ALCOHOL_5[$i] Then
					SendPacket(0x8, $UseItemHeader, DllStructGetData($lItem, "ID"))
					Return 4
				EndIf
			Next
		Next
	Next
	Return 0
EndFunc

Func pconsToggleActive()
	$pcons = Not $pcons

	IniWrite($iniFullPath, $pconsIniSection, "active", $pcons)
	GUICtrlSetData($pconsStatusLabel, $pcons ? "已开" : "已关")
	GUICtrlSetColor($pconsStatusLabel, $pcons ? $COLOR_GREEN : $COLOR_RED)
	GUICtrlSetState($CheckboxPCons, $pcons ? $GUI_CHECKED : $GUI_UNCHECKED)

	If ($pcons) Then
		Switch GetMapLoading()
			Case $INSTANCETYPE_EXPLORABLE
				$pconsRetArray = GetHasEffects($pconsEffects)
				$pconsRetArrayVerify = GetHasEffects($pconsEffects)
				For $i=1 To $pconsRetArray[0]
					$pconsRetArray[$i] = _Max($pconsRetArray[$i], $pconsRetArrayVerify[$i])
				Next

			Case $INSTANCETYPE_OUTPOST
				$pconsCityRetArray = GetHasEffects($pconsCityEffects)
				$pconsCityRetArrayVerify = GetHasEffects($pconsCityEffects)
				For $i=1 To $pconsCityRetArray[0]
					$pconsCityRetArray[$i] = _Max($pconsCityRetArray[$i], $pconsCityRetArrayVerify[$i])
				Next
		EndSwitch
	EndIf
EndFunc

Func pconsToggle()
	Local $aState = GUICtrlRead(@GUI_CtrlId) == $GUI_CHECKED
	Switch @GUI_CtrlId
		Case $pconsCheckbox[$PCONS_CONS]
			If $aState Then
				If pconsFind($ITEM_ID_CONS_ESSENCE) And pconsFind($ITEM_ID_CONS_ARMOR) And pconsFind($ITEM_ID_CONS_GRAIL) Then
					$pconsActive[$PCONS_CONS] = True
					IniWrite($iniFullPath, $pconsIniSection, $pconsName[$PCONS_CONS], True)
				Else
					GUICtrlSetState(@GUI_CtrlId, $GUI_UNCHECKED)
				EndIf
			Else
				$pconsActive[$PCONS_CONS] = False
				IniWrite($iniFullPath, $pconsIniSection, $pconsName[$PCONS_CONS], False)
			EndIf
		Case $pconsCheckbox[$PCONS_ALCOHOL]
			If $aState Then
				Local $lFound = False
				For $i=1 To $ITEM_ID_ALCOHOL_1[0]
					If pconsFind($ITEM_ID_ALCOHOL_1[$i]) Then
						$lFound = True
						ExitLoop
					EndIf
				Next
				If Not $lFound Then
					For $i=1 To $ITEM_ID_ALCOHOL_5[0]
						If pconsFind($ITEM_ID_ALCOHOL_5[$i]) Then
							$lFound = True
							ExitLoop
						EndIf
					Next
				EndIf
				If $lFound Then
					$pconsActive[$PCONS_ALCOHOL] = True
					IniWrite($iniFullPath, $pconsIniSection, $pconsName[$PCONS_ALCOHOL], True)
				Else
					GUICtrlSetState(@GUI_CtrlId, $GUI_UNCHECKED)
				EndIf
			Else
				$pconsActive[$PCONS_ALCOHOL] = False
				IniWrite($iniFullPath, $pconsIniSection, $pconsName[$PCONS_ALCOHOL], False)
			EndIf
		Case $pconsCheckbox[$PCONS_LUNARS]
			If $aState Then
				If pconsFind($ITEM_ID_LUNARS_RAT) Or pconsFind($ITEM_ID_LUNARS_OX) Or _
					pconsFind($ITEM_ID_LUNARS_TIGER) Or pconsFind($ITEM_ID_LUNARS_MONKEY) Or _
					pconsFind($ITEM_ID_LUNARS_DRAGON) Or pconsFind($ITEM_ID_LUNARS_SNAKE) Or _
					pconsFind($ITEM_ID_LUNARS_HORSE) Or pconsFind($ITEM_ID_LUNARS_RABBIT) Or _
					pconsFind($ITEM_ID_LUNARS_SHEEP) or pconsFind($ITEM_ID_LUNARS_PIG) or _
					pconsFind($ITEM_ID_LUNARS_ROOSTER) or pconsFind($ITEM_ID_LUNARS_DOG) or _
					pconsFind($ITEM_ID_LUNARS_PIG_2) Then
					$pconsActive[$PCONS_LUNARS] = True
					IniWrite($iniFullPath, $pconsIniSection, $pconsName[$PCONS_LUNARS], True)
				Else
					GUICtrlSetState(@GUI_CtrlId, $GUI_UNCHECKED)
				EndIf
			Else
				$pconsActive[$PCONS_LUNARS] = False
				IniWrite($iniFullPath, $pconsIniSection, $pconsName[$PCONS_LUNARS], False)
			EndIf
		Case $pconsCheckbox[$PCONS_CITY]
			If $aState Then
				Local $lFound = False
				For $i=1 To $pconsCityModels[0]
					If pconsFind($pconsCityModels[$i]) Then
						$lFound = True
						ExitLoop
					EndIf
				Next
				If $lFound Then
					$pconsActive[$PCONS_CITY] = True
					IniWrite($iniFullPath, $pconsIniSection, $pconsName[$PCONS_CITY], True)
				Else
					GUICtrlSetState(@GUI_CtrlId, $GUI_UNCHECKED)
				EndIf
			Else
				$pconsActive[$PCONS_CITY] = False
				IniWrite($iniFullPath, $pconsIniSection, $pconsName[$PCONS_CITY], False)
			EndIf
		Case Else
			For $i = 0 To $pconsCount-1
				If @GUI_CtrlId == $pconsCheckbox[$i] Then
					If $aState Then
						If pconsFind($pconsItemID[$i]) Then
							IniWrite($iniFullPath, $pconsIniSection, $pconsName[$i], True)
							If GUICtrlRead($pconsCheckbox[$i]) == $GUI_UNCHECKED Then GUICtrlSetState($pconsCheckbox[$i], $GUI_CHECKED)
							$pconsActive[$i] = True
						Else
							If GUICtrlRead($pconsCheckbox[$i]) == $GUI_CHECKED Then GUICtrlSetState($pconsCheckbox[$i], $GUI_UNCHECKED)
							$pconsActive[$i] = False
						EndIf
					Else
						IniWrite($iniFullPath, $pconsIniSection, $pconsName[$i], False)
						If GUICtrlRead($pconsCheckbox[$i]) == $GUI_CHECKED Then GUICtrlSetState($pconsCheckbox[$i], $GUI_UNCHECKED)
						$pconsActive[$i] = False
					EndIf
					ExitLoop
				EndIf
			Next
	EndSwitch
EndFunc

Func pconsFind($aModelID)
	For $lBag=1 To 4
		For $lSlot=1 To DllStructGetData(GetBag($lBag), 'Slots')
			If DllStructGetData(GetItemBySlot($lBag, $lSlot), "ModelID") == $aModelID Then
				Return True
			EndIf
		Next
	Next
	Return False
EndFunc

Func pconsScanInventory()
	Local $lPconsQuantity[$pconsCount]
	For $i = 0 To $pconsCount-1
		$lPconsQuantity[$i] = 0
	Next
	Local $lConsEssence=0, $lConsGrail=0, $lConsArmor=0
	Local $lItem, $lQuantity, $lItemID
	For $lBag=1 To 4 Step 1
		For $lSlot = 1 To DllStructGetData(GetBag($lBag), 'Slots')
			$lItem = GetItemBySlot($lBag, $lSlot)
			$lQuantity = DllStructGetData($lItem, "Quantity")
			$lItemID = DllStructGetData($lItem, "ModelID")
			Switch $lItemID
				Case 0
					ContinueLoop
				Case $ITEM_ID_CONS_ESSENCE
					$lConsEssence += $lQuantity
				Case $ITEM_ID_CONS_GRAIL
					$lConsGrail += $lQuantity
				Case $ITEM_ID_CONS_ARMOR
					$lConsArmor += $lQuantity
				Case $ITEM_ID_ALCOHOL_1[1], $ITEM_ID_ALCOHOL_1[2], $ITEM_ID_ALCOHOL_1[3], $ITEM_ID_ALCOHOL_1[4], $ITEM_ID_ALCOHOL_1[5], $ITEM_ID_ALCOHOL_1[6], $ITEM_ID_ALCOHOL_1[7], $ITEM_ID_ALCOHOL_1[8]
					$lPconsQuantity[$PCONS_ALCOHOL] += $lQuantity
				Case $ITEM_ID_ALCOHOL_5[1], $ITEM_ID_ALCOHOL_5[2], $ITEM_ID_ALCOHOL_5[3], $ITEM_ID_ALCOHOL_5[4], $ITEM_ID_ALCOHOL_5[5], $ITEM_ID_ALCOHOL_5[6], $ITEM_ID_ALCOHOL_5[7]
					$lPconsQuantity[$PCONS_ALCOHOL] += 5*$lQuantity
				Case $ITEM_ID_LUNARS_DRAGON, $ITEM_ID_LUNARS_SNAKE, $ITEM_ID_LUNARS_HORSE, $ITEM_ID_LUNARS_RABBIT, $ITEM_ID_LUNARS_SHEEP, $ITEM_ID_LUNARS_RAT, $ITEM_ID_LUNARS_OX, $ITEM_ID_LUNARS_TIGER, $ITEM_ID_LUNARS_MONKEY, $ITEM_ID_LUNARS_PIG, $ITEM_ID_LUNARS_ROOSTER, $ITEM_ID_LUNARS_DOG, $ITEM_ID_LUNARS_PIG_2
					$lPconsQuantity[$PCONS_LUNARS] += $lQuantity
				Case $pconsCityModels[1], $pconsCityModels[2], $pconsCityModels[3], $pconsCityModels[4], $pconsCityModels[5]
					$lPconsQuantity[$PCONS_CITY] += $lQuantity
				Case Else
					For $i = 0 To $pconsCount-1
						If $lItemID > 0 And $lItemID == $pconsItemID[$i] Then
							$lPconsQuantity[$i] += $lQuantity
							ExitLoop
						EndIf
					Next
			EndSwitch
		Next
	Next
	$lPconsQuantity[$PCONS_CONS] = _Min($lConsEssence, _Min($lConsArmor, $lConsGrail))
	For $i = 0 To $pconsCount-1
		$pconsActive[$i] = $pconsActive[$i] And $lPconsQuantity[$i] > 0
		GUICtrlSetState($pconsCheckbox[$i], $pconsActive[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
		Switch $i
			Case $PCONS_CONS, $PCONS_RRC, $PCONS_RES, $PCONS_MOBSTOPPERS
				pconsSetColor($i, $lPconsQuantity[$i], 5)
			Case $PCONS_BRC, $PCONS_PIE, $PCONS_CUPCAKE, $PCONS_APPLE, $PCONS_CORN, $PCONS_KABOB, $PCONS_SKALESOUP, $PCONS_PANHAI
				pconsSetColor($i, $lPconsQuantity[$i], 10)
			Case $PCONS_GRC
				pconsSetColor($i, $lPconsQuantity[$i], 15)
			Case $PCONS_EGG, $PCONS_WARSUPPLY, $PCONS_CITY
				pconsSetColor($i, $lPconsQuantity[$i], 20)
			Case $PCONS_ALCOHOL, $PCONS_LUNARS
				pconsSetColor($i, $lPconsQuantity[$i], 30)
		EndSwitch
	Next

	GUICtrlSetData($pconsCheckbox[$PCONS_CONS], "("&$lPconsQuantity[$PCONS_CONS]&") 药")
	GUICtrlSetData($pconsCheckbox[$PCONS_RRC], "("&$lPconsQuantity[$PCONS_RRC]&") 红糖")
	GUICtrlSetData($pconsCheckbox[$PCONS_BRC], "("&$lPconsQuantity[$PCONS_BRC]&") 蓝糖")
	GUICtrlSetData($pconsCheckbox[$PCONS_GRC], "("&$lPconsQuantity[$PCONS_GRC]&") 绿糖")
	GUICtrlSetData($pconsCheckbox[$PCONS_ALCOHOL], "("&$lPconsQuantity[$PCONS_ALCOHOL]&" 分钟) 酒")
	GUICtrlSetData($pconsCheckbox[$PCONS_PIE], "("&$lPconsQuantity[$PCONS_PIE]&") 南瓜派")
	GUICtrlSetData($pconsCheckbox[$PCONS_CUPCAKE], "("&$lPconsQuantity[$PCONS_CUPCAKE]&") 蛋糕")
	GUICtrlSetData($pconsCheckbox[$PCONS_APPLE], "("&$lPconsQuantity[$PCONS_APPLE]&") 苹果")
	GUICtrlSetData($pconsCheckbox[$PCONS_CORN], "("&$lPconsQuantity[$PCONS_CORN]&") 米糖")
	GUICtrlSetData($pconsCheckbox[$PCONS_EGG], "("&$lPconsQuantity[$PCONS_EGG]&") 鸡蛋")
	GUICtrlSetData($pconsCheckbox[$PCONS_KABOB], "("&$lPconsQuantity[$PCONS_KABOB]&") 烤龙兽肉")
	GUICtrlSetData($pconsCheckbox[$PCONS_WARSUPPLY], "("&$lPconsQuantity[$PCONS_WARSUPPLY]&") 战承物资")
	GUICtrlSetData($pconsCheckbox[$PCONS_LUNARS], "("&$lPconsQuantity[$PCONS_LUNARS]&") 锦囊")
	GUICtrlSetData($pconsCheckbox[$PCONS_RES], "("&$lPconsQuantity[$PCONS_RES]&") 复活卷")
	GUICtrlSetData($pconsCheckbox[$PCONS_SKALESOUP], "("&$lPconsQuantity[$PCONS_SKALESOUP]&") 鳞怪鳍汤")
	GUICtrlSetData($pconsCheckbox[$PCONS_MOBSTOPPERS], "("&$lPconsQuantity[$PCONS_MOBSTOPPERS]&") 骷髅笼")
	GUICtrlSetData($pconsCheckbox[$PCONS_PANHAI], "("&$lPconsQuantity[$PCONS_PANHAI]&") 伊波枷沙拉")
	GUICtrlSetData($pconsCheckbox[$PCONS_CITY], "("&$lPconsQuantity[$PCONS_CITY]&") 城内糖果")
EndFunc

Func pconsSetColor($pconID, $quantity, $threshold)
	If $quantity == 0 Then
		GUICtrlSetColor($pconsCheckbox[$pconID], $COLOR_RED)
	ElseIf $quantity > $threshold Then
		GUICtrlSetColor($pconsCheckbox[$pconID], $COLOR_GREEN)
	Else
		GUICtrlSetColor($pconsCheckbox[$pconID], $COLOR_YELLOW)
	EndIf
EndFunc

Func presetLoad()
	Local $lPreset = IniRead($iniFullPath, "pconsPresets", GUICtrlRead(@GUI_CtrlId), 18*"0")
	Local $lArr = StringSplit($lPreset, "")
	If $lArr[0] <> $pconsEffects[0]+1 Then
		WriteChat("设置文件装载失败", $GWToolbox)
		Return
	EndIf

	For $i = 0 To $pconsCount-1
		$pconsActive[$i] = $lArr[$i+1] == "1"
	Next

	pconsScanInventory()
EndFunc

Func presetSave()
	Local $lName = ""
	Local $lString = ""
	For $i = 0 To $pconsCount-1
		$lString &= $pconsActive[$i] ? "1" : "0"
	Next

	GUISetState(@SW_DISABLE, $mainGui)
	Opt("GUIOnEventMode", False)
	Local $lGui = GUICreate("Save Preset", 160, 150, Default, Default, $WS_POPUP, Default, $mainGui)
		GUISetBkColor($COLOR_BLACK)
		GUICtrlSetDefBkColor($COLOR_BLACK)
		GUICtrlSetDefColor($COLOR_WHITE)
		WinSetTrans($lGui, "", $Transparency)
	GUICtrlCreateLabel("储存此页设置...", 0, 0, 160, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
		GUICtrlSetFont(-1, 14)
	Local $lDefault = "输入文件名..."
	If GUICtrlRead($pconsPresetList) <> $pconsPresetDefault Then $lDefault = GUICtrlRead($pconsPresetList)
	Local $lInput = GUICtrlCreateInput($lDefault, 20, 60, 120, 23)
	Local $lCancel = MyGuiCtrlCreateButton("取消", 20, 100, 50, 20)
	Local $lOk = MyGuiCtrlCreateButton("储存", 90, 100, 50, 20)

	Local $iESC = GUICtrlCreateDummy()
	Local $AccelKeys[1][2] = [["{ESC}", $iESC]]; Set accelerators
	GUISetAccelerators($AccelKeys)

	GUISetState(@SW_SHOW)

	While 1
		Local $msg = GUIGetMsg()
		Switch $msg
			Case 0
				ContinueLoop
			Case $GUI_EVENT_CLOSE, $lCancel, $iESC
				ExitLoop
			Case $lOk, $lInput
				$lName = GUICtrlRead($lInput)
				If $lName <> "" And $lName <> $pconsPresetDefault Then IniWrite($iniFullPath, "pconsPresets", $lName, $lString)
				ExitLoop
		EndSwitch
	WEnd

	GUIDelete($lGui)
	GUISetState(@SW_ENABLE, $mainGui)
	WinActivate($mainGui)
	Opt("GUIOnEventMode", True)
	If (($lName <> "") And ($lName <> $pconsPresetDefault) And (_GUICtrlComboBox_FindString($pconsPresetList, $lName)==-1)) Then _GUICtrlComboBox_AddString($pconsPresetList, $lName)
EndFunc

Func presetDelete()
	Local $lName = ""
	GUISetState(@SW_DISABLE, $mainGui)
	Opt("GUIOnEventMode", False)
	Local $lGui = GUICreate("Delete Preset", 160, 150, Default, Default, $WS_POPUP, Default, $mainGui)
		GUISetBkColor($COLOR_BLACK)
		GUICtrlSetDefBkColor($COLOR_BLACK)
		GUICtrlSetDefColor($COLOR_WHITE)
		WinSetTrans($lGui, "", $Transparency)
	GUICtrlCreateLabel("删除设置文件...", 0, 0, 160, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
		GUICtrlSetFont(-1, 14)
	Local $lCombo = GUICtrlCreateCombo("", 20, 60, 120, 23, $CBS_DROPDOWNLIST)
		GUICtrlSetColor(-1, $COLOR_WHITE)
		GUICtrlSetBkColor(-1, $COLOR_BLACK)
		SetPresetCombo($lCombo)
	Local $lCancel = MyGuiCtrlCreateButton("取消", 20, 100, 50, 20)
	Local $lDelete = MyGuiCtrlCreateButton("删除", 90, 100, 50, 20)

	Local $iENTER = GUICtrlCreateDummy()
	Local $iESC = GUICtrlCreateDummy()
	Local $AccelKeys[2][2] = [["{ENTER}", $iENTER], ["{ESC}", $iESC]]; Set accelerators
	GUISetAccelerators($AccelKeys)

	GUISetState(@SW_SHOW)

	While 1
		Local $msg = GUIGetMsg()
		Switch $msg
			Case 0
				ContinueLoop
			Case $GUI_EVENT_CLOSE, $lCancel, $iESC
				ExitLoop
			Case $lDelete, $iENTER
				$lName = GUICtrlRead($lCombo)
				If $lName <> $pconsPresetDefault Then
					IniDelete($iniFullPath, "pconsPresets", $lName)
				EndIf
				ExitLoop
		EndSwitch
	WEnd

	GUIDelete($lGui)
	GUISetState(@SW_ENABLE, $mainGui)
	WinActivate($mainGui)
	Opt("GUIOnEventMode", True)
	If (($lName <> "") And ($lName <> $pconsPresetDefault)) Then _GUICtrlComboBox_DeleteString($pconsPresetList, _GUICtrlComboBox_FindString($pconsPresetList, $lName))
	GUICtrlSetData($pconsPresetList, $pconsPresetDefault)
EndFunc

Func SetPresetCombo($aGuiCtrlID, $aDefault = $pconsPresetDefault)
	Local $lPresets = IniReadSection($iniFullPath, "pconsPresets")
	Local $lPresetsString = $aDefault
	If Not @error Then
		For $i=1 To $lPresets[0][0]
			$lPresetsString = $lPresetsString&"|"&$lPresets[$i][0]
		Next
	EndIf
	GUICtrlSetData($aGuiCtrlID, $lPresetsString)
	GUICtrlSetData($aGuiCtrlID, $aDefault)
EndFunc

Func pconsHotkeyToggleActive()
	Local $active = (GUICtrlRead(@GUI_CtrlId) == $GUI_CHECKED)
	If @GUI_CtrlId <> $pconsHotkeyActive Then Return MyGuiMsgBox(0, "pconsHotkeyToggleActive", "not implemented!")

	$pconsHotkey = $active
	IniWrite($iniFullPath, $pconsIniSection, "hkActive", $active)
EndFunc
