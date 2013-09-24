local RE = REFlexNamespace;
local L = REFlexLocale;

-- *** MiniBar & LDB functions

-- LDB Subsection
function REFlex_LoadLDB()
	RE.LDBBar = RE.LDB:NewDataObject("|cFF74D06CREFlex|r", {
		type = "data source",
		icon = "Interface\\PvPRankBadges\\PvPRank09",
		OnLeave = function(self)
			RE.QTip:Release(self.tooltip);
			self.tooltip = nil;
		end,
		OnEnter = function(self)
			REFlex_LDBTooltip(self);
		end,
		OnClick = function(self, button)
			REFlex_MinimapButtonClick(button)	
		end
	})
end

function REFlex_UpdateLDB()
	if RE.RBGCounter then
		local REhk = GetPVPLifetimeStats();
		local _, REHonor = GetCurrencyInfo(HONOR_CURRENCY);
		local _, RECP = GetCurrencyInfo(CONQUEST_CURRENCY);

		if REHonor >= RE.HonorCap then
			RE.LDBBar.text = " |rH: |cFFFF141D" .. REHonor;
		else
			RE.LDBBar.text = " |rH: |cFFFFFFFF" .. REHonor;
		end

		if RE.RBGPointsWeek ~= nil then
			local REColor = "FFFFFFFF";
			if (RE.RBGSoftPointsWeek >= RE.RBGSoftMaxPointsWeek) and (RE.RBGPointsWeek ~= RE.RBGMaxPointsWeek) then
				REColor = "FFFFFF33";
			elseif RE.RBGPointsWeek == RE.RBGMaxPointsWeek then
				REColor = "FFFF141D";
			end
			if REFSettings["LDBCPCap"] then
				local RECPToGo = RE.RBGMaxPointsWeek - RE.RBGPointsWeek;
				if RECPToGo == 0 then
					RE.LDBBar.text = RE.LDBBar.text .. "|r  CP: |c" .. REColor .. RECP .. "|r";	
				else
					RE.LDBBar.text = RE.LDBBar.text .. "|r  CP: |c" .. REColor .. RECP .. "|r (|cFFFFFFFF" .. RECPToGo .. "|r)";
				end
			else
				RE.LDBBar.text = RE.LDBBar.text .. "|r  CP: |c" .. REColor .. RECP .. "|r"
			end
		else
			RE.LDBBar.text = RE.LDBBar.text .. "|r  CP: |cFFFFFFFF" .. RECP .. "|r"
		end

		if REFSettings["LDBHK"] then
			RE.LDBBar.text = RE.LDBBar.text .. "|r  HK: |cFFFFFFFF" .. REhk .. "|r"
		end

		if REFSettings["LDBShowTotalBG"] then
			RE.LDBBGWin, RE.LDBBGLoss, RE.LDBBGRatio = REFlex_WinLoss(nil, nil, nil, nil, nil, REFSettings["OnlyNew"]);
			RE.LDBBar.text = RE.LDBBar.text .. "|cFF696969  |  |rBG: |cFF00CC00" .. RE.LDBBGWin .. "|r - |cFFCC0000" .. RE.LDBBGLoss .. "|r |cFFFFFFFF(" .. RE.LDBBGRatio .. ")|r";
		end
		if REFSettings["LDBShowTotalArena"] then
			RE.LDBArenaWin, RE.LDBArenaLoss, RE.LDBArenaRatio = REFlex_WinLossArena(nil, nil, nil, nil, nil, REFSettings["OnlyNew"]);
			RE.LDBBar.text = RE.LDBBar.text .. "|cFF696969  |  |rA: |cFF00CC00" .. RE.LDBArenaWin .. "|r - |cFFCC0000" .. RE.LDBArenaLoss .. "|r |cFFFFFFFF(" .. RE.LDBArenaRatio .. ")|r";
		end

		if RE.LDBQueue ~= "" then
			RE.LDBBar.text = RE.LDBBar.text .. RE.LDBQueue;
		end
	end
end

function REFlex_UpdateLDBQueues(QueueID)
	if RE.RBGCounter then
		local REStatus, REMapName = GetBattlefieldStatus(QueueID);
		if REStatus == "queued" then
			local REWaitTime = GetBattlefieldEstimatedWaitTime(QueueID);
			local RETimeInQueue = GetBattlefieldTimeWaited(QueueID);
			RE.LDBQueue = RE.LDBQueue .. "|cFF696969  |  |r" .. REFlex_ShortMap(REMapName) .. ": |cFFFFFFFF" .. REFlex_ShortTime(RETimeInQueue) .. "|r / |cFF00CC00" .. REFlex_ShortTime(REWaitTime) .. "|r";
		end
	end
