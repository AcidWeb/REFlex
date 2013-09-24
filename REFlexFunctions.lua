local RE = REFlexNamespace;
local L = REFlexLocale;

-- *** Auxiliary functions

-- GUI subsection
function REFlex_SettingsReloadInternal(Field)
	if REFSettings[Field] then
		_G["REFlex_GUI_" .. Field]:SetChecked(true);
	else	
		_G["REFlex_GUI_" .. Field]:SetChecked(false);
	end
end

function REFlex_SettingsReload()
	REFlex_MainTab:Hide();

	if REFSettings["ShowMinimapButton"] then
		REFlex_MinimapButton:Show();
		REFlex_MinimapButtonReposition();
	else
		REFlex_MinimapButton:Hide();
	end
	
	for i=1, #RE.Options do
		REFlex_SettingsReloadInternal(RE.Options[i]);
	end	

	REFlex_GUI_SliderScale:SetValue(REFSettings["MiniBarScale"]);
	RE.SecondTimeMiniBar = false;
	RE.MiniBarSecondLineRdy = false;
	RequestRatedBattlegroundInfo();
	REFlex_UpdateLDB();
	
	if RE.NeedReload then
		ReloadUI();
	end
end

function REFlex_GUISaveInternal(Field)
	local REButtonCheck = _G["REFlex_GUI_" .. Field]:GetChecked();
	if REButtonCheck == 1 then
		if REFSettings[Field] == false and (Field == "ArenaSupport" or Field == "RBGSupport" or Field == "UNBGSupport") then
			RE.NeedReload = true;
		end
		REFSettings[Field] = true;
	else
		if REFSettings[Field] == true and (Field == "ArenaSupport" or Field == "RBGSupport" or Field == "UNBGSupport") then
			RE.NeedReload = true;
		end
		REFSettings[Field] = false;
	end
end

function REFlex_GUISave()
	RE.NeedReload = false;
	
	for i=1, #RE.Options do
		REFlex_GUISaveInternal(RE.Options[i]);
	end
	
	REFSettings["MiniBarScale"] = REFlex_Round(REFlex_GUI_SliderScale:GetValue(),2);

	REFlex_SettingsReload();
end

function REFlex_GUI_ModuleChangeBar(ModuleName, NewBar, OldBar) 
	if OldBar == 1 then
		local FirstLineCount = 0;
		for j=1, #REFSettings["MiniBarOrder"][RE.ActiveTalentGroup] do
			if REFSettings["MiniBarVisible"][RE.ActiveTalentGroup][REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][j]] == 1 then
				FirstLineCount = FirstLineCount + 1;
			end
		end
		if FirstLineCount >= 2 then
			REFSettings["MiniBarVisible"][RE.ActiveTalentGroup][ModuleName] = NewBar;
		end
	else
		REFSettings["MiniBarVisible"][RE.ActiveTalentGroup][ModuleName] = NewBar;
	end

	REFlex_GUIModulesOnShow();
	REFlex_SettingsReload();
end

function REFlex_GUI_ModuleChangeBarOrder(ModuleName, OldOrder, NewOrder) 
	local RETempName = REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][NewOrder]
	REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][NewOrder] = ModuleName;
	REFSettings["MiniBarOrder"][RE.ActiveTalentGroup][OldOrder] = RETempName;

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

function REFlex_ShortTime(TimeToShort)
	local TimeRaw = math.floor(TimeToShort / 1000);
	local TimeSec = math.floor(TimeRaw % 60);
	local TimeMin = math.floor(TimeRaw / 60);
	if TimeSec < 10 then
		TimeSec = "0" .. TimeSec;
	end

	return TimeMin .. ":" .. TimeSec;
end

function REFlex_NumberClean(Number, Round)
	local RoundAlpha, RoundBeta;
	if Round == nil then
		RoundAlpha = 2;
		RoundBeta = 0;
	else
		RoundAlpha, RoundBeta = Round, Round;	
	end

	if Number >= 0 then 
		if Number >= 1000000 then
			Number = REFlex_Round((Number / 1000000), RoundAlpha) .. "M";
		elseif Number >= 1000 then
			Number = REFlex_Round((Number / 1000), RoundBeta) .. "K";
		end
	else
		if Number <= -1000000 then
			Number = REFlex_Round((Number / 1000000), RoundAlpha) .. "M";
		elseif Number <= -1000 then
			Number = REFlex_Round((Number / 1000), RoundBeta) .. "K";
		end
	end
	return Number;
