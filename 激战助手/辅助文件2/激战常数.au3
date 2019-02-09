#include-once

Global Enum $DIFFICULTY_NORMAL, $DIFFICULTY_HARD
Global Enum $INSTANCETYPE_OUTPOST, $INSTANCETYPE_EXPLORABLE, $INSTANCETYPE_LOADING
Global Enum $RANGE_ADJACENT=156, $RANGE_NEARBY=240, $RANGE_AREA=312, $RANGE_EARSHOT=1000, $RANGE_SPELLCAST = 1085, $RANGE_SPIRIT = 2500, $RANGE_COMPASS = 5000
Global Enum $PROF_NONE, $PROF_WARRIOR, $PROF_RANGER, $PROF_MONK, $PROF_NECROMANCER, $PROF_MESMER, $PROF_ELEMENTALIST, $PROF_ASSASSIN, $PROF_RITUALIST, $PROF_PARAGON, $PROF_DERVISH
Global $BAG_SLOTS[23] = [0, 20, 10, 15, 15, 20, 41, 12, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 9]

Global Const $SKILL_ID_RECALL = 925
Global Const $SKILL_ID_UA = 268
Global Const $SKILL_ID_ETHER_RENEWAL = 181
Global Const $SKILL_ID_BURNING_SPEED = 823
Global Const $SKILL_ID_SPIRIT_BOND = 1114
Global Const $SKILL_ID_BALTHAZAR_SPIRIT = 242
Global Const $SKILL_ID_LIFE_BOND = 241
Global Const $SKILL_ID_PROT_BOND = 263

Global Const $MODELID_SKELETON_OF_DHUUM = 2338 ; was 2332 pre april20 update
Global Const $MODELID_BOO = 7445; was 7439 pre april20 update

Global Const $MODELID_GHOST_IN_THE_BOX = 6368
Global Const $MODELID_GSTONE = 32557
Global Const $MODELID_LEGIONNAIRE_STONE = 37810

Global Const $MODELID_BONES = 921
Global Const $MODELID_IRON = 948
Global Const $MODELID_GRANITE = 955
Global Const $MODELID_DUST = 929
Global Const $MODELID_FIBERS = 934
Global Const $MODELID_FEATHERS = 933

#region QuestIDs and DialogIDs
Global Const $DIALOG_ID_UW_TELE_VALE = 138
Global Const $DIALOG_ID_UW_TELE_PLAINS = 139
Global Const $DIALOG_ID_UW_TELE_WASTES = 140
Global Const $DIALOG_ID_UW_TELE_LAB = 141
Global Const $DIALOG_ID_UW_TELE_MNT = 142
Global Const $DIALOG_ID_UW_TELE_PITS = 143
Global Const $DIALOG_ID_UW_TELE_POOLS = 144

Global Const $QUEST_ID_UW_CHAMBER = 101
Global Const $QUEST_ID_UW_WASTES = 102
Global Const $QUEST_ID_UW_UNWANTED_GUESTS = 103
Global Const $QUEST_ID_UW_MNT = 104
Global Const $QUEST_ID_UW_PITS = 105
Global Const $QUEST_ID_UW_PLAINS = 106
Global Const $QUEST_ID_UW_POOLS = 107
Global Const $QUEST_ID_UW_ESCORT = 108
Global Const $QUEST_ID_UW_RESTORE = 109
Global Const $QUEST_ID_UW_VALE = 110
Global Const $QUEST_ID_UW_NIGHTMAN_COMETH = 1129 ; TODO: test this

Global Const $DIALOG_ID_FOW_OBBY_ARMOR = 127

Global Const $QUEST_ID_FOW_DEFEND = 202
Global Const $QUEST_ID_FOW_ARMY_OF_DARKNESSES = 203
Global Const $QUEST_ID_FOW_WAILING_LORD = 204
Global Const $QUEST_ID_FOW_GRIFFONS = 205
Global Const $QUEST_ID_FOW_SLAVES = 206
Global Const $QUEST_ID_FOW_RESTORE = 207
Global Const $QUEST_ID_FOW_HUNT = 208
Global Const $QUEST_ID_FOW_FORGEMASTER = 209
Global Const $QUEST_ID_FOW_TOS = 211
Global Const $QUEST_ID_FOW_TOC = 212
Global Const $QUEST_ID_FOW_KHOBAY = 224

Global Const $QUEST_ID_DOA_DEATHBRINGER_COMPANY = 749
Global Const $QUEST_ID_DOA_RIFT_BETWEEN_US = 752
Global Const $QUEST_ID_DOA_TO_THE_RESCUE = 753

Global Const $QUEST_ID_DOA_CITY = 751

Global Const $QUEST_ID_DOA_BREACHING_STYGIAN_VEIL = 742
Global Const $QUEST_ID_DOA_BROOD_WARS = 755

Global Const $QUEST_ID_DOA_FOUNDRY_BREAKOUT = 743
Global Const $QUEST_ID_DOA_FOUNDRY_OF_FAILED_CREATIONS = 744

Func _AcceptDialog($QuestID)
	Return '0x008' & Hex($QuestID, 3) & '01'
EndFunc
Func _RewardDialog($QuestID)
	Return '0x008' & Hex($QuestID, 3) & '07'
EndFunc


