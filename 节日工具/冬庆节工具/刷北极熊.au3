;~ Updated, compiled, revised and edited by RiflemanX
;~ Main, Pathing, and Skills by Danylia
;~ Additional operations and functions by Phat34
;~ Diconnect Function and Polar Bear Model_ID by Ralle1976
;~ New Get_Drunk_State function by Ralle1976
;~ Beta testing by DARKISM & Mystogan
;~ Upgraded stats trackers by so.sad
;~ Thanks for GWA2 Wiki http://wiki.gamerevision.com/index.php/GWA2
;~ Thanks to http://www.gamerevision.com Community for the informative site and knowledgeable community
;~	____________________________________
;~
;~ Summary:  Farms for Polar Bears Mini Pets from the final chest of the mission "Strength of Snow" during the Wintersaday Celebration
;~	_____________________________________
;~
;~ This was tested using an Assasin with the folowing info:
;~	    Level 20
;~		This Build: None.  The skills will be auto set when the mission begins
;~		Alt  Build: None tested at this time
;~		No Armor, Runes, or Insignias needed as the mission will auto-set to a standard index
;~ 		Q9 Caster Spear 20% Enchant, +5 Energy
;~		Q9/16 Shield
;~	_____________________________________
;
;~		 Testing was conducted over an 160 hour period.  At the time this was created the script
;		 was running very well with over 98% success rate with Monks, Assasins, and Rangers.  Others Chars stats not tracked
;~ Current issues to address:
;~		 A smart fight system that can help with final battle and Kite back into safe spots
;
;~  _____________________________________
;~
;~ Func HowToUseThisProgram()
;~		Unzip files
;~		Put both GWA2 and Kryra Farmer in same folder
;~		Start Guild Wars
;~ 		Log onto your Ritualist
;~ 		Run the Tangled Seed Farmer in AutoIt
;~      Select the character you want from the dropdown menu
;~ 		Click Start
;~ 		EndIf
;~ EndFunc

;~Tips:
;~		To increase speed, use sweets in town and use cupcakes for the mission
;~		Additionally, you can increase speed by NOT collecting candy canes or NOT accepting mission completed bonus.
;~		Many players may still want to collect candy canes and WD gifts for profit but again this slows down the runs.
;~		If you choose to go quicker by not accepting reward then change Global $iTakeReward to "0" down below.
#EndRegion About

#Region v9.3.1 Update
;~		Updated Notes for v9.3.1:
;~		General Script Clean-up
;~		Fixed Bug that casued it to use sweets x2 in town.
;~		Corrected Minor issue with warrior not casting dash at start
;~		Reduced Run time by 30 seconds by removing excess sleep times
;~		Renamed Checkboxes for Sweets, Alcohol, and Party Point useage
;~		Fixed Bug that kept "Polar Bear Detetected" message box from closing
;~		Corrected Model_ID that had Frosty Tonics and Snowman Summoners mixed up
;~		Corrected the use of Frosty and Mischevious Tonics if you run out of Yeultide Tonics
;~		Reduced Map Loading times by 8 seconds (previously 30 seconds now 22 seconds)
;~		Updated RndTravel() to prevent zoning into euro-english more often than intended
;~		Added "Use Party" option to use snowman summoners for party title and to keep inventory from filling up
;~		----------------------------------------------------------------------------------------------------------------
;~		PARTY, SWEETS, AND ALCOHOL TITLE PACKAGE (Ralle1976)
;~		New Party, Sweets, and Alcohol Title system. If selected, the title points will continue to prioritize Wintersday Items
;~		If you run out of Winterdday Items it will then begin using any other 1-point party, sweets, and alcohol in your inventory
;~		Once you run out of 1-point title point items it will begin using 2-point items and then finally 3-point items. It will not use 50 point items.

;~		-----------------------
;~		Update Notes from v8.9 - v9.2
;~		Repaired Pause Function
;~		Deleted "Start from Kamadan" checkbox
;~		Added Dual Radio Buttons for LA & Kamadan Support
;~		Condensed GUI Data and Shortend GUI overal length
;~		Fixed Slight Graphics break in GUI (Line break/Runs per Hour)
;~		Revised final battle safe spot coordinates to increase success rate
;~		Created Function for optional running script from Kamadan (For new Kamadan character creation)
#EndRegion


#Region To Do List
;~		To Do List:
;~		Pause Function still broken
;~		Find more ways to reduce overall run time
;~		Zoom camera in at last battle to watch fight (Door cuurently blocks view)
;~		Create Sweets Array to use other sweets if you run out of Fruitcake (Prioritize Fruitcakes 1st!)
;		Create Party Array to use other sweets if you run out of Fruitcake (Prioritize Fruitcakes 1st!)
;		Create Alcoho Array to use other sweets if you run out of Fruitcake (Prioritize Fruitcakes 1st!)
;~		Create Timer or Enemy Killed counter to determine when the last groups are fighting and join in
;~		Create a smart fight system that can help with final battle and Kite back into safe spots to speed up runs
#EndRegion

#include "../../激战接口.au3"
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <GuiEdit.au3>
;Opt("GUIOnEventMode", False)
Opt("GUICloseOnESC", False)
Opt("TrayIconHide", 1)

#Region Sweets
Global $Sweet_Town_Array[10] = [15528, 15479, 19170, 21492, 21812, 22644, 30208, 31150, 35125, 36681]
Global Const $ITEM_ID_Creme_Brulee = 15528
Global Const $ITEM_ID_Red_Bean_Cake = 15479
Global Const $ITEM_ID_Mandragor_Root_Cake = 19170
Global Const $ITEM_ID_Fruitcake = 21492
Global Const $ITEM_ID_Sugary_Blue_Drink = 21812
Global Const $ITEM_ID_Chocolate_Bunny = 22644
Global Const $ITEM_ID_MiniTreats_of_Purity = 30208
Global Const $ITEM_ID_Jar_of_Honey = 31150
Global Const $ITEM_ID_Krytan_Lokum = 35125
Global Const $ITEM_ID_Delicious_Cake = 36681
#EndRegion Sweets

#Region Alcohol
; For pickup use
Global $Alcohol_Array[19] = [6375, 2513, 5585, 6049, 6366, 6367, 910, 15477, 19171, 19172, 19173, 22190, 24593, 28435, 30855, 31145, 31146, 35124, 36682]
; For using them
Global $OnePoint_Alcohol_Array[11] = [6375, 5585, 6049, 6367, 910, 15477, 19171, 19172, 19173, 22190, 28435]
; Eggnog = 6375
Global $ThreePoint_Alcohol_Array[7] = [2513, 6366, 24593, 30855, 31145, 31146, 35124]

Global $FiftyPoint_Alcohol_Array[1] = [36682]

Global Const $ITEM_ID_Hunters_Ale = 910
Global Const $ITEM_ID_Flask_of_Firewater = 2513
Global Const $ITEM_ID_Dwarven_Ale = 5585
Global Const $ITEM_ID_Witchs_Brew = 6049
Global Const $ITEM_ID_Spiked_Eggnog = 6366
Global Const $ITEM_ID_Vial_of_Absinthe = 6367
Global Const $ITEM_ID_Eggnog = 6375
Global Const $ITEM_ID_Bottle_of_Rice_Wine = 15477
Global Const $ITEM_ID_Zehtukas_Jug = 19171
Global Const $ITEM_ID_Bottle_of_Juniberry_Gin = 19172
Global Const $ITEM_ID_Bottle_of_Vabbian_Wine = 19173
Global Const $ITEM_ID_Shamrock_Ale = 22190
Global Const $ITEM_ID_Aged_Dwarven_Ale = 24593
Global Const $ITEM_ID_Hard_Apple_Cider = 28435
Global Const $ITEM_ID_Bottle_of_Grog = 30855
Global Const $ITEM_ID_Aged_Hunters_Ale = 31145
Global Const $ITEM_ID_Keg_of_Aged_Hunters_Ale = 31146
Global Const $ITEM_ID_Krytan_Brandy = 35124
Global Const $ITEM_ID_Battle_Isle_Iced_Tea = 36682

