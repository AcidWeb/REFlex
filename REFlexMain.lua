REFlexNamespace = {};
local RE = REFlexNamespace;
local L = REFlexLocale;

RE.ScrollingTable = LibStub("ScrollingTable");
RE.ShefkiTimer = LibStub("LibShefkiTimer-1.0");
RE.QTip = LibStub('LibQTip-1.0');
RE.LDB = LibStub("LibDataBroker-1.1");

RE.ModuleTranslation = {
	["KillingBlows"] = KILLING_BLOWS,
	["HonorKills"] = L["Honor Kills"],
	["Damage"] = DAMAGE,
	["Healing"] = SHOW_COMBAT_HEALING,
	["Deaths"] = DEATHS,
	["KDRatio"] = L["K/D Ratio"],
	["Honor"] = HONOR 
};

RE.DataVersion = 19;
RE.AddonVersion = "v0.9.8.2";
RE.AddonVersionCheck = 982;

RE.Debug = 0;

RE.GuildMembers = {};
RE.ArenaTeams = {};
RE.ArenaTeamsSpec = {};
RE.Tab7Matrix = {};
RE.FriendRosterStringTable = {};
RE.EnemyRosterStringTable = {};
RE.Tab7Default = {["F"] = {["d"] = 1, ["m"] = 1, ["y"] = 2011}, ["T"] = {["d"] = 0, ["m"] = 0, ["y"] = 0}};
RE.Tab7Search = {["F"] = {["d"] = 1, ["m"] = 1, ["y"] = 2011}, ["T"] = {["d"] = 0, ["m"] = 0, ["y"] = 0}};

RE.ArenaReload = true;
RE.BattlegroundReload = true;
RE.Tab7GuildOnly = false;
RE.FoundNewVersion = false;
RE.QueryBlock = false;
RE.ArenaPrep = {[1] = false, [2] = false, [3] = false, [4] = false, [5] = false};

RE.Tab1LastID = 0;
RE.Tab1TableData = {};
RE.Tab2LastID = 0;
RE.Tab2TableData = {};
RE.Tab3LastID = 0;
RE.Tab3TableData = {};
RE.Tab5LastID = 0;
RE.Tab5TableData = {};
RE.Tab6TableData1 = {};
RE.Tab6TableData2 = {};
RE.Tab6TableData3 = {};
RE.Tab7TableData = {};
RE.ArenaLastID = 0;

RE.Options = {"ShowMinimapButton", "ShowMiniBar", "ShowDetectedBuilds", "ArenaSupport", "RBGSupport", "UNBGSupport", "LDBBGMorph", "LDBCPCap", "LDBHK", "LDBShowPlace", "LDBShowQueues", "LDBShowTotalBG", "LDBShowTotalArena", "OnlyNew", "AllowQuery"}
RE.DeleteID = 0;
RE.MiniBarPluginsCount = 0;
RE.RBGCounter = false;
RE.SlashTrigger = "";
RE.LDBQueue = "";
RE.HonorCap = 4000;
RE.CPCap = 4000;
RE.Faction = UnitFactionGroup("player");
RE.CurrentSeason = GetCurrentArenaSeason(); 
if RE.Faction == "Neutral" then
	RE.FactionNum = -1;
else
	if RE.Faction == "Horde" then
		RE.FactionNum = 0;
	else
		RE.FactionNum = 1;
	end
end

RE.ClassIconCoords = {
	["WARRIOR"] = {0, 0.25, 0, 0.25},
	["MAGE"] = {0.25, 0.49609375, 0, 0.25},
	["ROGUE"] = {0.49609375, 0.7421875, 0, 0.25},
	["DRUID"] = {0.7421875, 0.98828125, 0, 0.25},
	["HUNTER"] = {0, 0.25, 0.25, 0.5},
	["SHAMAN"] = {0.25, 0.49609375, 0.25, 0.5},
	["PRIEST"] = {0.49609375, 0.7421875, 0.25, 0.5},
	["WARLOCK"] = {0.7421875, 0.98828125, 0.25, 0.5},
	["PALADIN"] = {0, 0.25, 0.5, 0.75},
	["DEATHKNIGHT"] = {0.25, 0.49609375, 0.5, 0.75},
	["MONK"] = {0.49609375, 0.7421875, 0.5, 0.75},
};
RE.RaceIconCoords = {
	["HUMAN_MALE"] = {0, 0.125, 0, 0.25},
	["DWARF_MALE"] = {0.125, 0.25, 0, 0.25},
	["GNOME_MALE"] = {0.25, 0.375, 0, 0.25},
	["NIGHT ELF_MALE"] = {0.375, 0.5, 0, 0.25},
	["NIGHTELF_MALE"] = {0.375, 0.5, 0, 0.25},
	["TAUREN_MALE"] = {0, 0.125, 0.25, 0.5},
	["UNDEAD_MALE"] = {0.125, 0.25, 0.25, 0.5},
	["SCOURGE_MALE"] = {0.125, 0.25, 0.25, 0.5},
	["TROLL_MALE"] = {0.25, 0.375, 0.25, 0.5},
	["ORC_MALE"] = {0.375, 0.5, 0.25, 0.5},
	["BLOOD ELF_MALE"] = {0.5, 0.625, 0.25, 0.5},
	["BLOODELF_MALE"] = {0.5, 0.625, 0.25, 0.5},
	["DRAENEI_MALE"] = {0.5, 0.625, 0, 0.25},
	["GOBLIN_MALE"] = {0.625, 0.750, 0.25, 0.5},
	["WORGEN_MALE"] = {0.625, 0.750, 0, 0.25},
	["PANDAREN_MALE"] = {0.750, 0.875, 0, 0.25},
};
RE.ClassColors = {
	["HUNTER"] = "AAD372",
	["WARLOCK"] = "9482C9",
	["PRIEST"] = "FFFFFF",
	["PALADIN"] = "F48CBA",
	["MAGE"] = "68CCEF",
	["ROGUE"] = "FFF468",
	["DRUID"] = "FF7C0A",
	["SHAMAN"] = "0070DD",
	["WARRIOR"] = "C69B6D",
	["DEATHKNIGHT"] = "C41E3A",
	["MONK"] = "00FF96",
};
RE.Spec = {
	["HUNTER"] = {
		[255] = select(2, GetSpecializationInfoByID(255)),
		[254] = select(2, GetSpecializationInfoByID(254)),
		[253] = select(2, GetSpecializationInfoByID(253)),
		[select(2, GetSpecializationInfoByID(255))] = 255,
		[select(2, GetSpecializationInfoByID(254))] = 254,
		[select(2, GetSpecializationInfoByID(253))] = 253,
	},
	["WARRIOR"] = {
		[73] = select(2, GetSpecializationInfoByID(73)),
		[71] = select(2, GetSpecializationInfoByID(71)),
		[72] = select(2, GetSpecializationInfoByID(72)),
		[select(2, GetSpecializationInfoByID(73))] = 73,
		[select(2, GetSpecializationInfoByID(71))] = 71,
		[select(2, GetSpecializationInfoByID(72))] = 72,
	},
	["PALADIN"] = {
		[70] = select(2, GetSpecializationInfoByID(70)),
		[65] = select(2, GetSpecializationInfoByID(65)),
		[66] = select(2, GetSpecializationInfoByID(66)),
		[select(2, GetSpecializationInfoByID(70))] = 70,
		[select(2, GetSpecializationInfoByID(65))] = 65,
		[select(2, GetSpecializationInfoByID(66))] = 66,
	},
	["MAGE"] = {
		[64] = select(2, GetSpecializationInfoByID(64)),
		[63] = select(2, GetSpecializationInfoByID(63)),
		[62] = select(2, GetSpecializationInfoByID(62)),
		[select(2, GetSpecializationInfoByID(64))] = 64,
		[select(2, GetSpecializationInfoByID(63))] = 63,
		[select(2, GetSpecializationInfoByID(62))] = 62,
	},
	["PRIEST"] = {
		[257] = select(2, GetSpecializationInfoByID(257)),
		[258] = select(2, GetSpecializationInfoByID(258)),
		[256] = select(2, GetSpecializationInfoByID(256)),
		[select(2, GetSpecializationInfoByID(257))] = 257,
		[select(2, GetSpecializationInfoByID(258))] = 258,
		[select(2, GetSpecializationInfoByID(256))] = 256,
	},
	["WARLOCK"] = {
		[266] = select(2, GetSpecializationInfoByID(266)),
		[267] = select(2, GetSpecializationInfoByID(267)),
		[265] = select(2, GetSpecializationInfoByID(265)),
		[select(2, GetSpecializationInfoByID(266))] = 266,
		[select(2, GetSpecializationInfoByID(267))] = 267,
		[select(2, GetSpecializationInfoByID(265))] = 265,
	},
	["DEATHKNIGHT"] = {
		[252] = select(2, GetSpecializationInfoByID(252)),
		[251] = select(2, GetSpecializationInfoByID(251)),
		[250] = select(2, GetSpecializationInfoByID(250)),
		[select(2, GetSpecializationInfoByID(252))] = 252,
		[select(2, GetSpecializationInfoByID(251))] = 251,
		[select(2, GetSpecializationInfoByID(250))] = 250,
	},
	["SHAMAN"] = {
		[263] = select(2, GetSpecializationInfoByID(263)),
		[264] = select(2, GetSpecializationInfoByID(264)),
		[262] = select(2, GetSpecializationInfoByID(262)),
		[select(2, GetSpecializationInfoByID(263))] = 263,
		[select(2, GetSpecializationInfoByID(264))] = 264,
		[select(2, GetSpecializationInfoByID(262))] = 262,
	},
	["DRUID"] = {
		[103] = select(2, GetSpecializationInfoByID(103)),
		[104] = select(2, GetSpecializationInfoByID(104)),
		[102] = select(2, GetSpecializationInfoByID(102)),
		[105] = select(2, GetSpecializationInfoByID(105)),
		[select(2, GetSpecializationInfoByID(103))] = 103,
		[select(2, GetSpecializationInfoByID(104))] = 104,
		[select(2, GetSpecializationInfoByID(102))] = 102,
		[select(2, GetSpecializationInfoByID(105))] = 105,
	},
	["MONK"] = {
		[269] = select(2, GetSpecializationInfoByID(269)),
		[270] = select(2, GetSpecializationInfoByID(270)),
		[268] = select(2, GetSpecializationInfoByID(268)),
		[select(2, GetSpecializationInfoByID(269))] = 269,
		[select(2, GetSpecializationInfoByID(270))] = 270,
		[select(2, GetSpecializationInfoByID(268))] = 268,
	},
	["ROGUE"] = {
		[260] = select(2, GetSpecializationInfoByID(260)),
		[261] = select(2, GetSpecializationInfoByID(261)),
		[259] = select(2, GetSpecializationInfoByID(259)),
		[select(2, GetSpecializationInfoByID(260))] = 260,
		[select(2, GetSpecializationInfoByID(261))] = 261,
		[select(2, GetSpecializationInfoByID(259))] = 259,
	}
}
RE.BGSpecialFields = { 
	["AlteracValley"] = {"Interface\\WorldStateFrame\\ColumnIcon-GraveyardCapture" .. RE.FactionNum,
	"Interface\\WorldStateFrame\\ColumnIcon-GraveyardDefend" .. RE.FactionNum,
	"Interface\\WorldStateFrame\\ColumnIcon-TowerCapture" .. RE.FactionNum,
	"Interface\\WorldStateFrame\\ColumnIcon-TowerDefend" .. RE.FactionNum,
	"Interface\\WorldStateFrame\\ColumnIcon-FlagCapture2" .. RE.FactionNum},
	["CTF"] = {"Interface\\WorldStateFrame\\ColumnIcon-FlagCapture" .. RE.FactionNum,
	"Interface\\WorldStateFrame\\ColumnIcon-FlagReturn" .. RE.FactionNum},
	["Other"] = {"Interface\\WorldStateFrame\\ColumnIcon-TowerCapture" .. RE.FactionNum,
	"Interface\\WorldStateFrame\\ColumnIcon-TowerDefend" .. RE.FactionNum},
	["NetherstormArena"] = {"Interface\\WorldStateFrame\\ColumnIcon-FlagCapture" .. RE.FactionNum}
}
RE.TooltipBackdrop = {
    ["bgFile"] = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark";
    ["tileSize"] = 0;
    ["edgeFile"] = "Interface\\DialogFrame\\UI-DialogBox-Border";
    ["edgeSize"] = 16;
    ["insets"] = {
        ["top"] = 3.4999997615814;
        ["right"] = 3.4999997615814;
        ["left"] = 3.4999997615814;
        ["bottom"] = 3.4999997615814;
    };
};

SLASH_REFLEX1, SLASH_REFLEX2 = "/ref", "/reflex";

-- *** Event & initialisation functions

function REFlex_OnLoad(self)
	if select(4, GetBuildInfo()) < 50001 then
		print("\124cFF74D06C[REFlex]\124r This release require 5.x client!");
		return;
	end
	REFlex_LoadLDB();

	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	self:RegisterEvent("ADDON_LOADED");
	self:RegisterEvent("PVP_RATED_STATS_UPDATE");
	self:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS");
	self:RegisterEvent("CHAT_MSG_ADDON");
	self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
	self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	self:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
	self:RegisterEvent("GUILD_ROSTER_UPDATE");
	self:RegisterEvent("PVP_REWARDS_UPDATE");
	
	WorldStateScoreFrame:HookScript("OnShow", REFlex_ArenaEnd);
	WorldStateScoreFrame:HookScript("OnHide", function(self) REFlex_ScoreTab:Hide() end);
	StaticPopup1:HookScript("OnShow", REFlex_EntryPopup);

	RE.SecondTime = false;
	RE.SecondTimeMainTab = false;
	RE.SecondTimeMiniBar = false;
end

