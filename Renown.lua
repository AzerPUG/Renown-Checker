local AZPRenownFrame = nil

local CovenantNames =
{
    [1] =    "Kyrian",
    [2] =   "Venthyr",
    [3] =  "NightFae",
    [4] = "Necrolord",
}

function AZPRenownOnLoad()
    AZPRenownFrame = CreateFrame("FRAME", nil, UIParent, "BackdropTemplate")
    AZPRenownFrame:SetSize(200, 250)
    
    AZPRenownFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZPRenownFrame:SetBackdropColor(0.5, 0.5, 0.5, 0.75)

    AZPRenownFrame:EnableMouse(true)
    AZPRenownFrame:SetMovable(true)
    AZPRenownFrame:RegisterForDrag("LeftButton")
    AZPRenownFrame:SetScript("OnDragStart", AZPRenownFrame.StartMoving)
    AZPRenownFrame:SetScript("OnDragStop", function() AZPRenownFrame:StopMovingOrSizing() AZPRenownSavePositionFrame() end)

    AZPRenownFrame:RegisterEvent("VARIABLES_LOADED")
    AZPRenownFrame:RegisterEvent("COVENANT_CHOSEN")
    AZPRenownFrame:RegisterEvent("COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED")
    AZPRenownFrame:SetScript("OnEvent", function(...) AZPRenownOnEvent(...) end)

    AZPRenownFrame.Header = AZPRenownFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPRenownFrame.Header:SetSize(AZPRenownFrame:GetWidth(), 50)
    AZPRenownFrame.Header:SetPoint("TOP", 0, -5)
    AZPRenownFrame.Header:SetText("AzerPUG's\nRenown Checker")

    AZPRenownFrame.CloseButton = CreateFrame("Button", nil, AZPRenownFrame, "UIPanelCloseButton")
    AZPRenownFrame.CloseButton:SetSize(20, 21)
    AZPRenownFrame.CloseButton:SetPoint("TOPRIGHT", AZPRenownFrame, "TOPRIGHT", 2, 2)
    AZPRenownFrame.CloseButton:SetScript("OnClick", function() AZPRenownFrame:Hide() AZPRenownVars.Show = false end)

    local curWidth, curHeight = 180, 48     -- 482, 126     -- 241, 63

    AZPRenownFrame.NightFaeFrame = CreateFrame("FRAME", nil, AZPRenownFrame)
    AZPRenownFrame.NightFaeFrame:SetSize(curWidth, curHeight)
    AZPRenownFrame.NightFaeFrame:SetPoint("TOP", 0, -50)
    AZPRenownFrame.NightFaeFrame.BG = AZPRenownFrame.NightFaeFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownFrame.NightFaeFrame.BG:SetSize(AZPRenownFrame.NightFaeFrame:GetWidth(), AZPRenownFrame.NightFaeFrame:GetHeight())
    AZPRenownFrame.NightFaeFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownFrame.NightFaeFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownFrame.NightFaeFrame.BG:SetTexture("Interface/Garrison/ShadowlandsLandingPage")
    AZPRenownFrame.NightFaeFrame.BG:SetTexCoord(0.709473, 0.944824, 0.171875, 0.294922)
    AZPRenownFrame.NightFaeFrame.Name = AZPRenownFrame.NightFaeFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPRenownFrame.NightFaeFrame.Name:SetSize(AZPRenownFrame.NightFaeFrame:GetWidth() * 0.75, AZPRenownFrame.NightFaeFrame:GetHeight())
    AZPRenownFrame.NightFaeFrame.Name:SetPoint("LEFT", AZPRenownFrame.NightFaeFrame, "LEFT", 0, -2)
    AZPRenownFrame.NightFaeFrame.Name:SetText("Night Fae")
    AZPRenownFrame.NightFaeFrame.Name:SetJustifyV("CENTER")
    AZPRenownFrame.NightFaeFrame.Level = AZPRenownFrame.NightFaeFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPRenownFrame.NightFaeFrame.Level:SetSize(AZPRenownFrame.NightFaeFrame:GetWidth() * 0.25, AZPRenownFrame.NightFaeFrame:GetHeight())
    AZPRenownFrame.NightFaeFrame.Level:SetPoint("RIGHT", AZPRenownFrame.NightFaeFrame, "RIGHT", -15, -2)
    AZPRenownFrame.NightFaeFrame.Level:SetText("0")
    AZPRenownFrame.NightFaeFrame.Level:SetJustifyV("CENTER")

    AZPRenownFrame.VenthyrFrame = CreateFrame("FRAME", nil, AZPRenownFrame)
    AZPRenownFrame.VenthyrFrame:SetSize(curWidth, curHeight)
    AZPRenownFrame.VenthyrFrame:SetPoint("TOP", AZPRenownFrame.NightFaeFrame, "BOTTOM", 0, 0)
    AZPRenownFrame.VenthyrFrame.BG = AZPRenownFrame.VenthyrFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownFrame.VenthyrFrame.BG:SetSize(AZPRenownFrame.VenthyrFrame:GetWidth(), AZPRenownFrame.VenthyrFrame:GetHeight())
    AZPRenownFrame.VenthyrFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownFrame.VenthyrFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownFrame.VenthyrFrame.BG:SetTexture("Interface/Garrison/ShadowlandsLandingPage")
    AZPRenownFrame.VenthyrFrame.BG:SetTexCoord(0.473145, 0.708496, 0.546875, 0.669922)
    AZPRenownFrame.VenthyrFrame.Name = AZPRenownFrame.VenthyrFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPRenownFrame.VenthyrFrame.Name:SetSize(AZPRenownFrame.VenthyrFrame:GetWidth() * 0.75, AZPRenownFrame.VenthyrFrame:GetHeight())
    AZPRenownFrame.VenthyrFrame.Name:SetPoint("LEFT", AZPRenownFrame.VenthyrFrame, "LEFT", 0, -2)
    AZPRenownFrame.VenthyrFrame.Name:SetText("Venthyr")
    AZPRenownFrame.VenthyrFrame.Level = AZPRenownFrame.VenthyrFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPRenownFrame.VenthyrFrame.Level:SetSize(AZPRenownFrame.VenthyrFrame:GetWidth() * 0.25, AZPRenownFrame.VenthyrFrame:GetHeight())
    AZPRenownFrame.VenthyrFrame.Level:SetPoint("RIGHT", AZPRenownFrame.VenthyrFrame, "RIGHT", -15, -2)
    AZPRenownFrame.VenthyrFrame.Level:SetText("0")

    AZPRenownFrame.NecrolordFrame = CreateFrame("FRAME", nil, AZPRenownFrame)
    AZPRenownFrame.NecrolordFrame:SetSize(curWidth, curHeight)
    AZPRenownFrame.NecrolordFrame:SetPoint("TOP", AZPRenownFrame.VenthyrFrame, "BOTTOM", 0, 0)
    AZPRenownFrame.NecrolordFrame.BG = AZPRenownFrame.NecrolordFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownFrame.NecrolordFrame.BG:SetSize(AZPRenownFrame.NecrolordFrame:GetWidth(), AZPRenownFrame.NecrolordFrame:GetHeight())
    AZPRenownFrame.NecrolordFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownFrame.NecrolordFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownFrame.NecrolordFrame.BG:SetTexture("Interface/Garrison/ShadowlandsLandingPage")
    AZPRenownFrame.NecrolordFrame.BG:SetTexCoord(0.709473, 0.944824, 0.546875, 0.669922)
    AZPRenownFrame.NecrolordFrame.Name = AZPRenownFrame.NecrolordFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPRenownFrame.NecrolordFrame.Name:SetSize(AZPRenownFrame.NecrolordFrame:GetWidth() * 0.75, AZPRenownFrame.NecrolordFrame:GetHeight())
    AZPRenownFrame.NecrolordFrame.Name:SetPoint("LEFT", AZPRenownFrame.NecrolordFrame, "LEFT", 0, -2)
    AZPRenownFrame.NecrolordFrame.Name:SetText("Necrolord")
    AZPRenownFrame.NecrolordFrame.Level = AZPRenownFrame.NecrolordFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPRenownFrame.NecrolordFrame.Level:SetSize(AZPRenownFrame.NecrolordFrame:GetWidth() * 0.25, AZPRenownFrame.NecrolordFrame:GetHeight())
    AZPRenownFrame.NecrolordFrame.Level:SetPoint("RIGHT", AZPRenownFrame.NecrolordFrame, "RIGHT", -15, -2)
    AZPRenownFrame.NecrolordFrame.Level:SetText("0")

    AZPRenownFrame.KyrianFrame = CreateFrame("FRAME", nil, AZPRenownFrame)
    AZPRenownFrame.KyrianFrame:SetSize(curWidth, curHeight)
    AZPRenownFrame.KyrianFrame:SetPoint("TOP", AZPRenownFrame.NecrolordFrame, "BOTTOM", 0, 0)
    AZPRenownFrame.KyrianFrame.BG = AZPRenownFrame.KyrianFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownFrame.KyrianFrame.BG:SetSize(AZPRenownFrame.KyrianFrame:GetWidth(), AZPRenownFrame.KyrianFrame:GetHeight())
    AZPRenownFrame.KyrianFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownFrame.KyrianFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownFrame.KyrianFrame.BG:SetTexture("Interface/Garrison/ShadowlandsLandingPage")
    AZPRenownFrame.KyrianFrame.BG:SetTexCoord(0.236816, 0.472168, 0.296875, 0.419922)
    AZPRenownFrame.KyrianFrame.Name = AZPRenownFrame.KyrianFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPRenownFrame.KyrianFrame.Name:SetSize(AZPRenownFrame.KyrianFrame:GetWidth() * 0.75, AZPRenownFrame.KyrianFrame:GetHeight())
    AZPRenownFrame.KyrianFrame.Name:SetPoint("LEFT", AZPRenownFrame.KyrianFrame, "LEFT", 0, -2)
    AZPRenownFrame.KyrianFrame.Name:SetText("Kyrian")
    AZPRenownFrame.KyrianFrame.Level = AZPRenownFrame.KyrianFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPRenownFrame.KyrianFrame.Level:SetSize(AZPRenownFrame.KyrianFrame:GetWidth() * 0.25, AZPRenownFrame.KyrianFrame:GetHeight())
    AZPRenownFrame.KyrianFrame.Level:SetPoint("RIGHT", AZPRenownFrame.KyrianFrame, "RIGHT", -15, -2)
    AZPRenownFrame.KyrianFrame.Level:SetText("0")

    AZPRenownFrame:Hide()
