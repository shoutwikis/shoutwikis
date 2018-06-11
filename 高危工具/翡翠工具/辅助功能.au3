#include-once
#RequireAdmin
#include "../../激战接口.au3"
#Region Map_IDs
Global $MAP_ID[860]
$MAP_ID[0] = 859
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
$MAP_ID[297] = "Unwaking Waters Luxon"
$MAP_ID[298] = "Unwaking Waters Kurzick"
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
$MAP_ID[487] = "Beknur Harbor"
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
$MAP_ID[815] = "Shing Jea Monastery - Dragon Festival"
$MAP_ID[816] = "Shing Jea Monastery - Canthan New Year"
;~ $MAP_ID[817] = "Kaineng Center = 817
$MAP_ID[818] = "Kamadan Jewel of Istan - Halloween"
$MAP_ID[819] = "Kamadan Jewel of Istan - Wintersday"
$MAP_ID[820] = "Kamadan Jewel of Istan - Canthan New Year"
$MAP_ID[821] = "Eye of the North outpost - Wintersday"
$MAP_ID[857] = "Embark Beach"
#EndRegion Map_IDs
; SKILL TYPES
Global $Stance = 3;
Global $Hex = 4;
Global $Spell = 5;
Global $Enchantment = 6;
Global $Signet = 7;
Global $Condition = 8;
Global $Well = 9;
Global $Skill = 10;
Global $Ward = 11;
Global $Glyph = 12;
Global $Attack = 14;
Global $Shout = 15;
Global $Preparation = 19;
Global $Trap = 21;
Global $Ritual = 22;
Global $ItemSpell = 24;
Global $WeaponSpell = 25;
Global $Chant = 27;
Global $EchoRefrain = 28;
Global $Disguise = 29;

; PROFESSIONS
Global $None = 0
Global $Warrior = 1
Global $Ranger = 2
Global $Monk = 3
Global $Necromancer = 4
Global $Mesmer = 5
Global $Elementalist = 6
Global $Assassin = 7
Global $Ritualist = 8
Global $Paragon = 9
Global $Dervish = 10

; ATTRIBUTES
Global $Fast_Casting = 0;
Global $Illusion_Magic = 1;
Global $Domination_Magic = 2;
Global $Inspiration_Magic = 3;
Global $Blood_Magic = 4;
Global $Death_Magic = 5;
Global $Soul_Reaping = 6;
Global $Curses = 7;
Global $Air_Magic = 8;
Global $Earth_Magic = 9;
Global $Fire_Magic = 10;
Global $Water_Magic = 11;
Global $Energy_Storage = 12;
Global $Healing_Prayers = 13;
Global $Smiting_Prayers = 14;
Global $Protection_Prayers = 15;
Global $Divine_Favor = 16;
Global $Strength = 17;
Global $Axe_Mastery = 18;
Global $Hammer_Mastery = 19;
Global $Swordsmanship = 20;
Global $Tactics = 21;
Global $Beast_Mastery = 22;
Global $Expertise = 23;
Global $Wilderness_Survival = 24;
Global $Marksmanship = 25;
Global $Dagger_Mastery = 29;
Global $Deadly_Arts = 30;
Global $Shadow_Arts = 31;
Global $Communing = 32;
Global $Restoration_Magic = 33;
Global $Channeling_Magic = 34;
Global $Critical_Strikes = 35;
Global $Spawning_Power = 36;
Global $Spear_Mastery = 37;
Global $Command = 38;
Global $Motivation = 39;
Global $Leadership = 40;
Global $Scythe_Mastery = 41;
Global $Wind_Prayers = 42;
Global $Earth_Prayers = 43;
Global $Mysticism = 44;
Global $AttrID_None = 0xFF

; RANGES
Global $Adjacent = 156
Global $Nearby = 240
Global $Area = 312
Global $Earshot = 1000
Global $Spell_casting = 1085
Global $Spirit = 2500
Global $Compass = 5000

; SKILL TARGETS
Global $target_self = 0
Global $target_none = 0
Global $target_spirit = 1
Global $target_animal = 1
Global $target_corpse = 1
Global $target_ally = 3
Global $target_otherally = 4
Global $target_enemy = 5
Global $target_dead_ally = 6
Global $target_minion = 14
Global $target_ground = 16

