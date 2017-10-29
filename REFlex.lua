local _G = _G
_G.REFlexNamespace = {["Settings"] = {}, ["Database"] = {}}

local RE = REFlexNamespace
local L = LibStub("AceLocale-3.0"):GetLocale("REFlex")
local ST = LibStub("ScrollingTable")
local GUI = LibStub("AceGUI-3.0")
local LDB = LibStub("LibDataBroker-1.1")
local LDBI = LibStub("LibDBIcon-1.0")
local TOAST = LibStub("LibToast-1.0")
local QTIP = LibStub("LibQTip-1.0")
local DUMP = LibStub("LibTextDump-1.0")

local tinsert = _G.table.insert
local mfloor = _G.math.floor
local time, date, pairs, select, print, tonumber, hooksecurefunc, strsplit, tostring = _G.time, _G.date, _G.pairs, _G.select, _G.print, _G.tonumber, _G.hooksecurefunc, _G.strsplit, _G.tostring
local PanelTemplates_GetSelectedTab, PanelTemplates_SetTab, PanelTemplates_SetNumTabs = _G.PanelTemplates_GetSelectedTab, _G.PanelTemplates_SetTab, _G.PanelTemplates_SetNumTabs
local StaticPopup_Show = _G.StaticPopup_Show
local IsAltKeyDown = _G.IsAltKeyDown
local IsControlKeyDown = _G.IsControlKeyDown
local IsShiftKeyDown = _G.IsShiftKeyDown
local IsInInstance = _G.IsInInstance
local IsInGuild = _G.IsInGuild
local IsActiveBattlefieldArena = _G.IsActiveBattlefieldArena
local IsInBrawl = _G.C_PvP.IsInBrawl
local IsWargame = _G.IsWargame
local IsArenaSkirmish = _G.IsArenaSkirmish
local IsRatedBattleground = _G.IsRatedBattleground
local GetNumSpecializations = _G.GetNumSpecializations
local GetSpecializationInfo = _G.GetSpecializationInfo
local GetPersonalRatedInfo = _G.GetPersonalRatedInfo
local GetBattlefieldWinner = _G.GetBattlefieldWinner
local GetBattlefieldScore = _G.GetBattlefieldScore
local GetBattlefieldTeamInfo = _G.GetBattlefieldTeamInfo
local GetBattlefieldStatData = _G.GetBattlefieldStatData
local GetInstanceInfo = _G.GetInstanceInfo
local GetBattlefieldArenaFaction = _G.GetBattlefieldArenaFaction
local GetNumBattlefieldScores = _G.GetNumBattlefieldScores
local GetNumBattlefieldStats = _G.GetNumBattlefieldStats
local GetBattlefieldInstanceRunTime = _G.GetBattlefieldInstanceRunTime
local GetCurrentArenaSeason = _G.GetCurrentArenaSeason
local GetServerTime = _G.GetServerTime
local GetCVar = _G.GetCVar
local UnitName = _G.UnitName
local UnitFactionGroup = _G.UnitFactionGroup
local CalendarGetDate = _G.CalendarGetDate
local UIParentLoadAddOn = _G.UIParentLoadAddOn
local RegisterAddonMessagePrefix = _G.RegisterAddonMessagePrefix
local SendAddonMessage = _G.SendAddonMessage
local RequestRatedInfo = _G.RequestRatedInfo
local InterfaceOptionsFrame_OpenToCategory = _G.InterfaceOptionsFrame_OpenToCategory
local TimerAfter = _G.C_Timer.After

RE.Version = 236
RE.FoundNewVersion = false

RE.DataSaved = false
RE.MatchData = {}
RE.BGData = {}
RE.ArenaData = {}
RE.PrepareGUI = true
RE.CalendarMode = 0
RE.HideID = 0
RE.Season = 0

RE.PlayerName = UnitName("PLAYER")
RE.PlayerFaction = UnitFactionGroup("PLAYER")
RE.PlayerZone = GetCVar("portal")
RE.PlayerTimezone = time() - time(date('!*t', GetServerTime()))

