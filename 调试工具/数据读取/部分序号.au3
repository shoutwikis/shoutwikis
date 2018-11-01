#Region Global Items
Global Const $RARITY_White = 2621
Global Const $RARITY_Blue = 2623
Global Const $RARITY_Gold = 2624
Global Const $RARITY_Purple = 2626
Global Const $RARITY_Green = 2627
Global Const $RARITY_Red = 33026

#Region Merchant Items
Global Const $ITEM_ID_Belt_Pouch = 34
Global Const $ITEM_ID_Bag = 35
Global Const $ITEM_ID_Rune_of_Holding = 2988
Global Const $ITEM_ID_ID_Kit = 2989
Global Const $ITEM_ID_SUP_ID_Kit = 5899
Global Const $ITEM_ID_Salvage_Kit = 2992
Global Const $ITEM_ID_EXP_Salvage_Kit = 2991
Global Const $ITEM_ID_SUP_Salvage_Kit = 5900
Global Const $ITEM_ID_Small_Equipment_Pack = 31221
Global Const $ITEM_ID_Light_Equipment_Pack = 31222
Global Const $ITEM_ID_Large_Equipment_Pack = 31223
Global Const $ITEM_ID_Heavy_Equipment_Pack = 31224
#EndRegion Merchant Items

#Region Keys
Global Const $ITEM_ID_Ascalonian_Key = 5966
Global Const $ITEM_ID_Steel_Key = 5967
Global Const $ITEM_ID_Krytan_Key = 5964
Global Const $ITEM_ID_Maguuma_Key = 5965
Global Const $ITEM_ID_Elonian_Key = 5960
Global Const $ITEM_ID_Shiverpeak_Key = 5962
Global Const $ITEM_ID_Darkstone_Key = 5963
Global Const $ITEM_ID_Miners_Key = 5961
Global Const $ITEM_ID_Shing_Jea_Key = 6537
Global Const $ITEM_ID_Canthan_Key = 6540
Global Const $ITEM_ID_Kurzick_Key = 6535
Global Const $ITEM_ID_Stoneroot_Key = 6536
Global Const $ITEM_ID_Luxon_Key = 6538
Global Const $ITEM_ID_Deep_Jade_Key = 6539
Global Const $ITEM_ID_Forbidden_Key = 6534
Global Const $ITEM_ID_Istani_Key = 15557
Global Const $ITEM_ID_Kournan_Key = 15559
Global Const $ITEM_ID_Vabbian_Key = 15558
Global Const $ITEM_ID_Ancient_Elonian_Key = 15556
Global Const $ITEM_ID_Margonite_Key = 15560
Global Const $ITEM_ID_Demonic_Key = 19174
Global Const $ITEM_ID_Phantom_Key = 5882
Global Const $ITEM_ID_Obsidian_Key = 5971
Global Const $ITEM_ID_Lockpick = 22751
Global Const $ITEM_ID_Zaishen_Key = 28571
Global Const $ITEM_ID_Dungeon_Key = 18133 ; Snowman Cave
Global Const $ITEM_ID_Boss_Key = 52495 ; Snowman Cave
Global Const $ITEM_ID_Bogroots_Boss_Key = 2593
#EndRegion Keys

#Region Dyes
Global Const $ITEM_ID_Dyes = 146
Global Const $ITEM_ExtraID_Blue_Dye = 2
Global Const $ITEM_ExtraID_Green_Dye = 3
Global Const $ITEM_ExtraID_Purple_Dye = 4
Global Const $ITEM_ExtraID_Red_Dye = 5
Global Const $ITEM_ExtraID_Yellow_Dye = 6
Global Const $ITEM_ExtraID_Brown_Dye = 7
Global Const $ITEM_ExtraID_Orange_Dye = 8
Global Const $ITEM_ExtraID_Silver_Dye = 9
Global Const $ITEM_ExtraID_Black_Dye = 10
Global Const $ITEM_ExtraID_Gray_Dye = 11
Global Const $ITEM_ExtraID_White_Dye = 12
Global Const $ITEM_ExtraID_Pink_Dye = 13
#EndRegion Dyes

#Region Scrolls
Global $Blue_Scroll_Array[3] = [5853, 5975, 5976]
Global $Gold_Scroll_Array[8] = [3256, 3746, 5594, 5595, 5611, 21233, 22279, 22280]
Global Const $ITEM_ID_Passage_Scroll_Urgoz = 3256
Global Const $ITEM_ID_Passage_Scroll_UW = 3746
Global Const $ITEM_ID_Heros_Insight_Scroll = 5594
Global Const $ITEM_ID_Berserkers_Insight_Scroll = 5595
Global Const $ITEM_ID_Slayers_Insight_Scroll = 5611
Global Const $ITEM_ID_Adventurers_Insight_Scroll = 5853
Global Const $ITEM_ID_Rampagers_Insight_Scroll = 5975
Global Const $ITEM_ID_Hunters_Insight_Scroll = 5976
Global Const $ITEM_ID_Scroll_of_the_Lightbringer = 21233
Global Const $ITEM_ID_Passage_Scroll_Deep = 22279
Global Const $ITEM_ID_Passage_Scroll_FoW = 22280
#EndRegion Scrolls

#Region Alcohol
; For pickup use
Global $Alcohol_Array[19] = [910, 2513, 5585, 6049, 6366, 6367, 6375, 15477, 19171, 19172, 19173, 22190, 24593, 28435, 30855, 31145, 31146, 35124, 36682]
; For using them
Global $OnePoint_Alcohol_Array[11] = [910, 5585, 6049, 6367, 6375, 15477, 19171, 19172, 19173, 22190, 28435]
Global $ThreePoint_Alcohol_Array[7] = [2513, 6366, 24593, 30855, 31145, 31146, 35124]
Global $FiftyPoint_Alcohol_Array[1] = [36682]
; Data
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
#EndRegion Alcohol

#Region Party
Global $Spam_Party_Array[7] = [6368, 6369, 6376, 21809, 21810, 21813, 36683]
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

#Region Sweet Pcon
Global $Sweet_Pcon_Array[5] = [22269, 22752, 28431, 28432, 28436]
Global Const $ITEM_ID_Drake_Kabob = 17060
Global Const $ITEM_ID_Bowl_of_Skalefin_Soup = 17061
Global Const $ITEM_ID_Pahnai_Salad = 17062
Global Const $ITEM_ID_Birthday_Cupcake = 22269
Global Const $ITEM_ID_Golden_Egg = 22752
Global Const $ITEM_ID_Candy_Apple = 28431
Global Const $ITEM_ID_Candy_Corn = 28432
Global Const $ITEM_ID_Slice_of_Pumpkin_Pie = 28436
Global Const $ITEM_ID_Lunar_Fortune_2008 = 29425 ; Rat
Global Const $ITEM_ID_Lunar_Fortune_2009 = 29426 ; Ox
Global Const $ITEM_ID_Lunar_Fortune_2010 = 29427 ; Tiger
Global Const $ITEM_ID_Lunar_Fortune_2011 = 29428 ; Rabbit
Global Const $ITEM_ID_Lunar_Fortune_2012 = 29429 ; Dragon
Global Const $ITEM_ID_Lunar_Fortune_2013 = 29430 ; Snake
Global Const $ITEM_ID_Lunar_Fortune_2014 = 29431 ; Horse
Global Const $ITEM_ID_Lunar_Fortune_2015 = 29432 ; Sheep
Global Const $ITEM_ID_Lunar_Fortune_2016 = 29433 ; Monkey
Global Const $ITEM_ID_Blue_Rock_Candy = 31151
Global Const $ITEM_ID_Green_Rock_Candy = 31152
Global Const $ITEM_ID_Red_Rock_Candy = 31153
#EndRegion Sweet Pcon
#EndRegion Sweets