;SKILL IDs
Global $No_Skill = 0;
Global $Healing_Signet = 1;
Global $Resurrection_Signet = 2;
Global $Signet_of_Capture = 3;
Global $BAMPH = 4;
Global $Power_Block = 5;
Global $Mantra_of_Earth = 6;
Global $Mantra_of_Flame = 7;
Global $Mantra_of_Frost = 8;
Global $Mantra_of_Lightning = 9;
Global $Hex_Breaker = 10;
Global $Distortion = 11;
Global $Mantra_of_Celerity = 12;
Global $Mantra_of_Recovery = 13;
Global $Mantra_of_Persistence = 14;
Global $Mantra_of_Inscriptions = 15;
Global $Mantra_of_Concentration = 16;
Global $Mantra_of_Resolve = 17;
Global $Mantra_of_Signets = 18;
Global $Fragility = 19;
Global $Confusion = 20;
Global $Inspired_Enchantment = 21;
Global $Inspired_Hex = 22;
Global $Power_Spike = 23;
Global $Power_Leak = 24;
Global $Power_Drain = 25;
Global $Empathy = 26;
Global $Shatter_Delusions = 27;
Global $Backfire = 28;
Global $Blackout = 29;
Global $Diversion = 30;
Global $Conjure_Phantasm = 31;
Global $Illusion_of_Weakness = 32;
Global $Illusionary_Weaponry = 33;
Global $Sympathetic_Visage = 34;
Global $Ignorance = 35;
Global $Arcane_Conundrum = 36;
Global $Illusion_of_Haste = 37;
Global $Channeling = 38;
Global $Energy_Surge = 39;
Global $Ether_Feast = 40;
Global $Ether_Lord = 41;
Global $Energy_Burn = 42;
Global $Clumsiness = 43;
Global $Phantom_Pain = 44;
Global $Ethereal_Burden = 45;
Global $Guilt = 46;
Global $Ineptitude = 47;
Global $Spirit_of_Failure = 48;
Global $Mind_Wrack = 49;
Global $Wastrels_Worry = 50;
Global $Shame = 51;
Global $Panic = 52;
Global $Migraine = 53;
Global $Crippling_Anguish = 54;
Global $Fevered_Dreams = 55;
Global $Soothing_Images = 56;
Global $Cry_of_Frustration = 57;
Global $Signet_of_Midnight = 58;
Global $Signet_of_Weariness = 59;
Global $Signet_of_Illusions_beta_version = 60;
Global $Leech_Signet = 61;
Global $Signet_of_Humility = 62;
Global $Keystone_Signet = 63;
Global $Mimic = 64;
Global $Arcane_Mimicry = 65;
Global $Spirit_Shackles = 66;
Global $Shatter_Hex = 67;
Global $Drain_Enchantment = 68;
Global $Shatter_Enchantment = 69;
Global $Disappear = 70;
Global $Unnatural_Signet_alpha_version = 71;
Global $Elemental_Resistance = 72;
Global $Physical_Resistance = 73;
Global $Echo = 74;
Global $Arcane_Echo = 75;
Global $Imagined_Burden = 76;
Global $Chaos_Storm = 77;
Global $Epidemic = 78;
Global $Energy_Drain = 79;
Global $Energy_Tap = 80;
Global $Arcane_Thievery = 81;
Global $Mantra_of_Recall = 82;
Global $Animate_Bone_Horror = 83;
Global $Animate_Bone_Fiend = 84;
Global $Animate_Bone_Minions = 85;
Global $Grenths_Balance = 86;
Global $Veratas_Gaze = 87;
Global $Veratas_Aura = 88;
Global $Deathly_Chill = 89;
Global $Veratas_Sacrifice = 90;
Global $Well_of_Power = 91;
Global $Well_of_Blood = 92;
Global $Well_of_Suffering = 93;
Global $Well_of_the_Profane = 94;
Global $Putrid_Explosion = 95;
Global $Soul_Feast = 96;
Global $Necrotic_Traversal = 97;
Global $Consume_Corpse = 98;
Global $Parasitic_Bond = 99;
Global $Soul_Barbs = 100;
Global $Barbs = 101;
Global $Shadow_Strike = 102;
Global $Price_of_Failure = 103;
Global $Death_Nova = 104;
Global $Deathly_Swarm = 105;
Global $Rotting_Flesh = 106;
Global $Virulence = 107;
Global $Suffering = 108;
Global $Life_Siphon = 109;
Global $Unholy_Feast = 110;
Global $Awaken_the_Blood = 111;
Global $Desecrate_Enchantments = 112;
Global $Tainted_Flesh = 113;
Global $Aura_of_the_Lich = 114;
Global $Blood_Renewal = 115;
Global $Dark_Aura = 116;
Global $Enfeeble = 117;
Global $Enfeebling_Blood = 118;
Global $Blood_is_Power = 119;
Global $Blood_of_the_Master = 120;
Global $Spiteful_Spirit = 121;
Global $Malign_Intervention = 122;
Global $Insidious_Parasite = 123;
Global $Spinal_Shivers = 124;
Global $Wither = 125;
Global $Life_Transfer = 126;
Global $Mark_of_Subversion = 127;
Global $Soul_Leech = 128;
Global $Defile_Flesh = 129;
Global $Demonic_Flesh = 130;
Global $Barbed_Signet = 131;
Global $Plague_Signet = 132;
Global $Dark_Pact = 133;
Global $Order_of_Pain = 134;
Global $Faintheartedness = 135;
Global $Shadow_of_Fear = 136;
Global $Rigor_Mortis = 137;
Global $Dark_Bond = 138;
Global $Infuse_Condition = 139;
Global $Malaise = 140;
Global $Rend_Enchantments = 141;
Global $Lingering_Curse = 142;
Global $Strip_Enchantment = 143;
Global $Chilblains = 144;
Global $Signet_of_Agony = 145;
Global $Offering_of_Blood = 146;
Global $Dark_Fury = 147;
Global $Order_of_the_Vampire = 148;
Global $Plague_Sending = 149;
Global $Mark_of_Pain = 150;
Global $Feast_of_Corruption = 151;
Global $Taste_of_Death = 152;
Global $Vampiric_Gaze = 153;
Global $Plague_Touch = 154;
Global $Vile_Touch = 155;
Global $Vampiric_Touch = 156;
Global $Blood_Ritual = 157;
Global $Touch_of_Agony = 158;
Global $Weaken_Armor = 159;
Global $Windborne_Speed = 160;
Global $Lightning_Storm = 161;
Global $Gale = 162;
Global $Whirlwind = 163;
Global $Elemental_Attunement = 164;
Global $Armor_of_Earth = 165;
Global $Kinetic_Armor = 166;
Global $Eruption = 167;
Global $Magnetic_Aura = 168;
Global $Earth_Attunement = 169;
Global $Earthquake = 170;
Global $Stoning = 171;
Global $Stone_Daggers = 172;
Global $Grasping_Earth = 173;
Global $Aftershock = 174;
Global $Ward_Against_Elements = 175;
Global $Ward_Against_Melee = 176;
Global $Ward_Against_Foes = 177;
Global $Ether_Prodigy = 178;
Global $Incendiary_Bonds = 179;
Global $Aura_of_Restoration = 180;
Global $Ether_Renewal = 181;
Global $Conjure_Flame = 182;
Global $Inferno = 183;
Global $Fire_Attunement = 184;
Global $Mind_Burn = 185;
Global $Fireball = 186;
Global $Meteor = 187;
Global $Flame_Burst = 188;
Global $Rodgorts_Invocation = 189;
Global $Mark_of_Rodgort = 190;
Global $Immolate = 191;
Global $Meteor_Shower = 192;
Global $Phoenix = 193;
Global $Flare = 194;
Global $Lava_Font = 195;
Global $Searing_Heat = 196;
Global $Fire_Storm = 197;
Global $Glyph_of_Elemental_Power = 198;
Global $Glyph_of_Energy = 199;
Global $Glyph_of_Lesser_Energy = 200;
Global $Glyph_of_Concentration = 201;
Global $Glyph_of_Sacrifice = 202;
Global $Glyph_of_Renewal = 203;
Global $Rust = 204;
Global $Lightning_Surge = 205;
Global $Armor_of_Frost = 206;
Global $Conjure_Frost = 207;
Global $Water_Attunement = 208;
Global $Mind_Freeze = 209;
Global $Ice_Prison = 210;
Global $Ice_Spikes = 211;
Global $Frozen_Burst = 212;
Global $Shard_Storm = 213;
Global $Ice_Spear = 214;
Global $Maelstrom = 215;
Global $Iron_Mist = 216;
Global $Crystal_Wave = 217;
Global $Obsidian_Flesh = 218;
Global $Obsidian_Flame = 219;
Global $Blinding_Flash = 220;
Global $Conjure_Lightning = 221;
Global $Lightning_Strike = 222;
Global $Chain_Lightning = 223;
Global $Enervating_Charge = 224;
Global $Air_Attunement = 225;
Global $Mind_Shock = 226;
Global $Glimmering_Mark = 227;
Global $Thunderclap = 228;
Global $Lightning_Orb = 229;
Global $Lightning_Javelin = 230;
Global $Shock = 231;
Global $Lightning_Touch = 232;
Global $Swirling_Aura = 233;
Global $Deep_Freeze = 234;
Global $Blurred_Vision = 235;
Global $Mist_Form = 236;
Global $Water_Trident = 237;
Global $Armor_of_Mist = 238;
Global $Ward_Against_Harm = 239;
Global $Smite = 240;
Global $Life_Bond = 241;
Global $Balthazars_Spirit = 242;
Global $Strength_of_Honor = 243;
Global $Life_Attunement = 244;
Global $Protective_Spirit = 245;
Global $Divine_Intervention = 246;
Global $Symbol_of_Wrath = 247;
Global $Retribution = 248;
Global $Holy_Wrath = 249;
Global $Essence_Bond = 250;
Global $Scourge_Healing = 251;
Global $Banish = 252;
Global $Scourge_Sacrifice = 253;
Global $Vigorous_Spirit = 254;
Global $Watchful_Spirit = 255;
Global $Blessed_Aura = 256;
Global $Aegis = 257;
Global $Guardian = 258;
Global $Shield_of_Deflection = 259;
Global $Aura_of_Faith = 260;
Global $Shield_of_Regeneration = 261;
Global $Shield_of_Judgment = 262;
Global $Protective_Bond = 263;
Global $Pacifism = 264;
Global $Amity = 265;
Global $Peace_and_Harmony = 266;
Global $Judges_Insight = 267;
Global $Unyielding_Aura = 268;
Global $Mark_of_Protection = 269;
Global $Life_Barrier = 270;
Global $Zealots_Fire = 271;
Global $Balthazars_Aura = 272;
Global $Spell_Breaker = 273;
Global $Healing_Seed = 274;
Global $Mend_Condition = 275;
Global $Restore_Condition = 276;
Global $Mend_Ailment = 277;
Global $Purge_Conditions = 278;
Global $Divine_Healing = 279;
Global $Heal_Area = 280;
Global $Orison_of_Healing = 281;
Global $Word_of_Healing = 282;
Global $Dwaynas_Kiss = 283;
Global $Divine_Boon = 284;
Global $Healing_Hands = 285;
Global $Heal_Other = 286;
Global $Heal_Party = 287;
Global $Healing_Breeze = 288;
Global $Vital_Blessing = 289;
Global $Mending = 290;
Global $Live_Vicariously = 291;
Global $Infuse_Health = 292;
Global $Signet_of_Devotion = 293;
Global $Signet_of_Judgment = 294;
Global $Purge_Signet = 295;
Global $Bane_Signet = 296;
Global $Blessed_Signet = 297;
Global $Martyr = 298;
Global $Shielding_Hands = 299;
Global $Contemplation_of_Purity = 300;
Global $Remove_Hex = 301;
Global $Smite_Hex = 302;
Global $Convert_Hexes = 303;
Global $Light_of_Dwayna = 304;
Global $Resurrect = 305;
Global $Rebirth = 306;
Global $Reversal_of_Fortune = 307;
Global $Succor = 308;
Global $Holy_Veil = 309;
Global $Divine_Spirit = 310;
Global $Draw_Conditions = 311;
Global $Holy_Strike = 312;
Global $Healing_Touch = 313;
Global $Restore_Life = 314;
Global $Vengeance = 315;
Global $To_the_Limit = 316;
Global $Battle_Rage = 317;
Global $Defy_Pain = 318;
Global $Rush = 319;
Global $Hamstring = 320;
Global $Wild_Blow = 321;
Global $Power_Attack = 322;
Global $Desperation_Blow = 323;
Global $Thrill_of_Victory = 324;
Global $Distracting_Blow = 325;
Global $Protectors_Strike = 326;
Global $Griffons_Sweep = 327;
Global $Pure_Strike = 328;
Global $Skull_Crack = 329;
Global $Cyclone_Axe = 330;
Global $Hammer_Bash = 331;
Global $Bulls_Strike = 332;
Global $I_Will_Avenge_You = 333;
Global $Axe_Rake = 334;
Global $Cleave = 335;
Global $Executioners_Strike = 336;
Global $Dismember = 337;
Global $Eviscerate = 338;
Global $Penetrating_Blow = 339;
Global $Disrupting_Chop = 340;
Global $Swift_Chop = 341;
Global $Axe_Twist = 342;
Global $For_Great_Justice = 343;
Global $Flurry = 344;
Global $Defensive_Stance = 345;
Global $Frenzy = 346;
Global $Endure_Pain = 347;
Global $Watch_Yourself = 348;
Global $Sprint = 349;
Global $Belly_Smash = 350;
Global $Mighty_Blow = 351;
Global $Crushing_Blow = 352;
Global $Crude_Swing = 353;
Global $Earth_Shaker = 354;
Global $Devastating_Hammer = 355;
Global $Irresistible_Blow = 356;
Global $Counter_Blow = 357;
Global $Backbreaker = 358;
Global $Heavy_Blow = 359;
Global $Staggering_Blow = 360;
Global $Dolyak_Signet = 361;
Global $Warriors_Cunning = 362;
Global $Shield_Bash = 363;
Global $Charge = 364;
Global $Victory_is_Mine = 365;
Global $Fear_Me = 366;
Global $Shields_Up = 367;
Global $I_Will_Survive = 368;
Global $Dont_Believe_Their_Lies = 369;
Global $Berserker_Stance = 370;
Global $Balanced_Stance = 371;
Global $Gladiators_Defense = 372;
Global $Deflect_Arrows = 373;
Global $Warriors_Endurance = 374;
Global $Dwarven_Battle_Stance = 375;
Global $Disciplined_Stance = 376;
Global $Wary_Stance = 377;
Global $Shield_Stance = 378;
Global $Bulls_Charge = 379;
Global $Bonettis_Defense = 380;
Global $Hundred_Blades = 381;
Global $Sever_Artery = 382;
Global $Galrath_Slash = 383;
Global $Gash = 384;
Global $Final_Thrust = 385;
Global $Seeking_Blade = 386;
Global $Riposte = 387;
Global $Deadly_Riposte = 388;
Global $Flourish = 389;
Global $Savage_Slash = 390;
Global $Hunters_Shot = 391;
Global $Pin_Down = 392;
Global $Crippling_Shot = 393;
Global $Power_Shot = 394;
Global $Barrage = 395;
Global $Dual_Shot = 396;
Global $Quick_Shot = 397;
Global $Penetrating_Attack = 398;
Global $Distracting_Shot = 399;
Global $Precision_Shot = 400;
Global $Splinter_Shot_monster_skill = 401;
Global $Determined_Shot = 402;
Global $Called_Shot = 403;
Global $Poison_Arrow = 404;
Global $Oath_Shot = 405;
Global $Debilitating_Shot = 406;
Global $Point_Blank_Shot = 407;
Global $Concussion_Shot = 408;
Global $Punishing_Shot = 409;
Global $Call_of_Ferocity = 410;
Global $Charm_Animal = 411;
Global $Call_of_Protection = 412;
Global $Call_of_Elemental_Protection = 413;
Global $Call_of_Vitality = 414;
Global $Call_of_Haste = 415;
Global $Call_of_Healing = 416;
Global $Call_of_Resilience = 417;
Global $Call_of_Feeding = 418;
Global $Call_of_the_Hunter = 419;
Global $Call_of_Brutality = 420;
Global $Call_of_Disruption = 421;
Global $Revive_Animal = 422;
Global $Symbiotic_Bond = 423;
Global $Throw_Dirt = 424;
Global $Dodge = 425;
Global $Savage_Shot = 426;
Global $Antidote_Signet = 427;
Global $Incendiary_Arrows = 428;
Global $Melandrus_Arrows = 429;
Global $Marksmans_Wager = 430;
Global $Ignite_Arrows = 431;
Global $Read_the_Wind = 432;
Global $Kindle_Arrows = 433;
Global $Choking_Gas = 434;
Global $Apply_Poison = 435;
Global $Comfort_Animal = 436;
Global $Bestial_Pounce = 437;
Global $Maiming_Strike = 438;
Global $Feral_Lunge = 439;
Global $Scavenger_Strike = 440;
Global $Melandrus_Assault = 441;
Global $Ferocious_Strike = 442;
Global $Predators_Pounce = 443;
Global $Brutal_Strike = 444;
Global $Disrupting_Lunge = 445;
Global $Troll_Unguent = 446;
Global $Otyughs_Cry = 447;
Global $Escape = 448;
Global $Practiced_Stance = 449;
Global $Whirling_Defense = 450;
Global $Melandrus_Resilience = 451;
Global $Dryders_Defenses = 452;
Global $Lightning_Reflexes = 453;
Global $Tigers_Fury = 454;
Global $Storm_Chaser = 455;
Global $Serpents_Quickness = 456;
Global $Dust_Trap = 457;
Global $Barbed_Trap = 458;
Global $Flame_Trap = 459;
Global $Healing_Spring = 460;
Global $Spike_Trap = 461;
Global $Winter = 462;
Global $Winnowing = 463;
Global $Edge_of_Extinction = 464;
Global $Greater_Conflagration = 465;
Global $Conflagration = 466;
Global $Fertile_Season = 467;
Global $Symbiosis = 468;
Global $Primal_Echoes = 469;
Global $Predatory_Season = 470;
Global $Frozen_Soil = 471;
Global $Favorable_Winds = 472;
Global $High_Winds = 473;
Global $Energizing_Wind = 474;
Global $Quickening_Zephyr = 475;
Global $Natures_Renewal = 476;
Global $Muddy_Terrain = 477;
Global $Bleeding = 478;
Global $Blind = 479;
Global $Burning = 480;
Global $Crippled = 481;
Global $Deep_Wound = 482;
Global $Disease = 483;
Global $Poison = 484;
Global $Dazed = 485;
Global $Weakness = 486;
Global $Cleansed = 487;
Global $Eruption_environment = 488;
Global $Fire_Storm_environment = 489;
Global $Fount_Of_Maguuma = 491;
Global $Healing_Fountain = 492;
Global $Icy_Ground = 493;
Global $Maelstrom_environment = 494;
Global $Mursaat_Tower_skill = 495;
Global $Quicksand_environment_effect = 496;
Global $Curse_of_the_Bloodstone = 497;
Global $Chain_Lightning_environment = 498;
Global $Obelisk_Lightning = 499;
Global $Tar = 500;
Global $Siege_Attack = 501;
Global $Scepter_of_Orrs_Aura = 503;
Global $Scepter_of_Orrs_Power = 504;
Global $Burden_Totem = 505;
Global $Splinter_Mine_skill = 506;
Global $Entanglement = 507;
Global $Dwarven_Powder_Keg = 508;
Global $Seed_of_Resurrection = 509;
Global $Deafening_Roar = 510;
Global $Brutal_Mauling = 511;
Global $Crippling_Attack = 512;
Global $Breaking_Charm = 514;
Global $Charr_Buff = 515;
Global $Claim_Resource = 516;
Global $Dozen_Shot = 524;
Global $Nibble = 525;
Global $Reflection = 528;
Global $Giant_Stomp = 530;
Global $Agnars_Rage = 531;
Global $Crystal_Haze = 533;
Global $Crystal_Bonds = 534;
Global $Jagged_Crystal_Skin = 535;
Global $Crystal_Hibernation = 536;
Global $Hunger_of_the_Lich = 539;
Global $Embrace_the_Pain = 540;
Global $Life_Vortex = 541;
Global $Oracle_Link = 542;
Global $Guardian_Pacify = 543;
Global $Soul_Vortex = 544;
Global $Spectral_Agony = 546;
Global $Undead_sensitivity_to_Light = 554;
Global $Titans_get_plus_Health_regen_and_set_enemies_on_fire_each_time_he_is_hit = 558;
Global $Resurrect_Resurrect_Gargoyle = 560;
Global $Wurm_Siege = 563;
Global $Shiver_Touch = 566;
Global $Spontaneous_Combustion = 567;
Global $Vanish = 568;
Global $Victory_or_Death = 569;
Global $Mark_of_Insecurity = 570;
Global $Disrupting_Dagger = 571;
Global $Deadly_Paradox = 572;
Global $Holy_Blessing = 575;
Global $Statues_Blessing = 576;
Global $Domain_of_Energy_Draining = 580;
Global $Domain_of_Health_Draining = 582;
Global $Domain_of_Slow = 583;
Global $Divine_Fire = 584;
Global $Swamp_Water = 585;
Global $Janthirs_Gaze = 586;
Global $Stormcaller_skill = 589;
Global $Knock = 590;
Global $Blessing_of_the_Kurzicks = 593;
Global $Chimera_of_Intensity = 596;
Global $Life_Stealing_effect = 657;
Global $Jaundiced_Gaze = 763;
Global $Wail_of_Doom = 764;
Global $Heros_Insight = 765;
Global $Gaze_of_Contempt = 766;
Global $Berserkers_Insight = 767;
Global $Slayers_Insight = 768;
Global $Vipers_Defense = 769;
Global $Return = 770;
Global $Aura_of_Displacement = 771;
Global $Generous_Was_Tsungrai = 772;
Global $Mighty_Was_Vorizun = 773;
Global $To_the_Death = 774;
Global $Death_Blossom = 775;
Global $Twisting_Fangs = 776;
Global $Horns_of_the_Ox = 777;
Global $Falling_Spider = 778;
Global $Black_Lotus_Strike = 779;
Global $Fox_Fangs = 780;
Global $Moebius_Strike = 781;
Global $Jagged_Strike = 782;
Global $Unsuspecting_Strike = 783;
Global $Entangling_Asp = 784;
Global $Mark_of_Death = 785;
Global $Iron_Palm = 786;
Global $Resilient_Weapon = 787;
Global $Blind_Was_Mingson = 788;
Global $Grasping_Was_Kuurong = 789;
Global $Vengeful_Was_Khanhei = 790;
Global $Flesh_of_My_Flesh = 791;
Global $Splinter_Weapon = 792;
Global $Weapon_of_Warding = 793;
Global $Wailing_Weapon = 794;
Global $Nightmare_Weapon = 795;
Global $Sorrows_Flame = 796;
Global $Sorrows_Fist = 797;
Global $Blast_Furnace = 798;
Global $Beguiling_Haze = 799;
Global $Enduring_Toxin = 800;
Global $Shroud_of_Silence = 801;
Global $Expose_Defenses = 802;
Global $Power_Leech = 803;
Global $Arcane_Languor = 804;
Global $Animate_Vampiric_Horror = 805;
Global $Cultists_Fervor = 806;
Global $Reapers_Mark = 808;
Global $Shatterstone = 809;
Global $Protectors_Defense = 810;
Global $Run_as_One = 811;
Global $Defiant_Was_Xinrae = 812;
Global $Lyssas_Aura = 813;
Global $Shadow_Refuge = 814;
Global $Scorpion_Wire = 815;
Global $Mirrored_Stance = 816;
Global $Discord = 817;
Global $Well_of_Weariness = 818;
Global $Vampiric_Spirit = 819;
Global $Depravity = 820;
Global $Icy_Veins = 821;
Global $Weaken_Knees = 822;
Global $Burning_Speed = 823;
Global $Lava_Arrows = 824;
Global $Bed_of_Coals = 825;
Global $Shadow_Form = 826;
Global $Siphon_Strength = 827;
Global $Vile_Miasma = 828;
Global $Ray_of_Judgment = 830;
Global $Primal_Rage = 831;
Global $Animate_Flesh_Golem = 832;
Global $Reckless_Haste = 834;
Global $Blood_Bond = 835;
Global $Ride_the_Lightning = 836;
Global $Energy_Boon = 837;
Global $Dwaynas_Sorrow = 838;
Global $Retreat = 839;
Global $Poisoned_Heart = 840;
Global $Fetid_Ground = 841;
Global $Arc_Lightning = 842;
Global $Gust = 843;
Global $Churning_Earth = 844;
Global $Liquid_Flame = 845;
Global $Steam = 846;
Global $Boon_Signet = 847;
Global $Reverse_Hex = 848;
Global $Lacerating_Chop = 849;
Global $Fierce_Blow = 850;
Global $Sun_and_Moon_Slash = 851;
Global $Splinter_Shot = 852;
Global $Melandrus_Shot = 853;
Global $Snare = 854;
Global $Kilroy_Stonekin = 856;
Global $Adventurers_Insight = 857;
Global $Dancing_Daggers = 858;
Global $Conjure_Nightmare = 859;
Global $Signet_of_Disruption = 860;
Global $Ravenous_Gaze = 862;
Global $Order_of_Apostasy = 863;
Global $Oppressive_Gaze = 864;
Global $Lightning_Hammer = 865;
Global $Vapor_Blade = 866;
Global $Healing_Light = 867;
Global $Coward = 869;
Global $Pestilence = 870;
Global $Shadowsong = 871;
Global $Shadowsong_attack = 872;
Global $Resurrect_monster_skill = 873;
Global $Consuming_Flames = 874;
Global $Chains_of_Enslavement = 875;
Global $Signet_of_Shadows = 876;
Global $Lyssas_Balance = 877;
Global $Visions_of_Regret = 878;
Global $Illusion_of_Pain = 879;
Global $Stolen_Speed = 880;
Global $Ether_Signet = 881;
Global $Signet_of_Disenchantment = 882;
Global $Vocal_Minority = 883;
Global $Searing_Flames = 884;
Global $Shield_Guardian = 885;
Global $Restful_Breeze = 886;
Global $Signet_of_Rejuvenation = 887;
Global $Whirling_Axe = 888;
Global $Forceful_Blow = 889;
Global $None_Shall_Pass = 891;
Global $Quivering_Blade = 892;
Global $Seeking_Arrows = 893;
Global $Rampagers_Insight = 894;
Global $Hunters_Insight = 895;
Global $Oath_of_Healing = 897;
Global $Overload = 898;
Global $Images_of_Remorse = 899;
Global $Shared_Burden = 900;
Global $Soul_Bind = 901;
Global $Blood_of_the_Aggressor = 902;
Global $Icy_Prism = 903;
Global $Furious_Axe = 904;
Global $Auspicious_Blow = 905;
Global $On_Your_Knees = 906;
Global $Dragon_Slash = 907;
Global $Marauders_Shot = 908;
Global $Focused_Shot = 909;
Global $Spirit_Rift = 910;
Global $Union = 911;
Global $Tranquil_Was_Tanasen = 913;
Global $Consume_Soul = 914;
Global $Spirit_Light = 915;
Global $Lamentation = 916;
Global $Rupture_Soul = 917;
Global $Spirit_to_Flesh = 918;
Global $Spirit_Burn = 919;
Global $Destruction = 920;
Global $Dissonance = 921;
Global $Dissonance_attack = 922;
Global $Disenchantment = 923;
Global $Disenchantment_attack = 924;
Global $Recall = 925;
Global $Sharpen_Daggers = 926;
Global $Shameful_Fear = 927;
Global $Shadow_Shroud = 928;
Global $Shadow_of_Haste = 929;
Global $Auspicious_Incantation = 930;
Global $Power_Return = 931;
Global $Complicate = 932;
Global $Shatter_Storm = 933;
Global $Unnatural_Signet = 934;
Global $Rising_Bile = 935;
Global $Envenom_Enchantments = 936;
Global $Shockwave = 937;
Global $Ward_of_Stability = 938;
Global $Icy_Shackles = 939;
Global $Blessed_Light = 941;
Global $Withdraw_Hexes = 942;
Global $Extinguish = 943;
Global $Signet_of_Strength = 944;
Global $Trappers_Focus = 946;
Global $Brambles = 947;
Global $Desperate_Strike = 948;
Global $Way_of_the_Fox = 949;
Global $Shadowy_Burden = 950;
Global $Siphon_Speed = 951;
Global $Deaths_Charge = 952;
Global $Power_Flux = 953;
Global $Expel_Hexes = 954;
Global $Rip_Enchantment = 955;
Global $Spell_Shield = 957;
Global $Healing_Whisper = 958;
Global $Ethereal_Light = 959;
Global $Release_Enchantments = 960;
Global $Lacerate = 961;
Global $Spirit_Transfer = 962;
Global $Restoration = 963;
Global $Vengeful_Weapon = 964;
Global $Spear_of_Archemorus = 966;
Global $Argos_Cry = 971;
Global $Jade_Fury = 972;
Global $Blinding_Powder = 973;
Global $Mantis_Touch = 974;
Global $Exhausting_Assault = 975;
Global $Repeating_Strike = 976;
Global $Way_of_the_Lotus = 977;
Global $Mark_of_Instability = 978;
Global $Mistrust = 979;
Global $Feast_of_Souls = 980;
Global $Recuperation = 981;
Global $Shelter = 982;
Global $Weapon_of_Shadow = 983;
Global $Torch_Enchantment = 984;
Global $Caltrops = 985;
Global $Nine_Tail_Strike = 986;
Global $Way_of_the_Empty_Palm = 987;
Global $Temple_Strike = 988;
Global $Golden_Phoenix_Strike = 989;
Global $Expunge_Enchantments = 990;
Global $Deny_Hexes = 991;
Global $Triple_Chop = 992;
Global $Enraged_Smash = 993;
Global $Renewing_Smash = 994;
Global $Tiger_Stance = 995;
Global $Standing_Slash = 996;
Global $Famine = 997;
Global $Torch_Hex = 998;
Global $Torch_Degeneration_Hex = 999;
Global $Blinding_Snow = 1000;
Global $Avalanche_skill = 1001;
Global $Snowball = 1002;
Global $Mega_Snowball = 1003;
Global $Yuletide = 1004;
Global $Ice_Fort = 1006;
Global $Yellow_Snow = 1007;
Global $Hidden_Rock = 1008;
Global $Snow_Down_the_Shirt = 1009;
Global $Mmmm_Snowcone = 1010;
Global $Holiday_Blues = 1011;
Global $Icicles = 1012;
Global $Ice_Breaker = 1013;
Global $Lets_Get_Em = 1014;
Global $Flurry_of_Ice = 1015;
Global $Critical_Eye = 1018;
Global $Critical_Strike = 1019;
Global $Blades_of_Steel = 1020;
Global $Jungle_Strike = 1021;
Global $Wild_Strike = 1022;
Global $Leaping_Mantis_Sting = 1023;
Global $Black_Mantis_Thrust = 1024;
Global $Disrupting_Stab = 1025;
Global $Golden_Lotus_Strike = 1026;
Global $Critical_Defenses = 1027;
Global $Way_of_Perfection = 1028;
Global $Dark_Apostasy = 1029;
Global $Locusts_Fury = 1030;
Global $Shroud_of_Distress = 1031;
Global $Heart_of_Shadow = 1032;
Global $Impale = 1033;
Global $Seeping_Wound = 1034;
Global $Assassins_Promise = 1035;
Global $Signet_of_Malice = 1036;
Global $Dark_Escape = 1037;
Global $Crippling_Dagger = 1038;
Global $Star_Strike = 1039;
Global $Spirit_Walk = 1040;
Global $Unseen_Fury = 1041;
Global $Flashing_Blades = 1042;
Global $Dash = 1043;
Global $Dark_Prison = 1044;
Global $Palm_Strike = 1045;
Global $Assassin_of_Lyssa = 1046;
Global $Mesmer_of_Lyssa = 1047;
Global $Revealed_Enchantment = 1048;
Global $Revealed_Hex = 1049;
Global $Disciple_of_Energy = 1050;
Global $Accumulated_Pain = 1052;
Global $Psychic_Distraction = 1053;
Global $Ancestors_Visage = 1054;
Global $Recurring_Insecurity = 1055;
Global $Kitahs_Burden = 1056;
Global $Psychic_Instability = 1057;
Global $Psychic_Instability_PVP = 3185;
Global $Chaotic_Power = 1058;
Global $Hex_Eater_Signet = 1059;
Global $Celestial_Haste = 1060;
Global $Feedback = 1061;
Global $Arcane_Larceny = 1062;
Global $Chaotic_Ward = 1063;
Global $Favor_of_the_Gods = 1064;
Global $Dark_Aura_blessing = 1065;
Global $Spoil_Victor = 1066;
Global $Lifebane_Strike = 1067;
Global $Bitter_Chill = 1068;
Global $Taste_of_Pain = 1069;
Global $Defile_Enchantments = 1070;
Global $Shivers_of_Dread = 1071;
Global $Star_Servant = 1072;
Global $Necromancer_of_Grenth = 1073;
Global $Ritualist_of_Grenth = 1074;
Global $Vampiric_Swarm = 1075;
Global $Blood_Drinker = 1076;
Global $Vampiric_Bite = 1077;
Global $Wallows_Bite = 1078;
Global $Enfeebling_Touch = 1079;
Global $Disciple_of_Ice = 1080;
Global $Teinais_Wind = 1081;
Global $Shock_Arrow = 1082;
Global $Unsteady_Ground = 1083;
Global $Sliver_Armor = 1084;
Global $Ash_Blast = 1085;
Global $Dragons_Stomp = 1086;
Global $Unnatural_Resistance = 1087;
Global $Second_Wind = 1088;
Global $Cloak_of_Faith = 1089;
Global $Smoldering_Embers = 1090;
Global $Double_Dragon = 1091;
Global $Disciple_of_the_Air = 1092;
Global $Teinais_Heat = 1093;
Global $Breath_of_Fire = 1094;
Global $Star_Burst = 1095;
Global $Glyph_of_Essence = 1096;
Global $Teinais_Prison = 1097;
Global $Mirror_of_Ice = 1098;
Global $Teinais_Crystals = 1099;
Global $Celestial_Storm = 1100;
Global $Monk_of_Dwayna = 1101;
Global $Aura_of_the_Grove = 1102;
Global $Cathedral_Collapse = 1103;
Global $Miasma = 1104;
Global $Acid_Trap = 1105;
Global $Shield_of_Saint_Viktor = 1106;
Global $Urn_of_Saint_Viktor = 1107;
Global $Aura_of_Light = 1112;
Global $Kirins_Wrath = 1113;
Global $Spirit_Bond = 1114;
Global $Air_of_Enchantment = 1115;
Global $Warriors_Might = 1116;
Global $Heavens_Delight = 1117;
Global $Healing_Burst = 1118;
Global $Kareis_Healing_Circle = 1119;
Global $Jameis_Gaze = 1120;
Global $Gift_of_Health = 1121;
Global $Battle_Fervor = 1122;
Global $Life_Sheath = 1123;
Global $Star_Shine = 1124;
Global $Disciple_of_Fire = 1125;
Global $Empathic_Removal = 1126;
Global $Warrior_of_Balthazar = 1127;
Global $Resurrection_Chant = 1128;
Global $Word_of_Censure = 1129;
Global $Spear_of_Light = 1130;
Global $Stonesoul_Strike = 1131;
Global $Shielding_Branches = 1132;
Global $Drunken_Blow = 1133;
Global $Leviathans_Sweep = 1134;
Global $Jaizhenju_Strike = 1135;
Global $Penetrating_Chop = 1136;
Global $Yeti_Smash = 1137;
Global $Disciple_of_the_Earth = 1138;
Global $Ranger_of_Melandru = 1139;
Global $Storm_of_Swords = 1140;
Global $You_Will_Die = 1141;
Global $Auspicious_Parry = 1142;
Global $Strength_of_the_Oak = 1143;
Global $Silverwing_Slash = 1144;
Global $Destroy_Enchantment = 1145;
Global $Shove = 1146;
Global $Base_Defense = 1147;
Global $Carrier_Defense = 1148;
Global $The_Chalice_of_Corruption = 1149;
Global $Song_of_the_Mists = 1151;
Global $Demonic_Agility = 1152;
Global $Blessing_of_the_Kirin = 1153;
Global $Juggernaut_Toss = 1155;
Global $Aura_of_the_Juggernaut = 1156;
Global $Star_Shards = 1157;
Global $Turtle_Shell = 1172;
Global $Blood_of_zu_Heltzer = 1175;
Global $Afflicted_Soul_Explosion = 1176;
Global $Dark_Chain_Lightning = 1179;
Global $Corrupted_Breath = 1181;
Global $Renewing_Corruption = 1182;
Global $Corrupted_Dragon_Spores = 1183;
Global $Corrupted_Dragon_Scales = 1184;
Global $Construct_Possession = 1185;
Global $Siege_Turtle_Attack = 1186;
Global $Of_Royal_Blood = 1189;
Global $Passage_to_Tahnnakai = 1190;
Global $Sundering_Attack = 1191;
Global $Zojuns_Shot = 1192;
Global $Predatory_Bond = 1194;
Global $Heal_as_One = 1195;
Global $Zojuns_Haste = 1196;
Global $Needling_Shot = 1197;
Global $Broad_Head_Arrow = 1198;
Global $Glass_Arrows = 1199;
Global $Archers_Signet = 1200;
Global $Savage_Pounce = 1201;
Global $Enraged_Lunge = 1202;
Global $Bestial_Mauling = 1203;
Global $Energy_Drain_effect = 1204;
Global $Poisonous_Bite = 1205;
Global $Pounce = 1206;
Global $Celestial_Stance = 1207;
Global $Sheer_Exhaustion = 1208;
Global $Bestial_Fury = 1209;
Global $Life_Drain = 1210;
Global $Vipers_Nest = 1211;
Global $Equinox = 1212;
Global $Tranquility = 1213;
Global $Clamor_of_Souls = 1215;
Global $Ritual_Lord = 1217;
Global $Cruel_Was_Daoshen = 1218;
Global $Protective_Was_Kaolai = 1219;
Global $Attuned_Was_Songkai = 1220;
Global $Resilient_Was_Xiko = 1221;
Global $Lively_Was_Naomei = 1222;
Global $Anguished_Was_Lingwah = 1223;
Global $Draw_Spirit = 1224;
Global $Channeled_Strike = 1225;
Global $Spirit_Boon_Strike = 1226;
Global $Essence_Strike = 1227;
Global $Spirit_Siphon = 1228;
Global $Explosive_Growth = 1229;
Global $Boon_of_Creation = 1230;
Global $Spirit_Channeling = 1231;
Global $Armor_of_Unfeeling = 1232;
Global $Soothing_Memories = 1233;
Global $Mend_Body_and_Soul = 1234;
Global $Dulled_Weapon = 1235;
Global $Binding_Chains = 1236;
Global $Painful_Bond = 1237;
Global $Signet_of_Creation = 1238;
Global $Signet_of_Spirits = 1239;
Global $Soul_Twisting = 1240;
Global $Celestial_Summoning = 1241;
Global $Ghostly_Haste = 1244;
Global $Gaze_from_Beyond = 1245;
Global $Ancestors_Rage = 1246;
Global $Pain = 1247;
Global $Pain_attack = 1248;
Global $Displacement = 1249;
Global $Preservation = 1250;
Global $Life = 1251;
Global $Earthbind = 1252;
Global $Bloodsong = 1253;
Global $Bloodsong_attack = 1254;
Global $Wanderlust = 1255;
Global $Wanderlust_attack = 1256;
Global $Spirit_Light_Weapon = 1257;
Global $Brutal_Weapon = 1258;
Global $Guided_Weapon = 1259;
Global $Meekness = 1260;
Global $Frigid_Armor = 1261;
Global $Healing_Ring = 1262;
Global $Renew_Life = 1263;
Global $Doom = 1264;
Global $Wielders_Boon = 1265;
Global $Soothing = 1266;
Global $Vital_Weapon = 1267;
Global $Weapon_of_Quickening = 1268;
Global $Signet_of_Rage = 1269;
Global $Fingers_of_Chaos = 1270;
Global $Echoing_Banishment = 1271;
Global $Suicidal_Impulse = 1272;
Global $Impossible_Odds = 1273;
Global $Battle_Scars = 1274;
Global $Riposting_Shadows = 1275;
Global $Meditation_of_the_Reaper = 1276;
Global $Blessed_Water = 1280;
Global $Defiled_Water = 1281;
Global $Stone_Spores = 1282;
Global $Haiju_Lagoon_Water = 1287;
Global $Aspect_of_Exhaustion = 1288;
Global $Aspect_of_Exposure = 1289;
Global $Aspect_of_Surrender = 1290;
Global $Aspect_of_Death = 1291;
Global $Aspect_of_Soothing = 1292;
Global $Aspect_of_Pain = 1293;
Global $Aspect_of_Lethargy = 1294;
Global $Aspect_of_Depletion_energy_loss = 1295;
Global $Aspect_of_Failure = 1296;
Global $Aspect_of_Shadows = 1297;
Global $Scorpion_Aspect = 1298;
Global $Aspect_of_Fear = 1299;
Global $Aspect_of_Depletion_energy_depletion_damage = 1300;
Global $Aspect_of_Decay = 1301;
Global $Aspect_of_Torment = 1302;
Global $Nightmare_Aspect = 1303;
Global $Spiked_Coral = 1304;
Global $Shielding_Urn = 1305;
Global $Extensive_Plague_Exposure = 1306;
Global $Forests_Binding = 1307;
Global $Exploding_Spores = 1308;
Global $Suicide_Energy = 1309;
Global $Suicide_Health = 1310;
Global $Nightmare_Refuge = 1311;
Global $Rage_of_the_Sea = 1315;
Global $Sugar_Rush = 1323;
Global $Torment_Slash = 1324;
Global $Spirit_of_the_Festival = 1325;
Global $Trade_Winds = 1326;
Global $Dragon_Blast = 1327;
Global $Imperial_Majesty = 1328;
Global $Extend_Conditions = 1333;
Global $Hypochondria = 1334;
Global $Wastrels_Demise = 1335;
Global $Spiritual_Pain = 1336;
Global $Drain_Delusions = 1337;
Global $Persistence_of_Memory = 1338;
Global $Symbols_of_Inspiration = 1339;
Global $Symbolic_Celerity = 1340;
Global $Frustration = 1341;
Global $Tease = 1342;
Global $Ether_Phantom = 1343;
Global $Web_of_Disruption = 1344;
Global $Enchanters_Conundrum = 1345;
Global $Signet_of_Illusions = 1346;
Global $Discharge_Enchantment = 1347;
Global $Hex_Eater_Vortex = 1348;
Global $Mirror_of_Disenchantment = 1349;
Global $Simple_Thievery = 1350;
Global $Animate_Shambling_Horror = 1351;
Global $Order_of_Undeath = 1352;
Global $Putrid_Flesh = 1353;
Global $Feast_for_the_Dead = 1354;
Global $Jagged_Bones = 1355;
Global $Contagion = 1356;
Global $Ulcerous_Lungs = 1358;
Global $Pain_of_Disenchantment = 1359;
Global $Mark_of_Fury = 1360;
Global $Corrupt_Enchantment = 1362;
Global $Signet_of_Sorrow = 1363;
Global $Signet_of_Suffering = 1364;
Global $Signet_of_Lost_Souls = 1365;
Global $Well_of_Darkness = 1366;
Global $Blinding_Surge = 1367;
Global $Chilling_Winds = 1368;
Global $Lightning_Bolt = 1369;
Global $Storm_Djinns_Haste = 1370;
Global $Stone_Striker = 1371;
Global $Sandstorm = 1372;
Global $Stone_Sheath = 1373;
Global $Ebon_Hawk = 1374;
Global $Stoneflesh_Aura = 1375;
Global $Glyph_of_Restoration = 1376;
Global $Ether_Prism = 1377;
Global $Master_of_Magic = 1378;
Global $Glowing_Gaze = 1379;
Global $Savannah_Heat = 1380;
Global $Flame_Djinns_Haste = 1381;
Global $Freezing_Gust = 1382;
Global $Sulfurous_Haze = 1384;
Global $Sentry_Trap_skill = 1386;
Global $Judges_Intervention = 1390;
Global $Supportive_Spirit = 1391;
Global $Watchful_Healing = 1392;
Global $Healers_Boon = 1393;
Global $Healers_Covenant = 1394;
Global $Balthazars_Pendulum = 1395;
Global $Words_of_Comfort = 1396;
Global $Light_of_Deliverance = 1397;
Global $Scourge_Enchantment = 1398;
Global $Shield_of_Absorption = 1399;
Global $Reversal_of_Damage = 1400;
Global $Mending_Touch = 1401;
Global $Critical_Chop = 1402;
Global $Agonizing_Chop = 1403;
Global $Flail = 1404;
Global $Charging_Strike = 1405;
Global $Headbutt = 1406;
Global $Lions_Comfort = 1407;
Global $Rage_of_the_Ntouka = 1408;
Global $Mokele_Smash = 1409;
Global $Overbearing_Smash = 1410;
Global $Signet_of_Stamina = 1411;
Global $Youre_All_Alone = 1412;
Global $Burst_of_Aggression = 1413;
Global $Enraging_Charge = 1414;
Global $Crippling_Slash = 1415;
Global $Barbarous_Slice = 1416;
Global $Vial_of_Purified_Water = 1417;
Global $Disarm_Trap = 1418;
Global $Feeding_Frenzy_skill = 1419;
Global $Quake_Of_Ahdashim = 1420;
Global $Create_Light_of_Seborhin = 1422;
Global $Unlock_Cell = 1423;
Global $Wave_of_Torment = 1430;
Global $Corsairs_Net = 1433;
Global $Corrupted_Healing = 1434;
Global $Corrupted_Strength = 1436;
Global $Desert_Wurm_disguise = 1437;
Global $Junundu_Feast = 1438;
Global $Junundu_Strike = 1439;
Global $Junundu_Smash = 1440;
Global $Junundu_Siege = 1441;
Global $Junundu_Tunnel = 1442;
Global $Leave_Junundu = 1443;
Global $Summon_Torment = 1444;
Global $Signal_Flare = 1445;
Global $The_Elixir_of_Strength = 1446;
Global $Ehzah_from_Above = 1447;
Global $Last_Rites_of_Torment = 1449;
Global $Abaddons_Conspiracy = 1450;
Global $Hungers_Bite = 1451;
Global $Call_to_the_Torment = 1454;
Global $Command_of_Torment = 1455;
Global $Abaddons_Favor = 1456;
Global $Abaddons_Chosen = 1457;
Global $Enchantment_Collapse = 1458;
Global $Call_of_Sacrifice = 1459;
Global $Enemies_Must_Die = 1460;
Global $Earth_Vortex = 1461;
Global $Frost_Vortex = 1462;
Global $Rough_Current = 1463;
Global $Turbulent_Flow = 1464;
Global $Prepared_Shot = 1465;
Global $Burning_Arrow = 1466;
Global $Arcing_Shot = 1467;
Global $Strike_as_One = 1468;
Global $Crossfire = 1469;
Global $Barbed_Arrows = 1470;
Global $Scavengers_Focus = 1471;
Global $Toxicity = 1472;
Global $Quicksand = 1473;
Global $Storms_Embrace = 1474;
Global $Trappers_Speed = 1475;
Global $Tripwire = 1476;
Global $Kournan_Guardsman_Uniform = 1477;
Global $Renewing_Surge = 1478;
Global $Offering_of_Spirit = 1479;
Global $Spirits_Gift = 1480;
Global $Death_Pact_Signet = 1481;
Global $Reclaim_Essence = 1482;
Global $Banishing_Strike = 1483;
Global $Mystic_Sweep = 1484;
Global $Eremites_Attack = 1485;
Global $Reap_Impurities = 1486;
Global $Twin_Moon_Sweep = 1487;
Global $Victorious_Sweep = 1488;
Global $Irresistible_Sweep = 1489;
Global $Pious_Assault = 1490;
Global $Mystic_Twister = 1491;
Global $Grenths_Fingers = 1493;
Global $Aura_of_Thorns = 1495;
Global $Balthazars_Rage = 1496;
Global $Dust_Cloak = 1497;
Global $Staggering_Force = 1498;
Global $Pious_Renewal = 1499;
Global $Mirage_Cloak = 1500;
Global $Arcane_Zeal = 1502;
Global $Mystic_Vigor = 1503;
Global $Watchful_Intervention = 1504;
Global $Vow_of_Piety = 1505;
Global $Vital_Boon = 1506;
Global $Heart_of_Holy_Flame = 1507;
Global $Extend_Enchantments = 1508;
Global $Faithful_Intervention = 1509;
Global $Sand_Shards = 1510;
Global $Lyssas_Haste = 1512;
Global $Guiding_Hands = 1513;
Global $Fleeting_Stability = 1514;
Global $Armor_of_Sanctity = 1515;
Global $Mystic_Regeneration = 1516;
Global $Vow_of_Silence = 1517;
Global $Avatar_of_Balthazar = 1518;
Global $Avatar_of_Dwayna = 1519;
Global $Avatar_of_Grenth = 1520;
Global $Avatar_of_Lyssa = 1521;
Global $Avatar_of_Melandru = 1522;
Global $Meditation = 1523;
Global $Eremites_Zeal = 1524;
Global $Natural_Healing = 1525;
Global $Imbue_Health = 1526;
Global $Mystic_Healing = 1527;
Global $Dwaynas_Touch = 1528;
Global $Pious_Restoration = 1529;
Global $Signet_of_Pious_Light = 1530;
Global $Intimidating_Aura = 1531;
Global $Mystic_Sandstorm = 1532;
Global $Winds_of_Disenchantment = 1533;
Global $Rending_Touch = 1534;
Global $Crippling_Sweep = 1535;
Global $Wounding_Strike = 1536;
Global $Wearying_Strike = 1537;
Global $Lyssas_Assault = 1538;
Global $Chilling_Victory = 1539;
Global $Conviction = 1540;
Global $Enchanted_Haste = 1541;
Global $Pious_Concentration = 1542;
Global $Pious_Haste = 1543;
Global $Whirling_Charge = 1544;
Global $Test_of_Faith = 1545;
Global $Blazing_Spear = 1546;
Global $Mighty_Throw = 1547;
Global $Cruel_Spear = 1548;
Global $Harriers_Toss = 1549;
Global $Unblockable_Throw = 1550;
Global $Spear_of_Lightning = 1551;
Global $Wearying_Spear = 1552;
Global $Anthem_of_Fury = 1553;
Global $Crippling_Anthem = 1554;
Global $Defensive_Anthem = 1555;
Global $Godspeed = 1556;
Global $Anthem_of_Flame = 1557;
Global $Go_for_the_Eyes = 1558;
Global $Anthem_of_Envy = 1559;
Global $Song_of_Power = 1560;
Global $Zealous_Anthem = 1561;
Global $Aria_of_Zeal = 1562;
Global $Lyric_of_Zeal = 1563;
Global $Ballad_of_Restoration = 1564;
Global $Chorus_of_Restoration = 1565;
Global $Aria_of_Restoration = 1566;
Global $Song_of_Concentration = 1567;
Global $Anthem_of_Guidance = 1568;
Global $Energizing_Chorus = 1569;
Global $Song_of_Purification = 1570;
Global $Hexbreaker_Aria = 1571;
Global $Brace_Yourself = 1572;
Global $Awe = 1573;
Global $Enduring_Harmony = 1574;
Global $Blazing_Finale = 1575;
Global $Burning_Refrain = 1576;
Global $Finale_of_Restoration = 1577;
Global $Mending_Refrain = 1578;
Global $Purifying_Finale = 1579;
Global $Bladeturn_Refrain = 1580;
Global $Glowing_Signet = 1581;
Global $Leaders_Zeal = 1583;
Global $Leaders_Comfort = 1584;
Global $Signet_of_Synergy = 1585;
Global $Angelic_Protection = 1586;
Global $Angelic_Bond = 1587;
Global $Cautery_Signet = 1588;
Global $Stand_Your_Ground = 1589;
Global $Lead_the_Way = 1590;
Global $Make_Haste = 1591;
Global $We_Shall_Return = 1592;
Global $Never_Give_Up = 1593;
Global $Help_Me = 1594;
Global $Fall_Back = 1595;
Global $Incoming = 1596;
Global $Theyre_on_Fire = 1597;
Global $Never_Surrender = 1598;
Global $Its_just_a_flesh_wound = 1599;
Global $Barbed_Spear = 1600;
Global $Vicious_Attack = 1601;
Global $Stunning_Strike = 1602;
Global $Merciless_Spear = 1603;
Global $Disrupting_Throw = 1604;
Global $Wild_Throw = 1605;
Global $Curse_of_the_Staff_of_the_Mists = 1606;
Global $Aura_of_the_Staff_of_the_Mists = 1607;
Global $Power_of_the_Staff_of_the_Mists = 1608;
Global $Scepter_of_Ether = 1609;
Global $Summoning_of_the_Scepter = 1610;
Global $Rise_From_Your_Grave = 1611;
Global $Corsair_Disguise = 1613;
Global $Queen_Heal = 1616;
Global $Queen_Wail = 1617;
Global $Queen_Armor = 1618;
Global $Queen_Bite = 1619;
Global $Queen_Thump = 1620;
Global $Queen_Siege = 1621;
Global $Dervish_of_the_Mystic = 1624;
Global $Dervish_of_the_Wind = 1625;
Global $Paragon_of_Leadership = 1626;
Global $Paragon_of_Motivation = 1627;
Global $Dervish_of_the_Blade = 1628;
Global $Paragon_of_Command = 1629;
Global $Paragon_of_the_Spear = 1630;
Global $Dervish_of_the_Earth = 1631;
Global $Malicious_Strike = 1633;
Global $Shattering_Assault = 1634;
Global $Golden_Skull_Strike = 1635;
Global $Black_Spider_Strike = 1636;
Global $Golden_Fox_Strike = 1637;
Global $Deadly_Haste = 1638;
Global $Assassins_Remedy = 1639;
Global $Foxs_Promise = 1640;
Global $Feigned_Neutrality = 1641;
Global $Hidden_Caltrops = 1642;
Global $Assault_Enchantments = 1643;
Global $Wastrels_Collapse = 1644;
Global $Lift_Enchantment = 1645;
Global $Augury_of_Death = 1646;
Global $Signet_of_Toxic_Shock = 1647;
Global $Signet_of_Twilight = 1648;
Global $Way_of_the_Assassin = 1649;
Global $Shadow_Walk = 1650;
Global $Deaths_Retreat = 1651;
Global $Shadow_Prison = 1652;
Global $Swap = 1653;
Global $Shadow_Meld = 1654;
Global $Price_of_Pride = 1655;
Global $Air_of_Disenchantment = 1656;
Global $Signet_of_Clumsiness = 1657;
Global $Symbolic_Posture = 1658;
Global $Toxic_Chill = 1659;
Global $Well_of_Silence = 1660;
Global $Glowstone = 1661;
Global $Mind_Blast = 1662;
Global $Elemental_Flame = 1663;
Global $Invoke_Lightning = 1664;
Global $Battle_Cry = 1665;
Global $Energy_Shrine_Bonus = 1667;
Global $Northern_Health_Shrine_Bonus = 1668;
Global $Southern_Health_Shrine_Bonus = 1669;
Global $Curse_of_Silence = 1671;
Global $To_the_Pain_Hero_Battles = 1672;
Global $Edge_of_Reason = 1673;
Global $Depths_of_Madness_environment_effect = 1674;
Global $Cower_in_Fear = 1675;
Global $Dreadful_Pain = 1676;
Global $Veiled_Nightmare = 1677;
Global $Base_Protection = 1678;
Global $Kournan_Siege_Flame = 1679;
Global $Drake_Skin = 1680;
Global $Skale_Vigor = 1681;
Global $Pahnai_Salad_item_effect = 1682;
Global $Pensive_Guardian = 1683;
Global $Scribes_Insight = 1684;
Global $Holy_Haste = 1685;
Global $Glimmer_of_Light = 1686;
Global $Zealous_Benediction = 1687;
Global $Defenders_Zeal = 1688;
Global $Signet_of_Mystic_Wrath = 1689;
Global $Signet_of_Removal = 1690;
Global $Dismiss_Condition = 1691;
Global $Divert_Hexes = 1692;
Global $Counterattack = 1693;
Global $Magehunter_Strike = 1694;
Global $Soldiers_Strike = 1695;
Global $Decapitate = 1696;
Global $Magehunters_Smash = 1697;
Global $Soldiers_Stance = 1698;
Global $Soldiers_Defense = 1699;
Global $Frenzied_Defense = 1700;
Global $Steady_Stance = 1701;
Global $Steelfang_Slash = 1702;
Global $Sunspear_Battle_Call = 1703;
Global $Earth_Shattering_Blow = 1705;
Global $Corrupt_Power = 1706;
Global $Words_of_Madness = 1707;
Global $Gaze_of_MoavuKaal = 1708;
Global $Presence_of_the_Skale_Lord = 1709;
Global $Madness_Dart = 1710;
Global $Reform_Carvings = 1715;
Global $Sunspear_Siege = 1717;
Global $Soul_Torture = 1718;
Global $Screaming_Shot = 1719;
Global $Keen_Arrow = 1720;
Global $Rampage_as_One = 1721;
Global $Forked_Arrow = 1722;
Global $Disrupting_Accuracy = 1723;
Global $Experts_Dexterity = 1724;
Global $Roaring_Winds = 1725;
Global $Magebane_Shot = 1726;
Global $Natural_Stride = 1727;
Global $Hekets_Rampage = 1728;
Global $Smoke_Trap = 1729;
Global $Infuriating_Heat = 1730;
Global $Vocal_Was_Sogolon = 1731;
Global $Destructive_Was_Glaive = 1732;
Global $Wielders_Strike = 1733;
Global $Gaze_of_Fury = 1734;
Global $Gaze_of_Fury_attack = 1735;
Global $Spirits_Strength = 1736;
Global $Wielders_Zeal = 1737;
Global $Sight_Beyond_Sight = 1738;
Global $Renewing_Memories = 1739;
Global $Wielders_Remedy = 1740;
Global $Ghostmirror_Light = 1741;
Global $Signet_of_Ghostly_Might = 1742;
Global $Signet_of_Binding = 1743;
Global $Caretakers_Charge = 1744;
Global $Anguish = 1745;
Global $Anguish_attack = 1746;
Global $Empowerment = 1747;
Global $Recovery = 1748;
Global $Weapon_of_Fury = 1749;
Global $Xinraes_Weapon = 1750;
Global $Warmongers_Weapon = 1751;
Global $Weapon_of_Remedy = 1752;
Global $Rending_Sweep = 1753;
Global $Onslaught = 1754;
Global $Mystic_Corruption = 1755;
Global $Grenths_Grasp = 1756;
Global $Veil_of_Thorns = 1757;
Global $Harriers_Grasp = 1758;
Global $Vow_of_Strength = 1759;
Global $Ebon_Dust_Aura = 1760;
Global $Zealous_Vow = 1761;
Global $Heart_of_Fury = 1762;
Global $Zealous_Renewal = 1763;
Global $Attackers_Insight = 1764;
Global $Rending_Aura = 1765;
Global $Featherfoot_Grace = 1766;
Global $Reapers_Sweep = 1767;
Global $Harriers_Haste = 1768;
Global $Focused_Anger = 1769;
Global $Natural_Temper = 1770;
Global $Song_of_Restoration = 1771;
Global $Lyric_of_Purification = 1772;
Global $Soldiers_Fury = 1773;
Global $Aggressive_Refrain = 1774;
Global $Energizing_Finale = 1775;
Global $Signet_of_Aggression = 1776;
Global $Remedy_Signet = 1777;
Global $Signet_of_Return = 1778;
Global $Make_Your_Time = 1779;
Global $Cant_Touch_This = 1780;
Global $Find_Their_Weakness = 1781;
Global $The_Power_Is_Yours = 1782;
Global $Slayers_Spear = 1783;
Global $Swift_Javelin = 1784;
Global $Skale_Hunt = 1790;
Global $Mandragor_Hunt = 1791;
Global $Skree_Battle = 1792;
Global $Insect_Hunt = 1793;
Global $Corsair_Bounty = 1794;
Global $Plant_Hunt = 1795;
Global $Undead_Hunt = 1796;
Global $Eternal_Suffering = 1797;
Global $Eternal_Languor = 1800;
Global $Eternal_Lethargy = 1803;
Global $Thirst_of_the_Drought = 1808;
Global $Lightbringer = 1813;
Global $Lightbringers_Gaze = 1814;
Global $Lightbringer_Signet = 1815;
Global $Sunspear_Rebirth_Signet = 1816;
Global $Wisdom = 1817;
Global $Maddened_Strike = 1818;
Global $Maddened_Stance = 1819;
Global $Spirit_Form = 1820;
Global $Monster_Hunt = 1822;
Global $Elemental_Hunt = 1826;
Global $Demon_Hunt = 1831;
Global $Minotaur_Hunt = 1832;
Global $Heket_Hunt = 1837;
Global $Kournan_Bounty = 1839;
Global $Dhuum_Battle = 1844;
Global $Menzies_Battle = 1845;
Global $Monolith_Hunt = 1847;
Global $Margonite_Battle = 1849;
Global $Titan_Hunt = 1851;
Global $Giant_Hunt = 1853;
Global $Kournan_Siege = 1855;
Global $Lose_your_Head = 1856;
Global $Altar_Buff = 1859;
Global $Choking_Breath = 1861;
Global $Junundu_Bite = 1862;
Global $Blinding_Breath = 1863;
Global $Burning_Breath = 1864;
Global $Junundu_Wail = 1865;
Global $Capture_Point = 1866;
Global $Approaching_the_Vortex = 1867;
Global $Avatar_of_Sweetness = 1871;
Global $Corrupted_Lands = 1873;
Global $Unknown_Junundu_Ability = 1876;
Global $Torment_Slash_Smothering_Tendrils = 1880;
Global $Bonds_of_Torment = 1881;
Global $Shadow_Smash = 1882;
Global $Consume_Torment = 1884;
Global $Banish_Enchantment = 1885;
Global $Summoning_Shadows = 1886;
Global $Lightbringers_Insight = 1887;
Global $Repressive_Energy = 1889;
Global $Enduring_Torment = 1890;
Global $Shroud_of_Darkness = 1891;
Global $Demonic_Miasma = 1892;
Global $Enraged = 1893;
Global $Touch_of_Aaaaarrrrrrggghhh = 1894;
Global $Wild_Smash = 1895;
Global $Unyielding_Anguish = 1896;
Global $Jadoths_Storm_of_Judgment = 1897;
Global $Anguish_Hunt = 1898;
Global $Avatar_of_Holiday_Cheer = 1899;
Global $Side_Step = 1900;
Global $Jack_Frost = 1901;
Global $Avatar_of_Grenth_snow_fighting_skill = 1902;
Global $Avatar_of_Dwayna_snow_fighting_skill = 1903;
Global $Steady_Aim = 1904;
Global $Rudis_Red_Nose = 1905;
Global $Volatile_Charr_Crystal = 1911;
Global $Hard_mode = 1912;
Global $Sugar_Jolt = 1916;
Global $Rollerbeetle_Racer = 1917;
Global $Ram = 1918;
Global $Harden_Shell = 1919;
Global $Rollerbeetle_Dash = 1920;
Global $Super_Rollerbeetle = 1921;
Global $Rollerbeetle_Echo = 1922;
Global $Distracting_Lunge = 1923;
Global $Rollerbeetle_Blast = 1924;
Global $Spit_Rocks = 1925;
Global $Lunar_Blessing = 1926;
Global $Lucky_Aura = 1927;
Global $Spiritual_Possession = 1928;
Global $Water = 1929;
Global $Pig_Form = 1930;
Global $Beetle_Metamorphosis = 1931;
Global $Golden_Egg_item_effect = 1934;
Global $Infernal_Rage = 1937;
Global $Putrid_Flames = 1938;
Global $Flame_Call = 1940;
Global $Whirling_Fires = 1942;
Global $Charr_Siege_Attack_What_Must_Be_Done = 1943;
Global $Charr_Siege_Attack_Against_the_Charr = 1944;
Global $Birthday_Cupcake_skill = 1945;
Global $Blessing_of_the_Luxons = 1947;
Global $Shadow_Sanctuary = 1948;
Global $Ether_Nightmare = 1949;
Global $Signet_of_Corruption = 1950;
Global $Elemental_Lord = 1951;
Global $Selfless_Spirit = 1952;
Global $Triple_Shot = 1953;
Global $Save_Yourselves = 1954;
Global $Aura_of_Holy_Might = 1955;
Global $Spear_of_Fury = 1957;
Global $Fire_Dart = 1983;
Global $Ice_Dart = 1984;
Global $Poison_Dart = 1985;
Global $Vampiric_Assault = 1986;
Global $Lotus_Strike = 1987;
Global $Golden_Fang_Strike = 1988;
Global $Falling_Lotus_Strike = 1990;
Global $Sadists_Signet = 1991;
Global $Signet_of_Distraction = 1992;
Global $Signet_of_Recall = 1993;
Global $Power_Lock = 1994;
Global $Waste_Not_Want_Not = 1995;
Global $Sum_of_All_Fears = 1996;
Global $Withering_Aura = 1997;
Global $Cacophony = 1998;
Global $Winters_Embrace = 1999;
Global $Earthen_Shackles = 2000;
Global $Ward_of_Weakness = 2001;
Global $Glyph_of_Swiftness = 2002;
Global $Cure_Hex = 2003;
Global $Smite_Condition = 2004;
Global $Smiters_Boon = 2005;
Global $Castigation_Signet = 2006;
Global $Purifying_Veil = 2007;
Global $Pulverizing_Smash = 2008;
Global $Keen_Chop = 2009;
Global $Knee_Cutter = 2010;
Global $Grapple = 2011;
Global $Radiant_Scythe = 2012;
Global $Grenths_Aura = 2013;
Global $Signet_of_Pious_Restraint = 2014;
Global $Farmers_Scythe = 2015;
Global $Energetic_Was_Lee_Sa = 2016;
Global $Anthem_of_Weariness = 2017;
Global $Anthem_of_Disruption = 2018;
Global $Freezing_Ground = 2020;
Global $Fire_Jet = 2022;
Global $Ice_Jet = 2023;
Global $Poison_Jet = 2024;
Global $Fire_Spout = 2027;
Global $Ice_Spout = 2028;
Global $Poison_Spout = 2029;
Global $Summon_Spirits = 2051;
Global $Shadow_Fang = 2052;
Global $Calculated_Risk = 2053;
Global $Shrinking_Armor = 2054;
Global $Aneurysm = 2055;
Global $Wandering_Eye = 2056;
Global $Foul_Feast = 2057;
Global $Putrid_Bile = 2058;
Global $Shell_Shock = 2059;
Global $Glyph_of_Immolation = 2060;
Global $Patient_Spirit = 2061;
Global $Healing_Ribbon = 2062;
Global $Aura_of_Stability = 2063;
Global $Spotless_Mind = 2064;
Global $Spotless_Soul = 2065;
Global $Disarm = 2066;
Global $I_Meant_to_Do_That = 2067;
Global $Rapid_Fire = 2068;
Global $Sloth_Hunters_Shot = 2069;
Global $Aura_Slicer = 2070;
Global $Zealous_Sweep = 2071;
Global $Pure_Was_Li_Ming = 2072;
Global $Weapon_of_Aggression = 2073;
Global $Chest_Thumper = 2074;
Global $Hasty_Refrain = 2075;
Global $Cracked_Armor = 2077;
Global $Berserk = 2078;
Global $Fleshreavers_Escape = 2079;
Global $Chomp = 2080;
Global $Twisting_Jaws = 2081;
Global $Mandragors_Charge = 2083;
Global $Rock_Slide = 2084;
Global $Avalanche_effect = 2085;
Global $Snaring_Web = 2086;
Global $Ceiling_Collapse = 2087;
Global $Trample = 2088;
Global $Wurm_Bile = 2089 ;
Global $Critical_Agility = 2101;
Global $Cry_of_Pain = 2102;
Global $Necrosis = 2103;
Global $Intensity = 2104;
Global $Seed_of_Life = 2105;
Global $Call_of_the_Eye = 2106;
Global $Whirlwind_Attack = 2107;
Global $Never_Rampage_Alone = 2108;
Global $Eternal_Aura = 2109;
Global $Vampirism = 2110;
Global $Vampirism_attack = 2111;
Global $Theres_Nothing_to_Fear = 2112;
Global $Ursan_Rage_Blood_Washes_Blood = 2113;
Global $Ursan_Strike_Blood_Washes_Blood = 2114;
Global $Sneak_Attack = 2116;
Global $Firebomb_Explosion = 2117;
Global $Firebomb = 2118;
Global $Shield_of_Fire = 2119;
Global $Spirit_World_Retreat = 2122;
Global $Shattered_Spirit = 2124;
Global $Spirit_Roar = 2125;
Global $Spirit_Senses = 2126;
Global $Unseen_Aggression = 2127;
Global $Volfen_Pounce_Curse_of_the_Nornbear = 2128;
Global $Volfen_Claw_Curse_of_the_Nornbear = 2129;
Global $Volfen_Bloodlust_Curse_of_the_Nornbear = 2131;
Global $Volfen_Agility_Curse_of_the_Nornbear = 2132;
Global $Volfen_Blessing_Curse_of_the_Nornbear = 2133;
Global $Charging_Spirit = 2134;
Global $Trampling_Ox = 2135;
Global $Smoke_Powder_Defense = 2136;
Global $Confusing_Images = 2137;
Global $Hexers_Vigor = 2138;
Global $Masochism = 2139;
Global $Piercing_Trap = 2140;
Global $Companionship = 2141;
Global $Feral_Aggression = 2142;
Global $Disrupting_Shot = 2143;
Global $Volley = 2144;
Global $Expert_Focus = 2145;
Global $Pious_Fury = 2146;
Global $Crippling_Victory = 2147;
Global $Sundering_Weapon = 2148;
Global $Weapon_of_Renewal = 2149;
Global $Maiming_Spear = 2150;
Global $Temporal_Sheen = 2151;
Global $Flux_Overload = 2152;
Global $Phase_Shield_effect = 2154;
Global $Phase_Shield = 2155;
Global $Vitality_Transfer = 2156;
Global $Golem_Strike = 2157;
Global $Bloodstone_Slash = 2158;
Global $Energy_Blast_golem = 2159;
Global $Chaotic_Energy = 2160;
Global $Golem_Fire_Shield = 2161;
Global $The_Way_of_Duty = 2162;
Global $The_Way_of_Kinship = 2163;
Global $Diamondshard_Mist_environment_effect = 2164;
Global $Diamondshard_Grave = 2165;
Global $The_Way_of_Strength = 2166;
Global $Diamondshard_Mist = 2167;
Global $Raven_Blessing_A_Gate_Too_Far = 2168;
Global $Raven_Flight_A_Gate_Too_Far = 2170;
Global $Raven_Shriek_A_Gate_Too_Far = 2171;
Global $Raven_Swoop_A_Gate_Too_Far = 2172;
Global $Raven_Talons_A_Gate_Too_Far = 2173;
Global $Aspect_of_Oak = 2174;
Global $Tremor = 2176;
Global $Pyroclastic_Shot = 2180;
Global $Rolling_Shift = 2184;
Global $Powder_Keg_Explosion = 2185;
Global $Signet_of_Deadly_Corruption = 2186;
Global $Way_of_the_Master = 2187;
Global $Defile_Defenses = 2188;
Global $Angorodons_Gaze = 2189;
Global $Magnetic_Surge = 2190;
Global $Slippery_Ground = 2191;
Global $Glowing_Ice = 2192;
Global $Energy_Blast = 2193;
Global $Distracting_Strike = 2194;
Global $Symbolic_Strike = 2195;
Global $Soldiers_Speed = 2196;
Global $Body_Blow = 2197;
Global $Body_Shot = 2198;
Global $Poison_Tip_Signet = 2199;
Global $Signet_of_Mystic_Speed = 2200;
Global $Shield_of_Force = 2201;
Global $Mending_Grip = 2202;
Global $Spiritleech_Aura = 2203;
Global $Rejuvenation = 2204;
Global $Agony = 2205;
Global $Ghostly_Weapon = 2206;
Global $Inspirational_Speech = 2207;
Global $Burning_Shield = 2208;
Global $Holy_Spear = 2209;
Global $Spear_Swipe = 2210;
Global $Alkars_Alchemical_Acid = 2211;
Global $Light_of_Deldrimor = 2212;
Global $Ear_Bite = 2213;
Global $Low_Blow = 2214;
Global $Brawling_Headbutt = 2215;
Global $Dont_Trip = 2216;
Global $By_Urals_Hammer = 2217;
Global $Drunken_Master = 2218;
Global $Great_Dwarf_Weapon = 2219;
Global $Great_Dwarf_Armor = 2220;
Global $Breath_of_the_Great_Dwarf = 2221;
Global $Snow_Storm = 2222;
Global $Black_Powder_Mine = 2223;
Global $Summon_Mursaat = 2224;
Global $Summon_Ruby_Djinn = 2225;
Global $Summon_Ice_Imp = 2226;
Global $Summon_Naga_Shaman = 2227;
Global $Deft_Strike = 2228;
Global $Signet_of_Infection = 2229;
Global $Tryptophan_Signet = 2230;
Global $Ebon_Battle_Standard_of_Courage = 2231;
Global $Ebon_Battle_Standard_of_Wisdom = 2232;
Global $Ebon_Battle_Standard_of_Honor = 2233;
Global $Ebon_Vanguard_Sniper_Support = 2234;
Global $Ebon_Vanguard_Assassin_Support = 2235;
Global $Well_of_Ruin = 2236;
Global $Atrophy = 2237;
Global $Spear_of_Redemption = 2238;
Global $Gelatinous_Material_Explosion = 2240;
Global $Gelatinous_Corpse_Consumption = 2241;
Global $Gelatinous_Absorption = 2243;
Global $Unstable_Ooze_Explosion = 2244;
Global $Unstable_Aura = 2246;
Global $Unstable_Pulse = 2247;
Global $Polymock_Power_Drain = 2248;
Global $Polymock_Block = 2249;
Global $Polymock_Glyph_of_Concentration = 2250;
Global $Polymock_Ether_Signet = 2251;
Global $Polymock_Glyph_of_Power = 2252;
Global $Polymock_Overload = 2253;
Global $Polymock_Glyph_Destabilization = 2254;
Global $Polymock_Mind_Wreck = 2255;
Global $Order_of_Unholy_Vigor = 2256;
Global $Order_of_the_Lich = 2257;
Global $Master_of_Necromancy = 2258;
Global $Animate_Undead = 2259;
Global $Polymock_Deathly_Chill = 2260;
Global $Polymock_Rising_Bile = 2261;
Global $Polymock_Rotting_Flesh = 2262;
Global $Polymock_Lightning_Strike = 2263;
Global $Polymock_Lightning_Orb = 2264;
Global $Polymock_Lightning_Djinns_Haste = 2265;
Global $Polymock_Flare = 2266;
Global $Polymock_Immolate = 2267;
Global $Polymock_Meteor = 2268;
Global $Polymock_Ice_Spear = 2269;
Global $Polymock_Icy_Prison = 2270;
Global $Polymock_Mind_Freeze = 2271;
Global $Polymock_Ice_Shard_Storm = 2272;
Global $Polymock_Frozen_Trident = 2273;
Global $Polymock_Smite = 2274;
Global $Polymock_Smite_Hex = 2275;
Global $Polymock_Bane_Signet = 2276;
Global $Polymock_Stone_Daggers = 2277;
Global $Polymock_Obsidian_Flame = 2278;
Global $Polymock_Earthquake = 2279;
Global $Polymock_Frozen_Armor = 2280;
Global $Polymock_Glyph_Freeze = 2281;
Global $Polymock_Fireball = 2282;
Global $Polymock_Rodgorts_Invocation = 2283;
Global $Polymock_Calculated_Risk = 2284;
Global $Polymock_Recurring_Insecurity = 2285;
Global $Polymock_Backfire = 2286;
Global $Polymock_Guilt = 2287;
Global $Polymock_Lamentation = 2288;
Global $Polymock_Spirit_Rift = 2289;
Global $Polymock_Painful_Bond = 2290;
Global $Polymock_Signet_of_Clumsiness = 2291;
Global $Polymock_Migraine = 2292;
Global $Polymock_Glowing_Gaze = 2293;
Global $Polymock_Searing_Flames = 2294;
Global $Polymock_Signet_of_Revenge = 2295;
Global $Polymock_Signet_of_Smiting = 2296;
Global $Polymock_Stoning = 2297;
Global $Polymock_Eruption = 2298;
Global $Polymock_Shock_Arrow = 2299;
Global $Polymock_Mind_Shock = 2300;
Global $Polymock_Piercing_Light_Spear = 2301;
Global $Polymock_Mind_Blast = 2302;
Global $Polymock_Savannah_Heat = 2303;
Global $Polymock_Diversion = 2304;
Global $Polymock_Lightning_Blast = 2305;
Global $Polymock_Poisoned_Ground = 2306;
Global $Polymock_Icy_Bonds = 2307;
Global $Polymock_Sandstorm = 2308;
Global $Polymock_Banish = 2309;
Global $Mergoyle_Form = 2310;
Global $Skale_Form = 2311;
Global $Gargoyle_Form = 2312;
Global $Ice_Imp_Form = 2313;
Global $Fire_Imp_Form = 2314;
Global $Kappa_Form = 2315;
Global $Aloe_Seed_Form = 2316;
Global $Earth_Elemental_Form = 2317;
Global $Fire_Elemental_Form = 2318;
Global $Ice_Elemental_Form = 2319;
Global $Mirage_Iboga_Form = 2320;
Global $Wind_Rider_Form = 2321;
Global $Naga_Shaman_Form = 2322;
Global $Mantis_Dreamweaver_Form = 2323;
Global $Ruby_Djinn_Form = 2324;
Global $Gaki_Form = 2325;
Global $Stone_Rain_Form = 2326;
Global $Mursaat_Elementalist_Form = 2327;
Global $Crystal_Shield = 2328;
Global $Crystal_Snare = 2329;
Global $Paranoid_Indignation = 2330;
Global $Searing_Breath = 2331;
Global $Brawling = 2333;
Global $Brawling_Block = 2334;
Global $Brawling_Jab = 2335;
Global $Brawling_Straight_Right = 2337;
Global $Brawling_Hook = 2338;
Global $Brawling_Uppercut = 2340;
Global $Brawling_Combo_Punch = 2341;
Global $Brawling_Headbutt_Brawling_skill = 2342;
Global $STAND_UP = 2343;
Global $Call_of_Destruction = 2344;
Global $Lava_Ground = 2346;
Global $Lava_Wave = 2347;
Global $Charr_Siege_Attack_Assault_on_the_Stronghold = 2352;
Global $Finish_Him = 2353;
Global $Dodge_This = 2354;
Global $I_Am_The_Strongest = 2355;
Global $I_Am_Unstoppable = 2356;
Global $A_Touch_of_Guile = 2357;
Global $You_Move_Like_a_Dwarf = 2358;
Global $You_Are_All_Weaklings = 2359;
Global $Feel_No_Pain = 2360;
Global $Club_of_a_Thousand_Bears = 2361;
Global $Lava_Blast = 2364;
Global $Thunderfist_Strike = 2365;
Global $Alkars_Concoction = 2367;
Global $Murakais_Consumption = 2368;
Global $Murakais_Censure = 2369;
Global $Murakais_Calamity = 2370;
Global $Murakais_Storm_of_Souls = 2371;
Global $Edification = 2372;
Global $Heart_of_the_Norn = 2373;
Global $Ursan_Blessing = 2374;
Global $Ursan_Strike = 2375;
Global $Ursan_Rage = 2376;
Global $Ursan_Roar = 2377;
Global $Ursan_Force = 2378;
Global $Volfen_Blessing = 2379;
Global $Volfen_Claw = 2380;
Global $Volfen_Pounce = 2381;
Global $Volfen_Bloodlust = 2382;
Global $Volfen_Agility = 2383;
Global $Raven_Blessing = 2384;
Global $Raven_Talons = 2385;
Global $Raven_Swoop = 2386;
Global $Raven_Shriek = 2387;
Global $Raven_Flight = 2388;
Global $Totem_of_Man = 2389;
Global $Murakais_Call = 2391;
Global $Spawn_Pods = 2392;
Global $Enraged_Blast = 2393;
Global $Spawn_Hatchling = 2394;
Global $Ursan_Roar_Blood_Washes_Blood = 2395;
Global $Ursan_Force_Blood_Washes_Blood = 2396;
Global $Ursan_Aura = 2397;
Global $Consume_Flames = 2398;
Global $Charr_Flame_Keeper_Form = 2401;
Global $Titan_Form = 2402;
Global $Skeletal_Mage_Form = 2403;
Global $Smoke_Wraith_Form = 2404;
Global $Bone_Dragon_Form = 2405;
Global $Dwarven_Arcanist_Form = 2407;
Global $Dolyak_Rider_Form = 2408;
Global $Extract_Inscription = 2409;
Global $Charr_Shaman_Form = 2410;
Global $Mindbender = 2411;
Global $Smooth_Criminal = 2412;
Global $Technobabble = 2413;
Global $Radiation_Field = 2414;
Global $Asuran_Scan = 2415;
Global $Air_of_Superiority = 2416;
Global $Mental_Block = 2417;
Global $Pain_Inverter = 2418;
Global $Healing_Salve = 2419;
Global $Ebon_Escape = 2420;
Global $Weakness_Trap = 2421;
Global $Winds = 2422;
Global $Dwarven_Stability = 2423;
Global $StoutHearted = 2424;
Global $Decipher_Inscriptions = 2426;
Global $Rebel_Yell = 2427;
Global $Asuran_Flame_Staff = 2429;
Global $Aura_of_the_Bloodstone = 2430;
Global $Haunted_Ground = 2433;
Global $Asuran_Bodyguard = 2434;
Global $Energy_Channel = 2437;
Global $Hunt_Rampage_Asura = 2438;
Global $Boss_Bounty = 2440;
Global $Hunt_Point_Bonus_Asura = 2441;
Global $Time_Attack = 2444;
Global $Dwarven_Raider = 2445;
Global $Great_Dwarfs_Blessing = 2449;
Global $Hunt_Rampage_Deldrimor = 2450;
Global $Hunt_Point_Bonus = 2453;
Global $Vanguard_Patrol = 2457;
Global $Vanguard_Commendation = 2461;
Global $Hunt_Rampage_Ebon_Vanguard = 2462;
Global $Norn_Hunting_Party = 2469;
Global $Strength_of_the_Norn = 2473;
Global $Hunt_Rampage_Norn = 2474;
Global $Gloat = 2483;
Global $Metamorphosis = 2484;
Global $Inner_Fire = 2485;
Global $Elemental_Shift = 2486;
Global $Dryders_Feast = 2487;
Global $Fungal_Explosion = 2488;
Global $Blood_Rage = 2489;
Global $Parasitic_Bite = 2490;
Global $False_Death = 2491;
Global $Ooze_Combination = 2492;
Global $Ooze_Division = 2493;
Global $Bear_Form = 2494;
Global $Spore_Explosion = 2496;
Global $Dormant_Husk = 2497;
Global $Monkey_See_Monkey_Do = 2498;
Global $Tengus_Mimicry = 2500;
Global $Tongue_Lash = 2501;
Global $Soulrending_Shriek = 2502;
Global $Siege_Devourer = 2504;
Global $Siege_Devourer_Feast = 2505;
Global $Devourer_Bite = 2506;
Global $Siege_Devourer_Swipe = 2507;
Global $Devourer_Siege = 2508;
Global $HYAHHHHH = 2509;
Global $Dismount_Siege_Devourer = 2513;
Global $The_Masters_Mark = 2514;
Global $The_Snipers_Spear = 2515;
Global $Mount = 2516;
Global $Reverse_Polarity_Fire_Shield = 2517;
Global $Tengus_Gaze = 2518;
Global $Armor_of_Salvation_item_effect = 2520;
Global $Grail_of_Might_item_effect = 2521;
Global $Essence_of_Celerity_item_effect = 2522;
Global $Duncans_Defense = 2527;
Global $Invigorating_Mist = 2536;
Global $Courageous_Was_Saidra = 2537;
Global $Animate_Undead_Palawa_Joko = 2538;
Global $Order_of_Unholy_Vigor_Palawa_Joko = 2539;
Global $Order_of_the_Lich_Palawa_Joko = 2540;
Global $Golem_Boosters = 2541;
Global $Tongue_Whip = 2544;
Global $Lit_Torch = 2545;
Global $Dishonorable = 2546;
Global $Veteran_Asuran_Bodyguard = 2548;
Global $Veteran_Dwarven_Raider = 2549;
Global $Veteran_Vanguard_Patrol = 2550;
Global $Veteran_Norn_Hunting_Party = 2551 ;
Global $Candy_Corn_skill = 2604;
Global $Candy_Apple_skill = 2605;
Global $Anton_disguise = 2606;
Global $Erys_Vasburg_disguise = 2607;
Global $Olias_disguise = 2608;
Global $Argo_disguise = 2609;
Global $Mhenlo_disguise = 2610;
Global $Lukas_disguise = 2611;
Global $Aidan_disguise = 2612;
Global $Kahmu_disguise = 2613;
Global $Razah_disguise = 2614;
Global $Morgahn_disguise = 2615;
Global $Nika_disguise = 2616;
Global $Seaguard_Hala_disguise = 2617;
Global $Livia_disguise = 2618;
Global $Cynn_disguise = 2619;
Global $Tahlkora_disguise = 2620;
Global $Devona_disguise = 2621;
Global $Zho_disguise = 2622;
Global $Melonni_disguise = 2623;
Global $Xandra_disguise = 2624;
Global $Hayda_disguise = 2625 ;
Global $Pie_Induced_Ecstasy = 2649;
Global $Togo_disguise = 2651;
Global $Turai_Ossa_disguise = 2652;
Global $Gwen_disguise = 2653;
Global $Saul_DAlessio_disguise = 2654;
Global $Dragon_Empire_Rage = 2655;
Global $Call_to_the_Spirit_Realm = 2656;
Global $Hide = 2658;
Global $Feign_Death = 2659;
Global $Flee = 2660;
Global $Throw_Rock = 2661;
Global $Siege_Strike = 2663;
Global $Spike_Trap_spell = 2664;
Global $Barbed_Bomb = 2665;
Global $Balm_Bomb = 2667;
Global $Explosives = 2668;
Global $Rations = 2669;
Global $Form_Up_and_Advance = 2670;
Global $Spectral_Agony_hex = 2672;
Global $Stun_Bomb = 2673;
Global $Banner_of_the_Unseen = 2674;
Global $Signet_of_the_Unseen = 2675;
Global $For_Elona = 2676;
Global $Giant_Stomp_Turai_Ossa = 2677;
Global $Whirlwind_Attack_Turai_Ossa = 2678;
Global $Journey_to_the_North = 2699;
Global $Rat_Form = 2701;
Global $Party_Time = 2712;
Global $Awakened_Head_Form = 2841;
Global $Spider_Form = 2842;
Global $Golem_Form = 2844;
Global $Norn_Form = 2846;
Global $Rift_Warden_Form = 2848;
Global $Snowman_Form = 2851;
Global $Energy_Drain_PvP = 2852;
Global $Energy_Tap_PvP = 2853;
Global $PvP_effect = 2854;
Global $Ward_Against_Melee_PvP = 2855;
Global $Lightning_Orb_PvP = 2856;
Global $Aegis_PvP = 2857;
Global $Watch_Yourself_PvP = 2858;
Global $Enfeeble_PvP = 2859;
Global $Ether_Renewal_PvP = 2860;
Global $Penetrating_Attack_PvP = 2861;
Global $Shadow_Form_PvP = 2862;
Global $Discord_PvP = 2863;
Global $Sundering_Attack_PvP = 2864;
Global $Ritual_Lord_PvP = 2865;
Global $Flesh_of_My_Flesh_PvP = 2866;
Global $Ancestors_Rage_PvP = 2867;
Global $Splinter_Weapon_PvP = 2868;
Global $Assassins_Remedy_PvP = 2869;
Global $Blinding_Surge_PvP = 2870;
Global $Light_of_Deliverance_PvP = 2871;
Global $Death_Pact_Signet_PvP = 2872;
Global $Mystic_Sweep_PvP = 2873;
Global $Eremites_Attack_PvP = 2874;
Global $Harriers_Toss_PvP = 2875;
Global $Defensive_Anthem_PvP = 2876;
Global $Ballad_of_Restoration_PvP = 2877;
Global $Song_of_Restoration_PvP = 2878;
Global $Incoming_PvP = 2879;
Global $Never_Surrender_PvP = 2880;
Global $Mantra_of_Inscriptions_PvP = 2882;
Global $For_Great_Justice_PvP = 2883;
Global $Mystic_Regeneration_PvP = 2884;
Global $Enfeebling_Blood_PvP = 2885;
Global $Summoning_Sickness = 2886;
Global $Signet_of_Judgment_PvP = 2887;
Global $Chilling_Victory_PvP = 2888;
Global $Unyielding_Aura_PvP = 2891;
Global $Spirit_Bond_PvP = 2892;
Global $Weapon_of_Warding_PvP = 2893;
Global $Smiters_Boon_PvP = 2895;
Global $Battle_Fervor_Deactivating_ROX = 2896;
Global $Cloak_of_Faith_Deactivating_ROX = 2897;
Global $Dark_Aura_Deactivating_ROX = 2898;
Global $Reactor_Blast = 2902;
Global $Reactor_Blast_Timer = 2903;
Global $Jade_Brotherhood_Disguise = 2904;
Global $Internal_Power_Engaged = 2905;
Global $Target_Acquisition = 2906;
Global $NOX_Beam = 2907;
Global $NOX_Field_Dash = 2908;
Global $NOXion_Buster = 2909;
Global $Countdown = 2910;
Global $Bit_Golem_Breaker = 2911;
Global $Bit_Golem_Rectifier = 2912;
Global $Bit_Golem_Crash = 2913;
Global $Bit_Golem_Force = 2914;
Global $NOX_Phantom = 2916;
Global $NOX_Thunder = 2917;
Global $NOX_Lock_On = 2918;
Global $NOX_Driver = 2919;
Global $NOX_Fire = 2920;
Global $NOX_Knuckle = 2921;
Global $NOX_Divider_Drive = 2922;
Global $Sloth_Hunters_Shot_PvP = 2925;
Global $Experts_Dexterity_PvP = 2959;
Global $Signet_of_Spirits_PvP = 2965;
Global $Signet_of_Ghostly_Might_PvP = 2966;
Global $Avatar_of_Grenth_PvP = 2967;
Global $Oversized_Tonic_Warning = 2968;
Global $Read_the_Wind_PvP = 2969;
Global $Blue_Rock_Candy_Rush = 2971;
Global $Green_Rock_Candy_Rush = 2972;
Global $Red_Rock_Candy_Rush = 2973;
Global $Fall_Back_PVP = 3037;
Global $Well_Supplied = 3174;
#EndRegion All Skill IDs, Global Variables
Func Follow()
	Local $i = 1
	Local $j = 1

	While 1
		If GetMapLoading() == $INSTANCETYPE_EXPLORABLE Then