function RE:OnLoad(self)
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterEvent("PVP_RATED_STATS_UPDATE")
	self:RegisterForDrag("LeftButton")
	tinsert(_G.UISpecialFrames,"REFlex")

	_G.REFlexTab1:SetText(_G.ALL)
	_G.REFlexTab2:SetText(_G.PVP_TAB_HONOR)
	_G.REFlexTab3:SetText(_G.PVP_TAB_CONQUEST)
	_G.REFlexTab4:SetText(_G.ALL)
	_G.REFlexTab5:SetText(_G.PVP_TAB_HONOR)
	_G.REFlexTab6:SetText(_G.PVP_TAB_CONQUEST)

	_G.REFlex_Title:SetText("REFlex "..tostring(RE.Version):gsub(".", "%1."):sub(1,-2))
	_G.REFlex_HKBar_I:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	_G.REFlex_HKBar_I:SetStatusBarColor(0, 0.9, 0)

	RE.TableBG = ST:CreateST(RE.BGStructure, 30, nil, nil, _G.REFlex)
	RE.TableBG.head:SetHeight(25)
	for _, i in pairs({1,3,5,7,9}) do
		local _, parent = _G.REFlexNamespace.TableBG.frame["col"..i.."bg"]:GetPoint(1)
		_G.REFlexNamespace.TableBG.frame["col"..i.."bg"]:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, -9)
		_G.REFlexNamespace.TableBG.frame["col"..i.."bg"]:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT", 0, -9)
	end
	RE.TableBG.frame:SetPoint("TOP", _G.REFlex_ScoreHolder, "BOTTOM", 0, -15)
	RE.TableBG.frame:Hide()
	RE.TableBG:RegisterEvents({
		["OnClick"] = function (_, _, data, _, _, realRow, _, _, button, _)
			if realRow ~= nil and IsAltKeyDown() and IsControlKeyDown() and IsShiftKeyDown() and button == "LeftButton" then
				RE.HideID = data[realRow][11]
				StaticPopup_Show("REFLEX_CONFIRMDELETE")
			end
		end,
		["OnEnter"] = function (_, cellFrame, data, _, _, realRow, _)
			if realRow ~= nil and IsShiftKeyDown() then
				RE:OnEnterTooltip(cellFrame, data[realRow][11])
			end
		end,
		["OnLeave"] = function (_, _, _, _, _, realRow, _)
			if realRow ~= nil then
				RE:OnLeaveTooltip()
			end
		end,
	})
	RE.TableArena = ST:CreateST(RE.ArenaStructure, 18, 25, nil, _G.REFlex)
	RE.TableArena.frame:SetPoint("TOP", _G.REFlex_ScoreHolder, "BOTTOM", 0, -15)
	RE.TableArena.frame:Hide()
	RE.TableArena:RegisterEvents({
		["OnClick"] = function (_, _, data, _, _, realRow, _, _, button, _)
			if realRow ~= nil and IsAltKeyDown() and IsControlKeyDown() and IsShiftKeyDown() and button == "LeftButton" then
				RE.HideID = data[realRow][11]
				StaticPopup_Show("REFLEX_CONFIRMDELETE")
			end
		end,
		["OnEnter"] = function (_, cellFrame, data, _, _, realRow, _)
			if realRow ~= nil and IsShiftKeyDown() then
				RE:OnEnterTooltip(cellFrame, data[realRow][11])
			end
		end,
		["OnLeave"] = function (_, _, _, _, _, realRow, _)
			if realRow ~= nil then
				RE:OnLeaveTooltip()
			end
		end,
	})

	RE.SpecDropDown = GUI:Create("Dropdown")
	RE.SpecDropDown.frame:SetParent(_G.REFlex)
	RE.SpecDropDown.frame:SetPoint("BOTTOMLEFT", _G.REFlex, "BOTTOMLEFT", 15, 18)
	RE.SpecDropDown:SetWidth(150)
	RE.SpecDropDown:SetList({[_G.ALL] = _G.ALL})
	RE.SpecDropDown:SetCallback("OnValueChanged", RE.OnSpecChange)
	RE.BracketDropDown = GUI:Create("Dropdown")
	RE.BracketDropDown.frame:SetParent(_G.REFlex)
	RE.BracketDropDown.frame:SetPoint("LEFT", RE.SpecDropDown.frame, "RIGHT", 5, 0)
	RE.BracketDropDown:SetWidth(100)
	RE.BracketDropDown:SetCallback("OnValueChanged", RE.OnBracketChange)
	RE.BracketDropDown:SetList({[1] = _G.ALL, [4] = "2v2", [6] = "3v3"})
	RE.MapDropDown = GUI:Create("Dropdown")
	RE.MapDropDown.frame:SetParent(_G.REFlex)
	RE.MapDropDown.frame:SetPoint("BOTTOMRIGHT", _G.REFlex, "BOTTOMRIGHT", -19, 18)
	RE.MapDropDown:SetWidth(150)
	RE.MapDropDown:SetCallback("OnValueChanged", RE.OnMapChange)
	RE.DateDropDown = GUI:Create("Dropdown")
	RE.DateDropDown.frame:SetParent(_G.REFlex)
	RE.DateDropDown.frame:SetPoint("RIGHT", RE.MapDropDown.frame, "LEFT", -5, 0)
	RE.DateDropDown:SetWidth(100)
	RE.DateDropDown:SetCallback("OnValueChanged", RE.OnDateChange)
	RE.DateDropDown:SetList({[1] = _G.ALL, [2] = _G.HONOR_TODAY, [3] = _G.HONOR_YESTERDAY, [4] = _G.GUILD_CHALLENGES_THIS_WEEK, [5] = L["This month"], [6] = L["This season"], [7] = L["Prev. season"], [8] = _G.CUSTOM})
end

