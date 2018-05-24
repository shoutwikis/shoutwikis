#include <../辅助文件1/一般常数.au3>
#include <../辅助文件1/界面框.au3>
#include <../辅助文件2/颜色挑选.au3>
#include <../../激战接口.au3>


Global $toolboxLabel,$powerstoneBox
Global $sfmacro
Local $sfmacroCheckBoxes[8]
Local $sfmacroSkillsToUse[8]

Func settingsLoadIni()
	$IsOnTop = (IniRead($iniFullPath, "display", "ontop", True) == "True") ; true by default
	$Transparency = IniRead($iniFullPath, "display", "guitransparency", 210)
	$expandLeft = (IniRead($iniFullPath, "display", "expandleft", False) == "True")
	For $i = 0 To 7 Step 1
		$sfmacroSkillsToUse[$i] = (IniRead($iniFullPath, $s_sfmacro, $i + 1, False) == "True")
	Next
EndFunc

Func settingsBuildUI()
	Local $x = 10
	Local $y = 10

	Global Const $websiteButton = MyGuiCtrlCreateButton("滚动鼠标轮以视界面全貌", $x, $y, 190, 17, 0xAAAAAA, 0x222222, 1)
	;GUICtrlSetOnEvent(-1, "settingsEventHandler")
	;GUICtrlSetTip(-1, "The website where you can find the GWToolbox executable, source code, and detailed features description.")
	$y += 25

	Global Const $settingsButton = MyGuiCtrlCreateButton("击此开设置夹", $x, $y, 190, 17, 0xAAAAAA, 0x222222, 1)
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	GUICtrlSetTip(-1, "开'设置'夹，内含'激战助手.ini'设置文件，将其擦掉可还原最初设置")
	$y += 25

	GUICtrlCreateGroup("地下四马自救", 10, $y, 190, 55)
	$powerstoneBox = GUICtrlCreateCheckbox("粉石+暗影或黑曜石肉体", 20, $y + 20)
	$y += 65

	; display
	Local $displayX = 10
	Local $displayY = $y
	GUICtrlCreateGroup("界面选择", $displayX, $displayY, 190, 120)
	Global Const $OnTopCheckbox = GUICtrlCreateCheckbox("置前", $displayX + 10, $displayY + 20)
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	If $IsOnTop Then GUICtrlSetState($OnTopCheckbox, $GUI_CHECKED)

	Global Const $expandLeftCheckbox = GUICtrlCreateCheckbox("向左展开", $displayX + 10, $displayY + 45)
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	If $expandLeft Then GUICtrlSetState($expandLeftCheckbox, $GUI_CHECKED)

	GUICtrlCreateLabel("透明度:", $displayX + 10, $displayY + 70)
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	Global Const $TransparencySlider = GUICtrlCreateSlider($displayX + 10, $displayY + 90, 170, 23)
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	GUICtrlSetLimit(-1, 255, 40)
	GUICtrlSetData(-1, $Transparency)
	GUICtrlSetBkColor(-1, $COLOR_BLACK)
	$y += 130

	; bonds monitor
	GUICtrlCreateGroup("(元素僧)加持台", $x, $y, 190, 45)
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	Global Const $infoBuffsDropCheckbox = GUICtrlCreateCheckbox("点击摘除加持", $x + 10, $y + 15)
	GUICtrlSetOnEvent(-1, "infoBuffsDropToggleActive")
	If $buffsDrop Then GUICtrlSetState(-1, $GUI_CHECKED)
	MyGuiCtrlCreateButton("?", $x + 174, $y + 15, 10, 13)
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	GUICtrlSetFont(-1, 9)
	GUICtrlSetTip(-1, 	"显示角色维持在各队友上的众加持"&@CRLF& _
						"显示窗可并列与成员表，其高度相同"&@CRLF& _
						@CRLF& _
						"提示:"&@CRLF& _
						"- 队伍中有英雄或佣兵时或不工作"&@CRLF& _
						"- 显示窗只显示角色所有加持"&@CRLF& _
						"- 选择'点击摘除加持'后 可直接用显示窗 摘除不需要的加持")
	#cs
	GUICtrlSetTip(-1, 	"It will show which bonds are used on each party member."&@CRLF& _
						"Place the monitor next to the party window, it will have the same height."&@CRLF& _
						@CRLF& _
						"Notes:"&@CRLF& _
						"- It will work properly only in parties with no heroes or henchmen"&@CRLF& _
						"- It will only show the bonds you are maintaining"&@CRLF& _
						"- If you tick 'Drop on click' you can drop bonds when clicking on the bond in the monitor")
	#ce
	$y += 55


	GUICtrlCreateGroup("计时器", $x, $y, 190, 45)
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	Global Const $infoTimerColorPicker = _GUIColorPicker_Create("颜色", $x + 20, $y + 15, 100, 25, $COLOR_TIMER, BitOR($CP_FLAG_CHOOSERBUTTON, $CP_FLAG_MAGNIFICATION, $CP_FLAG_ARROWSTYLE), 0, -1, -1, 0, '计时器颜色')
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetBkColor(-1, $COLOR_TIMER)
	$y += 55


	GUICtrlCreateGroup("目标血量", $x, $y, 190, 45)
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	Global Const $infoHealthColorPicker1 = _GUIColorPicker_Create("颜色:高", $x + 10, $y + 15, 55, 25, $COLOR_HEALTH_HIGH, BitOR($CP_FLAG_CHOOSERBUTTON, $CP_FLAG_MAGNIFICATION, $CP_FLAG_ARROWSTYLE), 0, -1, -1, 0, '目标血量颜色 1')
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetBkColor(-1, $COLOR_HEALTH_HIGH)
	Global Const $infoHealthColorPicker2 = _GUIColorPicker_Create("颜色:中", $x + 67, $y + 15, 55, 25, $COLOR_HEALTH_MIDDLE, BitOR($CP_FLAG_CHOOSERBUTTON, $CP_FLAG_MAGNIFICATION, $CP_FLAG_ARROWSTYLE), 0, -1, -1, 0, '目标血量颜色 2')
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetBkColor(-1, $COLOR_HEALTH_MIDDLE)
	Global Const $infoHealthColorPicker3 = _GUIColorPicker_Create("颜色:低", $x + 124, $y + 15, 55, 25, $COLOR_HEALTH_LOW, BitOR($CP_FLAG_CHOOSERBUTTON, $CP_FLAG_MAGNIFICATION, $CP_FLAG_ARROWSTYLE), 0, -1, -1, 0, '目标血量颜色 3')
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetBkColor(-1, $COLOR_HEALTH_LOW)
	$y += 55

	GUICtrlCreateGroup("测距", $x, $y, 190, 45)
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	Global Const $infoDistanceColorPicker = _GUIColorPicker_Create("颜色", $x+20, $y+15, 100, 25, $COLOR_DISTANCE, BitOR($CP_FLAG_CHOOSERBUTTON, $CP_FLAG_MAGNIFICATION, $CP_FLAG_ARROWSTYLE), 0, -1, -1, 0, '距离颜色')
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetBkColor(-1, $COLOR_DISTANCE)
	$y += 55

	; zoom
	Local $zoomX = $x
	Local $zoomY = $y
	GUICtrlCreateGroup("视野选择", $zoomX, $zoomY, 190, 50)
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	MyGuiCtrlCreateButton("?", $zoomX + 174, $zoomY + 15, 10, 13)
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	GUICtrlSetFont(-1, 9)
	GUICtrlSetTip(-1, "用滑尺改变视野限度")
	Global Const $zoomSlider = GUICtrlCreateSlider($zoomX + 5, $zoomY + 20, 165, 23)
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	GUICtrlSetBkColor(-1, $COLOR_BLACK)
	GUICtrlSetLimit(-1, 20000, 750)
	$y += 60


	GUICtrlCreateGroup("被瞄准次数", $x, $y, 190, 45)
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	Global Const $infoPartyCheckbox = GUICtrlCreateCheckbox("显示", $x+10, $y+17)
	GUICtrlSetOnEvent(-1, "toggleParty")
	If $party Then GUICtrlSetState(-1, $GUI_CHECKED)
	Global Const $infoPartyColorPicker = _GUIColorPicker_Create("颜色", $x+75, $Y + 15, 80, 25, $COLOR_PARTY, BitOR($CP_FLAG_CHOOSERBUTTON, $CP_FLAG_MAGNIFICATION, $CP_FLAG_ARROWSTYLE), 0, -1, -1, 0, '队伍颜色')
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetBkColor(-1, $COLOR_PARTY)
	MyGuiCtrlCreateButton("?", $x + 174, $y + 15, 10, 13)
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	GUICtrlSetFont(-1, 9)
	GUICtrlSetTip(-1,  "显示有多少敌人在瞄准各队员"&@CRLF& _
						"显示窗可并列与成员表，其高度相同"&@CRLF&@CRLF& _
						"注意: 此功能耗力，尤其在雷达范围内有过多敌人时, 或导致游戏退出, 慎用"&@CRLF)
	#cs
	GUICtrlSetTip(-1,  "It will show how many enemies are targeting each party member."&@CRLF& _
						"Place the monitor next to the party window, it will have the same height."&@CRLF&@CRLF& _
						"IMPORTANT: This feature uses a lot of CPU power, and may crash the game, expecially"&@CRLF& _
						"when used with a lot of enemies in radar range. Not recommended. Use at your own risk.")
	#ce
	$y += 55

	; skills clicker
	Local $clickerX = $x
	Local $clickerY = $y
	GUICtrlCreateGroup("技能维持", $clickerX, $clickerY, 190, 105)
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	Global Const $sfmacroActive = GUICtrlCreateCheckbox("启用", $clickerX + 10, $clickerY + 20, 60, 17)
	Global Const $sfmacroEmoMode = GUICtrlCreateCheckbox("元素僧", $clickerX + 95, $clickerY + 20, 60, 17)
	MyGuiCtrlCreateButton("?", $clickerX + 174, $clickerY + 15, 10, 13)
	GUICtrlSetFont(-1, 9)
	GUICtrlSetTip(-1, "自动使用被选中的技能" & @CRLF & "使用顺序: 自左往右, 重复使用" & @CRLF & @CRLF & "元素僧模式 可维持魔力复原, 速度燃烧, 和精神连结" & @CRLF & "元素僧模式 不受限于以下技能顺序")
	#cs
	GUICtrlSetTip(-1, "It will just use selected skills on recharge"&@CRLF& _
	"Note: priority left to right"&@CRLF&@CRLF& _
	"If E/mo is also enabled it will cast ER, spirit bond and burning speed."&@CRLF& _
	"E/mo mode does NOT check for skill numbers below.")
	#ce
	GUICtrlCreateLabel("选择技能:", $clickerX + 10, $clickerY + 40, 80, 17)
	GUICtrlSetOnEvent(-1, "settingsEventHandler")
	$sfmacroCheckBoxes[0] = GUICtrlCreateCheckbox("1", $clickerX + 10,  $clickerY + 60, 25, 17)
	$sfmacroCheckBoxes[1] = GUICtrlCreateCheckbox("2", $clickerX + 55,  $clickerY + 60, 25, 17)
	$sfmacroCheckBoxes[2] = GUICtrlCreateCheckbox("3", $clickerX + 100, $clickerY + 60, 25, 17)
	$sfmacroCheckBoxes[3] = GUICtrlCreateCheckbox("4", $clickerX + 145, $clickerY + 60, 25, 17)
	$sfmacroCheckBoxes[4] = GUICtrlCreateCheckbox("5", $clickerX + 10,  $clickerY + 80, 25, 17)
	$sfmacroCheckBoxes[5] = GUICtrlCreateCheckbox("6", $clickerX + 55,  $clickerY + 80, 25, 17)
	$sfmacroCheckBoxes[6] = GUICtrlCreateCheckbox("7", $clickerX + 100, $clickerY + 80, 25, 17)
	$sfmacroCheckBoxes[7] = GUICtrlCreateCheckbox("8", $clickerX + 145, $clickerY + 80, 25, 17)
		GUICtrlSetOnEvent($sfmacroActive, "sfMacroToggleActive")
	If $sfmacro Then GUICtrlSetState($sfmacroActive, $GUI_CHECKED)
	For $i = 0 To 7 Step 1
		If $sfmacroSkillsToUse[$i] == True Then
			GUICtrlSetState($sfmacroCheckBoxes[$i], $GUI_CHECKED)
		EndIf
		GUICtrlSetOnEvent($sfmacroCheckBoxes[$i], "sfmacroToggleSkill")
	Next

	GUICtrlSetState($toolboxLabel, $GUI_FOCUS)
