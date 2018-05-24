#RequireAdmin
#NoTrayIcon
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <GuiEdit.au3>
#include "../../激战接口.au3"

Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)

; 稀有状态号
Global Const $RARITY_GOLD = 2624
Global Const $RARITY_PURPLE = 2626
Global Const $RARITY_BLUE = 2623
Global Const $RARITY_WHITE = 2621
Global Const $RARITY_GREEN = 2627

; 常见品号
Global Const $ITEM_ID_LOCKPICKS = 22751
Global Const $ITEM_ID_ID_KIT = 2989
Global Const $ITEM_ID_SUP_ID_KIT = 5899
Global Const $ITEM_ID_SALVAGE_KIT = 2992
Global Const $ITEM_ID_EXP_SALVAGE_KIT = 2991
Global Const $ITEM_ID_SUP_SALVAGE_KIT = 5900

; 其它物品号
Global $Array_Pickup[5] = [930, 3746, 32557, 935, 5882]

#cs
Global $Array_Pickup[149] = [32557, 5882, 474, 476, 486, 522, 525, 811, 819, 822, 835, 610, 2994, 19185, 22751, 4629, 24630, 4631, 24632, 27033, 27035, 27044, 27046, 27047, 7052, 5123 _
		, 1796, 21797, 21798, 21799, 21800, 21801, 21802, 21803, 21804, 1805, 910, 2513, 5585, 6049, 6366, 6367, 6375, 15477, 19171, 22190, 24593, 28435, 30855, 31145, 31146, 35124, 36682 _
		, 6376 , 6368 , 6369 , 21809 , 21810, 21813, 29436, 29543, 36683, 4730, 15837, 21490, 22192, 30626, 30630, 30638, 30642, 30646, 30648, 31020, 31141, 31142, 31144, 1172, 15528 _
		, 15479, 19170, 21492, 21812, 22269, 22644, 22752, 28431, 28432, 28436, 1150, 35125, 36681, 3256, 3746, 5594, 5595, 5611, 5853, 5975, 5976, 21233, 22279, 22280, 6370, 21488 _
		, 21489, 22191, 35127, 26784, 28433, 18345, 21491, 28434, 35121, 921, 922, 923, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943 _
		, 944, 945, 946, 948, 949, 950, 951, 952, 953, 954, 955, 956, 6532, 6533]
#ce

; 更多物品号/备用， 与上重复
Global $ModelsAlcohol[100] = [910, 2513, 5585, 6049, 6366, 6367, 6375, 15477, 19171, 22190, 24593, 28435, 30855, 31145, 31146, 35124, 36682]
Global $ModelSweetOutpost[100] = [15528, 15479, 19170, 21492, 21812, 22644, 31150, 35125, 36681]
Global $ModelsSweetPve[100] = [22269, 22644, 28431, 28432, 28436]
Global $ModelsParty[100] = [6368, 6369, 6376, 21809, 21810, 21813]

; 材料
Global $PIC_MATS[24][2] = [["Fur Square", 941],["Bolt of Linen", 926],["Bolt of Damask", 927],["Bolt of Silk", 928],["Glob of Ectoplasm", 930],["Steel of Ignot", 949],["Deldrimor Steel Ingot", 950],["Monstrous Claws", 923],["Monstrous Eye", 931],["Monstrous Fangs", 932],["Rubies", 937],["Sapphires", 938],["Diamonds", 935],["Onyx Gemstones", 936],["Lumps of Charcoal", 922],["Obsidian Shard", 945],["Tempered Glass Vial", 939],["Leather Squares", 942],["Elonian Leather Square", 943],["Vial of Ink", 944],["Rolls of Parchment", 951],["Rolls of Vellum", 952],["Spiritwood Planks", 956]]

; 燃料颜色号
Global Const $ITEM_ID_DYES = 146
Global Const $ITEM_EXTRAID_BLUEDYE = 2
Global Const $ITEM_EXTRAID_GREENDYE = 3
Global Const $ITEM_EXTRAID_PURPLEDYE = 4
Global Const $ITEM_EXTRAID_REDDYE = 5
Global Const $ITEM_EXTRAID_YELLOWDYE = 6
Global Const $ITEM_EXTRAID_BROWNDYE = 7
Global Const $ITEM_EXTRAID_ORANGEDYE = 8
Global Const $ITEM_EXTRAID_SILVERDYE = 9
Global Const $ITEM_EXTRAID_BLACKDYE = 10
Global Const $ITEM_EXTRAID_GRAYDYE = 11
Global Const $ITEM_EXTRAID_WHITEDYE = 12
Global Const $ITEM_EXTRAID_PINKDYE = 13

