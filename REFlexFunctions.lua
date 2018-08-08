local _G = _G
local _, RE = ...
local L = LibStub("AceLocale-3.0"):GetLocale("REFlex")
local BR = LibStub("LibBabble-Race-3.0"):GetReverseLookupTable()
local DUMP = LibStub("LibTextDump-1.0")
local TOAST = LibStub("LibToast-1.0")

--GLOBALS: CLASS_ICON_TCOORDS, RAID_CLASS_COLORS, LOCALIZED_CLASS_NAMES_MALE
local tinsert, tsort, tconcat, tremove = _G.table.insert, _G.table.sort, _G.table.concat, _G.table.remove
local mfloor = _G.math.floor
local sgsub, sbyte = _G.string.gsub, _G.string.byte
local strsplit, date, select, tostring, PlaySound, time, pairs, ipairs = _G.strsplit, _G.date, _G.select, _G.tostring, _G.PlaySound, _G.time, _G.pairs, _G.ipairs
local GetAchievementCriteriaInfo = _G.GetAchievementCriteriaInfo
local GetHonorRewardInfo = _G.C_PvP.GetHonorRewardInfo
local GetQuestLineQuests = _G.C_QuestLine.GetQuestLineQuests
local GetQuestObjectives = _G.C_QuestLog.GetQuestObjectives
local HaveQuestData = _G.HaveQuestData
local PanelTemplates_GetSelectedTab = _G.PanelTemplates_GetSelectedTab
local StaticPopup_Hide = _G.StaticPopup_Hide
local IsOnQuest = _G.C_QuestLog.IsOnQuest
local IsQuestFlaggedCompleted = _G.IsQuestFlaggedCompleted

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

function RE:GetMMR(databaseID, player, csv)
	local faction = RE:GetFactionID(databaseID, player) + 1
	if RE.Database[databaseID].isRated then
		return RE.Database[databaseID].TeamData[faction][4]
	else
		if csv then
			return 0
		else
			return "-"
		end
	end
end

function RE:GetArenaTeamIcons(databaseID, player)
	local faction = RE:GetFactionID(databaseID, player)
	local teamRaw, team = {}, {}
	for i=1, #RE.Database[databaseID].Players do
		if RE.Database[databaseID].Players[i][6] == faction then
			tinsert(teamRaw, RE.Database[databaseID].Players[i][9])
		end
	end
	tsort(teamRaw)
	for i=1, #teamRaw do
		tinsert(team, RE:GetClassIcon(teamRaw[i], 20))
	end
	return tconcat(team, " ")
end

function RE:GetArenaTeamDetails(databaseID, player)
	local faction = RE:GetFactionID(databaseID, player)
	local team, damageSum, healingSum = {}, 0, 0
	for i=1, #RE.Database[databaseID].Players do
		if RE.Database[databaseID].Players[i][6] == faction then
			damageSum = damageSum + RE.Database[databaseID].Players[i][10]
			healingSum = healingSum + RE.Database[databaseID].Players[i][11]
			tinsert(team, {RE:GetRaceIcon(RE.Database[databaseID].Players[i][7], 30).."   "..RE:GetClassIcon(RE.Database[databaseID].Players[i][9], 30),
			"|c"..RAID_CLASS_COLORS[RE.Database[databaseID].Players[i][9]].colorStr..RE:NameClean(RE.Database[databaseID].Players[i][1]).."|r",
			"|c"..RAID_CLASS_COLORS[RE.Database[databaseID].Players[i][9]].colorStr..RE.Database[databaseID].Players[i][16].."|r",
			RE:AbbreviateNumbers(RE.Database[databaseID].Players[i][10]),
			RE:AbbreviateNumbers(RE.Database[databaseID].Players[i][11]),
			"|n["..RE:RatingChangeClean(RE.Database[databaseID].Players[i][13], databaseID).."]",
			RE:GetPrestigeIcon(RE.Database[databaseID].Players[i][17], 16)})
		end
	end
	while #team < 3 do
		tinsert(team, {"", "", "", "", "", "", ""})
	end
	return team, RE:AbbreviateNumbers(damageSum), RE:AbbreviateNumbers(healingSum)
