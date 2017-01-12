local RE = REFlexNamespace
local L = LibStub("AceLocale-3.0"):GetLocale("REFlex")

function RE:UpdateSettings()
  if RE.Settings.ConfigVersion ~= RE.Version then
    if RE.Settings.ConfigVersion < 220 then
      RE.Settings.CurrentTab = 1
      RE.Settings.Filters = {["Spec"] = ALL, ["Map"] = 1, ["Bracket"] = 1, ["Date"] = {0, 0}}
      RE.Settings.ConfigVersion = 220
    end
  end
end

function RE:UpdateDatabase()
end