; 酒
Global $Alcohol_Array[11] = [910, 5585, 6366, 6375, 22190, 24593, 28435, 30855, 31145, 35124, 36682]
Global Const $ITEM_ID_HUNTERS_ALE = 910
Global Const $ITEM_ID_DWARVEN_ALE = 5585
Global Const $ITEM_ID_SPIKED_EGGNOG = 6366
Global Const $ITEM_ID_EGGNOG = 6375
Global Const $ITEM_ID_SHAMROCK_ALE = 22190
Global Const $ITEM_ID_AGED_DWARVEN_ALE = 24593
Global Const $ITEM_ID_CIDER = 28435
Global Const $ITEM_ID_GROG = 30855
Global Const $ITEM_ID_AGED_HUNTERS_ALE = 31145
Global Const $ITEM_ID_KRYTAN_BRANDY = 35124
Global Const $ITEM_ID_BATTLE_ISLE_ICED_TEA = 36682

; 节日
Global $Spam_Party_Array[5] = [6376, 21809, 21810, 21813, 36683]
Global Const $ITEM_ID_SNOWMAN_SUMMONER = 6376
Global Const $ITEM_ID_ROCKETS = 21809
Global Const $ITEM_ID_POPPERS = 21810
Global Const $ITEM_ID_SPARKLER = 21813
Global Const $ITEM_ID_PARTY_BEACON = 36683

; 糖
Global $Spam_Sweet_Array[6] = [21492, 21812, 22269, 22644, 22752, 28436]
Global Const $ITEM_ID_FRUITCAKE = 21492
Global Const $ITEM_ID_BLUE_DRINK = 21812
Global Const $ITEM_ID_CUPCAKES = 22269
Global Const $ITEM_ID_BUNNIES = 22644
Global Const $ITEM_ID_GOLDEN_EGGS = 22752
Global Const $ITEM_ID_PIE = 28436

; 变身
Global $Tonic_Party_Array[4] = [15837, 21490, 30648, 31020]
Global Const $ITEM_ID_TRANSMOGRIFIER = 15837
Global Const $ITEM_ID_YULETIDE = 21490
Global Const $ITEM_ID_FROSTY = 30648
Global Const $ITEM_ID_MISCHIEVIOUS = 31020

; 去惩罚
Global $DPRemoval_Sweets[6] = [6370, 21488, 21489, 22191, 26784, 28433]
Global Const $ITEM_ID_PEPPERMINT_CC = 6370
Global Const $ITEM_ID_WINTERGREEN_CC = 21488
Global Const $ITEM_ID_RAINBOW_CC = 21489
Global Const $ITEM_ID_CLOVER = 22191
Global Const $ITEM_ID_HONEYCOMB = 26784
Global Const $ITEM_ID_PUMPKIN_COOKIE = 28433

; 其它
Global $Special_Drops[7] = [5656, 18345, 21491, 37765, 21833, 28433, 28434]
Global Const $ITEM_ID_CC_SHARDS = 556
Global Const $ITEM_ID_VICTORY_TOKEN = 18345
Global Const $ITEM_ID_WINTERSDAY_GIFT = 21491
Global Const $ITEM_ID_WAYFARER_MARK = 37765
Global Const $ITEM_ID_LUNAR_TOKEN = 21833
Global Const $ITEM_ID_LUNAR_TOKENS = 28433
Global Const $ITEM_ID_TOTS = 28434

Global Const $ITEM_ID_GLACIAL_STONES = 27047
Global Const $ITEM_ID_Mesmer_Tome = 21797

; 部分集合
Global $Array_pscon[39]=[$ITEM_ID_HUNTERS_ALE, $ITEM_ID_DWARVEN_ALE, $ITEM_ID_SPIKED_EGGNOG, $ITEM_ID_EGGNOG, $ITEM_ID_SHAMROCK_ALE, $ITEM_ID_AGED_DWARVEN_ALE, $ITEM_ID_CIDER, _
$ITEM_ID_GROG, $ITEM_ID_AGED_HUNTERS_ALE, $ITEM_ID_KRYTAN_BRANDY, $ITEM_ID_BATTLE_ISLE_ICED_TEA, $ITEM_ID_SNOWMAN_SUMMONER, $ITEM_ID_ROCKETS, $ITEM_ID_POPPERS, $ITEM_ID_SPARKLER, _
$ITEM_ID_PARTY_BEACON, $ITEM_ID_FRUITCAKE, $ITEM_ID_BLUE_DRINK, $ITEM_ID_CUPCAKES, $ITEM_ID_BUNNIES, $ITEM_ID_GOLDEN_EGGS, $ITEM_ID_PIE, $ITEM_ID_TRANSMOGRIFIER, $ITEM_ID_YULETIDE, _
$ITEM_ID_FROSTY, $ITEM_ID_MISCHIEVIOUS, $ITEM_ID_PEPPERMINT_CC, $ITEM_ID_WINTERGREEN_CC, $ITEM_ID_RAINBOW_CC, $ITEM_ID_CLOVER, $ITEM_ID_HONEYCOMB, $ITEM_ID_PUMPKIN_COOKIE, $ITEM_ID_CC_SHARDS, _
$ITEM_ID_VICTORY_TOKEN, $ITEM_ID_WINTERSDAY_GIFT, $ITEM_ID_LUNAR_TOKEN, $ITEM_ID_LUNAR_TOKENS, $ITEM_ID_TOTS,36681] ;missing $ITEM_ID_GLACIAL_STONES

