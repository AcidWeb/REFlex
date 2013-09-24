local L = REFlexLocale;
local REScrollingTable = LibStub("ScrollingTable");
local REShefkiTimer = LibStub("LibShefkiTimer-1.0");
SLASH_REFLEX1, SLASH_REFLEX2 = "/ref", "/reflex";

-- *** Event functions

function REFlex_OnLoad(self)
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	self:RegisterEvent("ADDON_LOADED");
	self:RegisterEvent("PVP_RATED_STATS_UPDATE");

	WorldStateScoreFrame:HookScript("OnShow", REFlex_BGEnd);
	WorldStateScoreFrame:HookScript("OnHide", function(self) REFlex_ScoreTab:Hide() end);

	RESecondTime = false;
	RESecondTimeMainTab = false;
	RESecondTimeMiniBar = false;
	RESecondTimeMiniBarTimer = false;
end

function REFlex_OnEvent(self,event,...)
	local REAddonName = ...;
	local _, REZoneType = IsInInstance();
	if event == "UPDATE_BATTLEFIELD_SCORE" then
		if RESecondTimeMiniBarTimer ~= true then
			REFlex_Frame:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE");
			REShefkiTimer:ScheduleTimer(REFlex_MiniBarDelay, 30);
			RESecondTimeMiniBarTimer = true;
		elseif REZoneType ~= "arena" then
			REFlex_UpdateMiniBar();
		end
	elseif event == "PVP_RATED_STATS_UPDATE" then
		RERBG, _, RERBGPointsWeek, RERBGMaxPointsWeek = GetPersonalRatedBGInfo();
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_I:SetMinMaxValues(0, RERBGMaxPointsWeek);
	elseif event == "ZONE_CHANGED_NEW_AREA" and RESecondTime == true then
		RESecondTime = false;
		RESecondTimeMiniBar = false;
		RESecondTimeMiniBarTimer = false;

		REFlex_MiniBar:Hide();

		RequestRatedBattlegroundInfo();
	elseif event == "ZONE_CHANGED_NEW_AREA" and RESecondTimeMiniBarTimer == true then
	        RESecondTimeMiniBarTimer = false;
	elseif event == "ADDON_LOADED" and REAddonName == "REFlex" then
		REFlex_ScoreTab_MsgGuild:SetText(GUILD); 
		REFlex_ScoreTab_MsgParty:SetText(PARTY);
		REFlex_MainTab_MsgGuild:SetText(GUILD); 
		REFlex_MainTab_MsgParty:SetText(PARTY);
		REFlex_MainTabTab1:SetText(L["All"]);
		REFlex_MainTabTab2:SetText(L["Normal"]);
		REFlex_MainTabTab3:SetText(L["Rated"]);
		REFlex_MainTabTab4:SetText(L["Statistics"]);
		REFlex_MainTab_SpecHolderTab1:SetText(L["Both Specs"]);
		REFlex_MainTab_SpecHolderTab2:SetText(L["Spec 1"]);
		REFlex_MainTab_SpecHolderTab3:SetText(L["Spec 2"]);
		REFlex_MainTab_Tab4_ScoreHolderSpecial_CP:SetText("- " .. PVP_CONQUEST .. " -");
		REFlex_MainTab_Tab4_ScoreHolderSpecial_Honor:SetText("- " .. HONOR .. " -");
		BINDING_HEADER_REFLEXB = "REFlex";
		BINDING_NAME_REFLEXSHOW = L["Show main window"];
		REFlex_MainTab_Tab4_Bar_I:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
		REFlex_MainTab_Tab4_Bar_I:SetStatusBarColor(0, 0.9, 0);
		REFlex_MainTab_Tab4_Bar_I:SetMinMaxValues(0, 100000);
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_I:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_I:SetStatusBarColor(0, 0.9, 0);
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarHonor_I:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarHonor_I:SetStatusBarColor(0, 0.9, 0);
		REFlex_MainTab_Tab4_ScoreHolderSpecial_BarHonor_I:SetMinMaxValues(0, 4000);
		UIDropDownMenu_SetWidth(REFlex_MainTab_Tab4_DropDown, 140);
		UIDropDownMenu_SetButtonWidth(REFlex_MainTab_Tab4_DropDown, 200)
		UIDropDownMenu_SetSelectedID(REFlex_MainTab_Tab4_DropDown, 1)
		UIDropDownMenu_JustifyText(REFlex_MainTab_Tab4_DropDown, "LEFT")

		if REFDatabase == nil then
			REFDatabase = {};
		end
		if REFSettings == nil then
			REFSettings = {["MinimapPos"] = 45, ["ShowMinimapButton"] = true, ["ShowMiniBar"] = true};
		end

		RequestRatedBattlegroundInfo();
		REFlex_SettingsReload();

		self:UnregisterEvent("ADDON_LOADED");
	end
