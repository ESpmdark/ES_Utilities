local _, addon = ...
local fact, _ = UnitFactionGroup("player")

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
	[1] = 3378, -- Catalyst
	[2] = 3383, -- Adventurer
	[3] = 3341, -- Veteran
	[4] = 3343, -- Champion
	[5] = 3345, -- Hero
	[6] = 3347 -- Myth
}

local factionlookup = {
	["Alliance"] = {
		[1] = {port = 33691, tele = 33690, name = "Shattrath"},
		[2] = {port = 88345, tele = 88342, name = "Tol Barad"},
		[3] = {port = 132620, tele = 132621, name = "Vale of\nEternal\nBlossoms"},
		[4] = {port = 176246, tele = 176248, name = "Ashran"}
	},
	["Horde"] = {
		[1] = {port = 35717, tele = 35715, name = "Shattrath"},
		[2] = {port = 88346, tele = 88344, name = "Tol Barad"},
		[3] = {port = 132626, tele = 132627, name = "Vale of\nEternal\nBlossoms"},
		[4] = {port = 176244, tele = 176242, name = "Ashran"}
	}
}

addon.ports = { -- Mage Teleports/Portals
	[1] = {port = 11417, tele = 3567, name = "Orgrimmar"},
	[2] = {port = 10059, tele = 3561, name = "Stormwind"},
	[3] = {port = 11418, tele = 3563, name = "Undercity"},
	[4] = {port = 11416, tele = 3562, name = "Ironforge"},
	[5] = {port = 11420, tele = 3566, name = "Thunder Bluff"},
	[6] = {port = 11419, tele = 3565, name = "Darnassus"},
	[7] = {port = 32267, tele = 32272, name = "Silvermoon"},
	[8] = {port = 32266, tele = 32271, name = "Exodar"},
	[9] = {port = 49361, tele = 49358, name = "Stonard"},
	[10] = {port = 49360, tele = 49359, name = "Theramore"},
	[11] = factionlookup[fact][1], -- Shattrath
	[12] = {port = 53142, tele = 53140, name = "Dalaran\nNorthrend"},
	[13] = factionlookup[fact][2], -- Tol Barad
	[14] = {port = 120146, tele = 120145, name = "Dalaran\nAncient"},
	[15] = factionlookup[fact][3], -- Vale of Eternal Blossoms
	[16] = factionlookup[fact][4], -- Ashran
	[17] = {port = 224871, tele = 224869, name = "Dalaran\nLegion"},
	[18] = {port = false, tele = 193759, name = "Hall of the\nGuardian"},
	[19] = {port = 281402, tele = 281404, name = "Dazar'alor"},
	[20] = {port = 281400, tele = 281403, name = "Boralus"},
	[21] = {port = 344597, tele = 344587, name = "Oribos"},
	[22] = {port = 395289, tele = 395277, name = "Valdrakken"},
	[23] = {port = 446534, tele = 446540, name = "Dornogal"},
}

addon.mainTitle = { -- Category titles for main window
	[1] = "General",
	[2] = "Engineering",
	[3] = "Mage",
}

addon.dungeonTitle = { -- Category titles for dungeon window
	[1] = "Other",
	[2] = "Legion",
	[3] = "Battle for Azeroth",
	[4] = "Shadowlands",
	[5] = "Dragonflight",
	[6] = "The War Within",
	[7] = "Midnight",
	[8] = "Current Season",
}

addon.dungeon = {
	[1] = { -- Other
		[445424] = "Grim Batol",
		[159899] = "Shadowmoon\nBurial Grounds",
		[159900] = "Grimrail\nDepot",
		[159896] = "Iron Docks",
		[131204] = "Temple of the\nJade Serpent",
		[424142] = "Throne of\nthe Tides",
		[159901] = "The\nEverbloom",
		[410080] = "Vortex\nPinnacle",
		--[1254555] = "Pit of\nSaron",
		--[1254557] = "Skyreach", -- 159898 is the original ID from WOD
	},
	[2] = { -- Legion
		[424153] = "Black Rook\nHold",
		[393766] = "Court of\nStars",
		[424163] = "Darkheart\nThicket",
		[393764] = "Halls of\nValor",
		[410078] = "Neltharion's\nLair",
		[373262] = "Karazhan",
		--[1254551] = " Seat of the\nTriumvirate",
	},
	[3] = { -- Battle for Azeroth
		[424187] = "Atal Dazar",
		[410071] = "Freehold",
		[373274] = "Operation:\nMechagon",
		[445418] = "Siege of\nBoralus", --Alliance
		[464256] = "Siege of\nBoralus", --Horde
		[410074] = "Underrot",
		[424167] = "Waycrest\nManor",
		[467555] = "The\nMOTHERLODE!!",
	},
	[4] = { -- Shadowlands
		[354463] = "Plaguefall",
		[354468] = "De Other\nSide",
		[354465] = "Halls of\nAtonement",
		[354464] = "Mists of\nTirna Scithe",
		[354462] = "Necrotic\nWake",
		[354469] = "Sanguine\nDepths",
		[354466] = "Spires of\nAscension",
		[354467] = "Theater\nof Pain",
		[367416] = "Tazavesh",
	},
	[5] = { -- Dragonflight
		--[393273] = "Algeth'ar\nAcademy",
		[393267] = "Brackenhide\nHollow",
		[393283] = "Halls of\nInfusion",
		[393276] = "Neltharus",
		[393256] = "Ruby\nLife Pools",
		[393279] = "Azure Vault",
		[393262] = "Nokhud\nOffensive",
		[393222] = "Uldaman:LoT",
		[424197] = "Dawn of\nthe Infinite",
	},
	[6] = { -- The War Within
		[445269] = "Stonevault",
		[445414] = "Dawnbreaker",
		[445417] = "Ara-Kara",
		[445416] = "City of\nThreads",
		[445443] = "The Rookery",
		[445440] = "Cinderbrew\nMeadery",
		[445444] = "Priory of the\nSacred Flame",
		[445441] = "Darkflame\nCleft",
		[1216786] = "Operation:\nFloodgate",
		[1237215] = "Eco-Dome\nAl'dani",
	},
	[7] = { -- Midnight
		--[1254572] = "Magister's\nTerrace",
		--[1254400] = "Windrunner\nSpire",
		--[1254563] = "Nexus Point\nXenas", -- Marked as placeholder, verify later.
		--[1254559] = "Maisara\nCaverns", -- Marked as placeholder, verify later.
	},
	[8] ={ -- Current Season
		[393273] = "Algeth'ar\nAcademy",
		[1254551] = " Seat of the\nTriumvirate",
		[1254557] = "Skyreach",
		[1254555] = "Pit of\nSaron",
		[1254572] = "Magister's\nTerrace",
		[1254400] = "Windrunner\nSpire",
		[1254563] = "Nexus Point\nXenas",
		[1254559] = "Maisara\nCaverns",
	},
}

