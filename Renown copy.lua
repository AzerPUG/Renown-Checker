local AZPRenownCompactFrame = nil
local AZPRenownFullFrame = nil

local AZPRenownVersion = 5

local CovenantNames =
{
    [1] =    "Kyrian",
    [2] =   "Venthyr",
    [3] =  "NightFae",
    [4] = "Necrolord",
}

local curFont = {}
local valuesRecentlyUpdated = false

function AZPRenownOnLoad()
    AZPRenownFrame:RegisterEvent("VARIABLES_LOADED")    -- Create Event Frame
    AZPRenownFrame:RegisterEvent("COVENANT_CHOSEN")
    AZPRenownFrame:RegisterEvent("COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED")
    AZPRenownFrame:SetScript("OnEvent", function(...) AZPRenownOnEvent(...) end)
end

function AZPRenownCompactFrame()
    

    AZPRenownFrameMarkActiveFull()
end

function AZPRenownFullFrame()
    

    AZPRenownVars.Size = "Full"

    AZPRenownFrameMarkActiveFull()
end

function AZPRenownFrameSizeToggle()
        if AZPRenownVars.Size == "Full" then AZPRenownVars.Size = "Compact" AZPRenownCompactFrame()
    elseif AZPRenownVars.Size == "Compact" then AZPRenownVars.Size = "Full" AZPRenownFullFrame() end
end

function AZPRenownFrameMarkActiveCompact()
    local curCovID = C_Covenants.GetActiveCovenantID()
    AZPRenownFrame.NightFaeFrame.CGlow1:Hide()
    AZPRenownFrame.NightFaeFrame.CGlow2:Hide()
    AZPRenownFrame.VenthyrFrame.CGlow1:Hide()
    AZPRenownFrame.VenthyrFrame.CGlow2:Hide()
    AZPRenownFrame.NecrolordFrame.CGlow1:Hide()
    AZPRenownFrame.NecrolordFrame.CGlow2:Hide()
    AZPRenownFrame.KyrianFrame.CGlow1:Hide()
    AZPRenownFrame.KyrianFrame.CGlow2:Hide()
    if curCovID == 1 then
        AZPRenownFrame.KyrianFrame.CGlow1:Show()
        AZPRenownFrame.KyrianFrame.CGlow2:Show()
    elseif curCovID == 2 then
        AZPRenownFrame.VenthyrFrame.CGlow1:Show()
        AZPRenownFrame.VenthyrFrame.CGlow2:Show()
    elseif curCovID == 3 then
        AZPRenownFrame.NightFaeFrame.CGlow1:Show()
        AZPRenownFrame.NightFaeFrame.CGlow2:Show()
    elseif curCovID == 4 then
        AZPRenownFrame.NecrolordFrame.CGlow1:Show()
        AZPRenownFrame.NecrolordFrame.CGlow2:Show()
    end
end

function AZPRenownFrameMarkActiveFull()
    local curCovID = C_Covenants.GetActiveCovenantID()
    AZPRenownFrame.NightFaeFrame.FGlow1:Hide()
    AZPRenownFrame.NightFaeFrame.FGlow2:Hide()
    AZPRenownFrame.VenthyrFrame.FGlow1:Hide()
    AZPRenownFrame.VenthyrFrame.FGlow2:Hide()
    AZPRenownFrame.NecrolordFrame.FGlow1:Hide()
    AZPRenownFrame.NecrolordFrame.FGlow2:Hide()
    AZPRenownFrame.KyrianFrame.FGlow1:Hide()
    AZPRenownFrame.KyrianFrame.FGlow2:Hide()
    if curCovID == 1 then
        AZPRenownFrame.KyrianFrame.FGlow1:Show()
        AZPRenownFrame.KyrianFrame.FGlow2:Show()
    elseif curCovID == 2 then
        AZPRenownFrame.VenthyrFrame.FGlow1:Show()
        AZPRenownFrame.VenthyrFrame.FGlow2:Show()
    elseif curCovID == 3 then
        AZPRenownFrame.NightFaeFrame.FGlow1:Show()
        AZPRenownFrame.NightFaeFrame.FGlow2:Show()
    elseif curCovID == 4 then
        AZPRenownFrame.NecrolordFrame.FGlow1:Show()
        AZPRenownFrame.NecrolordFrame.FGlow2:Show()
    end
end

