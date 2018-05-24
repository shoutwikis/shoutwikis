#include-once
#include <String.au3>
#include <GuiComboBox.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <GuiEdit.au3>

#Region Guild Hall Globals
;~ Prophecies
Global $BurningIsle_GH_ID = 52 ;Key=Burning Isle
Global $Druid_GH_ID = 70 ;Key=Druid's Isle
Global $FrozenIsle_GH_ID = 68 ;Key=Frozen Isle
Global $Hunter_GH_ID = 8 ;Key=Hunter's Isle
Global $IsleOFDead_GH_ID = 179 ;Key=Isle Of Dead
Global $NomadIsle_GH_ID = 69 ;Key=Nomand's Isle
Global $WarriorsIsle_GH_ID = 7 ;Key=Warrior's Isle
Global $WizardsIsle_GH_ID = 9 ;Key=Wizard's Isle
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


; == 自动工具通用常数 ==

Global $reZone = 0

; 成员表
Global $PartyArray

; 状态标志
Global $InitialPhase = 1
Global $TailgateMes = 0

; 人员类值 agent struct
Global $Mesmer = 0       ;幻术
Global $LabTank = 0      ;主队暗杀
; Global $DhuumTank = 0    ;挡多姆者

; 跟随范围, 启动加持距离, 拾起范围
Global $Range_Mesmer = 1235
Global $Range_LT = 3300      ;2750, 4000
; 范围内将追随施法
Global $Range_Cast = 1400
Global $Range_LTMes = 3300
Global $Range_Pickup = 1500

; 不速之客状态
Global $UWG = 0
Global $pfLT = 1

; 多姆技能状态
Global $FirstJudgment = 0
Global $JudgmentTimer
Global $NoEr_Stop = 0

; 人员名称
Global $nameMes = ""
Global $nameLT = ""
Global $nameDT = ""

; 地下进程标志
Global $Mindblades = FALSE ;dead also counts as true
Global $Souls = FALSE
Global $ReaperCount = 0
Global $ReaperPosition = 0
Global $MindbladeLiveCount = 0
Global $SkeleCount = 0
Global $KeeperCount = 0
Global $EndChest = 0
Global $SlowedCasting = 0 ;for dhuum and others
Global $InterruptPresent = 0
Global $NearestMindblade = False ;only live ones count as true
Global $NearestMindbladeDistance = 6000

; 提示范围
Global $Nightmare_Warn = 2400
Global $Mindblade_Warn = 1000 ; mindblade is probably loose and close
Global $Grasping_Warn = 2500 ; back aggro and
Global $Grasping_Warn2 = 500 ;grasping is adjacent
Global $Aatxe_Warn = 500 ;aatxe is nearby

; 猴子, grasping, mindblade aatxe 人员号数列
Global $DNIDArray[1]=[0]
Global $GDIDArray[1]=[0]
Global $MSIDArray[1]=[0]
Global $BAIDArray[1]=[0]

; 激战成像标记
Global $RenderingEnabled = True

; 自动工具开关标记
Global $BotRunning = False
Global $BotInitialized = False

; 记录被困时间/包载物量
Global $ChatStuckTimer = TimerInit()
Global $BAG_SLOTS[18] = [0, 20, 5, 10, 10, 20, 41, 12, 20, 20, 20, 20, 20, 20, 20, 20, 20, 9]

Global $RunCount=0
Global $FailCount
Global $SuccessCount=0
Global $BossKills

; 技能表
Global Const $SkillBarTemplate = "OQQUc4YRzKSWC0k4kqM9F5Fja7gA"
Global Const $SkillBarTemplateH = "OQikEqm8pgijKeYbivx07aMLmHD"

; 技能表中位置

Global Const $MOP = 1
Global Const $Dolyak= 2
Global Const $Endure = 3
Global Const $Protector = 4
Global Const $HundredB = 5
Global Const $Wary = 6
Global Const $Soldier = 7
Global Const $WW = 8

; 技能能量需求量
Global $skillCost[9]
$skillCost[$MOP] = 10
$skillCost[$Dolyak] = 5
$skillCost[$Endure] = 5
$skillCost[$Protector] = 5
$skillCost[$HundredB] = 5
$skillCost[$Wary] = 10
$skillCost[$Soldier] = 5
$skillCost[$WW] = 0

Global $skillCostH[9]
$skillCostH[1] = 10
$skillCostH[2] = 5
$skillCostH[3] = 10
$skillCostH[4] = 5
$skillCostH[5] = 5
$skillCostH[6] = 0
$skillCostH[7] = 0
$skillCostH[8] = 5

