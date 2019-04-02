#NoTrayIcon
#RequireAdmin

; Images and compiler instructions
#AutoIt3Wrapper_Icon=图标/Monster_skill.ico
#AutoIt3Wrapper_Outfile=GWToolbox.exe
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_File_Add=图标/balthspirit.jpg, rt_rcdata, BALTHSPIRIT_JPG
#AutoIt3Wrapper_Res_File_Add=图标/lifebond.jpg, rt_rcdata, LIFEBOND_JPG
#AutoIt3Wrapper_Res_File_Add=图标/protbond.jpg, rt_rcdata, PROTBOND_JPG
#AutoIt3Wrapper_Res_File_Add=图标/comment.jpg, rt_rcdata, comment_JPG
#AutoIt3Wrapper_Res_File_Add=图标/cupcake.jpg, rt_rcdata, cupcake_JPG
#AutoIt3Wrapper_Res_File_Add=图标/feather.jpg, rt_rcdata, feather_JPG
#AutoIt3Wrapper_Res_File_Add=图标/keyboard.jpg, rt_rcdata, keyboard_JPG
#AutoIt3Wrapper_Res_File_Add=图标/list.jpg, rt_rcdata, list_JPG
#AutoIt3Wrapper_Res_File_Add=图标/plane.jpg, rt_rcdata, plane_JPG
#AutoIt3Wrapper_Res_File_Add=图标/settings.jpg, rt_rcdata, settings_JPG
#AutoIt3Wrapper_Run_Obfuscator=n
;#Obfuscator_Parameters=/mergeonly

; Include autoit stuff
#include-once
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <ComboConstants.au3>
#include <Crypt.au3>
#include <GUITab.au3>
#include <Math.au3>
#include <EditConstants.au3>
#include <GuiComboBox.au3>
#include <Misc.au3>
#include <constants.au3>
#include <GuiScrollBars.au3>

; Include external Libraries
#include <辅助文件2/颜色挑选.au3>
#include <辅助文件2/附件.au3>

; Include GWA2 and other GW stuff
#include <../激战接口.au3>
#include <辅助文件2/激战常数.au3>
#include <辅助文件2/辅助功能.au3>
#include <辅助文件2/技能词典.au3>

; Include constants and other useful files
#include <辅助文件1/一般常数.au3>
#include <辅助文件1/界面框.au3>

; feature files
#include <辅助文件1/补品.au3>
#include <辅助文件1/快键.au3>
#include <辅助文件1/直达.au3>
#include <辅助文件1/设置.au3>
#include <辅助文件1/技能栏.au3>
#include <辅助文件1/对话窗.au3>
#include <辅助文件1/快键绑定.au3>
#include <辅助文件1/材料.au3>

; Set some global options
Opt("GUIOnEventMode", True)
Opt("TrayMenuMode", True)
Opt("MustDeclareVars", True)
Opt("GUICloseOnESC", False)

Global $mName = "", $mProfession = ""

Global $mSkillbar

Global $tStorage

Global $mMe, $mTgt, $mAgents, $mParty

; 技能能量需求量
Global $skillCost[9] = [8, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000]

; 技能耗时
Global $activationCost[9] = [8, 10000, 10000, 10000, 10000, 10000, 10000, 10000, 10000]

; 技能名称
Global $skillName[9] = [8, "", "", "", "", "", "", "", ""]

Global $pcons_Slot[2]
Global $pconQuantity = 0




Global Const $SKILL_ID_INFUSE_HEALTH = 292
Global Const $SKILL_ID_EBON_ESCAPE = 2420

Global Const $SKILL_ID_SIGNET_OF_SPIRITS = 1239
Global Const $SKILL_ID_BLOOD_SONG = 1253
Global Const $SKILL_ID_PAIN_INVERTER = 2418
Global Const $SKILL_ID_SERPENTS_QUICKNESS = 456
Global Const $SKILL_ID_QUICKENING_ZEPHYR = 475
Global Const $SKILL_ID_ESSENCE_BOND = 250

;contains skill id's
Global $mTemplate[9]
$mTemplate[0]=8

Global $SfSlot = -1, $ShroudSlot = -1, $OfSlot = -1

Global $burningSlot = -1
Global $spiritBondSlot = -1
Global $infuseSlot = -1
Global $protSlot = -1
Global $lifeSlot = -1
Global $balthSlot = -1
Global $eeSlot = -1
Global $renewalSlot = -1

Global $sosSlot = -1
Global $bloodsongSlot = -1
Global $piSlot = -1
Global $sqSlot = -1
Global $qzSlot = -1
Global $essencebondSlot = -1

Global $isSpirit = false
Global $testVariable = false

If Not FileExists($DataFolder) Then DirCreate($DataFolder)
If Not FileExists($keysIniFullPath) Then FileInstall("设置\keys.ini", $keysIniFullPath)

; license and disclaimer if first run (ini file is not there)
Global Const $s_disclaimer = "3.1版"&@CRLF&@CRLF& _
							 '    工具 或可导致 激战 掉线，退出，或封号    '&@CRLF&@CRLF
If Not FileExists($iniFullPath) Then
	If MyGuiMsgBox(1, "野队激战助手", $s_disclaimer, 0, 400, 230) <> 1 Then exitProgram()
EndIf

; Initialize GW client
MyInitialize()

; Get window handle and PID
$gwHWND = GetWindowHandle()
$gwPID = WinGetProcess($gwHWND)

Global $timerGui, $timerGuiLabel
Global $healthGui, $healthGuiLabelHP, $healthGuiLabelMaxHP, $healthGuiLabelPerc, $healthGuiCurrentColor
Global $distanceGui, $distanceGuiLabelDist, $distanceGuiLabelPerc, $distanceGuiLabelText, $distanceGuiCurrentColor
Global $partyGui, $partyLabels[9]
Global $buffsGui, $buffsImages[9][3], $buffsStatus[9][3], $buffsImagesHidden[9][3], $buffsID[9][3], $buffsX = 0, $buffsY = 0
Global Enum $BUFFS_VISIBLE, $BUFFS_HIDDEN, $BUFFS_UNKNOWN

Global $hDownload
If $do_update Then
	$hDownload = InetGet($Host&"GWToolbox_currentVersion.txt", $tmpFullPath, 1, 1)
Else
	$hDownload = 0
EndIf

;~ Remove default windows theme, so that custom colors can be used in the GUI
DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)

#region READ INI FILE
Global $COLOR_TIMER = IniRead($iniFullPath, "timer", "color", $COLOR_TIMER_DEFAULT)

Global $COLOR_HEALTH_HIGH = IniRead($iniFullPath, "health", "color1", $COLOR_TIMER_DEFAULT)
Global $COLOR_HEALTH_MIDDLE = IniRead($iniFullPath, "health", "color2", $COLOR_YELLOW)
Global $COLOR_HEALTH_LOW = IniRead($iniFullPath, "health", "color3", $COLOR_RED)

Global $COLOR_PARTY = IniRead($iniFullPath, "party", "color", $COLOR_TIMER_DEFAULT)

Global $COLOR_DISTANCE = IniRead($iniFullPath, "distance", "color", $COLOR_TIMER_DEFAULT)

Global $sfmacro = 	(IniRead($iniFullPath, "sfmacro", 		"active", False) == "True")

Global $timer = 	(IniRead($iniFullPath, "timer", 		"active", False) == "True")
Global $health = 	(IniRead($iniFullPath, "health", 		"active", False) == "True")
Global $party = 	(IniRead($iniFullPath, "party", 		"active", False) == "True")
Global $buffs = 	(IniRead($iniFullPath, "buffs", 		"active", False) == "True")
Global $buffsDrop = (IniRead($iniFullPath, "buffsdrop", 	"active", False) == "True")
Global $distance = 	(IniRead($iniFullPath, "distance",	 	"active", False) == "True")

pconsLoadIni()

hotkeyLoadIni()

dialogsLoadIni()

settingsLoadIni()
#endregion Inifile

#region GUI
Local $x, $y ; for GUI construction
Global Const $MainWidth = 100
Global Const $UtilityWidth = 400
Global Const $MenuBarHeight = 21
Global Const $MainHeight = 300
Global Const $TabButtonHeight = 27