;~ 			ChangeLoot()
			ResignAfterSpawn()

			While 1 ;;;;;;;;;; FOLLOWER LOOP
				If $i = 3000 Then Main() ; Infinite Loop Check
				$i += 1
				Sleep(Abs(1500 - ($NumberOfFoesInSpellRange*200)))
				If Not UpdateWorld() Then Death()
				If Not SmartCast() Then Death()
				If Not MoveIfHurt() Then Death()
				If Not AttackRange() Then Death()
				If Not PickUpLoot() Then Death()
				If Not GrabAllBounties() Then Death()
				If Not FollowLeader() Then Death()
				If Not $boolRun Then ExitLoop
				If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then ExitLoop
			WEnd
		EndIf

		OutpostCheck()

		If $j = 3000 Then ExitLoop ; Infinite Loop Check
	WEnd

	Main()

EndFunc   ;==>Follow

Func FollowLeader()
	If GetIsDead() Then Return False
	$LeaderLocation = XandYLocation($SavedLeaderID) ; returns array
	$MyLocation = XandYLocation() ; returns array
	$DistanceToLeader = ComputeDistance($LeaderLocation[0], $LeaderLocation[1], $MyLocation[0], $MyLocation[1])
	If $DistanceToLeader <= 250 Then Return True
	If $DistanceToLeader > 1200 Then
		If MoveToLeader() == False Then Return False
		$LeaderLocation = XandYLocation($SavedLeaderID) ; returns array
		$MyLocation = XandYLocation() ; returns array
		$DistanceToLeader = ComputeDistance($LeaderLocation[0], $LeaderLocation[1], $MyLocation[0], $MyLocation[1])
	EndIf
	If $DistanceToLeader > 250 Then
		If $LeaderLocation[0] <> 0 And $LeaderLocation[1] <> 0 Then
			If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return True
			If $NumberOfFoesInAttackRange <= 0 Then
				$theta = $MyPlayerNumber * 51.42857
				Move(50 * Cos($theta * 0.01745) + $LeaderLocation[0], 50 * Sin($theta * 0.01745) + $LeaderLocation[1], 0)
			EndIf
		EndIf
	EndIf
