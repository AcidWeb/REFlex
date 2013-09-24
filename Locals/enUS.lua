local L = {
	["Old"] = true,
	["RECORD"] = true,
	["Date"] = true,
	["Map"] = true,
	["Wins"] = true,
	["Losses"] = true,
	["A Rating"] = true,
	["H Rating"] = true,
	["Rated BGs"] = true,
	["Unrated BGs"] = true,
	["Rated & Unrated BGs"] = true,
	["Total"] = true,
	["Top"] = true,
	["All"] = true,
	["Normal"] = true,
	["Rated"] = true,
	["Statistics"] = true,
	["Both Specs"] = true,
	["Spec 1"] = true,
	["Spec 2"] = true,
	["Show minimap button"] = true,
	["Show main window"] = true,
	["Show MiniBar (Battlegrounds only)"] = true,
	["MiniBar modules"] = true,
	["Bar 1"] = true,
	["Bar 2"] = true,
	["Hide"] = true,
	["Left"] = true,
	["Right"] = true,
	["K/D Ratio"] = true,
	["Honor Kills"] = true,
	["MiniBar scale"] = true
}

REFlexLocale = L
function L:CreateLocaleTable(t)
	for k, v in pairs(t) do
		self[k] = (v == true and k) or v
	end
end

L:CreateLocaleTable(L);
