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
	["Both Specs"] = true,
	["Spec 1"] = true,
	["Spec 2"] = true,
	["Show minimap button"] = true,
	["Show main window."] = true,
	["Show battleground minibar."] = true,
	["Minibar works only on Battlegrounds."] = true,
	["Show minibar (Battleground only)"] = true
}

REFlexLocale = L
function L:CreateLocaleTable(t)
	for k, v in pairs(t) do
		self[k] = (v == true and k) or v
	end
end

L:CreateLocaleTable(L);