end

function REFlex_FindI(FieldName, j)
	RE.FSum = RE.FSum + REFDatabase[j][FieldName];
	if RE.FTop < REFDatabase[j][FieldName] then
		RE.FTop = REFDatabase[j][FieldName];
	end
end

function REFlex_Find(FieldName, Rated, TalentSets, Map)
	RE.FTop = 0;
	RE.FSum = 0;

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

	return RE.FTop, RE.FSum;
end

function REFlex_FindArenaI(FieldName, j)
	RE.FSum = RE.FSum + REFDatabaseA[j][FieldName];
	if RE.FTop < REFDatabaseA[j][FieldName] then
		RE.FTop = REFDatabaseA[j][FieldName];
	end
end

function REFlex_FindArena(FieldName, Bracket, TalentSets, Map)
	RE.FTop = 0;
	RE.FSum = 0;

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

	return RE.FTop, RE.FSum;
end

function REFlex_WinLossI(Faction, j, TimeF, TimeT)
	if (TimeF == nil) or (REFDatabase[j]["TimeRaw"] >= TimeF and REFDatabase[j]["TimeRaw"] <= TimeT and REFDatabase[j]["RBG" .. RE.Faction .. "Team"] ~= nil) then
		if Faction == "Horde" then
			if REFDatabase[j]["Winner"] == FACTION_HORDE then
				RE.Win = RE.Win + 1;
			else
				RE.Loss = RE.Loss + 1;
			end
		else
			if REFDatabase[j]["Winner"] == FACTION_ALLIANCE then
				RE.Win = RE.Win + 1;
			else
				RE.Loss = RE.Loss + 1;
			end
		end
	end
end

function REFlex_WinLoss(Rated, TalentSets, Map, TimeF, TimeT)
	RE.Win = 0;
	RE.Loss = 0;

	if Map == nil then
		if TalentSets ~= nil then
			if Rated then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] and REFDatabase[j]["TalentSet"] == TalentSets then
						REFlex_WinLossI(RE.Faction, j, TimeF, TimeT);
					end
				end
			elseif Rated == false then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] == false and REFDatabase[j]["TalentSet"] == TalentSets then
						REFlex_WinLossI(RE.Faction, j, TimeF, TimeT);	
					end
				end
			else
				for j=1, #REFDatabase do
					if REFDatabase[j]["TalentSet"] == TalentSets then
						REFlex_WinLossI(RE.Faction, j, TimeF, TimeT);	
					end
				end
			end
		else
			if Rated then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] then
						REFlex_WinLossI(RE.Faction, j, TimeF, TimeT);	
					end
				end
			elseif Rated == false then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] == false then
						REFlex_WinLossI(RE.Faction, j, TimeF, TimeT);	
					end
				end
			else
				for j=1, #REFDatabase do
					REFlex_WinLossI(RE.Faction, j, TimeF, TimeT);
				end
			end
		end
	else
		if TalentSets ~= nil then
			if Rated then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] and REFDatabase[j]["TalentSet"] == TalentSets and REFDatabase[j]["MapName"] == Map then
						REFlex_WinLossI(RE.Faction, j, TimeF, TimeT);
					end
				end
			elseif Rated == false then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] == false and REFDatabase[j]["TalentSet"] == TalentSets and REFDatabase[j]["MapName"] == Map then
						REFlex_WinLossI(RE.Faction, j, TimeF, TimeT);	
					end
				end
			else
				for j=1, #REFDatabase do
					if REFDatabase[j]["TalentSet"] == TalentSets and REFDatabase[j]["MapName"] == Map then
						REFlex_WinLossI(RE.Faction, j, TimeF, TimeT);	
					end
				end
			end
		else
			if Rated then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] and REFDatabase[j]["MapName"] == Map then
						REFlex_WinLossI(RE.Faction, j, TimeF, TimeT);	
					end
				end
			elseif Rated == false then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] == false and REFDatabase[j]["MapName"] == Map then
						REFlex_WinLossI(RE.Faction, j, TimeF, TimeT);	
					end
				end
			else
				for j=1, #REFDatabase do
					if REFDatabase[j]["MapName"] == Map then
						REFlex_WinLossI(RE.Faction, j, TimeF, TimeT);
					end
				end
			end
		end
	end

	local RERatio = math.floor((RE.Win/(RE.Win+RE.Loss))*100) .. "%";
	return RE.Win, RE.Loss, RERatio;