#Region TAP Declaration
	Global Const $runtimer = TimerInit()
	Global $mcycle
	Global $mexitcycle = False
	Global $mx, $my
	Global $mblockeddirection = 0
	Global $mteam
	Global $mteamothers
	Global $mteamdead
	Global $menemies
	Global $menemiesrange
	Global $menemiesspellrange
	Global $mspirits
	Global $mpets
	Global $mminions
	Global $mmiku
	Global $mself
	Global $mselfid
	Global $mlowestally
	Global $mlowestallyhp
	Global $mlowestotherally
	Global $mlowestotherallyhp
	Global $mlowestenemy
	Global $mlowestenemyhp
	Global $mclosestenemy
	Global $mclosestenemydist
	Global $meffects
	Global $mskillbar
	Global $menergy
	Global $mdazed = False
	Global $mblind = False
	Global $mskillhardcounter = False
	Global $mskillsoftcounter = 0
	Global $mattackhardcounter = False
	Global $mattacksoftcounter = 0
	Global $mallyspellhardcounter = False
	Global $menemyspellhardcounter = False
	Global $mspellsoftcounter = 0
	Global $mblocking = False
	Global $mskilltimer = TimerInit()
	Global $mcasttime = -1
	Global $mlasttarget = 0
	Global $homid = 646;849
	Global $boolrun = False
	Global $arrowexp = 849
	Global $btnstate = 0
	Global $startcash = 0
	Global $startvanguard = 0
	Global $vanguardnow
	Global $cashnow
	Global $warsupplies = 0
	Global $runs = 0
	Global $failrunscount = 0
	Global $RenderingEnabled = True
	Global $lastwptx
	Global $lastwpty
	Global $shadowsong[7] = [4195, 4197, 4182, 4198, 4199, 4181, 2843]
	Global $wptcount
	Global $move = False
	Global $ndeadlock = TimerInit()
#EndRegion TAP Declaration


Global $cgui = GUICreate("吉祥开端", 270, 225, 200, 180)
;Global $cbxidsell = GUICtrlCreateCheckbox("鉴定/卖", 8, 38, 110, 17)
;Global $goldz = GUICtrlCreateCheckbox("存金", 135, 60, 75, 17)
;Global $cbxpickall = GUICtrlCreateCheckbox("捡起所有东西", 8, 60, 110, 17)
Global $lblname = GUICtrlCreateLabel("角色名:", 8, 8, 80, 17) ;BitOR($ss_center, $ss_centerimage)
Global $inputcharname = GUICtrlCreateCombo("", 105, 8, 150, 21)
Global $cbxhidegw = GUICtrlCreateCheckbox("停止成像", 8, 38, 110, 17)
Global $lblr2d2 = GUICtrlCreateLabel("总次数: ", 8, 68, 130, 17)
Global $lblruns = GUICtrlCreateLabel("-", 140, 68, 100, 17, $ss_center)
Global $lblfailruns = GUICtrlCreateLabel("失败次数: ", 8, 88, 113, 17)
Global $lblfailrunscount = GUICtrlCreateLabel("-", 140, 88, 100, 17, BitOR($ss_center, $ss_centerimage))
Global $lblcash = GUICtrlCreateLabel("所获现金:", 8, 108, 130, 17)
Global $lblgold = GUICtrlCreateLabel("-", 140, 108, 100, 17, $ss_center)
Global $lblfaction = GUICtrlCreateLabel("所获分数:", 8, 128, 130, 17)
Global $lblvanguard = GUICtrlCreateLabel("-", 140, 128, 100, 17, $ss_center)
Global $lblluxon = GUICtrlCreateLabel("战承物资:", 8, 148, 130, 17)
Global $lblws = GUICtrlCreateLabel("-", 140, 148, 100, 17, $ss_center)
Global $lblstatus = GUICtrlCreateLabel("准备开始", 8, 175, 256, 17, $ss_center)
Global $btnstart = GUICtrlCreateButton("开始", 7, 195, 256, 25, $ws_group)
;Global $glogbox = GUICtrlCreateEdit("", 8, 262, 260, 170, 2097220)
;Global $flog = FileOpen("操作记录.log", 129)
;GUICtrlSetState($cbxpickall, $gui_disable)
;GUICtrlSetState($goldz, $gui_disable)
;GUICtrlSetState($cbxidsell, $gui_disable)
GUICtrlSetOnEvent($cbxhidegw, "EventHandler")
GUICtrlSetOnEvent($btnstart, "EventHandler")
GUISetOnEvent($gui_event_close, "EventHandler")
GUISetState(@SW_SHOW)

Local $master_Timer = TimerInit()

While 1


	If $boolrun Then
		GUICtrlSetData($lblvanguard, getvanguardtitle() - $startvanguard)
		GUICtrlSetData($lblgold, getgoldcharacter() - $startcash)
		GUICtrlSetData($lblruns, $runs)
		GUICtrlSetData($lblfailrunscount, $failrunscount)
		main()
	EndIf
WEnd

