local RE = REFlexNamespace
local L = LibStub("AceLocale-3.0"):GetLocale("REFlex")
local BR = LibStub("LibBabble-Race-3.0"):GetReverseLookupTable()

function RE:GetPlayerData(databaseID)
	return RE.Database[databaseID].Players[RE.Database[databaseID].PlayerNum]
end

function RE:GetPlayerStatsData(databaseID)
	return RE.Database[databaseID].PlayersStats[RE.Database[databaseID].PlayerNum]
end

function RE:GetPlayerWin(databaseID, icon)
  if RE.Database[databaseID].PlayerSide == RE.Database[databaseID].Winner then
    if icon then
      return "|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14:0:0|t"
    else
      return true
    end
  else
    if icon then
      return "|TInterface\\RaidFrame\\ReadyCheck-NotReady:14:14:0:0|t"
    else
      return false
    end
  end
end

function RE:GetPlayerKD(databaseID)
	local playerData = RE:GetPlayerData(databaseID)
	local deaths = playerData[4]
	if deaths == 0 then
		deaths = 1
	end
	return RE:Round(playerData[3]/deaths, 2)
end

function RE:GetMMR(databaseID, player)
	local faction
	if player then
		faction = RE.Database[databaseID].PlayerSide + 1
	else
		faction = (1 - RE.Database[databaseID].PlayerSide) + 1
	end
	if RE.Database[databaseID].isRated then
		return RE.Database[databaseID].TeamData[faction][4]
	else
		return "-"
	end
end

function RE:GetArenaTeamIcons(databaseID, player)
	local faction
	if player then
		faction = RE.Database[databaseID].PlayerSide
	else
		faction = (1 - RE.Database[databaseID].PlayerSide)
	end
	local teamRaw, team = {}, {}
	for i=1, #RE.Database[databaseID].Players do
		if RE.Database[databaseID].Players[i][6] == faction then
			table.insert(teamRaw, RE.Database[databaseID].Players[i][9])
		end
	end
	table.sort(teamRaw)
	for i=1, #teamRaw do
		table.insert(team, RE:GetClassIcon(teamRaw[i], 20))
	end
	return table.concat(team, " ")
end

function RE:GetArenaTeamDetails(databaseID, player)
	local faction
	if player then
		faction = RE.Database[databaseID].PlayerSide
	else
		faction = (1 - RE.Database[databaseID].PlayerSide)
	end
	local team, damageSum, healingSum = {}, 0, 0
	for i=1, #RE.Database[databaseID].Players do
		if RE.Database[databaseID].Players[i][6] == faction then
			damageSum = damageSum + RE.Database[databaseID].Players[i][10]
			healingSum = healingSum + RE.Database[databaseID].Players[i][11]
			table.insert(team, {RE:GetRaceIcon(RE.Database[databaseID].Players[i][7], 30).."   "..RE:GetClassIcon(RE.Database[databaseID].Players[i][9], 30),
													"|c"..RAID_CLASS_COLORS[RE.Database[databaseID].Players[i][9]].colorStr..RE:NameClean(RE.Database[databaseID].Players[i][1]).."|r",
													"|c"..RAID_CLASS_COLORS[RE.Database[databaseID].Players[i][9]].colorStr..RE.Database[databaseID].Players[i][16].."|r",
													RE:AbbreviateNumbers(RE.Database[databaseID].Players[i][10]),
													RE:AbbreviateNumbers(RE.Database[databaseID].Players[i][11]),
													"|n["..RE:RatingChangeClean(RE.Database[databaseID].Players[i][13], databaseID).."]",
													RE:GetPrestigeIcon(RE.Database[databaseID].Players[i][17], 16)})
		end
	end
	while #team < 3 do
		table.insert(team, {"", "", "", "", "", "", ""})
	end
	return team, RE:AbbreviateNumbers(damageSum), RE:AbbreviateNumbers(healingSum)