function REFlex_OnEvent(self,Event,...)
	local _, REZoneType = IsInInstance();
	if Event == "UPDATE_BATTLEFIELD_SCORE" and REZoneType == "pvp" then
		if RE.BGTimer == nil then
			RE.BGTimer = RE.ShefkiTimer:ScheduleRepeatingTimer(RequestBattlefieldScoreData, 15);
		end
		if GetBattlefieldWinner() ~= nil then
			REFlex_BGEnd();
		end
		if REFSettings["ShowMiniBar"] or REFSettings["LDBBGMorph"] then
			REFlex_UpdateMiniBar();
		end
	elseif Event == "UPDATE_BATTLEFIELD_STATUS" and REFSettings["LDBShowQueues"] and ((REZoneType ~= "pvp" and REZoneType ~= "arena") or REFSettings["LDBBGMorph"] == false) then
		RE.LDBQueue = "";
		for j=1, GetMaxBattlefieldID() do
			REFlex_UpdateLDBQueues(j);
		end
		REFlex_UpdateLDB();
	elseif Event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" and REFSettings["ShowDetectedBuilds"] and REZoneType == "arena" and REFSettings["ArenaSupport"] then
		local numOpps = GetNumArenaOpponentSpecs();
		for i=1, MAX_ARENA_ENEMIES do
			if (i <= numOpps) then
				local enemySpec = GetArenaOpponentSpec(i);
				if not RE.ArenaPrep[i] and enemySpec > 0 then
					RE.ArenaPrep[i] = true;
					local _, spec, _, _, _, _, classToken = GetSpecializationInfoByID(enemySpec);
					UIErrorsFrame:AddMessage("\124cFF" .. RE.ClassColors[classToken] .. LOCALIZED_CLASS_NAMES_MALE[classToken] .. " - " .. spec .. "\124r", 1, 1, 1, 2.0);
					print("\124cFF74D06C[REFlex]\124r \124cFF" .. RE.ClassColors[classToken] .. LOCALIZED_CLASS_NAMES_MALE[classToken] .. " - " .. spec .. "\124r");
				end
			end
		end
	elseif Event == "CURRENCY_DISPLAY_UPDATE" and REZoneType == "none" then
		REFlex_UpdateLDB();
	elseif Event == "CHAT_MSG_ADDON" and ... == "REFlex" then
		local _, REMessage, _, RESender = ...;
		if RE.Debug > 0 then
			print("\124cFF74D06C[REFlex]\124r " .. RESender .. " - " .. REMessage);
		end
		if tonumber(REMessage) ~= nil then
			if tonumber(REMessage) > RE.AddonVersionCheck and RE.FoundNewVersion == false then
				print("\124cFF74D06C[REFlex]\124r " .. L["New version released!"]);
				RE.FoundNewVersion = true;
			end
		else
			if REMessage == "Query" then
				SendAddonMessage("REFlex", REFlex_SendStats(), "WHISPER", RESender);
			else
				local REMessageEx = {strsplit(";", REMessage)};
				if REMessageEx[1] == "Block" then
					print("\124cFF74D06C[REFlex]\124r \124cFF" .. RE.ClassColors[REMessageEx[2]] .. RESender .. "\124r - \124cFFFF0000" .. L["Player disabled data sharing."] .. "\124r");
				else
					print("\124cFF74D06C[REFlex]\124r \124cFF" .. RE.ClassColors[REMessageEx[1]] .. RESender .. "\124r - \124cFFC5F3BCA:\124r \124cFF00FF00" .. REMessageEx[2] .. "\124r - \124cFFFF0000" .. REMessageEx[3] .. "\124r \124cFF555555*\124r \124cFFC5F3BCBG:\124r \124cFF00FF00" .. REMessageEx[4] .. "\124r - \124cFFFF0000" .. REMessageEx[5] .. "\124r")
					print("\124cFF74D06C[REFlex]\124r \124cFF" .. RE.ClassColors[REMessageEx[1]] .. RESender .. "\124r - \124cFFC5F3BCA " .. RATING .. ":\124r " .. REMessageEx[6] .. " (" .. REMessageEx[10] .. ")" .. " / " .. REMessageEx[7] .. " (" .. REMessageEx[11] .. ")" .. " / " .. REMessageEx[8] .. " (" .. REMessageEx[12] .. ")" .. " \124cFF555555*\124r \124cFFC5F3BCBG " .. RATING .. ":\124r " .. REMessageEx[9] .. " (" .. REMessageEx[13] .. ")");
				end
			end
		end
	elseif Event == "GUILD_ROSTER_UPDATE" and RE.InGuild == 1 and RE.GuildRosterUpdate then
		RE.GuildRosterUpdate = false;
		local REGuildNum = GetNumGuildMembers();

		for i=1, REGuildNum do
			local Found = false;
			local REGuildName, _, _, _, _, _, _, _, REOnline = GetGuildRosterInfo(i);
			for j=1, #RE.GuildMembers do
				if RE.GuildMembers[j]["Name"] == REGuildName then
					Found = true;
					RE.GuildMembers[j]["Online"] = REOnline;
					break;
				end
			end

			if not Found then
				table.insert(RE.GuildMembers, {["Name"] = REGuildName, ["Online"] = REOnline});
			end
		end
	elseif Event == "PVP_RATED_STATS_UPDATE" and REZoneType == "none" then
		if RE.RBGCounter then
			RE.RBG = GetPersonalRatedBGInfo();
			REFlex_PVPStatsCompleting();
		end
	elseif Event == "PVP_REWARDS_UPDATE" and REZoneType == "none" then
		if RE.RBGCounter then
			RE.RBGPointsWeek, RE.RBGMaxPointsWeek, _, _, RE.RBGSoftPointsWeek, RE.RBGSoftMaxPointsWeek = GetPVPRewards();
			REFlex_UpdateLDB();
		end
	elseif Event == "ZONE_CHANGED_NEW_AREA" and (REZoneType == "none" or REZoneType == "party" or REZoneType == "raid") then
		RE.ShefkiTimer:CancelTimer(RE.BGTimer, true);
		RE.BGTimer = nil;
		RE.SecondTime = false;
		RE.SecondTimeMiniBar = false;
		RE.MiniBarSecondLineRdy = false;
		RE.ArenaPrep = {[1] = false, [2] = false, [3] = false, [4] = false, [5] = false};
		REFlex_UpdateLDB();
		RE.CurrentSeason = GetCurrentArenaSeason();

		if REFSettings["ShowMiniBar"] and REFlex_MiniBar1 ~= nil then
			REFSettings["MiniBarAnchor"], _, _, REFSettings["MiniBarX"], REFSettings["MiniBarY"] = REFlex_MiniBar1:GetPoint(1);
			REFSettings["MiniBarX"] = REFlex_Round(REFSettings["MiniBarX"], 2);
			REFSettings["MiniBarY"] = REFlex_Round(REFSettings["MiniBarY"], 2);
		end
		if RE.MiniBarPluginsCount > 0 then
			for i=1, RE.MiniBarPluginsCount do
				_G["REFlex_MiniBar" .. i]:Hide();
			end
		end
		if UnitLevel("player") > 9 and PVPHonorFrame.selectedPvpID ~= nil then
			RequestRatedBattlegroundInfo();
		end
		RequestPVPRewards();
	elseif Event == "ACTIVE_TALENT_GROUP_CHANGED" then
		print("\124cFF74D06C[REFlex]\124r " .. L["Reloaded MiniBar settings"]);
		RE.ActiveTalentGroup = GetActiveSpecGroup(false, false);
		if RE.RBGCounter then
			REFlex_SettingsReload();
		end
	elseif Event == "PLAYER_ENTERING_WORLD" then
		REFlex_Frame:UnregisterEvent("PLAYER_ENTERING_WORLD");
		RE.CurrentSeason = GetCurrentArenaSeason();

		REFlex_FindTab7Default();
		RE.InGuild = IsInGuild();
		if RE.InGuild == 1 then
			RE.GuildRosterUpdate = true;
			GuildRoster();
			RE.Tab7GuildOnly = true;
			REFlex_MainTab_Tab7_Trigger:SetText(GUILD);
		end

		REFlex_MainTab_Tab7_SearchBoxDT:SetText(RE.Tab7Default["T"]["d"]);
		REFlex_MainTab_Tab7_SearchBoxMT:SetText(RE.Tab7Default["T"]["m"]);
		REFlex_MainTab_Tab7_SearchBoxYT:SetText(RE.Tab7Default["T"]["y"]);
		REFlex_MainTab_Tab7_SearchBoxDF:SetText(RE.Tab7Default["F"]["d"]);
		REFlex_MainTab_Tab7_SearchBoxMF:SetText(RE.Tab7Default["F"]["m"]);
		REFlex_MainTab_Tab7_SearchBoxYF:SetText(RE.Tab7Default["F"]["y"]);

		RE.ActiveTalentGroup = GetActiveSpecGroup(false, false);
		REFlex_SettingsReload();
		RE.ShefkiTimer:ScheduleTimer(REFlex_PVPUpdateDelay, 10);
	elseif Event == "ADDON_LOADED" and ... == "REFlex" then
		BINDING_HEADER_REFLEXB = "REFlex";
		BINDING_NAME_REFLEXSHOW = L["Show main window"];

		REFlex_ScoreTab_MsgGuild:SetText(GUILD); 
		REFlex_ScoreTab_MsgParty:SetText(PARTY);
		REFlex_MainTab_MsgGuild:SetText(GUILD); 
		REFlex_MainTab_MsgParty:SetText(PARTY);
		REFlex_MainTab_Query:SetText(L["Guild query"]);
		REFlex_MainTab_Tab5_Search:SetText(SEARCH); 
		REFlex_MainTab_Tab5_Clear:SetText(RESET);
		REFlex_MainTab_Tab5_SearchBox:SetText(NAME .. " / " .. TEAM);
		REFlex_MainTab_Tab5_SearchBox:SetAutoFocus(false);
		REFlex_MainTab_Tab5_Search:SetScale(0.85);
		REFlex_MainTab_Tab5_Clear:SetScale(0.85);
		REFlex_MainTab_Tab7_Search:SetText(FILTER); 
		REFlex_MainTab_Tab7_Clear:SetText(RESET);
		REFlex_MainTab_Tab7_Trigger:SetText(ALL);
		REFlex_MainTab_Tab7_Search:SetScale(0.85);
		REFlex_MainTab_Tab7_Clear:SetScale(0.85);
		REFlex_MainTab_Tab7_Trigger:SetScale(0.85);
		REFlex_MainTab_Tab7_SearchBoxDT:SetAutoFocus(false);
		REFlex_MainTab_Tab7_SearchBoxMT:SetAutoFocus(false);
		REFlex_MainTab_Tab7_SearchBoxYT:SetAutoFocus(false);
		REFlex_MainTab_Tab7_SearchBoxDF:SetAutoFocus(false);
		REFlex_MainTab_Tab7_SearchBoxMF:SetAutoFocus(false);
		REFlex_MainTab_Tab7_SearchBoxYF:SetAutoFocus(false);
		
		REFlex_MainTab_Title:SetText("REFlex " .. RE.AddonVersion);
		REFlex_MainTabTab1:SetText(ALL);
		REFlex_MainTabTab2:SetText(PLAYER_DIFFICULTY1);
		REFlex_MainTabTab3:SetText(L["Rated"]);
		REFlex_MainTabTab4:SetText(string.gsub(STATS_LABEL, ":", ""));
		REFlex_MainTabTab5:SetText(ARENA);
		REFlex_MainTabTab6:SetText(string.gsub(STATS_LABEL, ":", ""));
		REFlex_MainTabTab7:SetText(L["Attendance"]);
		
		REFlex_MainTab_SpecHolderTab1:SetText(L["Both Specs"]);
		REFlex_MainTab_SpecHolderTab2:SetText(L["Spec 1"]);
		REFlex_MainTab_SpecHolderTab3:SetText(L["Spec 2"]);
		REFlex_MainTab_Tab6_Table1_Label:SetText(L["Easiest compositions"]);
		REFlex_MainTab_Tab6_Table2_Label:SetText(L["Most common compositions"]);
		REFlex_MainTab_Tab6_Table3_Label:SetText(L["Hardest compositions"])

		REFlex_MainTab_Tab4_ScoreHolderSpecial_CP:SetText("- " .. PVP_CONQUEST .. " -");
		REFlex_MainTab_Tab4_ScoreHolderSpecial_Honor:SetText("- " .. HONOR .. " -");
		REFlex_MainTab_Tab6_ScoreHolderSpecial_CP:SetText("- " .. PVP_CONQUEST .. " -");
		REFlex_MainTab_Tab6_ScoreHolderSpecial_Honor:SetText("- " .. HONOR .. " -");

		CreateFrame("Frame", "REFlex_MainTab_Tab1_ScoreHolder", REFlex_MainTab_Tab1, "REFlex_Tab_ScoreHolder_Virtual");
		CreateFrame("Frame", "REFlex_MainTab_Tab2_ScoreHolder", REFlex_MainTab_Tab2, "REFlex_Tab_ScoreHolder_Virtual");
		CreateFrame("Frame", "REFlex_MainTab_Tab3_ScoreHolder", REFlex_MainTab_Tab3, "REFlex_Tab_ScoreHolder_Virtual");
		CreateFrame("Frame", "REFlex_MainTab_Tab5_ScoreHolder", REFlex_MainTab_Tab5, "REFlex_Tab_ScoreHolder_Virtual");
		CreateFrame("Frame", "REFlex_MainTab_Tab7_ScoreHolder", REFlex_MainTab_Tab7, "REFlex_Tab_ScoreHolder_Virtual");
		
		CreateFrame("Frame", "REFlex_MainTab_Tab4_ScoreHolder1", REFlex_MainTab_Tab4, "REFlex_Tab4_ScoreHolder_Virtual");
		REFlex_MainTab_Tab4_ScoreHolder1:SetPoint("RIGHT", REFlex_MainTab_Tab4_ScoreHolderSpecial, "LEFT", -17, 0);
		CreateFrame("Frame", "REFlex_MainTab_Tab4_ScoreHolder2", REFlex_MainTab_Tab4, "REFlex_Tab4_ScoreHolder_Virtual");
		REFlex_MainTab_Tab4_ScoreHolder2:SetPoint("LEFT", REFlex_MainTab_Tab4_ScoreHolderSpecial, "RIGHT", 17, 0);
		CreateFrame("Frame", "REFlex_MainTab_Tab4_ScoreHolder3", REFlex_MainTab_Tab4, "REFlex_Tab4_ScoreHolder_Virtual");
		REFlex_MainTab_Tab4_ScoreHolder3:SetPoint("TOP", REFlex_MainTab_Tab4_ScoreHolder1, "BOTTOM", 0, -15);
		CreateFrame("Frame", "REFlex_MainTab_Tab4_ScoreHolder4", REFlex_MainTab_Tab4, "REFlex_Tab4_ScoreHolder_Virtual");
		REFlex_MainTab_Tab4_ScoreHolder4:SetPoint("TOPLEFT", REFlex_MainTab_Tab4_ScoreHolderSpecial, "BOTTOMLEFT", 0, -15);
		CreateFrame("Frame", "REFlex_MainTab_Tab4_ScoreHolder5", REFlex_MainTab_Tab4, "REFlex_Tab4_ScoreHolder_Virtual");
		REFlex_MainTab_Tab4_ScoreHolder5:SetPoint("TOPRIGHT", REFlex_MainTab_Tab4_ScoreHolderSpecial, "BOTTOMRIGHT", 0, -15);
		CreateFrame("Frame", "REFlex_MainTab_Tab4_ScoreHolder6", REFlex_MainTab_Tab4, "REFlex_Tab4_ScoreHolder_Virtual");
		REFlex_MainTab_Tab4_ScoreHolder6:SetPoint("TOP", REFlex_MainTab_Tab4_ScoreHolder2, "BOTTOM", 0, -15);
		CreateFrame("Frame", "REFlex_MainTab_Tab4_ScoreHolder7", REFlex_MainTab_Tab4, "REFlex_Tab4_ScoreHolder_Virtual");
		REFlex_MainTab_Tab4_ScoreHolder7:SetPoint("TOP", REFlex_MainTab_Tab4_ScoreHolder3, "BOTTOM", 0, -15);
		CreateFrame("Frame", "REFlex_MainTab_Tab4_ScoreHolder8", REFlex_MainTab_Tab4, "REFlex_Tab4_ScoreHolder_Virtual");
		REFlex_MainTab_Tab4_ScoreHolder8:SetPoint("TOP", REFlex_MainTab_Tab4_ScoreHolder4, "BOTTOM", 0, -15);
		CreateFrame("Frame", "REFlex_MainTab_Tab4_ScoreHolder9", REFlex_MainTab_Tab4, "REFlex_Tab4_ScoreHolder_Virtual");
		REFlex_MainTab_Tab4_ScoreHolder9:SetPoint("TOP", REFlex_MainTab_Tab4_ScoreHolder5, "BOTTOM", 0, -15);
		CreateFrame("Frame", "REFlex_MainTab_Tab4_ScoreHolder10", REFlex_MainTab_Tab4, "REFlex_Tab4_ScoreHolder_Virtual");
		REFlex_MainTab_Tab4_ScoreHolder10:SetPoint("TOP", REFlex_MainTab_Tab4_ScoreHolder6, "BOTTOM", 0, -15);
		
		CreateFrame("Frame", "REFlex_MainTab_Tab6_ScoreHolder1", REFlex_MainTab_Tab6, "REFlex_Tab6_ScoreHolder_Virtual");
		REFlex_MainTab_Tab6_ScoreHolder1:SetPoint("RIGHT", REFlex_MainTab_Tab6_ScoreHolderSpecial, "LEFT", -10, 0);
		CreateFrame("Frame", "REFlex_MainTab_Tab6_ScoreHolder2", REFlex_MainTab_Tab6, "REFlex_Tab6_ScoreHolder_Virtual");
		REFlex_MainTab_Tab6_ScoreHolder2:SetPoint("LEFT", REFlex_MainTab_Tab6_ScoreHolderSpecial, "RIGHT", 10, 0);
		CreateFrame("Frame", "REFlex_MainTab_Tab6_ScoreHolder3", REFlex_MainTab_Tab6, "REFlex_Tab6_ScoreHolder_VirtualB");
		REFlex_MainTab_Tab6_ScoreHolder3:SetPoint("TOPRIGHT", REFlex_MainTab_Tab6_ScoreHolderSpecial, "BOTTOM", -5, -15);
		CreateFrame("Frame", "REFlex_MainTab_Tab6_ScoreHolder4", REFlex_MainTab_Tab6, "REFlex_Tab6_ScoreHolder_VirtualB");
		REFlex_MainTab_Tab6_ScoreHolder4:SetPoint("TOPLEFT", REFlex_MainTab_Tab6_ScoreHolderSpecial, "BOTTOM", 5, -15);
		CreateFrame("Frame", "REFlex_MainTab_Tab6_ScoreHolder5", REFlex_MainTab_Tab6, "REFlex_Tab6_ScoreHolder_VirtualB");
		REFlex_MainTab_Tab6_ScoreHolder5:SetPoint("RIGHT", REFlex_MainTab_Tab6_ScoreHolder3, "LEFT", -10, 0);
		CreateFrame("Frame", "REFlex_MainTab_Tab6_ScoreHolder6", REFlex_MainTab_Tab6, "REFlex_Tab6_ScoreHolder_VirtualB");
		REFlex_MainTab_Tab6_ScoreHolder6:SetPoint("LEFT", REFlex_MainTab_Tab6_ScoreHolder4, "RIGHT", 10, 0);
		
		REFlex_MainTab_Tab4_Bar_I:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
		REFlex_MainTab_Tab4_Bar_I:SetStatusBarColor(0, 0.9, 0);
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_I:SetMinMaxValues(0, RE.CPCap);
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_I:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_I:SetStatusBarColor(0, 0.9, 0);
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarHonor_I:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarHonor_I:SetStatusBarColor(0, 0.9, 0);
		REFlex_MainTab_Tab6_ScoreHolderSpecial_BarCP_I:SetMinMaxValues(0, RE.CPCap);
		REFlex_MainTab_Tab6_ScoreHolderSpecial_BarCP_I:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
		REFlex_MainTab_Tab6_ScoreHolderSpecial_BarCP_I:SetStatusBarColor(0, 0.9, 0);
		REFlex_MainTab_Tab6_ScoreHolderSpecial_BarHonor_I:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
		REFlex_MainTab_Tab6_ScoreHolderSpecial_BarHonor_I:SetStatusBarColor(0, 0.9, 0);

		UIDropDownMenu_Initialize(REFlex_MainTab_Tab4_DropDown, REFlex_DropDownTab4OnLoad);
		UIDropDownMenu_SetWidth(REFlex_MainTab_Tab4_DropDown, 100);
		UIDropDownMenu_SetButtonWidth(REFlex_MainTab_Tab4_DropDown, 124);
		UIDropDownMenu_SetSelectedID(REFlex_MainTab_Tab4_DropDown, 1);
		UIDropDownMenu_JustifyText(REFlex_MainTab_Tab4_DropDown, "LEFT");
		UIDropDownMenu_Initialize(REFlex_MainTab_Tab5_DropDown, REFlex_DropDownTab5OnLoad);
		UIDropDownMenu_SetWidth(REFlex_MainTab_Tab5_DropDown, 100);
		UIDropDownMenu_SetButtonWidth(REFlex_MainTab_Tab5_DropDown, 124);
		UIDropDownMenu_SetSelectedID(REFlex_MainTab_Tab5_DropDown, 1);
		UIDropDownMenu_JustifyText(REFlex_MainTab_Tab5_DropDown, "LEFT");
		UIDropDownMenu_Initialize(REFlex_MainTab_Tab6_DropDown, REFlex_DropDownTab6OnLoad);
		UIDropDownMenu_SetWidth(REFlex_MainTab_Tab6_DropDown, 100);
		UIDropDownMenu_SetButtonWidth(REFlex_MainTab_Tab6_DropDown, 124);
		UIDropDownMenu_SetSelectedID(REFlex_MainTab_Tab6_DropDown, 1);
		UIDropDownMenu_JustifyText(REFlex_MainTab_Tab6_DropDown, "LEFT");

		REFlex_ExportTab_Panel_Text:SetMultiLine(true);
		REFlex_ExportTab_Panel_Text:SetMaxLetters(0);
		REFlex_ExportTab_Panel_Text:EnableMouse(true);
		REFlex_ExportTab_Panel_Text:SetAutoFocus(true);
		REFlex_ExportTab_Panel_Text:SetFontObject(ChatFontNormal);
		REFlex_ExportTab_Panel_Text:SetWidth(444);
		REFlex_ExportTab_Panel_Text:SetHeight(440);
		REFlex_ExportTab_Panel:SetScrollChild(REFlex_ExportTab_Panel_Text);

		StaticPopupDialogs["REFLEX_SHIFTINFO"] = {
			text = L["Hold SHIFT key when browsing arena matches to see extended tooltips."],
			button1 = OKAY,
			OnAccept = function() REFSettings["ArenasListFirstTime"] = false end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = false,
		}
		StaticPopupDialogs["REFLEX_SHIFTINFORBG"] = {
			text = L["Hold SHIFT key when browsing rated battlegrounds to see extended tooltips."],
			button1 = OKAY,
			OnAccept = function() REFSettings["RBGListFirstTime"] = false end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = false,
		}
		StaticPopupDialogs["REFLEX_CONFIRMDELETE"] = {
			text = L["Are you sure you want to delete this entry?"],
			button1 = YES,
			button2 = NO,
			OnAccept = function() REFlex_DeleteEntry(RE.DeleteID) end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}

		--- Settings and database patcher
		if REFDatabase == nil then
			REFDatabase = {};
		end
		if REFDatabaseA == nil then
			REFDatabaseA = {};
		end

		if REFSettings == nil then
			REFSettings = {["Version"] = RE.DataVersion ,["MinimapPos"] = 45, ["ShowDetectedBuilds"] = true, ["ShowMinimapButton"] = true, ["ShowMiniBar"] = false, ["MiniBarX"] = 0, ["MiniBarY"] = 0, ["MiniBarAnchor"] = "CENTER", ["MiniBarScale"] = 1, ["ArenasListFirstTime"] = true, ["RBGListFirstTime"] = true, ["LDBBGMorph"] = true, ["LDBShowPlace"] = false, ["LDBShowQueues"] = true, ["LDBCPCap"] = true, ["LDBHK"] = false, ["LDBShowTotalBG"] = false, ["LDBShowTotalArena"] = false, ["ArenaSupport"] = true, ["RBGSupport"] = true, ["UNBGSupport"] = true, ["LastDay"] = 0, ["CurrentMMR"] = 0, ["CurrentMMRBG"] = 0, ["LastDayStats"] = {["Honor"] = 0, ["CP"] = 0, ["2v2"] = 0, ["3v3"] = 0, ["5v5"] = 0, ["RBG"] = 0, ["MMR"] = 0, ["MMRBG"] = 0}, ["MiniBarOrder"] = {}, ["MiniBarVisible"] = {}, ["OnlyNew"] = false, ["AllowQuery"] = true};
			REFSettings["MiniBarVisible"][1] = {["KillingBlows"] = 1, ["HonorKills"] = 1, ["Damage"] = 2, ["Healing"] = 2, ["Deaths"] = nil, ["KDRatio"] = nil, ["Honor"] = nil};
			REFSettings["MiniBarVisible"][2] = {["KillingBlows"] = 1, ["HonorKills"] = 1, ["Damage"] = 2, ["Healing"] = 2, ["Deaths"] = nil, ["KDRatio"] = nil, ["Honor"] = nil};
			REFSettings["MiniBarOrder"][1] = {"KillingBlows", "HonorKills", "Damage", "Healing", "Deaths", "KDRatio", "Honor"};
			REFSettings["MiniBarOrder"][2] = {"KillingBlows", "HonorKills", "Damage", "Healing", "Deaths", "KDRatio", "Honor"};
		elseif REFSettings["Version"] == RE.DataVersion then
			-- NOTHING :-)
		elseif REFSettings["Version"] == 18 then -- 0.9.8
			REFlex_Update18();
		elseif REFSettings["Version"] == 17 then -- 0.9.7.1	
			REFlex_Update17();	
			REFlex_Update18();
		elseif REFSettings["Version"] == 16 then -- 0.9.6.2
			REFlex_Update16();
			REFlex_Update17();
			REFlex_Update18();
		elseif REFSettings["Version"] == 15 then -- 0.9.6
			REFlex_Update15();
			REFlex_Update16();
			REFlex_Update17();
			REFlex_Update18();
		elseif REFSettings["Version"] == 14 then -- 0.9.5.5
			REFlex_Update14();
			REFlex_Update15();
			REFlex_Update16();
			REFlex_Update17();
			REFlex_Update18();
		elseif REFSettings["Version"] == 13 then -- 0.9.5.3
			REFlex_Update13();
			REFlex_Update14();
			REFlex_Update15();
			REFlex_Update16();
			REFlex_Update17();
			REFlex_Update18();
		elseif REFSettings["Version"] == 11 or REFSettings["Version"] == 12 then -- 0.9.5.1/0.9.5.2
			REFlex_Update1112();	
			REFlex_Update13();
			REFlex_Update14();
			REFlex_Update15();
			REFlex_Update16();
			REFlex_Update17();
			REFlex_Update18();
		elseif REFSettings["Version"] == 10 then -- 0.9.4
			REFlex_Update10();	
			REFlex_Update1112();
			REFlex_Update13();
			REFlex_Update14();
			REFlex_Update15();
			REFlex_Update16();
			REFlex_Update17();
			REFlex_Update18();
		elseif REFSettings["Version"] == 8 or REFSettings["Version"] == 9 then -- 0.9.3.1/0.9.1
			REFlex_Update89();
			REFlex_Update10();
			REFlex_Update1112();
			REFlex_Update13();
			REFlex_Update14();
			REFlex_Update15();
			REFlex_Update16();
			REFlex_Update17();
			REFlex_Update18();
		elseif REFSettings["Version"] == 7 then -- 0.9
			REFlex_Update7();
			REFlex_Update89();
			REFlex_Update10();
			REFlex_Update1112();
			REFlex_Update13();
			REFlex_Update14();
			REFlex_Update15();
			REFlex_Update16();
			REFlex_Update17();
			REFlex_Update18();
		elseif REFSettings["Version"] == 6 then -- 0.8.8
			REFlex_Update6();	
			REFlex_Update7();
			REFlex_Update89();
			REFlex_Update10();
			REFlex_Update1112();
			REFlex_Update13();
			REFlex_Update14();
			REFlex_Update15();
			REFlex_Update16();
			REFlex_Update17();
			REFlex_Update18();
		elseif REFSettings["Version"] ~= RE.DataVersion then -- 0.8.7 and older
			REFlex_UpdateOld();	
			REFlex_Update6();
			REFlex_Update7();
			REFlex_Update89();
			REFlex_Update10();
			REFlex_Update1112();
			REFlex_Update13();
			REFlex_Update14();
			REFlex_Update15();
			REFlex_Update16();
			REFlex_Update17();
			REFlex_Update18();
		end
		REFSettings["Version"] = RE.DataVersion;
		---

		RegisterAddonMessagePrefix("REFlex");
		if IsInGuild() == 1 then
			SendAddonMessage("REFlex", RE.AddonVersionCheck, "GUILD");
		end

		if RE.Debug == 2 then
			RE.CurrentMemoryUsage = 0;
			RE.CurrentMemoryDiff = 0;
			RE.CurrentMemoryStart = 0;
			RE.CurrentMemoryIgnition = 0;

			UpdateAddOnMemoryUsage();
			RE.CurrentMemoryStart = GetAddOnMemoryUsage("REFlex");
			RE.ShefkiTimer:ScheduleRepeatingTimer(REFlex_MemoryDebug, 5);
		end

		self:UnregisterEvent("ADDON_LOADED");
	end
end

-- DropDown Menu subsection
function REFlex_DropDownTab4Click(self)
	UIDropDownMenu_SetSelectedID(REFlex_MainTab_Tab4_DropDown, self:GetID());
	if REFlex_MainTab_Tab4_DropDown["selectedID"] == 3 then
		RE.RatedDrop = true;
		RE.BattlegroundReload = true;
	elseif REFlex_MainTab_Tab4_DropDown["selectedID"] == 2 then
		RE.RatedDrop = false;
		RE.BattlegroundReload = true;
	else
		RE.RatedDrop = nil;
		RE.BattlegroundReload = true;
	end
	REFlex_MainTab_Tab4:Hide();
	REFlex_MainTab_Tab4:Show();
end

function REFlex_DropDownTab4OnLoad(self, level)
	local BGDropMenu = UIDropDownMenu_CreateInfo();
	BGDropMenu.text = ALL;
	BGDropMenu.func = REFlex_DropDownTab4Click
	UIDropDownMenu_AddButton(BGDropMenu, level);
	BGDropMenu = UIDropDownMenu_CreateInfo();
	BGDropMenu.text = L["Unrated BGs"];
	BGDropMenu.func = REFlex_DropDownTab4Click
	UIDropDownMenu_AddButton(BGDropMenu, level);
	BGDropMenu = UIDropDownMenu_CreateInfo();
	BGDropMenu.text = L["Rated BGs"];
	BGDropMenu.func = REFlex_DropDownTab4Click 
	UIDropDownMenu_AddButton(BGDropMenu, level);
end

function REFlex_DropDownTab5Click(self)
	UIDropDownMenu_SetSelectedID(REFlex_MainTab_Tab5_DropDown, self:GetID());
	if REFlex_MainTab_Tab5_DropDown["selectedID"] == 4 then
		RE.BracketDrop = 5;
	elseif REFlex_MainTab_Tab5_DropDown["selectedID"] == 3 then
		RE.BracketDrop = 3;
	elseif REFlex_MainTab_Tab5_DropDown["selectedID"] == 2 then
		RE.BracketDrop = 2;
	else
		RE.BracketDrop = nil;
	end
	REFlex_MainTab_Tab5:Hide();
	REFlex_MainTab_Tab5:Show();
	RE.MainTable5:SetFilter(REFlex_Tab_Tab5Filter);
end

function REFlex_DropDownTab5OnLoad(self, level)
	local BGDropMenu2 = UIDropDownMenu_CreateInfo();
	BGDropMenu2.text       = ALL;
	BGDropMenu2.func       = REFlex_DropDownTab5Click
	UIDropDownMenu_AddButton(BGDropMenu2, level);
	BGDropMenu2 = UIDropDownMenu_CreateInfo();
	BGDropMenu2.text       = "2v2";
	BGDropMenu2.func       = REFlex_DropDownTab5Click
	UIDropDownMenu_AddButton(BGDropMenu2, level);
	BGDropMenu2 = UIDropDownMenu_CreateInfo();
	BGDropMenu2.text       = "3v3";
	BGDropMenu2.func       = REFlex_DropDownTab5Click 
	UIDropDownMenu_AddButton(BGDropMenu2, level);
	BGDropMenu2.text       = "5v5";
	BGDropMenu2.func       = REFlex_DropDownTab5Click 
	UIDropDownMenu_AddButton(BGDropMenu2, level);
end

function REFlex_DropDownTab6Click(self)
	UIDropDownMenu_SetSelectedID(REFlex_MainTab_Tab6_DropDown, self:GetID());
	if REFlex_MainTab_Tab6_DropDown["selectedID"] == 4 then
		RE.BracketDropTab6 = 5;
		RE.ArenaReloadAlpha = true;
	elseif REFlex_MainTab_Tab6_DropDown["selectedID"] == 3 then
		RE.BracketDropTab6 = 3;
		RE.ArenaReloadAlpha = true;
	elseif REFlex_MainTab_Tab6_DropDown["selectedID"] == 2 then
		RE.BracketDropTab6 = 2;
		RE.ArenaReloadAlpha = true;
	else
		RE.BracketDropTab6 = nil;
		RE.ArenaReloadAlpha = true;
	end
	REFlex_MainTab_Tab6:Hide();
	REFlex_MainTab_Tab6:Show();
end

function REFlex_DropDownTab6OnLoad(self, level)
	local BGDropMenu3 = UIDropDownMenu_CreateInfo();
	BGDropMenu3.text       = ALL;
	BGDropMenu3.func       = REFlex_DropDownTab6Click
	UIDropDownMenu_AddButton(BGDropMenu3, level);
	BGDropMenu3 = UIDropDownMenu_CreateInfo();
	BGDropMenu3.text       = "2v2";
	BGDropMenu3.func       = REFlex_DropDownTab6Click
	UIDropDownMenu_AddButton(BGDropMenu3, level);
	BGDropMenu3 = UIDropDownMenu_CreateInfo();
	BGDropMenu3.text       = "3v3";
	BGDropMenu3.func       = REFlex_DropDownTab6Click 
	UIDropDownMenu_AddButton(BGDropMenu3, level);
	BGDropMenu3.text       = "5v5";
	BGDropMenu3.func       = REFlex_DropDownTab6Click 
	UIDropDownMenu_AddButton(BGDropMenu3, level);
end
--

-- GUI subsection
function REFlex_GUIOnLoad(REPanel)
	REPanel.name = "REFlex";
	REPanel.okay = REFlex_GUISave;
	InterfaceOptions_AddCategory(REPanel);

	REFlex_GUI_ShowMinimapButtonText:SetText(L["Show minimap button"]);
	REFlex_GUI_ShowMiniBarText:SetText(L["Show MiniBar (Battlegrounds only)"]);
	REFlex_GUI_OnlyNewText:SetText(L["Use only records from current season to calculate statistics"]);
	REFlex_GUI_AllowQueryText:SetText(L["Allow sending daily statistics to other guild members"]);
	REFlex_GUI_SliderScaleText:SetText(L["MiniBar scale"]);
	REFlex_GUI_LDBBGMorphText:SetText(L["Show LDB MiniBar (Battlegrounds only)"]);
	REFlex_GUI_LDBShowPlaceText:SetText("|cFFFFFFFF" .. L["Show place instead difference of score"]  .. "|r");
	REFlex_GUI_LDBCPCapText:SetText("|cFFFFFFFF[LDB] |r" .. L["Show amount of CPs to cap"]);
	REFlex_GUI_LDBHKText:SetText("|cFFFFFFFF[LDB] |r" .. L["Show Honorable Kills"]);
	REFlex_GUI_LDBShowQueuesText:SetText("|cFFFFFFFF[LDB] |r" .. L["Show queues"]);	
	REFlex_GUI_LDBShowTotalBGText:SetText("|cFFFFFFFF[LDB] |r" .. L["Show Battleground totals"]);
	REFlex_GUI_LDBShowTotalArenaText:SetText("|cFFFFFFFF[LDB] |r" .. L["Show Arena totals"]);
	REFlex_GUI_ArenaSupportText:SetText(L["Arena support"]);
	REFlex_GUI_ShowDetectedBuildsText:SetText("|cFFFFFFFF" .. L["Show detected builds"] .. "|r");
	REFlex_GUI_UNBGSupportText:SetText(L["Unrated battlegrounds support"]);
	REFlex_GUI_RBGSupportText:SetText(L["Rated battlegrounds support"]);
	REFlex_GUI_SliderScaleLow:SetText("0.1");
	REFlex_GUI_SliderScaleHigh:SetText("2.0");

	REFlex_GUI_SliderScale:SetValueStep(0.05);
end

function REFlex_GUIModulesOnLoad(REPanel)
	REPanel.name = L["MiniBar modules"];
	REPanel.parent = "REFlex"
	InterfaceOptions_AddCategory(REPanel);
end

function REFlex_GUIScaleSlider()
	REFlex_GUI_SliderScaleValue:SetText(REFlex_Round(REFlex_GUI_SliderScale:GetValue(),2));

	if REFSettings["ShowMiniBar"] and RE.MiniBarPluginsCount > 0 then
		for i=1, RE.MiniBarPluginsCount do
			_G["REFlex_MiniBar" .. i]:SetScale(REFlex_Round(REFlex_GUI_SliderScale:GetValue(),2));
		end
	end
end

function REFlex_GUIModulesOnShow()
	if REFSettings then
		for j=1, #REFSettings["MiniBarOrder"][RE.ActiveTalentGroup] do
			if j == 1 then
				if _G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]] == nil then
					CreateFrame("Frame", "REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j], REFlex_GUI_Modules, "REFlex_GUI_Modules_Virtual");
				end
				_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]]:ClearAllPoints();
				_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]]:SetPoint("TOPLEFT", REFlex_GUI_Modules, "TOPLEFT", 10 , -35);

			else
				if _G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]] == nil then
					CreateFrame("Frame", "REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j], REFlex_GUI_Modules, "REFlex_GUI_Modules_Virtual");
				end
				_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]]:ClearAllPoints();
				_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]]:SetPoint("TOPLEFT", _G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j-1]], "BOTTOMLEFT", 0 , -47);
			end
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_Bar1Button"]:Enable()
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_Bar2Button"]:Enable()
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_HideButton"]:Enable()
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_LeftButton"]:Enable()
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_RightButton"]:Enable()

			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_Name"]:SetText(RE.ModuleTranslation[REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]]);
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_Bar1ButtonText"]:SetText(L["Bar 1"]);
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_Bar2ButtonText"]:SetText(L["Bar 2"]);
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_HideButtonText"]:SetText(HIDE);
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_LeftButtonText"]:SetText(L["Left"]);
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_RightButtonText"]:SetText(L["Right"]);

			if j == 1 then
				_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_LeftButton"]:Disable()
			elseif j == #REFSettings["MiniBarOrder"][RE.ActiveTalentGroup] then
				_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_RightButton"]:Disable()
			end

			if REFSettings["MiniBarVisible"][RE.ActiveTalentGroup][REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]] == 1 then
				_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_Bar1Button"]:Disable()
			elseif REFSettings["MiniBarVisible"][RE.ActiveTalentGroup][REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]] == 2 then
				_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_Bar2Button"]:Disable()
			else
				_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_HideButton"]:Disable()
			end

			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_Bar1Button"]:SetScript("OnClick", function() REFlex_GUI_ModuleChangeBar(REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j], 1, REFSettings["MiniBarVisible"][RE.ActiveTalentGroup][REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]]) end);
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_Bar2Button"]:SetScript("OnClick", function() REFlex_GUI_ModuleChangeBar(REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j], 2, REFSettings["MiniBarVisible"][RE.ActiveTalentGroup][REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]]) end);
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_HideButton"]:SetScript("OnClick", function() REFlex_GUI_ModuleChangeBar(REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j], nil, REFSettings["MiniBarVisible"][RE.ActiveTalentGroup][REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]]) end);
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_LeftButton"]:SetScript("OnClick", function() REFlex_GUI_ModuleChangeBarOrder(REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j], j, j-1) end);
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] .. "_RightButton"]:SetScript("OnClick", function() REFlex_GUI_ModuleChangeBarOrder(REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j], j, j+1) end);
		end
	end
end
--

-- Minimap subsection
function REFlex_MinimapButtonDrag()
	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

	xpos = xmin-xpos/UIParent:GetScale()+70
	ypos = ypos/UIParent:GetScale()-ymin-70

	REFSettings["MinimapPos"] = math.deg(math.atan2(ypos,xpos))
	REFlex_MinimapButtonReposition()
end

function REFlex_MinimapButtonClick(Button)
	if Button == "LeftButton" or Button == nil then
		local Visible = REFlex_MainTab:IsVisible();

		if Visible ~= 1 then
			REFlex_MainTab:Show();
		else
			REFlex_MainTab:Hide();
		end
	elseif Button == "RightButton" then
		InterfaceOptionsFrame_OpenToCategory("REFlex") 	
	end
end
--