end

function REFlex_LDBTooltipFill(Field)
	local RELine = "0";
	local REOld = REFSettings["LastDayStats"][Field];
	local RENew = 0;
	if Field == "Honor" then
		_, RENew = GetCurrencyInfo(HONOR_CURRENCY);
	elseif Field == "CP" then
		_, RENew = GetCurrencyInfo(CONQUEST_CURRENCY);
	elseif Field == "RBG" then
		RENew = RE.RBG;
	elseif Field == "2v2" then
		local team2ID = ArenaTeam_GetTeamSizeID(2);
		if team2ID ~= nil then
			_, _, _, _, _, _, _, _, _, _, RENew = GetArenaTeam(team2ID);
		end
	elseif Field == "3v3" then
		local team3ID = ArenaTeam_GetTeamSizeID(3);
		if team3ID ~= nil then
			_, _, _, _, _, _, _, _, _, _, RENew = GetArenaTeam(team3ID);
		end
	elseif Field == "5v5" then
		local team5ID = ArenaTeam_GetTeamSizeID(5);
		if team5ID ~= nil then
			_, _, _, _, _, _, _, _, _, _, RENew = GetArenaTeam(team5ID);
		end
	elseif Field == "MMR" then
		RENew = REFSettings["CurrentMMR"];
	elseif Field == "MMRBG" then
		RENew = REFSettings["CurrentMMRBG"];
	end

	if RENew == nil then
		RENew = REOld;
	end
	local REDiff = RENew - REOld;

	if REDiff > 0 then
		RELine = "|cFF00CC00+" .. REDiff .. "|r";
	elseif REDiff < 0 then
		RELine = "|cFFCC0000" .. REDiff .. "|r";
	end

	return RELine;
end