function RE:OnEvent(_, event, ...)
	if event == "ADDON_LOADED" and ... == "REFlex" then
		if not _G.REFlexSettings then
			_G.REFlexSettings = RE.DefaultConfig
		end
		if not _G.REFlexDatabase then
			_G.REFlexDatabase = {}
		end
		RE.Settings = _G.REFlexSettings
		RE.Database = _G.REFlexDatabase
		RE:UpdateSettings()
		RE:UpdateDatabase()
		RE:HiddenPurge()

		PanelTemplates_SetNumTabs(_G.REFlex, 6)
		PanelTemplates_SetTab(_G.REFlex, RE.Settings.CurrentTab)

		_G.LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("REFlex", RE.AceConfig)
		RE.OptionsMenu = _G.LibStub("AceConfigDialog-3.0"):AddToBlizOptions("REFlex", "REFlex")
		RegisterAddonMessagePrefix("REFlex")
		_G.BINDING_HEADER_REFLEXB = "REFlex"
		_G.BINDING_NAME_REFLEXOPEN = L["Show main window"]
		RequestRatedInfo()

		TOAST:Register("REFlexToast", function(toast, ...)
			toast:SetFormattedTitle("|cFF74D06CRE|r|cFFFFFFFFFlex|r")
			toast:SetFormattedText(...)
			toast:SetIconTexture([[Interface\PvPRankBadges\PvPRank09]])
			toast:MakePersistent()
			if RE.PlayerFaction == "Horde" then
				toast:SetSoundFile([[Sound\Doodad\BellTollHorde.ogg]])
				toast:SetPrimaryCallback(_G.HORDE_CHEER, RE.CloseToast)
			else
				toast:SetSoundFile([[Sound\Doodad\BellTollAlliance.ogg]])
				toast:SetPrimaryCallback(_G.ALLIANCE_CHEER, RE.CloseToast)
			end
		end)
		TOAST:Register("REFlexToastInfo", function(toast, ...)
			toast:SetFormattedTitle("|cFF74D06CRE|r|cFFFFFFFFFlex|r")
			toast:SetFormattedText(...)
			toast:SetIconTexture([[Interface\PvPRankBadges\PvPRank09]])
		end)

		RE.LDB = LDB:NewDataObject("REFlex", {
			type = "launcher",
			text = "REFlex",
			icon = "Interface\\PvPRankBadges\\PvPRank09",
			OnClick = function(_, button, _)
				if button == "LeftButton" then
					if not _G.REFlex:IsVisible() then
						_G.REFlex:Show()
					else
						_G.REFlex:Hide()
					end
				elseif button == "RightButton" then
					_G.InterfaceOptionsFrame:Show()
					InterfaceOptionsFrame_OpenToCategory(_G.REFlexNamespace.OptionsMenu)
				end
			end})
		LDBI:Register("REFlex", RE.LDB, RE.Settings.MiniMapButtonSettings)

		_G.StaticPopupDialogs["REFLEX_FIRSTTIME"] = {
			text = L["Hold SHIFT to display tooltips."].."|n|n"..L["Hold SHIFT and ALT to display extended tooltips."].."|n"..L["They are available only for rated BGs."].."|n|n"..L["SHIFT + ALT + CTRL + CLICK will hide the match."],
			button1 = _G.OKAY,
			OnAccept = function() RE.Settings.FirstTime = false end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = false
		}
		_G.StaticPopupDialogs["REFLEX_CUSTOMDATE"] = {
			text = L["Select start and end date by clicking it."],
			timeout = 0,
			whileDead = true,
			hideOnEscape = false
		}
		_G.StaticPopupDialogs["REFLEX_CONFIRMDELETE"] = {
			text = L["Are you sure you want to hide this entry?"],
			button1 = _G.YES,
			button2 = _G.NO,
			OnAccept = function() RE:HideEntry(RE.HideID) end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}

		RE.DumpFrame = DUMP:New("REFlex - CSV")

		RE:UpdateBGData(true)
		RE:UpdateArenaData(true)
	elseif event == "ADDON_LOADED" and ... == "Blizzard_Calendar" then
		hooksecurefunc("CalendarDayButton_Click", RE.CalendarParser)
		_G.CalendarFrame:HookScript("OnHide", RE.CalendarCleanup)
	elseif event == "CHAT_MSG_ADDON" and ... == "REFlex" then
		local _, message, _ = ...
		local messageEx = {strsplit(";", message)}
		if messageEx[1] == "Version" then
			if not RE.FoundNewVersion and tonumber(messageEx[2]) > RE.Version then
				TOAST:Spawn("REFlexToastInfo", L["New version released!"])
				RE.FoundNewVersion = true
			end
		end
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		local _, instanceType = IsInInstance()
		RE.DataSaved = false
		if instanceType == "pvp" or instanceType == "arena" then
			SendAddonMessage("REFlex", "Version;"..RE.Version, "INSTANCE_CHAT")
			if IsInGuild() then
				SendAddonMessage("REFlex", "Version;"..RE.Version, "GUILD")
			end
		end
	elseif event == "UPDATE_BATTLEFIELD_SCORE" and not RE.DataSaved and GetBattlefieldWinner() ~= nil and _G.WorldStateScoreFrame:IsVisible() then
		RE.DataSaved = true
		TimerAfter(1, RE.PVPEnd)
	elseif event == "PVP_RATED_STATS_UPDATE" then
		RE.Season = GetCurrentArenaSeason()
	end
end

