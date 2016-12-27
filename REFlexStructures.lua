local RE = REFlexNamespace
local L = LibStub("AceLocale-3.0"):GetLocale("REFlex")

RE.BGStructure = {
  {
    ["name"] = L["Date"],
    ["width"] = 110,
    ["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Time", 0) end,
    ["align"] = "CENTER"
  },
  {
    ["name"] = BATTLEGROUND,
    ["width"] = 75,
    ["color"] = RE.GetMapColor,
    ["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Map", 0) end,
    ["bgcolor"] = {
      ["r"] = 0.15,
      ["g"] = 0.15,
      ["b"] = 0.15,
      ["a"] = 1.0
    },
    ["align"] = "CENTER"
  },
  {
    ["name"] = AUCTION_DURATION,
    ["width"] = 70,
    ["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Duration", 0) end,
    ["align"] = "CENTER"
  },
  {
    ["name"] = WIN,
    ["width"] = 55,
    ["bgcolor"] = {
      ["r"] = 0.15,
      ["g"] = 0.15,
      ["b"] = 0.15,
      ["a"] = 1.0
    },
    ["align"] = "CENTER"
  },
  {
    ["name"] = "KB",
    ["width"] = 50,
    ["align"] = "CENTER"
  },
  {
    ["name"] = "HK",
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
    ["name"] = DAMAGE,
    ["width"] = 90,
    ["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Damage", 12) end,
    ["align"] = "CENTER"
  },
  {
    ["name"] = SHOW_COMBAT_HEALING,
    ["width"] = 90,
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
    ["name"] = HONOR,
    ["width"] = 65,
    ["color"] = {
      ["r"] = 0.80,
      ["g"] = 0.60,
      ["b"] = 0,
      ["a"] = 1.0
    },
    ["align"] = "CENTER"
  },
  {
    ["name"] = RATING,
    ["width"] = 65,
    ["bgcolor"] = {
      ["r"] = 0.15,
      ["g"] = 0.15,
      ["b"] = 0.15,
      ["a"] = 1.0
    },
    ["align"] = "CENTER"
  }
}

RE.ArenaStructure = {
  {
    ["name"] = L["Date"],
    ["width"] = 110,
    ["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Time", 0) end,
    ["align"] = "CENTER"
  },
  {
    ["name"] = ARENA,
    ["width"] = 60,
    ["color"] = RE.GetMapColorArena,
    ["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Map", 0) end,
    ["bgcolor"] = {
      ["r"] = 0.15,
      ["g"] = 0.15,
      ["b"] = 0.15,
      ["a"] = 1.0
    },
    ["align"] = "CENTER"
  },
  {
    ["name"] = TEAM,
    ["width"] = 100,
    ["align"] = "CENTER"
  },
  {
    ["name"] = "MMR",
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
    ["name"] = ENEMY,
    ["width"] = 100,
    ["align"] = "CENTER"
  },
  {
    ["name"] = "MMR",
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
    ["name"] = AUCTION_DURATION,
    ["width"] = 60,
    ["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Duration", 0) end,
    ["align"] = "CENTER"
  },
  {
    ["name"] = DAMAGE,
    ["width"] = 70,
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
    ["width"] = 70,
    ["comparesort"] = function (self, rowa, rowb, sortbycol) return RE:CustomSort(self, rowa, rowb, sortbycol, "Healing", 13) end,
    ["align"] = "CENTER"
  },
  {
    ["name"] = RATING,
    ["width"] = 50,
    ["bgcolor"] = {
      ["r"] = 0.15,
      ["g"] = 0.15,
      ["b"] = 0.15,
      ["a"] = 1.0
    },
    ["align"] = "CENTER"
  }
}