end

function RE:GetRGBTeamDetails(databaseID, player)
	local faction
	if player then
		faction = RE.Database[databaseID].PlayerSide
	else
		faction = (1 - RE.Database[databaseID].PlayerSide)
	end
	local team, damageSum, healingSum, kbSum = {}, 0, 0, 0
	for i=1, #RE.Database[databaseID].Players do
		if RE.Database[databaseID].Players[i][6] == faction then
			damageSum = damageSum + RE.Database[databaseID].Players[i][10]
			healingSum = healingSum + RE.Database[databaseID].Players[i][11]
			kbSum = kbSum + RE.Database[databaseID].Players[i][2]
			table.insert(team, {RE:GetRaceIcon(RE.Database[databaseID].Players[i][7], 30).."   "..RE:GetClassIcon(RE.Database[databaseID].Players[i][9], 30),
													"|c"..RAID_CLASS_COLORS[RE.Database[databaseID].Players[i][9]].colorStr..RE:NameClean(RE.Database[databaseID].Players[i][1]).."|r",
													"|c"..RAID_CLASS_COLORS[RE.Database[databaseID].Players[i][9]].colorStr..RE.Database[databaseID].Players[i][16].."|r",
													RE:GetPrestigeIcon(RE.Database[databaseID].Players[i][17], 16),
													RE.Database[databaseID].Players[i][2],
													RE:AbbreviateNumbers(RE.Database[databaseID].Players[i][10]),
													RE:AbbreviateNumbers(RE.Database[databaseID].Players[i][11]),
													"|n["..RE:RatingChangeClean(RE.Database[databaseID].Players[i][13], databaseID).."]"})
		end
	end
	return team, RE:AbbreviateNumbers(damageSum), RE:AbbreviateNumbers(healingSum), kbSum
end

function RE:GetWinNumber(filter, arena)
  local won, lost = 0, 0
  for i=1, #RE.Database do
		if RE.Database[i].isArena == arena then
      local playerData = RE:GetPlayerData(i)
      if RE:FilterStats(i, playerData) then
        if RE:GetPlayerWin(i, false) then
          if filter == 1 or (filter == 2 and not RE.Database[i].isRated) or (filter == 3 and RE.Database[i].isRated) then
            won = won + 1
          end
        else
          if filter == 1 or (filter == 2 and not RE.Database[i].isRated) or (filter == 3 and RE.Database[i].isRated) then
            lost = lost + 1
          end
        end
      end
    end
  end
  return won, lost
end

function RE:GetStats(filter, arena, skipLatest)
	local ili = #RE.Database
  local kb, topKB, hk, topHK, honor, topHonor, damage, topDamage, healing, topHealing = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	if skipLatest then
		ili = ili - 1
	end
  for i=1, ili do
		if RE.Database[i].isArena == arena then
      if filter == 1 or (filter == 2 and not RE.Database[i].isRated) or (filter == 3 and RE.Database[i].isRated) then
        local playerData = RE:GetPlayerData(i)
        if RE:FilterStats(i, playerData) then
          kb = kb + playerData[2]
          hk = hk + playerData[3]
					honor = honor + playerData[5]
					damage = damage + playerData[10]
          healing = healing + playerData[11]
          if playerData[2] > topKB then
            topKB = playerData[2]
          end
          if playerData[3] > topHK then
            topHK = playerData[3]
          end
					if playerData[5] > topHonor then
						topHonor = playerData[5]
					end
					if playerData[10] > topDamage then
						topDamage = playerData[10]
					end
          if playerData[11] > topHealing then
            topHealing = playerData[11]
          end
        end
      end
    end
  end
  return kb, topKB, hk, topHK, honor, topHonor, damage, topDamage, healing, topHealing
end