function RE:OnEnterTooltip(cellFrame, databaseID)
	if RE.Database[databaseID].isArena then
		local team, damageSum, healingSum = RE:GetArenaTeamDetails(databaseID, true)
		local teamEnemy, damageSumEnemy, healingSumEnemy = RE:GetArenaTeamDetails(databaseID, false)
		RE.Tooltip = QTIP:Acquire("REFlexTooltip", 7, "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER")
		RE.Tooltip:AddLine()
		for i=1, 7 do
			if i == 4 then
				RE.Tooltip:SetCell(1, 4, "", nil, nil, nil, nil, nil, nil, nil, 50)
			else
				RE.Tooltip:SetCell(1, i, "", nil, nil, nil, nil, nil, nil, nil, 80)
			end
		end
		for i=1, 3 do
			if team[i][2] ~= "" or teamEnemy[i][2] ~= "" then
				RE.Tooltip:AddLine(team[i][1], team[i][7].." "..team[i][2], team[i][3], nil, teamEnemy[i][1], teamEnemy[i][7].." "..teamEnemy[i][2], teamEnemy[i][3])
			end
		end
		RE.Tooltip:AddSeparator(3)
		RE.Tooltip:AddLine(nil, "|cFF74D06C".._G.DAMAGE.."|r", "|cFF74D06C".._G.SHOW_COMBAT_HEALING.."|r", nil, nil, "|cFF74D06C".._G.DAMAGE.."|r", "|cFF74D06C".._G.SHOW_COMBAT_HEALING.."|r")
		for i=1, 3 do
			if team[i][2] ~= "" or teamEnemy[i][2] ~= "" then
				RE.Tooltip:AddLine(team[i][2]..team[i][6], team[i][4], team[i][5], nil, teamEnemy[i][2]..teamEnemy[i][6], teamEnemy[i][4], teamEnemy[i][5])
			end
		end
		RE.Tooltip:AddSeparator(3)
		RE.Tooltip:AddLine(nil, "|cFFFF141D"..damageSum.."|r", "|cFF00ff00"..healingSum.."|r", nil, nil, "|cFFFF141D"..damageSumEnemy.."|r", "|cFF00ff00"..healingSumEnemy.."|r")
	else
		local playerData = RE:GetPlayerData(databaseID)
		local placeKB, placeHK, placeHonor, placeDamage, placeHealing = RE:GetBGPlace(databaseID, false)
		local placeFKB, placeFHK, placeFHonor, placeFDamage, placeFHealing = RE:GetBGPlace(databaseID, true)
		local mmrLine = nil
		RE.Tooltip = QTIP:Acquire("REFlexTooltip", 3, "CENTER", "CENTER", "CENTER")
		if RE.Database[databaseID].isRated then
			if RE.PlayerFaction == "Horde" then
				mmrLine = "|cFF74D06CMMR|r|n|cFFFF141D"..RE:GetMMR(databaseID, true).."|r|n|cFF00A9FF"..RE:GetMMR(databaseID, false).."|r"
			else
				mmrLine = "|cFF74D06CMMR|r|n|cFF00A9FF"..RE:GetMMR(databaseID, true).."|r|n|cFFFF141D"..RE:GetMMR(databaseID, false).."|r"
			end
		end
		RE.Tooltip:AddLine()
		RE.Tooltip:SetCell(1, 1, "|cFF74D06CHK/D|r|n"..RE:GetPlayerKD(databaseID), nil, nil, nil, nil, nil, nil, nil, 50)
		RE.Tooltip:SetCell(1, 2, mmrLine, nil, nil, nil, nil, nil, nil, nil, 50)
		RE.Tooltip:SetCell(1, 3, "|cFF74D06C".._G.DEATHS.."|r|n"..playerData[4], nil, nil, nil, nil, nil, nil, nil, 50)
		RE.Tooltip:AddSeparator(3)
		RE.Tooltip:AddLine(nil, "|cFF74D06C"..L["Place"].."|r", nil)
		RE.Tooltip:SetColumnLayout(3, "LEFT", "CENTER", "CENTER")
		RE.Tooltip:AddLine(nil, _G.FACTION, _G.ALL)
		RE.Tooltip:AddLine("KB", placeFKB, placeKB)
		RE.Tooltip:AddLine("HK", placeFHK, placeHK)
		RE.Tooltip:AddLine(_G.HONOR, placeFHonor, placeHonor)
		RE.Tooltip:AddLine(_G.DAMAGE, placeFDamage, placeDamage)
		RE.Tooltip:AddLine(_G.SHOW_COMBAT_HEALING, placeFHealing, placeHealing)
		RE.Tooltip:SetLineColor(5, 1, 1, 1, 0.5)
		RE.Tooltip:SetLineColor(7, 1, 1, 1, 0.5)
		RE.Tooltip:SetLineColor(9, 1, 1, 1, 0.5)
		RE.Tooltip:SetColumnLayout(3, "CENTER", "CENTER", "CENTER")
		RE.Tooltip:AddSeparator(3)
		local tank, healer, dps = RE:GetBGComposition(databaseID, true)
		local tankE, healerE, dpsE = RE:GetBGComposition(databaseID, false)
		RE.Tooltip:AddLine("|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:0:19:22:41|t", "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:1:20|t", "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:22:41|t")
		if RE.PlayerFaction == "Horde" then
			RE.Tooltip:AddLine("|cFFFF141D"..tank.."|r - |cFF00A9FF"..tankE.."|r", "|cFFFF141D"..healer.."|r - |cFF00A9FF"..healerE.."|r", "|cFFFF141D"..dps.."|r - |cFF00A9FF"..dpsE.."|r")
		else
			RE.Tooltip:AddLine("|cFF00A9FF"..tank.."|r - |cFFFF141D"..tankE.."|r", "|cFF00A9FF"..healer.."|r - |cFFFF141D"..healerE.."|r", "|cFF00A9FF"..dps.."|r - |cFFFF141D"..dpsE.."|r")
		end
		if RE.Database[databaseID].StatsNum > 0 then
			RE.Tooltip:AddSeparator(3)
			local faction = ""
			local playerStatsData = RE:GetPlayerStatsData(databaseID)
			if RE.MapListStat[RE.Database[databaseID].Map][1] or RE.Database[databaseID].StatsNum == 3 then
				if RE.PlayerFaction == "Horde" then
					faction = 0
				else
					faction = 1
				end
			end
			if RE.Database[databaseID].StatsNum == 1 then
				RE.Tooltip:AddLine(nil, "|T"..RE.MapListStat[RE.Database[databaseID].Map][2]..faction..":16:16:0:0|t: "..playerStatsData[1][1], nil)
			elseif RE.Database[databaseID].StatsNum == 3 then
				RE.Tooltip:AddLine("|T"..RE.MapListStat[567][2]..faction..":16:16:0:0|t: "..playerStatsData[1][1], "|T"..RE.MapListStat[567][3]..faction..":16:16:0:0|t: "..playerStatsData[2][1], "|T"..RE.MapListStat[567][4]..":16:16:0:0|t: "..playerStatsData[3][1])
			else
				RE.Tooltip:AddLine("|T"..RE.MapListStat[RE.Database[databaseID].Map][2]..faction..":16:16:0:0|t: "..playerStatsData[1][1], nil, "|T"..RE.MapListStat[RE.Database[databaseID].Map][3]..faction..":16:16:0:0|t: "..playerStatsData[2][1])
				if RE.Database[databaseID].StatsNum > 2 then
					RE.Tooltip:AddLine("|T"..RE.MapListStat[RE.Database[databaseID].Map][4]..faction..":16:16:0:0|t: "..playerStatsData[3][1], nil, "|T"..RE.MapListStat[RE.Database[databaseID].Map][5]..faction..":16:16:0:0|t: "..playerStatsData[4][1])
				end
			end
		end
		if IsAltKeyDown() and RE.Database[databaseID].isRated then
			local team, damageSum, healingSum, kbSum = RE:GetRGBTeamDetails(databaseID, true)
			RE.TooltipRGB1 = QTIP:Acquire("REFlexTooltipRGB1", 7, "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER")
			RE.TooltipRGB1:AddLine()
			for i=1, 7 do
				if i == 2 then
					RE.TooltipRGB1:SetCell(1, 2, "", nil, nil, nil, nil, nil, nil, nil, 10)
				elseif i == 5 then
					RE.TooltipRGB1:SetCell(1, 5, "", nil, nil, nil, nil, nil, nil, nil, 40)
				else
					RE.TooltipRGB1:SetCell(1, i, "", nil, nil, nil, nil, nil, nil, nil, 80)
				end
			end
			RE.TooltipRGB1:AddLine(nil, nil, nil, nil, "|cFF74D06CKB|r", "|cFF74D06C".._G.DAMAGE.."|r", "|cFF74D06C".._G.SHOW_COMBAT_HEALING.."|r")
			for i=1, #team do
				RE.TooltipRGB1:AddLine(team[i][1], team[i][4], team[i][2]..team[i][8], team[i][3], team[i][5], team[i][6], team[i][7])
			end
			RE.TooltipRGB1:AddSeparator(3)
			RE.TooltipRGB1:AddLine(nil, nil, nil, nil, "|cff00ccff"..kbSum.."|r", "|cFFFF141D"..damageSum.."|r", "|cFF00ff00"..healingSum.."|r")
			RE.TooltipRGB1:SetBackdrop(RE.TooltipBackdrop)
			RE.TooltipRGB1:ClearAllPoints()
			RE.TooltipRGB1:SetClampedToScreen(true)
			RE.TooltipRGB1:SetPoint("RIGHT", RE.Tooltip, "LEFT", -5, 0)
			RE.TooltipRGB1:Show()
			local team, damageSum, healingSum, kbSum = RE:GetRGBTeamDetails(databaseID, false)
			RE.TooltipRGB2 = QTIP:Acquire("REFlexTooltipRGB2", 7, "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER")
			RE.TooltipRGB2:AddLine()
			for i=1, 7 do
				if i == 2 then
					RE.TooltipRGB2:SetCell(1, 2, "", nil, nil, nil, nil, nil, nil, nil, 10)
				elseif i == 5 then
					RE.TooltipRGB2:SetCell(1, 5, "", nil, nil, nil, nil, nil, nil, nil, 40)
				else
					RE.TooltipRGB2:SetCell(1, i, "", nil, nil, nil, nil, nil, nil, nil, 80)
				end
			end
			RE.TooltipRGB2:AddLine(nil, nil, nil, nil, "|cFF74D06CKB|r", "|cFF74D06C".._G.DAMAGE.."|r", "|cFF74D06C".._G.SHOW_COMBAT_HEALING.."|r")
			for i=1, #team do
				RE.TooltipRGB2:AddLine(team[i][1], team[i][4], team[i][2]..team[i][8], team[i][3], team[i][5], team[i][6], team[i][7])
			end
			RE.TooltipRGB2:AddSeparator(3)
			RE.TooltipRGB2:AddLine(nil, nil, nil, nil, "|cff00ccff"..kbSum.."|r", "|cFFFF141D"..damageSum.."|r", "|cFF00ff00"..healingSum.."|r")
			RE.TooltipRGB2:SetBackdrop(RE.TooltipBackdrop)
			RE.TooltipRGB2:ClearAllPoints()
			RE.TooltipRGB2:SetClampedToScreen(true)
			RE.TooltipRGB2:SetPoint("LEFT", RE.Tooltip, "RIGHT", 5, 0)
			RE.TooltipRGB2:Show()
		end
	end
	RE.Tooltip:SetBackdrop(RE.TooltipBackdrop)
	RE.Tooltip:SmartAnchorTo(cellFrame)
	RE.Tooltip:Show()
