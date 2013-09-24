local REScrollingTable = LibStub("ScrollingTable");
local REShefkiTimer = LibStub("LibShefkiTimer-1.0");
local REQTip = LibStub('LibQTip-1.0');

local L = REFlexLocale;
local REModuleTranslation = {
	["KillingBlows"] = KILLING_BLOWS,
	["HonorKills"] = L["Honor Kills"],
	["Damage"] = DAMAGE,
	["Healing"] = SHOW_COMBAT_HEALING,
	["Deaths"] = DEATHS,
	["KDRatio"] = L["K/D Ratio"],
	["Honor"] = HONOR 
};

local REDataVersion = 4;
local REAddonVersion = "v0.8.1";
local REArenaBuilds = {};
local REArenaTeams = {};
local REArenaRaces = {};
local REArenaTeamsSpec = {["2"] = {}, ["3"] = {}, ["5"] = {}, ["All"] = {}, ["AllNoTalent"] = {}};
local REPartyArenaCheck = 0;

local REClassIconCoords = {
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
};
local RERaceIconCoords = {
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
};
local REClassColors = {
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
};

local REBuildRecognition = {      
	-- WARRIOR
	[GetSpellInfo(12294)]	= L["Arms"],			-- Mortal Strike
	[GetSpellInfo(46924)]	= L["Arms"],			-- Bladestorm
	[GetSpellInfo(56638)]	= L["Arms"],			-- Taste for Blood
	[GetSpellInfo(64976)]	= L["Arms"],			-- Juggernaut
	[GetSpellInfo(85388)]	= L["Arms"],			-- Throwdown
	[GetSpellInfo(85730)]	= L["Arms"],			-- Deadly Calm
	[GetSpellInfo(12328)]	= L["Arms"],			-- Sweeping Strikes
	[GetSpellInfo(23881)]	= L["Fury"],			-- Bloodthirst
	[GetSpellInfo(29801)]	= L["Fury"],			-- Rampage
	[GetSpellInfo(12323)]	= L["Fury"],			-- Piercing Howl
	[GetSpellInfo(60970)]	= L["Fury"],			-- Heroic Fury
	[GetSpellInfo(12292)]	= L["Fury"],			-- Death Wish
	[GetSpellInfo(85288)]	= L["Fury"],			-- Raging Blow
	[GetSpellInfo(12809)]	= L["Protection"],		-- Concussion Blow
	[GetSpellInfo(23922)]	= L["Protection"],		-- Shield Slam
	[GetSpellInfo(50227)]	= L["Protection"],		-- Sword and Board
	[GetSpellInfo(12975)]	= L["Protection"],		-- Last Stand
	[GetSpellInfo(50720)]	= L["Protection"],		-- Vigilance
	[GetSpellInfo(46968)]	= L["Protection"],		-- Shockwave
	-- PALADIN
	[GetSpellInfo(31935)]	= L["Protection"],		-- Avenger's Shield
	[GetSpellInfo(70940)]	= L["Protection"],		-- Divine Guardian
	[GetSpellInfo(31850)]	= L["Protection"],		-- Ardent Defender
	[GetSpellInfo(53595)]	= L["Protection"],		-- Hammer of the Righteous
	[GetSpellInfo(53600)]	= L["Protection"],		-- Shield of the Righteous
	[GetSpellInfo(20473)]	= L["Holy"],			-- Holy Shock
	[GetSpellInfo(31842)]	= L["Holy"],			-- Divine Favor
	[GetSpellInfo(53563)]	= L["Holy"],			-- Beacon of Light
	[GetSpellInfo(31821)]	= L["Holy"],			-- Aura Mastery
	[GetSpellInfo(85222)]	= L["Holy"],			-- Light of Dawn
	[GetSpellInfo(68020)]	= L["Retribution"],		-- Seal of Command
	[GetSpellInfo(35395)]	= L["Retribution"],		-- Crusader Strike
	[GetSpellInfo(85285)]	= L["Retribution"],		-- Rebuke
	[GetSpellInfo(85696)]	= L["Retribution"],		-- Zealotry
	[GetSpellInfo(53385)]	= L["Retribution"],		-- Divine Storm
	[GetSpellInfo(20066)]	= L["Retribution"],		-- Repentance
	[GetSpellInfo(85256)]	= L["Retribution"],		-- Templar's Verdict
	-- ROGUE
	[GetSpellInfo(1329)]	= L["Assassination"],	   	-- Mutilate
	[GetSpellInfo(79140)]	= L["Assassination"],	   	-- Vendetta
	[GetSpellInfo(14177)]	= L["Assassination"],	   	-- Cold Blood
	[GetSpellInfo(51690)]	= L["Combat"],			-- Killing Spree
	[GetSpellInfo(13877)]	= L["Combat"],			-- Blade Flurry
	[GetSpellInfo(13750)]	= L["Combat"],			-- Adrenaline Rush
	[GetSpellInfo(84617)]	= L["Combat"],			-- Revealing Strike
	[GetSpellInfo(16511)]	= L["Subtlety"],		-- Hemorrhage
	[GetSpellInfo(36554)]	= L["Subtlety"],		-- Shadowstep
	[GetSpellInfo(31223)]	= L["Subtlety"],		-- Master of Subtlety
	[GetSpellInfo(14185)]	= L["Subtlety"],		-- Preparation
	[GetSpellInfo(51713)]	= L["Subtlety"],		-- Shadow Dance
	-- PRIEST	
	[GetSpellInfo(47540)]	= L["Discipline"],		-- Penance
	[GetSpellInfo(10060)]	= L["Discipline"],		-- Power Infusion
	[GetSpellInfo(33206)]	= L["Discipline"],		-- Pain Suppression
	[GetSpellInfo(52795)]	= L["Discipline"],		-- Borrowed Time
	[GetSpellInfo(57472)]	= L["Discipline"],		-- Renewed Hope
	--[GetSpellInfo(47517)]	= L["Discipline"],		-- Grace
	[GetSpellInfo(89485)]	= L["Discipline"],		-- Inner Focus
	[GetSpellInfo(34861)]	= L["Holy"],			-- Circle of Healing
	[GetSpellInfo(14751)]	= L["Holy"],			-- Chakra
	[GetSpellInfo(47788)]	= L["Holy"],			-- Guardian Spirit
	[GetSpellInfo(88625)]	= L["Holy"],			-- Holy Word: Chastise
	[GetSpellInfo(19236)]	= L["Holy"],			-- Desperate Prayer
	[GetSpellInfo(15487)]	= L["Shadow"],			-- Silence
	[GetSpellInfo(34914)]	= L["Shadow"],			-- Vampiric Touch	
	[GetSpellInfo(15407)]	= L["Shadow"],			-- Mind Flay		
	[GetSpellInfo(15473)]	= L["Shadow"],			-- Shadowform
	[GetSpellInfo(15286)]	= L["Shadow"],			-- Vampiric Embrace
	[GetSpellInfo(64044)]	= L["Shadow"],			-- Psychic Horror
	[GetSpellInfo(47585)]	= L["Shadow"],			-- Dispersion
	-- DEATHKNIGHT
	[GetSpellInfo(55050)]	= L["Blood"],			-- Heart Strike
	[GetSpellInfo(49016)]	= L["Blood"],			-- Hysteria
	[GetSpellInfo(53138)]	= L["Blood"],			-- Abomination's Might
	[GetSpellInfo(55233)]	= L["Blood"],			-- Vampiric Blood
	[GetSpellInfo(49222)]	= L["Blood"],			-- Bone Shield
	[GetSpellInfo(49203)]	= L["Frost"],			-- Hungering Cold
	[GetSpellInfo(49143)]	= L["Frost"],			-- Frost Strike
	[GetSpellInfo(49184)]	= L["Frost"],			-- Howling Blast
	[GetSpellInfo(51271)]	= L["Frost"],			-- Pillar of Frost
	[GetSpellInfo(55610)]	= L["Frost"],			-- Imp. Icy Talons
	[GetSpellInfo(55090)]	= L["Unholy"],			-- Scourge Strike
	[GetSpellInfo(49016)]	= L["Unholy"],			-- Unholy Frenzy
	[GetSpellInfo(51052)]	= L["Unholy"],			-- Anti-Magic Zone
	[GetSpellInfo(49206)]	= L["Unholy"],			-- Summon Gargoyle
	[GetSpellInfo(63560)]	= L["Unholy"],			-- Dark Transformation
	-- MAGE
	[GetSpellInfo(44425)]	= L["Arcane"],			-- Arcane Barrage
	[GetSpellInfo(12043)]	= L["Arcane"],			-- Presence of Mind
	[GetSpellInfo(31589)]	= L["Arcane"],			-- Slow
	[GetSpellInfo(54646)]	= L["Arcane"],			-- Focus Magic
	[GetSpellInfo(12042)]	= L["Arcane"],			-- Arcane Power
	[GetSpellInfo(44457)]	= L["Fire"],		   	-- Living Bomb
	[GetSpellInfo(31661)]	= L["Fire"],		   	-- Dragon's Breath
	[GetSpellInfo(11366)]	= L["Fire"],		   	-- Pyroblast
	[GetSpellInfo(11129)]	= L["Fire"],			-- Combustion
	[GetSpellInfo(11113)]	= L["Fire"],			-- Blast Wave
	[GetSpellInfo(44572)]	= L["Frost"],		   	-- Deep Freeze
	[GetSpellInfo(31687)]	= L["Frost"],		   	-- Summon Water Elemental
	[GetSpellInfo(11426)]	= L["Frost"],			-- Ice Barrier	
	[GetSpellInfo(12472)]	= L["Frost"],		   	-- Icy Veins
	[GetSpellInfo(11958)]	= L["Frost"],			-- Cold Snap
	-- WARLOCK
	[GetSpellInfo(48181)]	= L["Affliction"],		-- Haunt
	[GetSpellInfo(30108)]	= L["Affliction"],		-- Unstable Affliction
	[GetSpellInfo(18223)]	= L["Affliction"],		-- Curse of Exhaustion
	[GetSpellInfo(86121)]	= L["Affliction"],		-- Soul Swap
	[GetSpellInfo(59672)]	= L["Demonology"],		-- Metamorphosis
	[GetSpellInfo(30146)]	= L["Demonology"],		-- Summon Felguard
	[GetSpellInfo(71521)]	= L["Demonology"],		-- Hand of Gul'dan
	[GetSpellInfo(47193)]	= L["Demonology"],		-- Demonic Empowerment
	[GetSpellInfo(50769)]	= L["Destruction"],		-- Chaos Bolt
	[GetSpellInfo(30283)]	= L["Destruction"],		-- Shadowfury
	[GetSpellInfo(30299)]	= L["Destruction"],		-- Nether Protection
	[GetSpellInfo(17962)]	= L["Destruction"],		-- Conflagrate
	[GetSpellInfo(80240)]	= L["Destruction"],		-- Bane of Havoc
	[GetSpellInfo(17877)]	= L["Destruction"],		-- Shadowburn
	-- SHAMAN
	[GetSpellInfo(51490)]	= L["Elemental"],		-- Thunderstorm
	[GetSpellInfo(16166)]	= L["Elemental"],		-- Elemental Mastery
	[GetSpellInfo(51470)]	= L["Elemental"],		-- Elemental Oath
	[GetSpellInfo(61882)]	= L["Elemental"],		-- Earthquake
	[GetSpellInfo(30802)]	= L["Enhancement"],		-- Unleashed Rage
	[GetSpellInfo(51533)]	= L["Enhancement"],		-- Feral Spirit
	[GetSpellInfo(30823)]	= L["Enhancement"],		-- Shamanistic Rage
	[GetSpellInfo(17364)]	= L["Enhancement"],		-- Stormstrike
	[GetSpellInfo(60103)]	= L["Enhancement"],		-- Lava Lash
	[GetSpellInfo(61295)]	= L["Restoration"],		-- Riptide
	[GetSpellInfo(51886)]	= L["Restoration"],		-- Cleanse Spirit
	[GetSpellInfo(974)]	= L["Restoration"],		-- Earth Shield
	[GetSpellInfo(16188)]	= L["Restoration"],		-- Nature's Swiftness
	-- HUNTER
	[GetSpellInfo(19577)]	= L["Beast Mastery"],		-- Intimidation
	[GetSpellInfo(20895)]	= L["Beast Mastery"],		-- Spirit Bond
	[GetSpellInfo(82692)]	= L["Beast Mastery"],		-- Focus Fire
	[GetSpellInfo(82726)]	= L["Beast Mastery"],		-- Fervor
	[GetSpellInfo(19506)]	= L["Marksmanship"],	   	-- Trueshot Aura
	[GetSpellInfo(34490)]	= L["Marksmanship"],	   	-- Silencing Shot
	[GetSpellInfo(53209)]	= L["Marksmanship"],	   	-- Chimera Shot
	[GetSpellInfo(19434)]	= L["Marksmanship"],    	-- Aimed Shot
	[GetSpellInfo(23989)]	= L["Marksmanship"],    	-- Readiness
	[GetSpellInfo(53301)]	= L["Survival"],		-- Explosive Shot
	[GetSpellInfo(19386)]	= L["Survival"],		-- Wyvern Sting
	[GetSpellInfo(3674)]	= L["Survival"],		-- Black Arrow
	[GetSpellInfo(19306)]	= L["Survival"],		-- Counterattack 
	-- DRUID
	[GetSpellInfo(48505)]	= L["Balance"],			-- Starfall
	[GetSpellInfo(50516)]	= L["Balance"],			-- Typhoon
	[GetSpellInfo(78674)]	= L["Balance"],			-- Starsurge
	[GetSpellInfo(33831)]	= L["Balance"],			-- Force of Nature
	[GetSpellInfo(24907)]	= L["Balance"],			-- Moonkin Form
	[GetSpellInfo(78675)]	= L["Balance"],			-- Solar Beam
	[GetSpellInfo(33876)]	= L["Feral"],			-- Mangle (Cat)
	[GetSpellInfo(33878)]	= L["Feral"],			-- Mangle (Bear)
	[GetSpellInfo(24932)]	= L["Feral"],			-- Leader of the Pack
	[GetSpellInfo(61336)]	= L["Feral"],			-- Survival Instincts
	[GetSpellInfo(80313)]	= L["Feral"],			-- Pulverize
	[GetSpellInfo(18562)]	= L["Restoration"],		-- Swiftmend
	[GetSpellInfo(48438)]	= L["Restoration"],		-- Wild Growth		
	[GetSpellInfo(33891)]	= L["Restoration"],		-- Tree of Life		
	[GetSpellInfo(65139)]	= L["Restoration"],		-- Tree of Life
	--[GetSpellInfo(17116)]	= L["Restoration"],		-- Nature's Swiftness
}

SLASH_REFLEX1, SLASH_REFLEX2 = "/ref", "/reflex";

-- *** Event functions

function REFlex_OnLoad(self)
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	self:RegisterEvent("ADDON_LOADED");
	self:RegisterEvent("PVP_RATED_STATS_UPDATE");
	self:RegisterEvent("ARENA_OPPONENT_UPDATE");
	self:RegisterEvent("UNIT_SPELLCAST_START");
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
	self:RegisterEvent("UNIT_AURA");

	WorldStateScoreFrame:HookScript("OnShow", REFlex_BGEnd);
	WorldStateScoreFrame:HookScript("OnHide", function(self) REFlex_ScoreTab:Hide() end);

	RESecondTime = false;
	RESecondTimeMainTab = false;
	RESecondTimeMiniBar = false;
	RESecondTimeMiniBarTimer = false;
end