Global $DIALOGS_NAME[44]
Global $DIALOGS_ID[44]
$DIALOGS_NAME[0] = 43 ; number of elements in array
$DIALOGS_ID[0] = 43
$DIALOGS_NAME[1] = "灾难-保护圣殿"
$DIALOGS_ID[1] = _AcceptDialog($QUEST_ID_FOW_DEFEND)
$DIALOGS_NAME[2] = "灾难-黑暗的军队"
$DIALOGS_ID[2] = _AcceptDialog($QUEST_ID_FOW_ARMY_OF_DARKNESSES)
$DIALOGS_NAME[3] = "灾难-悲鸣领主"
$DIALOGS_ID[3] = _AcceptDialog($QUEST_ID_FOW_WAILING_LORD)
$DIALOGS_NAME[4] = "灾难-狮鹫"
$DIALOGS_ID[4] = _AcceptDialog($QUEST_ID_FOW_GRIFFONS)
$DIALOGS_NAME[5] = "灾难-孟席斯"
$DIALOGS_ID[5] = _AcceptDialog($QUEST_ID_FOW_SLAVES)
$DIALOGS_NAME[6] = "灾难-恢复圣殿"
$DIALOGS_ID[6] = _AcceptDialog($QUEST_ID_FOW_RESTORE)
$DIALOGS_NAME[7] = "灾难-碎片狼"
$DIALOGS_ID[7] = _AcceptDialog($QUEST_ID_FOW_HUNT)
$DIALOGS_NAME[8] = "灾难-锻造大师"
$DIALOGS_ID[8] = _AcceptDialog($QUEST_ID_FOW_FORGEMASTER)
$DIALOGS_NAME[9] = "灾难-力量塔"
$DIALOGS_ID[9] = _AcceptDialog($QUEST_ID_FOW_TOS)
$DIALOGS_NAME[10] = "灾难-勇气之塔"
$DIALOGS_ID[10] = _AcceptDialog($QUEST_ID_FOW_TOC)
$DIALOGS_NAME[11] = "灾难-库贝"
$DIALOGS_ID[11] = _AcceptDialog($QUEST_ID_FOW_KHOBAY)
$DIALOGS_NAME[12] = "四门: 铸造厂"
$DIALOGS_ID[12] = _AcceptDialog($QUEST_ID_DOA_FOUNDRY_OF_FAILED_CREATIONS)
$DIALOGS_NAME[13] = "四门: 逃出铸造厂"
$DIALOGS_ID[13] = _AcceptDialog($QUEST_ID_DOA_FOUNDRY_BREAKOUT)
$DIALOGS_NAME[14] = "四门: 奖励-狂怒者"
$DIALOGS_ID[14] = _RewardDialog($QUEST_ID_DOA_FOUNDRY_BREAKOUT)
$DIALOGS_NAME[15] = "四门: 托加之城"
$DIALOGS_ID[15] = _AcceptDialog($QUEST_ID_DOA_CITY)
$DIALOGS_NAME[16] = "四门: 奖励-贾多斯"
$DIALOGS_ID[16] = _RewardDialog($QUEST_ID_DOA_CITY)
$DIALOGS_NAME[17] = "四门: 突破冥狱之幕"
$DIALOGS_ID[17] = _AcceptDialog($QUEST_ID_DOA_BREACHING_STYGIAN_VEIL)
$DIALOGS_NAME[18] = "四门: 一网打尽"
$DIALOGS_ID[18] = _AcceptDialog($QUEST_ID_DOA_BROOD_WARS)
$DIALOGS_NAME[19] = "四门: 奖励-母体+致命触须"
$DIALOGS_ID[19] = _RewardDialog($QUEST_ID_DOA_BROOD_WARS)
$DIALOGS_NAME[20] = "四门: 前往救援!"
$DIALOGS_ID[20] = _AcceptDialog($QUEST_ID_DOA_TO_THE_RESCUE)
$DIALOGS_NAME[21] = "四门: 异世界的裂缝"
$DIALOGS_ID[21] = _AcceptDialog($QUEST_ID_DOA_RIFT_BETWEEN_US)
$DIALOGS_NAME[22] = "四门: 死亡召唤大队"
$DIALOGS_ID[22] = _AcceptDialog($QUEST_ID_DOA_DEATHBRINGER_COMPANY)
$DIALOGS_NAME[23] = "四门: 奖励-巨大阴影"
$DIALOGS_ID[23] = _RewardDialog($QUEST_ID_DOA_DEATHBRINGER_COMPANY)
$DIALOGS_NAME[24] = "地下-接清场任务"
$DIALOGS_ID[24] = _AcceptDialog($QUEST_ID_UW_CHAMBER)
$DIALOGS_NAME[25] = "地下-接护送任务"
$DIALOGS_ID[25] = _AcceptDialog($QUEST_ID_UW_ESCORT)
$DIALOGS_NAME[26] = "地下-接不速任务"
$DIALOGS_ID[26] = _AcceptDialog($QUEST_ID_UW_UNWANTED_GUESTS)
$DIALOGS_NAME[27] = "地下-接恢复任务"
$DIALOGS_ID[27] = _AcceptDialog($QUEST_ID_UW_RESTORE)
$DIALOGS_NAME[28] = "地下-接墓穴任务"
$DIALOGS_ID[28] = _AcceptDialog($QUEST_ID_UW_PITS)
$DIALOGS_NAME[29] = "地下-接四马任务"
$DIALOGS_ID[29] = _AcceptDialog($QUEST_ID_UW_PLAINS)
$DIALOGS_NAME[30] = "地下-接遗忘谷任务"
$DIALOGS_ID[30] = _AcceptDialog($QUEST_ID_UW_VALE)
$DIALOGS_NAME[31] = "地下-接冰地任务"
$DIALOGS_ID[31] = _AcceptDialog($QUEST_ID_UW_WASTES)
$DIALOGS_NAME[32] = "地下-接女王任务"
$DIALOGS_ID[32] = _AcceptDialog($QUEST_ID_UW_POOLS)
$DIALOGS_NAME[33] = "地下-接龙山任务"
$DIALOGS_ID[33] = _AcceptDialog($QUEST_ID_UW_MNT)
$DIALOGS_NAME[34] = "地下-传孵化之池"
$DIALOGS_ID[34] = $DIALOG_ID_UW_TELE_POOLS
$DIALOGS_NAME[35] = "地下-传遗忘之谷"
$DIALOGS_ID[35] = $DIALOG_ID_UW_TELE_VALE
$DIALOGS_NAME[36] = "地下-传混浊平原"
$DIALOGS_ID[36] = $DIALOG_ID_UW_TELE_PLAINS
$DIALOGS_NAME[37] = "地下-传荒凉冰地"
$DIALOGS_ID[37] = $DIALOG_ID_UW_TELE_WASTES
$DIALOGS_NAME[38] = "地下-传迷宫"
$DIALOGS_ID[38] = $DIALOG_ID_UW_TELE_LAB
$DIALOGS_NAME[39] = "地下-传双头龙山"
$DIALOGS_ID[39] = $DIALOG_ID_UW_TELE_MNT
$DIALOGS_NAME[40] = "地下-传骷髅墓穴"
$DIALOGS_ID[40] = $DIALOG_ID_UW_TELE_PITS
$DIALOGS_NAME[41] = "地下-接多姆任务"
$DIALOGS_ID[41] = _AcceptDialog($QUEST_ID_UW_NIGHTMAN_COMETH)
$DIALOGS_NAME[42] = "灾难-收保殿奖励"
$DIALOGS_ID[42] = _RewardDialog($QUEST_ID_FOW_DEFEND)
$DIALOGS_NAME[43] = "灾难-收勇气塔奖励"
$DIALOGS_ID[43] = _RewardDialog($QUEST_ID_FOW_TOC)
#endregion Dialogs
#cs
Global $DIALOGS_NAME[44]
Global $DIALOGS_ID[44]
$DIALOGS_NAME[0] = 43 ; number of elements in array
$DIALOGS_ID[0] = 43
$DIALOGS_NAME[1] = "FoW-Defend"
$DIALOGS_ID[1] = _AcceptDialog($QUEST_ID_FOW_DEFEND)
$DIALOGS_NAME[2] = "FoW-Army of Darknesses"
$DIALOGS_ID[2] = _AcceptDialog($QUEST_ID_FOW_ARMY_OF_DARKNESSES)
$DIALOGS_NAME[3] = "FoW-Wailing Lord"
$DIALOGS_ID[3] = _AcceptDialog($QUEST_ID_FOW_WAILING_LORD)
$DIALOGS_NAME[4] = "FoW-Griffons"
$DIALOGS_ID[4] = _AcceptDialog($QUEST_ID_FOW_GRIFFONS)
$DIALOGS_NAME[5] = "FoW-Slaves"
$DIALOGS_ID[5] = _AcceptDialog($QUEST_ID_FOW_SLAVES)
$DIALOGS_NAME[6] = "FoW-Restore"
$DIALOGS_ID[6] = _AcceptDialog($QUEST_ID_FOW_RESTORE)
$DIALOGS_NAME[7] = "FoW-Hunt"
$DIALOGS_ID[7] = _AcceptDialog($QUEST_ID_FOW_HUNT)
$DIALOGS_NAME[8] = "FoW-Forgemaster"
$DIALOGS_ID[8] = _AcceptDialog($QUEST_ID_FOW_FORGEMASTER)
$DIALOGS_NAME[9] = "FoW-ToS"
$DIALOGS_ID[9] = _AcceptDialog($QUEST_ID_FOW_TOS)
$DIALOGS_NAME[10] = "FoW-ToC"
$DIALOGS_ID[10] = _AcceptDialog($QUEST_ID_FOW_TOC)
$DIALOGS_NAME[11] = "FoW-Khobay"
$DIALOGS_ID[11] = _AcceptDialog($QUEST_ID_FOW_KHOBAY)
$DIALOGS_NAME[12] = "DoA-F1-Foundry of Failed Creations"
$DIALOGS_ID[12] = _AcceptDialog($QUEST_ID_DOA_FOUNDRY_OF_FAILED_CREATIONS)
$DIALOGS_NAME[13] = "DoA-F2-Foundry Breakout"
$DIALOGS_ID[13] = _AcceptDialog($QUEST_ID_DOA_FOUNDRY_BREAKOUT)
$DIALOGS_NAME[14] = "DoA-F2-Reward (Fury spawn)"
$DIALOGS_ID[14] = _RewardDialog($QUEST_ID_DOA_FOUNDRY_BREAKOUT)
$DIALOGS_NAME[15] = "DoA-C1"
$DIALOGS_ID[15] = _AcceptDialog($QUEST_ID_DOA_CITY)
$DIALOGS_NAME[16] = "DoA-C1-Reward(Jadoth spawn)"
$DIALOGS_ID[16] = _RewardDialog($QUEST_ID_DOA_CITY)
$DIALOGS_NAME[17] = "DoA-V1-Breaching the Stygian Veil"
$DIALOGS_ID[17] = _AcceptDialog($QUEST_ID_DOA_BREACHING_STYGIAN_VEIL)
$DIALOGS_NAME[18] = "DoA-V2-Brood Wars"
$DIALOGS_ID[18] = _AcceptDialog($QUEST_ID_DOA_BROOD_WARS)
$DIALOGS_NAME[19] = "DoA-V2-Reward(Dreadspawn Maw spawn)"
$DIALOGS_ID[19] = _RewardDialog($QUEST_ID_DOA_BROOD_WARS)
$DIALOGS_NAME[20] = "DoA-G1-To the Rescue!"
$DIALOGS_ID[20] = _AcceptDialog($QUEST_ID_DOA_TO_THE_RESCUE)
$DIALOGS_NAME[21] = "DoA-G2-The Rifts Between Us"
$DIALOGS_ID[21] = _AcceptDialog($QUEST_ID_DOA_RIFT_BETWEEN_US)
$DIALOGS_NAME[22] = "DoA-G3-Deathbringer Company"
$DIALOGS_ID[22] = _AcceptDialog($QUEST_ID_DOA_DEATHBRINGER_COMPANY)
$DIALOGS_NAME[23] = "DoA-G3-Reward(Darknesses spawn)"
$DIALOGS_ID[23] = _RewardDialog($QUEST_ID_DOA_DEATHBRINGER_COMPANY)
$DIALOGS_NAME[24] = "UW-Clear the Chamber"
$DIALOGS_ID[24] = _AcceptDialog($QUEST_ID_UW_CHAMBER)
$DIALOGS_NAME[25] = "UW-Lab-Escort"
$DIALOGS_ID[25] = _AcceptDialog($QUEST_ID_UW_ESCORT)
$DIALOGS_NAME[26] = "UW-Lab-UWG"
$DIALOGS_ID[26] = _AcceptDialog($QUEST_ID_UW_UNWANTED_GUESTS)
$DIALOGS_NAME[27] = "UW-Lab-Restoring"
$DIALOGS_ID[27] = _AcceptDialog($QUEST_ID_UW_RESTORE)
$DIALOGS_NAME[28] = "UW-Pits-Imprisoned Spirits"
$DIALOGS_ID[28] = _AcceptDialog($QUEST_ID_UW_PITS)
$DIALOGS_NAME[29] = "UW-Plains-4H"
$DIALOGS_ID[29] = _AcceptDialog($QUEST_ID_UW_PLAINS)
$DIALOGS_NAME[30] = "UW-Vale-Wrathful Spirits"
$DIALOGS_ID[30] = _AcceptDialog($QUEST_ID_UW_VALE)
$DIALOGS_NAME[31] = "UW-Wastes-Servants of Grenth"
$DIALOGS_ID[31] = _AcceptDialog($QUEST_ID_UW_WASTES)
$DIALOGS_NAME[32] = "UW-Pools-Queen"
$DIALOGS_ID[32] = _AcceptDialog($QUEST_ID_UW_POOLS)
$DIALOGS_NAME[33] = "UW-Mnt-Demon Assassin"
$DIALOGS_ID[33] = _AcceptDialog($QUEST_ID_UW_MNT)
$DIALOGS_NAME[34] = "UW-Tele Pools"
$DIALOGS_ID[34] = $DIALOG_ID_UW_TELE_POOLS
$DIALOGS_NAME[35] = "UW-Tele Vale"
$DIALOGS_ID[35] = $DIALOG_ID_UW_TELE_VALE
$DIALOGS_NAME[36] = "UW-Tele Plains"
$DIALOGS_ID[36] = $DIALOG_ID_UW_TELE_PLAINS
$DIALOGS_NAME[37] = "UW-Tele Wastes"
$DIALOGS_ID[37] = $DIALOG_ID_UW_TELE_WASTES
$DIALOGS_NAME[38] = "UW-Tele Lab"
$DIALOGS_ID[38] = $DIALOG_ID_UW_TELE_LAB
$DIALOGS_NAME[39] = "UW-Tele Mnt"
$DIALOGS_ID[39] = $DIALOG_ID_UW_TELE_MNT
$DIALOGS_NAME[40] = "UW-Tele Pits"
$DIALOGS_ID[40] = $DIALOG_ID_UW_TELE_PITS
$DIALOGS_NAME[41] = "UW-King-Dhuum"
$DIALOGS_ID[41] = _AcceptDialog($QUEST_ID_UW_NIGHTMAN_COMETH)
$DIALOGS_NAME[42] = "FoW-Defend-Reward"
$DIALOGS_ID[42] = _RewardDialog($QUEST_ID_FOW_DEFEND)
$DIALOGS_NAME[43] = "FoW-ToC-Reward"
$DIALOGS_ID[43] = _RewardDialog($QUEST_ID_FOW_TOC)
#endregion Dialogs
#ce

