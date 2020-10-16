local _G = _G
local _, RE = ...
local L = LibStub("AceLocale-3.0"):GetLocale("REFlex")

local GetRealZoneText = _G.GetRealZoneText
local GetClassInfo = _G.GetClassInfo
local GetNumSpecializationsForClassID = _G.GetNumSpecializationsForClassID
local GetSpecializationInfoForClassID = _G.GetSpecializationInfoForClassID
local ReloadUI = _G.ReloadUI

RE.DefaultConfig = {
	["MiniMapButtonSettings"] = {["hide"] = false},
	["ShowServerName"] = false,
	["CurrentTab"] = 1,
	["Filters"] = {["Spec"] = _G.ALL, ["Map"] = 1, ["Bracket"] = 1, ["Date"] = {0, 0}, ["Season"] = 0, ["DateMode"] = 1},
	["FirstTime"] = true,
	["LDBMode"] = 3,
	["LDBSide"] = "A",
	["ArenaStatsLimit"] = 3,
	["ConfigVersion"] = RE.Version
}

RE.MapList = {
	[30] = GetRealZoneText(30),
	[2107] = GetRealZoneText(2107),
	[1191] = GetRealZoneText(1191),
	[1691] = GetRealZoneText(1691),
	[2245] = GetRealZoneText(2245),
	[1105] = GetRealZoneText(1105),
	[566] = GetRealZoneText(566),
	[968] = GetRealZoneText(566),
	[628] = GetRealZoneText(628),
	[727] = GetRealZoneText(727),
	[607] = GetRealZoneText(607),
	[1035] = GetRealZoneText(1035),
	[761] = GetRealZoneText(761),
	[726] = GetRealZoneText(726),
	[2106] = GetRealZoneText(2106),
	[1280] = GetRealZoneText(1280),
	[1803] = GetRealZoneText(1803),
	[2118] = GetRealZoneText(2118),
	[1552] = RE:GetShortMapName(GetRealZoneText(1552)),
	[1504] = RE:GetShortMapName(GetRealZoneText(1504)),
	[562] = RE:GetShortMapName(GetRealZoneText(1672)),
	[1672] = RE:GetShortMapName(GetRealZoneText(1672)),
	[617] = RE:GetShortMapName(GetRealZoneText(617)),
	[559] = RE:GetShortMapName(GetRealZoneText(1505)),
	[1505] = RE:GetShortMapName(GetRealZoneText(1505)),
	[572] = RE:GetShortMapName(GetRealZoneText(572)),
	[1134] = RE:GetShortMapName(GetRealZoneText(1134)),
	[980] = RE:GetShortMapName(GetRealZoneText(980)),
	[1911] = RE:GetShortMapName(GetRealZoneText(1911)),
	[1825] = RE:GetShortMapName(GetRealZoneText(1825)),
	[2167] = RE:GetShortMapName(GetRealZoneText(2167))
}

RE.MapListLongBG = {
	[1] = _G.ALL,
	[30] = GetRealZoneText(30),
	[2107] = GetRealZoneText(2107),
	[1191] = GetRealZoneText(1191),
	[1691] = GetRealZoneText(1691),
	[2245] = GetRealZoneText(2245),
	[1105] = GetRealZoneText(1105),
	[566] = GetRealZoneText(566),
	[628] = GetRealZoneText(628),
	[1803] = GetRealZoneText(1803),
	[727] = GetRealZoneText(727),
	[607] = GetRealZoneText(607),
	[1280] = GetRealZoneText(1280),
	[1035] = GetRealZoneText(1035),
	[761] = GetRealZoneText(761),
	[726] = GetRealZoneText(726),
	[2106] = GetRealZoneText(2106),
	[2118] = GetRealZoneText(2118)
}

RE.MapListLongArena = {
	[1] = _G.ALL,
	[1552] = GetRealZoneText(1552),
	[1504] = GetRealZoneText(1504),
	[1672] = GetRealZoneText(1672),
	[617] = GetRealZoneText(617),
	[1505] = GetRealZoneText(1505),
	[572] = GetRealZoneText(572),
	[1134] = GetRealZoneText(1134),
	[980] = GetRealZoneText(980),
	[1911] = GetRealZoneText(1911),
	[1825] = GetRealZoneText(1825),
	[2167] = GetRealZoneText(2167)
}

RE.MapListLongOrderBG = {
	1, 30, 2107, 1191, 2118, 1691, 2245, 1105, 566, 628, 1803, 727, 1280, 607, 1035, 761, 726, 2106
}