-- Slash subsection
function SlashCmdList.REFLEX(RECommand)
 	local RECom, REArgs = RECommand:match("^(%S*)%s*(.-)$");
	if RECom == "RBGWipe" then
		RESlashBGWipe(true, "Rated");
	elseif RECom == "UNRBGWipe" then
		RESlashBGWipe(false, "Unrated");
	elseif RECom == "2v2Wipe" then
		RESlashArenaWipe(2);
	elseif RECom == "3v3Wipe" then
		RESlashArenaWipe(3);
	elseif RECom == "5v5Wipe" then
		RESlashArenaWipe(5);
	elseif RECom == "OldSeasonWipe" then
		RESlashArenaSeasonWipe(RE.CurrentSeason);
	elseif RECom == "FullWipe" then
		if RE.SlashTrigger == "FullWipe" then
			REFDatabase = {};
			REFDatabaseA = {};
			ReloadUI();
		else
			RE.SlashTrigger = "FullWipe";
			print("\124cFF74D06C[REFlex]\124r " .. L["Issue command second time to confirm database wipe."]);
		end
	elseif RECom == "Query" then
		REFlex_SendQuery(REArgs);
	else
		REFlex_MinimapButtonClick();
	end
end

function RESlashBGWipe(IsRated, IsRatedString)
	if RE.SlashTrigger == "BGWipe" .. IsRatedString then	
		local REToWipe = {};
		for j=1, #REFDatabase do
			if REFDatabase[j]["IsRated"] == IsRated then
				table.insert(REToWipe, j);
			end
		end
		local REWipeCounter = 0;
		table.sort(REToWipe);
		for j=1, #REToWipe do
			local REWipeID = REToWipe[j] - REWipeCounter;
			table.remove(REFDatabase,REWipeID);
			REWipeCounter = REWipeCounter + 1;
		end
		ReloadUI();
	else
		RE.SlashTrigger = "BGWipe" .. IsRatedString;
		print("\124cFF74D06C[REFlex]\124r " .. L["Issue command second time to confirm database wipe."]);
	end
end

function RESlashArenaWipe(Bracket)
	if RE.SlashTrigger == "ArenaWipe" .. Bracket then
		local REToWipe = {};
		for j=1, #REFDatabaseA do
			if REFDatabaseA[j]["Bracket"] == Bracket then
				table.insert(REToWipe, j);
			end
		end
		local REWipeCounter = 0;
		table.sort(REToWipe);
		for j=1, #REToWipe do
			local REWipeID = REToWipe[j] - REWipeCounter;
			table.remove(REFDatabaseA,REWipeID);
			REWipeCounter = REWipeCounter + 1;
		end
		ReloadUI();
	else
		RE.SlashTrigger = "ArenaWipe" .. Bracket;
		print("\124cFF74D06C[REFlex]\124r " .. L["Issue command second time to confirm database wipe."]);
	end
end

function RESlashArenaSeasonWipe(Season)
	local REToWipe = {};
	if RE.SlashTrigger == "ArenaSeasonWipe" .. Season then	
		for j=1, #REFDatabaseA do
			if REFDatabaseA[j]["Season"] ~= Season then
				table.insert(REToWipe, j);
			end
		end
		local REWipeCounter = 0;
		table.sort(REToWipe);
		for j=1, #REToWipe do
			local REWipeID = REToWipe[j] - REWipeCounter;
			table.remove(REFDatabaseA,REWipeID);
			REWipeCounter = REWipeCounter + 1;
		end

		REToWipe = {};
		for j=1, #REFDatabase do
			if REFDatabase[j]["Season"] ~= Season and REFDatabase[j]["IsRated"] == true then
				table.insert(REToWipe, j);
			end
		end
		REWipeCounter = 0;
		table.sort(REToWipe);
		for j=1, #REToWipe do
			local REWipeID = REToWipe[j] - REWipeCounter;
			table.remove(REFDatabase,REWipeID);
			REWipeCounter = REWipeCounter + 1;
		end
		ReloadUI();
	else
		RE.SlashTrigger = "ArenaSeasonWipe" .. Season;
		print("\124cFF74D06C[REFlex]\124r " .. L["Issue command second time to confirm database wipe."]);
	end
end
--

-- Tabs subsection
function REFlex_SpecTabClick(Spec)
	RE.TalentTab = Spec;
	RE.BattlegroundReload = true;
	RE.ArenaReloadAlpha = true;

	local Visible1 = REFlex_MainTab_Tab1:IsVisible();
	local Visible2 = REFlex_MainTab_Tab2:IsVisible();
	local Visible3 = REFlex_MainTab_Tab3:IsVisible();
	local Visible4 = REFlex_MainTab_Tab4:IsVisible();
	local Visible5 = REFlex_MainTab_Tab5:IsVisible();
	local Visible6 = REFlex_MainTab_Tab6:IsVisible();

	if Visible1 == 1 then
		REFlex_MainTab_Tab1:Hide();
		REFlex_MainTab_Tab1:Show();
	elseif Visible2 == 1 then
		REFlex_MainTab_Tab2:Hide();
		REFlex_MainTab_Tab2:Show();
	elseif Visible3 == 1 then
		REFlex_MainTab_Tab3:Hide();
		REFlex_MainTab_Tab3:Show();
	elseif Visible4 == 1 then
		REFlex_MainTab_Tab4:Hide();
		REFlex_MainTab_Tab4:Show();
	elseif Visible5 == 1 then
		REFlex_MainTab_Tab5:Hide();
		REFlex_MainTab_Tab5:Show();
	elseif Visible6 == 1 then
		REFlex_MainTab_Tab6:Hide();
		REFlex_MainTab_Tab6:Show();
	end

	if RE.MainTable1 ~= nil then
		RE.MainTable1:SetFilter(REFlex_Tab_DefaultFilter);
	end
	if RE.MainTable2 ~= nil then
		RE.MainTable2:SetFilter(REFlex_Tab_DefaultFilter);
	end
	if RE.MainTable3 ~= nil then
		RE.MainTable3:SetFilter(REFlex_Tab_DefaultFilter);
	end
	if RE.MainTable5 ~= nil then
		RE.MainTable5:SetFilter(REFlex_Tab_Tab5Filter);
	end
end

function REFlex_SetTabs()
	REFlex_MainTabTab1:Show();
	REFlex_MainTabTab2:Show();
	REFlex_MainTabTab3:Show();
	REFlex_MainTabTab4:Show();
	REFlex_MainTabTab5:Show();
	REFlex_MainTabTab6:Show();
	REFlex_MainTabTab7:Show();

	if REFSettings["UNBGSupport"] then
		if REFSettings["RBGSupport"] then
			REFlex_MainTabTab1:SetPoint("CENTER", "REFlex_MainTab", "BOTTOMLEFT", 35, -10);
			REFlex_MainTabTab2:SetPoint("LEFT", "REFlex_MainTabTab1", "RIGHT", -16, 0);
			REFlex_MainTabTab3:SetPoint("LEFT", "REFlex_MainTabTab2", "RIGHT", -16, 0);
			REFlex_MainTabTab7:SetPoint("LEFT", "REFlex_MainTabTab3", "RIGHT", -16, 0);
			REFlex_MainTabTab4:SetPoint("LEFT", "REFlex_MainTabTab7", "RIGHT", -16, 0);
			if REFSettings["ArenaSupport"] then
				REFlex_MainTabTab5:SetPoint("LEFT", "REFlex_MainTabTab4", "RIGHT", -6, 0);
				REFlex_MainTabTab6:SetPoint("LEFT", "REFlex_MainTabTab5", "RIGHT", -16, 0);
			else	
				REFlex_MainTabTab5:Hide();
				REFlex_MainTabTab6:Hide();
			end
		else
			REFlex_MainTabTab2:SetPoint("CENTER", "REFlex_MainTab", "BOTTOMLEFT", 35, -10);
			REFlex_MainTabTab4:SetPoint("LEFT", "REFlex_MainTabTab2", "RIGHT", -16, 0);
			REFlex_MainTabTab1:Hide();
			REFlex_MainTabTab3:Hide();
			REFlex_MainTabTab7:Hide();
			if REFSettings["ArenaSupport"] then
				REFlex_MainTabTab5:SetPoint("LEFT", "REFlex_MainTabTab4", "RIGHT", -6, 0);
				REFlex_MainTabTab6:SetPoint("LEFT", "REFlex_MainTabTab5", "RIGHT", -16, 0);
			else
				REFlex_MainTabTab5:Hide();
				REFlex_MainTabTab6:Hide();
			end
		end
	else
		REFlex_MainTabTab1:Hide();
		REFlex_MainTabTab2:Hide();
		if REFSettings["RBGSupport"] then
			REFlex_MainTabTab3:SetPoint("CENTER", "REFlex_MainTab", "BOTTOMLEFT", 35, -10);
			REFlex_MainTabTab7:SetPoint("LEFT", "REFlex_MainTabTab3", "RIGHT", -16, 0);
			REFlex_MainTabTab4:SetPoint("LEFT", "REFlex_MainTabTab7", "RIGHT", -16, 0);
			if REFSettings["ArenaSupport"] then
				REFlex_MainTabTab5:SetPoint("LEFT", "REFlex_MainTabTab4", "RIGHT", -6, 0);
				REFlex_MainTabTab6:SetPoint("LEFT", "REFlex_MainTabTab5", "RIGHT", -16, 0);
			else
				REFlex_MainTabTab5:Hide();
				REFlex_MainTabTab6:Hide();
			end
		else
			REFlex_MainTabTab3:Hide();
			REFlex_MainTabTab7:Hide();
			REFlex_MainTabTab4:Hide();
			if REFSettings["ArenaSupport"] then
				REFlex_MainTabTab5:SetPoint("CENTER", "REFlex_MainTab", "BOTTOMLEFT", 35, -10);
				REFlex_MainTabTab6:SetPoint("LEFT", "REFlex_MainTabTab5", "RIGHT", -16, 0);
			else
				REFlex_MainTabTab5:Hide();
				REFlex_MainTabTab6:Hide();
			end
		end
	end
end
--

-- ***

-- *** Main functions

-- Button subsection
function REFlex_ScoreOnClick(Channel)
	local REBGRated = IsRatedBattleground();
	if REBGRated then
		SendChatMessage("[REFlex] - " .. RE.Map .. " - " .. WIN .. ": " .. REWinSide .. " - " .. REFlex_DurationShort(RE.BGTimeRaw) .. " - " .. RATING .. ": " .. RE.BGRatingChange, Channel ,nil ,nil);
		SendChatMessage("<KB> " .. RE.killingBlows .. " (" .. RE.PlaceKB .. "/" .. RE.BGPlayers .. ") - <HK> " .. RE.honorKills .. " (" .. RE.PlaceHK .. "/" .. RE.BGPlayers .. ")", Channel ,nil ,nil);
		SendChatMessage("<" .. DAMAGE .. "> " .. REFlex_NumberClean(RE.damageDone) .. " (" .. RE.PlaceDamage .. "/" .. RE.BGPlayers .. ") - <" .. SHOW_COMBAT_HEALING .. "> " .. REFlex_NumberClean(RE.healingDone) .. " (" .. RE.PlaceHealing .. "/" .. RE.BGPlayers .. ")", Channel ,nil ,nil);
	else
		SendChatMessage("[REFlex] - " .. RE.Map .. " - " .. WIN .. ": " .. REWinSide .. " - " .. REFlex_DurationShort(RE.BGTimeRaw),Channel ,nil ,nil);
		SendChatMessage("<KB> " .. RE.killingBlows .. " (" .. RE.PlaceKB .. "/" .. RE.BGPlayers .. ") - <HK> " .. RE.honorKills .. " (" .. RE.PlaceHK .. "/" .. RE.BGPlayers .. ") - <H> " .. RE.honorGained .. " (" .. RE.PlaceHonor .. "/" .. RE.BGPlayers .. ")", Channel ,nil ,nil);
		SendChatMessage("<" .. DAMAGE .. "> " .. REFlex_NumberClean(RE.damageDone) .. " (" .. RE.PlaceDamage .. "/" .. RE.BGPlayers .. ") - <" .. SHOW_COMBAT_HEALING .. "> " .. REFlex_NumberClean(RE.healingDone) .. " (" .. RE.PlaceHealing .. "/" .. RE.BGPlayers .. ")", Channel ,nil ,nil);
	end
end

function REFlex_MainOnClick(Channel)
	local IsArena = REFlex_MainTab_Tab5:IsVisible();
	if IsArena == 1 then
		local REAddidional = "";
		if RE.BracketDrop == 2 then
			REAddidional = " - 2v2";
		elseif RE.BracketDrop == 3 then
			REAddidional = " - 3v3";
		elseif RE.BracketDrop == 5 then
			REAddidional = " - 5v5"
		else
			REAddidional = " - " .. ALL;	
		end
		SendChatMessage("[REFlex] " .. WINS .. ": " .. RE.Wins .. " - " .. LOSSES .. ": " .. RE.Losses .. REAddidional,Channel ,nil ,nil);
		SendChatMessage("<" .. DAMAGE .. "> " .. L["Total"] .. ": " .. REFlex_NumberClean(RE.SumDamage) .. " - " .. L["Top"] .. ": " .. REFlex_NumberClean(RE.TopDamage), Channel ,nil ,nil);
		SendChatMessage("<" .. SHOW_COMBAT_HEALING .. "> " .. L["Total"] .. ": " .. REFlex_NumberClean(RE.SumHealing) .. " - " .. L["Top"] .. ": " .. REFlex_NumberClean(RE.TopHealing), Channel ,nil ,nil);
	else
		local REAddidional = "";
		if PanelTemplates_GetSelectedTab(REFlex_MainTab) == 3 then
			REAddidional = " - " .. L["Rated BGs"];
		elseif PanelTemplates_GetSelectedTab(REFlex_MainTab) == 2 then
			REAddidional = " - " .. L["Unrated BGs"];	
		end
		SendChatMessage("[REFlex] " .. WINS .. ": " .. RE.Wins .. " - " .. LOSSES .. ": " .. RE.Losses .. REAddidional,Channel ,nil ,nil);
		if PanelTemplates_GetSelectedTab(REFlex_MainTab) == 3 then
			SendChatMessage("<KB> " .. L["Total"] .. ": " .. RE.SumKB .. " - " .. L["Top"] .. ": " .. RE.TopKB, Channel ,nil ,nil);
		else
			SendChatMessage("<KB> " .. L["Total"] .. ": " .. RE.SumKB .. " - " .. L["Top"] .. ": " .. RE.TopKB .. " <HK> " .. L["Total"] .. ": " .. RE.SumHK .. " - " .. L["Top"] .. ": " .. RE.TopHK, Channel ,nil ,nil);
		end
		SendChatMessage("<" .. DAMAGE .. "> " .. L["Total"] .. ": " .. REFlex_NumberClean(RE.SumDamage) .. " - " .. L["Top"] .. ": " .. REFlex_NumberClean(RE.TopDamage), Channel ,nil ,nil);
		SendChatMessage("<" .. SHOW_COMBAT_HEALING .. "> " .. L["Total"] .. ": " .. REFlex_NumberClean(RE.SumHealing) .. " - " .. L["Top"] .. ": " .. REFlex_NumberClean(RE.TopHealing), Channel ,nil ,nil);
	end
end

function REFlex_SearchOnClick()
	RE.NameSearch = REFlex_MainTab_Tab5_SearchBox:GetText();
	REFlex_MainTab_Tab5_SearchBox:ClearFocus();
	RE.MainTable5:SetFilter(REFlex_Tab_NameFilter);
end

function REFlex_ClearOnClick()
	REFlex_MainTab_Tab5_SearchBox:SetText(NAME .. " / " .. TEAM);
	REFlex_MainTab_Tab5_SearchBox:ClearFocus();
	RE.MainTable5:SetFilter(REFlex_Tab_Tab5Filter);
	RE.NameSearch = nil;
end

function REFlex_Tab7SearchOnClick()
	if tonumber(REFlex_MainTab_Tab7_SearchBoxDT:GetText()) ~= nil and tonumber(REFlex_MainTab_Tab7_SearchBoxMT:GetText()) ~= nil and tonumber(REFlex_MainTab_Tab7_SearchBoxYT:GetText()) ~= nil and tonumber(REFlex_MainTab_Tab7_SearchBoxDF:GetText()) ~= nil and tonumber(REFlex_MainTab_Tab7_SearchBoxMF:GetText()) ~= nil and tonumber(REFlex_MainTab_Tab7_SearchBoxYF:GetText()) ~= nil then
		RE.Tab7Search["T"]["d"] = tonumber(REFlex_MainTab_Tab7_SearchBoxDT:GetText());
		RE.Tab7Search["T"]["m"] = tonumber(REFlex_MainTab_Tab7_SearchBoxMT:GetText());
		RE.Tab7Search["T"]["y"] = tonumber(REFlex_MainTab_Tab7_SearchBoxYT:GetText());
		RE.Tab7Search["F"]["d"] = tonumber(REFlex_MainTab_Tab7_SearchBoxDF:GetText());
		RE.Tab7Search["F"]["m"] = tonumber(REFlex_MainTab_Tab7_SearchBoxMF:GetText());
		RE.Tab7Search["F"]["y"] = tonumber(REFlex_MainTab_Tab7_SearchBoxYF:GetText());

		RE.Wins, RE.Losses = REFlex_WinLoss(true, RE.TalentTab, nil, time({["year"] = RE.Tab7Search["F"]["y"], ["month"] = RE.Tab7Search["F"]["m"], ["day"] = RE.Tab7Search["F"]["d"]}), time({["year"] = RE.Tab7Search["T"]["y"], ["month"] = RE.Tab7Search["T"]["m"], ["day"] = RE.Tab7Search["T"]["d"], ["hour"] = 23, ["min"] = 59, ["sec"] = 59}), REFSettings["OnlyNew"]); 
		REFlex_MainTab_Tab7_ScoreHolder_Wins:SetText(RE.Wins);
		REFlex_MainTab_Tab7_ScoreHolder_Lose:SetText(RE.Losses);

		RE.Table9Rdy = nil;
		REFlex_MainTab_Tab7:Hide();
		REFlex_MainTab_Tab7:Show();
	end
end

function REFlex_Tab7ClearOnClick()
	REFlex_FindTab7Default();

	REFlex_MainTab_Tab7_SearchBoxDT:SetText(RE.Tab7Default["T"]["d"]);
	REFlex_MainTab_Tab7_SearchBoxMT:SetText(RE.Tab7Default["T"]["m"]);
	REFlex_MainTab_Tab7_SearchBoxYT:SetText(RE.Tab7Default["T"]["y"]);
	REFlex_MainTab_Tab7_SearchBoxDF:SetText(RE.Tab7Default["F"]["d"]);
	REFlex_MainTab_Tab7_SearchBoxMF:SetText(RE.Tab7Default["F"]["m"]);
	REFlex_MainTab_Tab7_SearchBoxYF:SetText(RE.Tab7Default["F"]["y"]);

	RE.Table9Rdy = nil;
	REFlex_MainTab_Tab7:Hide();
	REFlex_MainTab_Tab7:Show();
end

function REFlex_Tab7TriggerOnClick()
	if RE.Tab7GuildOnly then
		RE.Tab7GuildOnly = false;
		REFlex_MainTab_Tab7_Trigger:SetText(ALL);
		REFlex_MainTab_Tab7:Hide();
		REFlex_MainTab_Tab7:Show();
		RE.MainTable9:SetFilter(REFlex_Tab_Tab7Filter);
	else
		RE.Tab7GuildOnly = true;
		REFlex_MainTab_Tab7_Trigger:SetText(GUILD);
		REFlex_MainTab_Tab7:Hide();
		REFlex_MainTab_Tab7:Show();
		RE.MainTable9:SetFilter(REFlex_Tab_Tab7Filter);
	end
end
--