end

-- DropDown Menu subsection
function REFlex_DropDownClick(self)
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

function REFlex_DropDownOnLoad(self, level)
	local BGDropMenu = UIDropDownMenu_CreateInfo();
	BGDropMenu.text       = L["Rated & Unrated BGs"];
	BGDropMenu.func       = REFlex_DropDownClick
	UIDropDownMenu_AddButton(BGDropMenu);
	BGDropMenu = UIDropDownMenu_CreateInfo();
	BGDropMenu.text       = L["Unrated BGs"];
	BGDropMenu.func       = REFlex_DropDownClick
	UIDropDownMenu_AddButton(BGDropMenu);
	BGDropMenu = UIDropDownMenu_CreateInfo();
	BGDropMenu.text       = L["Rated BGs"];
	BGDropMenu.func       = REFlex_DropDownClick 
	UIDropDownMenu_AddButton(BGDropMenu);
end
--

-- GUI subsection
function REFlex_GUIOnLoad(REPanel)
	REPanel.name = "REFlex";
	REPanel.okay = REFlex_GUISave;
	InterfaceOptions_AddCategory(REPanel);

	REFlex_GUI_MinimapButtonText:SetText(L["Show minimap button"]);
	REFlex_GUI_MiniBarText:SetText(L["Show minibar (Battlegrounds only)"]);
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

function REFlex_MinimapButtonClick(...)
	local Visible = REFlex_MainTab:IsVisible();

	if Visible ~= 1 then
		REFlex_MainTab:Show();
	else
		REFlex_MainTab:Hide();
	end
end
--

function REFlex_SpecTab(Spec)
	RETalentTab = Spec;

	local Visible1 = REFlex_MainTab_Tab1:IsVisible();
	local Visible2 = REFlex_MainTab_Tab2:IsVisible();
	local Visible3 = REFlex_MainTab_Tab3:IsVisible();
	local Visible4 = REFlex_MainTab_Tab4:IsVisible();

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
		local Visible = REFlex_MiniBar:IsVisible();
		if Visible == 1 then
			REFlex_MiniBar:Hide();
		end
	end
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