#region ITEM_IDs
Global Const $ITEM_ID_GROG = 30855
Global Const $ITEM_ID_RRC = 31153
Global Const $ITEM_ID_BRC = 31151
Global Const $ITEM_ID_GRC = 31152
Global Const $ITEM_ID_PIES = 28436
Global Const $ITEM_ID_CUPCAKES = 22269
Global Const $ITEM_ID_APPLES = 28431
Global Const $ITEM_ID_CORNS = 28432
Global Const $ITEM_ID_EGGS = 22752
Global Const $ITEM_ID_KABOBS = 17060
Global Const $ITEM_ID_WARSUPPLIES = 35121

Global Const $ITEM_ID_LUNARS_PIG = 29424;;
Global Const $ITEM_ID_LUNARS_RAT = 29425
Global Const $ITEM_ID_LUNARS_OX = 29426
Global Const $ITEM_ID_LUNARS_TIGER = 29427
Global Const $ITEM_ID_LUNARS_RABBIT = 29428
Global Const $ITEM_ID_LUNARS_DRAGON = 29429
Global Const $ITEM_ID_LUNARS_SNAKE = 29430
Global Const $ITEM_ID_LUNARS_HORSE = 29431
Global Const $ITEM_ID_LUNARS_SHEEP = 29432
Global Const $ITEM_ID_LUNARS_MONKEY = 29433
Global Const $ITEM_ID_LUNARS_ROOSTER = 29434;;
Global Const $ITEM_ID_LUNARS_DOG = 29435;;
Global Const $ITEM_ID_LUNARS_PIG_2 = 29436;;不是真的物品，是以前推测的

Global Const $ITEM_ID_CONS_ESSENCE = 24859
Global Const $ITEM_ID_CONS_ARMOR = 24860
Global Const $ITEM_ID_CONS_GRAIL = 24861
Global Const $ITEM_ID_RES_SCROLLS = 26501
Global Const $ITEM_ID_SKALEFIN_SOUP = 17061
Global Const $ITEM_ID_PAHNAI_SALAD = 17062
Global Const $ITEM_ID_MOBSTOPPER = 32558
Global Const $ITEM_ID_POWERSTONE = 24862
Global Const $ITEM_ID_CREME_BRULEE = 15528
Global Const $ITEM_ID_FRUITCAKE = 21492
Global Const $ITEM_ID_SUGARY_BLUE_DRINK = 21812
Global Const $ITEM_ID_RED_BEAN_CAKE = 15479
Global Const $ITEM_ID_JAR_OF_HONEY = 31150
Global Const $ITEM_ID_CHOCOLATE_BUNNY = 22644
#endregion
#region Alcohol
#cs
Alcohol:
ModelID		Name:				Duration:	Notes:
idk		Bottle of Rice Wine		1
6375	Eggnog					1
5585	Dwarven Ale				1
28435	Hard Apple Cider		1
910		Hunter's Ale			1
idk		Juniberry Gin			1			Noone will ever use this
22190	Shamrock Ale			1
idk		Vabbian Wine			1			Noone will ever use this (only for trade or drop from a boss)
6367	Vial of Absinthe		1
6049	Witch's Brew			1
idk 	Zehtuka's Jug			1			Noone will ever use this (found on the ground in the desolation)
24593	Aged Dwarven Ale		5
31145	Aged Hunter's Ale		5
30855	Bottle of Grog			5
2513	Flask of Firewater		5
31146	Keg of Aged Hunter's Ale5
35124	Krytan Brandy			5
6366	Spiked Eggnog			5
idk		Battle Isle Iced Tea	5			Noone will ever use this (50 points for 5min)
#ce

Global $ITEM_ID_ALCOHOL_1[9]
$ITEM_ID_ALCOHOL_1[0] =   8
$ITEM_ID_ALCOHOL_1[1] = 6375	; eggnog
$ITEM_ID_ALCOHOL_1[2] = 5585	; dwarven ale
$ITEM_ID_ALCOHOL_1[3] = 910		; hunter's ale
$ITEM_ID_ALCOHOL_1[4] = 6367	; absinthe
$ITEM_ID_ALCOHOL_1[5] = 6049	; witch's brew
$ITEM_ID_ALCOHOL_1[6] = 15477	; ricewine
$ITEM_ID_ALCOHOL_1[7] = 22190	; shamrock ale
$ITEM_ID_ALCOHOL_1[8] = 28435	; cider

Global $ITEM_ID_ALCOHOL_5[8]
$ITEM_ID_ALCOHOL_5[0] =   7
$ITEM_ID_ALCOHOL_5[1] = 30855	; grog
$ITEM_ID_ALCOHOL_5[2] = 6366	; spiked eggnog
$ITEM_ID_ALCOHOL_5[3] = 24593	; aged dwarven ale
$ITEM_ID_ALCOHOL_5[4] = 31145	; aged hunger's ale
$ITEM_ID_ALCOHOL_5[5] = 31146	; keg
$ITEM_ID_ALCOHOL_5[6] = 2513	; flask of firewater
$ITEM_ID_ALCOHOL_5[7] = 35124	; krytan brandy
#endregion
#region Effects
Global Const $EFFECT_LIGHTBRINGER = 1813
Global Const $EFFECT_HARDMODE = 1912
Global Const $EFFECT_CORN = 2604
Global Const $EFFECT_APPLE = 2605
Global Const $EFFECT_REDROCK = 2973
Global Const $EFFECT_BLUEROCK = 2971
Global Const $EFFECT_GREENROCK = 2972
Global Const $EFFECT_WARSUPPLIES = 3174
Global Const $EFFECT_KABOBS = 1680
Global Const $EFFECT_CUPCAKE = 1945
Global Const $EFFECT_EGG = 1934
Global Const $EFFECT_GROG = 2923
Global Const $EFFECT_PIE = 2649
Global Const $EFFECT_LUNARS = 1926
Global Const $EFFECT_CONS_ESSENCE = 2522
Global Const $EFFECT_CONS_ARMOR = 2520
Global Const $EFFECT_CONS_GRAIL = 2521
Global Const $EFFECT_SKALE_VIGOR = 1681
Global Const $EFFECT_PAHNAI_SALAD = 1682
Global Const $EFFECT_WEAKENED_BY_DHUUM = 3077