RE.MapListLongOrderArena = {
	1, 1552, 1504, 1672, 617, 1825, 1911, 1505, 2167, 572, 1134, 980
}

RE.MapListStat = {
	[2106] = {true, "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture", "Interface\\WorldStateFrame\\ColumnIcon-FlagReturn"},
	[726] = {true, "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture", "Interface\\WorldStateFrame\\ColumnIcon-FlagReturn"},
	[2107] = {true, "Interface\\WorldStateFrame\\ColumnIcon-TowerCapture", "Interface\\WorldStateFrame\\ColumnIcon-TowerDefend"},
	[566] = {false, "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture2"},
	[567] = {true, "Interface\\WorldStateFrame\\ColumnIcon-TowerCapture", "Interface\\WorldStateFrame\\ColumnIcon-TowerDefend", "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture2"},
	[761] = {true, "Interface\\WorldStateFrame\\ColumnIcon-TowerCapture", "Interface\\WorldStateFrame\\ColumnIcon-TowerDefend"},
	[1035] = {false, "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture2", "Interface\\GroupFrame\\UI-Group-MasterLooter"},
	[2245] = {true, "Interface\\WorldStateFrame\\ColumnIcon-TowerCapture", "Interface\\WorldStateFrame\\ColumnIcon-TowerDefend"},
	[1105] = {true, "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture", "Interface\\WorldStateFrame\\ColumnIcon-FlagReturn", "Interface\\WorldStateFrame\\ColumnIcon-TowerCapture", "Interface\\WorldStateFrame\\ColumnIcon-TowerDefend"},
	[727] = {false, "Interface\\MINIMAP\\Vehicle-SilvershardMines-MineCart"},
	[30] = {true, "Interface\\WorldStateFrame\\ColumnIcon-GraveyardCapture", "Interface\\WorldStateFrame\\ColumnIcon-GraveyardDefend", "Interface\\WorldStateFrame\\ColumnIcon-TowerCapture", "Interface\\WorldStateFrame\\ColumnIcon-TowerDefend"},
	[628] = {true, "Interface\\WorldStateFrame\\ColumnIcon-TowerCapture", "Interface\\WorldStateFrame\\ColumnIcon-TowerDefend"},
	[607] = {false, "Interface\\MINIMAP\\Vehicle-AllianceCart", "Interface\\MINIMAP\\Suramar_Door_Icon"},
	[1803] = {false, "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture2"},
	[1691] = {false, "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture2"},
	[1191] = {false, "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture2"},
}

RE.RaceIcons = {
	["Human"]	= {0.388672, 0.513672, 0.130859, 0.255859},
	["Humans"]	= {0.388672, 0.513672, 0.130859, 0.255859},
	["Dwarf"]	= {0.00195312, 0.126953, 0.130859, 0.255859},
	["Dwarves"]	= {0.00195312, 0.126953, 0.130859, 0.255859},
	["Gnome"]	= {0.00195312, 0.126953, 0.388672, 0.513672},
	["Gnomes"]	= {0.00195312, 0.126953, 0.388672, 0.513672},
	["Night Elf"]	= {0.388672, 0.513672, 0.259766, 0.384766},
	["Night elves"]	= {0.388672, 0.513672, 0.259766, 0.384766},
	["Tauren"] = {0.259766, 0.384766, 0.646484, 0.771484},
	["Undead"] = {0.646484, 0.771484, 0.388672, 0.513672},
	["Troll"]	= {0.388672, 0.513672, 0.388672, 0.513672},
	["Trolls"]	= {0.388672, 0.513672, 0.388672, 0.513672},
	["Orc"]	= {0.646484, 0.771484, 0.259766, 0.384766},
	["Orcs"]	= {0.646484, 0.771484, 0.259766, 0.384766},
	["Blood Elf"]	= {0.130859, 0.255859, 0.00195312, 0.126953},
	["Blood elves"]	= {0.130859, 0.255859, 0.00195312, 0.126953},
	["Draenei"]	= {0.646484, 0.771484, 0.00195312, 0.126953},
	["Goblin"] = {0.00195312, 0.126953, 0.646484, 0.771484},
	["Goblins"] = {0.00195312, 0.126953, 0.646484, 0.771484},
	["Worgen"] = {0.388672, 0.513672, 0.775391, 0.900391},
	["Pandaren"] = {0.259766, 0.384766, 0.388672, 0.513672},
	["Nightborne"] = {0.130859, 0.255859, 0.775391, 0.900391},
	["Highmountain Tauren"] = {0.130859, 0.255859, 0.130859, 0.255859},
	["Void Elf"] = {0.388672, 0.513672, 0.517578, 0.642578},
	["Void elves"] = {0.388672, 0.513672, 0.517578, 0.642578},
	["Lightforged Draenei"] = {0.130859, 0.255859, 0.259766, 0.384766},
	["Dark Iron Dwarf"] = {0.388672, 0.513672, 0.00195312, 0.126953},
	["Dark Iron Dwarves"] = {0.388672, 0.513672, 0.00195312, 0.126953},
	["Mag'har Orc"] = {0.130859, 0.255859, 0.517578, 0.642578},
	["Zandalari Troll"] = {0.646484, 0.771484, 0.517578, 0.642578},
	["Zandalari Trolls"] = {0.646484, 0.771484, 0.517578, 0.642578},
	["Kul Tiran"] = {0.646484, 0.771484, 0.130859, 0.255859},
	["Vulpera"] = {0.646484, 0.771484, 0.646484, 0.771484},
	["Vulperas"] = {0.646484, 0.771484, 0.646484, 0.771484},
	["Mechagnome"] = {0.517578, 0.642578, 0.646484, 0.771484},
	["Mechagnomes"] = {0.517578, 0.642578, 0.646484, 0.771484}
}