function REFlex_OnEvent(self,Event,...)
	local _, REZoneType = IsInInstance();
	if Event == "UPDATE_BATTLEFIELD_SCORE" then
		if RESecondTimeMiniBarTimer ~= true then
			REFlex_Frame:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE");
			REShefkiTimer:ScheduleTimer(REFlex_MiniBarDelay, 25);
			RESecondTimeMiniBarTimer = true;
		elseif REZoneType ~= "arena" then
			REFlex_UpdateMiniBar();
		end
	elseif (Event == "UNIT_SPELLCAST_START" or Event == "UNIT_SPELLCAST_SUCCEEDED") and REZoneType == "arena" then
		local REUnitID, RESpellName = ...;

		if REUnitID == "arena1" or REUnitID == "arena2" or REUnitID == "arena3" or REUnitID == "arena4" or REUnitID == "arena5" then
			if REBuildRecognition[RESpellName] ~= nil then
				local REName = table.concat({ strsplit(" ", GetUnitName(REUnitID, true), 3) });
				if REArenaBuilds[REName] == nil and REName ~= UNKNOWN then
					_, REArenaRaces[REName] = UnitRace(REUnitID);
					REArenaBuilds[REName] = REBuildRecognition[RESpellName];
					print("\124cFF74D06C[REFlex]\124r " .. REFlex_NameClean(REName) .. " - " .. REBuildRecognition[RESpellName]);
				end
			end
		end
	elseif Event == "UNIT_AURA" and REZoneType == "arena" then
		local REUnitID = ...;

		if REUnitID == "arena1" or REUnitID == "arena2" or REUnitID == "arena3" or REUnitID == "arena4" or REUnitID == "arena5" then
			local REId = 1
			while true do
				local  REAuraName, _, _, _, _, _, _, RECaster = UnitAura(REUnitID, REId, "HELPFUL")
				if not REAuraName then 
					break 
				end

				if REBuildRecognition[REAuraName] ~= nil and RECaster ~= "" and RECaster ~= nil then
					local REName = table.concat({ strsplit(" ", GetUnitName(RECaster, true), 3) });
					if REArenaBuilds[REName] == nil and REName ~= UNKNOWN then
						_, REArenaRaces[REName] = UnitRace(RECaster); 
						REArenaBuilds[REName] = REBuildRecognition[REAuraName];
						print("\124cFF74D06C[REFlex]\124r " .. REFlex_NameClean(REName) .. " - " .. REBuildRecognition[REAuraName]);
					end
				end

				REId = REId + 1
			end
		end
	elseif Event == "ARENA_OPPONENT_UPDATE" and REZoneType == "arena" then
		REFlex_Frame:UnregisterEvent("ARENA_OPPONENT_UPDATE");
		REArenaBuilds = {};
		REPartyArenaCheck = 0;
		REArenaRaces = {};
		REShefkiTimer:ScheduleTimer(REFlex_ArenaTalentCheck, 30);
	elseif Event == "INSPECT_READY" then
		REFlex_Frame:UnregisterEvent("INSPECT_READY");
		local REInspectedGID = ...
		if REInspectedGID == UnitGUID("party" .. REPartyArenaCheck) then
			local RETalentGroup = GetActiveTalentGroup(true);
			local REPartyName = GetUnitName("party" .. REPartyArenaCheck, true);
			_, REArenaRaces[REPartyName] = UnitRace("party" .. REPartyArenaCheck);

			local REPrimaryTree = 1;
			local REPoints = 0;
			for j = 1, 3 do
				local _, _, _, _, REPointsSpent = GetTalentTabInfo(j,true,false,RETalentGroup);
				if (REPointsSpent > REPoints) then
					REPrimaryTree = j;
					REPoints = REPointsSpent;
				end
			end
			local _, REBuildName = GetTalentTabInfo(REPrimaryTree,true,false,RETalentGroup);

			REArenaBuilds[REPartyName] = REBuildName;
			REPartyArenaCheck = REPartyArenaCheck + 1;
		end
		REFlex_ArenaTalentCheck();
	elseif Event == "PVP_RATED_STATS_UPDATE" then
		RERBG, _, RERBGPointsWeek, RERBGMaxPointsWeek = GetPersonalRatedBGInfo();
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_I:SetMinMaxValues(0, RERBGMaxPointsWeek);
		REFlex_MainTab_Tab6_ScoreHolderSpecial_BarCP_I:SetMinMaxValues(0, RERBGMaxPointsWeek);
	elseif Event == "ZONE_CHANGED_NEW_AREA" and RESecondTime == true then
		REFlex_Frame:RegisterEvent("ARENA_OPPONENT_UPDATE");
		RESecondTime = false;
		RESecondTimeMiniBar = false;
		RESecondTimeMiniBarTimer = false;
		REMiniBarSecondLineRdy = false;

		if REFSettings["ShowMiniBar"] and REMiniBarPluginsCount ~= nil then
			REFSettings["MiniBarAnchor"], _, _, REFSettings["MiniBarX"], REFSettings["MiniBarY"] = REFlex_MiniBar1:GetPoint(1);
			REFSettings["MiniBarX"] = REFlex_Round(REFSettings["MiniBarX"], 2);
			REFSettings["MiniBarY"] = REFlex_Round(REFSettings["MiniBarY"], 2);

			for i=1, REMiniBarPluginsCount do
				_G["REFlex_MiniBar" .. i]:Hide();
			end
		end

		RequestRatedBattlegroundInfo();
	elseif Event == "ZONE_CHANGED_NEW_AREA" and REMiniBarPluginsCount ~= nil and REFSettings["ShowMiniBar"] then
		for i=1, REMiniBarPluginsCount do
			_G["REFlex_MiniBar" .. i]:Hide();
		end
	elseif Event == "ADDON_LOADED" and ... == "REFlex" then
		BINDING_HEADER_REFLEXB = "REFlex";
		BINDING_NAME_REFLEXSHOW = L["Show main window"];

		REFlex_ScoreTab_MsgGuild:SetText(GUILD); 
		REFlex_ScoreTab_MsgParty:SetText(PARTY);
		REFlex_MainTab_MsgGuild:SetText(GUILD); 
		REFlex_MainTab_MsgParty:SetText(PARTY);

		REFlex_MainTab_Title:SetText("REFlex " .. REAddonVersion);
		REFlex_MainTabTab1:SetText(ALL);
		REFlex_MainTabTab2:SetText(PLAYER_DIFFICULTY1);
		REFlex_MainTabTab3:SetText(L["Rated"]);
		REFlex_MainTabTab4:SetText(STATISTICS);
		REFlex_MainTabTab5:SetText(ARENA);
		REFlex_MainTabTab6:SetText(STATISTICS);

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
		CreateFrame("Frame", "REFlex_MainTab_Tab4_ScoreHolder1", REFlex_MainTab_Tab4, "REFlex_Tab4_ScoreHolder_Virtual");
		REFlex_MainTab_Tab4_ScoreHolder1:SetPoint("TOPLEFT", 15, -45);
		CreateFrame("Frame", "REFlex_MainTab_Tab4_ScoreHolder2", REFlex_MainTab_Tab4, "REFlex_Tab4_ScoreHolder_Virtual");
		REFlex_MainTab_Tab4_ScoreHolder2:SetPoint("TOPRIGHT", -15, -45);
		CreateFrame("Frame", "REFlex_MainTab_Tab4_ScoreHolder3", REFlex_MainTab_Tab4, "REFlex_Tab4_ScoreHolder_Virtual");
		REFlex_MainTab_Tab4_ScoreHolder3:SetPoint("TOPLEFT", 15, -185);
		CreateFrame("Frame", "REFlex_MainTab_Tab4_ScoreHolder4", REFlex_MainTab_Tab4, "REFlex_Tab4_ScoreHolder_Virtual");
		REFlex_MainTab_Tab4_ScoreHolder4:SetPoint("TOP", 0, -185);
		CreateFrame("Frame", "REFlex_MainTab_Tab4_ScoreHolder5", REFlex_MainTab_Tab4, "REFlex_Tab4_ScoreHolder_Virtual");
		REFlex_MainTab_Tab4_ScoreHolder5:SetPoint("TOPRIGHT", -15, -185);
		CreateFrame("Frame", "REFlex_MainTab_Tab4_ScoreHolder6", REFlex_MainTab_Tab4, "REFlex_Tab4_ScoreHolder_Virtual");
		REFlex_MainTab_Tab4_ScoreHolder6:SetPoint("TOPLEFT", 15, -325);
		CreateFrame("Frame", "REFlex_MainTab_Tab4_ScoreHolder7", REFlex_MainTab_Tab4, "REFlex_Tab4_ScoreHolder_Virtual");
		REFlex_MainTab_Tab4_ScoreHolder7:SetPoint("TOP", 0, -325);
		CreateFrame("Frame", "REFlex_MainTab_Tab4_ScoreHolder8", REFlex_MainTab_Tab4, "REFlex_Tab4_ScoreHolder_Virtual");
		REFlex_MainTab_Tab4_ScoreHolder8:SetPoint("TOPRIGHT", -15, -325);
		CreateFrame("Frame", "REFlex_MainTab_Tab5_ScoreHolder", REFlex_MainTab_Tab5, "REFlex_Tab_ScoreHolder_Virtual");
		CreateFrame("Frame", "REFlex_MainTab_Tab6_ScoreHolder1", REFlex_MainTab_Tab6, "REFlex_Tab6_ScoreHolder_Virtual");
		REFlex_MainTab_Tab6_ScoreHolder1:SetPoint("TOPLEFT", 15, -45);
		CreateFrame("Frame", "REFlex_MainTab_Tab6_ScoreHolder2", REFlex_MainTab_Tab6, "REFlex_Tab6_ScoreHolder_Virtual");
		REFlex_MainTab_Tab6_ScoreHolder2:SetPoint("TOPRIGHT", -15, -45);
		CreateFrame("Frame", "REFlex_MainTab_Tab6_ScoreHolder3", REFlex_MainTab_Tab6, "REFlex_Tab6_ScoreHolder_Virtual");
		REFlex_MainTab_Tab6_ScoreHolder3:SetPoint("TOPLEFT", 15, -185);
		CreateFrame("Frame", "REFlex_MainTab_Tab6_ScoreHolder4", REFlex_MainTab_Tab6, "REFlex_Tab6_ScoreHolder_Virtual");
		REFlex_MainTab_Tab6_ScoreHolder4:SetPoint("TOP", 0, -185);
		CreateFrame("Frame", "REFlex_MainTab_Tab6_ScoreHolder5", REFlex_MainTab_Tab6, "REFlex_Tab6_ScoreHolder_Virtual");
		REFlex_MainTab_Tab6_ScoreHolder5:SetPoint("TOPRIGHT", -15, -185);

		REFlex_MainTab_Tab4_Bar_I:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
		REFlex_MainTab_Tab4_Bar_I:SetStatusBarColor(0, 0.9, 0);
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_I:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_I:SetStatusBarColor(0, 0.9, 0);
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarHonor_I:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarHonor_I:SetStatusBarColor(0, 0.9, 0);
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

		--- Settings and database patcher
		if REFDatabase == nil then
			REFDatabase = {};
		end
		if REFDatabaseA == nil then
			REFDatabaseA = {};
		end

		if REFSettings == nil then
			REFSettings = {["Version"] = REDataVersion ,["MinimapPos"] = 45, ["ShowMinimapButton"] = true, ["ShowMiniBar"] = true, ["MiniBarX"] = 0, ["MiniBarY"] = 0, ["MiniBarAnchor"] = "CENTER", ["MiniBarScale"] = 1, ["MiniBarOrder"] = {"KillingBlows", "HonorKills", "Damage", "Healing", "Deaths", "KDRatio", "Honor"}, ["MiniBarVisible"] = {["KillingBlows"] = 1, ["HonorKills"] = 1, ["Damage"] = 2, ["Healing"] = 2, ["Deaths"] = nil, ["KDRatio"] = nil, ["Honor"] = nil}};
		elseif REFSettings["Version"] == 3 then -- 0.7
			REFSettings["Version"] = REDataVersion;

			for i=1, #REFDatabase do
				if REFDatabase[i]["DataVersion"] < 4 then
					REFDatabase[i]["DataVersion"] = REDataVersion;
					REFDatabase[i]["SpecialFields"] = {};
				end
			end
			for i=1, #REFDatabaseA do
				if REFDatabaseA[i]["DataVersion"] < 4 then
					REFDatabaseA[i]["DataVersion"] = REDataVersion;
				end
			end
		elseif REFSettings["Version"] == 2 then -- 0.6
			REFSettings["Version"] = REDataVersion;
			REFSettings["MiniBarAnchor"] = "CENTER";
		elseif REFSettings["Version"] == nil then -- 0.5
			REFSettings["MiniBarOrder"] = {"KillingBlows", "HonorKills", "Damage", "Healing", "Deaths", "KDRatio", "Honor"};
			REFSettings["MiniBarVisible"] = {["KillingBlows"] = 1, ["HonorKills"] = 1, ["Damage"] = 2, ["Healing"] = 2, ["Deaths"] = nil, ["KDRatio"] = nil, ["Honor"] = nil};
			REFSettings["Version"] = REDataVersion;
			REFSettings["MiniBarScale"] = 1;
			REFSettings["MiniBarAnchor"] = "CENTER";

			for i=1, #REFDatabase do
				if REFDatabase[i]["DataVersion"] == nil then
					REFDatabase[i]["DataVersion"] = REDataVersion;
				end
			end
		end
		-- ***

		REFlex_SettingsReload();

		self:UnregisterEvent("ADDON_LOADED");
	end
end

-- DropDown Menu subsection
function REFlex_DropDownTab4Click(self)
	UIDropDownMenu_SetSelectedID(REFlex_MainTab_Tab4_DropDown, self:GetID());
	if REFlex_MainTab_Tab4_DropDown["selectedID"] == 3 then
		RERatedDrop = true;	
	elseif REFlex_MainTab_Tab4_DropDown["selectedID"] == 2 then
		RERatedDrop = false;
	else
		RERatedDrop = nil;
	end
	REFlex_MainTab_Tab4:Hide();
	REFlex_MainTab_Tab4:Show();
end

function REFlex_DropDownTab4OnLoad(self, level)
	local BGDropMenu = UIDropDownMenu_CreateInfo();
	BGDropMenu.text       = ALL;
	BGDropMenu.func       = REFlex_DropDownTab4Click
	UIDropDownMenu_AddButton(BGDropMenu, level);
	BGDropMenu = UIDropDownMenu_CreateInfo();
	BGDropMenu.text       = L["Unrated BGs"];
	BGDropMenu.func       = REFlex_DropDownTab4Click
	UIDropDownMenu_AddButton(BGDropMenu, level);
	BGDropMenu = UIDropDownMenu_CreateInfo();
	BGDropMenu.text       = L["Rated BGs"];
	BGDropMenu.func       = REFlex_DropDownTab4Click 
	UIDropDownMenu_AddButton(BGDropMenu, level);
end

function REFlex_DropDownTab5Click(self)
	UIDropDownMenu_SetSelectedID(REFlex_MainTab_Tab5_DropDown, self:GetID());
	if REFlex_MainTab_Tab5_DropDown["selectedID"] == 4 then
		REBracketDrop = 5;	
	elseif REFlex_MainTab_Tab5_DropDown["selectedID"] == 3 then
		REBracketDrop = 3;
	elseif REFlex_MainTab_Tab5_DropDown["selectedID"] == 2 then
		REBracketDrop = 2;
	else
		REBracketDrop = nil;
	end
	REFlex_MainTab_Tab5:Hide();
	REFlex_MainTab_Tab5:Show();
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
		REBracketDropTab6 = 5;	
	elseif REFlex_MainTab_Tab6_DropDown["selectedID"] == 3 then
		REBracketDropTab6 = 3;
	elseif REFlex_MainTab_Tab6_DropDown["selectedID"] == 2 then
		REBracketDropTab6 = 2;
	else
		REBracketDropTab6 = nil;
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

	REFlex_GUI_MinimapButtonText:SetText(L["Show minimap button"]);
	REFlex_GUI_MiniBarText:SetText(L["Show MiniBar (Battlegrounds only)"]);
	REFlex_GUI_SliderScaleText:SetText(L["MiniBar scale"]);
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

	if REFSettings["ShowMiniBar"] and REMiniBarPluginsCount ~= nil then
		for i=1, REMiniBarPluginsCount do
			_G["REFlex_MiniBar" .. i]:SetScale(REFlex_Round(REFlex_GUI_SliderScale:GetValue(),2));
		end
	end
end

function REFlex_GUIModulesOnShow()
	if REFSettings then
		for j=1, #REFSettings["MiniBarOrder"] do
			if j == 1 then
				if _G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j]] == nil then
					CreateFrame("Frame", "REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j], REFlex_GUI_Modules, "REFlex_GUI_Modules_Virtual");
				end
				_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j]]:ClearAllPoints();
				_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j]]:SetPoint("TOPLEFT", REFlex_GUI_Modules, "TOPLEFT", 10 , -35);

			else
				if _G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j]] == nil then
					CreateFrame("Frame", "REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j], REFlex_GUI_Modules, "REFlex_GUI_Modules_Virtual");
				end
				_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j]]:ClearAllPoints();
				_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j]]:SetPoint("TOPLEFT", _G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j-1]], "BOTTOMLEFT", 0 , -47);
			end
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_Bar1Button"]:Enable()
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_Bar2Button"]:Enable()
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_HideButton"]:Enable()
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_LeftButton"]:Enable()
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_RightButton"]:Enable()

			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_Name"]:SetText(REModuleTranslation[REFSettings["MiniBarOrder"][j]]);
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_Bar1ButtonText"]:SetText(L["Bar 1"]);
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_Bar2ButtonText"]:SetText(L["Bar 2"]);
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_HideButtonText"]:SetText(HIDE);
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_LeftButtonText"]:SetText(L["Left"]);
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_RightButtonText"]:SetText(L["Right"]);

			if j == 1 then
				_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_LeftButton"]:Disable()
			elseif j == #REFSettings["MiniBarOrder"] then
				_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_RightButton"]:Disable()
			end

			if REFSettings["MiniBarVisible"][REFSettings["MiniBarOrder"][j]] == 1 then
				_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_Bar1Button"]:Disable()
			elseif REFSettings["MiniBarVisible"][REFSettings["MiniBarOrder"][j]] == 2 then
				_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_Bar2Button"]:Disable()
			else
				_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_HideButton"]:Disable()
			end

			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_Bar1Button"]:SetScript("OnClick", function() REFlex_GUI_ModuleChangeBar(REFSettings["MiniBarOrder"][j], 1, REFSettings["MiniBarVisible"][REFSettings["MiniBarOrder"][j]]) end);
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_Bar2Button"]:SetScript("OnClick", function() REFlex_GUI_ModuleChangeBar(REFSettings["MiniBarOrder"][j], 2, REFSettings["MiniBarVisible"][REFSettings["MiniBarOrder"][j]]) end);
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_HideButton"]:SetScript("OnClick", function() REFlex_GUI_ModuleChangeBar(REFSettings["MiniBarOrder"][j], nil, REFSettings["MiniBarVisible"][REFSettings["MiniBarOrder"][j]]) end);
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_LeftButton"]:SetScript("OnClick", function() REFlex_GUI_ModuleChangeBarOrder(REFSettings["MiniBarOrder"][j], j, j-1) end);
			_G["REFlex_GUI_Modules_" .. REFSettings["MiniBarOrder"][j] .. "_RightButton"]:SetScript("OnClick", function() REFlex_GUI_ModuleChangeBarOrder(REFSettings["MiniBarOrder"][j], j, j+1) end);
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

function REFlex_SpecTabClick(Spec)
	RETalentTab = Spec;

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
end
-- ***

-- *** Auxiliary functions

-- GUI subsection
function REFlex_SettingsReload()
	if REFSettings["ShowMinimapButton"] then
		REFlex_MinimapButton:Show();
		REFlex_MinimapButtonReposition();
		REFlex_GUI_MinimapButton:SetChecked(true);
	else
		REFlex_MinimapButton:Hide();
		REFlex_GUI_MinimapButton:SetChecked(false);
	end

	if REFSettings["ShowMiniBar"] then
		REFlex_GUI_MiniBar:SetChecked(true);
		REFlex_Frame:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
	else	
		REFlex_GUI_MiniBar:SetChecked(false);
		REFlex_Frame:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE");
	end

	REFlex_GUI_SliderScale:SetValue(REFSettings["MiniBarScale"]);
	RESecondTimeMiniBar = false;
	REMiniBarSecondLineRdy = false;