EndFunc

Func ResignAfterSpawn()
	Local $k = 0
	If $Resigned == False Then
		$Resigned = True
		Update("Loading Explorable")
		Do
			RndSleep(1000)
			If $k = 3000 Then Main() ; Infinite Loop Check
		Until GetPartyLeader() == True
		Sleep(2000)
		Update("Resigning", 5)
		Resign()
		Local $Me = GetAgentByID(-2)
		$MyPlayerNumber = DllStructGetData($Me, 'PlayerNumber')
	EndIf
 EndFunc
 #Region Skill INFO
Func SkillDamageAmount($Skill)
	Return DllStructGetData($Skill, 'Scale15')
EndFunc   ;==>SkillDamageAmount

Func SkillAOERange($Skill)
	Return DllStructGetData($Skill, 'AoERange')
EndFunc   ;==>SkillAOERange

Func SkillRecharge($Skill)
	Return DllStructGetData($Skill, 'Recharge')
EndFunc   ;==>SkillRecharge

Func SkillActivation($Skill)
	Return DllStructGetData($Skill, 'Activation')
EndFunc   ;==>SkillActivation

Func SkillAttribute($Skill)
	Return DllStructGetData($Skill, 'Attribute')
EndFunc   ;==>SkillAttribute
#EndRegion Skill INFO
Func IsCorpseSkill($Skill)
	Switch DllStructGetData($Skill, 'ID')
		Case $Aura_of_the_Lich, $Animate_Bone_Fiend, $Animate_Bone_Horror, $Animate_Bone_Minions
			Return True
		Case $Animate_Flesh_Golem, $Animate_Shambling_Horror, $Animate_Vampiric_Horror
			Return True
		Case $Consume_Corpse, $Necrotic_Traversal, $Putrid_Explosion, $Soul_Feast, $Well_of_Blood
			Return True
		Case $Well_of_Darkness, $Well_of_Power, $Well_of_Ruin, $Well_of_Silence, $Well_of_Suffering
			Return True
		Case $Well_of_the_Profane, $Well_of_Weariness, $Junundu_Feast, $Siege_Devourer_Feast
			Return True
		Case Else
			Return False
	EndSwitch
	Return False
 EndFunc   ;==>IsCorpseSkill
 Func IsResSkill($Skill)
	Switch DllStructGetData($Skill, 'ID')
		Case $By_Urals_Hammer
			Return True
		Case $We_Shall_Return
			Return True
		Case $Death_Pact_Signet
			Return True
		Case $Eternal_Aura
			Return True
		Case $Flesh_of_My_Flesh
			Return True
		Case $Junundu_Wail
			Return True
		Case $Light_of_Dwayna
			Return True
		Case $Lively_Was_Naomei
			Return True
		Case $Rebirth
			Return True
		Case $Renew_Life
			Return True
		Case $Restoration
			Return True
		Case $Restore_Life
			Return True
		Case $Resurrect
			Return True
		Case $Resurrection_Chant
			Return True
		Case $Resurrection_Signet
			Return True
		Case $Signet_of_Return
			Return True
		Case $Sunspear_Rebirth_Signet
			Return True
		Case $Unyielding_Aura
			Return True
		Case $Vengeance
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>IsResSkill

