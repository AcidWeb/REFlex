local RE = REFlexNamespace
local L = LibStub("AceLocale-3.0"):GetLocale("REFlex")

function RE:GetPlayerData(databaseID)
	return REFlexDatabase[databaseID].Players[REFlexDatabase[databaseID].PlayerNum]
end

function RE:GetPlayerWin(databaseID, icon)
  if REFlexDatabase[databaseID].PlayerSide == REFlexDatabase[databaseID].Winner then
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

function RE:GetArenaMMR(databaseID, player)
	local faction
	if player then
		faction = REFlexDatabase[databaseID].PlayerSide + 1
	else
		faction = (1 - REFlexDatabase[databaseID].PlayerSide) + 1
	end
	if REFlexDatabase[databaseID].isRated then
		return REFlexDatabase[databaseID].TeamData[faction][4]
	else
		return "-"
	end
end

function RE:GetArenaTeam(databaseID, player)
	local faction
	if player then
		faction = REFlexDatabase[databaseID].PlayerSide
	else
		faction = (1 - REFlexDatabase[databaseID].PlayerSide)
	end
	local teamRaw, team = {}, {}
	for i=1, table.getn(REFlexDatabase[databaseID].Players) do
		if REFlexDatabase[databaseID].Players[i][6] == faction then
			table.insert(teamRaw, REFlexDatabase[databaseID].Players[i][9])
		end
	end
	table.sort(teamRaw)
	for i=1, table.getn(teamRaw) do
		table.insert(team, "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:20:20:0:0:256:256:" ..
								CLASS_ICON_TCOORDS[teamRaw[i]][1]*256+5 ..
								":"..CLASS_ICON_TCOORDS[teamRaw[i]][2]*256-5 ..
								":" .. CLASS_ICON_TCOORDS[teamRaw[i]][3]*256+5 ..
								":" .. CLASS_ICON_TCOORDS[teamRaw[i]][4]*256-5 .. "|t")
	end
	return table.concat(team, " ")
end

function RE:GetWinNumber(filter, arena)
  local won, lost = 0, 0
  for i=1, table.getn(REFlexDatabase) do
		if REFlexDatabase[i].isArena == arena then
      local playerData = RE:GetPlayerData(i)
      if RE:FilterStats(i, playerData) then
        if RE:GetPlayerWin(i, false) then
          if filter == 1 or (filter == 2 and not REFlexDatabase[i].isRated) or (filter == 3 and REFlexDatabase[i].isRated) then
            won = won + 1
          end
        else
          if filter == 1 or (filter == 2 and not REFlexDatabase[i].isRated) or (filter == 3 and REFlexDatabase[i].isRated) then
            lost = lost + 1
          end
        end
      end
    end
  end
  return won, lost
end

function RE:GetStats(filter, arena, skipLatest)
	local ili = table.getn(REFlexDatabase)
  local kb, topKB, hk, topHK, honor, topHonor, damage, topDamage, healing, topHealing = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	if skipLatest then
		ili = ili - 1
	end
  for i=1, ili do
		if REFlexDatabase[i].isArena == arena then
      if filter == 1 or (filter == 2 and not REFlexDatabase[i].isRated) or (filter == 3 and REFlexDatabase[i].isRated) then
        local playerData = RE:GetPlayerData(i)
        if RE:FilterStats(i, playerData) then
          kb = kb + playerData[2]
          hk = hk + playerData[3]
					honor = honor + playerData[10]
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

function RE:GetBGPlace(databaseID)
	local placeKB, placeHK, placeHonor, placeDamage, placeHealing = 1, 1, 1, 1, 1
	local playerData = RE:GetPlayerData(databaseID)
	for i=1, table.getn(REFlexDatabase[databaseID].Players) do
	   if REFlexDatabase[databaseID].Players[i][1] ~= RE.PlayerName then
	      if playerData[2] < REFlexDatabase[databaseID].Players[i][2] then
					placeKB = placeKB + 1
				end
				if playerData[3] < REFlexDatabase[databaseID].Players[i][3] then
					placeHK = placeHK + 1
				end
				if playerData[5] < REFlexDatabase[databaseID].Players[i][5] then
					placeHonor = placeHonor + 1
				end
				if playerData[10] < REFlexDatabase[databaseID].Players[i][10] then
					placeDamage = placeDamage + 1
				end
				if playerData[11] < REFlexDatabase[databaseID].Players[i][11] then
					placeHealing = placeHealing + 1
				end
	   end
	end
	return placeKB, placeHK, placeHonor, placeDamage, placeHealing
