REFlexNamespace = {["Settings"] = {}, ["Database"] = {}}
local RE = REFlexNamespace
local L = LibStub("AceLocale-3.0"):GetLocale("REFlex")
local ST = LibStub("ScrollingTable")
local GUI = LibStub("AceGUI-3.0")
local LDB = LibStub("LibDataBroker-1.1")
local LDBI = LibStub("LibDBIcon-1.0")
local TOAST = LibStub("LibToast-1.0")
local QTIP = LibStub("LibQTip-1.0")

RE.Version = 200
RE.VersionStr = "2.0.0"
RE.FoundNewVersion = false

RE.DataSaved = false
RE.MatchData = {}
RE.BGData = {}
RE.ArenaData = {}
RE.PrepareGUI = true
RE.LastTab = 0
RE.SpecFilterVal = ALL
RE.MapFilterVal = 1
RE.BracketFilterVal = 1

RE.PlayerName = UnitName("PLAYER")
RE.PlayerFaction = UnitFactionGroup("PLAYER")
RE.PlayerZone = GetCVar("portal")

function RE:OnLoad(self)
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterForDrag("LeftButton")
	tinsert(UISpecialFrames,"REFlex")
	PanelTemplates_SetNumTabs(REFlex, 6)
	PanelTemplates_SetTab(REFlex, 1)

	REFlexTab1:SetText(ALL)
	REFlexTab2:SetText(PVP_TAB_HONOR)
	REFlexTab3:SetText(PVP_TAB_CONQUEST)
	REFlexTab4:SetText(ALL)
	REFlexTab5:SetText(PVP_TAB_HONOR)
	REFlexTab6:SetText(PVP_TAB_CONQUEST)

	REFlex_Title:SetText("REFlex "..RE.VersionStr)
	REFlex_HKBar_I:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	REFlex_HKBar_I:SetStatusBarColor(0, 0.9, 0)

	RE.TableBG = ST:CreateST(RE.BGStructure, 30, nil, nil, REFlex)
	RE.TableBG.frame:SetPoint("TOP", REFlex_ScoreHolder, "BOTTOM", 0, -15)
	RE.TableBG.frame:Hide()
	RE.TableBG:RegisterEvents({
		["OnEnter"] = function (_, cellFrame, data, _, _, realRow, ...)
			if realRow ~= nil and IsShiftKeyDown() then
				RE:OnEnterTooltip(cellFrame, data[realRow][11])
			end
		end,
		["OnLeave"] = function (_, _, _, _, _, realRow, ...)
			if realRow ~= nil then
				RE:OnLeaveTooltip()
			end
		end,
	})
	RE.TableArena = ST:CreateST(RE.ArenaStructure, 18, 25, nil, REFlex)
	RE.TableArena.frame:SetPoint("TOP", REFlex_ScoreHolder, "BOTTOM", 0, -15)
	RE.TableArena.frame:Hide()
	RE.TableArena:RegisterEvents({
		["OnEnter"] = function (_, cellFrame, data, _, _, realRow, ...)
			if realRow ~= nil and IsShiftKeyDown() then
				RE:OnEnterTooltip(cellFrame, data[realRow][11])
			end
		end,
		["OnLeave"] = function (_, _, _, _, _, realRow, ...)
			if realRow ~= nil then
				RE:OnLeaveTooltip()
			end
		end,
	})

	RE.SpecDropDown = GUI:Create("Dropdown")
	RE.SpecDropDown.frame:SetParent(REFlex)
	RE.SpecDropDown.frame:SetPoint("BOTTOMLEFT", REFlex, "BOTTOMLEFT", 15, 18)
	RE.SpecDropDown:SetWidth(150)
	RE.SpecDropDown:SetList({[ALL] = ALL})
	RE.SpecDropDown:SetValue(ALL)
	RE.SpecDropDown:SetCallback("OnValueChanged", RE.OnSpecChange)
	RE.BracketDropDown = GUI:Create("Dropdown")
	RE.BracketDropDown.frame:SetParent(REFlex)
	RE.BracketDropDown.frame:SetPoint("BOTTOM", REFlex, "BOTTOM", 0, 18)
	RE.BracketDropDown:SetWidth(100)
	RE.BracketDropDown:SetCallback("OnValueChanged", RE.OnBracketChange)
	RE.BracketDropDown:SetList({[1] = ALL, [4] = "2v2", [6] = "3v3"})
	RE.BracketDropDown:SetValue(1)
	RE.MapDropDown = GUI:Create("Dropdown")
	RE.MapDropDown.frame:SetParent(REFlex)
	RE.MapDropDown.frame:SetPoint("BOTTOMRIGHT", REFlex, "BOTTOMRIGHT", -19, 18)
	RE.MapDropDown:SetWidth(150)
	RE.MapDropDown:SetCallback("OnValueChanged", RE.OnMapChange)