-- Tabs subsection
function REFlex_ExportTabShow()
	local Visible1 = REFlex_MainTab_Tab1:IsVisible();
	local Visible2 = REFlex_MainTab_Tab2:IsVisible();
	local Visible3 = REFlex_MainTab_Tab3:IsVisible();
	local Visible5 = REFlex_MainTab_Tab5:IsVisible();
	local REDataType, REBracket, RERated;
	local REExport = "";
	local RESpec = RE.TalentTab;

	if Visible1 == 1 then
		REDataType = "Battleground";
		RERated = nil; 
	elseif Visible2 == 1 then
		REDataType = "Battleground";
		RERated = false; 
	elseif Visible3 == 1 then
		REDataType = "Battleground";
		RERated = true; 
	elseif Visible5 == 1 then
		REDataType = "Arena";
		REBracket = RE.BracketDrop;
	end
	REFlex_MainTab:Hide();

	if REDataType == "Battleground" then
		if RERated == nil then
			REExport = "Time;Date;TimeHour;TimeMinutes;DateDay;DateMonth;DateYear;Map;DurationMinutes;DurationSeconds;Winner;KillingBlows;HonorableKills;Damage;Healing;Honor;PlaceKillingBlows;PlaceHonorableKills;PlaceDamage;PlaceHealing;PlaceHonor;FactionPlaceKillingBlows;FactionPlaceHonorableKills;FactionPlaceDamage;FactionPlaceHealing;FactionPlaceHonor;TowersCaptured;TowersDefended;FlagsCaptured;FlagsReturned;GraveyardsCaptured;GraveyardsDefended;TalentSet;PlayersNumber;AlliancePlayers;HordePlayers;IsRated;RatingChange;AllianceRating;HordeRating;HordeAverageMMR;AllianceAverageMMR;MMR;MMRChange\n";
		elseif RERated == false then
			REExport = "Time;Date;TimeHour;TimeMinutes;DateDay;DateMonth;DateYear;Map;DurationMinutes;DurationSeconds;Winner;KillingBlows;HonorableKills;Damage;Healing;Honor;PlaceKillingBlows;PlaceHonorableKills;PlaceDamage;PlaceHealing;PlaceHonor;FactionPlaceKillingBlows;FactionPlaceHonorableKills;FactionPlaceDamage;FactionPlaceHealing;FactionPlaceHonor;TowersCaptured;TowersDefended;FlagsCaptured;FlagsReturned;GraveyardsCaptured;GraveyardsDefended;TalentSet;PlayersNumber;AlliancePlayers;HordePlayers\n";
		elseif RERated == true then
			REExport = "Time;Date;TimeHour;TimeMinutes;DateDay;DateMonth;DateYear;Map;DurationMinutes;DurationSeconds;Winner;KillingBlows;HonorableKills;Damage;Healing;Honor;PlaceKillingBlows;PlaceHonorableKills;PlaceDamage;PlaceHealing;PlaceHonor;FactionPlaceKillingBlows;FactionPlaceHonorableKills;FactionPlaceDamage;FactionPlaceHealing;FactionPlaceHonor;TowersCaptured;TowersDefended;FlagsCaptured;FlagsReturned;GraveyardsCaptured;GraveyardsDefended;TalentSet;PlayersNumber;AlliancePlayers;HordePlayers;RatingChange;AllianceRating;HordeRating;HordeAverageMMR;AllianceAverageMMR;MMR;MMRChange\n";
		end

		local RELine = "";
		for i=1, #REFDatabase do
			if RERated == nil then
				if (REFDatabase[i]["TalentSet"] == RESpec and RESpec ~= nil) or RESpec == nil then
					RELine =  "\"" .. date("%H", REFDatabase[i]["TimeRaw"]) .. ":" .. date("%M", REFDatabase[i]["TimeRaw"]) .. "\";\"" .. date("%d", REFDatabase[i]["TimeRaw"]) .. "." .. date("%m", REFDatabase[i]["TimeRaw"]) .. "." .. date("%Y", REFDatabase[i]["TimeRaw"]) .. "\";" .. tonumber(date("%H", REFDatabase[i]["TimeRaw"])) .. ";" .. tonumber(date("%M", REFDatabase[i]["TimeRaw"])) .. ";" .. tonumber(date("%d", REFDatabase[i]["TimeRaw"])) .. ";" .. tonumber(date("%m", REFDatabase[i]["TimeRaw"])) .. ";" .. tonumber(date("%Y", REFDatabase[i]["TimeRaw"])) .. ";\"" .. REFDatabase[i]["MapName"] .. "\";" .. tonumber(REFlex_DurationShort(REFDatabase[i]["DurationRaw"], "M")) .. ";" .. tonumber(REFlex_DurationShort(REFDatabase[i]["DurationRaw"], "S")) .. ";\"" .. REFDatabase[i]["Winner"] .. "\";" .. REFDatabase[i]["KB"] .. ";" .. REFDatabase[i]["HK"] .. ";" .. REFDatabase[i]["Damage"] .. ";" .. REFDatabase[i]["Healing"] .. ";" .. REFDatabase[i]["Honor"] .. ";" .. REFDatabase[i]["PlaceKB"] .. ";" .. REFDatabase[i]["PlaceHK"] .. ";" .. REFDatabase[i]["PlaceDamage"] .. ";" .. REFDatabase[i]["PlaceHealing"] .. ";" .. REFDatabase[i]["PlaceHonor"] .. ";" .. REFDatabase[i]["PlaceFactionKB"] .. ";" .. REFDatabase[i]["PlaceFactionHK"] .. ";" .. REFDatabase[i]["PlaceFactionDamage"] .. ";" .. REFDatabase[i]["PlaceFactionHealing"] .. ";" .. REFDatabase[i]["PlaceFactionHonor"] .. ";";
					if REFDatabase[i]["MapInfo"] == "AlteracValley" then
						RELine = RELine .. REFDatabase[i]["SpecialFields"][3] .. ";" .. REFDatabase[i]["SpecialFields"][4] .. ";0;0;" .. REFDatabase[i]["SpecialFields"][1] .. ";" .. REFDatabase[i]["SpecialFields"][2] .. ";";
					elseif REFDatabase[i]["MapInfo"] == "WarsongGulch" or REFDatabase[i]["MapInfo"] == "TwinPeaks" then
						RELine = RELine .. "0;0;" .. REFDatabase[i]["SpecialFields"][1] .. ";" .. REFDatabase[i]["SpecialFields"][2] .. ";0;0;";
					elseif REFDatabase[i]["MapInfo"] == "GilneasBattleground2" or REFDatabase[i]["MapInfo"] == "IsleofConquest" or REFDatabase[i]["MapInfo"] == "ArathiBasin" or REFDatabase[i]["MapInfo"] == "StrandoftheAncients" then
						RELine = RELine .. REFDatabase[i]["SpecialFields"][1] .. ";" .. REFDatabase[i]["SpecialFields"][2] .. ";0;0;0;0;";
					elseif REFDatabase[i]["MapInfo"] == "NetherstormArena" then
						RELine = RELine .. "0;0;" .. REFDatabase[i]["SpecialFields"][1] .. ";0;0;0;";
					else
						RELine = RELine .. "0;0;0;0;0;0;";
					end
					local RERatingChange, REAllianceRating, REHordeRating, REHordeAverageMMR, REAllianceAverageMMR, REMMR, REMMRChange;
					if REFDatabase[i]["RatingChange"] == nil then
						RERatingChange = 0;
					else
						RERatingChange = REFDatabase[i]["RatingChange"];
					end
					if REFDatabase[i]["AllianceRating"] == nil then
						REAllianceRating = 0;
					else
						REAllianceRating = REFDatabase[i]["AllianceRating"];
					end
					if REFDatabase[i]["HordeRating"] == nil then
						REHordeRating = 0;
					else
						REHordeRating = REFDatabase[i]["HordeRating"];
					end
					if REFDatabase[i]["HordeMMR"] == nil then
						REHordeAverageMMR = 0;
					else
						REHordeAverageMMR = REFDatabase[i]["HordeMMR"];
					end
					if REFDatabase[i]["AllianceMMR"] == nil then
						REAllianceAverageMMR = 0;
					else
						REAllianceAverageMMR = REFDatabase[i]["AllianceMMR"];
					end
					if REFDatabase[i]["PreMMR"] == nil then
						REMMR = 0;
					else
						REMMR = REFDatabase[i]["PreMMR"];
					end
					if REFDatabase[i]["MMRChange"] == nil then
						REMMRChange = 0;
					else
						REMMRChange = REFDatabase[i]["MMRChange"];
					end
					RELine = RELine .. REFDatabase[i]["TalentSet"] .. ";" .. tonumber( REFDatabase[i]["AllianceNum"])+tonumber(REFDatabase[i]["HordeNum"]) .. ";" .. REFDatabase[i]["AllianceNum"] .. ";" .. REFDatabase[i]["HordeNum"] .. ";\"" .. tostring(REFDatabase[i]["IsRated"]) .. "\";\"" .. RERatingChange .. "\";" .. REAllianceRating .. ";" .. REHordeRating .. ";" .. REHordeAverageMMR .. ";" .. REAllianceAverageMMR .. ";" .. REMMR .. ";" .. REMMRChange;
					REExport = REExport .. RELine .. "\n";
					RELine = "";
				end
			elseif REFDatabase[i]["IsRated"] == RERated and RERated == false then
				if (REFDatabase[i]["TalentSet"] == RESpec and RESpec ~= nil) or RESpec == nil then
					RELine =  "\"" .. date("%H", REFDatabase[i]["TimeRaw"]) .. ":" .. date("%M", REFDatabase[i]["TimeRaw"]) .. "\";\"" .. date("%d", REFDatabase[i]["TimeRaw"]) .. "." .. date("%m", REFDatabase[i]["TimeRaw"]) .. "." .. date("%Y", REFDatabase[i]["TimeRaw"]) .. "\";" .. tonumber(date("%H", REFDatabase[i]["TimeRaw"])) .. ";" .. tonumber(date("%M", REFDatabase[i]["TimeRaw"])) .. ";" .. tonumber(date("%d", REFDatabase[i]["TimeRaw"])) .. ";" .. tonumber(date("%m", REFDatabase[i]["TimeRaw"])) .. ";" .. tonumber(date("%Y", REFDatabase[i]["TimeRaw"])) .. ";\"" .. REFDatabase[i]["MapName"] .. "\";" .. tonumber(REFlex_DurationShort(REFDatabase[i]["DurationRaw"], "M")) .. ";" .. tonumber(REFlex_DurationShort(REFDatabase[i]["DurationRaw"], "S")) .. ";\"" .. REFDatabase[i]["Winner"] .. "\";" .. REFDatabase[i]["KB"] .. ";" .. REFDatabase[i]["HK"] .. ";" .. REFDatabase[i]["Damage"] .. ";" .. REFDatabase[i]["Healing"] .. ";" .. REFDatabase[i]["Honor"] .. ";" .. REFDatabase[i]["PlaceKB"] .. ";" .. REFDatabase[i]["PlaceHK"] .. ";" .. REFDatabase[i]["PlaceDamage"] .. ";" .. REFDatabase[i]["PlaceHealing"] .. ";" .. REFDatabase[i]["PlaceHonor"] .. ";" .. REFDatabase[i]["PlaceFactionKB"] .. ";" .. REFDatabase[i]["PlaceFactionHK"] .. ";" .. REFDatabase[i]["PlaceFactionDamage"] .. ";" .. REFDatabase[i]["PlaceFactionHealing"] .. ";" .. REFDatabase[i]["PlaceFactionHonor"] .. ";";
					if REFDatabase[i]["MapInfo"] == "AlteracValley" then
						RELine = RELine .. REFDatabase[i]["SpecialFields"][3] .. ";" .. REFDatabase[i]["SpecialFields"][4] .. ";0;0;" .. REFDatabase[i]["SpecialFields"][1].. ";" .. REFDatabase[i]["SpecialFields"][2] .. ";";
					elseif REFDatabase[i]["MapInfo"] == "WarsongGulch" or REFDatabase[i]["MapInfo"] == "TwinPeaks" then
						RELine = RELine .. "0;0;" .. REFDatabase[i]["SpecialFields"][1] .. ";" .. REFDatabase[i]["SpecialFields"][2] .. ";0;0;";
					elseif REFDatabase[i]["MapInfo"] == "GilneasBattleground2" or REFDatabase[i]["MapInfo"] == "IsleofConquest" or REFDatabase[i]["MapInfo"] == "ArathiBasin" or REFDatabase[i]["MapInfo"] == "StrandoftheAncients" then
						RELine = RELine .. REFDatabase[i]["SpecialFields"][1] .. ";" .. REFDatabase[i]["SpecialFields"][2] .. ";0;0;0;0;";
					elseif REFDatabase[i]["MapInfo"] == "NetherstormArena" then
						RELine = RELine .. "0;0;" .. REFDatabase[i]["SpecialFields"][1] .. ";0;0;0;";
					else
						RELine = RELine .. "0;0;0;0;0;0;";
					end
					RELine = RELine .. REFDatabase[i]["TalentSet"] .. ";" .. tonumber( REFDatabase[i]["AllianceNum"])+tonumber(REFDatabase[i]["HordeNum"]) .. ";" .. REFDatabase[i]["AllianceNum"] .. ";" .. REFDatabase[i]["HordeNum"];
					REExport = REExport .. RELine .. "\n";
					RELine = "";
				end
			elseif REFDatabase[i]["IsRated"] == RERated and RERated == true then
				if (REFDatabase[i]["TalentSet"] == RESpec and RESpec ~= nil) or RESpec == nil then
					RELine = "\"" .. date("%H", REFDatabase[i]["TimeRaw"]) .. ":" .. date("%M", REFDatabase[i]["TimeRaw"]) .. "\";\"" .. date("%d", REFDatabase[i]["TimeRaw"]) .. "." .. date("%m", REFDatabase[i]["TimeRaw"]) .. "." .. date("%Y", REFDatabase[i]["TimeRaw"]) .. "\";" .. tonumber(date("%H", REFDatabase[i]["TimeRaw"])) .. ";" .. tonumber(date("%M", REFDatabase[i]["TimeRaw"])) .. ";" .. tonumber(date("%d", REFDatabase[i]["TimeRaw"])) .. ";" .. tonumber(date("%m", REFDatabase[i]["TimeRaw"])) .. ";" .. tonumber(date("%Y", REFDatabase[i]["TimeRaw"])) .. ";\"" .. REFDatabase[i]["MapName"] .. "\";" .. tonumber(REFlex_DurationShort(REFDatabase[i]["DurationRaw"], "M")) .. ";" .. tonumber(REFlex_DurationShort(REFDatabase[i]["DurationRaw"], "S")) .. ";\"" .. REFDatabase[i]["Winner"] .. "\";" .. REFDatabase[i]["KB"] .. ";" .. REFDatabase[i]["HK"] .. ";" .. REFDatabase[i]["Damage"] .. ";" .. REFDatabase[i]["Healing"] .. ";" .. REFDatabase[i]["Honor"] .. ";" .. REFDatabase[i]["PlaceKB"] .. ";" .. REFDatabase[i]["PlaceHK"] .. ";" .. REFDatabase[i]["PlaceDamage"] .. ";" .. REFDatabase[i]["PlaceHealing"] .. ";" .. REFDatabase[i]["PlaceHonor"] .. ";" .. REFDatabase[i]["PlaceFactionKB"] .. ";" .. REFDatabase[i]["PlaceFactionHK"] .. ";" .. REFDatabase[i]["PlaceFactionDamage"] .. ";" .. REFDatabase[i]["PlaceFactionHealing"] .. ";" .. REFDatabase[i]["PlaceFactionHonor"] .. ";";
					if REFDatabase[i]["MapInfo"] == "AlteracValley" then
						RELine = RELine .. REFDatabase[i]["SpecialFields"][3] .. ";" .. REFDatabase[i]["SpecialFields"][4] .. ";0;0;" .. REFDatabase[i]["SpecialFields"][1] .. ";" .. REFDatabase[i]["SpecialFields"][2] .. ";";
					elseif REFDatabase[i]["MapInfo"] == "WarsongGulch" or REFDatabase[i]["MapInfo"] == "TwinPeaks" then
						RELine = RELine .. "0;0;" .. REFDatabase[i]["SpecialFields"][1] .. ";" .. REFDatabase[i]["SpecialFields"][2] .. ";0;0;";
					elseif REFDatabase[i]["MapInfo"] == "GilneasBattleground2" or REFDatabase[i]["MapInfo"] == "IsleofConquest" or REFDatabase[i]["MapInfo"] == "ArathiBasin" or REFDatabase[i]["MapInfo"] == "StrandoftheAncients" then
						RELine = RELine .. REFDatabase[i]["SpecialFields"][1] .. ";" .. REFDatabase[i]["SpecialFields"][2] .. ";0;0;0;0;";
					elseif REFDatabase[i]["MapInfo"] == "NetherstormArena" then
						RELine = RELine .. "0;0;" .. REFDatabase[i]["SpecialFields"][1] .. ";0;0;0;";
					else
						RELine = RELine .. "0;0;0;0;0;0;";
					end
					RELine = RELine .. REFDatabase[i]["TalentSet"] .. ";" .. tonumber( REFDatabase[i]["AllianceNum"])+tonumber(REFDatabase[i]["HordeNum"]) .. ";" .. REFDatabase[i]["AllianceNum"] .. ";" .. REFDatabase[i]["HordeNum"] .. ";\"" .. REFDatabase[i]["RatingChange"] .. "\";" .. REFDatabase[i]["AllianceRating"] .. ";" .. REFDatabase[i]["HordeRating"] .. ";";
					local REHordeAverageMMR, REAllianceAverageMMR, REMMR, REMMRChange;
					if REFDatabase[i]["HordeMMR"] == nil then
						REHordeAverageMMR = 0;
					else
						REHordeAverageMMR = REFDatabase[i]["HordeMMR"];
					end
					if REFDatabase[i]["AllianceMMR"] == nil then
						REAllianceAverageMMR = 0;
					else
						REAllianceAverageMMR = REFDatabase[i]["AllianceMMR"];
					end
					if REFDatabase[i]["PreMMR"] == nil then
						REMMR = 0;
					else
						REMMR = REFDatabase[i]["PreMMR"];
					end
					if REFDatabase[i]["MMRChange"] == nil then
						REMMRChange = 0;
					else
						REMMRChange = REFDatabase[i]["MMRChange"];
					end
					RELine = RELine .. REHordeAverageMMR .. ";" .. REAllianceAverageMMR .. ";" .. REMMR .. ";" .. REMMRChange;
					REExport = REExport .. RELine .. "\n";
					RELine = "";
				end
			end
		end
	elseif REDataType == "Arena" then
		if REBracket == nil or REBracket == 5 then
			REExport = "Time;Date;TimeHour;TimeMinutes;DateDay;DateMonth;DateYear;Map;DurationMinutes;DurationSeconds;WeWon;TalentSet;Bracket;Season;MyTeamName;EnemyTeamName;MyTeamRating;EnemyTeamRating;MyTeamRatingChange;EnemyTeamRatingChange;MyKillingBlows;MyDamage;MyHealing;MyTeamDamage;MyTeamHealing;EnemyTeamDamage;EnemyTeamHealing;MyMMR;MyMMRChange;MyTeamMMR;EnemyTeamMMr;Ally1Name;Ally1Race;Ally1Class;Ally1Build;Ally1Damage;Ally1Healing;Ally1KillingBlows;Ally1MMR;Ally1MMRChange;Ally2Name;Ally2Race;Ally2Class;Ally2Build;Ally2Damage;Ally2Healing;Ally2KillingBlows;Ally2MMR;Ally2MMRChange;Ally3Name;Ally3Race;Ally3Class;Ally3Build;Ally3Damage;Ally3Healing;Ally3KillingBlows;Ally3MMR;Ally3MMRChange;Ally4Name;Ally4Race;Ally4Class;Ally4Build;Ally4Damage;Ally4Healing;Ally4KillingBlows;Ally4MMR;Ally4MMRChange;Ally5Name;Ally5Race;Ally5Class;Ally5Build;Ally5Damage;Ally5Healing;Ally5KillingBlows;Ally5MMR;Ally5MMRChange;Enemy1Name;Enemy1Race;Enemy1Class;Enemy1Build;Enemy1Damage;Enemy1Healing;Enemy1KillingBlows;Enemy1MMR;Enemy1MMRChange;Enemy2Name;Enemy2Race;Enemy2Class;Enemy2Build;Enemy2Damage;Enemy2Healing;Enemy2KillingBlows;Enemy2MMR;Enemy2MMRChange;Enemy3Name;Enemy3Race;Enemy3Class;Enemy3Build;Enemy3Damage;Enemy3Healing;Enemy3KillingBlows;Enemy3MMR;Enemy3MMRChange;Enemy4Name;Enemy4Race;Enemy4Class;Enemy4Build;Enemy4Damage;Enemy4Healing;Enemy4KillingBlows;Enemy4MMR;Enemy4MMRChange;Enemy5Name;Enemy5Race;Enemy5Class;Enemy5Build;Enemy5Damage;Enemy5Healing;Enemy5KillingBlowsEnemy5;MMR;Enemy5MMRChange\n";
			RESlots = 5;
		elseif REBracket == 2 then
			REExport = "Time;Date;TimeHour;TimeMinutes;DateDay;DateMonth;DateYear;Map;DurationMinutes;DurationSeconds;WeWon;TalentSet;Bracket;Season;MyTeamName;EnemyTeamName;MyTeamRating;EnemyTeamRating;MyTeamRatingChange;EnemyTeamRatingChange;MyKillingBlows;MyDamage;MyHealing;MyTeamDamage;MyTeamHealing;EnemyTeamDamage;EnemyTeamHealing;MyMMR;MyMMRChange;MyTeamMMR;EnemyTeamMMr;Ally1Name;Ally1Race;Ally1Class;Ally1Build;Ally1Damage;Ally1Healing;Ally1KillingBlows;Ally1MMR;Ally1MMRChange;Ally2Name;Ally2Race;Ally2Class;Ally2Build;Ally2Damage;Ally2Healing;Ally2KillingBlows;Ally2MMR;Ally2MMRChange;Enemy1Name;Enemy1Race;Enemy1Class;Enemy1Build;Enemy1Damage;Enemy1Healing;Enemy1KillingBlows;Enemy1MMR;Enemy1MMRChange;Enemy2Name;Enemy2Race;Enemy2Class;Enemy2Build;Enemy2Damage;Enemy2Healing;Enemy2KillingBlowsEnemy2MMR;Enemy2MMRChange\n";
			RESlots = 2;
		elseif REBracket == 3 then
			REExport = "Time;Date;TimeHour;TimeMinutes;DateDay;DateMonth;DateYear;Map;DurationMinutes;DurationSeconds;WeWon;TalentSet;Bracket;Season;MyTeamName;EnemyTeamName;MyTeamRating;EnemyTeamRating;MyTeamRatingChange;EnemyTeamRatingChange;MyKillingBlows;MyDamage;MyHealing;MyTeamDamage;MyTeamHealing;EnemyTeamDamage;EnemyTeamHealing;MyMMR;MyMMRChange;MyTeamMMR;EnemyTeamMMr;Ally1Name;Ally1Race;Ally1Class;Ally1Build;Ally1Damage;Ally1Healing;Ally1KillingBlows;Ally1MMR;Ally1MMRChange;Ally2Name;Ally2Race;Ally2Class;Ally2Build;Ally2Damage;Ally2Healing;Ally2KillingBlows;Ally2MMR;Ally2MMRChange;Ally3Name;Ally3Race;Ally3Class;Ally3Build;Ally3Damage;Ally3Healing;Ally3KillingBlows;Ally3MMR;Ally3MMRChange;Enemy1Name;Enemy1Race;Enemy1Class;Enemy1Build;Enemy1Damage;Enemy1Healing;Enemy1KillingBlows;Enemy1MMR;Enemy1MMRChange;Enemy2Name;Enemy2Race;Enemy2Class;Enemy2Build;Enemy2Damage;Enemy2Healing;Enemy2KillingBlows;Enemy2MMR;Enemy2MMRChange;Enemy3Name;Enemy3Race;Enemy3Class;Enemy3Build;Enemy3Damage;Enemy3Healing;Enemy3KillingBlows;Enemy3MMR;Enemy3MMRChange\n";
			RESlots = 3;
		end

		local RELine = "";
		for i=1, #REFDatabaseA do
			if ((REFDatabaseA[i]["TalentSet"] == RESpec and RESpec ~= nil) or RESpec == nil) and ((REFDatabaseA[i]["Bracket"] == REBracket and REBracket ~= nil) or REBracket == nil) and REFlex_ArenaExportSearch(i) then
				local _, REEnemyID, _, REFriendID, Team, TeamE = REFlex_ArenaTeamHash(i);
				local REMapName;
				if REFDatabaseA[i]["MapName"] == nil then
					REMapName = "";
				else
					REMapName = REFDatabaseA[i]["MapName"];
				end
				RELine = "\"" .. date("%H", REFDatabaseA[i]["TimeRaw"]) .. ":" .. date("%M", REFDatabaseA[i]["TimeRaw"]) .. "\";\"" .. date("%d", REFDatabaseA[i]["TimeRaw"]) .. "." .. date("%m", REFDatabaseA[i]["TimeRaw"]) .. "." .. date("%Y", REFDatabaseA[i]["TimeRaw"]) .. "\";" .. tonumber(date("%H", REFDatabaseA[i]["TimeRaw"])) .. ";" .. tonumber(date("%M", REFDatabaseA[i]["TimeRaw"])) .. ";" .. tonumber(date("%d", REFDatabaseA[i]["TimeRaw"])) .. ";" .. tonumber(date("%m", REFDatabaseA[i]["TimeRaw"])) .. ";" .. tonumber(date("%Y", REFDatabaseA[i]["TimeRaw"])) .. ";\"" .. REMapName .. "\";" .. tonumber(REFlex_DurationShort(REFDatabaseA[i]["DurationRaw"], "M")) .. ";" .. tonumber(REFlex_DurationShort(REFDatabaseA[i]["DurationRaw"], "S")) .. ";";
				if REFDatabaseA[i]["Winner"] == REFDatabaseA[i]["PlayerTeam"] then
					RELine = RELine .. "true;";
				else
					RELine = RELine .. "false;";
				end
				RELine = RELine .. REFDatabaseA[i]["TalentSet"] .. ";" .. REFDatabaseA[i]["Bracket"] .. ";" .. REFDatabaseA[i]["Season"] .. ";" .. REFDatabaseA[i][Team .. "TeamName"] .. ";" .. REFDatabaseA[i][TeamE .. "TeamName"] .. ";" .. REFDatabaseA[i][Team .. "TeamRating"] .. ";" .. REFDatabaseA[i][TeamE .. "TeamRating"] .. ";" .. REFDatabaseA[i][Team .. "TeamRatingChange"] .. ";" .. REFDatabaseA[i][TeamE .. "TeamRatingChange"] .. ";" .. REFDatabaseA[i]["KB"] .. ";" .. REFDatabaseA[i]["Damage"] .. ";" .. REFDatabaseA[i]["Healing"] .. ";";
				
				local REMyTeamDamage, REMyTeamHealing, REEnemyTeamDamage, REEnemyTeamHealing = 0,0,0,0;
				for k=1, #REFDatabaseA[i][Team .. "Team"] do
					REMyTeamDamage = REMyTeamDamage + REFDatabaseA[i][Team .. "Team"][k]["Damage"];
					REMyTeamHealing = REMyTeamHealing + REFDatabaseA[i][Team .. "Team"][k]["Healing"];
				end
				for k=1, #REFDatabaseA[i][TeamE .. "Team"] do
					REEnemyTeamDamage = REEnemyTeamDamage + REFDatabaseA[i][TeamE .. "Team"][k]["Damage"];
					REEnemyTeamHealing = REEnemyTeamHealing + REFDatabaseA[i][TeamE .. "Team"][k]["Healing"];
				end
				RELine = RELine .. REMyTeamDamage .. ";" .. REMyTeamHealing .. ";" .. REEnemyTeamDamage .. ";" .. REEnemyTeamHealing .. ";";

				local REMyMMR, REMyMMRChange, REMyTeamMMR, REEnemyTeamMMR;
				if REFDatabaseA[i]["PreMMR"] == nil then
					REMyMMR = 0;
				else
					REMyMMR = REFDatabaseA[i]["PreMMR"];
				end
				if REFDatabaseA[i]["MMRChange"] == nil then
					REMyMMRChange = 0;
				else
					REMyMMRChange = REFDatabaseA[i]["MMRChange"];
				end
				if REFDatabaseA[i][Team .. "TeamMMR"] == nil then
					REMyTeamMMR = 0;
				else
					REMyTeamMMR = REFDatabaseA[i][Team .. "TeamMMR"];
				end
				if REFDatabaseA[i][TeamE .. "TeamMMR"] == nil then
					REEnemyTeamMMR = 0;
				else
					REEnemyTeamMMR = REFDatabaseA[i][TeamE .. "TeamMMR"];
				end
				RELine = RELine .. REMyMMR .. ";" .. REMyMMRChange .. ";" .. REMyTeamMMR .. ";" .. REEnemyTeamMMR .. ";";

				local RESlotsTemp = RESlots;
				for k=1, #REFriendID do
					local REBuild = UNKNOWN;
					if REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["Build"] ~= nil then
						REBuild = REFlex_SpecTranslate(REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["classToken"], REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["Build"]);
					end
					local RERace = UNKNOWN;
					if REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["Race"] ~= nil then
						RERace = REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["Race"];
					end
					if REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["PreMMR"] ~= nil then
						RELine = RELine .. "\"" .. REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["Name"] .. "\";\"" .. RERace .. "\";\"" .. LOCALIZED_CLASS_NAMES_MALE[REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["classToken"]] .. "\";\"" .. REBuild .. "\";" .. REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["Damage"] .. ";" .. REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["Healing"] .. ";" .. REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["KB"] .. ";" .. REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["PreMMR"] .. ";" .. REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["MMRChange"] .. ";";
					else
						RELine = RELine .. "\"" .. REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["Name"] .. "\";\"" .. RERace .. "\";\"" .. LOCALIZED_CLASS_NAMES_MALE[REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["classToken"]] .. "\";\"" .. REBuild .. "\";" .. REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["Damage"] .. ";" .. REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["Healing"] .. ";" .. REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["KB"] .. ";;;";
					end
					RESlotsTemp = RESlotsTemp - 1;
				end
				if RESlotsTemp ~= 0 then
					for k=1, RESlotsTemp do
						RELine = RELine .. ";;;;;;;;;";
					end
				end
				local RESlotsTemp = RESlots;
				for k=1, #REEnemyID do
					local REBuild = UNKNOWN;
					if REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["Build"] ~= nil then
						REBuild = REFlex_SpecTranslate(REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["classToken"], REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["Build"]);
					end
					local RERace = UNKNOWN;
					if REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["Race"] ~= nil then
						RERace = REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["Race"];
					end
					if REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["PreMMR"] ~= nil then
						RELine = RELine .. "\"" .. REFlex_NameClean(REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["Name"]) .. "\";\"" .. RERace .. "\";\"" .. LOCALIZED_CLASS_NAMES_MALE[REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["classToken"]] .. "\";\"" .. REBuild .. "\";" .. REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["Damage"] .. ";" .. REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["Healing"] .. ";" .. REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["KB"] .. ";" .. REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["PreMMR"] .. ";" .. REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["MMRChange"] .. ";";
					else
						RELine = RELine .. "\"" .. REFlex_NameClean(REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["Name"]) .. "\";\"" .. RERace .. "\";\"" .. LOCALIZED_CLASS_NAMES_MALE[REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["classToken"]] .. "\";\"" .. REBuild .. "\";" .. REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["Damage"] .. ";" .. REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["Healing"] .. ";" .. REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["KB"] .. ";;;";
					end
					RESlotsTemp = RESlotsTemp - 1;
				end
				if RESlotsTemp ~= 0 then
					for k=1, RESlotsTemp do
						RELine = RELine .. ";;;;;;;;;";
					end
				end
				REExport = REExport .. RELine .. "\n";
				RELine = "";
			end
		end
	end

	REFlex_ExportTab_Panel_Text:SetText(REExport);
	REFlex_ExportTab_Panel_Text:HighlightText(0);
	REExport = "";
	collectgarbage('collect');
end