$GlobalToggleDrinkUsed = 0
; 各技能号
#cs
Global Const $SKILL_ID_SQ = 456
Global Const $SKILL_ID_SF = 826
Global Const $SKILL_ID_SD = 1031
Global Const $SKILL_ID_HOS = 1032
Global Const $SKILL_ID_DS = 2423
Global Const $SKILL_ID_SC = 455
Global Const $SKILL_ID_WD = 450
Global Const $SKILL_ID_DC = 952
Global Const $SKILL_ID_DIVERSION = 30
#ce
; 各种范围
Global Enum $DIFFICULTY_NORMAL, $DIFFICULTY_HARD
Global Enum $INSTANCETYPE_OUTPOST, $INSTANCETYPE_EXPLORABLE, $INSTANCETYPE_LOADING
Global Enum $RANGE_ADJACENT=156, $RANGE_NEARBY=240, $RANGE_AREA=312, $RANGE_EARSHOT=1000, $RANGE_SPELLCAST = 1085, $RANGE_SPIRIT = 2500, $RANGE_COMPASS = 5000
Global Enum $RANGE_ADJACENT_2=156^2, $RANGE_NEARBY_2=240^2, $RANGE_AREA_2=312^2, $RANGE_EARSHOT_2=1000^2, $RANGE_SPELLCAST_2=1085^2, $RANGE_SPIRIT_2=2500^2, $RANGE_COMPASS_2=5000^2
Global Enum $PROF_NONE, $PROF_WARRIOR, $PROF_RANGER, $PROF_MONK, $PROF_NECROMANCER, $PROF_MESMER, $PROF_ELEMENTALIST, $PROF_ASSASSIN, $PROF_RITUALIST, $PROF_PARAGON, $PROF_DERVISH

; 地图号
Global Const $MAP_ID_UW = 72
Global Const $MAP_ID_BJORA = 482
Global Const $MAP_ID_JAGA = 546
Global Const $MAP_ID_LONGEYE = 650
Global Const $Map_ID_SIFHALLA = 643
Global Const $MAP_ID_UMBRAL = 639
Global Const $MAP_ID_RATA = 640

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
Global Const $ITEM_ID_SALVAGE_KIT = 2992 ;同 2993
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


Global Const $My_Array[30]=[29, 30855, 2513, 5899, 27583,    28432, 22752, 22269, 28431, 35121,   30647, 36442, 36452, 36447, 30641, 31143, 36457, 36456, 32520, 30615,  _
							28436, 29422, 29419, 26501, 22190, 22191, 32526, 3746,22280,3256]
; ==== Constants ====
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
#cs
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
#ce
;~ Stupid Drops that I am not using, but in here in case you want these to add these to the CanPickUp and collect in your chest
Global $Map_Piece_Array[4] = [24629, 24630, 24631, 24632]
Global Const $ITEM_ID_MAP_PIECE_TL = 24629
Global Const $ITEM_ID_MAP_PIECE_TR = 24630
Global Const $ITEM_ID_MAP_PIECE_BL = 24631
Global Const $ITEM_ID_MAP_PIECE_BR = 24632
Global Const $ITEM_ID_GOLDEN_LANTERN = 4195

#cs
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

#Region Global MatsPic's And ModelID'Select
Global $PIC_MATS[24][2] = [["Fur Square", 941],["Bolt of Linen", 926],["Bolt of Damask", 927],["Bolt of Silk", 928],["Glob of Ectoplasm", 930],["Steel of Ignot", 949],["Deldrimor Steel Ingot", 950],["Monstrous Claws", 923],["Monstrous Eye", 931],["Monstrous Fangs", 932],["Rubies", 937],["Sapphires", 938],["Diamonds", 935],["Onyx Gemstones", 936],["Lumps of Charcoal", 922],["Obsidian Shard", 945],["Tempered Glass Vial", 939],["Leather Squares", 942],["Elonian Leather Square", 943],["Vial of Ink", 944],["Rolls of Parchment", 951],["Rolls of Vellum", 952],["Spiritwood Planks", 956]]
#EndRegion Global MatsPic's And ModelID'Select

Global $Array_Store_ModelIDs460[147] = [474, 476, 486, 522, 525, 811, 819, 822, 835, 610, 2994, 19185, 22751, 4629, 24630, 4631, 24632, 27033, 27035, 27044, 27046, 27047, 7052, 5123 _
		, 1796, 21797, 21798, 21799, 21800, 21801, 21802, 21803, 21804, 1805, 910, 2513, 5585, 6049, 6366, 6367, 6375, 15477, 19171, 22190, 24593, 28435, 30855, 31145, 31146, 35124, 36682 _
		, 6376 , 6368 , 6369 , 21809 , 21810, 21813, 29436, 29543, 36683, 4730, 15837, 21490, 22192, 30626, 30630, 30638, 30642, 30646, 30648, 31020, 31141, 31142, 31144, 1172, 15528 _
		, 15479, 19170, 21492, 21812, 22269, 22644, 22752, 28431, 28432, 28436, 1150, 35125, 36681, 3256, 3746, 5594, 5595, 5611, 5853, 5975, 5976, 21233, 22279, 22280, 6370, 21488 _
		, 21489, 22191, 35127, 26784, 28433, 18345, 21491, 28434, 35121, 921, 922, 923, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943 _
		, 944, 945, 946, 948, 949, 950, 951, 952, 953, 954, 955, 956, 6532, 6533]
#ce