RE.BracketNames = {
	_G.ARENA_2V2,
	_G.ARENA_3V3,
	"",
	_G.BATTLEGROUND_10V10
}

RE.MapIDRemap = {
	[968] = 566,
	[998] = 1035,
	[1681] = 2107,
	[2197] = 30
}

RE.Roles = {}
for classID=1, _G.MAX_CLASSES do
	local _, classTag = GetClassInfo(classID)
	local specNum = GetNumSpecializationsForClassID(classID)
	RE.Roles[classTag] = {}
	for i=1, specNum do
		local _, name, _, _, role = GetSpecializationInfoForClassID(classID, i)
		RE.Roles[classTag][name] = role
	end
end

RE.StatsDropDown = {
	{ text = L["Most common teams"], notCheckable = true, func = function() RE:GetArenaStatsTooltip(1) end },
	{ text = L["Easiest teams"], notCheckable = true, func = function() RE:GetArenaStatsTooltip(2) end },
	{ text = L["Hardest teams"], notCheckable = true, func = function() RE:GetArenaStatsTooltip(3) end }
}

RE.AceConfig = {
	type = "group",
	args = {
		minimap = {
			name = L["Hide minimap button"],
			type = "toggle",
			width = "full",
			order = 1,
			set = function(_, val) RE.Settings.MiniMapButtonSettings.hide = val; RE:UpdateConfig() end,
			get = function(_) return RE.Settings.MiniMapButtonSettings.hide end
		},
		servername = {
			name = L["Display server names"],
			desc = L["Show player server name in match detail tooltip."],
			type = "toggle",
			width = "full",
			order = 2,
			set = function(_, val) RE.Settings.ShowServerName = val end,
			get = function(_) return RE.Settings.ShowServerName end
		},
		arenalimit = {
			name = L["Arena composition statistics limit"],
			desc = L["A minimal number of matches required to be included in arena team composition statistics."],
			type = "range",
			width = "double",
			order = 3,
			min = 1,
			max = 10,
			step = 1,
			set = function(_, val) RE.Settings.ArenaStatsLimit = val end,
			get = function(_) return RE.Settings.ArenaStatsLimit end
		},
		ldbmode = {
			name = L["LDB feed display mode"],
			desc = L["Rating display always compares the values with the previous week."],
			type = "select",
			width = "double",
			order = 4,
			values = {
				[1] = L["Current session"],
				[2] = _G.HONOR_TODAY,
				[3] = _G.GUILD_CHALLENGES_THIS_WEEK
			},
			set = function(_, val) RE.Settings.LDBMode = val; RE.LDBUpdate = true; RE:UpdateLDBTime(); RE:UpdateLDB() end,
			get = function(_) return RE.Settings.LDBMode end
		},
		deletebase = {
			name = L["Purge database"],
			desc = L["WARNING! This operation is not reversible!"],
			type = "execute",
			width = "double",
			confirm = true,
			order = 5,
			func = function() _G.REFlexDatabase = {}; _G.REFlexHonorDatabase = {}; ReloadUI() end
		},
		deleteoldseason = {
			name = L["Purge previous seasons"],
			desc = L["WARNING! This operation is not reversible!"],
			type = "execute",
			width = "double",
			confirm = true,
			order = 6,
			func = function() RE:SeasonPurge(); ReloadUI() end
		}
	}
}