Func IsHexRemovalSkill($Skill)
	If BitAND(DllStructGetData($Skill, 'Effect2'), 2048) Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>IsHexRemovalSkill

Func IsConditionRemovalSkill($Skill)
	Switch DllStructGetData($Skill, 'ID')
		Case $Dismiss_Condition
			Return True
		Case $Mend_Condition
			Return True
		Case $Mend_Ailment
			Return True
		Case $Restore_Condition
			Return True
		Case $Mending_Touch
			Return True
		Case $Purge_Conditions
			Return True
		Case $Purge_Signet
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>IsConditionRemovalSkill
 Func IsHealSkill($Skill)
	If IsResSkill($Skill) == True Then Return False
	If BitAND(DllStructGetData($Skill, 'Effect1'), 4096) Then Return True
	If BitAND(DllStructGetData($Skill, 'Effect2'), 2) Then Return True
	If BitAND(DllStructGetData($Skill, 'Effect2'), 4) Then Return True
	If DllStructGetData($Skill, 'Attribute') == $Restoration_Magic Then Return True
	If DllStructGetData($Skill, 'Attribute') == $Healing_Prayers Then Return True
	If DllStructGetData($Skill, 'Attribute') == $Protection_Prayers Then Return True
	If DllStructGetData($Skill, 'Attribute') == $Divine_Favor Then Return True
	If DllStructGetData($Skill, 'Attribute') == $Blood_Magic Then Return False
	If DllStructGetData($Skill, 'ID') == $Mystic_Regeneration Then Return True
	If DllStructGetData($Skill, 'ID') == $Mystic_Regeneration_PvP Then Return True
	Return False
 EndFunc   ;==>IsHealSkill
 Func TargetSelfSkill($Skill)
	If DllStructGetData($Skill, 'Target') = 0 Then Return True
	Return False