end

function RE:OnLeaveTooltip()
	QTIP:Release(RE.Tooltip)
	QTIP:Release(RE.TooltipRGB1)
	QTIP:Release(RE.TooltipRGB2)
end

function RE:OnSpecChange(_, spec)
	RE.Settings.Filters.Spec = spec
	RE:UpdateGUI()
end

function RE:OnMapChange(_, map)
	RE.Settings.Filters.Map = map
	RE:UpdateGUI()
end

function RE:OnBracketChange(_, bracket)
	RE.Settings.Filters.Bracket = bracket
	RE:UpdateGUI()
end

function RE:OnDateChange(_, mode)
	local weekdayR, monthR, dayR, yearR = CalendarGetDate()
	local t = {day = dayR, month = monthR, year = yearR, hour = 0}
	RE.Settings.Filters.DateMode = mode
	RE.Settings.Filters.Season = 0
	if mode == 1 then
		RE.Settings.Filters.Date = {0, 0}
	elseif mode == 2 then
		RE.Settings.Filters.Date = {time(t) - RE.PlayerTimezone, 0}
	elseif mode == 3 then
		RE.Settings.Filters.Date = {time(t) - 86400 - RE.PlayerTimezone, time(t) - RE.PlayerTimezone}
	elseif mode == 4 then
		if weekdayR == 1 then
			weekdayR = 6
		else
			weekdayR = weekdayR - 2
		end
		RE.Settings.Filters.Date = {time(t) - (weekdayR * 86400) - RE.PlayerTimezone, 0}
	elseif mode == 5 then
		t = {day = 1, month = monthR, year = yearR, hour = 0}
		RE.Settings.Filters.Date = {time(t) - RE.PlayerTimezone, 0}
	elseif mode == 6 then
		RE.Settings.Filters.Date = {0, 0}
		RE.Settings.Filters.Season = RE.Season
	elseif mode == 7 then
		RE.Settings.Filters.Date = {0, 0}
		RE.Settings.Filters.Season = RE.Season - 1
	else
		RE.CalendarMode = 1
		StaticPopup_Show("REFLEX_CUSTOMDATE")
		UIParentLoadAddOn("Blizzard_Calendar")
		_G.CalendarFrame:Show()
		return
	end
	RE:UpdateGUI()