end

function REFlex_GUISave()
	local REButtonCheck = REFlex_GUI_MinimapButton:GetChecked();
	if REButtonCheck == 1 then
		REFSettings["ShowMinimapButton"] = true;
	else
		REFSettings["ShowMinimapButton"] = false;
	end

	REButtonCheck = REFlex_GUI_MiniBar:GetChecked();
	if REButtonCheck == 1 then
		REFSettings["ShowMiniBar"] = true;
	else
		REFSettings["ShowMiniBar"] = false;
	end

	REFSettings["MiniBarScale"] = REFlex_Round(REFlex_GUI_SliderScale:GetValue(),2);

	REFlex_SettingsReload();
end

function REFlex_GUI_ModuleChangeBar(ModuleName, NewBar, OldBar) 
	if OldBar == 1 then
		local FirstLineCount = 0;
		for j=1, #REFSettings["MiniBarOrder"] do
			if REFSettings["MiniBarVisible"][REFSettings["MiniBarOrder"][j]] == 1 then
				FirstLineCount = FirstLineCount + 1;
			end
		end
		if FirstLineCount >= 2 then
			REFSettings["MiniBarVisible"][ModuleName] = NewBar;
		end
	else
		REFSettings["MiniBarVisible"][ModuleName] = NewBar;
	end

	REFlex_GUIModulesOnShow();
	REFlex_SettingsReload();
end

function REFlex_GUI_ModuleChangeBarOrder(ModuleName, OldOrder, NewOrder) 
	local RETempName = REFSettings["MiniBarOrder"][NewOrder]
	REFSettings["MiniBarOrder"][NewOrder] = ModuleName;
	REFSettings["MiniBarOrder"][OldOrder] = RETempName;

	REFlex_GUIModulesOnShow();
	REFlex_SettingsReload();
end
--

-- Minimap subsection
function REFlex_MinimapButtonReposition()
	REFlex_MinimapButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(80*cos(REFSettings["MinimapPos"])),(80*sin(REFSettings["MinimapPos"]))-52);
end
--

-- Math subsection
function REFlex_Round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function REFlex_NumberClean(Number, round)
	if Number >= 0 then 
		if Number >= 1000000 then
			Number = REFlex_Round((Number / 1000000), round) .. "M";
		elseif Number >= 1000 then
			Number = REFlex_Round((Number / 1000), round) .. "K";
		end
	else
		if Number <= -1000000 then
			Number = REFlex_Round((Number / 1000000), round) .. "M";
		elseif Number <= -1000 then
			Number = REFlex_Round((Number / 1000), round) .. "K";
		end
	end
	return Number;
end

function REFlex_FindI(FieldName, j)
	REFSum = REFSum + REFDatabase[j][FieldName];
	if REFTop < REFDatabase[j][FieldName] then
		REFTop = REFDatabase[j][FieldName];
	end
end

function REFlex_Find(FieldName, Rated, TalentSets, Map)
	REFTop = 0;
	REFSum = 0;

	if Map == nil then
		if TalentSets ~= nil then
			if Rated then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] and REFDatabase[j]["TalentSet"] == TalentSets then
						REFlex_FindI(FieldName, j);
					end
				end
			elseif Rated == false then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] == false and REFDatabase[j]["TalentSet"] == TalentSets then 
						REFlex_FindI(FieldName, j);
					end
				end
			else
				for j=1, #REFDatabase do
					if REFDatabase[j]["TalentSet"] == TalentSets then
						REFlex_FindI(FieldName, j);
					end
				end
			end
		else
			if Rated then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] then
						REFlex_FindI(FieldName, j);
					end
				end
			elseif Rated == false then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] == false then 
						REFlex_FindI(FieldName, j);
					end
				end
			else
				for j=1, #REFDatabase do
					REFlex_FindI(FieldName, j);
				end
			end
		end
	else
		if TalentSets ~= nil then
			if Rated then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] and REFDatabase[j]["TalentSet"] == TalentSets and REFDatabase[j]["MapName"] == Map then
						REFlex_FindI(FieldName, j);
					end
				end
			elseif Rated == false then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] == false and REFDatabase[j]["TalentSet"] == TalentSets and REFDatabase[j]["MapName"] == Map then 
						REFlex_FindI(FieldName, j);
					end
				end
			else
				for j=1, #REFDatabase do
					if REFDatabase[j]["TalentSet"] == TalentSets and REFDatabase[j]["MapName"] == Map then
						REFlex_FindI(FieldName, j);
					end
				end
			end
		else
			if Rated then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] and REFDatabase[j]["MapName"] == Map then
						REFlex_FindI(FieldName, j);
					end
				end
			elseif Rated == false then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] == false and REFDatabase[j]["MapName"] == Map then 
						REFlex_FindI(FieldName, j);
					end
				end
			else
				for j=1, #REFDatabase do
					if REFDatabase[j]["MapName"] == Map then
						REFlex_FindI(FieldName, j);
					end
				end
			end
		end
	end

	return REFTop, REFSum;
end

function REFlex_FindArenaI(FieldName, j)
	REFSum = REFSum + REFDatabaseA[j][FieldName];
	if REFTop < REFDatabaseA[j][FieldName] then
		REFTop = REFDatabaseA[j][FieldName];
	end
end

function REFlex_FindArena(FieldName, Bracket, TalentSets, Map)
	REFTop = 0;
	REFSum = 0;

	if Map == nil then
		if TalentSets ~= nil then
			if Bracket ~= nil then
				for j=1, #REFDatabaseA do
					if REFDatabaseA[j]["Bracket"] == Bracket and REFDatabaseA[j]["TalentSet"] == TalentSets then
						REFlex_FindArenaI(FieldName, j);
					end
				end
			else
				for j=1, #REFDatabaseA do
					if REFDatabaseA[j]["TalentSet"] == TalentSets then
						REFlex_FindArenaI(FieldName, j);
					end
				end
			end
		else
			if Bracket ~= nil then
				for j=1, #REFDatabaseA do
					if REFDatabaseA[j]["Bracket"] == Bracket then
						REFlex_FindArenaI(FieldName, j);
					end
				end
			else
				for j=1, #REFDatabaseA do
					REFlex_FindArenaI(FieldName, j);
				end
			end
		end
	else
		if TalentSets ~= nil then
			if Bracket ~= nil then
				for j=1, #REFDatabaseA do
					if REFDatabaseA[j]["Bracket"] == Bracket and REFDatabaseA[j]["TalentSet"] == TalentSets and REFDatabaseA[j]["MapName"] == Map then
						REFlex_FindArenaI(FieldName, j);
					end
				end
			else
				for j=1, #REFDatabaseA do
					if REFDatabaseA[j]["TalentSet"] == TalentSets and REFDatabaseA[j]["MapName"] == Map then
						REFlex_FindArenaI(FieldName, j);
					end
				end
			end
		else
			if Bracker ~= nil then
				for j=1, #REFDatabaseA do
					if REFDatabaseA[j]["Bracket"] == Bracket and REFDatabaseA[j]["MapName"] == Map then
						REFlex_FindArenaI(FieldName, j);
					end
				end
			else
				for j=1, #REFDatabaseA do
					if REFDatabaseA[j]["MapName"] == Map then
						REFlex_FindArenaI(FieldName, j);
					end
				end
			end
		end
	end

	return REFTop, REFSum;
end

function REFlex_WinLossI(Faction, j)
	if Faction == "Horde" then
		if REFDatabase[j]["Winner"] == FACTION_HORDE then
			REWin = REWin + 1;
		else
			RELoss = RELoss + 1;
		end
	else
		if REFDatabase[j]["Winner"] == FACTION_ALLIANCE then
			REWin = REWin + 1;
		else
			RELoss = RELoss + 1;
		end
	end
end

function REFlex_WinLoss(Rated, TalentSets, Map)
	REWin = 0;
	RELoss = 0;
	local REFaction = UnitFactionGroup("player");

	if Map == nil then
		if TalentSets ~= nil then
			if Rated then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] and REFDatabase[j]["TalentSet"] == TalentSets then
						REFlex_WinLossI(REFaction, j);
					end
				end
			elseif Rated == false then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] == false and REFDatabase[j]["TalentSet"] == TalentSets then
						REFlex_WinLossI(REFaction, j);	
					end
				end
			else
				for j=1, #REFDatabase do
					if REFDatabase[j]["TalentSet"] == TalentSets then
						REFlex_WinLossI(REFaction, j);	
					end
				end
			end
		else
			if Rated then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] then
						REFlex_WinLossI(REFaction, j);	
					end
				end
			elseif Rated == false then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] == false then
						REFlex_WinLossI(REFaction, j);	
					end
				end
			else
				for j=1, #REFDatabase do
					REFlex_WinLossI(REFaction, j);
				end
			end
		end
	else
		if TalentSets ~= nil then
			if Rated then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] and REFDatabase[j]["TalentSet"] == TalentSets and REFDatabase[j]["MapName"] == Map then
						REFlex_WinLossI(REFaction, j);
					end
				end
			elseif Rated == false then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] == false and REFDatabase[j]["TalentSet"] == TalentSets and REFDatabase[j]["MapName"] == Map then
						REFlex_WinLossI(REFaction, j);	
					end
				end
			else
				for j=1, #REFDatabase do
					if REFDatabase[j]["TalentSet"] == TalentSets and REFDatabase[j]["MapName"] == Map then
						REFlex_WinLossI(REFaction, j);	
					end
				end
			end
		else
			if Rated then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] and REFDatabase[j]["MapName"] == Map then
						REFlex_WinLossI(REFaction, j);	
					end
				end
			elseif Rated == false then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] == false and REFDatabase[j]["MapName"] == Map then
						REFlex_WinLossI(REFaction, j);	
					end
				end
			else
				for j=1, #REFDatabase do
					if REFDatabase[j]["MapName"] == Map then
						REFlex_WinLossI(REFaction, j);
					end
				end
			end
		end
	end

	local RERatio = math.floor((REWin/(REWin+RELoss))*100) .. "%";
	return REWin, RELoss, RERatio;
end

function REFlex_WinLossArenaI(j)
	if REFDatabaseA[j]["Winner"] == REFDatabaseA[j]["PlayerTeam"] then
		REWin = REWin + 1;
	else
		RELoss = RELoss + 1;
	end
end

function REFlex_WinLossArena(Bracket, TalentSets, Map)
	REWin = 0;
	RELoss = 0;

	if Map == nil then
		if TalentSets ~= nil then
			if Bracket ~= nil then
				for j=1, #REFDatabaseA do
					if REFDatabaseA[j]["Bracket"] == Bracket and REFDatabaseA[j]["TalentSet"] == TalentSets then
						REFlex_WinLossArenaI(j);
					end
				end
			else
				for j=1, #REFDatabaseA do
					if REFDatabaseA[j]["TalentSet"] == TalentSets then
						REFlex_WinLossArenaI(j);
					end
				end
			end
		else
			if Bracket ~= nil then
				for j=1, #REFDatabaseA do
					if REFDatabaseA[j]["Bracket"] == Bracket then
						REFlex_WinLossArenaI(j);	
					end
				end
			else
				for j=1, #REFDatabaseA do
					REFlex_WinLossArenaI(j);
				end
			end
		end
	else
		if TalentSets ~= nil then
			if Bracket ~= nil then
				for j=1, #REFDatabaseA do
					if REFDatabaseA[j]["Bracket"] == Bracket and REFDatabaseA[j]["TalentSet"] == TalentSets and REFDatabaseA[j]["MapName"] == Map then
						REFlex_WinLossArenaI(j);
					end
				end
			else
				for j=1, #REFDatabaseA do
					if REFDatabaseA[j]["TalentSet"] == TalentSets and REFDatabaseA[j]["MapName"] == Map then
						REFlex_WinLossArenaI(j);	
					end
				end
			end
		else
			if Bracket ~= nil then
				for j=1, #REFDatabaseA do
					if REFDatabaseA[j]["Bracket"] == Bracket and REFDatabaseA[j]["MapName"] == Map then
						REFlex_WinLossArenaI(j);	
					end
				end
			else
				for j=1, #REFDatabaseA do
					if REFDatabaseA[j]["MapName"] == Map then
						REFlex_WinLossArenaI(j);
					end
				end
			end
		end
	end

	local RERatio = math.floor((REWin/(REWin+RELoss))*100) .. "%";
	return REWin, RELoss, RERatio;
end

function REFlex_ArenaTeamHash(DatabaseID, isEnemy)
	local REEnemyNames = {};
	local REEnemyID = {};
	local REFriendNames = {};
	local REFriendID = {};
	local REEnemyNamesSpec = {};

	local Team, TeamE = "", "";
	if REFDatabaseA[DatabaseID]["PlayerTeam"] == 0 then
		Team = "Green";
		TeamE = "Gold";
	else
		Team = "Gold";
		TeamE = "Green";
	end

	if isEnemy == true or isEnemy == nil then
		local REBuildComplete = true;
		for kk=1, #REFDatabaseA[DatabaseID][TeamE .. "Team"] do
			if REFDatabaseA[DatabaseID][TeamE .. "Team"][kk]["Build"] == nil then
				REBuildComplete = false;
				break;
			end
		end
		if #REFDatabaseA[DatabaseID][TeamE .. "Team"] == 0 then
			REBuildComplete = false;
		end

		if REBuildComplete then
			table.insert(REEnemyNamesSpec, REFDatabaseA[DatabaseID]["TalentSet"] .. "#");
			table.insert(REEnemyNamesSpec, REFDatabaseA[DatabaseID]["Bracket"] .. "#");
		end
		for jj=1, #REFDatabaseA[DatabaseID][TeamE .. "Team"] do
			table.insert(REEnemyNames, REFDatabaseA[DatabaseID][TeamE .. "Team"][jj]["Name"]);
			if REBuildComplete then	
				table.insert(REEnemyNamesSpec, REFDatabaseA[DatabaseID][TeamE .. "Team"][jj]["ClassToken"] .. "*" .. REFDatabaseA[DatabaseID][TeamE .. "Team"][jj]["Build"] .. "@");
			end
		end
		table.sort(REEnemyNames);
		table.sort(REEnemyNamesSpec);
		for jj=1, #REEnemyNames do
			for kk=1, #REFDatabaseA[DatabaseID][TeamE .. "Team"] do
				if REEnemyNames[jj] == REFDatabaseA[DatabaseID][TeamE .. "Team"][kk]["Name"] then
					table.insert(REEnemyID, kk);
					break;
				end
			end
		end
	end

	if isEnemy == false or isEnemy == nil then
		for jj=1, #REFDatabaseA[DatabaseID][Team .. "Team"] do
			table.insert(REFriendNames, REFDatabaseA[DatabaseID][Team .. "Team"][jj]["Name"]);
		end
		table.sort(REFriendNames);

		for jj=1, #REFriendNames do
			for kk=1, #REFDatabaseA[DatabaseID][Team .. "Team"] do
				if REFriendNames[jj] == REFDatabaseA[DatabaseID][Team .. "Team"][kk]["Name"] then
					table.insert(REFriendID, kk);
					break;
				end
			end
		end
	end

	return REEnemyNames, REEnemyID, REFriendNames, REFriendID, Team, TeamE, REEnemyNamesSpec;
end