end

function RE:GetBGToast(databaseID)
	local toast = {}
	local savedFilter = RE.MapFilterVal
	RE.MapFilterVal = REFlexDatabase[databaseID].Map
	local playerData = RE:GetPlayerData(databaseID)
	local placeKB, placeHK, placeHonor, placeDamage, placeHealing = RE:GetBGPlace(databaseID)
	local _, topKB, _, topHK, _, topHonor, _, topDamage, _, topHealing = RE:GetStats(1, false, true)
	RE.MapFilterVal = savedFilter
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
  	return RE.MapList[mapID]
	else
		return "E"..mapID
	end
end

function RE:GetMapColor(_, realrow, _, table)
  local isRated = REFlexDatabase[table.data[realrow][11]].isRated
  if isRated then
    return {["r"] = 1.0,
            ["g"] = 0,
            ["b"] = 0,
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

function RE:RatingChangeClean(change)
	if change > 0 then
		return "|cFF00FF00+"..change.."|r"
	elseif change < 0 then
		return "|cFFFF141C"..change.."|r"
	else
		return "0"
	end
end

function RE:DateClean(timeRaw)
	-- Barbarian friendly
	if RE.PlayerZone == "US" then
		return date("%I:%M %p %m/%d/%y", timeRaw)
	else
		return date("%H:%M %d.%m.%y", timeRaw)
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
    rowA = REFlexDatabase[obj.data[rowa][11]][field]
    rowB = REFlexDatabase[obj.data[rowb][11]][field]
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
  if RE.SpecFilterVal ~= ALL then
    if rowdata[14] == RE.SpecFilterVal then
      return true
    else
      return false
    end
  else
    return true
  end
end

function RE:MapFilter(rowdata)
  if RE.MapFilterVal ~= 1 then
    if REFlexDatabase[rowdata[11]].Map == RE.MapFilterVal then
      return true
    else
      return false
    end
  else
    return true
  end
end

function RE:BracketFilter(rowdata)
  if REFlexDatabase[rowdata[11]].isArena and RE.BracketFilterVal ~= 1 then
    if REFlexDatabase[rowdata[11]].PlayersNum == RE.BracketFilterVal then
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
  return RE:SpecFilter(rowdata) and RE:MapFilter(rowdata) and RE:BracketFilter(rowdata) and not REFlexDatabase[rowdata[11]].isRated
end

function RE:FilterRated(rowdata)
  return RE:SpecFilter(rowdata) and RE:MapFilter(rowdata) and RE:BracketFilter(rowdata) and REFlexDatabase[rowdata[11]].isRated
end

function RE:FilterStats(id, playerdata)
  local data = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, id, 0, 0, playerdata[16]}
  return RE:SpecFilter(data) and RE:MapFilter(data) and RE:BracketFilter(data)
end

function RE:Round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
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
		REFlexGUI_HKBar_Text:SetText(hk.." / "..hkMax)
		REFlexGUI_HKBar_I:SetMinMaxValues(0, hkMax)
	else
		REFlexGUI_HKBar_Text:SetText(hk)
		REFlexGUI_HKBar_I:SetMinMaxValues(0, hk)
	end
	REFlexGUI_HKBar_I:SetValue(hk)
end

function RE:InsideToast(label, value, databaseID, place, top)
	local toast = {}
	table.insert(toast, "|cFFC5F3BC"..label..":|r |cFFFFFFFF"..AbbreviateNumbers(value).." - "..place.."/"..REFlexDatabase[databaseID].PlayersNum.."|r")
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
	for i=1, table.getn(REFlexDatabase) do
		if REFlexDatabase[i].Season ~= currentSeason then
			table.insert(toWipe, i)
		end
	end
	local wipeI = 0
	for j=1, table.getn(toWipe) do
		local wipeID = toWipe[j] - wipeI
		table.remove(REFlexDatabase, wipeID)
		wipeI = wipeI + 1
	end
end
