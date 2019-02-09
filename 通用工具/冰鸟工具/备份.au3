#cs
#################################
#                               #
#          Vaettir Bot          #
#                               #
#           by gigi             #
#                               #
#################################

The Following mods were added:

-Storage of Event items using arrays (Ralle) (ditched)
-Alternate path to farming zone (Ralle)
-Use Cupcakes to run to farm area (Ralle/Savsuds)
-Random Travel (dDarek/Savsuds)
-Displays Norn title (dDarek)/// no no no thats from Skadlish pls edit this
-Store Golds (Danylia)

Testing peformed by Savsuds

Took away starting the bot fresh while in the farm area. Sorry about that, but to
adjust for a death on the run from Sifhalla, it had to be done.

#ce

#RequireAdmin
#NoTrayIcon

#include "GWA2Gigi.au3"
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <GuiEdit.au3>
Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Opt("MustDeclareVars", True)

; ==== Constants ====
Global Enum $DIFFICULTY_NORMAL, $DIFFICULTY_HARD
Global Enum $INSTANCETYPE_OUTPOST, $INSTANCETYPE_EXPLORABLE, $INSTANCETYPE_LOADING
Global Enum $RANGE_ADJACENT=156, $RANGE_NEARBY=240, $RANGE_AREA=312, $RANGE_EARSHOT=1000, $RANGE_SPELLCAST = 1085, $RANGE_SPIRIT = 2500, $RANGE_COMPASS = 5000
Global Enum $RANGE_ADJACENT_2=156^2, $RANGE_NEARBY_2=240^2, $RANGE_AREA_2=312^2, $RANGE_EARSHOT_2=1000^2, $RANGE_SPELLCAST_2=1085^2, $RANGE_SPIRIT_2=2500^2, $RANGE_COMPASS_2=5000^2
Global Enum $PROF_NONE, $PROF_WARRIOR, $PROF_RANGER, $PROF_MONK, $PROF_NECROMANCER, $PROF_MESMER, $PROF_ELEMENTALIST, $PROF_ASSASSIN, $PROF_RITUALIST, $PROF_PARAGON, $PROF_DERVISH

Global Const $MAP_ID_BJORA = 482
Global Const $MAP_ID_JAGA = 546
Global Const $MAP_ID_LONGEYE = 650
Global Const $Map_ID_SIFHALLA = 643

#Region Global Items
Global Const $RARITY_GOLD = 2624
Global Const $RARITY_PURPLE = 2626
Global Const $RARITY_BLUE = 2623
Global Const $RARITY_WHITE = 2621
;~ Weapon Mods
Global $Weapon_Mod_Array[25] = [893, 894, 895, 896, 897, 905, 906, 907, 908, 909, 6323, 6331, 15540, 15541, 15542, 15543, 15544, 15551, 15552, 15553, 15554, 15555, 17059, 19122, 19123]
Global Const $ITEM_ID_STAFF_HEAD = 896
Global Const $ITEM_ID_STAFF_WRAPPING = 908
Global Const $ITEM_ID_SHIELD_HANDLE = 15554
Global Const $ITEM_ID_FOCUS_CORE = 15551
Global Const $ITEM_ID_WAND = 15552
Global Const $ITEM_ID_BOW_STRING = 894
Global Const $ITEM_ID_BOW_GRIP = 906
Global Const $ITEM_ID_SWORD_HILT = 897
Global Const $ITEM_ID_SWORD_POMMEL = 909
Global Const $ITEM_ID_AXE_HAFT = 893
Global Const $ITEM_ID_AXE_GRIP = 905
Global Const $ITEM_ID_DAGGER_TANG = 6323
Global Const $ITEM_ID_DAGGER_HANDLE = 6331
Global Const $ITEM_ID_HAMMER_HAFT = 895
Global Const $ITEM_ID_HAMMER_GRIP = 907
Global Const $ITEM_ID_SCYTHE_SNATHE = 15543
Global Const $ITEM_ID_SCYTHE_GRIP = 15553
Global Const $ITEM_ID_SPEARHEAD = 15544
Global Const $ITEM_ID_SPEAR_GRIP = 15555
Global Const $ITEM_ID_INSCRIPTIONS_MARTIAL = 15540
Global Const $ITEM_ID_INSCRIPTIONS_FOCUS_SHIELD = 15541
Global Const $ITEM_ID_INSCRIPTIONS_ALL = 15542
Global Const $ITEM_ID_INSCRIPTIONS_GENERAL = 17059
Global Const $ITEM_ID_INSCRIPTIONS_SPELLCASTING = 19122
Global Const $ITEM_ID_INSCRIPTIONS_FOCUS_ITEMS = 19123
;~ General items
Global Const $ITEM_ID_LOCKPICKS = 22751
Global Const $ITEM_ID_ID_KIT = 2989
Global Const $ITEM_ID_SUP_ID_KIT = 5899
Global Const $ITEM_ID_SALVAGE_KIT = 2992
Global Const $ITEM_ID_EXP_SALVAGE_KIT = 2991
Global Const $ITEM_ID_SUP_SALVAGE_KIT = 5900
;~ Dyes I included colors not normally grabbed
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
;~ Alcohol
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
;~ Party
Global $Spam_Party_Array[5] = [6376, 21809, 21810, 21813, 36683]
Global Const $ITEM_ID_SNOWMAN_SUMMONER = 6376
Global Const $ITEM_ID_ROCKETS = 21809
Global Const $ITEM_ID_POPPERS = 21810
Global Const $ITEM_ID_SPARKLER = 21813
Global Const $ITEM_ID_PARTY_BEACON = 36683
;~ Sweets
Global $Spam_Sweet_Array[6] = [21492, 21812, 22269, 22644, 22752, 28436]
Global Const $ITEM_ID_FRUITCAKE = 21492
Global Const $ITEM_ID_BLUE_DRINK = 21812
Global Const $ITEM_ID_CUPCAKES = 22269
Global Const $ITEM_ID_BUNNIES = 22644
Global Const $ITEM_ID_GOLDEN_EGGS = 22752
Global Const $ITEM_ID_PIE = 28436
;~ Tonics
Global $Tonic_Party_Array[4] = [15837, 21490, 30648, 31020]
Global Const $ITEM_ID_TRANSMOGRIFIER = 15837
Global Const $ITEM_ID_YULETIDE = 21490
Global Const $ITEM_ID_FROSTY = 30648
Global Const $ITEM_ID_MISCHIEVIOUS = 31020
;~ DR Removal
Global $DPRemoval_Sweets[6] = [6370, 21488, 21489, 22191, 26784, 28433]
Global Const $ITEM_ID_PEPPERMINT_CC = 6370
Global Const $ITEM_ID_WINTERGREEN_CC = 21488
Global Const $ITEM_ID_RAINBOW_CC = 21489
Global Const $ITEM_ID_CLOVER = 22191
Global Const $ITEM_ID_HONEYCOMB = 26784
Global Const $ITEM_ID_PUMPKIN_COOKIE = 28433
;~ Special Drops
Global $Special_Drops[7] = [5656, 18345, 21491, 37765, 21833, 28433, 28434]
Global Const $ITEM_ID_CC_SHARDS = 556
Global Const $ITEM_ID_VICTORY_TOKEN = 18345
Global Const $ITEM_ID_WINTERSDAY_GIFT = 21491 ; Not really a drop
Global Const $ITEM_ID_WAYFARER_MARK = 37765
Global Const $ITEM_ID_LUNAR_TOKEN = 21833 ; Not really a drop
Global Const $ITEM_ID_LUNAR_TOKENS = 28433 ; Not really a drop
Global Const $ITEM_ID_TOTS = 28434
;~ Stupid Drops that I am not using, but in here in case you want these to add these to the CanPickUp and collect in your chest
Global $Map_Piece_Array[4] = [24629, 24630, 24631, 24632]
Global Const $ITEM_ID_MAP_PIECE_TL = 24629
Global Const $ITEM_ID_MAP_PIECE_TR = 24630
Global Const $ITEM_ID_MAP_PIECE_BL = 24631
Global Const $ITEM_ID_MAP_PIECE_BR = 24632
Global Const $ITEM_ID_GOLDEN_LANTERN = 4195
;~ Stackable Trophies
Global $Stackable_Trophies_Array[1] = [27047]
Global Const $ITEM_ID_GLACIAL_STONES = 27047
;~ Tomes
Global $Regular_Tome_Array[10] = [21796, 21797, 21798, 21799, 21800, 21801, 21802, 21803, 21804, 21805]
Global Const $ITEM_ID_Warrior_Tome = 21801
Global Const $ITEM_ID_Ranger_Tome = 21802
Global Const $ITEM_ID_Monk_Tome = 21800
Global Const $ITEM_ID_Necromancer_Tome = 21798
Global Const $ITEM_ID_Mesmer_Tome = 21797
Global Const $ITEM_ID_Elementalist_Tome = 21799
Global Const $ITEM_ID_Assassin_Tome = 21796
Global Const $ITEM_ID_Ritualist_Tome = 21804
Global Const $ITEM_ID_Paragon_Tome = 21805
Global Const $ITEM_ID_Dervish_Tome = 21803
;~ Elite Tomes
Global $Elite_Tome_Array[10] = [21786, 21787, 21788, 21789, 21790, 21791, 21792, 21793, 21794, 21795]
Global Const $ITEM_ID_Warrior_EliteTome = 21791
Global Const $ITEM_ID_Ranger_EliteTome = 21792
Global Const $ITEM_ID_Monk_EliteTome = 21790
Global Const $ITEM_ID_Necromancer_EliteTome = 21788
Global Const $ITEM_ID_Mesmer_EliteTome = 21787
Global Const $ITEM_ID_Elementalist_EliteTome = 21789
Global Const $ITEM_ID_Assassin_EliteTome = 21786
Global Const $ITEM_ID_Ritualist_EliteTome = 21794
Global Const $ITEM_ID_Paragon_EliteTome = 21795
Global Const $ITEM_ID_Dervish_EliteTome = 21793