function RE:GetBGPlace(databaseID, onlyFaction)
	local placeKB, placeHK, placeHonor, placeDamage, placeHealing = 1, 1, 1, 1, 1
	local playerData = RE:GetPlayerData(databaseID)
	for i=1, #RE.Database[databaseID].Players do
		if RE.Database[databaseID].Players[i][1] ~= RE.PlayerName and (not onlyFaction or (onlyFaction and RE.Database[databaseID].Players[i][6] == RE.Database[databaseID].PlayerSide)) then
			if playerData[2] < RE.Database[databaseID].Players[i][2] then
				placeKB = placeKB + 1
			end
			if playerData[3] < RE.Database[databaseID].Players[i][3] then
				placeHK = placeHK + 1
			end
			if playerData[5] < RE.Database[databaseID].Players[i][5] then
				placeHonor = placeHonor + 1
			end
			if playerData[10] < RE.Database[databaseID].Players[i][10] then
				placeDamage = placeDamage + 1
			end
			if playerData[11] < RE.Database[databaseID].Players[i][11] then
				placeHealing = placeHealing + 1
			end
		end
	end
	return placeKB, placeHK, placeHonor, placeDamage, placeHealing
end

function RE:GetBGToast(databaseID)
	local toast = {}
	local savedFilter = RE.Settings.Filters.Map
	RE.Settings.Filters.Map = RE.Database[databaseID].Map
	local playerData = RE:GetPlayerData(databaseID)
	local placeKB, placeHK, placeHonor, placeDamage, placeHealing = RE:GetBGPlace(databaseID, false)
	local _, topKB, _, topHK, _, topHonor, _, topDamage, _, topHealing = RE:GetStats(1, false, true)
	RE.Settings.Filters.Map = savedFilter
	table.insert(toast, RE:InsideToast("KB", playerData[2], databaseID, placeKB, topKB))
	table.insert(toast, RE:InsideToast("HK", playerData[3], databaseID, placeHK, topHK))
	table.insert(toast, RE:InsideToast(HONOR, playerData[5], databaseID, placeHonor, topHonor))
	table.insert(toast, RE:InsideToast(DAMAGE, playerData[10], databaseID, placeDamage, topDamage))
	table.insert(toast, RE:InsideToast(SHOW_COMBAT_HEALING, playerData[11], databaseID, placeHealing, topHealing))
	return table.concat(toast, "")
end

function RE:GetMapName(mapID)
	local map = RE.MapList[mapID]
	if map then
  	return map
	else
		return "E"..mapID
	end
end

function RE:GetShortMapName(mapName)
   local mapNameTemp = {strsplit(" ", mapName)}
   local mapShortName = ""
   for i=1, #mapNameTemp do
      mapShortName = mapShortName..RE:StrSub(mapNameTemp[i],0,1)
   end
   return mapShortName
end

function RE:GetMapColor(_, realrow, _, table)
  local isRated = RE.Database[table.data[realrow][11]].isRated
  if isRated then
    return {["r"] = 0,
            ["g"] = 0.8,
            ["b"] = 1.0,
            ["a"] = 1.0}
  else
    return {["r"] = 1.0,
            ["g"] = 1.0,
            ["b"] = 1.0,
            ["a"] = 1}
  end
end

function RE:GetMapColorArena(_, realrow, _, table)
  if RE:GetPlayerWin(table.data[realrow][11], false) then
    return {["r"] = 0,
            ["g"] = 1.0,
            ["b"] = 0,
            ["a"] = 1.0}
  else
    return {["r"] = 1.0,
            ["g"] = 0,
            ["b"] = 0,
            ["a"] = 1}
  end
end

function RE:GetClassIcon(token, size)
	return "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:"..size..":"..size..":0:0:256:256:" ..
				 CLASS_ICON_TCOORDS[token][1]*256+5 ..
				 ":" .. CLASS_ICON_TCOORDS[token][2]*256-5 ..
				 ":" .. CLASS_ICON_TCOORDS[token][3]*256+5 ..
				 ":" .. CLASS_ICON_TCOORDS[token][4]*256-5 .. "|t"
