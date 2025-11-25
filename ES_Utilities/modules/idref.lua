local _, addon = ...

addon.illusions = { -- [itemID] = illusionID
	--Default Illusions?
	--[0] = 1898, -- Lifestealing
	--[0] = 5862, -- Titanguard
	--[0] = 5861, -- Beastslayer
	--[0] = 5393, -- Crusader
	--[0] = 5389, -- Striking
	--[0] = 5387, -- Agility
	--//	
	[138787] = 1899, -- Unholy Weapon (Tome of Illusions: Azeroth)
	--[138787] = 803, -- Fiery Weapon (Tome of Illusions: Azeroth)
	--[138787] = 5863, -- Coldlight (Tome of Illusions: Azeroth)
	[138789] = 5390, -- Battlemaster (Tome of Illusions:Outland)
	--[138789] = 2674, -- Spellsurge (Tome of Illusions:Outland)
	--[138789] = 5864, -- Netherflame (Tome of Illusions:Outland)
	[138790] = 5391, -- Berserking (Tome of Illusions: Northrend)
	--[138790] = 5388, -- Greater Spellpower (Tome of Illusions: Northrend)
	--[138790] = 1894, -- Icy Chill (Tome of Illusions: Northrend)
	[138792] = 4067, -- Avalanche (Tome of Illusions: Elemental Lords)
	--[138792] = 4099, -- Landslide (Tome of Illusions: Elemental Lords)
	--[138792] = 4074, -- Elemental Slayer (Tome of Illusions: Elemental Lords)
	[138791] = 4098, -- Windwalk (Tome of Illusions: Cataclysm)
	--[138791] = 4084, -- Heartsong (Tome of Illusions: Cataclysm)
	--[138791] = 5867, -- Light of the Earth-Warder (Tome of Illusions: Cataclysm)
	[138794] = 4446, -- River's Song (Tome of Illusions: Secrets of the Shado-Pan)
	--[138794] = 4444, -- Dancing Steel (Tome of Illusions: Secrets of the Shado-Pan)
	[138793] = 4441, -- Windsong (Tome of Illusions: Pandaria)
	--[138793] = 4443, -- Elemental Force (Tome of Illusions: Pandaria)
	--[138793] = 5868, -- Breath of Yu'lon (Tome of Illusions: Pandaria)
	[138795] = 5334, -- Mark of the Frostwolf (Tome of Illusions: Draenor)
	--[138795] = 5330, -- Mark of the Thunderlord (Tome of Illusions: Draenor)
	[138832] = 5871, -- Earthliving (Shaman Only)
	[138833] = 5872, -- Flametongue (Shaman Only)
	[138834] = 5873, -- Frostbrand (Shaman Only)
	[138835] = 5874, -- Rockbiter (Shaman Only)
	[138955] = 5869, -- Rune of Razorice (Death Knight Only)
	[138797] = 2673, -- Mongoose
	[138800] = 3869, -- Blade Ward
	[138801] = 5392, -- Blood Draining
	[138802] = 4097, -- Power Torrent
	[118572] = 5394, -- Flame of Ragnaros
	[138796] = 3225, -- Executioner
	[138805] = 4442, -- Jade Spirit
	[138803] = 4066, -- Mending
	[138838] = 3273, -- Deathfrost
	[138804] = 4445, -- Colossus
	[128649] = 5448, -- Winter's Grasp
	[138808] = 5384, -- Mark of Bleeding Hollow
	[138807] = 5331, -- Mark of the Shattered Hand
	[138806] = 5335, -- Mark of Shadowmoon
	[138809] = 5336, -- Mark of Blackrock
	[138798] = 5865, -- Sunfire
	[138799] = 5866, -- Soulfrost
	[138827] = 5876, -- Nightmare
	[138828] = 5877, -- Chronos
	[172177] = 6162, -- Wraithchill
	[174932] = 6174, -- Void Edge
	[184351] = 6256, -- Devoted Spirit
	[184352] = 6257, -- Transcendent Soul
	[182204] = 6258, -- Sinwrath
	[182207] = 6259, -- Sinsedge
	[183189] = 6261, -- Undying Spirit
	[183462] = 6262, -- Unbreakable Resolve
	[184164] = 6263, -- Wild Soul
	[183134] = 6264, -- Hunt's Favor
	[200470] = 6672, -- Primal Mastery
	[200883] = 6675, -- Primal Air
	[200905] = 6676, -- Primal Earth
	[200906] = 6677, -- Primal Fire
	[200907] = 6678, -- Primal Frost
	[250776] = 7322, -- Sha Corruption
	[220765] = 7322, -- Sha Corruption (Remix)
	[253353] = 8549, -- Felshatter
}

