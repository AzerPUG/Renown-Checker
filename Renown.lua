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
    AZPRenownFrame:SetPoint("CENTER", 0, 0)
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
    AZPRenownFrame:SetScript("OnDragStop", function() AZPRenownFrame:StopMovingOrSizing() end)

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
    AZPRenownFrame.CloseButton:SetScript("OnClick", function() AZPRenownFrame:Hide() end)

    --AZPRenownFullFrame()
    AZPRenownCompactFrame()
end

function AZPRenownCompactFrame()
    AZPRenownFrame:SetSize(170, 105)

    local curWidth, curHeight = 50, 50

    AZPRenownFrame.NightFaeFrame = CreateFrame("FRAME", nil, AZPRenownFrame)
    AZPRenownFrame.NightFaeFrame:SetSize(curWidth, curHeight)
    AZPRenownFrame.NightFaeFrame:SetPoint("TOP", -60, -50)
    AZPRenownFrame.NightFaeFrame.BG = AZPRenownFrame.NightFaeFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownFrame.NightFaeFrame.BG:SetSize(40, 40)
    AZPRenownFrame.NightFaeFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownFrame.NightFaeFrame.BG:SetTexture("Interface/CovenantChoice/CovenantChoiceCelebration")
    AZPRenownFrame.NightFaeFrame.BG:SetTexCoord(0.75, 0.827148, 0.695312, 0.851562)
    AZPRenownFrame.NightFaeFrame.Level = AZPRenownFrame.NightFaeFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPRenownFrame.NightFaeFrame.Level:SetSize(AZPRenownFrame.NightFaeFrame:GetWidth(), AZPRenownFrame.NightFaeFrame:GetHeight())
    AZPRenownFrame.NightFaeFrame.Level:SetPoint("CENTER", 1, -1)
    AZPRenownFrame.NightFaeFrame.Level:SetText("0")
    AZPRenownFrame.NightFaeFrame.Level:SetJustifyV("CENTER")
    AZPRenownFrame.NightFaeFrame.Level:SetTextColor(1, 1, 1, 1)

    AZPRenownFrame.VenthyrFrame = CreateFrame("FRAME", nil, AZPRenownFrame)
    AZPRenownFrame.VenthyrFrame:SetSize(curWidth, curHeight)
    AZPRenownFrame.VenthyrFrame:SetPoint("TOP", -17, -50)
    AZPRenownFrame.VenthyrFrame.BG = AZPRenownFrame.VenthyrFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownFrame.VenthyrFrame.BG:SetSize(34, 45)
    AZPRenownFrame.VenthyrFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownFrame.VenthyrFrame.BG:SetTexture("Interface/CovenantChoice/CovenantChoiceCelebration")
    AZPRenownFrame.VenthyrFrame.BG:SetTexCoord(0.829102, 0.895508, 0.695312, 0.871094)
    AZPRenownFrame.VenthyrFrame.Level = AZPRenownFrame.VenthyrFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPRenownFrame.VenthyrFrame.Level:SetSize(AZPRenownFrame.VenthyrFrame:GetWidth(), AZPRenownFrame.VenthyrFrame:GetHeight())
    AZPRenownFrame.VenthyrFrame.Level:SetPoint("CENTER", 1, -1)
    AZPRenownFrame.VenthyrFrame.Level:SetText("0")
    AZPRenownFrame.VenthyrFrame.Level:SetJustifyV("CENTER")
    AZPRenownFrame.VenthyrFrame.Level:SetTextColor(1, 1, 1, 1)

    AZPRenownFrame.NecrolordFrame = CreateFrame("FRAME", nil, AZPRenownFrame)
    AZPRenownFrame.NecrolordFrame:SetSize(curWidth, curHeight)
    AZPRenownFrame.NecrolordFrame:SetPoint("TOP", 20, -50)
    AZPRenownFrame.NecrolordFrame.BG = AZPRenownFrame.NecrolordFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownFrame.NecrolordFrame.BG:SetSize(38, 47)
    AZPRenownFrame.NecrolordFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownFrame.NecrolordFrame.BG:SetTexture("Interface/CovenantChoice/CovenantChoiceCelebration")
    AZPRenownFrame.NecrolordFrame.BG:SetTexCoord(0.672852, 0.748047, 0.695312, 0.880859)
    AZPRenownFrame.NecrolordFrame.Level = AZPRenownFrame.NecrolordFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPRenownFrame.NecrolordFrame.Level:SetSize(AZPRenownFrame.NecrolordFrame:GetWidth(), AZPRenownFrame.NecrolordFrame:GetHeight())
    AZPRenownFrame.NecrolordFrame.Level:SetPoint("CENTER", 0, -1)
    AZPRenownFrame.NecrolordFrame.Level:SetText("0")
    AZPRenownFrame.NecrolordFrame.Level:SetJustifyV("CENTER")
    AZPRenownFrame.NecrolordFrame.Level:SetTextColor(1, 1, 1, 1)

    AZPRenownFrame.KyrianFrame = CreateFrame("FRAME", nil, AZPRenownFrame)
    AZPRenownFrame.KyrianFrame:SetSize(curWidth, curHeight)
    AZPRenownFrame.KyrianFrame:SetPoint("TOP", 60, -50)
    AZPRenownFrame.KyrianFrame.BG = AZPRenownFrame.KyrianFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownFrame.KyrianFrame.BG:SetSize(31, 46)
    AZPRenownFrame.KyrianFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownFrame.KyrianFrame.BG:SetTexture("Interface/CovenantChoice/CovenantChoiceCelebration")
    AZPRenownFrame.KyrianFrame.BG:SetTexCoord(0.897461, 0.955078, 0.695312, 0.876953)
    AZPRenownFrame.KyrianFrame.Level = AZPRenownFrame.KyrianFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPRenownFrame.KyrianFrame.Level:SetSize(AZPRenownFrame.KyrianFrame:GetWidth(), AZPRenownFrame.KyrianFrame:GetHeight())
    AZPRenownFrame.KyrianFrame.Level:SetPoint("CENTER", 0, -1)
    AZPRenownFrame.KyrianFrame.Level:SetText("0")
    AZPRenownFrame.KyrianFrame.Level:SetJustifyV("CENTER")
    AZPRenownFrame.KyrianFrame.Level:SetTextColor(1, 1, 1, 1)