#Region DP Removal
Global $DPRemoval_Sweets[6] = [6370, 21488, 21489, 22191, 26784, 28433]
Global Const $ITEM_ID_Peppermint_CC = 6370
Global Const $ITEM_ID_Refined_Jelly = 19039
Global Const $ITEM_ID_Elixir_of_Valor = 21227
Global Const $ITEM_ID_Wintergreen_CC = 21488
Global Const $ITEM_ID_Rainbow_CC = 21489
Global Const $ITEM_ID_Four_Leaf_Clover = 22191
Global Const $ITEM_ID_Honeycomb = 26784
Global Const $ITEM_ID_Pumpkin_Cookie = 28433
Global Const $ITEM_ID_Oath_of_Purity = 30206
Global Const $ITEM_ID_Seal_of_the_Dragon_Empire = 30211
Global Const $Item_ID_Shining_Blade_Ration = 35127
#EndRegion DP Removal

#Region Special Drops
Global $Special_Drops[6] = [556, 18345, 37765, 21833, 28433, 28434]
Global Const $ITEM_ID_CC_Shard = 556
Global Const $ITEM_ID_Flame_of_Balthazar = 2514 ; Not really a drop
Global Const $ITEM_ID_Golden_Flame_of_Balthazar = 22188 ; Not really a drop
Global Const $ITEM_ID_Celestial_Sigil = 2571 ; Not really a drop
Global Const $ITEM_ID_Victory_Token = 18345
Global Const $ITEM_ID_Wintersday_Gift = 21491 ; Not really a drop
Global Const $ITEM_ID_Wayfarer_Mark = 37765
Global Const $ITEM_ID_Lunar_Token = 21833
Global Const $ITEM_ID_Lunar_Tokens = 28433
Global Const $ITEM_ID_ToT = 28434
Global Const $ITEM_ID_Blessing_of_War = 37843
#EndRegion Special Drops

#Region Stupid Drops
Global $Map_Pieces_Array[4] = [24629, 24630, 24631, 24632]
Global Const $Item_ID_Kilhn_Testibries_Cuisse = 2113
Global Const $Item_ID_Kilhn_Testibries_Greaves = 2114
Global Const $Item_ID_Kilhn_Testibries_Crest = 2115
Global Const $Item_ID_Kilhn_Testibries_Pauldron = 2116
Global Const $ITEM_ID_Map_Piece_TL = 24629
Global Const $ITEM_ID_Map_Piece_TR = 24630
Global Const $ITEM_ID_Map_Piece_BL = 24631
Global Const $ITEM_ID_Map_Piece_BR = 24632
Global Const $ITEM_ID_Golden_Lantern = 4195 ; Mount Qinkai Quest Item
Global Const $ITEM_ID_Hunk_of_Fresh_Meat = 15583 ; NF Quest Item for Drakes on a Plain
Global Const $ITEM_ID_Zehtukas_Great_Horn = 15845
Global Const $ITEM_ID_Jade_Orb = 15940
Global Const $ITEM_ID_Herring = 26502 ; Mini Black Moa Chick incubator item
Global Const $ITEM_ID_Encrypted_Charr_Battle_Plans = 27976
Global Const $ITEM_ID_Ministerial_Decree = 29109 ; WoC quest item
Global Const $ITEM_ID_Keirans_Bow = 35829 ; Not really a drop
#EndRegion Stupid Drops

#Region Hero Armor Upgrades
Global Const $ITEM_ID_Ancient_Armor_Remnant = 19190
Global Const $ITEM_ID_Stolen_Sunspear_Armor = 19191
Global Const $ITEM_ID_Mysterious_Armor_Piece = 19192
Global Const $ITEM_ID_Primeval_Armor_Remnant = 19193
Global Const $ITEM_ID_Deldrimor_Armor_Remnant = 27321
Global Const $ITEM_ID_Cloth_of_the_Brotherhood = 27322
#EndRegion Hero Armor Upgrades

#Region Endgame Rewards
Global Const $ITEM_ID_Amulet_of_the_Mists = 6069
Global Const $ITEM_ID_Book_of_Secrets = 19197
Global Const $ITEM_ID_Droknars_Key = 26724
Global Const $ITEM_ID_Imperial_Dragons_Tear = 30205; Not tradeable
Global Const $ITEM_ID_Deldrimor_Talisman = 30693
Global Const $ITEM_ID_Medal_of_Honor = 35122 ; Not tradeable
#EndRegion Endgame Rewards

#Region Reward Trophy
Global Const $ITEM_ID_Copper_Zaishen_Coin = 31202
Global Const $ITEM_ID_Gold_Zaishen_Coin = 31203
Global Const $ITEM_ID_Silver_Zaishen_Coin = 31204
Global Const $ITEM_ID_Monastery_Credit = 5819
Global Const $ITEM_ID_Imperial_Commendation = 6068
Global Const $ITEM_ID_Luxon_Totem = 6048
Global Const $ITEM_ID_Equipment_Requisition = 5817
Global Const $ITEM_ID_Battle_Commendation = 17081
Global Const $ITEM_ID_Kournan_Coin = 19195
Global Const $ITEM_ID_Trade_Contract = 17082
Global Const $ITEM_ID_Ancient_Artifact = 19182
Global Const $ITEM_ID_Inscribed_Secret = 19196
Global Const $ITEM_ID_Burol_Ironfists_Commendation = 29018
Global Const $ITEM_ID_Bison_Championship_Token = 27563
Global Const $ITEM_ID_Monumental_Tapestry = 27583
Global Const $ITEM_ID_Royal_Gift = 35120
Global Const $ITEM_ID_War_Supplies = 35121
Global Const $ITEM_ID_Confessors_Orders = 35123
Global Const $ITEM_ID_Paper_Wrapped_Parcel = 34212
Global Const $ITEM_ID_Sack_of_Random_Junk = 34213
;Global Const $ITEM_ID_Legion_Loot_Bag =
;Global Const $ITEM_ID_Reverie_Gift =
Global Const $ITEM_ID_Ministerial_Commendation = 36985
Global Const $ITEM_ID_Imperial_Guard_Requisition_Order = 29108
Global Const $ITEM_ID_Imperial_Guard_Lockbox = 30212 ; Not tradeable
;Global Const $ITEM_ID_Proof_of_Flames =
;Global Const $ITEM_ID_Proof_of_Mountains =
;Global Const $ITEM_ID_Proof_of_Waves =
;Global Const $ITEM_ID_Proof_of_Winds =
;Global Const $ITEM_ID_Racing_Medal =
Global Const $ITEM_ID_Glob_of_Frozen_Ectoplasm = 21509
;Global Const $ITEM_ID_Celestial_Miniature_Token =
;Global Const $ITEM_ID_Dragon_Festival_Grab_Bag =
Global Const $ITEM_ID_Red_Gift_Bag = 21811
;Global Const $ITEM_ID_Lunar_Festival_Grab_Bag =
Global Const $ITEM_ID_Festival_Prize = 15478
;Global Const $ITEM_ID_Imperial_Mask_Token =
;Global Const $ITEM_ID_Ghoulish_Grab_Bag =
;Global Const $ITEM_ID_Ghoulish_Accessory_Token =
;Global Const $ITEM_ID_Frozen_Accessory_Token =
;;Global Const $ITEM_ID_Wintersday_Grab_Bag =
Global Const $ITEM_ID_Armbrace_of_Truth = 21127
Global Const $ITEM_ID_Margonite_Gemstone = 21128
Global Const $ITEM_ID_Stygian_Gemstone = 21129
Global Const $ITEM_ID_Titan_Gemstone = 21130
Global Const $ITEM_ID_Torment_Gemstone = 21131
Global Const $ITEM_ID_Coffer_of_Whispers = 21228
Global Const $ITEM_ID_Gift_of_the_Traveller = 31148
Global Const $ITEM_ID_Gift_of_the_Huntsman = 31149
Global Const $ITEM_ID_Champions_Zaishen_Strongbox = 36665
Global Const $ITEM_ID_Heros_Zaishen_Strongbox = 36666
Global Const $ITEM_ID_Gladiators_Zaishen_Strongbox = 36667
Global Const $ITEM_ID_Strategists_Zaishen_Strongbox = 36668
Global Const $ITEM_ID_Zhos_Journal = 25866
#EndRegion Reward Trophy