#Region Weapon ModelIDs
;~ Shields
Global $OakenAegisTactics = 2414
Global $OakenAegisStrength = 2413
Global $ShieldoftheLion = 1888
Global $EquineAegisCommand = 2409
Global $EquineAegisTactics = 2410
Global $EbonhandAegis = 2408; not in array
;~ Hammers
Global $RubyMaul = 2274
;~ Bows
Global $DragonHornbow = 1760
Global $MaplewoodLongbow = 2037

Global $Array_Weapon_ModelID[8][2] = [ _
									[$OakenAegisStrength, 16], _
									[$OakenAegisTactics, 16], _
									[$ShieldoftheLion, 16], _
									[$EquineAegisCommand, 16], _
									[$EquineAegisTactics, 16], _
									[$RubyMaul, 35], _
									[$DragonHornbow, 28], _
									[$MaplewoodLongbow, 28]]
#EndRegion Weapon ModelIDs

;~ Arrays for the title spamming (Not inside this version of the bot, but at least the arrays are made for you)
Global $ModelsAlcohol[100] = [910, 2513, 5585, 6049, 6366, 6367, 6375, 15477, 19171, 22190, 24593, 28435, 30855, 31145, 31146, 35124, 36682]
Global $ModelSweetOutpost[100] = [15528, 15479, 19170, 21492, 21812, 22644, 31150, 35125, 36681]
Global $ModelsSweetPve[100] = [22269, 22644, 28431, 28432, 28436]
Global $ModelsParty[100] = [6368, 6369, 6376, 21809, 21810, 21813]

Global $Array_pscon[39]=[$ITEM_ID_HUNTERS_ALE, $ITEM_ID_DWARVEN_ALE, $ITEM_ID_SPIKED_EGGNOG, $ITEM_ID_EGGNOG, $ITEM_ID_SHAMROCK_ALE, $ITEM_ID_AGED_DWARVEN_ALE, $ITEM_ID_CIDER, $ITEM_ID_GROG, $ITEM_ID_AGED_HUNTERS_ALE, $ITEM_ID_KRYTAN_BRANDY, $ITEM_ID_BATTLE_ISLE_ICED_TEA, $ITEM_ID_SNOWMAN_SUMMONER, $ITEM_ID_ROCKETS, $ITEM_ID_POPPERS, $ITEM_ID_SPARKLER, $ITEM_ID_PARTY_BEACON, $ITEM_ID_FRUITCAKE, $ITEM_ID_BLUE_DRINK, $ITEM_ID_CUPCAKES, $ITEM_ID_BUNNIES, $ITEM_ID_GOLDEN_EGGS, $ITEM_ID_PIE, $ITEM_ID_TRANSMOGRIFIER, $ITEM_ID_YULETIDE, $ITEM_ID_FROSTY, $ITEM_ID_MISCHIEVIOUS, $ITEM_ID_PEPPERMINT_CC, $ITEM_ID_WINTERGREEN_CC, $ITEM_ID_RAINBOW_CC, $ITEM_ID_CLOVER, $ITEM_ID_HONEYCOMB, $ITEM_ID_PUMPKIN_COOKIE, $ITEM_ID_CC_SHARDS, $ITEM_ID_VICTORY_TOKEN, $ITEM_ID_WINTERSDAY_GIFT, $ITEM_ID_LUNAR_TOKEN, $ITEM_ID_LUNAR_TOKENS, $ITEM_ID_GLACIAL_STONES, $ITEM_ID_TOTS]

#Region Global MatsPic´s And ModelID´Select
Global $PIC_MATS[24][2] = [["Fur Square", 941],["Bolt of Linen", 926],["Bolt of Damask", 927],["Bolt of Silk", 928],["Glob of Ectoplasm", 930],["Steel of Ignot", 949],["Deldrimor Steel Ingot", 950],["Monstrous Claws", 923],["Monstrous Eye", 931],["Monstrous Fangs", 932],["Rubies", 937],["Sapphires", 938],["Diamonds", 935],["Onyx Gemstones", 936],["Lumps of Charcoal", 922],["Obsidian Shard", 945],["Tempered Glass Vial", 939],["Leather Squares", 942],["Elonian Leather Square", 943],["Vial of Ink", 944],["Rolls of Parchment", 951],["Rolls of Vellum", 952],["Spiritwood Planks", 956]]
#EndRegion Global MatsPic´s And ModelID´Select

Global $Array_Store_ModelIDs460[147] = [474, 476, 486, 522, 525, 811, 819, 822, 835, 610, 2994, 19185, 22751, 4629, 24630, 4631, 24632, 27033, 27035, 27044, 27046, 27047, 7052, 5123 _
		, 1796, 21797, 21798, 21799, 21800, 21801, 21802, 21803, 21804, 1805, 910, 2513, 5585, 6049, 6366, 6367, 6375, 15477, 19171, 22190, 24593, 28435, 30855, 31145, 31146, 35124, 36682 _
		, 6376 , 6368 , 6369 , 21809 , 21810, 21813, 29436, 29543, 36683, 4730, 15837, 21490, 22192, 30626, 30630, 30638, 30642, 30646, 30648, 31020, 31141, 31142, 31144, 1172, 15528 _
		, 15479, 19170, 21492, 21812, 22269, 22644, 22752, 28431, 28432, 28436, 1150, 35125, 36681, 3256, 3746, 5594, 5595, 5611, 5853, 5975, 5976, 21233, 22279, 22280, 6370, 21488 _
		, 21489, 22191, 35127, 26784, 28433, 18345, 21491, 28434, 35121, 921, 922, 923, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943 _
		, 944, 945, 946, 948, 949, 950, 951, 952, 953, 954, 955, 956, 6532, 6533]

#EndRegion Global Items

#Region Guild Hall Globals
;~ Prophecies
Global $BurningIsle_GH_ID = 52 ;Key=Burning Isle
Global $Druid_GH_ID = 70 ;Key=Druid´s Isle
Global $FrozenIsle_GH_ID = 68 ;Key=Frozen Isle
Global $Hunter_GH_ID = 8 ;Key=Hunter´s Isle
Global $IsleOFDead_GH_ID = 179 ;Key=Isle Of Dead
Global $NomadIsle_GH_ID = 69 ;Key=Nomand´s Isle
Global $WarriorsIsle_GH_ID = 7 ;Key=Warrior´s Isle
Global $WizardsIsle_GH_ID = 9 ;Key=Wizard´s Isle
;~ Factions
Global $Imperial_GH_ID = 363 ;Key=Imperial Isle
Global $IsleOfJade_GH_ID = 362 ;Key=Isle Of Jade
Global $Meditation_GH_ID = 360 ;Key=Isle Of Meditation
Global $IsleOfWeepingStone_GH_ID = 361 ;Key=Isle Of Weeping Stone
;~ Nightfall
Global $Corrupted_GH_ID = 539 ;Key=Corrupted Isle
Global $Solitude_GH_ID = 538 ;Key=Isle of Solitude
Global $IsleOfWurm_GH_ID = 532 ;Key=Isle Of Wurm
Global $Ucharted_GH_ID = 531 ;Key=Ucharted Isle

Global $BURNINGISLE = False
Global $DRUIDISLE = False
Global $FROZENISLE = False
Global $HUNTERISLE = False
Global $ISLEOFDEAD = False
Global $NOMADISLE = False
Global $WARRIORISLE = False
Global $WIZARDISLE = False
Global $IMPERIALISLE = False
Global $ISLEOFJADE = False
Global $ISLEOFMEDITATION = False
Global $ISLEOFWEEPING = False
Global $CORRUPTEDISLE = False
Global $ISLEOFSOLITUDE = False
Global $ISLEOFWURMS = False
Global $UNCHARTEDISLE = False
#endregion Guild Hall Globals

; ================== CONFIGURATION ==================
; True or false to load the list of logged in characters or not
Global Const $doLoadLoggedChars = True
; ================ END CONFIGURATION ================

; ==== Bot global variables ====
Global $RenderingEnabled = True
Global $PickUpAll = True
Global $PickUpMapPieces = False
Global $PickUpTomes = False
Global $RunCount = 0
Global $FailCount = 0
Global $BotRunning = False
Global $BotInitialized = False
Global $ChatStuckTimer = TimerInit()