#Region Party
Global $Spam_Party_Array[7] = [6376, 6369, 6368, 21809, 21810, 21813, 36683]
;Snowman Summoner = 6376
Global Const $ITEM_ID_Ghost_in_the_Box = 6368
Global Const $ITEM_ID_Squash_Serum = 6369
Global Const $ITEM_ID_Snowman_Summoner = 6376
Global Const $ITEM_ID_Bottle_Rocket = 21809
Global Const $ITEM_ID_Champagne_Popper = 21810
Global Const $ITEM_ID_Sparkler = 21813
Global Const $ITEM_ID_Crate_of_Fireworks = 29436 ; Not spammable
Global Const $ITEM_ID_Disco_Ball = 29543 ; Not Spammable
Global Const $ITEM_ID_Party_Beacon = 36683
#EndRegion Party

#Region Party Tonics
Global $Tonic_Party_Array[23] = [4730, 15837, 21490, 22192, 30624, 30626, 30628, 30630, 30632, 30634, 30636, 30638, 30640, 30642, 30646, 30648, 31020, 31141, 31142, 31144, 31172, 37771, 37772]
Global $Winters_Day_Tonics[3] = [21490, 31141, 30648]
;Yeultide 	  = 21490
;Mischievious = 31141
;Frosty Tonic = 30648
Global Const $ITEM_ID_Sinister_Automatonic_Tonic = 4730
Global Const $ITEM_ID_Transmogrifier_Tonic = 15837
Global Const $ITEM_ID_Yuletide_Tonic = 21490
Global Const $ITEM_ID_Beetle_Juice_Tonic = 22192
Global Const $ITEM_ID_Abyssal_Tonic = 30624
Global Const $ITEM_ID_Cerebral_Tonic = 30626
Global Const $ITEM_ID_Macabre_Tonic =30628
Global Const $ITEM_ID_Trapdoor_Tonic = 30630
Global Const $ITEM_ID_Searing_Tonic = 30632
Global Const $ITEM_ID_Autmatonic_Tonic = 30634
Global Const $ITEM_ID_Skeletonic_Tonic = 30636
Global Const $ITEM_ID_Boreal_Tonic = 30638
Global Const $ITEM_ID_Gelatinous_Tonic = 30640
Global Const $ITEM_ID_Phantasmal_Tonic = 30642
Global Const $ITEM_ID_Abominable_Tonic = 30646
Global Const $ITEM_ID_Frosty_Tonic = 30648
Global Const $ITEM_ID_Mischievious_Tonic = 31020
Global Const $ITEM_ID_Mysterious_Tonic = 31141
Global Const $ITEM_ID_Cottontail_Tonic = 31142
Global Const $ITEM_ID_Zaishen_Tonic = 31144
Global Const $ITEM_ID_Unseen_Tonic = 31172
Global Const $ITEM_ID_Spooky_Tonic = 37771
Global Const $ITEM_ID_Minutely_Mad_King_Tonic = 37772
#Region Party Tonics

;MISC
Global $g_tDrunkState
Global $g_tDrunkStateHook
Global $INTSKILLENERGY[8] = [10, 10, 5, 0, 10, 10, 5, 10]
Global $COORDS[2]
Global $GWPID = -1
Global $meID
Global $PartyDead = 0
Global $iTakeReward = 1; 1 if you want the reward of the quest, 0 if you dont want it (faster runs)
Global $iGW; Name of your GW
Global $RenderingEnabled = True
Global $bRunning = False
Global $iBounty
Global $Chest = 0
Global $iFailed = 0
Global $iSpawn = 0
Global $iHealth = 0

;Model ID's
Global Const $MID_Eggnog =  06375 ;Eggnog, Alcohol
Global Const $MID_WDGift =  21491 ;Wintersday Gift
Global Const $MID_CShard =  00556 ;Candy Cane Shard
Global Const $MID_PBear  =  21439 ;PolarBear
Global Const $MID_CCake  =  22269 ;Cupcake, P-Cons, Sweets
Global Const $MID_FCake  =  21492 ;Fruitcake, Sweets
Global Const $MID_YTonic =  21490 ;Yuletide, Party
Global Const $MID_FTonic =  30648 ;Frosty Tonic, Party
Global Const $MID_Snowman = 06376 ;Snowman Summoner, Party

;Friendly ID's
Global Const $MID_Freezie 			  = 7386 ;Freezie Ally, Main Target to follow for final fight
Global Const $MID_Mischievous_Snowman =	7383
Global Const $MID_Roguish_Snowman 	  =	7384
Global Const $MID_Wintersday_Chest	  =	16640
Global Const $MID_Chilled_Snowman 	  =	7373
Global Const $MID_Industrious_Snowman =	7380
Global Const $MID_Impeccable_Snowman  =	7381
Global Const $MID_Bustling_Snowman    =	7376

;Enemy ID's
Global Const $MID_Grentchus_Magnus  = 	7402 ;Boss at final fight
Global Const $MID_Speedy_Grentch	=	7392
Global Const $MID_Flashy_Grentch	=	7390
Global Const $MID_Icy_Grentch		=	7389
Global Const $MID_Sneaky_Grentch	=	7400
Global Const $MID_Shifty_Grentch	=	7388
Global Const $MID_Tricky_Grentch	=	7399