function REFlex_ArenaTeamGrid()
	for j=1, #REFDatabaseA do
		local REEnemyNames, REEnemyID, _, _, _, _, REEnemyNamesSpec = REFlex_ArenaTeamHash(j, true);

		local REEnemyTeamID = table.concat(REEnemyNames);
		if REArenaTeams[REEnemyTeamID] == nil then
			REArenaTeams[REEnemyTeamID] = {};
			REArenaTeams[REEnemyTeamID]["Win"] = 0;
			REArenaTeams[REEnemyTeamID]["Loss"] = 0;
		end
		if  REFDatabaseA[j]["Winner"] == REFDatabaseA[j]["PlayerTeam"] then
			REArenaTeams[REEnemyTeamID]["Win"] = REArenaTeams[REEnemyTeamID]["Win"] + 1;
		else
			REArenaTeams[REEnemyTeamID]["Loss"] = REArenaTeams[REEnemyTeamID]["Loss"] + 1;
		end

		if REEnemyNamesSpec[1] ~= nil then
			local REEnemyTeamID = table.concat(REEnemyNamesSpec);
			local RETempBracket = { strsplit("#", REEnemyTeamID) };
			REEnemyTeamID = RETempBracket[1] .. "#" .. RETempBracket[3];
			local REEnemyTeamIDNoTalent = RETempBracket[3];
			if REArenaTeamsSpec[RETempBracket[2]][REEnemyTeamID] == nil then
				REArenaTeamsSpec[RETempBracket[2]][REEnemyTeamID] = {};
				REArenaTeamsSpec[RETempBracket[2]][REEnemyTeamID]["Win"] = 0;
				REArenaTeamsSpec[RETempBracket[2]][REEnemyTeamID]["Loss"] = 0;
				REArenaTeamsSpec[RETempBracket[2]][REEnemyTeamID]["Total"] = 0;
				REArenaTeamsSpec[RETempBracket[2]][REEnemyTeamID]["Team"] = REEnemyTeamIDNoTalent;
				REArenaTeamsSpec[RETempBracket[2]][REEnemyTeamID]["TalentSet"] = REFDatabaseA[j]["TalentSet"];
			end
			if REArenaTeamsSpec["All"][REEnemyTeamID] == nil then
				REArenaTeamsSpec["All"][REEnemyTeamID] = {};
				REArenaTeamsSpec["All"][REEnemyTeamID]["Win"] = 0;
				REArenaTeamsSpec["All"][REEnemyTeamID]["Loss"] = 0;
				REArenaTeamsSpec["All"][REEnemyTeamID]["Total"] = 0;
				REArenaTeamsSpec["All"][REEnemyTeamID]["Team"] = REEnemyTeamIDNoTalent;
				REArenaTeamsSpec["All"][REEnemyTeamID]["TalentSet"] = REFDatabaseA[j]["TalentSet"];
			end
			if REArenaTeamsSpec["AllNoTalent"][REEnemyTeamIDNoTalent] == nil then
				REArenaTeamsSpec["AllNoTalent"][REEnemyTeamIDNoTalent] = {};
				REArenaTeamsSpec["AllNoTalent"][REEnemyTeamIDNoTalent]["Win"] = 0;
				REArenaTeamsSpec["AllNoTalent"][REEnemyTeamIDNoTalent]["Loss"] = 0;
				REArenaTeamsSpec["AllNoTalent"][REEnemyTeamIDNoTalent]["Total"] = 0;
				REArenaTeamsSpec["AllNoTalent"][REEnemyTeamIDNoTalent]["Team"] = REEnemyTeamIDNoTalent;
			end
			if  REFDatabaseA[j]["Winner"] == REFDatabaseA[j]["PlayerTeam"] then
				REArenaTeamsSpec[RETempBracket[2]][REEnemyTeamID]["Win"] = REArenaTeamsSpec[RETempBracket[2]][REEnemyTeamID]["Win"] + 1;
				REArenaTeamsSpec["All"][REEnemyTeamID]["Win"] = REArenaTeamsSpec["All"][REEnemyTeamID]["Win"] + 1;
				REArenaTeamsSpec["AllNoTalent"][REEnemyTeamIDNoTalent]["Win"] = REArenaTeamsSpec["AllNoTalent"][REEnemyTeamIDNoTalent]["Win"] + 1;
			else
				REArenaTeamsSpec[RETempBracket[2]][REEnemyTeamID]["Loss"] = REArenaTeamsSpec[RETempBracket[2]][REEnemyTeamID]["Loss"] + 1;
				REArenaTeamsSpec["All"][REEnemyTeamID]["Loss"] = REArenaTeamsSpec["All"][REEnemyTeamID]["Loss"] + 1;
				REArenaTeamsSpec["AllNoTalent"][REEnemyTeamIDNoTalent]["Loss"] = REArenaTeamsSpec["AllNoTalent"][REEnemyTeamIDNoTalent]["Loss"] + 1;
			end
			REArenaTeamsSpec[RETempBracket[2]][REEnemyTeamID]["Total"] = REArenaTeamsSpec[RETempBracket[2]][REEnemyTeamID]["Total"] + 1;
			REArenaTeamsSpec["All"][REEnemyTeamID]["Total"] = REArenaTeamsSpec["All"][REEnemyTeamID]["Total"] + 1;
			REArenaTeamsSpec["AllNoTalent"][REEnemyTeamIDNoTalent]["Total"] = REArenaTeamsSpec["AllNoTalent"][REEnemyTeamIDNoTalent]["Total"] + 1;
		end
	end
end
--

-- Timers subsection
function REFlex_MiniBarDelay()
	REFlex_Frame:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
end

function REFlex_ArenaTalentCheck()
	local _, REZoneType = IsInInstance();
	if REZoneType == "arena" then
		if REPartyArenaCheck == 0 then
			local RETalentGroup = GetActiveTalentGroup(false);
			local REPartyName = GetUnitName("player", true);
			_, REArenaRaces[REPartyName] = UnitRace("player");

			local REPrimaryTree = 1;
			local REPoints = 0;
			for j = 1, 3 do
				local _, _, _, _, REPointsSpent = GetTalentTabInfo(j,false,false,RETalentGroup);
				if (REPointsSpent > REPoints) then
					REPrimaryTree = j;
					REPoints = REPointsSpent;
				end
			end
			local _, REBuildName = GetTalentTabInfo(REPrimaryTree,false,false,RETalentGroup);

			REArenaBuilds[REPartyName] = REBuildName;
			REPartyArenaCheck = 1;
			REFlex_ArenaTalentCheck();
		elseif REPartyArenaCheck < 5 then
			local REPartyName = GetUnitName("party" .. REPartyArenaCheck, true)

			if REPartyName ~= nil and REPartyName ~= UNKNOWN then
				ClearInspectPlayer();
				REFlex_Frame:RegisterEvent("INSPECT_READY");
				NotifyInspect("party" .. REPartyArenaCheck);
			else
				REShefkiTimer:ScheduleTimer(REFlex_ArenaTalentCheck, 10);
			end
		end
	end
end
--

-- String subsection
function REFlex_ShortMap(MapName)
	local MapNameTemp = { strsplit(" ", MapName) };
	local ShortMapName = "";
	for j=1, #MapNameTemp do
		ShortMapName = ShortMapName .. string.sub(MapNameTemp[j], 0, 1)
	end
	return ShortMapName;
end

function REFlex_NameClean(Name)
	local RENameOnly = { strsplit("-", Name) };
	return RENameOnly[1];
end
--

-- Table subsection

function REFlex_TableCount(Table)
	local RENum = 0;
	local RETable = {};
	for k,v in pairs(Table) do
		RENum = RENum + 1;
		table.insert(RETable, k);
	end

	return RENum, RETable
end

function REFlex_TableClick(TableName, column)
	local cols = _G["REMainTable" .. TableName].cols;
	local st = _G["REMainTable" .. TableName];

	for i, col in ipairs(st.cols) do 
		if i ~= column then 
			cols[i].sort = nil;
		end
	end

	local sortorder = "asc";
	if not cols[column].sort and cols[column].defaultsort then
		sortorder = cols[column].defaultsort;
	elseif cols[column].sort and cols[column].sort:lower() == "asc" then 
		sortorder = "dsc";
	end
	cols[column].sort = sortorder;
	_G["REMainTable" .. TableName]:SortData();
end

function REFlex_Tab_DefaultFilter(self, rowdata)
	if RETalentTab ~= nil then
		if rowdata["cols"][12]["value"] == RETalentTab then
			return true;
		else
			return false;
		end
	else
		return true;
	end
end

function REFlex_TableRatingArena(PlayerTeam, j)
	if PlayerTeam  == 0 then
		return REFDatabaseA[j]["GreenTeamRatingChange"];
	else
		return REFDatabaseA[j]["GoldTeamRatingChange"];
	end
end