Func main()
	Local $lgold = getgoldcharacter()

	If ($lgold > 95000) and (GetGoldStorage() < 1000000) Then
		travelto(642)
		depositgold($lgold)
	EndIf

	clearmemory()

	If getmapid() = 849 Then
		If runningquest() Then
			$runs = $runs + 1
			Sleep(5000)
		Else
			$failrunscount = $failrunscount + 1
			Sleep(5000)
			returntooutpost()
			Sleep(5000)
			waitmaploading($homid)
			main()
		EndIf
	ElseIf getmapid() = 646 Then
		enterquest()
	ElseIf (getmapid() = 642) OR (getmapid() = 821) Then
		enterhom()
	Else
		travelto(642)
	EndIf
EndFunc

Func eventhandler()
	Switch (@GUI_CtrlId)
		Case $btnstart
			$boolrun = True
			GUICtrlSetData($btnstart, "正在启动...")
			GUICtrlSetState($btnstart, $gui_disable)
			GUICtrlSetState($inputcharname, $gui_disable)
			If initialize(GUICtrlRead($inputcharname), True, True, True) = False Then
				MsgBox(0, "失败", "无法找到角色")
				Exit
			EndIf
			$startvanguard = getvanguardtitle()
			$startcash = getgoldcharacter()
			WinSetTitle($cgui, "", "刷物资")
			GUICtrlSetData($btnstart, "已启动")
			setmaxmemory()
		Case $cbxhidegw
			clearmemory()
			togglerendering()
		Case $gui_event_close
			Exit
	EndSwitch
EndFunc

Func enterhom()
	out("走向殿堂")
	moveto(-3477, 4245)
	moveto(-4060, 4675)
	moveto(-4448, 4952)
	move(-4779, 5209)
	waitmaploading($homid)
	rndsleep(3000)
EndFunc

Func enterquest()
	out("启动任务")
	Local $npc = getnearestnpctocoords(-6753, 6513)
	gotonpc($npc)
	rndsleep(1000)
	changeweaponset(4)
	rndsleep(1000)
	dialog(0x00000632);1586
	waitmaploading($arrowexp)
	rndsleep(3000)
EndFunc

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

Func runningquest()
	Local $ltime
	$ltime = TimerInit()
	If getmapid() <> 849 Then
		Return False
	EndIf
	out("开始")
	If NOT aggromovetoex(11828, -4815, "等待") Then Return False
	waitforenemies(1550, 60000)
	Global $mwaypoints[21][4] = [[11125, -5226, "干道 1", 1250], [10338, -5966, "干道 2", 1250], [9871, -6464, "干道 3", 1250], _
	[8933, -8213, "干道 4", 1250], [7498, -8517, "干道 6", 1250], [5193, -8514, "或跳过这组敌人", 1600], _
	[3082, -11112, "或跳过树林", 1300], [1743, -12859, "杀树林之敌", 1300], [-181, -12791, "离开树林", 1250], _
	[-2728, -11695, "干道 16", 1250], [-2858, -11942, "岔道 17", 1250], [-4212, -12641, "岔道 18", 1250], [-4276, -12771, "岔道 19", 1250], _
	[-6884, -11357, "岔道 20", 1250], [-9085, -8631, "岔道 22", 1250], [-13156, -7883, "岔道 23", 1250], [-13768, -8158, "终点区 30", 1250], _
	[-14205, -8373, "终点区 31", 1250], [-15876, -8903, "终点区 32", 1250], [-17109, -8978, "终点区 33", 1250], ["等待敌人", 1500, 25000, False]]

	If NOT runwaypoints() Then Return False
	out("此圈耗时 " & Round(TimerDiff($ltime) / 60000) & " 分.")
	Do
		Sleep(100)
	Until getmapid() = 646 OR getisdead(-2)
	rndsleep(5000)
#cs
	if TimerDiff($master_Timer) > 60000*30 Then
		Local $loop_Timer = TimerInit()
		out("半小时暂停")
		while TimerDiff($loop_Timer) < 60000*30
			sleep(500)
		WEnd
		$master_Timer = TimerInit()
	EndIf
#ce
	Return True
EndFunc

Func _purgehook()
	togglerendering()
	Sleep(Random(2000, 2500))
	togglerendering()
EndFunc

Func runwaypoints()
	Local $lx, $ly, $lmsg, $lrange
	$wptcount = 0
	For $i = 0 To 20
		$lx = $mwaypoints[$i][0]
		$ly = $mwaypoints[$i][1]
		$lmsg = $mwaypoints[$i][2]
		$lrange = $mwaypoints[$i][3]
		If IsString($lx) Then
			Call("waitforenemies", $ly, $lmsg, $lrange)
		Else
			If NOT aggromovetoex($lx, $ly, $lmsg, $lrange) Then Return False
		EndIf
		$wptcount = $wptcount + 1
	Next
	Return True
EndFunc

Func countspirits()
	Local $lshadowsong
	Local $lspiritsinrange
	If $mspirits[0] = 0 Then Return False
	For $i = 1 To $mspirits[0]
		If getdistance($mspirits[$i]) > 1500 Then ContinueLoop
		$lspiritsinrange = $lspiritsinrange + 1
		If DllStructGetData($mspirits[$i], "PlayerNumber") = 4181 Then
			$lshadowsong = True
		EndIf
	Next
	If $lspiritsinrange > 2 OR $lshadowsong Then Return True
