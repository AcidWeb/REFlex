local RE = REFlexNamespace
local L = LibStub("AceLocale-3.0"):GetLocale("REFlex")

function RE:UpdateSettings()
  if RE.Settings.ConfigVersion ~= RE.Version then
    if RE.Settings.ConfigVersion < 220 then
      RE.Settings.CurrentTab = 1
      RE.Settings.Filters = {["Spec"] = ALL, ["Map"] = 1, ["Bracket"] = 1, ["DateMode"] = 1, ["Date"] = {0, 0}}
      RE.Settings.ConfigVersion = 220
    end
  end
end

function RE:UpdateDatabase()
  for i=1, #RE.Database do
    if RE.Database[i].Version < 224 then
      if RE.Database[i].Map == 1681 then
        RE.Database[i].Map = 529
        RE.Database[i].isBrawl = true
      else
        RE.Database[i].isBrawl = false
      end
      RE.Database[i].Version = 224
    end
    if RE.Database[i].Version < 225 then
      if RE.Database[i].Map == 562 then
        RE.Database[i].Map = 1672
      end
      if RE.Database[i].Map == 559 then
        RE.Database[i].Map = 1505
      end
      RE.Database[i].Version = 225
    end
  end
end
