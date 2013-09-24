local L = {
	["Old"] = true,
	["RECORD"] = true,
	["Total"] = true,
	["Top"] = true,
	["Place"] = true,
	
	["Date"] = true,
	["Map"] = true,
	["A Rating"] = true,
	["H Rating"] = true,
	["Rated BGs"] = true,
	["Unrated BGs"] = true,
	["Rated"] = true,

	["Most common compositions"] = true,
	["Easiest compositions"] = true,
	["Hardest compositions"] = true,
	
	["Both Specs"] = true,
	["Spec 1"] = true,
	["Spec 2"] = true,
	
	["Arena support"] = true,
	["Rated battlegrounds support"] = true,
	["Unrated battlegrounds support"] = true,
	["Show minimap button"] = true,
	["Show main window"] = true,
	["Show MiniBar (Battlegrounds only)"] = true,
	["Show LDB MiniBar (Battlegrounds only)"] = true,
	["Show amount of CPs to cap"] = true,
	["Show Honorable Kills"] = true,
	["Show Battleground totals"] = true,
	["Show Arena totals"] = true,
	["Show place instead difference of score"] = true,
	["Show queues"] = true,
	["Show detected builds"] = true,
	["MiniBar modules"] = true,
	["Bar 1"] = true,
	["Bar 2"] = true,
	["Left"] = true,
	["Right"] = true,
	["K/D Ratio"] = true,
	["Honor Kills"] = true,
	["MiniBar scale"] = true,

	["Hold SHIFT key when browsing arena matches to see extended tooltips."] = true,
	["Are you sure you want to delete this entry?"] = true,
	["Reloaded MiniBar settings"] = true,
	["New version released!"] = true,
	["Issue command second time to confirm database wipe"] = true,

	["Arms"] = true,
	["Fury"] = true,
	["Protection"] = true,
	["Retribution"] = true,
	["Assassination"] = true,
	["Combat"] = true,
	["Subtlety"] = true,
	["Discipline"] = true,
	["Holy"] = true,
	["Shadow"] = true,
	["Blood"] = true,
	["Unholy"] = true,
	["Arcane"] = true,
	["Fire"] = true,
	["Frost"] = true,
	["Affliction"] = true,
	["Demonology"] = true,
	["Destruction"] = true,
	["Elemental"] = true,
	["Enhancement"] = true,
	["Restoration"] = true,
	["Beast Mastery"] = true,
	["Marksmanship"] = true,
	["Survival"] = true,
	["Balance"] = true,
	["Feral"]  = true
}

REFlexLocale = L
function L:CreateLocaleTable(t)
	for k, v in pairs(t) do
		self[k] = (v == true and k) or v
	end
end

L:CreateLocaleTable(L);