addon.wormholes = {
	[1] = {id = 18986, name = "Gadgetzan"},
	[2] = {id = 18984, name = "Everlook"},
	[3] = {id = 30544, name = "Toshley's Station"},
	[4] = {id = 30542, name = "Area 52"},
	[5] = {id = 48933, name = "Northrend"},
	[6] = {id = 87215, name = "Pandaria"},
	[7] = {id = 112059, name = "Draenor"},
	[8] = {id = 151652, name = "Argus"},
	[9] = {id = 144341, item = "Rechargeable Reaves Battery", name = "Legion"},
	[10] = {id = 168807, name = "Kul Tiras"},
	[11] = {id = 168808, name = "Zandalar"},
	[12] = {id = 172924, name = "Shadowlands"},
	[13] = {id = 198156, name = "Dragon Isles"},
	[14] = {id = 221966, name = "Khaz Algar"},
	[15] = {id = 248485, name = "Quel'Thalas"},
}

local questRef = {
	[140192] = {44663, 44184}, -- Dalaran
	[110560] = {34378, 34586}, -- Garrrison
}

addon.checkQuest = function(questId)
	for _,id in ipairs(questRef[questId]) do
		if C_QuestLog.IsQuestFlaggedCompleted(id) then
			return true
		end
	end
	return false
end

addon.general = {
	[1] = {id = 126892, type = "spell", name = "Zen\nPilgrimage"},
	[2] = {id = 50977, type = "spell", name = "Death Gate"},
	[3] = {id = 18960, type = "spell", name = "Moonglade"},
	[4] = {id = 193753, type = "spell", name = "Dreamwalk"},
	[5] = {id = 253629, type = "toy", name = "Arcantina"},
	[6] = {id = 243056, type = "toy", name = "Dornogal"},
	[7] = {id = 110560, type = "toy", name = "Garrison", quest = true},
	[8] = {id = 140192, type = "toy", name = "Dalaran", quest = true},
	[9] = {id = 556, type = "spell", name = "Astral Recall"},
	[10] = {id = 6948, type = "item", name = "Hearthstone"},
}

local list = { -- Toys to check and add for HS override setting
	[166747] = "Brewfest Reveler's Hearthstone",
	[190237] = "Broker Translocation Matrix",
	[246565] = "Cosmic Hearthstone",
	[93672] = "Dark Portal",
	[208704] = "Deepdweller's Earthen Hearthstone",
	[188952] = "Dominated Hearthstone",
	[190196] = "Enlightened Hearthstone",
	[172179] = "Eternal Traveler's Hearthstone",
	[54452] = "Ethereal Portal",
	[236687] = "Explosive Hearthstone",
	[166746] = "Fire Eater's Hearthstone",
	[162973] = "Greatfather Winter's Hearthstone",
	[163045] = "Headless Horseman's Hearthstone",
	[209035] = "Hearthstone of the Flame",
	[168907] = "Holographic Digitalization Hearthstone",
	[184353] = "Kyrian Hearthstone",
	[165669] = "Lunar Elder's Hearthstone",
	[182773] = "Necrolord Hearthstone",
	[180290] = "Night Fae Hearthstone",
	[165802] = "Noble Gardener's Hearthstone",
	[228940] = "Notorious Thread's Hearthstone",
	[200630] = "Ohn'ir Windsage's Hearthstone",
	[245970] = "P.O.S.T. Master's Express Hearthstone",
	[206195] = "Path of the Naaru",
	[165670] = "Peddlefeet's Lovely Hearthstone",
	[235016] = "Redeployment Module",
	[212337] = "Stone of the Hearth",
	[64488] = "The Innkeeper's Daughter",
	[193588] = "Timewalker's Hearthstone",
	[142542] = "Tome of Town Portal",
	[183716] = "Venthyr Hearthstone",
}

addon.knownToys = {}
addon.knownReversed = {}

addon.getToyName = function(itemID)
	return list[itemID]
end

addon.initToys = function()
	table.wipe(addon.knownToys)
	table.wipe(addon.knownReversed)
	for k,v in pairs(list) do
		if PlayerHasToy(k) then
			addon.knownToys[k] = v
		end
	end
	local sorted = {}
	for k,v in pairs(addon.knownToys) do
		addon.knownReversed[v] = k
		table.insert(sorted, v)
	end
	table.sort(sorted)
	addon.knownToys = sorted
end

