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
	["ForceCivilisedClock"] = false,
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
	[2373] = RE:GetShortMapName(GetRealZoneText(2373)),
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
	[2373] = GetRealZoneText(2373),
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
	1, 1552, 1504, 1672, 617, 2373, 1825, 1911, 1505, 1134, 2167, 980, 572
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
	["Human"]	= {0.86084, 0.89209, 0.000976562, 0.0634766},
	["Humans"]	= {0.86084, 0.89209, 0.000976562, 0.0634766},
	["Dwarf"]	= {0.444824, 0.476074, 0.889648, 0.952148},
	["Dwarves"]	= {0.444824, 0.476074, 0.889648, 0.952148},
	["Gnome"]	= {0.66748, 0.69873, 0.000976562, 0.0634766},
	["Gnomes"]	= {0.66748, 0.69873, 0.000976562, 0.0634766},
	["Night Elf"]	= {0.508301, 0.539551, 0.643555, 0.706055},
	["Night elves"]	= {0.508301, 0.539551, 0.643555, 0.706055},
	["Tauren"]	= {0.540527, 0.571777, 0.192383, 0.254883},
	["Undead"]	= {0.540527, 0.571777, 0.450195, 0.512695},
	["Troll"]	= {0.540527, 0.571777, 0.321289, 0.383789},
	["Trolls"]	= {0.540527, 0.571777, 0.321289, 0.383789},
	["Orc"]	= {0.508301, 0.539551, 0.772461, 0.834961},
	["Orcs"]	= {0.508301, 0.539551, 0.772461, 0.834961},
	["Blood Elf"]	= {0.0639648, 0.0952148, 0.889648, 0.952148},
	["Blood elves"]	= {0.0639648, 0.0952148, 0.889648, 0.952148},
	["Draenei"]	= {0.317871, 0.349121, 0.889648, 0.952148},
	["Goblin"]	= {0.731934, 0.763184, 0.000976562, 0.0634766},
	["Goblins"]	= {0.731934, 0.763184, 0.000976562, 0.0634766},
	["Worgen"]	= {0.540527, 0.571777, 0.836914, 0.899414},
	["Pandaren"]	= {0.508301, 0.539551, 0.901367, 0.963867},
	["Nightborne"]	= {0.508301, 0.539551, 0.514648, 0.577148},
	["Highmountain Tauren"]	= {0.796387, 0.827637, 0.000976562, 0.0634766},
	["Void Elf"]	= {0.540527, 0.571777, 0.579102, 0.641602},
	["Void elves"]	= {0.540527, 0.571777, 0.579102, 0.641602},
	["Lightforged Draenei"]	= {0.508301, 0.539551, 0.12793, 0.19043},
	["Dark Iron Dwarf"]	= {0.190918, 0.222168, 0.889648, 0.952148},
	["Dark Iron Dwarves"]	= {0.190918, 0.222168, 0.889648, 0.952148},
	["Mag'har Orc"]	= {0.508301, 0.539551, 0.256836, 0.319336},
	["Zandalari Troll"]	= {0.572754, 0.604004, 0.12793, 0.19043},
	["Zandalari Trolls"]	= {0.572754, 0.604004, 0.12793, 0.19043},
	["Kul Tiran"]	= {0.925293, 0.956543, 0.000976562, 0.0634766},
	["Vulpera"]	= {0.540527, 0.571777, 0.708008, 0.770508},
	["Vulperas"]	= {0.540527, 0.571777, 0.708008, 0.770508},
	["Mechagnome"]	= {0.508301, 0.539551, 0.385742, 0.448242},
	["Mechagnomes"]	= {0.508301, 0.539551, 0.385742, 0.448242}
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
		civilisedclock = {
			name = L["Force 24-hour time format"],
			desc = L["Display 24-hour timestamps even if US realm is detected."],
			type = "toggle",
			width = "full",
			order = 3,
			set = function(_, val) RE.Settings.ForceCivilisedClock = val end,
			get = function(_) return RE.Settings.ForceCivilisedClock end
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