; === Skills ===
Global Const $Snowball		 = 1 ;Snowball +50 Damage.  You gain 1 Strike of adrenaline
Global Const $Mega_Snowball  = 2 ;Mega Snowball, Adrenaline Skill (4-Points) +75 Dmg & Knock Down
Global Const $Snow_Down_Shirt= 3 ;Snow Down The Shirt. Interupts target foe when taking damage
Global Const $Hidden_Rock	 = 4 ;Hidden Rock.  Causes knockdown, Inflcits Daze
Global Const $Avalanche		 = 5 ;Avaalanche.  Inflicts cripple on target and surrounding foes
Global Const $Open			 = 6 ;This skill varies with each proffession (Monk = Ice Breaker +5hp Regen
Global Const $Ice_Fort		 = 7 ;Ice Fort, Enchantment.
Global Const $Snow_Cone		 = 8 ;Mmmmm.  Snow Cone. Heal Shout

; === Skill Cost ===
Global Const $skillCost[9] = [0, 0, 4, 0, 0, 0, 0, 0, 0]


; ==== Constants ====
Global Enum $DIFFICULTY_NORMAL, $DIFFICULTY_HARD
Global Enum $INSTANCETYPE_OUTPOST, $INSTANCETYPE_EXPLORABLE, $INSTANCETYPE_LOADING
Global Enum $RANGE_ADJACENT = 156, $RANGE_NEARBY = 240, $RANGE_AREA = 312, $RANGE_EARSHOT = 1000, $RANGE_SPELLCAST = 1085, $RANGE_SPIRIT = 2500, $RANGE_COMPASS = 5000
Global Enum $RANGE_ADJACENT_2 = 156 ^ 2, $RANGE_NEARBY_2 = 240 ^ 2, $RANGE_AREA_2 = 312 ^ 2, $RANGE_EARSHOT_2 = 1000 ^ 2, $RANGE_SPELLCAST_2 = 1085 ^ 2, $RANGE_SPIRIT_2 = 2500 ^ 2, $RANGE_COMPASS_2 = 5000 ^ 2
Global Enum $PROF_NONE, $PROF_WARRIOR, $PROF_RANGER, $PROF_MONK, $PROF_NECROMANCER, $PROF_MESMER, $PROF_ELEMENTALIST, $PROF_ASSASSIN, $PROF_RITUALIST, $PROF_PARAGON, $PROF_DERVISH

Global Enum $BAG_Backpack = 1, $BAG_BeltPouch, $BAG_Bag1, $BAG_Bag2, $BAG_EquipmentPack, $BAG_UnclaimedItems = 7, $BAG_Storage1, $BAG_Storage2, _
		$BAG_Storage3, $BAG_Storage4, $BAG_Storage5, $BAG_Storage6, $BAG_Storage7, $BAG_Storage8, $BAG_StorageAnniversary

Global $BAG_SLOTS[23] = [0, 20, 10, 15, 15, 20, 41, 12, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 9]

Global $g_nMyId = 0
Global $g_nStrafe = 0
Global $lastX
Global $lastY
Global $strafeTimer = TimerInit()
Global $strafeGo = False
Global $leftright = 0
Global $MoveToB = True
Global $BackTrack = True
Global $tSwitchtarget
Global $tLastTarget, $tRun, $tBlock

;MAPS
Global $LAMapID =    809
Global $KamaMapID =  819
Global $QuestMapID = 782

;RARITY
Global Const $RARITY_GOLD =   2624
Global Const $RARITY_PURPLE = 2626
Global Const $RARITY_BLUE =   2623
Global Const $RARITY_WHITE =  2621
Global Const $golds = 2511

;GUI STATS TIME
Global $status_time = 0
Global $status_total = 0
Global $status_average = 0
Global $status_best = 3600000
Global $status_worst = 0

;GUI STATS
Global $Polarbearcount = 0
Global $AmountPolarBears = 0
Global $SuccessTime = 0
Global $LabelRuns = 0

Global $Seconds = 0
Global $Minutes = 0
Global $Hours = 0

Global $MapTimer = 0
Global $tTotal = 0
Global $tRun = 0

Global $iTotalRuns = 0
Global $iTotalRunsSuccess = 0
Global $iTotalRunsFailed = 0
Global $iTotalCanes = 0


Global $tRunFinal = 0
Global $iDeaths = 0
Global $InstTime = 0

Global $RenderingEnabled = True
Global $BotRunning = False
Global $BotInitialized = False
Global $giveup = False
Global $HWND
Global $aItem
Global $PartyDead = 0
Global $hp_start


#Region Vaiables
Global $NightfallChar = True
Global $LAMapID = 809
Global $KamaMapID = 819
Global $QuestMapID = 782
Global $OutPostMapID = $LAMapID
Global $bRunning = False
Global $bInitialized = False
Global $RenderingEnabled = True
Global $OutPostMapID = $LAMapID
Global $leftright = 0
Global $strafeTimer = TimerInit()
Global $currentWP = 0
Global $prof
Global $mSelfID
Global $Chest = 0
Global $DoChest = 0
Global $OutPostMapID = $LAMapID
Global $mAgentMovement = GetAgentMovementPtr()

Global $RunWayPoints = [[-14431, 15110, "里程碑 1"], _
		[-14747, 11980, "里程碑 2"], _
		[-17290, 8232, "里程碑 3"], _
		[-18632, 6120, "里程碑 4"], _
		[-18210, 3788, "里程碑 5"], _
		[-15686, 2577, "里程碑 6"], _
		[-14024, 601, "里程碑 7"], _
		[-13424, -1823, "里程碑 8"], _
		[-13397, -5948, "里程碑 9"], _
		[-14561, -9396, "里程碑 10"], _
		[-16334, -12974, "里程碑 11"], _
		[-14839, -16264, "里程碑 12"], _
		[-10850, -18691, "里程碑 13"], _  ;-10850, -18691 Safe Spot in the corner next to door
		["Chest", "", ""]]
#EndRegion Vaiables


#Region GUI
Global $BotRunning = False
Global $BotInitialized = False

Global Const $gui_main = GUICreate("北极熊 9.3.1 版", 335, 370)
GUISetIcon("icon.ico")
GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
Opt("GUIOnEventMode", True)

Global $Input = GUICtrlCreateCombo("", 10, 8, 150, 25)
GUICtrlSetData(-1, GetLoggedCharNames())
;Global $gui_ipt_Char = GUICtrlCreateInput("", 10, 8, 150, 25)


;Run Stats
GUICtrlCreateGroup("统计", 8, 33, 150, 160)
GUICtrlCreateLabel("成功:", 18, 55, 60, 20)
$gui_lbl_Wins = GUICtrlCreateLabel($iTotalRunsSuccess, 100, 55, 25, 17)
GUICtrlCreateLabel("失败:", 18, 70, 60, 20)
$gui_lbl_Fails = GUICtrlCreateLabel($iTotalRunsFailed, 100, 70, 25, 17)

GUICtrlCreateLabel("圈数/每小时:", 18, 85, 80, 15)
$gui_lbl_RunsHour = GUICtrlCreateLabel("-", 100, 85, 30, 15)

GUICtrlCreateLabel("成功率:", 18, 100, 85, 15)
;GUICtrlCreateLabel("%", 120, 115, 15, 15)
$gui_lbl_SuccRate = GUICtrlCreateLabel("-", 100, 100, 32, 15)

GUICtrlCreateLabel("耗时(上一轮):", 18, 115, 85, 15)
$gui_lbl_LastRun = GUICtrlCreateLabel("-", 100, 115, 50, 15)

GUICtrlCreateLabel("均耗时:", 18, 130, 50, 17)
$gui_lbl_AvgTime = GUICtrlCreateLabel("-", 100, 130, 50, 15)
$MyRunsLabel = GUICtrlCreateLabel("0", 284, 130, 28, 0)


;Map Selection (Radio Buttons)
;GUIStartgroup()
GUICtrlCreateLabel("起点:", 18, 170, 50, 17)
$LA_Button = GUICtrlCreateRadio("狮城", 50, 168, 40, 17)
$KA_Button = GUICtrlCreateRadio("卡玛丹", 90, 168, 60, 17)


;Loot
GUICtrlCreateLabel("北极熊:", 18, 200, 60, 15)
$gui_lbl_PBear = GUICtrlCreateLabel("0", 120, 200, 25, 15)
GUICtrlCreateLabel("冬庆日礼物:", 18, 215, 100, 20)
$gui_lbl_WGift = GUICtrlCreateLabel("0", 120, 215, 25, 17)
GUICtrlCreateLabel("糖果碎片:", 18, 230, 110, 20)
$gui_lbl_Canes = GUICtrlCreateLabel("0", 120, 230, 25, 17)

;Tools
GUICtrlCreateGroup("设置", 8, 246, 318, 118)
GUICtrlCreateLabel("总耗时:", 18, 145, 100, 15)
Global $gui_lbl_Time = 		GUICtrlCreateLabel("00:00:00", 100, 145, 50, 15)
Global $gui_cbx_Alc = 		GUICtrlCreateCheckbox("饮酒", 170, 300, 80, 17)
Global $gui_cbx_Sweets =	GUICtrlCreateCheckbox("用甜点", 170, 280, 80, 17)
Global $gui_cbx_Canes = 	GUICtrlCreateCheckbox("收集糖果碎片", 170, 340, 140, 17)
Global $gui_cbx_Cupcake = 	GUICtrlCreateCheckbox("用蛋糕", 18, 300, 86, 17)
Global $gui_lbl_Cupcake = 	GUICtrlCreateLabel("", 115, 302, 40, 17)
;Global $gui_cbx_Battle = 	GUICtrlCreateCheckbox("Fight in Main Battle", 18, 280, 120, 17)
Global $gui_cbx_District = 	GUICtrlCreateCheckbox("换区", 18, 280, 120, 17)
Global $gui_cbx_Rendering = GUICtrlCreateCheckbox("不成像", 18, 260, 129, 17)
Global $gui_cbx_Tonic = 	GUICtrlCreateCheckbox("用冬庆日变身", 170, 320, 100, 17)
Global $gui_cbx_Purge = 	GUICtrlCreateCheckbox("每轮刷新工具状态", 18, 340, 140, 17)
Global $gui_cbx_Party =     GUICtrlCreateCheckbox("消耗狂欢节日品", 170, 260, 100, 17)
Global $gui_cbx_Fight =     GUICtrlCreateCheckbox("参与最后一场对仗", 18, 320, 110, 17)
Global $gui_btn_Toggle = 	GUICtrlCreateButton("开始", 165, 205, 160, 30)

GUICtrlSetState($LA_Button, 		$GUI_CHECKED)
GUICtrlSetState($gui_cbx_Fight,		$GUI_DISABLE)
GUICtrlSetState($gui_cbx_Alc, 		$GUI_CHECKED)
GUICtrlSetState($gui_cbx_Sweets,	$GUI_CHECKED)
GUICtrlSetState($gui_cbx_Canes, 	$GUI_CHECKED)
GUICtrlSetState($gui_cbx_Cupcake,	$GUI_CHECKED)
GUICtrlSetState($gui_cbx_District, 	$GUI_CHECKED)
GUICtrlSetState($gui_cbx_Rendering, $GUI_DISABLE)
GUICtrlSetState($gui_cbx_Tonic, 	$GUI_CHECKED)
GUICtrlSetState($gui_cbx_Purge, 	$GUI_CHECKED)
GUICtrlSetState($gui_cbx_Party, 	$GUI_CHECKED)

GUICtrlSetOnEvent($gui_btn_Toggle, "GuiButtonHandler")
GUICtrlSetOnEvent($gui_cbx_Rendering, "ToggleRendering")

GUICtrlCreateLabel("9.3.1 版", 280, 260, 45, 0)
Global $GLOGBOX = GUICtrlCreateEdit("北极熊 9.3.1 版", 165, 8, 160, 185, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
GUICtrlSetColor($GLOGBOX, 65280)
GUICtrlSetBkColor($GLOGBOX, 0)
GUISetState(@SW_SHOW)

Func GuiButtonHandler()

	If $BotRunning Then
	  Out("此轮过后暂停.")
	  GUICtrlSetData($gui_btn_Toggle, "即刻暂停")
	  GUICtrlSetOnEvent($gui_btn_Toggle, "Resign")
	  ;GUICtrlSetState($StartButton, $GUI_DISABLE)
	  $BotRunning = False
    ElseIf $BotInitialized Then
	  GUICtrlSetData($gui_btn_Toggle, "暂停")
	  $BotRunning = True

	Else
		Out("正在启动...")
		Local $CharName = GUICtrlRead($Input)
		If $CharName == "" Then
			If Initialize("", True, True, True) = False Then
				MsgBox(0, "故障", "需事先运行激战.")
				Exit
			EndIf

		Else
			If Initialize("", True, True, True) = False Then
				MsgBox(0, "故障", "以下角色失寻： '" & $CharName & "'")
				Exit
			EndIf
		EndIf

		EnsureEnglish(True)
		GUICtrlSetState($gui_cbx_Rendering, $GUI_ENABLE)
		GUICtrlSetState($Input, $GUI_DISABLE)
		GUICtrlSetData($gui_btn_Toggle, "暂停")
		WinSetTitle($gui_main, "", "北极熊 9.3.1 版" & GetCharname())
		$BotRunning = True
		$BotInitialized = True
		$tTotal = TimerInit()
		AdlibRegister("TimeUpdater", 2000)
	EndIf
EndFunc   ;==>GuiButtonHandler
#EndRegion GUI

;################# Main Loop ##################

While 1
	If $BotRunning Then
		Global $Me = GetAgentByID(-2)
		ClearMemory()
		Sleep(50)
		ReduceMemory()
		Sleep(50)
		Out("正在统计包内空格")
		While CountFreeSlots() > 1
			Main()
		WEnd
	EndIf

	sleep(50)
WEnd


#Region Functions
Func Main()

	;If GetMapLoading() = 2 Then Disconnected()
	$prof = GetProfessionNameEx()

	Out("正文开始")
	$lBlockedTimer = TimerInit()
	$tRun = TimerInit()
	$Return = 0

	If GUICtrlRead($LA_Button) = $GUI_CHECKED Then
		CheckMap_1()
	EndIf

	If GUICtrlRead($KA_Button) = $GUI_CHECKED Then
		CheckMap_2()
	EndIf

	;Accept Loot
	Out("接受奖励")
	AcceptAllItems()
	PingSleep(100)

	;Selecting Starting Location & Change District
	If GUICtrlRead($gui_cbx_District) = $GUI_CHECKED  And GUICtrlRead($LA_Button) = $GUI_CHECKED Then
		Out("换区")
		RndTravel($LAMapID)
	Else
		If GUICtrlRead($gui_cbx_District) = $GUI_CHECKED  And GUICtrlRead($KA_Button) = $GUI_CHECKED Then
		Out("换区")
		RndTravel($KamaMapID)
		PingSleep(100)
		EndIf
	EndIf

	If GetMapID == ($LAMapID) Then
	Move (2537, 8002)
	EndIf

	;Use Sweets
	If GUICtrlRead($gui_cbx_Sweets) = $GUI_CHECKED Then
		Out("服用甜点")
		If UseItemByModelId($MID_FCake) Then
			Out("速度已加快!!!")
		Else
			Out("水果蛋糕已耗尽 :(")
		EndIf
	EndIf

	;Use Alcohol
	If GUICtrlRead($gui_cbx_Alc) = $GUI_CHECKED Then
		Out("饮酒")
		If UseItemByModelId($ITEM_ID_Eggnog) Then
			Out("饮酒完毕!!!")
		Else
			Out("酒水已耗尽 :(")
		EndIf
	EndIf

	;Use Party
	If GUICtrlRead($gui_cbx_Party) = $GUI_CHECKED Then       ;<<<<<<<<<<<TESTING>>>>>>>>>>>>>>>>>>>>>
		Out("用雪人召唤者")
		If UseItemByModelId($MID_Snowman) Then              ;<-------------Change this to party_array
			Out("已用!!!")
		Else
			Out("雪人召唤者已耗尽 :(")
		EndIf
	EndIf

	;Quest Loop
	If GUICtrlRead($LA_Button) = $GUI_CHECKED Then
		Enter_LA_Quest()
	Else
		If GUICtrlRead($KA_Button) = $GUI_CHECKED Then
		Enter_Kamadan_Quest()
		EndIf
	EndIf

	If RunQuest() Then
		UpdateStatistics(1)
	Else
		UpdateStatistics(0)
	EndIf

	BackToTown()
EndFunc   ;==>Main

#Region Main Quest Loop
Func Enter_LA_Quest()
	Local $lGrenth
	Local $lChest

	If GetMapID() <> $LAMapID Then
		Out("前往: 狮子拱门")
		RndTravel($LAMapID)
	EndIf

	If $OutPostMapID = $LAMapID Then
		$lGrenth = GetNearestNPCToCoords(2537, 8002)
	EndIf

	GoToNPC($lGrenth)
	Out("拿任务奖励")
	PingSleep(100)
	Dialog(0x839F07) ;tries to get reward if one is still available from previous session


	Out("开始任务")
	PingSleep(150)
	If GetQuestByID(927) <> 0 Then
		Out("清除任务序号")
		AbandonQuest(927)
		PingSleep(250)
	EndIf
	Dialog(0x839F03)
	PingSleep(400)
	Dialog(0x839F01)
	PingSleep(400)

	If GUICtrlRead($gui_cbx_District) = $GUI_CHECKED And GetQuestByID(927) > 1 Then
		Out("换区")
		RndTravel($LAMapID)
		PingSleep(100)
	EndIf

	Dialog(0x86)
	WaitMapLoading()
EndFunc   ;==>EnterQuest


#Region Main Quest Loop
Func Enter_Kamadan_Quest()
	Local $lGrenth
	Local $lChest

	If GetMapID() <> $KamaMapID Then
		Out("前往: 卡玛丹")
		RndTravel($KamaMapID)
	EndIf

	If $OutPostMapID = $KamaMapID Then
		$lGrenth = GetNearestNPCToCoords(-10868, 14487)
	EndIf


	GoToNPC($lGrenth)

	Out("拿任务奖励")
	PingSleep(100)
	Dialog(0x839F07) ;tries to get reward if one is still available from previous session


	Out("开始任务")
	PingSleep(250)
	If GetQuestByID(927) <> 0 Then
		Out("清除任务序号")
		AbandonQuest(927)
		PingSleep(500)
	EndIf
	Dialog(0x839F03)
	PingSleep(200)
	Dialog(0x839F01)
	PingSleep(200)

	If GUICtrlRead($gui_cbx_District) = $GUI_CHECKED And GetQuestByID(927) > 1 Then
		Out("换区")
		RndTravel($LAMapID)
		PingSleep(100)
	EndIf

	Dialog(0x86)
	WaitMapLoading()
EndFunc   ;==>Enter Kamadan Quest


Func RunQuest() ;<  New one with stuck timer
	If GetMapId() <> $QuestMapID Then Return False

	Local $tInstanceTimer = TimerInit()

	;Use Tonics
	If GUICtrlRead($gui_cbx_Tonic) = $GUI_CHECKED Then
		Out("用变身")
		If UseItemByModelId($MID_YTonic) Then
			Out("已用变身!!!")
		Else
			Out("变身已耗尽 :(")
		EndIf
	EndIf

	;speed boost
	If GUICtrlRead($gui_cbx_Cupcake) = $GUI_CHECKED Then
		Out("用生日蛋糕")
		If UseItemByModelId($MID_CCake) Then
			Out("速度已加快!!!")
		Else
			Out("生日蛋糕已耗尽 :(")
		EndIf
		PingSleep(150)
	EndIf

	$mSelfID = GetMyID()

	;Run to Final Battle
	For $cWP = 0 To UBound($RunWayPoints) - 1
		$currentWP = $cWP
		If Not GetIsDead(-2) Then
			If IsInt($RunWayPoints[$cWP][0]) Then
				Out($RunWayPoints[$cWP][2])
				MoveRunning($RunWayPoints[$cWP][0], $RunWayPoints[$cWP][1])
			Else
				Out("最后一场对仗已开始!")
				ReverseDirection()
				Local $StuckTimer = TimerInit()

				If GUICtrlRead($gui_cbx_Alc) = $GUI_CHECKED Then
					Drink()
					PingSleep(100)
				EndIf

				If GUICtrlRead($gui_cbx_Purge) = $GUI_CHECKED Then
					_PurgeHook()
				EndIf

				PingSleep(300)
				TargetNearestItem()

				;Wait for Battle to finish
				;put some fighting logic here

				Do
					Sleep(2000)
					If GetIsDead(-2) = 1 Or GetMapLoading() <> 1 Or GetMapID() <> 782 Then
						Return False
					EndIf
				Until IsDllStruct(GetNearestSignpostToCoords(-11452.18, -17942.34))

				;get spoils
				PickUpLoot2()

				;open chest
				Out("开箱!")
				MoveTo(-11757, -18089) ; Closer Spot in front of chest

				;security checks
				If GetMapLoading() = 2 Then Disconnected()

				;TargetNearestItem()

				;open chest
				$lChest = GetNearestSignpostToCoords(-11452.18, -17942.34)
				If IsDllStruct($lChest) Then
					GoSignPost($lChest)
					Sleep(Random(1500, 3000, 1))
				EndIf


				;finish
				WaitMapLoading(0, 16000)
				Out("任务完毕: " & GetTimeString(TimerDiff($tInstanceTimer)))

				Return True
			EndIf
		Else
			Out("失败： " & $RunWayPoints[$cWP][2])
			Out("换区")
			RndTravel($LAMapID)
			Return False
		EndIf
	Next
EndFunc   ;==>RunQuest

Func BackToTown()
	Out("回城")
	PingSleep(50)
	If GetMapID() = $QuestMapID Then HardLeave()
EndFunc   ;==>BackToTown

#EndRegion Main Quest Loop
#Region Helper Functions
#Region Time & Update Functions
Func TimeUpdater()
	GUICtrlSetData($gui_lbl_Time, GetTimeString(TimerDiff($tTotal)))
EndFunc   ;==>TimeUpdater

Func GetTimeString($iTimerdiff)
	local $lTimeString = ""
	local $lTimerdiff[3]
		  $lTimerdiff[0] = Floor($iTimerdiff / 3600000)
		  $lTimerdiff[1] = Floor($iTimerdiff / 60000) - $lTimerdiff[0] * 60
		  $lTimerdiff[2] = Round($iTimerdiff / 1000) - $lTimerdiff[0] * 3600 - $lTimerdiff[1] * 60

	For $i = 0 to 2
		If $lTimerdiff[$i] < 10 Then $lTimeString &= "0"

		$lTimeString &= $lTimerdiff[$i] & ":"
	Next

	Return StringTrimRight($lTimeString, 1)
EndFunc

#EndRegion Time & Update Functions
#Region Movement
Func MoveRunning($lDestX, $lDestY, $lRandom = 250)
	If GetIsDead(-2) Then Return False

	Local $lMe, $lMeX, $lMeY, $lTgt, $lDeadLock

	$lDeadLock = TimerInit()

	$lMe = GetAgentPtr(-2)

	If IsRecharged(6) Then UseSkill(6, -2)   				 ;New Line
	;If IsRecharged(6) And $prof = 'W' Then UseSkill(6, -2)  ;Old Line

	Move($lDestX, $lDestY, $lRandom)

	Do
		PingSleep(250)

		If GetMapLoading() == 2 Then Disconnected()

		TargetNearestEnemy()

		$lTgt = GetAgentPtr(-1)

		If MemoryRead($lTgt + 436, 'word') == 1002 And GetTarget($lTgt) == $mSelfID And TimerDiff($strafeTimer) > 4000 Then
			Strafe()
		EndIf

		If IsRecharged(6) And GetHealth(-2) < 300 And $prof <> 'W' Then UseSkill(6, -2)

		If GetIsDead(-2) Then Return

		If GetHealth(-2) < 150 And IsRecharged(8) Then UseSkill(8, -2)

		If GetHasHex(-2) And IsRecharged(7) Then
			UseSkill(7, -2)
			Do
				PingSleep(100)
			Until GetEffectTimeRemaining(1012) = 0
		EndIf

		If GetMoving(-2) = 0 Then Move($lDestX, $lDestY, $lRandom)

		UpdateAgentPosByPtr($lMe, $lMeX, $lMeY)
	Until ComputeDistance($lMeX, $lMeY, $lDestX, $lDestY) < 250 Or TimerDiff($lDeadLock) > 120000
	Return True
EndFunc   ;==>MoveRunning

Func Strafe()
	$strafeTimer = TimerInit()
	WriteChat("Strafing")
	ToggleAutoRun()
	PingSleep(250)
	If $leftright = 0 Then
		StrafeRight(1)
		PingSleep(750)
		StrafeRight(0)
		$leftright = 1
	Else
		StrafeLeft(1)
		Sleep(750)
		StrafeLeft(0)
		$leftright = 0
	EndIf
	Move($RunWayPoints[$currentWP][0], $RunWayPoints[$currentWP][1])
EndFunc   ;==>Strafe

Func UpdateAgentPosByPtr($aAgentPtr, ByRef $aX, ByRef $aY)
	Local $lStruct = MemoryReadStruct($aAgentPtr + 116, 'float X;float Y')
	$aX = DllStructGetData($lStruct, 'X')
	$aY = DllStructGetData($lStruct, 'Y')
EndFunc   ;==>UpdateAgentPosByPtr

Func GetMoving($aAgentID)
	Local $lPtr = MemoryRead($mAgentMovement + 4 * ConvertID($aAgentID))
	Return MemoryRead($lPtr + 60, 'long')
EndFunc   ;==>GetMoving

Func MemoryReadStruct($aAddress, $aStruct = 'dword')
	Local $lBuffer = DllStructCreate($aStruct)
	DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')
	Return $lBuffer
EndFunc   ;==>MemoryReadStruct

Func GetAgentMovementPtr()
	Local $Offset[4] = [0, 0x18, 0x8, 0xE8]
	Local $lPtr = MemoryReadPtr($mBasePointer, $Offset, 'ptr')
	Return $lPtr[1]
EndFunc   ;==>GetAgentMovementPtr
#EndRegion Movement

Func IsRecharged($lSkill)
	Return GetSkillBarSkillRecharge($lSkill) == 0
EndFunc   ;==>IsRecharged

Func Disconnected() ;Ralle's Disconnect ;
	Out("掉线!")
	Out("正在重连.")
	Static Local $gs_obj = GetValue('PacketLocation')
	Local $State = MemoryRead($gs_obj)
	If $State = 0 Then
		Do ;Disconnected
			ControlSend($mGWHwnd, '', '', '{ENTER}{ENTER}') ; Hit enter key until you log back in
			Sleep(Random(5000, 10000, 1))
		Until MemoryRead($gs_obj) <> 0
		RndSleep(500)
		Resign()
		Return True
	EndIf
	Return False
EndFunc   ;==>Disconnected

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

Func GetProfessionNameEx($aProf = GetAgentPrimaryProfession())
	Switch $aProf
		Case 0 ; $PROFESSION_None
			Return "x"
		Case 1 ; $PROFESSION_Warrior
			Return "W"
		Case 2 ; $PROFESSION_Ranger
			Return "R"
		Case 3 ; $PROFESSION_Monk
			Return "Mo"
		Case 4 ; $PROFESSION_Necromancer
			Return "N"
		Case 5 ; $PROFESSION_Mesmer
			Return "Me"
		Case 6 ; $PROFESSION_Elementalist
			Return "E"
		Case 7 ; $PROFESSION_Assassin
			Return "A"
		Case 8 ; $PROFESSION_Ritualist
			Return "Rt"
		Case 9 ; $PROFESSION_Paragon
			Return "P"
		Case 10 ; $PROFESSION_Dervish
			Return "D"
	EndSwitch
EndFunc   ;==>GetProfessionName

Func GetAgentPrimaryProfession($aAgent = GetAgentPtr(-2))
	If IsPtr($aAgent) <> 0 Then
		Return MemoryRead($aAgent + 266, 'byte')
	ElseIf IsDllStruct($aAgent) <> 0 Then
		Return DllStructGetData($aAgent, 'Primary')
	Else
		Return MemoryRead(GetAgentPtr($aAgent) + 266, 'byte')
	EndIf
EndFunc   ;==>GetAgentPrimaryProfession

Func Out($TEXT)
	Local $TEXTLEN = StringLen($TEXT)
	Local $CONSOLELEN = _GUICtrlEdit_GetTextLen($GLOGBOX)
	If $TEXTLEN + $CONSOLELEN > 30000 Then GUICtrlSetData($GLOGBOX, StringRight(_GUICtrlEdit_GetText($GLOGBOX), 30000 - $TEXTLEN - 1000))
	_GUICtrlEdit_AppendText($GLOGBOX, @CRLF & $TEXT)
	_GUICtrlEdit_Scroll($GLOGBOX, 1)
EndFunc   ;==>Out

;PingSleep: Pings the server and detects current lag.
;Adds the lag to any called sleep times.

Func PingSleep($msExtra = 0)
	$ping = GetPing()
	Sleep($ping + $msExtra)
EndFunc  ;==>PingSleep

Func HardLeave()
	Resign()
	PingSleep(Random(5000, 7500, 1))
	ReturnToOutpost()
	WaitMapLoading()
EndFunc   ;==>HardLeave

Func CountFreeSlots()
	Local $temp = 0
	Local $bag
	Out("正在清点空位个数")
	$bag = GetBag(1)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(2)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(3)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(4)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	Return $temp
EndFunc   ;==>CountFreeSlots

Func CheckMap_1()
	If GetMapID() <> $LAMapID Then
		Out("准备前往狮子拱门")
		RndTravel($LAMapID)
	EndIf
EndFunc   ;==>Checkmap

Func CheckMap_2()
	If GetMapID() <> $KamaMapID Then
		Out("准备前往卡玛丹")
		RndTravel($KamaMapID)
	EndIf
EndFunc

Func UseItemByModelId($iModelID)
	local $aItem = GetItemByModelID($iModelID)

	If DllStructGetData($aItem, 'Bag') <> 0 Then
		UseItem($aItem)
		Return True
	EndIf

	Return False
EndFunc

Func Drink() ;Drink Eggnog
	$item = GetItemByModelID($MID_Eggnog)
	If DllStructGetData($item, 'Bag') <> 0 Then
		Out("饮酒 x1!")
		Out("干杯!!!")
		UseItem($item)
		Sleep(60000) ;<-----One minute
		Out("饮酒 x2!")
		Out("干杯!!!")
		UseItem($item)
		Sleep(60000) ;<-----One minute
		Out("饮酒 x3!")
		Out("干杯!!!")
		UseItem($item)
		Sleep(60000) ;<-----One minute
		Out("观赛 4 分钟")
		Return
	EndIf
EndFunc   ;==>Drink


Func _Exit()
	Exit
EndFunc   ;==>_Exit

Func ReduceMemory()
	If $GWPID <> -1 Then
		Local $AI_HANDLE = DllCall("kernel32.dll", "int", "OpenProcess", "int", 2035711, "int", False, "int", $GWPID)
		Local $AI_RETURN = DllCall("psapi.dll", "int", "EmptyWorkingSet", "long", $AI_HANDLE[0])
		DllCall("kernel32.dll", "int", "CloseHandle", "int", $AI_HANDLE[0])
	Else
		Local $AI_RETURN = DllCall("psapi.dll", "int", "EmptyWorkingSet", "long", -1)
	EndIf
	Return $AI_RETURN[0]
EndFunc   ;==>ReduceMemory

Func GetItemCount($iModelID, $iMaxBag = 4)
	Local $iItemCount
	local $aBag, $aItem

	For $i = 1 To $iMaxBag
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") = $iModelID Then
				$iItemCount += DllStructGetData($aItem, "Quantity")
			EndIf
		Next
	Next
	Return $iItemCount
EndFunc
#cs
Func RndTravel($aMapID)
	Local $UseDistricts = 11
	; 7=eu, 8=eu+int, 11=all(incl. asia)
	; Region/Language order: eu-en, eu-fr, eu-ge, eu-it, eu-sp, eu-po, eu-ru, int, asia-ko, asia-ch, asia-ja
	Local $ComboDistrict[11][2]=[[2, 0],[2, 2],[2, 3],[2, 4], [2, 5],[2, 9],[2, 10],[-2, 0],[1, 0], [3, 0], [4, 0]]
	;Local $Region[11] = [2, 2, 2, 2, 2, 2, 2, -2, 1, 3, 4]
	;Local $Language[11] = [0, 2, 3, 4, 5, 9, 10, 0, 0, 0, 0]
	Local $Random = Random(0, $UseDistricts - 1, 1)
	MoveMap($aMapID, $ComboDistrict[$Random][0], 0, $ComboDistrict[$Random][1])
	WaitMapLoading($aMapID, 25000) ;Reduced loading times from 30 seconds down to 22 seconds.
	Sleep(GetPing() + 1000)
EndFunc ;==>RndTravel
#ce
Func _PurgeHook()
	Out("刷新工具内存")
	Sleep(Random(2000, 2500))
	ToggleRendering()
	Sleep(Random(2000, 2500))
	ClearMemory()
	Sleep(Random(2000, 2500))
	ToggleRendering()
EndFunc   ;==>_PurgeHook

Func UpdateStatistics($iSuccess)
	Out("统计数据")

	$iTotalRuns += 1
	If $iSuccess Then
		$iTotalRunsSuccess += 1

		$status_time = TimerDiff($tRun)
		$status_total += $status_time
		$status_average = Round($status_total / $iTotalRunsSuccess)

		If $status_time < $status_best then $status_best = $status_time
		If $status_time > $status_worst then $status_worst = $status_time

		Out("最快耗时: " & GetTimeString($status_best))
		Out("最慢耗时: " & GetTimeString($status_worst))

	Else
		$iTotalRunsFailed += 1

		Out("最快耗时: " & GetTimeString($status_best))
		Out("最慢耗时: " & GetTimeString($status_worst))
	EndIf

	GUICtrlSetData($gui_lbl_WGift, GetItemCount($MID_WDGift))
	GUICtrlSetData($gui_lbl_Cupcake, GetItemCount($MID_CCake))
	GUICtrlSetData($gui_lbl_Canes, GetItemCount($MID_CShard))
	GUICtrlSetData($gui_lbl_Wins, $iTotalRunsSuccess)
	GUICtrlSetData($gui_lbl_Fails, $iTotalRunsFailed)
	GUICtrlSetData($gui_lbl_RunsHour, Round($iTotalRuns / (TimerDiff($tTotal) / 3600000)))
	GUICtrlSetData($gui_lbl_LastRun, GetTimeString(TimerDiff($tRun)))
	GUICtrlSetData($gui_lbl_AvgTime, GetTimeString($status_average))
	GUICtrlSetData($gui_lbl_SuccRate, Round($iTotalRunsSuccess / $iTotalRuns, 2))
	GUICtrlSetData($gui_lbl_PBear, GetItemCount($MID_PBear))
	If CountItemInBagsByModelID($MID_PBear) > 0 Then
		PolarBearAlert()
	EndIf
EndFunc   ;==>UpdateStatistics

Func PolarBearAlert() ;
	$GUI = GUICreate("恭喜", 200, 200)
	$s_text = "找到北极熊!"
	$RED = 1
	$lbl_text = GUICtrlCreateLabel($s_text, 10, 50, 180, 60, $SS_SUNKEN)
	GUICtrlSetColor($lbl_text, 0x008000)
	GUICtrlSetFont($lbl_text, 20, 700)
	Opt("GUIOnEventMode", False)

	GUISetState(@SW_SHOW)
	$sec = @SEC
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case Else
				If @SEC <> $sec Then
					$sec = @SEC
					If $RED Then
						GUICtrlSetColor($lbl_text, 0xffffff)
					Else
						GUICtrlSetColor($lbl_text, 0x008000)
					EndIf
					$RED = Not $RED
				EndIf
		EndSelect
	WEnd
EndFunc   ;==>PolarBearAlert

Func CountItemInBagsByModelID($ItemModelID) ;
	$count = 0
	For $i = $BAG_Backpack To $BAG_Bag2
		For $j = 1 To DllStructGetData(GetBag($i), 'Slots')
			$lItemInfo = GetItemBySlot($i, $j)
			If DllStructGetData($lItemInfo, 'ModelID') = $ItemModelID Then $count += DllStructGetData($lItemInfo, 'quantity')
		Next
	Next
	Return $count
EndFunc   ;==>CountItemInBagsByModelID

Func PickUpLoot2()
	Local $lMe = GetAgentByID(-2)
	Local $lBlockedTimer
	Local $lBlockedCount = 0
	Local $lItemExists = True
	Local $iCurDistance = 99999999
	Local $iBestDistance = 99999999
	Local $lAgent, $lTempAgent, $lTempIndex

	Local $lItemList[GetMaxAgents() + 1]
	Local $lPickupList[GetMaxAgents() + 1]

	Out("捡东西")
	For $i = 1 To GetMaxAgents()
		If GetIsDead(-2) Then Return False
		$lAgent = GetAgentByID($i)
		If Not GetIsMovable($lAgent) Then ContinueLoop
		$lDistance = GetDistance($lAgent)
		;If $lDistance > 2500 Then ContinueLoop ;<----Increased from 2,000 to try to pickup all canes
		$lItem = GetItemByAgentID($i)

		;add Items to pick up to item list
		If GuiCtrlRead($gui_cbx_Canes) = $GUI_CHECKED And CanPickUp2($lItem) Then
			$lItemList[0] += 1
			$lItemList[$lItemList[0]] = $lAgent
		EndIf
	Next

	;calculate shortest paths for picking up items
	$lTempAgent = GetAgentByID(-2)
	While $lItemList[0] > 0
		$iBestDistance = 99999999

		For $i = 1 to $lItemList[0]
			$iCurDistance = GetDistance($lItemList[$i], $lTempAgent)

			If $iCurDistance < $iBestDistance Then
				$iBestDistance = $iCurDistance
				$lTempIndex = $i
			EndIf
		Next

		;check if it's viable to run to the item
		If $iBestDistance > 2000 Then ExitLoop

		;add Item to pickup list
		$lPickupList[0] += 1
		$lPickupList[$lPickupList[0]] = $lItemList[$lTempIndex]
		$lTempAgent = $lItemList[$lTempIndex]

		;remove Item from Itemlist
		$lItemList[$lTempIndex] = $lItemList[$lItemList[0]]
		$lItemList[0] -= 1
	WEnd

	;pickup items using shortest path
	For $i = 1 to $lPickupList[0]
		$lBlockedCount = 0

		Do
			If GetDistance($lPickupList[$i]) > 150 Then
				MoveTo(DllStructGetData($lPickupList[$i], 'X'), DllStructGetData($lPickupList[$i], 'Y'), 0)
			EndIf

			$lBlockedTimer = TimerInit()
			$lItem = GetAgentByID(DllStructGetData($lPickupList[$i],"Id"))
			If IsDllStruct($lItem) Then
				Do
					PickUpItem($lItem)
					PingSleep(250)
					$lItemExists = IsDllStruct(GetAgentByID(DllStructGetData($lPickupList[$i],"Id")))
				Until Not $lItemExists Or TimerDiff($lBlockedTimer) > 2500
			Else
				$lItemExists = 0
			EndIf

			If $lItemExists Then $lBlockedCount += 1
		Until Not $lItemExists Or $lBlockedCount > 5
	Next
EndFunc   ;==>PickUpLoot2

Func CanPickUp2($aItem)
	If GetMapLoading() = 2 Then Disconnected()
	Local $m = DllStructGetData($aItem, 'ModelId')
	Local $t = DllStructGetData($aItem, 'Type')
	Local $r = GetRarity($aItem)
	Local $Req = GetItemReq($aItem)
	Local $lRarity = GetRarity($aItem)
	If $r = $RARITY_GOLD Then Return True
	If $m > 21785 And $m < 21806 Then Return True ; Elite/Normal Tomes
	Switch $m
		Case 21439 ; Polar Bear
			$Polarbearcount = $Polarbearcount + 1
			GUICtrlSetData($gui_lbl_PBear, $Polarbearcount)
			Return True
		Case 2624 ; Gold Items
			Return True
		Case 556 ; Candy Cane Shard
			Return True
	EndSwitch
	Return False
EndFunc   ;==>CanPickUp2
#EndRegion HelperFunctions
#EndRegion Functions

Func GoToRift()
	Local $me, $x, $y, $DistanceToRift
	$me = GetAgentByID(-2)
	$x = DllStructGetData($me, 'X')
	$y = DllStructGetData($me, 'Y')
	$DistanceToRift = Sqrt(($x + 10918) ^ 2 + ($y - 14536) ^ 2)
	If $DistanceToRift > 4000 Then
		If $x > -4000 Then
			MoveTo(-5687, 9244)
		EndIf
		$x = DllStructGetData($me, 'X')
		$y = DllStructGetData($me, 'Y')
		$DistanceToRift = Sqrt(($x + 10918) ^ 2 + ($y - 14536) ^ 2)
		If $DistanceToRift > 6700 Then
			MoveTo(-8295, 10705)
		EndIf
	EndIf
	MoveTo(-10912, 14491)
	PingSleep(500)
	MoveTo(-10918, 14536)
	PingSleep(500)
EndFunc   ;==>GoToRift

Func GoToRiftLA()

	MoveTo(1098, 7772)
	Local $me, $x, $y, $DistanceToRift
	$me = GetAgentByID(-2)
	$x = DllStructGetData($me, 'X')
	$y = DllStructGetData($me, 'Y')
	$DistanceToRift = Sqrt(($x - 2519) ^ 2 + ($y - 7931) ^ 2)
	If $DistanceToRift > 4000 Then
		If $x > 4000 Then
			MoveTo(1098, 7772)
		EndIf
		$x = DllStructGetData($me, 'X')
		$y = DllStructGetData($me, 'Y')
		$DistanceToRift = Sqrt(($x - 2519) ^ 2 + ($y - 7931) ^ 2)
		If $DistanceToRift > 6700 Then
			MoveTo(924, 7773)
		EndIf
	EndIf
	MoveTo(2467, 7974)
	PingSleep(500)
EndFunc   ;==>GoToRiftLA
#cs
Func GetLoggedCharNames()
	Local $array = ScanGW()
	If $array[0] <= 1 Then Return ''
	Local $ret = $array[1]
	For $i=2 To $array[0]
		$ret &= "|"
		$ret &= $array[$i]
	Next
	Return $ret
EndFunc

Func ScanGW()
	Local $lWinList = WinList("Guild Wars")
	Local $lReturnArray[1] = [0]
	Local $lPid

	For $i=1 To $lWinList[0][0]

		$mGWHwnd = $lWinList[$i][1]
		$lPid = WinGetProcess($mGWHwnd)
		If __ProcessGetName($lPid) <> "gw.exe" Then ContinueLoop
		MemoryOpen(WinGetProcess($mGWHwnd))

		If $mGWProcHandle Then
			$lReturnArray[0] += 1
			ReDim $lReturnArray[$lReturnArray[0] + 1]
			$lReturnArray[$lReturnArray[0]] = ScanForCharname()
		EndIf

		MemoryClose()

		$mGWProcHandle = 0
	Next

	Return $lReturnArray
EndFunc

Func __ProcessGetName($i_PID)
	If Not ProcessExists($i_PID) Then Return SetError(1, 0, '')
	If Not @error Then
		Local $a_Processes = ProcessList()
		For $i = 1 To $a_Processes[0][0]
			If $a_Processes[$i][1] = $i_PID Then Return $a_Processes[$i][0]
		Next
	EndIf
	Return SetError(1, 0, '')
EndFunc
#ce
#EndRegion Functions

#Region DrunkState
Global $mDrunkState = 0

;~ Description: Returns Drunklevel, starting with next drunklevel-change.
Func GetIsDrunk()
   Return MemoryRead($mDrunkState)
EndFunc
#EndRegion


#Region Fight
Func Fight_Last_Group()
	$Boss = $MID_Grentchus_Magnus
	;If GetIsDead(-2) = 1 Or GetMapLoading() <> 1 Or GetMapID() <> 782 Then
		;Return False
		;EndIf = True
	PingSleep(150)
	Do
		PingSleep(1200)
		If GetAgentByID = $Boss Then
			Emote()  ;<--- For Testing Purpose
			;Snowball_Fight()
		EndIf
	Until GetIsDead(-2) = 1 Or GetMapLoading()

EndFunc

;Need to write good fight function here!
Func Snowball_Fight()
	Out("打雪仗!")
	PingSleep(100)
EndFunc


Func Checked_Fight()
	If GUICtrlRead($gui_cbx_Fight) = $GUI_CHECKED Then
	Emote()
	Fight_Last_Group()
	EndIf
EndFunc

Func SelectTarget()
	$tSwitchtarget = TimerInit()
	$target = GetCurrentTarget()
	$Me = GetAgentByID(-2)
	If $target <> 0 And DllStructGetData($target, 'Type') = 219 _
			And DllStructGetData($target, 'Allegiance') = 3 And GetIsDead($target) = 0 Then
		If TimerDiff($tSwitchtarget) < 1000 Or GetDistance($Me, $target) < 100 Then
			Return DllStructGetData($target, 'Id')
		Else
			ConsoleWrite("Switching Target, out of Range!" & @CRLF)
		EndIf
	EndIf
	Out("选择新目标")
	$Freezie = GetAgentById($MID_FREEZIE)
	If GetIsDead($Freezie) Then
		$target = GetNearestEnemyToAgent($meID)
		ConsoleWrite("Freezie is Dead! Roaming!" & @CRLF)
	Else
		$target = GetAgentByID(GetTarget($MID_Freezie))
		If $target = 0 Or GetIsDead($target) Or DllStructGetData($target, 'Allegiance') <> 3 Then
			$possibletarget = GetNearestEnemyToAgent($MID_Freezie)
			If GetDistance($possibletarget, $MID_Freezie) < 1250 Then
				ConsoleWrite("Roaming!" & @CRLF)
				$target = $possibletarget
			EndIf
		Else
			ConsoleWrite("Trying to copy target!" & @CRLF)
		EndIf
	EndIf
	If GetIsBoss($target) Then
		;It's a boss, lets search for minions first!
		$possibletarget = GetNearestEnemyToAgent($target)
		If $possibletarget <> 0 And GetDistance($possibletarget, $Freezie) < 1250 Then
			ConsoleWrite("Retargeting to Minion!" & @CRLF)
			$target = $possibletarget
		EndIf
	EndIf
	If $target <> 0 And GetIsDead($target) = 0 Then
		$targetId = DllStructGetData($target, 'Id')
		Out("正在攻击 " & $targetId)
		ChangeTarget($target)
		Sleep(GetPing())
		Attack($target)
		Return $targetId
	EndIf
EndFunc   ;==>SelectTarget


Func Fight()
	Out("正在攻击!")
	Do
		$enemyID = SelectTarget()
		While $enemyID <> 0 And Not $giveup
			$tLastTarget = TimerInit()
			$target = GetAgentByID($enemyID)
			$targetHP = DllStructGetData($target, 'HP')
			$shouldblock = GetIsCasting($target) And GetDistance($target, -2) < 200

			$skillbar = GetSkillbar()
			$useSkill = -1
			If DllStructGetData($skillbar, 'Id7') <> 0 And DllStructGetData($skillbar, 'Recharge7') = 0 Then
				$useSkill = 7; Finisher
			ElseIf TimerDiff($tBlock) > 1000 And DllStructGetData(GetEffect(485), 'SkillID') == 0 And DllStructGetData($skillbar, 'Recharge1') == 0 Then
				$useSkill = 1; Block
				$tBlock = TimerInit()
			ElseIf $shouldblock And DllStructGetData($skillbar, 'Recharge3') = 0 Then
				$useSkill = 3; Interrupt
				CancelAction(); No point in interrupting, if it would come to late
			ElseIf DllStructGetData($skillbar, 'AdrenalineA5') >= 10 * 25 And DllStructGetData($skillbar, 'Recharge5') == 0 Then
				$useSkill = 5; Uppercut
			ElseIf DllStructGetData($skillbar, 'AdrenalineA6') >= 7 * 25 And DllStructGetData($skillbar, 'Recharge6') == 0 Then
				$useSkill = 6; Headbutt
			ElseIf DllStructGetData($skillbar, 'AdrenalineA4') >= 4 * 25 And DllStructGetData($skillbar, 'Recharge4') == 0 Then
				$useSkill = 4; Hook
			Else
				$useSkill = 2
			EndIf
			If $useSkill <> -1 Then
				UseSkill($useSkill, $target)
			EndIf

			Sleep(200)
			$enemyID = SelectTarget()
		WEnd
		Out("正在跟随雪人 " & $MID_Freezie)
		RndSleep(GetPing())
		$Freezie = GetAgentById($MID_Freezie)
		Move(DllStructGetData($Freezie, 'X'), DllStructGetData($Freezie, 'Y'), 400)
		RndSleep(500)
	Until $giveup Or GetMapID() <> $QuestMapID
EndFunc   ;==>Fight



Func Kill()
   If GetMapLoading() == 2 Then Disconnected()
   If GetIsDead(-2) Then Return
   CheckHeals()
   Use_Snowballs()
   While GetNumberOfFoesInRangeOfAgent(-2,800) > 0
	  If GetMapLoading() == 2 Then Disconnected()
	  If GetIsDead(-2) Then Return
	  If GetSkillbarSkillAdrenaline($Mega_Snowball) >= 150 Then
		UseSkill(2,-1)   ;Mega_Snowball
		Use_Snowballs()
		TargetNearestEnemy()
		UseSkill($Snowball, -1)
		PingSleep(800)
	  EndIf
	  If GetSkillbarSkillAdrenaline($Mega_Snowball) >= 120 Then
		 Use_Snowballs()
		 TargetNearestEnemy()
		 UseSkill($Snowball, -1)
		 PingSleep(800)
	  EndIf
	  PingSleep(100)
	  Use_Snowballs()
	  TargetNearestEnemy()
	  Attack(-1)
   WEnd
   PingSleep(200)
EndFunc

Func Use_Snowballs()
	If IsRecharged($Mega_Snowball) Then
		UseSkill(3,-1)		;Snow Down Shirt
		UseSkill(4,-1)		;Hidden Rock
		UseSkill(7,-1)		;Ice_Fort (Defense)
		UseSkill(1,-1)		;Snowball
		UseSkill(8,-1)		;Snow Cone (Heals)
		UseSkill(2,-1)		;Mega SNowball
		UseSkill(6,-1)		;Open Support Sill.  Monk = +5hp Regen
		UseSkill(5,-1)		;Avalance
	EndIf
EndFunc

Func CheckHeals()
	If GetHealth > .5 Then
		UseSkill(8,-1)
	EndIf
EndFunc

Func GetNumberOfFoesInRangeOfAgent($aAgent = -2, $aRange = 1250)
   If GetMapLoading() == 2 Then Disconnected()
   Local $lAgent, $lDistance
   Local $lCount = 0, $lAgentArray = GetAgentArray(0xDB)
   If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)
   For $i = 1 To $lAgentArray[0]
	  $lAgent = $lAgentArray[$i]
	  If BitAND(DllStructGetData($lAgent, 'typemap'), 262144) Then
		If StringLeft(GetAgentName($lAgent), 7) <> "Servant" Then ContinueLoop
	  EndIf
	  If DllStructGetData($lAgent, 'Allegiance') <> 3 Then ContinueLoop
	  If DllStructGetData($lAgent, 'HP') <= 0 Then ContinueLoop
	  If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) > 0 Then ContinueLoop
	  ;If StringLeft(GetAgentName($lAgent), 7) <> "Sensali" Then ContinueLoop
	  $lDistance = GetDistance($lAgent)
	  If $lDistance > $aRange Then ContinueLoop
	  $lCount += 1
   Next
   Return $lCount
EndFunc

#CS
Func UseSkillEx($aSkillSlot, $aTarget)
	$tDeadlock = TimerInit()
	USESKILL($aSkillSlot, $aTarget)
	Do
		Sleep(50)
		If GetIsDead(-2) = True Then Return Death()
	Until GetSkillBarSkillRecharge($aSkillSlot) <> 0 Or TimerDiff($tDeadlock) > 1000
EndFunc   ;==>UseSkillEx
#CE

;~ Already Defined, here for example
;~ Description: Tests if an agent is a boss.

#CS
Func GetIsBoss($aAgent)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Return BitAND(DllStructGetData($aAgent, 'TypeMap'), 1024) > 0
EndFunc   ;==>GetIsBoss
#CE

#EndRegion Fight