end

function RE:UpdateGUI()
	if RE.Settings.FirstTime then
		StaticPopup_Show("REFLEX_FIRSTTIME")
	end
	if RE.PrepareGUI then
		RequestRatedInfo()
		for i=1, GetNumSpecializations() do
			local Spec = select(2, GetSpecializationInfo(i))
			RE.SpecDropDown:AddItem(Spec, Spec)
		end
		RE.SpecDropDown:SetValue(RE.Settings.Filters.Spec)
		RE.BracketDropDown:SetValue(RE.Settings.Filters.Bracket)
		RE.DateDropDown:SetValue(RE.Settings.Filters.DateMode)
	end
	if PanelTemplates_GetSelectedTab(_G.REFlex) < 4 then
		RE.TableBG.frame:Show()
		RE.TableArena.frame:Hide()
		RE.BracketDropDown:SetDisabled(true)
		if RE.Settings.CurrentTab > 3 or RE.PrepareGUI then
			RE.MapDropDown:SetList(RE.MapListLongBG, RE.MapListLongOrderBG)
			if RE.PrepareGUI then
				RE.PrepareGUI = false
				RE.MapDropDown:SetValue(RE.Settings.Filters.Map)
			else
				RE.MapDropDown:SetValue(1)
				RE.Settings.Filters.Map = 1
			end
		end
		if #RE.TableBG.data == 0 then
			RE.TableBG.cols[1].sort = "asc"
		end
		RE.TableBG:SetData(RE.BGData, true)
		if PanelTemplates_GetSelectedTab(_G.REFlex) == 1 then
			RE.TableBG:SetFilter(RE.FilterDefault)
			_G.REFlex_ScoreHolder_RBG:SetText("|cFFFFD100".._G.RATING..":|r "..select(1, GetPersonalRatedInfo(4)))
		elseif PanelTemplates_GetSelectedTab(_G.REFlex) == 2 then
			RE.TableBG:SetFilter(RE.FilterCasual)
			_G.REFlex_ScoreHolder_RBG:SetText("")
		elseif PanelTemplates_GetSelectedTab(_G.REFlex) == 3 then
			RE.TableBG:SetFilter(RE.FilterRated)
			_G.REFlex_ScoreHolder_RBG:SetText("|cFFFFD100".._G.RATING..":|r "..select(1, GetPersonalRatedInfo(4)))
		end
		local won, lost = RE:GetWinNumber(PanelTemplates_GetSelectedTab(_G.REFlex), false)
		local kb, topKB, hk, topHK, _, _, damage, topDamage, healing, topHealing = RE:GetStats(PanelTemplates_GetSelectedTab(_G.REFlex), false, false)
		_G.REFlex_ScoreHolder_HK1:SetText("|cFFFFD100HK|r")
		_G.REFlex_ScoreHolder_KB1:SetText("|cFFFFD100KB|r")
		_G.REFlex_ScoreHolder_Damage1:SetText("|cFFFFD100".._G.DAMAGE.."|r")
		_G.REFlex_ScoreHolder_Healing1:SetText("|cFFFFD100".._G.SHOW_COMBAT_HEALING.."|r")
		_G.REFlex_ScoreHolder_Wins:SetText(won)
		_G.REFlex_ScoreHolder_Lose:SetText(lost)
		_G.REFlex_ScoreHolder_HK2:SetText(_G.BEST..": "..topHK)
		_G.REFlex_ScoreHolder_HK3:SetText(_G.TOTAL..": "..hk)
		_G.REFlex_ScoreHolder_KB2:SetText(_G.BEST..": "..topKB)
		_G.REFlex_ScoreHolder_KB3:SetText(_G.TOTAL..": "..kb)
		_G.REFlex_ScoreHolder_Damage2:SetText(_G.BEST..": "..RE:AbbreviateNumbers(topDamage))
		_G.REFlex_ScoreHolder_Damage3:SetText(_G.TOTAL..": "..RE:AbbreviateNumbers(damage))
		_G.REFlex_ScoreHolder_Healing2:SetText(_G.BEST..": "..RE:AbbreviateNumbers(topHealing))
		_G.REFlex_ScoreHolder_Healing3:SetText(_G.TOTAL..": "..RE:AbbreviateNumbers(healing))
		RE:HKBarUpdate()
	elseif PanelTemplates_GetSelectedTab(_G.REFlex) > 3 then
		RE.TableArena.frame:Show()
		RE.TableBG.frame:Hide()
		RE.BracketDropDown:SetDisabled(false)
		if RE.Settings.CurrentTab < 4 or RE.PrepareGUI then
			RE.MapDropDown:SetList(RE.MapListLongArena, RE.MapListLongOrderArena)
			if RE.PrepareGUI then
				RE.PrepareGUI = false
				RE.MapDropDown:SetValue(RE.Settings.Filters.Map)
			else
				RE.MapDropDown:SetValue(1)
				RE.Settings.Filters.Map = 1
			end
		end
		if #RE.TableArena.data == 0 then
			RE.TableArena.cols[1].sort = "asc"
		end
		RE.TableArena:SetData(RE.ArenaData, true)
		if PanelTemplates_GetSelectedTab(_G.REFlex) == 4 then
			RE.TableArena:SetFilter(RE.FilterDefault)
			_G.REFlex_ScoreHolder_RBG:SetText("|cFFFFD100".._G.RATING..":|r "..select(1, GetPersonalRatedInfo(1)).." |cFFFFD100/|r "..select(1, GetPersonalRatedInfo(2)))
		elseif PanelTemplates_GetSelectedTab(_G.REFlex) == 5 then
			RE.TableArena:SetFilter(RE.FilterCasual)
			_G.REFlex_ScoreHolder_RBG:SetText("")
		elseif PanelTemplates_GetSelectedTab(_G.REFlex) == 6 then
			RE.TableArena:SetFilter(RE.FilterRated)
			_G.REFlex_ScoreHolder_RBG:SetText("|cFFFFD100".._G.RATING..":|r "..select(1, GetPersonalRatedInfo(1)).." |cFFFFD100/|r "..select(1, GetPersonalRatedInfo(2)))
		end
		local won, lost = RE:GetWinNumber(PanelTemplates_GetSelectedTab(_G.REFlex) - 3, true)
		local _, _, _, _, _, _, damage, topDamage, healing, topHealing = RE:GetStats(PanelTemplates_GetSelectedTab(_G.REFlex) - 3, true, false)
		_G.REFlex_ScoreHolder_HK1:SetText("|cFFFFD100".._G.SHOW_COMBAT_HEALING.."|r")
		_G.REFlex_ScoreHolder_KB1:SetText("|cFFFFD100".._G.DAMAGE.."|r")
		_G.REFlex_ScoreHolder_Damage1:SetText("")
		_G.REFlex_ScoreHolder_Healing1:SetText("")
		_G.REFlex_ScoreHolder_Wins:SetText(won)
		_G.REFlex_ScoreHolder_Lose:SetText(lost)
		_G.REFlex_ScoreHolder_HK2:SetText(_G.BEST..": "..RE:AbbreviateNumbers(topHealing))
		_G.REFlex_ScoreHolder_HK3:SetText(_G.TOTAL..": "..RE:AbbreviateNumbers(healing))
		_G.REFlex_ScoreHolder_KB2:SetText(_G.BEST..": "..RE:AbbreviateNumbers(topDamage))
		_G.REFlex_ScoreHolder_KB3:SetText(_G.TOTAL..": "..RE:AbbreviateNumbers(damage))
		_G.REFlex_ScoreHolder_Damage2:SetText("")
		_G.REFlex_ScoreHolder_Damage3:SetText("")
		_G.REFlex_ScoreHolder_Healing2:SetText("")
		_G.REFlex_ScoreHolder_Healing3:SetText("")
	end
	RE.Settings.CurrentTab = PanelTemplates_GetSelectedTab(_G.REFlex)