Global Const $EFFECT_CREME_BRULEE = 1612
Global Const $EFFECT_BLUE_DRINK = 1916
Global Const $EFFECT_CHOCOLATE_BUNNY = 1933
Global Const $EFFECT_RED_BEAN_CAKE_FRUITCAKE = 1323
#endregion Effects
#region Attributes
Global Enum _
	$ATTR_FAST_CASTING, $ATTR_ILLUSION_MAGIC, $ATTR_DOMINATION_MAGIC, $ATTR_INSPIRATION_MAGIC, _
	$ATTR_BLOOD_MAGIC, $ATTR_DEATH_MAGIC, $ATTR_SOUL_REAPING, $ATTR_CURSES, _
	$ATTR_AIR_MAGIC, $ATTR_EARTH_MAGIC, $ATTR_FIRE_MAGIC, $ATTR_WATER_MAGIC, $ATTR_ENERGY_STORAGE, _
	$ATTR_HEALING_PRAYERS, $ATTR_SMITING_PRAYERS, $ATTR_PROTECTION_PRAYERS, $ATTR_DIVINE_FAVOR, _
	$ATTR_STRENGTH, $ATTR_AXE_MASTERY, $ATTR_HAMMER_MASTERY, $ATTR_SWORDSMANSHIP, $ATTR_TACTICS, _
	$ATTR_BEAST_MASTERY, $ATTR_EXPERTISE, $ATTR_WILDERNESS_SURVIVAL, $ATTR_MARKSMANSHIP, _
	$ATTR_DAGGER_MASTERY = 29, $ATTR_DEADLY_ARTS, $ATTR_SHADOW_ARTS, _
	$ATTR_COMMUNING, $ATTR_RESTORATION_MAGIC, $ATTR_CHANNELING_MAGIC, _
	$ATTR_CRITICAL_STRIKES, _
	$ATTR_SPAWNING_POWER, _
	$ATTR_SPEAR_MASTERY, $ATTR_COMMAND, $ATTR_MOTIVATION, $ATTR_LEADERSHIP, _
	$ATTR_SCYTHE_MASTERY, $ATTR_WIND_PRAYERS, $ATTR_EARTH_PRAYERS, $ATTR_MYSTICISM, _
	$ATTR_NONE = 0xFF

Global $attr_name[45]
$attr_name[$attr_fast_casting] = "快速施法"
$attr_name[$attr_illusion_magic] = "幻术魔法"
$attr_name[$attr_domination_magic] = "支配魔法"
$attr_name[$attr_inspiration_magic] = "灵感魔法"
$attr_name[$attr_blood_magic] = "血魔法"
$attr_name[$attr_death_magic] = "死亡魔法"
$attr_name[$attr_soul_reaping] = "灵魂吸取"
$attr_name[$attr_curses] = "诅咒"
$attr_name[$attr_air_magic] = "风系魔法"
$attr_name[$attr_earth_magic] = "地系魔法"
$attr_name[$attr_fire_magic] = "火系魔法"
$attr_name[$attr_water_magic] = "水系魔法"
$attr_name[$attr_energy_storage] = "能量储存"
$attr_name[$attr_healing_prayers] = "治疗"
$attr_name[$attr_smiting_prayers] = "惩戒"
$attr_name[$attr_protection_prayers] = "防护"
$attr_name[$attr_divine_favor] = "神恩"
$attr_name[$attr_strength] = "力量"
$attr_name[$attr_axe_mastery] = "斧术"
$attr_name[$attr_hammer_mastery] = "锤术"
$attr_name[$attr_swordsmanship] = "剑术"
$attr_name[$attr_tactics] = "战术"
$attr_name[$attr_beast_mastery] = "野兽术"
$attr_name[$attr_expertise] = "专精"
$attr_name[$attr_wilderness_survival] = "求生"
$attr_name[$attr_marksmanship] = "弓术"
$attr_name[$attr_dagger_mastery] = "匕首术"
$attr_name[$attr_deadly_arts] = "暗杀技巧"
$attr_name[$attr_shadow_arts] = "暗影技巧"
$attr_name[$attr_communing] = "神谕"
$attr_name[$attr_restoration_magic] = "复原"
$attr_name[$attr_channeling_magic] = "导引"
$attr_name[$attr_critical_strikes] = "致命攻击"
$attr_name[$attr_spawning_power] = "召唤"
$attr_name[$attr_spear_mastery] = "矛术"
$attr_name[$attr_command] = "命令"
$attr_name[$attr_motivation] = "激励"
$attr_name[$attr_leadership] = "领导"
$attr_name[$attr_scythe_mastery] = "镰刀术"
$attr_name[$attr_wind_prayers] = "风系祷告"
$attr_name[$attr_earth_prayers] = "地系祷告"
$attr_name[$attr_mysticism] = "秘法"
#cs
Global $ATTR_NAME[45]
$ATTR_NAME[$ATTR_FAST_CASTING] = "Fast Casting"
$ATTR_NAME[$ATTR_ILLUSION_MAGIC] = "Illusion Magic"
$ATTR_NAME[$ATTR_DOMINATION_MAGIC] = "Domination Magic"
$ATTR_NAME[$ATTR_INSPIRATION_MAGIC] = "Inspiration Magic"
$ATTR_NAME[$ATTR_BLOOD_MAGIC] = "Blood Magic"
$ATTR_NAME[$ATTR_DEATH_MAGIC] = "Death Magic"
$ATTR_NAME[$ATTR_SOUL_REAPING] = "Soul Reaping"
$ATTR_NAME[$ATTR_CURSES] = "Curses"
$ATTR_NAME[$ATTR_AIR_MAGIC] = "Air Magic"
$ATTR_NAME[$ATTR_EARTH_MAGIC] = "Earth Magic"
$ATTR_NAME[$ATTR_FIRE_MAGIC] = "Fire Magic"
$ATTR_NAME[$ATTR_WATER_MAGIC] = "Water Magic"
$ATTR_NAME[$ATTR_ENERGY_STORAGE] = "Energy Storage"
$ATTR_NAME[$ATTR_HEALING_PRAYERS] = "Healing Prayers"
$ATTR_NAME[$ATTR_SMITING_PRAYERS] = "Smiting Prayers"
$ATTR_NAME[$ATTR_PROTECTION_PRAYERS] = "Protection Prayers"
$ATTR_NAME[$ATTR_DIVINE_FAVOR] = "Divine Favor"
$ATTR_NAME[$ATTR_STRENGTH] = "Strength"
$ATTR_NAME[$ATTR_AXE_MASTERY] = "Axe Mastery"
$ATTR_NAME[$ATTR_HAMMER_MASTERY] = "Hammer Mastery"
$ATTR_NAME[$ATTR_SWORDSMANSHIP] = "Swordsmanship"
$ATTR_NAME[$ATTR_TACTICS] = "Tactics"
$ATTR_NAME[$ATTR_BEAST_MASTERY] = "Beast Mastery"
$ATTR_NAME[$ATTR_EXPERTISE] = "Expertise"
$ATTR_NAME[$ATTR_WILDERNESS_SURVIVAL] = "Wilderness Survival"
$ATTR_NAME[$ATTR_MARKSMANSHIP] = "Marksmanship"
$ATTR_NAME[$ATTR_DAGGER_MASTERY] = "Dagger Mastery"
$ATTR_NAME[$ATTR_DEADLY_ARTS] = "Deadly Arts"
$ATTR_NAME[$ATTR_SHADOW_ARTS] = "Shadow Arts"
$ATTR_NAME[$ATTR_COMMUNING] = "Communing"
$ATTR_NAME[$ATTR_RESTORATION_MAGIC] = "Restoration Magic"
$ATTR_NAME[$ATTR_CHANNELING_MAGIC] = "Channeling Magic"
$ATTR_NAME[$ATTR_CRITICAL_STRIKES] = "Critical Strikes"
$ATTR_NAME[$ATTR_SPAWNING_POWER] = "Spawning Power"
$ATTR_NAME[$ATTR_SPEAR_MASTERY] = "Spear Mastery"
$ATTR_NAME[$ATTR_COMMAND] = "Command"
$ATTR_NAME[$ATTR_MOTIVATION] = "Motivation"
$ATTR_NAME[$ATTR_LEADERSHIP] = "Leadership"
$ATTR_NAME[$ATTR_SCYTHE_MASTERY] = "Scythe Mastery"
$ATTR_NAME[$ATTR_WIND_PRAYERS] = "Wind Prayers"
$ATTR_NAME[$ATTR_EARTH_PRAYERS] = "Earth Prayers"
$ATTR_NAME[$ATTR_MYSTICISM] = "Mysticism"
#endregion
#ce
#region ModStruct_headpiece
Global Const $MODSTRUCT_HEADPIECE_DOMINATION_MAGIC = "3F"
Global Const $MODSTRUCT_HEADPIECE_FAST_CASTING = "40"
Global Const $MODSTRUCT_HEADPIECE_ILLUSION_MAGIC = "41"
Global Const $MODSTRUCT_HEADPIECE_INSPIRATION_MAGIC = "42"