EndFunc

Func checkforspirits($movebackx, $movebacky)
	Local $lenemy
	Local $j
	If NOT countspirits() Then Return True
	$j = 1
	Do
		If getisdead(-2) Then Return False
		If $wptcount < 4 OR $wptcount = (UBound($mwaypoints) - 1) Then Return True
		If $wptcount - $j < 0 Then Return True
		If IsString($mwaypoints[$wptcount - $j][0]) Then Return True
		out("有灵，跑到里程点 " & $wptcount - $j)
		moveto($mwaypoints[$wptcount - $j][0], $mwaypoints[$wptcount - $j][1])
		$j = $j + 1
		$ndeadlock = TimerInit()
		Sleep(2000)
	Until NOT countspirits()
	out("回归干道")
	If NOT aggromovetoex($movebackx, $movebacky) Then Return False
	Return True
EndFunc

#Region CastEngine

	Func castengine($askill = False, $atarget = 0)
		If NOT $askill Then
			If TimerDiff($mskilltimer) < $mcasttime Then Return False
			$mcasttime = -1
			Local $ldeadlock = TimerInit()
			If cast() Then
				Do
					Sleep(3)
				Until $mcasttime > -1 OR TimerDiff($ldeadlock) > getping() + 175
				Return True
			EndIf
		Else
			If TimerDiff($mskilltimer) < $mcasttime Then Sleep($mcasttime - TimerDiff($mskilltimer))
			$mcasttime = -1
			Local $ldeadlock = TimerInit()
			useskill($askill, $atarget)
			Do
				Sleep(3)
			Until $mcasttime > -1 OR TimerDiff($ldeadlock) > getping() + 750
			If $mcasttime > -1 Then Sleep($mcasttime)
		EndIf
		Return False
	EndFunc

	Func canuseskill($askillslot, $aenergy = 0, $asoftcounter = 10)
		If $mskillhardcounter Then Return False
		If $mskillsoftcounter > $asoftcounter Then Return False
		If $menergy < $aenergy Then Return False
		If DllStructGetData($mskillbar, "Recharge" & $askillslot) == 0 Then
			Local $lskill = getskillbyid(DllStructGetData($mskillbar, "Id" & $askillslot))
			If DllStructGetData($mskillbar, "AdrenalineA" & $askillslot) < DllStructGetData($lskill, "Adrenaline") Then Return False
			Switch DllStructGetData($lskill, "Type")
				Case 7, 10, 3, 12, 15, 16, 19, 20, 21, 22, 26, 27, 28
				Case 14
					If $mattackhardcounter Then Return False
					If $mattacksoftcounter > $asoftcounter Then Return False
				Case 4, 5, 6, 9, 11, 24, 25
					If $mspellsoftcounter > $asoftcounter Then Return False
					If $mdazed Then
						If DllStructGetData($lskill, "Activation") > 0.25 Then Return False
					EndIf
					Switch DllStructGetData($lskill, "Target")
						Case 3, 4
							If $mallyspellhardcounter Then Return False
						Case 5, 16
							If $menemyspellhardcounter Then Return False
						Case Else
					EndSwitch
			EndSwitch
			Return True
		EndIf
		Return False
	EndFunc

#EndRegion CastEngine
#Region Events

	Func skillactivate($acaster, $atarget, $askill, $aactivation)
		If DllStructGetData($acaster, "ID") == $mselfid Then
			If DllStructGetData($atarget, "Allegiance") == 3 Then $mlasttarget = DllStructGetData($atarget, "ID")
			$mskilltimer = TimerInit()
			$mcasttime = $aactivation * 1000 + DllStructGetData($askill, "Aftercast") * 1000 + 25 - getping() / 1.75
		EndIf
	EndFunc

	Func skillcancel($acaster, $atarget, $askill)
		If DllStructGetData($acaster, "ID") == $mselfid Then
			$mskilltimer = TimerInit()
			$mcasttime = 775
		EndIf
	EndFunc

#EndRegion Events


Func waitforenemies($adist, $iideadlock, $param = False)
	Local $ltarget, $ldistance
	Local $ssdeadlock = TimerInit()
	out("等待敌人")
	Do
		$ltarget = getnearestenemytoagent(-2)
		If NOT IsDllStruct($ltarget) Then ContinueLoop
		$ldistance = getdistance($ltarget, -2)
		If $ldistance < $adist Then fight(1500)
	Until TimerDiff($ssdeadlock) > $iideadlock
	Return False
EndFunc