function REFlex_TableTeamArenaTab6(TeamString)
	local RETeamLine = "";

	local RETeam = { strsplit("@", TeamString) };
	for i=1, (#RETeam - 1) do
		local REMember = { strsplit("*", RETeam[i]) };
		
		RETeamLine = RETeamLine .. "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:27:27:0:0:256:256:" .. REClassIconCoords[REMember[1]][1]*256 .. ":" .. REClassIconCoords[REMember[1]][2]*256 .. ":".. REClassIconCoords[REMember[1]][3]*256 ..":" .. REClassIconCoords[REMember[1]][4]*256 .."|t |cFF" .. REClassColors[REMember[1]] .. string.sub(REMember[2], 1, 2) .. "|r  ";
	end

	return RETeamLine;
end

function REFlex_TableTeamArena(IsEnemy, j)
	local Line = "";

	if IsEnemy then
		local REEnemyNames, REEnemyID, _, _, Team, TeamE = REFlex_ArenaTeamHash(j, true);

		for jj=1, #REEnemyID do
			local ClassToken = REFDatabaseA[j][TeamE .. "Team"][REEnemyID[jj]]["ClassToken"];
			Line = Line .. "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:30:30:0:0:256:256:" .. REClassIconCoords[ClassToken][1]*256 .. ":" .. REClassIconCoords[ClassToken][2]*256 .. ":".. REClassIconCoords[ClassToken][3]*256 ..":" .. REClassIconCoords[ClassToken][4]*256 .."|t  "
		end
		if REFDatabaseA[j][TeamE .. "TeamRating"] >= 0 then
			Line = Line .. "[" .. REFDatabaseA[j][TeamE .. "TeamRating"] .. "]";
		else
			Line = "-";
		end
	else
		local _, _, REFriendNames, REFriendID, Team, TeamE = REFlex_ArenaTeamHash(j, false);

		for jj=1, #REFriendID do
			local ClassToken = REFDatabaseA[j][Team .. "Team"][REFriendID[jj]]["ClassToken"];
			Line = Line .. "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:30:30:0:0:256:256:" .. REClassIconCoords[ClassToken][1]*256 .. ":" .. REClassIconCoords[ClassToken][2]*256 .. ":".. REClassIconCoords[ClassToken][3]*256 ..":" .. REClassIconCoords[ClassToken][4]*256 .."|t  "
		end
		if REFDatabaseA[j][Team .. "TeamRating"] >= 0 then
			Line = Line .. "[" .. REFDatabaseA[j][Team .. "TeamRating"] .. "]";
		else
			Line = "-";
		end
	end

	return Line
end

function REFlex_TableWinColorArena(j)
	if  REFDatabaseA[j]["Winner"] == REFDatabaseA[j]["PlayerTeam"] then
		return { 
			["r"] = 0,
			["g"] = 1,
			["b"] = 0,
			["a"] = 1.0,
		};
	else
		return { 
			["r"] = 1,
			["g"] = 0.08,
			["b"] = 0.11,
			["a"] = 1.0,
		};
	end
end

function REFlex_TableWinColor(Winner)
	if Winner == FACTION_HORDE then
		return { 
			["r"] = 1,
			["g"] = 0.08,
			["b"] = 0.11,
			["a"] = 1.0,
		};
	else
		return { 
			["r"] = 0,
			["g"] = 0.66,
			["b"] = 1,
			["a"] = 1.0,
		};
	end
end

function REFlex_TableCheckRated(Rated)
	if Rated then
		return { 
			["r"] = 1,
			["g"] = 0,
			["b"] = 0,
			["a"] = 1.0,
		};
	else
		return { 
			["r"] = 1,
			["g"] = 1,
			["b"] = 1,
			["a"] = 1.0,
		};
	end
end

function REFlex_TableRatingColor(Rating)
	if Rating > 0 then
		return { 
			["r"] = 0,
			["g"] = 1,
			["b"] = 0,
			["a"] = 1.0,
		};
	elseif Rating < 0 then
		return { 
			["r"] = 1,
			["g"] = 0.08,
			["b"] = 0.11,
			["a"] = 1.0,
		};
	else
		return { 
			["r"] = 1,
			["g"] = 1,
			["b"] = 1,
			["a"] = 1.0,
		};
	end
end

function REFlex_TableRatingColorArena(PlayerTeam, j)
	local Rating = 0;

	if PlayerTeam  == 0 then
		Rating = REFDatabaseA[j]["GreenTeamRatingChange"];
	else
		Rating = REFDatabaseA[j]["GoldTeamRatingChange"];
	end

	if Rating > 0 then
		return { 
			["r"] = 0,
			["g"] = 1,
			["b"] = 0,
			["a"] = 1.0,
		};
	elseif Rating < 0 then
		return { 
			["r"] = 1,
			["g"] = 0.08,
			["b"] = 0.11,
			["a"] = 1.0,
		};
	else
		return { 
			["r"] = 1,
			["g"] = 1,
			["b"] = 1,
			["a"] = 1.0,
		};
	end
end
--

-- Tooltips Subsection
function REFlex_ToolTipRatingColorArena(Rating)
	if Rating > 0 then
		return "00FF00+"; 
	elseif Rating < 0 then
		return "FF141C"; 
	else
		return "FFFFFF"; 
	end
end
--
-- ***

-- *** Main functions

-- Button subsection
function REFlex_ScoreOnClick(Channel)
	local REBGRated = IsRatedBattleground();
	if REBGRated then
		SendChatMessage("[REFlex] - " .. REMap .. " - " .. WIN .. ": " .. REWinSide .. " - " .. REBGMinutes .. ":" .. REBGSeconds .. " - " .. RATING .. ": " .. REBGRatingChange,Channel ,nil ,nil);
		SendChatMessage("<KB> " .. REkillingBlows .. " (" .. REPlaceKB .. "/" .. REBGPlayers .. ") - <HK> " .. REhonorKills .. " (" .. REPlaceHK .. "/" .. REBGPlayers .. ")" ,Channel ,nil ,nil);
		SendChatMessage("<" .. DAMAGE .. "> " .. REFlex_NumberClean(REdamageDone, 2) .. " (" .. REPlaceDamage .. "/" .. REBGPlayers .. ") - <" .. SHOW_COMBAT_HEALING .. "> " .. REFlex_NumberClean(REhealingDone, 2) .. " (" .. REPlaceHealing .. "/" .. REBGPlayers .. ")" ,Channel ,nil ,nil);
	else
		SendChatMessage("[REFlex] - " .. REMap .. " - " .. WIN .. ": " .. REWinSide .. " - " .. REBGMinutes .. ":" .. REBGSeconds,Channel ,nil ,nil);
		SendChatMessage("<KB> " .. REkillingBlows .. " (" .. REPlaceKB .. "/" .. REBGPlayers .. ") - <HK> " .. REhonorKills .. " (" .. REPlaceHK .. "/" .. REBGPlayers .. ") - <H> " .. REhonorGained .. " (" .. REPlaceHonor .. "/" .. REBGPlayers .. ")" ,Channel ,nil ,nil);
		SendChatMessage("<" .. DAMAGE .. "> " .. REFlex_NumberClean(REdamageDone, 2) .. " (" .. REPlaceDamage .. "/" .. REBGPlayers .. ") - <" .. SHOW_COMBAT_HEALING .. "> " .. REFlex_NumberClean(REhealingDone, 2) .. " (" .. REPlaceHealing .. "/" .. REBGPlayers .. ")" ,Channel ,nil ,nil);
	end
end

function REFlex_MainOnClick(Channel)
	if PanelTemplates_GetSelectedTab(REFlex_MainTab) == 3 then
		REAddidional = " - " .. L["Rated BGs"];
	elseif PanelTemplates_GetSelectedTab(REFlex_MainTab) == 2 then
		REAddidional = " - " .. L["Unrated BGs"];	
	else
		REAddidional = "";
	end
	SendChatMessage("[REFlex] " .. WINS .. ": " .. REWins .. " - " .. LOSSES .. ": " .. RELosses .. REAddidional,Channel ,nil ,nil);
	SendChatMessage("<KB> " .. L["Total"] .. ": " .. RESumKB .. " - " .. L["Top"] .. ": " .. RETopKB .. " <HK> " .. L["Total"] .. ": " .. RESumHK .. " - " .. L["Top"] .. ": " .. RETopHK,Channel ,nil ,nil);
	SendChatMessage("<" .. DAMAGE .. "> " .. L["Total"] .. ": " .. REFlex_NumberClean(RESumDamage, 2) .. " - " .. L["Top"] .. ": " .. REFlex_NumberClean(RETopDamage , 2),Channel ,nil ,nil);
	SendChatMessage("<" .. SHOW_COMBAT_HEALING .. "> " .. L["Total"] .. ": " .. REFlex_NumberClean(RESumHealing, 2) .. " - " .. L["Top"] .. ": " .. REFlex_NumberClean(RETopHealing, 2),Channel ,nil ,nil);
end
--

-- Tabs subsection
function REFlex_MainTabShow()
	RequestRatedBattlegroundInfo();
	REArenaTeams = {};
	REArenaTeamsSpec = {["2"] = {}, ["3"] = {}, ["5"] = {}, ["All"] = {}, ["AllNoTalent"] = {} };
	REFlex_ArenaTeamGrid();

	if RESecondTimeMainTab == false then
		local REDataStructure12 = {
			{
				["name"] = L["Date"],
				["width"] = 110,
				["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; RERowA = REFDatabase[rowa]["TimeRaw"]; RERowB = REFDatabase[rowb]["TimeRaw"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
				["align"] = "CENTER"
			},
			{
				["name"] = L["Map"],
				["width"] = 130,
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
				["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; RERowA = REFDatabase[rowa]["DurationRaw"]; RERowB = REFDatabase[rowb]["DurationRaw"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
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
			{
				["name"] = "HK",
				["width"] = 35,
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
				["width"] = 60,
				["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; RERowA = REFDatabase[rowa]["Damage"]; RERowB = REFDatabase[rowb]["Damage"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
				["align"] = "CENTER"
			},
			{
				["name"] = SHOW_COMBAT_HEALING,
				["width"] = 60,
				["bgcolor"] = { 
					["r"] = 0.15, 
					["g"] = 0.15, 
					["b"] = 0.15, 
					["a"] = 1.0 
				},
				["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; RERowA = REFDatabase[rowa]["Healing"]; RERowB = REFDatabase[rowb]["Healing"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
				["align"] = "CENTER"
			},
			{
				["name"] = HONOR,
				["width"] = 40,
				["align"] = "CENTER"
			}
		}

		local REDataStructure3 = {
			{
				["name"] = L["Date"],
				["width"] = 92,
				["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; RERowA = REFDatabase[rowa]["TimeRaw"]; RERowB = REFDatabase[rowb]["TimeRaw"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
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
				["name"] = L["A Rating"],
				["width"] = 54,
				["align"] = "CENTER"
			},
			{
				["name"] = L["H Rating"],
				["width"] = 54,
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
				["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; RERowA = REFDatabase[rowa]["DurationRaw"]; RERowB = REFDatabase[rowb]["DurationRaw"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
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
			{
				["name"] = "HK",
				["width"] = 35,
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
				["width"] = 60,
				["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; RERowA = REFDatabase[rowa]["Damage"]; RERowB = REFDatabase[rowb]["Damage"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
				["align"] = "CENTER"
			},
			{
				["name"] = SHOW_COMBAT_HEALING,
				["width"] = 60,
				["bgcolor"] = { 
					["r"] = 0.15, 
					["g"] = 0.15, 
					["b"] = 0.15, 
					["a"] = 1.0 
				},
				["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; RERowA = REFDatabase[rowa]["Healing"]; RERowB = REFDatabase[rowb]["Healing"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
				["align"] = "CENTER"
			},
			{
				["name"] = RATING,
				["width"] = 40,
				["align"] = "CENTER"
			}
		}

		local REDataStructure5 = {
			{
				["name"] = "\n" .. L["Date"],
				["width"] = 92,
				["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; RERowA = REFDatabaseA[rowa]["TimeRaw"]; RERowB = REFDatabaseA[rowb]["TimeRaw"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
				["align"] = "CENTER"
			},
			{
				["name"] = "\n" .. L["Map"],
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
				["name"] = "\n" .. TEAM,
				["width"] = 160,
				["align"] = "CENTER"
			},
			{
				["name"] = "\n" .. ENEMY,
				["bgcolor"] = { 
					["r"] = 0.15, 
					["g"] = 0.15, 
					["b"] = 0.15, 
					["a"] = 1.0 
				},
				["width"] = 160,
				["align"] = "CENTER"
			},
			{
				["name"] = "\n" .. AUCTION_DURATION,
				["width"] = 60,
				["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; RERowA = REFDatabaseA[rowa]["DurationRaw"]; RERowB = REFDatabaseA[rowb]["DurationRaw"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
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
				["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; RERowA = REFDatabaseA[rowa]["Damage"]; RERowB = REFDatabaseA[rowb]["Damage"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
				["align"] = "CENTER"
			},
			{
				["name"] = "\n" .. SHOW_COMBAT_HEALING,
				["width"] = 60,
				["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; RERowA = REFDatabaseA[rowa]["Healing"]; RERowB = REFDatabaseA[rowb]["Healing"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
				["align"] = "CENTER"
			},
			{
				["name"] = "\n" .. RATING,
				["width"] = 40,
				["bgcolor"] = { 
					["r"] = 0.15, 
					["g"] = 0.15, 
					["b"] = 0.15, 
					["a"] = 1.0 
				},
				["align"] = "CENTER"
			}
		}

		local REDataStructure6 = {
			{
				["name"] = "\n" .. TEAM,
				["width"] = 240,
				["align"] = "LEFT"
			},
			{
				["name"] = "\n" .. WIN,
				["bgcolor"] = { 
					["r"] = 0.15, 
					["g"] = 0.15, 
					["b"] = 0.15, 
					["a"] = 1.0 
				},
				["width"] = 35,
				["align"] = "CENTER"
			},
			{
				["name"] = "\n" .. LOSS,
				["width"] = 35,
				["align"] = "CENTER"
			}
		}

		local REDataStructure7 = {
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

		local REDataStructure8 = {
			{
				["name"] = "\n" .. TEAM,
				["width"] = 240,
				["align"] = "LEFT"
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
			},
			{
				["name"] = "\n" .. WIN,
				["width"] = 35,
				["align"] = "CENTER"
			}
		}

		REMainTable1 = REScrollingTable:CreateST(REDataStructure12, 25, nil, nil, REFlex_MainTab_Tab1_Table)
		_G[REMainTable1["frame"]:GetName()]:SetPoint("TOP");
		REMainTable1:RegisterEvents({
			["OnEnter"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
				if realrow ~= nil then
					REFlex_ShowBGDetails_OnEnter(cellFrame, data[realrow]["cols"][13]["value"]);    
				end
			end,
			["OnLeave"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
				if realrow ~= nil then
					REFlex_ShowDetails_OnLeave(cellFrame);    
				end
			end,
		});
		REMainTable2 = REScrollingTable:CreateST(REDataStructure12, 25, nil, nil, REFlex_MainTab_Tab2_Table)
		_G[REMainTable2["frame"]:GetName()]:SetPoint("TOP");
		REMainTable2:RegisterEvents({
			["OnEnter"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
				if realrow ~= nil then
					REFlex_ShowBGDetails_OnEnter(cellFrame, data[realrow]["cols"][13]["value"]);    
				end
			end,
			["OnLeave"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
				if realrow ~= nil then
					REFlex_ShowDetails_OnLeave(cellFrame);    
				end
			end,
		});
		REMainTable3 = REScrollingTable:CreateST(REDataStructure3, 25, nil, nil, REFlex_MainTab_Tab3_Table)
		_G[REMainTable3["frame"]:GetName()]:SetPoint("TOP");
		REMainTable3:RegisterEvents({
			["OnEnter"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
				if realrow ~= nil then
					REFlex_ShowBGDetails_OnEnter(cellFrame, data[realrow]["cols"][13]["value"], "REMainTable3");    
				end
			end,
			["OnLeave"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
				if realrow ~= nil then
					REFlex_ShowDetails_OnLeave(cellFrame);    
				end
			end,
		});
		REMainTable5 = REScrollingTable:CreateST(REDataStructure5, 15, 25, nil, REFlex_MainTab_Tab5_Table)
		_G[REMainTable5["frame"]:GetName()]:SetPoint("TOP");
		REMainTable5:RegisterEvents({
			["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
				if row == nil and (column == 3 or column == 4) then
					return true;   
				end
			end,
			["OnEnter"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
				if realrow ~= nil then
					REFlex_ShowArenaDetails_OnEnter(cellFrame, data[realrow]["cols"][13]["value"]);    
				end
			end,
			["OnLeave"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
				if realrow ~= nil then
					REFlex_ShowDetails_OnLeave(cellFrame);    
				end
			end,
		});
		REMainTable6 = REScrollingTable:CreateST(REDataStructure6, 5, 25, nil, REFlex_MainTab_Tab6_Table1)
		_G[REMainTable6["frame"]:GetName()]:SetPoint("TOP");
		REMainTable6:RegisterEvents({
			["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
				if row == nil then
					return true;   
				end
			end,
		});
		REMainTable7 = REScrollingTable:CreateST(REDataStructure7, 5, 25, nil, REFlex_MainTab_Tab6_Table2)
		_G[REMainTable7["frame"]:GetName()]:SetPoint("TOP");
		REMainTable7:RegisterEvents({
			["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
				if row == nil then
					return true;   
				end
			end,
		});
		REMainTable8 = REScrollingTable:CreateST(REDataStructure8, 5, 25, nil, REFlex_MainTab_Tab6_Table3)
		_G[REMainTable8["frame"]:GetName()]:SetPoint("TOP");
		REMainTable8:RegisterEvents({
			["OnClick"] = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
				if row == nil then
					return true;   
				end
			end,
		});

		RETalentTab = nil;

		PanelTemplates_SetTab(REFlex_MainTab, 1);
		PanelTemplates_SetTab(REFlex_MainTab_SpecHolder, 1);
		REFlex_MainTab_Tab1:Hide();
		REFlex_MainTab_Tab1:Show();
		REFlex_MainTab_Tab2:Hide();
		REFlex_MainTab_Tab3:Hide();
		REFlex_MainTab_Tab4:Hide();
		REFlex_MainTab_Tab5:Hide();
		REFlex_MainTab_Tab6:Hide();

		RESecondTimeMainTab = true;
	end
end	

function REFlex_Tab1Show()
	REFlex_MainTab:SetSize(655, 502)
	REFlex_MainTab_MsgGuild:Show(); 
	REFlex_MainTab_MsgParty:Show();
	local RETableData = {};

	for j=1, #REFDatabase do
		local RETempCol = {};
		RETempCol[1] = {
			["value"] = REFDatabase[j]["TimeHo"] .. ":" .. REFDatabase[j]["TimeMi"] .. " " .. REFDatabase[j]["TimeDa"] .. "." .. REFDatabase[j]["TimeMo"] .. "." .. REFDatabase[j]["TimeYe"]
		}
		RETempCol[2] = {
			["value"] = REFDatabase[j]["MapName"],
			["color"] = REFlex_TableCheckRated,
			["colorargs"] = {REFDatabase[j]["IsRated"],}
		}
		RETempCol[3] = {
			["value"] = REFDatabase[j]["DurationMin"] .. ":" .. REFDatabase[j]["DurationSec"]
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
			["value"] = REFlex_NumberClean(REFDatabase[j]["Damage"], 2)
		}
		RETempCol[8] = {
			["value"] = REFlex_NumberClean(REFDatabase[j]["Healing"], 2)
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

		table.insert(RETableData, RETempRow);
	end

	REMainTable1:SetData(RETableData);
	REMainTable1:SetFilter(REFlex_Tab_DefaultFilter);

	if RETable1Rdy then
		REMainTable1:SortData();
	else
		REFlex_TableClick(1, 1);
		RETable1Rdy = true;
	end

	RETopKB, RESumKB = REFlex_Find("KB", nil, RETalentTab);
	RETopHK, RESumHK = REFlex_Find("HK", nil, RETalentTab);
	RETopDamage, RESumDamage = REFlex_Find("Damage", nil, RETalentTab);
	RETopHealing, RESumHealing = REFlex_Find("Healing", nil, RETalentTab);
	REWins, RELosses = REFlex_WinLoss(nil, RETalentTab); 

	REFlex_MainTab_Tab1_ScoreHolder_Wins:SetText(REWins);
	REFlex_MainTab_Tab1_ScoreHolder_Lose:SetText(RELosses);
	REFlex_MainTab_Tab1_ScoreHolder_RBG:SetText(RERBG);
	REFlex_MainTab_Tab1_ScoreHolder_HK1:SetText("HK");
	REFlex_MainTab_Tab1_ScoreHolder_HK2:SetText(L["Top"] .. ": " .. RETopHK);
	REFlex_MainTab_Tab1_ScoreHolder_HK3:SetText(L["Total"] .. ": " .. RESumHK);
	REFlex_MainTab_Tab1_ScoreHolder_KB1:SetText("KB");
	REFlex_MainTab_Tab1_ScoreHolder_KB2:SetText(L["Top"] .. ": " .. RETopKB);
	REFlex_MainTab_Tab1_ScoreHolder_KB3:SetText(L["Total"] .. ": " .. RESumKB);
	REFlex_MainTab_Tab1_ScoreHolder_Damage1:SetText(DAMAGE);
	REFlex_MainTab_Tab1_ScoreHolder_Damage2:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RETopDamage, 2));
	REFlex_MainTab_Tab1_ScoreHolder_Damage3:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RESumDamage, 2));
	REFlex_MainTab_Tab1_ScoreHolder_Healing1:SetText(SHOW_COMBAT_HEALING);
	REFlex_MainTab_Tab1_ScoreHolder_Healing2:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RETopHealing, 2));
	REFlex_MainTab_Tab1_ScoreHolder_Healing3:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RESumHealing, 2));
end

function REFlex_Tab2Show()
	REFlex_MainTab:SetSize(655, 502)
	REFlex_MainTab_MsgGuild:Show(); 
	REFlex_MainTab_MsgParty:Show();
	local RETableData = {};

	for j=1, #REFDatabase do
		if REFDatabase[j]["IsRated"] == false then
			local RETempCol = {};
			RETempCol[1] = {
				["value"] = REFDatabase[j]["TimeHo"] .. ":" .. REFDatabase[j]["TimeMi"] .. " " .. REFDatabase[j]["TimeDa"] .. "." .. REFDatabase[j]["TimeMo"] .. "." .. REFDatabase[j]["TimeYe"]
			}
			RETempCol[2] = {
				["value"] = REFDatabase[j]["MapName"]
			}
			RETempCol[3] = {
				["value"] = REFDatabase[j]["DurationMin"] .. ":" .. REFDatabase[j]["DurationSec"]
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
				["value"] = REFlex_NumberClean(REFDatabase[j]["Damage"], 2)
			}
			RETempCol[8] = {
				["value"] = REFlex_NumberClean(REFDatabase[j]["Healing"], 2)
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

			table.insert(RETableData, RETempRow);
		end
	end

	REMainTable2:SetData(RETableData);
	REMainTable2:SetFilter(REFlex_Tab_DefaultFilter);
	REMainTable2:SortData();

	RETopKB, RESumKB = REFlex_Find("KB", false, RETalentTab);
	RETopHK, RESumHK = REFlex_Find("HK", false, RETalentTab);
	RETopDamage, RESumDamage = REFlex_Find("Damage", false, RETalentTab);
	RETopHealing, RESumHealing = REFlex_Find("Healing", false, RETalentTab);
	REWins, RELosses = REFlex_WinLoss(false, RETalentTab); 

	REFlex_MainTab_Tab2_ScoreHolder_Wins:SetText(REWins);
	REFlex_MainTab_Tab2_ScoreHolder_Lose:SetText(RELosses);
	REFlex_MainTab_Tab2_ScoreHolder_HK1:SetText("HK");
	REFlex_MainTab_Tab2_ScoreHolder_HK2:SetText(L["Top"] .. ": " .. RETopHK);
	REFlex_MainTab_Tab2_ScoreHolder_HK3:SetText(L["Total"] .. ": " .. RESumHK);
	REFlex_MainTab_Tab2_ScoreHolder_KB1:SetText("KB");
	REFlex_MainTab_Tab2_ScoreHolder_KB2:SetText(L["Top"] .. ": " .. RETopKB);
	REFlex_MainTab_Tab2_ScoreHolder_KB3:SetText(L["Total"] .. ": " .. RESumKB);
	REFlex_MainTab_Tab2_ScoreHolder_Damage1:SetText(DAMAGE);
	REFlex_MainTab_Tab2_ScoreHolder_Damage2:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RETopDamage, 2));
	REFlex_MainTab_Tab2_ScoreHolder_Damage3:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RESumDamage, 2));
	REFlex_MainTab_Tab2_ScoreHolder_Healing1:SetText(SHOW_COMBAT_HEALING);
	REFlex_MainTab_Tab2_ScoreHolder_Healing2:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RETopHealing, 2));
	REFlex_MainTab_Tab2_ScoreHolder_Healing3:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RESumHealing, 2));
end

function REFlex_Tab3Show()
	REFlex_MainTab:SetSize(655, 502)
	REFlex_MainTab_MsgGuild:Show(); 
	REFlex_MainTab_MsgParty:Show();
	local RETableData = {};

	for j=1, #REFDatabase do
		if REFDatabase[j]["IsRated"] then
			local RETempCol = {};
			RETempCol[1] = {
				["value"] = REFDatabase[j]["TimeHo"] .. ":" .. REFDatabase[j]["TimeMi"] .. " " .. REFDatabase[j]["TimeDa"] .. "." .. REFDatabase[j]["TimeMo"] .. "." .. string.sub(REFDatabase[j]["TimeYe"], 3)
			}
			RETempCol[2] = {
				["value"] = REFlex_ShortMap(REFDatabase[j]["MapName"])
			}
			RETempCol[3] = {
				["value"] = REFDatabase[j]["AllianceRating"]
			}
			RETempCol[4] = {
				["value"] = REFDatabase[j]["HordeRating"]
			}
			RETempCol[5] = {
				["value"] = REFDatabase[j]["DurationMin"] .. ":" .. REFDatabase[j]["DurationSec"]
			}
			RETempCol[6] = {
				["value"] = REFDatabase[j]["Winner"],
				["color"] = REFlex_TableWinColor,
				["colorargs"] = {REFDatabase[j]["Winner"],}
			}
			RETempCol[7] = {
				["value"] = REFDatabase[j]["KB"]
			}
			RETempCol[8] = {
				["value"] = REFDatabase[j]["HK"]
			}
			RETempCol[9] = {
				["value"] = REFlex_NumberClean(REFDatabase[j]["Damage"], 2)
			}
			RETempCol[10] = {
				["value"] = REFlex_NumberClean(REFDatabase[j]["Healing"], 2)
			}
			RETempCol[11] = {
				["value"] = REFDatabase[j]["RatingChange"],
				["color"] = REFlex_TableRatingColor,
				["colorargs"] = {REFDatabase[j]["RatingChange"],}
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

			table.insert(RETableData, RETempRow);
		end
	end

	REMainTable3:SetData(RETableData);
	REMainTable3:SetFilter(REFlex_Tab_DefaultFilter);
	if RETable3Rdy then
		REMainTable3:SortData();
	else
		REFlex_TableClick(3, 1);
		RETable3Rdy = true;
	end

	RETopKB, RESumKB = REFlex_Find("KB", true, RETalentTab);
	RETopHK, RESumHK = REFlex_Find("HK", true, RETalentTab);
	RETopDamage, RESumDamage = REFlex_Find("Damage", true, RETalentTab);
	RETopHealing, RESumHealing = REFlex_Find("Healing", true, RETalentTab);
	REWins, RELosses = REFlex_WinLoss(true, RETalentTab); 

	REFlex_MainTab_Tab3_ScoreHolder_Wins:SetText(REWins);
	REFlex_MainTab_Tab3_ScoreHolder_Lose:SetText(RELosses);
	REFlex_MainTab_Tab3_ScoreHolder_RBG:SetText(RERBG);
	REFlex_MainTab_Tab3_ScoreHolder_HK1:SetText("HK");
	REFlex_MainTab_Tab3_ScoreHolder_HK2:SetText(L["Top"] .. ": " .. RETopHK);
	REFlex_MainTab_Tab3_ScoreHolder_HK3:SetText(L["Total"] .. ": " .. RESumHK);
	REFlex_MainTab_Tab3_ScoreHolder_KB1:SetText("KB");
	REFlex_MainTab_Tab3_ScoreHolder_KB2:SetText(L["Top"] .. ": " .. RETopKB);
	REFlex_MainTab_Tab3_ScoreHolder_KB3:SetText(L["Total"] .. ": " .. RESumKB);
	REFlex_MainTab_Tab3_ScoreHolder_Damage1:SetText(DAMAGE);
	REFlex_MainTab_Tab3_ScoreHolder_Damage2:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RETopDamage, 2));
	REFlex_MainTab_Tab3_ScoreHolder_Damage3:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RESumDamage, 2));
	REFlex_MainTab_Tab3_ScoreHolder_Healing1:SetText(SHOW_COMBAT_HEALING);
	REFlex_MainTab_Tab3_ScoreHolder_Healing2:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RETopHealing, 2));
	REFlex_MainTab_Tab3_ScoreHolder_Healing3:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RESumHealing, 2));
end

function REFlex_Tab4ShowI(j)
	local REMapsTester = false;
	for k=1, #REMapsHolder do
		if REMapsHolder[k] == REFDatabase[j]["MapName"] then
			REMapsTester = true;
			break
		end
	end

	if not REMapsTester then
		table.insert(REMapsHolder, REFDatabase[j]["MapName"]);
	end
end

function REFlex_Tab4Show()
	REFlex_MainTab:SetSize(1070, 502);
	REFlex_MainTab_MsgGuild:Hide(); 
	REFlex_MainTab_MsgParty:Hide();

	local REhk = GetPVPLifetimeStats();
	local _, REHonor = GetCurrencyInfo(HONOR_CURRENCY);
	local _, RECP = GetCurrencyInfo(CONQUEST_CURRENCY);
	REFlex_MainTab_Tab4_Bar_I:SetValue(REhk);
	REFlex_MainTab_Tab4_Bar_Text:SetText(REhk .. " / 100000");
	REFlex_MainTab_Tab4_ScoreHolderSpecial_BarHonor_I:SetValue(REHonor);
	REFlex_MainTab_Tab4_ScoreHolderSpecial_BarHonor_Text:SetText(REHonor .. " / 4000");
	REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_I:SetValue(RERBGPointsWeek);
	REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_Text:SetText(RECP .. " - " .. RERBGPointsWeek .. " / " .. RERBGMaxPointsWeek);

	REMapsHolder = {};
	for j=1, #REFDatabase do
		if RETalentTab ~= nil then
			if RERatedDrop ~= nil then
				if REFDatabase[j]["TalentSet"] == RETalentTab and REFDatabase[j]["IsRated"] == RERatedDrop then
					REFlex_Tab4ShowI(j);		
				end
			else
				if REFDatabase[j]["TalentSet"] == RETalentTab then
					REFlex_Tab4ShowI(j);
				end
			end
		else
			if RERatedDrop ~= nil then
				if REFDatabase[j]["IsRated"] == RERatedDrop then
					REFlex_Tab4ShowI(j);
				end
			else
				REFlex_Tab4ShowI(j);
			end
		end
	end
	table.sort(REMapsHolder);

	local REUsed = 0;
	for j=1, #REMapsHolder do
		RETopKB, RESumKB = REFlex_Find("KB", RERatedDrop, RETalentTab, REMapsHolder[j]);
		RETopHK, RESumHK = REFlex_Find("HK", RERatedDrop, RETalentTab, REMapsHolder[j]);
		RETopDamage, RESumDamage = REFlex_Find("Damage", RERatedDrop, RETalentTab, REMapsHolder[j]);
		RETopHealing, RESumHealing = REFlex_Find("Healing", RERatedDrop, RETalentTab, REMapsHolder[j]);
		REWins, RELosses = REFlex_WinLoss(RERatedDrop, RETalentTab, REMapsHolder[j]); 
		REUsed = REUsed + 1;

		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j]:Show();
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Title"]:SetText("- " .. REFlex_ShortMap(REMapsHolder[j]) .. " -");
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Wins"]:SetText(REWins);
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Lose"]:SetText(RELosses);
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_HK1"]:SetText("HK");
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_HK2"]:SetText(L["Top"] .. ": " .. RETopHK);
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_HK3"]:SetText(L["Total"] .. ": " .. RESumHK);
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_KB1"]:SetText("KB");
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_KB2"]:SetText(L["Top"] .. ": " .. RETopKB);
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_KB3"]:SetText(L["Total"] .. ": " .. RESumKB);
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Damage1"]:SetText(DAMAGE);
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Damage2"]:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RETopDamage, 2));
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Damage3"]:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RESumDamage, 2));
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Healing1"]:SetText(SHOW_COMBAT_HEALING);
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Healing2"]:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RETopHealing, 2));
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Healing3"]:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RESumHealing, 2));
	end

	if REUsed < 8 then
		for j=1, 8-REUsed do
			_G["REFlex_MainTab_Tab4_ScoreHolder" .. (j+REUsed)]:Hide();
		end
	end
end

function REFlex_Tab5Show()
	REFlex_MainTab:SetSize(736, 502);
	REFlex_MainTab_MsgGuild:Hide(); 
	REFlex_MainTab_MsgParty:Hide();

	local RETableData = {};

	for j=1, #REFDatabaseA do
		if REBracketDrop ~= nil then
			if REFDatabaseA[j]["Bracket"] == REBracketDrop then
				local RETempCol = {};
				RETempCol[1] = {
					["value"] = REFDatabaseA[j]["TimeHo"] .. ":" .. REFDatabaseA[j]["TimeMi"] .. " " .. REFDatabaseA[j]["TimeDa"] .. "." .. REFDatabaseA[j]["TimeMo"] .. "." .. string.sub(REFDatabaseA[j]["TimeYe"], 3)
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
					["value"] = REFlex_TableTeamArena(true, j)
				}
				RETempCol[5] = {
					["value"] = REFDatabaseA[j]["DurationMin"] .. ":" .. REFDatabaseA[j]["DurationSec"]
				}
				RETempCol[6] = {
					["value"] = REFlex_NumberClean(REFDatabaseA[j]["Damage"], 2)
				}
				RETempCol[7] = {
					["value"] = REFlex_NumberClean(REFDatabaseA[j]["Healing"], 2)
				}
				RETempCol[8] = {
					["value"] = REFlex_TableRatingArena(REFDatabaseA[j]["PlayerTeam"], j),
					["color"] = REFlex_TableRatingColorArena,
					["colorargs"] = {REFDatabaseA[j]["PlayerTeam"], j,}
				}
				RETempCol[12] = {
					["value"] = REFDatabaseA[j]["TalentSet"]
				}
				RETempCol[13] = {
					["value"] = j
				}

				local RETempRow = {
					["cols"] = RETempCol
				}

				table.insert(RETableData, RETempRow);
			end
		else
			local RETempCol = {};
			RETempCol[1] = {
				["value"] = REFDatabaseA[j]["TimeHo"] .. ":" .. REFDatabaseA[j]["TimeMi"] .. " " .. REFDatabaseA[j]["TimeDa"] .. "." .. REFDatabaseA[j]["TimeMo"] .. "." .. string.sub(REFDatabaseA[j]["TimeYe"], 3)
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
				["value"] = REFlex_TableTeamArena(true, j)
			}
			RETempCol[5] = {
				["value"] = REFDatabaseA[j]["DurationMin"] .. ":" .. REFDatabaseA[j]["DurationSec"]
			}
			RETempCol[6] = {
				["value"] = REFlex_NumberClean(REFDatabaseA[j]["Damage"], 2)
			}
			RETempCol[7] = {
				["value"] = REFlex_NumberClean(REFDatabaseA[j]["Healing"], 2)
			}
			RETempCol[8] = {
				["value"] = REFlex_TableRatingArena(REFDatabaseA[j]["PlayerTeam"], j),
				["color"] = REFlex_TableRatingColorArena,
				["colorargs"] = {REFDatabaseA[j]["PlayerTeam"], j,}
			}
			RETempCol[12] = {
				["value"] = REFDatabaseA[j]["TalentSet"]
			}
			RETempCol[13] = {
				["value"] = j
			}

			local RETempRow = {
				["cols"] = RETempCol
			}

			table.insert(RETableData, RETempRow);
		end
	end

	REMainTable5:SetData(RETableData);
	REMainTable5:SetFilter(REFlex_Tab_DefaultFilter);
	if RETable5Rdy then
		REMainTable5:SortData();
	else
		REFlex_TableClick(5, 1);
		RETable5Rdy = true;
	end

	RETopDamage, RESumDamage = REFlex_FindArena("Damage", REBracketDrop, RETalentTab);
	RETopHealing, RESumHealing = REFlex_FindArena("Healing", REBracketDrop, RETalentTab);
	REWins, RELosses = REFlex_WinLossArena(REBracketDrop, RETalentTab); 

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
		RERatings = RERatings .. " / " .. player3Rating;
	else
		RERatings = RERatings .. " / -";
	end
	if player5Rating ~= nil then 
		RERatings = RERatings .. " / " .. player5Rating;
	else
		RERatings = RERatings .. " / -";
	end

	REFlex_MainTab_Tab5_ScoreHolder_Wins:SetText(REWins);
	REFlex_MainTab_Tab5_ScoreHolder_Lose:SetText(RELosses);
	REFlex_MainTab_Tab5_ScoreHolder_RBG:SetText(RERatings);
	REFlex_MainTab_Tab5_ScoreHolder_KB1:SetText(DAMAGE);
	REFlex_MainTab_Tab5_ScoreHolder_KB2:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RETopDamage, 2));
	REFlex_MainTab_Tab5_ScoreHolder_KB3:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RESumDamage, 2));
	REFlex_MainTab_Tab5_ScoreHolder_HK1:SetText(SHOW_COMBAT_HEALING);
	REFlex_MainTab_Tab5_ScoreHolder_HK2:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RETopHealing, 2));
	REFlex_MainTab_Tab5_ScoreHolder_HK3:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RESumHealing, 2));