function REFlex_MainTabShow()
	if RE.Debug == 2 then
		UpdateAddOnMemoryUsage();
		RE.CurrentMemoryIgnition = GetAddOnMemoryUsage("REFlex");
	end

	if UnitLevel("player") > 9 and PVPHonorFrame.selectedPvpID ~= nil then
		RequestRatedBattlegroundInfo();
	end
	RequestPVPRewards();
	REFlex_ExportTab:Hide();
	if REFSettings["ArenaSupport"] and RE.ArenaReload then
		RE.ArenaReload = false;
		RE.ArenaReloadAlpha = true;
		RE.ArenaLastID = RE.ArenaLastID + 1;
		REFlex_ArenaTeamGrid(RE.ArenaLastID);
	end

	if RE.SecondTimeMainTab == false then
		REFlex_SetTabs();
		RE.DataStructure12, RE.DataStructure3, RE.DataStructure5, RE.DataStructure6, RE.DataStructure7, RE.DataStructure8 = {}, {}, {}, {}, {}, {};
		if REFSettings["UNBGSupport"] then
			RE.DataStructure12 = {
				{
					["name"] = L["Date"],
					["width"] = 122,
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[self.data[rowa].cols[13].value]["TimeRaw"]; local RERowB = REFDatabase[self.data[rowb].cols[13].value]["TimeRaw"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = L["Map"],
					["width"] = 142,
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
					["width"] = 72,
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[self.data[rowa].cols[13].value]["DurationRaw"]; local RERowB = REFDatabase[self.data[rowb].cols[13].value]["DurationRaw"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = WIN,
					["width"] = 72,
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
					["width"] = 47,
					["align"] = "CENTER"
				},
				{
					["name"] = "HK",
					["width"] = 47,
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
					["width"] = 73,
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[self.data[rowa].cols[13].value]["Damage"]; local RERowB = REFDatabase[self.data[rowb].cols[13].value]["Damage"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = SHOW_COMBAT_HEALING,
					["width"] = 73,
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[self.data[rowa].cols[13].value]["Healing"]; local RERowB = REFDatabase[self.data[rowb].cols[13].value]["Healing"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = HONOR,
					["width"] = 53,
					["align"] = "CENTER"
				}
			}
		end

		if REFSettings["RBGSupport"] then
			RE.DataStructure3 = {
				{
					["name"] = L["Date"],
					["width"] = 92,
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[self.data[rowa].cols[13].value]["TimeRaw"]; local RERowB = REFDatabase[self.data[rowb].cols[13].value]["TimeRaw"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = L["Map"],
					["width"] = 40,
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},    
					["align"] = "CENTER"
				},
				{
					["name"] = L["A Rating"] .. "/ MMR",
					["width"] = 90,
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[self.data[rowa].cols[13].value]["AllianceRating"]; local RERowB = REFDatabase[self.data[rowb].cols[13].value]["AllianceRating"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = L["H Rating"] .. "/ MMR",
					["width"] = 90,
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[self.data[rowa].cols[13].value]["HordeRating"]; local RERowB = REFDatabase[self.data[rowb].cols[13].value]["HordeRating"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = AUCTION_DURATION,
					["width"] = 60,
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[self.data[rowa].cols[13].value]["DurationRaw"]; local RERowB = REFDatabase[self.data[rowb].cols[13].value]["DurationRaw"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = WIN,
					["width"] = 60,
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
					["width"] = 35,
					["align"] = "CENTER"
				},
				--{
				--	["name"] = "HK",
				--	["width"] = 35,
				--	["bgcolor"] = { 
				--		["r"] = 0.15, 
				--		["g"] = 0.15, 
				--		["b"] = 0.15, 
				--		["a"] = 1.0 
				--	},
				--	["align"] = "CENTER"
				--},
				{
					["name"] = DAMAGE,
					["width"] = 77,
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[self.data[rowa].cols[13].value]["Damage"]; local RERowB = REFDatabase[self.data[rowb].cols[13].value]["Damage"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = SHOW_COMBAT_HEALING,
					["width"] = 77,
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[self.data[rowa].cols[13].value]["Healing"]; local RERowB = REFDatabase[self.data[rowb].cols[13].value]["Healing"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = RATING .. " / MMR",
					["width"] = 80,
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[self.data[rowa].cols[13].value]["RatingChange"]; local RERowB = REFDatabase[self.data[rowb].cols[13].value]["RatingChange"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				}
			}

			RE.DataStructure9 = {
				{
					["name"] = NAME,
					["width"] = 125,
					["align"] = "CENTER"
				},
				{
					["name"] = L["Last active"],
					["width"] = 102,
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = self.data[rowa].cols[11].value; local RERowB = self.data[rowb].cols[11].value; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},    
					["align"] = "CENTER"
				},
				{
					["name"] = L["Attendance"],
					["width"] = 103,
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = self.data[rowa].cols[12].value; local RERowB = self.data[rowb].cols[12].value; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				--{
				--	["name"] = "MMR",
				--	["width"] = 93,
				--	["bgcolor"] = { 
				--		["r"] = 0.15, 
				--		["g"] = 0.15, 
				--		["b"] = 0.15, 
				--		["a"] = 1.0 
				--	},
				--	["align"] = "CENTER"
				--},
				--{
				--	["name"] = "MMR +/-",
				--	["width"] = 93,
				--	["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = self.data[rowa].cols[11].value; local RERowB = self.data[rowb].cols[11].value; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
				--	["align"] = "CENTER"
				--},
				{
					["name"] = RATING,
					["width"] = 78,
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},
					["align"] = "CENTER"
				},
				{
					["name"] = RATING .. " +/-",
					["width"] = 78,
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = self.data[rowa].cols[13].value; local RERowB = self.data[rowb].cols[13].value; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = WINS,
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
					["name"] = LOSSES,
					["width"] = 55,
					["align"] = "CENTER"
				},
				{
					["name"] = WINS .. " %",
					["width"] = 55,
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = self.data[rowa].cols[15].value; local RERowB = self.data[rowb].cols[15].value; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = GUILD_ONLINE_LABEL,
					["width"] = 50,
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = self.data[rowa].cols[10].value; local RERowB = self.data[rowb].cols[10].value; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				}
			}
		end

		if REFSettings["ArenaSupport"] then
			RE.DataStructure5 = {
				{
					["name"] = "\n" .. L["Date"],
					["width"] = 102,
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabaseA[self.data[rowa].cols[13].value]["TimeRaw"]; local RERowB = REFDatabaseA[self.data[rowb].cols[13].value]["TimeRaw"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. L["Map"],
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
					["name"] = "\n" .. TEAM,
					["width"] = 200,
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. RATING .. " / MMR",
					["width"] = 95,
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RETeam1, RETeam2; if REFDatabaseA[self.data[rowa].cols[13].value]["PlayerTeam"] == 0 then RETeam1 = "Green" else RETeam1 = "Gold" end; if REFDatabaseA[self.data[rowb].cols[13].value]["PlayerTeam"] == 0 then RETeam2 = "Green" else RETeam2 = "Gold" end; local RERowA = REFDatabaseA[self.data[rowa].cols[13].value][RETeam1 .. "TeamRating"]; local RERowB = REFDatabaseA[self.data[rowb].cols[13].value][RETeam2 .. "TeamRating"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. ENEMY,
					["width"] = 200,
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. RATING .. " / MMR",
					["width"] = 95,
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RETeam1, RETeam2; if REFDatabaseA[self.data[rowa].cols[13].value]["PlayerTeam"] == 0 then RETeam1 = "Gold" else RETeam1 = "Green" end; if REFDatabaseA[self.data[rowb].cols[13].value]["PlayerTeam"] == 0 then RETeam2 = "Gold" else RETeam2 = "Green" end; local RERowA = REFDatabaseA[self.data[rowa].cols[13].value][RETeam1 .. "TeamRating"]; local RERowB = REFDatabaseA[self.data[rowb].cols[13].value][RETeam2 .. "TeamRating"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. AUCTION_DURATION,
					["width"] = 60,
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabaseA[self.data[rowa].cols[13].value]["DurationRaw"]; local RERowB = REFDatabaseA[self.data[rowb].cols[13].value]["DurationRaw"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. DAMAGE,
					["width"] = 60,
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabaseA[self.data[rowa].cols[13].value]["Damage"]; local RERowB = REFDatabaseA[self.data[rowb].cols[13].value]["Damage"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. SHOW_COMBAT_HEALING,
					["width"] = 60,
				["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabaseA[self.data[rowa].cols[13].value]["Healing"]; local RERowB = REFDatabaseA[self.data[rowb].cols[13].value]["Healing"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. RATING .. " / MMR",
					["width"] = 85,
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RETeam1, RETeam2; if REFDatabaseA[self.data[rowa].cols[13].value]["PlayerTeam"] == 0 then RETeam1 = "Green" else RETeam1 = "Gold" end; if REFDatabaseA[self.data[rowb].cols[13].value]["PlayerTeam"] == 0 then RETeam2 = "Green" else RETeam2 = "Gold" end; local RERowA = REFDatabaseA[self.data[rowa].cols[13].value][RETeam1 .. "TeamRatingChange"]; local RERowB = REFDatabaseA[self.data[rowb].cols[13].value][RETeam2 .. "TeamRatingChange"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				}
			}

			RE.DataStructure6 = {
				{
					["name"] = "\n" .. TEAM,
					["width"] = 205,
					["align"] = "LEFT"
				},
				{
					["name"] = "\n" .. "W/L",
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},
					["width"] = 35,
					["sortnext"]= 3,
					["defaultsort"] = "asc",
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. WIN,
					["width"] = 35,
					["sortnext"]= 4,
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. LOSS,
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},
					["width"] = 35,
					["defaultsort"] = "dsc",
					["align"] = "CENTER"
				}
			}

			RE.DataStructure7 = {
				{
					["name"] = "\n" .. TEAM,
					["width"] = 205,
					["align"] = "LEFT"
				},
				{
					["name"] = "\n" .. "#",
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},
					["width"] = 35,
					["sortnext"]= 3,
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. WIN,
					["width"] = 35,
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. LOSS,
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},
					["width"] = 35,
					["align"] = "CENTER"
				}
			}

			RE.DataStructure8 = {
				{
					["name"] = "\n" .. TEAM,
					["width"] = 205,
					["align"] = "LEFT"
				},
				{
					["name"] = "\n" .. "W/L",
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},
					["width"] = 35,
					["sortnext"]= 3,
					["defaultsort"] = "dsc",
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. LOSS,
					["width"] = 35,
					["sortnext"]= 4,
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. WIN,
					["width"] = 35,
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},
					["defaultsort"] = "dsc",
					["align"] = "CENTER"
				}
			}
		end

		if REFSettings["UNBGSupport"] and REFSettings["RBGSupport"] then
			RE.MainTable1 = RE.ScrollingTable:CreateST(RE.DataStructure12, 25, nil, nil, REFlex_MainTab_Tab1_Table)
			_G[RE.MainTable1["frame"]:GetName()]:SetPoint("TOP");
			RE.MainTable1:RegisterEvents({
				["OnEnter"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
					if realrow ~= nil and IsAltKeyDown() == nil then
						RE.TooltipTimer = RE.ShefkiTimer:ScheduleTimer(REFlex_ShowBGDetails_OnEnter, 0.5, {cellFrame, data[realrow]["cols"][13]["value"]});
					end
				end,
				["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, Button, ...)
					if realrow ~= nil and IsAltKeyDown() == 1 and IsControlKeyDown() == 1 and IsShiftKeyDown() == 1 and Button == "LeftButton" then
						RE.DeleteID = data[realrow]["cols"][13]["value"];
						StaticPopup_Show("REFLEX_CONFIRMDELETE");
					end
				end,
				["OnLeave"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
					if realrow ~= nil then
						RE.ShefkiTimer:CancelTimer(RE.TooltipTimer, true)
						REFlex_ShowDetails_OnLeave(cellFrame);    
					end
				end,
			});
		end
		if REFSettings["UNBGSupport"] then
			RE.MainTable2 = RE.ScrollingTable:CreateST(RE.DataStructure12, 25, nil, nil, REFlex_MainTab_Tab2_Table)
			_G[RE.MainTable2["frame"]:GetName()]:SetPoint("TOP");
			RE.MainTable2:RegisterEvents({
				["OnEnter"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
					if realrow ~= nil and IsAltKeyDown() == nil then
						RE.TooltipTimer = RE.ShefkiTimer:ScheduleTimer(REFlex_ShowBGDetails_OnEnter, 0.5, {cellFrame, data[realrow]["cols"][13]["value"]});    
					end
				end,
				["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, Button, ...)
					if realrow ~= nil and IsAltKeyDown() == 1 and IsControlKeyDown() == 1 and IsShiftKeyDown() == 1 and Button == "LeftButton" then
						RE.DeleteID = data[realrow]["cols"][13]["value"];
						StaticPopup_Show("REFLEX_CONFIRMDELETE");
					end
				end,
				["OnLeave"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
					if realrow ~= nil then
						RE.ShefkiTimer:CancelTimer(RE.TooltipTimer, true);
						REFlex_ShowDetails_OnLeave(cellFrame);    
					end
				end,
			});
		end
		if REFSettings["RBGSupport"] then
			RE.MainTable3 = RE.ScrollingTable:CreateST(RE.DataStructure3, 25, nil, nil, REFlex_MainTab_Tab3_Table)
			_G[RE.MainTable3["frame"]:GetName()]:SetPoint("TOP");
			RE.MainTable3:RegisterEvents({
				["OnEnter"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
					if realrow ~= nil and IsAltKeyDown() == nil then
						RE.TooltipTimer = RE.ShefkiTimer:ScheduleTimer(REFlex_ShowBGDetails_OnEnter, 0.5, {cellFrame, data[realrow]["cols"][13]["value"], "REMainTable3"});
					end
				end,
				["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, Button, ...)
					if realrow ~= nil and IsAltKeyDown() == 1 and IsControlKeyDown() == 1 and IsShiftKeyDown() == 1 and Button == "LeftButton" then
						RE.DeleteID = data[realrow]["cols"][13]["value"];
						StaticPopup_Show("REFLEX_CONFIRMDELETE");
					end
				end,
				["OnLeave"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
					if realrow ~= nil then
						RE.ShefkiTimer:CancelTimer(RE.TooltipTimer, true);
						REFlex_ShowDetails_OnLeaveRBG(cellFrame);    
					end
				end,
			});
			RE.MainTable9 = RE.ScrollingTable:CreateST(RE.DataStructure9, 25, nil, nil, REFlex_MainTab_Tab7_Table)
			RE.MainTable9:RegisterEvents({
				["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, Button, ...)
					if realrow ~= nil and IsShiftKeyDown() == 1 and IsControlKeyDown() ~= 1 and Button == "LeftButton" then
						InviteUnit(data[realrow]["cols"][14]["value"]);
					end
					if realrow ~= nil and IsControlKeyDown() == 1 and IsShiftKeyDown() ~= 1 and Button == "LeftButton" then
						if data[realrow]["cols"][10]["value"] == "1" then
							REFlex_SendQuery(data[realrow]["cols"][14]["value"]);
						end
					end
				end,
			});
			_G[RE.MainTable9["frame"]:GetName()]:SetPoint("TOP");
		end
		if REFSettings["ArenaSupport"] then
			RE.MainTable5 = RE.ScrollingTable:CreateST(RE.DataStructure5, 15, 25, nil, REFlex_MainTab_Tab5_Table)
			_G[RE.MainTable5["frame"]:GetName()]:SetPoint("TOP");
			RE.MainTable5:RegisterEvents({
				["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, Button ,...)
					if realrow ~= nil and IsAltKeyDown() == 1 and IsControlKeyDown() == 1 and IsShiftKeyDown() == 1 and Button == "LeftButton" then
						RE.DeleteID = data[realrow]["cols"][13]["value"];
						StaticPopup_Show("REFLEX_CONFIRMDELETE");
					elseif realrow == nil and (column == 3 or column == 5) then
						return true;   
					end
				end,
				["OnEnter"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
					if realrow ~= nil and IsAltKeyDown() == nil then
						RE.TooltipTimer = RE.ShefkiTimer:ScheduleTimer(REFlex_ShowArenaDetails_OnEnter, 0.5, {cellFrame, data[realrow]["cols"][13]["value"]}); 
					end
				end,
				["OnLeave"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
					if realrow ~= nil then
						RE.ShefkiTimer:CancelTimer(RE.TooltipTimer, true);
						REFlex_ShowDetails_OnLeave(cellFrame);    
					end
				end,
			});
			RE.MainTable6 = RE.ScrollingTable:CreateST(RE.DataStructure6, 5, 25, nil, REFlex_MainTab_Tab6_Table1)
			_G[RE.MainTable6["frame"]:GetName()]:SetPoint("TOP");
			RE.MainTable6:RegisterEvents({
				["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
					if row == nil then
						return true;   
					end
				end,
			});
			RE.MainTable7 = RE.ScrollingTable:CreateST(RE.DataStructure7, 5, 25, nil, REFlex_MainTab_Tab6_Table2)
			_G[RE.MainTable7["frame"]:GetName()]:SetPoint("TOP");
			RE.MainTable7:RegisterEvents({
				["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
					if row == nil then
						return true;   
					end
				end,
			});
			RE.MainTable8 = RE.ScrollingTable:CreateST(RE.DataStructure8, 5, 25, nil, REFlex_MainTab_Tab6_Table3)
			_G[RE.MainTable8["frame"]:GetName()]:SetPoint("TOP");
			RE.MainTable8:RegisterEvents({
				["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
					if row == nil then
						return true;   
					end
				end,
			});
		end

		RE.TalentTab = nil;

		if REFSettings["UNBGSupport"] and REFSettings["RBGSupport"] then
			PanelTemplates_SetTab(REFlex_MainTab, 1);
			PanelTemplates_SetTab(REFlex_MainTab_SpecHolder, 1);
			REFlex_MainTab_Tab1:Hide();
			REFlex_MainTab_Tab1:Show();
			REFlex_MainTab_Tab2:Hide();
			REFlex_MainTab_Tab3:Hide();
			REFlex_MainTab_Tab4:Hide();
			REFlex_MainTab_Tab5:Hide();
			REFlex_MainTab_Tab6:Hide();
			REFlex_MainTab_Tab7:Hide();
		elseif REFSettings["UNBGSupport"] == false and REFSettings["RBGSupport"] then 
			PanelTemplates_SetTab(REFlex_MainTab, 3);
			PanelTemplates_SetTab(REFlex_MainTab_SpecHolder, 1);
			REFlex_MainTab_Tab1:Hide();
			REFlex_MainTab_Tab2:Hide();
			REFlex_MainTab_Tab3:Hide();
			REFlex_MainTab_Tab3:Show();
			REFlex_MainTab_Tab4:Hide();
			REFlex_MainTab_Tab5:Hide();
			REFlex_MainTab_Tab6:Hide();
			REFlex_MainTab_Tab7:Hide();
		elseif REFSettings["UNBGSupport"] and REFSettings["RBGSupport"] == false then
			PanelTemplates_SetTab(REFlex_MainTab, 2);
			PanelTemplates_SetTab(REFlex_MainTab_SpecHolder, 1);
			REFlex_MainTab_Tab1:Hide();
			REFlex_MainTab_Tab2:Hide();
			REFlex_MainTab_Tab2:Show();
			REFlex_MainTab_Tab3:Hide();
			REFlex_MainTab_Tab4:Hide();
			REFlex_MainTab_Tab5:Hide();
			REFlex_MainTab_Tab6:Hide();
			REFlex_MainTab_Tab7:Hide();
		elseif REFSettings["UNBGSupport"] == false and REFSettings["RBGSupport"] == false and REFSettings["ArenaSupport"] then
			PanelTemplates_SetTab(REFlex_MainTab, 5);
			PanelTemplates_SetTab(REFlex_MainTab_SpecHolder, 1);
			REFlex_MainTab_Tab1:Hide();
			REFlex_MainTab_Tab2:Hide();
			REFlex_MainTab_Tab3:Hide();
			REFlex_MainTab_Tab4:Hide();
			REFlex_MainTab_Tab5:Hide();
			REFlex_MainTab_Tab5:Show();
			REFlex_MainTab_Tab6:Hide();
			REFlex_MainTab_Tab7:Hide();
		else
			REFlex_MainTab_SpecHolderTab1:Hide();
			REFlex_MainTab_SpecHolderTab2:Hide();
			REFlex_MainTab_SpecHolderTab3:Hide();
			REFlex_MainTab_MsgGuild:Hide(); 
			REFlex_MainTab_MsgParty:Hide();
			REFlex_MainTab_Tab1:Hide();
			REFlex_MainTab_Tab2:Hide();
			REFlex_MainTab_Tab3:Hide();
			REFlex_MainTab_Tab4:Hide();
			REFlex_MainTab_Tab5:Hide();
			REFlex_MainTab_Tab5:Hide();
			REFlex_MainTab_Tab6:Hide();
			REFlex_MainTab_Tab7:Hide();
		end
		RE.SecondTimeMainTab = true;
	end
end	

function REFlex_Tab1Show()
	REFlex_MainTab:SetSize(767, 502);
	REFlex_MainTab_MsgGuild:Show();
	REFlex_MainTab_MsgParty:Show();
	REFlex_MainTab_CSVExport:Show();
	REFlex_MainTab_Query:Hide();

	if REFDatabase[RE.Tab1LastID + 1] ~= nil then
		RE.Tab1LastID = RE.Tab1LastID + 1;
		for j=RE.Tab1LastID, #REFDatabase do
			local RETempCol = {};

			RETempCol[1] = {
				["value"] = date("%H:%M %d.%m.%Y", REFDatabase[j]["TimeRaw"])
			}
			RETempCol[2] = {
				["value"] = REFDatabase[j]["MapName"],
				["color"] = REFlex_TableCheckRated,
				["colorargs"] = {REFDatabase[j]["IsRated"],}
			}
			RETempCol[3] = {
				["value"] = REFlex_DurationShort(REFDatabase[j]["DurationRaw"])
			}
			RETempCol[4] = {
				["value"] = REFDatabase[j]["Winner"],
				["color"] = REFlex_TableWinColor,
				["colorargs"] = {REFDatabase[j]["Winner"],}
			}
			RETempCol[5] = {
				["value"] = REFDatabase[j]["KB"]
			}
			RETempCol[6] = {
				["value"] = REFDatabase[j]["HK"]
			}
			RETempCol[7] = {
				["value"] = REFlex_NumberClean(REFDatabase[j]["Damage"])
			}
			RETempCol[8] = {
				["value"] = REFlex_NumberClean(REFDatabase[j]["Healing"])
			}
			RETempCol[9] = {
				["value"] = REFDatabase[j]["Honor"]
			}
			RETempCol[12] = {
				["value"] = REFDatabase[j]["TalentSet"]
			}
			RETempCol[13] = {
				["value"] = j
			}

			local RETempRow = {
				["cols"] = RETempCol
			}

			table.insert(RE.Tab1TableData, RETempRow);
			RE.Tab1LastID = j;
		end

		RE.MainTable1:SetData(RE.Tab1TableData);
	end

	if RE.Table1Rdy == nil then
		RE.MainTable1:SetFilter(REFlex_Tab_DefaultFilter);
		REFlex_TableClick(1, 1);
		RE.Table1Rdy = true;
	end

	RE.TopKB, RE.SumKB = REFlex_Find("KB", nil, RE.TalentTab, nil, REFSettings["OnlyNew"]);
	RE.TopHK, RE.SumHK = REFlex_Find("HK", nil, RE.TalentTab, nil, REFSettings["OnlyNew"]);
	RE.TopDamage, RE.SumDamage = REFlex_Find("Damage", nil, RE.TalentTab, nil, REFSettings["OnlyNew"]);
	RE.TopHealing, RE.SumHealing = REFlex_Find("Healing", nil, RE.TalentTab, nil, REFSettings["OnlyNew"]);
	RE.Wins, RE.Losses = REFlex_WinLoss(nil, RE.TalentTab, nil, nil, nil, REFSettings["OnlyNew"]); 

	REFlex_MainTab_Tab1_ScoreHolder_Wins:SetText(RE.Wins);
	REFlex_MainTab_Tab1_ScoreHolder_Lose:SetText(RE.Losses);
	if RE.RBG ~= nil then
		--REFlex_MainTab_Tab1_ScoreHolder_RBG:SetText("|cFFFFD100R:|r " .. RE.RBG .. "  |cFFFFD100MMR:|r " .. REFSettings["CurrentMMRBG"]);
		REFlex_MainTab_Tab1_ScoreHolder_RBG:SetText("|cFFFFD100" .. PVP_RATING .. "|r " .. RE.RBG);
	end
	REFlex_MainTab_Tab1_ScoreHolder_HK1:SetText("HK");
	REFlex_MainTab_Tab1_ScoreHolder_HK2:SetText(L["Top"] .. ": " .. RE.TopHK);
	REFlex_MainTab_Tab1_ScoreHolder_HK3:SetText(L["Total"] .. ": " .. RE.SumHK);
	REFlex_MainTab_Tab1_ScoreHolder_KB1:SetText("KB");
	REFlex_MainTab_Tab1_ScoreHolder_KB2:SetText(L["Top"] .. ": " .. RE.TopKB);
	REFlex_MainTab_Tab1_ScoreHolder_KB3:SetText(L["Total"] .. ": " .. RE.SumKB);
	REFlex_MainTab_Tab1_ScoreHolder_Damage1:SetText(DAMAGE);
	REFlex_MainTab_Tab1_ScoreHolder_Damage2:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RE.TopDamage));
	REFlex_MainTab_Tab1_ScoreHolder_Damage3:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RE.SumDamage));
	REFlex_MainTab_Tab1_ScoreHolder_Healing1:SetText(SHOW_COMBAT_HEALING);
	REFlex_MainTab_Tab1_ScoreHolder_Healing2:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RE.TopHealing));
	REFlex_MainTab_Tab1_ScoreHolder_Healing3:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RE.SumHealing));
end

function REFlex_Tab2Show()
	REFlex_MainTab:SetSize(767, 502);
	REFlex_MainTab_MsgGuild:Show();
	REFlex_MainTab_MsgParty:Show();
	REFlex_MainTab_CSVExport:Show();
	REFlex_MainTab_Query:Hide();

	if REFDatabase[RE.Tab2LastID + 1] ~= nil then
		RE.Tab2LastID = RE.Tab2LastID + 1;
		for j=RE.Tab2LastID, #REFDatabase do	
			if REFDatabase[j]["IsRated"] == false then
				local RETempCol = {};
				RETempCol[1] = {
					["value"] = date("%H:%M %d.%m.%Y", REFDatabase[j]["TimeRaw"])
				}
				RETempCol[2] = {
					["value"] = REFDatabase[j]["MapName"]
				}
				RETempCol[3] = {
					["value"] = REFlex_DurationShort(REFDatabase[j]["DurationRaw"])
				}
				RETempCol[4] = {
					["value"] = REFDatabase[j]["Winner"],
					["color"] = REFlex_TableWinColor,
					["colorargs"] = {REFDatabase[j]["Winner"],}
				}
				RETempCol[5] = {
					["value"] = REFDatabase[j]["KB"]
				}
				RETempCol[6] = {
					["value"] = REFDatabase[j]["HK"]
				}
				RETempCol[7] = {
					["value"] = REFlex_NumberClean(REFDatabase[j]["Damage"])
				}
				RETempCol[8] = {
					["value"] = REFlex_NumberClean(REFDatabase[j]["Healing"])
				}
				RETempCol[9] = {
					["value"] = REFDatabase[j]["Honor"]
				}
				RETempCol[12] = {
					["value"] = REFDatabase[j]["TalentSet"]
				}
				RETempCol[13] = {
					["value"] = j
				}

				local RETempRow = {
					["cols"] = RETempCol
				}

				table.insert(RE.Tab2TableData, RETempRow);
				RE.Tab2LastID = j;
			end
		end

		RE.MainTable2:SetData(RE.Tab2TableData);
	end


	RE.TopKB, RE.SumKB = REFlex_Find("KB", false, RE.TalentTab, nil, REFSettings["OnlyNew"]);
	RE.TopHK, RE.SumHK = REFlex_Find("HK", false, RE.TalentTab, nil, REFSettings["OnlyNew"]);
	RE.TopDamage, RE.SumDamage = REFlex_Find("Damage", false, RE.TalentTab, nil, REFSettings["OnlyNew"]);
	RE.TopHealing, RE.SumHealing = REFlex_Find("Healing", false, RE.TalentTab, nil, REFSettings["OnlyNew"]);
	RE.Wins, RE.Losses = REFlex_WinLoss(false, RE.TalentTab, nil, nil, nil, REFSettings["OnlyNew"]); 

	REFlex_MainTab_Tab2_ScoreHolder_Wins:SetText(RE.Wins);
	REFlex_MainTab_Tab2_ScoreHolder_Lose:SetText(RE.Losses);
	REFlex_MainTab_Tab2_ScoreHolder_HK1:SetText("HK");
	REFlex_MainTab_Tab2_ScoreHolder_HK2:SetText(L["Top"] .. ": " .. RE.TopHK);
	REFlex_MainTab_Tab2_ScoreHolder_HK3:SetText(L["Total"] .. ": " .. RE.SumHK);
	REFlex_MainTab_Tab2_ScoreHolder_KB1:SetText("KB");
	REFlex_MainTab_Tab2_ScoreHolder_KB2:SetText(L["Top"] .. ": " .. RE.TopKB);
	REFlex_MainTab_Tab2_ScoreHolder_KB3:SetText(L["Total"] .. ": " .. RE.SumKB);
	REFlex_MainTab_Tab2_ScoreHolder_Damage1:SetText(DAMAGE);
	REFlex_MainTab_Tab2_ScoreHolder_Damage2:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RE.TopDamage));
	REFlex_MainTab_Tab2_ScoreHolder_Damage3:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RE.SumDamage));
	REFlex_MainTab_Tab2_ScoreHolder_Healing1:SetText(SHOW_COMBAT_HEALING);
	REFlex_MainTab_Tab2_ScoreHolder_Healing2:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RE.TopHealing));
	REFlex_MainTab_Tab2_ScoreHolder_Healing3:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RE.SumHealing));
end

function REFlex_Tab3Show()
	REFlex_MainTab:SetSize(767, 502);
	REFlex_MainTab_MsgGuild:Show();
	REFlex_MainTab_MsgParty:Show();
	REFlex_MainTab_CSVExport:Show();
	REFlex_MainTab_Query:Hide();

	if REFSettings["RBGListFirstTime"] then
		StaticPopup_Show("REFLEX_SHIFTINFORBG");
	end

	if REFDatabase[RE.Tab3LastID + 1] ~= nil then
		RE.Tab3LastID = RE.Tab3LastID + 1;
		for j=RE.Tab3LastID, #REFDatabase do
			if REFDatabase[j]["IsRated"] then
				local RETempCol = {};
				RETempCol[1] = {
					["value"] = date("%H:%M %d.%m.%y", REFDatabase[j]["TimeRaw"])
				}
				RETempCol[2] = {
					["value"] = REFlex_ShortMap(REFDatabase[j]["MapName"]),
					["color"] = REFlex_TableWinError,
					["colorargs"] = {REFDatabase[j]["HordeNum"], REFDatabase[j]["AllianceNum"],}
				}
				RETempCol[3] = {
					["value"] = REFlex_TableRBGRatingMMR("Alliance", j)
				}
				RETempCol[4] = {
					["value"] = REFlex_TableRBGRatingMMR("Horde", j)
				}
				RETempCol[5] = {
					["value"] = REFlex_DurationShort(REFDatabase[j]["DurationRaw"])
				}
				RETempCol[6] = {
					["value"] = REFDatabase[j]["Winner"],
					["color"] = REFlex_TableWinColor,
					["colorargs"] = {REFDatabase[j]["Winner"],}
				}
				RETempCol[7] = {
					["value"] = REFDatabase[j]["KB"]
				}
				--RETempCol[8] = {
				--	["value"] = REFDatabase[j]["HK"]
				--}
				RETempCol[8] = {
					["value"] = REFlex_NumberClean(REFDatabase[j]["Damage"])
				}
				RETempCol[9] = {
					["value"] = REFlex_NumberClean(REFDatabase[j]["Healing"])
				}
				RETempCol[10] = {
					["value"] = REFlex_TableRBGRatingMMRColor(REFDatabase[j]["RatingChange"], j)
				}
				RETempCol[12] = {
					["value"] = REFDatabase[j]["TalentSet"]
				}
				RETempCol[13] = {
					["value"] = j
				}

				local RETempRow = {
					["cols"] = RETempCol
				}

				table.insert(RE.Tab3TableData, RETempRow);
				RE.Tab3LastID = j;
			end
		end

		RE.MainTable3:SetData(RE.Tab3TableData);
	end

	if RE.Table3Rdy == nil then
		RE.MainTable3:SetFilter(REFlex_Tab_DefaultFilter);
		REFlex_TableClick(3, 1);
		RE.Table3Rdy = true;
	end

	RE.TopKB, RE.SumKB = REFlex_Find("KB", true, RE.TalentTab, nil, REFSettings["OnlyNew"]);
	RE.TopHK, RE.SumHK = REFlex_Find("HK", true, RE.TalentTab, nil, REFSettings["OnlyNew"]);
	RE.TopDamage, RE.SumDamage = REFlex_Find("Damage", true, RE.TalentTab, nil, REFSettings["OnlyNew"]);
	RE.TopHealing, RE.SumHealing = REFlex_Find("Healing", true, RE.TalentTab, nil, REFSettings["OnlyNew"]);
	RE.Wins, RE.Losses = REFlex_WinLoss(true, RE.TalentTab, nil, nil, nil, REFSettings["OnlyNew"]); 

	REFlex_MainTab_Tab3_ScoreHolder_Wins:SetText(RE.Wins);
	REFlex_MainTab_Tab3_ScoreHolder_Lose:SetText(RE.Losses);
	if RE.RBG ~= nil then
		--REFlex_MainTab_Tab3_ScoreHolder_RBG:SetText("|cFFFFD100R:|r " .. RE.RBG .. "  |cFFFFD100MMR:|r " .. REFSettings["CurrentMMRBG"]);
		REFlex_MainTab_Tab3_ScoreHolder_RBG:SetText("|cFFFFD100" .. PVP_RATING .. "|r " .. RE.RBG);
	end
	--REFlex_MainTab_Tab3_ScoreHolder_HK1:SetText("HK");
	--REFlex_MainTab_Tab3_ScoreHolder_HK2:SetText(L["Top"] .. ": " .. RE.TopHK);
	--REFlex_MainTab_Tab3_ScoreHolder_HK3:SetText(L["Total"] .. ": " .. RE.SumHK);
	REFlex_MainTab_Tab3_ScoreHolder_KB1:SetText("KB");
	REFlex_MainTab_Tab3_ScoreHolder_KB2:SetText(L["Top"] .. ": " .. RE.TopKB);
	REFlex_MainTab_Tab3_ScoreHolder_KB3:SetText(L["Total"] .. ": " .. RE.SumKB);
	REFlex_MainTab_Tab3_ScoreHolder_Damage1:SetText(DAMAGE);
	REFlex_MainTab_Tab3_ScoreHolder_Damage2:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RE.TopDamage));
	REFlex_MainTab_Tab3_ScoreHolder_Damage3:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RE.SumDamage));
	REFlex_MainTab_Tab3_ScoreHolder_Healing1:SetText(SHOW_COMBAT_HEALING);
	REFlex_MainTab_Tab3_ScoreHolder_Healing2:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RE.TopHealing));
	REFlex_MainTab_Tab3_ScoreHolder_Healing3:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RE.SumHealing));
end

function REFlex_Tab7Show()
	REFlex_MainTab:SetSize(767, 502);
	REFlex_MainTab_MsgGuild:Hide(); 
	REFlex_MainTab_MsgParty:Hide();
	REFlex_MainTab_CSVExport:Hide();
	REFlex_MainTab_Query:Show();

	if RE.InGuild ~= 1 then
		REFlex_MainTab_Tab7_Trigger:Disable();
	else
		RE.GuildRosterUpdate = true;
		GuildRoster();
	end

	local REBGCount = 0;
	if RE.Table9Rdy == nil then
		REBGCount = REFlex_Tab7PlayerGrid(time({["year"] = RE.Tab7Search["F"]["y"], ["month"] = RE.Tab7Search["F"]["m"], ["day"] = RE.Tab7Search["F"]["d"]}), time({["year"] = RE.Tab7Search["T"]["y"], ["month"] = RE.Tab7Search["T"]["m"], ["day"] = RE.Tab7Search["T"]["d"], ["hour"] = 23, ["min"] = 59, ["sec"] = 59}));

		wipe(RE.Tab7TableData);
		RETableCount, RETableI = REFlex_TableCount(RE.Tab7Matrix);
		RE.AvCount, RE.AvRating, RE.AvMMR = 0, 0, 0;
		for j=1, RETableCount do
			local RETempCol = {};
			RETempCol[1] = {
				["value"] = "|cFF" .. RE.ClassColors[RE.Tab7Matrix[RETableI[j]]["Class"]] .. RE.Tab7Matrix[RETableI[j]]["Name"] .. "|r"
			}
			RETempCol[2] = {
				["value"] = date("%H:%M %d.%m.%y", REFDatabase[RE.Tab7Matrix[RETableI[j]]["Time"]]["TimeRaw"])
			}
			RETempCol[3] = {
				["value"] = REFlex_Round(((RE.Tab7Matrix[RETableI[j]]["Attendance"]/REBGCount)*100), 0) .. "%  " .. RE.Tab7Matrix[RETableI[j]]["Attendance"] .. " / " .. REBGCount,
				["color"] = REFlex_TableTab7Attendance,
				["colorargs"] = {(RE.Tab7Matrix[RETableI[j]]["Attendance"]/REBGCount)*100,}
			}
			--RETempCol[4] = {
			--	["value"] = REFlex_TableTab7Field(RE.Tab7Matrix[RETableI[j]]["LastMMR"], "LastMMR")
			--}
			--if RETempCol[4]["value"] ~= "" then
			--	RE.AvMMR = RE.AvMMR + RETempCol[4]["value"];
			--	RE.AvCount = RE.AvCount + 1;
			--end
			--RETempCol[5] = {
			--	["value"] = REFlex_TableTab7Field(RE.Tab7Matrix[RETableI[j]]["DiffMMR"], "DiffMMR")
			--}
			RETempCol[4] = {
				["value"] = REFlex_TableTab7Field(RE.Tab7Matrix[RETableI[j]]["LastRBG"], "LastRBG")
			}
			if RETempCol[4]["value"] ~= "" then
				RE.AvRating = RE.AvRating + RETempCol[4]["value"];
				RE.AvCount = RE.AvCount + 1;
			end
			RETempCol[5] = {
				["value"] = REFlex_TableTab7Field(RE.Tab7Matrix[RETableI[j]]["DiffRBG"], "DiffRBG")
			}
			RETempCol[6] = {
				["value"] = RE.Tab7Matrix[RETableI[j]]["Wins"]
			}
			RETempCol[7] = {
				["value"] = RE.Tab7Matrix[RETableI[j]]["Losses"]
			}
			RETempCol[8] = {
				["value"] = REFlex_Round(((RE.Tab7Matrix[RETableI[j]]["Wins"]/(RE.Tab7Matrix[RETableI[j]]["Wins"]+RE.Tab7Matrix[RETableI[j]]["Losses"]))*100) ,0) .. "%"
			}
			RETempCol[9] = {
				["value"] = REFlex_TableTab7Online(RE.Tab7Matrix[RETableI[j]]["Name"], true)
			}
			RETempCol[10] = {
				["value"] = REFlex_TableTab7Online(RE.Tab7Matrix[RETableI[j]]["Name"], false)
			}
			RETempCol[11] = {
				["value"] = REFDatabase[RE.Tab7Matrix[RETableI[j]]["Time"]]["TimeRaw"]
			}
			RETempCol[12] = {
				["value"] = RE.Tab7Matrix[RETableI[j]]["Attendance"]
			}
			RETempCol[13] = {
				["value"] = REFlex_TableTab7Field(RE.Tab7Matrix[RETableI[j]]["DiffRBG"], "DiffRBGa")
			}
			RETempCol[14] = {
				["value"] = RE.Tab7Matrix[RETableI[j]]["Name"]
			}
			RETempCol[15] = {
				["value"] = REFlex_Round(((RE.Tab7Matrix[RETableI[j]]["Wins"]/(RE.Tab7Matrix[RETableI[j]]["Wins"]+RE.Tab7Matrix[RETableI[j]]["Losses"]))*100) ,0)
			}

			local RETempRow = {
				["cols"] = RETempCol
			}

			table.insert(RE.Tab7TableData, RETempRow);
		end

		RE.MainTable9:SetData(RE.Tab7TableData);
	end

	if RE.Table9Rdy == nil then
		RE.MainTable9:SetFilter(REFlex_Tab_Tab7Filter);
		REFlex_TableClick(9, 1);
		REFlex_TableClick(9, 1);
		RE.Table9Rdy = true;
	end

	RE.Wins, RE.Losses = REFlex_WinLoss(true, RE.TalentTab, nil, time({["year"] = RE.Tab7Search["F"]["y"], ["month"] = RE.Tab7Search["F"]["m"], ["day"] = RE.Tab7Search["F"]["d"]}), time({["year"] = RE.Tab7Search["T"]["y"], ["month"] = RE.Tab7Search["T"]["m"], ["day"] = RE.Tab7Search["T"]["d"], ["hour"] = 23, ["min"] = 59, ["sec"] = 59}), REFSettings["OnlyNew"]); 

	REFlex_MainTab_Tab7_ScoreHolder_Wins:SetText(RE.Wins);
	REFlex_MainTab_Tab7_ScoreHolder_Lose:SetText(RE.Losses);
	if RE.AvCount ~= 0 then
		--REFlex_MainTab_Tab7_ScoreHolder_RBG:SetText("|cFFFFD100" .. GMSURVEYRATING3 .. " R:|r " .. REFlex_Round(RE.AvMMR / RE.AvCount, 0) .. "   |cFFFFD100" .. GMSURVEYRATING3 .. " MMR:|r " .. REFlex_Round(RE.AvRating / RE.AvCount, 0));
		REFlex_MainTab_Tab7_ScoreHolder_RBG:SetText("|cFFFFD100" .. GMSURVEYRATING3 .. " " .. PVP_RATING .. "|r " .. REFlex_Round(RE.AvRating / RE.AvCount, 0));
	else
		--REFlex_MainTab_Tab7_ScoreHolder_RBG:SetText("|cFFFFD100" .. GMSURVEYRATING3 .. " R:|r 0   |cFFFFD100" .. GMSURVEYRATING3 .. " MMR:|r 0");
		REFlex_MainTab_Tab7_ScoreHolder_RBG:SetText("|cFFFFD100" .. GMSURVEYRATING3 .. " " .. PVP_RATING .. "|r 0");
	end
end

function REFlex_Tab4ShowI(j)
	local REMapsTester = false;
	for k=1, #RE.MapsHolder do
		if RE.MapsHolder[k] == REFDatabase[j]["MapName"] then
			REMapsTester = true;
			break
		end
	end

	if not REMapsTester then
		table.insert(RE.MapsHolder, REFDatabase[j]["MapName"]);
	end
end

function REFlex_Tab4Show()
	REFlex_MainTab:SetSize(767, 502);
	REFlex_MainTab_MsgGuild:Hide(); 
	REFlex_MainTab_MsgParty:Hide();
	REFlex_MainTab_CSVExport:Hide();
	REFlex_MainTab_Query:Hide();

	if REFSettings["UNBGSupport"] and (not REFSettings["RBGSupport"]) then
		REFlex_MainTab_Tab4_DropDown:Hide();
		RE.RatedDrop = false;
	elseif REFSettings["RBGSupport"] and (not REFSettings["UNBGSupport"]) then
		RE.RatedDrop = true;
		REFlex_MainTab_Tab4_DropDown:Hide();
	else
		REFlex_MainTab_Tab4_DropDown:Show();
	end

	local REhk = GetPVPLifetimeStats();
	local _, REHonor = GetCurrencyInfo(HONOR_CURRENCY);
	local _, RECP = GetCurrencyInfo(CONQUEST_CURRENCY);
	REFlex_Tab4BarFiller(REhk);
	REFlex_MainTab_Tab4_ScoreHolderSpecial_BarHonor_I:SetValue(REHonor);
	REFlex_MainTab_Tab4_ScoreHolderSpecial_BarHonor_Text:SetText(REHonor .. " / " .. RE.HonorCap);
	if RE.RBGPointsWeek ~= nil then
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_I:SetValue(RECP);
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_Text:SetText(RECP .. " / " .. RE.CPCap .. " - " .. RE.RBGPointsWeek .. " / " .. RE.RBGMaxPointsWeek);
	end

	if RE.BattlegroundReload then
		RE.MapsHolder = {};
		for j=1, #REFDatabase do
			if RE.TalentTab ~= nil then
				if RE.RatedDrop ~= nil then
					if REFDatabase[j]["TalentSet"] == RE.TalentTab and REFDatabase[j]["IsRated"] == RE.RatedDrop then
						if REFDatabase[j]["IsRated"] == false or (REFSettings["OnlyNew"] == false or (REFSettings["OnlyNew"] == true and (REFDatabase[j]["Season"] == RE.CurrentSeason))) then
							REFlex_Tab4ShowI(j);
						end
					end
				else
					if REFDatabase[j]["TalentSet"] == RE.TalentTab then
						REFlex_Tab4ShowI(j);
					end
				end
			else
				if RE.RatedDrop ~= nil then
					if REFDatabase[j]["IsRated"] == RE.RatedDrop then
						if REFDatabase[j]["IsRated"] == false or (REFSettings["OnlyNew"] == false or (REFSettings["OnlyNew"] == true and (REFDatabase[j]["Season"] == RE.CurrentSeason))) then
							REFlex_Tab4ShowI(j);
						end
					end
				else
					REFlex_Tab4ShowI(j);
				end
			end
		end
		table.sort(RE.MapsHolder);
		RE.BattlegroundReload = false;
	end

	local REUsed = 0;
	for j=1, #RE.MapsHolder do
		RE.TopKB, RE.SumKB = REFlex_Find("KB", RE.RatedDrop, RE.TalentTab, RE.MapsHolder[j], REFSettings["OnlyNew"]);
		RE.TopHK, RE.SumHK = REFlex_Find("HK", RE.RatedDrop, RE.TalentTab, RE.MapsHolder[j], REFSettings["OnlyNew"]);
		RE.TopDamage, RE.SumDamage = REFlex_Find("Damage", RE.RatedDrop, RE.TalentTab, RE.MapsHolder[j], REFSettings["OnlyNew"]);
		RE.TopHealing, RE.SumHealing = REFlex_Find("Healing", RE.RatedDrop, RE.TalentTab, RE.MapsHolder[j], REFSettings["OnlyNew"]);
		RE.Wins, RE.Losses = REFlex_WinLoss(RE.RatedDrop, RE.TalentTab, RE.MapsHolder[j], nil, nil, REFSettings["OnlyNew"]); 
		REUsed = REUsed + 1;

		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j]:Show();
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Title"]:SetText("- " .. REFlex_ShortMap(RE.MapsHolder[j]) .. " -");
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Wins"]:SetText(RE.Wins);
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Lose"]:SetText(RE.Losses);
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_HK1"]:SetText("HK");
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_HK2"]:SetText(L["Top"] .. ": " .. RE.TopHK);
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_HK3"]:SetText(L["Total"] .. ": " .. RE.SumHK);
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_KB1"]:SetText("KB");
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_KB2"]:SetText(L["Top"] .. ": " .. RE.TopKB);
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_KB3"]:SetText(L["Total"] .. ": " .. RE.SumKB);
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Damage1"]:SetText(DAMAGE);
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Damage2"]:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RE.TopDamage, 1));
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Damage3"]:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RE.SumDamage, 1));
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Healing1"]:SetText(SHOW_COMBAT_HEALING);
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Healing2"]:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RE.TopHealing, 1));
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Healing3"]:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RE.SumHealing, 1));
	end

	if REUsed < 10 then
		for j=1, 10-REUsed do
			_G["REFlex_MainTab_Tab4_ScoreHolder" .. (j+REUsed)]:Hide();
		end
	end
end

function REFlex_Tab5Show()
	REFlex_MainTab:SetSize(1070, 502);
	REFlex_MainTab_MsgGuild:Show();
	REFlex_MainTab_MsgParty:Show();
	REFlex_MainTab_CSVExport:Show();
	REFlex_MainTab_Query:Hide();
	REFlex_MainTab_Tab5_SearchBox:SetText(NAME .. " / " .. TEAM);

	if REFSettings["ArenasListFirstTime"] then
		StaticPopup_Show("REFLEX_SHIFTINFO");
	end

	if REFDatabaseA[RE.Tab5LastID + 1] ~= nil then
		RE.Tab5LastID = RE.Tab5LastID + 1;
		for j=RE.Tab5LastID, #REFDatabaseA do
			local RETempCol = {};
			RETempCol[1] = {
				["value"] = date("%H:%M %d.%m.%y", REFDatabaseA[j]["TimeRaw"])
			}
			RETempCol[2] = {
				["value"] = REFlex_ShortMap(REFDatabaseA[j]["MapName"]),
				["color"] = REFlex_TableWinColorArena,
				["colorargs"] = {j,}
			}
			RETempCol[3] = {
				["value"] = REFlex_TableTeamArena(false, j)
			}
			RETempCol[4] = {
				["value"] = REFlex_TableTeamArenaRating(false, j)
			}
			RETempCol[5] = {
				["value"] = REFlex_TableTeamArena(true, j)
			}
			RETempCol[6] = {
				["value"] = REFlex_TableTeamArenaRating(true, j)
			}
			RETempCol[7] = {
				["value"] = REFlex_DurationShort(REFDatabaseA[j]["DurationRaw"])
			}
			RETempCol[8] = {
				["value"] = REFlex_NumberClean(REFDatabaseA[j]["Damage"])
			}
			RETempCol[9] = {
				["value"] = REFlex_NumberClean(REFDatabaseA[j]["Healing"])
			}
			RETempCol[10] = {
				["value"] = REFlex_TableRatingMMRArena(REFDatabaseA[j]["PlayerTeam"], j)
			}
			RETempCol[12] = {
				["value"] = REFDatabaseA[j]["TalentSet"]
			}
			RETempCol[13] = {
				["value"] = j
			}
			RETempCol[14] = {
				["bracket"] = REFDatabaseA[j]["Bracket"]
			}
			RETempCol[15] = {
				["value"] = REFlex_ArenaGetEnemyName(j)
			}


			local RETempRow = {
				["cols"] = RETempCol
			}

			table.insert(RE.Tab5TableData, RETempRow);
			RE.Tab5LastID = j;
		end
		
		RE.MainTable5:SetData(RE.Tab5TableData);
	end

	if RE.Table5Rdy == nil then
		RE.MainTable5:SetFilter(REFlex_Tab_Tab5Filter);
		REFlex_TableClick(5, 1);
		RE.Table5Rdy = true;
	end

	RE.TopDamage, RE.SumDamage = REFlex_FindArena("Damage", RE.BracketDrop, RE.TalentTab, nil, REFSettings["OnlyNew"]);
	RE.TopHealing, RE.SumHealing = REFlex_FindArena("Healing", RE.BracketDrop, RE.TalentTab, nil, REFSettings["OnlyNew"]);
	RE.Wins, RE.Losses = REFlex_WinLossArena(RE.BracketDrop, RE.TalentTab, nil, REFSettings["OnlyNew"]); 

	local RERatings = "";
	local team2ID = ArenaTeam_GetTeamSizeID(2);
	local team3ID = ArenaTeam_GetTeamSizeID(3);
	local team5ID = ArenaTeam_GetTeamSizeID(5);
	local player2Rating, player3Rating, player5Rating = nil, nil, nil;
	if team2ID ~= nil then
		_, _, _, _, _, _, _, _, _, _, player2Rating = GetArenaTeam(team2ID);
	end
	if team3ID ~= nil then
		_, _, _, _, _, _, _, _, _, _, player3Rating = GetArenaTeam(team3ID);
	end
	if team5ID ~= nil then
		_, _, _, _, _, _, _, _, _, _, player5Rating = GetArenaTeam(team5ID);
	end

	if player2Rating ~= nil then 
		RERatings = player2Rating;
	else
		RERatings = "-";
	end
	if player3Rating ~= nil then 
		RERatings = RERatings .. " |cFFFFD100/|r " .. player3Rating;
	else
		RERatings = RERatings .. " |cFFFFD100/|r -";
	end
	if player5Rating ~= nil then 
		RERatings = RERatings .. " |cFFFFD100/|r " .. player5Rating;
	else
		RERatings = RERatings .. " |cFFFFD100/|r -";
	end

	REFlex_MainTab_Tab5_ScoreHolder_Wins:SetText(RE.Wins);
	REFlex_MainTab_Tab5_ScoreHolder_Lose:SetText(RE.Losses);
	REFlex_MainTab_Tab5_ScoreHolder_RBG:SetText(RERatings);
	REFlex_MainTab_Tab5_ScoreHolder_KB1:SetText(DAMAGE);
	REFlex_MainTab_Tab5_ScoreHolder_KB2:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RE.TopDamage));
	REFlex_MainTab_Tab5_ScoreHolder_KB3:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RE.SumDamage));
	REFlex_MainTab_Tab5_ScoreHolder_HK1:SetText(SHOW_COMBAT_HEALING);
	REFlex_MainTab_Tab5_ScoreHolder_HK2:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RE.TopHealing));
	REFlex_MainTab_Tab5_ScoreHolder_HK3:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RE.SumHealing));