end

function REFlex_WinLossArenaI(j)
	if REFDatabaseA[j]["Winner"] == REFDatabaseA[j]["PlayerTeam"] then
		RE.Win = RE.Win + 1;
	else
		RE.Loss = RE.Loss + 1;
	end
end

function REFlex_WinLossArena(Bracket, TalentSets, Map)
	RE.Win = 0;
	RE.Loss = 0;

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

	local RERatio = math.floor((RE.Win/(RE.Win+RE.Loss))*100) .. "%";
	return RE.Win, RE.Loss, RERatio;
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

function REFlex_ArenaTeamGrid(IDTo)
	for j=IDTo, #REFDatabaseA do
		if REFDatabaseA[j] == nil then
			break;
		end

		local REEnemyNames, _, _, _, _, _, REEnemyNamesSpec = REFlex_ArenaTeamHash(j, true);

		local REEnemyTeamID = table.concat(REEnemyNames);
		if RE.ArenaTeams[REEnemyTeamID] == nil then
			RE.ArenaTeams[REEnemyTeamID] = {};
			RE.ArenaTeams[REEnemyTeamID]["Win"] = 0;
			RE.ArenaTeams[REEnemyTeamID]["Loss"] = 0;
		end
		if  REFDatabaseA[j]["Winner"] == REFDatabaseA[j]["PlayerTeam"] then
			RE.ArenaTeams[REEnemyTeamID]["Win"] = RE.ArenaTeams[REEnemyTeamID]["Win"] + 1;
		else
			RE.ArenaTeams[REEnemyTeamID]["Loss"] = RE.ArenaTeams[REEnemyTeamID]["Loss"] + 1;
		end

		if REEnemyNamesSpec[1] ~= nil then
			local RETempBracket = { strsplit("#", table.concat(REEnemyNamesSpec)) };
			local REEnemyTeamID = RETempBracket[3];
			
			if RE.ArenaTeamsSpec[REEnemyTeamID] == nil then
				RE.ArenaTeamsSpec[REEnemyTeamID] = {};
				RE.ArenaTeamsSpec[REEnemyTeamID]["Win"] = 0;
				RE.ArenaTeamsSpec[REEnemyTeamID]["Loss"] = 0;
				RE.ArenaTeamsSpec[REEnemyTeamID]["Total"] = 0;
				RE.ArenaTeamsSpec[REEnemyTeamID]["Win1"] = 0;
				RE.ArenaTeamsSpec[REEnemyTeamID]["Loss1"] = 0;
				RE.ArenaTeamsSpec[REEnemyTeamID]["Total1"] = 0;
				RE.ArenaTeamsSpec[REEnemyTeamID]["Win2"] = 0;
				RE.ArenaTeamsSpec[REEnemyTeamID]["Loss2"] = 0;
				RE.ArenaTeamsSpec[REEnemyTeamID]["Total2"] = 0;
				RE.ArenaTeamsSpec[REEnemyTeamID]["Team"] = REEnemyTeamID;
				RE.ArenaTeamsSpec[REEnemyTeamID]["Bracket"] = RETempBracket[2];
				RE.ArenaTeamsSpec[REEnemyTeamID]["TalentSet"] = REFDatabaseA[j]["TalentSet"];
			end
			
			if  REFDatabaseA[j]["Winner"] == REFDatabaseA[j]["PlayerTeam"] then
				RE.ArenaTeamsSpec[REEnemyTeamID]["Win"] = RE.ArenaTeamsSpec[REEnemyTeamID]["Win"] + 1;
				RE.ArenaTeamsSpec[REEnemyTeamID]["Win" .. REFDatabaseA[j]["TalentSet"]] = RE.ArenaTeamsSpec[REEnemyTeamID]["Win" .. REFDatabaseA[j]["TalentSet"]] + 1;
			else
				RE.ArenaTeamsSpec[REEnemyTeamID]["Loss"] = RE.ArenaTeamsSpec[REEnemyTeamID]["Loss"] + 1;
				RE.ArenaTeamsSpec[REEnemyTeamID]["Loss" .. REFDatabaseA[j]["TalentSet"]] = RE.ArenaTeamsSpec[REEnemyTeamID]["Loss" .. REFDatabaseA[j]["TalentSet"]] + 1;
			end
			RE.ArenaTeamsSpec[REEnemyTeamID]["Total"] = RE.ArenaTeamsSpec[REEnemyTeamID]["Total"] + 1;
			RE.ArenaTeamsSpec[REEnemyTeamID]["Total" .. REFDatabaseA[j]["TalentSet"]] = RE.ArenaTeamsSpec[REEnemyTeamID]["Total" .. REFDatabaseA[j]["TalentSet"]] + 1;
		end
		RE.ArenaLastID = j;
	end