function REFlex_Find(FieldName, Rated, TalentSets, Map)
	local Top = 0;
	local Sum = 0;

	if Map == nil then
		if TalentSets ~= nil then
			if Rated then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] and REFDatabase[j]["TalentSet"] == TalentSets then
						Sum = Sum + REFDatabase[j][FieldName];
						if Top < REFDatabase[j][FieldName] then
							Top = REFDatabase[j][FieldName];
						end
					end
				end
			elseif Rated == false then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] == false and REFDatabase[j]["TalentSet"] == TalentSets then 
						Sum = Sum + REFDatabase[j][FieldName];
						if Top < REFDatabase[j][FieldName] then
							Top = REFDatabase[j][FieldName];
						end
					end
				end
			else
				for j=1, #REFDatabase do
					if REFDatabase[j]["TalentSet"] == TalentSets then
						Sum = Sum + REFDatabase[j][FieldName];
						if Top < REFDatabase[j][FieldName] then
							Top = REFDatabase[j][FieldName];
						end
					end
				end
			end
		else
			if Rated then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] then
						Sum = Sum + REFDatabase[j][FieldName];
						if Top < REFDatabase[j][FieldName] then
							Top = REFDatabase[j][FieldName];
						end
					end
				end
			elseif Rated == false then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] == false then 
						Sum = Sum + REFDatabase[j][FieldName];
						if Top < REFDatabase[j][FieldName] then
							Top = REFDatabase[j][FieldName];
						end
					end
				end
			else
				for j=1, #REFDatabase do
					Sum = Sum + REFDatabase[j][FieldName];
					if Top < REFDatabase[j][FieldName] then
						Top = REFDatabase[j][FieldName];
					end
				end
			end
		end
	else
		if TalentSets ~= nil then
			if Rated then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] and REFDatabase[j]["TalentSet"] == TalentSets and REFDatabase[j]["MapName"] == Map then
						Sum = Sum + REFDatabase[j][FieldName];
						if Top < REFDatabase[j][FieldName] then
							Top = REFDatabase[j][FieldName];
						end
					end
				end
			elseif Rated == false then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] == false and REFDatabase[j]["TalentSet"] == TalentSets and REFDatabase[j]["MapName"] == Map then 
						Sum = Sum + REFDatabase[j][FieldName];
						if Top < REFDatabase[j][FieldName] then
							Top = REFDatabase[j][FieldName];
						end
					end
				end
			else
				for j=1, #REFDatabase do
					if REFDatabase[j]["TalentSet"] == TalentSets and REFDatabase[j]["MapName"] == Map then
						Sum = Sum + REFDatabase[j][FieldName];
						if Top < REFDatabase[j][FieldName] then
							Top = REFDatabase[j][FieldName];
						end
					end
				end
			end
		else
			if Rated then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] and REFDatabase[j]["MapName"] == Map then
						Sum = Sum + REFDatabase[j][FieldName];
						if Top < REFDatabase[j][FieldName] then
							Top = REFDatabase[j][FieldName];
						end
					end
				end
			elseif Rated == false then
				for j=1, #REFDatabase do
					if REFDatabase[j]["IsRated"] == false and REFDatabase[j]["MapName"] == Map then 
						Sum = Sum + REFDatabase[j][FieldName];
						if Top < REFDatabase[j][FieldName] then
							Top = REFDatabase[j][FieldName];
						end
					end
				end
			else
				for j=1, #REFDatabase do
					if REFDatabase[j]["MapName"] == Map then
						Sum = Sum + REFDatabase[j][FieldName];
						if Top < REFDatabase[j][FieldName] then
							Top = REFDatabase[j][FieldName];
						end
					end
				end
			end
		end
	end

	return Top, Sum;
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
--

-- Timers subsection
function REFlex_MiniBarDelay()
	REFlex_Frame:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
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
--

-- Table subsection
function REFlex_Tab_DefaultFilter(self, rowdata)
	if RETalentTab ~= nil then
		if rowdata["cols"][10]["value"] == RETalentTab then
			return true;
		else
			return false;
		end
	else
		return true;
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
		REAddidional = " - " .. L["Rated & Unrated BGs"];
	end
	SendChatMessage("[REFlex] " .. L["Wins"] .. ": " .. REWins .. " - " .. L["Losses"] .. ": " .. RELosses .. REAddidional,Channel ,nil ,nil);
	SendChatMessage("<KB> " .. L["Total"] .. ": " .. RESumKB .. " - " .. L["Top"] .. ": " .. RETopKB .. " <HK> " .. L["Total"] .. ": " .. RESumHK .. " - " .. L["Top"] .. ": " .. RETopHK,Channel ,nil ,nil);
	SendChatMessage("<" .. DAMAGE .. "> " .. L["Total"] .. ": " .. REFlex_NumberClean(RESumDamage, 2) .. " - " .. L["Top"] .. ": " .. REFlex_NumberClean(RETopDamage , 2),Channel ,nil ,nil);
	SendChatMessage("<" .. SHOW_COMBAT_HEALING .. "> " .. L["Total"] .. ": " .. REFlex_NumberClean(RESumHealing, 2) .. " - " .. L["Top"] .. ": " .. REFlex_NumberClean(RETopHealing, 2),Channel ,nil ,nil);