end

function AZPRenownOnEvent(_, event, ...)
    if event == "COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED" then
        C_Timer.After(1,
        function()
            local curGUID = UnitGUID("PLAYER")
            local curCovID = C_Covenants.GetActiveCovenantID()
            local curCovName = CovenantNames[curCovID]
            local curCovLevel = C_CovenantSanctumUI.GetRenownLevel()
            AZPRenownLevels[curGUID][curCovName] = curCovLevel
            AZPRenownSetLevels(curGUID)
        end)
    elseif event == "VARIABLES_LOADED" then
        AZPRenownLoadPositionFrame()
        C_Timer.After(1,
        function()
            local curCovID = C_Covenants.GetActiveCovenantID()
            local curCovName = CovenantNames[curCovID]
            local curGUID = UnitGUID("PLAYER")
            local curCovLevel = C_CovenantSanctumUI.GetRenownLevel()
            if AZPRenownLevels == nil then AZPRenownLevels = {} end
            if AZPRenownLevels[curGUID] == nil then AZPRenownLevels[curGUID] = {NightFae = 0, Venthyr = 0, Necrolord = 0, Kyrian = 0,} end
            AZPRenownLevels[curGUID][curCovName] = curCovLevel
            AZPRenownSetLevels(curGUID)
        end)
    end