Global $BAG_SLOTS[23] = [0, 20, 10, 15, 15, 20, 41, 12, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 9]

;~ Any pcons you want to use during a run
Global $pconsCupcake_slot[2]
Global $useCupcake = True ; set it on true and he use it

; ==== Build ====
Global Const $SkillBarTemplate = "OwVUI2h5lPP8Id2BkAiAvpLBTAA"
; declare skill numbers to make the code WAY more readable (UseSkill($sf) is better than UseSkill(2))
Global Const $paradox = 1
Global Const $sf = 2
Global Const $shroud = 3
Global Const $wayofperf = 4
Global Const $hos = 5
Global Const $wastrel = 6
Global Const $echo = 7
Global Const $channeling = 8
; Store skills energy cost
Global $skillCost[9]
$skillCost[$paradox] = 15
$skillCost[$sf] = 5
$skillCost[$shroud] = 10
$skillCost[$wayofperf] = 5
$skillCost[$hos] = 5
$skillCost[$wastrel] = 5
$skillCost[$echo] = 15
$skillCost[$channeling] = 5
;~ Skill IDs
Global Const $SKILL_ID_SHROUD = 1031
Global Const $SKILL_ID_CHANNELING = 38
Global Const $SKILL_ID_ARCHANE_ECHO = 75
Global Const $SKILL_ID_WASTREL_DEMISE = 1335


#Region GUI
Global $SELECT_GH = "Burning Isle|Druid's Isle|Frozen Isle|Hunter's Isle|Isle of the Dead|Nomad's Isle|Warrior's Isle|Wizard's Isle|Imperial Isle|Isle of Jade|Isle of Meditation|Isle of Weeping Stone|Corrupted Isle|Isle of Solitude|Isle of Wurms|Uncharted Isle"
Global $HOWMANYDATA = "", $MATID, $RAREMATSBUY = False, $mFoundChest = False, $mFoundMerch = False, $Bags = 4, $PICKUP_GOLDS = False
Global $HOWMANY_AMOUNT = "2|3|4|5|6|7|8|9|10|11|12|13|14|15"
Global $SELECT_MAT = "Fur Square|Bolt of Linen|Bolt of Damask|Bolt of Silk|Glob of Ectoplasm|Steel of Ignot|Deldrimor Steel Ingot|Monstrous Claws|Monstrous Eye|Monstrous Fangs|Rubies|Sapphires|Diamonds|Onyx Gemstones|Lumps of Charcoal|Obsidian Shard|Tempered Glass Vial|Leather Squares|Elonian Leather Square|Vial of Ink|Rolls of Parchment|Rolls of Vellum|Spiritwood Planks"
Global $SELECT_TOWN = "Longeye's Ledge|Sifhalla"
Global $LONGEYE = False
Global $SIFHALLA = False

Global Const $mainGui = GUICreate("Vaettir Bot", 350, 275)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
Global $Input
If $doLoadLoggedChars Then
	$Input = GUICtrlCreateCombo("", 8, 8, 129, 21)
		GUICtrlSetData(-1, GetLoggedCharNames())
Else
	$Input = GUICtrlCreateInput("character name", 8, 8, 129, 21)