end

function AZPRenownFullFrame()
    AZPRenownFrame:SetSize(200, 250)

    local curWidth, curHeight = 180, 48

    AZPRenownFrame.NightFaeFrame = CreateFrame("FRAME", nil, AZPRenownFrame)
    AZPRenownFrame.NightFaeFrame:SetSize(curWidth, curHeight)
    AZPRenownFrame.NightFaeFrame:SetPoint("TOP", 0, -50)
    AZPRenownFrame.NightFaeFrame.BG = AZPRenownFrame.NightFaeFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownFrame.NightFaeFrame.BG:SetSize(AZPRenownFrame.NightFaeFrame:GetWidth(), AZPRenownFrame.NightFaeFrame:GetHeight())
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
end

function AZPRenownOnEvent(_, event, ...)
    if event == "COVENANT_CHOSEN" then
        local curCovID = ...
        local curCovName = CovenantNames[curCovID]
        local curGUID = UnitGUID("PLAYER")
        local curCovLevel = C_CovenantSanctumUI.GetRenownLevel()
        AZPRenownLevels[curGUID][curCovName] = curCovLevel
        AZPRenownSetLevels(curGUID)
    elseif event == "COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED" then
        local curCovLevel = ...
        local curGUID = UnitGUID("PLAYER")
        local curCovID = C_Covenants.GetActiveCovenantID()
        local curCovName = CovenantNames[curCovID]
        AZPRenownLevels[curGUID][curCovName] = curCovLevel
        AZPRenownSetLevels(curGUID)
    elseif event == "VARIABLES_LOADED" then
        local curCovID = C_Covenants.GetActiveCovenantID()
        local curCovName = CovenantNames[curCovID]
        local curGUID = UnitGUID("PLAYER")
        local curCovLevel = C_CovenantSanctumUI.GetRenownLevel()
        if AZPRenownLevels == nil then AZPRenownLevels = {} end
        if AZPRenownLevels[curGUID] == nil then AZPRenownLevels[curGUID] = {NightFae = 0, Venthyr = 0, Necrolord = 0, Kyrian = 0,} end
        AZPRenownLevels[curGUID][curCovName] = curCovLevel
        AZPRenownSetLevels(curGUID)
    end
end

function AZPRenownSetLevels(curGUID)
    AZPRenownFrame.NightFaeFrame.Level:SetText(AZPRenownLevels[curGUID].NightFae)
    AZPRenownFrame.VenthyrFrame.Level:SetText(AZPRenownLevels[curGUID].Venthyr)
    AZPRenownFrame.NecrolordFrame.Level:SetText(AZPRenownLevels[curGUID].Necrolord)
    AZPRenownFrame.KyrianFrame.Level:SetText(AZPRenownLevels[curGUID].Kyrian)
end

AZPRenownOnLoad()

AZP.SlashCommands["RC"] = function()
    AZPRenownFrame:Show()
end

AZP.SlashCommands["rc"] = AZP.SlashCommands["RC"]
AZP.SlashCommands["renown"] = AZP.SlashCommands["RC"]
AZP.SlashCommands["Renown"] = AZP.SlashCommands["RC"]
AZP.SlashCommands["renown checker"] = AZP.SlashCommands["RC"]
AZP.SlashCommands["Renown Checker"] = AZP.SlashCommands["RC"]