addon.titles = { -- [itemID] = titleId
	[230258] = 856, -- Classic Enthusiast
	[230259] = 857, -- Outland Enthusiast
	[230260] = 858, -- Northrend Enthusiast
	[230261] = 859, -- Cataclysm Enthusiast
	[230262] = 860, -- Pandaria Enthusiast
	[230263] = 861, -- Draenor Enthusiast
	[230264] = 862, -- Broken Isles Enthusiast
	[230265] = 863, -- Zandalar Enthusiast
	[230266] = 864, -- Kul Tiras Enthusiast
	[230267] = 865, -- Shadowlands Enthusiast
	[230268] = 866, -- Dragon Isles Enthusiast
	[249242] = 925, -- Khaz Algar Enthusiast
	[229827] = 853, -- Plaguelands Survivor
	[229826] = 852, -- Grizzly Hills Hiker
	[231833] = 871, -- Karazhan Graduate
	[231832] = 870, -- Molten Core Prospector
}

addon.factionIDs = {
	-- The War Within
	2590, -- Council of Dornogal
	2570, -- Hallowfall Arathi
	2594, -- The Assembly of the Deeps
	2600, -- The Severed Threads
	2605, -- The General
	2607, -- The Vizier
	2601, -- The Weaver
	2653, -- The Cartels of Undermine
	2677, -- Steamwheedle Cartel
	2671, -- Venture Company
	2669, -- Darkfuse Solutions
	2673, -- Bilgewater Cartel
	2675, -- Blackwater Cartel
	2688, -- Flame's Radiance
	2658, -- The K'aresh Trust

	-- Dragonflight
	2574, -- Dream Wardens
	2511, -- Iskaara Tuskarr
	2564, -- Loamm Niffen
	2503, -- Maruuk Centaur
	2507, -- Dragonscale Expedition
	2510, -- Valdrakken Accord

	-- Shadowlands
	2407, -- The Ascended
	2413, -- Court of Harvesters
	2410, -- The Undying Army
	2465, -- The Wild Hunt
	2432, -- Ve'nari
	2470, -- Death's Advance
	2472, -- The Archivists' Codex
	2478, -- The Enlightened

	-- Battle for Azeroth
	2164, -- Champions of Azeroth
	2163, -- Tortollan Seekers
	2391, -- Rustbolt Resistance
	2415, -- Rajani
	2417, -- Uldum Accord
	2159, -- 7th Legion
	2161, -- Order of Embers
	2160, -- Proudmoore Admiralty
	2162, -- Storm's Wake
	2400, -- Waveblade Ankoan
	2157, -- The Honorbound
	2156, -- Talanji's Expedition
	2158, -- Voldunai
	2103, -- Zandalari Empire
	2373, -- The Unshackled

	-- Legion
	1828, -- Highmountain Tribe
	1900, -- Court of Farondis
	1883, -- Dreamweavers
	1894, -- The Wardens
	1948, -- Valarjar
	1859, -- The Nightfallen
	2045, -- Armies of Legionfall
	2170, -- Argussian Reach
	2165 -- Army of the Light
}