function AZPRenownFrameUpdateValues()
    if valuesRecentlyUpdated == false then
        print("AZPRenownFrameUpdateValues()")
        valuesRecentlyUpdated = true
        C_Timer.After(2, function() valuesRecentlyUpdated = false end)
        C_Timer.After(1,
        function()
            local curCovID = C_Covenants.GetActiveCovenantID()
            if curCovID ~= nil and curCovID ~= 0 then
                local curCovName = CovenantNames[curCovID]
                local curGUID = UnitGUID("PLAYER")
                local curCovLevel = C_CovenantSanctumUI.GetRenownLevel()
                if AZPRenownLevels == nil then AZPRenownLevels = {} end
                if AZPRenownLevels[curGUID] == nil then AZPRenownLevels[curGUID] = {NightFae = 0, Venthyr = 0, Necrolord = 0, Kyrian = 0,} end
                AZPRenownLevels[curGUID][curCovName] = curCovLevel
                AZPRenownSetLevels(curGUID)
                AZPRenownFrameMarkActiveFull()
            end
        end)
    end
end

function AZPRenownOnEvent(_, event, ...)
    if event == "COVENANT_CHOSEN" then
        print("COVENANT_CHOSEN")
        AZPRenownFrameUpdateValues()
    elseif event == "COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED" then
        print("COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED")
        AZPRenownFrameUpdateValues()
    elseif event == "VARIABLES_LOADED" then
        AZPRenownLoadPositionFrame()
        if AZPRenownVars.Size == nil then AZPRenownVars.Size = "Full" end
        if AZPRenownVars.Size == "Full" then AZPRenownFullFrame()
        elseif AZPRenownVars.Size == "Compact" then AZPRenownCompactFrame() end
        AZPRenownFrameUpdateValues()
    end
end

function AZPRenownSetLevels(curGUID)
    AZPRenownCompactFrame. NightFaeFrame.Level:SetText(AZPRenownLevels[curGUID]. NightFae)
    AZPRenownCompactFrame.  VenthyrFrame.Level:SetText(AZPRenownLevels[curGUID].  Venthyr)
    AZPRenownCompactFrame.NecrolordFrame.Level:SetText(AZPRenownLevels[curGUID].Necrolord)
    AZPRenownCompactFrame.   KyrianFrame.Level:SetText(AZPRenownLevels[curGUID].   Kyrian)

    AZPRenownFullFrame. NightFaeFrame.Level:SetText(AZPRenownLevels[curGUID]. NightFae)
    AZPRenownFullFrame.  VenthyrFrame.Level:SetText(AZPRenownLevels[curGUID].  Venthyr)
    AZPRenownFullFrame.NecrolordFrame.Level:SetText(AZPRenownLevels[curGUID].Necrolord)
    AZPRenownFullFrame.   KyrianFrame.Level:SetText(AZPRenownLevels[curGUID].   Kyrian)
end

function AZPRenownLoadPositionFrame()
    if AZPRenownVars == nil then AZPRenownVars = {} AZPRenownVars.Position = {"CENTER", nil, nil, 0, 0} end
    local curPos = AZPRenownVars.Position
    AZPRenownCompactFrame:SetPoint(curPos[1], curPos[2], curPos[3], curPos[4], curPos[5])
    AZPRenownFullFrame:SetPoint(curPos[1], curPos[2], curPos[3], curPos[4], curPos[5])
    if AZPRenownVars.Show == true or AZPRenownVars.Show == nil then AZPRenownFrame:Show() end
end

function AZPRenownSavePositionFrame()
    local v1, v2, v3, v4, v5 = nil, nil, nil, nil, nil
        if AZPRenownVars.Size == "Compact" then v1, v2, v3, v4, v5 = AZPRenownCompactFrame:GetPoint()
    elseif AZPRenownVars.Size == "Full" then v1, v2, v3, v4, v5 = AZPRenownFullFrame:GetPoint() end
    AZPRenownVars.Position = {v1, v2, v3, v4, v5}
end

function AZPRenownShowHideToggle()
    local curFrame = nil
        if AZPRenownVars.Size == "Compact" then curFrame = AZPRenownCompactFrame
    elseif AZPRenownVars.Size == "Full" then curFrame = AZPRenownFullFrame end
    if curFrame:IsShown() == true then curFrame:Hide() curFrame.Show = false
    elseif curFrame:IsShown() == false then curFrame:Show() curFrame.Show = true end
end

AZPRenownOnLoad()

AZP.SlashCommands["RC"] = function()
    AZPRenownShowHideToggle()
end

AZP.SlashCommands["rc"] = AZP.SlashCommands["RC"]
AZP.SlashCommands["renown"] = AZP.SlashCommands["RC"]
AZP.SlashCommands["Renown"] = AZP.SlashCommands["RC"]
AZP.SlashCommands["renown checker"] = AZP.SlashCommands["RC"]
AZP.SlashCommands["Renown Checker"] = AZP.SlashCommands["RC"]