end
--

function REFlex_MainTabShow()
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
	if RESecondTimeMainTab == false then
		REMainTable1 = REScrollingTable:CreateST(REDataStructure12, 25, nil, nil, REFlex_MainTab_Tab1_Table)
		ScrollTable1:SetPoint("TOP");
		REMainTable2 = REScrollingTable:CreateST(REDataStructure12, 25, nil, nil, REFlex_MainTab_Tab2_Table)
		ScrollTable2:SetPoint("TOP");
		REMainTable3 = REScrollingTable:CreateST(REDataStructure3, 25, nil, nil, REFlex_MainTab_Tab3_Table)
		ScrollTable3:SetPoint("TOP");
		RESecondTimeMainTab = true;
	end

	RETalentTab = nil;

	PanelTemplates_SetTab(REFlex_MainTab, 1);
	PanelTemplates_SetTab(REFlex_MainTab_SpecHolder, 1);
	REFlex_MainTab_Tab1:Hide();
	REFlex_MainTab_Tab1:Show();
	REFlex_MainTab_Tab2:Hide();
	REFlex_MainTab_Tab3:Hide();
	REFlex_MainTab_Tab4:Hide();
end	

function REFlex_Tab1Show()
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
		RETempCol[10] = {
			["value"] = REFDatabase[j]["TalentSet"]
		}

		local RETempRow = {
			["cols"] = RETempCol
		}

		table.insert(RETableData, RETempRow);
	end

	REMainTable1:SetData(RETableData);
	REMainTable1:SetFilter(REFlex_Tab_DefaultFilter);
	REMainTable1:SortData();

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
			RETempCol[10] = {
				["value"] = REFDatabase[j]["TalentSet"]
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

			local RETempRow = {
				["cols"] = RETempCol
			}

			table.insert(RETableData, RETempRow);
		end
	end

	REMainTable3:SetData(RETableData);
	REMainTable3:SetFilter(REFlex_Tab_DefaultFilter);
	REMainTable3:SortData();

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

function REFlex_Tab4Show()
	REFlex_MainTab_MsgGuild:Hide(); 
	REFlex_MainTab_MsgParty:Hide();
	REFlex_MainTab:SetSize(1070, 502);

	local REhk = GetPVPLifetimeStats();
	local _, REHonor = GetCurrencyInfo(HONOR_CURRENCY);
	local _, RECP = GetCurrencyInfo(CONQUEST_CURRENCY);
	REFlex_MainTab_Tab4_Bar_I:SetValue(REhk);
	REFlex_MainTab_Tab4_Bar_Text:SetText(REhk .. " / 100000");
	REFlex_MainTab_Tab4_ScoreHolderSpecial_BarHonor_I:SetValue(REHonor);
	REFlex_MainTab_Tab4_ScoreHolderSpecial_BarHonor_Text:SetText(REHonor .. " / 4000");
	REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_I:SetValue(RERBGPointsWeek);
	REFlex_MainTab_Tab4_ScoreHolderSpecial_BarCP_Text:SetText(RECP .. " - " .. RERBGPointsWeek .. " / " .. RERBGMaxPointsWeek);

	local REMapsHolder = {};
	for j=1, #REFDatabase do
		local REMapsTester = false;
		for k=1, #REMapsHolder do
			if REMapsHolder[k] == REFDatabase[j]["MapName"] then
				REMapsTester = true;
			end
		end
		if not REMapsTester then
			table.insert(REMapsHolder, REFDatabase[j]["MapName"]);
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

function REFlex_Tab4Hide()
	REFlex_MainTab_MsgGuild:Show(); 
	REFlex_MainTab_MsgParty:Show();
	REFlex_MainTab:SetSize(655, 502);
end

function REFlex_BGEnd()
	local REWinner = GetBattlefieldWinner();
	local _, REZoneType = IsInInstance();
	if REWinner ~= nil and RESecondTime ~= true and REZoneType ~= "arena" then
		REFlex_ScoreTab:Show()

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

		RESecondTime = true;

		print("\n");
		print("\124cFF74D06C[REFlex]\124r \124cFF555555-\124r " .. REMap .. " \124cFF555555-\124r " .. WIN .. ": " .. REWinSidePrint .. " \124cFF555555-\124r " .. REBGMinutes .. ":" .. REBGSeconds);
		print("\124cFFC5F3BCKB:\124r " .. REkillingBlows .. " (" .. REPlaceKB .. "/" .. REBGPlayers .. ") \124cFF555555* \124cFFC5F3BCHK:\124r " .. REhonorKills .. " (" .. REPlaceHK .. "/" .. REBGPlayers .. ") \124cFF555555* \124cFFC5F3BCH:\124r " .. REhonorGained .. " (" .. REPlaceHonor .. "/" .. REBGPlayers .. ")");
		print("\124cFFC5F3BC" .. DAMAGE .. ":\124r " .. REFlex_NumberClean(REdamageDone, 2) .. " (" .. REPlaceDamage .. "/" .. REBGPlayers .. ") \124cFF555555* \124cFFC5F3BC" .. SHOW_COMBAT_HEALING .. ":\124r " .. REFlex_NumberClean(REhealingDone, 2) .. " (" .. REPlaceHealing .. "/" .. REBGPlayers .. ")");
		if REkillingBlows > RETopKB then
			print("\124cFF74D06C" .. string.upper(NEW) .. " " .. string.upper(KILLING_BLOWS) .. " " .. L["RECORD"] ..":\124r " .. REkillingBlows .. " \124cFF555555-\124r ".. L["Old"] .. ": " .. RETopKB);
		end
		if REhonorKills > RETopHK then
			print("\124cFF74D06C" .. string.upper(NEW) .. " " .. string.upper(HONOR .. " " .. KILLS) .. " " .. L["RECORD"] ..":\124r " .. REhonorKills .. " \124cFF555555-\124r ".. L["Old"] .. ": " .. RETopHK);
		end
		if REdamageDone > RETopDamage then
			print("\124cFF74D06C" .. string.upper(NEW) .. " " .. string.upper(DAMAGE) .. " " .. L["RECORD"] ..":\124r " .. REFlex_NumberClean(REdamageDone, 2) .. " \124cFF555555-\124r ".. L["Old"] .. ": " .. REFlex_NumberClean(RETopDamage, 2));
		end
		if REhealingDone > RETopHealing then
			print("\124cFF74D06C" .. string.upper(NEW) .. " " .. string.upper(SHOW_COMBAT_HEALING) .. " " .. L["RECORD"] ..":\124r " .. REFlex_NumberClean(REhealingDone, 2) .. " \124cFF555555-\124r ".. L["Old"] .. ": " .. REFlex_NumberClean(RETopHealing, 2));
		end
		print("\n");

		local REBGData = { MapName=REMap, Damage=REdamageDone, Healing=REhealingDone, KB=REkillingBlows, HK=REhonorKills, Honor=REhonorGained, TalentSet=RETalentGroup, Winner=REWinSide, PlayersNum=REBGPlayers, HordeNum=REHordeNum, AliianceNum=REAllianceNum, DurationMin=REBGMinutes, DurationSec=REBGSeconds, DurationRaw=BGTimeRaw, TimeHo=RETimeHour, TimeMi=RETimeMinute, TimeMo=RETimeMonth, TimeDa=RETimeDay, TimeYe=RETimeYear, TimeRaw=RETimeRaw, IsRated=REBGRated, Rating=REBGRating, RatingChange=REBGRatingChange, HordeRating=REBGHordeRating, AllianceRating=REBGAllyRating, PlaceKB=REPlaceKB, PlaceHK=REPlaceHK, PlaceHonor=REPlaceHonor, PlaceDamage=REPlaceDamage, PlaceHealing=REPlaceHealing, PlaceFactionKB=REPlaceKBF, PlaceFactionHK=REPlaceHKF, PlaceFactionHonor=REPlaceHonorF, PlaceFactionDamage=REPlaceDamageF, PlaceFactionHealing=REPlaceHealingF };
		table.insert(REFDatabase, REBGData);			
	end
end

function REFlex_UpdateMiniBar()
	if RESecondTimeMiniBar ~= true then
		REFlex_MiniBar:Show();
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
	local REMMaxKB, REMMaxHK, REMMaxDamage, REMMaxHealing = 0, 0, 0, 0;
	local _, REMkillingBlows, REMhonorKills, _, _, _, _, _, _, REMdamageDone, REMhealingDone = GetBattlefieldScore(REMPlayerID);

	for j=1, REMBGPlayers do
		if j ~= REMPlayerID then
			local _, killingBlowsTemp, honorKillsTemp, _, _, _, _, _, _, damageDoneTemp, healingDoneTemp = GetBattlefieldScore(j);
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
		end
	end

	local REMKBD = REMkillingBlows - REMMaxKB;
	local REMHKD = REMhonorKills - REMMaxHK;
	local REMDamageD = REMdamageDone - REMMaxDamage;
	local REMHealingD = REMhealingDone - REMMaxHealing;

	if REMKBD > 0 then
		REMKBD = "|cFF00ff00+" .. REMKBD .. "|r"
	elseif REMKBD < 0 then
		REMKBD = "|cFFFF141D" .. REMKBD .. "|r"
	end
	if REMHKD > 0 then
		REMHKD = "|cFF00ff00+" .. REMHKD .. "|r"
	elseif REMHKD < 0 then
		REMHKD = "|cFFFF141D" .. REMHKD .. "|r"
	end
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

	REFlex_MiniBar_KB2:SetText(REMkillingBlows .. " (" .. REMKBD .. ")");
	REFlex_MiniBar_HK2:SetText(REMhonorKills .. " (" .. REMHKD .. ")");
	if REMdamageDone > 1000000 then
		REFlex_MiniBar_Damage2:SetText(REFlex_NumberClean(REMdamageDone, 2) .. " (" .. REMDamageD .. ")");
	else
		REFlex_MiniBar_Damage2:SetText(REFlex_NumberClean(REMdamageDone, 0) .. " (" .. REMDamageD .. ")");
	end
	if REMhealingDone > 1000000 then
		REFlex_MiniBar_Healing2:SetText(REFlex_NumberClean(REMhealingDone, 2) .. " (" .. REMHealingD .. ")");
	else
		REFlex_MiniBar_Healing2:SetText(REFlex_NumberClean(REMhealingDone, 0) .. " (" .. REMHealingD .. ")");
	end
end

function SlashCmdList.REFLEX(msg)
	if msg == "" then
		print("\124cFF74D06C[REFlex]\124r");
		print("/ref main - " .. L["Show main window"])
		print("/ref minibar - " .. L["Show battleground minibar"])
	elseif msg == "main" then
		REFlex_MinimapButtonClick();
	elseif msg == "minibar" then
		local Visible = REFlex_MiniBar:IsVisible();
		local _, REZoneType = IsInInstance();

		if REZoneType == "pvp" then	
			if Visible ~= 1 then
				REFlex_MiniBar:Show();
			else
				REFlex_MiniBar:Hide();
			end
		else
			print(L["Minibar works only on Battlegrounds"])
		end
	end
end
-- ***