end

function REFlex_Tab7PlayerGrid(TimeF, TimeT)
	RE.Tab7Matrix = {};
	local REBGCounter = 0;
	
 	for j=1, #REFDatabase do
		if REFDatabase[j]["IsRated"] and REFDatabase[j]["RBG" .. RE.Faction .. "Team"] ~= nil and REFDatabase[j]["TimeRaw"] >= TimeF and REFDatabase[j]["TimeRaw"] <= TimeT then
			for k=1, #REFDatabase[j]["RBG" .. RE.Faction .. "Team"] do
				local REName = REFlex_NameClean(REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["name"]);
				if RE.Tab7Matrix[REName] == nil then
					RE.Tab7Matrix[REName] = {};
					RE.Tab7Matrix[REName]["Name"] = REName;
					RE.Tab7Matrix[REName]["Class"] = REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["classToken"];
					RE.Tab7Matrix[REName]["Time"] = j;
					RE.Tab7Matrix[REName]["Attendance"] = 1;
					if REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["PreMMR"] ~= nil and REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["BGRating"] ~= nil and REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["MMRChange"] ~= nil and REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["BGRatingChange"] ~= nil then
						RE.Tab7Matrix[REName]["MMR"] = REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["PreMMR"];
						RE.Tab7Matrix[REName]["LastMMR"] = REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["PreMMR"] + REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["MMRChange"];
						RE.Tab7Matrix[REName]["RBG"] = REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["BGRating"];
						RE.Tab7Matrix[REName]["LastRBG"] = REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["BGRating"]  + REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["BGRatingChange"];
					end
				else
					RE.Tab7Matrix[REName]["Time"] = j;
					RE.Tab7Matrix[REName]["Attendance"] = RE.Tab7Matrix[REName]["Attendance"] + 1;
					if REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["PreMMR"] ~= nil and REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["BGRating"] ~= nil and REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["MMRChange"] ~= nil and REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["BGRatingChange"] ~= nil then
						RE.Tab7Matrix[REName]["LastMMR"] = REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["PreMMR"] + REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["MMRChange"];
						RE.Tab7Matrix[REName]["LastRBG"] = REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["BGRating"] + REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["BGRatingChange"];
					end
					if (RE.Tab7Matrix[REName]["MMR"] == nil and RE.Tab7Matrix[REName]["RBG"] == nil) and (REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["PreMMR"] ~= nil and REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["BGRating"] ~= nil) then
						RE.Tab7Matrix[REName]["MMR"] = REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["PreMMR"];
						RE.Tab7Matrix[REName]["RBG"] = REFDatabase[j]["RBG" .. RE.Faction .. "Team"][k]["BGRating"];
					end
				end
			end
			REBGCounter = REBGCounter + 1;
		end
	end

	local RETableCount, RETableI = REFlex_TableCount(RE.Tab7Matrix);
	for j=1, RETableCount do
		if RE.Tab7Matrix[RETableI[j]]["MMR"] ~= nil and RE.Tab7Matrix[RETableI[j]]["RBG"] ~= nil then
			RE.Tab7Matrix[RETableI[j]]["DiffMMR"] = RE.Tab7Matrix[RETableI[j]]["LastMMR"] - RE.Tab7Matrix[RETableI[j]]["MMR"];
			RE.Tab7Matrix[RETableI[j]]["DiffRBG"] = RE.Tab7Matrix[RETableI[j]]["LastRBG"] - RE.Tab7Matrix[RETableI[j]]["RBG"];
		end
	end

	return REBGCounter;