end

function REFlex_Tab6ShowI(j)
	local REMapsTester = false;
	for k=1, #RE.MapsHolderArena do
		if RE.MapsHolderArena[k] == REFDatabaseA[j]["MapName"] then
			REMapsTester = true;
			break
		end
	end

	if not REMapsTester then
		table.insert(RE.MapsHolderArena, REFDatabaseA[j]["MapName"]);
	end
end

function REFlex_Tab6Show()
	REFlex_MainTab:SetSize(1070, 502);
	REFlex_MainTab_MsgGuild:Hide(); 
	REFlex_MainTab_MsgParty:Hide();
	REFlex_MainTab_CSVExport:Hide();
	REFlex_MainTab_Query:Hide();

	if RE.ArenaReloadAlpha then
		RE.MapsHolderArena = {};
		for j=1, #REFDatabaseA do
			if RE.TalentTab ~= nil then
				if RE.BracketDropTab6 ~= nil then
					if REFDatabaseA[j]["TalentSet"] == RE.TalentTab and REFDatabaseA[j]["Bracket"] == RE.BracketDropTab6 then
						if REFSettings["OnlyNew"] == false or (REFSettings["OnlyNew"] == true and (REFDatabaseA[j]["Season"] == RE.CurrentSeason)) then
							REFlex_Tab6ShowI(j);
						end
					end
				else
					if REFDatabaseA[j]["TalentSet"] == RE.TalentTab then
						if REFSettings["OnlyNew"] == false or (REFSettings["OnlyNew"] == true and (REFDatabaseA[j]["Season"] == RE.CurrentSeason)) then
							REFlex_Tab6ShowI(j);
						end
					end
				end
			else
				if RE.BracketDropTab6 ~= nil then
					if REFDatabaseA[j]["Bracket"] == RE.BracketDropTab6 then
						if REFSettings["OnlyNew"] == false or (REFSettings["OnlyNew"] == true and (REFDatabaseA[j]["Season"] == RE.CurrentSeason)) then
							REFlex_Tab6ShowI(j);
						end
					end
				else
					if REFSettings["OnlyNew"] == false or (REFSettings["OnlyNew"] == true and (REFDatabaseA[j]["Season"] == RE.CurrentSeason)) then
						REFlex_Tab6ShowI(j);
					end
				end
			end
		end
		table.sort(RE.MapsHolderArena);
	end

	local _, REHonor = GetCurrencyInfo(HONOR_CURRENCY);
	local _, RECP = GetCurrencyInfo(CONQUEST_CURRENCY);
	REFlex_MainTab_Tab6_ScoreHolderSpecial_BarHonor_I:SetValue(REHonor);
	REFlex_MainTab_Tab6_ScoreHolderSpecial_BarHonor_Text:SetText(REHonor .. " / ".. RE.HonorCap);
	if RE.RBGPointsWeek ~= nil then
		REFlex_MainTab_Tab6_ScoreHolderSpecial_BarCP_I:SetValue(RECP);
		REFlex_MainTab_Tab6_ScoreHolderSpecial_BarCP_Text:SetText(RECP .. " / " .. RE.CPCap .. " - " .. RE.RBGPointsWeek .. " / " .. RE.RBGMaxPointsWeek);
	end

	local REUsed = 0;
	for j=1, #RE.MapsHolderArena do
		RE.TopDamage, RE.SumDamage = REFlex_FindArena("Damage", RE.BracketDropTab6, RE.TalentTab, RE.MapsHolderArena[j], REFSettings["OnlyNew"]);
		RE.TopHealing, RE.SumHealing = REFlex_FindArena("Healing", RE.BracketDropTab6, RE.TalentTab, RE.MapsHolderArena[j], REFSettings["OnlyNew"]);
		RE.Wins, RE.Losses = REFlex_WinLossArena(RE.BracketDropTab6, RE.TalentTab, RE.MapsHolderArena[j], REFSettings["OnlyNew"]); 
		REUsed = REUsed + 1;

		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j]:Show();
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Title"]:SetText("- " .. REFlex_ShortMap(RE.MapsHolderArena[j]) .. " -");
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Wins"]:SetText(RE.Wins);
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Lose"]:SetText(RE.Losses);
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Damage1"]:SetText(DAMAGE);
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Damage2"]:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RE.TopDamage));
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Damage3"]:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RE.SumDamage));
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Healing1"]:SetText(SHOW_COMBAT_HEALING);
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Healing2"]:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RE.TopHealing));
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Healing3"]:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RE.SumHealing));
	end

	if REUsed < 6 then
		for j=1, 6-REUsed do
			_G["REFlex_MainTab_Tab6_ScoreHolder" .. (j+REUsed)]:Hide();
		end
	end

	local RETalent = "";
	local REBracket = "";
	if RE.TalentTab ~= nil then
		RETalent = tostring(RE.TalentTab);
	end
	if RE.BracketDropTab6 ~= nil then
		REBracket = tostring(RE.BracketDropTab6);
	end
	
	if RE.ArenaReloadAlpha then
		wipe(RE.Tab6TableData1);
		wipe(RE.Tab6TableData2);
		wipe(RE.Tab6TableData3);

		local RETableCount, RETableI = REFlex_TableCount(RE.ArenaTeamsSpec);
		for j=1, RETableCount do
			if (REBracket == "" and RE.ArenaTeamsSpec[RETableI[j]]["Win" .. RETalent] > 0 and RE.ArenaTeamsSpec[RETableI[j]]["Loss" .. RETalent] > 0) or (RE.ArenaTeamsSpec[RETableI[j]]["Bracket"] == REBracket and RE.ArenaTeamsSpec[RETableI[j]]["Win" .. RETalent] > 0 and RE.ArenaTeamsSpec[RETableI[j]]["Loss" .. RETalent] > 0) then
				local RETempCol = {};
				RETempCol[1] = {
					["value"] = REFlex_TableTeamArenaTab6(RE.ArenaTeamsSpec[RETableI[j]]["Team"]),
				}
				RETempCol[2] = {
					["value"] = REFlex_Round(RE.ArenaTeamsSpec[RETableI[j]]["Win" .. RETalent]/RE.ArenaTeamsSpec[RETableI[j]]["Loss" .. RETalent], 2)
				}
				RETempCol[3] = {
					["value"] = RE.ArenaTeamsSpec[RETableI[j]]["Win" .. RETalent],
					["color"] = { ["r"] = 0, ["g"] = 1, ["b"] = 0, ["a"] = 1 },
				}
				RETempCol[4] = {
					["value"] = RE.ArenaTeamsSpec[RETableI[j]]["Loss" .. RETalent],
					["color"] = { ["r"] = 1, ["g"] = 0, ["b"] = 0, ["a"] = 1 },
				}

				local RETempRow = {
					["cols"] = RETempCol
				}

				table.insert(RE.Tab6TableData1, RETempRow);
			end
		end

		for j=1, RETableCount do
			if (REBracket == "" and RE.ArenaTeamsSpec[RETableI[j]]["Total" .. RETalent] > 0) or (RE.ArenaTeamsSpec[RETableI[j]]["Bracket"] == REBracket and RE.ArenaTeamsSpec[RETableI[j]]["Total" .. RETalent] > 0) then
				local RETempCol = {};
				RETempCol[1] = {
					["value"] = REFlex_TableTeamArenaTab6(RE.ArenaTeamsSpec[RETableI[j]]["Team"]),
				}
				RETempCol[2] = {
					["value"] = RE.ArenaTeamsSpec[RETableI[j]]["Total" .. RETalent],
				}
				RETempCol[3] = {
					["value"] = RE.ArenaTeamsSpec[RETableI[j]]["Win"  .. RETalent],
					["color"] = { ["r"] = 0, ["g"] = 1, ["b"] = 0, ["a"] = 1 },
				}
				RETempCol[4] = {
					["value"] = RE.ArenaTeamsSpec[RETableI[j]]["Loss"  .. RETalent],
					["color"] = { ["r"] = 1, ["g"] = 0, ["b"] = 0, ["a"] = 1 },
				}

				local RETempRow = {
					["cols"] = RETempCol
				}

				table.insert(RE.Tab6TableData2, RETempRow);
			end
		end

		for j=1, RETableCount do
			if (REBracket == "" and RE.ArenaTeamsSpec[RETableI[j]]["Loss" .. RETalent] > 0 and RE.ArenaTeamsSpec[RETableI[j]]["Win" .. RETalent] > 0) or (RE.ArenaTeamsSpec[RETableI[j]]["Bracket"] == REBracket and RE.ArenaTeamsSpec[RETableI[j]]["Loss" .. RETalent] > 0 and RE.ArenaTeamsSpec[RETableI[j]]["Win" .. RETalent] > 0) then
				local RETempCol = {};
				RETempCol[1] = {
					["value"] = REFlex_TableTeamArenaTab6(RE.ArenaTeamsSpec[RETableI[j]]["Team"]),
				}
				RETempCol[2] = {
					["value"] = REFlex_Round(RE.ArenaTeamsSpec[RETableI[j]]["Win" .. RETalent]/RE.ArenaTeamsSpec[RETableI[j]]["Loss" .. RETalent], 2)
				}
				RETempCol[3] = {
					["value"] = RE.ArenaTeamsSpec[RETableI[j]]["Loss" .. RETalent],
					["color"] = { ["r"] = 1, ["g"] = 0, ["b"] = 0, ["a"] = 1 },
				}
				RETempCol[4] = {
					["value"] = RE.ArenaTeamsSpec[RETableI[j]]["Win" .. RETalent],
					["color"] = { ["r"] = 0, ["g"] = 1, ["b"] = 0, ["a"] = 1 },
				}

				local RETempRow = {
					["cols"] = RETempCol
				}

				table.insert(RE.Tab6TableData3, RETempRow);
			end
		end

		RE.MainTable6:SetData(RE.Tab6TableData1);
		RE.MainTable7:SetData(RE.Tab6TableData2);
		RE.MainTable8:SetData(RE.Tab6TableData3);
		RE.ArenaReloadAlpha = false;
	end

	if RE.Table6Rdy == nil then
		REFlex_TableClick(6, 2);
		RE.Table6Rdy = true;
	end

	if RE.Table7Rdy == nil then
		REFlex_TableClick(7, 2);
		RE.Table7Rdy = true;
	end

	if RE.Table8Rdy == nil then
		REFlex_TableClick(8, 2);
		RE.Table8Rdy = true;
	end
