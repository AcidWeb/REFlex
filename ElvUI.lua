local _G = _G
local unpack = _G.unpack

if not _G.AddOnSkins then return end
local AS = unpack(_G.AddOnSkins)
if not AS:CheckAddOn("REFlex") then return end

function AS:REFlex()
  AS:SkinFrame(_G.REFlexFrame)
  AS:SkinFrame(_G.REFlex.TableBG.frame, nil, true)
  AS:StripTextures(_G[_G.REFlex.TableBG.frame:GetName().."ScrollTrough"], true)
  AS:SkinScrollBar(_G[_G.REFlex.TableBG.frame:GetName().."ScrollFrameScrollBar"])
  AS:SkinFrame(_G.REFlex.TableArena.frame, nil, true)
  AS:StripTextures(_G[_G.REFlex.TableArena.frame:GetName().."ScrollTrough"], true)
  AS:SkinScrollBar(_G[_G.REFlex.TableArena.frame:GetName().."ScrollFrameScrollBar"])
  AS:SkinButton(_G.REFlexFrame_DumpButton)
  AS:SkinButton(_G.REFlexFrame_StatsButton)
  AS:SkinCloseButton(_G.REFlexFrame_CloseButton)
  AS:StripTextures(_G.REFlexFrame_HKBar)
  AS:SkinStatusBar(_G.REFlexFrame_HKBar_I)
  for i = 1, _G.REFlexFrame.numTabs do
    AS:SkinTab(_G["REFlexFrameTab"..i])
  end
  _G.REFlexFrame_Title:SetPoint("TOP", 0, -10)
  _G.REFlexFrame_HKBar:SetPoint("BOTTOM", 0, 18)
end

AS:RegisterSkin("REFlex", AS.REFlex)