end
--

-- Timers subsection
function REFlex_MiniBarDelay()
	REFlex_Frame:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
end

function REFlex_PVPUpdateDelay()
	RE.RBGCounter = true;
	RequestRatedBattlegroundInfo();
	REFlex_UpdateLDB();
end

function REFlex_ArenaTalentCheck()
	local _, REZoneType = IsInInstance();
	if REZoneType == "arena" then
		if RE.PartyArenaCheck == 0 then
			local RETalentGroup = GetActiveTalentGroup(false);
			local REPartyName = GetUnitName("player", true);
			_, RE.ArenaRaces[REPartyName] = UnitRace("player");

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

			RE.ArenaBuilds[REPartyName] = REBuildName;
			RE.PartyArenaCheck = 1;
			REFlex_ArenaTalentCheck();
		elseif RE.PartyArenaCheck < 5 then
			local REPartyName = GetUnitName("party" .. RE.PartyArenaCheck, true)

			if REPartyName ~= nil and REPartyName ~= UNKNOWN then
				ClearInspectPlayer();
				REFlex_Frame:RegisterEvent("INSPECT_READY");
				NotifyInspect("party" .. RE.PartyArenaCheck);
			else
				RE.ShefkiTimer:ScheduleTimer(REFlex_ArenaTalentCheck, 10);
			end
		end
	end
end
--

-- String subsection
function REFlex_ShortMap(MapName)
	if MapName == nil then
		MapName = "-";
	end
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
function REFlex_DeleteEntry(DatabaseID)
	local Visible, IsArena = 0, false;
	local Visible1 = REFlex_MainTab_Tab1:IsVisible();
	local Visible2 = REFlex_MainTab_Tab2:IsVisible();
	local Visible3 = REFlex_MainTab_Tab3:IsVisible();
	local Visible5 = REFlex_MainTab_Tab5:IsVisible();

	if Visible1 == 1 then
		Visible = 1;
	elseif Visible2 == 1 then
		Visible = 2;
	elseif Visible3 == 1 then
		Visible = 3;
	elseif Visible5 == 1 then
		IsArena = true;
		Visible = 5;
	end

	_G["REFlex_MainTab_Tab" .. Visible]:Hide();

	if IsArena then
		table.remove(REFDatabaseA,DatabaseID);
	else
		table.remove(REFDatabase,DatabaseID);
	end

	_G["REFlexNamespace"]["Tab" .. Visible .. "LastID"] = 0;
	_G["REFlexNamespace"]["Tab" .. Visible .. "TableData"] = {};
	_G["REFlex_MainTab_Tab" .. Visible]:Show();
end

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
	local cols = RE["MainTable" .. TableName].cols;
	local st = RE["MainTable" .. TableName];

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
	RE["MainTable" .. TableName]:SortData();
end

function REFlex_FindTab7Default()
	_, RE.Tab7Default["T"]["m"], RE.Tab7Default["T"]["d"], RE.Tab7Default["T"]["y"] = CalendarGetDate();
	_, RE.Tab7Search["T"]["m"], RE.Tab7Search["T"]["d"], RE.Tab7Search["T"]["y"] = CalendarGetDate();

	for i=1, #REFDatabase do
		if REFDatabase[i]["IsRated"] and REFDatabase[i]["RBG" .. RE.Faction .. "Team"] ~= nil then
			RE.Tab7Default["F"]["m"] = tonumber(REFDatabase[i]["TimeMo"]);
			RE.Tab7Default["F"]["d"] = tonumber(REFDatabase[i]["TimeDa"]);
			RE.Tab7Default["F"]["y"] = tonumber(REFDatabase[i]["TimeYe"]);
			RE.Tab7Search["F"]["m"] = tonumber(REFDatabase[i]["TimeMo"]);
			RE.Tab7Search["F"]["d"] = tonumber(REFDatabase[i]["TimeDa"]);
			RE.Tab7Search["F"]["y"] = tonumber(REFDatabase[i]["TimeYe"]);
			break;
		end
	end
end

function REFlex_Tab_DefaultFilter(self, rowdata)
	if RE.TalentTab ~= nil then
		if rowdata["cols"][12]["value"] == RE.TalentTab then
			return true;
		else
			return false;
		end
	else
		return true;
	end