end

function RE:OnEvent(self, event, ...)
	if event == "ADDON_LOADED" and ... == "REFlex" then
    if not REFlexSettings then
  		REFlexSettings = RE.DefaultConfig
  	end
    if not REFlexDatabase then
      REFlexDatabase = {}
    end
		RE.Settings = REFlexSettings
		RE.Database = REFlexDatabase
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("REFlex", RE.AceConfig)
		RE.OptionsMenu = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("REFlex", "REFlex")
		RegisterAddonMessagePrefix("REFlex")
		BINDING_HEADER_REFLEXB = "REFlex"
		BINDING_NAME_REFLEXOPEN = L["Show main window"]
		RequestRatedInfo()

		TOAST:Register("REFlexToast", function(toast, ...)
	    toast:SetFormattedTitle("|cFF74D06CRE|r|cFFFFFFFFFlex|r")
	    toast:SetFormattedText(...)
	    toast:SetIconTexture([[Interface\PvPRankBadges\PvPRank09]])
			toast:MakePersistent()
			if RE.PlayerFaction == "Horde" then
	      toast:SetSoundFile([[Sound\Doodad\BellTollHorde.ogg]])
	      toast:SetPrimaryCallback(HORDE_CHEER, RE.CloseToast)
			else
				toast:SetSoundFile([[Sound\Doodad\BellTollAlliance.ogg]])
	      toast:SetPrimaryCallback(ALLIANCE_CHEER, RE.CloseToast)
			end
		end)
		TOAST:Register("REFlexToastInfo", function(toast, ...)
	    toast:SetFormattedTitle("|cFF74D06CRE|r|cFFFFFFFFFlex|r")
			toast:SetFormattedText(...)
			toast:SetIconTexture([[Interface\PvPRankBadges\PvPRank09]])
		end)

		RE.LDB = LDB:NewDataObject("REFlex", {
			type = "launcher",
			text = "REPorter",
			icon = "Interface\\PvPRankBadges\\PvPRank09",
			OnClick = function(self, button, _)
				if button == "LeftButton" then
					if not REFlex:IsVisible() then
						REFlex:Show()
					else
						REFlex:Hide()
					end
				elseif button == "RightButton" then
					InterfaceOptionsFrame:Show()
					InterfaceOptionsFrame_OpenToCategory(REFlexNamespace.OptionsMenu)
				end
			end})
		LDBI:Register("REFlex", RE.LDB, RE.Settings.MiniMapButtonSettings)

		StaticPopupDialogs["REFLEX_FIRSTTIME"] = {
			text = L["Hold SHIFT key to display tooltips with additional data."],
			button1 = OKAY,
			OnAccept = function() RE.Settings.FirstTime = false end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = false,
		}

		RE:UpdateBGData(true)
		RE:UpdateArenaData(true)
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
    RE.DataSaved = false
		SendAddonMessage("REFlex", "Version;"..RE.Version, "INSTANCE_CHAT")
		if IsInGuild() then
			SendAddonMessage("REFlex", "Version;"..RE.Version, "GUILD")
		end
  elseif event == "UPDATE_BATTLEFIELD_SCORE" then
		RE:PVPEnd()
  end
end