end

function REFlex_Tab6ShowI(j)
	local REMapsTester = false;
	for k=1, #REMapsHolder do
		if REMapsHolder[k] == REFDatabaseA[j]["MapName"] then
			REMapsTester = true;
			break
		end
	end

	if not REMapsTester then
		table.insert(REMapsHolder, REFDatabaseA[j]["MapName"]);
	end
end

function REFlex_Tab6Show()
	REFlex_MainTab:SetSize(1070, 502);
	REFlex_MainTab_MsgGuild:Hide(); 
	REFlex_MainTab_MsgParty:Hide();

	REMapsHolder = {};
	for j=1, #REFDatabaseA do
		if RETalentTab ~= nil then
			if REBracketDropTab6 ~= nil then
				if REFDatabaseA[j]["TalentSet"] == RETalentTab and REFDatabaseA[j]["Bracket"] == REBracketDropTab6 then
					REFlex_Tab6ShowI(j);		
				end
			else
				if REFDatabaseA[j]["TalentSet"] == RETalentTab then
					REFlex_Tab6ShowI(j);
				end
			end
		else
			if REBracketDropTab6 ~= nil then
				if REFDatabaseA[j]["Bracket"] == REBracketDropTab6 then
					REFlex_Tab6ShowI(j);
				end
			else
				REFlex_Tab6ShowI(j);
			end
		end
	end
	table.sort(REMapsHolder);

	local _, REHonor = GetCurrencyInfo(HONOR_CURRENCY);
	local _, RECP = GetCurrencyInfo(CONQUEST_CURRENCY);
	REFlex_MainTab_Tab6_ScoreHolderSpecial_BarHonor_I:SetValue(REHonor);
	REFlex_MainTab_Tab6_ScoreHolderSpecial_BarHonor_Text:SetText(REHonor .. " / 4000");
	REFlex_MainTab_Tab6_ScoreHolderSpecial_BarCP_I:SetValue(RERBGPointsWeek);
	REFlex_MainTab_Tab6_ScoreHolderSpecial_BarCP_Text:SetText(RECP .. " - " .. RERBGPointsWeek .. " / " .. RERBGMaxPointsWeek);

	local REUsed = 0;
	for j=1, #REMapsHolder do
		RETopDamage, RESumDamage = REFlex_FindArena("Damage", REBracketDropTab6, RETalentTab, REMapsHolder[j]);
		RETopHealing, RESumHealing = REFlex_FindArena("Healing", REBracketDropTab6, RETalentTab, REMapsHolder[j]);
		REWins, RELosses = REFlex_WinLossArena(REBracketDropTab6, RETalentTab, REMapsHolder[j]); 
		REUsed = REUsed + 1;

		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j]:Show();
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Title"]:SetText("- " .. REMapsHolder[j] .. " -");
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Wins"]:SetText(REWins);
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Lose"]:SetText(RELosses);
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Damage1"]:SetText(DAMAGE);
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Damage2"]:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RETopDamage, 2));
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Damage3"]:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RESumDamage, 2));
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Healing1"]:SetText(SHOW_COMBAT_HEALING);
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Healing2"]:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RETopHealing, 2));
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Healing3"]:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RESumHealing, 2));
	end

	if REUsed < 5 then
		for j=1, 5-REUsed do
			_G["REFlex_MainTab_Tab6_ScoreHolder" .. (j+REUsed)]:Hide();
		end
	end

	local REBracket, RETableData1, RETableData2, RETableData3 = "", {}, {}, {};
	if REBracketDropTab6 == nil and RETalentTab == nil then
		REBracket = "AllNoTalent";
	elseif REBracketDropTab6 == nil then
		REBracket = "All";
	else
		REBracket = tostring(REBracketDropTab6);
	end

	local RETableCount, RETableI = REFlex_TableCount(REArenaTeamsSpec[REBracket]);
	for j=1, RETableCount do
		if REArenaTeamsSpec[REBracket][RETableI[j]]["Win"] > 0 then
			local RETempCol = {};
			RETempCol[1] = {
				["value"] = REFlex_TableTeamArenaTab6(REArenaTeamsSpec[REBracket][RETableI[j]]["Team"]),
			}
			RETempCol[2] = {
				["value"] = REArenaTeamsSpec[REBracket][RETableI[j]]["Win"],
				["color"] = { ["r"] = 0, ["g"] = 1, ["b"] = 0, ["a"] = 1 },
			}
			RETempCol[3] = {
				["value"] = REArenaTeamsSpec[REBracket][RETableI[j]]["Loss"],
				["color"] = { ["r"] = 1, ["g"] = 0, ["b"] = 0, ["a"] = 1 },
			}
			RETempCol[12] = {
				["value"] = REArenaTeamsSpec[REBracket][RETableI[j]]["TalentSet"],
			}

			local RETempRow = {
				["cols"] = RETempCol
			}

			table.insert(RETableData1, RETempRow);
		end
	end

	for j=1, RETableCount do
		local RETempCol = {};
		RETempCol[1] = {
			["value"] = REFlex_TableTeamArenaTab6(REArenaTeamsSpec[REBracket][RETableI[j]]["Team"]),
		}
		RETempCol[2] = {
			["value"] = REArenaTeamsSpec[REBracket][RETableI[j]]["Total"],
		}
		RETempCol[3] = {
			["value"] = REArenaTeamsSpec[REBracket][RETableI[j]]["Win"],
			["color"] = { ["r"] = 0, ["g"] = 1, ["b"] = 0, ["a"] = 1 },
		}
		RETempCol[4] = {
			["value"] = REArenaTeamsSpec[REBracket][RETableI[j]]["Loss"],
			["color"] = { ["r"] = 1, ["g"] = 0, ["b"] = 0, ["a"] = 1 },
		}
		RETempCol[12] = {
			["value"] = REArenaTeamsSpec[REBracket][RETableI[j]]["TalentSet"],
		}

		local RETempRow = {
			["cols"] = RETempCol
		}

		table.insert(RETableData2, RETempRow);
	end

	for j=1, RETableCount do
		if REArenaTeamsSpec[REBracket][RETableI[j]]["Loss"] > 0 then
			local RETempCol = {};
			RETempCol[1] = {
				["value"] = REFlex_TableTeamArenaTab6(REArenaTeamsSpec[REBracket][RETableI[j]]["Team"]),
			}
			RETempCol[2] = {
				["value"] = REArenaTeamsSpec[REBracket][RETableI[j]]["Loss"],
				["color"] = { ["r"] = 1, ["g"] = 0, ["b"] = 0, ["a"] = 1 },
			}
			RETempCol[3] = {
				["value"] = REArenaTeamsSpec[REBracket][RETableI[j]]["Win"],
				["color"] = { ["r"] = 0, ["g"] = 1, ["b"] = 0, ["a"] = 1 },
			}
			RETempCol[12] = {
				["value"] = REArenaTeamsSpec[REBracket][RETableI[j]]["TalentSet"],
			}

			local RETempRow = {
				["cols"] = RETempCol
			}

			table.insert(RETableData3, RETempRow);
		end
	end

	REMainTable6:SetData(RETableData1);
	REMainTable6:SetFilter(REFlex_Tab_DefaultFilter);
	if RETable6Rdy then
		REMainTable6:SortData();
	else
		REFlex_TableClick(6, 2);
		RETable6Rdy = true;
	end

	REMainTable7:SetData(RETableData2);
	REMainTable7:SetFilter(REFlex_Tab_DefaultFilter);
	if RETable7Rdy then
		REMainTable7:SortData();
	else
		REFlex_TableClick(7, 2);
		RETable7Rdy = true;
	end

	REMainTable8:SetData(RETableData3);
	REMainTable8:SetFilter(REFlex_Tab_DefaultFilter);
	if RETable8Rdy then
		REMainTable8:SortData();
	else
		REFlex_TableClick(8, 2);
		RETable8Rdy = true;
	end
end
-- 