EndIf
Global $LOCATION = GUICtrlCreateCombo("Location", 8, 35, 125, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlCreateLabel("Runs:", 8, 65, 70, 17)
Global Const $RunsLabel = GUICtrlCreateLabel($RunCount, 80, 65, 50, 17)
GUICtrlCreateLabel("Fails:", 8, 80, 70, 17)
Global Const $FailsLabel = GUICtrlCreateLabel($FailCount, 80, 80, 50, 17)
Global Const $Checkbox = GUICtrlCreateCheckbox("Disable Rendering", 8, 98, 129, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "ToggleRendering")
Global Const $Button = GUICtrlCreateButton("Start", 8, 120, 131, 25)
	GUICtrlSetOnEvent(-1, "GuiButtonHandler")
Global Const $StatusLabel = GUICtrlCreateLabel("", 8, 148, 125, 17)
Global $GUILDHALL = GUICtrlCreateCombo("Guild Hall", 8, 168, 125, 25)
Global $SELECTMAT = GUICtrlCreateCombo("Rare Mat´s", 8, 188, 125,  25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
Global $HOWMANY = GUICtrlCreateCombo("HowMany", 8, 208, 125,  25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
Global $INPUTPRICEFORRARE = GUICtrlCreateInput("", 8, 228, 125, 20)
GUICtrlSetLimit($INPUTPRICEFORRARE, 5)
Global $GLOGBOX = GUICtrlCreateEdit("", 140, 8, 200, 240, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
GUICtrlSetColor($GLOGBOX, 65280)
GUICtrlSetBkColor($GLOGBOX, 0)
GUISetState(@SW_SHOW)
Global Const $Leeching = GUICtrlCreateCheckbox("Leech Bot Present", 8, 253, 110, 17)
Global Const $MapPieces = GUICtrlCreateCheckbox("Map Pieces", 140, 253, 75, 17)
Global Const $Tomes = GUICtrlCreateCheckbox("Mesmer Tomes", 240, 253, 90, 17)

GUICtrlSetData($LOCATION, $SELECT_TOWN)
GUICtrlSetData($GUILDHALL, $SELECT_GH)
GUICtrlSetData($SELECTMAT, $SELECT_MAT)
GUICtrlSetData($HOWMANY, $HOWMANY_AMOUNT)
GUICtrlSetOnEvent($GUILDHALL, "START_STOP")
GUICtrlSetOnEvent($SELECTMAT, "START_STOP")

;~ Description: Handles the button presses
Func GuiButtonHandler()
	If $BotRunning Then
		GUICtrlSetData($Button, "Will pause after this run")
		GUICtrlSetState($Button, $GUI_DISABLE)
		$BotRunning = False
	ElseIf $BotInitialized Then
		GUICtrlSetData($Button, "Pause")
		$BotRunning = True
	Else
		Out("Initializing")
		Local $CharName = GUICtrlRead($Input)
		If $CharName=="" Then
			If Initialize(ProcessExists("gw.exe"), True, True, False) = False Then
				MsgBox(0, "Error", "Guild Wars is not running.")
				Exit
			EndIf
		Else
			If Initialize($CharName, True, True, False) = False Then
				MsgBox(0, "Error", "Could not find a Guild Wars client with a character named '"&$CharName&"'")
				Exit
			EndIf
		EndIf
		EnsureEnglish(True)
		GUICtrlSetState($Checkbox, $GUI_ENABLE)
		GUICtrlSetState($Leeching, $GUI_ENABLE)
		GUICtrlSetState($MapPieces, $GUI_ENABLE)
		GUICtrlSetState($Tomes, $GUI_ENABLE)
		GUICtrlSetState($Input, $GUI_DISABLE)
		GUICtrlSetData($Button, "Pause")
		WinSetTitle($mainGui, "", "VBot-" & GetCharname())
		$BotRunning = True
		$BotInitialized = True
	EndIf
EndFunc
#EndRegion GUI

Func START_STOP()
	Switch (@GUI_CtrlId)
		Case $SELECTMAT
			MATSWITCHER()

		Case $GUILDHALL
			GHSWITCHER()
	EndSwitch
EndFunc   ;==>START_STOP

Out("Waiting for input")

While Not $BotRunning
	Sleep(100)
WEnd

; load template if we're in town
If GetMapLoading() == $INSTANCETYPE_OUTPOST Then LoadSkillTemplate($SkillBarTemplate)

While True
	If GUICtrlRead($LOCATION, "") == "Longeye's Ledge" Then
		$LONGEYE = True
	ElseIf GUICtrlRead($LOCATION, "") == "Sifhalla" Then
		$SIFHALLA = True
	EndIf
	If $SIFHALLA Then MapS()
	If $LONGEYE Then MapL()
	If $SIFHALLA Then RunThereSifhalla()
	If $LONGEYE Then RunThereLongeyes()
	If (GetIsDead(-2)==True) Then ContinueLoop

	If GUICtrlRead($Leeching) = 1 Then
		$PickUpAll = False
	Else
		$PickUpAll = True
	EndIf

	If GUICtrlRead($MapPieces) = 1 Then
		$PickUpMapPieces = True
	Else
		$PickUpMapPieces = False
	EndIf

	If GUICtrlRead($Tomes) = 1 Then
		$PickUpTomes = True
	Else
		$PickUpTomes = False
	EndIf

	While (CountSlots() > 4)
		If Not $BotRunning Then
			Out("Bot Paused")
			GUICtrlSetState($Button, $GUI_ENABLE)
			GUICtrlSetData($Button, "Start")
			While Not $BotRunning
				Sleep(100)
			WEnd
		EndIf
		CombatLoop()
	WEnd

	If (CountSlots() < 5) Then
		If Not $BotRunning Then
			Out("Bot Paused")
			GUICtrlSetState($Button, $GUI_ENABLE)
			GUICtrlSetData($Button, "Start")
			While Not $BotRunning
				Sleep(100)
			WEnd
		EndIf
		PLACE_FOR_INVENTORY()
	EndIf
WEnd

Func MapL()
;~ Checks if you are already in Longeye's Ledge, if not then you travel to Longeye's Ledge
	If GetMapID() <> $MAP_ID_LONGEYE Then
		Out("Travelling to longeye")
		RndTravel($MAP_ID_LONGEYE)
	EndIf
;~ Hardmode
	SwitchMode(1)

	Out("Exiting Outpost")
	Move(-26472, 16217)
	WaitMapLoading($MAP_ID_BJORA)

;~ Scans your bags for Cupcakes and uses one to make the run faster.
	pconsScanInventory()
	Sleep(GetPing()+500)
	UseCupcake()
	Sleep(GetPing()+500)
;~ Displays your Norn Title for the Health boost.
	SetDisplayedTitle(0x29)
	Sleep(GetPing()+500)
EndFunc

Func MapS()
;~ Checks if you are already in Sifhalla, if not then you travel to Sifhalla
	If (GetMapID() <> $Map_ID_Sifhalla) Then
		Out("Travelling to Sifhalla")
		RndTravel($Map_ID_Sifhalla)
	EndIf
;~ Hardmode
	SwitchMode(1)

	Out("Exiting Outpost")
	MoveTo(16197, 22825)
	Move(16800, 22867)
	WaitMapLoading($MAP_ID_JAGA)

;~ Scans your bags for Cupcakes and uses one to make the run faster.
	pconsScanInventory()
	Sleep(GetPing()+500)
	UseCupcake()
	Sleep(GetPing()+500)
;~ Displays your Norn Title for the Health boost.
	SetDisplayedTitle(0x29)
	Sleep(GetPing()+500)
EndFunc

;~ Description: zones to longeye if we're not there, and travel to Jaga Moraine
Func RunThereLongeyes()
	Out("Running to farm spot")
	DIM $array_Longeyes[31][3] = [ _
										[1, 15003.8, -16598.1], _
										[1, 15003.8, -16598.1], _
										[1, 12699.5, -14589.8], _
										[1, 11628,   -13867.9], _
										[1, 10891.5, -12989.5], _
										[1, 10517.5, -11229.5], _
										[1, 10209.1, -9973.1], _
										[1, 9296.5,  -8811.5], _
										[1, 7815.6,  -7967.1], _
										[1, 6266.7,  -6328.5], _
										[1, 4940,    -4655.4], _
										[1, 3867.8,  -2397.6], _
										[1, 2279.6,  -1331.9], _
										[1, 7.2,     -1072.6], _
										[1, 7.2,     -1072.6], _
										[1, -1752.7, -1209], _
										[1, -3596.9, -1671.8], _
										[1, -5386.6, -1526.4], _
										[1, -6904.2, -283.2], _
										[1, -7711.6, 364.9], _
										[1, -9537.8, 1265.4], _
										[1, -11141.2,857.4], _
										[1, -12730.7,371.5], _
										[1, -13379,  40.5], _
										[1, -14925.7,1099.6], _
										[1, -16183.3,2753], _
										[1, -17803.8,4439.4], _
										[1, -18852.2,5290.9], _
										[1, -19250,  5431], _
										[1, -19968, 5564], _
										[2, -20076,  5580]]
	Out("Running to Jaga")
	For $i = 0 To (UBound($array_Longeyes) -1)
		If ($array_Longeyes[$i][0]==1)Then
			If Not MoveRunning($array_Longeyes[$i][1], $array_Longeyes[$i][2])Then ExitLoop
		EndIf
		If ($array_Longeyes[$i][0]==2)Then
			Move($array_Longeyes[$i][1], $array_Longeyes[$i][2], 30)
			WaitMapLoading($MAP_ID_JAGA)
		EndIf
	Next
EndFunc

Func RunThereSifhalla()
	Out("Running to farm spot")
	DIM $array_Sifhalla[31][3] = [ _
								[1, -11059,	-23401], _
								[1, -8524,	-21590], _
								[1, -8870,	-21818], _
								[1, -6979,	-21705], _
								[1, -4144,	-25480], _
								[1, -456,	-25575], _
								[1, 2362,	-23315], _
								[1, 1877,	-21862], _
								[1, 914,	-21159], _
								[1, 1303,	-18593], _
								[1, 2092,	-16943], _
								[1, 2909,	-15487], _
								[1, 2757,	-13745], _
								[1, 1280,	-11243], _
								[1, -217,	-10112], _
								[1, -1201,	-8855], _
								[1, -2022,	-8535], _
								[1, -2383,	-7170], _
								[1, -332,	-5391], _
								[1, 1726,	-5463], _
								[1, 3465,	-5999], _
								[1, 4130,	-8139], _
								[1, 5170,	-9609], _
								[1, 7922,	-11222], _
								[1, 9600,	-11614], _
								[1, 11818,	-13547], _
								[1, 12911,	-15538], _
								[1, 14199,	-18786], _
								[1, 15201,	-20293], _
								[2, 15865, -20531], _
								[3, -20076,  5580]]

	For $i = 0 To (UBound($array_Sifhalla) -1)
		If ($array_Sifhalla[$i][0]==1)Then
			If Not MoveRunning($array_Sifhalla[$i][1], $array_Sifhalla[$i][2])Then ExitLoop
		EndIf
		If ($array_Sifhalla[$i][0]==2)Then
			Move($array_Sifhalla[$i][1], $array_Sifhalla[$i][2], 30)
			WaitMapLoading($MAP_ID_BJORA)
		EndIf
		If ($array_Sifhalla[$i][0]==3)Then
			Move($array_Sifhalla[$i][1], $array_Sifhalla[$i][2], 30)
			WaitMapLoading($MAP_ID_JAGA)
		EndIf
	Next
EndFunc

; Description: This is pretty much all, take bounty, do left, do right, kill, rezone
Func CombatLoop()
	If Not $RenderingEnabled Then ClearMemory()

	If GetNornTitle() < 160000 Then
		Out("Taking Blessing")
		GoNearestNPCToCoords(13318, -20826)
		Dialog(132)
	EndIf

	DisplayCounts()

	Sleep(GetPing()+2000)

	Out("Moving to aggro left")
	MoveTo(13501, -20925)
	MoveTo(13172, -22137)
	TargetNearestEnemy()
	MoveAggroing(12496, -22600, 150)
	MoveAggroing(11375, -22761, 150)
	MoveAggroing(10925, -23466, 150)
	MoveAggroing(10917, -24311, 150)
	MoveAggroing(9910, -24599, 150)
	MoveAggroing(8995, -23177, 150)
	MoveAggroing(8307, -23187, 150)
	MoveAggroing(8213, -22829, 150)
	MoveAggroing(8307, -23187, 150)
	MoveAggroing(8213, -22829, 150)
	MoveAggroing(8740, -22475, 150)
	MoveAggroing(8880, -21384, 150)
	MoveAggroing(8684, -20833, 150)
	MoveAggroing(8982, -20576, 150)

	Out("Waiting for left ball")
	WaitFor(12*1000)

	If GetDistance()<1000 Then
		UseSkillEx($hos, -1)
	Else
		UseSkillEx($hos, -2)
	EndIf

	WaitFor(6000)

	TargetNearestEnemy()

	Out("Moving to aggro right")
	MoveAggroing(10196, -20124, 150)
	MoveAggroing(9976, -18338, 150)
	MoveAggroing(11316, -18056, 150)
	MoveAggroing(10392, -17512, 150)
	MoveAggroing(10114, -16948, 150)
	MoveAggroing(10729, -16273, 150)
	MoveAggroing(10810, -15058, 150)
	MoveAggroing(11120, -15105, 150)
	MoveAggroing(11670, -15457, 150)
	MoveAggroing(12604, -15320, 150)
	TargetNearestEnemy()
	MoveAggroing(12476, -16157)

	;Out("Waiting for right ball")
	WaitFor(15*1000)

	If GetDistance()<1000 Then
		UseSkillEx($hos, -1)
	Else
		UseSkillEx($hos, -2)
	EndIf

	WaitFor(5000)

	;Out("Blocking enemies in spot")
	MoveAggroing(12920, -17032, 30)
	MoveAggroing(12847, -17136, 30)
	MoveAggroing(12720, -17222, 30)
	WaitFor(300)
	MoveAggroing(12617, -17273, 30)
	WaitFor(300)
	MoveAggroing(12518, -17305, 20)
	WaitFor(300)
	MoveAggroing(12445, -17327, 10)

	;Out("Killing")
	Kill()

	WaitFor(1200)

	;Out("Looting")
	PickUpLoot()

	If GetIsDead(-2) Then
		$FailCount += 1
		GUICtrlSetData($FailsLabel, $FailCount)
	Else
		$RunCount += 1
		GUICtrlSetData($RunsLabel, $RunCount)
	EndIf

	;Out("Zoning")
	MoveAggroing(12289, -17700)
	MoveAggroing(15318, -20351)

	While GetIsDead(-2)
		Out("Waiting for res")
		Sleep(1000)
	WEnd

	Move(15865, -20531)
	WaitMapLoading($MAP_ID_BJORA)

	MoveTo(-19968, 5564)
	Move(-20076,  5580, 30)

	WaitMapLoading($MAP_ID_JAGA)

EndFunc

#CS
Description: use whatever skills you need to keep yourself alive.
Take agent array as param to more effectively react to the environment (mobs)
#CE
Func StayAlive(Const ByRef $lAgentArray)
	If IsRecharged($sf) Then
		UseSkillEx($paradox)
		UseSkillEx($sf)
	EndIf

	Local $lMe = GetAgentByID(-2)
	Local $lEnergy = GetEnergy($lMe)
	Local $lAdjCount, $lAreaCount, $lSpellCastCount, $lProximityCount
	Local $lDistance
	For $i=1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], "Allegiance") <> 0x3 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], "HP") <= 0 Then ContinueLoop
		$lDistance = GetPseudoDistance($lMe, $lAgentArray[$i])
		If $lDistance < 1200*1200 Then
			$lProximityCount += 1
			If $lDistance < $RANGE_SPELLCAST_2 Then
				$lSpellCastCount += 1
				If $lDistance < $RANGE_AREA_2 Then
					$lAreaCount += 1
					If $lDistance < $RANGE_ADJACENT_2 Then
						$lAdjCount += 1
					EndIf
				EndIf
			EndIf
		EndIf
	Next

	UseSF($lProximityCount)

	If IsRecharged($shroud) Then
		If $lSpellCastCount > 0 And DllStructGetData(GetEffect($SKILL_ID_SHROUD), "SkillID") == 0 Then
			UseSkillEx($shroud)
		ElseIf DllStructGetData($lMe, "HP") < 0.6 Then
			UseSkillEx($shroud)
		ElseIf $lAdjCount > 20 Then
			UseSkillEx($shroud)
		EndIf
	EndIf

	UseSF($lProximityCount)

	If IsRecharged($wayofperf) Then
		If DllStructGetData($lMe, "HP") < 0.5 Then
			UseSkillEx($wayofperf)
		ElseIf $lAdjCount > 20 Then
			UseSkillEx($wayofperf)
		EndIf
	EndIf

	UseSF($lProximityCount)

	If IsRecharged($channeling) Then
		If $lAreaCount > 5 And GetEffectTimeRemaining($SKILL_ID_CHANNELING) < 2000 Then
			UseSkillEx($channeling)
		EndIf
	EndIf

	UseSF($lProximityCount)