end
-- 

-- Tooltips subsection
function REFlex_ShowBGDetails_OnEnter(OptionArray)
	local Me = OptionArray[1];
	local DatabaseID = OptionArray[2];
	local Table = OptionArray[3];
	local RETooltip = RE.QTip:Acquire("REBGDetailsToolTip", 3, "CENTER", "CENTER", "CENTER");
	Me.tooltip = RETooltip;

	RETooltip:AddHeader("", "|cFF74D06C" .. TUTORIAL_TITLE19 .. "|r", "");
	RETooltip:AddLine("|cFF00A9FF" .. FACTION_ALLIANCE .. ":|r " .. REFDatabase[DatabaseID]["AllianceNum"], "", "|cFFFF141D" .. FACTION_HORDE .. ":|r " .. REFDatabase[DatabaseID]["HordeNum"]);
	RETooltip:AddLine();
	RETooltip:AddSeparator();
	RETooltip:AddLine();
	RETooltip:AddHeader("", "|cFF74D06C" .. L["Place"] .. "|r", "");
	RETooltip:SetColumnLayout(3, "LEFT", "CENTER", "CENTER");
	RETooltip:AddLine("", FACTION, ALL);
	if REFDatabase[DatabaseID]["IsRated"] then
		RETooltip:AddLine("KB", REFDatabase[DatabaseID]["PlaceFactionKB"], REFDatabase[DatabaseID]["PlaceKB"]);
		RETooltip:AddLine(DAMAGE, REFDatabase[DatabaseID]["PlaceFactionDamage"], REFDatabase[DatabaseID]["PlaceDamage"]); 
		RETooltip:AddLine(SHOW_COMBAT_HEALING, REFDatabase[DatabaseID]["PlaceFactionHealing"], REFDatabase[DatabaseID]["PlaceHealing"]);
		RETooltip:SetLineColor(9, 1, 1, 1, 0.5);
	else
		RETooltip:AddLine("KB", REFDatabase[DatabaseID]["PlaceFactionKB"], REFDatabase[DatabaseID]["PlaceKB"]);
		RETooltip:AddLine("HK", REFDatabase[DatabaseID]["PlaceFactionHK"], REFDatabase[DatabaseID]["PlaceHK"]); 
		RETooltip:AddLine(DAMAGE, REFDatabase[DatabaseID]["PlaceFactionDamage"], REFDatabase[DatabaseID]["PlaceDamage"]); 
		RETooltip:AddLine(SHOW_COMBAT_HEALING, REFDatabase[DatabaseID]["PlaceFactionHealing"], REFDatabase[DatabaseID]["PlaceHealing"]);
		RETooltip:SetLineColor(9, 1, 1, 1, 0.5);
		RETooltip:SetLineColor(11, 1, 1, 1, 0.5);
		RETooltip:AddLine(HONOR, REFDatabase[DatabaseID]["PlaceFactionHonor"], REFDatabase[DatabaseID]["PlaceHonor"]);
	end
	if Table == "REMainTable3" then
		RETooltip:AddSeparator();
		RETooltip:AddLine();
		RETooltip:AddLine("", HONOR .. ": " .. REFDatabase[DatabaseID]["Honor"], "");
	end
	if REFDatabase[DatabaseID]["MapInfo"] ~= nil then
		RETooltip:AddLine();
		RETooltip:AddSeparator();
		RETooltip:AddLine();
		if REFDatabase[DatabaseID]["MapInfo"] == "AlteracValley" then
			RETooltip:AddLine("|T" .. RE.BGSpecialFields["AlteracValley"][1] .. ":22:22|t: " .. REFDatabase[DatabaseID]["SpecialFields"][1], "", "|T" .. RE.BGSpecialFields["AlteracValley"][2] .. ":22:22|t: " .. REFDatabase[DatabaseID]["SpecialFields"][2]);
			RETooltip:AddLine("|T" .. RE.BGSpecialFields["AlteracValley"][3] .. ":22:22|t: " .. REFDatabase[DatabaseID]["SpecialFields"][3], "", "|T" .. RE.BGSpecialFields["AlteracValley"][4] .. ":22:22|t: " .. REFDatabase[DatabaseID]["SpecialFields"][4]);
		elseif REFDatabase[DatabaseID]["MapInfo"] == "WarsongGulch" or REFDatabase[DatabaseID]["MapInfo"] == "TwinPeaks" then
			RETooltip:AddLine("|T" .. RE.BGSpecialFields["CTF"][1] .. ":22:22|t: " .. REFDatabase[DatabaseID]["SpecialFields"][1], "", "|T" .. RE.BGSpecialFields["CTF"][2] .. ":22:22|t: " .. REFDatabase[DatabaseID]["SpecialFields"][2]);
		elseif REFDatabase[DatabaseID]["MapInfo"] == "NetherstormArena" then
			RETooltip:AddLine("|T" .. RE.BGSpecialFields["NetherstormArena"][1] .. ":22:22|t: " .. REFDatabase[DatabaseID]["SpecialFields"][1], "", "");
		else
			RETooltip:AddLine("|T" .. RE.BGSpecialFields["Other"][1] .. ":22:22|t: " .. REFDatabase[DatabaseID]["SpecialFields"][1], "", "|T" .. RE.BGSpecialFields["Other"][2] .. ":22:22|t: " .. REFDatabase[DatabaseID]["SpecialFields"][2]);
		end
	end

	RETooltip:SetBackdrop(RE.TooltipBackdrop);
	RETooltip:SmartAnchorTo(Me);
	RETooltip:Show();

	if IsShiftKeyDown() == 1 and IsControlKeyDown() ~= 1 and Table == "REMainTable3" then
		local Me = OptionArray[1];
		local DatabaseID = OptionArray[2];
		local RETooltipF = RE.QTip:Acquire("RERBGRosterToolTipFriend", 5, "CENTER", "CENTER", "CENTER", "CENTER", "CENTER");
		Me.tooltip1 = RETooltipF;
		local RETooltipE = RE.QTip:Acquire("RERBGRosterToolTipEnemy", 5, "CENTER", "CENTER", "CENTER", "CENTER", "CENTER");
		Me.tooltip2 = RETooltipE;

		local Friend, Enemy = "", "";
		TotalDamageF, TotalHealingF, TotalDamageE, TotalHealingE = 0, 0, 0, 0 ;
		local New = true;
		if RE.Faction == "Horde" then
			Friend = "RBGHordeTeam";
			Enemy = "RBGAllianceTeam";
		else
			Enemy = "RBGHordeTeam";
			Friend = "RBGAllianceTeam";
		end
		
		if REFDatabase[DatabaseID][Friend] ~= nil then
			if REFDatabase[DatabaseID][Friend][1]["Damage"] == nil then
				New = false;
			end

			if New then
				RETooltipF:AddLine();
				RETooltipF:AddHeader("", "   - " .. GetRealmName() .. " -", "", "   |cFF74D06C" .. DAMAGE .. "|r  ", "  |cFF74D06C" .. SHOW_COMBAT_HEALING .. "|r   ");
				RETooltipF:AddLine();
				RETooltipF:AddSeparator(3);
				RETooltipF:AddLine();
				RETooltipE:AddLine();
				RETooltipE:AddHeader("", "   - " .. REFlex_GetEnemyRealmName(DatabaseID, false) .. " -", "", "   |cFF74D06C" .. DAMAGE .. "|r  ", "  |cFF74D06C" .. SHOW_COMBAT_HEALING .. "|r   ");
				RETooltipE:AddLine();
				RETooltipE:AddSeparator(3);
				RETooltipE:AddLine();
			else
				RETooltipF:AddLine();
				RETooltipF:AddHeader("", "- " .. GetRealmName() .. " -");
				RETooltipF:AddLine();
				RETooltipF:AddSeparator(3);
				RETooltipF:AddLine();
				RETooltipE:AddLine();
				RETooltipE:AddHeader("", "- " .. REFlex_GetEnemyRealmName(DatabaseID, false) .. " -");
				RETooltipE:AddLine();
				RETooltipE:AddSeparator(3);
				RETooltipE:AddLine();
			end

			for i=1, 10 do
				local EnemyString, FriendString = "", "";

				if REFDatabase[DatabaseID][Friend][i] ~= nil then
					if New then
						FriendString = "  |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:30:30:0:0:256:256:" .. RE.ClassIconCoords[REFDatabase[DatabaseID][Friend][i]["classToken"]][1]*256 .. ":" .. RE.ClassIconCoords[REFDatabase[DatabaseID][Friend][i]["classToken"]][2]*256 .. ":".. RE.ClassIconCoords[REFDatabase[DatabaseID][Friend][i]["classToken"]][3]*256 ..":" .. RE.ClassIconCoords[REFDatabase[DatabaseID][Friend][i]["classToken"]][4]*256 .."|t%   |cFF" .. RE.ClassColors[REFDatabase[DatabaseID][Friend][i]["classToken"]] .. REFlex_NameClean(REFDatabase[DatabaseID][Friend][i]["name"]) .. "|r%   |cFF" .. RE.ClassColors[REFDatabase[DatabaseID][Friend][i]["classToken"]] .. REFlex_SpecTranslate(REFDatabase[DatabaseID][Friend][i]["classToken"], REFDatabase[DatabaseID][Friend][i]["Build"]) .. "|r%" .. REFlex_NumberClean(REFDatabase[DatabaseID][Friend][i]["Damage"]) .. "%" .. REFlex_NumberClean(REFDatabase[DatabaseID][Friend][i]["Healing"]);
						TotalDamageF = TotalDamageF + REFDatabase[DatabaseID][Friend][i]["Damage"];
						TotalHealingF = TotalHealingF + REFDatabase[DatabaseID][Friend][i]["Healing"];
					else
						FriendString = "  |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:30:30:0:0:256:256:" .. RE.ClassIconCoords[REFDatabase[DatabaseID][Friend][i]["classToken"]][1]*256 .. ":" .. RE.ClassIconCoords[REFDatabase[DatabaseID][Friend][i]["classToken"]][2]*256 .. ":".. RE.ClassIconCoords[REFDatabase[DatabaseID][Friend][i]["classToken"]][3]*256 ..":" .. RE.ClassIconCoords[REFDatabase[DatabaseID][Friend][i]["classToken"]][4]*256 .."|t%   |cFF" .. RE.ClassColors[REFDatabase[DatabaseID][Friend][i]["classToken"]] .. REFlex_NameClean(REFDatabase[DatabaseID][Friend][i]["name"]) .. "|r   ";
					end
				end
				if REFDatabase[DatabaseID][Enemy][i] ~= nil then
					if New then
						EnemyString = "  |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:30:30:0:0:256:256:" .. RE.ClassIconCoords[REFDatabase[DatabaseID][Enemy][i]["classToken"]][1]*256 .. ":" .. RE.ClassIconCoords[REFDatabase[DatabaseID][Enemy][i]["classToken"]][2]*256 .. ":".. RE.ClassIconCoords[REFDatabase[DatabaseID][Enemy][i]["classToken"]][3]*256 ..":" .. RE.ClassIconCoords[REFDatabase[DatabaseID][Enemy][i]["classToken"]][4]*256 .."|t%   |cFF" .. RE.ClassColors[REFDatabase[DatabaseID][Enemy][i]["classToken"]] .. REFlex_NameClean(REFDatabase[DatabaseID][Enemy][i]["name"]) .. "|r%   |cFF" .. RE.ClassColors[REFDatabase[DatabaseID][Enemy][i]["classToken"]] .. REFlex_SpecTranslate(REFDatabase[DatabaseID][Enemy][i]["classToken"], REFDatabase[DatabaseID][Enemy][i]["Build"]) .. "|r%" .. REFlex_NumberClean(REFDatabase[DatabaseID][Enemy][i]["Damage"]) .. "%" .. REFlex_NumberClean(REFDatabase[DatabaseID][Enemy][i]["Healing"]);
						TotalDamageE = TotalDamageE + REFDatabase[DatabaseID][Enemy][i]["Damage"];
						TotalHealingE = TotalHealingE + REFDatabase[DatabaseID][Enemy][i]["Healing"];
					else
						EnemyString = "  |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:30:30:0:0:256:256:" .. RE.ClassIconCoords[REFDatabase[DatabaseID][Enemy][i]["classToken"]][1]*256 .. ":" .. RE.ClassIconCoords[REFDatabase[DatabaseID][Enemy][i]["classToken"]][2]*256 .. ":".. RE.ClassIconCoords[REFDatabase[DatabaseID][Enemy][i]["classToken"]][3]*256 ..":" .. RE.ClassIconCoords[REFDatabase[DatabaseID][Enemy][i]["classToken"]][4]*256 .."|t%   |cFF" .. RE.ClassColors[REFDatabase[DatabaseID][Enemy][i]["classToken"]] .. REFlex_NameClean(REFDatabase[DatabaseID][Enemy][i]["name"]) .. "|r   ";
					end
				end

				RE.FriendRosterStringTable[i] = FriendString;
				RE.EnemyRosterStringTable[i] = EnemyString;
			end

			table.sort(RE.FriendRosterStringTable);
			table.sort(RE.EnemyRosterStringTable);

			for i=1, 10 do
				if RE.FriendRosterStringTable[i] ~= nil then
					local RETempFriend = { strsplit("%", RE.FriendRosterStringTable[i]) };
					RETooltipF:AddLine(RETempFriend[1], RETempFriend[2], RETempFriend[3], RETempFriend[4], RETempFriend[5]);
				end
				if RE.EnemyRosterStringTable[i] ~= nil then
					local RETempEnemy = { strsplit("%", RE.EnemyRosterStringTable[i]) };
					RETooltipE:AddLine(RETempEnemy[1], RETempEnemy[2], RETempEnemy[3], RETempEnemy[4], RETempEnemy[5]);
				end
			end

			RETooltipF:SetBackdrop(RE.TooltipBackdrop);
			RETooltipE:SetBackdrop(RE.TooltipBackdrop);
			if New then
				RETooltipF:AddLine();
				RETooltipF:AddSeparator(3);
				RETooltipF:AddLine();
				RETooltipF:AddLine("", "" , "",  "|cFFFF141D" .. REFlex_NumberClean(TotalDamageF) .. "|r" , "|cFF00ff00" .. REFlex_NumberClean(TotalHealingF) .. "|r");
				RETooltipF:AddLine();
				RETooltipE:AddLine();
				RETooltipE:AddSeparator(3);
				RETooltipE:AddLine();
				RETooltipE:AddLine("", "" , "",  "|cFFFF141D" .. REFlex_NumberClean(TotalDamageE) .. "|r" , "|cFF00ff00" .. REFlex_NumberClean(TotalHealingE) .. "|r");
				RETooltipE:AddLine();
			end

			RETooltipF:ClearAllPoints();
			RETooltipF:SetClampedToScreen(true);
			RETooltipF:SetPoint("RIGHT", Me.tooltip, "LEFT", -10, 0);
			RETooltipF:Show();
			RETooltipE:ClearAllPoints();
			RETooltipE:SetClampedToScreen(true);
			RETooltipE:SetPoint("LEFT", Me.tooltip, "RIGHT", 10, 0);
			RETooltipE:Show();
		end
	end
end

