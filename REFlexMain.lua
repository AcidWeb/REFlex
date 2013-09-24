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

RE.DataVersion = 9;
RE.AddonVersion = "v0.9.3";
RE.AddonVersionCheck = 93;

RE.Debug = false;

RE.ArenaBuilds = {};
RE.ArenaTeams = {};
RE.ArenaRaces = {};
RE.ArenaTeamsSpec = {["2"] = {}, ["3"] = {}, ["5"] = {}, ["All"] = {}, ["AllNoTalent"] = {}};

RE.ArenaReload = true;
RE.BattlegroundReload = true;

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

RE.Options = {"ShowMinimapButton", "ShowMiniBar", "ShowDetectedBuilds", "ArenaSupport", "RBGSupport", "UNBGSupport", "LDBBGMorph", "LDBCPCap", "LDBHK", "LDBShowPlace", "LDBShowQueues", "LDBShowTotalBG", "LDBShowTotalArena"}
RE.DeleteID = 0;
RE.PartyArenaCheck = 0;
RE.MiniBarPluginsCount = 0;
RE.RBGCounter = 1;
RE.SlashTrigger = "";
RE.LDBQueue = "";
RE.HonorCap = 4000;

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
};

RE.BuildRecognition = {      
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

-- *** Event & initialisation functions

function REFlex_OnLoad(self)
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	self:RegisterEvent("ADDON_LOADED");
	self:RegisterEvent("PVP_RATED_STATS_UPDATE");
	self:RegisterEvent("ARENA_OPPONENT_UPDATE");
	self:RegisterEvent("UNIT_SPELLCAST_START");
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
	self:RegisterEvent("UNIT_AURA");
	self:RegisterEvent("CHAT_MSG_ADDON");
	self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
	self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");

	WorldStateScoreFrame:HookScript("OnShow", REFlex_BGEnd);
	WorldStateScoreFrame:HookScript("OnHide", function(self) REFlex_ScoreTab:Hide() end);
	StaticPopup1:HookScript("OnShow", REFlex_EntryPopup);

	RE.SecondTime = false;
	RE.SecondTimeMainTab = false;
	RE.SecondTimeMiniBar = false;
	RE.SecondTimeMiniBarTimer = false;
end

function REFlex_OnEvent(self,Event,...)
	local _, REZoneType = IsInInstance();
	if Event == "UPDATE_BATTLEFIELD_SCORE" and REZoneType == "pvp" then
		if RE.SecondTimeMiniBarTimer ~= true and (REFSettings["ShowMiniBar"] or REFSettings["LDBBGMorph"]) then
			REFlex_Frame:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE");
			RE.ShefkiTimer:ScheduleTimer(REFlex_MiniBarDelay, 30);
			RE.SecondTimeMiniBarTimer = true;
		elseif RE.SecondTimeMiniBarTimer and (REFSettings["ShowMiniBar"] or REFSettings["LDBBGMorph"]) then
			REFlex_UpdateMiniBar();
		end
	elseif Event == "UPDATE_BATTLEFIELD_STATUS" and REFSettings["LDBShowQueues"] and ((REZoneType ~= "pvp" and REZoneType ~= "arena") or REFSettings["LDBBGMorph"] == false) then
		RE.LDBQueue = "";
		for j=1, MAX_BATTLEFIELD_QUEUES do
			REFlex_UpdateLDBQueues(j);
		end
		REFlex_UpdateLDB();
	elseif (Event == "UNIT_SPELLCAST_START" or Event == "UNIT_SPELLCAST_SUCCEEDED") and REZoneType == "arena" and REFSettings["ArenaSupport"] then
		local REUnitID, RESpellName = ...;

		if REUnitID == "arena1" or REUnitID == "arena2" or REUnitID == "arena3" or REUnitID == "arena4" or REUnitID == "arena5" and REFSettings["ArenaSupport"] then
			if RE.BuildRecognition[RESpellName] ~= nil then
				local REName = table.concat({ strsplit(" ", GetUnitName(REUnitID, true), 3) });
				if RE.ArenaBuilds[REName] == nil and REName ~= UNKNOWN then
					_, RE.ArenaRaces[REName] = UnitRace(REUnitID);
					RE.ArenaBuilds[REName] = RE.BuildRecognition[RESpellName];
					local _, RETempClass = UnitClass(REUnitID);
					if REFSettings["ShowDetectedBuilds"] then
						UIErrorsFrame:AddMessage("\124cFF" .. RE.ClassColors[RETempClass] .. REFlex_NameClean(REName) .. " - " .. RE.BuildRecognition[RESpellName] .. "\124r", 1, 1, 1, 1.0);
						print("\124cFF74D06C[REFlex]\124r " .. REFlex_NameClean(REName) .. " - " .. RE.BuildRecognition[RESpellName]);
					end
				end
			end
		end
	elseif Event == "UNIT_AURA" and REZoneType == "arena" and REFSettings["ArenaSupport"] then
		local REUnitID = ...;

		if REUnitID == "arena1" or REUnitID == "arena2" or REUnitID == "arena3" or REUnitID == "arena4" or REUnitID == "arena5" then
			for i=1, 20 do
				local  REAuraName, _, _, _, _, _, _, RECaster = UnitAura(REUnitID, i, "HELPFUL")
				if not REAuraName then 
					break 
				end
				if RE.BuildRecognition[REAuraName] ~= nil and RECaster ~= "" and RECaster ~= nil then
					local REName = table.concat({ strsplit(" ", GetUnitName(RECaster, true), 3) });
					if RE.ArenaBuilds[REName] == nil and REName ~= UNKNOWN then
						_, RE.ArenaRaces[REName] = UnitRace(RECaster); 
						RE.ArenaBuilds[REName] = RE.BuildRecognition[REAuraName];
						local _, RETempClass = UnitClass(RECaster);
						if REFSettings["ShowDetectedBuilds"] then
							UIErrorsFrame:AddMessage("\124cFF" .. RE.ClassColors[RETempClass] .. REFlex_NameClean(REName) .. " - " .. RE.BuildRecognition[REAuraName] .. "\124r", 1, 1, 1, 1.0);
							print("\124cFF74D06C[REFlex]\124r " .. REFlex_NameClean(REName) .. " - " .. RE.BuildRecognition[REAuraName]);
						end
					end
				end
			end
		end
	elseif Event == "ARENA_OPPONENT_UPDATE" and REZoneType == "arena" and REFSettings["ArenaSupport"] then
		REFlex_Frame:UnregisterEvent("ARENA_OPPONENT_UPDATE");
		RE.ArenaBuilds = {};
		RE.PartyArenaCheck = 0;
		RE.ArenaRaces = {};
		RE.ShefkiTimer:ScheduleTimer(REFlex_ArenaTalentCheck, 30);
	elseif Event == "INSPECT_READY" then
		REFlex_Frame:UnregisterEvent("INSPECT_READY");
		local REInspectedGID = ...
		if REInspectedGID == UnitGUID("party" .. RE.PartyArenaCheck) then
			local RETalentGroup = GetActiveTalentGroup(true);
			local REPartyName = GetUnitName("party" .. RE.PartyArenaCheck, true);
			_, RE.ArenaRaces[REPartyName] = UnitRace("party" .. RE.PartyArenaCheck);

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

			RE.ArenaBuilds[REPartyName] = REBuildName;
			RE.PartyArenaCheck = RE.PartyArenaCheck + 1;
		end
		REFlex_ArenaTalentCheck();
	elseif Event == "CHAT_MSG_ADDON" and ... == "REFlex" then
		local _, REMessage, _, RESender = ...;
		if RE.Debug == true then
			print("\124cFF74D06C[REFlex]\124r " .. RESender .. " - " .. REMessage);
		end
		if RESender == "Livarax" or RESender == "Livarax-Karazhan" then
			print("\124cFF74D06C[REFlex]\124r You played with REFlex author :-) FOR THE HORDE!");
		elseif tonumber(REMessage) > RE.AddonVersionCheck then
			REFlex_Frame:UnregisterEvent("CHAT_MSG_ADDON");
			print("\124cFF74D06C[REFlex]\124r " .. L["New version released!"]);
		end
	elseif Event == "PVP_RATED_STATS_UPDATE" and REZoneType == "none" then
		-- Workaround - GetPersonalRatedBGInfo() is glitched
		if RE.RBGCounter == 4 then
			_, _, RE.RBGPointsWeek, RE.RBGMaxPointsWeek = GetPersonalRatedBGInfo();
			RE.RBG = GetPersonalRatedBGInfo();
			REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_I:SetMinMaxValues(0, RE.RBGMaxPointsWeek);
			REFlex_MainTab_Tab6_ScoreHolderSpecial_BarCP_I:SetMinMaxValues(0, RE.RBGMaxPointsWeek);
			local _, _, REToday = CalendarGetDate();

			if REToday ~= REFSettings["LastDay"] then
				REFSettings["LastDay"] = REToday;
				_, REFSettings["LastDayStats"]["Honor"] = GetCurrencyInfo(HONOR_CURRENCY);
				_, REFSettings["LastDayStats"]["CP"] = GetCurrencyInfo(CONQUEST_CURRENCY);
				local team2ID = ArenaTeam_GetTeamSizeID(2);
				local team3ID = ArenaTeam_GetTeamSizeID(3);
				local team5ID = ArenaTeam_GetTeamSizeID(5);
				REFSettings["LastDayStats"]["2v2"], REFSettings["LastDayStats"]["3v3"], REFSettings["LastDayStats"]["5v5"] = 0, 0, 0;
				if team2ID ~= nil then
					_, _, _, _, _, _, _, _, _, _, REFSettings["LastDayStats"]["2v2"] = GetArenaTeam(team2ID);
				end
				if team3ID ~= nil then
					_, _, _, _, _, _, _, _, _, _, REFSettings["LastDayStats"]["3v3"] = GetArenaTeam(team3ID);
				end
				if team5ID ~= nil then
					_, _, _, _, _, _, _, _, _, _, REFSettings["LastDayStats"]["5v5"] = GetArenaTeam(team5ID);
				end
				REFSettings["LastDayStats"]["RBG"] = RE.RBG;
			end

			REFlex_UpdateLDB();
		else	
			RE.RBGCounter = RE.RBGCounter + 1;
			RequestRatedBattlegroundInfo();
		end
	elseif Event == "ZONE_CHANGED_NEW_AREA" and (REZoneType == "none" or REZoneType == "party" or REZoneType == "raid") then
		REFlex_Frame:RegisterEvent("ARENA_OPPONENT_UPDATE");
		RE.SecondTime = false;
		RE.SecondTimeMiniBar = false;
		RE.SecondTimeMiniBarTimer = false;
		RE.MiniBarSecondLineRdy = false;
		REFlex_UpdateLDB();

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

		RequestRatedBattlegroundInfo();
	elseif Event == "ACTIVE_TALENT_GROUP_CHANGED" then
		print("\124cFF74D06C[REFlex]\124r " .. L["Reloaded MiniBar settings"]);
		RE.ActiveTalentGroup = GetActiveTalentGroup(false, false);
		REFlex_SettingsReload();
	elseif Event == "ADDON_LOADED" and ... == "REFlex" then
		BINDING_HEADER_REFLEXB = "REFlex";
		BINDING_NAME_REFLEXSHOW = L["Show main window"];

		REFlex_ScoreTab_MsgGuild:SetText(GUILD); 
		REFlex_ScoreTab_MsgParty:SetText(PARTY);
		REFlex_MainTab_MsgGuild:SetText(GUILD); 
		REFlex_MainTab_MsgParty:SetText(PARTY);
		REFlex_MainTab_Tab5_Search:SetText(SEARCH); 
		REFlex_MainTab_Tab5_Clear:SetText(RESET);
		REFlex_MainTab_Tab5_SearchBox:SetText(NAME);
		REFlex_MainTab_Tab5_SearchBox:SetAutoFocus(false);
		REFlex_MainTab_Tab5_Search:SetScale(0.85);
		REFlex_MainTab_Tab5_Clear:SetScale(0.85);

		REFlex_MainTab_Title:SetText("REFlex " .. RE.AddonVersion);
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
			REFSettings = {["Version"] = RE.DataVersion ,["MinimapPos"] = 45, ["ShowDetectedBuilds"] = true, ["ShowMinimapButton"] = true, ["ShowMiniBar"] = false, ["MiniBarX"] = 0, ["MiniBarY"] = 0, ["MiniBarAnchor"] = "CENTER", ["MiniBarScale"] = 1, ["ArenasListFirstTime"] = true, ["LDBBGMorph"] = true, ["LDBShowPlace"] = false, ["LDBShowQueues"] = true, ["LDBCPCap"] = true, ["LDBHK"] = false, ["LDBShowTotalBG"] = false, ["LDBShowTotalArena"] = false, ["ArenaSupport"] = true, ["RBGSupport"] = true, ["UNBGSupport"] = true, ["LastDay"] = 0, ["LastDayStats"] = {["Honor"] = 0, ["CP"] = 0, ["2v2"] = 0, ["3v3"] = 0, ["5v5"] = 0, ["RBG"] = 0}, ["MiniBarOrder"] = {}, ["MiniBarVisible"] = {}};
			REFSettings["MiniBarVisible"][1] = {["KillingBlows"] = 1, ["HonorKills"] = 1, ["Damage"] = 2, ["Healing"] = 2, ["Deaths"] = nil, ["KDRatio"] = nil, ["Honor"] = nil};
			REFSettings["MiniBarVisible"][2] = {["KillingBlows"] = 1, ["HonorKills"] = 1, ["Damage"] = 2, ["Healing"] = 2, ["Deaths"] = nil, ["KDRatio"] = nil, ["Honor"] = nil};
			REFSettings["MiniBarOrder"][1] = {"KillingBlows", "HonorKills", "Damage", "Healing", "Deaths", "KDRatio", "Honor"};
			REFSettings["MiniBarOrder"][2] = {"KillingBlows", "HonorKills", "Damage", "Healing", "Deaths", "KDRatio", "Honor"};
		elseif REFSettings["Version"] == 8 then -- 0.9.1
			REFSettings["Version"] = RE.DataVersion;
		elseif REFSettings["Version"] == 7 then -- 0.9
			REFSettings["Version"] = RE.DataVersion;
			REFSettings["LDBShowPlace"] = false;
			REFSettings["LDBShowQueues"] = true;
			REFSettings["LDBShowTotalBG"] = false;
			REFSettings["LDBShowTotalArena"] = false;
		elseif REFSettings["Version"] == 6 then -- 0.8.8
			REFSettings["Version"] = RE.DataVersion;
			REFSettings["LDBBGMorph"] = true;
			REFSettings["LDBCPCap"] = true;
			REFSettings["LDBHK"] = false;
			REFSettings["MiniBarVisible"] = {};
			REFSettings["MiniBarVisible"][1] = {["KillingBlows"] = 1, ["HonorKills"] = 1, ["Damage"] = 2, ["Healing"] = 2, ["Deaths"] = nil, ["KDRatio"] = nil, ["Honor"] = nil}
			REFSettings["MiniBarVisible"][2] = {["KillingBlows"] = 1, ["HonorKills"] = 1, ["Damage"] = 2, ["Healing"] = 2, ["Deaths"] = nil, ["KDRatio"] = nil, ["Honor"] = nil}
			REFSettings["MiniBarOrder"] = {};
			REFSettings["MiniBarOrder"][1] = {"KillingBlows", "HonorKills", "Damage", "Healing", "Deaths", "KDRatio", "Honor"};
			REFSettings["MiniBarOrder"][2] = {"KillingBlows", "HonorKills", "Damage", "Healing", "Deaths", "KDRatio", "Honor"};
			REFSettings["LastDay"] = 0;
			REFSettings["LastDayStats"] = {["Honor"] = 0, ["CP"] = 0, ["2v2"] = 0, ["3v3"] = 0, ["5v5"] = 0, ["RBG"] = 0};
			REFSettings["LDBShowPlace"] = false;
			REFSettings["LDBShowQueues"] = true;
			REFSettings["LDBShowTotalBG"] = false;
			REFSettings["LDBShowTotalArena"] = false;
		elseif REFSettings["Version"] == 5 then -- 0.8.7
			REFSettings["Version"] = RE.DataVersion;
			REFSettings["ArenasListFirstTime"] = true;
			REFSettings["ArenaSupport"] = true;
			REFSettings["RBGSupport"] = true;
			REFSettings["UNBGSupport"] = true;
			REFSettings["LDBBGMorph"] = true;
			REFSettings["LDBCPCap"] = true;
			REFSettings["LDBHK"] = false;
			REFSettings["MiniBarVisible"] = {};
			REFSettings["MiniBarVisible"][1] = {["KillingBlows"] = 1, ["HonorKills"] = 1, ["Damage"] = 2, ["Healing"] = 2, ["Deaths"] = nil, ["KDRatio"] = nil, ["Honor"] = nil}
			REFSettings["MiniBarVisible"][2] = {["KillingBlows"] = 1, ["HonorKills"] = 1, ["Damage"] = 2, ["Healing"] = 2, ["Deaths"] = nil, ["KDRatio"] = nil, ["Honor"] = nil}
			REFSettings["MiniBarOrder"] = {};
			REFSettings["MiniBarOrder"][1] = {"KillingBlows", "HonorKills", "Damage", "Healing", "Deaths", "KDRatio", "Honor"};
			REFSettings["MiniBarOrder"][2] = {"KillingBlows", "HonorKills", "Damage", "Healing", "Deaths", "KDRatio", "Honor"};
			REFSettings["LastDay"] = 0;
			REFSettings["LastDayStats"] = {["Honor"] = 0, ["CP"] = 0, ["2v2"] = 0, ["3v3"] = 0, ["5v5"] = 0, ["RBG"] = 0};
			REFSettings["LDBShowPlace"] = false;
			REFSettings["LDBShowQueues"] = true;
			REFSettings["LDBShowTotalBG"] = false;
			REFSettings["LDBShowTotalArena"] = false;
		elseif REFSettings["Version"] ~= RE.DataVersion then -- 0.8.1 and older
			REFSettings["Version"] = RE.DataVersion;
			REFSettings["ShowDetectedBuilds"] = true;
			REFSettings["ArenasListFirstTime"] = true;
			REFSettings["ArenaSupport"] = true;
			REFSettings["RBGSupport"] = true;
			REFSettings["UNBGSupport"] = true;
			REFSettings["LDBBGMorph"] = true;
			REFSettings["LDBCPCap"] = true;
			REFSettings["LDBHK"] = false;
			REFSettings["MiniBarVisible"] = {};
			REFSettings["MiniBarVisible"][1] = {["KillingBlows"] = 1, ["HonorKills"] = 1, ["Damage"] = 2, ["Healing"] = 2, ["Deaths"] = nil, ["KDRatio"] = nil, ["Honor"] = nil}
			REFSettings["MiniBarVisible"][2] = {["KillingBlows"] = 1, ["HonorKills"] = 1, ["Damage"] = 2, ["Healing"] = 2, ["Deaths"] = nil, ["KDRatio"] = nil, ["Honor"] = nil}
			REFSettings["MiniBarOrder"] = {};
			REFSettings["MiniBarOrder"][1] = {"KillingBlows", "HonorKills", "Damage", "Healing", "Deaths", "KDRatio", "Honor"};
			REFSettings["MiniBarOrder"][2] = {"KillingBlows", "HonorKills", "Damage", "Healing", "Deaths", "KDRatio", "Honor"};
			REFSettings["MiniBarAnchor"] = "CENTER";
			REFSettings["MiniBarScale"] = 1;
			REFSettings["LastDay"] = 0;
			REFSettings["LastDayStats"] = {["Honor"] = 0, ["CP"] = 0, ["2v2"] = 0, ["3v3"] = 0, ["5v5"] = 0, ["RBG"] = 0};
			REFSettings["LDBShowPlace"] = false;
			REFSettings["LDBShowQueues"] = true;
			REFSettings["LDBShowTotalBG"] = false;
			REFSettings["LDBShowTotalArena"] = false;

			for i=1, #REFDatabase do
				if REFDatabase[i]["SpecialFields"] == nil then
					REFDatabase[i]["DataVersion"] = RE.DataVersion;
					REFDatabase[i]["SpecialFields"] = {};
				end
			end
		end
		---

		RE.ActiveTalentGroup = GetActiveTalentGroup(false, false);
		REFlex_LoadLDB();
		REFlex_UpdateLDB();
		REFlex_SettingsReload();

		RegisterAddonMessagePrefix("REFlex");
		SendAddonMessage("REFlex", RE.AddonVersionCheck, "GUILD");

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
		RE.BracketDrop = 5;
		RE.Tab5LastID = 0;
		RE.Tab5TableData = {};
	elseif REFlex_MainTab_Tab5_DropDown["selectedID"] == 3 then
		RE.BracketDrop = 3;	
		RE.Tab5LastID = 0;
		RE.Tab5TableData = {};
	elseif REFlex_MainTab_Tab5_DropDown["selectedID"] == 2 then
		RE.BracketDrop = 2;
		RE.Tab5LastID = 0;
		RE.Tab5TableData = {};
	else
		RE.BracketDrop = nil;
		RE.Tab5LastID = 0;
		RE.Tab5TableData = {};
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
	if RECommand == "RBGWipe" then
		RESlashBGWipe(true, "Rated");
	elseif RECommand == "UNRBGWipe" then
		RESlashBGWipe(false, "Unrated");
	elseif RECommand == "2v2Wipe" then
		RESlashArenaWipe(2);
	elseif RECommand == "3v3Wipe" then
		RESlashArenaWipe(3);
	elseif RECommand == "5v5Wipe" then
		RESlashArenaWipe(5);
	elseif RECommand == "OldSeasonWipe" then
		RESlashArenaSeasonWipe(GetCurrentArenaSeason());
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
		print("\124cFF74D06C[REFlex]\124r " .. L["Issue command second time to confirm database wipe"]);
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
		print("\124cFF74D06C[REFlex]\124r " .. L["Issue command second time to confirm database wipe"]);
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
		ReloadUI();
	else
		RE.SlashTrigger = "ArenaSeasonWipe" .. Season;
		print("\124cFF74D06C[REFlex]\124r " .. L["Issue command second time to confirm database wipe"]);
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
end

function REFlex_SetTabs()
	REFlex_MainTabTab1:Show();
	REFlex_MainTabTab2:Show();
	REFlex_MainTabTab3:Show();
	REFlex_MainTabTab4:Show();
	REFlex_MainTabTab5:Show();
	REFlex_MainTabTab6:Show();

	if REFSettings["UNBGSupport"] then
		if REFSettings["RBGSupport"] then
			REFlex_MainTabTab1:SetPoint("CENTER", "REFlex_MainTab", "BOTTOMLEFT", 35, -10);
			REFlex_MainTabTab2:SetPoint("LEFT", "REFlex_MainTabTab1", "RIGHT", -16, 0);
			REFlex_MainTabTab3:SetPoint("LEFT", "REFlex_MainTabTab2", "RIGHT", -16, 0);
			REFlex_MainTabTab4:SetPoint("LEFT", "REFlex_MainTabTab3", "RIGHT", -16, 0);
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
			REFlex_MainTabTab4:SetPoint("LEFT", "REFlex_MainTabTab3", "RIGHT", -16, 0);
			if REFSettings["ArenaSupport"] then
				REFlex_MainTabTab5:SetPoint("LEFT", "REFlex_MainTabTab4", "RIGHT", -6, 0);
				REFlex_MainTabTab6:SetPoint("LEFT", "REFlex_MainTabTab5", "RIGHT", -16, 0);
			else
				REFlex_MainTabTab5:Hide();
				REFlex_MainTabTab6:Hide();
			end
		else
			REFlex_MainTabTab3:Hide();
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
		SendChatMessage("[REFlex] - " .. RE.Map .. " - " .. WIN .. ": " .. REWinSide .. " - " .. RE.BGMinutes .. ":" .. RE.BGSeconds .. " - " .. RATING .. ": " .. RE.BGRatingChange, Channel ,nil ,nil);
		SendChatMessage("<KB> " .. RE.killingBlows .. " (" .. RE.PlaceKB .. "/" .. RE.BGPlayers .. ") - <HK> " .. RE.honorKills .. " (" .. RE.PlaceHK .. "/" .. RE.BGPlayers .. ")", Channel ,nil ,nil);
		SendChatMessage("<" .. DAMAGE .. "> " .. REFlex_NumberClean(RE.damageDone) .. " (" .. RE.PlaceDamage .. "/" .. RE.BGPlayers .. ") - <" .. SHOW_COMBAT_HEALING .. "> " .. REFlex_NumberClean(RE.healingDone) .. " (" .. RE.PlaceHealing .. "/" .. RE.BGPlayers .. ")", Channel ,nil ,nil);
	else
		SendChatMessage("[REFlex] - " .. RE.Map .. " - " .. WIN .. ": " .. REWinSide .. " - " .. RE.BGMinutes .. ":" .. RE.BGSeconds,Channel ,nil ,nil);
		SendChatMessage("<KB> " .. RE.killingBlows .. " (" .. RE.PlaceKB .. "/" .. RE.BGPlayers .. ") - <HK> " .. RE.honorKills .. " (" .. RE.PlaceHK .. "/" .. RE.BGPlayers .. ") - <H> " .. RE.honorGained .. " (" .. RE.PlaceHonor .. "/" .. RE.BGPlayers .. ")", Channel ,nil ,nil);
		SendChatMessage("<" .. DAMAGE .. "> " .. REFlex_NumberClean(RE.damageDone) .. " (" .. RE.PlaceDamage .. "/" .. RE.BGPlayers .. ") - <" .. SHOW_COMBAT_HEALING .. "> " .. REFlex_NumberClean(RE.healingDone) .. " (" .. RE.PlaceHealing .. "/" .. RE.BGPlayers .. ")", Channel ,nil ,nil);
	end
end

function REFlex_MainOnClick(Channel)
	local REAddidional = "";
	if PanelTemplates_GetSelectedTab(REFlex_MainTab) == 3 then
		REAddidional = " - " .. L["Rated BGs"];
	elseif PanelTemplates_GetSelectedTab(REFlex_MainTab) == 2 then
		REAddidional = " - " .. L["Unrated BGs"];	
	end
	SendChatMessage("[REFlex] " .. WINS .. ": " .. RE.Wins .. " - " .. LOSSES .. ": " .. RE.Losses .. REAddidional,Channel ,nil ,nil);
	SendChatMessage("<KB> " .. L["Total"] .. ": " .. RE.SumKB .. " - " .. L["Top"] .. ": " .. RE.TopKB .. " <HK> " .. L["Total"] .. ": " .. RE.SumHK .. " - " .. L["Top"] .. ": " .. RE.TopHK, Channel ,nil ,nil);
	SendChatMessage("<" .. DAMAGE .. "> " .. L["Total"] .. ": " .. REFlex_NumberClean(RE.SumDamage) .. " - " .. L["Top"] .. ": " .. REFlex_NumberClean(RE.TopDamage), Channel ,nil ,nil);
	SendChatMessage("<" .. SHOW_COMBAT_HEALING .. "> " .. L["Total"] .. ": " .. REFlex_NumberClean(RE.SumHealing) .. " - " .. L["Top"] .. ": " .. REFlex_NumberClean(RE.TopHealing), Channel ,nil ,nil);
end

function REFlex_SearchOnClick()
	RE.NameSearch = REFlex_MainTab_Tab5_SearchBox:GetText();
	REFlex_MainTab_Tab5_SearchBox:ClearFocus();
	RE.MainTable5:SetFilter(REFlex_Tab_NameFilter);
end

function REFlex_ClearOnClick()
	REFlex_MainTab_Tab5_SearchBox:SetText(NAME);
	REFlex_MainTab_Tab5_SearchBox:ClearFocus();
	RE.MainTable5:SetFilter(REFlex_Tab_DefaultFilter);
	RE.NameSearch = nil;
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
			REExport = "Time;Date;TimeHour;TimeMinutes;DateDay;DateMonth;DateYear;Map;DurationMinutes;DurationSeconds;Winner;KillingBlows;HonorableKills;Damage;Healing;Honor;PlaceKillingBlows;PlaceHonorableKills;PlaceDamage;PlaceHealing;PlaceHonor;FactionPlaceKillingBlows;FactionPlaceHonorableKills;FactionPlaceDamage;FactionPlaceHealing;FactionPlaceHonor;TowersCaptured;TowersDefended;FlagsCaptured;FlagsReturned;GraveyardsCaptured;GraveyardsDefended;TalentSet;PlayersNumber;AlliancePlayers;HordePlayers;IsRated;RatingChange;AllianceRating;HordeRating\n";
		elseif RERated == false then
			REExport = "Time;Date;TimeHour;TimeMinutes;DateDay;DateMonth;DateYear;Map;DurationMinutes;DurationSeconds;Winner;KillingBlows;HonorableKills;Damage;Healing;Honor;PlaceKillingBlows;PlaceHonorableKills;PlaceDamage;PlaceHealing;PlaceHonor;FactionPlaceKillingBlows;FactionPlaceHonorableKills;FactionPlaceDamage;FactionPlaceHealing;FactionPlaceHonor;TowersCaptured;TowersDefended;FlagsCaptured;FlagsReturned;GraveyardsCaptured;GraveyardsDefended;TalentSet;PlayersNumber;AlliancePlayers\n";
		elseif RERated == true then
			REExport = "Time;Date;TimeHour;TimeMinutes;DateDay;DateMonth;DateYear;Map;DurationMinutes;DurationSeconds;Winner;KillingBlows;HonorableKills;Damage;Healing;Honor;PlaceKillingBlows;PlaceHonorableKills;PlaceDamage;PlaceHealing;PlaceHonor;FactionPlaceKillingBlows;FactionPlaceHonorableKills;FactionPlaceDamage;FactionPlaceHealing;FactionPlaceHonor;TowersCaptured;TowersDefended;FlagsCaptured;FlagsReturned;GraveyardsCaptured;GraveyardsDefended;TalentSet;PlayersNumber;AlliancePlayers;HordePlayers;RatingChange;AllianceRating;HordeRating\n";
		end

		local RELine = "";
		for i=1, #REFDatabase do
			if RERated == nil then
				if (REFDatabase[i]["TalentSet"] == RESpec and RESpec ~= nil) or RESpec == nil then
					RELine =  "\"" .. REFDatabase[i]["TimeHo"] .. ":" .. REFDatabase[i]["TimeMi"] .. "\";\"" .. REFDatabase[i]["TimeDa"] .. "." .. REFDatabase[i]["TimeMo"] .. "." .. REFDatabase[i]["TimeYe"] .. "\";" .. tonumber(REFDatabase[i]["TimeHo"]) .. ";" .. tonumber(REFDatabase[i]["TimeMi"]) .. ";" .. tonumber(REFDatabase[i]["TimeDa"]) .. ";" .. tonumber(REFDatabase[i]["TimeMo"]) .. ";" .. tonumber(REFDatabase[i]["TimeYe"]) .. ";\"" .. REFDatabase[i]["MapName"] .. "\";" .. tonumber(REFDatabase[i]["DurationMin"]) .. ";" .. tonumber(REFDatabase[i]["DurationSec"]) .. ";\"" .. REFDatabase[i]["Winner"] .. "\";" .. REFDatabase[i]["KB"] .. ";" .. REFDatabase[i]["HK"] .. ";" .. REFDatabase[i]["Damage"] .. ";" .. REFDatabase[i]["Healing"] .. ";" .. REFDatabase[i]["Honor"] .. ";" .. REFDatabase[i]["PlaceKB"] .. ";" .. REFDatabase[i]["PlaceHK"] .. ";" .. REFDatabase[i]["PlaceDamage"] .. ";" .. REFDatabase[i]["PlaceHealing"] .. ";" .. REFDatabase[i]["PlaceHonor"] .. ";" .. REFDatabase[i]["PlaceFactionKB"] .. ";" .. REFDatabase[i]["PlaceFactionHK"] .. ";" .. REFDatabase[i]["PlaceFactionDamage"] .. ";" .. REFDatabase[i]["PlaceFactionHealing"] .. ";" .. REFDatabase[i]["PlaceFactionHonor"] .. ";";
					if REFDatabase[i]["MapInfo"] == "AlteracValley" then
						RELine = RELine .. REFDatabase[i]["SpecialFields"][3][1] .. ";" .. REFDatabase[i]["SpecialFields"][4][1] .. ";0;0;" .. REFDatabase[i]["SpecialFields"][1][1] .. ";" .. REFDatabase[i]["SpecialFields"][2][1] .. ";";
					elseif REFDatabase[i]["MapInfo"] == "WarsongGulch" or REFDatabase[i]["MapInfo"] == "TwinPeaks" then
						RELine = RELine .. "0;0;" .. REFDatabase[i]["SpecialFields"][1][1] .. ";" .. REFDatabase[i]["SpecialFields"][2][1] .. ";0;0;";
					elseif REFDatabase[i]["MapInfo"] == "GilneasBattleground2" or REFDatabase[i]["MapInfo"] == "IsleofConquest" or REFDatabase[i]["MapInfo"] == "ArathiBasin" or REFDatabase[i]["MapInfo"] == "StrandoftheAncients" then
						RELine = RELine .. REFDatabase[i]["SpecialFields"][1][1] .. ";" .. REFDatabase[i]["SpecialFields"][2][1] .. ";0;0;0;0;";
					elseif REFDatabase[i]["MapInfo"] == "NetherstormArena" then
						RELine = RELine .. "0;0;" .. REFDatabase[i]["SpecialFields"][1][1] .. ";0;0;0;";
					else
						RELine = RELine .. "0;0;0;0;0;0;";
					end
					local RERatingChange, REAllianceRating, REHordeRating;
					if REFDatabase[i]["RatingChange"] == nil then
						RERatingChange = 0;
					else
						RERatingChange = REFDatabase[i]["RatingChange"]
					end
					if REFDatabase[i]["AllianceRating"] == nil then
						REAllianceRating = 0;
					else
						REAllianceRating = REFDatabase[i]["AllianceRating"]
					end
					if REFDatabase[i]["HordeRating"] == nil then
						REHordeRating = 0;
					else
						REHordeRating = REFDatabase[i]["HordeRating"]
					end
					RELine = RELine .. REFDatabase[i]["TalentSet"] .. ";" .. REFDatabase[i]["PlayersNum"] .. ";" .. REFDatabase[i]["AliianceNum"] .. ";" .. REFDatabase[i]["HordeNum"] .. ";\"" .. tostring(REFDatabase[i]["IsRated"]) .. "\";\"" .. RERatingChange .. "\";" .. REAllianceRating .. ";" .. REHordeRating;
					REExport = REExport .. RELine .. "\n";
					RELine = "";
				end
			elseif REFDatabase[i]["IsRated"] == RERated and RERated == false then
				if (REFDatabase[i]["TalentSet"] == RESpec and RESpec ~= nil) or RESpec == nil then
					RELine =  "\"" .. REFDatabase[i]["TimeHo"] .. ":" .. REFDatabase[i]["TimeMi"] .. "\";\"" .. REFDatabase[i]["TimeDa"] .. "." .. REFDatabase[i]["TimeMo"] .. "." .. REFDatabase[i]["TimeYe"] .. "\";" .. tonumber(REFDatabase[i]["TimeHo"]) .. ";" .. tonumber(REFDatabase[i]["TimeMi"]) .. ";" .. tonumber(REFDatabase[i]["TimeDa"]) .. ";" .. tonumber(REFDatabase[i]["TimeMo"]) .. ";" .. tonumber(REFDatabase[i]["TimeYe"]) .. ";\"" .. REFDatabase[i]["MapName"] .. "\";" .. tonumber(REFDatabase[i]["DurationMin"]) .. ";" .. tonumber(REFDatabase[i]["DurationSec"]) .. ";\"" .. REFDatabase[i]["Winner"] .. "\";" .. REFDatabase[i]["KB"] .. ";" .. REFDatabase[i]["HK"] .. ";" .. REFDatabase[i]["Damage"] .. ";" .. REFDatabase[i]["Healing"] .. ";" .. REFDatabase[i]["Honor"] .. ";" .. REFDatabase[i]["PlaceKB"] .. ";" .. REFDatabase[i]["PlaceHK"] .. ";" .. REFDatabase[i]["PlaceDamage"] .. ";" .. REFDatabase[i]["PlaceHealing"] .. ";" .. REFDatabase[i]["PlaceHonor"] .. ";" .. REFDatabase[i]["PlaceFactionKB"] .. ";" .. REFDatabase[i]["PlaceFactionHK"] .. ";" .. REFDatabase[i]["PlaceFactionDamage"] .. ";" .. REFDatabase[i]["PlaceFactionHealing"] .. ";" .. REFDatabase[i]["PlaceFactionHonor"] .. ";";
					if REFDatabase[i]["MapInfo"] == "AlteracValley" then
						RELine = RELine .. REFDatabase[i]["SpecialFields"][3][1] .. ";" .. REFDatabase[i]["SpecialFields"][4][1] .. ";0;0;" .. REFDatabase[i]["SpecialFields"][1][1] .. ";" .. REFDatabase[i]["SpecialFields"][2][1] .. ";";
					elseif REFDatabase[i]["MapInfo"] == "WarsongGulch" or REFDatabase[i]["MapInfo"] == "TwinPeaks" then
						RELine = RELine .. "0;0;" .. REFDatabase[i]["SpecialFields"][1][1] .. ";" .. REFDatabase[i]["SpecialFields"][2][1] .. ";0;0;";
					elseif REFDatabase[i]["MapInfo"] == "GilneasBattleground2" or REFDatabase[i]["MapInfo"] == "IsleofConquest" or REFDatabase[i]["MapInfo"] == "ArathiBasin" or REFDatabase[i]["MapInfo"] == "StrandoftheAncients" then
						RELine = RELine .. REFDatabase[i]["SpecialFields"][1][1] .. ";" .. REFDatabase[i]["SpecialFields"][2][1] .. ";0;0;0;0;";
					elseif REFDatabase[i]["MapInfo"] == "NetherstormArena" then
						RELine = RELine .. "0;0;" .. REFDatabase[i]["SpecialFields"][1][1] .. ";0;0;0;";
					else
						RELine = RELine .. "0;0;0;0;0;0;";
					end
					RELine = RELine .. REFDatabase[i]["TalentSet"] .. ";" .. REFDatabase[i]["PlayersNum"] .. ";" .. REFDatabase[i]["AliianceNum"] .. ";" .. REFDatabase[i]["HordeNum"];
					REExport = REExport .. RELine .. "\n";
					RELine = "";
				end
			elseif REFDatabase[i]["IsRated"] == RERated and RERated == true then
				if (REFDatabase[i]["TalentSet"] == RESpec and RESpec ~= nil) or RESpec == nil then
					RELine =  "\"" .. REFDatabase[i]["TimeHo"] .. ":" .. REFDatabase[i]["TimeMi"] .. "\";\"" .. REFDatabase[i]["TimeDa"] .. "." .. REFDatabase[i]["TimeMo"] .. "." .. REFDatabase[i]["TimeYe"] .. "\";" .. tonumber(REFDatabase[i]["TimeHo"]) .. ";" .. tonumber(REFDatabase[i]["TimeMi"]) .. ";" .. tonumber(REFDatabase[i]["TimeDa"]) .. ";" .. tonumber(REFDatabase[i]["TimeMo"]) .. ";" .. tonumber(REFDatabase[i]["TimeYe"]) .. ";\"" .. REFDatabase[i]["MapName"] .. "\";" .. tonumber(REFDatabase[i]["DurationMin"]) .. ";" .. tonumber(REFDatabase[i]["DurationSec"]) .. ";\"" .. REFDatabase[i]["Winner"] .. "\";" .. REFDatabase[i]["KB"] .. ";" .. REFDatabase[i]["HK"] .. ";" .. REFDatabase[i]["Damage"] .. ";" .. REFDatabase[i]["Healing"] .. ";" .. REFDatabase[i]["Honor"] .. ";" .. REFDatabase[i]["PlaceKB"] .. ";" .. REFDatabase[i]["PlaceHK"] .. ";" .. REFDatabase[i]["PlaceDamage"] .. ";" .. REFDatabase[i]["PlaceHealing"] .. ";" .. REFDatabase[i]["PlaceHonor"] .. ";" .. REFDatabase[i]["PlaceFactionKB"] .. ";" .. REFDatabase[i]["PlaceFactionHK"] .. ";" .. REFDatabase[i]["PlaceFactionDamage"] .. ";" .. REFDatabase[i]["PlaceFactionHealing"] .. ";" .. REFDatabase[i]["PlaceFactionHonor"] .. ";";
					if REFDatabase[i]["MapInfo"] == "AlteracValley" then
						RELine = RELine .. REFDatabase[i]["SpecialFields"][3][1] .. ";" .. REFDatabase[i]["SpecialFields"][4][1] .. ";0;0;" .. REFDatabase[i]["SpecialFields"][1][1] .. ";" .. REFDatabase[i]["SpecialFields"][2][1] .. ";";
					elseif REFDatabase[i]["MapInfo"] == "WarsongGulch" or REFDatabase[i]["MapInfo"] == "TwinPeaks" then
						RELine = RELine .. "0;0;" .. REFDatabase[i]["SpecialFields"][1][1] .. ";" .. REFDatabase[i]["SpecialFields"][2][1] .. ";0;0;";
					elseif REFDatabase[i]["MapInfo"] == "GilneasBattleground2" or REFDatabase[i]["MapInfo"] == "IsleofConquest" or REFDatabase[i]["MapInfo"] == "ArathiBasin" or REFDatabase[i]["MapInfo"] == "StrandoftheAncients" then
						RELine = RELine .. REFDatabase[i]["SpecialFields"][1][1] .. ";" .. REFDatabase[i]["SpecialFields"][2][1] .. ";0;0;0;0;";
					elseif REFDatabase[i]["MapInfo"] == "NetherstormArena" then
						RELine = RELine .. "0;0;" .. REFDatabase[i]["SpecialFields"][1][1] .. ";0;0;0;";
					else
						RELine = RELine .. "0;0;0;0;0;0;";
					end
					RELine = RELine .. REFDatabase[i]["TalentSet"] .. ";" .. REFDatabase[i]["PlayersNum"] .. ";" .. REFDatabase[i]["AliianceNum"] .. ";" .. REFDatabase[i]["HordeNum"] .. ";" .. REFDatabase[i]["RatingChange"] .. "\";" .. REFDatabase[i]["AllianceRating"] .. ";" .. REFDatabase[i]["HordeRating"];
					REExport = REExport .. RELine .. "\n";
					RELine = "";
				end
			end
		end
	elseif REDataType == "Arena" then
		if REBracket == nil or REBracket == 5 then
			REExport = "Time;Date;TimeHour;TimeMinutes;DateDay;DateMonth;DateYear;Map;DurationMinutes;DurationSeconds;WeWon;TalentSet;Bracket;Season;MyTeamName;EnemyTeamName;MyTeamRating;EnemyTeamRating;MyTeamRatingChange;EnemyTeamRatingChange;MyKillingBlows;MyDamage;MyHealing;MyTeamDamage;MyTeamHealing;EnemyTeamDamage;EnemyTeamHealing;Ally1Name;Ally1Race;Ally1Class;Ally1Build;Ally1Damage;Ally1Healing;Ally1KillingBlows;Ally2Name;Ally2Race;Ally2Class;Ally2Build;Ally2Damage;Ally2Healing;Ally2KillingBlows;Ally3Name;Ally3Race;Ally3Class;Ally3Build;Ally3Damage;Ally3Healing;Ally3KillingBlows;Ally4Name;Ally4Race;Ally4Class;Ally4Build;Ally4Damage;Ally4Healing;Ally4KillingBlows;Ally5Name;Ally5Race;Ally5Class;Ally5Build;Ally5Damage;Ally5Healing;Ally5KillingBlows;Enemy1Name;Enemy1Race;Enemy1Class;Enemy1Build;Enemy1Damage;Enemy1Healing;Enemy1KillingBlows;Enemy2Name;Enemy2Race;Enemy2Class;Enemy2Build;Enemy2Damage;Enemy2Healing;Enemy2KillingBlows;Enemy3Name;Enemy3Race;Enemy3Class;Enemy3Build;Enemy3Damage;Enemy3Healing;Enemy3KillingBlows;Enemy4Name;Enemy4Race;Enemy4Class;Enemy4Build;Enemy4Damage;Enemy4Healing;Enemy4KillingBlows;Enemy5Name;Enemy5Race;Enemy5Class;Enemy5Build;Enemy5Damage;Enemy5Healing;Enemy5KillingBlows\n";
			RESlots = 5;
		elseif REBracket == 2 then
			REExport = "Time;Date;TimeHour;TimeMinutes;DateDay;DateMonth;DateYear;Map;DurationMinutes;DurationSeconds;WeWon;TalentSet;Bracket;Season;MyTeamName;EnemyTeamName;MyTeamRating;EnemyTeamRating;MyTeamRatingChange;EnemyTeamRatingChange;MyKillingBlows;MyDamage;MyHealing;MyTeamDamage;MyTeamHealing;EnemyTeamDamage;EnemyTeamHealing;Ally1Name;Ally1Race;Ally1Class;Ally1Build;Ally1Damage;Ally1Healing;Ally1KillingBlows;Ally2Name;Ally2Race;Ally2Class;Ally2Build;Ally2Damage;Ally2Healing;Ally2KillingBlows;Enemy1Name;Enemy1Race;Enemy1Class;Enemy1Build;Enemy1Damage;Enemy1Healing;Enemy1KillingBlows;Enemy2Name;Enemy2Race;Enemy2Class;Enemy2Build;Enemy2Damage;Enemy2Healing;Enemy2KillingBlows\n";
			RESlots = 2;
		elseif REBracket == 3 then
			REExport = "Time;Date;TimeHour;TimeMinutes;DateDay;DateMonth;DateYear;Map;DurationMinutes;DurationSeconds;WeWon;TalentSet;Bracket;Season;MyTeamName;EnemyTeamName;MyTeamRating;EnemyTeamRating;MyTeamRatingChange;EnemyTeamRatingChange;MyKillingBlows;MyDamage;MyHealing;MyTeamDamage;MyTeamHealing;EnemyTeamDamage;EnemyTeamHealing;Ally1Name;Ally1Race;Ally1Class;Ally1Build;Ally1Damage;Ally1Healing;Ally1KillingBlows;Ally2Name;Ally2Race;Ally2Class;Ally2Build;Ally2Damage;Ally2Healing;Ally2KillingBlows;Ally3Name;Ally3Race;Ally3Class;Ally3Build;Ally3Damage;Ally3Healing;Ally3KillingBlows;Enemy1Name;Enemy1Race;Enemy1Class;Enemy1Build;Enemy1Damage;Enemy1Healing;Enemy1KillingBlows;Enemy2Name;Enemy2Race;Enemy2Class;Enemy2Build;Enemy2Damage;Enemy2Healing;Enemy2KillingBlows;Enemy3Name;Enemy3Race;Enemy3Class;Enemy3Build;Enemy3Damage;Enemy3Healing;Enemy3KillingBlows\n";
			RESlots = 3;
		end

		local RELine = "";
		for i=1, #REFDatabaseA do
			if ((REFDatabaseA[i]["TalentSet"] == RESpec and RESpec ~= nil) or RESpec == nil) and ((REFDatabaseA[i]["Bracket"] == REBracket and REBracket ~= nil) or REBracket == nil) and REFlex_ArenaExportSearch(i) then
				local _, REEnemyID, _, REFriendID, Team, TeamE = REFlex_ArenaTeamHash(i);
				RELine = "\"" .. REFDatabaseA[i]["TimeHo"] .. ":" .. REFDatabaseA[i]["TimeMi"] .. "\";\"" .. REFDatabaseA[i]["TimeDa"] .. "." .. REFDatabaseA[i]["TimeMo"] .. "." .. REFDatabaseA[i]["TimeYe"] .. "\";" .. tonumber(REFDatabaseA[i]["TimeHo"]) .. ";" .. tonumber(REFDatabaseA[i]["TimeMi"]) .. ";" .. tonumber(REFDatabaseA[i]["TimeDa"]) .. ";" .. tonumber(REFDatabaseA[i]["TimeMo"]) .. ";" .. tonumber(REFDatabaseA[i]["TimeYe"]) .. ";\"" .. REFDatabaseA[i]["MapName"] .. "\";" .. tonumber(REFDatabaseA[i]["DurationMin"]) .. ";" .. tonumber(REFDatabaseA[i]["DurationSec"]) .. ";";
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
				local RESlotsTemp = RESlots;
				for k=1, #REFriendID do
					local REBuild = "Unknown";
					if REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["Build"] ~= nil then
						REBuild = REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["Build"];
					end
					local RERace = "Unknown";
					if REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["Race"] ~= nil then
						RERace = REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["Race"];
					end
					RELine = RELine .. "\"" .. REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["Name"] .. "\";\"" .. RERace .. "\";\"" .. REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["Class"] .. "\";\"" .. REBuild .. "\";" .. REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["Damage"] .. ";" .. REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["Healing"] .. ";" .. REFDatabaseA[i][Team .. "Team"][REFriendID[k]]["KB"] .. ";";
					RESlotsTemp = RESlotsTemp - 1;
				end
				if RESlotsTemp ~= 0 then
					for k=1, RESlotsTemp do
						RELine = RELine .. ";;;;;;;";
					end
				end
				local RESlotsTemp = RESlots;
				for k=1, #REEnemyID do
					local REBuild = "Unknown";
					if REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["Build"] ~= nil then
						REBuild = REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["Build"];
					end
					local RERace = "Unknown";
					if REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["Race"] ~= nil then
						RERace = REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["Race"];
					end
					RELine = RELine .. "\"" .. REFlex_NameClean(REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["Name"]) .. "\";\"" .. RERace .. "\";\"" .. REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["Class"] .. "\";\"" .. REBuild .. "\";" .. REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["Damage"] .. ";" .. REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["Healing"] .. ";" .. REFDatabaseA[i][TeamE .. "Team"][REEnemyID[k]]["KB"] .. ";";
					RESlotsTemp = RESlotsTemp - 1;
				end
				if RESlotsTemp ~= 0 then
					for k=1, RESlotsTemp do
						RELine = RELine .. ";;;;;;;";
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
	if RE.StartMemoryUsage ~= nil then
		UpdateAddOnMemoryUsage();
		RE.CurrentMemoryUsage = GetAddOnMemoryUsage("REFlex");
		local REDiff = RE.CurrentMemoryUsage - RE.StartMemoryUsage;
		if RE.Debug == true then
			print(REDiff);
		end
		if REDiff > 1500 then
			collectgarbage('collect');
		end
	end

	RequestRatedBattlegroundInfo();
	REFlex_ExportTab:Hide();
	if REFSettings["ArenaSupport"] and RE.ArenaReload then
		RE.ArenaTeams = {};
		RE.ArenaTeamsSpec = {["2"] = {}, ["3"] = {}, ["5"] = {}, ["All"] = {}, ["AllNoTalent"] = {} };
		RE.ArenaReload = false;
		RE.ArenaReloadAlpha = true;
		REFlex_ArenaTeamGrid();
	end

	if RE.SecondTimeMainTab == false then
		REFlex_SetTabs();
		RE.DataStructure12, RE.DataStructure3, RE.DataStructure5, RE.DataStructure6, RE.DataStructure7, RE.DataStructure8 = {}, {}, {}, {}, {}, {};
		if REFSettings["UNBGSupport"] then
			RE.DataStructure12 = {
				{
					["name"] = L["Date"],
					["width"] = 110,
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[rowa]["TimeRaw"]; local RERowB = REFDatabase[rowb]["TimeRaw"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
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
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[rowa]["DurationRaw"]; local RERowB = REFDatabase[rowb]["DurationRaw"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
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
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[rowa]["Damage"]; local RERowB = REFDatabase[rowb]["Damage"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
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
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[rowa]["Healing"]; local RERowB = REFDatabase[rowb]["Healing"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = HONOR,
					["width"] = 40,
					["align"] = "CENTER"
				}
			}
		end

		if REFSettings["RBGSupport"] then
			RE.DataStructure3 = {
				{
					["name"] = L["Date"],
					["width"] = 92,
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[rowa]["TimeRaw"]; local RERowB = REFDatabase[rowb]["TimeRaw"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
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
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[rowa]["DurationRaw"]; local RERowB = REFDatabase[rowb]["DurationRaw"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
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
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[rowa]["Damage"]; local RERowB = REFDatabase[rowb]["Damage"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
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
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabase[rowa]["Healing"]; local RERowB = REFDatabase[rowb]["Healing"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = RATING,
					["width"] = 40,
					["align"] = "CENTER"
				}
			}
		end

		if REFSettings["ArenaSupport"] then
			RE.DataStructure5 = {
				{
					["name"] = "\n" .. L["Date"],
					["width"] = 92,
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabaseA[rowa]["TimeRaw"]; local RERowB = REFDatabaseA[rowb]["TimeRaw"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
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
					["width"] = 140,
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. RATING,
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
					["name"] = "\n" .. ENEMY,
					["width"] = 140,
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. RATING,
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
					["name"] = "\n" .. AUCTION_DURATION,
					["width"] = 60,
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabaseA[rowa]["DurationRaw"]; local RERowB = REFDatabaseA[rowb]["DurationRaw"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
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
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabaseA[rowa]["Damage"]; local RERowB = REFDatabaseA[rowb]["Damage"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. SHOW_COMBAT_HEALING,
					["width"] = 60,
					["comparesort"] = function (self, rowa, rowb, sortbycol) local REColumn = self.cols[sortbycol]; local RERowA = REFDatabaseA[rowa]["Healing"]; local RERowB = REFDatabaseA[rowb]["Healing"]; local REDirection = REColumn.sort or REColumn.defaultsort or "asc"; if RERowA == RERowB then return false; else if REDirection:lower() == "asc" then if RERowA > RERowB then return true; else return false; end else if RERowA > RERowB then return false; else return true; end end end end,
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. RATING,
					["width"] = 50,
					["bgcolor"] = { 
						["r"] = 0.15, 
						["g"] = 0.15, 
						["b"] = 0.15, 
						["a"] = 1.0 
					},
					["align"] = "CENTER"
				}
			}

			RE.DataStructure6 = {
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
					["sortnext"]= 3,
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. LOSS,
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
					["sortnext"]= 3,
					["align"] = "CENTER"
				},
				{
					["name"] = "\n" .. WIN,
					["width"] = 35,
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
					if realrow ~= nil then
						REFlex_ShowBGDetails_OnEnter(cellFrame, data[realrow]["cols"][13]["value"]);    
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
					if realrow ~= nil then
						REFlex_ShowBGDetails_OnEnter(cellFrame, data[realrow]["cols"][13]["value"]);    
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
					if realrow ~= nil then
						REFlex_ShowBGDetails_OnEnter(cellFrame, data[realrow]["cols"][13]["value"], "REMainTable3");    
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
						REFlex_ShowDetails_OnLeave(cellFrame);    
					end
				end,
			});
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
		end
		RE.SecondTimeMainTab = true;
	end

	if RE.StartMemoryUsage == nil then
		UpdateAddOnMemoryUsage();
		RE.StartMemoryUsage = GetAddOnMemoryUsage("REFlex");
	end
end	

function REFlex_Tab1Show()
	REFlex_MainTab:SetSize(655, 502)
	REFlex_MainTab_MsgGuild:Show(); 
	REFlex_MainTab_MsgParty:Show();
	REFlex_MainTab_CSVExport:ClearAllPoints();
	REFlex_MainTab_CSVExport:SetPoint("TOPLEFT", 142 , -12)
	REFlex_MainTab_CSVExport:Show();

	if REFDatabase[RE.Tab1LastID + 1] ~= nil then
		RE.Tab1LastID = RE.Tab1LastID + 1;
		for j=RE.Tab1LastID, #REFDatabase do
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
	end

	RE.MainTable1:SetData(RE.Tab1TableData);
	RE.MainTable1:SetFilter(REFlex_Tab_DefaultFilter);

	if RE.Table1Rdy == nil then
		REFlex_TableClick(1, 1);
		RE.Table1Rdy = true;
	end

	RE.TopKB, RE.SumKB = REFlex_Find("KB", nil, RE.TalentTab);
	RE.TopHK, RE.SumHK = REFlex_Find("HK", nil, RE.TalentTab);
	RE.TopDamage, RE.SumDamage = REFlex_Find("Damage", nil, RE.TalentTab);
	RE.TopHealing, RE.SumHealing = REFlex_Find("Healing", nil, RE.TalentTab);
	RE.Wins, RE.Losses = REFlex_WinLoss(nil, RE.TalentTab); 

	REFlex_MainTab_Tab1_ScoreHolder_Wins:SetText(RE.Wins);
	REFlex_MainTab_Tab1_ScoreHolder_Lose:SetText(RE.Losses);
	if RE.RBG ~= nil then
		REFlex_MainTab_Tab1_ScoreHolder_RBG:SetText(RE.RBG);
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
	REFlex_MainTab:SetSize(655, 502)
	REFlex_MainTab_MsgGuild:Show(); 
	REFlex_MainTab_MsgParty:Show();
	REFlex_MainTab_CSVExport:ClearAllPoints();
	REFlex_MainTab_CSVExport:SetPoint("TOPLEFT", 142 , -12)
	REFlex_MainTab_CSVExport:Show();

	if REFDatabase[RE.Tab2LastID + 1] ~= nil then
		RE.Tab2LastID = RE.Tab2LastID + 1;
		for j=RE.Tab2LastID, #REFDatabase do	
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
	end

	RE.MainTable2:SetData(RE.Tab2TableData);
	RE.MainTable2:SetFilter(REFlex_Tab_DefaultFilter);

	RE.TopKB, RE.SumKB = REFlex_Find("KB", false, RE.TalentTab);
	RE.TopHK, RE.SumHK = REFlex_Find("HK", false, RE.TalentTab);
	RE.TopDamage, RE.SumDamage = REFlex_Find("Damage", false, RE.TalentTab);
	RE.TopHealing, RE.SumHealing = REFlex_Find("Healing", false, RE.TalentTab);
	RE.Wins, RE.Losses = REFlex_WinLoss(false, RE.TalentTab); 

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
	REFlex_MainTab:SetSize(655, 502)
	REFlex_MainTab_MsgGuild:Show(); 
	REFlex_MainTab_MsgParty:Show();
	REFlex_MainTab_CSVExport:ClearAllPoints();
	REFlex_MainTab_CSVExport:SetPoint("TOPLEFT", 142 , -12)
	REFlex_MainTab_CSVExport:Show();

	if REFDatabase[RE.Tab3LastID + 1] ~= nil then
		RE.Tab3LastID = RE.Tab3LastID + 1;
		for j=RE.Tab3LastID, #REFDatabase do
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
					["value"] = REFlex_NumberClean(REFDatabase[j]["Damage"])
				}
				RETempCol[10] = {
					["value"] = REFlex_NumberClean(REFDatabase[j]["Healing"])
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

				table.insert(RE.Tab3TableData, RETempRow);
				RE.Tab3LastID = j;
			end
		end
	end

	RE.MainTable3:SetData(RE.Tab3TableData);
	RE.MainTable3:SetFilter(REFlex_Tab_DefaultFilter);
	if RE.Table3Rdy == nil then
		REFlex_TableClick(3, 1);
		RE.Table3Rdy = true;
	end

	RE.TopKB, RE.SumKB = REFlex_Find("KB", true, RE.TalentTab);
	RE.TopHK, RE.SumHK = REFlex_Find("HK", true, RE.TalentTab);
	RE.TopDamage, RE.SumDamage = REFlex_Find("Damage", true, RE.TalentTab);
	RE.TopHealing, RE.SumHealing = REFlex_Find("Healing", true, RE.TalentTab);
	RE.Wins, RE.Losses = REFlex_WinLoss(true, RE.TalentTab); 

	REFlex_MainTab_Tab3_ScoreHolder_Wins:SetText(RE.Wins);
	REFlex_MainTab_Tab3_ScoreHolder_Lose:SetText(RE.Losses);
	if RE.RBG ~= nil then
		REFlex_MainTab_Tab3_ScoreHolder_RBG:SetText(RE.RBG);
	end
	REFlex_MainTab_Tab3_ScoreHolder_HK1:SetText("HK");
	REFlex_MainTab_Tab3_ScoreHolder_HK2:SetText(L["Top"] .. ": " .. RE.TopHK);
	REFlex_MainTab_Tab3_ScoreHolder_HK3:SetText(L["Total"] .. ": " .. RE.SumHK);
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
	REFlex_MainTab:SetSize(1070, 502);
	REFlex_MainTab_MsgGuild:Hide(); 
	REFlex_MainTab_MsgParty:Hide();
	REFlex_MainTab_CSVExport:Hide();

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
	REFlex_MainTab_Tab4_Bar_I:SetValue(REhk);
	REFlex_MainTab_Tab4_Bar_Text:SetText(REhk .. " / 100000");
	REFlex_MainTab_Tab4_ScoreHolderSpecial_BarHonor_I:SetValue(REHonor);
	REFlex_MainTab_Tab4_ScoreHolderSpecial_BarHonor_Text:SetText(REHonor .. " / " .. RE.HonorCap);
	if RE.RBGPointsWeek ~= nil then
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_I:SetValue(RE.RBGPointsWeek);
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_Text:SetText(RECP .. " - " .. RE.RBGPointsWeek .. " / " .. RE.RBGMaxPointsWeek);
	end

	if RE.BattlegroundReload then
		RE.MapsHolder = {};
		for j=1, #REFDatabase do
			if RE.TalentTab ~= nil then
				if RE.RatedDrop ~= nil then
					if REFDatabase[j]["TalentSet"] == RE.TalentTab and REFDatabase[j]["IsRated"] == RE.RatedDrop then
						REFlex_Tab4ShowI(j);		
					end
				else
					if REFDatabase[j]["TalentSet"] == RE.TalentTab then
						REFlex_Tab4ShowI(j);
					end
				end
			else
				if RE.RatedDrop ~= nil then
					if REFDatabase[j]["IsRated"] == RE.RatedDrop then
						REFlex_Tab4ShowI(j);
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
		RE.TopKB, RE.SumKB = REFlex_Find("KB", RE.RatedDrop, RE.TalentTab, RE.MapsHolder[j]);
		RE.TopHK, RE.SumHK = REFlex_Find("HK", RE.RatedDrop, RE.TalentTab, RE.MapsHolder[j]);
		RE.TopDamage, RE.SumDamage = REFlex_Find("Damage", RE.RatedDrop, RE.TalentTab, RE.MapsHolder[j]);
		RE.TopHealing, RE.SumHealing = REFlex_Find("Healing", RE.RatedDrop, RE.TalentTab, RE.MapsHolder[j]);
		RE.Wins, RE.Losses = REFlex_WinLoss(RE.RatedDrop, RE.TalentTab, RE.MapsHolder[j]); 
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
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Damage2"]:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RE.TopDamage));
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Damage3"]:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RE.SumDamage));
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Healing1"]:SetText(SHOW_COMBAT_HEALING);
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Healing2"]:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RE.TopHealing));
		_G["REFlex_MainTab_Tab4_ScoreHolder" .. j .. "_Healing3"]:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RE.SumHealing));
	end

	if REUsed < 8 then
		for j=1, 8-REUsed do
			_G["REFlex_MainTab_Tab4_ScoreHolder" .. (j+REUsed)]:Hide();
		end
	end
end

function REFlex_Tab5Show()
	REFlex_MainTab:SetSize(806, 502);
	REFlex_MainTab_MsgGuild:Hide(); 
	REFlex_MainTab_MsgParty:Hide();
	REFlex_MainTab_CSVExport:ClearAllPoints();
	REFlex_MainTab_CSVExport:SetPoint("LEFT", "REFlex_MainTab_Tab5_DropDownButton", "RIGHT", 4, 0)
	REFlex_MainTab_CSVExport:Show();
	REFlex_MainTab_Tab5_SearchBox:SetText(NAME);

	if REFSettings["ArenasListFirstTime"] then
		StaticPopup_Show("REFLEX_SHIFTINFO");
	end

	if REFDatabaseA[RE.Tab5LastID + 1] ~= nil then
		RE.Tab5LastID = RE.Tab5LastID + 1;
		for j=RE.Tab5LastID, #REFDatabaseA do
			if RE.BracketDrop ~= nil then
				if REFDatabaseA[j]["Bracket"] == RE.BracketDrop then
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
						["value"] = REFlex_TableTeamArenaRating(false, j)
					}
					RETempCol[5] = {
						["value"] = REFlex_TableTeamArena(true, j)
					}
					RETempCol[6] = {
						["value"] = REFlex_TableTeamArenaRating(true, j)
					}
					RETempCol[7] = {
						["value"] = REFDatabaseA[j]["DurationMin"] .. ":" .. REFDatabaseA[j]["DurationSec"]
					}
					RETempCol[8] = {
						["value"] = REFlex_NumberClean(REFDatabaseA[j]["Damage"])
					}
					RETempCol[9] = {
						["value"] = REFlex_NumberClean(REFDatabaseA[j]["Healing"])
					}
					RETempCol[10] = {
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

					table.insert(RE.Tab5TableData, RETempRow);
					RE.Tab5LastID = j;
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
					["value"] = REFlex_TableTeamArenaRating(false, j)
				}
				RETempCol[5] = {
					["value"] = REFlex_TableTeamArena(true, j)
				}
				RETempCol[6] = {
					["value"] = REFlex_TableTeamArenaRating(true, j)
				}
				RETempCol[7] = {
					["value"] = REFDatabaseA[j]["DurationMin"] .. ":" .. REFDatabaseA[j]["DurationSec"]
				}
				RETempCol[8] = {
					["value"] = REFlex_NumberClean(REFDatabaseA[j]["Damage"])
				}
				RETempCol[9] = {
					["value"] = REFlex_NumberClean(REFDatabaseA[j]["Healing"])
				}
				RETempCol[10] = {
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

				table.insert(RE.Tab5TableData, RETempRow);
				RE.Tab5LastID = j;
			end
		end
	end

	RE.MainTable5:SetData(RE.Tab5TableData);
	RE.MainTable5:SetFilter(REFlex_Tab_DefaultFilter);
	if RE.Table5Rdy == nil then
		REFlex_TableClick(5, 1);
		RE.Table5Rdy = true;
	end

	RE.TopDamage, RE.SumDamage = REFlex_FindArena("Damage", RE.BracketDrop, RE.TalentTab);
	RE.TopHealing, RE.SumHealing = REFlex_FindArena("Healing", RE.BracketDrop, RE.TalentTab);
	RE.Wins, RE.Losses = REFlex_WinLossArena(RE.BracketDrop, RE.TalentTab); 

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

	if RE.ArenaReloadAlpha then
		RE.MapsHolderArena = {};
		for j=1, #REFDatabaseA do
			if RE.TalentTab ~= nil then
				if RE.BracketDropTab6 ~= nil then
					if REFDatabaseA[j]["TalentSet"] == RE.TalentTab and REFDatabaseA[j]["Bracket"] == RE.BracketDropTab6 then
						REFlex_Tab6ShowI(j);		
					end
				else
					if REFDatabaseA[j]["TalentSet"] == RE.TalentTab then
						REFlex_Tab6ShowI(j);
					end
				end
			else
				if RE.BracketDropTab6 ~= nil then
					if REFDatabaseA[j]["Bracket"] == RE.BracketDropTab6 then
						REFlex_Tab6ShowI(j);
					end
				else
					REFlex_Tab6ShowI(j);
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
		REFlex_MainTab_Tab6_ScoreHolderSpecial_BarCP_I:SetValue(RE.RBGPointsWeek);
		REFlex_MainTab_Tab6_ScoreHolderSpecial_BarCP_Text:SetText(RECP .. " - " .. RE.RBGPointsWeek .. " / " .. RE.RBGMaxPointsWeek);
	end

	local REUsed = 0;
	for j=1, #RE.MapsHolderArena do
		RE.TopDamage, RE.SumDamage = REFlex_FindArena("Damage", RE.BracketDropTab6, RE.TalentTab, RE.MapsHolderArena[j]);
		RE.TopHealing, RE.SumHealing = REFlex_FindArena("Healing", RE.BracketDropTab6, RE.TalentTab, RE.MapsHolderArena[j]);
		RE.Wins, RE.Losses = REFlex_WinLossArena(RE.BracketDropTab6, RE.TalentTab, RE.MapsHolderArena[j]); 
		REUsed = REUsed + 1;

		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j]:Show();
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Title"]:SetText("- " .. RE.MapsHolderArena[j] .. " -");
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Wins"]:SetText(RE.Wins);
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Lose"]:SetText(RE.Losses);
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Damage1"]:SetText(DAMAGE);
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Damage2"]:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RE.TopDamage));
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Damage3"]:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RE.SumDamage));
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Healing1"]:SetText(SHOW_COMBAT_HEALING);
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Healing2"]:SetText(L["Top"] .. ": " .. REFlex_NumberClean(RE.TopHealing));
		_G["REFlex_MainTab_Tab6_ScoreHolder" .. j .. "_Healing3"]:SetText(L["Total"] .. ": " .. REFlex_NumberClean(RE.SumHealing));
	end

	if REUsed < 5 then
		for j=1, 5-REUsed do
			_G["REFlex_MainTab_Tab6_ScoreHolder" .. (j+REUsed)]:Hide();
		end
	end

	local REBracket = "";
	if RE.BracketDropTab6 == nil then
		REBracket = "All";
	else
		REBracket = tostring(RE.BracketDropTab6);
	end

	if RE.ArenaReloadAlpha then
		RE.Tab6TableData1 = {};
		RE.Tab6TableData2 = {};
		RE.Tab6TableData3 = {};

		local RETableCount, RETableI = REFlex_TableCount(RE.ArenaTeamsSpec[REBracket]);
		for j=1, RETableCount do
			if RE.ArenaTeamsSpec[REBracket][RETableI[j]]["Win"] > 0 then
				local RETempCol = {};
				RETempCol[1] = {
					["value"] = REFlex_TableTeamArenaTab6(RE.ArenaTeamsSpec[REBracket][RETableI[j]]["Team"]),
				}
				RETempCol[2] = {
					["value"] = RE.ArenaTeamsSpec[REBracket][RETableI[j]]["Win"],
					["color"] = { ["r"] = 0, ["g"] = 1, ["b"] = 0, ["a"] = 1 },
				}
				RETempCol[3] = {
					["value"] = RE.ArenaTeamsSpec[REBracket][RETableI[j]]["Loss"],
					["color"] = { ["r"] = 1, ["g"] = 0, ["b"] = 0, ["a"] = 1 },
				}
				RETempCol[12] = {
					["value"] = RE.ArenaTeamsSpec[REBracket][RETableI[j]]["TalentSet"]
				}

				local RETempRow = {
					["cols"] = RETempCol
				}

				table.insert(RE.Tab6TableData1, RETempRow);
			end
		end

		for j=1, RETableCount do
			local RETempCol = {};
			RETempCol[1] = {
				["value"] = REFlex_TableTeamArenaTab6(RE.ArenaTeamsSpec[REBracket][RETableI[j]]["Team"]),
			}
			RETempCol[2] = {
				["value"] = RE.ArenaTeamsSpec[REBracket][RETableI[j]]["Total"],
			}
			RETempCol[3] = {
				["value"] = RE.ArenaTeamsSpec[REBracket][RETableI[j]]["Win"],
				["color"] = { ["r"] = 0, ["g"] = 1, ["b"] = 0, ["a"] = 1 },
			}
			RETempCol[4] = {
				["value"] = RE.ArenaTeamsSpec[REBracket][RETableI[j]]["Loss"],
				["color"] = { ["r"] = 1, ["g"] = 0, ["b"] = 0, ["a"] = 1 },
			}
			RETempCol[12] = {
				["value"] = RE.ArenaTeamsSpec[REBracket][RETableI[j]]["TalentSet"],
			}

			local RETempRow = {
				["cols"] = RETempCol
			}

			table.insert(RE.Tab6TableData2, RETempRow);
		end

		for j=1, RETableCount do
			if RE.ArenaTeamsSpec[REBracket][RETableI[j]]["Loss"] > 0 then
				local RETempCol = {};
				RETempCol[1] = {
					["value"] = REFlex_TableTeamArenaTab6(RE.ArenaTeamsSpec[REBracket][RETableI[j]]["Team"]),
				}
				RETempCol[2] = {
					["value"] = RE.ArenaTeamsSpec[REBracket][RETableI[j]]["Loss"],
					["color"] = { ["r"] = 1, ["g"] = 0, ["b"] = 0, ["a"] = 1 },
				}
				RETempCol[3] = {
					["value"] = RE.ArenaTeamsSpec[REBracket][RETableI[j]]["Win"],
					["color"] = { ["r"] = 0, ["g"] = 1, ["b"] = 0, ["a"] = 1 },
				}
				RETempCol[12] = {
					["value"] = RE.ArenaTeamsSpec[REBracket][RETableI[j]]["TalentSet"],
				}

				local RETempRow = {
					["cols"] = RETempCol
				}

				table.insert(RE.Tab6TableData3, RETempRow);
			end
		end
		RE.ArenaReloadAlpha = false;
	end

	RE.MainTable6:SetData(RE.Tab6TableData1);
	RE.MainTable6:SetFilter(REFlex_Tab_DefaultFilter);
	if RE.Table6Rdy == nil then
		REFlex_TableClick(6, 2);
		RE.Table6Rdy = true;
	end

	RE.MainTable7:SetData(RE.Tab6TableData2);
	RE.MainTable7:SetFilter(REFlex_Tab_DefaultFilter);
	if RE.Table7Rdy == nil then
		REFlex_TableClick(7, 2);
		RE.Table7Rdy = true;
	end

	RE.MainTable8:SetData(RE.Tab6TableData3);
	RE.MainTable8:SetFilter(REFlex_Tab_DefaultFilter);
	if RE.Table8Rdy == nil then
		REFlex_TableClick(8, 2);
		RE.Table8Rdy = true;
	end
end
-- 

-- Tooltips subsection
function REFlex_ShowBGDetails_OnEnter(self, DatabaseID, Table)
	local RETooltip = RE.QTip:Acquire("REBGDetailsToolTip", 3, "CENTER", "CENTER", "CENTER");
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
		RETooltip:AddLine();
		RETooltip:AddSeparator();
		RETooltip:AddLine();
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
	local RETooltip = RE.QTip:Acquire("REArenaDetailsToolTip", 7, "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER");
	self.tooltip = RETooltip;

	local REEnemyNames, REEnemyID, REFriendNames, REFriendID, Team, TeamE = REFlex_ArenaTeamHash(DatabaseID);
	local REEnemyTeamID = table.concat(REEnemyNames);

	RETooltip:SetHeaderFont(SystemFont_Huge1);
	RETooltip:AddHeader("", "", "", "|cFF00CC00" .. RE.ArenaTeams[REEnemyTeamID]["Win"] .. "|r - |cFFCC0000" .. RE.ArenaTeams[REEnemyTeamID]["Loss"] .. "|r", "", "", "");

	local FriendRatingChange = REFDatabaseA[DatabaseID][Team .. "TeamRatingChange"];
	local EnemyRatingChange = REFDatabaseA[DatabaseID][TeamE .. "TeamRatingChange"];
	if REFDatabaseA[DatabaseID][TeamE .. "TeamRating"] < 0 then
		EnemyRatingChange = 0;
	end
	RETooltip:SetHeaderFont(GameTooltipHeader);
	RETooltip:AddHeader("", "[|cFF" .. REFlex_ToolTipRatingColorArena(FriendRatingChange) .. FriendRatingChange .. "|r]", "", "", "", "[|cFF" .. REFlex_ToolTipRatingColorArena(EnemyRatingChange) .. EnemyRatingChange .. "|r]","");
	RETooltip:AddLine();
	RETooltip:AddSeparator(3);
	RETooltip:AddLine();

	for i=1, REFDatabaseA[DatabaseID]["Bracket"] do
		local RaceClassCell, NameCell, BuildCell, EnemyRaceClassCell, EnemyNameCell, EnemyBuildCell = "", "", "", "", "", "";

		if REFriendID[i] ~= nil then
			local ClassToken = REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["ClassToken"];
			local RaceToken = nil;
			if REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Race"] ~= nil then
				RaceToken = string.upper(REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Race"] .. "_MALE");
			end
			if RE.RaceIconCoords[RaceToken] ~= nil then
				RaceClassCell = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:40:40:0:0:512:256:" .. RE.RaceIconCoords[RaceToken][1]*512 .. ":" .. RE.RaceIconCoords[RaceToken][2]*512 .. ":".. RE.RaceIconCoords[RaceToken][3]*256 ..":" .. RE.RaceIconCoords[RaceToken][4]*256 .. "|t  |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:40:40:0:0:256:256:" .. RE.ClassIconCoords[ClassToken][1]*256 .. ":" .. RE.ClassIconCoords[ClassToken][2]*256 .. ":".. RE.ClassIconCoords[ClassToken][3]*256 ..":" .. RE.ClassIconCoords[ClassToken][4]*256 .."|t"
			else
				RaceClassCell = "|TInterface\\Icons\\INV_Misc_QuestionMark:40:40|t  |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:40:40:0:0:256:256:" .. RE.ClassIconCoords[ClassToken][1]*256 .. ":" .. RE.ClassIconCoords[ClassToken][2]*256 .. ":".. RE.ClassIconCoords[ClassToken][3]*256 ..":" .. RE.ClassIconCoords[ClassToken][4]*256 .."|t"
			end

			NameCell = "|cFF" .. RE.ClassColors[ClassToken] .. REFlex_NameClean(REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Name"]) .. "|r";

			if REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Build"] ~= nil then
				BuildCell = "|cFF" .. RE.ClassColors[ClassToken] .. REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Build"] .. "|r";
			else
				BuildCell = "|cFF" .. RE.ClassColors[ClassToken] .. UNKNOWN .. "|r";
			end
		end

		if REEnemyID[i] ~= nil then
			local ClassToken = REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["ClassToken"];
			local RaceToken = nil;
			if REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Race"] ~= nil then
				RaceToken = string.upper(REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Race"] .. "_MALE");
			end
			if RE.RaceIconCoords[RaceToken] ~= nil then
				EnemyRaceClassCell = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:40:40:0:0:512:256:" .. RE.RaceIconCoords[RaceToken][1]*512 .. ":" .. RE.RaceIconCoords[RaceToken][2]*512 .. ":".. RE.RaceIconCoords[RaceToken][3]*256 ..":" .. RE.RaceIconCoords[RaceToken][4]*256 .. "|t  |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:40:40:0:0:256:256:" .. RE.ClassIconCoords[ClassToken][1]*256 .. ":" .. RE.ClassIconCoords[ClassToken][2]*256 .. ":".. RE.ClassIconCoords[ClassToken][3]*256 ..":" .. RE.ClassIconCoords[ClassToken][4]*256 .."|t"
			else
				EnemyRaceClassCell = "|TInterface\\Icons\\INV_Misc_QuestionMark:40:40|t  |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:40:40:0:0:256:256:" .. RE.ClassIconCoords[ClassToken][1]*256 .. ":" .. RE.ClassIconCoords[ClassToken][2]*256 .. ":".. RE.ClassIconCoords[ClassToken][3]*256 ..":" .. RE.ClassIconCoords[ClassToken][4]*256 .."|t"
			end

			EnemyNameCell = "|cFF" .. RE.ClassColors[ClassToken] .. REFlex_NameClean(REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Name"]) .. "|r";

			if REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Build"] ~= nil then
				EnemyBuildCell = "|cFF" .. RE.ClassColors[ClassToken] .. REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Build"] .. "|r";
			else
				EnemyBuildCell = "|cFF" .. RE.ClassColors[ClassToken] .. UNKNOWN .. "|r";
			end
		end

		RETooltip:AddLine(RaceClassCell, NameCell, BuildCell, "", EnemyRaceClassCell, EnemyNameCell, EnemyBuildCell);	
	end

	if IsShiftKeyDown() == 1 then
		local RETotalDamage, RETotalHealing, RETotalDamageEnemy, RETotalHealingEnemy = 0, 0, 0, 0;

		RETooltip:AddLine();
		RETooltip:AddSeparator(3);
		RETooltip:AddLine();
		RETooltip:AddHeader("", DAMAGE, SHOW_COMBAT_HEALING, "", "", DAMAGE, SHOW_COMBAT_HEALING);
		for i=1, REFDatabaseA[DatabaseID]["Bracket"] do
			local NameCell, DamageCell, HealingCell, EnemyNameCell, EnemyDamageCell, EnemyHealingCell = "", "", "", "", "", "";

			if REFriendID[i] ~= nil then
				RETotalDamage = RETotalDamage + REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Damage"];
				RETotalHealing = RETotalHealing + REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Healing"];
				local ClassToken = REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["ClassToken"];
				NameCell = "|cFF" .. RE.ClassColors[ClassToken] .. REFlex_NameClean(REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Name"]) .. "|r";
				DamageCell = REFlex_NumberClean(REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Damage"]);
				HealingCell = REFlex_NumberClean(REFDatabaseA[DatabaseID][Team .. "Team"][REFriendID[i]]["Healing"]);
			end

			if REEnemyID[i] ~= nil then
				RETotalDamageEnemy = RETotalDamageEnemy + REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Damage"];
				RETotalHealingEnemy = RETotalHealingEnemy + REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Healing"];
				local ClassToken = REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["ClassToken"];
				EnemyNameCell = "|cFF" .. RE.ClassColors[ClassToken] .. REFlex_NameClean(REFDatabaseA[DatabaseID][TeamE .. "Team"][REEnemyID[i]]["Name"]) .. "|r";
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
	end

	RETooltip:SmartAnchorTo(self);
	RETooltip:Show();
end

function REFlex_ShowDetails_OnLeave(self)
	RE.QTip:Release(self.tooltip)
	self.tooltip = nil
end
--

function REFlex_BGEnd()
	local REWinner = GetBattlefieldWinner();
	local REArena, REArenaRegistered = IsActiveBattlefieldArena();
	local _, REZoneType = IsInInstance();
	local REBGRated = IsRatedBattleground();
	if REWinner ~= nil and RE.SecondTime ~= true and REArena == nil and REZoneType == "pvp" and ((REFSettings["UNBGSupport"] and REBGRated ~= true) or (REFSettings["RBGSupport"] and REBGRated)) then
		SendAddonMessage("REFlex", RE.AddonVersionCheck, "BATTLEGROUND");

		if REWinner == 1 then
			REWinSide = FACTION_ALLIANCE;
			REWinSidePrint = "\124cFF00A9FF" .. FACTION_ALLIANCE;
		else
			REWinSide = FACTION_HORDE;
			REWinSidePrint = "\124cFFFF141D" .. FACTION_HORDE;
		end

		RE.Map = GetRealZoneText();
		local REPlayerName = GetUnitName("player");
		local REFaction = UnitFactionGroup("player");
		local RETalentGroup = GetActiveTalentGroup(false, false);
		RE.BGPlayers = GetNumBattlefieldScores();
		local BGTimeRaw = math.floor(GetBattlefieldInstanceRunTime() / 1000);
		RE.BGMinutes = math.floor(BGTimeRaw / 60);
		RE.BGSeconds = math.floor(BGTimeRaw % 60);
		local RETimeHour, RETimeMinute = GetGameTime();
		local _, RETimeMonth, RETimeDay, RETimeYear = CalendarGetDate();
		local RETimeRaw = time();
		local RESpecialFields = {};
		local REFactionNum;

		if RE.BGSeconds < 10 then
			RE.BGSeconds = "0" .. RE.BGSeconds;
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
			RE.PlayerID = i;
			i = i + 1;
			if i == 100 then
				break
			end
		end

		RE.playerName, RE.killingBlows, RE.honorKills, _, RE.honorGained, _, _, RE.class, RE.classToken, RE.damageDone, RE.healingDone, RE.BGRating, RE.BGRatingChange = GetBattlefieldScore(RE.PlayerID);
		RE.PlaceKB, RE.PlaceHK, RE.PlaceHonor, RE.PlaceDamage, RE.PlaceHealing = RE.BGPlayers, RE.BGPlayers, RE.BGPlayers, RE.BGPlayers, RE.BGPlayers;
		local REHordeNum, REAllianceNum = 0, 0;
		local REAverageHorde, REAverageAlliance = 0, 0;
		local RERBGHorde, RERBGAlly = nil, nil;

		if REFaction == "Horde" then
			REHordeNum = 1;
			if REBGRated then
				RERBGHorde, RERBGAlly = {}, {};
				local REPLayerdataTemp = {["name"] = RE.playerName, ["class"] = RE.class, ["classToken"] = RE.classToken}
				table.insert(RERBGHorde, REPLayerdataTemp);
			end
		else
			REAllianceNum = 1;
			if REBGRated then
				RERBGHorde, RERBGAlly = {}, {};
				local REPLayerdataTemp = {["name"] = RE.playerName, ["class"] = RE.class, ["classToken"] = RE.classToken}
				table.insert(RERBGAlly, REPLayerdataTemp);
			end
		end

		for j=1, RE.BGPlayers do
			if j ~= RE.PlayerID then
				local name, killingBlowsTemp, honorKillsTemp, _, honorGainedTemp, factionTemp, _, class, classToken, damageDoneTemp, healingDoneTemp, ratingTemp = GetBattlefieldScore(j);
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

				if factionTemp == 0 then
					REHordeNum = REHordeNum + 1;
					REAverageHorde = REAverageHorde + ratingTemp;
					if REBGRated then
						local REPLayerdataTemp = {["name"] = name, ["class"] = class, ["classToken"] = classToken}
						table.insert(RERBGHorde, REPLayerdataTemp);
					end
				else
					REAllianceNum = REAllianceNum + 1;
					REAverageAlliance = REAverageAlliance + ratingTemp;
					if REBGRated then
						local REPLayerdataTemp = {["name"] = name, ["class"] = class, ["classToken"] = classToken}
						table.insert(RERBGAlly, REPLayerdataTemp);
					end
				end
			end
		end

		if REBGRated then
			REFlex_ScoreTab:ClearAllPoints();
			REFlex_ScoreTab:SetPoint("BOTTOMRIGHT", -6, -33);
			REFlex_ScoreTab:Show();

			RE.TopKB = REFlex_Find("KB", true, RETalentGroup);
			RE.TopHK = REFlex_Find("HK", true, RETalentGroup);
			RE.TopDamage = REFlex_Find("Damage", true, RETalentGroup);
			RE.TopHealing = REFlex_Find("Healing", true, RETalentGroup);

			if REFaction == "Horde" then
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

			RE.TopKB = REFlex_Find("KB", false, RETalentGroup);
			RE.TopHK = REFlex_Find("HK", false, RETalentGroup);
			RE.TopDamage = REFlex_Find("Damage", false, RETalentGroup);
			RE.TopHealing = REFlex_Find("Healing", false, RETalentGroup);

			RE.BGRating = nil;
			RE.BGRatingChange = nil;
			REBGHordeRating = nil;
			REBGAllyRating = nil;
		end

		if REFaction == "Horde" then
			RE.BGPlayersF = REHordeNum;
			REFactionNum = 0;
		else
			RE.BGPlayersF = REAllianceNum;
			REFactionNum = 1;
		end

		local REPlaceKBF, REPlaceHKF, REPlaceHonorF, REPlaceDamageF, REPlaceHealingF = RE.BGPlayersF, RE.BGPlayersF, RE.BGPlayersF, RE.BGPlayersF, RE.BGPlayersF;

		for jj=1, RE.BGPlayers do
			local _, killingBlowsTemp, honorKillsTemp, _, honorGainedTemp, factionTemp, _, _, _, damageDoneTemp, healingDoneTemp = GetBattlefieldScore(jj);
			if jj ~= RE.PlayerID and factionTemp == REFactionNum  then
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
			RESpecialFields[1] = { GetBattlefieldStatData(RE.PlayerID, 1), "Interface\\WorldStateFrame\\ColumnIcon-GraveyardCapture" .. REFactionNum };
			RESpecialFields[2] = { GetBattlefieldStatData(RE.PlayerID, 2), "Interface\\WorldStateFrame\\ColumnIcon-GraveyardDefend" .. REFactionNum };
			RESpecialFields[3] = { GetBattlefieldStatData(RE.PlayerID, 3), "Interface\\WorldStateFrame\\ColumnIcon-TowerCapture" .. REFactionNum };
			RESpecialFields[4] = { GetBattlefieldStatData(RE.PlayerID, 4), "Interface\\WorldStateFrame\\ColumnIcon-TowerDefend" .. REFactionNum };
			RESpecialFields[5] = { GetBattlefieldStatData(RE.PlayerID, 5), "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture2" };
		elseif REMapInfo == "WarsongGulch" or REMapInfo == "TwinPeaks" then
			RESpecialFields[1] = { GetBattlefieldStatData(RE.PlayerID, 1), "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture" .. REFactionNum };
			RESpecialFields[2] = { GetBattlefieldStatData(RE.PlayerID, 2), "Interface\\WorldStateFrame\\ColumnIcon-FlagReturn" .. REFactionNum };	
		elseif REMapInfo == "GilneasBattleground2" or REMapInfo == "IsleofConquest" or REMapInfo == "ArathiBasin" or REMapInfo == "StrandoftheAncients" then
			RESpecialFields[1] = { GetBattlefieldStatData(RE.PlayerID, 1), "Interface\\WorldStateFrame\\ColumnIcon-TowerCapture" .. REFactionNum };
			RESpecialFields[2] = { GetBattlefieldStatData(RE.PlayerID, 2), "Interface\\WorldStateFrame\\ColumnIcon-TowerDefend" .. REFactionNum };
		elseif REMapInfo == "NetherstormArena" then
			RESpecialFields[1] = { GetBattlefieldStatData(RE.PlayerID, 1), "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture" .. REFactionNum };
		end

		RE.SecondTime = true;
		RE.BattlegroundReload = true;

		print("\n");
		print("\124cFF74D06C[REFlex]\124r \124cFF555555-\124r " .. RE.Map .. " \124cFF555555-\124r " .. WIN .. ": " .. REWinSidePrint .. " \124cFF555555-\124r " .. RE.BGMinutes .. ":" .. RE.BGSeconds);
		print("\124cFFC5F3BCKB:\124r " .. RE.killingBlows .. " (" .. RE.PlaceKB .. "/" .. RE.BGPlayers .. ") \124cFF555555* \124cFFC5F3BCHK:\124r " .. RE.honorKills .. " (" .. RE.PlaceHK .. "/" .. RE.BGPlayers .. ") \124cFF555555* \124cFFC5F3BCH:\124r " .. RE.honorGained .. " (" .. RE.PlaceHonor .. "/" .. RE.BGPlayers .. ")");
		print("\124cFFC5F3BC" .. DAMAGE .. ":\124r " .. REFlex_NumberClean(RE.damageDone) .. " (" .. RE.PlaceDamage .. "/" .. RE.BGPlayers .. ") \124cFF555555* \124cFFC5F3BC" .. SHOW_COMBAT_HEALING .. ":\124r " .. REFlex_NumberClean(RE.healingDone) .. " (" .. RE.PlaceHealing .. "/" .. RE.BGPlayers .. ")");
		if RE.killingBlows > RE.TopKB then
			print("\124cFF74D06C" .. string.upper(NEW) .. " " .. string.upper(KILLING_BLOWS) .. " " .. L["RECORD"] ..":\124r " .. RE.killingBlows .. " \124cFF555555-\124r ".. L["Old"] .. ": " .. RE.TopKB);
		end
		if RE.honorKills > RE.TopHK then
			print("\124cFF74D06C" .. string.upper(NEW) .. " " .. string.upper(L["Honor Kills"]) .. " " .. L["RECORD"] ..":\124r " .. RE.honorKills .. " \124cFF555555-\124r ".. L["Old"] .. ": " .. RE.TopHK);
		end
		if RE.damageDone > RE.TopDamage then
			print("\124cFF74D06C" .. string.upper(NEW) .. " " .. string.upper(DAMAGE) .. " " .. L["RECORD"] ..":\124r " .. REFlex_NumberClean(RE.damageDone) .. " \124cFF555555-\124r ".. L["Old"] .. ": " .. REFlex_NumberClean(RE.TopDamage));
		end
		if RE.healingDone > RE.TopHealing then
			print("\124cFF74D06C" .. string.upper(NEW) .. " " .. string.upper(SHOW_COMBAT_HEALING) .. " " .. L["RECORD"] ..":\124r " .. REFlex_NumberClean(RE.healingDone) .. " \124cFF555555-\124r ".. L["Old"] .. ": " .. REFlex_NumberClean(RE.TopHealing));
		end
		print("\n");

		local REBGData = { DataVersion=RE.DataVersion, SpecialFields=RESpecialFields, RBGHordeTeam=RERBGHorde, RBGAllianceTeam=RERBGAlly, MapName=RE.Map, MapInfo=REMapInfo, Damage=RE.damageDone, Healing=RE.healingDone, KB=RE.killingBlows, HK=RE.honorKills, Honor=RE.honorGained, TalentSet=RETalentGroup, Winner=REWinSide, PlayersNum=RE.BGPlayers, HordeNum=REHordeNum, AliianceNum=REAllianceNum, DurationMin=RE.BGMinutes, DurationSec=RE.BGSeconds, DurationRaw=BGTimeRaw, TimeHo=RETimeHour, TimeMi=RETimeMinute, TimeMo=RETimeMonth, TimeDa=RETimeDay, TimeYe=RETimeYear, TimeRaw=RETimeRaw, IsRated=REBGRated, Rating=RE.BGRating, RatingChange=RE.BGRatingChange, HordeRating=REBGHordeRating, AllianceRating=REBGAllyRating, PlaceKB=RE.PlaceKB, PlaceHK=RE.PlaceHK, PlaceHonor=RE.PlaceHonor, PlaceDamage=RE.PlaceDamage, PlaceHealing=RE.PlaceHealing, PlaceFactionKB=REPlaceKBF, PlaceFactionHK=REPlaceHKF, PlaceFactionHonor=REPlaceHonorF, PlaceFactionDamage=REPlaceDamageF, PlaceFactionHealing=REPlaceHealingF };
		table.insert(REFDatabase, REBGData);			
	elseif REWinner ~= nil and RE.SecondTime ~= true and REArena == 1 and REArenaRegistered == 1 and REZoneType == "arena" and REFSettings["ArenaSupport"] then
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

		local REPLayerTemp = {};
		local REPlayerTeam, RELocalDamage, RELocalHealing, RELocalKB = "", "", "", "";
		for j=1, REBGPlayers do
			local REPlayerTemp = {};
			local REPName, REKillingBlows, _, _, _, REFaction, _, REClass, REClassToken, REDamageDone, REHealingDone = GetBattlefieldScore(j);
			local REBuild = RE.ArenaBuilds[REPName];
			local RERace = RE.ArenaRaces[REPName]; 
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

		RE.SecondTime = true;
		RE.ArenaReload = true;

		local REBGData = { DataVersion=RE.DataVersion, MapName=REMap, TalentSet=RETalentGroup, Winner=REWinSide, Damage=RELocalDamage, Healing=RELocalHealing, KB=RELocalKB, DurationMin=REBGMinutes, DurationSec=REBGSeconds, DurationRaw=BGTimeRaw, TimeHo=RETimeHour, TimeMi=RETimeMinute, TimeMo=RETimeMonth, TimeDa=RETimeDay, TimeYe=RETimeYear, TimeRaw=RETimeRaw, Season=REArenaSeason, Bracket=REBracket, PlayerTeam=REPlayerTeam, GreenTeamName=REGreenTeamName, GreenTeamRating=REGreenNewTeamRating, GreenTeamRatingChange=(REGreenNewTeamRating - REGreenTeamRating), GoldTeamName=REGoldTeamName, GoldTeamRating=REGoldNewTeamRating, GoldTeamRatingChange=(REGoldNewTeamRating - REGoldTeamRating), GreenTeam=RETeamGreen, GoldTeam=RETeamGold};
		table.insert(REFDatabaseA, REBGData);
	end
end
-- ***
