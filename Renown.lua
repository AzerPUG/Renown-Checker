local EventFrame = nil

local AZPRenownVersion = 23

local FactionIDs =
{
    [2503] = {Position = 2, Name = "Maruuk Centaur",},
    [2507] = {Position = 1, Name = "Dragonscale Expedition",},
    [2510] = {Position = 4, Name = "Valdrakken Accord",},
    [2511] = {Position = 3, Name = "Iskaara Tuskarr",},
}

function AZPRenownOnLoad()
    EventFrame = CreateFrame("FRAME", nil)
    EventFrame:RegisterEvent("VARIABLES_LOADED")
    EventFrame:RegisterEvent("MAJOR_FACTION_RENOWN_LEVEL_CHANGED")
    EventFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
    EventFrame:SetScript("OnEvent", function(...) AZPRenownOnEvent(...) end)

    ColorPickerOkayButton:HookScript("OnClick", function() AZPRenownColorSave() end)
end


function AZPRenownOnEvent(_, event, ...)
    if event == "MAJOR_FACTION_RENOWN_LEVEL_CHANGED" then
    -- elseif event == "CURRENCY_DISPLAY_UPDATE" then
    --     if ... == 1813 then AZPRenownFrameUpdateValues() end
    elseif event == "VARIABLES_LOADED" then
        if AZPRenownLevels == nil then AZPRenownLevels = {} end
        if AZPRenownLevels.MaxValues == nil then AZPRenownLevels.MaxValues = {} end
        C_Timer.After(1, function() AZPRenownGetFactionLevels() AZPCreateFramesOnExpansionPage() end)
    end
end

function AZPCreateFramesOnExpansionPage()
    local ExpackTest = {ExpansionLandingPage.Overlay:GetChildren()}
    local FactionListFrame = ExpackTest[1].MajorFactionList
    ExpansionLandingPage.AZPRenownFrame = CreateFrame("Frame", nil, ExpansionLandingPage)
    ExpansionLandingPage.AZPRenownFrame:SetSize(60, 450)
    ExpansionLandingPage.AZPRenownFrame:SetPoint("TOPLEFT", FactionListFrame, "TOPRIGHT", -20, 60)
    ExpansionLandingPage.AZPRenownFrame:SetFrameStrata("HIGH")

    ExpansionLandingPage.AZPRenownFrame.HeaderFrame = CreateFrame("Frame", nil, ExpansionLandingPage.AZPRenownFrame)
    ExpansionLandingPage.AZPRenownFrame.HeaderFrame:SetSize(60, 50)
    ExpansionLandingPage.AZPRenownFrame.HeaderFrame:SetPoint("TOP", ExpansionLandingPage.AZPRenownFrame, "TOP", 0, 0)
    ExpansionLandingPage.AZPRenownFrame.HeaderFrame:SetFrameLevel(100)

    ExpansionLandingPage.AZPRenownFrame.HeaderFrame.AccountMax = ExpansionLandingPage.AZPRenownFrame.HeaderFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ExpansionLandingPage.AZPRenownFrame.HeaderFrame.AccountMax:SetPoint("TOP", ExpansionLandingPage.AZPRenownFrame.HeaderFrame, "TOP", 0, -5)
    ExpansionLandingPage.AZPRenownFrame.HeaderFrame.AccountMax:SetText("Max Level")

    ExpansionLandingPage.AZPRenownFrame.HeaderFrame.Percentage = ExpansionLandingPage.AZPRenownFrame.HeaderFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ExpansionLandingPage.AZPRenownFrame.HeaderFrame.Percentage:SetPoint("TOP", ExpansionLandingPage.AZPRenownFrame.HeaderFrame.AccountMax, "BOTTOM", 0, -5)
    ExpansionLandingPage.AZPRenownFrame.HeaderFrame.Percentage:SetText("Rep Rate")

    -- ExpansionLandingPage.AZPRenownFrame.HeaderFrame.Percentage = ExpansionLandingPage.AZPRenownFrame.HeaderFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    -- ExpansionLandingPage.AZPRenownFrame.HeaderFrame.Percentage:SetPoint("TOP", ExpansionLandingPage.AZPRenownFrame.HeaderFrame.Percentage, "BOTTOM", 0, -5)
    -- ExpansionLandingPage.AZPRenownFrame.HeaderFrame.Percentage:SetText("Inventory")

    ExpansionLandingPage.AZPRenownFrame.FactionList = {}

    for i = 1, 4 do
        ExpansionLandingPage.AZPRenownFrame.FactionList[i] = CreateFrame("Frame", nil, ExpansionLandingPage.AZPRenownFrame)
        local curFrame = ExpansionLandingPage.AZPRenownFrame.FactionList[i]
        curFrame:SetSize(60, 88)
        if i == 1 then
            curFrame:SetPoint("TOP", ExpansionLandingPage.AZPRenownFrame.HeaderFrame, "BOTTOM", 0, -12)
        else
            curFrame:SetPoint("TOP", ExpansionLandingPage.AZPRenownFrame.FactionList[i-1], "BOTTOM", 0, -12)
        end
        curFrame:SetFrameLevel(100)

        curFrame.AccountMax = curFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        curFrame.AccountMax:SetPoint("TOP", curFrame, "TOP", 0, -20)
        curFrame.AccountMax:SetText("Max Level")

        curFrame.Percentage = curFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        curFrame.Percentage:SetPoint("TOP", curFrame.AccountMax, "BOTTOM", 0, -10)
        curFrame.Percentage:SetText("Rep Rate")

        -- curFrame.Inventory = curFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        -- curFrame.Inventory:SetPoint("TOP", curFrame.Percentage, "BOTTOM", 0, -10)
        -- curFrame.Inventory:SetText("Inventory")
    end
    AZPRenownAddDataToFrame()