end

function RE:UpdateBGData(all)
	local ili
	if all then
		ili = 1
	else
		ili = #RE.Database
	end
	for i=ili, #RE.Database do
		if not RE.Database[i].isArena and not RE.Database[i].Hidden then
			local playeData = RE:GetPlayerData(i)
			local tempData = {RE:DateClean(RE.Database[i].Time),
			RE:GetMapName(RE.Database[i].Map),
			RE:TimeClean(RE.Database[i].Duration),
			RE:GetPlayerWin(i, true),
			playeData[2],
			playeData[3],
			RE:AbbreviateNumbers(playeData[10]),
			RE:AbbreviateNumbers(playeData[11]),
			playeData[5],
			RE:RatingChangeClean(playeData[13], i),
			i,
			playeData[10],
			playeData[11],
			playeData[16],
			playeData[13]}
			tinsert(RE.BGData, tempData)
		end
	end
end

function RE:UpdateArenaData(all)
	local ili
	if all then
		ili = 1
	else
		ili = #RE.Database
	end
	for i=ili, #RE.Database do
		if RE.Database[i].isArena and not RE.Database[i].Hidden then
			local playeData = RE:GetPlayerData(i)
			local tempData = {RE:DateClean(RE.Database[i].Time),
			RE:GetMapName(RE.Database[i].Map),
			RE:GetArenaTeamIcons(i, true),
			RE:GetMMR(i, true),
			RE:GetArenaTeamIcons(i, false),
			RE:GetMMR(i, false),
			RE:TimeClean(RE.Database[i].Duration),
			RE:AbbreviateNumbers(playeData[10]),
			RE:AbbreviateNumbers(playeData[11]),
			RE:RatingChangeClean(playeData[13], i),
			i,
			playeData[10],
			playeData[11],
			playeData[16],
			playeData[13]}
			tinsert(RE.ArenaData, tempData)
		end
	end