#Region Polymock
Global Const $ITEM_ID_Polymock_Wind_Rider = 24356 ; Gold
Global Const $ITEM_ID_Polymock_Gargoyle = 24361 ; White
Global Const $ITEM_ID_Polymock_Mergoyle = 24369 ; White
Global Const $ITEM_ID_Polymock_Skale = 24373 ; White
Global Const $ITEM_ID_Polymock_Fire_Imp = 24359 ; White
Global Const $ITEM_ID_Polymock_Kappa = 24367 ; Purple
Global Const $ITEM_ID_Polymock_Ice_Imp = 24366 ; White
Global Const $ITEM_ID_Polymock_Earth_Elemental = 24357 ; Purple
Global Const $ITEM_ID_Polymock_Ice_Elemental = 24365 ; Purple
Global Const $ITEM_ID_Polymock_Fire_Elemental = 24358 ; Purple
Global Const $ITEM_ID_Polymock_Aloe_Seed = 24355 ; Purple
Global Const $ITEM_ID_Polymock_Mirage_Iboga = 24363 ; Gold
Global Const $ITEM_ID_Polymock_Gaki = 24360 ; Gold
;Global Const $ITEM_ID_Polymock_Mantis_Dreamweaver =  ; Gold
Global Const $ITEM_ID_Polymock_Mursaat_Elementalist = 24370 ; Gold
Global Const $ITEM_ID_Polymock_Ruby_Djinn = 24371 ; Gold
Global Const $ITEM_ID_Polymock_Naga_Shaman = 24372 ; Gold
Global Const $ITEM_ID_Polymock_Stone_Rain = 24374 ; Gold
#EndRegion Polymock