end

function RE:GetRaceIcon(token, size)
	if BR[token] == nil then
		return "|TInterface\\Icons\\INV_Misc_QuestionMark:"..size..":"..size.."|t"
	else
		token = string.gsub(token, "_PL", "")
		return "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:"..size..":"..size..":0:0:256:256:" ..
					 RE.RaceIcons[token][1]*256+5 ..
					 ":" .. RE.RaceIcons[token][2]*256-5 ..
					 ":" .. RE.RaceIcons[token][3]*256+5 ..
					 ":" .. RE.RaceIcons[token][4]*256-5 .. "|t"
	end
end

function RE:GetPrestigeIcon(level, size)
	local sufix = ""
	if level > 0 and level < 5 then
		sufix = level
	elseif level > 4 and level < 10 then
		sufix = "2-"..level - 4
	end
	if sufix ~= "" then
		return "|TInterface\\PVPFrame\\Icons\\prestige-icon-"..sufix..":"..size..":"..size..":0:0|t"
	else
		return ""
	end
end

function RE:NameClean(name)
	if RE.Settings.ShowServerName then
		return name
	else
		return strsplit("-", name)
	end
end

function RE:RatingChangeClean(change, databaseID)
	if change > 0 then
		return "|cFF00FF00+"..change.."|r"
	elseif change < 0 then
		return "|cFFFF141C"..change.."|r"
	else
		if RE.Database[databaseID].isRated then
			return "0"
		else
			return "-"
		end
	end
end

function RE:DateClean(timeRaw)
	-- Barbarian friendly
	if RE.PlayerZone == "US" then
		return date("%I:%M %p %m/%d/%y", timeRaw + RE.PlayerTimezone)
	else
		return date("%H:%M %d.%m.%y", timeRaw + RE.PlayerTimezone)
	end
end

function RE:TimeClean(timeRaw)
	local timeSec = math.floor(timeRaw % 60)
	local timeMin = math.floor(timeRaw / 60)
	if timeSec < 10 then
		timeSec = "0"..timeSec
	end
	return timeMin..":"..timeSec
end

function RE:CustomSort(obj, rowa, rowb, sortbycol, field, inside)
  local column = obj.cols[sortbycol]
  local direction = column.sort or column.defaultsort or "asc"
  local rowA, rowB
  if inside > 0 then
    rowA = obj.data[rowa][inside]
    rowB = obj.data[rowb][inside]
  else
    rowA = RE.Database[obj.data[rowa][11]][field]
    rowB = RE.Database[obj.data[rowb][11]][field]
  end
  if rowA == rowB then
    return false
  else
    if direction:lower() == "asc" then
      return rowA > rowB
    else
      return rowA < rowB
    end
  end
end

function RE:SpecFilter(rowdata)
  if RE.Settings.Filters.Spec ~= ALL then
    if rowdata[14] == RE.Settings.Filters.Spec then
      return true
    else
      return false
    end
  else
    return true
  end
end

function RE:MapFilter(rowdata)
  if RE.Settings.Filters.Map ~= 1 then
    if RE.Database[rowdata[11]].Map == RE.Settings.Filters.Map then
      return true
    else
      return false
    end
  else
    return true
  end
end

function RE:BracketFilter(rowdata)
  if RE.Database[rowdata[11]].isArena and RE.Settings.Filters.Bracket ~= 1 then
    if RE.Database[rowdata[11]].PlayersNum == RE.Settings.Filters.Bracket then
      return true
    else
      return false
    end
  else
    return true
  end
end

function RE:FilterDefault(rowdata)
  return RE:SpecFilter(rowdata) and RE:MapFilter(rowdata) and RE:BracketFilter(rowdata)
end

function RE:FilterCasual(rowdata)
  return RE:SpecFilter(rowdata) and RE:MapFilter(rowdata) and RE:BracketFilter(rowdata) and not RE.Database[rowdata[11]].isRated