Global Const $MODSTRUCT_HEADPIECE_BLOOD_MAGIC = "43"
Global Const $MODSTRUCT_HEADPIECE_CURSES = "44"
Global Const $MODSTRUCT_HEADPIECE_DEATH_MAGIC = "45"
Global Const $MODSTRUCT_HEADPIECE_SOUL_REAPING = "46"

Global Const $MODSTRUCT_HEADPIECE_AIR_MAGIC = "47"
Global Const $MODSTRUCT_HEADPIECE_EARTH_MAGIC = "48"
Global Const $MODSTRUCT_HEADPIECE_ENERGY_STORAGE = "49"
Global Const $MODSTRUCT_HEADPIECE_FIRE_MAGIC = "4A"
Global Const $MODSTRUCT_HEADPIECE_WATER_MAGIC = "4B"

Global Const $MODSTRUCT_HEADPIECE_DIVINE_FAVOR = "4C"
Global Const $MODSTRUCT_HEADPIECE_HEALING_PRAYERS = "4D"
Global Const $MODSTRUCT_HEADPIECE_PROTECTION_PRAYERS = "4E"
Global Const $MODSTRUCT_HEADPIECE_SMITING_PRAYERS = "4F"

Global Const $MODSTRUCT_HEADPIECE_AXE_MASTERY = "50"
Global Const $MODSTRUCT_HEADPIECE_HAMMER_MASTERY = "51"
Global Const $MODSTRUCT_HEADPIECE_SWORDSMANSHIP = "53"
Global Const $MODSTRUCT_HEADPIECE_STRENGTH = "54"
Global Const $MODSTRUCT_HEADPIECE_TACTICS = "55"

Global Const $MODSTRUCT_HEADPIECE_BEAST_MASTERY = "56"
Global Const $MODSTRUCT_HEADPIECE_MARKSMANSHIP = "57"
Global Const $MODSTRUCT_HEADPIECE_EXPERTISE = "58"
Global Const $MODSTRUCT_HEADPIECE_WILDERNESS_SURVIVAL = "59"
#endregion ModStruct_headpiece
#region Map_IDs
Global Const $MAP_ID_TOA = 138
Global Const $MAP_ID_KAMADAN = 449
Global Const $MAP_ID_DOA = 474
Global Const $MAP_ID_EMBARK = 857
Global Const $MAP_ID_VLOX = 624
Global Const $MAP_ID_URGOZ = 266
Global Const $MAP_ID_DEEP = 307
Global Const $MAP_ID_EOTN = 642

Global $MAP_ID[858]
$MAP_ID[0] = 857
$map_id[4] = "公会厅 - 战士之岛"
	$map_id[5] = "公会厅 - 猎人之岛"
	$map_id[6] = "公会厅 - 巫师之岛"
	$map_id[10] = "血石沼泽"
	$map_id[11] = "荒原"
	$map_id[12] = "欧若拉林地"
	$map_id[14] = "科瑞塔关所"
	$map_id[15] = "达雷西海滨"
	$map_id[16] = "神圣海岸"
	$map_id[19] = "神圣沙滩"
	$map_id[20] = "熔炉"
	$map_id[21] = "寒霜之门"
	$map_id[22] = "悲伤冰谷"
	$map_id[23] = "雷云要塞"
	$map_id[24] = "莫拉登矿山"
	$map_id[25] = "柏里斯通道"
	$map_id[28] = "北方长城"
	$map_id[29] = "瑞尼克要塞"
	$map_id[30] = "蘇米亚废墟"
	$map_id[32] = "若拉尼学院"
	$map_id[35] = "残火影地"
	$map_id[36] = "葛兰迪法院"
	$map_id[38] = "占卜之石"
	$map_id[39] = "萨德拉克疗养院"
	$map_id[40] = "派肯广场"
	$map_id[49] = "丹拉维圣地"
	$map_id[51] = "山吉之街"
	$map_id[52] = "公会厅 - 燃烧之岛"
	$map_id[55] = "狮门"
	$map_id[57] = "卑而根温泉"
	$map_id[73] = "河畔地带"
	$map_id[77] = "凤荷议院"
	$map_id[81] = "阿斯克隆城"
	$map_id[82] = "先王之墓"
	$map_id[85] = "竞技场/阿斯克隆"
	$map_id[109] = "安奴绿洲"
	$map_id[116] = "绝望沙丘"
	$map_id[117] = "干枯河流"
	$map_id[118] = "伊洛那流域"
	$map_id[120] = "龙穴"
	$map_id[122] = "火环群岛"
	$map_id[123] = "地狱隘口"
	$map_id[124] = "地狱悬崖"
	$map_id[129] = "路嘉帝斯温室"
	$map_id[130] = "维思柏兵营"
	$map_id[131] = "宁静神殿"
	$map_id[132] = "冰牙洞穴"
	$map_id[133] = "比肯"
	$map_id[134] = "犛牛村"
	$map_id[135] = "边境关所"
	$map_id[136] = "甲虫镇"
	$map_id[137] = "渔人避风港"
	$map_id[138] = "世纪"
	$map_id[139] = "凡特里避难所"
	$map_id[140] = "德鲁伊高地"
	$map_id[141] = "梅古玛业林"
	$map_id[142] = "怨言瀑布"
	$map_id[148] = "阿斯克隆城"
	$map_id[152] = "英雄之痕"
	$map_id[153] = "探索者通道"
	$map_id[154] = "命运峡谷"
	$map_id[155] = "蓝口营地"
	$map_id[156] = "花岗岩堡垒"
	$map_id[157] = "马汉"
	$map_id[158] = "雪橇港"
	$map_id[159] = "铜锤矿坑"
	$map_id[163] = "毁灭前: 巴拉丁领地"
	$map_id[164] = "毁灭前: 灰色浅滩"
	$map_id[165] = "毁灭前: 佛伊伯市集"
	$map_id[166] = "毁灭前: 瑞尼克要塞"
	$map_id[176] = "公会厅 - 冰冻之岛"
	$map_id[177] = "公会厅 - 流浪之岛"
	$map_id[178] = "公会厅 - 德鲁伊之岛"
	$map_id[179] = "公会厅 - 死亡之岛"
	$map_id[181] = "竞技场/Shiverpeak"
	$map_id[188] = "随机竞技场"
	$map_id[189] = "竞技场/Team"
	$map_id[193] = "卡瓦隆"
	$map_id[194] = "凯宁中心"
	$map_id[204] = "蓝 - 沉睡之水 - 蓝"
	$map_id[206] = "戴而狄摩兵营"
	$map_id[213] = "祯台郡"
	$map_id[214] = "周大臣庄园"
	$map_id[216] = "纳普区"
	$map_id[217] = "谭纳凯神殿"
	$map_id[218] = "亭石"
	$map_id[219] = "风神海床"
	$map_id[220] = "孙江行政区"
	$map_id[222] = "永恒之林"
	$map_id[224] = "盖拉孵化所"
	$map_id[225] = "莱蘇皇宫"
	$map_id[226] = "帝国圣所"
	$map_id[227] = "红 - 沉睡之水 红"
	$map_id[230] = "亚马兹盆地"
	$map_id[234] = "奥里欧斯矿坑"
	$map_id[242] = "星岬寺"
	$map_id[243] = "竞技场/星岬寺"
	$map_id[248] = "巴萨则圣殿"
	$map_id[249] = "蘇梅村"
	$map_id[250] = "青函港"
	$map_id[251] = "岚穆蘇花园"
	$map_id[253] = "Dwayna Vs Grenth outpost"
	$map_id[266] = "尔果"
	$map_id[272] = "奥楚蘭废墟"
	$map_id[273] = "佐席洛斯水道"
	$map_id[274] = "龙喉"
	$map_id[275] = "公会厅 - 泣石之岛"
	$map_id[276] = "公会厅 - 翡翠之岛"
	$map_id[277] = "丰收神殿"
	$map_id[278] = "断崖谷"
	$map_id[279] = "利拜亚森矿场"
	$map_id[281] = "战承挑战"
	$map_id[282] = "战承精英"
	$map_id[283] = "麻都堡垒"
	$map_id[284] = "辛库走廊"
	$map_id[286] = "巴而学院"
	$map_id[287] = "杜汉姆卷藏室"
	$map_id[288] = "拜巴蘇区域"
	$map_id[289] = "航海者休息处"
	$map_id[291] = "薇茹广场 本地"
	$map_id[292] = "薇茹广场 外地"
	$map_id[293] = "红 - 杨木要塞 - 红"
	$map_id[294] = "蓝 - 杨木要塞 - 蓝"
	$map_id[295] = "红 - 翡翠矿场 - 红"
	$map_id[296] = "蓝 - 翡翠矿场 - 蓝"
	$map_id[303] = "市集"
	$map_id[307] = "深渊"
	$map_id[328] = "红 - 盐滩 - 红"
	$map_id[329] = "蓝 - 盐滩 - 蓝"
	$map_id[330] = "Heroes Ascent outpost"
	$map_id[331] = "红 - 葛伦斯领域 - 红"
	$map_id[332] = "蓝 - 葛伦斯领域 - 蓝"
	$map_id[333] = "红 - 先人圣地 - 红"
	$map_id[334] = "蓝 - 先人圣地 - 蓝"
	$map_id[335] = "红 - Etnaran Keys - 红"
	$map_id[336] = "蓝 - Etnaran Keys - 蓝"
	$map_id[337] = "红 - Kaanai Canyon - 红"
	$map_id[338] = "蓝 - Kaanai Canyon - 蓝"
	$map_id[348] = "谭格塢树林"
	$map_id[349] = "圣者安捷卡的祭坛"
	$map_id[350] = "而雷登平地"
	$map_id[359] = "公会厅 - 帝国之岛"
	$map_id[360] = "公会厅 - 冥想之岛"
	$map_id[368] = "竞技场/龙"
	$map_id[376] = "何加努营地"
	$map_id[378] = "薇恩平台"
	$map_id[381] = "犹朗避难所"
	$map_id[387] = "日戟避难所"
	$map_id[388] = "蓝 - 杨木大门 - 蓝"
	$map_id[389] = "红 - 杨木大门 - 红"
	$map_id[390] = "蓝 - 翡翠浅滩 - 蓝"
	$map_id[391] = "红 - 翡翠浅滩 - 红"
	$map_id[393] = "隐密教堂"
	$map_id[396] = "米哈努小镇"
	$map_id[398] = "玄武岩石穴"
	$map_id[403] = "霍奴而丘陵"
	$map_id[407] = "雅诺而市集"
	$map_id[414] = "库丹西市集广场"
	$map_id[421] = "凡特墓地"
	$map_id[424] = "科登诺路口"
	$map_id[425] = "里欧恩难民营"
	$map_id[426] = "波甘驿站"
	$map_id[427] = "摩多克裂缝"
	$map_id[428] = "提亚克林地"
	$map_id[431] = "日戟大会堂"
	$map_id[433] = "蕯岗诺堡"
	$map_id[434] = "达沙走廊"
	$map_id[435] = "希贝克大宫廷"
	$map_id[438] = "白骨宫殿"
	$map_id[440] = "苦痛之地隘口"
	$map_id[442] = "被遗忘者的巢穴"
	$map_id[449] = "卡玛丹"
	$map_id[450] = "苦痛之门"
	$map_id[457] = "别克诺港"
	$map_id[467] = "Rollerbeetle Racing outpost"
	$map_id[469] = "恐惧之门"
	$map_id[473] = "奥秘之门"
	$map_id[474] = "悲难之门"
	$map_id[476] = "征纳群落"
	$map_id[477] = "纳度湾"
	$map_id[478] = "荒芜之地入口"
	$map_id[479] = "勇士曙光"
	$map_id[480] = "莫拉废墟"
	$map_id[489] = "克拓怒-哈姆雷特"
	$map_id[491] = "卓坎诺挖掘点"
	$map_id[492] = "黑潮之穴"
	$map_id[493] = "领事馆码头"
	$map_id[494] = "惩罚之门"
	$map_id[495] = "疯狂之门"
	$map_id[496] = "亚霸顿之门"
	$map_id[497] = "竞技场/日戟"
	$map_id[502] = "亚斯特拉利姆"
	$map_id[529] = "公会厅 - 迷样之岛"
	$map_id[530] = "公会厅 - 巨虫之岛"
	$map_id[537] = "公会厅 - 坠落之岛"
	$map_id[538] = "公会厅 - 神隐之岛"
	$map_id[544] = "夏贝克村庄"
	$map_id[545] = "萨拉加遗址"
	$map_id[549] = "Hero Battles outpost"
	$map_id[554] = "达卡港"
	$map_id[555] = "The Shadow Nexus outpost"
	$map_id[559] = "Gate of the Nightfallen Lands"
	$map_id[624] = "瀑布"
	$map_id[638] = "盖得"
	$map_id[639] = "阴影石穴"
	$map_id[640] = "顶点"
	$map_id[641] = "灰暗避难所"
	$map_id[642] = "极地之眼"
	$map_id[643] = "袭哈拉"
	$map_id[644] = "甘拿"
	$map_id[645] = "欧拉夫之地"
	$map_id[648] = "末日传说神殿"
	$map_id[650] = "长眼"
	$map_id[652] = "中央转送室"
	$map_id[675] = "北极驻地"
	$map_id[721] = "Costume Brawl outpost"
	$map_id[795] = "战承动物园"
	$map_id[796] = "竞技场/Codex"
	$map_id[808] = "狮城 - 万圣节"
	$map_id[809] = "狮城 - 冬日"
	$map_id[810] = "狮城 - 二章新年"
	$map_id[811] = "阿城 - 冬日"
	$map_id[812] = "熔炉 - 万圣节"
	$map_id[813] = "熔炉 - 冬日"
	$map_id[814] = "先王之墓 - 万圣节"
	$map_id[815] = "星岬寺 - 龙节"
	$map_id[816] = "星岬寺 - 二章新年"
	$map_id[818] = "卡玛丹 - 万圣节"
	$map_id[819] = "卡玛丹 - 冬日"
	$map_id[820] = "卡玛丹 - 二章新年"
	$map_id[821] = "极地之眼 - 冬日"
	$map_id[857] = "登陆滩"
	#endregion Map_IDs