#Region Stackable Trophies
Global Const $ITEM_ID_Charr_Carving = 423
Global Const $ITEM_ID_Icy_Lodestone = 424
Global Const $ITEM_ID_Spiked_Crest = 434
Global Const $ITEM_ID_Hardened_Hump = 435
Global Const $ITEM_ID_Mergoyle_Skull = 436
Global Const $ITEM_ID_Glowing_Heart = 439
Global Const $ITEM_ID_Forest_Minotaur_Horn = 440
Global Const $ITEM_ID_Shadowy_Remnant = 441
Global Const $ITEM_ID_Abnormal_Seed = 442
Global Const $ITEM_ID_Bog_Skale_Fin = 443
Global Const $ITEM_ID_Feathered_Caromi_Scalp = 444
Global Const $ITEM_ID_Shriveled_Eye = 446
Global Const $ITEM_ID_Dune_Burrower_Jaw = 447
Global Const $Item_ID_Losaru_Mane = 448
Global Const $ITEM_ID_Bleached_Carapace = 449
Global Const $Item_ID_Topaz_Crest = 450
Global Const $ITEM_ID_Encrusted_Lodestone = 451
Global Const $ITEM_ID_Massive_Jawbone = 452
Global Const $Item_ID_Iridescant_Griffon_Wing = 453
Global Const $ITEM_ID_Dessicated_Hydra_Claw = 454
Global Const $ITEM_ID_Minotaur_Horn = 455
Global Const $ITEM_ID_Jade_Mandible = 457
Global Const $ITEM_ID_Forgotten_Seal = 459
Global Const $ITEM_ID_White_Mantle_Emblem = 460
Global Const $ITEM_ID_White_Mantle_Badge = 461
Global Const $ITEM_ID_Mursaat_Token = 462
Global Const $ITEM_ID_Ebon_Spider_Leg = 463
Global Const $ITEM_ID_Ancient_Eye = 464
Global Const $ITEM_ID_Behemoth_Jaw = 465
Global Const $ITEM_ID_Maguuma_Mane = 466
Global Const $ITEM_ID_Thorny_Carapace = 467
Global Const $ITEM_ID_Tangled_Seed = 468
Global Const $ITEM_ID_Mossy_Mandible = 469
Global Const $ITEM_ID_Jungle_Skale_Fin = 70
Global Const $ITEM_ID_Jungle_Troll_Tusk = 471
Global Const $ITEM_ID_Obsidian_Burrower_Jaw = 472
Global Const $ITEM_ID_Demonic_Fang = 473
Global Const $ITEM_ID_Phantom_Residue = 474
Global Const $ITEM_ID_Gruesome_Sternum = 475
Global Const $ITEM_ID_Demonic_Remains = 476
Global Const $ITEM_ID_Stormy_Eye = 477
Global Const $ITEM_ID_Scar_Behemoth_Jaw = 478
Global Const $ITEM_ID_Fetid_Carapace = 479
Global Const $ITEM_ID_Singed_Gargoyle_Skull = 480
Global Const $ITEM_ID_Gruesome_Ribcage = 482
Global Const $ITEM_ID_Rawhide_Belt = 483
Global Const $ITEM_ID_Leathery_Claw = 484
Global Const $ITEM_ID_Scorched_Seed = 485
Global Const $ITEM_ID_Scorched_Lodestone = 486
Global Const $ITEM_ID_Ornate_Grawl_Necklace = 487
Global Const $ITEM_ID_Shiverpeak_Mane = 488
Global Const $ITEM_ID_Frostfire_Fang = 489
Global Const $ITEM_ID_Icy_Hump = 490
Global Const $ITEM_ID_Huge_Jawbone = 492
Global Const $ITEM_ID_Frosted_Griffon_Wing = 493
Global Const $ITEM_ID_Frigid_Heart = 494
Global Const $ITEM_ID_Curved_Mintaur_Horn = 495
Global Const $ITEM_ID_Azure_Remains = 496
Global Const $ITEM_ID_Alpine_Seed = 497
Global Const $Item_ID_Feathered_Avicara_Scalp = 498
Global Const $ITEM_ID_Intricate_Grawl_Necklace = 499
Global Const $ITEM_ID_Mountain_Troll_Tusk = 500
Global Const $ITEM_ID_Stone_Summit_Badge = 502
Global Const $ITEM_ID_Molten_Claw = 503
Global Const $ITEM_ID_Decayed_Orr_Emblem = 504
Global Const $Item_ID_Igneous_Spider_Leg = 505
Global Const $ITEM_ID_Molten_Eye = 506
Global Const $Item_ID_Fiery_Crest = 508
Global Const $ITEM_ID_Igneous_Hump = 510
Global Const $Item_ID_Unctuous_Remains = 511
Global Const $ITEM_ID_Mahgo_Claw = 513
Global Const $Item_ID_Molten_Heart = 514
Global Const $ITEM_ID_Corrosive_Spider_Leg = 518
Global Const $ITEM_ID_Umbral_Eye = 519
Global Const $ITEM_ID_Shadowy_Crest = 520
Global Const $ITEM_ID_Dark_Remains = 522
Global Const $ITEM_ID_Gloom_Seed = 523
Global Const $ITEM_ID_Umbral_Skeletal_Limb = 525
Global Const $ITEM_ID_Shadowy_Husk = 526
Global Const $ITEM_ID_Enslavement_Stone = 532
Global Const $ITEM_ID_Kurzick_Bauble = 604
Global Const $ITEM_ID_Jade_Bracelet = 809
Global Const $ITEM_ID_Luxon_Pendant = 810
Global Const $ITEM_ID_Bone_Charm = 811
Global Const $ITEM_ID_Truffle = 813
Global Const $ITEM_ID_Skull_Juju = 814
Global Const $ITEM_ID_Mantid_Pincer = 815
Global Const $ITEM_ID_Stone_Horn = 816
Global Const $ITEM_ID_Keen_Oni_Claw = 817
Global Const $ITEM_ID_Dredge_Incisor = 818
Global Const $ITEM_ID_Dragon_Root = 819
Global Const $ITEM_ID_Stone_Carving = 820
Global Const $ITEM_ID_Warden_Horn = 822
Global Const $ITEM_ID_Pulsating_Growth = 824
Global Const $ITEM_ID_Forgotten_Trinket_Box = 825
Global Const $ITEM_ID_Augmented_Flesh = 826
Global Const $ITEM_ID_Putrid_Cyst = 827
Global Const $ITEM_ID_Mantis_Pincer = 829
Global Const $ITEM_ID_Naga_Pelt = 833
Global Const $ITEM_ID_Feathered_Crest = 835
Global Const $ITEM_ID_Feathered_Scalp = 836
Global Const $ITEM_ID_Kappa_Hatchling_Shell = 838
Global Const $ITEM_ID_Black_Pearl = 841
Global Const $ITEM_ID_Rot_Wallow_Tusk = 842
Global Const $ITEM_ID_Kraken_Eye = 843
Global Const $ITEM_ID_Azure_Crest = 844
Global Const $ITEM_ID_Kirin_Horn = 846
Global Const $ITEM_ID_Keen_Oni_Talon = 847
Global Const $ITEM_ID_Naga_Skin = 848
Global Const $ITEM_ID_Guardian_Moss = 849
Global Const $ITEM_ID_Archaic_Kappa_Shell = 850
Global Const $ITEM_ID_Stolen_Provisions = 851
Global Const $ITEM_ID_Soul_Stone = 852
Global Const $ITEM_ID_Vermin_Hide = 853
Global Const $ITEM_ID_Venerable_Mantid_Pincer = 854
Global Const $ITEM_ID_Celestial_Essence = 855
Global Const $ITEM_ID_Moon_Shell = 1009
Global Const $ITEM_ID_Copper_Shilling = 1577
Global Const $ITEM_ID_Gold_Doubloon = 1578
Global Const $ITEM_ID_Silver_Bullion_Coin = 1579
Global Const $ITEM_ID_Demonic_Relic = 1580
Global Const $ITEM_ID_Margonite_Mask = 1581
Global Const $ITEM_ID_Kournan_Pendant = 1582
Global Const $ITEM_ID_Mummy_Wrapping = 1583
Global Const $ITEM_ID_Sandblasted_Lodestone = 1584
Global Const $ITEM_ID_Inscribed_Shard = 1587
Global Const $ITEM_ID_Dusty_Insect_Carapace = 1588
Global Const $ITEM_ID_Giant_Tusk = 1590
Global Const $ITEM_ID_Insect_Appendage = 1597
Global Const $Item_ID_Juvenile_Termite_Leg = 1598
Global Const $ITEM_ID_Sentient_Root = 1600
Global Const $ITEM_ID_Sentient_Seed = 1601
Global Const $ITEM_ID_Skale_Tooth = 1603
Global Const $ITEM_ID_Skale_Claw = 1604
Global Const $ITEM_ID_Skeleton_Bone = 1605
Global Const $ITEM_ID_Cobalt_Talon = 1609
Global Const $ITEM_ID_Skree_Wing = 1610
Global Const $ITEM_ID_Insect_Carapace = 1617
Global Const $ITEM_ID_Sentient_Lodestone = 1619
Global Const $ITEM_ID_Immolated_Djinn_Essence = 1620
Global Const $ITEM_ID_Roaring_Ether_Claw = 1629
Global Const $ITEM_ID_Mandragor_Husk = 1668
Global Const $ITEM_ID_Mandragor_Swamproot = 1671
Global Const $ITEM_ID_Behemoth_Hide = 1675
Global Const $ITEM_ID_Geode = 1681
Global Const $ITEM_ID_Hunting_Minotaur_Horn = 1682
Global Const $ITEM_ID_Mandragor_Root = 1686
Global Const $ITEM_ID_Red_Iris_Flower = 2994
Global Const $ITEM_ID_Iboga_Petal = 19183
Global Const $ITEM_ID_Skale_Fin = 19184
Global Const $ITEM_ID_Chunk_of_Drake_Flesh = 19185
Global Const $ITEM_ID_Ruby_Djinn_Essence = 19187
Global Const $ITEM_ID_Sapphire_Djinn_Essence = 19188
Global Const $ITEM_ID_Sentient_Spore = 19198
Global Const $ITEM_ID_Heket_Tongue = 19199
Global Const $ITEM_ID_Golden_Rin_Relic = 24354
Global Const $ITEM_ID_Destroyer_Core = 27033
Global Const $ITEM_ID_Incubus_Wing = 27034
Global Const $ITEM_ID_Saurian_Bone = 27035
Global Const $ITEM_ID_Amphibian_Tongue = 27036
Global Const $ITEM_ID_Weaver_Leg = 27037
Global Const $ITEM_ID_Patch_of_Simian_Fur = 27038
Global Const $ITEM_ID_Quetzal_Crest = 27039
Global Const $ITEM_ID_Skelk_Claw = 27040
Global Const $ITEM_ID_Sentient_Vine = 27041
Global Const $ITEM_ID_Frigid_Mandragor_Husk = 27042
Global Const $ITEM_ID_Modnir_Mane = 27043
Global Const $ITEM_ID_Stone_Summit_Emblem = 27044
Global Const $ITEM_ID_Jotun_Pelt = 27045
Global Const $ITEM_ID_Berserker_Horn = 27046
Global Const $ITEM_ID_Glacial_Stone = 27047
Global Const $ITEM_ID_Frozen_Wurm_Husk = 27048
Global Const $ITEM_ID_Mountain_Root = 27049
Global Const $ITEM_ID_Pile_of_Elemental_Dust = 27050
Global Const $ITEM_ID_Superior_Charr_Carving = 27052
Global Const $ITEM_ID_Stone_Grawl_Necklace = 27053
Global Const $ITEM_ID_Mantid_Ungula = 27054
Global Const $ITEM_ID_Skale_Fang = 27055
Global Const $ITEM_ID_Stone_Claw = 27057
Global Const $ITEM_ID_Skelk_Fang = 27060
Global Const $ITEM_ID_Fungal_Root = 27061
Global Const $ITEM_ID_Flesh_Reaver_Morsel = 27062
Global Const $ITEM_ID_Golem_Runestone = 27065
Global Const $ITEM_ID_Beetle_Egg = 27066
Global Const $ITEM_ID_Blob_of_Ooze = 27067
Global Const $ITEM_ID_Chromatic_Scale = 27069
Global Const $ITEM_ID_Dryder_Web = 27070
Global Const $ITEM_ID_Vaettir_Essence = 27071
Global Const $ITEM_ID_Krait_Skin = 27729
Global Const $ITEM_ID_Undead_Bone = 27974
#EndRegion  Stackable Trophies