end

function RE:FilterRated(rowdata)
  return RE:SpecFilter(rowdata) and RE:MapFilter(rowdata) and RE:BracketFilter(rowdata) and RE.Database[rowdata[11]].isRated
end

function RE:FilterStats(id, playerdata)
  local data = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, id, 0, 0, playerdata[16]}
  return RE:SpecFilter(data) and RE:MapFilter(data) and RE:BracketFilter(data)
end

function RE:HKBarUpdate()
  local hk = select(4, GetAchievementCriteriaInfo(5363, 1))
  local hkMax = 0
	if hk < 100 then
		hkMax = 100
	elseif hk < 500 then
		hkMax = 500
	elseif hk < 1000 then
		hkMax = 1000
	elseif hk < 5000 then
		hkMax = 5000
	elseif hk < 10000 then
		hkMax = 10000
	elseif hk < 25000 then
		hkMax = 25000
	elseif hk < 50000 then
		hkMax = 50000
	elseif hk < 100000 then
		hkMax = 100000
	elseif hk < 250000 then
		hkMax = 250000
	end
	if hkMax ~= 0 then
		REFlex_HKBar_Text:SetText(hk.." / "..hkMax)
		REFlex_HKBar_I:SetMinMaxValues(0, hkMax)
	else
		REFlex_HKBar_Text:SetText(hk)
		REFlex_HKBar_I:SetMinMaxValues(0, hk)
	end
	REFlex_HKBar_I:SetValue(hk)
end

function RE:InsideToast(label, value, databaseID, place, top)
	local toast = {}
	table.insert(toast, "|cFFC5F3BC"..label..":|r |cFFFFFFFF"..RE:AbbreviateNumbers(value).." - "..place.."/"..RE.Database[databaseID].PlayersNum.."|r")
	if value > top then
		table.insert(toast, " |cFFFFFFFF-|r |TInterface\\GroupFrame\\UI-Group-LeaderIcon:14:14:0:0|t")
	end
	table.insert(toast, "|n")
	return table.concat(toast, "")
end

function RE:CloseToast()
end

function RE:SeasonPurge()
	local currentSeason = GetCurrentArenaSeason()
	local toWipe = {}
	for i=1, #RE.Database do
		if RE.Database[i].Season ~= currentSeason then
			table.insert(toWipe, i)
		end
	end
	local wipeI = 0
	for j=1, #toWipe do
		local wipeID = toWipe[j] - wipeI
		table.remove(RE.Database, wipeID)
		wipeI = wipeI + 1
	end
end

function RE:Round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function RE:AbbreviateNumbers(value)
	if value >= 10000000000 then
		value = RE:Round(value / 1000000000, 1).."B"
	elseif value >= 1000000000 then
		value = RE:Round(value / 1000000000, 2).."B"
	elseif value >= 100000000 then
		value = RE:Round(value / 1000000, 0).."M"
	elseif value >= 1000000 then
		value = RE:Round(value / 1000000, 1).."M"
	elseif value >= 1000 then
		value = RE:Round(value / 1000, 0).."K"
	end
	return value;
end

function RE:CSize(char)
   if not char then
      return 0
   elseif char > 240 then
      return 4
   elseif char > 225 then
      return 3
   elseif char > 192 then
      return 2
   else
      return 1
   end
end

function RE:StrSub(str, startChar, numChars)
   local startIndex = 1
   while startChar > 1 do
      local char = string.byte(str, startIndex)
      startIndex = startIndex + RE:CSize(char)
      startChar = startChar - 1
   end
   local currentIndex = startIndex
   while numChars > 0 and currentIndex <= #str do
      local char = string.byte(str, currentIndex)
      currentIndex = currentIndex + RE:CSize(char)
      numChars = numChars -1
   end
   return str:sub(startIndex, currentIndex - 1)
end