function REFlex_LDBTooltip(self)
	local REBGWin, REBGLoss, REArenaWin, REArenaLoss, REKBTotal, REHKTotal, REHealingTotal, REDamageTotal, REKBTop, REHKTop, REHealingTop, REDamageTop = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
	local RETimeDay = tonumber(date("%d"));
	local RETimeMonth = tonumber(date("%m"));
	local RETimeYear = tonumber(date("%Y"));
	local REDatabaseItems, REDatabaseAItems = #REFDatabase, #REFDatabaseA;

	for i=1, #REFDatabase do
		if tonumber(date("%d", REFDatabase[REDatabaseItems]["TimeRaw"])) ~= RETimeDay or tonumber(date("%m", REFDatabase[REDatabaseItems]["TimeRaw"])) ~= RETimeMonth or tonumber(date("%Y", REFDatabase[REDatabaseItems]["TimeRaw"])) ~= RETimeYear then
			break;
		end

		if RE.Faction == REFDatabase[REDatabaseItems]["Winner"] then
			REBGWin = REBGWin + 1;
		else
			REBGLoss = REBGLoss + 1;
		end
		REKBTotal = REKBTotal + REFDatabase[REDatabaseItems]["KB"];
		if REFDatabase[REDatabaseItems]["KB"] > REKBTop then
			REKBTop = REFDatabase[REDatabaseItems]["KB"];
		end
		REHKTotal = REHKTotal + REFDatabase[REDatabaseItems]["HK"];
		if REFDatabase[REDatabaseItems]["HK"] > REHKTop then
			REHKTop = REFDatabase[REDatabaseItems]["HK"];
		end
		REDamageTotal = REDamageTotal + REFDatabase[REDatabaseItems]["Damage"];
		if REFDatabase[REDatabaseItems]["Damage"] > REDamageTop then
			REDamageTop = REFDatabase[REDatabaseItems]["Damage"];
		end
		REHealingTotal = REHealingTotal + REFDatabase[REDatabaseItems]["Healing"];
		if REFDatabase[REDatabaseItems]["Healing"] > REHealingTop then
			REHealingTop = REFDatabase[REDatabaseItems]["Healing"];
		end

		REDatabaseItems = REDatabaseItems - 1;
	end

	for i=1, #REFDatabaseA do
		if tonumber(date("%d", REFDatabaseA[REDatabaseAItems]["TimeRaw"])) ~= RETimeDay or tonumber(date("%m", REFDatabaseA[REDatabaseAItems]["TimeRaw"])) ~= RETimeMonth or tonumber(date("%Y", REFDatabaseA[REDatabaseAItems]["TimeRaw"])) ~= RETimeYear then
			break;
		end

		if REFDatabaseA[REDatabaseAItems]["Winner"] == REFDatabaseA[REDatabaseAItems]["PlayerTeam"] then
			REArenaWin = REArenaWin + 1;
		else
			REArenaLoss = REArenaLoss + 1;
		end
		REKBTotal = REKBTotal + REFDatabaseA[REDatabaseAItems]["KB"];
		if REFDatabaseA[REDatabaseAItems]["KB"] > REKBTop then
			REKBTop = REFDatabaseA[REDatabaseAItems]["KB"];
		end
		REDamageTotal = REDamageTotal + REFDatabaseA[REDatabaseAItems]["Damage"];
		if REFDatabaseA[REDatabaseAItems]["Damage"] > REDamageTop then
			REDamageTop = REFDatabaseA[REDatabaseAItems]["Damage"];
		end
		REHealingTotal = REHealingTotal + REFDatabaseA[REDatabaseAItems]["Healing"];
		if REFDatabaseA[REDatabaseAItems]["Healing"] > REHealingTop then
			REHealingTop = REFDatabaseA[REDatabaseAItems]["Healing"];
		end

		REDatabaseAItems = REDatabaseAItems - 1;
	end

	local RETooltip = RE.QTip:Acquire("RELDBToolTip", 3, "RIGHT", "CENTER", "LEFT");
	local RENormalFont = RETooltip:GetFont();
	self.tooltip = RETooltip;

	RETooltip:SetHeaderFont(SystemFont_Large);
	RETooltip:AddHeader("", "|cFFFFD100- " .. HONOR_TODAY .. " -|r", "");
	RETooltip:SetHeaderFont(GameTooltipHeader);
	RETooltip:AddLine();
	RETooltip:AddSeparator();
	RETooltip:AddLine();
	if REFSettings["UNBGSupport"] or REFSettings["RBGSupport"] then
		RETooltip:AddHeader("", "|cFF74D06C" .. BATTLEGROUND .. "|r", "");
		RETooltip:SetFont(GameTooltipHeader);
		RETooltip:AddLine("|cFF00CC00" .. REBGWin .. "|r", "-", "|cFFCC0000" .. REBGLoss .. "|r");
	else
		RETooltip:AddHeader("", "", "");
		RETooltip:SetFont(GameTooltipHeader);
		RETooltip:AddLine("", "", "");
	end
	RETooltip:AddLine();
	if REFSettings["ArenaSupport"] then
		RETooltip:AddHeader("", "|cFF74D06C" .. ARENA .. "|r", "");
		RETooltip:AddLine("|cFF00CC00" .. REArenaWin .. "|r", "-", "|cFFCC0000" .. REArenaLoss .. "|r");
	else
		RETooltip:AddHeader("", "", "");
		RETooltip:AddLine("", "", "");
	end
	RETooltip:AddLine();
	--RETooltip:AddLine();
	--RETooltip:AddHeader("", "|cFF74D06C" .. ARENA .. " MMR / RBG MMR|r", "");
	--RETooltip:AddLine("", REFSettings["CurrentMMR"] .. " |cFFFFD100(|r" .. REFlex_LDBTooltipFill("MMR") .. "|cFFFFD100) / |r" .. REFSettings["CurrentMMRBG"] .. " |cFFFFD100(|r" .. REFlex_LDBTooltipFill("MMRBG") .. "|cFFFFD100)|r", "");
	RETooltip:SetFont(RENormalFont);
	RETooltip:AddLine();
	RETooltip:AddSeparator();
	RETooltip:AddLine();
	RETooltip:SetColumnLayout(3, "LEFT", "CENTER", "CENTER");
	RETooltip:AddLine("", L["Total"], L["Top"]);
	RETooltip:AddLine("KB", REKBTotal, REKBTop);
	RETooltip:AddLine("HK", REHKTotal, REHKTop);
	RETooltip:AddLine(DAMAGE, REFlex_NumberClean(REDamageTotal), REFlex_NumberClean(REDamageTop));
	RETooltip:AddLine(SHOW_COMBAT_HEALING, REFlex_NumberClean(REHealingTotal), REFlex_NumberClean(REHealingTop));
	RETooltip:SetLineColor(16, 1, 1, 1, 0.5);
	RETooltip:SetLineColor(18, 1, 1, 1, 0.5);
	RETooltip:AddLine();
	RETooltip:AddSeparator();
	RETooltip:AddLine();
	RETooltip:SetColumnLayout(3, "CENTER", "CENTER", "CENTER");
	RETooltip:AddLine("|cFFFFD100" .. HONOR .. "|r", "|cFFFFD100" .. BG_RATING_ABBR .. "|r", "|cFFFFD100CP|r");
	RETooltip:AddLine(REFlex_LDBTooltipFill("Honor"), REFlex_LDBTooltipFill("RBG"), REFlex_LDBTooltipFill("CP"));
	RETooltip:AddLine();
	RETooltip:AddLine("|cFFFFD100" .. ARENA_2V2 .. " " .. RATING .."|r", "|cFFFFD100" .. ARENA_3V3 .. " " .. RATING .."|r", "|cFFFFD100" .. ARENA_5V5 .. " " .. RATING .."|r");
	RETooltip:AddLine(REFlex_LDBTooltipFill("2v2"), REFlex_LDBTooltipFill("3v3"), REFlex_LDBTooltipFill("5v5"));
	RETooltip:AddLine();
	RETooltip:AddLine();
	RETooltip:AddLine();

	RETooltip:SmartAnchorTo(self);
	RETooltip:Show();