#Region Tomes
; All Tomes
Global $Tome_Array[20] = [21786, 21787, 21788, 21789, 21790, 21791, 21792, 21793, 21794, 21795, 21796, 21797, 21798, 21799, 21800, 21801, 21802, 21803, 21804, 21805]
;~ Elite Tomes
Global $Elite_Tome_Array[10] = [21786, 21787, 21788, 21789, 21790, 21791, 21792, 21793, 21794, 21795]
Global Const $ITEM_ID_Assassin_EliteTome = 21786
Global Const $ITEM_ID_Mesmer_EliteTome = 21787
Global Const $ITEM_ID_Necromancer_EliteTome = 21788
Global Const $ITEM_ID_Elementalist_EliteTome = 21789
Global Const $ITEM_ID_Monk_EliteTome = 21790
Global Const $ITEM_ID_Warrior_EliteTome = 21791
Global Const $ITEM_ID_Ranger_EliteTome = 21792
Global Const $ITEM_ID_Dervish_EliteTome = 21793
Global Const $ITEM_ID_Ritualist_EliteTome = 21794
Global Const $ITEM_ID_Paragon_EliteTome = 21795
;~ Normal Tomes
Global $Regular_Tome_Array[10] = [21796, 21797, 21798, 21799, 21800, 21801, 21802, 21803, 21804, 21805]
Global Const $ITEM_ID_Assassin_Tome = 21796
Global Const $ITEM_ID_Mesmer_Tome = 21797
Global Const $ITEM_ID_Necromancer_Tome = 21798
Global Const $ITEM_ID_Elementalist_Tome = 21799
Global Const $ITEM_ID_Monk_Tome = 21800
Global Const $ITEM_ID_Warrior_Tome = 21801
Global Const $ITEM_ID_Ranger_Tome = 21802
Global Const $ITEM_ID_Dervish_Tome = 21803
Global Const $ITEM_ID_Ritualist_Tome = 21804
Global Const $ITEM_ID_Paragon_Tome = 21805
#EndRegion Tomes

#Region Consumable Crafter Items
Global $Conset_Array[7] = [24859, 24860, 24861]
Global Const $ITEM_ID_Armor_of_Salvation = 24860
Global Const $ITEM_ID_Essence_of_Celerity = 24859
Global Const $ITEM_ID_Grail_of_Might = 24861
Global Const $ITEM_ID_Powerstone_of_Courage = 24862
Global Const $ITEM_ID_Scroll_of_Resurrection = 26501
Global Const $ITEM_ID_Star_of_Transference = 25896
Global Const $ITEM_ID_Perfect_Salvage_Kit = 25881
#EndRegion Consumable Crafter Items

#Region Summoning Stones
Global $Summon_Stone_Array[19] = [21154, 30209, 30210, 30846, 30959, 30960, 30961, 30962, 30963, 30964, 30965, 30966, 31022, 31023, 31155, 31156, 32557, 34176, 35126]
Global Const $ITEM_ID_Merchant_Summon = 21154
Global Const $ITEM_ID_Tengu_Summon = 30209
Global Const $ITEM_ID_Imperial_Guard_Summon = 30210
Global Const $ITEM_ID_Automaton_Summon = 30846
Global Const $Item_ID_Igneous_Summoning_Stone = 30847
Global Const $ITEM_ID_Chitinous_Summon = 30959
Global Const $Item_ID_Mystical_Summon = 30960
Global Const $ITEM_ID_Amber_Summon = 30961
Global Const $ITEM_ID_Artic_Summon = 30962
Global Const $ITEM_ID_Demonic_Summon = 30963
Global Const $ITEM_ID_Gelatinous_Summon = 30964
Global Const $ITEM_ID_Fossilized__Summon = 30965
Global Const $ITEM_ID_Jadeite_Summon = 30966
Global Const $Item_ID_Mischievous_Summon = 31022
Global Const $ITEM_ID_Frosty_Summon = 31023
Global Const $Item_ID_Mysterious_Summon = 31155
Global Const $ITEM_ID_Zaishen_Summon = 31156
Global Const $ITEM_ID_Ghastly_Summon = 32557
Global Const $ITEM_ID_Celestial_Summon = 34176
Global Const $Item_ID_Shining_Blade_Summon = 35126
Global Const $Item_ID_Legionnaire_Summoning_Crystal = 37810
#EndRegion Summoning Stones

#Region Tonics
Global $Tonic_Party_Array[23] = [4730, 15837, 21490, 22192, 30624, 30626, 30628, 30630, 30632, 30634, 30636, 30638, 30640, 30642, 30646, 30648, 31020, 31141, 31142, 31144, 31172, 37771, 37772]
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