EndFunc

;~ Description: Uses sf if there's anything close and if its recharged
Func UseSF($lProximityCount)
	If IsRecharged($sf) And $lProximityCount > 0 Then
		UseSkillEx($paradox)
		UseSkillEx($sf)
	EndIf
EndFunc

;~ Description: Move to destX, destY, while staying alive vs vaettirs
Func MoveAggroing($lDestX, $lDestY, $lRandom = 150)
	If GetIsDead(-2) Then Return

	Local $lMe, $lAgentArray
	Local $lBlocked
	Local $lHosCount
	Local $lAngle
	Local $stuckTimer = TimerInit()

	Move($lDestX, $lDestY, $lRandom)

	Do
		RndSleep(50)

		$lMe = GetAgentByID(-2)

		$lAgentArray = GetAgentArray(0xDB)

		If GetIsDead($lMe) Then Return False

		StayAlive($lAgentArray)

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			If $lHosCount > 6 Then
				Do	; suicide
					Sleep(100)
				Until GetIsDead(-2)
				Return False
			EndIf

			$lBlocked += 1
			If $lBlocked < 5 Then
				Move($lDestX, $lDestY, $lRandom)
			ElseIf $lBlocked < 10 Then
				$lAngle += 40
				Move(DllStructGetData($lMe, 'X')+300*sin($lAngle), DllStructGetData($lMe, 'Y')+300*cos($lAngle))
			ElseIf IsRecharged($hos) Then
				If $lHosCount==0 And GetDistance() < 1000 Then
					UseSkillEx($hos, -1)
				Else
					UseSkillEx($hos, -2)
				EndIf
				$lBlocked = 0
				$lHosCount += 1
			EndIf
		Else
			If $lBlocked > 0 Then
				If TimerDiff($ChatStuckTimer) > 3000 Then	; use a timer to avoid spamming /stuck
					SendChat("stuck", "/")
					$ChatStuckTimer = TimerInit()
				EndIf
				$lBlocked = 0
				$lHosCount = 0
			EndIf

			If GetDistance() > 1100 Then ; target is far, we probably got stuck.
				If TimerDiff($ChatStuckTimer) > 3000 Then ; dont spam
					SendChat("stuck", "/")
					$ChatStuckTimer = TimerInit()
					RndSleep(GetPing())
					If GetDistance() > 1100 Then ; we werent stuck, but target broke aggro. select a new one.
						TargetNearestEnemy()
					EndIf
				EndIf
			EndIf
		EndIf

	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < $lRandom*1.5
	Return True
EndFunc

;~ Description: Move to destX, destY. This is to be used in the run from across Bjora
Func MoveRunning($lDestX, $lDestY)
	If GetIsDead(-2) Then Return False

	Local $lMe, $lTgt
	Local $lBlocked

	Move($lDestX, $lDestY)

	Do
		RndSleep(500)

		TargetNearestEnemy()
		$lMe = GetAgentByID(-2)
		$lTgt = GetAgentByID(-1)

		If GetIsDead($lMe) Then Return False

		If GetDistance($lMe, $lTgt) < 1300 And GetEnergy($lMe)>20 And IsRecharged($paradox) And IsRecharged($sf) Then
			UseSkillEx($paradox)
			UseSkillEx($sf)
		EndIf

		If DllStructGetData($lMe, "HP") < 0.9 And GetEnergy($lMe) > 10 And IsRecharged($shroud) Then UseSkillEx($shroud)

		If DllStructGetData($lMe, "HP") < 0.5 And GetDistance($lMe, $lTgt) < 500 And GetEnergy($lMe) > 5 And IsRecharged($hos) Then UseSkillEx($hos, -1)

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			$lBlocked += 1
			Move($lDestX, $lDestY)
		EndIf

	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < 250
	Return True
EndFunc

;~ Description: Waits until all foes are in range (useless comment ftw)
Func WaitUntilAllFoesAreInRange($lRange)
	Local $lAgentArray
	Local $lAdjCount, $lSpellCastCount
	Local $lMe
	Local $lDistance
	Local $lShouldExit = False
	While Not $lShouldExit
		Sleep(100)
		$lMe = GetAgentByID(-2)
		If GetIsDead($lMe) Then Return
		$lAgentArray = GetAgentArray(0xDB)
		StayAlive($lAgentArray)
		$lShouldExit = False
		For $i=1 To $lAgentArray[0]
			$lDistance = GetPseudoDistance($lMe, $lAgentArray[$i])
			If $lDistance < $RANGE_SPELLCAST_2 And $lDistance > $lRange^2 Then
				$lShouldExit = True
				ExitLoop
			EndIf
		Next
	WEnd
EndFunc

;~ Description: Wait and stay alive at the same time (like Sleep(..), but without the letting yourself die part)
Func WaitFor($lMs)
	If GetIsDead(-2) Then Return
	Local $lAgentArray
	Local $lTimer = TimerInit()
	Do
		Sleep(100)
		If GetIsDead(-2) Then Return
		$lAgentArray = GetAgentArray(0xDB)
		StayAlive($lAgentArray)
	Until TimerDiff($lTimer) > $lMs
EndFunc

;~ Description: BOOOOOOOOOOOOOOOOOM
Func Kill()
	If GetIsDead(-2) Then Return

	Local $lAgentArray
	Local $lDeadlock = TimerInit()

	TargetNearestEnemy()
	Sleep(100)
	Local $lTargetID = GetCurrentTargetID()

	While GetAgentExists($lTargetID) And DllStructGetData(GetAgentByID($lTargetID), "HP") > 0
		Sleep(50)
		If GetIsDead(-2) Then Return
		$lAgentArray = GetAgentArray(0xDB)
		StayAlive($lAgentArray)

		; Use echo if possible
		If GetSkillbarSkillRecharge($sf) > 5000 And GetSkillbarSkillID($echo)==$SKILL_ID_ARCHANE_ECHO Then
			If IsRecharged($wastrel) And IsRecharged($echo) Then
				UseSkillEx($echo)
				UseSkillEx($wastrel, GetGoodTarget($lAgentArray))
				$lAgentArray = GetAgentArray(0xDB)
			EndIf
		EndIf

		UseSF(True)

		; Use wastrel if possible
		If IsRecharged($wastrel) Then
			UseSkillEx($wastrel, GetGoodTarget($lAgentArray))
			$lAgentArray = GetAgentArray(0xDB)
		EndIf

		UseSF(True)

		; Use echoed wastrel if possible
		If IsRecharged($echo) And GetSkillbarSkillID($echo)==$SKILL_ID_WASTREL_DEMISE Then
			UseSkillEx($echo, GetGoodTarget($lAgentArray))
		EndIf

		; Check if target has ran away
		If GetDistance(-2, $lTargetID) > $RANGE_EARSHOT Then
			TargetNearestEnemy()
			Sleep(GetPing()+100)
			If GetAgentExists(-1) And DllStructGetData(GetAgentByID(-1), "HP") > 0 And GetDistance(-2, -1) < $RANGE_AREA Then
				$lTargetID = GetCurrentTargetID()
			Else
				ExitLoop
			EndIf
		EndIf

		If TimerDiff($lDeadlock) > 60 * 1000 Then ExitLoop
	WEnd
