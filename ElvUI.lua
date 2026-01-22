local _, RE = ...

if ElvUI then
  local E = unpack(ElvUI)
  local S = E:GetModule("Skins")

  function RE:SkinTooltip(tt)
    S:HandleFrame(tt)
  end

  local function Skin_REFlex()
    S:HandleFrame(REFlexFrame)
    S:HandleFrame(REFlex.TableBG.frame, nil, true)
    _G[REFlex.TableBG.frame:GetName().."ScrollTrough"]:StripTextures()
    S:HandleScrollBar(_G[REFlex.TableBG.frame:GetName().."ScrollFrameScrollBar"])
    S:HandleFrame(REFlex.TableArena.frame, nil, true)
    _G[REFlex.TableArena.frame:GetName().."ScrollTrough"]:StripTextures()
    S:HandleScrollBar(_G[REFlex.TableArena.frame:GetName().."ScrollFrameScrollBar"])
    S:HandleButton(REFlexFrame_DumpButton)
    S:HandleButton(REFlexFrame_StatsButton)
    S:HandleCloseButton(REFlexFrame_CloseButton)
    REFlexFrame_HKBar:StripTextures()
    S:HandleStatusBar(REFlexFrame_HKBar_I)
    for i = 1, REFlexFrame.numTabs do
      S:HandleTab(_G["REFlexFrameTab"..i])
    end
    REFlexFrame_Title:SetPoint("TOP", 0, -10)
    REFlexFrame_HKBar:SetPoint("BOTTOM", 0, 18)
  end

  S:AddCallbackForAddon("REFlex", "REFlex", Skin_REFlex)
else
  function RE:SkinTooltip(tt) end
end