local RE = REFlexNamespace;
local L = REFlexLocale;

-- *** Database and settings patches

function REFlex_Update20()
	for i=1, #REFDatabaseA do
		if REFDatabaseA[i]["Season"] == 14 and REFDatabaseA[i]["Bracket"] == 0 then
			local REGreenTeamSize = table.getn(REFDatabaseA[i]["GreenTeam"]);
			local REGoldTeamSize = table.getn(REFDatabaseA[i]["GoldTeam"]);
			if REGreenTeamSize == REGoldTeamSize then
				REFDatabaseA[i]["Bracket"] = REGreenTeamSize;
			end
		end
	end
end

function REFlex_Update19()
	for i=1, #REFDatabase do
		if REFDatabase[i]["MapInfo"] == "TempleofKotmogu" then
			REFDatabase[i]["SpecialFields"] = {0, 0};
		elseif REFDatabase[i]["MapInfo"] == "STVDiamondMineBG" then
			REFDatabase[i]["SpecialFields"] = {0};
		end
	end
end

function REFlex_Update18()
	for i=1, #REFDatabase do
		if REFDatabase[i]["RBGHordeTeam"] ~= nil then
			for k=1, #REFDatabase[i]["RBGHordeTeam"] do
				if REFDatabase[i]["RBGHordeTeam"][k]["classToken"] == nil then
					REFDatabase[i]["RBGHordeTeam"][k]["classToken"] = "WARRIOR";
				end
			end
		end
		if REFDatabase[i]["RBGAllianceTeam"] ~= nil then
			for k=1, #REFDatabase[i]["RBGAllianceTeam"] do
				if REFDatabase[i]["RBGAllianceTeam"][k]["classToken"] == nil then
					REFDatabase[i]["RBGAllianceTeam"][k]["classToken"] = "WARRIOR";
				end
			end
		end
	end
	for i=1, #REFDatabaseA do
		if REFDatabaseA[i]["GoldTeam"] ~= nil then
			for k=1, #REFDatabaseA[i]["GoldTeam"] do
				if REFDatabaseA[i]["GoldTeam"][k]["classToken"] == nil then
					REFDatabaseA[i]["GoldTeam"][k]["classToken"] = "WARRIOR";
				end	
			end
		end
		if REFDatabaseA[i]["GreenTeam"] ~= nil then
			for k=1, #REFDatabaseA[i]["GreenTeam"] do
				if REFDatabaseA[i]["GreenTeam"][k]["classToken"] == nil then
					REFDatabaseA[i]["GreenTeam"][k]["classToken"] = "WARRIOR";
				end
			end
		end
	end
end

