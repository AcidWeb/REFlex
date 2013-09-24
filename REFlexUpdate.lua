local RE = REFlexNamespace;
local L = REFlexLocale;

-- *** Database and settings patches

function REFlex_Update17()
	for i=1, #REFDatabase do
		REFDatabase[i]["DurationSec"] = nil;
		REFDatabase[i]["DurationMin"] = nil;
		REFDatabase[i]["TimeDa"] = nil;
		REFDatabase[i]["TimeMo"] = nil;
		REFDatabase[i]["TimeHo"] = nil;
		REFDatabase[i]["TimeMi"] = nil;
		REFDatabase[i]["TimeYe"] = nil;
		REFDatabase[i]["PlayersNum"] = nil;
	end
	for i=1, #REFDatabaseA do
		REFDatabaseA[i]["DurationSec"] = nil;
		REFDatabaseA[i]["DurationMin"] = nil;
		REFDatabaseA[i]["TimeDa"] = nil;
		REFDatabaseA[i]["TimeMo"] = nil;
		REFDatabaseA[i]["TimeHo"] = nil;
		REFDatabaseA[i]["TimeMi"] = nil;
		REFDatabaseA[i]["TimeYe"] = nil;
	end
end

function REFlex_Update16()
	for i=1, #REFDatabase do
		if REFDatabase[i]["RBGHordeTeam"] ~= nil then
			for k=1, #REFDatabase[i]["RBGHordeTeam"] do
				REFDatabase[i]["RBGHordeTeam"][k]["class"] = nil;
			end
		end
		if REFDatabase[i]["RBGAllianceTeam"] ~= nil then
			for k=1, #REFDatabase[i]["RBGAllianceTeam"] do
				REFDatabase[i]["RBGAllianceTeam"][k]["class"] = nil;
			end
		end
	end
	for i=1, #REFDatabaseA do
		if REFDatabaseA[i]["GreenTeam"] ~= nil then
			for k=1, #REFDatabaseA[i]["GreenTeam"] do
				REFDatabaseA[i]["GreenTeam"][k]["Class"] = nil;
			end
		end
		if REFDatabaseA[i]["GoldTeam"] ~= nil then
			for k=1, #REFDatabaseA[i]["GoldTeam"] do
				REFDatabaseA[i]["GoldTeam"][k]["Class"] = nil;
			end
		end
	end
	REFSettings["RBGListFirstTime"] = true;
end

function REFlex_Update15()
	local RETempLocalClasses, RELocalClasses = {}, {};
	FillLocalizedClassList(RETempLocalClasses, false)
	for token, localizedName in pairs(RETempLocalClasses) do
		RELocalClasses[localizedName] = token;
	end
	RETempLocalClasses = {};
	FillLocalizedClassList(RETempLocalClasses, true)
	for token, localizedName in pairs(RETempLocalClasses) do
		RELocalClasses[localizedName] = token;
	end

	for i=1, #REFDatabase do
		if REFDatabase[i]["IsRated"] == true and REFDatabase[i]["RBGAllianceTeam"] ~= nil then
			for k=1, #REFDatabase[i]["RBGAllianceTeam"] do
				REFDatabase[i]["RBGAllianceTeam"][k]["classToken"] = RELocalClasses[REFDatabase[i]["RBGAllianceTeam"][k]["class"]];
			end
		end
	end
end

function REFlex_Update14()
	REFSettings["AllowQuery"] = true;
end

function REFlex_Update13()
	for i=1, #REFDatabase do
		if REFDatabase[i]["Season"] == 0 then
			REFDatabase[i]["Season"] = 10;
		end
	end
	for i=1, #REFDatabaseA do
		if REFDatabaseA[i]["Season"] == 0 then
			REFDatabaseA[i]["Season"] = 10;
		end
	end
end

function REFlex_Update1112()
	REFSettings["OnlyNew"] = false;
end

function REFlex_Update10()
	if REFSettings["CurrentMMR"] == nil then
		REFSettings["CurrentMMR"] = 0;
	end
	if REFSettings["LastDayStats"]["MMR"] == nil then
		REFSettings["LastDayStats"]["MMR"] = 0;
	end
	REFSettings["CurrentMMRBG"] = 0;
	REFSettings["LastDayStats"]["MMRBG"] = 0;
end

function REFlex_Update89()
	REFSettings["CurrentMMR"] = 0;
	REFSettings["LastDayStats"]["MMR"] = 0;
	for i=1, #REFDatabase do
		for k=1, #REFDatabase[i]["SpecialFields"] do
			local REFixTemp = REFDatabase[i]["SpecialFields"][k][1];
			REFDatabase[i]["SpecialFields"][k] = REFixTemp;
		end
	end
end

function REFlex_Update7()
	REFSettings["LDBShowPlace"] = false;
	REFSettings["LDBShowQueues"] = true;
	REFSettings["LDBShowTotalBG"] = false;
	REFSettings["LDBShowTotalArena"] = false;
end

function REFlex_Update6()
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
	REFSettings["LastDayStats"] = {["Honor"] = 0, ["CP"] = 0, ["2v2"] = 0, ["3v3"] = 0, ["5v5"] = 0, ["RBG"] = 0, ["MMR"] = 0, ["MMRBG"] = 0};
end

function REFlex_UpdateOld()
	REFSettings["ShowDetectedBuilds"] = true;
	REFSettings["ArenasListFirstTime"] = true;
	REFSettings["ArenaSupport"] = true;
	REFSettings["RBGSupport"] = true;
	REFSettings["UNBGSupport"] = true;
	REFSettings["MiniBarAnchor"] = "CENTER";
	REFSettings["MiniBarScale"] = 1;
	for i=1, #REFDatabase do
		if REFDatabase[i]["SpecialFields"] == nil then
			REFDatabase[i]["DataVersion"] = RE.DataVersion;
			REFDatabase[i]["SpecialFields"] = {};
		end
	end
end

-- ***