$dummyGui = GUICreate("")
Global $x = IniRead($iniFullPath, "display", "x", -1)
Global $y = IniRead($iniFullPath, "display", "y", -1)
If $x <> -1 And $x+$MainWidth > @DesktopWidth Then $x = @DesktopWidth-$MainWidth
If $x <> -1 And $x < 0 Then $x = 0
If $y <> -1 And $y+$MainHeight > @DesktopHeight Then $y = @DesktopHeight-$MainHeight
If $y <> -1 And $y < 0 Then $y = 0
$mainGui = GUICreate($GWToolbox, $MainWidth, $MainHeight, $x, $y, $WS_POPUP)
	GUISetBkColor($COLOR_BLACK)
	GUICtrlSetDefColor($COLOR_WHITE)
	GUISetOnEvent($GUI_EVENT_CLOSE, "exitProgram")
	GUIRegisterMsg($WM_MOUSEWHEEL, "mouseWheelHandler")
$x = $MainWidth - 18
GUICtrlCreateLabel("x", $x+1, 0, 17, 20, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetOnEvent(-1, "exitProgram")
GuiCtrlCreateRect($x, 0, 1, 20)
$x -= 18
GUICtrlCreateLabel("-", $x+1, 0, 17, 20, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetOnEvent(-1, "minimizeProgram")
GuiCtrlCreateRect($x, 0, 1, 20)

Global Const $dragButton = GUICtrlCreateLabel("激战助手", 0, 0, $x-1, 20, BitOR($SS_CENTER, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetOnEvent(-1, "mainGuiEventHandler")

; horizontal line on top
GuiCtrlCreateRect(0, 20, 390, 1)

; vertical line in middle
GuiCtrlCreateRect(171, 20, 1, 273)


Global Const $tabCount = 7
Global Enum $TAB_PCONS, $TAB_HOTKEYS, $TAB_BUILDS, $TAB_FASTTRAVEL, $TAB_DIALOGS, $TAB_MATERIALS, $TAB_SETTINGS, $TAB_NONE = -1
Global $currentTab = $TAB_NONE
Global $tabButtons[$tabCount]

GUISetFont(10)
$y = $MenuBarHeight
$tabButtons[$TAB_PCONS] = MyGuiCtrlCreateTab("补品", $y, "cupcake")
$CheckboxPCons = GUICtrlCreateCheckbox("", 80, $y, 20, $TabButtonHeight-1)
GUICtrlSetOnEvent($CheckboxPCons, "pconsToggleActive")
$y += $TabButtonHeight
$tabButtons[$TAB_HOTKEYS] = MyGuiCtrlCreateTab("快键", $y, "keyboard")
$y += $TabButtonHeight
$tabButtons[$TAB_BUILDS] = MyGuiCtrlCreateTab("技能", $y, "list")
$y += $TabButtonHeight
$tabButtons[$TAB_FASTTRAVEL] = MyGuiCtrlCreateTab("直达", $y, "plane")
$y += $TabButtonHeight
$tabButtons[$TAB_DIALOGS] = MyGuiCtrlCreateTab("传送", $y, "comment")
$y += $TabButtonHeight
$tabButtons[$TAB_MATERIALS] = MyGuiCtrlCreateTab("材料", $y, "feather")
$y += $TabButtonHeight
$tabButtons[$TAB_SETTINGS] = MyGuiCtrlCreateTab("设置", $y, "settings")
$y += $TabButtonHeight + 5
For $i = 0 To $tabCount-1
	GUICtrlSetOnEvent($tabButtons[$i], "tabEventHandler")
Next
Global Const $infoTimerCheckbox = GUICtrlCreateCheckbox("计时器", 7, $y, 73, 17)
GUICtrlSetOnEvent(-1, "toggleTimer")
If $timer Then GUICtrlSetState(-1, $GUI_CHECKED)
$y += 20
Global Const $infoHealthChckbox = GUICtrlCreateCheckbox("血量", 7, $y, 73, 17)
GUICtrlSetOnEvent(-1, "toggleHealth")
If $health Then GUICtrlSetState(-1, $GUI_CHECKED)
$y += 20
Global Const $infoDistanceCheckbox = GUICtrlCreateCheckbox("测距", 7, $y, 73, 17)
GUICtrlSetOnEvent(-1, "toggleDistance")
If $distance Then GUICtrlSetState(-1, $GUI_CHECKED)
$y += 20
Global Const $infoBuffsCheckbox = GUICtrlCreateCheckbox("加持台", 7, $y, 73, 17)
GUICtrlSetOnEvent(-1, "toggleBuffs")
If $buffs Then GUICtrlSetState(-1, $GUI_CHECKED)
$y += 20

GUISetFont(8.5)

Global Const $UtilityHeight = $MainHeight - $MenuBarHeight

Global $tabLeftPanel[$tabCount]
Global $tabMainPanel[$tabCount]
Global $tabScrollPos[$tabCount]
Global $tabScrollMax[$tabCount]
Global $tabPanelWidth[$tabCount]
$tabPanelWidth[$TAB_PCONS] = 400
$tabPanelWidth[$TAB_HOTKEYS] = 195
$tabPanelWidth[$TAB_BUILDS] = 195
$tabPanelWidth[$TAB_SETTINGS] = 210
$tabPanelWidth[$TAB_FASTTRAVEL] = 195
$tabPanelWidth[$TAB_DIALOGS] = 400
$tabPanelWidth[$TAB_MATERIALS] = 300

$tabScrollMax[$TAB_PCONS] = 0
$tabScrollMax[$TAB_HOTKEYS] = hotkeyGetMaxScroll()
$tabScrollMax[$TAB_BUILDS] = $buildsMaxScroll
$tabScrollMax[$TAB_SETTINGS] = 410
$tabScrollMax[$TAB_FASTTRAVEL] = 0
$tabScrollMax[$TAB_DIALOGS] = 0
$tabScrollMax[$TAB_MATERIALS] = 0

Local $tabY = $MenuBarHeight + 3
Local $tabLeftPanelX, $tabMainPanelX
For $tabIndex = 0 To $tabCount - 1
	If $expandLeft Then
		$tabLeftPanelX = 2
		$tabMainPanelX = 3-$tabPanelWidth[$tabIndex]
	Else
		$tabLeftPanelX = $MainWidth+3
		$tabMainPanelX = $MainWidth+4
	EndIf

	$tabScrollPos[$tabIndex] = 0
	$tabLeftPanel[$tabIndex] = GUICreate("", 1, $UtilityHeight, $tabLeftPanelX, $tabY, $WS_POPUP, $WS_EX_MDICHILD, $mainGui)
	GUISetBkColor($COLOR_WHITE)
	GuiCtrlCreateRect(0, $TabButtonHeight * $tabIndex, 1, $TabButtonHeight-1, $COLOR_BLACK)
	$tabMainPanel[$tabIndex] = GUICreate("", $tabPanelWidth[$tabIndex]-1,  $UtilityHeight, $tabMainPanelX, $tabY, $WS_POPUP, $WS_EX_MDICHILD, $MainGui)
	GUISetBkColor($COLOR_BLACK)
	GUICtrlSetDefColor($COLOR_WHITE)
	GUIRegisterMsg($WM_MOUSEWHEEL, "mouseWheelHandler")

	Switch $tabIndex
		Case $TAB_PCONS
			pconsBuildUI()
		Case $TAB_HOTKEYS
			hotkeyBuildUI()
		Case $TAB_BUILDS
			buildsBuildUI()
		Case $TAB_SETTINGS
			settingsBuildUI()
		Case $TAB_FASTTRAVEL
			fastTravelBuildUI()
		Case $TAB_DIALOGS
			dialogsBuildUI()
		Case $TAB_MATERIALS
			materialsBuildUI()
	EndSwitch
Next

GUIRegisterMsg($WM_MOUSEWHEEL, "mouseWheelHandler")

WinSetTrans($MainGui, "", $transparency)
For $i = 0 To $tabCount - 1
	WinSetTrans($tabLeftPanel[$i], "", $transparency)
	WinSetTrans($tabMainPanel[$i], "", $transparency)
Next


If $timer Then
	$timer = Not $timer
	toggleTimer()
EndIf

If $health Then
	$health = Not $health
	toggleHealth()
EndIf

If $party Then
	$party = Not $party
	toggleParty()
EndIf

If $distance Then
	$distance = Not $distance
	toggleDistance()
EndIf

If $buffs Then
	$buffs = Not $buffs
	toggleBuffs()
EndIf

WinSetOnTop($MainGui, "", $isOnTop)
GUISetState(@SW_SHOW, $mainGui)
#endregion GUI

Func mainLoop()
	#region declarations
	Local $currentMap = -1
	Local $currentLoadingState = -1

	; variable for the pressed status
	Local $pressed = False

	; open the DLL used for _isPressed(..)
	Local $hDLL = DllOpen("user32.dll")

	; stuff for info
	Local $lTgtHP, $lTgtMaxHP

	; variable for the timer
	Local $timerDefaultColor = True
	Local $currentTime, $sec, $min

	Local $lAgentArray = GetAgentArray()
	Local $lParty = GetParty($lAgentArray)
	Local $lPartyDanger = GetPartyDanger($lAgentArray, $lParty)
	Local $lMe = GetAgentByID(-2)
	Local $lTgt = GetAgentByID(-1)

	Local $lBuff, $lBuffTarget, $lBuffTargetNumber
	#endregion
	;Local $timerCycle = TimerInit()
	While True
		If Not ProcessExists($gwPID) Then
			exitProgram()
		EndIf

		if (GUICTRLRead($powerstoneBox) == $GUI_Checked) and (NOT HasEffect(3134)) and (GetMapLoading() == $INSTANCETYPE_EXPLORABLE) then
			updateData()
			saveYourselfOperations()
			;SkeletalOperations()
			shadowFormObsidianFlesh()
		endif
		;writechat(round(TimerDiff($timerCycle)/1000,3))
		;$timerCycle = TimerInit()

		#region GetStuff
		$lMe = GetAgentByID(-2)
		$lTgt = GetAgentByID(-1)
		If GetMapLoading() == $INSTANCETYPE_EXPLORABLE Then
			If $pcons And (($pconsActive[$PCONS_CONS] And GetInstanceUpTime() < 61*1000) Or $pconsActive[$PCONS_RES]) Or $party Then
				$lAgentArray = GetAgentArray()
				$lParty = GetParty($lAgentArray)
			EndIf
		EndIf
		#endregion

		#region Transparency
		If GUICtrlRead($TransparencySlider) <> $Transparency Then
			$Transparency = GUICtrlRead($TransparencySlider)
			WinSetTrans($mainGui, "", $Transparency)
			For $i = 0 To $tabCount-1
				WinSetTrans($tabLeftPanel[$i], "", $Transparency)
				WinSetTrans($tabMainPanel[$i], "", $Transparency)
			Next
			If $timer Then WinSetTrans($timerGui, "", $Transparency)
			If $health Then WinSetTrans($healthGui, "", $Transparency)
			If $distance Then WinSetTrans($distanceGui, "", $Transparency)
		EndIf
		#endregion

		#region partydanger
		If $party Then
			$lPartyDanger = GetPartyDanger($lAgentArray, $lParty)
			If GetMapLoading()==$INSTANCETYPE_EXPLORABLE Then
				For $i=1 To _Min($lPartyDanger[0], 8)
					If DllStructGetData($lParty[$i], "PlayerNumber") <= 8 Then
						GuiCtrlUpdateData($partyLabels[DllStructGetData($lParty[$i], "PlayerNumber")], $lPartyDanger[$i]); &" - "&GetPlayerName($lParty[$i]))
					EndIf
				Next
			Else
				For $i=1 To 8
					GuiCtrlUpdateData($partyLabels[$i], "-")
				Next
			EndIf
		EndIf
		#endregion

		#region buffs
		If $buffs Then
			For $i=1 To 8
				For $k=0 To 2
					$buffsStatus[$i][$k] = $BUFFS_UNKNOWN
				Next
			Next
			For $buffIndex=1 To GetBuffCount()
				$lBuff = GetBuffByIndex($buffIndex)
				$lBuffTarget = GetAgentByID(DllStructGetData($lBuff, "TargetID"))
				$lBuffTargetNumber = DllStructGetData($lBuffTarget, "PlayerNumber")
				If $lBuffTargetNumber > 0 And $lBuffTargetNumber < 9 Then
					Switch DllStructGetData($lBuff, "SkillID")
						Case 242 ; balth
							buffsShow($lBuffTargetNumber, 0)
							$buffsID[$lBuffTargetNumber][0] = DllStructGetData($lBuff, "BuffID")
						Case 241 ; lifebond
							buffsShow($lBuffTargetNumber, 1)
							$buffsID[$lBuffTargetNumber][1] = DllStructGetData($lBuff, "BuffID")
						Case 263 ; prot
							buffsShow($lBuffTargetNumber, 2)
							$buffsID[$lBuffTargetNumber][2] = DllStructGetData($lBuff, "BuffID")
					EndSwitch
				EndIf
			Next
			For $i=1 To 8
				For $k=0 To 2
					If $buffsStatus[$i][$k] == $BUFFS_UNKNOWN Then
						buffsHide($i, $k)
					EndIf
				Next
			Next
		EndIf
		#endregion

		#region health
		If $health Then
			If DllStructGetData($lTgt, "Type")==0xDB Then
				$lTgtHP = DllStructGetData($lTgt, "HP")
				$lTgtMaxHP = DllStructGetData($lTgt, "MaxHP")
					GuiCtrlUpdateData($healthGuiLabelHP, StringFormat("%.1f", $lTgtHP*100))
					If $lTgtMaxHP <> 0 Then
						GuiCtrlUpdateData($healthGuiLabelMaxHP, Round($lTgtHP*$lTgtMaxHP)&" / "&$lTgtMaxHP)
					Else
						GuiCtrlUpdateData($healthGuiLabelMaxHP, "- / -")
					EndIf
					If $lTgtHP >= 0.9 Then
						healthUpdateColor($COLOR_HEALTH_HIGH)
					ElseIf $lTgtHP >= 0.5 Then
						healthUpdateColor($COLOR_HEALTH_MIDDLE)
					Else
						healthUpdateColor($COLOR_HEALTH_LOW)
					EndIf
			Else
				GuiCtrlUpdateData($healthGuiLabelHP, "-")
				GuiCtrlUpdateData($healthGuiLabelMaxHP, "- / -")
				healthUpdateColor($COLOR_GREY)
			EndIf
		EndIf
		#endregion health

		#region distance
		If $distance Then
			If DllStructGetData($lTgt, "Type")==0xDB Then
				distanceUpdateColor($COLOR_DISTANCE)
				Local $lDistance = GetDistance($lMe, $lTgt)
				If $lDistance < $RANGE_ADJACENT Then
					GuiCtrlUpdateData($distanceGuiLabelDist, Round($lDistance / $RANGE_ADJACENT * 100))
					GuiCtrlUpdateData($distanceGuiLabelText, "邻近")
				ElseIf $lDistance < $RANGE_NEARBY Then
					GuiCtrlUpdateData($distanceGuiLabelDist, Round($lDistance / $RANGE_NEARBY * 100))
					GuiCtrlUpdateData($distanceGuiLabelText, "附近")
				ElseIf $lDistance < $RANGE_AREA Then
					GuiCtrlUpdateData($distanceGuiLabelDist, Round($lDistance / $RANGE_AREA * 100))
					GuiCtrlUpdateData($distanceGuiLabelText, "周围/范围内")
				ElseIf $lDistance < $RANGE_EARSHOT Then
					GuiCtrlUpdateData($distanceGuiLabelDist, Round($lDistance / $RANGE_EARSHOT * 100))
					GuiCtrlUpdateData($distanceGuiLabelText, "听距内") ;earshot
				ElseIf $lDistance < $RANGE_SPELLCAST Then
					GuiCtrlUpdateData($distanceGuiLabelDist, Round($lDistance / $RANGE_SPELLCAST * 100))
					GuiCtrlUpdateData($distanceGuiLabelText, "施法区内")
				ElseIf $lDistance < $RANGE_SPIRIT Then
					GuiCtrlUpdateData($distanceGuiLabelDist, Round($lDistance / $RANGE_SPIRIT * 100))
					GuiCtrlUpdateData($distanceGuiLabelText, "灵区内")
				ElseIf $lDistance < $RANGE_COMPASS Then
					GuiCtrlUpdateData($distanceGuiLabelDist, Round($lDistance / $RANGE_COMPASS * 100))
					GuiCtrlUpdateData($distanceGuiLabelText, "雷达内")
				EndIf
			Else
				GuiCtrlUpdateData($distanceGuiLabelDist, "-")
				GuiCtrlUpdateData($distanceGuiLabelText, "-")
				distanceUpdateColor($COLOR_GREY)
			EndIf
		EndIf
		#endregion distance

		#region timer
		If $timer Then
			If GetMapLoading() <> $INSTANCETYPE_LOADING Then
				$sec = Int(GetInstanceUptime()/1000)
				If $sec <> $currentTime Then
					$currentTime = $sec
					$min = Int($sec/60)
					GUICtrlSetData($timerGuiLabel, Int($min/60)&":"&StringFormat("%02d", Mod($min, 60))&":"&StringFormat("%02d", Mod($sec, 60)))
					If GetMapID() == $MAP_ID_URGOZ And GetMapLoading()==$INSTANCETYPE_EXPLORABLE Then
						$timerDefaultColor = False
						Local $temp = Mod($sec, 25)
						If $temp < 1 Then
							GUICtrlSetColor($timerGuiLabel, $COLOR_URGOZ_OPENING)
						ElseIf $temp < 13 Then
							GUICtrlSetColor($timerGuiLabel, $COLOR_URGOZ_OPEN)
						ElseIf $temp < 16 Then
							GUICtrlSetColor($timerGuiLabel, $COLOR_URGOZ_CLOSING)
						ElseIf $temp < 23 Then
							GUICtrlSetColor($timerGuiLabel, $COLOR_URGOZ_CLOSED)
						Else
							GUICtrlSetColor($timerGuiLabel, $COLOR_URGOZ_OPENING)
						EndIf
					Else
						If Not $timerDefaultColor Then
							GUICtrlSetColor($timerGuiLabel, $COLOR_TIMER)
							$timerDefaultColor = True
						EndIf
					EndIf
				EndIf
			Else
				GuiCtrlUpdateData($timerGuiLabel, "正在装图")
			EndIf
		EndIf
		#endregion

		#region sf_macro
		If $sfmacro Then
			SkillsMacro()
		EndIf
		#endregion sf_macro

		hotkeyMainLoop($hDLL)

		pconsMainLoop($hDLL, $lMe, $lTgt, $lParty)

		dialogsMainLoop($hDLL)

		materialsMainLoop()

		Sleep(5)
	WEnd
EndFunc   ;==>mainLoop


Func SkillsMacro()
	If Not GetMapLoading()==$INSTANCETYPE_EXPLORABLE Then Return
	Local $lMe = GetAgentByID(-2)
	If BitAND(DllStructGetData($lMe, 'Effects'), 0x0010) > 0 Then Return	; GetIsDead(-2)
	If DllStructGetData($lMe, 'Skill') <> 0 Then Return ; GetIsCasting(-2)
	Local $lSKillBar = GetSkillbar(0)
	If GUICtrlRead($sfmacroEmoMode) == $GUI_CHECKED Then
		Local $energyMissing = Int((1 - DllStructGetData($lMe, 'EnergyPercent')) * DllStructGetData($lMe, 'MaxEnergy'))
		If GetHeroProfession(0)==$PROF_ELEMENTALIST And $energyMissing > 10 Then
			Local $haveER = DllStructGetData(GetEffect($SKILL_ID_ETHER_RENEWAL), "SkillID") == $SKILL_ID_ETHER_RENEWAL
			Local $lSkillIDs[8]
			For $i=0 To 7
				$lSkillIDs[$i] = DllStructGetData($lSKillBar, "ID" & $i + 1)
			Next

			; Ether renewal
			For $i=0 To 7
				If $lSkillIDs[$i] == $SKILL_ID_ETHER_RENEWAL And DllStructGetData($lSKillBar, "Recharge" & $i + 1) == 0 Then
					UseSkill($i+1, -2)
					pingSleep()
					Return
				EndIf
			Next

			If $haveER Then
				; spirit bond
				For $i=0 To 7
					If $lSkillIDs[$i] == $SKILL_ID_SPIRIT_BOND And DllStructGetData($lSKillBar, "Recharge" & $i + 1) == 0 Then
						UseSkill($i+1, -2)
						pingSleep()
						Return
					EndIf
				Next

				; burning speed
				For $i=0 To 7
					If $lSkillIDs[$i] == $SKILL_ID_BURNING_SPEED And DllStructGetData($lSKillBar, "Recharge" & $i + 1) == 0 Then
						UseSkill($i+1, -2)
						pingSleep()
						Return
					EndIf
				Next
			EndIf
		EndIf
	Else
		For $i = 0 To 7 Step 1
			If $sfmacroSkillsToUse[$i] Then
				If DllStructGetData($lSKillBar, "Recharge" & $i + 1) == 0 Then
					useSkill($i + 1, -1)
					pingSleep()
					Return
				EndIf
			EndIf
		Next
	EndIf
EndFunc

#region timer
Func toggleTimer()
	$timer = Not $timer
	If $timer Then
		Local $x = IniRead($iniFullPath, "timer", "x", -1)
		Local $y = IniRead($iniFullPath, "timer", "y", -1)
		$timerGui = GUICreate("", 150, 40, $x, $y, $WS_POPUP, $WS_EX_TOPMOST, $dummyGui)
		_GuiRoundCorners($timerGui, 10)
		$timerGuiLabel = GUICtrlCreateLabel("", 0, 0, 150, 40, BitOR($SS_CENTER, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
		GUICtrlSetFont($timerGuiLabel, 26)
		GUICtrlSetColor($timerGuiLabel, $COLOR_TIMER)
		GUISetBkColor($COLOR_BLACK)
		GUISetOnEvent($GUI_EVENT_PRIMARYUP, "timerMoved")
		WinSetTrans($timerGui, "", $Transparency)
		GUISetState()
		WinActivate($mainGui)
	Else
		GUIDelete($timerGui)
	EndIf
	IniWrite($iniFullPath, "timer", "Active", $timer)
EndFunc

Func timerMoved()
	If $timer Then
		Local $pos = WinGetPos($timerGui)
		IniWrite($iniFullPath, "timer", "x", $pos[0])
		IniWrite($iniFullPath, "timer", "y", $pos[1])
	EndIf
EndFunc
#endregion timer

#region health
Func toggleHealth()
	$health = Not $health
	If $health Then
		Local $x = IniRead($iniFullPath, "health", "x", -1)
		Local $y = IniRead($iniFullPath, "health", "y", -1)
		$healthGui = GUICreate("", 105, 60, $x, $y, $WS_POPUP, $WS_EX_TOPMOST, $dummyGui)
		_GuiRoundCorners($healthGui, 10)
		GUISetBkColor($COLOR_BLACK)
		GUICtrlSetDefColor($COLOR_HEALTH_HIGH)
		$healthGuiLabelHP = 	GUICtrlCreateLabel("", 3, 	0, 	85, 40, $SS_RIGHT, $GUI_WS_EX_PARENTDRAG)
			GUICtrlSetFont(-1, 26, 500)
		$healthGuiLabelPerc = 	GUICtrlCreateLabel("%",90, 	0, 	15, 40, BitOR($SS_LEFT, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
			GUICtrlSetFont(-1, 12)
		$healthGuiLabelMaxHP = 	GUICtrlCreateLabel("", 3, 	40, 105,20, BitOR($SS_CENTER, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
			GUICtrlSetFont(-1, 12)
		$healthGuiCurrentColor = $COLOR_HEALTH_HIGH
		GUISetOnEvent($GUI_EVENT_PRIMARYUP, "healthMoved")
		WinSetTrans($healthGui, "", $Transparency)
		GUISetState()
		WinActivate($mainGui)
	Else
		GUIDelete($healthGui)
	EndIf
	IniWrite($iniFullPath, "health", "Active", $health)
EndFunc

Func healthMoved()
	If $health Then
		Local $pos = WinGetPos($healthGui)
		IniWrite($iniFullPath, "health", "x", $pos[0])
		IniWrite($iniFullPath, "health", "y", $pos[1])
	EndIf
EndFunc

Func healthUpdateColor($color)
	If $healthGuiCurrentColor <> $color Then
		GUICtrlSetColor($healthGuiLabelHP, $color)
		GUICtrlSetColor($healthGuiLabelMaxHP, $color)
		GUICtrlSetColor($healthGuiLabelPerc, $color)
		$healthGuiCurrentColor = $color
	EndIf
EndFunc
#endregion

#region distance
Func toggledistance()
	$distance = Not $distance
	If $distance Then
		Local $x = IniRead($iniFullPath, "distance", "x", -1)
		Local $y = IniRead($iniFullPath, "distance", "y", -1)
		$distanceGui = GUICreate("", 85, 50, $x, $y, $WS_POPUP, $WS_EX_TOPMOST, $dummyGui)
		_GuiRoundCorners($distanceGui, 10)
		GUISetBkColor($COLOR_BLACK)
		GUICtrlSetDefColor($COLOR_DISTANCE)
		$distanceGuiLabelDist = GUICtrlCreateLabel("", 0, 0, 80, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
			GUICtrlSetFont(-1, 24)
		$distanceGuiLabelPerc = GUICtrlCreateLabel("%", 70, 0, 15, 30, BitOR($SS_LEFT, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
			GUICtrlSetFont(-1, 10)
		$distanceGuiLabelText = GUICtrlCreateLabel("", 0, 30, 85, 20, BitOR($SS_CENTER, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
			GUICtrlSetFont(-1, 10)
		$distanceGuiCurrentColor = $COLOR_DISTANCE
		GUISetOnEvent($GUI_EVENT_PRIMARYUP, "distanceMoved")
		WinSetTrans($distanceGui, "", $Transparency)
		GUISetState()
		WinActivate($mainGui)
	Else
		GUIDelete($distanceGui)
	EndIf
	IniWrite($iniFullPath, "distance", "Active", $distance)
EndFunc

Func distanceUpdateColor($color)
	If $distanceGuiCurrentColor <> $color Then
		GUICtrlSetColor($distanceGuiLabelDist, $color)
		GUICtrlSetColor($distanceGuiLabelPerc, $color)
		GUICtrlSetColor($distanceGuiLabelText, $color)
		$distanceGuiCurrentColor = $color
	EndIf
EndFunc

Func distanceMoved()
	If $distance Then
		Local $pos = WinGetPos($distanceGui)
		IniWrite($iniFullPath, "distance", "x", $pos[0])
		IniWrite($iniFullPath, "distance", "y", $pos[1])
	EndIf
EndFunc
#endregion distance

#region party
Func toggleParty()
	$party = Not $party
	If $party Then
		Local $lWidth = 30
		Local $lHeight = 22
		Local $x = IniRead($iniFullPath, "party", "x", -1)
		Local $y = IniRead($iniFullPath, "party", "y", -1)
		$partyGui = GUICreate("", $lWidth, $lHeight*8, $x, $y, $WS_POPUP, $WS_EX_TOPMOST, $dummyGui)
		_GuiRoundCorners($partyGui, 10)
		GUISetBkColor($COLOR_BLACK)
		GUICtrlSetDefColor($COLOR_PARTY)
		For $i=1 To 8
			$partyLabels[$i] = GUICtrlCreateLabel("-", 0, ($i-1)*$lHeight, $lWidth, $lHeight, BitOR($SS_CENTER, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
				GUICtrlSetFont(-1, 12)
		Next
		GUISetOnEvent($GUI_EVENT_PRIMARYUP, "partyMoved")
		WinSetTrans($partyGui, "", $Transparency)
		GUISetState()
		WinActivate($mainGui)
	Else
		GUIDelete($partyGui)
	EndIf
	IniWrite($iniFullPath, "party", "Active", $party)
EndFunc

Func partyMoved()
	If $party Then
		Local $pos = WinGetPos($partyGui)
		IniWrite($iniFullPath, "party", "x", $pos[0])
		IniWrite($iniFullPath, "party", "y", $pos[1])
	EndIf
EndFunc
#endregion

#region buffs
Func toggleBuffs()
	$buffs = Not $buffs
	If $buffs Then
		Local $lSize = 22
		$buffsX = IniRead($iniFullPath, "buffs", "x", -1)
		$buffsY = IniRead($iniFullPath, "buffs", "y", -1)
		$buffsGui = GUICreate("", $lSize*3, $lSize*8, $buffsX, $buffsY, $WS_POPUP, $WS_EX_TOPMOST, $dummyGui)
		GUISetBkColor($COLOR_BLACK)
		GUICtrlCreateLabel("", 0, 0, $lSize*3, $lSize*8, Default, $GUI_WS_EX_PARENTDRAG)
			GUICtrlSetOnEvent(-1, "buffsClicked")
		For $i=1 To 8
			$buffsImages[$i][0] = GUICtrlCreatePic("", 0*$lSize, ($i-1)*$lSize, $lSize, $lSize, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
			$buffsImages[$i][1] = GUICtrlCreatePic("", 1*$lSize, ($i-1)*$lSize, $lSize, $lSize, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
			$buffsImages[$i][2] = GUICtrlCreatePic("", 2*$lSize, ($i-1)*$lSize, $lSize, $lSize, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
			If @Compiled Then
				_Resource_SetToCtrlID($buffsImages[$i][0], "BALTHSPIRIT_JPG")
				_Resource_SetToCtrlID($buffsImages[$i][1], "LIFEBOND_JPG")
				_Resource_SetToCtrlID($buffsImages[$i][2], "PROTBOND_JPG")
			Else
				GUICtrlSetImage($buffsImages[$i][0], "图标/balthspirit.jpg")
				GUICtrlSetImage($buffsImages[$i][1], "图标/lifebond.jpg")
				GUICtrlSetImage($buffsImages[$i][2], "图标/protbond.jpg")
			EndIf
		Next
		For $i=1 To 8
			For $k=0 To 2
				$buffsImagesHidden[$i][$k] = False
				buffsHide($i, $k)
			Next
		Next
;~ 		GUISetOnEvent($GUI_EVENT_PRIMARYUP, "buffsMoved") ; unfortunately this won't trigger since the GUI is covered by labels with an event on them
		WinSetTrans($buffsGui, "", $Transparency)
		GUISetState()
		WinActivate($mainGui)
	Else
		GUIDelete($buffsGui)
	EndIf
	IniWrite($iniFullPath, "buffs", "Active", $buffs)
EndFunc

Func buffsClicked()
	If Not $buffsDrop Then Return
	Local $mousePos = GUIGetCursorInfo($buffsGui)
	Local $lBuffNo = Int(Floor($mousePos[0] / 22))
	Local $lPlayer = Int(Floor($mousePos[1] / 22)) + 1
	If $buffsStatus[$lPlayer][$lBuffNo] == $BUFFS_VISIBLE Then
		SendPacket(0x8, $DropBuffHeader, $buffsID[$lPlayer][$lBuffNo]);
		Sleep(10)
	EndIf
	buffsMoved()
EndFunc

Func buffsShow($aPlayer, $aBuffNo)
	If $buffsImagesHidden[$aPlayer][$aBuffNo] Then
		GUICtrlSetState($buffsImages[$aPlayer][$aBuffNo], $GUI_SHOW)
		$buffsImagesHidden[$aPlayer][$aBuffNo] = False
	EndIf
	$buffsStatus[$aPlayer][$aBuffNo] = $BUFFS_VISIBLE
EndFunc

Func buffsHide($aPlayer, $aBuffNo)
	If Not $buffsImagesHidden[$aPlayer][$aBuffNo] Then
		GUICtrlSetState($buffsImages[$aPlayer][$aBuffNo], $GUI_HIDE)
		$buffsImagesHidden[$aPlayer][$aBuffNo] = True
	EndIf
	$buffsStatus[$aPlayer][$aBuffNo] = $BUFFS_HIDDEN
EndFunc

Func buffsMoved()
	If $buffs Then
		Local $pos = WinGetPos($buffsGui)
		If $pos[0] <> $buffsX Then IniWrite($iniFullPath, "buffs", "x", $pos[0])
		If $pos[1] <> $buffsY Then IniWrite($iniFullPath, "buffs", "y", $pos[1])
	EndIf
EndFunc
#endregion buffs

#region GuiEventHandlers
Func tabEventHandler()
	If Not ($currentTab == $TAB_NONE) Then
		GUICtrlSetBkColor($tabButtons[$currentTab], $COLOR_BLACK)
		GUISetState(@SW_HIDE, $tabMainPanel[$currentTab])
		GUISetState(@SW_HIDE, $tabLeftPanel[$currentTab])

		If $tabButtons[$currentTab] == @GUI_CtrlId Then
			$currentTab = $TAB_NONE
			Return
		EndIf
	EndIf

	For $i = 0 To $tabCount-1
		If @GUI_CtrlId == $tabButtons[$i] Then
			GUICtrlSetBkColor($tabButtons[$i], $COLOR_BLACK)
			GUISetState(@SW_SHOW, $tabMainPanel[$i])
			GUISetState(@SW_SHOW, $tabLeftPanel[$i])
			$currentTab = $i
			ExitLoop
		EndIf
	Next
EndFunc

; note: 0x00780000 is wheel UP, 0xFF880010 is wheel DOWN (on $wParam)
Func mouseWheelHandler($hWnd, $MsgID, $wParam, $lParam)
	If $currentTab == $TAB_NONE Then Return

	Local $lAmount = 0
	If $wParam = 0x00780000 Then
		$lAmount = -20
	ElseIf $WParam = 0xFF880000 Then
		$lAmount = 20
	EndIf

	If $tabScrollPos[$currentTab] + $lAmount < 0 Then Return
	If $tabScrollPos[$currentTab] + $lAmount > $tabScrollMax[$currentTab] Then Return

	_GUIScrollBars_ScrollWindow($tabMainPanel[$currentTab], 0, -$lAmount)
	$tabScrollPos[$currentTab] += $lAmount
	Return
EndFunc

Func MyGuiCtrlMoveBy($hWindowID, $hControlID, $XAmount, $YAmount)
	Local $lPos = ControlGetPos($hWindowID, "", $hControlID)
	GUICtrlSetPos($hControlID, $lPos[0] + $XAmount, $lPos[1] + $YAmount, $lPos[2], $lPos[3])
EndFunc

Func mainGuiEventHandler()
	Switch @GUI_CtrlId
		Case $dragButton
			Local $pos = WinGetPos($mainGui)
			IniWrite($iniFullPath, "display", "x",$pos[0])
			IniWrite($iniFullPath, "display", "y", $pos[1])
		Case Else
			MyGuiMsgBox(0, "error", "not yet implemented"&@CRLF&"Please tell someone about it")
	EndSwitch
EndFunc
#endregion GuiEventHandlers


Func MyGuiCtrlCreateTab($sText, $iY, $sIcon = "")
	Local $lColor = $COLOR_WHITE
	Local $lBgColor = $COLOR_BLACK
	Local $lStyle = BitOR($SS_LEFT, $SS_CENTERIMAGE)
	Local $lStyleEx = -1
    GuiCtrlCreateRect(0, $iY + $TabButtonHeight - 1, $MainWidth, 1)
	Local $lWidth = $sText == "Pcons" ? $MainWidth - 20 : $MainWidth
	Local $ret = GUICtrlCreateLabel("        " & $sText, 0, $iY, $lWidth, $TabButtonHeight-1, $lStyle, $lStyleEx)
	GUICtrlSetBkColor(-1, $lBgColor)
	If $sIcon Then
		Local $lIcon = GUICtrlCreatePic("", 5, $iY+1, 24, 24)
		If @Compiled Then
			_Resource_SetToCtrlID($lIcon, $sIcon & "_JPG")
		Else
			GUICtrlSetImage($lIcon, "图标/" & $sIcon & ".jpg")
		EndIf
		GUICtrlSetState($lIcon, $GUI_DISABLE)
	EndIf
    Return $ret
EndFunc

#region initialization
Func MyInitialize()
	Local $lGwProcList = ProcessList("gw.exe")
	Local $lToolboxProcList = ProcessList($GWToolbox&".exe")
	Local $lInitParameter

	; exit conditions:
	If $lGwProcList[0][0] == 0 Then
		MyGuiMsgBox(0, "激战助手", "提示: 激战未开")
		exitProgram()
	EndIf
	If $lGwProcList[0][0] == 1 And $lToolboxProcList[0][0] == 2 Then
		MyGuiMsgBox(0, "激战助手", "提示: 激战助手已开")
		exitProgram()
	EndIf

	Local $lActiveChars = ScanGW()

	Switch $lActiveChars[0]
		Case 0
			MyGuiMsgBox(0, "激战助手", "提示: 未在激战内选择角色")
			exitProgram()
		Case 1
			$lInitParameter = $lActiveChars[1]
		Case Else
			$lInitParameter = selectClient($lActiveChars)
	EndSwitch

	Local $lInitRet = Initialize($lInitParameter)

	If $lInitRet == 0 Then
		MyGuiMsgBox(0, "激战助手", "提示: 启动失败")
		exitProgram()
	EndIf

	SetEvent('SkillActivate', 'SkillCancel', 'SkillComplete', '', '')

EndFunc

Func selectClient($chars)
	Opt("GUIOnEventMode", False)
	Local $clientSelectionGui = GUICreate("激战助手", 300, 150, Default, Default, $WS_POPUP)
	GUISetBkColor($COLOR_BLACK)
	GUICtrlSetDefBkColor($COLOR_BLACK)
	GUICtrlSetDefColor($COLOR_WHITE)

	Local $lCharString = ""
	For $i=1 To $chars[0]
		$lCharString = $lCharString & "|" & $chars[$i]
	Next

	GUICtrlCreateLabel("窗口选择...", 0, 0, 300, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
		GUICtrlSetFont(-1, 14)
	Local $lCombo = GUICtrlCreateCombo("窗口选择", 20, 50, 260, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL, $CBS_SORT))
		GUICtrlSetData(-1, $lCharString)
		GUICtrlSetBkColor(-1, $COLOR_BLACK)
	Local $okButton = MyGuiCtrlCreateButton("完成", 20, 110, 110, 25)
	Local $cancelButton = MyGuiCtrlCreateButton("取消", 170, 110, 110, 25)

	GUISetState(@SW_SHOW)

	Local $lSelectedChar = ""

	While 1
		Local $msg = GUIGetMsg()
		Switch $msg
			Case 0
				ContinueLoop
			Case $GUI_EVENT_CLOSE, $cancelButton
				Exit
			Case $okButton
				$lSelectedChar = GUICtrlRead($lCombo)
				ExitLoop
		EndSwitch
	WEnd

	GUIDelete($clientSelectionGui)
	Opt("GUIOnEventMode", True)
	Return $lSelectedChar
EndFunc
#endregion initialization

Func ArrayGetCommonElements($aArrA, $aArrB)
	Local $lReturnArray[1] = [0]
	For $i=1 To $aArrA[0]
		For $j=1 To $aArrB[0]
			If $aArrA[$i] == $aArrB[$j] Then
				$lReturnArray[0] += 1
				ReDim $lReturnArray[$lReturnArray[0] + 1]
				$lReturnArray[$lReturnArray[0]] = $aArrA[$i]
			EndIf
		Next
	Next
	Return $lReturnArray
EndFunc


Func minimizeProgram()
	GUISetState(@SW_MINIMIZE, $mainGui)
EndFunc

; Actually I don't care about the parameter, it's just a hack to allow Exit(somefunc())
; I know, this is horrible, I dont give an exit code and I don't close stuff. But windows doesn't care about the exit message, and AutoIt closes automatically all open resources... in theory.
Func exitProgram($param = 0)
	Exit 0
EndFunc

mainLoop()

Func DuiYuan_ShiFa($Caster, $Target, $Skill, $Completed=true)
		Local $lCasterStruct = GetAgentByID($Caster)
		;战士1, 游侠2, 僧侣3, 死灵4, 幻术5, 元素6, 暗杀7, 祭祀8, 圣言9, 神唤10
		if (GUICtrlRead($hotkeyCheckbox[$HOTKEY_TALLY]) == $GUI_Checked) and (DllStructGetData($lCasterStruct, 'PlayerNumber') <= 8) and (DllStructGetData($lCasterStruct, 'Allegiance') == 1)  Then
			Local $pinDao = false ;! # $

			Local $zhiYe = DllStructGetData($lCasterStruct, 'Primary')
			Local $fuzhi = DllStructGetData($lCasterStruct, 'Secondary')

			if $zhiYe == 4 and $fuzhi = 2 then
					$pinDao = "!"
			elseif $zhiYe == 5 and $fuzhi == 7 then
					$pinDao = "#"
			elseif $zhiYe == 5 and $fuzhi == 3 then
					$pinDao = "$"
			endif

			if $zhiYe == 4 or $zhiYe == 5 then
				Local $agentName, $temp_name, $skillLink, $targetName
				$agentName = GetAgentName($Caster)
				$targetName = GetAgentName($Target)
				$skillLink=StringReplace(SkillDictionary($Skill), "<div align='center'><a href='https://guildwars.huijiwiki.com/wiki/", "")
				$skillLink=StringRegExpReplace($skillLink, "'><img.*?$", "")
				if $agentName == "" then
					$agentName = GetPlayerName($Caster)
					if $agentName == "" then $agentName = $Caster  & " 号机体"
				endif

				if $targetName == "" then
					$agentName = GetPlayerName($Target)
					if $targetName == "" then $targetName = $Target  & " 号机体"
				endif

				$agentName=StringRegExpReplace($agentName, "\[.*?\]", "")
				$targetName= StringRegExpReplace($targetName, "\[.*?\]", "")

				Local $agentEnergy
				if $Completed == "零施展" then
					$agentEnergy = Round(DllStructGetData($lCasterStruct, 'MaxEnergy') * DllStructGetData($lCasterStruct, 'EnergyPercent') - GetSkillEnergyCost($Skill))
					$agentEnergy = "~"&$agentEnergy
				else
					$agentEnergy = Round(DllStructGetData($lCasterStruct, 'MaxEnergy') * DllStructGetData($lCasterStruct, 'EnergyPercent'))
				endif

				if $Completed then
					if $Caster == $Target then
						if $pinDao then
							Sendchat(""&$agentName&"["&$agentEnergy&"蓝] 施展了: <<"&$skillLink&">>", $pinDao)
						else
							WriteChat(""&$agentName&"["&$agentEnergy&"蓝] 施展了: <<"&$skillLink&">>")
						endif
					else
						if $pinDao then
							Sendchat(""&$agentName&"["&$agentEnergy&"蓝] 对 "&$targetName&"("&$Target&"号) 施展了: <<"&$skillLink&">>", $pinDao)
						else
							WriteChat(""&$agentName&"["&$agentEnergy&"蓝] 对 "&$targetName&"("&$Target&"号) 施展了: <<"&$skillLink&">>")
						endif
					endif
					if $Skill == 979 and ($Target == 5212 or $Target == 5213 or $Target == 5199) then
						CallTarget($Target)
						WriteChat($Target)
					endif
					if DllStructGetData(GetAgentByID($Target), 'HP') < 0.30 then
						;(DllStructGetData(GetAgentByID($Target), 'MaxHP') * DllStructGetData(GetAgentByID($Target), 'HP'))
						SendChat("按 [T] 键，瞄准并杀掉目标", "#")
						CallTarget($Target)
					endif
				else
					if $pinDao then
						Sendchat(""&$agentName&"["&$agentEnergy&"蓝] 所发的 [["&$skillLink&"]] <<被断>><<被断>><<被断>>", $pinDao)
					else
						WriteChat(""&$agentName&"["&$agentEnergy&"蓝] 所发的 [["&$skillLink&"]] <<被断>><<被断>><<被断>>")
					endif
				endif
				;ChangeTarget($Target)
			endif
		endif
EndFunc

Func SkillComplete($Caster, $Target, $Skill)

	DuiYuan_ShiFa($Caster, $Target, $Skill)

EndFunc

Func SkillCancel($Caster, $Target, $Skill)

	DuiYuan_ShiFa($Caster, $Target, $Skill, false)

EndFunc

Func SkillActivate($aCaster, $aTarget, $aSkill, $aTime)

	if $aTime < 0.01 and (DllStructGetData(GetAgentByID($aCaster), 'Allegiance') == 1) then
		DuiYuan_ShiFa($aCaster, $aTarget, $aSkill, "零施展")
	endif

	if $aSkill == 1894 then ;阿尔古之触
		ChangeTarget($Caster)
		UseSkillByIDOnTarget(2358)
	endif


	#cs
	if $aSkill == 390 or $aSkill == 325 or $aSkill == 329 or $aSkill == 61 or $aSkill == 25 or $aSkill == 57 or $aSkill == 5 or $aSkill == 23 then

		;猛烈斩击,虚晃打击,碎颚,榨取纹章,强力吸收,挫折哭喊,强力封锁,强力钉刺
		;Case 390, 325, 329,61,25,57,5,23
			If ($aTarget == GetMyID()) Then
				Send("{ESCAPE}")
				writechat("rupt for me")
				while GetIsCasting(-2)
					CancelAction()
					Send("{ESCAPE}")
					writechat("防断")
				Wend
			endif
	endif
	#ce
	;本人在山顶
	if ($aSkill == 460) then
		Local $myCharr = GetAgentByID(-2)
		if (ComputeDistance(DllStructGetData($myCharr, 'X'),DllStructGetData($myCharr, 'Y'), -8497, -5330) < 900) Then
			if DllStructGetData($myCharr, 'MoveX') = 0 and DllStructGetData($myCharr, 'MoveY') = 0 Then
				;本人不在移动
				If GetDistance($aCaster) < 312 Then ;邻近距离x2内/adjacent
					If (GetIsDead($myCharr)==False) and (DllStructGetData($myCharr, 'HP') > 0) Then
						;ChangeTarget($aCaster)
						Attack($aCaster)
						writechat("断巨兽")
					EndIf
				EndIf
			EndIf
		EndIf
	endif

EndFunc

Func HasEffect($fSkillID)
   return (DllStructGetData(GetEffect($fSkillID), "SkillID") == $fSkillID)
EndFunc

func updateData()

	$mMe = 0
	$mTgt = 0

	$mMe = GetAgentByID(-2)
	$mTgt = GetAgentByID(-1)

	$tStorage = GetCharname()
	$testVariable = HasEffect(3134)
	if ($mName <> $tStorage) or ($testVariable <> $isSpirit) Then

		$isSpirit = $testVariable

		$SfSlot = -1
		$ShroudSlot = -1
		$OfSlot = -1

		$burningSlot = -1
		$spiritBondSlot = -1
		$infuseSlot = -1
		$protSlot = -1
		$lifeSlot = -1
		$balthSlot = -1
		$eeSlot = -1
		$renewalSlot = -1

		$sosSlot = -1
		$bloodsongSlot = -1
		$piSlot = -1
		$sqSlot = -1
		$qzSlot = -1
		$essencebondSlot = -1

		;Name Set
		$mName = $tStorage

		;Primary Profession Set
		$mProfession = GetHeroProfession(0)

		;Skillbar Set
		$mSkillbar = GetSkillbar()

		$skillCost[0] = 8
		$activationCost[0] = 8
		$skillName[0] = 8
		for $tloopIndex = 1 to 8
			$skillCost[$tloopIndex]=10000
			$activationCost[$tloopIndex]=10000
			$skillName[$tloopIndex] = ""
		Next


		;Template Skill ID's Set
		For $i = 1 to $mTemplate[0]
			$mTemplate[$i]= DllStructGetData($mSkillbar, 'ID'&$i)

			;Terra Skill Slots ID'd
			if $mTemplate[$i] = 826 then $SfSlot = $i
			if $mTemplate[$i] = 1031 then $ShroudSlot = $i
			if $mTemplate[$i] = 218 then $OfSlot = $i

			if $mTemplate[$i] = $SKILL_ID_BURNING_SPEED then
				$burningSlot = $i
				$skillCost[$i] = 10
				$activationCost[$i] = 250
				$skillName[$i] = "速度燃烧"
			EndIf

			if $mTemplate[$i] = $SKILL_ID_SPIRIT_BOND then
				$spiritBondSlot = $i
				$skillCost[$i] = 10
				$activationCost[$i] = 250
				$skillName[$i] = "精神连结"
			EndIf

			if $mTemplate[$i] = $SKILL_ID_INFUSE_HEALTH then
				$infuseSlot = $i
				$skillCost[$i] = 10
				$activationCost[$i] = 250
				$skillName[$i] = "生之礼赞"
			EndIf

			if $mTemplate[$i] = $SKILL_ID_PROT_BOND then
				$protSlot = $i
				$skillCost[$i] = 10
				$activationCost[$i] = 2000
				$skillName[$i] = "保护连结"
			EndIf

			if $mTemplate[$i] = $SKILL_ID_LIFE_BOND then
				$lifeSlot = $i
				$skillCost[$i] = 10
				$activationCost[$i] = 2000
				$skillName[$i] = "生命连结"
			EndIf

			if $mTemplate[$i] = $SKILL_ID_BALTHAZAR_SPIRIT then
				$balthSlot = $i
				$skillCost[$i] = 10
				$activationCost[$i] = 2000
				$skillName[$i] = "巴萨泽的精神"
			EndIf

			if $mTemplate[$i] = $SKILL_ID_EBON_ESCAPE then
				$eeSlot = $i
				$skillCost[$i] = 5
				$activationCost[$i] = 250
				$skillName[$i] = "黑檀脱逃"
			EndIf

			if $mTemplate[$i] = $SKILL_ID_ETHER_RENEWAL then
				$renewalSlot = $i
				$skillCost[$i] = 10
				$activationCost[$i] = 1000
				$skillName[$i] = "魔力复原"
			EndIf

			if $mTemplate[$i] = $SKILL_ID_SIGNET_OF_SPIRITS then
				$renewalSlot = $i
				$skillCost[$i] = 0
				$activationCost[$i] = 1000
				$skillName[$i] = "缚灵纹章"
			EndIf

			if $mTemplate[$i] = $SKILL_ID_BLOOD_SONG then
				$renewalSlot = $i
				$skillCost[$i] = 5
				$activationCost[$i] = 750
				$skillName[$i] = "血歌"
			EndIf

			if $mTemplate[$i] = $SKILL_ID_PAIN_INVERTER then
				$renewalSlot = $i
				$skillCost[$i] = 10
				$activationCost[$i] = 1000
				$skillName[$i] = "痛苦倒转"
			EndIf

			if $mTemplate[$i] = $SKILL_ID_SERPENTS_QUICKNESS then
				$renewalSlot = $i
				$skillCost[$i] = 5
				$activationCost[$i] = 0
				$skillName[$i] = "蛇之敏捷"
			EndIf

			if $mTemplate[$i] = $SKILL_ID_QUICKENING_ZEPHYR then
				$renewalSlot = $i
				$skillCost[$i] = 25
				$activationCost[$i] = 5000
				$skillName[$i] = "活力微风"
			EndIf

			if $mTemplate[$i] = $SKILL_ID_ESSENCE_BOND then
				$renewalSlot = $i
				$skillCost[$i] = 10
				$activationCost[$i] = 2000
				$skillName[$i] = "本质连结"
			EndIf

		Next
	EndIf

EndFunc


Func IsRechargedX($lSkill)
	Return GetSkillBarSkillRecharge($lSkill)==0
EndFunc

Func saveYourselfOperations()
	Local $powerstoneX = DllStructGetData($mMe,'X')
	Local $powerStoneY= DllStructGetData($mMe,'Y')
	if (GetEffectTimeRemaining(2522) > 0) and (GetMorale() < 10) and _
		((ComputeDistance($powerstoneX, $powerstoneY, 7807,-19388) < 2500) or (ComputeDistance($powerstoneX, $powerstoneY, 13869,-14394) < 2500)) and _
		((($SFSlot <> -1) and (NOT IsRechargedX($SfSlot)) and (GetEffectTimeRemaining(826) <= 0)) or (($OfSlot <> -1) and (NOT IsRechargedX($OfSlot)) and (GetEffectTimeRemaining(218) <= 0))) Then
			pconsScanInventory2($ITEM_ID_POWERSTONE)
			If $pcons_Slot[0] > 0 And $pcons_Slot[1] > 0 and (DllStructGetData(GetItemBySlot($pcons_Slot[0], $pcons_Slot[1]), 'ModelID') == $ITEM_ID_POWERSTONE) and _
				(GetIsDead(-2)==False) Then
				UseItemBySlot($pcons_Slot[0], $pcons_Slot[1]) ;<===============================
				if ($SFSlot<>-1) then useskill($SFSLot, -2)
			    if ($OFSlot<>-1) then useskill($OFSlot, -2)
			    ;writechat("["&@HOUR&":"&@MIN&":"&@SEC&"]"&" <用了粉石+技能>")
			EndIf
	  EndIf
EndFunc

Func shadowFormObsidianFlesh()
		If GetIsDead(-2) Then Return
		if $testVariable then Return
		; 暗影恢复时用暗影
		if $SfSlot <> -1 and IsRechargedX($SfSlot) Then
				UseSkillEx($SfSlot)
				;writechat("用了暗影")
		EndIf
		; 暗影恢复时用暗影
		if $OfSlot <> -1 and IsRechargedX($OfSlot) Then
				UseSkillEx($OfSlot)
				;writechat("用了黑曜石肉体")
		EndIf
EndFunc


Func UseSkillEx($lSkill, $lTgt=-2, $aTimeout = 3000)
	Local $lDeadlock = TimerInit()
	UseSkill($lSkill, $lTgt)
	Do
		Sleep(50)
		If GetIsDead(-2) = 1 Then Return
	Until (Not IsRechargedX($lSkill)) Or (TimerDiff($lDeadlock) > $aTimeout)
	RndSleep(750)
EndFunc

;~ This searches the bags for the specific pcon you wish to use.

Func pconsScanInventory2($ItemID)
	Local $bag
	Local $size
	Local $slot
	Local $item
	Local $ModelID
	$pcons_Slot[0] = 0
	$pcons_Slot[1] = 0
	$pconQuantity = 0
	For $bag = 1 To 4 Step 1
		If $bag == 1 Then $size = 20
		If $bag == 2 Then $size = 5
		If $bag == 3 Then $size = 10
		If $bag == 4 Then $size = 10
		For $slot = 1 To $size Step 1
			;注: 原文: $item = GetItemBySlot($bag, $slot) <===CCC===
			$item = GetItemBySlot($bag, $slot)

			;注: 原文: $ModelID = DllStructGetData($item, "ModelID") <===CCC===
			$ModelID = DllStructGetData($item, 'modelID')

			Switch $ModelID
				Case 0
					ContinueLoop
				Case $ItemID
					$pcons_Slot[0] = $bag
					$pcons_Slot[1] = $slot
					;注: 原文: $pconQuantity += DllStructGetData($item, 'Quantity') <===CCC===
					$pconQuantity += DllStructGetData($item,'Quantity')
			EndSwitch
		Next
	Next
EndFunc   ;==>pconsScanInventory2


Func SkeletalOperations()

	If $ToggleSkeleton and NOT HasEffect($EFFECT_WEAKENED_BY_DHUUM) then ; means effect is off

		;注: 原文: $tempCurrentTarget=GetAgentByID(-1);GetCurrentTarget();declared globally in constants.au3 <===CCC===
		$tempCurrentTarget=GetAgentPtr(-1);GetCurrentTargetPtr();declared globally in constants.au3 ;getcurrenttargetid()

		;注: 以下[=或需 IsPtr 或 MemoryRead=] <===CCC===
		local $locallocallocal = MemoryRead($tempCurrentTarget+244, "Word")
		If $locallocallocal == $MODELID_SKELETON_OF_DHUUM or $locallocallocal == 2339 Then

			if TimerDiff($skeleAimTimer) > 20*1000 then
				out("瞄准骷髅")
				;writechat; writechat("已瞄准骷髅，可更换目标，20秒内不再提示")
				$skeleAimTimer=TimerInit()
			EndIf
			;注: 以下[=或需 IsPtr 或 MemoryRead=] <===CCC===
			If MemoryRead($tempCurrentTarget+304, "float") > 0 And MemoryRead($tempCurrentTarget+304, "float") < 0.25 Then ;

				;注: 以下[=或需 IsPtr 或 MemoryRead=] <===CCC===
				out("骷髅血量为: "&round(MemoryRead($tempCurrentTarget+304, "float")*100, 2)&"%")

				;注: 原文: If GetDistance(getagentbyid(-2), $tempCurrentTarget) < 400 Then <===CCC===
				If GetDistance(GetAgentPtr(-2), $tempCurrentTarget) < 400 Then

					out("骷髅在捕捉范围内")
						pconsScanInventory2($ITEM_ID_MOBSTOPPER)
						;RndSleepEx(GetPing()+1000)
					If (GetMapLoading() == 1) And (GetIsDead(-2) == False) Then
							If $pcons_Slot[0] > 0 And $pcons_Slot[1] > 0 Then
								;注: 以下[=或需 IsPtr 或 MemoryRead=] <===CCC===
								;注: 原文: If DllStructGetData(GetItemBySlot($pcons_Slot[0], $pcons_Slot[1]), "ModelID") == $ITEM_ID_MOBSTOPPER and (TimerDiff($SkeletalTimer) > 5000) Then <===CCC===
								If MemoryRead(GetItemBySlot($pcons_Slot[0], $pcons_Slot[1])+44, "long") == $ITEM_ID_MOBSTOPPER and (TimerDiff($SkeletalTimer) > 5000) Then

									out("==抓骷髅==")
									out("所剩笼子数为: "&($pconQuantity-1)&" 个")
									UseItemBySlot($pcons_Slot[0], $pcons_Slot[1])
									;writechat; writechat("["&@HOUR&":"&@MIN&":"&@SEC&"]"&" 用了骷髅笼子")
									$SkeletalTimer = TimerInit()
								EndIf
							else
								ToggleSkeleton();~ 抓骷髅开关
								writechat("骷髅笼子已尽，已关闭相应功能")
								$SkeletalTimer = TimerInit()
								SoundSetWaveVolume(100)
								soundplay("辅助文件\铃响.mp3")
							EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	clearmemory()
EndFunc