end

function REFlex_Tab_Tab7Filter(self, rowdata)
	if RE.Tab7GuildOnly and RE.InGuild == 1 then
		for i=1, #RE.GuildMembers do
			if RE.GuildMembers[i] == rowdata["cols"][12]["value"] then
				return true;
			end
		end
	
		return false;
	else
		return true;
	end
end

function REFlex_Tab_NameFilter(self, rowdata)
	if RE.TalentTab ~= nil then
		if rowdata["cols"][12]["value"] == RE.TalentTab then
			local REEnemyNames, _, REFriendNames = REFlex_ArenaTeamHash(rowdata["cols"][13]["value"]);
			for i=1, #REEnemyNames do
				if REFlex_NameClean(REEnemyNames[i]) == RE.NameSearch then
					return true;
				end
			end
			for i=1, #REFriendNames do
				if REFriendNames[i] == RE.NameSearch then
					return true;
				end
			end
			return false;
		else
			return false;
		end
	else
		local REEnemyNames, _, REFriendNames = REFlex_ArenaTeamHash(rowdata["cols"][13]["value"]);
		for i=1, #REEnemyNames do
			if REFlex_NameClean(REEnemyNames[i]) == RE.NameSearch then
				return true;
			end
		end
		for i=1, #REFriendNames do
			if REFriendNames[i] == RE.NameSearch then
				return true;
			end
		end
		return false;	
	end
end

function REFlex_TableRatingMMRArena(PlayerTeam, j)
	local Rating = 0;
	local MMR = REFDatabaseA[j]["MMRChange"];

	if MMR ~= nil then
		if MMR > 0 then
			MMR = " / |cFF00FF00+" .. MMR.. "|r";
		elseif MMR < 0 then
			MMR = " / |cFFFF141C" .. MMR.. "|r";
		end
	else
		MMR = "";
	end
	
	if PlayerTeam  == 0 then
		Rating = REFDatabaseA[j]["GreenTeamRatingChange"];
	else
		Rating = REFDatabaseA[j]["GoldTeamRatingChange"];
	end

	if Rating > 0 then
		Rating = "|cFF00FF00+" .. Rating.. "|r";
	elseif Rating < 0 then
		Rating = "|cFFFF141C" .. Rating.. "|r";
	end

	return Rating .. MMR;
end

function REFlex_TableRBGRatingMMRColor(Rating, j)
	local Color = "";
	
	if Rating > 0 then
		Color = "|CFF00FF00+"; 
	elseif Rating < 0 then
		Color = "|CFFFF141C"; 
	end

	local MMR = REFDatabase[j]["MMRChange"];

	if MMR ~= nil then
		if MMR > 0 then
			MMR = " / |cFF00FF00+" .. MMR.. "|r";
		elseif MMR < 0 then
			MMR = " / |cFFFF141C" .. MMR.. "|r";
		end
	else
		MMR = "";
	end

	return Color .. Rating .. "|r" .. MMR;
end

function REFlex_TableRBGRatingMMR(Faction, j)
	local RELine = "";
	
	if REFDatabase[j][Faction .. "MMR"] ~= nil then
		RELine = " / " .. REFDatabase[j][Faction .. "MMR"];
	end

	return REFDatabase[j][Faction .. "Rating"] .. RELine;
end

