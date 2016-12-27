REFlexNamespace = {}
local RE = REFlexNamespace
local RES = REFlexSettings
local RED = REFlexDatabase
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

RE.DefaultConfig = {
	["MiniMapButtonSettings"] = {["hide"] = false},
	["Toasts"] = true,
	["ShowServerName"] = false,
	["ConfigVersion"] = RE.Version,
}
RE.MapList = {
	[30] = "AV",
	[529] = "AB",
	[1105] = "DG",
	[566] = "EotS",
	[968] = "EotS",
	[628] = "IoC",
	[727] = "SM",
	[607] = "SotA",
	[998] = "ToK",
	[1035] = "ToK",
	[761] = "TBfG",
	[726] = "TP",
	[489] = "WSG",
	[1552] = "AF",
	[1504] = "BRH",
	[562] = "BE",
	[1672] = "BE",
	[617] = "DS",
	[559] = "NA",
	[1505] = "NA",
	[572] = "RoL",
	[1134] = "TP",
	[980] = "TV"
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
	[998] = GetRealZoneText(998),
	[761] = GetRealZoneText(761),
	[726] = GetRealZoneText(726),
	[489] = GetRealZoneText(489)
}
RE.MapListLongArena = {
	[1] = ALL,
	[1552] = GetRealZoneText(1552),
	[1504] = GetRealZoneText(1504),
	[562] = GetRealZoneText(562),
	[617] = GetRealZoneText(617),
	[559] = GetRealZoneText(559),
	[572] = GetRealZoneText(572),
	[1134] = GetRealZoneText(1134),
	[980] = GetRealZoneText(980)
}
RE.MapListLongOrderBG = {
	1, 30, 529, 1105, 566, 628, 727, 607, 998, 761, 726, 489
}
RE.MapListLongOrderArena = {
	1, 1552, 1504, 562, 617, 559, 572, 1134, 980
}
RE.AceConfig = {
	type = "group",
	args = {
		minimap = {
			name = L["Hide minimap button"],
			type = "toggle",
			width = "full",
			order = 1,
			set = function(_, val) RES.MiniMapButtonSettings.hide = val; RE:UpdateConfig() end,
			get = function(_) return RES.MiniMapButtonSettings.hide end
		},
		toasts = {
			name = L["Enable battleground summary"],
			desc = L["Display toast with battleground summary after completed match."],
			type = "toggle",
			width = "full",
			order = 2,
			set = function(_, val) RES.Toasts = val end,
			get = function(_) return RES.Toasts end
		},
		servername = {
			name = L["Display server names"],
			desc = L["Show player server name in match detail tooltip."],
			type = "toggle",
			width = "full",
			order = 3,
			set = function(_, val) RES.ShowServerName = val end,
			get = function(_) return RES.ShowServerName end
		},
		deletebase = {
			name = L["Purge database"],
			desc = L["WARNING! This operation is not reversible!"],
			type = "execute",
			width = "normal",
			confirm = true,
			order = 4,
			func = function() RED = {}; ReloadUI() end
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

function RE:OnLoad(self)
	self:RegisterEvent("ADDON_LOADED")
  self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
  self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
	self:RegisterEvent("CHAT_MSG_ADDON")
	tinsert(UISpecialFrames,"REFlexGUI")
end

function RE:OnLoadGUI(self)
	self:RegisterForDrag("LeftButton")
	PanelTemplates_SetNumTabs(REFlexGUI, 6)
	PanelTemplates_SetTab(REFlexGUI, 1)

	REFlexGUI_Title:SetText("REFlex "..RE.VersionStr)
	REFlexGUITab1:SetText(ALL)
	REFlexGUITab2:SetText(PVP_TAB_HONOR)
	REFlexGUITab3:SetText(PVP_TAB_CONQUEST)
	REFlexGUITab4:SetText(ALL)
	REFlexGUITab5:SetText(PVP_TAB_HONOR)
	REFlexGUITab6:SetText(PVP_TAB_CONQUEST)

	REFlexGUI_HKBar_I:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	REFlexGUI_HKBar_I:SetStatusBarColor(0, 0.9, 0)

	RE.TableBG = ST:CreateST(RE.BGStructure, 30, nil, nil, REFlexGUI)
	RE.TableBG.frame:SetPoint("TOP", REFlexGUI_ScoreHolder, "BOTTOM", 0, -15)
	RE.TableBG.frame:Hide()
	RE.TableArena = ST:CreateST(RE.ArenaStructure, 18, 25, nil, REFlexGUI)
	RE.TableArena.frame:SetPoint("TOP", REFlexGUI_ScoreHolder, "BOTTOM", 0, -15)
	RE.TableArena.frame:Hide()

	RE.SpecDropDown = GUI:Create("Dropdown")
	RE.SpecDropDown.frame:SetParent(REFlexGUI)
	RE.SpecDropDown.frame:SetPoint("BOTTOMLEFT", REFlexGUI, "BOTTOMLEFT", 15, 18)
	RE.SpecDropDown:SetWidth(150)
	RE.SpecDropDown:SetList({[ALL] = ALL})
	RE.SpecDropDown:SetValue(ALL)
	RE.SpecDropDown:SetCallback("OnValueChanged", RE.OnSpecChange)
	RE.BracketDropDown = GUI:Create("Dropdown")
	RE.BracketDropDown.frame:SetParent(REFlexGUI)
	RE.BracketDropDown.frame:SetPoint("BOTTOM", REFlexGUI, "BOTTOM", 0, 18)
	RE.BracketDropDown:SetWidth(100)
	RE.BracketDropDown:SetCallback("OnValueChanged", RE.OnBracketChange)
	RE.BracketDropDown:SetList({[1] = ALL, [4] = "2v2", [6] = "3v3"})
	RE.BracketDropDown:SetValue(1)
	RE.MapDropDown = GUI:Create("Dropdown")
	RE.MapDropDown.frame:SetParent(REFlexGUI)
	RE.MapDropDown.frame:SetPoint("BOTTOMRIGHT", REFlexGUI, "BOTTOMRIGHT", -19, 18)
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
		RES = REFlexSettings
		RED = REFlexDatabase
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
			OnClick = function(self, button, down)
				if button == "LeftButton" then
					if not REFlexGUI:IsVisible() then
						REFlexGUI:Show()
					else
						REFlexGUI:Hide()
					end
				elseif button == "RightButton" then
					InterfaceOptionsFrame:Show()
					InterfaceOptionsFrame_OpenToCategory(REFlexNamespace.OptionsMenu)
				end
			end})
		LDBI:Register("REFlex", RE.LDB, REFlexSettings.MiniMapButtonSettings)

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
	if RE.PrepareGUI then
		RE.PrepareGUI = false
		for i=1, GetNumSpecializations() do
			local Spec = select(2, GetSpecializationInfo(i))
			RE.SpecDropDown:AddItem(Spec, Spec)
		end
	end
	if PanelTemplates_GetSelectedTab(REFlexGUI) < 4 then
		RE.TableBG.frame:Show()
		RE.TableArena.frame:Hide()
		RE.BracketDropDown.frame:Hide()
		REFlexGUI_HKBar:Show()
		if RE.LastTab > 3 or RE.LastTab == 0 then
			RE.MapDropDown:SetList(RE.MapListLongBG, RE.MapListLongOrderBG)
			RE.MapDropDown:SetValue(1)
			RE.MapFilterVal = 1
		end
		if table.getn(RE.TableBG.data) == 0 then
			RE.TableBG.cols[1].sort = "asc"
		end
		RE.TableBG:SetData(RE.BGData, true)
		if PanelTemplates_GetSelectedTab(REFlexGUI) == 1 then
			RE.TableBG:SetFilter(RE.FilterDefault)
			REFlexGUI_ScoreHolder_RBG:SetText("|cFFFFD100"..RATING..":|r "..select(1, GetPersonalRatedInfo(4)))
		elseif PanelTemplates_GetSelectedTab(REFlexGUI) == 2 then
			RE.TableBG:SetFilter(RE.FilterCasual)
			REFlexGUI_ScoreHolder_RBG:SetText("")
		elseif PanelTemplates_GetSelectedTab(REFlexGUI) == 3 then
			RE.TableBG:SetFilter(RE.FilterRated)
			REFlexGUI_ScoreHolder_RBG:SetText("|cFFFFD100"..RATING..":|r "..select(1, GetPersonalRatedInfo(4)))
		end
		local won, lost = RE:GetWinNumber(PanelTemplates_GetSelectedTab(REFlexGUI), false)
		local kb, topKB, hk, topHK, _, _, damage, topDamage, healing, topHealing = RE:GetStats(PanelTemplates_GetSelectedTab(REFlexGUI), false, false)
		REFlexGUI_ScoreHolder_HK1:SetText("|cFFFFD100HK|r")
		REFlexGUI_ScoreHolder_KB1:SetText("|cFFFFD100KB|r")
		REFlexGUI_ScoreHolder_Damage1:SetText("|cFFFFD100"..DAMAGE.."|r")
		REFlexGUI_ScoreHolder_Healing1:SetText("|cFFFFD100"..SHOW_COMBAT_HEALING.."|r")
		REFlexGUI_ScoreHolder_Wins:SetText(won)
		REFlexGUI_ScoreHolder_Lose:SetText(lost)
		REFlexGUI_ScoreHolder_HK2:SetText(BEST..": "..topHK)
		REFlexGUI_ScoreHolder_HK3:SetText(TOTAL..": "..hk)
		REFlexGUI_ScoreHolder_KB2:SetText(BEST..": "..topKB)
		REFlexGUI_ScoreHolder_KB3:SetText(TOTAL..": "..kb)
		REFlexGUI_ScoreHolder_Damage2:SetText(BEST..": "..AbbreviateNumbers(topDamage))
		REFlexGUI_ScoreHolder_Damage3:SetText(TOTAL..": "..AbbreviateNumbers(damage))
		REFlexGUI_ScoreHolder_Healing2:SetText(BEST..": "..AbbreviateNumbers(topHealing))
		REFlexGUI_ScoreHolder_Healing3:SetText(TOTAL..": "..AbbreviateNumbers(healing))
		RE:HKBarUpdate()
	elseif PanelTemplates_GetSelectedTab(REFlexGUI) > 3 then
		RE.TableArena.frame:Show()
		RE.TableBG.frame:Hide()
		RE.BracketDropDown.frame:Show()
		REFlexGUI_HKBar:Hide()
		if RE.LastTab < 4 then
			RE.MapDropDown:SetList(RE.MapListLongArena, RE.MapListLongOrderArena)
			RE.MapDropDown:SetValue(1)
			RE.MapFilterVal = 1
		end
		if table.getn(RE.TableArena.data) == 0 then
			RE.TableArena.cols[1].sort = "asc"
		end
		RE.TableArena:SetData(RE.ArenaData, true)
		if PanelTemplates_GetSelectedTab(REFlexGUI) == 4 then
			RE.TableArena:SetFilter(RE.FilterDefault)
			REFlexGUI_ScoreHolder_RBG:SetText("|cFFFFD100"..RATING..":|r "..select(1, GetPersonalRatedInfo(1)).." |cFFFFD100/|r "..select(1, GetPersonalRatedInfo(2)))
		elseif PanelTemplates_GetSelectedTab(REFlexGUI) == 5 then
			RE.TableArena:SetFilter(RE.FilterCasual)
			REFlexGUI_ScoreHolder_RBG:SetText("")
		elseif PanelTemplates_GetSelectedTab(REFlexGUI) == 6 then
			RE.TableArena:SetFilter(RE.FilterRated)
			REFlexGUI_ScoreHolder_RBG:SetText("|cFFFFD100"..RATING..":|r "..select(1, GetPersonalRatedInfo(1)).." |cFFFFD100/|r "..select(1, GetPersonalRatedInfo(2)))
		end
		local won, lost = RE:GetWinNumber(PanelTemplates_GetSelectedTab(REFlexGUI) - 3, true)
		local _, _, _, _, _, _, damage, topDamage, healing, topHealing = RE:GetStats(PanelTemplates_GetSelectedTab(REFlexGUI) - 3, true, false)
		REFlexGUI_ScoreHolder_HK1:SetText("|cFFFFD100"..SHOW_COMBAT_HEALING.."|r")
		REFlexGUI_ScoreHolder_KB1:SetText("|cFFFFD100"..DAMAGE.."|r")
		REFlexGUI_ScoreHolder_Damage1:SetText("")
		REFlexGUI_ScoreHolder_Healing1:SetText("")
		REFlexGUI_ScoreHolder_Wins:SetText(won)
		REFlexGUI_ScoreHolder_Lose:SetText(lost)
		REFlexGUI_ScoreHolder_HK2:SetText(BEST..": "..AbbreviateNumbers(topHealing))
		REFlexGUI_ScoreHolder_HK3:SetText(TOTAL..": "..AbbreviateNumbers(healing))
		REFlexGUI_ScoreHolder_KB2:SetText(BEST..": "..AbbreviateNumbers(topDamage))
		REFlexGUI_ScoreHolder_KB3:SetText(TOTAL..": "..AbbreviateNumbers(damage))
		REFlexGUI_ScoreHolder_Damage2:SetText("")
		REFlexGUI_ScoreHolder_Damage3:SetText("")
		REFlexGUI_ScoreHolder_Healing2:SetText("")
		REFlexGUI_ScoreHolder_Healing3:SetText("")
	end
	RE.LastTab = PanelTemplates_GetSelectedTab(REFlexGUI)
end

function RE:UpdateBGData(all)
	local ili
	if all then
		ili = 1
	else
		ili = table.getn(RED)
	end
	for i=ili, table.getn(RED) do
		if not RED[i].isArena then
			local playeData = RE:GetPlayerData(i)
			local tempData = {RE:DateClean(RED[i].Time),
												RE:GetMapName(RED[i].Map),
												RE:TimeClean(RED[i].Duration),
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
		ili = table.getn(RED)
	end
	for i=ili, table.getn(RED) do
		if RED[i].isArena then
			local playeData = RE:GetPlayerData(i)
			local tempData = {RE:DateClean(RED[i].Time),
												RE:GetMapName(RED[i].Map),
												RE:GetArenaTeam(i, true),
												RE:GetArenaMMR(i, true),
												RE:GetArenaTeam(i, false),
												RE:GetArenaMMR(i, false),
												RE:TimeClean(RED[i].Duration),
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
	if RES.MiniMapButtonSettings.hide then
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

    table.insert(RED, RE.MatchData)
		if RE.MatchData.isArena then
			RE:UpdateArenaData(false)
		else
			RE:UpdateBGData(false)
			if RES.Toasts then
				TOAST:Spawn("REFlexToast", RE:GetBGToast(table.getn(RED)))
			end
		end
  end
end