end

function AZPRenownSetLevels(curGUID)
    AZPRenownFrame.NightFaeFrame.Level:SetText(AZPRenownLevels[curGUID].NightFae)
    AZPRenownFrame.VenthyrFrame.Level:SetText(AZPRenownLevels[curGUID].Venthyr)
    AZPRenownFrame.NecrolordFrame.Level:SetText(AZPRenownLevels[curGUID].Necrolord)
    AZPRenownFrame.KyrianFrame.Level:SetText(AZPRenownLevels[curGUID].Kyrian)
end

function AZPRenownLoadPositionFrame()
    if AZPRenownVars == nil then AZPRenownVars = {} AZPRenownVars.Position = {"CENTER", nil, nil, 0, 0} end
    local curPos = AZPRenownVars.Position
    AZPRenownFrame:SetPoint(curPos[1], curPos[2], curPos[3], curPos[4], curPos[5])
    if AZPRenownVars.Show == true or AZPRenownVars.Show == nil then AZPRenownFrame:Show() end
end

function AZPRenownSavePositionFrame()
    local v1, v2, v3, v4, v5 = AZPRenownFrame:GetPoint()
    AZPRenownVars.Position = {v1, v2, v3, v4, v5}
end

function AZPRenownShowHideFrame()
    AZPRenownVars.Show = false
end

function AZPRenownVarsLoaded()

end

AZPRenownOnLoad()

AZP.SlashCommands["RC"] = function()
    AZPRenownFrame:Show()
    AZPRenownVars.Show = true
end

AZP.SlashCommands["rc"] = AZP.SlashCommands["RC"]
AZP.SlashCommands["renown"] = AZP.SlashCommands["RC"]
AZP.SlashCommands["Renown"] = AZP.SlashCommands["RC"]
AZP.SlashCommands["renown checker"] = AZP.SlashCommands["RC"]
AZP.SlashCommands["Renown Checker"] = AZP.SlashCommands["RC"]