function REFlex_TableTeamArenaTab6(TeamString)
	local RETeamLine = "";

	local RETeam = { strsplit("@", TeamString) };
	for i=1, (#RETeam - 1) do
		local REMember = { strsplit("*", RETeam[i]) };

		RETeamLine = RETeamLine .. "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:25:25:0:0:256:256:" .. RE.ClassIconCoords[REMember[1]][1]*256 .. ":" .. RE.ClassIconCoords[REMember[1]][2]*256 .. ":".. RE.ClassIconCoords[REMember[1]][3]*256 ..":" .. RE.ClassIconCoords[REMember[1]][4]*256 .."|t |cFF" .. RE.ClassColors[REMember[1]] .. string.sub(REMember[2], 1, 2) .. "|r  ";
	end

	return RETeamLine;
end

function REFlex_TableTab7Field(Value, Field)
	if Field == "LastMMR" or Field == "LastRBG" then
		if Value == nil then
			return "";
		else
			return Value;
		end
	elseif Field == "DiffMMRa" or Field == "DiffRBGa" then
		if Value == nil then
			return -1;
		else
			return Value;
		end
	elseif Field == "DiffMMR" or Field == "DiffRBG" then
		if Value ~= nil then
			if Value > 0 then
				return "|cFF00FF00+" .. Value.. "|r";
			elseif Value < 0 then
				return "|cFFFF141C" .. Value .. "|r";
			else
				return Value;
			end
		else
			return "";
		end
	end
end

function REFlex_TableTeamArena(IsEnemy, j)
	local Line = "";

	if IsEnemy then
		local REEnemyNames, REEnemyID, _, _, _, TeamE = REFlex_ArenaTeamHash(j, true);

		for jj=1, #REEnemyID do
			local ClassToken = REFDatabaseA[j][TeamE .. "Team"][REEnemyID[jj]]["ClassToken"];
			Line = Line .. " |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:25:25:0:0:256:256:" .. RE.ClassIconCoords[ClassToken][1]*256 .. ":" .. RE.ClassIconCoords[ClassToken][2]*256 .. ":".. RE.ClassIconCoords[ClassToken][3]*256 ..":" .. RE.ClassIconCoords[ClassToken][4]*256 .."|t "
		end
	else
		local _, _, REFriendNames, REFriendID, Team = REFlex_ArenaTeamHash(j, false);

		for jj=1, #REFriendID do
			local ClassToken = REFDatabaseA[j][Team .. "Team"][REFriendID[jj]]["ClassToken"];
			Line = Line .. " |TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:25:25:0:0:256:256:" .. RE.ClassIconCoords[ClassToken][1]*256 .. ":" .. RE.ClassIconCoords[ClassToken][2]*256 .. ":".. RE.ClassIconCoords[ClassToken][3]*256 ..":" .. RE.ClassIconCoords[ClassToken][4]*256 .."|t "
		end
	end

	return Line
end

function REFlex_TableTeamArenaRating(IsEnemy, j)
	local Line = "";

	if IsEnemy then
		local _, _, _, _, _, TeamE = REFlex_ArenaTeamHash(j, true);

		if REFDatabaseA[j][TeamE .. "TeamRating"] >= 0 then
			if REFDatabaseA[j][TeamE .. "TeamMMR"] ~= nil then
				Line = REFDatabaseA[j][TeamE .. "TeamRating"] .. " / " .. REFDatabaseA[j][TeamE .. "TeamMMR"];
			else
				Line = REFDatabaseA[j][TeamE .. "TeamRating"];
			end
		else
			Line = "-";
		end
	else
		local _, _, _, _, Team = REFlex_ArenaTeamHash(j, false);

		if REFDatabaseA[j][Team .. "TeamRating"] >= 0 then
			if REFDatabaseA[j][Team .. "TeamMMR"] ~= nil then
				Line = REFDatabaseA[j][Team .. "TeamRating"] .. " / " .. REFDatabaseA[j][Team .. "TeamMMR"];
			else
				Line = REFDatabaseA[j][Team .. "TeamRating"];
			end
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

function REFlex_TableWinError(HordeN, AllyN)
	if HordeN > 10 or AllyN > 10 then
		return { 
			["r"] = 0.9,
			["g"] = 0.9,
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

function REFlex_TableTab7Attendance(Attendance)
	local Red = 1 - (Attendance/10*0.1);
	local Green = Attendance/10*0.1;

	return { 
		["r"] = Red,
		["g"] = Green,
		["b"] = 0,
		["a"] = 1.0,
	};
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

function REFlex_ArenaExportSearch(REID)
	if RE.NameSearch ~= nil then
		local REEnemyNames, _, REFriendNames = REFlex_ArenaTeamHash(REID);
		for i=1, #REEnemyNames do
			if REFlex_NameClean(REEnemyNames[i]) == RE.NameSearch then
				return true;
			end
		end
		for i=1, #REFriendNames do
			if REFriendNames[i] == RE.NameSearch then
				return true;
			end
		end
		return false;
	else
		return true;
	end
end

function REFlex_EntryPopup()
	if StaticPopup1["which"] == "CONFIRM_BATTLEFIELD_ENTRY" then
		REFlex_MainTab:Hide();
		REFlex_ExportTab:Hide();
	end
end
-- ***