EndFunc

Func sfmacroToggleSkill()
	For $i = 0 To 7 Step 1
		If $sfmacroCheckBoxes[$i] == @GUI_CtrlId Then
			$sfmacroSkillsToUse[$i] = Not $sfmacroSkillsToUse[$i]
			IniWrite($iniFullPath, $s_sfmacro, $i + 1, $sfmacroSkillsToUse[$i])
			Return
		EndIf
	Next
EndFunc   ;==>sfmacroToggleSkill

Func settingsEventHandler()
	Switch @GUI_CtrlId
		Case $OnTopCheckbox
			$IsOnTop = GUICtrlRead($OnTopCheckbox)==$GUI_CHECKED
			WinSetOnTop($mainGui, "", $IsOnTop)
			IniWrite($iniFullPath, "display", "ontop", $IsOnTop)
		Case $TransparencySlider
			IniWrite($iniFullPath, "display", "transparency", GUICtrlRead($TransparencySlider))
			GUICtrlSetState($toolboxLabel, $GUI_FOCUS)
		Case $expandLeftCheckbox
			$expandLeft = (GUICtrlRead($expandLeftCheckbox) == $GUI_CHECKED)
			IniWrite($iniFullPath, "display", "expandleft", $expandLeft)
			MyGuiMsgBox(0, "Info", "You need to restart GWToolbox for this change to have effect")
		Case $infoTimerColorPicker
			Local $lColor = _GuiColorPicker_GetColor($infoTimerColorPicker)
			IniWrite($iniFullPath, "timer", "color", $lColor)
			If $timer Then GUICtrlSetColor($timerGuiLabel, $lColor)
			$COLOR_TIMER = $lColor
			GUICtrlSetBkColor($infoTimerColorPicker, $lColor)
		Case $infoHealthColorPicker1
			Local $lColor = _GuiColorPicker_GetColor($infoHealthColorPicker1)
			IniWrite($iniFullPath, "health", "color1", $lColor)
			$COLOR_HEALTH_HIGH = $lColor
			GUICtrlSetBkColor($infoHealthColorPicker1, $lColor)
		Case $infoHealthColorPicker2
			Local $lColor = _GuiColorPicker_GetColor($infoHealthColorPicker2)
			IniWrite($iniFullPath, "health", "color2", $lColor)
			$COLOR_HEALTH_MIDDLE = $lColor
			GUICtrlSetBkColor($infoHealthColorPicker2, $lColor)
		Case $infoHealthColorPicker3
			Local $lColor = _GuiColorPicker_GetColor($infoHealthColorPicker3)
			IniWrite($iniFullPath, "health", "color3", $lColor)
			$COLOR_HEALTH_LOW = $lColor
			GUICtrlSetBkColor($infoHealthColorPicker3, $lColor)
		Case $infoDistanceColorPicker
			Local $lColor = _GuiColorPicker_GetColor($infoDistanceColorPicker)
			If $distance Then distanceUpdateColor($lColor)
			IniWrite($iniFullPath, "distance", "color3", $lColor)
			$COLOR_DISTANCE = $lColor
			GUICtrlSetBkColor($infoDistanceColorPicker, $lColor)
		Case $infoPartyColorPicker
			Local $lColor = _GUIColorPicker_GetColor($infoPartyColorPicker)
			IniWrite($iniFullPath, "party", "color", $lColor)
			$COLOR_PARTY = $lColor
			If $party Then
				For $i=1 To 8
					GUICtrlSetColor($partyLabels[$i], $lColor)
				Next
			EndIf
			GUICtrlSetBkColor($infoPartyColorPicker, $lColor)
		Case $zoomSlider
			ChangeMaxZoom(GUICtrlRead($zoomSlider))
			GUICtrlSetState($toolboxLabel, $GUI_FOCUS)
		Case $settingsButton
			ShellExecute($DataFolder)
		Case $websiteButton
			ShellExecute($Host)
		Case Else
			GUICtrlSetState($toolboxLabel, $GUI_FOCUS)
	EndSwitch
EndFunc

Func infoBuffsDropToggleActive()
	Local $active = (GUICtrlRead(@GUI_CtrlId) == $GUI_CHECKED)
	If @GUI_CtrlId <> $infoBuffsDropCheckbox Then Return MyGuiMsgBox(0, "infoBuffsDropToggleActive", "not implemented!")

	$buffsDrop = $active
	IniWrite($iniFullPath, "buffsdrop", "active", $active)
EndFunc

Func sfMacroToggleActive()
	Local $active = (GUICtrlRead(@GUI_CtrlId) == $GUI_CHECKED)
	If @GUI_CtrlId <> $sfmacroActive Then Return MyGuiMsgBox(0, "sfMacroToggleActive", "not implemented!")

	$sfmacro = $active
	IniWrite($iniFullPath, $s_sfmacro, "active", $active)
EndFunc