EndFunc   ;==>TargetSelfSkill

Func TargetSpiritSkill($Skill) ; Conditions, Charm Animal, Putrid Explosion, Spirit Targetting
	If DllStructGetData($Skill, 'Target') = 1 Then Return True
	Return False
EndFunc   ;==>TargetSpiritSkill

Func TargetAllySkill($Skill)
	If DllStructGetData($Skill, 'Target') = 3 Then Return True
	Return False
EndFunc   ;==>TargetAllySkill

Func TargetOtherAllySkill($Skill)
	If DllStructGetData($Skill, 'Target') = 4 Then Return True
	Return False
EndFunc   ;==>TargetOtherAllySkill

Func TargetEnemySkill($Skill)
	If DllStructGetData($Skill, 'Target') = 5 Then Return True
	Return False
EndFunc   ;==>TargetEnemySkill

Func TargetDeadAllySkill($Skill)
	If DllStructGetData($Skill, 'Target') = 6 Then Return True
	Return False
EndFunc   ;==>TargetDeadAllySkill

Func TargetMinionSkill($Skill)
	If DllStructGetData($Skill, 'Target') = 14 Then Return True
	Return False
EndFunc   ;==>TargetMinionSkill

Func TargetGroundSkill($Skill) ; some AoE spells
	If DllStructGetData($Skill, 'Target') = 16 Then Return True
	Return False