RE.BGStructure = {
	{
		["name"] = L["Date"],
		["width"] = 110,
		["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Time", 0) end,
		["bgcolor"] = {
			["r"] = 0.15,
			["g"] = 0.15,
			["b"] = 0.15,
			["a"] = 1.0
		},
		["align"] = "CENTER"
	},
	{
		["name"] = _G.BATTLEGROUND,
		["width"] = 130,
		["color"] = RE.GetMapColor,
		["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Map", 0) end,
		["align"] = "CENTER"
	},
	{
		["name"] = _G.AUCTION_DURATION,
		["width"] = 70,
		["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Duration", 0) end,
		["bgcolor"] = {
			["r"] = 0.15,
			["g"] = 0.15,
			["b"] = 0.15,
			["a"] = 1.0
		},
		["align"] = "CENTER"
	},
	{
		["name"] = _G.WIN,
		["width"] = 50,
		["align"] = "CENTER"
	},
	{
		["name"] = "KB",
		["width"] = 50,
		["bgcolor"] = {
			["r"] = 0.15,
			["g"] = 0.15,
			["b"] = 0.15,
			["a"] = 1.0
		},
		["align"] = "CENTER"
	},
	{
		["name"] = "HK",
		["width"] = 50,
		["align"] = "CENTER"
	},
	{
		["name"] = _G.DAMAGE,
		["width"] = 65,
		["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Damage", 12) end,
		["bgcolor"] = {
			["r"] = 0.15,
			["g"] = 0.15,
			["b"] = 0.15,
			["a"] = 1.0
		},
		["align"] = "CENTER"
	},
	{
		["name"] = _G.SHOW_COMBAT_HEALING,
		["width"] = 65,
		["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Healing", 13) end,
		["align"] = "CENTER"
	},
	{
		["name"] = _G.HONOR,
		["width"] = 65,
		["color"] = {
			["r"] = 0.80,
			["g"] = 0.60,
			["b"] = 0,
			["a"] = 1.0
		},
		["bgcolor"] = {
			["r"] = 0.15,
			["g"] = 0.15,
			["b"] = 0.15,
			["a"] = 1.0
		},
		["align"] = "CENTER"
	},
	{
		["name"] = _G.RATING,
		["width"] = 65,
		["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Rating", 15) end,
		["align"] = "CENTER"
	}
}

RE.ArenaStructure = {
	{
		["name"] = L["Date"],
		["width"] = 110,
		["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Time", 0) end,
		["bgcolor"] = {
			["r"] = 0.15,
			["g"] = 0.15,
			["b"] = 0.15,
			["a"] = 1.0
		},
		["align"] = "CENTER"
	},
	{
		["name"] = _G.ARENA,
		["width"] = 60,
		["color"] = RE.GetMapColorArena,
		["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Map", 0) end,
		["align"] = "CENTER"
	},
	{
		["name"] = _G.TEAM,
		["width"] = 100,
		["bgcolor"] = {
			["r"] = 0.15,
			["g"] = 0.15,
			["b"] = 0.15,
			["a"] = 1.0
		},
		["align"] = "CENTER"
	},
	{
		["name"] = "MMR",
		["width"] = 50,
		["align"] = "CENTER"
	},
	{
		["name"] = _G.ENEMY,
		["width"] = 100,
		["bgcolor"] = {
			["r"] = 0.15,
			["g"] = 0.15,
			["b"] = 0.15,
			["a"] = 1.0
		},
		["align"] = "CENTER"
	},
	{
		["name"] = "MMR",
		["width"] = 50,
		["align"] = "CENTER"
	},
	{
		["name"] = _G.AUCTION_DURATION,
		["width"] = 60,
		["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Duration", 0) end,
		["bgcolor"] = {
			["r"] = 0.15,
			["g"] = 0.15,
			["b"] = 0.15,
			["a"] = 1.0
		},
		["align"] = "CENTER"
	},
	{
		["name"] = _G.DAMAGE,
		["width"] = 70,
		["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Damage", 12) end,
		["align"] = "CENTER"
	},
	{
		["name"] = _G.SHOW_COMBAT_HEALING,
		["width"] = 70,
		["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Healing", 13) end,
		["bgcolor"] = {
			["r"] = 0.15,
			["g"] = 0.15,
			["b"] = 0.15,
			["a"] = 1.0
		},
		["align"] = "CENTER"
	},
	{
		["name"] = _G.RATING,
		["width"] = 50,
		["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Rating", 15) end,
		["align"] = "CENTER"
	}
}