end

function RE:GetArenaTeamCSV(databaseID, player)
	local faction = RE:GetFactionID(databaseID, player)
	local team = {}
	for i=1, #RE.Database[databaseID].Players do
		if RE.Database[databaseID].Players[i][6] == faction then
			tinsert(team, RE.Database[databaseID].Players[i][9].."-"..RE.Database[databaseID].Players[i][16])
		end
	end
	tsort(team)
	return tconcat(team, ",")
end

function RE:GetArenaTeamStats(mode)
	local teamMatrix = {}
	local payload = {}
	for i=1, #RE.TableArena.filtered do
		local databaseID = RE.TableArena.data[RE.TableArena.filtered[i]][11]
		local faction = RE:GetFactionID(databaseID, false)
		local win = RE:GetPlayerWin(databaseID, false)
		local teamID = {}
		for j=1, #RE.Database[databaseID].Players do
			if RE.Database[databaseID].Players[j][6] == faction then
				tinsert(teamID, RE.Database[databaseID].Players[j][9].."-"..RE.Database[databaseID].Players[j][16])
			end
		end
		tsort(teamID)
		teamID = tconcat(teamID, ";")
		if teamMatrix[teamID] then
			if win then
				teamMatrix[teamID].Count = teamMatrix[teamID].Count + 1
				teamMatrix[teamID].Win = teamMatrix[teamID].Win + 1
			else
				teamMatrix[teamID].Count = teamMatrix[teamID].Count + 1
				teamMatrix[teamID].Loss = teamMatrix[teamID].Loss + 1
			end
		else
			if win then
				teamMatrix[teamID] = {["Count"] = 1, ["Win"] = 1, ["Loss"] = 0}
			else
				teamMatrix[teamID] = {["Count"] = 1, ["Win"] = 0, ["Loss"] = 1}
			end
		end
	end
	teamMatrix[""] = nil
	for t, v in pairs(teamMatrix) do
		if v.Count <= RE.Settings.ArenaStatsLimit then
			teamMatrix[t] = nil
		end
	end
	if mode == 1 then
		RE:ForeachInOrder(teamMatrix, function(t, v) if #payload < 6 then tinsert(payload, {t, v.Count, v.Win, v.Loss}) end end, function(a,b) return teamMatrix[a].Count > teamMatrix[b].Count end)
	elseif mode == 2 then
		RE:ForeachInOrder(teamMatrix, function(t, v) if #payload < 6 then tinsert(payload, {t, v.Count, v.Win, v.Loss}) end end, function(a,b) return (teamMatrix[a].Win / teamMatrix[a].Count) > (teamMatrix[b].Win / teamMatrix[b].Count) end)
	else
		RE:ForeachInOrder(teamMatrix, function(t, v) if #payload < 6 then tinsert(payload, {t, v.Count, v.Win, v.Loss}) end end, function(a,b) return (teamMatrix[a].Loss / teamMatrix[a].Count) > (teamMatrix[b].Loss / teamMatrix[b].Count) end)
	end
	return payload
end

function RE:GetRGBTeamDetails(databaseID, player)
	local faction = RE:GetFactionID(databaseID, player)
	local team, damageSum, healingSum, kbSum = {}, 0, 0, 0
	for i=1, #RE.Database[databaseID].Players do
		if RE.Database[databaseID].Players[i][6] == faction then
			damageSum = damageSum + RE.Database[databaseID].Players[i][10]
			healingSum = healingSum + RE.Database[databaseID].Players[i][11]
			kbSum = kbSum + RE.Database[databaseID].Players[i][2]
			tinsert(team, {RE:GetRaceIcon(RE.Database[databaseID].Players[i][7], 30).."   "..RE:GetClassIcon(RE.Database[databaseID].Players[i][9], 30),
			"|c"..RAID_CLASS_COLORS[RE.Database[databaseID].Players[i][9]].colorStr..RE:NameClean(RE.Database[databaseID].Players[i][1]).."|r",
			"|c"..RAID_CLASS_COLORS[RE.Database[databaseID].Players[i][9]].colorStr..RE.Database[databaseID].Players[i][16].."|r",
			RE:GetPrestigeIcon(RE.Database[databaseID].Players[i][17], 16),
			RE.Database[databaseID].Players[i][2],
			RE:AbbreviateNumbers(RE.Database[databaseID].Players[i][10]),
			RE:AbbreviateNumbers(RE.Database[databaseID].Players[i][11]),
			"|n"..RE.Database[databaseID].Players[i][12].." ["..RE:RatingChangeClean(RE.Database[databaseID].Players[i][13], databaseID).."]"})
		end
	end
	return team, RE:AbbreviateNumbers(damageSum), RE:AbbreviateNumbers(healingSum), kbSum
end

function RE:GetWinNumber(filter, arena)
	local won, lost = 0, 0
	for i=1, #RE.Database do
		if (RE.Database[i].isArena == arena or arena == nil) and not RE.Database[i].Hidden then
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

function RE:GetHonor()
	local honor = 0
	local from = RE.Settings.Filters.Date[1]
	local to = RE.Settings.Filters.Date[2]
	if RE.Settings.LDBMode == 1 then
		from = RE:ParseUTCTimestamp()
	elseif RE.Settings.LDBMode == 3 then
		if RE.PlayerZone == "US" then
			from = from - 54000 - (3600 * RE.PlayerTimezone)
		elseif RE.PlayerZone == "CN" or RE.PlayerZone == "KR" then
			from = from - 82800 - (3600 * RE.PlayerTimezone)
		else
			from = from - 25200 - (3600 * RE.PlayerTimezone)
		end
	end
	for t, v in pairs(RE.HDatabase) do
		if t >= from and (to == 0 or t <= to) then
			honor = honor + v
		end
	end
	return honor
end

function RE:GetSessionHonor()
	local savedFilters = RE.Settings.Filters
	RE.Settings.Filters = {["Spec"] = _G.ALL, ["Map"] = 1, ["Bracket"] = 1, ["Date"] = {RE.SessionStart, 0}, ["Season"] = 0}
	RE.SessionHonor = RE:GetHonor()
	RE.Settings.Filters = savedFilters
end

function RE:GetStats(filter, arena, skipLatest)
	local ili = #RE.Database
	local kb, topKB, hk, topHK, honor, topHonor, damage, topDamage, healing, topHealing = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	if skipLatest then
		ili = ili - 1
	end
	for i=1, ili do
		if (RE.Database[i].isArena == arena or arena == nil) and not RE.Database[i].Hidden then
			if filter == 1 or (filter == 2 and not RE.Database[i].isRated) or (filter == 3 and RE.Database[i].isRated) then
				local playerData = RE:GetPlayerData(i)
				if RE:FilterStats(i, playerData) then
					kb = kb + playerData[2]
					hk = hk + playerData[3]
					honor = honor + playerData[5]
					if RE.Database[i].Time > RE.LastSquash then
						damage = damage + playerData[10]
						healing = healing + playerData[11]
					end
					if playerData[2] > topKB then
						topKB = playerData[2]
					end
					if playerData[3] > topHK then
						topHK = playerData[3]
					end
					if playerData[5] > topHonor then
						topHonor = playerData[5]
					end
					if RE.Database[i].Time > RE.LastSquash then
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

function RE:GetBGComposition(databaseID, player)
	local tank, healer, dps = 0, 0, 0
	local faction = RE:GetFactionID(databaseID, player)
	for i=1, #RE.Database[databaseID].Players do
		if RE.Database[databaseID].Players[i][6] == faction and RE.Database[databaseID].Players[i][9] ~= nil then
			local role = RE.Roles[RE.Database[databaseID].Players[i][9]][RE.Database[databaseID].Players[i][16]]
			if role == "TANK" then
				tank = tank + 1
			elseif role == "HEALER" then
				healer = healer + 1
			else
				dps = dps + 1
			end
		end
	end
	return tank, healer, dps
end

function RE:GetMercenaryStatus(databaseID)
	return not (RE.Database[databaseID].PlayerSide == RE.PlayerFaction)
end

function RE:GetBGToast(databaseID)
	local toast = {}
	local savedFilters = RE.Settings.Filters
	RE.Settings.Filters = {["Spec"] = _G.ALL, ["Map"] = RE.Database[databaseID].Map, ["Bracket"] = 1, ["Date"] = {0, 0}, ["Season"] = 0}
	local playerData = RE:GetPlayerData(databaseID)
	local placeKB, placeHK, placeHonor, placeDamage, placeHealing = RE:GetBGPlace(databaseID, false)
	local _, topKB, _, topHK, _, topHonor, _, topDamage, _, topHealing = RE:GetStats(1, false, true)
	RE.Settings.Filters = savedFilters
	tinsert(toast, RE:InsideToast("KB", playerData[2], databaseID, placeKB, topKB))
	tinsert(toast, RE:InsideToast("HK", playerData[3], databaseID, placeHK, topHK))
	tinsert(toast, RE:InsideToast(_G.HONOR, playerData[5], databaseID, placeHonor, topHonor))
	tinsert(toast, RE:InsideToast(_G.DAMAGE, playerData[10], databaseID, placeDamage, topDamage))
	tinsert(toast, RE:InsideToast(_G.SHOW_COMBAT_HEALING, playerData[11], databaseID, placeHealing, topHealing))
	return tconcat(toast, "")
end

function RE:GetArenaToast(mode)
	if #RE.TableArena.filtered > 0 then
		local payload = RE:GetArenaTeamStats(mode)
		local title = "|cFF74D06CRE|r|cFFFFFFFFFlex|r"
		local toast = {}
		if mode == 1 then
			title = title.." "..L["Most common teams"]
		elseif mode == 2 then
			title = title.." "..L["Easiest teams"]
		else
			title = title.." "..L["Hardest teams"]
		end
		for _, v in pairs(payload) do
			local members = {strsplit(";", v[1])}
			for i=1, #members do
				local class, spec = strsplit("-", members[i])
				tinsert(toast, "|c"..RAID_CLASS_COLORS[class]:GenerateHexColor()..LOCALIZED_CLASS_NAMES_MALE[class].." "..spec.."|r|n")
			end
			if mode == 1 then
				tinsert(toast, "|cFFFFFFFF"..v[2].."|r | |cFF00FF00"..v[3].."|r - |cFFFF0000"..v[4].."|r|n|n")
			elseif mode == 2 then
				tinsert(toast, "|cFF00FF00"..v[3].."|r - |cFFFF0000"..v[4].."|r | |cFFFFFFFF"..v[2].."|n|n")
			else
				tinsert(toast, "|cFFFF0000"..v[4].."|r - |cFF00FF00"..v[3].."|r | |cFFFFFFFF"..v[2].."|n|n")
			end
		end
		if #toast > 1 then
			toast[#toast] = toast[#toast]:gsub("|n|n", "")
			TOAST:Spawn("REFlexToastArena", title, tconcat(toast, ""))
		end
	end
end

function RE:GetFactionID(databaseID, player)
	if player then
		return RE.Database[databaseID].PlayerSide
	else
		return 1 - RE.Database[databaseID].PlayerSide
	end
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
	if RE.Database[table.data[realrow][11]].isRated then
		return {["r"] = 0.52,
		["g"] = 1.0,
		["b"] = 0.52,
		["a"] = 1.0}
	elseif RE.Database[table.data[realrow][11]].isBrawl then
		return {["r"] = 1.0,
		["g"] = 0.98,
		["b"] = 0.72,
		["a"] = 1.0}
	elseif RE:GetMercenaryStatus(table.data[realrow][11]) then
		if RE.PlayerFaction == 0 then
			return {["r"] = 0,
			["g"] = 0.66,
			["b"] = 1.0,
			["a"] = 1.0}
		else
			return {["r"] = 1.0,
			["g"] = 0.08,
			["b"] = 0.11,
			["a"] = 1.0}
		end
	else
		return {["r"] = 1.0,
		["g"] = 1.0,
		["b"] = 1.0,
		["a"] = 1.0}
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
		token = sgsub(BR[token], "_PL", "")
		return "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:"..size..":"..size..":0:0:256:256:" ..
		RE.RaceIcons[token][1]*256+5 ..
		":" .. RE.RaceIcons[token][2]*256-5 ..
		":" .. RE.RaceIcons[token][3]*256+5 ..
		":" .. RE.RaceIcons[token][4]*256-5 .. "|t"
	end
end

function RE:GetPrestigeIcon(level, size)
	local hLevelData = GetHonorRewardInfo(level)
	if hLevelData and hLevelData.badgeFileDataID then
		return "|T"..hLevelData.badgeFileDataID..":"..size..":"..size..":0:0|t"
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
		if not databaseID or RE.Database[databaseID].isRated then
			return "0"
		else
			return "-"
		end
	end
end

function RE:DateClean(timeRaw)
	-- Barbarian friendly
	if RE.PlayerZone == "US" then
		return date("%I:%M %p %m/%d/%y", timeRaw + (RE.PlayerTimezone * 3600))
	else
		return date("%H:%M %d.%m.%y", timeRaw + (RE.PlayerTimezone * 3600))
	end
end

function RE:TimeClean(timeRaw)
	local timeSec = mfloor(timeRaw % 60)
	local timeMin = mfloor(timeRaw / 60)
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
	if RE.Settings.Filters.Spec ~= _G.ALL then
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

function RE:DateFilter(rowdata)
	local from = RE.Settings.Filters.Date[1]
	local to = RE.Settings.Filters.Date[2]
	if from > 0 or to > 0 then
		if RE.Database[rowdata[11]].Time >= from and (to == 0 or RE.Database[rowdata[11]].Time <= to) then
			return true
		else
			return false
		end
	else
		if RE.Settings.Filters.Season > 0 then
			if RE.Database[rowdata[11]].Season == RE.Settings.Filters.Season then
				return true
			else
				return false
			end
		else
			return true
		end
	end
end

function RE:FilterDefault(rowdata)
	return not RE.Database[rowdata[11]].Hidden and RE:SpecFilter(rowdata) and RE:MapFilter(rowdata) and RE:BracketFilter(rowdata) and RE:DateFilter(rowdata)
end

function RE:FilterCasual(rowdata)
	return not RE.Database[rowdata[11]].Hidden and not RE.Database[rowdata[11]].isRated and RE:SpecFilter(rowdata) and RE:MapFilter(rowdata) and RE:BracketFilter(rowdata) and RE:DateFilter(rowdata)
end

function RE:FilterRated(rowdata)
	return not RE.Database[rowdata[11]].Hidden and RE.Database[rowdata[11]].isRated and RE:SpecFilter(rowdata) and RE:MapFilter(rowdata) and RE:BracketFilter(rowdata) and RE:DateFilter(rowdata)
end

function RE:FilterStats(id, playerdata)
	local data = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, id, 0, 0, playerdata[16], 0}
	return not RE.Database[data[11]].Hidden and RE:SpecFilter(data) and RE:MapFilter(data) and RE:BracketFilter(data) and RE:DateFilter(data)
end

function RE:CalendarParser()
	if RE.CalendarMode == 1 then
		local t = {day = _G.CalendarFrame.selectedDay, month = _G.CalendarFrame.selectedMonth, year = _G.CalendarFrame.selectedYear, hour = 0}
		PlaySound(624)
		RE.Settings.Filters.Date[1] = time(t) - (RE.PlayerTimezone * 3600)
		RE.CalendarMode = 2
	elseif RE.CalendarMode == 2 then
		local t = {day = _G.CalendarFrame.selectedDay, month = _G.CalendarFrame.selectedMonth, year = _G.CalendarFrame.selectedYear, hour = 23, min = 59, sec = 59}
		PlaySound(624)
		RE.Settings.Filters.Date[2] = time(t) - (RE.PlayerTimezone * 3600)
		_G.CalendarFrame:Hide()
		RE:UpdateGUI()
	end
end

function RE:CalendarCleanup()
	RE.CalendarMode = 0
	StaticPopup_Hide("REFLEX_CUSTOMDATE")
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
		_G.REFlexFrame_HKBar_Text:SetText(hk.." / "..hkMax)
		_G.REFlexFrame_HKBar_I:SetMinMaxValues(0, hkMax)
	else
		_G.REFlexFrame_HKBar_Text:SetText(hk)
		_G.REFlexFrame_HKBar_I:SetMinMaxValues(0, hk)
	end
	_G.REFlexFrame_HKBar_I:SetValue(hk)
end

function RE:InsideToast(label, value, databaseID, place, top)
	local toast = {}
	tinsert(toast, "|cFFC5F3BC"..label..":|r |cFFFFFFFF"..RE:AbbreviateNumbers(value).." - "..place.."/"..RE.Database[databaseID].PlayersNum.."|r")
	if value > top then
		tinsert(toast, " |cFFFFFFFF-|r |TInterface\\GroupFrame\\UI-Group-LeaderIcon:14:14:0:0|t")
	end
	tinsert(toast, "|n")
	return tconcat(toast, "")
end

function RE:CloseToast()
end

function RE:HideEntry(databaseID)
	RE.Database[databaseID].Hidden = true
	RE:UpdateGUI()
end

function RE:SeasonPurge()
	if RE.Season < 1 then return end
	local toWipe = {}
	for i=1, #RE.Database do
		if RE.Database[i].Season ~= RE.Season then
			tinsert(toWipe, i)
		end
	end
	RE:DatabasePurge(toWipe)
end

function RE:HiddenPurge()
	local currentTime = RE:GetUTCTimestamp()
	local toWipe = {}
	for i=1, #RE.Database do
		if RE.Database[i].Hidden and currentTime - RE.Database[i].Time > 604800 then
			tinsert(toWipe, i)
		end
	end
	RE:DatabasePurge(toWipe)
end

function RE:DatabasePurge(idTable)
	local wipeI = 0
	for i=1, #idTable do
		local wipeID = idTable[i] - wipeI
		tremove(RE.Database, wipeID)
		wipeI = wipeI + 1
	end
end

function RE:DumpCSV()
	local id, d, s
	if not _G.REFlexFrame:IsShown() then return end
	RE.DumpFrame:Clear()
	if PanelTemplates_GetSelectedTab(_G.REFlexFrame) < 4 then
		RE.DumpFrame:AddLine("Timestamp;Map;Duration;Victory;KillingBlows;HonorKills;Deaths;Damage;Healing;Honor;RatingChange;MMR;EnemyMMR;Specialization;PrestigeLevel;isRated;isBrawl;isMercenary")
		for i=1, #RE.TableBG.filtered do
			id = RE.TableBG.data[RE.TableBG.filtered[i]][11]
			d = RE.Database[id]
			s = RE:GetPlayerData(id)
			RE.DumpFrame:AddLine(tostring(d.Time)..";"..tostring(d.Map)..";"..tostring(d.Duration)..";"..tostring(RE:GetPlayerWin(id, false))..";"..
			tostring(s[2])..";"..tostring(s[3])..";"..tostring(s[4])..";"..tostring(s[10])..";"..tostring(s[11])..";"..tostring(s[5])..";"..tostring(s[13])..";"..tostring(RE:GetMMR(id, true, true))..";"..
			tostring(RE:GetMMR(id, false, true))..";"..tostring(s[16])..";"..tostring(s[17])..";"..tostring(d.isRated)..";"..tostring(d.isBrawl)..";"..tostring(RE:GetMercenaryStatus(id)))
		end
	else
		RE.DumpFrame:AddLine("Timestamp;Map;PlayersNumber;TeamComposition;EnemyComposition;Duration;Victory;KillingBlows;Damage;Healing;Honor;RatingChange;MMR;EnemyMMR;Specialization;isRated")
		for i=1, #RE.TableArena.filtered do
			id = RE.TableArena.data[RE.TableArena.filtered[i]][11]
			d = RE.Database[id]
			s = RE:GetPlayerData(id)
			RE.DumpFrame:AddLine(tostring(d.Time)..";"..tostring(d.Map)..";"..tostring(d.PlayersNum)..";"..RE:GetArenaTeamCSV(id, true)..";"..RE:GetArenaTeamCSV(id, false)..";"..tostring(d.Duration)..";"..
			tostring(RE:GetPlayerWin(id, false))..";"..tostring(s[2])..";"..tostring(s[10])..";"..tostring(s[11])..";"..tostring(s[5])..";"..tostring(s[13])..";"..tostring(RE:GetMMR(id, true, true))..";"..tostring(RE:GetMMR(id, false, true))..";"..tostring(s[16])..";"..tostring(d.isRated))
		end
	end
	RE.DumpFrame:Display()

	if RE.IsSkinned then
		_G.AddOnSkins[1]:SkinFrame(DUMP.frames[RE.DumpFrame])
		_G.AddOnSkins[1]:SkinFrame(DUMP.frames[RE.DumpFrame].Inset)
		_G.AddOnSkins[1]:SkinCloseButton(DUMP.frames[RE.DumpFrame].CloseButton)
		_G.AddOnSkins[1]:SkinScrollBar(DUMP.frames[RE.DumpFrame].scrollArea.ScrollBar)
	end
end

function RE:GetConquestPoints()
	local quests = GetQuestLineQuests(782)
	local currentQuestID = quests[1]
	for _, questID in ipairs(quests) do
		if not IsQuestFlaggedCompleted(questID) and not IsOnQuest(questID) then
			break
		end
		currentQuestID = questID
	end
	if not HaveQuestData(currentQuestID) then
		return 0, 0
	end
	local objectives = GetQuestObjectives(currentQuestID)
	if not objectives or not objectives[1] then
		return 0, 0
	end
	return objectives[1].numFulfilled, objectives[1].numRequired
end

function RE:GetWeeklyResetDay()
	local d = date("!*t")
	local resetday, hour
	if RE.PlayerZone == "US" then
		hour = 15
		if d.wday >= 3 then
			resetday = d.wday - 3
		else
			resetday = d.wday + 4
		end
	else
		if RE.PlayerZone == "CN" or RE.PlayerZone == "KR" then
			hour = 23
		else
			hour = 7
		end
		if d.wday >= 4 then
			resetday = d.wday - 4
		else
			resetday = d.wday + 3
		end
	end
	if resetday == 0 and d.hour < hour then
		resetday = 7
	end
	return resetday, hour
end

function RE:GetUTCTimestamp(timezone)
	local d1 = date("*t")
	local d2 = date("!*t")
	d2.isdst = d1.isdst
	local utc = time(d2)
	if timezone then
		local player = time(d1)
		return utc, RE:Round((player - utc) / 3600, 0)
	else
		return utc
	end
end

function RE:ParseUTCTimestamp(month)
	local d1 = date("*t")
	local d2 = date("!*t")
	d2.isdst = d1.isdst
	if month then
		return time(d2) - (86400 * (d1.day - 1)) - (3600 * d1.hour) - (60 * d1.min) - d1.sec
	else
		return time(d2) - (3600 * d1.hour) - (60 * d1.min) - d1.sec
	end
end

function RE:Round(num, idp)
	local mult = 10^(idp or 0)
	return mfloor(num * mult + 0.5) / mult
end

function RE:AbbreviateNumbers(value)
	if value >= 10000000000 then
		value = RE:Round(value / 1000000000, 1).."B"
	elseif value >= 1000000000 then
		value = RE:Round(value / 1000000000, 2).."B"
	elseif value >= 100000000 then
		value = RE:Round(value / 1000000, 1).."M"
	elseif value >= 1000000 then
		value = RE:Round(value / 1000000, 2).."M"
	elseif value >= 1000 then
		value = RE:Round(value / 1000, 0).."K"
	end
	return value
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
		local char = sbyte(str, startIndex)
		startIndex = startIndex + RE:CSize(char)
		startChar = startChar - 1
	end
	local currentIndex = startIndex
	while numChars > 0 and currentIndex <= #str do
		local char = sbyte(str, currentIndex)
		currentIndex = currentIndex + RE:CSize(char)
		numChars = numChars -1
	end
	return str:sub(startIndex, currentIndex - 1)
end

function RE:ForeachInOrder(t, f, cmp)
	local keys = {}
	for k, _ in pairs(t) do
		keys[#keys + 1] = k
	end
	tsort(keys,cmp)
	for _, k in ipairs(keys) do
		f(k, t[k])
	end
end