-- Tooltips subsection
function REFlex_ShowBGDetails_OnEnter(self, DatabaseID, Table)
	local RETooltip = REQTip:Acquire("REBGDetailsToolTip", 3, "CENTER", "CENTER", "CENTER");
	self.tooltip = RETooltip;

	RETooltip:AddHeader("", "|cFF74D06C" .. TUTORIAL_TITLE19 .. "|r", "");
	RETooltip:AddLine("|cFF00A9FF" .. FACTION_ALLIANCE .. ":|r " .. REFDatabase[DatabaseID]["AliianceNum"], "", "|cFFFF141D" .. FACTION_HORDE .. ":|r " .. REFDatabase[DatabaseID]["HordeNum"]);

	RETooltip:AddSeparator();
	RETooltip:AddHeader("", "|cFF74D06C" .. L["Place"] .. "|r", "");
	RETooltip:SetColumnLayout(3, "LEFT", "CENTER", "CENTER");
	RETooltip:AddLine("", FACTION, ALL);
	RETooltip:AddLine("KB", REFDatabase[DatabaseID]["PlaceFactionKB"], REFDatabase[DatabaseID]["PlaceKB"]);
	RETooltip:AddLine("HK", REFDatabase[DatabaseID]["PlaceFactionHK"], REFDatabase[DatabaseID]["PlaceHK"]); 
	RETooltip:AddLine(DAMAGE, REFDatabase[DatabaseID]["PlaceFactionDamage"], REFDatabase[DatabaseID]["PlaceDamage"]); 
	RETooltip:AddLine(SHOW_COMBAT_HEALING, REFDatabase[DatabaseID]["PlaceFactionHealing"], REFDatabase[DatabaseID]["PlaceHealing"]);
	RETooltip:SetLineColor(7, 1, 1, 1, 0.5);
	RETooltip:SetLineColor(9, 1, 1, 1, 0.5);
	if not REFDatabase[DatabaseID]["IsRated"] then
		RETooltip:AddLine(HONOR, REFDatabase[DatabaseID]["PlaceFactionHonor"], REFDatabase[DatabaseID]["PlaceHonor"]);
	elseif Table == "REMainTable3" then
		RETooltip:AddSeparator();
		RETooltip:AddLine("", HONOR .. ": " .. REFDatabase[DatabaseID]["Honor"], "");
	end
	if REFDatabase[DatabaseID]["MapInfo"] ~= nil then
		RETooltip:AddSeparator();
		if REFDatabase[DatabaseID]["MapInfo"] == "AlteracValley" then
			RETooltip:AddLine("|T" .. REFDatabase[DatabaseID]["SpecialFields"][1][2] .. ":32:32|t: " .. REFDatabase[DatabaseID]["SpecialFields"][1][1], "", "|T" .. REFDatabase[DatabaseID]["SpecialFields"][2][2] .. ":32:32|t: " .. REFDatabase[DatabaseID]["SpecialFields"][2][1]);
			RETooltip:AddLine("|T" .. REFDatabase[DatabaseID]["SpecialFields"][3][2] .. ":32:32|t: " .. REFDatabase[DatabaseID]["SpecialFields"][3][1], "", "|T" .. REFDatabase[DatabaseID]["SpecialFields"][4][2] .. ":32:32|t: " .. REFDatabase[DatabaseID]["SpecialFields"][4][1]);
		elseif REFDatabase[DatabaseID]["MapInfo"] == "NetherstormArena" then
			RETooltip:AddLine("|T" .. REFDatabase[DatabaseID]["SpecialFields"][1][2] .. ":32:32|t: " .. REFDatabase[DatabaseID]["SpecialFields"][1][1], "", "");
		else
			RETooltip:AddLine("|T" .. REFDatabase[DatabaseID]["SpecialFields"][1][2] .. ":32:32|t: " .. REFDatabase[DatabaseID]["SpecialFields"][1][1], "", "|T" .. REFDatabase[DatabaseID]["SpecialFields"][2][2] .. ":32:32|t: " .. REFDatabase[DatabaseID]["SpecialFields"][2][1]);
		end
	end

	RETooltip:SmartAnchorTo(self);
	RETooltip:Show();
end