Func cast()
	If getisknocked($mself) Then Return False
	$mmiku = getagentbyname("Miku")
	If DllStructGetData($mself, "HP") < 0.7 OR DllStructGetData($mmiku, "HP") < 0.5 Then
		If canuseskill(6, 2) Then
			useskill(6, $mselfid)
			Return True
		EndIf
	EndIf
	If canuseskill(1, 2) Then
		For $i = 1 To $menemiesrange[0]
			If gethashex($menemiesrange[$i]) Then
				useskill(1, $menemiesrange[$i])
				Return True
			EndIf
		Next
	EndIf
	If gethascondition($mself) Then
		If canuseskill(5, 3) Then
			useskill(5, $mlowestenemy)
			Return True
		EndIf
	EndIf
	If canuseskill(3, 1) Then
		For $i = 1 To $menemiesrange[0]
			If getisbleeding($menemiesrange[$i]) OR DllStructGetData($menemiesrange[$i], "Skill") <> 0 OR gettarget($menemiesrange[$i]) == $mselfid Then
				useskill(3, $menemiesrange[$i])
				Return True
			EndIf
		Next
	EndIf
	If canuseskill(4, 1) Then
		useskill(4, $mlowestenemy)
		Return True
	EndIf
	If canuseskill(2, 2) Then
		For $i = 1 To $menemiesrange[0]
			If gethascondition($menemiesrange[$i]) OR gettarget($menemiesrange[$i]) == $mselfid Then
				useskill(2, $menemiesrange[$i])
				Return True
			EndIf
		Next
	EndIf
	Return False
EndFunc

Func buildmaintenance()
	$mmiku = getagentbyname("Miku")
	If DllStructGetData($mself, "HP") < 0.7 OR DllStructGetData($mmiku, "HP") < 0.5 Then
		If canuseskill(6, 2) Then
			useskill(6, $mselfid)
			Return True
		EndIf
	EndIf
	Return False
EndFunc

Func fight($arange)
	Local $nx, $ny, $rnd, $rndrange
	update($arange)
	If $move Then move(DllStructGetData(-2, "X"), DllStructGetData(-2, "Y"), 250)
	$mlasttarget = DllStructGetData(-1, "ID")
	$ndeadlock = TimerInit()
	Do
		If getisdead($mself) Then ExitLoop
		If TimerDiff($ndeadlock) > 30000 Then
			out("被堵住")
			$magent = getagentbyname("Miku")
			moveto(DllStructGetData($magent, "X"), DllStructGetData($magent, "Y"), 200)
			$ndeadlock = TimerInit() + 20000
		EndIf
		update($arange)
		If $move Then
			out("发现陨石雨或僧光, 跑.")
			$rnd = Random(1, 4, 1)
			Switch $rnd
				Case 1
					move(DllStructGetData(-2, "X") + 250, DllStructGetData(-2, "Y"))
				Case 2
					move(DllStructGetData(-2, "X") - 250, DllStructGetData(-2, "Y"))
				Case 3
					move(DllStructGetData(-2, "X"), DllStructGetData(-2, "Y") + 250)
				Case 4
					move(DllStructGetData(-2, "X"), DllStructGetData(-2, "Y") - 250)
			EndSwitch
		EndIf
		$nx = DllStructGetData($mself, "X")
		$ny = DllStructGetData($mself, "Y")
		If NOT checkforspirits($nx, $ny) Then Return False
		castengine()
	Until $menemiesrange[0] = 0
	If TimerDiff($mskilltimer) < $mcasttime Then Sleep($mcasttime - TimerDiff($mskilltimer))
	Sleep(Random(500, 1000, 1))
	If getisdead($mself) Then
		Return False
	EndIf
	pickuploot()
	Return True
EndFunc