#cs
Global $MAP_ID[858]
$MAP_ID[0] = 857
$MAP_ID[4] = "Guild Hall - Warrior's Isle"
$MAP_ID[5] = "Guild Hall - Hunter's Isle"
$MAP_ID[6] = "Guild Hall - Wizard's Isle"
$MAP_ID[10] = "Bloodstone Fen outpost"
$MAP_ID[11] = "The Wilds outpost"
$MAP_ID[12] = "Aurora Glade outpost"
$MAP_ID[14] = "Gates of Kryta outpost"
$MAP_ID[15] = "D'Alessio Seaboard outpost"
$MAP_ID[16] = "Divinity Coast outpost"
$MAP_ID[19] = "Sanctum Cay outpost"
$MAP_ID[20] = "Droknar's Forge"
$MAP_ID[21] = "The Frost Gate outpost"
$MAP_ID[22] = "Ice Caves of Sorrow outpost"
$MAP_ID[23] = "Thunderhead Keep outpost"
$MAP_ID[24] = "Iron Mines of Moladune outpost"
$MAP_ID[25] = "Borlis Pass outpost"
$MAP_ID[28] = "The Great Northern Wall outpost"
$MAP_ID[29] = "Fort Ranik outpost"
$MAP_ID[30] = "Ruins of Surmia outpost"
$MAP_ID[32] = "Nolani Academy outpost"
$MAP_ID[35] = "Ember Light Camp"
$MAP_ID[36] = "Grendich Courthouse"
$MAP_ID[38] = "Augury Rock outpost"
$MAP_ID[39] = "Sardelac Sanitarium"
$MAP_ID[40] = "Piken Square"
$MAP_ID[49] = "Henge of Denravi"
$MAP_ID[51] = "Senjis Corner"
$MAP_ID[52] = "Burning Isle"
$MAP_ID[55] = "Lions Arch"
$MAP_ID[57] = "Bergen Hot Springs"
$MAP_ID[73] = "Riverside Province outpost"
$MAP_ID[77] = "House zu Heltzer"
$MAP_ID[81] = "Ascalon City"
$MAP_ID[82] = "Tomb of the Primeval Kings"
$MAP_ID[85] = "Ascalon Arena outpost"
$MAP_ID[109] = "The Amnoon Oasis"
$MAP_ID[116] = "Dunes of Despair outpost"
$MAP_ID[117] = "Thirsty River outpost"
$MAP_ID[118] = "Elona Reach outpost"
;~ $MAP_ID[119] = "Augury Rock outpost"
$MAP_ID[120] = "The Dragon's Lair outpost"
$MAP_ID[122] = "Ring of Fire outpost"
$MAP_ID[123] = "Abaddon's Mouth outpost"
$MAP_ID[124] = "Hell's Precipice outpost"
$MAP_ID[129] = "Lutgardis Conservatory"
$MAP_ID[130] = "Vasburg Armory"
$MAP_ID[131] = "Serenity Temple"
$MAP_ID[132] = "Ice Tooth Cave"
$MAP_ID[133] = "Beacons Perch"
$MAP_ID[134] = "Yaks Bend"
$MAP_ID[135] = "Frontier Gate"
$MAP_ID[136] = "Beetletun"
$MAP_ID[137] = "Fishermens Haven"
$MAP_ID[138] = "Temple of the Ages"
$MAP_ID[139] = "Ventaris Refuge"
$MAP_ID[140] = "Druids Overlook"
$MAP_ID[141] = "Maguuma Stade"
$MAP_ID[142] = "Quarrel Falls"
$MAP_ID[148] = "Ascalon City outpost"
$MAP_ID[152] = "Heroes Audience"
$MAP_ID[153] = "Seekers Passage"
$MAP_ID[154] = "Destinys Gorge"
$MAP_ID[155] = "Camp Rankor"
$MAP_ID[156] = "The Granite Citadel"
$MAP_ID[157] = "Marhans Grotto"
$MAP_ID[158] = "Port Sledge"
$MAP_ID[159] = "Copperhammer Mines"
$MAP_ID[163] = "Pre-Searing: The Barradin Estate"
$MAP_ID[164] = "Pre-Searing: Ashford Abbey"
$MAP_ID[165] = "Pre-Searing: Foibles Fair"
$MAP_ID[166] = "Pre-Searing: Fort Ranik"
$MAP_ID[176] = "Guild Hall - Frozen Isle"
$MAP_ID[177] = "Guild Hall - Nomad's Isle"
$MAP_ID[178] = "Guild Hall - Druid's Isle"
$MAP_ID[179] = "Guild Hall - Isle of the Dead"
$MAP_ID[181] = "Shiverpeak Arena outpost"
$MAP_ID[188] = "Random Arenas outpost"
$MAP_ID[189] = "Team Arenas outpost"
$MAP_ID[193] = "Cavalon"
$MAP_ID[194] = "Kaineng Center"
$MAP_ID[204] = "Unwaking Waters - Kurzick"
$MAP_ID[206] = "Deldrimor War Camp"
$MAP_ID[213] = "Zen Daijun outpost"
$MAP_ID[214] = "Minister Chos Estate outpost"
$MAP_ID[216] = "Nahpui Quarter outpost"
$MAP_ID[217] = "Tahnnakai Temple outpost"
$MAP_ID[218] = "Arborstone outpost"
$MAP_ID[219] = "Boreas Seabed outpost"
$MAP_ID[220] = "Sunjiang District outpost"
$MAP_ID[222] = "The Eternal Grove outpost"
$MAP_ID[224] = "Gyala Hatchery outpost"
$MAP_ID[225] = "Raisu Palace outpost"
$MAP_ID[226] = "Imperial Sanctum outpost"
$MAP_ID[227] = "Unwaking Waters Luxon"
$MAP_ID[230] = "Amatz Basin outpost"
;~ $MAP_ID[233] = "Raisu Palace outpost"
$MAP_ID[234] = "The Aurios Mines outpost"
$MAP_ID[242] = "Shing Jea Monastery"
$MAP_ID[243] = "Shing Jea Arena outpost"
$MAP_ID[248] = "Great Temple of Balthazar"
$MAP_ID[249] = "Tsumei Village"
$MAP_ID[250] = "Seitung Harbor"
$MAP_ID[251] = "Ran Musu Gardens"
$MAP_ID[253] = "Dwayna Vs Grenth outpost"
$MAP_ID[266] = "Urgoz's Warren outpost"
$MAP_ID[272] = "Altrumm Ruins outpost"
$MAP_ID[273] = "Zos Shivros Channel outpost"
$MAP_ID[274] = "Dragons Throat outpost"
$MAP_ID[275] = "Guild Hall - Isle of Weeping Stone"
$MAP_ID[276] = "Guild Hall - Isle of Jade"
$MAP_ID[277] = "Harvest Temple"
$MAP_ID[278] = "Breaker Hollow"
$MAP_ID[279] = "Leviathan Pits"
$MAP_ID[281] = "Zaishen Challenge outpost"
$MAP_ID[282] = "Zaishen Elite outpost"
$MAP_ID[283] = "Maatu Keep"
$MAP_ID[284] = "Zin Ku Corridor"
$MAP_ID[286] = "Brauer Academy"
$MAP_ID[287] = "Durheim Archives"
$MAP_ID[288] = "Bai Paasu Reach"
$MAP_ID[289] = "Seafarer's Rest"
$MAP_ID[291] = "Vizunah Square Local Quarter"
$MAP_ID[292] = "Vizunah Square Foreign Quarter"
$MAP_ID[293] = "Fort Aspenwood - Luxon"
$MAP_ID[294] = "Fort Aspenwood - Kurzick"
$MAP_ID[295] = "The Jade Quarry - Luxon"
$MAP_ID[296] = "The Jade Quarry - Kurzick"
;~ $MAP_ID[297] = "Unwaking Waters Luxon"
;~ $MAP_ID[298] = "Unwaking Waters Kurzick"
$MAP_ID[303] = "The Marketplace"
$MAP_ID[307] = "The Deep outpost"
$MAP_ID[328] = "Saltspray Beach - Luxon"
$MAP_ID[329] = "Saltspray Beach - Kurzick"
$MAP_ID[330] = "Heroes Ascent outpost"
$MAP_ID[331] = "Grenz Frontier - Luxon"
$MAP_ID[332] = "Grenz Frontier - Kurzick"
$MAP_ID[333] = "The Ancestral Lands - Luxon"
$MAP_ID[334] = "The Ancestral Lands - Kurzick"
$MAP_ID[335] = "Etnaran Keys - Luxon"
$MAP_ID[336] = "Etnaran Keys - Kurzick"
$MAP_ID[337] = "Kaanai Canyon - Luxon"
$MAP_ID[338] = "Kaanai Canyon - Kurzick"
$MAP_ID[348] = "Tanglewood Copse"
$MAP_ID[349] = "Saint Anjeka's Shrine"
$MAP_ID[350] = "Eredon Terrace"
$MAP_ID[359] = "Imperial Isle"
$MAP_ID[360] = "Guild Hall - Isle of Meditation"
$MAP_ID[368] = "Dragon Arena outpost"
$MAP_ID[376] = "Camp Hojanu"
$MAP_ID[378] = "Wehhan Terraces"
$MAP_ID[381] = "Yohlon Haven"
$MAP_ID[387] = "Sunspear Sanctuary"
$MAP_ID[388] = "Aspenwood Gate - Kurzick"
$MAP_ID[389] = "Aspenwood Gate - Luxon"
$MAP_ID[390] = "Jade Flats Kurzick"
$MAP_ID[391] = "Jade Flats Luxon"
$MAP_ID[393] = "Chantry of Secrets"
$MAP_ID[396] = "Mihanu Township"
$MAP_ID[398] = "Basalt Grotto"
$MAP_ID[403] = "Honur Hill"
$MAP_ID[407] = "Yahnur Market"
$MAP_ID[414] = "The Kodash Bazaar"
$MAP_ID[421] = "Venta Cemetery outpost"
$MAP_ID[424] = "Kodonur Crossroads outpost"
$MAP_ID[425] = "Rilohn Refuge outpost"
$MAP_ID[426] = "Pogahn Passage outpost"
$MAP_ID[427] = "Moddok Crevice outpost"
$MAP_ID[428] = "Tihark Orchard outpost"
$MAP_ID[431] = "Sunspear Great Hall"
$MAP_ID[433] = "Dzagonur Bastion outpost"
$MAP_ID[434] = "Dasha Vestibule outpost"
$MAP_ID[435] = "Grand Court of Sebelkeh outpost"
$MAP_ID[438] = "Bone Palace"
$MAP_ID[440] = "The Mouth of Torment"
$MAP_ID[442] = "Lair of the Forgotten"
$MAP_ID[449] = "Kamadan Jewel of Istan"
$MAP_ID[450] = "Gate of Torment"
$MAP_ID[457] = "Beknur Harbor"
$MAP_ID[467] = "Rollerbeetle Racing outpost"
$MAP_ID[469] = "Gate of Fear"
$MAP_ID[473] = "Gate of Secrets"
$MAP_ID[474] = "Gate of Anguish"
$MAP_ID[476] = "Jennurs Horde outpost"
$MAP_ID[477] = "Nundu Bay outpost"
$MAP_ID[478] = "Gate of Desolation outpost"
$MAP_ID[479] = "Champions Dawn"
$MAP_ID[480] = "Ruins of Morah outpost"
;~ $MAP_ID[487] = "Beknur Harbor"
$MAP_ID[489] = "Kodlonu Hamlet"
$MAP_ID[491] = "Jokanur Diggings outpost"
$MAP_ID[492] = "Blacktide Den outpost"
$MAP_ID[493] = "Consulate Docks outpost"
$MAP_ID[494] = "Gate of Pain outpost"
$MAP_ID[495] = "Gate of Madness outpost"
$MAP_ID[496] = "Abaddons Gate outpost"
$MAP_ID[497] = "Sunspear Arena outpost"
$MAP_ID[502] = "The Astralarium"
$MAP_ID[529] = "Guild Hall - Uncharted Isle"
$MAP_ID[530] = "Guild Hall - Isle of Wurms"
$MAP_ID[537] = "Guild Hall - Corrupted Isle"
$MAP_ID[538] = "Guild Hall - Isle of Solitude"
$MAP_ID[544] = "Chahbek Village outpost"
$MAP_ID[545] = "Remains of Sahlahja outpost"
$MAP_ID[549] = "Hero Battles outpost"
$MAP_ID[554] = "Dajkah Inlet outpost"
$MAP_ID[555] = "The Shadow Nexus outpost"
$MAP_ID[559] = "Gate of the Nightfallen Lands"
$MAP_ID[624] = "Vlox's Falls"
$MAP_ID[638] = "Gadd's Encampment"
$MAP_ID[639] = "Umbral Grotto"
$MAP_ID[640] = "Rata Sum"
$MAP_ID[641] = "Tarnished Haven"
$MAP_ID[642] = "Eye of the North outpost"
$MAP_ID[643] = "Sifhalla"
$MAP_ID[644] = "Gunnar's Hold"
$MAP_ID[645] = "Olafstead"
$MAP_ID[648] = "Doomlore Shrine"
$MAP_ID[650] = "Longeye's Ledge"
$MAP_ID[652] = "Central Transfer Chamber"
$MAP_ID[675] = "Boreal Station"
$MAP_ID[721] = "Costume Brawl outpost"
$MAP_ID[795] = "Zaishen Menagerie outpost"
$MAP_ID[796] = "Codex Arena outpost"
$MAP_ID[808] = "Lions Arch - Halloween"
$MAP_ID[809] = "Lions Arch - Wintersday"
$MAP_ID[810] = "Lions Arch - Canthan New Year"
$MAP_ID[811] = "Ascalon City - Wintersday"
$MAP_ID[812] = "Droknars Forge - Halloween"
$MAP_ID[813] = "Droknars Forge - Wintersday"
$MAP_ID[814] = "Tomb of the Primeval Kings - Halloween"
$MAP_ID[815] = "Shing Jea - Dragon Festival"
$MAP_ID[816] = "Shing Jea - Canthan New Year"
;~ $MAP_ID[817] = "Kaineng Center = 817
$MAP_ID[818] = "Kamadan - Halloween"
$MAP_ID[819] = "Kamadan - Wintersday"
$MAP_ID[820] = "Kamadan - Canthan New Year"
$MAP_ID[821] = "Eye of the North - Wintersday"
$MAP_ID[857] = "Embark Beach"
#endregion Map_IDs
#ce
#region materials
Global $MATS_ID[37]
Global $MATS_NAME[37]
$MATS_NAME[0] = 36
$MATS_ID[0] = 36
$MATS_NAME[1] = "琥珀"
$MATS_ID[1] = 6532
$MATS_NAME[2] = "布料"
$MATS_ID[2] = 925
$MATS_NAME[3] = "缎布"
$MATS_ID[3] = 927
$MATS_NAME[4] = "亚麻布"
$MATS_ID[4] = 926
$MATS_NAME[5] = "丝绸"
$MATS_ID[5] = 928
$MATS_NAME[6] = "骨头"
$MATS_ID[6] = 921
$MATS_NAME[7] = "外壳"
$MATS_ID[7] = 954
$MATS_NAME[8] = "戴尔狄摩钢铁矿石"
$MATS_ID[8] = 950
$MATS_NAME[9] = "金刚石"
$MATS_ID[9] = 935
$MATS_NAME[10] = "伊洛那皮革"
$MATS_ID[10] = 943
$MATS_NAME[11] = "羽毛"
$MATS_ID[11] = 933
$MATS_NAME[12] = "毛皮"
$MATS_ID[12] = 941
$MATS_NAME[13] = "玉"
$MATS_ID[13] = 930
$MATS_NAME[14] = "花岗岩石板"
$MATS_ID[14] = 955
$MATS_NAME[15] = "铁矿石"
$MATS_ID[15] = 948
$MATS_NAME[16] = "硬玉"
$MATS_ID[16] = 6533
$MATS_NAME[17] = "皮革"
$MATS_ID[17] = 942
$MATS_NAME[18] = "结块的木炭"
$MATS_ID[18] = 922
$MATS_NAME[19] = "巨大的爪"
$MATS_ID[19] = 923
$MATS_NAME[20] = "巨大的眼"
$MATS_ID[20] = 931
$MATS_NAME[21] = "巨大的牙"
$MATS_ID[21] = 932
$MATS_NAME[22] = "黑曜石"
$MATS_ID[22] = 945
$MATS_NAME[23] = "玛瑙宝石"
$MATS_ID[23] = 936
$MATS_NAME[24] = "闪烁之土"
$MATS_ID[24] = 929
$MATS_NAME[25] = "植物纤维"
$MATS_ID[25] = 934
$MATS_NAME[26] = "羊皮纸卷"
$MATS_ID[26] = 951
$MATS_NAME[27] = "牛皮纸卷"
$MATS_ID[27] = 952
$MATS_NAME[28] = "红宝石"
$MATS_ID[28] = 937
$MATS_NAME[29] = "蓝宝石"
$MATS_ID[29] = 938
$MATS_NAME[30] = "鳞片"
$MATS_ID[30] = 953
$MATS_NAME[31] = "心灵之板"
$MATS_ID[31] = 956
$MATS_NAME[32] = "钢铁矿石"
$MATS_ID[32] = 949
$MATS_NAME[33] = "褐色兽皮"
$MATS_ID[33] = 940
$MATS_NAME[34] = "调和后的玻璃瓶"
$MATS_ID[34] = 939
$MATS_NAME[35] = "木材"
$MATS_ID[35] = 946
$MATS_NAME[36] = "小瓶墨水"
$MATS_ID[36] = 944
#endregion materials
#cs
#region materials
Global $MATS_ID[37]
Global $MATS_NAME[37]
$MATS_NAME[0] = 36
$MATS_ID[0] = 36
$MATS_NAME[1] = "Amber Chunk"			; 6532
$MATS_ID[1] = 6532
$MATS_NAME[2]  = "Bolt of Cloth"		; 925
$MATS_ID[2] = 925
$MATS_NAME[3] = "Bolt of Damask"		; 927
$MATS_ID[3] = 927
$MATS_NAME[4] = "Bolt of Linen"			; 926
$MATS_ID[4] = 926
$MATS_NAME[5] = "Bolt of Silk"	 		; 928
$MATS_ID[5] = 928
$MATS_NAME[6]  = "Bone"					; 921
$MATS_ID[6] = 921
$MATS_NAME[7]  = "Chitin Fragment"		; 954
$MATS_ID[7] = 954
$MATS_NAME[8] = "Deldrimor Steel Ingot"; 950
$MATS_ID[8] = 950
$MATS_NAME[9] = "Diamond"				; 935
$MATS_ID[9] = 935
$MATS_NAME[10] = "Elonian Leather Square";943
$MATS_ID[10] = 943
$MATS_NAME[11]  = "Feather"				; 933
$MATS_ID[11] = 933
$MATS_NAME[12] = "Fur Square"			; 941
$MATS_ID[12] = 941
$MATS_NAME[13] = "Glob of Ectoplasm"	; 930
$MATS_ID[13] = 930
$MATS_NAME[14]  = "Granite Slab"		; 955
$MATS_ID[14] = 955
$MATS_NAME[15]  = "Iron Ingot"			; 948
$MATS_ID[15] = 948
$MATS_NAME[16] = "Jadeite Shard"		; 6533
$MATS_ID[16] = 6533
$MATS_NAME[17] = "Leather Square"		; 942
$MATS_ID[17] = 942
$MATS_NAME[18] = "Lump of Charcoal"		; 922
$MATS_ID[18] = 922
$MATS_NAME[19] = "Monstrous Claw"		; 923
$MATS_ID[19] = 923
$MATS_NAME[20] = "Monstrous Eye"		; 931
$MATS_ID[20] = 931
$MATS_NAME[21] = "Monstrous Fang"		; 932
$MATS_ID[21] = 932
$MATS_NAME[22] = "Obsidian Shard"		; 945
$MATS_ID[22] = 945
$MATS_NAME[23] = "Onyx Gemstone"		; 936
$MATS_ID[23] = 936
$MATS_NAME[24]  = "Pile of Glittering Dust"	; 929
$MATS_ID[24] = 929
$MATS_NAME[25]  = "Plant Fiber"			; 934
$MATS_ID[25] = 934
$MATS_NAME[26] = "Roll of Parchment"	; 951
$MATS_ID[26] = 951
$MATS_NAME[27] = "Roll of Vellum"		; 952
$MATS_ID[27] = 952
$MATS_NAME[28] = "Ruby"					; 937
$MATS_ID[28] = 937
$MATS_NAME[29] = "Sapphire"				; 938
$MATS_ID[29] = 938
$MATS_NAME[30]  = "Scale"				; 953
$MATS_ID[30] = 953
$MATS_NAME[31] = "Spiritwood Plank"		; 956
$MATS_ID[31] = 956
$MATS_NAME[32] = "Steel Ingot"			; 949
$MATS_ID[32] = 949
$MATS_NAME[33] = "Tanned Hide Square"	; 940
$MATS_ID[33] = 940
$MATS_NAME[34] = "Tempered Glass Vial"	; 939
$MATS_ID[34] = 939
$MATS_NAME[35] = "Wood Plank"			; 946
$MATS_ID[35] = 946
$MATS_NAME[36] = "Vial of Ink"			; 944
$MATS_ID[36] = 944
#endregion materials
#ce