EndFunc

; Returns a good target for watrels
; Takes the agent array as returned by GetAgentArray(..)
Func GetGoodTarget(Const ByRef $lAgentArray)
	Local $lMe = GetAgentByID(-2)
	For $i=1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], "Allegiance") <> 0x3 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], "HP") <= 0 Then ContinueLoop
		If GetDistance($lMe, $lAgentArray[$i]) > $RANGE_NEARBY Then ContinueLoop
		If GetHasHex($lAgentArray[$i]) Then ContinueLoop
		If Not GetIsEnchanted($lAgentArray[$i]) Then ContinueLoop
		Return DllStructGetData($lAgentArray[$i], "ID")
	Next
EndFunc

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
		Sleep(50)
		If GetIsDead(-2) = 1 Then Return
	Until (Not IsRecharged($lSkill)) Or (TimerDiff($lDeadlock) > $aTimeout)

	If $lSkill > 1 Then RndSleep(750)
EndFunc

; Checks if skill given (by number in bar) is recharged. Returns True if recharged, otherwise False.
Func IsRecharged($lSkill)
	Return GetSkillBarSkillRecharge($lSkill)==0
EndFunc

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

;~ Description: standard pickup function, only modified to increment a custom counter when taking stuff with a particular ModelID
Func PickUpLoot()
	Local $lAgent
	Local $lItem
	Local $lDeadlock
	For $i = 1 To GetMaxAgents()
		If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If CanPickup($lItem) Then
			PickUpItem($lItem)
			$lDeadlock = TimerInit()
			While GetAgentExists($i)
				Sleep(100)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
			WEnd
		EndIf
	Next
EndFunc   ;==>PickUpLoot

; Checks if should pick up the given item. Returns True or False
Func CanPickUp($aItem)
	Local $lModelID = DllStructGetData(($aItem), 'ModelID')
	Local $aExtraID = DllStructGetData($aItem, "ExtraID")
	Local $lRarity = GetRarity($aItem)
	Local $Requirement = GetItemReq($aItem)
	If (($lModelID == 2511) And (GetGoldCharacter() < 99000)) Then
		Return True	; gold coins (only pick if character has less than 99k in inventory)
	ElseIf ($lModelID == $ITEM_ID_Mesmer_Tome) And ($PickUpTomes = True) Then
		Return True	; Mesmer Tomes
	ElseIf ($lModelID == $ITEM_ID_DYES) Then	; if dye
		If (($aExtraID == $ITEM_EXTRAID_BLACKDYE) Or ($aExtraID == $ITEM_EXTRAID_WHITEDYE))Then ; only pick white and black ones
			Return True
		EndIf
	ElseIf ($lRarity == $RARITY_GOLD) And $PickUpAll Then ; gold items
		Return True
	ElseIf ($lRarity == $RARITY_PURPLE) And $PickUpAll Then ; purple items
		Return True
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

Func CheckArrayMapPieces($lModelID)
For $p = 0 To (UBound($Map_Piece_Array) -1)
	If ($lModelID == $Map_Piece_Array[$p]) Then Return True
Next
EndFunc

Func CheckArrayWeapons($lModelID, $Requirement, $aItem)
For $i = 0 To (UBound($Array_Weapon_ModelID) -1)
	If(($lModelID == $Array_Weapon_ModelID[$i][0]) And ($Requirement <= 9) And (GetItemMaxDmg($aItem) == $Array_Weapon_ModelID[$i][1]))Then
		Return True
	EndIf
Next
EndFunc

Func GetItemMaxDmg($aItem)
	If Not IsDllStruct($aItem) Then $aItem = GetItemByItemID($aItem)
	Local $lModString = GetModStruct($aItem)
	Local $lPos = StringInStr($lModString, "A8A7") ; Weapon Damage
	If $lPos = 0 Then $lPos = StringInStr($lModString, "C867") ; Energy (focus)
	If $lPos = 0 Then $lPos = StringInStr($lModString, "B8A7") ; Armor (shield)
	If $lPos = 0 Then Return 0
	Return Int("0x" & StringMid($lModString, $lPos - 2, 2))
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

Func DISCONNECTED()
	OUT("Disconnected!")
	OUT("Attempting to reconnect.")
	ControlSend(GetWindowHandle(), "", "", "{Enter}")
	Local $LCHECK = False
	Local $lDeadlock = TimerInit()
	Do
		Sleep(200)
		$LCHECK = GetMapLoading() <> 2 And GetAgentExists(-2)
	Until $LCHECK Or TimerDiff($lDeadlock) > 60000
	If $LCHECK = False Then
		OUT("Failed to Reconnect!")
		OUT("Retrying.")
		ControlSend(GetWindowHandle(), "", "", "{Enter}")
		$lDeadlock = TimerInit()
		Do
			Sleep(200)
			$LCHECK = GetMapLoading() <> 2 And GetAgentExists(-2)
		Until $LCHECK Or TimerDiff($lDeadlock) > 60000
		If $LCHECK = False Then
			OUT("Could not reconnect!")
			OUT("Exiting.")
			Exit 1
		EndIf
	EndIf
	OUT("Reconnected!")
	Sleep(8000)
EndFunc   ;==>DISCONNECTED

Func GhSwitcher()
	If GUICtrlRead($GUILDHALL, "") == "Uncharted Isle" Then
		$UNCHARTEDISLE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "Imperial Isle" Then
		$IMPERIALISLE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "Druid's Isl" Then
		$DRUIDISLE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "Hunter's Isle" Then
		$HUNTERISLE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "Isle of Wurms" Then
		$ISLEOFWURMS = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "Isle of Meditation" Then
		$ISLEOFMEDITATION = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "Isle of Solitude" Then
		$ISLEOFSOLITUDE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "Corrupted Isle" Then
		$CORRUPTEDISLE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "Isle of the Dead" Then
		$ISLEOFDEAD = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "Burning Isle" Then
		$BURNINGISLE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "Warrior's Isle" Then
		$WARRIORISLE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "Isle of Weeping Stone" Then
		$ISLEOFWEEPING = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "Frozen Isle" Then
		$FROZENISLE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "Nomad's Isle" Then
		$NOMADISLE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "Isle of Jade" Then
		$ISLEOFJADE = True
	ElseIf GUICtrlRead($GUILDHALL, "") == "Wizard's Isle" Then
		$WIZARDISLE = True
	EndIf
EndFunc

Func MATSWITCHER()
	$RAREMATSBUY = False
	OUT("$RareMatsBuy" & $RAREMATSBUY)
	For $i = 0 To UBound($PIC_MATS) - 1
		If (GUICtrlRead($SELECTMAT, "") == $PIC_MATS[$i][0]) Then
			$MATID = $PIC_MATS[$i][1]
			$RAREMATSBUY = True
			OUT("$RareMatsBuy" & $RAREMATSBUY)
			OUT("You Select -" & $PIC_MATS[$i][0])
			OUT("Mat Model ID == " & "" & $MATID)
		EndIf
	Next
EndFunc   ;==>MATSWITCHER

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
				OUT("Out of cash, beginning farm")
				Return False
		EndSwitch
	EndIf
	Return True
EndFunc   ;==>CHECKGOLD

Func PLACE_FOR_INVENTORY()
	Dim $GH_CHECK[16][5] = [ _
			[$DRUIDISLE, $Druid_GH_ID, "Travel To GH Druid", "You are in GH Druid", "Druid"], _
			[$ISLEOFDEAD, $IsleOFDead_GH_ID, "Travel To GH Isle OF Dead", "You are in GH Isle OF Dead", "Isle Of Dead"], _
			[$ISLEOFMEDITATION, $Meditation_GH_ID, "Travel To GH Meditation", "You are in GH Meditation", "Meditation"], _
			[$ISLEOFSOLITUDE, $Solitude_GH_ID, "Travel To GH Solitude", "You are in GH Solitude", "Solitude"], _
			[$UNCHARTEDISLE, $Ucharted_GH_ID, "Travel To GH Ucharted", "You are in GH Ucharted", "Uncharted"], _
			[$HUNTERISLE, $Hunter_GH_ID, "Travel To GH Hunter", "You are in GH Hunter", "Hunter"], _
			[$IMPERIALISLE, $Imperial_GH_ID, "Travel To GH Imperial", "You are in GH Imperial", "Imperial"], _
			[$ISLEOFWURMS, $IsleOfWurm_GH_ID, "Travel To GH Isle Of Wurm", "You are in GH Isle Of Wurm", "Isle Of Wurm"], _
			[$WIZARDISLE, $WizardsIsle_GH_ID, "Travel To GH Wizards Isle", "You are in GH Wizards Isle", "Wizards Isle"], _
			[$BURNINGISLE, $BurningIsle_GH_ID, "Travel To GH Burning Isle", "You are in GH Burning Isle", "Burning Isle"], _
			[$WARRIORISLE, $WarriorsIsle_GH_ID, "Travel To GH Warriors Isle", "You are in GH Warriors Isle", "Warriors Isle"], _
			[$ISLEOFWEEPING, $IsleOfWeepingStone_GH_ID, "Travel To GH Isle Of Weeping Stone", "You are in GH Isle Of Weeping Stone", "Isle Of Weeping Stone"], _
			[$FROZENISLE, $FrozenIsle_GH_ID, "Travel To GH Frozen Isle", "You are in GH Frozen Isle", "Frozen Isle"], _
			[$NOMADISLE, $NomadIsle_GH_ID, "Travel To GH Nomand Isle", "You are in GH Nomand Isle", "Nomad Isle"], _
			[$CORRUPTEDISLE, $Corrupted_GH_ID, "Travel to GH Corrupted Isle", " You are in GH Corrupted Isle", "Corrupted Isle"], _
			[$ISLEOFJADE, $IsleOfJade_GH_ID, "Travel To GH Isle Of Jade", "You are in GH Isle Of Jade", "Isle Of Jade"]]

	For $i = 0 To (UBound($GH_CHECK) - 1)
		If ($GH_CHECK[$i][0] == True) Then
			OUT($GH_CHECK[$i][2])
			If (GetMapID() <> $GH_CHECK[$i][1]) Then
				TravelGH()
				WaitMapLoading($GH_CHECK[$i][1], 10000)
				Inventory()
				Return True
			Else
				OUT($GH_CHECK[$i][3])
				Inventory()
				Return True
			EndIf
		EndIf
	Next
	Return False