Func update($arange)
	$mselfid = getmyid()
	$mself = getagentbyid($mselfid)
	$menergy = getenergy($mself)
	$mskillbar = getskillbar()
	$meffects = geteffect()
	If NOT IsArray($meffects) Then Dim $meffects[1] = [0]
	$mdazed = False
	$mblind = False
	$mskillhardcounter = False
	$mskillsoftcounter = 0
	$mattackhardcounter = False
	$mattacksoftcounter = 0
	$mallyspellhardcounter = False
	$menemyspellhardcounter = False
	$mspellsoftcounter = 0
	$mblocking = False
	$move = False
	For $i = 1 To $meffects[0]
		Switch DllStructGetData($meffects[$i], "SkillID")
			Case 485
				$mdazed = True
			Case 479
				$mblind = True
			Case 30, 764
				$mskillhardcounter = True
			Case 51, 127
				$mallyspellhardcounter = True
			Case 46, 979, 3191
				$menemyspellhardcounter = True
			Case 878, 3234
				$mskillsoftcounter += 1
				$mspellsoftcounter += 1
				$mattacksoftcounter += 1
			Case 28, 128
				$mspellsoftcounter += 1
			Case 47, 43, 2056, 3195
				$mattackhardcounter = True
			Case 123, 26, 3151, 121, 103, 66
				$mattacksoftcounter += 1
			Case 380, 810
				$mblocking = True
		EndSwitch
	Next
	Local $lagent
	Local $lteam = DllStructGetData($mself, "Team")
	Local $lhp
	Local $ldistance
	Local $lmodel
	Dim $mteam[1] = [0]
	Dim $mteamothers[1] = [0]
	Dim $mteamdead[1] = [0]
	Dim $menemies[1] = [0]
	Dim $menemiesrange[1] = [0]
	Dim $menemiesspellrange[1] = [0]
	Dim $mspirits[1] = [0]
	Dim $mpets[1] = [0]
	Dim $mminions[1] = [0]
	$mlowestally = $mself
	$mlowestallyhp = 1
	$mlowestotherally = 0
	$mlowestotherallyhp = 2
	$mlowestenemy = 0
	$mlowestenemyhp = 2
	$mclosestenemy = 0
	$mclosestenemydist = 5000
	For $i = 1 To getmaxagents()
		$lagent = getagentbyid($i)
		If DllStructGetData($lagent, "Type") <> 219 Then ContinueLoop
		$lhp = DllStructGetData($lagent, "HP")
		$ldistance = getdistance($lagent, $mself)
		Switch DllStructGetData($lagent, "Allegiance")
			Case 1
				If NOT BitAND(DllStructGetData($lagent, "Typemap"), 131072) Then ContinueLoop
				If NOT getisdead($lagent) AND $lhp > 0 Then
					$mteam[0] += 1
					ReDim $mteam[$mteam[0] + 1]
					$mteam[$mteam[0]] = $lagent
					If $lhp < $mlowestallyhp Then
						$mlowestally = $lagent
						$mlowestallyhp = $lhp
					ElseIf $lhp = $mlowestallyhp Then
						If $ldistance < getdistance($mlowestally, $mself) Then
							$mlowestally = $lagent
							$mlowestallyhp = $lhp
						EndIf
					EndIf
					If $i <> $mselfid Then
						$mteamothers[0] += 1
						ReDim $mteamothers[$mteamothers[0] + 1]
						$mteamothers[$mteamothers[0]] = $lagent
						If $lhp < $mlowestotherallyhp Then
							$mlowestotherally = $lagent
							$mlowestotherallyhp = $lhp
						ElseIf $lhp = $mlowestotherallyhp Then
							If $ldistance < getdistance($mlowestotherally, $mself) Then
								$mlowestotherally = $lagent
								$mlowestotherallyhp = $lhp
							EndIf
						EndIf
					EndIf
				Else
					$mteamdead[0] += 1
					ReDim $mteamdead[$mteamdead[0] + 1]
					$mteamdead[$mteamdead[0]] = $lagent
				EndIf
			Case 3
				If getisdead($lagent) OR $lhp <= 0 Then ContinueLoop
				If BitAND(DllStructGetData($lagent, "Typemap"), 262144) Then
					$mspirits[0] += 1
					ReDim $mspirits[$mspirits[0] + 1]
					$mspirits[$mspirits[0]] = $lagent
				EndIf
				$lmodel = DllStructGetData($lagent, "PlayerNumber")
				$menemies[0] += 1
				ReDim $menemies[$menemies[0] + 1]
				$menemies[$menemies[0]] = $lagent
				If $ldistance <= $arange Then
					$menemiesrange[0] += 1
					ReDim $menemiesrange[$menemiesrange[0] + 1]
					$menemiesrange[$menemiesrange[0]] = $lagent
					If $lhp < $mlowestenemyhp Then
						$mlowestenemy = $lagent
						$mlowestenemyhp = $lhp
					ElseIf $lhp = $mlowestenemyhp Then
						If $ldistance < getdistance($mlowestenemy, $mself) Then
							$mlowestenemy = $lagent
							$mlowestenemyhp = $lhp
						EndIf
					EndIf
					If $ldistance < $mclosestenemydist Then
						$mclosestenemydist = $ldistance
						$mclosestenemy = $lagent
					EndIf
				EndIf
				If $ldistance <= 1240 Then
					$menemiesspellrange[0] += 1
					ReDim $menemiesspellrange[$menemiesspellrange[0] + 1]
					$menemiesspellrange[$menemiesspellrange[0]] = $lagent
					If getiscasting($lagent) Then
						Switch DllStructGetData($lagent, "Skill")
							Case 830, 192, 1083, 1372, 1380
								$move = True
						EndSwitch
					EndIf
				EndIf
			Case 4
				If getisdead($lagent) OR $lhp <= 0 Then ContinueLoop
				If BitAND(DllStructGetData($lagent, "Typemap"), 262144) Then
					$mspirits[0] += 1
					ReDim $mspirits[$mspirits[0] + 1]
					$mspirits[$mspirits[0]] = $lagent
					out("spirits: " & $mspirits[0])
				Else
					$mpets[0] += 1
					ReDim $mpets[$mpets[0] + 1]
					$mpets[$mpets[0]] = $lagent
				EndIf
			Case 5
				If NOT BitAND(DllStructGetData($lagent, "Typemap"), 131072) Then ContinueLoop
				If getisdead($lagent) OR $lhp <= 0 Then ContinueLoop
				$mminions[0] += 1
				ReDim $mminions[$mminions[0] + 1]
				$mminions[$mminions[0]] = $lagent
			Case Else
		EndSwitch
	Next
EndFunc