function RE:OnEnterTooltip(cellFrame, databaseID)
	if RE.Database[databaseID].isArena then
		RE.Tooltip = QTIP:Acquire("REFlexTooltip", 6, "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER")
		--TODO
	else
		local playerData = RE:GetPlayerData(databaseID)
		local placeKB, placeHK, placeHonor, placeDamage, placeHealing = RE:GetBGPlace(databaseID, false)
		local placeFKB, placeFHK, placeFHonor, placeFDamage, placeFHealing = RE:GetBGPlace(databaseID, true)
		RE.Tooltip = QTIP:Acquire("REFlexTooltip", 3, "CENTER", "CENTER", "CENTER")
		RE.Tooltip:AddLine("", "", "")
		RE.Tooltip:SetCell(1, 1, "|cFF74D06CHK/D|r|n"..RE:GetPlayerKD(databaseID), nil, nil, nil, nil, nil, nil, nil, 50)
		RE.Tooltip:SetCell(1, 2, "", nil, nil, nil, nil, nil, nil, nil, 50)
		RE.Tooltip:SetCell(1, 3, "|cFF74D06C"..DEATHS.."|r|n"..playerData[4], nil, nil, nil, nil, nil, nil, nil, 50)
		RE.Tooltip:AddSeparator()
		RE.Tooltip:AddLine("", "|cFF74D06C"..L["Place"].."|r", "")
		RE.Tooltip:SetColumnLayout(3, "LEFT", "CENTER", "CENTER")
		RE.Tooltip:AddLine("", FACTION, ALL)
		RE.Tooltip:AddLine("KB", placeFKB, placeKB)
		RE.Tooltip:AddLine("HK", placeFHK, placeHK)
		RE.Tooltip:AddLine(HONOR, placeFHonor, placeHonor)
		RE.Tooltip:AddLine(DAMAGE, placeFDamage, placeDamage)
		RE.Tooltip:AddLine(SHOW_COMBAT_HEALING, placeFHealing, placeHealing)
		RE.Tooltip:SetLineColor(5, 1, 1, 1, 0.5)
		RE.Tooltip:SetLineColor(7, 1, 1, 1, 0.5)
		RE.Tooltip:SetLineColor(9, 1, 1, 1, 0.5)
		if RE.Database[databaseID].StatsNum > 0 then
			RE.Tooltip:SetColumnLayout(3, "CENTER", "CENTER", "CENTER")
			RE.Tooltip:AddSeparator()
			local faction = ""
			local playerStatsData = RE:GetPlayerStatsData(databaseID)
			if RE.MapListStat[RE.Database[databaseID].Map][1] then
				if RE.PlayerFaction == "Horde" then
					faction = 0
				else
					faction = 1
				end
			end
			if RE.Database[databaseID].StatsNum == 1 then
				RE.Tooltip:AddLine("", "|T"..RE.MapListStat[RE.Database[databaseID].Map][2]..faction..":16:16:0:0|t: "..playerStatsData[1][1], "")
			else
				RE.Tooltip:AddLine("|T"..RE.MapListStat[RE.Database[databaseID].Map][2]..faction..":16:16:0:0|t: "..playerStatsData[1][1], "", "|T"..RE.MapListStat[RE.Database[databaseID].Map][3]..faction..":16:16:0:0|t: "..playerStatsData[2][1])
				if RE.Database[databaseID].StatsNum > 2 then
					RE.Tooltip:AddLine("|T"..RE.MapListStat[RE.Database[databaseID].Map][4]..faction..":16:16:0:0|t: "..playerStatsData[3][1], "", "|T"..RE.MapListStat[RE.Database[databaseID].Map][5]..faction..":16:16:0:0|t: "..playerStatsData[4][1])
				end
			end
		end
	end
	RE.Tooltip:SmartAnchorTo(cellFrame)
	RE.Tooltip:Show()
end

function RE:OnLeaveTooltip()
	QTIP:Release(RE.Tooltip)
end

function RE:OnSpecChange(_, spec)
	RE.SpecFilterVal = spec
	RE:UpdateGUI()
end

function RE:OnMapChange(_, map)
	RE.MapFilterVal = map
	RE:UpdateGUI()
end

function RE:OnBracketChange(_, bracket)
	RE.BracketFilterVal = bracket
	RE:UpdateGUI()
end