EndFunc   ;==>TargetGroundSkill
#EndRegion Target
Func IsSpeedBoost($Skill)
	Switch DllStructGetData($Skill, 'ID')
		Case $Make_Haste
			Return True
		Case $Windborne_Speed
			Return True
		Case $Lead_the_Way
			Return True
		Case $Gust
			Return True
		Case Else
			Return False
	EndSwitch
 EndFunc   ;==>IsSpeedBoost
 Func IsSpiritSkill($Skill) ; Spirits (Binding Rituals)
	Switch DllStructGetData($Skill, 'ID')
		Case $Signet_of_Spirits
			Return True
		Case $Agony
			Return True
		Case $Anguish
			Return True
		Case $Bloodsong
			Return True
		Case $Call_to_the_Spirit_Realm
			Return True
		Case $Destruction
			Return True
		Case $Disenchantment
			Return True
		Case $Displacement
			Return True
		Case $Dissonance
			Return True
		Case $Earthbind
			Return True
		Case $Empowerment
			Return True
		Case $Gaze_of_Fury
			Return True
		Case $Life
			Return True
		Case $Jack_Frost
			Return True
		Case $Pain
			Return True
		Case $Preservation
			Return True
		Case $Recovery
			Return True
		Case $Recuperation
			Return True
		Case $Rejuvenation
			Return True
		Case $Restoration
			Return True
		Case $Shadowsong
			Return True
		Case $Shelter
			Return True
		Case $Soothing
			Return True
		Case $Union
			Return True
		Case $Vampirism
			Return True
		Case $Wanderlust
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>IsSpiritSkill

Func IsPvESkill($Skill)
	If BitAND(DllStructGetData($Skill, 'Special'), 524288) Then
		Return True
	Else
		Return False
	EndIf
 EndFunc   ;==>IsPvESkill
 Func IsInterruptSkill($Skill)
	Switch DllStructGetData($Skill, 'ID')
		Case $You_Move_Like_a_Dwarf
			Return True
		Case $Disarm
			Return True
		Case $Disrupting_Chop
			Return True
		Case $Distracting_Blow
			Return True
		Case $Distracting_Shot
			Return True
		Case $Distracting_Strike
			Return True
		Case $Savage_Slash
			Return True
		Case $Skull_Crack
			Return True
		Case $Disrupting_Shot
			Return True
		Case $Magebane_Shot
			Return True
		Case $Punishing_Shot
			Return True
		Case $Savage_Shot
			Return True
		Case $Leech_Signet
			Return True
		Case $Psychic_Instability
			Return True
		Case $Psychic_Instability_PVP
			Return True
		Case $Simple_Thievery
			Return True
		Case $Thunderclap
			Return True
		Case $Disrupting_Stab
			Return True
		Case $Exhausting_Assault
			Return True
		Case $Lyssas_Assault
			Return True
		Case $Lyssas_Haste
			Return True
		Case $Disrupting_Lunge
			Return True
		Case $Complicate
			Return True
		Case $Cry_of_Frustration
			Return True
		Case $Psychic_Distraction
			Return True
		Case $Tease
			Return True
		Case $Web_of_Disruption
			Return True
		Case $Disrupting_Dagger
			Return True
		Case $Signet_of_Disruption
			Return True
		Case $Signet_of_Distraction
			Return True
		Case $Temple_Strike
			Return True
		Case $Power_Block
			Return True
		Case $Power_Drain
			Return True
		Case $Power_Flux
			Return True
		Case $Power_Leak
			Return True
		Case $Power_Leech
			Return True
		Case $Power_Lock
			Return True
		Case $Power_Return
			Return True
		Case $Power_Spike
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>IsInterruptSkill

Func IsWeaponSpell($SkillID)
	Switch $SkillID
		Case $Brutal_Weapon
			Return True
		Case $Ghostly_Weapon
			Return True
		Case $Great_Dwarf_Weapon
			Return True
		Case $Guided_Weapon
			Return True
		Case $Nightmare_Weapon
			Return True
		Case $Resilient_Weapon
			Return True
		Case $Spirit_Light_Weapon
			Return True
		Case $Splinter_Weapon
			Return True
		Case $Sundering_Weapon
			Return True
		Case $Vengeful_Weapon
			Return True
		Case $Vital_Weapon
			Return True
		Case $Wailing_Weapon
			Return True
		Case $Warmongers_Weapon
			Return True
		Case $Weapon_of_Aggression
			Return True
		Case $Weapon_of_Fury
			Return True
		Case $Weapon_of_Quickening
			Return True
		Case $Weapon_of_Remedy
			Return True
		Case $Weapon_of_Renewal
			Return True
		Case $Weapon_of_Shadow
			Return True
		Case $Weapon_of_Warding
			Return True
		Case $Xinraes_Weapon
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>IsWeaponSpell

Func SkillRequiresCondition($SkillID)
	Switch $SkillID
		Case $Victory_is_Mine
			Return True
		Case $Yeti_Smash
			Return True
		Case $Pestilence
			Return True
		Case $Scavenger_Strike
			Return True
		Case $Scavengers_Focus
			Return True
		Case $Discord
			Return True
;~ 			Case $Necrosis
;~ 				Return True
		Case $Oppressive_Gaze
			Return True
		Case $Signet_of_Corruption
			Return True
		Case $Vile_Miasma
			Return True
		Case $Virulence
			Return True
		Case $Epidemic
			Return True
		Case $Extend_Conditions
			Return True
		Case $Fevered_Dreams
			Return True
		Case $Fragility
			Return True
		Case $Hypochondria
			Return True
		Case $Crystal_Wave
			Return True
		Case $Iron_Palm
			Return True
		Case $Malicious_Strike
			Return True
		Case $Sadists_Signet
			Return True
		Case $Seeping_Wound
			Return True
		Case $Signet_of_Deadly_Corruption
			Return True
		Case $Signet_of_Malice
			Return True
		Case $Disrupting_Throw
			Return True
		Case $Spear_of_Fury
			Return True
		Case $Stunning_Strike
			Return True
		Case $Armor_of_Sanctity
			Return True
		Case $Reap_Impurities
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>SkillRequiresCondition

Func SkillRequiresHex($SkillID)
	Switch $SkillID
		Case $Convert_Hexes
			Return True
		Case $Cure_Hex
			Return True
		Case $Divert_Hexes
			Return True
		Case $Reverse_Hex
			Return True
		Case $Smite_Hex
			Return True
		Case $Discord
			Return True
		Case $Necrosis
			Return True
		Case $Drain_Delusions
			Return True
		Case $Hex_Eater_Signet
			Return True
		Case $Hex_Eater_Vortex
			Return True
		Case $Inspired_Hex
			Return True
		Case $Revealed_Hex
			Return True
		Case $Shatter_Delusions
			Return True
		Case $Shatter_Hex
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>SkillRequiresHex

Func IsSummonSkill($SkillID)
	Switch $SkillID
		Case $Summon_Ice_Imp
			Return True
		Case $Summon_Mursaat
			Return True
		Case $Summon_Naga_Shaman
			Return True
		Case $Summon_Ruby_Djinn
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>IsSummonSkill

Func IsAntiMeleeSkill($SkillID)
	Switch $SkillID
		Case $Spear_of_Light
			Return True
		Case $Smite
			Return True
		Case $Castigation_Signet
			Return True
		Case $Bane_Signet
			Return True
		Case $Signet_of_Clumsiness
			Return True
		Case $Signet_of_Judgment
			Return True
		Case $Ineptitude
			Return True
		Case $Clumsiness
			Return True
		Case $Wandering_Eye
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>IsAntiMeleeSkill
Func CacheSkillbar()
	Local $HealSkillCounter = 0
	If Not $mSkillbarCache[0] Then
		For $i = 1 To 8
			$mSkillbarCache[$i] = DllStructGetData($mSkillbar, 'Id' & $i)
			$mSkillbarCacheStruct[$i] = GetSkillByID($mSkillbarCache[$i])

			If DllStructGetData($mSkillbarCacheStruct[$i], 'Adrenaline') > 0 Then
				$SkillAdrenalineReq[$i] = DllStructGetData($mSkillbarCacheStruct[$i], 'Adrenaline')
				$SkillAdrenalineReq[0] = True
				$mSkillbarCacheEnergyReq[$i] = 0
				WriteChat("Skill " & $i & " requires " & DllStructGetData($mSkillbarCacheStruct[$i], 'Adrenaline') & " Adrenaline.", "Skills")
			Else
				$SkillAdrenalineReq[$i] = 0
				Switch DllStructGetData($mSkillbarCacheStruct[$i], 'EnergyCost')
					Case 0
						$mSkillbarCacheEnergyReq[$i] = 0
					Case 1
						$mSkillbarCacheEnergyReq[$i] = 1
					Case 5
						$mSkillbarCacheEnergyReq[$i] = 5
					Case 10
						$mSkillbarCacheEnergyReq[$i] = 10
					Case 11
						$mSkillbarCacheEnergyReq[$i] = 15
					Case 12
						$mSkillbarCacheEnergyReq[$i] = 25
				EndSwitch

;~ 				Update("Skill " & $i & " requires " & $mSkillbarCacheEnergyReq[$i] & " energy.")
			EndIf

			$SkillDamageAmount[$i] = SkillDamageAmount($mSkillbarCacheStruct[$i])

			If IsCorpseSkill($mSkillbarCacheStruct[$i]) == True Then
				$IsCorpseSpell[$i] = True
				$IsCorpseSpell[0] = True
			EndIf
			If IsHealSkill($mSkillbarCacheStruct[$i]) And Not IsSpiritSkill($mSkillbarCacheStruct[$i]) And Not IsResSkill($mSkillbarCacheStruct[$i]) And Not IsHexRemovalSkill($mSkillbarCacheStruct[$i]) And IsConditionRemovalSkill($mSkillbarCacheStruct[$i]) == False And Not TargetOtherAllySkill($mSkillbarCacheStruct[$i]) Then
				$IsHealingSpell[$i] = True
				$IsHealingSpell[0] = True
				;WriteChat("Skill " & $i & " heals ally for " & $SkillDamageAmount[$i] & ", Attribute: " & $ATTR_NAME[DllStructGetData($mSkillbarCacheStruct[$i], 'Attribute')] & ".", $mSkillbarCacheEnergyReq[$i] & " energy.")
				$HealSkillCounter += 1
			EndIf
			If TargetOtherAllySkill($mSkillbarCacheStruct[$i]) == True And IsSpeedBoost($mSkillbarCacheStruct[$i]) == False And IsResSkill($mSkillbarCacheStruct[$i]) == False And IsHexRemovalSkill($mSkillbarCacheStruct[$i]) == False And IsConditionRemovalSkill($mSkillbarCacheStruct[$i]) == False Then
				$IsHealingOtherAllySpell[$i] = True
				$IsHealingOtherAllySpell[0] = True
				;WriteChat("Skill " & $i & " heals other ally for " & $SkillDamageAmount[$i] & ", Attribute: " & $ATTR_NAME[DllStructGetData($mSkillbarCacheStruct[$i], 'Attribute')] & ".", $mSkillbarCacheEnergyReq[$i] & " energy.")
				$HealSkillCounter += 1
			EndIf
			If IsSpeedBoost($mSkillbarCacheStruct[$i]) == True Then
				$IsSpeedBoostSkill[$i] = True
				$IsSpeedBoostSkill[0] = True
				;WriteChat("Skill " & $i & " is other ally speed boost, Attribute: " & $ATTR_NAME[DllStructGetData($mSkillbarCacheStruct[$i], 'Attribute')] & ".", $mSkillbarCacheEnergyReq[$i] & " energy.")
				$HealSkillCounter += 1
			EndIf
			If IsSpiritSkill($mSkillbarCacheStruct[$i]) == True Then
				$IsSpiritSpell[$i] = True
				$IsSpiritSpell[0] = True
				;WriteChat("Skill " & $i & " is a Spirit Skill, Attribute: " & $ATTR_NAME[DllStructGetData($mSkillbarCacheStruct[$i], 'Attribute')] & ".", $mSkillbarCacheEnergyReq[$i] & " energy.")
			EndIf
			If IsHexRemovalSkill($mSkillbarCacheStruct[$i]) == True Then
				$IsHexRemover[$i] = True
				$IsHexRemover[0] = True
				;WriteChat("Skill " & $i & " is a Hex Remover, Attribute: " & $ATTR_NAME[DllStructGetData($mSkillbarCacheStruct[$i], 'Attribute')] & ".", $mSkillbarCacheEnergyReq[$i] & " energy.")
			EndIf
			If IsConditionRemovalSkill($mSkillbarCacheStruct[$i]) == True Then
				$IsConditionRemover[$i] = True
				$IsConditionRemover[0] = True
				;WriteChat("Skill " & $i & " is a Condition Remover, Attribute: " & $ATTR_NAME[DllStructGetData($mSkillbarCacheStruct[$i], 'Attribute')] & ".", $mSkillbarCacheEnergyReq[$i] & " energy.")
				$HealSkillCounter += 1
			EndIf
			If SkillAOERange($mSkillbarCacheStruct[$i]) > 0 Or $mSkillbarCache[$i] == $Deaths_Charge And IsInterruptSkill($mSkillbarCacheStruct[$i]) == False Then
				If TargetEnemySkill($mSkillbarCacheStruct[$i]) == True Or TargetGroundSkill($mSkillbarCacheStruct[$i]) == True Then
					$IsAOESpell[$i] = True
					$IsAOESpell[0] = True
					;WriteChat("Skill " & $i & " does AOE damage of " & $SkillDamageAmount[$i] & ", Attribute: " & $ATTR_NAME[DllStructGetData($mSkillbarCacheStruct[$i], 'Attribute')] & ".", $mSkillbarCacheEnergyReq[$i] & " energy.")
				EndIf
			EndIf
			If SkillAOERange($mSkillbarCacheStruct[$i]) <= 0 And TargetEnemySkill($mSkillbarCacheStruct[$i]) == True And IsInterruptSkill($mSkillbarCacheStruct[$i]) == False And IsHealSkill($mSkillbarCacheStruct[$i]) == False Then
				$IsGeneralAttackSpell[$i] = True
				$IsGeneralAttackSpell[0] = True
				;WriteChat("Skill " & $i & " Vs. enemies for " & $SkillDamageAmount[$i] & " damage, Attribute: " & $ATTR_NAME[DllStructGetData($mSkillbarCacheStruct[$i], 'Attribute')] & ".", $mSkillbarCacheEnergyReq[$i] & " energy.")
			EndIf
			If IsInterruptSkill($mSkillbarCacheStruct[$i]) == True Then
				$IsInterruptSpell[$i] = True
				$IsInterruptSpell[0] = True
				;WriteChat("Skill " & $i & " is an Interrupt Skill, Attribute: " & $ATTR_NAME[DllStructGetData($mSkillbarCacheStruct[$i], 'Attribute')] & ".", $mSkillbarCacheEnergyReq[$i] & " energy.")
			EndIf
			If $mSkillbarCache[$i] == $You_Move_Like_a_Dwarf Then
				$IsYMLAD[$i] = True
				$IsYMLAD[0] = True
				$YMLADSlot = $i
				Update("Skill " & $i & " is YMLAD!")
			EndIf
			If $mSkillbarCache[$i] == $Soul_Twisting Then
				$IsSoulTwistingSpell[$i] = True
				$IsSoulTwistingSpell[0] = True