function REFlex_ShowArenaDetails_OnEnter(self, DatabaseID)
	local RETooltip = REQTip:Acquire("REArenaDetailsToolTip", 7, "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER");
	self.tooltip = RETooltip;

	local REEnemyNames, REEnemyID, REFriendNames, REFriendID, Team, TeamE = REFlex_ArenaTeamHash(DatabaseID);
	local REEnemyTeamID = table.concat(REEnemyNames);

	RETooltip:SetHeaderFont(SystemFont_Huge1);
	RETooltip:AddHeader("", "", "", "|cFF00CC00" .. REArenaTeams[REEnemyTeamID]["Win"] .. "|r - |cFFCC0000" .. REArenaTeams[REEnemyTeamID]["Loss"] .. "|r", "", "", "");

	local FriendRatingChange = REFDatabaseA[DatabaseID][Team .. "TeamRatingChange"];
	local EnemyRatingChange = REFDatabaseA[DatabaseID][TeamE .. "TeamRatingChange"];
	if REFDatabaseA[DatabaseID][TeamE .. "TeamRating"] < 0 then
		EnemyRatingChange = 0;
	end
	RETooltip:SetHeaderFont(GameTooltipHeader);
	RETooltip:AddHeader("", "[|cFF" .. REFlex_ToolTipRatingColorArena(FriendRatingChange) .. FriendRatingChange .. "|r]", "", "", "", "[|cFF" .. REFlex_ToolTipRatingColorArena(EnemyRatingChange) .. EnemyRatingChange .. "|r]","");
	RETooltip:AddSeparator(3);

	for i=1, REFDatabaseA[DatabaseID]["Bracket"] do
		local RaceClassCell, NameCell, BuildCell, EnemyRaceClassCell, EnemyNameCell, EnemyBuildCell = "", "", "", "", "", "";

		if REFriendID[i] ~= nil then
			local ClassToken = REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["ClassToken"];
			local RaceToken = string.upper(REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Race"] .. "_MALE");
			if RERaceIconCoords[RaceToken] ~= nil then
				RaceClassCell = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:40:40:0:0:512:256:" .. RERaceIconCoords[RaceToken][1]*512 .. ":" .. RERaceIconCoords[RaceToken][2]*512 .. ":".. RERaceIconCoords[RaceToken][3]*256 ..":" .. RERaceIconCoords[RaceToken][4]*256 .. "|t  |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:40:40:0:0:256:256:" .. REClassIconCoords[ClassToken][1]*256 .. ":" .. REClassIconCoords[ClassToken][2]*256 .. ":".. REClassIconCoords[ClassToken][3]*256 ..":" .. REClassIconCoords[ClassToken][4]*256 .."|t"
			else
				RaceClassCell = "|TInterface\\Icons\\INV_Misc_QuestionMark:40:40|t  |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:40:40:0:0:256:256:" .. REClassIconCoords[ClassToken][1]*256 .. ":" .. REClassIconCoords[ClassToken][2]*256 .. ":".. REClassIconCoords[ClassToken][3]*256 ..":" .. REClassIconCoords[ClassToken][4]*256 .."|t"
			end

			NameCell = "|cFF" .. REClassColors[ClassToken] .. REFlex_NameClean(REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Name"]) .. "|r";

			if REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Build"] ~= nil then
				BuildCell = "|cFF" .. REClassColors[ClassToken] .. REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Build"] .. "|r";
			else
				BuildCell = "|cFF" .. REClassColors[ClassToken] .. UNKNOWN .. "|r";
			end
		end

		if REEnemyID[i] ~= nil then
			local ClassToken = REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["ClassToken"];
			local RaceToken = string.upper(REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Race"] .. "_MALE");
			if RERaceIconCoords[RaceToken] ~= nil then
				EnemyRaceClassCell = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:40:40:0:0:512:256:" .. RERaceIconCoords[RaceToken][1]*512 .. ":" .. RERaceIconCoords[RaceToken][2]*512 .. ":".. RERaceIconCoords[RaceToken][3]*256 ..":" .. RERaceIconCoords[RaceToken][4]*256 .. "|t  |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:40:40:0:0:256:256:" .. REClassIconCoords[ClassToken][1]*256 .. ":" .. REClassIconCoords[ClassToken][2]*256 .. ":".. REClassIconCoords[ClassToken][3]*256 ..":" .. REClassIconCoords[ClassToken][4]*256 .."|t"
			else
				EnemyRaceClassCell = "|TInterface\\Icons\\INV_Misc_QuestionMark:40:40|t  |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:40:40:0:0:256:256:" .. REClassIconCoords[ClassToken][1]*256 .. ":" .. REClassIconCoords[ClassToken][2]*256 .. ":".. REClassIconCoords[ClassToken][3]*256 ..":" .. REClassIconCoords[ClassToken][4]*256 .."|t"
			end

			EnemyNameCell = "|cFF" .. REClassColors[ClassToken] .. REFlex_NameClean(REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Name"]) .. "|r";

			if REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Build"] ~= nil then
				EnemyBuildCell = "|cFF" .. REClassColors[ClassToken] .. REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Build"] .. "|r";
			else
				EnemyBuildCell = "|cFF" .. REClassColors[ClassToken] .. UNKNOWN .. "|r";
			end
		end

		RETooltip:AddLine(RaceClassCell, NameCell, BuildCell, "", EnemyRaceClassCell, EnemyNameCell, EnemyBuildCell);	
	end

	RETooltip:SmartAnchorTo(self);
	RETooltip:Show();
end

function REFlex_ShowDetails_OnLeave(self)
	REQTip:Release(self.tooltip)
	self.tooltip = nil
end
--

function REFlex_BGEnd()
	local REWinner = GetBattlefieldWinner();
	local REArena, REArenaRegistered = IsActiveBattlefieldArena();
	if REWinner ~= nil and RESecondTime ~= true and REArena == nil then
		if REWinner == 1 then
			REWinSide = FACTION_ALLIANCE;
			REWinSidePrint = "\124cFF00A9FF" .. FACTION_ALLIANCE;
		else
			REWinSide = FACTION_HORDE;
			REWinSidePrint = "\124cFFFF141D" .. FACTION_HORDE;
		end

		REMap = GetRealZoneText();
		local REPlayerName = GetUnitName("player");
		local REFaction = UnitFactionGroup("player");
		local RETalentGroup = GetActiveTalentGroup(false, false);
		REBGPlayers = GetNumBattlefieldScores();
		local BGTimeRaw = math.floor(GetBattlefieldInstanceRunTime() / 1000);
		REBGMinutes = math.floor(BGTimeRaw / 60);
		REBGSeconds = math.floor(BGTimeRaw % 60);
		local RETimeHour, RETimeMinute = GetGameTime();
		local _, RETimeMonth, RETimeDay, RETimeYear = CalendarGetDate();
		local RETimeRaw = time();
		local RESpecialFields = {};
		local REFactionNum;

		if REBGSeconds < 10 then
			REBGSeconds = "0" .. REBGSeconds;
		end
		if RETimeHour < 10 then
			RETimeHour = "0" .. RETimeHour;
		end
		if RETimeMinute < 10 then
			RETimeMinute = "0" .. RETimeMinute;
		end
		if RETimeDay < 10 then
			RETimeDay = "0" .. RETimeDay;
		end
		if RETimeMonth < 10 then
			RETimeMonth = "0" .. RETimeMonth;
		end

		local REName = "";
		local i = 1;
		while REName ~= REPlayerName do
			REName = GetBattlefieldScore(i);
			REPlayerID = i;
			i = i + 1;
		end

		_, REkillingBlows, REhonorKills, _, REhonorGained, _, _, _, _, REdamageDone, REhealingDone, REBGRating, REBGRatingChange = GetBattlefieldScore(REPlayerID);
		REPlaceKB, REPlaceHK, REPlaceHonor, REPlaceDamage, REPlaceHealing = REBGPlayers, REBGPlayers, REBGPlayers, REBGPlayers, REBGPlayers;
		local REHordeNum, REAllianceNum = 0, 0;
		local REAverageHorde, REAverageAlliance = 0, 0;

		if REFaction == "Horde" then
			REHordeNum = 1;
		else
			REAllianceNum = 1;
		end

		for j=1, REBGPlayers do
			if j ~= REPlayerID then
				local _, killingBlowsTemp, honorKillsTemp, _, honorGainedTemp, factionTemp, _, _, _, damageDoneTemp, healingDoneTemp, ratingTemp = GetBattlefieldScore(j);
				if REkillingBlows >= killingBlowsTemp then
					REPlaceKB = REPlaceKB - 1;
				end
				if REhonorKills >= honorKillsTemp then
					REPlaceHK = REPlaceHK - 1;
				end
				if REhonorGained >= honorGainedTemp then
					REPlaceHonor = REPlaceHonor - 1;
				end
				if REdamageDone >= damageDoneTemp then
					REPlaceDamage = REPlaceDamage - 1;
				end
				if REhealingDone >= healingDoneTemp then
					REPlaceHealing = REPlaceHealing - 1;
				end

				if factionTemp == 0 then
					REHordeNum = REHordeNum + 1;
					REAverageHorde = REAverageHorde + ratingTemp;
				else
					REAllianceNum = REAllianceNum + 1;
					REAverageAlliance = REAverageAlliance + ratingTemp;
				end
			end
		end

		local REBGRated = IsRatedBattleground();
		if REBGRated then
			REFlex_ScoreTab:ClearAllPoints();
			REFlex_ScoreTab:SetPoint("BOTTOMRIGHT", -6, -33);
			REFlex_ScoreTab:Show();

			RETopKB = REFlex_Find("KB", true, RETalentGroup);
			RETopHK = REFlex_Find("HK", true, RETalentGroup);
			RETopDamage = REFlex_Find("Damage", true, RETalentGroup);
			RETopHealing = REFlex_Find("Healing", true, RETalentGroup);

			if REFaction == "Horde" then
				REBGHordeRating = REFlex_Round((REAverageHorde + REBGRating) / REHordeNum, 0);
				REBGAllyRating = REFlex_Round(REAverageAlliance / REAllianceNum, 0);
			else
				REBGHordeRating = REFlex_Round(REAverageHorde / REHordeNum, 0);
				REBGAllyRating = REFlex_Round((REAverageAlliance + REBGRating) / REAllianceNum, 0);
			end
		else
			REFlex_ScoreTab:ClearAllPoints();
			REFlex_ScoreTab:SetPoint("BOTTOMRIGHT", -6, 2);
			REFlex_ScoreTab:Show();

			RETopKB = REFlex_Find("KB", false, RETalentGroup);
			RETopHK = REFlex_Find("HK", false, RETalentGroup);
			RETopDamage = REFlex_Find("Damage", false, RETalentGroup);
			RETopHealing = REFlex_Find("Healing", false, RETalentGroup);

			REBGRating = nil;
			REBGRatingChange = nil;
			REBGHordeRating = nil;
			REBGAllyRating = nil;
		end

		if REFaction == "Horde" then
			REBGPlayersF = REHordeNum;
			REFactionNum = 0;
		else
			REBGPlayersF = REAllianceNum;
			REFactionNum = 1;
		end

		local REPlaceKBF, REPlaceHKF, REPlaceHonorF, REPlaceDamageF, REPlaceHealingF = REBGPlayersF, REBGPlayersF, REBGPlayersF, REBGPlayersF, REBGPlayersF;

		for jj=1, REBGPlayers do
			local _, killingBlowsTemp, honorKillsTemp, _, honorGainedTemp, factionTemp, _, _, _, damageDoneTemp, healingDoneTemp = GetBattlefieldScore(jj);
			if jj ~= REPlayerID and factionTemp == REFactionNum  then
				if REkillingBlows >= killingBlowsTemp then
					REPlaceKBF = REPlaceKBF - 1;
				end
				if REhonorKills >= honorKillsTemp then
					REPlaceHKF = REPlaceHKF - 1;
				end
				if REhonorGained >= honorGainedTemp then
					REPlaceHonorF = REPlaceHonorF - 1;
				end
				if REdamageDone >= damageDoneTemp then
					REPlaceDamageF = REPlaceDamageF - 1;
				end
				if REhealingDone >= healingDoneTemp then
					REPlaceHealingF = REPlaceHealingF - 1;
				end
			end
		end

		SetMapToCurrentZone();
		local REMapInfo = GetMapInfo();
		if REMapInfo == "AlteracValley" then
			RESpecialFields[1] = { GetBattlefieldStatData(REPlayerID, 1), "Interface\\WorldStateFrame\\ColumnIcon-GraveyardCapture" .. REFactionNum };
			RESpecialFields[2] = { GetBattlefieldStatData(REPlayerID, 2), "Interface\\WorldStateFrame\\ColumnIcon-GraveyardDefend" .. REFactionNum };
			RESpecialFields[3] = { GetBattlefieldStatData(REPlayerID, 3), "Interface\\WorldStateFrame\\ColumnIcon-TowerCapture" .. REFactionNum };
			RESpecialFields[4] = { GetBattlefieldStatData(REPlayerID, 4), "Interface\\WorldStateFrame\\ColumnIcon-TowerDefend" .. REFactionNum };
			RESpecialFields[5] = { GetBattlefieldStatData(REPlayerID, 5), "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture2" };
		elseif REMapInfo == "WarsongGulch" or REMapInfo == "TwinPeaks" then
			RESpecialFields[1] = { GetBattlefieldStatData(REPlayerID, 1), "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture" .. REFactionNum };
			RESpecialFields[2] = { GetBattlefieldStatData(REPlayerID, 2), "Interface\\WorldStateFrame\\ColumnIcon-FlagReturn" .. REFactionNum };	
		elseif REMapInfo == "GilneasBattleground2" or REMapInfo == "IsleofConquest" or REMapInfo == "ArathiBasin" or REMapInfo == "StrandoftheAncients" then
			RESpecialFields[1] = { GetBattlefieldStatData(REPlayerID, 1), "Interface\\WorldStateFrame\\ColumnIcon-TowerCapture" .. REFactionNum };
			RESpecialFields[2] = { GetBattlefieldStatData(REPlayerID, 2), "Interface\\WorldStateFrame\\ColumnIcon-TowerDefend" .. REFactionNum };
		elseif REMapInfo == "NetherstormArena" then
			RESpecialFields[1] = { GetBattlefieldStatData(REPlayerID, 1), "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture" .. REFactionNum };
		end

		RESecondTime = true;

		print("\n");
		print("\124cFF74D06C[REFlex]\124r \124cFF555555-\124r " .. REMap .. " \124cFF555555-\124r " .. WIN .. ": " .. REWinSidePrint .. " \124cFF555555-\124r " .. REBGMinutes .. ":" .. REBGSeconds);
		print("\124cFFC5F3BCKB:\124r " .. REkillingBlows .. " (" .. REPlaceKB .. "/" .. REBGPlayers .. ") \124cFF555555* \124cFFC5F3BCHK:\124r " .. REhonorKills .. " (" .. REPlaceHK .. "/" .. REBGPlayers .. ") \124cFF555555* \124cFFC5F3BCH:\124r " .. REhonorGained .. " (" .. REPlaceHonor .. "/" .. REBGPlayers .. ")");
		print("\124cFFC5F3BC" .. DAMAGE .. ":\124r " .. REFlex_NumberClean(REdamageDone, 2) .. " (" .. REPlaceDamage .. "/" .. REBGPlayers .. ") \124cFF555555* \124cFFC5F3BC" .. SHOW_COMBAT_HEALING .. ":\124r " .. REFlex_NumberClean(REhealingDone, 2) .. " (" .. REPlaceHealing .. "/" .. REBGPlayers .. ")");
		if REkillingBlows > RETopKB then
			print("\124cFF74D06C" .. string.upper(NEW) .. " " .. string.upper(KILLING_BLOWS) .. " " .. L["RECORD"] ..":\124r " .. REkillingBlows .. " \124cFF555555-\124r ".. L["Old"] .. ": " .. RETopKB);
		end
		if REhonorKills > RETopHK then
			print("\124cFF74D06C" .. string.upper(NEW) .. " " .. string.upper(L["Honor Kills"]) .. " " .. L["RECORD"] ..":\124r " .. REhonorKills .. " \124cFF555555-\124r ".. L["Old"] .. ": " .. RETopHK);
		end
		if REdamageDone > RETopDamage then
			print("\124cFF74D06C" .. string.upper(NEW) .. " " .. string.upper(DAMAGE) .. " " .. L["RECORD"] ..":\124r " .. REFlex_NumberClean(REdamageDone, 2) .. " \124cFF555555-\124r ".. L["Old"] .. ": " .. REFlex_NumberClean(RETopDamage, 2));
		end
		if REhealingDone > RETopHealing then
			print("\124cFF74D06C" .. string.upper(NEW) .. " " .. string.upper(SHOW_COMBAT_HEALING) .. " " .. L["RECORD"] ..":\124r " .. REFlex_NumberClean(REhealingDone, 2) .. " \124cFF555555-\124r ".. L["Old"] .. ": " .. REFlex_NumberClean(RETopHealing, 2));
		end
		print("\n");

		local REBGData = { DataVersion=REDataVersion, SpecialFields=RESpecialFields, MapName=REMap, MapInfo=REMapInfo, Damage=REdamageDone, Healing=REhealingDone, KB=REkillingBlows, HK=REhonorKills, Honor=REhonorGained, TalentSet=RETalentGroup, Winner=REWinSide, PlayersNum=REBGPlayers, HordeNum=REHordeNum, AliianceNum=REAllianceNum, DurationMin=REBGMinutes, DurationSec=REBGSeconds, DurationRaw=BGTimeRaw, TimeHo=RETimeHour, TimeMi=RETimeMinute, TimeMo=RETimeMonth, TimeDa=RETimeDay, TimeYe=RETimeYear, TimeRaw=RETimeRaw, IsRated=REBGRated, Rating=REBGRating, RatingChange=REBGRatingChange, HordeRating=REBGHordeRating, AllianceRating=REBGAllyRating, PlaceKB=REPlaceKB, PlaceHK=REPlaceHK, PlaceHonor=REPlaceHonor, PlaceDamage=REPlaceDamage, PlaceHealing=REPlaceHealing, PlaceFactionKB=REPlaceKBF, PlaceFactionHK=REPlaceHKF, PlaceFactionHonor=REPlaceHonorF, PlaceFactionDamage=REPlaceDamageF, PlaceFactionHealing=REPlaceHealingF };
		table.insert(REFDatabase, REBGData);			
	elseif REWinner ~= nil and RESecondTime ~= true and REArena == 1 and REArenaRegistered == 1 then
		local REWinSide = REWinner;
		local REMap = GetRealZoneText();
		local REPlayerName = GetUnitName("player");
		local RETalentGroup = GetActiveTalentGroup(false, false);
		local REArenaSeason = GetCurrentArenaSeason();
		local REBGPlayers = GetNumBattlefieldScores();
		local BGTimeRaw = math.floor(GetBattlefieldInstanceRunTime() / 1000);
		local REBGMinutes = math.floor(BGTimeRaw / 60);
		local REBGSeconds = math.floor(BGTimeRaw % 60);
		local RETimeHour, RETimeMinute = GetGameTime();
		local _, RETimeMonth, RETimeDay, RETimeYear = CalendarGetDate();
		local RETimeRaw = time();

		if REBGSeconds < 10 then
			REBGSeconds = "0" .. REBGSeconds;
		end

		if RETimeHour < 10 then
			RETimeHour = "0" .. RETimeHour;
		end

		if RETimeMinute < 10 then
			RETimeMinute = "0" .. RETimeMinute;
		end

		if RETimeDay < 10 then
			RETimeDay = "0" .. RETimeDay;
		end

		if RETimeMonth < 10 then
			RETimeMonth = "0" .. RETimeMonth;
		end

		local REGreenTeamName, REGreenTeamRating, REGreenNewTeamRating = GetBattlefieldTeamInfo(0);
		local REGoldTeamName, REGoldTeamRating, REGoldNewTeamRating = GetBattlefieldTeamInfo(1);

		local RETeamGreen, RETeamGold = {}, {};
		local RELocalDamage, RELocalHealing, RELocalKB = 0, 0, 0;

		for j=1, REBGPlayers do
			local REPlayerTemp = {};
			local REPName, REKillingBlows, _, _, _, REFaction, _, REClass, REClassToken, REDamageDone, REHealingDone = GetBattlefieldScore(j);
			local REBuild = REArenaBuilds[REPName];
			local RERace = REArenaRaces[REPName]; 
			REPLayerTemp = {Name=REPName, KB=REKillingBlows, Race=RERace, Class=REClass, ClassToken=REClassToken, Build=REBuild, Damage=REDamageDone, Healing=REHealingDone};

			if REPName == REPlayerName then
				REPlayerTeam = REFaction;
				RELocalDamage = REDamageDone;
				RELocalHealing = REHealingDone;
				RELocalKB = REKillingBlows;
			end

			if REFaction == 1 then
				table.insert(RETeamGold, REPLayerTemp);
			else
				table.insert(RETeamGreen, REPLayerTemp);
			end
		end

		-- Workaround - GetBattlefieldStatus() is broken
		local REBracket = 0;
		for i=1, 3 do
			local teamName, teamSize = GetArenaTeam(i);
			if (teamName == REGreenTeamName) or (teamName == REGoldTeamName) then
				REBracket = teamSize
				break
			end
		end

		RESecondTime = true;

		local REBGData = { DataVersion=REDataVersion, MapName=REMap, TalentSet=RETalentGroup, Winner=REWinSide, Damage=RELocalDamage, Healing=RELocalHealing, KB=RELocalKB, DurationMin=REBGMinutes, DurationSec=REBGSeconds, DurationRaw=BGTimeRaw, TimeHo=RETimeHour, TimeMi=RETimeMinute, TimeMo=RETimeMonth, TimeDa=RETimeDay, TimeYe=RETimeYear, TimeRaw=RETimeRaw, Season=REArenaSeason, Bracket=REBracket, PlayerTeam=REPlayerTeam, GreenTeamName=REGreenTeamName, GreenTeamRating=REGreenNewTeamRating, GreenTeamRatingChange=(REGreenNewTeamRating - REGreenTeamRating), GoldTeamName=REGoldTeamName, GoldTeamRating=REGoldNewTeamRating, GoldTeamRatingChange=(REGoldNewTeamRating - REGoldTeamRating), GreenTeam=RETeamGreen, GoldTeam=RETeamGold};
		table.insert(REFDatabaseA, REBGData);
	end
end

function REFlex_UpdateMiniBar()
	if RESecondTimeMiniBar ~= true then
		if REMiniBarPluginsCount ~= nil then
			for i=1, REMiniBarPluginsCount do
				_G["REFlex_MiniBar" .. i]:Hide();
			end
		end

		REMiniBarPluginsID = {};
		REMiniBarPluginsCount = 0;
		local i = 1;
		local RESecondLineID = 0;
		local REFirstLineID = 0;

		for j=1, #REFSettings["MiniBarOrder"] do
			if REFSettings["MiniBarVisible"][REFSettings["MiniBarOrder"][j]] == 1 then
				if i ~= 1 then
					CreateFrame("Frame", "REFlex_MiniBar" .. i, _G["REFlex_MiniBar" .. REFirstLineID], "REFlex_MiniBar_Cell");
					_G["REFlex_MiniBar" .. i]:Show();
					_G["REFlex_MiniBar" .. i]:ClearAllPoints();
					_G["REFlex_MiniBar" .. i]:SetPoint("LEFT", _G["REFlex_MiniBar" .. REFirstLineID], "RIGHT", -10 , 0);
					_G["REFlex_MiniBar" .. i]:SetScale(REFSettings["MiniBarScale"]);
					REFirstLineID = i;
				else
					CreateFrame("Frame", "REFlex_MiniBar" .. i, UIParent, "REFlex_MiniBar_Cell_Prime");
					_G["REFlex_MiniBar" .. i]:Show();
					_G["REFlex_MiniBar" .. i]:ClearAllPoints();
					_G["REFlex_MiniBar" .. i]:SetPoint(REFSettings["MiniBarAnchor"], REFSettings["MiniBarX"], REFSettings["MiniBarY"]);
					_G["REFlex_MiniBar" .. i]:SetScale(REFSettings["MiniBarScale"]);
					REFirstLineID = i;
				end
				_G["REFlex_MiniBar" .. i]:Show();

				REMiniBarPluginsID[REFSettings["MiniBarOrder"][j]] = i;
				i = i + 1;
			end
		end
		for j=1, #REFSettings["MiniBarOrder"] do
			if REFSettings["MiniBarVisible"][REFSettings["MiniBarOrder"][j]] == 2 then 
				if REMiniBarSecondLineRdy then
					CreateFrame("Frame", "REFlex_MiniBar" .. i, _G["REFlex_MiniBar" .. RESecondLineID], "REFlex_MiniBar_Cell");
					_G["REFlex_MiniBar" .. i]:Show();
					_G["REFlex_MiniBar" .. i]:ClearAllPoints();
					_G["REFlex_MiniBar" .. i]:SetPoint("LEFT", _G["REFlex_MiniBar" .. RESecondLineID], "RIGHT", -10 , 0);
					_G["REFlex_MiniBar" .. i]:SetScale(REFSettings["MiniBarScale"]);
					RESecondLineID = i;
				else
					CreateFrame("Frame", "REFlex_MiniBar" .. i, REFlex_MiniBar1, "REFlex_MiniBar_Cell");
					_G["REFlex_MiniBar" .. i]:Show();
					_G["REFlex_MiniBar" .. i]:ClearAllPoints();
					_G["REFlex_MiniBar" .. i]:SetPoint("TOP", REFlex_MiniBar1, "BOTTOM", 0 , 10);
					_G["REFlex_MiniBar" .. i]:SetScale(REFSettings["MiniBarScale"]);
					REMiniBarSecondLineRdy = true;
					RESecondLineID = i;
				end
				_G["REFlex_MiniBar" .. i]:Show();

				REMiniBarPluginsID[REFSettings["MiniBarOrder"][j]] = i;
				i = i + 1;
			end
		end

		REMiniBarPluginsCount = i - 1;
		REMPlayerName = GetUnitName("player");
		RESecondTimeMiniBar = true;
	end

	local REMName = "";
	local i = 1;
	while REMName ~= REMPlayerName do
		REMName = GetBattlefieldScore(i);
		REMPlayerID = i;
		i = i + 1;
	end

	local REMBGPlayers = GetNumBattlefieldScores();
	local REMMaxKB, REMMaxHK, REMMaxDamage, REMMaxHealing, REMMaxDeaths, REMMaxHonorGained = 0, 0, 0, 0, 0, 0;
	local _, REMkillingBlows, REMhonorKills, REMdeaths, REMhonorGained, _, _, _, _, REMdamageDone, REMhealingDone = GetBattlefieldScore(REMPlayerID);

	for j=1, REMBGPlayers do
		if j ~= REMPlayerID then
			local _, killingBlowsTemp, honorKillsTemp, deathsTemp, honorGainedTemp, _, _, _, _, damageDoneTemp, healingDoneTemp = GetBattlefieldScore(j);
			if REMMaxKB < killingBlowsTemp then
				REMMaxKB = killingBlowsTemp;
			end
			if REMMaxHK < honorKillsTemp then
				REMMaxHK = honorKillsTemp;
			end
			if REMMaxDamage < damageDoneTemp then
				REMMaxDamage = damageDoneTemp;
			end
			if REMMaxHealing < healingDoneTemp then
				REMMaxHealing = healingDoneTemp;
			end
			if REMMaxDeaths < deathsTemp then
				REMMaxDeaths = deathsTemp;
			end
			if REMMaxHonorGained < honorGainedTemp then
				REMMaxHonorGained = honorGainedTemp;
			end
		end
	end

	local REMKBD = REMkillingBlows - REMMaxKB;
	local REMHKD = REMhonorKills - REMMaxHK;
	local REMDamageD = REMdamageDone - REMMaxDamage;
	local REMHealingD = REMhealingDone - REMMaxHealing;
	local REMDeathsD = REMdeaths - REMMaxDeaths;
	local REMHonorD = REMhonorGained - REMMaxHonorGained;
	if REMdeaths ~= 0 then
		REMKDRatio = REFlex_Round(REMkillingBlows/REMdeaths, 2);
	else
		REMKDRatio = REMkillingBlows;
	end

	for j=1, #REFSettings["MiniBarOrder"] do
		if REMiniBarPluginsID[REFSettings["MiniBarOrder"][j]] ~= nil then
			if REFSettings["MiniBarOrder"][j] == "KillingBlows" then
				if REMKBD > 0 then
					REMKBD = "|cFF00ff00+" .. REMKBD .. "|r"
				elseif REMKBD < 0 then
					REMKBD = "|cFFFF141D" .. REMKBD .. "|r"
				end

				REMiniBarLabel = "KB:";
				REMiniBarValue = REMkillingBlows .. " (" .. REMKBD .. ")";
			elseif REFSettings["MiniBarOrder"][j] == "HonorKills" then
				if REMHKD > 0 then
					REMHKD = "|cFF00ff00+" .. REMHKD .. "|r"
				elseif REMHKD < 0 then
					REMHKD = "|cFFFF141D" .. REMHKD .. "|r"
				end

				REMiniBarLabel = "HK:";
				REMiniBarValue = REMhonorKills .. " (" .. REMHKD .. ")";
			elseif REFSettings["MiniBarOrder"][j] == "Damage" then
				if REMDamageD > 0 then
					if REMDamageD >= 1000000 then
						REMDamageD = "|cFF00ff00+" .. REFlex_NumberClean(REMDamageD, 2) .. "|r"
					else
						REMDamageD = "|cFF00ff00+" .. REFlex_NumberClean(REMDamageD, 0) .. "|r"
					end
				elseif REMDamageD < 0 then
					if REMDamageD <= -1000000 then
						REMDamageD = "|cFFFF141D" .. REFlex_NumberClean(REMDamageD, 2) .. "|r"
					else
						REMDamageD = "|cFFFF141D" .. REFlex_NumberClean(REMDamageD, 0) .. "|r"
					end
				end

				REMiniBarLabel = "Dam:";
				if REMdamageDone > 1000000 then
					REMiniBarValue = REFlex_NumberClean(REMdamageDone, 2) .. " (" .. REMDamageD .. ")";
				else
					REMiniBarValue = REFlex_NumberClean(REMdamageDone, 0) .. " (" .. REMDamageD .. ")";
				end
			elseif REFSettings["MiniBarOrder"][j] == "Healing" then
				if REMHealingD > 0 then
					if REMHealingD >= 1000000 then
						REMHealingD = "|cFF00ff00+" .. REFlex_NumberClean(REMHealingD, 2) .. "|r"
					else
						REMHealingD = "|cFF00ff00+" .. REFlex_NumberClean(REMHealingD, 0) .. "|r"
					end
				elseif REMHealingD < 0 then
					if REMHealingD <= -1000000 then
						REMHealingD = "|cFFFF141D" .. REFlex_NumberClean(REMHealingD, 2) .. "|r"
					else
						REMHealingD = "|cFFFF141D" .. REFlex_NumberClean(REMHealingD, 0) .. "|r"
					end
				end

				REMiniBarLabel = "Hea:";
				if REMhealingDone > 1000000 then
					REMiniBarValue = REFlex_NumberClean(REMhealingDone, 2) .. " (" .. REMHealingD .. ")";
				else
					REMiniBarValue = REFlex_NumberClean(REMhealingDone, 0) .. " (" .. REMHealingD .. ")";
				end
			elseif REFSettings["MiniBarOrder"][j] == "Deaths" then
				if REMDeathsD > 0 then
					REMDeathsD = "|cFFFF141D+" .. REMDeathsD .. "|r"
				elseif REMDeathsD < 0 then
					REMDeathsD = "|cFF00ff00" .. REMDeathsD .. "|r"
				end

				REMiniBarLabel = "Dea:";
				REMiniBarValue = REMdeaths .. " (" .. REMDeathsD .. ")";
			elseif REFSettings["MiniBarOrder"][j] == "KDRatio" then
				REMiniBarLabel = "K/D:";
				if REMKDRatio >= 1 then
					REMiniBarValue = "|cFF00ff00" .. REMKDRatio .. "|r";
				else
					REMiniBarValue = "|cFFFF141D" .. REMKDRatio .. "|r";
				end
			elseif REFSettings["MiniBarOrder"][j] == "Honor" then
				if REMHonorD > 0 then
					REMHonorD = "|cFF00ff00+" .. REMHonorD .. "|r"
				elseif REMHonorD < 0 then
					REMHonorD = "|cFFFF141D" .. REMHonorD .. "|r"
				end

				REMiniBarLabel = "Hon:";
				REMiniBarValue = REMhonorGained .. " (" .. REMHonorD .. ")";
			end

			_G["REFlex_MiniBar" .. REMiniBarPluginsID[REFSettings["MiniBarOrder"][j]] .. "_Label"]:SetText(REMiniBarLabel);
			_G["REFlex_MiniBar" .. REMiniBarPluginsID[REFSettings["MiniBarOrder"][j]] .. "_Value"]:SetText(REMiniBarValue);
		end
	end
end

function SlashCmdList.REFLEX(msg)
	--TODO
	REFlex_MinimapButtonClick();
end
-- ***