EndFunc   ;==>PLACE_FOR_INVENTORY

#Region Inventory
#CS

#CE
Func Inventory()
;~ Opening the Chest
	Out("Going to Xunlai Chest.")
	CHEST()

	If GetGoldCharacter() > 90000 Then
		Out("Depositing Gold")
		DepositGold()
	EndIf

;~ Storing things I want to keep
	Out("Storing Stuff")
	StoreItems()
	StoreMaterials()
;	StoreReqs()
	StoreMods()
;	StoreUNIDGolds()

;~ Opening the Merchant
	Out("Going to Merchant.")
	MERCHANT()

	Out("Identifying")
;~ Identifies each bag
	Ident(1)
	Ident(2)
	Ident(3)
	Ident(4)

	Out("Selling")
;~ Sells each bag
	Sell(1)
	Sell(2)
	Sell(3)
	Sell(4)

	If GetGoldCharacter() > 90000 Then
		Out("Buying Rare Materials")
		RareMaterialTrader()
	EndIf
EndFunc

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

Func SELL($BAGINDEX)
	Local $AITEM
	Local $BAG = GETBAG($BAGINDEX)
	Local $NUMOFSLOTS = DllStructGetData($BAG, "slots")
	For $I = 1 To $NUMOFSLOTS
		Out("Selling item: " & $BAGINDEX & ", " & $I)
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
	If $LRARITY == $RARITY_GOLD Then
		Return True
	EndIf
	If $LRARITY == $RARITY_PURPLE Then
		Return True
	EndIf
;~ Leaving Blues and Whites as false for now. Going to make it salvage them at some point in the future. It does not currently pick up whites or blues
	If $LRARITY == $RARITY_BLUE Then
		Return False
	EndIf
	If $LRARITY == $RARITY_WHITE Then
		Return False
	EndIf
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
	Return True
EndFunc   ;==>CANSELL

Func CHEST()
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
			Local $aChestName = "Xunlai Chest"
			Local $lChest = GetAgentByName($aChestName)
			If IsDllStruct($lChest)Then
				OUT("Going to " & $aChestName)
				GoToNPC($lChest)
				RndSleep(Random(3000, 4200))
			EndIf
		EndIf
	Next
EndFunc   ;~ Xunlai Chest

Func MERCHANT()
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
			Local $aMerchName = "Merchant"
			Local $lMerch = GetAgentByName($aMerchName)
			If IsDllStruct($lMerch)Then
				OUT("Going to " & $aMerchName)
				GoToNPC($lMerch)
				RndSleep(Random(3000, 4200))
			EndIf
		EndIf
	Next
EndFunc   ;~ Merchant

Func RAREMATERIALTRADER()
	Dim $Waypoints_by_RareMatTrader[16][3] = [ _
			[$BURNINGISLE, -2126, -18], _
			[$DRUIDISLE, -1101, 4651], _
			[$FROZENISLE, -1116, 2988], _
			[$HUNTERISLE, 2973, 6597], _
			[$ISLEOFDEAD, -3413, -1519], _
			[$NOMADISLE, 392, 3469], _
			[$WARRIORISLE, 4003, 6014], _
			[$WIZARDISLE, 3337, 9904], _
			[$IMPERIALISLE, 217, 11807], _
			[$ISLEOFJADE, 6532, 1919], _
			[$ISLEOFMEDITATION, 467, 9834], _
			[$ISLEOFWEEPING, -1725, 8997], _
			[$CORRUPTEDISLE, -5639, 3857], _
			[$ISLEOFSOLITUDE, 3900, 4360], _
			[$ISLEOFWURMS, 6348, 3119], _
			[$UNCHARTEDISLE, 2525, -2184]]
	For $i = 0 To (UBound($Waypoints_by_RareMatTrader) - 1)
		If ($Waypoints_by_RareMatTrader[$i][0] == True) Then
			Do
				GENERICRANDOMPATH($Waypoints_by_RareMatTrader[$i][1], $Waypoints_by_RareMatTrader[$i][2], Random(60, 80, 2))
			Until CHECKAREA($Waypoints_by_RareMatTrader[$i][1], $Waypoints_by_RareMatTrader[$i][2])
			Local $lRareTrader = "Rare Material Trader"
			Local $lRare = GetAgentByName($lRareTrader)
			If IsDllStruct($lRare)Then
				OUT("Going to " & $lRareTrader)
				GoToNPC($lRare)
				RndSleep(Random(3000, 4200))
			EndIf
;~This section does the buying
			Local $Z = 0
			Do
				TraderRequest($MATID)
				Sleep(500 + 3 * GetPing())
				Local $LPRICE = GetTraderCostValue()
				Local $PRICE = GUICtrlRead($INPUTPRICEFORRARE, "")
				OUT("Price for" & $MATID & ":" & $LPRICE)
				OUT("My Setting" & $MATID & ":" & $PRICE)
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
					OUT("Price for" & $MATID & ":" & $LPRICE)
					OUT("My Setting" & $MATID & ":" & $PRICE)
					If ($LPRICE < $PRICE) Or ($LPRICE == $PRICE) Then
						TraderBuy()
						$q = $q + 1
					Else
						OUT("The Cost are to high!")
						ExitLoop
					EndIf
					If (CHECKGOLD() == False) Then ExitLoop
				WEnd
			EndIf
		EndIf
	Next
EndFunc   ;~ Rare Material trader

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
		Out("Current Gold:" & $CurrentGold)
	ElseIf GetGlacialStoneCount() > 0 Then
		Out("Glacial Conut:" & $GlacialStones)
	ElseIf GetMesmerTomeCount() > 0 Then
		Out("Mesmer Tomes:" & $MesmerTomes)
	ElseIf GetLockpickCount() > 0 Then
		Out ("Lockpicks:" & $Lockpicks)
	ElseIf GetBlackDyeCount() > 0 Then
		Out ("Black Dyes:" & $BlackDye)
	ElseIf GetWhiteDyeCount() > 0 Then
		Out ("White Dyes:" & $WhiteDye)
	EndIf
;	Rare Materials
	If GetFurCount() > 0 Then
		Out ("Fur Squares:" & $FurCount)
	ElseIf GetLinenCount() > 0 Then
		Out ("Linen:" & $LinenCount)
	ElseIf GetDamaskCount() > 0 Then
		Out ("Damask:" & $DamaskCount)
	ElseIf GetSilkCount() > 0 Then
		Out ("Silk:" & $SilkCount)
	ElseIf GetEctoCount() > 0 Then
		Out("Ecto Count:" & $EctoCount)
	ElseIf GetSteelCount() > 0 Then
		Out ("Steel:" & $SteelCount)
	ElseIf GetDeldSteelCount() > 0 Then
		Out ("Deldrimor Steel:" & $DSteelCount)
	ElseIf GetMonClawCount() > 0 Then
		Out ("Monstrous Claw:" & $MonClawCount)
	ElseIf GetMonEyeCount() > 0 Then
		Out ("Monstrous Eye:" & $MonEyeCount)
	ElseIf GetMonFangCount() > 0 Then
		Out ("Monstrous Fang:" & $MonFangCount)
	ElseIf GetRubyCount() > 0 Then
		Out ("Ruby:" & $RubyCount)
	ElseIf GetSapphireCount() > 0 Then
		Out ("Sapphire:" & $SapphireCount)
	ElseIf GetDiamondCount() > 0 Then
		Out ("Diamond:" & $DiamondCount)
	ElseIf GetOnyxCount() > 0 Then
		Out ("Onyx:" & $OnyxCount)
	ElseIf GetCharcoalCount() > 0 Then
		Out ("Charcoal:" & $CharcoalCount)
	ElseIf GetObsidianShardCount() > 0 Then
		Out("Obby Count:" & $ObShardCount)
	ElseIf GetGlassVialCount() > 0 Then
		Out ("Glass Vial:" & $GlassVialCount)
	ElseIf GetLeatherCount() > 0 Then
		Out ("Leather Square:" & $LeatherCount)
	ElseIf GetElonLeatherCount() > 0 Then
		Out ("Elonian Leather:" & $ElonLeatherCount)
	ElseIf GetVialInkCount() > 0 Then
		Out ("Vials of Ink:" & $VialInkCount)
	ElseIf GetParchmentCount() > 0 Then
		Out ("Parchment:" & $ParchmentCount)
	ElseIf GetVellumCount() > 0 Then
		Out ("Vellum:" & $VellumCount)
	ElseIf GetSpiritwoodCount() > 0 Then
		Out ("Spiritwood Planks:" & $SpiritwoodCount)
	ElseIf GetAmberCount() > 0 Then
		Out ("Amber:" & $AmberCount)
	ElseIf GetSpiritwoodCount() > 0 Then
		Out ("Jade:" & $JadeCount)
	EndIf