#Region EL Tonics
Global $EL_Tonic_Array[] = []
;Global Const $ITEM_ID_EL_Beetle_Juice_Tonic =
;Global Const $ITEM_ID_EL_Frosty_Tonic =
Global Const $ITEM_ID_EL_Transmogrifier_Tonic = 23242
Global Const $ITEM_ID_EL_Yuletide_Tonic = 29241
;Global Const $ITEM_ID_EL_Knight_Tonic =
;Global Const $ITEM_ID_EL_Legionaire_Tonic =
Global Const $ITEM_ID_EL_Abyssal_Tonic = 30625
Global Const $ITEM_ID_EL_Cerebral_Tonic = 30627
Global Const $ITEM_ID_EL_Macabre_Tonic = 30629
Global Const $ITEM_ID_EL_Trapdoor_Tonic = 30631
Global Const $ITEM_ID_EL_Searing_Tonic = 30633
Global Const $ITEM_ID_EL_Automatonic_Tonic = 30635
Global Const $ITEM_ID_EL_Skeletonic_Tonic = 30637
Global Const $ITEM_ID_EL_Boreal_Tonic = 30639
Global Const $ITEM_ID_EL_Gelatinous_Tonic = 30641
Global Const $ITEM_ID_EL_Phantasmal_Tonic = 30643
Global Const $ITEM_ID_EL_Abominable_Tonic = 30647
Global Const $ITEM_ID_EL_Sinister_Automatonic_Tonic = 30827
Global Const $ITEM_ID_EL_Mischievious_Tonic = 31021
Global Const $ITEM_ID_EL_Cottontail_Tonic = 31143
Global Const $ITEM_ID_EL_Crate_of_Fireworks = 31147
Global Const $ITEM_ID_EL_Unseen_Tonic = 31173
Global Const $ITEM_ID_EL_Henchman_Julyia_Tonic = 32832
Global Const $ITEM_ID_EL_Henchman_Aurora_Allesandra_Tonic = 32843
Global Const $ITEM_ID_EL_Henchman_Divinus_Tutela_Tonic = 32850
Global Const $ITEM_ID_EL_Henchman_Ghavin_Tonic = 32853
Global Const $ITEM_ID_EL_Henchman_Hobba_Inaste = 32854
Global Const $ITEM_ID_EL_Henchman_Khai_Kemnebi_Tonic = 32862
Global Const $ITEM_ID_EL_Reindeer_Tonic = 34156
Global Const $ITEM_ID_EL_Koss_Tonic = 36425
Global Const $ITEM_ID_EL_Dunkoro_Tonic = 36426
Global Const $ITEM_ID_EL_Melonni_Tonic = 36427
Global Const $ITEM_ID_EL_Acolyte_Jin_Tonic = 36428
Global Const $ITEM_ID_EL_Acolyte_Sousuke_Tonic = 36429
Global Const $ITEM_ID_EL_Tahlkora_Tonic = 36430
Global Const $ITEM_ID_EL_Zhed_Shadowhoof_Tonic = 36431
Global Const $ITEM_ID_EL_Magrid_the_Sly_Tonic = 36432
Global Const $ITEM_ID_EL_Master_of_Whispers_Tonic = 36433
Global Const $ITEM_ID_EL_Goren_Tonic = 36434
Global Const $ITEM_ID_EL_Norgu_Tonic = 36435
Global Const $ITEM_ID_EL_Morgahn_Tonic = 36436
Global Const $ITEM_ID_EL_Razah_Tonic = 36437
Global Const $ITEM_ID_EL_Olias_Tonic = 36438
Global Const $ITEM_ID_EL_Zenmai_Tonic = 36439
Global Const $ITEM_ID_EL_Ogden_Stonehealer_Tonic = 36440
Global Const $ITEM_ID_EL_Vekk_Tonic = 36441
Global Const $ITEM_ID_EL_Gwen_Tonic = 36442
Global Const $ITEM_ID_EL_Xandra_Tonic = 36443
Global Const $ITEM_ID_EL_Kahmu_Tonic = 36444

Global Const $ITEM_ID_EL_Pyre_Fiercehot_Tonic = 36446
Global Const $ITEM_ID_EL_Anton_Tonic = 36447
Global Const $ITEM_ID_EL_Hayda_Tonic = 36448
Global Const $ITEM_ID_EL_Livia_Tonic = 36449
Global Const $ITEM_ID_EL_Keiran_Thackeray_Tonic = 36450
Global Const $ITEM_ID_EL_Miku_Tonic = 36451
Global Const $ITEM_ID_EL_MOX_Tonic = 36452
Global Const $ITEM_ID_EL_Shiro_Tonic = 36453

Global Const $ITEM_ID_EL_Jora_Tonic = 36455
Global Const $ITEM_ID_EL_Prince_Rurik_Tonic = 36455

Global Const $ITEM_ID_EL_Margonite_Tonic = 36456
Global Const $ITEM_ID_EL_Destroyer_Tonic = 36457
Global Const $ITEM_ID_EL_Queen_Salma_Tonic = 36458

Global Const $ITEM_ID_EL_Slightly_Mad_King_Tonic = 36460
Global Const $ITEM_ID_EL_Kuunavang_Tonic = 36461
Global Const $ITEM_ID_EL_Guild_Lord_Tonic = 36652
Global Const $ITEM_ID_EL_Avatar_of_Balthazar_Tonic = 36658
Global Const $ITEM_ID_EL_Priest_of_Balthazar_Tonic = 36659
Global Const $ITEM_ID_EL_Ghostly_Hero_Tonic = 36660
Global Const $ITEM_ID_EL_Balthazars_Champion_Tonic = 36661
Global Const $ITEM_ID_EL_Ghostly_Priest_Tonic = 36663
Global Const $ITEM_ID_EL_Flame_Sentinel_Tonic = 36664
#EndRegion EL Tonics
#EndRegion Tonics

