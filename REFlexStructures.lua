local RE = REFlexNamespace
local L = LibStub("AceLocale-3.0"):GetLocale("REFlex")

local GetRealZoneText = GetRealZoneText
local GetClassInfoByID = GetClassInfoByID
local GetNumSpecializationsForClassID = GetNumSpecializationsForClassID
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID
local ReloadUI = ReloadUI

RE.DefaultConfig = {
	["MiniMapButtonSettings"] = {["hide"] = false},
	["Toasts"] = true,
	["ShowServerName"] = false,
	["CurrentTab"] = 1,
	["Filters"] = {["Spec"] = ALL, ["Map"] = 1, ["Bracket"] = 1, ["Date"] = {0, 0}},
	["FirstTime"] = true,
	["ConfigVersion"] = RE.Version
}

RE.TooltipBackdrop = {
	["bgFile"] = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
	["tileSize"] = 0
}

RE.MapList = {
  [30] = GetRealZoneText(30),
  [529] = GetRealZoneText(529),
  [1105] = GetRealZoneText(1105),
  [566] = GetRealZoneText(566),
  [968] = GetRealZoneText(566),
  [628] = GetRealZoneText(628),
  [727] = GetRealZoneText(727),
  [607] = GetRealZoneText(607),
  [998] = GetRealZoneText(998),
  [1035] = GetRealZoneText(998),
  [761] = GetRealZoneText(761),
  [726] = GetRealZoneText(726),
  [489] = GetRealZoneText(489),
  [1280] = GetRealZoneText(1280),
  [1552] = RE:GetShortMapName(GetRealZoneText(1552)),
  [1504] = RE:GetShortMapName(GetRealZoneText(1504)),
  [562] = RE:GetShortMapName(GetRealZoneText(1672)),
  [1672] = RE:GetShortMapName(GetRealZoneText(1672)),
  [617] = RE:GetShortMapName(GetRealZoneText(617)),
  [559] = RE:GetShortMapName(GetRealZoneText(1505)),
  [1505] = RE:GetShortMapName(GetRealZoneText(1505)),
  [572] = RE:GetShortMapName(GetRealZoneText(572)),
  [1134] = RE:GetShortMapName(GetRealZoneText(1134)),
  [980] = RE:GetShortMapName(GetRealZoneText(980))
}

RE.MapListLongBG = {
	[1] = ALL,
	[30] = GetRealZoneText(30),
	[529] = GetRealZoneText(529),
	[1105] = GetRealZoneText(1105),
	[566] = GetRealZoneText(566),
	[628] = GetRealZoneText(628),
	[727] = GetRealZoneText(727),
	[607] = GetRealZoneText(607),
	[1280] = GetRealZoneText(1280),
	[998] = GetRealZoneText(998),
	[761] = GetRealZoneText(761),
	[726] = GetRealZoneText(726),
	[489] = GetRealZoneText(489)
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
	[980] = GetRealZoneText(980)
}

RE.MapListLongOrderBG = {
	1, 30, 529, 1105, 566, 628, 727, 607, 1280, 998, 761, 726, 489
}

RE.MapListLongOrderArena = {
	1, 1552, 1504, 1672, 617, 1505, 572, 1134, 980
}

RE.MapListStat = {
	[489] = {true, "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture", "Interface\\WorldStateFrame\\ColumnIcon-FlagReturn"},
	[726] = {true, "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture", "Interface\\WorldStateFrame\\ColumnIcon-FlagReturn"},
	[529] = {true, "Interface\\WorldStateFrame\\ColumnIcon-TowerCapture", "Interface\\WorldStateFrame\\ColumnIcon-TowerDefend"},
	[566] = {false, "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture2"},
	[567] = {true, "Interface\\WorldStateFrame\\ColumnIcon-TowerCapture", "Interface\\WorldStateFrame\\ColumnIcon-TowerDefend", "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture2"},
	[761] = {true, "Interface\\WorldStateFrame\\ColumnIcon-TowerCapture", "Interface\\WorldStateFrame\\ColumnIcon-TowerDefend"},
	[998] = {false, "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture2", "Interface\\GroupFrame\\UI-Group-MasterLooter"},
	[1105] = {true, "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture", "Interface\\WorldStateFrame\\ColumnIcon-FlagReturn", "Interface\\WorldStateFrame\\ColumnIcon-TowerCapture", "Interface\\WorldStateFrame\\ColumnIcon-TowerDefend"},
	[727] = {false, "Interface\\MINIMAP\\Vehicle-SilvershardMines-MineCart"},
	[30] = {true, "Interface\\WorldStateFrame\\ColumnIcon-GraveyardCapture", "Interface\\WorldStateFrame\\ColumnIcon-GraveyardDefend", "Interface\\WorldStateFrame\\ColumnIcon-TowerCapture", "Interface\\WorldStateFrame\\ColumnIcon-TowerDefend"},
	[628] = {true, "Interface\\WorldStateFrame\\ColumnIcon-TowerCapture", "Interface\\WorldStateFrame\\ColumnIcon-TowerDefend"},
	[607] = {false, "Interface\\MINIMAP\\Vehicle-AllianceCart", "Interface\\MINIMAP\\Suramar_Door_Icon"}
}

RE.RaceIcons = {
	["Human"]	= {0, 0.125, 0, 0.25},
	["Dwarf"]	= {0.125, 0.25, 0, 0.25},
	["Gnome"]	= {0.25, 0.375, 0, 0.25},
	["Night Elf"]	= {0.375, 0.5, 0, 0.25},
	["Tauren"]	= {0, 0.125, 0.25, 0.5},
	["Undead"]	= {0.125, 0.25, 0.25, 0.5},
	["Troll"]	= {0.25, 0.375, 0.25, 0.5},
	["Orc"]	= {0.375, 0.5, 0.25, 0.5},
	["Blood Elf"]	= {0.5, 0.625, 0.25, 0.5},
	["Draenei"]	= {0.5, 0.625, 0, 0.25},
	["Goblin"]	= {0.629, 0.750, 0.25, 0.5},
	["Worgen"]	= {0.629, 0.750, 0, 0.25},
	["Pandaren"]	= {0.756, 0.881, 0, 0.25}
}

RE.Roles = {}
for classID=1, MAX_CLASSES do
	local _, classTag = GetClassInfoByID(classID)
	local specNum = GetNumSpecializationsForClassID(classID)
	RE.Roles[classTag] = {}
	for i=1, specNum do
		local _, name, _, _, role = GetSpecializationInfoForClassID(classID, i)
		RE.Roles[classTag][name] = role
	end
end

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
		deletebase = {
			name = L["Purge database"],
			desc = L["WARNING! This operation is not reversible!"],
			type = "execute",
			width = "normal",
			confirm = true,
			order = 4,
			func = function() REFlexDatabase = {}; ReloadUI() end
		},
		deleteoldseason = {
			name = L["Purge previous seasons"],
			desc = L["WARNING! This operation is not reversible!"],
			type = "execute",
			width = "normal",
			confirm = true,
			order = 5,
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