end
--

-- MiniBar Subsection
function REFlex_UpdateMiniBar()
	if RE.SecondTimeMiniBar ~= true and REFSettings["ShowMiniBar"] then
		if RE.MiniBarPluginsCount > 0 then
			for i=1, RE.MiniBarPluginsCount do
				_G["REFlex_MiniBar" .. i]:Hide();
			end
		end

		RE.MiniBarPluginsID = {};
		RE.MiniBarPluginsCount = 0;
		local i = 1;
		local RESecondLineID = 0;
		local REFirstLineID = 0;

		for j=1, #REFSettings["MiniBarOrder"][RE.ActiveTalentGroup] do
			if REFSettings["MiniBarVisible"][RE.ActiveTalentGroup][REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]] == 1 then
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

				RE.MiniBarPluginsID[REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]] = i;
				i = i + 1;
			end
		end
		for j=1, #REFSettings["MiniBarOrder"][RE.ActiveTalentGroup] do
			if REFSettings["MiniBarVisible"][RE.ActiveTalentGroup][REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]] == 2 then 
				if RE.MiniBarSecondLineRdy then
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
					RE.MiniBarSecondLineRdy = true;
					RESecondLineID = i;
				end
				_G["REFlex_MiniBar" .. i]:Show();

				RE.MiniBarPluginsID[REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]] = i;
				i = i + 1;
			end
		end

		RE.MiniBarPluginsCount = i - 1;
		RE.SecondTimeMiniBar = true;
	elseif RE.SecondTimeMiniBar ~= true and REFSettings["ShowMiniBar"] == false then
		if RE.MiniBarPluginsCount > 0 then
			for i=1, RE.MiniBarPluginsCount do
				_G["REFlex_MiniBar" .. i]:Hide();
			end
		end

		RE.MiniBarPluginsID = {};
		local i = 1;

		for j=1, #REFSettings["MiniBarOrder"][RE.ActiveTalentGroup] do
			if REFSettings["MiniBarVisible"][RE.ActiveTalentGroup][REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]] == 1 or REFSettings["MiniBarVisible"][RE.ActiveTalentGroup][REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]] == 2 then
				RE.MiniBarPluginsID[REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]] = i;
				i = i + 1;
			end
		end

		RE.SecondTimeMiniBar = true;
	end

	local REMPlayerName = GetUnitName("player");
	local REMName = "";
	local REMPlayerID = 0;
	local i = 1;
	while REMName ~= REMPlayerName do
		REMName = GetBattlefieldScore(i);
		REMPlayerID = i;
		i = i + 1;
		if i == 100 then
			break
		end
	end

	local REMBGPlayers = GetNumBattlefieldScores();
	local REMMaxKB, REMMaxHK, REMMaxDamage, REMMaxHealing, REMMaxDeaths, REMMaxHonorGained = 0, 0, 0, 0, 0, 0;
	local _, REMkillingBlows, REMhonorKills, REMdeaths, REMhonorGained, _, _, _, _, REMdamageDone, REMhealingDone = GetBattlefieldScore(REMPlayerID);
	local REPlaceKB, REPlaceHK, REPlaceHonor, REPlaceDamage, REPlaceHealing, REPlaceDeaths = REMBGPlayers, REMBGPlayers, REMBGPlayers, REMBGPlayers, REMBGPlayers, REMBGPlayers;

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
			
			if REMkillingBlows > killingBlowsTemp then
				REPlaceKB = REPlaceKB - 1;
			end
			if REMhonorKills > honorKillsTemp then
				REPlaceHK = REPlaceHK - 1;
			end
			if REMhonorGained > honorGainedTemp then
				REPlaceHonor = REPlaceHonor - 1;
			end
			if REMdamageDone > damageDoneTemp then
				REPlaceDamage = REPlaceDamage - 1;
			end
			if REMhealingDone > healingDoneTemp then
				REPlaceHealing = REPlaceHealing - 1;
			end
			if REMdeaths < deathsTemp then
				REPlaceDeaths = REPlaceDeaths - 1;
			end
		end
	end

	local REMKBD = REMkillingBlows - REMMaxKB;
	local REMHKD = REMhonorKills - REMMaxHK;
	local REMDamageD = REMdamageDone - REMMaxDamage;
	local REMHealingD = REMhealingDone - REMMaxHealing;
	local REMDeathsD = REMdeaths - REMMaxDeaths;
	local REMHonorD = REMhonorGained - REMMaxHonorGained;
	local REMKDRatio = 0;
	if REMdeaths ~= 0 then
		REMKDRatio = REFlex_Round(REMkillingBlows/REMdeaths, 2);
	else
		REMKDRatio = REMkillingBlows;
	end

	local REMiniBarLabel = "";
	local REMiniBarValue = "";
	local REMiniBarLDBValue = "";
	local RESecondTimeBGLDB = false;
	local REIsRated = IsRatedBattleground();

	if REFSettings["LDBBGMorph"] then
		RE.LDBBar.text = "|r";
	end
	for j=1, #REFSettings["MiniBarOrder"][RE.ActiveTalentGroup] do
		if RE.MiniBarPluginsID[REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]] ~= nil then
			if REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] == "KillingBlows" then
				if REMKBD > 0 then
					REMKBD = "|cFF00ff00+" .. REMKBD .. "|r"
				elseif REMKBD < 0 then
					REMKBD = "|cFFFF141D" .. REMKBD .. "|r"
				end

				REMiniBarLabel = "KB:";
				REMiniBarValue = REMkillingBlows .. " (" .. REMKBD .. ")";
				if REFSettings["LDBShowPlace"] then
					REMiniBarLDBValue = "|cFFFFFFFF" .. REMkillingBlows .. "|r  (" .. REPlaceKB .. ")";
				else
					REMiniBarLDBValue = "|cFFFFFFFF" .. REMkillingBlows .. "|r  (" .. REMKBD .. ")";
				end
			elseif REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] == "HonorKills" then
				if REIsRated then
					REMiniBarLabel = "";
					REMiniBarLDBValue = "";
				else
					if REMHKD > 0 then
						REMHKD = "|cFF00ff00+" .. REMHKD .. "|r"
					elseif REMHKD < 0 then
						REMHKD = "|cFFFF141D" .. REMHKD .. "|r"
					end

					REMiniBarLabel = "HK:";
					REMiniBarValue = REMhonorKills .. " (" .. REMHKD .. ")";
					if REFSettings["LDBShowPlace"] then
						REMiniBarLDBValue = "|cFFFFFFFF" .. REMhonorKills .. "|r  (" .. REPlaceHK .. ")";
					else
						REMiniBarLDBValue = "|cFFFFFFFF" .. REMhonorKills .. "|r  (" .. REMHKD .. ")";
					end
				end
			elseif REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] == "Damage" then
				if REMDamageD > 0 then
					REMDamageD = "|cFF00ff00+" .. REFlex_NumberClean(REMDamageD) .. "|r"
				elseif REMDamageD < 0 then
					REMDamageD = "|cFFFF141D" .. REFlex_NumberClean(REMDamageD) .. "|r"
				end

				REMiniBarLabel = "Dam:";
				REMiniBarValue = REFlex_NumberClean(REMdamageDone) .. " (" .. REMDamageD .. ")";
				if REFSettings["LDBShowPlace"] then
					REMiniBarLDBValue = "|cFFFFFFFF" .. REFlex_NumberClean(REMdamageDone) .. "|r  (" .. REPlaceDamage .. ")";
				else
					REMiniBarLDBValue = "|cFFFFFFFF" .. REFlex_NumberClean(REMdamageDone) .. "|r  (" .. REMDamageD .. ")";
				end
			elseif REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] == "Healing" then
				if REMHealingD > 0 then
					REMHealingD = "|cFF00ff00+" .. REFlex_NumberClean(REMHealingD) .. "|r"
				elseif REMHealingD < 0 then
					REMHealingD = "|cFFFF141D" .. REFlex_NumberClean(REMHealingD) .. "|r"
				end

				REMiniBarLabel = "Hea:";
				REMiniBarValue = REFlex_NumberClean(REMhealingDone) .. " (" .. REMHealingD .. ")";
				if REFSettings["LDBShowPlace"] then
					REMiniBarLDBValue = "|cFFFFFFFF" .. REFlex_NumberClean(REMhealingDone) .. "|r  (" .. REPlaceHealing .. ")";
				else
					REMiniBarLDBValue = "|cFFFFFFFF" .. REFlex_NumberClean(REMhealingDone) .. "|r  (" .. REMHealingD .. ")";
				end
			elseif REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] == "Deaths" then
				if REMDeathsD > 0 then
					REMDeathsD = "|cFFFF141D+" .. REMDeathsD .. "|r"
				elseif REMDeathsD < 0 then
					REMDeathsD = "|cFF00ff00" .. REMDeathsD .. "|r"
				end

				REMiniBarLabel = "Dea:";
				REMiniBarValue = REMdeaths .. " (" .. REMDeathsD .. ")";
				if REFSettings["LDBShowPlace"] then
					REMiniBarLDBValue = "|cFFFFFFFF" .. REMdeaths .. "|r  (" .. REPlaceDeaths .. ")";
				else
					REMiniBarLDBValue = "|cFFFFFFFF" .. REMdeaths .. "|r  (" .. REMDeathsD .. ")";
				end
			elseif REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] == "KDRatio" then
				REMiniBarLabel = "K/D:";
				if REMKDRatio >= 1 then
					REMiniBarValue = "|cFF00ff00" .. REMKDRatio .. "|r";
					REMiniBarLDBValue = REMiniBarValue;
				else
					REMiniBarValue = "|cFFFF141D" .. REMKDRatio .. "|r";
					REMiniBarLDBValue = REMiniBarValue;
				end
			elseif REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j] == "Honor" then
				if REMHonorD > 0 then
					REMHonorD = "|cFF00ff00+" .. REMHonorD .. "|r"
				elseif REMHonorD < 0 then
					REMHonorD = "|cFFFF141D" .. REMHonorD .. "|r"
				end

				REMiniBarLabel = "Hon:";
				REMiniBarValue = REMhonorGained .. " (" .. REMHonorD .. ")";
				if REFSettings["LDBShowPlace"] then
					REMiniBarLDBValue = "|cFFFFFFFF" .. REMhonorGained .. "|r  (" .. REPlaceHonor .. ")";
				else
					REMiniBarLDBValue = "|cFFFFFFFF" .. REMhonorGained .. "|r  (" .. REMHonorD .. ")";
				end
			end

			if REFSettings["ShowMiniBar"] then
				_G["REFlex_MiniBar" .. RE.MiniBarPluginsID[REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]] .. "_Label"]:SetText(REMiniBarLabel);
				_G["REFlex_MiniBar" .. RE.MiniBarPluginsID[REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]] .. "_Value"]:SetText(REMiniBarValue);
			end
			if REFSettings["LDBBGMorph"] then
				if RESecondTimeBGLDB == false then
					if REMiniBarLabel ~= "" and REMiniBarLDBValue ~= "" then
						RE.LDBBar.text = RE.LDBBar.text .. " " .. REMiniBarLabel .. "  " .. REMiniBarLDBValue;
					end
					RESecondTimeBGLDB = true;
				else
					if REMiniBarLabel ~= "" and REMiniBarLDBValue ~= "" then
						RE.LDBBar.text = RE.LDBBar.text .. "|cFF696969  |  |r" .. REMiniBarLabel .. "  " .. REMiniBarLDBValue;
					end
				end
			end
		end
	end
end
--
-- ***