function REFlex_Update17()
	local RETranslationMatrix = {
	["HUNTER"] = {
		["Beast Mastery"] = 253,
		["Marksmanship"] = 254,
		["Survival"] = 255,
		["Tierherrschaft"] = 253,
		["Treffsicherheit"] = 254,
		["\195\156berleben"] = 255,
		["Maitrise des B\195\170tes"] = 253,
		["Pr\195\169cision"] = 254,
		["Survie"] = 255,
		["\236\149\188\236\136\152ˆ˜"] = 253,
		["\236\130\172\234\178\169"] = 254,
		["\236\131\157\236\161\180"] = 255,
		["\208\159\208\190\208\178\208\181\208\187\208\184\209\130\208\181\208\187\209\140 \208\183\208\178\208\181\209\128\208\181\208\185"] = 253,
		["\208\161\209\130\209\128\208\181\208\187\209\140\208\177\208\176"] = 254,
		["\208\146\209\139\208\182\208\184\208\178\208\176\208\189\208\184\208\181"] = 255

	},
	["WARRIOR"] = {
		["Arms"] = 71,
		["Fury"] = 72,
		["Protection"] = 73,
		["Waffen"] = 71,
		["Furor"] = 72,
		["Schutz"] = 73,
		["Armes"] = 71,
		["Furie"] = 72,
		["\235\172\180\234\184\176"] = 71,
		["\235\182\132\235\133\184"] = 72,
		["\235\176\169\236\150\180"] = 73,
		["\208\158\209\128\209\131\208\182\208\184\208\181"] = 71,
		["\208\157\208\181\208\184\209\129\209\130\208\190\208\178\209\129\209\130\208\178\208\190"] = 72,
		["\208\151\208\176\209\137\208\184\209\130\208\176"] = 73,
		["\230\173\166\229\153\168"] = 71,
		["\231\139\130\230\128\146"] = 72,
		["\233\152\178\232\173\183"] = 73

	},
	["PALADIN"] = {
		["Holy"] = 65,
		["Protection"] = 66,
		["Retribution"] = 70,
		["Heilig"] = 65,
		["Schutz"] = 66,
		["Vergeltung"] = 70,
		["Sacr\195\169"] = 65,
		["Vindicte"] = 70,
		["\236\139\160\236\132\177"] = 65,
		["\235\176\169\236\150\180"] = 66,
		["\236\167\149\235\178\140"] = 70,
		["\208\161\208\178\208\181\209\130"] = 65,
		["\208\151\208\176\209\137\208\184\209\130\208\176"] = 66,
		["\208\146\208\190\208\183\208\180\208\176\209\143\208\189\208\184\208\181"] = 70,
		["\231\165\158\232\129\150"] = 65,
		["\233\152\178\232\173\183"] = 66,
		["\230\135\178\230\136\146"] = 70

	},
	["MAGE"] = {
		["Arcane"] = 62,
		["Fire"] = 63,
		["Frost"] = 64,
		["Arkan"] = 62,
		["Feuer"] = 63,
		["Feu"] = 63,
		["Givre"] = 64,
		["\235\185\132\236\160\132"] = 62,
		["\237\153\148\236\151\188"] = 63,
		["\235\131\137\234\184\176"] = 64,
		["\208\162\208\176\208\185\208\189\208\176\209\143 \208\188\208\176\208\179\208\184\209\143"] = 62,
		["\208\158\208\179\208\190\208\189\209\140"] = 63,
		["\208\155\209\145\208\180"] = 64,
		["\231\165\149\230\179\149"] = 62,
		["\231\129\171\231\132\176"] = 63,
		["\229\134\176\233\156\156"] = 64

	},
	["PRIEST"] = {
		["Discipline"] = 256,
		["Holy"] = 257,
		["Shadow"] = 258,
		["Disziplin"] = 256,
		["Heilig"] = 257,
		["Schattenmagie"] = 258,
		["Sacr\195\169"] = 257,
		["Ombre"] = 258,
		["\236\136\152\236\150\145"] = 256,
		["\236\139\160\236\132\177"] = 257,
		["\236\149\148\237\157\145"] = 258,
		["\208\159\208\190\209\129\208\187\209\131\209\136\208\176\208\189\208\184\208\181"] = 256,
		["\208\161\208\178\208\181\209\130"] = 257,
		["\208\162\209\140\208\188\208\176"] = 258,
		["\230\136\146\229\190\139"] = 256,
		["\231\165\158\232\129\150"] = 257,
		["\230\154\151\229\189\177"] = 258

	},
	["WARLOCK"] = {
		["Affliction"] = 265,
		["Demonology"] = 266,
		["Destruction"] = 267,
		["Gebrechen"] = 265,
		["D\195\164monologie"] = 266,
		["Zerst\195\182rung"] = 267,
		["D\195\169monologie"] = 266,
		["\234\179\160\237\134\181"] = 265,
		["\236\149\133\235\167\136"] = 266,
		["\237\140\140\234\180\180"] = 267,
		["\208\154\208\190\208\187\208\180\208\190\208\178\209\129\209\130\208\178\208\190"] = 265,
		["\208\148\208\181\208\188\208\190\208\189\208\190\208\187\208\190\208\179\208\184\209\143"] = 266,
		["\208\160\208\176\208\183\209\128\209\131\209\136\208\181\208\189\208\184\208\181"] = 267,
		["\231\151\155\232\139\166"] = 265,
		["\230\131\161\233\173\148"] = 266,
		["\230\175\128\230\187\133"] = 267
		
	},
	["DEATHKNIGHT"] = {
		["Blood"] = 250,
		["Frost"] = 251,
		["Unholy"] = 252,
		["Blut"] = 250,
		["Unheilig"] = 252,
		["Sang"] = 250,
		["Givre"] = 251,
		["Impie"] = 252,
		["\237\152\136\234\184\176"] = 250,
		["\235\131\137\234\184\176"] = 251,
		["\235\182\128\236\160\149"] = 252,
		["\208\154\209\128\208\190\208\178\209\140"] = 250,
		["\208\155\209\145\208\180"] = 251,
		["\208\157\208\181\209\135\208\181\209\129\209\130\208\184\208\178\208\190\209\129\209\130\209\140"] = 252,
		["\229\134\176\233\156\156"] = 251

	},
	["SHAMAN"] = {
		["Elemental"] = 262,
		["Enhancement"] = 263,
		["Restoration"] = 264,
		["Elementarkampf"] = 262,
		["Verst\195\164rkung"] = 263,
		["Wiederherstellung"] = 264,
		["\195\137l\195\169mentaire"] = 262,
		["Am\195\169lioration"] = 263,
		["Restauration"] = 264,
		["\236\160\149\234\184\176"] = 262,
		["\234\179\160\236\150\145"] = 263,	
		["\237\154\140\235\179\181"] = 264,
		["\208\161\209\130\208\184\209\133\208\184\208\184"] = 262,
		["\208\161\208\190\208\178\208\181\209\128\209\136\208\181\208\189\209\129\209\130\208\178\208\190\208\178\208\176\208\189\208\184\208\181"] = 263,
		["\208\152\209\129\209\134\208\181\208\187\208\181\208\189\208\184\208\181"] = 264,
		["\229\133\131\231\180\160"] = 262,
		["\229\162\158\229\188\183"] = 263,
		["\230\129\162\229\190\169"] = 264
		
	},
	["DRUID"] = {
		["Balance"] = 102,
		["Feral"]  = 103,
		["Restoration"] = 105,
		["Gleichgewicht"] = 102,
		["Wilder Kampf"] = 103,
		["Wiederherstellung"] = 105,
		["\195\137quilibre"] = 102,
		["F\195\169ral"] = 103,
		["Restauration"] = 105,
		["\236\161\176\237\153\148"] = 102,
		["\236\149\188\236\132\177"] = 103,
		["\237\154\140\235\179\181"] = 105,
		["\208\145\208\176\208\187\208\176\208\189\209\129"] = 102,
		["\208\161\208\184\208\187\208\176 \208\151\208\178\208\181\209\128\209\143"] = 103,
		["\208\152\209\129\209\134\208\181\208\187\208\181\208\189\208\184\208\181"] = 105,
		["\229\185\179\232\161\161"] = 102,
		["\233\135\142\230\128\167"] = 103,
		["\230\129\162\229\190\169"] = 105
		
	},
	["ROGUE"] = {
		["Assassination"] = 259,
		["Combat"] = 260,
		["Subtlety"] = 261,
		["Meucheln"] = 259,
		["Kampf"] = 260,
		["T\195\164uschung"] = 261,
		["Assassinat"] = 259,
		["Finesse"] = 261,
		["\236\149\148\236\130\180"] = 259,
		["\236\160\132\237\136\172"] = 260,
		["\236\158\160\237\150\137"] = 261,
		["\208\155\208\184\208\186\208\178\208\184\208\180\208\176\209\134\208\184\209\143"] = 259,
		["\208\145\208\190\208\185"] = 260,
		["\208\161\208\186\209\128\209\139\209\130\208\189\208\190\209\129\209\130\209\140"] = 261,
		["\233\128\163\230\147\138"] = 260
	}
	}

	for i=1, #REFDatabase do
		if REFDatabase[i]["RBGHordeTeam"] ~= nil then
			for k=1, #REFDatabase[i]["RBGHordeTeam"] do
				if REFDatabase[i]["RBGHordeTeam"][k]["Build"] ~= nil then
					if RETranslationMatrix[REFDatabase[i]["RBGHordeTeam"][k]["classToken"]][REFDatabase[i]["RBGHordeTeam"][k]["Build"]] ~= nil then
						REFDatabase[i]["RBGHordeTeam"][k]["Build"] = RETranslationMatrix[REFDatabase[i]["RBGHordeTeam"][k]["classToken"]][REFDatabase[i]["RBGHordeTeam"][k]["Build"]];
					else
						REFDatabase[i]["RBGHordeTeam"][k]["oldBuild"] = REFDatabase[i]["RBGHordeTeam"][k]["Build"];
						REFDatabase[i]["RBGHordeTeam"][k]["Build"] = 0;
					end
				end
			end
		end
		if REFDatabase[i]["RBGAllianceTeam"] ~= nil then
			for k=1, #REFDatabase[i]["RBGAllianceTeam"] do
				if REFDatabase[i]["RBGAllianceTeam"][k]["Build"] ~= nil then
					if RETranslationMatrix[REFDatabase[i]["RBGAllianceTeam"][k]["classToken"]][REFDatabase[i]["RBGAllianceTeam"][k]["Build"]] ~= nil then
						REFDatabase[i]["RBGAllianceTeam"][k]["Build"] = RETranslationMatrix[REFDatabase[i]["RBGAllianceTeam"][k]["classToken"]][REFDatabase[i]["RBGAllianceTeam"][k]["Build"]];
					else
						REFDatabase[i]["RBGAllianceTeam"][k]["oldBuild"] = REFDatabase[i]["RBGAllianceTeam"][k]["Build"];
						REFDatabase[i]["RBGAllianceTeam"][k]["Build"] = 0;
					end
				end
			end
		end
		
		REFDatabase[i]["DurationSec"] = nil;
		REFDatabase[i]["DurationMin"] = nil;
		REFDatabase[i]["TimeDa"] = nil;
		REFDatabase[i]["TimeMo"] = nil;
		REFDatabase[i]["TimeHo"] = nil;
		REFDatabase[i]["TimeMi"] = nil;
		REFDatabase[i]["TimeYe"] = nil;
		REFDatabase[i]["PlayersNum"] = nil;
		REFDatabase[i]["AllianceNum"] = REFDatabase[i]["AliianceNum"];
		REFDatabase[i]["AliianceNum"] = nil;
	end
	for i=1, #REFDatabaseA do
		if REFDatabaseA[i]["GoldTeam"] ~= nil then
			for k=1, #REFDatabaseA[i]["GoldTeam"] do
				if REFDatabaseA[i]["GoldTeam"][k]["Build"] ~= nil then
					if RETranslationMatrix[REFDatabaseA[i]["GoldTeam"][k]["ClassToken"]][REFDatabaseA[i]["GoldTeam"][k]["Build"]] ~= nil then
						REFDatabaseA[i]["GoldTeam"][k]["Build"] = RETranslationMatrix[REFDatabaseA[i]["GoldTeam"][k]["ClassToken"]][REFDatabaseA[i]["GoldTeam"][k]["Build"]];
					else
						REFDatabaseA[i]["GoldTeam"][k]["oldBuild"] = REFDatabaseA[i]["GoldTeam"][k]["Build"];
						REFDatabaseA[i]["GoldTeam"][k]["Build"] = 0;
					end
				end
				
				REFDatabaseA[i]["GoldTeam"][k]["classToken"] = REFDatabaseA[i]["GoldTeam"][k]["ClassToken"];
				REFDatabaseA[i]["GoldTeam"][k]["ClassToken"] = nil;
			end
		end
		if REFDatabaseA[i]["GreenTeam"] ~= nil then
			for k=1, #REFDatabaseA[i]["GreenTeam"] do
				if REFDatabaseA[i]["GreenTeam"][k]["Build"] ~= nil then
					if RETranslationMatrix[REFDatabaseA[i]["GreenTeam"][k]["ClassToken"]][REFDatabaseA[i]["GreenTeam"][k]["Build"]] ~= nil then
						REFDatabaseA[i]["GreenTeam"][k]["Build"] = RETranslationMatrix[REFDatabaseA[i]["GreenTeam"][k]["ClassToken"]][REFDatabaseA[i]["GreenTeam"][k]["Build"]];
					else
						REFDatabaseA[i]["GreenTeam"][k]["oldBuild"] = REFDatabaseA[i]["GreenTeam"][k]["Build"];
						REFDatabaseA[i]["GreenTeam"][k]["Build"] = 0;
					end
				end
				
				REFDatabaseA[i]["GreenTeam"][k]["classToken"] = REFDatabaseA[i]["GreenTeam"][k]["ClassToken"];
				REFDatabaseA[i]["GreenTeam"][k]["ClassToken"] = nil;
			end
		end
			
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