Func aggromovetoex($x, $y, $s = "", $z = 1250)
	Local $random = 50
	Local $iblocked = 0
	If $s <> "" Then out($s)
	buildmaintenance()
	move($x, $y, $random)
	$lme = getagentbyid(-2)
	$coordsx = DllStructGetData($lme, "X")
	$coordsy = DllStructGetData($lme, "Y")
	Do
		rndsleep(250)
		$oldcoordsx = $coordsx
		$oldcoordsy = $coordsy
		$nearestenemy = getnearestenemytoagent(-2)
		$ldistance = getdistance($nearestenemy, -2)
		If $ldistance < $z AND DllStructGetData($nearestenemy, "ID") <> 0 Then
			changeweaponset(3)
			If fight($z) = False Then
				out("角色已死")
				Return False
			EndIf
			changeweaponset(4)
		EndIf
		rndsleep(250)
		$lme = getagentbyid(-2)
		$coordsx = DllStructGetData($lme, "X")
		$coordsy = DllStructGetData($lme, "Y")
		If $oldcoordsx = $coordsx AND $oldcoordsy = $coordsy Then
			$iblocked += 1
			move($coordsx, $coordsy, 500)
			rndsleep(350)
			move($x, $y, $random)
			If getmaploading() == 2 Then disconnected()
		EndIf
		If getisdead(-2) Then
			Return False
		EndIf
	Until computedistance($coordsx, $coordsy, $x, $y) < 250 OR $iblocked > 20
	If getisdead(-2) Then
		Return False
	EndIf
	Return True
EndFunc

Func out($astring)
	;FileWriteLine($flog, @HOUR & ":" & @MIN & " - " & $astring)
	;ConsoleWrite(@HOUR & ":" & @MIN & " - " & $astring & @CRLF)
	GUICtrlSetData($lblstatus,@HOUR & ":" & @MIN & " - " & $astring); & @CRLF)
	;GUICtrlSetData($glogbox, GUICtrlRead($glogbox) & @HOUR & ":" & @MIN & " - " & $astring & @CRLF)
	;_guictrledit_scroll($glogbox, 4)
EndFunc


;~ Description: standard pickup function, only modified to increment a custom counter when taking stuff with a particular ModelID
Func PickUpLoot()
	Local $lAgent
	Local $lItem
	Local $lDeadlock
	Local $lBlocklock

	For $i = 1 To GetMaxAgents() ;merge 435 and 436 to return to normal
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

	Next

	For $i = 1 To GetMaxAgents()
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

	Next

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
	If (($lModelID == 2511) And (GetGoldCharacter() < 99000)) Then
		Return True	; gold coins (only pick if character has less than 99k in inventory)
	ElseIf ($lModelID=27035) Then
		Return True ;saurian bone
	ElseIf (($lModelID == $ITEM_ID_Mesmer_Tome) Or ($lModelID=21786) Or ($lModelID=21787) Or ($lModelID=21788) Or ($lModelID=21789) Or ($lModelID=21790) Or ($lModelID=21791) Or ($lModelID=21792) Or ($lModelID=21793) Or ($lModelID=21794) Or ($lModelID=21795) Or ($lModelID=21796) Or ($lModelID=21797) Or ($lModelID=21798) Or ($lModelID=21799) Or ($lModelID=21800) Or ($lModelID=21801) Or ($lModelID=21802) Or ($lModelID=21803) Or ($lModelID=21804) Or ($lModelID=21805)) Then
		Return True	; all tomes, not just mesmer
	ElseIf ($lModelID == $ITEM_ID_DYES) Then	; if dye
		If (($aExtraID == $ITEM_EXTRAID_BLACKDYE) Or ($aExtraID == $ITEM_EXTRAID_WHITEDYE))Then ; only pick white and black ones
			Return True
		EndIf
	ElseIf ($lRarity == $RARITY_GOLD) Then ; gold items
		Return True
	ElseIf ($lRarity == $RARITY_GREEN) Then ; 拿绿
		Return False
	elseif( $LMODELID == 35123) Then ;confessor's orders
		return true

;#cs 若蓝/紫中只要达标的匕首和盾
	; use getattribute from helper for list
	elseif ($LMODELID <> 146) and (($Requirement = 5) or ($Requirement = 6)) and (GetItemAttribute($aItem) = 29) and (GetItemMaxDmg($aItem) > 12)  Then

		Return True


	elseIf ($LMODELID <> 146) and ((($Requirement = 5) and (GetIsShield($aItem) > 12)) or _
							   (($Requirement = 6) and (GetIsShield($aItem) > 13)) or _
							   (($Requirement = 7) and (GetIsShield($aItem) > 14))) Then
		Return True

;#ce
	ElseIf ($lRarity == $RARITY_PURPLE) Then ;拿紫
		Return False
	ElseIf ($lRarity == $RARITY_BLUE) Then ;拿蓝
		Return False
	ElseIf($lModelID == $ITEM_ID_LOCKPICKS)Then
		Return True ; Lockpicks
	ElseIf($lModelID == $ITEM_ID_GLACIAL_STONES)Then
		Return True ; glacial stones
	ElseIf CheckArrayPscon($lModelID)Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>CanPickUp

Func CheckArrayPscon($lModelID)
For $p = 0 To (UBound($Array_pscon) -1)
	If ($lModelID == $Array_pscon[$p]) Then Return True
Next
EndFunc