#Region Minis
; ==== First year ====
Global Const $ITEM_ID_Prince_Rurik_Mini = 13790
Global Const $ITEM_ID_Shiro_Mini = 13791
Global Const $ITEM_ID_Charr_Shaman_Mini = 13784
Global Const $ITEM_ID_Fungal_Wallow_Mini = 13782
Global Const $ITEM_ID_Bone_Dragon_Mini = 13783
Global Const $ITEM_ID_Hydra_Mini = 13787
Global Const $ITEM_ID_Jade_Armor_Mini = 13788
Global Const $ITEM_ID_Kirin_Mini = 13789
Global Const $ITEM_ID_Jungle_Troll_Mini = 13794
Global Const $ITEM_ID_Necrid_Horseman_Mini = 13786
Global Const $ITEM_ID_Temple_Guardian_Mini = 13792
Global Const $ITEM_ID_Burning_Titan_Mini = 13793
Global Const $ITEM_ID_Siege_Turtle_Mini = 13795
Global Const $ITEM_ID_Whiptail_Devourer_Mini = 13785
; ==== Second year ====
Global Const $ITEM_ID_Gwen_Mini = 22753
Global Const $ITEM_ID_Water_Djinn_Mini = 22754
Global Const $ITEM_ID_Lich_Mini = 22755
Global Const $ITEM_ID_Elf_Mini = 22756
Global Const $ITEM_ID_Palawa_Joko_Mini = 22757
Global Const $ITEM_ID_Koss_Mini = 22758
Global Const $ITEM_ID_Aatxe_Mini = 22765
Global Const $ITEM_ID_Harpy_Ranger_Mini = 22761
Global Const $ITEM_ID_Heket_Warrior_Mini = 22760
Global Const $ITEM_ID_Juggernaut_Mini = 22762
Global Const $ITEM_ID_Mandragor_Imp_Mini = 22759
Global Const $ITEM_ID_Thorn_Wolf_Mini = 22766
Global Const $ITEM_ID_Wind_Rider_Mini = 22763
Global Const $ITEM_ID_Fire_Imp_Mini = 22764
; ==== Third year ====
Global Const $ITEM_ID_Black_Beast_of_Aaaaarrrrrrggghhh_Mini = 30611
Global Const $ITEM_ID_Irukandji_Mini = 30613
Global Const $ITEM_ID_Mad_King_Thorn_Mini = 30614
Global Const $ITEM_ID_Raptor_Mini = 30619
Global Const $ITEM_ID_Cloudtouched_Simian_Mini = 30621
Global Const $ITEM_ID_White_Rabbit_Mini = 30623
Global Const $ITEM_ID_Freezie_Mini = 30612
Global Const $ITEM_ID_Nornbear_Mini = 32519
Global Const $ITEM_ID_Ooze_Mini = 30618
Global Const $ITEM_ID_Abyssal_Mini = 30610
Global Const $ITEM_ID_Cave_Spider_Mini = 30622
Global Const $ITEM_ID_Forest_Minotaur_Mini = 30615
Global Const $ITEM_ID_Mursaat_Mini = 30616
Global Const $ITEM_ID_Roaring_Ether_Mini = 30620
; ==== Fourth year ====
Global Const $ITEM_ID_Eye_of_Janthir_Mini = 32529
Global Const $ITEM_ID_Dredge_Brute_Mini = 32517
Global Const $ITEM_ID_Terrorweb_Dryder_Mini = 32518
Global Const $ITEM_ID_Abomination_Mini = 32519
Global Const $ITEM_ID_Flame_Djinn_Mini = 32528
Global Const $ITEM_ID_Flowstone_Elemental_Mini = 32525
Global Const $ITEM_ID_Nian_Mini = 32526
Global Const $ITEM_ID_Dagnar_Stonepate_Mini = 32527
Global Const $ITEM_ID_Jora_Mini = 32524
Global Const $ITEM_ID_Desert_Griffon_Mini = 32521
Global Const $ITEM_ID_Krait_Neoss_Mini = 32520
Global Const $ITEM_ID_Kveldulf_Mini = 32522
Global Const $ITEM_ID_Quetzal_Sly_Mini = 32523
Global Const $ITEM_ID_Word_of_Madness_Mini = 32516
; ==== Fifth year ====
Global Const $ITEM_ID_MOX_Mini = 34400
Global Const $ITEM_ID_Ventari_Mini = 34395
Global Const $ITEM_ID_Oola_Mini = 34396
Global Const $ITEM_ID_Candysmith_Marley_Mini = 34397
Global Const $ITEM_ID_Zhu_Hanuku_Mini = 34398
Global Const $ITEM_ID_King_Adelbern_Mini = 34399
Global Const $ITEM_ID_Cobalt_Scabara_Mini = 34393
Global Const $ITEM_ID_Fire_Drake_Mini = 34390
Global Const $ITEM_ID_Ophil_Nahualli_Mini = 34392
Global Const $ITEM_ID_Scourge_Manta_Mini = 34394
Global Const $ITEM_ID_Seer_Mini = 34386
Global Const $ITEM_ID_Shard_Wolf_Mini = 34389
Global Const $ITEM_ID_Siege_Devourer = 34387
Global Const $ITEM_ID_Summit_Giant_Herder = 34391
; ==== Seventh ====
Global Const $ITEM_ID_Vizu_Mini = 22196
Global Const $ITEM_ID_Shiroken_Assassin_Mini = 22195
Global Const $ITEM_ID_Zhed_Shadowhoof_Mini = 22197
Global Const $ITEM_ID_Naga_Raincaller_Mini = 15515
Global Const $ITEM_ID_Oni_Mini = 15516
; ==== Collector's Edition ====
Global Const $ITEM_ID_Kuunavang_Mini = 12389
Global Const $ITEM_ID_Varesh_Ossa_Mini = 21069
; ==== In-Game Reward ====
Global Const $ITEM_ID_Mallyx_Mini = 21229
Global Const $ITEM_ID_Black_Moa_Chick_Mini = 25499
Global Const $ITEM_ID_Gwen_Doll_Mini = 31157
Global Const $ITEM_ID_Yakkington_Mini = 32515
Global Const $ITEM_ID_Brown_Rabbit_Mini = 31158
Global Const $ITEM_ID_Ghostly_Hero_Mini = 16460
Global Const $ITEM_ID_Minister_Reiko_Mini = 30224
Global Const $ITEM_ID_Ecclesiate_Xun_Rao_Mini = 30225
;Global Const $ITEM_ID_Peacekeeper_Enforcer_Mini =
Global Const $ITEM_ID_Evennia_Mini = 35128
Global Const $ITEM_ID_Livia_Mini = 35129
Global Const $ITEM_ID_Princess_Salma_Mini = 35130
Global Const $ITEM_ID_Confessor_Dorian_Mini = 35132
Global Const $ITEM_ID_Confessor_Isaiah_Mini = 35131
Global Const $ITEM_ID_Guild_Lord_Mini = 36648
Global Const $ITEM_ID_Ghostly_Priest_Mini = 36650
Global Const $ITEM_ID_Rift_Warden_Mini = 36651
Global Const $ITEM_ID_High_Priest_Zhang_Mini = 36649
Global Const $ITEM_ID_Dhuum_Mini = 32822
Global Const $ITEM_ID_Smite_Crawler_Mini = 32556
; ==== Special Event Minis ====
;Global Const $ITEM_ID_Greased_Lightning_Mini =
Global Const $ITEM_ID_Pig_Mini = 21806
Global Const $ITEM_ID_Celestial_Pig_Mini = 29412
Global Const $ITEM_ID_Celestial_Rat_Mini = 29413
Global Const $ITEM_ID_Celestial_Ox_Mini = 29414
Global Const $ITEM_ID_Celestial_Tiger_Mini = 29415
Global Const $ITEM_ID_Celestial_Rabbit_Mini = 29416
Global Const $ITEM_ID_Celestial_Dragon_Mini = 29417
Global Const $ITEM_ID_Celestial_Snake_Mini = 29418
Global Const $ITEM_ID_Celestial_Horse_Mini = 29419
Global Const $ITEM_ID_Celestial_Sheep_Mini = 29420
Global Const $ITEM_ID_Celestial_Monkey_Mini = 29421
Global Const $ITEM_ID_Celestial_Rooster_Mini = 29422
Global Const $ITEM_ID_Celestial_Dog_Mini = 29423
Global Const $ITEM_ID_World_Famous_Racing_Beetle_Mini = 37792
;Global Const $ITEM_ID_Legionnaire_Mini =
Global Const $ITEM_ID_Polar_Bear_Mini = 21439
; ==== Promotional ====
Global Const $ITEM_ID_Asura_Mini = 22189
Global Const $ITEM_ID_Destroyer_of_Flesh_Mini = 22250
Global Const $ITEM_ID_Gray_Giant_Mini = 17053
Global Const $ITEM_ID_Grawl_Mini = 22822
Global Const $ITEM_ID_Ceratadon_Mini = 28416
; ==== Miscellaneous ====
;Global Const $ITEM_ID_Kanaxai_Mini =
Global Const $ITEM_ID_Polar_Bear_Mini = 21439
Global Const $ITEM_ID_Mad_Kings_Guard_Mini = 32555
Global Const $ITEM_ID_Panda_Mini = 15517
;Global Const $ITEM_ID_Longhair_Yeti_Mini =
#EndRegion Minis