function REFlex_ShowArenaDetails_OnEnter(OptionArray)
	local Me = OptionArray[1];
	local DatabaseID = OptionArray[2];
	local RETooltip = RE.QTip:Acquire("REArenaDetailsToolTip", 7, "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER");
	Me.tooltip = RETooltip;

	local REEnemyNames, REEnemyID, REFriendNames, REFriendID, Team, TeamE = REFlex_ArenaTeamHash(DatabaseID);
	local REEnemyTeamID = table.concat(REEnemyNames);

	RETooltip:SetHeaderFont(SystemFont_Huge1);
	RETooltip:AddHeader("", "", "", "|cFF00CC00" .. RE.ArenaTeams[REEnemyTeamID]["Win"] .. "|r - |cFFCC0000" .. RE.ArenaTeams[REEnemyTeamID]["Loss"] .. "|r", "", "", "");

	local FriendRatingChange = REFDatabaseA[DatabaseID][Team .. "TeamRatingChange"];
	local EnemyRatingChange = REFDatabaseA[DatabaseID][TeamE .. "TeamRatingChange"];
	local FriendTeamName = REFDatabaseA[DatabaseID][Team .. "TeamName"];
	local EnemyTeamName = REFDatabaseA[DatabaseID][TeamE .. "TeamName"];
	if REFDatabaseA[DatabaseID][TeamE .. "TeamRating"] < 0 then
		EnemyRatingChange = 0;
	end
	RETooltip:SetHeaderFont(GameTooltipHeader);
	RETooltip:AddHeader("", "[|cFF" .. REFlex_ToolTipRatingColorArena(FriendRatingChange) .. FriendRatingChange .. "|r]", "", "", "", "[|cFF" .. REFlex_ToolTipRatingColorArena(EnemyRatingChange) .. EnemyRatingChange .. "|r]","");
	RETooltip:AddLine();
	RETooltip:AddHeader("", "|cFFFFD100- " .. FriendTeamName .. " -|r", "", "", "", "|cFFFFD100- " .. EnemyTeamName .. " -|r", "");
	if IsShiftKeyDown() == 1 and IsControlKeyDown() ~= 1 then
		RETooltip:AddHeader("", "|cFFFFD100- " .. GetRealmName() .. " -|r", "", "", "", "|cFFFFD100- " .. REFlex_GetEnemyRealmName(REFDatabaseA[DatabaseID][TeamE .. "Team"], true) .. " -|r", "");
	end
	RETooltip:AddLine();
	RETooltip:AddSeparator(3);
	RETooltip:AddLine();

	for i=1, REFDatabaseA[DatabaseID]["Bracket"] do
		local RaceClassCell, NameCell, BuildCell, EnemyRaceClassCell, EnemyNameCell, EnemyBuildCell = "", "", "", "", "", "";

		if REFriendID[i] ~= nil then
			local ClassToken = REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["classToken"];
			local RaceToken = nil;
			if REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Race"] ~= nil then
				RaceToken = string.upper(REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Race"] .. "_MALE");
			end
			if RE.RaceIconCoords[RaceToken] ~= nil then
				RaceClassCell = "   |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:30:30:0:0:512:256:" .. RE.RaceIconCoords[RaceToken][1]*512 .. ":" .. RE.RaceIconCoords[RaceToken][2]*512 .. ":".. RE.RaceIconCoords[RaceToken][3]*256 ..":" .. RE.RaceIconCoords[RaceToken][4]*256 .. "|t  |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:30:30:0:0:256:256:" .. RE.ClassIconCoords[ClassToken][1]*256 .. ":" .. RE.ClassIconCoords[ClassToken][2]*256 .. ":".. RE.ClassIconCoords[ClassToken][3]*256 ..":" .. RE.ClassIconCoords[ClassToken][4]*256 .."|t"
			else
				RaceClassCell = "   |TInterface\\Icons\\INV_Misc_QuestionMark:30:30|t  |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:30:30:0:0:256:256:" .. RE.ClassIconCoords[ClassToken][1]*256 .. ":" .. RE.ClassIconCoords[ClassToken][2]*256 .. ":".. RE.ClassIconCoords[ClassToken][3]*256 ..":" .. RE.ClassIconCoords[ClassToken][4]*256 .."|t"
			end

			NameCell = "|cFF" .. RE.ClassColors[ClassToken] .. REFlex_NameClean(REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Name"]) .. "|r";

			if REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Build"] ~= nil then
				BuildCell = "|cFF" .. RE.ClassColors[ClassToken] .. REFlex_SpecTranslate(ClassToken, REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Build"]) .. "|r";
			else
				BuildCell = "|cFF" .. RE.ClassColors[ClassToken] .. UNKNOWN .. "|r";
			end
		end

		if REEnemyID[i] ~= nil then
			local ClassToken = REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["classToken"];
			local RaceToken = nil;
			if REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Race"] ~= nil then
				RaceToken = string.upper(REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Race"] .. "_MALE");
			end
			if RE.RaceIconCoords[RaceToken] ~= nil then
				EnemyRaceClassCell = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:30:30:0:0:512:256:" .. RE.RaceIconCoords[RaceToken][1]*512 .. ":" .. RE.RaceIconCoords[RaceToken][2]*512 .. ":".. RE.RaceIconCoords[RaceToken][3]*256 ..":" .. RE.RaceIconCoords[RaceToken][4]*256 .. "|t  |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:30:30:0:0:256:256:" .. RE.ClassIconCoords[ClassToken][1]*256 .. ":" .. RE.ClassIconCoords[ClassToken][2]*256 .. ":".. RE.ClassIconCoords[ClassToken][3]*256 ..":" .. RE.ClassIconCoords[ClassToken][4]*256 .."|t"
			else
				EnemyRaceClassCell = "|TInterface\\Icons\\INV_Misc_QuestionMark:30:30|t  |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:30:30:0:0:256:256:" .. RE.ClassIconCoords[ClassToken][1]*256 .. ":" .. RE.ClassIconCoords[ClassToken][2]*256 .. ":".. RE.ClassIconCoords[ClassToken][3]*256 ..":" .. RE.ClassIconCoords[ClassToken][4]*256 .."|t"
			end

			EnemyNameCell = "|cFF" .. RE.ClassColors[ClassToken] .. REFlex_NameClean(REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Name"]) .. "|r";

			if REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Build"] ~= nil then
				EnemyBuildCell = "|cFF" .. RE.ClassColors[ClassToken] .. REFlex_SpecTranslate(ClassToken, REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Build"]) .. "|r";
			else
				EnemyBuildCell = "|cFF" .. RE.ClassColors[ClassToken] .. UNKNOWN .. "|r";
			end
		end

		RETooltip:AddLine(RaceClassCell, NameCell, BuildCell, "", EnemyRaceClassCell, EnemyNameCell, EnemyBuildCell);	
	end

	if IsShiftKeyDown() == 1 and IsControlKeyDown() ~= 1 then
		local RETotalDamage, RETotalHealing, RETotalDamageEnemy, RETotalHealingEnemy = 0, 0, 0, 0;

		RETooltip:AddLine();
		RETooltip:AddSeparator(3);
		RETooltip:AddLine();
		RETooltip:AddHeader("", "|cFF74D06C" .. DAMAGE .. "|r", "|cFF74D06C" .. SHOW_COMBAT_HEALING .. "|r", "", "", "|cFF74D06C" .. DAMAGE .. "|r", "|cFF74D06C" .. SHOW_COMBAT_HEALING .. "|r");
		RETooltip:AddLine();
		for i=1, REFDatabaseA[DatabaseID]["Bracket"] do
			local NameCell, DamageCell, HealingCell, EnemyNameCell, EnemyDamageCell, EnemyHealingCell = "", "", "", "", "", "";

			if REFriendID[i] ~= nil then
				RETotalDamage = RETotalDamage + REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Damage"];
				RETotalHealing = RETotalHealing + REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Healing"];
				local ClassToken = REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["classToken"];
				if REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["PreMMR"] ~= nil then
					NameCell = "   |cFF" .. RE.ClassColors[ClassToken] .. REFlex_NameClean(REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Name"]) .. "|r"
					if not (REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["PreMMR"] == 0 and REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["MMRChange"] == 0) then
						NameCell = NameCell .. "\n   [" .. REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["PreMMR"] .. "] [|cFF" .. REFlex_ToolTipRatingColorArena(REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["MMRChange"]) .. REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["MMRChange"] .. "|r]";
					end
				else
					NameCell = "   |cFF" .. RE.ClassColors[ClassToken] .. REFlex_NameClean(REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Name"]) .. "|r";
				end
				DamageCell = REFlex_NumberClean(REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Damage"]);
				HealingCell = REFlex_NumberClean(REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Healing"]);
			end

			if REEnemyID[i] ~= nil then
				RETotalDamageEnemy = RETotalDamageEnemy + REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Damage"];
				RETotalHealingEnemy = RETotalHealingEnemy + REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Healing"];
				local ClassToken = REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["classToken"];
				if REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["PreMMR"] ~= nil then
					EnemyNameCell = "|cFF" .. RE.ClassColors[ClassToken] .. REFlex_NameClean(REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Name"]) .. "|r"
					if not (REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["PreMMR"] == 0 and REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["MMRChange"] == 0) then
						EnemyNameCell = EnemyNameCell .. "\n[" .. REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["PreMMR"] .. "] [|cFF" .. REFlex_ToolTipRatingColorArena(REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["MMRChange"]) .. REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["MMRChange"] .. "|r]";
					end
				else
					EnemyNameCell = "|cFF" .. RE.ClassColors[ClassToken] .. REFlex_NameClean(REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Name"]) .. "|r";
				end
				EnemyDamageCell = REFlex_NumberClean(REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Damage"]);
				EnemyHealingCell = REFlex_NumberClean(REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Healing"]);
			end

			RETooltip:AddLine(NameCell, DamageCell, HealingCell, "", EnemyNameCell, EnemyDamageCell, EnemyHealingCell);
		end

		RETooltip:AddLine();
		RETooltip:AddSeparator(3);
		RETooltip:AddLine();
		RETooltip:AddLine("", "|cFFFF141D" .. REFlex_NumberClean(RETotalDamage) .. "|r", "|cFF00ff00" .. REFlex_NumberClean(RETotalHealing) .. "|r", "", "", "|cFFFF141D" .. REFlex_NumberClean(RETotalDamageEnemy) .. "|r", "|cFF00ff00" .. REFlex_NumberClean(RETotalHealingEnemy) .. "|r");
		RETooltip:AddLine();
		RETooltip:AddLine();
	end

	RETooltip:SetBackdrop(RE.TooltipBackdrop);
	RETooltip:SmartAnchorTo(Me);
	RETooltip:Show();
end

function REFlex_ShowDetails_OnLeave(self)
	RE.QTip:Release(self.tooltip)
	self.tooltip = nil
end

function REFlex_ShowDetails_OnLeaveRBG(self)
	RE.QTip:Release(self.tooltip)
	self.tooltip = nil
	RE.QTip:Release(self.tooltip1)
	self.tooltip1 = nil
	RE.QTip:Release(self.tooltip2)
	self.tooltip2 = nil
end
--

function REFlex_BGEnd()
	REFlex_Frame:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE");	
	RE.CurrentSeason = GetCurrentArenaSeason();
	local REWinner = GetBattlefieldWinner();
	local REArena = IsActiveBattlefieldArena();
	local _, REZoneType = IsInInstance();
	local REBGRated = IsRatedBattleground();
	if REWinner ~= nil and RE.SecondTime ~= true and REArena == nil and REZoneType == "pvp" and ((REFSettings["UNBGSupport"] and REBGRated ~= true) or (REFSettings["RBGSupport"] and REBGRated)) then
		SendAddonMessage("REFlex", RE.AddonVersionCheck, "INSTANCE_CHAT");

		SetMapToCurrentZone();
		RE.Map = GetMapNameByID(GetCurrentMapAreaID());
		local REPlayerName = GetUnitName("player");
		local RETalentGroup = GetActiveSpecGroup(false, false);
		RE.BGPlayers = GetNumBattlefieldScores();
		local REMyFaction = GetBattlefieldArenaFaction();
		local REArenaSeason = RE.CurrentSeason;
		RE.BGTimeRaw = math.floor(GetBattlefieldInstanceRunTime() / 1000);
		local RETimeRaw = time();
		local RESpecialFields = {};
		local REHordeMMR, REAllianceMMR;

		if RE.FactionNum ~= REMyFaction then
			if REWinner == 1 then
				REWinSide = FACTION_HORDE;
				REWinSidePrint = "\124cFFFF141D" .. FACTION_HORDE;
			else
				REWinSide = FACTION_ALLIANCE;
				REWinSidePrint = "\124cFF00A9FF" .. FACTION_ALLIANCE;
			end
		else
			if REWinner == 1 then
				REWinSide = FACTION_ALLIANCE;
				REWinSidePrint = "\124cFF00A9FF" .. FACTION_ALLIANCE;
			else
				REWinSide = FACTION_HORDE;
				REWinSidePrint = "\124cFFFF141D" .. FACTION_HORDE;
			end
		end

		local REName = "";
		local i = 1;
		while REName ~= REPlayerName do
			REName = GetBattlefieldScore(i);
			RE.PlayerID = i;
			i = i + 1;
			if i == 100 then
				break
			end
		end

		RE.playerName, RE.killingBlows, RE.honorKills, _, RE.honorGained, _, _, _, RE.classToken, RE.damageDone, RE.healingDone, RE.BGRating, RE.BGRatingChange, RE.BGPreMatchMMR, RE.BGMMRChange, RE.playerBuild = GetBattlefieldScore(RE.PlayerID);
		if RE.classToken == nil or RE.classToken == "" then
			_, _, _, _, _, _, _, _, RE.classToken = GetBattlefieldScore(RE.PlayerID);
		end
		if RE.classToken == nil or RE.classToken == "" then
			RE.classToken = "WARRIOR";
		end
		RE.playerBuild = REFlex_SpecTranslate(RE.classToken, RE.playerBuild);
		RE.PlaceKB, RE.PlaceHK, RE.PlaceHonor, RE.PlaceDamage, RE.PlaceHealing = RE.BGPlayers, RE.BGPlayers, RE.BGPlayers, RE.BGPlayers, RE.BGPlayers;
		local REHordeNum, REAllianceNum = 0, 0;
		local REAverageHorde, REAverageAlliance = 0, 0;
		local RERBGHorde, RERBGAlly = nil, nil;

		if RE.Faction == "Horde" then
			REHordeNum = 1;
			if REBGRated then
				RERBGHorde, RERBGAlly = {}, {};
				if RE.FactionNum ~= REMyFaction then
					_, _, _, REAllianceMMR = GetBattlefieldTeamInfo(REMyFaction);
					_, _, _, REHordeMMR = GetBattlefieldTeamInfo((REMyFaction+1)%2);
				else
					_, _, _, REHordeMMR = GetBattlefieldTeamInfo(REMyFaction);
					_, _, _, REAllianceMMR = GetBattlefieldTeamInfo((REMyFaction+1)%2);
				end
				local REPLayerdataTemp = {["name"] = RE.playerName, ["classToken"] = RE.classToken, ["BGRating"] = RE.BGRating, ["BGRatingChange"] = RE.BGRatingChange, ["PreMMR"] = RE.BGPreMatchMMR, ["MMRChange"] = RE.BGMMRChange, ["Damage"] = RE.damageDone, ["Healing"] = RE.healingDone, ["Build"] = RE.playerBuild}
				table.insert(RERBGHorde, REPLayerdataTemp);
				REFSettings["CurrentMMRBG"] = RE.BGPreMatchMMR + RE.BGMMRChange;
			end
		else
			REAllianceNum = 1;
			if REBGRated then
				RERBGHorde, RERBGAlly = {}, {};
				if RE.FactionNum ~= REMyFaction then
					_, _, _, REHordeMMR = GetBattlefieldTeamInfo(REMyFaction);
					_, _, _, REAllianceMMR = GetBattlefieldTeamInfo((REMyFaction+1)%2);
				else
					_, _, _, REAllianceMMR = GetBattlefieldTeamInfo(REMyFaction);
					_, _, _, REHordeMMR = GetBattlefieldTeamInfo((REMyFaction+1)%2);
				end
				local REPLayerdataTemp = {["name"] = RE.playerName, ["classToken"] = RE.classToken, ["BGRating"] = RE.BGRating, ["BGRatingChange"] = RE.BGRatingChange, ["PreMMR"] = RE.BGPreMatchMMR, ["MMRChange"] = RE.BGMMRChange, ["Damage"] = RE.damageDone, ["Healing"] = RE.healingDone, ["Build"] = RE.playerBuild}
				table.insert(RERBGAlly, REPLayerdataTemp);
				REFSettings["CurrentMMRBG"] = RE.BGPreMatchMMR + RE.BGMMRChange;
			end
		end

		for j=1, RE.BGPlayers do
			if j ~= RE.PlayerID then
				local name, killingBlowsTemp, honorKillsTemp, _, honorGainedTemp, factionTemp, _, _, classToken, damageDoneTemp, healingDoneTemp, ratingTemp, ratingChangeTemp, preMMRTemp, changeMMRTemp, buildTemp = GetBattlefieldScore(j);
				if classToken == nil or classToken == "" then
					_, _, _, _, _, _, _, _, classToken = GetBattlefieldScore(j);
				end
				if classToken == nil or classToken == "" then
					classToken = "WARRIOR";
				end
				buildTemp = REFlex_SpecTranslate(classToken, buildTemp);
				if RE.killingBlows >= killingBlowsTemp then
					RE.PlaceKB = RE.PlaceKB - 1;
				end
				if RE.honorKills >= honorKillsTemp then
					RE.PlaceHK = RE.PlaceHK - 1;
				end
				if RE.honorGained >= honorGainedTemp then
					RE.PlaceHonor = RE.PlaceHonor - 1;
				end
				if RE.damageDone >= damageDoneTemp then
					RE.PlaceDamage = RE.PlaceDamage - 1;
				end
				if RE.healingDone >= healingDoneTemp then
					RE.PlaceHealing = RE.PlaceHealing - 1;
				end

				if RE.FactionNum ~= REMyFaction then
					if factionTemp == 0 then
						REAllianceNum = REAllianceNum + 1;
						REAverageAlliance = REAverageAlliance + ratingTemp;
						if REBGRated then
							local REPLayerdataTemp = {["name"] = name, ["classToken"] = classToken, ["BGRating"] = ratingTemp, ["BGRatingChange"] = ratingChangeTemp, ["PreMMR"] = preMMRTemp, ["MMRChange"] = changeMMRTemp, ["Damage"] = damageDoneTemp, ["Healing"] = healingDoneTemp, ["Build"] = buildTemp}
							table.insert(RERBGAlly, REPLayerdataTemp);
						end
					else
						REHordeNum = REHordeNum + 1;
						REAverageHorde = REAverageHorde + ratingTemp;
						if REBGRated then
							local REPLayerdataTemp = {["name"] = name, ["classToken"] = classToken, ["BGRating"] = ratingTemp, ["BGRatingChange"] = ratingChangeTemp, ["PreMMR"] = preMMRTemp, ["MMRChange"] = changeMMRTemp, ["Damage"] = damageDoneTemp, ["Healing"] = healingDoneTemp, ["Build"] = buildTemp}
							table.insert(RERBGHorde, REPLayerdataTemp);
						end
					end
				else
					if factionTemp == 0 then
						REHordeNum = REHordeNum + 1;
						REAverageHorde = REAverageHorde + ratingTemp;
						if REBGRated then
							local REPLayerdataTemp = {["name"] = name, ["classToken"] = classToken, ["BGRating"] = ratingTemp, ["BGRatingChange"] = ratingChangeTemp, ["PreMMR"] = preMMRTemp, ["MMRChange"] = changeMMRTemp, ["Damage"] = damageDoneTemp, ["Healing"] = healingDoneTemp, ["Build"] = buildTemp}
							table.insert(RERBGHorde, REPLayerdataTemp);
						end
					else
						REAllianceNum = REAllianceNum + 1;
						REAverageAlliance = REAverageAlliance + ratingTemp;
						if REBGRated then
							local REPLayerdataTemp = {["name"] = name, ["classToken"] = classToken, ["BGRating"] = ratingTemp, ["BGRatingChange"] = ratingChangeTemp, ["PreMMR"] = preMMRTemp, ["MMRChange"] = changeMMRTemp, ["Damage"] = damageDoneTemp, ["Healing"] = healingDoneTemp, ["Build"] = buildTemp}
							table.insert(RERBGAlly, REPLayerdataTemp);
						end
					end
				end
			end
		end

		if REBGRated then
			REFlex_ScoreTab:ClearAllPoints();
			REFlex_ScoreTab:SetPoint("BOTTOMRIGHT", -6, -33);
			REFlex_ScoreTab:Show();

			RE.TopKB = REFlex_Find("KB", true, RETalentGroup, nil, REFSettings["OnlyNew"]);
			RE.TopHK = REFlex_Find("HK", true, RETalentGroup, nil, REFSettings["OnlyNew"]);
			RE.TopDamage = REFlex_Find("Damage", true, RETalentGroup, nil, REFSettings["OnlyNew"]);
			RE.TopHealing = REFlex_Find("Healing", true, RETalentGroup, nil, REFSettings["OnlyNew"]);

			if RE.Faction == "Horde" then
				REBGHordeRating = REFlex_Round((REAverageHorde + RE.BGRating) / REHordeNum, 0);
				REBGAllyRating = REFlex_Round(REAverageAlliance / REAllianceNum, 0);
			else
				REBGHordeRating = REFlex_Round(REAverageHorde / REHordeNum, 0);
				REBGAllyRating = REFlex_Round((REAverageAlliance + RE.BGRating) / REAllianceNum, 0);
			end
		else
			REFlex_ScoreTab:ClearAllPoints();
			REFlex_ScoreTab:SetPoint("BOTTOMRIGHT", -6, 2);
			REFlex_ScoreTab:Show();

			RE.TopKB = REFlex_Find("KB", false, RETalentGroup, nil, REFSettings["OnlyNew"]);
			RE.TopHK = REFlex_Find("HK", false, RETalentGroup, nil, REFSettings["OnlyNew"]);
			RE.TopDamage = REFlex_Find("Damage", false, RETalentGroup, nil, REFSettings["OnlyNew"]);
			RE.TopHealing = REFlex_Find("Healing", false, RETalentGroup, nil, REFSettings["OnlyNew"]);

			REArenaSeason = nil;
			RE.BGRating = nil;
			RE.BGRatingChange = nil;
			REBGHordeRating = nil;
			REBGAllyRating = nil;
		end

		if RE.Faction == "Horde" then
			RE.BGPlayersF = REHordeNum;
		else
			RE.BGPlayersF = REAllianceNum;
		end

		local REPlaceKBF, REPlaceHKF, REPlaceHonorF, REPlaceDamageF, REPlaceHealingF = RE.BGPlayersF, RE.BGPlayersF, RE.BGPlayersF, RE.BGPlayersF, RE.BGPlayersF;

		for jj=1, RE.BGPlayers do
			local _, killingBlowsTemp, honorKillsTemp, _, honorGainedTemp, factionTemp, _, _, _, damageDoneTemp, healingDoneTemp = GetBattlefieldScore(jj);
			if jj ~= RE.PlayerID and factionTemp == REMyFaction then
				if RE.killingBlows >= killingBlowsTemp then
					REPlaceKBF = REPlaceKBF - 1;
				end
				if RE.honorKills >= honorKillsTemp then
					REPlaceHKF = REPlaceHKF - 1;
				end
				if RE.honorGained >= honorGainedTemp then
					REPlaceHonorF = REPlaceHonorF - 1;
				end
				if RE.damageDone >= damageDoneTemp then
					REPlaceDamageF = REPlaceDamageF - 1;
				end
				if RE.healingDone >= healingDoneTemp then
					REPlaceHealingF = REPlaceHealingF - 1;
				end
			end
		end

		SetMapToCurrentZone();
		local REMapInfo = GetMapInfo();
		if REMapInfo == "AlteracValley" then
			RESpecialFields[1] = GetBattlefieldStatData(RE.PlayerID, 1);
			RESpecialFields[2] = GetBattlefieldStatData(RE.PlayerID, 2);
			RESpecialFields[3] = GetBattlefieldStatData(RE.PlayerID, 3);
			RESpecialFields[4] = GetBattlefieldStatData(RE.PlayerID, 4);
			RESpecialFields[5] = GetBattlefieldStatData(RE.PlayerID, 5);
		elseif REMapInfo == "WarsongGulch" or REMapInfo == "TwinPeaks" then
			RESpecialFields[1] = GetBattlefieldStatData(RE.PlayerID, 1);
			RESpecialFields[2] = GetBattlefieldStatData(RE.PlayerID, 2);	
		elseif REMapInfo == "GilneasBattleground2" or REMapInfo == "IsleofConquest" or REMapInfo == "ArathiBasin" or REMapInfo == "StrandoftheAncients" then
			RESpecialFields[1] = GetBattlefieldStatData(RE.PlayerID, 1);
			RESpecialFields[2] = GetBattlefieldStatData(RE.PlayerID, 2);
		elseif REMapInfo == "NetherstormArena" then
			RESpecialFields[1] = GetBattlefieldStatData(RE.PlayerID, 1);
		end

		RE.SecondTime = true;
		RE.BattlegroundReload = true;

		if REBGRated then
			print("\n");
			print("\124cFF74D06C[REFlex]\124r \124cFF555555-\124r " .. RE.Map .. " \124cFF555555-\124r " .. WIN .. ": " .. REWinSidePrint .. " \124cFF555555-\124r " .. REFlex_DurationShort(RE.BGTimeRaw));
			print("\124cFFC5F3BCKB:\124r " .. RE.killingBlows .. " (" .. RE.PlaceKB .. "/" .. RE.BGPlayers .. ") \124cFF555555* \124cFFC5F3BCH:\124r " .. RE.honorGained);
			print("\124cFFC5F3BC" .. DAMAGE .. ":\124r " .. REFlex_NumberClean(RE.damageDone) .. " (" .. RE.PlaceDamage .. "/" .. RE.BGPlayers .. ") \124cFF555555* \124cFFC5F3BC" .. SHOW_COMBAT_HEALING .. ":\124r " .. REFlex_NumberClean(RE.healingDone) .. " (" .. RE.PlaceHealing .. "/" .. RE.BGPlayers .. ")");

			RE.Table9Rdy = nil;
		else
			print("\n");
			print("\124cFF74D06C[REFlex]\124r \124cFF555555-\124r " .. RE.Map .. " \124cFF555555-\124r " .. WIN .. ": " .. REWinSidePrint .. " \124cFF555555-\124r " .. REFlex_DurationShort(RE.BGTimeRaw));
			print("\124cFFC5F3BCKB:\124r " .. RE.killingBlows .. " (" .. RE.PlaceKB .. "/" .. RE.BGPlayers .. ") \124cFF555555* \124cFFC5F3BCHK:\124r " .. RE.honorKills .. " (" .. RE.PlaceHK .. "/" .. RE.BGPlayers .. ") \124cFF555555* \124cFFC5F3BCH:\124r " .. RE.honorGained .. " (" .. RE.PlaceHonor .. "/" .. RE.BGPlayers .. ")");
			print("\124cFFC5F3BC" .. DAMAGE .. ":\124r " .. REFlex_NumberClean(RE.damageDone) .. " (" .. RE.PlaceDamage .. "/" .. RE.BGPlayers .. ") \124cFF555555* \124cFFC5F3BC" .. SHOW_COMBAT_HEALING .. ":\124r " .. REFlex_NumberClean(RE.healingDone) .. " (" .. RE.PlaceHealing .. "/" .. RE.BGPlayers .. ")");
		end
		if RE.killingBlows > RE.TopKB then
			print("\124cFF74D06C" .. string.upper(NEW) .. " " .. string.upper(KILLING_BLOWS) .. " " .. L["RECORD"] ..":\124r " .. RE.killingBlows .. " \124cFF555555-\124r ".. L["Old"] .. ": " .. RE.TopKB);
		end
		if RE.honorKills > RE.TopHK and REBGRated == false then
			print("\124cFF74D06C" .. string.upper(NEW) .. " " .. string.upper(L["Honor Kills"]) .. " " .. L["RECORD"] ..":\124r " .. RE.honorKills .. " \124cFF555555-\124r ".. L["Old"] .. ": " .. RE.TopHK);
		end
		if RE.damageDone > RE.TopDamage then
			print("\124cFF74D06C" .. string.upper(NEW) .. " " .. string.upper(DAMAGE) .. " " .. L["RECORD"] ..":\124r " .. REFlex_NumberClean(RE.damageDone) .. " \124cFF555555-\124r ".. L["Old"] .. ": " .. REFlex_NumberClean(RE.TopDamage));
		end
		if RE.healingDone > RE.TopHealing then
			print("\124cFF74D06C" .. string.upper(NEW) .. " " .. string.upper(SHOW_COMBAT_HEALING) .. " " .. L["RECORD"] ..":\124r " .. REFlex_NumberClean(RE.healingDone) .. " \124cFF555555-\124r ".. L["Old"] .. ": " .. REFlex_NumberClean(RE.TopHealing));
		end
		print("\n");

		local REBGData = { DataVersion=RE.DataVersion, SpecialFields=RESpecialFields, RBGHordeTeam=RERBGHorde, RBGAllianceTeam=RERBGAlly, Season=REArenaSeason,MapName=RE.Map, MapInfo=REMapInfo, Damage=RE.damageDone, Healing=RE.healingDone, KB=RE.killingBlows, HK=RE.honorKills, Honor=RE.honorGained, TalentSet=RETalentGroup, HordeMMR=REHordeMMR, AllianceMMR=REAllianceMMR, PreMMR=RE.BGPreMatchMMR, MMRChange=RE.BGMMRChange, Winner=REWinSide, HordeNum=REHordeNum, AllianceNum=REAllianceNum, DurationRaw=RE.BGTimeRaw, TimeRaw=RETimeRaw, IsRated=REBGRated, Rating=RE.BGRating, RatingChange=RE.BGRatingChange, HordeRating=REBGHordeRating, AllianceRating=REBGAllyRating, PlaceKB=RE.PlaceKB, PlaceHK=RE.PlaceHK, PlaceHonor=RE.PlaceHonor, PlaceDamage=RE.PlaceDamage, PlaceHealing=RE.PlaceHealing, PlaceFactionKB=REPlaceKBF, PlaceFactionHK=REPlaceHKF, PlaceFactionHonor=REPlaceHonorF, PlaceFactionDamage=REPlaceDamageF, PlaceFactionHealing=REPlaceHealingF };
		table.insert(REFDatabase, REBGData);
	end
	REFlex_Frame:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");	
end

function REFlex_ArenaEnd()
	local REWinner = GetBattlefieldWinner();
	local REArena, REArenaRegistered = IsActiveBattlefieldArena();
	local _, REZoneType = IsInInstance();
	if REWinner ~= nil and RE.SecondTime ~= true and REArena == 1 and REArenaRegistered == 1 and REZoneType == "arena" and REFSettings["ArenaSupport"] then
		RE.CurrentSeason = GetCurrentArenaSeason();
		local REWinSide = REWinner;
		local REMap = GetRealZoneText();
		local REPlayerName = GetUnitName("player");
		local RETalentGroup = GetActiveSpecGroup(false, false);
		local REArenaSeason = RE.CurrentSeason;
		local REBGPlayers = GetNumBattlefieldScores();
		local BGTimeRaw = math.floor(GetBattlefieldInstanceRunTime() / 1000);
		local RETimeRaw = time();

		local REGreenTeamName, REGreenTeamRating, REGreenNewTeamRating, REGreenMMR = GetBattlefieldTeamInfo(0);
		local REGoldTeamName, REGoldTeamRating, REGoldNewTeamRating, REGoldMMR = GetBattlefieldTeamInfo(1);

		local RETeamGreen, RETeamGold = {}, {};
		local RELocalDamage, RELocalHealing, RELocalKB, RELocalPreMMR, RELocalMMRChange = 0, 0, 0, 0, 0;

		local REPLayerTemp = {};
		local REPlayerTeam, RELocalDamage, RELocalHealing, RELocalKB = "", "", "", "";
		
		local REArenaRaces = {};
		for i=1, MAX_ARENA_ENEMIES do
			if GetUnitName("arena"..i, true) then
				local REName = table.concat({ strsplit(" ", GetUnitName("arena"..i, true), 3) });
				_, REArenaRaces[REName] = UnitRace("arena"..i);
			end
		end
		for i=1, MAX_ARENA_ENEMIES-1 do
			if GetUnitName("party"..i, true) then
				local REName = table.concat({ strsplit(" ", GetUnitName("party"..i, true), 3) });
				_, REArenaRaces[REName] = UnitRace("party"..i);
			end
		end
		_, REArenaRaces[GetUnitName("player", true)] = UnitRace("player");
		
		for j=1, REBGPlayers do
			local REPlayerTemp = {};
			local REPName, REKillingBlows, _, _, _, REFaction, _, _, REClassToken, REDamageDone, REHealingDone, _, _, REpreMatchMmr, REmmrChange, REBuild = GetBattlefieldScore(j);
			if REClassToken == nil or REClassToken == "" then
				_, _, _, _, _, _, _, _, REClassToken = GetBattlefieldScore(j);
			end
			if REClassToken == nil or REClassToken == "" then
				REClassToken = "WARRIOR";
			end
			REBuild = REFlex_SpecTranslate(REClassToken, REBuild);
			local RERace = REArenaRaces[REPName]; 
			REPLayerTemp = {Name=REPName, KB=REKillingBlows, Race=RERace, classToken=REClassToken, Build=REBuild, Damage=REDamageDone, Healing=REHealingDone, PreMMR=REpreMatchMmr, MMRChange=REmmrChange};

			if REPName == REPlayerName then
				REPlayerTeam = REFaction;
				RELocalDamage = REDamageDone;
				RELocalHealing = REHealingDone;
				RELocalKB = REKillingBlows;
				RELocalPreMMR = REpreMatchMmr;
				RELocalMMRChange = REmmrChange;
				REFSettings["CurrentMMR"] = RELocalPreMMR + RELocalMMRChange;
			end

			if REFaction == 1 then
				table.insert(RETeamGold, REPLayerTemp);
			else
				table.insert(RETeamGreen, REPLayerTemp);
			end
		end

		-- Workaround - GetBattlefieldStatus() sometimes return incorrect data
		local REBracket = 0;
		for i=1, 3 do
			local teamName, teamSize = GetArenaTeam(i);
			if (teamName == REGreenTeamName) or (teamName == REGoldTeamName) then
				REBracket = teamSize;
				break
			end
		end

		RE.SecondTime = true;
		RE.ArenaReload = true;

		local REBGData = { DataVersion=RE.DataVersion, MapName=REMap, TalentSet=RETalentGroup, Winner=REWinSide, Damage=RELocalDamage, Healing=RELocalHealing, KB=RELocalKB, PreMMR=RELocalPreMMR, MMRChange=RELocalMMRChange, DurationRaw=BGTimeRaw, TimeRaw=RETimeRaw, Season=REArenaSeason, Bracket=REBracket, PlayerTeam=REPlayerTeam, GreenTeamName=REGreenTeamName, GreenTeamMMR=REGreenMMR, GreenTeamRating=REGreenNewTeamRating, GreenTeamRatingChange=(REGreenNewTeamRating - REGreenTeamRating), GoldTeamName=REGoldTeamName, GoldTeamMMR=REGoldMMR, GoldTeamRating=REGoldNewTeamRating, GoldTeamRatingChange=(REGoldNewTeamRating - REGoldTeamRating), GreenTeam=RETeamGreen, GoldTeam=RETeamGold};
		table.insert(REFDatabaseA, REBGData);
	end
end
-- ***