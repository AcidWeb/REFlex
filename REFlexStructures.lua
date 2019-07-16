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
	["Toasts"] = true,
	["ShowServerName"] = false,
	["CurrentTab"] = 1,
	["Filters"] = {["Spec"] = ALL, ["Map"] = 1, ["Bracket"] = 1, ["Date"] = {0, 0}, ["Season"] = 0, ["DateMode"] = 1},
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
	[1] = ALL,
	[30] = GetRealZoneText(30),
	[2107] = GetRealZoneText(2107),
	[1191] = GetRealZoneText(1191),
	[1691] = GetRealZoneText(1691),
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
	[1] = ALL,
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
	1, 30, 2107, 1191, 2118, 1691, 1105, 566, 628, 1803, 727, 1280, 607, 1035, 761, 726, 2106
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
	["Human"]	= {0, 0.125, 0, 0.25},
	["Humans"]	= {0, 0.125, 0, 0.25},
	["Dwarf"]	= {0.125, 0.25, 0, 0.25},
	["Dwarves"]	= {0.125, 0.25, 0, 0.25},
	["Gnome"]	= {0.25, 0.375, 0, 0.25},
	["Gnomes"]	= {0.25, 0.375, 0, 0.25},
	["Night Elf"]	= {0.375, 0.5, 0, 0.25},
	["Night elves"]	= {0.375, 0.5, 0, 0.25},
	["Tauren"] = {0, 0.125, 0.25, 0.5},
	["Undead"] = {0.125, 0.25, 0.25, 0.5},
	["Troll"]	= {0.25, 0.375, 0.25, 0.5},
	["Trolls"]	= {0.25, 0.375, 0.25, 0.5},
	["Orc"]	= {0.375, 0.5, 0.25, 0.5},
	["Ors"]	= {0.375, 0.5, 0.25, 0.5},
	["Blood Elf"]	= {0.5, 0.625, 0.25, 0.5},
	["Blood elves"]	= {0.5, 0.625, 0.25, 0.5},
	["Draenei"]	= {0.5, 0.625, 0, 0.25},
	["Goblin"] = {0.629, 0.750, 0.25, 0.5},
	["Goblins"] = {0.629, 0.750, 0.25, 0.5},
	["Worgen"] = {0.629, 0.750, 0, 0.25},
	["Pandaren"] = {0.756, 0.881, 0, 0.25},
	["Nightborne"] = {0.375, 0.5, 0, 0.25},
	["Highmountain Tauren"] = {0, 0.125, 0.25, 0.5},
	["Void Elf"] = {0.5, 0.625, 0.25, 0.5},
	["Void elves"] = {0.5, 0.625, 0.25, 0.5},
	["Lightforged Draenei"] = {0.5, 0.625, 0, 0.25},
	["Dark Iron Dwarf"] = {0.125, 0.25, 0, 0.25},
	["Dark Iron Dwarves"] = {0.125, 0.25, 0, 0.25},
	["Mag'har Orc"] = {0.375, 0.5, 0.25, 0.5},
	["Zandalari Troll"] = {0.25, 0.375, 0.25, 0.5},
	["Zandalari Trolls"] = {0.25, 0.375, 0.25, 0.5},
	["Kul Tiran"] = {0, 0.125, 0, 0.25}
}

RE.BracketNames = {
	ARENA_2V2,
	ARENA_3V3,
	"",
	BATTLEGROUND_10V10
}

RE.MapIDRemap = {
	[968] = 566,
	[998] = 1035,
	[1681] = 2107
}

RE.Roles = {}
for classID=1, MAX_CLASSES do
	local _, classTag = GetClassInfo(classID)
	local specNum = GetNumSpecializationsForClassID(classID)
	RE.Roles[classTag] = {}
	for i=1, specNum do
		local _, name, _, _, role = GetSpecializationInfoForClassID(classID, i)
		RE.Roles[classTag][name] = role
	end
end

RE.StatsDropDown = {
	{ text = L["Most common teams"], notCheckable = true, func = function() RE:GetArenaToast(1) end },
	{ text = L["Easiest teams"], notCheckable = true, func = function() RE:GetArenaToast(2) end },
	{ text = L["Hardest teams"], notCheckable = true, func = function() RE:GetArenaToast(3) end }
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
		toasts = {
			name = L["Enable battleground summary"],
			desc = L["Display toast with battleground summary after completed match."],
			type = "toggle",
			width = "full",
			order = 2,
			set = function(_, val) RE.Settings.Toasts = val end,
			get = function(_) return RE.Settings.Toasts end
		},
		servername = {
			name = L["Display server names"],
			desc = L["Show player server name in match detail tooltip."],
			type = "toggle",
			width = "full",
			order = 3,
			set = function(_, val) RE.Settings.ShowServerName = val end,
			get = function(_) return RE.Settings.ShowServerName end
		},
		arenalimit = {
			name = L["Arena composition statistics limit"],
			desc = L["A minimal number of matches required to be included in arena team composition statistics."],
			type = "range",
			width = "double",
			order = 4,
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
			order = 5,
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
			order = 6,
			func = function() _G.REFlexDatabase = {}; _G.REFlexHonorDatabase = {}; ReloadUI() end
		},
		deleteoldseason = {
			name = L["Purge previous seasons"],
			desc = L["WARNING! This operation is not reversible!"],
			type = "execute",
			width = "double",
			confirm = true,
			order = 7,
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
		["name"] = BATTLEGROUND,
		["width"] = 130,
		["color"] = RE.GetMapColor,
		["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Map", 0) end,
		["align"] = "CENTER"
	},
	{
		["name"] = AUCTION_DURATION,
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
		["name"] = WIN,
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
		["name"] = DAMAGE,
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
		["name"] = SHOW_COMBAT_HEALING,
		["width"] = 65,
		["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Healing", 13) end,
		["align"] = "CENTER"
	},
	{
		["name"] = HONOR,
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
		["name"] = RATING,
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
		["name"] = ARENA,
		["width"] = 60,
		["color"] = RE.GetMapColorArena,
		["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Map", 0) end,
		["align"] = "CENTER"
	},
	{
		["name"] = TEAM,
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
		["name"] = ENEMY,
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
		["name"] = AUCTION_DURATION,
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
		["name"] = DAMAGE,
		["width"] = 70,
		["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Damage", 12) end,
		["align"] = "CENTER"
	},
	{
		["name"] = SHOW_COMBAT_HEALING,
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
		["name"] = RATING,
		["width"] = 50,
		["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Rating", 15) end,
		["align"] = "CENTER"
	}
}