#Region Weapon Mods
Global $Weapon_Mod_Array[25] = [893, 894, 895, 896, 897, 905, 906, 907, 908, 909, 6323, 6331, 15540, 15541, 15542, 15543, 15544, 15551, 15552, 15553, 15554, 15555, 17059, 19122, 19123]
Global Const $ITEM_ID_Staff_Head = 896
Global Const $ITEM_ID_Staff_Wrapping = 908
Global Const $ITEM_ID_Shield_Handle = 15554
Global Const $ITEM_ID_Focus_Core = 15551
Global Const $ITEM_ID_Wand = 15552
Global Const $ITEM_ID_Bow_String = 894
Global Const $ITEM_ID_Bow_Grip = 906
Global Const $ITEM_ID_Sword_Hilt = 897
Global Const $ITEM_ID_Sword_Pommel = 909
Global Const $ITEM_ID_Axe_Haft = 893
Global Const $ITEM_ID_Axe_Grip = 905
Global Const $ITEM_ID_Dagger_Tang = 6323
Global Const $ITEM_ID_Dagger_Handle = 6331
Global Const $ITEM_ID_Hammer_Haft = 895
Global Const $ITEM_ID_Hammer_Grip = 907
Global Const $ITEM_ID_Scythe_Snathe = 15543
Global Const $ITEM_ID_Scythe_Grip = 15553
Global Const $ITEM_ID_Spearhead = 15544
Global Const $ITEM_ID_Spear_Grip = 15555
Global Const $ITEM_ID_Inscriptions_Martial = 15540
Global Const $ITEM_ID_Inscriptions_Focus_Shield = 15541
Global Const $ITEM_ID_Inscriptions_All = 15542
Global Const $ITEM_ID_Inscriptions_General = 17059
Global Const $ITEM_ID_Inscriptions_Spellcasting = 19122
Global Const $ITEM_ID_Inscriptions_Focus_Items = 19123
#EndRegion Weapon Mods

#Region Envoy Weapons
;Envoy Skinned Greens
; Green Envoys
Global Const $ITEM_ID_Demrikovs_Judgement = 36670
Global Const $ITEM_ID_Vetauras_Harbinger = 36678
Global Const $ITEM_ID_Torivos_Rage = 36680
Global Const $ITEM_ID_Heleynes_Insight = 36676
; Gold Envoys
;Global Const $ITEM_ID_Envoy_Sword =
Global Const $ITEM_ID_Envoy_Scythe = 36677
;Global Const $ITEM_ID_Envoy_Axe =
;Global Const $ITEM_ID_Chaotic_Envoy_Staff =
;Global Const $ITEM_ID_Dark_Envoy_Staff =
;Global Const $ITEM_ID_Elemental_Envoy_Staff =
;Global Const $ITEM_ID_Divine_Envoy_Staff =
;Global Const $ITEM_ID_Spiritual_Envoy_Staff =
#EndRegion Envoy Weapons

#Region Froggy
Global Const $ITEM_ID_Froggy_Domination = 1953
Global Const $ITEM_ID_Froggy_Fast_Casting = 1956
Global Const $ITEM_ID_Froggy_Illusion = 1957
Global Const $ITEM_ID_Froggy_Inspiration = 1958
Global Const $ITEM_ID_Froggy_Soul_Reaping = 1959
Global Const $ITEM_ID_Froggy_Blood = 1960
Global Const $ITEM_ID_Froggy_Curses = 1961
Global Const $ITEM_ID_Froggy_Death = 1962
Global Const $ITEM_ID_Froggy_Air = 1963
Global Const $ITEM_ID_Froggy_Earth = 1964
Global Const $ITEM_ID_Froggy_Energy_Storage = 1965
Global Const $ITEM_ID_Froggy_Fire = 1966
Global Const $ITEM_ID_Froggy_Water = 1967
Global Const $ITEM_ID_Froggy_Divine = 1968
Global Const $ITEM_ID_Froggy_Healing = 1969
Global Const $ITEM_ID_Froggy_Protection = 1970
Global Const $ITEM_ID_Froggy_Smiting = 1971
Global Const $ITEM_ID_Froggy_Communing = 1972
Global Const $ITEM_ID_Froggy_Spawning = 1973
Global Const $ITEM_ID_Froggy_Restoration = 1974
Global Const $ITEM_ID_Froggy_Channeling = 1975
#EndRegion Froggy

#Region Bone Dragon Staff
Global Const $ITEM_ID_BDS_Domination = 1987
Global Const $ITEM_ID_BDS_Fast_Casting = 1988
Global Const $ITEM_ID_BDS_Illusion = 1989
Global Const $ITEM_ID_BDS_Inspiration = 1990
Global Const $ITEM_ID_BDS_Soul_Reaping = 1991
Global Const $ITEM_ID_BDS_Blood = 1992
Global Const $ITEM_ID_BDS_Curses = 1993
Global Const $ITEM_ID_BDS_Death = 1994
Global Const $ITEM_ID_BDS_Air = 1995
Global Const $ITEM_ID_BDS_Earth = 1996
Global Const $ITEM_ID_BDS_Energy_Storage = 1997
Global Const $ITEM_ID_BDS_Fire = 1998
Global Const $ITEM_ID_BDS_Water = 1999
Global Const $ITEM_ID_BDS_Divine = 2000
Global Const $ITEM_ID_BDS_Healing = 2001
Global Const $ITEM_ID_BDS_Protection = 2002
Global Const $ITEM_ID_BDS_Smiting = 2003
Global Const $ITEM_ID_BDS_Communing = 2004
Global Const $ITEM_ID_BDS_Spawning = 2005
Global Const $ITEM_ID_BDS_Restoration = 2006
Global Const $ITEM_ID_BDS_Channeling = 2007
#EndRegion Bone Dragon Staff

#Region Wintergreen Weapons
Global Const $ITEM_ID_Wintergreen_Axe = 15835
Global Const $ITEM_ID_Wintergreen_Bow = 15836
Global Const $ITEM_ID_Wintergreen_Sword = 16130
Global Const $ITEM_ID_Wintergreen_Daggers = 15838
Global Const $ITEM_ID_Wintergreen_Hammer = 15839
Global Const $ITEM_ID_Wintergreen_Wand = 15840
Global Const $ITEM_ID_Wintergreen_Scythe = 15877
Global Const $ITEM_ID_Wintergreen_Shield = 15878
Global Const $ITEM_ID_Wintergreen_Spear = 15971
Global Const $ITEM_ID_Wintergreen_Staff =16128
#EndRegion Wintergreen Weapons

#Region Celestial Compass
Global Const $ITEM_ID_CC_Domination = 1055
Global Const $ITEM_ID_CC_Fast_Casting = 1058
Global Const $ITEM_ID_CC_Illusion = 1060
Global Const $ITEM_ID_CC_Inspiration = 1064
Global Const $ITEM_ID_CC_Soul_Reaping = 1752
Global Const $ITEM_ID_CC_Blood = 1065
Global Const $ITEM_ID_CC_Curses = 1066
Global Const $ITEM_ID_CC_Death = 1067
Global Const $ITEM_ID_CC_Air = 1768
Global Const $ITEM_ID_CC_Earth = 1769
Global Const $ITEM_ID_CC_Energy_Storage = 1770
Global Const $ITEM_ID_CC_Fire = 1771
Global Const $ITEM_ID_CC_Water = 1772
Global Const $ITEM_ID_CC_Divine = 1773
Global Const $ITEM_ID_CC_Healing = 1870
Global Const $ITEM_ID_CC_Protection = 1879
Global Const $ITEM_ID_CC_Smiting = 1880
Global Const $ITEM_ID_CC_Communing = 1881
Global Const $ITEM_ID_CC_Spawning = 1883
Global Const $ITEM_ID_CC_Restoration = 1884
Global Const $ITEM_ID_CC_Channeling = 1885
#EndRegion Celestial Compass

#EndRegion Global Items