;	Event Items
	If GetAgedDwarvenAleCount() > 0 Then
		Out("Aged Dwarven Ale:" & $AgedDwarvenAle)
	ElseIf GetAgedHuntersAleCount() > 0 Then
		Out("Aged Hunter's Ale:" & $AgedHuntersAle)
	ElseIf GetIcedTeaCount() > 0 Then
		Out("Iced Tea:" & $BattleIslandIcedTea)
	ElseIf GetBirthdayCupcakeCount() > 0 Then
		Out("Cupcakes:" & $BirthdayCupcake)
	ElseIf GetBlueDrinkCount() > 0 Then
		Out("Blue Drink:" & $BlueDrink)
	ElseIf GetCandyCaneShards() > 0 Then
		Out("CC Shards:" & $CandyCaneShards)
	ElseIf GetPopperCount() > 0 Then
		Out("Champagne Poppers:" & $ChampagnePopper)
	ElseIf GetBunnyCount() > 0 Then
		Out("Chocolate Bunnies:" & $ChocolateBunny)
	ElseIf GetDwarvenAleCount() > 0 Then
		Out("Dwarven Ale:" & $DwarvenAle)
	ElseIf GetGoldenEggCount() > 0 Then
		Out("Golden Eggs:" & $GoldenEgg)
	ElseIf GetHardCiderCount() > 0 Then
		Out("Hard Cider:" & $HardCider)
	ElseIf GetHuntersAleCount() > 0 Then
		Out("Hunter's Ale:" & $HuntersAle)
	ElseIf GetFourLeafCloverCount() > 0 Then
		Out("Clovers:" & $Clovers)
	ElseIf GetEggnogCount() > 0 Then
		Out("Egg Nog:" & $Eggnog)
	ElseIf GetFrostyTonicCount() > 0 Then
		Out("Frosty Tonics:" & $FrostyTonic)
	ElseIf GetFruitcakeCount() > 0 Then
		Out("Fruitcakes:" & $Fruitcake)
	ElseIf GetBottleOfGrogCount() > 0 Then
		Out("Grog Arrr:" & $Grog)
	ElseIf GetHoneyCombCount() > 0 Then
		Out("Honeycombs:" & $HoneyCombs)
	ElseIf GetKrytanBrandyCount() > 0 Then
		Out("Krytan Brandy:" & $KrytanBrandy)
	ElseIf GetMischieviousTonicCount() > 0 Then
		Out("Mischievious Tonics:" & $MischieviousTonic)
	ElseIf GetPartyBeaconCount() > 0 Then
		Out("Jesus Beams:" & $PartyBeacon)
	ElseIf GetPumpkinPieCount() > 0 Then
		Out("Pumpkin Pies:" & $PumpkinPies)
	ElseIf GetRocketCount() > 0 Then
		Out("Bottle Rockets:" & $Rocket)
	ElseIf GetShamrockAleCount() > 0 Then
		Out("Shamrock Ales:" & $ShamrockAle)
	ElseIf GetSnowmanSummonerCount() > 0 Then
		Out("Snowman Summoners:" & $SnowmanSummoner)
	ElseIf GetSparklersCount() > 0 Then
		Out("Sparklers:" & $Sparklers)
	ElseIf GetSpikedEggnogCount() > 0 Then
		Out("Spiked Eggnog:" & $SpikedEggnog)
	ElseIf GetTransTonicCount() > 0 Then
		Out("Transmogrifier Tonics:" & $TransmogrifierTonic)
	ElseIf GetLunarTokenCount() > 0 Then
		Out("Token Count:" & $Tokencount)
	ElseIf GetTrickOrTreatCount() > 0 Then
		Out("ToTs:" & $TrickOrTreats)
	ElseIf GetVictoryTokenCount() > 0 Then
		Out("Victory Tokens:" & $VictoryToken)
	ElseIf GetWayfarerMarkCount() > 0 Then
		Out("Wayfarer Marks:" & $WayfarerMark)
	ElseIf GetYuletideTonicCount() > 0 Then
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

Func CountSlots()
	Local $bag
	Local $temp = 0
	$bag = GetBag(1)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(2)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(3)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(4)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	Return $temp
EndFunc ; Counts open slots in your Imventory

Func CountSlotsChest()
	Local $bag
	Local $temp = 0
	$bag = GetBag(8)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(9)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(10)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(11)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(12)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(13)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(14)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(15)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(16)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	Return $temp
EndFunc ; Counts open slots in the storage chest
#EndRegion Counting Things

#Region Storing Stuff
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
	For $I = 1 To $NUMOFSLOTS
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
	For $I = 1 To $NUMOFSLOTS
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
	For $I = 1 To $NUMOFSLOTS
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
	For $I = 1 To $NUMOFSLOTS
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
	For $I = 1 To $NUMOFSLOTS
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
	For $I = 1 To $NUMOFSLOTS
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
	For $I = 1 To $NUMOFSLOTS
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
	For $I = 1 To $NUMOFSLOTS
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
	For $I = 1 To $NUMOFSLOTS
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
	For $I = 1 To $NUMOFSLOTS
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
	For $I = 1 To $NUMOFSLOTS
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
	For $I = 1 To $NUMOFSLOTS
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
	For $I = 1 To $NUMOFSLOTS
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
#EndRegion Storing Stuff

#EndRegion Inventory

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

;~ Description: Print to console with timestamp
Func Out($TEXT)
	;If $BOTRUNNING Then FileWriteLine($FLOG, @CRLF & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " & $TEXT)
	Local $TEXTLEN = StringLen($TEXT)
	Local $CONSOLELEN = _GUICtrlEdit_GetTextLen($GLOGBOX)
	If $TEXTLEN + $CONSOLELEN > 30000 Then GUICtrlSetData($GLOGBOX, StringRight(_GUICtrlEdit_GetText($GLOGBOX), 30000 - $TEXTLEN - 1000))
	_GUICtrlEdit_AppendText($GLOGBOX, @CRLF & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " & $TEXT)
	_GUICtrlEdit_Scroll($GLOGBOX, 1)
EndFunc   ;==>OUT

;~ Description: guess what?
Func _exit()
	Exit
EndFunc

#Region Pcons
Func UseCupcake()
	If $useCupcake Then
		If (GetMapLoading() == 1) And (GetIsDead(-2) == False) Then
			If $pconsCupcake_slot[0] > 0 And $pconsCupcake_slot[1] > 0 Then
				If DllStructGetData(GetItemBySlot($pconsCupcake_slot[0], $pconsCupcake_slot[1]), "ModelID") == $ITEM_ID_CUPCAKES Then
					UseItemBySlot($pconsCupcake_slot[0], $pconsCupcake_slot[1])
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc
;~ This searches the bags for the specific pcon you wish to use.
Func pconsScanInventory()
	Local $bag
	Local $size
	Local $slot
	Local $item
	Local $ModelID
	$pconsCupcake_slot[0] = $pconsCupcake_slot[1] = 0
	For $bag = 1 To 4 Step 1
		If $bag == 1 Then $size = 20
		If $bag == 2 Then $size = 5
		If $bag == 3 Then $size = 10
		If $bag == 4 Then $size = 10
		For $slot = 1 To $size Step 1
			$item = GetItemBySlot($bag, $slot)
			$ModelID = DllStructGetData($item, "ModelID")
			Switch $ModelID
				Case 0
					ContinueLoop
				Case $ITEM_ID_Cupcakes
					$pconsCupcake_slot[0] = $bag
					$pconsCupcake_slot[1] = $slot
			EndSwitch
		Next
	Next
EndFunc   ;==>pconsScanInventory
;~ Uses the Item from UseCupcake()
Func UseItemBySlot($aBag, $aSlot)
	Local $item = GetItemBySlot($aBag, $aSlot)
	SENDPACKET(8, $UseItemHeader, DllStructGetData($item, "ID"));
EndFunc   ;==>UseItemBySlot

Func arrayContains($array, $item)
	For $i = 1 To $array[0]
		If $array[$i] == $item Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>arrayContains
#EndRegion Pcons

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