function RE:UpdateGUI()
	if RE.Settings.FirstTime then
		StaticPopup_Show("REFLEX_FIRSTTIME")
	end
	if RE.PrepareGUI then
		RE.PrepareGUI = false
		RequestRatedInfo()
		for i=1, GetNumSpecializations() do
			local Spec = select(2, GetSpecializationInfo(i))
			RE.SpecDropDown:AddItem(Spec, Spec)
		end
	end
	if PanelTemplates_GetSelectedTab(REFlex) < 4 then
		RE.TableBG.frame:Show()
		RE.TableArena.frame:Hide()
		RE.BracketDropDown.frame:Hide()
		REFlex_HKBar:Show()
		if RE.LastTab > 3 or RE.LastTab == 0 then
			RE.MapDropDown:SetList(RE.MapListLongBG, RE.MapListLongOrderBG)
			RE.MapDropDown:SetValue(1)
			RE.MapFilterVal = 1
		end
		if table.getn(RE.TableBG.data) == 0 then
			RE.TableBG.cols[1].sort = "asc"
		end
		RE.TableBG:SetData(RE.BGData, true)
		if PanelTemplates_GetSelectedTab(REFlex) == 1 then
			RE.TableBG:SetFilter(RE.FilterDefault)
			REFlex_ScoreHolder_RBG:SetText("|cFFFFD100"..RATING..":|r "..select(1, GetPersonalRatedInfo(4)))
		elseif PanelTemplates_GetSelectedTab(REFlex) == 2 then
			RE.TableBG:SetFilter(RE.FilterCasual)
			REFlex_ScoreHolder_RBG:SetText("")
		elseif PanelTemplates_GetSelectedTab(REFlex) == 3 then
			RE.TableBG:SetFilter(RE.FilterRated)
			REFlex_ScoreHolder_RBG:SetText("|cFFFFD100"..RATING..":|r "..select(1, GetPersonalRatedInfo(4)))
		end
		local won, lost = RE:GetWinNumber(PanelTemplates_GetSelectedTab(REFlex), false)
		local kb, topKB, hk, topHK, _, _, damage, topDamage, healing, topHealing = RE:GetStats(PanelTemplates_GetSelectedTab(REFlex), false, false)
		REFlex_ScoreHolder_HK1:SetText("|cFFFFD100HK|r")
		REFlex_ScoreHolder_KB1:SetText("|cFFFFD100KB|r")
		REFlex_ScoreHolder_Damage1:SetText("|cFFFFD100"..DAMAGE.."|r")
		REFlex_ScoreHolder_Healing1:SetText("|cFFFFD100"..SHOW_COMBAT_HEALING.."|r")
		REFlex_ScoreHolder_Wins:SetText(won)
		REFlex_ScoreHolder_Lose:SetText(lost)
		REFlex_ScoreHolder_HK2:SetText(BEST..": "..topHK)
		REFlex_ScoreHolder_HK3:SetText(TOTAL..": "..hk)
		REFlex_ScoreHolder_KB2:SetText(BEST..": "..topKB)
		REFlex_ScoreHolder_KB3:SetText(TOTAL..": "..kb)
		REFlex_ScoreHolder_Damage2:SetText(BEST..": "..AbbreviateNumbers(topDamage))
		REFlex_ScoreHolder_Damage3:SetText(TOTAL..": "..AbbreviateNumbers(damage))
		REFlex_ScoreHolder_Healing2:SetText(BEST..": "..AbbreviateNumbers(topHealing))
		REFlex_ScoreHolder_Healing3:SetText(TOTAL..": "..AbbreviateNumbers(healing))
		RE:HKBarUpdate()
	elseif PanelTemplates_GetSelectedTab(REFlex) > 3 then
		RE.TableArena.frame:Show()
		RE.TableBG.frame:Hide()
		RE.BracketDropDown.frame:Show()
		REFlex_HKBar:Hide()
		if RE.LastTab < 4 then
			RE.MapDropDown:SetList(RE.MapListLongArena, RE.MapListLongOrderArena)
			RE.MapDropDown:SetValue(1)
			RE.MapFilterVal = 1
		end
		if table.getn(RE.TableArena.data) == 0 then
			RE.TableArena.cols[1].sort = "asc"
		end
		RE.TableArena:SetData(RE.ArenaData, true)
		if PanelTemplates_GetSelectedTab(REFlex) == 4 then
			RE.TableArena:SetFilter(RE.FilterDefault)
			REFlex_ScoreHolder_RBG:SetText("|cFFFFD100"..RATING..":|r "..select(1, GetPersonalRatedInfo(1)).." |cFFFFD100/|r "..select(1, GetPersonalRatedInfo(2)))
		elseif PanelTemplates_GetSelectedTab(REFlex) == 5 then
			RE.TableArena:SetFilter(RE.FilterCasual)
			REFlex_ScoreHolder_RBG:SetText("")
		elseif PanelTemplates_GetSelectedTab(REFlex) == 6 then
			RE.TableArena:SetFilter(RE.FilterRated)
			REFlex_ScoreHolder_RBG:SetText("|cFFFFD100"..RATING..":|r "..select(1, GetPersonalRatedInfo(1)).." |cFFFFD100/|r "..select(1, GetPersonalRatedInfo(2)))
		end
		local won, lost = RE:GetWinNumber(PanelTemplates_GetSelectedTab(REFlex) - 3, true)
		local _, _, _, _, _, _, damage, topDamage, healing, topHealing = RE:GetStats(PanelTemplates_GetSelectedTab(REFlex) - 3, true, false)
		REFlex_ScoreHolder_HK1:SetText("|cFFFFD100"..SHOW_COMBAT_HEALING.."|r")
		REFlex_ScoreHolder_KB1:SetText("|cFFFFD100"..DAMAGE.."|r")
		REFlex_ScoreHolder_Damage1:SetText("")
		REFlex_ScoreHolder_Healing1:SetText("")
		REFlex_ScoreHolder_Wins:SetText(won)
		REFlex_ScoreHolder_Lose:SetText(lost)
		REFlex_ScoreHolder_HK2:SetText(BEST..": "..AbbreviateNumbers(topHealing))
		REFlex_ScoreHolder_HK3:SetText(TOTAL..": "..AbbreviateNumbers(healing))
		REFlex_ScoreHolder_KB2:SetText(BEST..": "..AbbreviateNumbers(topDamage))
		REFlex_ScoreHolder_KB3:SetText(TOTAL..": "..AbbreviateNumbers(damage))
		REFlex_ScoreHolder_Damage2:SetText("")
		REFlex_ScoreHolder_Damage3:SetText("")
		REFlex_ScoreHolder_Healing2:SetText("")
		REFlex_ScoreHolder_Healing3:SetText("")
	end
	RE.LastTab = PanelTemplates_GetSelectedTab(REFlex)