end

function AZPRenownGetFactionLevels()
    local curGUID = UnitGUID("PLAYER")
    AZPRenownLevels[curGUID] =
    {
        [2503] = tonumber(C_MajorFactions.GetMajorFactionData(2503).renownLevel),
        [2507] = tonumber(C_MajorFactions.GetMajorFactionData(2507).renownLevel),
        [2510] = tonumber(C_MajorFactions.GetMajorFactionData(2510).renownLevel),
        [2511] = tonumber(C_MajorFactions.GetMajorFactionData(2511).renownLevel),
    }
end

function AZPRenownGetMaxValues()
    for PlayerGUID, PlayerData in pairs(AZPRenownLevels) do
        if PlayerGUID ~= "MaxValues" then
            for FactionID, FactionLevel in pairs(PlayerData) do
                if AZPRenownLevels.MaxValues[FactionID] == nil then AZPRenownLevels.MaxValues[FactionID] = FactionLevel
                elseif FactionLevel > tonumber(AZPRenownLevels.MaxValues[FactionID]) then
                    AZPRenownLevels.MaxValues[FactionID] = FactionLevel
                end
            end
        end
    end
end

function AZPRenownAddDataToFrame()
    local curGUID = UnitGUID("PLAYER")
    AZPRenownGetMaxValues()

    for FactionID, FactionData in pairs(FactionIDs) do
        local maxLevel = AZPRenownLevels.MaxValues[FactionID]
        local curPercentage = 100

        if maxLevel >= 20 then
            if AZPRenownLevels[curGUID][FactionID] < 10 then curPercentage = 300
            elseif AZPRenownLevels[curGUID][FactionID] < 20 then curPercentage = 200 end
        elseif maxLevel >= 10 then
            if AZPRenownLevels[curGUID][FactionID] < 10 then curPercentage = 200 end
        end

        ExpansionLandingPage.AZPRenownFrame.FactionList[FactionData.Position].AccountMax:SetText(maxLevel)
        ExpansionLandingPage.AZPRenownFrame.FactionList[FactionData.Position].Percentage:SetText(string.format("%d%%", curPercentage))
    end

end

AZPRenownOnLoad()