addon.currentRenowns = { -- Updating to only contain the most recent expansion
	["|cffff5d76Dornogal|r"] = {
		fid = 2590,
		id = {
			[3] = {82342},
			[5] = {84404},
			[6] = {82333},
			[7] = {82346},
			[8] = {84403},
			[9] = {82344},
			[11] = {82349},
			[12] = {82348},
			[17] = {82356,85545},
			[18] = {85546},
			[19] = {82358},
			[20] = {82359},
			[22] = {82361},
			[24] = {82365},
			[25] = {82362}    
		}
	},
	["|cfffcba75Ringing Deeps|r"] = {
		fid = 2594,
		id = {
			[6] = {82369},
			[7] = {82385},
			[8] = {82371},
			[9] = {82370},
			[10] = {82372},
			[11] = {82373},
			[12] = {82379},
			[13] = {82375},
			[14] = {82376},
			[15] = {82377},
			[16] = {82378},
			[17] = {83043},
			[18] = {85538},
			[20] = {82381},
			[21] = {82382},
			[22] = {85543,82383},
			[23] = {83046},
			[24] = {82384,85544},
			[25] = {84914}    
		}
	},
	["|cff9482c9Azj-Kahet|r"] = {
		fid = 2600,
		id = {
			[3] = {82417},
			[6] = {82418},
			[8] = {85535},
			[9] = {82431},
			[10] = {82432},
			[12] = {82433},
			[13] = {82434},
			[14] = {85532,82435},
			[18] = {82440,85533},
			[21] = {82443},
			[22] = {85534,82444},
			[24] = {82446}    
		}
	},
	["|cfffff000Hallowfall|r"] = {
		fid = 2570,
		id = {
			[4] = {82335},
			[6] = {82390},
			[7] = {84409},
			[8] = {82393},
			[9] = {82394},
			[12] = {82396},
			[13] = {84559},
			[14] = {82398},
			[16] = {82400,85536},
			[19] = {82403,85537},
			[22] = {82406},
			[23] = {83334},
			[24] = {82407}
		}
	},
	["|cffff7d0aFlame's Radiance|r"] = {
		fid = 2688,
		id = {
			[2] = {89349},
			[3] = {89390},
			[4] = {89391,89398},
			[5] = {89392},
			[6] = {89393},
			[7] = {89394,89399},
			[8] = {89395},
			[9] = {89396},
			[10] = {89397,89400}
		}
	},
	["|cff98ff00Undermine|r"] = {
		fid = 2653,
		id = {
			[3] = {85816},
			[4] = {85815},
			[6] = {85817},
			[8] = {85818},
			[9] = {85819,90557},
			[11] = {85820},
			[12] = {85821},
			[15] = {85823},
			[17] = {85824},
			[18] = {85825},
			[20] = {85827}
		}
	},
	["|cff69ccf0K'aresh|r"] = {
		fid = 2658,
		id = {
			[5] = {90630,90631},
			[6] = {90632},
			[8] = {90633,90634},
			[9] = {90635},
			[12] = {90636,90637},
			[13] = {90638},
			[14] = {91143},
			[16] = {92330},
			[17] = {90665},
			[18] = {90666},
			[20] = {90667}
		}
	}
}

addon.items = { -- Items to find through bagcheck function
	["keyIds"] = {
		[180653] = true, -- Shadowlands, Dragonflight and The War Within
		[158923] = false, -- BfA
		[138019] = false, -- Legion
		[187786] = false, -- Timewalking
		[151086] = false, -- Tournament
	},
	["magefood"] = {
		[113509] = true, -- "Conjured Mana Bun"
		[80618] = true, -- "Conjured Mana Fritter"
		[80610] = true, -- "Conjured Mana Pudding"
		[65499] = true, -- "Conjured Mana Cake"
		[43523] = true, -- "Conjured Mana Strudel"
		[43518] = true, -- "Conjured Mana Pie"
		[65517] = true, -- "Conjured Mana Lollipop"
		[65516] = true, -- "Conjured Mana Cupcake"
		[65515] = true, -- "Conjured Mana Brownie"
		[65500] = true, -- "Conjured Mana Cookie"
	}
}

addon.currencies = {
	[1] = 3269, -- Catalyst
	[2] = 3008, -- Valor
	[3] = 3284, -- Weathered
	[4] = 3286, -- Carved
	[5] = 3288, -- Runed
	[6] = 3290 -- Gilded
}