end

function RE:UpdateConfig()
	if RE.Settings.MiniMapButtonSettings.hide then
		LDBI:Hide("REFlex")
	else
		LDBI:Show("REFlex")
	end
end

function RE:PVPEnd()
	RE.MatchData = {}

	RE.MatchData.Map = select(8, GetInstanceInfo())
	RE.MatchData.Winner = GetBattlefieldWinner()
	RE.MatchData.PlayerSide = GetBattlefieldArenaFaction()
	RE.MatchData.isArena = IsActiveBattlefieldArena()
	RE.MatchData.Season = GetCurrentArenaSeason()
	RE.MatchData.PlayersNum = GetNumBattlefieldScores()
	RE.MatchData.StatsNum = GetNumBattlefieldStats()
	RE.MatchData.Duration = mfloor(GetBattlefieldInstanceRunTime() / 1000)
	RE.MatchData.Time = time(date('!*t', GetServerTime()))
	RE.MatchData.isBrawl = IsInBrawl()
	RE.MatchData.Version = RE.Version

	if RE.MatchData.Map == 968 then
		RE.MatchData.Map = 566
	end
	if RE.MatchData.Map == 1035 then
		RE.MatchData.Map = 998
	end
	if RE.MatchData.Map == 1681 then
		RE.MatchData.Map = 529
	end

	if (IsRatedBattleground() and not IsWargame()) or (RE.MatchData.isArena and not IsArenaSkirmish()) then
		RE.MatchData.isRated = true
	else
		RE.MatchData.isRated = false
	end

	RE.MatchData.Players = {}
	for i=1, RE.MatchData.PlayersNum do
		local data = {GetBattlefieldScore(i)}
		if data[1] == RE.PlayerName then
			RE.MatchData.PlayerNum = i
		end
		tinsert(RE.MatchData.Players, data)
	end

	if RE.MatchData.isRated then
		RE.MatchData.TeamData = {}
		RE.MatchData.TeamData[1] = {GetBattlefieldTeamInfo(0)}
		RE.MatchData.TeamData[2] = {GetBattlefieldTeamInfo(1)}
	end

	if RE.MatchData.StatsNum > 0 then
		RE.MatchData.PlayersStats = {}
		for i=1, RE.MatchData.PlayersNum do
			RE.MatchData.PlayersStats[i] = {}
			for j=1, RE.MatchData.StatsNum do
				tinsert(RE.MatchData.PlayersStats[i], {GetBattlefieldStatData(i, j)})
			end
		end
	end

	-- Hide corrupted records
	if not RE.MatchData.PlayerNum or RE.MatchData.Map == 1170 or (RE.MatchData.isArena and RE.MatchData.isRated and RE.MatchData.isBrawl) then
		RE.MatchData.Hidden = true
	else
		RE.MatchData.Hidden = false
	end

	tinsert(RE.Database, RE.MatchData)
	if not RE.MatchData.Hidden then
		if RE.MatchData.isArena then
			RE:UpdateArenaData(false)
		else
			RE:UpdateBGData(false)
			if RE.Settings.Toasts then
				TOAST:Spawn("REFlexToast", RE:GetBGToast(#RE.Database))
			end
		end
	else
		print("\124cFF74D06C[REFlex]\124r "..L["API returned corrupted data. Match will not be recorded."])
	end
end