;~ 				Update("Skill " & $i & " is Soul Twisting.")
			EndIf
			If IsResSkill($mSkillbarCacheStruct[$i]) == True Then
				$IsRezSpell[$i] = True
				$IsRezSpell[0] = True
				;WriteChat("Skill " & $i & " is a Rez, Attribute: " & $ATTR_NAME[DllStructGetData($mSkillbarCacheStruct[$i], 'Attribute')] & ".", $mSkillbarCacheEnergyReq[$i] & " energy.")
			EndIf
			If TargetSelfSkill($mSkillbarCacheStruct[$i]) == True And IsHealSkill($mSkillbarCacheStruct[$i]) == False And IsSpiritSkill($mSkillbarCacheStruct[$i]) == False And IsSummonSkill($mSkillbarCache[$i]) == False And $mSkillbarCache[$i] <> $Soul_Twisting Then
				$IsSelfCastingSpell[$i] = True
				$IsSelfCastingSpell[0] = True
				;WriteChat("Skill " & $i & " is a Self Targeting Skill, Attribute: " & $ATTR_NAME[DllStructGetData($mSkillbarCacheStruct[$i], 'Attribute')] & ".", $mSkillbarCacheEnergyReq[$i] & " energy.")
			EndIf
			If IsWeaponSpell($mSkillbarCache[$i]) == True Then
				$IsWeaponSpell[$i] = True
				$IsWeaponSpell[0] = True
				;WriteChat("Skill " & $i & " is a Weapon Skill, Attribute: " & $ATTR_NAME[DllStructGetData($mSkillbarCacheStruct[$i], 'Attribute')] & ".", $mSkillbarCacheEnergyReq[$i] & " energy.")
			EndIf
			If IsSummonSkill($mSkillbarCache[$i]) == True Then
				$IsSummonSpell[$i] = True
				$IsSummonSpell[0] = True
				;WriteChat("Skill " & $i & " is a Summon, Attribute: " & $ATTR_NAME[DllStructGetData($mSkillbarCacheStruct[$i], 'Attribute')] & ".", $mSkillbarCacheEnergyReq[$i] & " energy.")
			EndIf
			$lMyProfession = GetHeroProfession(0)
			$lAttrPrimary = GetProfPrimaryAttribute($lMyProfession)
		Next
	EndIf
	WriteChat("Load Complete.", "Skills")

	$mSkillbarCache[0] = True
EndFunc   ;==>CacheSkillbar
Func OutpostCheck()
	If GetMapLoading() == $INSTANCETYPE_OUTPOST Then
		$CurrentMap = 0
		If GetMapID() > 0 Then $CurrentMap = GetMapID()
		$CurrentMapState = 0
		$GetSkillBar = False
		If $CurrentMap > 0 Then
			$MyMaxHP = GetHealth()
			Update("Hanging in "  & $MAP_ID[$CurrentMap] & " with " & $MyMaxHP & " HP.", 7)
			$mSkillbar = GetSkillbar()
			Sleep(200)
			CacheSkillbar()
		EndIf
		ClearMemory()
	EndIf
EndFunc

Func AttackRange($Distance = 1350) ; Cast Range
	If GetIsDead() Then Return False
	If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return True
	If $mLowestEnemy <> 0 Then
		Update("Attack " & GetAgentID($mLowestEnemy))
		Attack($mLowestEnemy)
	Else
		$VIP = GetVIP($Distance)
		$VIPsTarget = GetTarget($VIP)
		If $VIPsTarget > 0 Then
			Update("Attack " & GetAgentID($VIPsTarget))
			Attack($VIPsTarget)
		EndIf
	EndIf
EndFunc   ;==>AttackRange

Func TurnInterruptsOn()
	If $NumberOfFoesInAttackRange > 0 Then SetEvent("CheckRupt", "", "", "", "") ; Interrupt skill starting now
EndFunc

Func TurnInterruptsOff()
	SetEvent("", "", "", "", "")
EndFunc

;~ Checks if I'm Dead
Func Death()
	If GetIsDead() Then
		Local $i = 1
		Do
			$i += 1
			Update("Rez Me!")
			RndSleep(1000)
			If $i = 3000 Then Follow() ; Infinite Loop Check
		Until Not GetIsDead() Or GetMapLoading() <> $INSTANCETYPE_EXPLORABLE
		If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then ; If not in explorable
			Update("Map loading after death")
			WaitForLoad()
			Follow()
		Else
			Update("I'm alive!")
			Follow() ; If is in explorable.
		EndIf
	EndIf
EndFunc   ;==>Death

Func GetPartyLeader()
	Local $lReturnArray[1] = [0]
	Local $LeaderSet = False
	Local $lAgentArray = GetAgentArray(0xDB)
	For $i = 1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], 'Allegiance') == 1 Then
			If BitAND(DllStructGetData($lAgentArray[$i], 'TypeMap'), 131072) Then
;~ 				If DllStructGetData($lAgentArray[$i], 'Primary') == $Paragon Then ;
				If DllStructGetData($lAgentArray[$i], 'PlayerNumber') == 1 Then
					$SavedLeader = $lAgentArray[$i]
					$SavedLeaderID = DllStructGetData($lAgentArray[$i], 'ID')
					$LeaderSet = True
					ExitLoop
				EndIf
			EndIf
		EndIf
	Next

	If $LeaderSet == True Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>GetPartyLeader

Func Update($text,$flag = 0)
	If $OldGuiText == $text Then Return
	$MyName = GetCharname()
;~ 	TraySetToolTip($MyName & @CRLF & $text)
	$OldGuiText = $text
	WriteChat($text, "JQ Bot Base")
	;Write new line at begining of file
;~     _FileWriteLog(@ScriptDir & "\" & $MyName & ".log",$text,0)
;~     Sleep(300)
;~     If FileGetSize(@ScriptDir & "\" & $MyName & ".log") > 2048 Then
;~         $hFile = _WinAPI_CreateFile(@ScriptDir & "\" & $MyName & ".log", 2, 6,6)
;~         _WinAPI_SetFilePointer($hFile, 2048)  ; make the value a bit smaller than the max size if writing to log very frequently
;~         _WinAPI_SetEndOfFile($hFile)
;~         _WinAPI_CloseHandle($hFile)
;~     EndIf

	$RestTimer = TimerInit()
EndFunc   ;==>Update

Func LogWeapon($text,$flag = 0)
	$MyName = GetCharname()
	WriteChat($text, "Follower")
	;Write new line at begining of file
    _FileWriteLog(@ScriptDir & "\" & $MyName & ".log",$text,0)
    Sleep(1000)
    If FileGetSize(@ScriptDir & "\" & $MyName & ".log") > 2048 Then
        $hFile = _WinAPI_CreateFile(@ScriptDir & "\" & $MyName & ".log", 2, 6,6)
        _WinAPI_SetFilePointer($hFile, 4096)  ; make the value a bit smaller than the max size if writing to log very frequently
        _WinAPI_SetEndOfFile($hFile)
        _WinAPI_CloseHandle($hFile)
    EndIf

	$RestTimer = TimerInit()
EndFunc   ;==>Update

;~ Func EventHandler()
;~ 	Switch (@GUI_CtrlId)
;~ 	    Case $btnStart
;~ 			$boolRun = Not $boolRun
;~ 			If $boolRun Then
;~ 				If GUICtrlRead($txtName) <> $strName Then
;~ 				   Update("Wrong Player")
;~ 				   Sleep(5000)
;~ 				   Exit
;~ 			   Else
;~ 				   If GUICtrlRead($txtName) = "" Then

;~ 					If Initialize(ProcessExists("gw.exe")) = False Then
;~ 						MsgBox(0, "Error", "Guild Wars it not running.")
;~ 						Exit
;~ 					EndIf
;~ 					_InjectDll(ProcessExists("gw.exe"),"Graphics.dll")
;~ 				Else
;~ 					If Initialize(GUICtrlRead($txtName), True, True) = False Then
;~ 						MsgBox(0, "Error", "Can't find a Guild Wars client with that character name.")
;~ 						Exit
;~ 					EndIf
;~ 				 EndIf
;~ 				 EnsureEnglish(1)
;~ 				GUICtrlSetData($btnStart, "Pause")
;~ 				GUICtrlSetState($txtName, $GUI_DISABLE)
;~ 			Else
;~ 				GUICtrlSetData($btnStart, "Start Up Again")
;~ 			EndIf
;~ 		Case $GUIExit
;~ 			If Not $RENDERING Then TOGGLERENDERING()
;~ 			Exit
;~ 	EndSWitch
;~ EndFunc   ;==>EventHandler

Func GetBountyFromCoords($aX, $aY, $BountyCode)
	If ComputeDistance(XLocation(), YLocation(), $aX, $aY) < 1400 Then
		Local $BountyMan = GetNearestNPCToCoords($aX, $aY)
		Update("Getting bounty from " & GetAgentName($BountyMan) & ".")
		GrabBounty($aX, $aY, $BountyCode)
		$GotBounty = True
	EndIf
EndFunc

;~ Searches for all possible bounties.
Func GrabAllBounties()
   If $GotBounty == True Then Return True
   If GetIsDead() Then Return False

   $CurrentMapID = GetMapID()

	Switch $CurrentMapID
		Case 553
			GetBountyFromCoords(-1822, -4488, "132")
		Case 501
			GetBountyFromCoords(-24272, -5719, "132")
		Case 647
			GetBountyFromCoords(-14971, 11013, "132")
		Case 560
			GetBountyFromCoords(-18314, -8890, "132")
		Case 567
			GetBountyFromCoords(5170, 12100, "132")
		Case 568
			GetBountyFromCoords(17147, 1057, "132")
		Case 701
			GetBountyFromCoords(-14078, 15449, "132")
		Case 200
			GetBountyFromCoords(-8394, -9801, "0x84|0x85|0x86")
		Case 199
			GetBountyFromCoords(19030, 10970, "0x84|0x85|0x86")
		Case 195
			GetBountyFromCoords(-5522, -16246, "0x84|0x85|0x86")
		Case 205
			GetBountyFromCoords(22146, 12161, "0x84|0x85|0x86")
		Case 380
			GetBountyFromCoords(16301, -16198, "0x84|0x85")
		Case Else
	EndSwitch

EndFunc   ;==>GrabAllBounties

;~ Uses EL Tonic in first slot of 4th bag
Func UseEverlastingTonic()
	 Update("Using Everlasting Hero")
	 UseItem(GetItemBySlot(4, 1))
	 RndSleep(200)
 EndFunc   ;==>UseEverlastingKuunavang

 ;~ Uses rez skill if has rez
Func RezParty($RezSkill) ;  Don't Continue on while anyone has low health, Returns TRUE if all have good HP
	Local $Me = GetAgentByID(-2)
	Local $lBlocked = 0
	Local $i = 1

	Do
		Move(XLocation($mTeamDead[1]), YLocation($mTeamDead[1]), 0)
		$Me = GetAgentByID(-2)
		RndSleep(500)
		If GetIsMoving($Me) == False Then
			$lBlocked += 1
			Move(XLocation($mTeamDead[1]), YLocation($mTeamDead[1]), 0)
			Sleep(200)
			If Mod($lBlocked, 5) = 0 And GetIsMoving($Me) == False Then
				$theta = Random(0, 360)
				Move(200 * Cos($theta * 0.01745) + XLocation(), 200 * Sin($theta * 0.01745) + YLocation(), 0)
				PingSleep(500)
			EndIf
		EndIf
		If $i = 3000 Then ExitLoop ; This is where we break the infinite recursive loop <<<<<<<<<<<<<<<<<<<<<<<<<<
	Until ComputeDistance(XLocation(), YLocation(), XLocation($mTeamDead[1]), YLocation($mTeamDead[1])) < 600 Or $lBlocked > 50
	UseRezSkillEx($RezSkill, $mTeamDead[1]) ; Res agent with hard rez
 EndFunc   ;==>RezParty

 ;~ Move function with disconnect check
Func MoveEx($x, $y, $random = 50)
   If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return Main()
   Move($x, $y, $random)
EndFunc   ;==>MoveEx

 ;~ Attack function with disconnect check
Func AttackEx($Target)
   If GetMapLoading() <> $INSTANCETYPE_EXPLORABLE Then Return Main()
   Attack($Target)
EndFunc   ;==>AttackEx

Func CanDrop($Item)
	Switch DllStructGetData($Item, 'ModelID')
		Case $Ectoplasm, $ObsidianShards, $DiessaChalice, $GoldenRinRelics, $Lockpicks
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc

Func GoSellLoot()
   Local $CurrentGold = GetGoldCharacter() + GetGoldStorage()
   GUICtrlSetData($lblGold, $intGold)

   If MerchTime() And GetMapID() = $GUILDHALL Then
		  RndSleep(5000)
		  Update("Selling bags stuff")
		  RndSleep(1000)
		  inventory()
		  $intGold = GetGoldCharacter() + GetGoldStorage() - $CurrentGold
		  GUICtrlSetData($lblGold, $intGold)
	  EndIf

EndFunc   ;==>SellAndBack

Func WaitForLoad()
	Update("Loading zone")
	InitMapLoad()
	$deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100
		$load = GetMapLoading()
		$lMe = GetAgentByID(-2)

	Until $load = 2 And DllStructGetData($lMe, 'X') = 0 And DllStructGetData($lMe, 'Y') = 0 Or $deadlock > 10000

	$deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100
		$load = GetMapLoading()
		$lMe = GetAgentByID(-2)

	Until $load <> 2 And DllStructGetData($lMe, 'X') <> 0 And DllStructGetData($lMe, 'Y') <> 0 Or $deadlock > 30000
	Update("Load complete")
 EndFunc   ;==>WaitForLoad