end

function RE:UpdateBGData(all)
	local ili
	if all then
		ili = 1
	else
		ili = table.getn(RE.Database)
	end
	for i=ili, table.getn(RE.Database) do
		if not RE.Database[i].isArena then
			local playeData = RE:GetPlayerData(i)
			local tempData = {RE:DateClean(RE.Database[i].Time),
												RE:GetMapName(RE.Database[i].Map),
												RE:TimeClean(RE.Database[i].Duration),
												RE:GetPlayerWin(i, true),
												playeData[2],
												playeData[3],
												AbbreviateNumbers(playeData[10]),
												AbbreviateNumbers(playeData[11]),
												playeData[5],
												RE:RatingChangeClean(playeData[13]),
												i,
												playeData[10],
												playeData[11],
												playeData[16]}
			table.insert(RE.BGData, tempData)
		end
	end
end

function RE:UpdateArenaData(all)
	local ili
	if all then
		ili = 1
	else
		ili = table.getn(RE.Database)
	end
	for i=ili, table.getn(RE.Database) do
		if RE.Database[i].isArena then
			local playeData = RE:GetPlayerData(i)
			local tempData = {RE:DateClean(RE.Database[i].Time),
												RE:GetMapName(RE.Database[i].Map),
												RE:GetArenaTeam(i, true),
												RE:GetArenaMMR(i, true),
												RE:GetArenaTeam(i, false),
												RE:GetArenaMMR(i, false),
												RE:TimeClean(RE.Database[i].Duration),
												AbbreviateNumbers(playeData[10]),
												AbbreviateNumbers(playeData[11]),
												RE:RatingChangeClean(playeData[13]),
												i,
												playeData[10],
												playeData[11],
												playeData[16]}
			table.insert(RE.ArenaData, tempData)
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
  if GetBattlefieldWinner() ~= nil and not RE.DataSaved then
    RE.DataSaved = true
    RE.MatchData = {}

    RE.MatchData.Map = select(8, GetInstanceInfo())
    RE.MatchData.Winner = GetBattlefieldWinner()
    RE.MatchData.PlayerSide = GetBattlefieldArenaFaction()
    RE.MatchData.isArena = IsActiveBattlefieldArena()
    RE.MatchData.Season = GetCurrentArenaSeason()
    RE.MatchData.PlayersNum = GetNumBattlefieldScores()
    RE.MatchData.StatsNum = GetNumBattlefieldStats()
    RE.MatchData.Duration = math.floor(GetBattlefieldInstanceRunTime() / 1000)
  	RE.MatchData.Time = GetServerTime()
    RE.MatchData.Version = RE.Version

		if RE.MatchData.Map == 968 then
			RE.MatchData.Map = 566
		end
		if RE.MatchData.Map == 1035 then
			RE.MatchData.Map = 998
		end
		if RE.MatchData.Map == 1672 then
			RE.MatchData.Map = 562
		end
		if RE.MatchData.Map == 1505 then
			RE.MatchData.Map = 559
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
      table.insert(RE.MatchData.Players, data)
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
          table.insert(RE.MatchData.PlayersStats[i], {GetBattlefieldStatData(i, j)})
        end
      end
    end

    table.insert(RE.Database, RE.MatchData)
		if RE.MatchData.isArena then
			RE:UpdateArenaData(false)
		else
			RE:UpdateBGData(false)
			if RE.Settings.Toasts then
				TOAST:Spawn("REFlexToast", RE:GetBGToast(table.getn(RE.Database)))
			end
		end
  end
end
