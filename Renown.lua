local AZPRenownCompactFrame, AZPRenownFullFrame, AZPRenownAltFrame = nil, nil, nil
local EventFrame, OptionsFrame = nil, nil

local AZPRenownVersion = 10

local CovenantNames =
{
    [1] =    "Kyrian",
    [2] =   "Venthyr",
    [3] =  "NightFae",
    [4] = "Necrolord",
}

local curFont = {}
local valuesRecentlyUpdated = false
local AZPRenownSizes = {Full = {Width = 200, Height = 250}, Compact = {Width = 200, Height = 125}}
local ColorPickerFrameInUse = nil

function AZPRenownOnLoad()
    EventFrame = CreateFrame("FRAME", nil)
    EventFrame:RegisterEvent("VARIABLES_LOADED")
    EventFrame:RegisterEvent("COVENANT_CHOSEN")
    EventFrame:RegisterEvent("COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED")
    EventFrame:SetScript("OnEvent", function(...) AZPRenownOnEvent(...) end)

    OptionsFrame = CreateFrame("FRAME", nil, UIParent, "BackdropTemplate")
    OptionsFrame:SetSize(300, 125)
    OptionsFrame:SetPoint("CENTER", 0, 0)
    OptionsFrame:EnableMouse(true)
    OptionsFrame:SetMovable(true)
    OptionsFrame:RegisterForDrag("LeftButton")
    OptionsFrame:SetScript("OnDragStart", OptionsFrame.StartMoving)
    OptionsFrame:SetScript("OnDragStop", function() OptionsFrame:StopMovingOrSizing() AZPRenownSavePositionFrame() end)
    OptionsFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    OptionsFrame:SetBackdropColor(0.5, 0.5, 0.5, 0.75)

    OptionsFrame.Header = OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    OptionsFrame.Header:SetSize(OptionsFrame:GetWidth(), 25)
    OptionsFrame.Header:SetPoint("TOP", 0, -5)
    OptionsFrame.Header:SetText(string.format("AzerPUG's Renown Checker v%s", AZPRenownVersion))

    OptionsFrame.SubHeader = OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    OptionsFrame.SubHeader:SetSize(OptionsFrame:GetWidth(), 16)
    OptionsFrame.SubHeader:SetPoint("TOP", OptionsFrame.Header, "BOTTOM", 0, 0)
    OptionsFrame.SubHeader:SetText("Options Panel")

    OptionsFrame.CloseButton = CreateFrame("Button", nil, OptionsFrame, "UIPanelCloseButton")
    OptionsFrame.CloseButton:SetSize(20, 21)
    OptionsFrame.CloseButton:SetPoint("TOPRIGHT", OptionsFrame, "TOPRIGHT", 2, 2)
    OptionsFrame.CloseButton:SetScript("OnClick", function() OptionsFrame:Hide() end)

    OptionsFrame.BorderColorButton = CreateFrame("Button", nil, OptionsFrame, "UIPanelButtonTemplate")
    OptionsFrame.BorderColorButton:SetSize(75, 20)
    OptionsFrame.BorderColorButton:SetPoint("BOTTOM", 0, 10)
    OptionsFrame.BorderColorButton:SetText("Border Color")
    OptionsFrame.BorderColorButton:SetScript("OnClick", function() ColorPickerMain({AZPRenownCompactFrame, AZPRenownFullFrame}, "Border") end)

    OptionsFrame.BGColorButton = CreateFrame("Button", nil, OptionsFrame, "UIPanelButtonTemplate")
    OptionsFrame.BGColorButton:SetSize(75, 20)
    OptionsFrame.BGColorButton:SetPoint("RIGHT", OptionsFrame.BorderColorButton, "LEFT", -5, 0)
    OptionsFrame.BGColorButton:SetText("BG Color")
    OptionsFrame.BGColorButton:SetScript("OnClick", function() ColorPickerMain({AZPRenownCompactFrame, AZPRenownFullFrame}, "BG") end)

    OptionsFrame.ChangeSizeButton = CreateFrame("Button", nil, OptionsFrame, "UIPanelButtonTemplate")
    OptionsFrame.ChangeSizeButton:SetSize(75, 20)
    OptionsFrame.ChangeSizeButton:SetPoint("BOTTOM", OptionsFrame.BGColorButton, "TOP", 0, 10)
    OptionsFrame.ChangeSizeButton:SetScript("OnClick", function() AZPRenownFrameSizeToggle() end)

    OptionsFrame.TextColorButton = CreateFrame("Button", nil, OptionsFrame, "UIPanelButtonTemplate")
    OptionsFrame.TextColorButton:SetSize(75, 20)
    OptionsFrame.TextColorButton:SetPoint("LEFT", OptionsFrame.BorderColorButton, "RIGHT", 5, 0)
    OptionsFrame.TextColorButton:SetText("Text Color")
    OptionsFrame.TextColorButton:SetScript("OnClick",
    function()
        ColorPickerMain(
        {
            AZPRenownCompactFrame.Header,
            AZPRenownCompactFrame.NightFaeFrame.Level,
            AZPRenownCompactFrame.VenthyrFrame.Level,
            AZPRenownCompactFrame.NecrolordFrame.Level,
            AZPRenownCompactFrame.KyrianFrame.Level,
            AZPRenownFullFrame.Header,
            AZPRenownFullFrame.NightFaeFrame.Level,
            AZPRenownFullFrame.NightFaeFrame.Name,
            AZPRenownFullFrame.VenthyrFrame.Level,
            AZPRenownFullFrame.VenthyrFrame.Name,
            AZPRenownFullFrame.NecrolordFrame.Level,
            AZPRenownFullFrame.NecrolordFrame.Name,
            AZPRenownFullFrame.KyrianFrame.Level,
            AZPRenownFullFrame.KyrianFrame.Name,
        }, "Text")
    end)

    OptionsFrame.AltFrameButton = CreateFrame("Button", nil, OptionsFrame, "UIPanelButtonTemplate")
    OptionsFrame.AltFrameButton:SetSize(75, 20)
    OptionsFrame.AltFrameButton:SetPoint("BOTTOM", OptionsFrame.TextColorButton, "TOP", 0, 10)
    OptionsFrame.AltFrameButton:SetScript("OnClick", function() AZPRenownAltFrame:Show() end)
    OptionsFrame.AltFrameButton:SetText("Show AltFrame")

    OptionsFrame:Hide()

    ColorPickerOkayButton:HookScript("OnClick", function() AZPRenownColorSave() end)

    AZPRenownCreateCompactFrame()
    AZPRenownCreateFullFrame()
end

function AZPRenownCreateCompactFrame()
    AZPRenownCompactFrame = CreateFrame("FRAME", nil, UIParent, "BackdropTemplate")
    AZPRenownCompactFrame:SetSize(AZPRenownSizes.Compact.Width, AZPRenownSizes.Compact.Height)
    AZPRenownCompactFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZPRenownCompactFrame:SetBackdropColor(0.5, 0.5, 0.5, 0.75)

    AZPRenownCompactFrame:EnableMouse(true)
    AZPRenownCompactFrame:SetMovable(true)
    AZPRenownCompactFrame:RegisterForDrag("LeftButton")
    AZPRenownCompactFrame:SetScript("OnDragStart", AZPRenownCompactFrame.StartMoving)
    AZPRenownCompactFrame:SetScript("OnDragStop", function() AZPRenownCompactFrame:StopMovingOrSizing() AZPRenownSavePositionFrame() end)

    AZPRenownCompactFrame.Header = AZPRenownCompactFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPRenownCompactFrame.Header:SetSize(AZPRenownCompactFrame:GetWidth(), 50)
    AZPRenownCompactFrame.Header:SetPoint("TOP", 0, -5)
    AZPRenownCompactFrame.Header:SetText(string.format("AzerPUG's\nRenown Checker v%s", AZPRenownVersion))

    AZPRenownCompactFrame.OpenOptionPanelButton = CreateFrame("Frame", nil, AZPRenownCompactFrame)
    AZPRenownCompactFrame.OpenOptionPanelButton:SetSize(15, 15)
    AZPRenownCompactFrame.OpenOptionPanelButton:SetPoint("TOPLEFT", AZPRenownCompactFrame, "TOPLEFT", 3, -3)
    AZPRenownCompactFrame.OpenOptionPanelButton:SetScript("OnMouseDown", function() OptionsFrame:Show() end)
    AZPRenownCompactFrame.OpenOptionPanelButton.Texture = AZPRenownCompactFrame.OpenOptionPanelButton:CreateTexture(nil, "ARTWORK")
    AZPRenownCompactFrame.OpenOptionPanelButton.Texture:SetSize(AZPRenownCompactFrame.OpenOptionPanelButton:GetWidth(), AZPRenownCompactFrame.OpenOptionPanelButton:GetHeight())
    AZPRenownCompactFrame.OpenOptionPanelButton.Texture:SetPoint("CENTER", 0, 0)
    AZPRenownCompactFrame.OpenOptionPanelButton.Texture:SetTexture("Interface/BUTTONS/UI-OptionsButton")

    AZPRenownCompactFrame.CloseButton = CreateFrame("Button", nil, AZPRenownCompactFrame, "UIPanelCloseButton")
    AZPRenownCompactFrame.CloseButton:SetSize(20, 21)
    AZPRenownCompactFrame.CloseButton:SetPoint("TOPRIGHT", AZPRenownCompactFrame, "TOPRIGHT", 2, 2)
    AZPRenownCompactFrame.CloseButton:SetScript("OnClick", function() AZPRenownShowHideToggle() end)

    local curWidth, curHeight = 75, 75

    AZPRenownCompactFrame.NightFaeFrame = CreateFrame("FRAME", nil, AZPRenownCompactFrame)
    AZPRenownCompactFrame.NightFaeFrame:SetSize(curWidth, curHeight)
    AZPRenownCompactFrame.NightFaeFrame:SetPoint("TOP", -75, -50)

    AZPRenownCompactFrame.NightFaeFrame.BG = AZPRenownCompactFrame.NightFaeFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownCompactFrame.NightFaeFrame.BG:SetSize(curWidth, curHeight)
    AZPRenownCompactFrame.NightFaeFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownCompactFrame.NightFaeFrame.BG:SetAtlas("shadowlands-landingbutton-NightFae-up")

    AZPRenownCompactFrame.NightFaeFrame.Level = AZPRenownCompactFrame.NightFaeFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPRenownCompactFrame.NightFaeFrame.Level:SetSize(AZPRenownCompactFrame.NightFaeFrame:GetWidth(), AZPRenownCompactFrame.NightFaeFrame:GetHeight())
    AZPRenownCompactFrame.NightFaeFrame.Level:SetPoint("CENTER", 0, -1)
    AZPRenownCompactFrame.NightFaeFrame.Level:SetText("0")
    AZPRenownCompactFrame.NightFaeFrame.Level:SetJustifyV("CENTER")
    AZPRenownCompactFrame.NightFaeFrame.Level:SetTextColor(1, 1, 1, 1)

    AZPRenownCompactFrame.NightFaeFrame.Glow = AZPRenownCompactFrame.NightFaeFrame:CreateTexture(nil, "ARTWORK")
    AZPRenownCompactFrame.NightFaeFrame.Glow:SetSize(curWidth + 15, curHeight + 15)
    AZPRenownCompactFrame.NightFaeFrame.Glow:SetPoint("CENTER", 0, 0)
    AZPRenownCompactFrame.NightFaeFrame.Glow:SetAtlas("shadowlands-landingbutton-NightFae-highlight")
    AZPRenownCompactFrame.NightFaeFrame.Glow:SetBlendMode("ADD")
    AZPRenownCompactFrame.NightFaeFrame.Glow:SetDesaturated(true)
    AZPRenownCompactFrame.NightFaeFrame.Glow:SetVertexColor(0, 1, 1)

    AZPRenownCompactFrame.NightFaeFrame.Glow2 = AZPRenownCompactFrame.NightFaeFrame:CreateTexture(nil, "ARTWORK")
    AZPRenownCompactFrame.NightFaeFrame.Glow2:SetSize(curWidth + 15, curHeight + 15)
    AZPRenownCompactFrame.NightFaeFrame.Glow2:SetPoint("CENTER", 0, 0)
    AZPRenownCompactFrame.NightFaeFrame.Glow2:SetAtlas("shadowlands-landingbutton-NightFae-highlight")
    AZPRenownCompactFrame.NightFaeFrame.Glow2:SetBlendMode("ADD")
    AZPRenownCompactFrame.NightFaeFrame.Glow2:SetDesaturated(true)
    AZPRenownCompactFrame.NightFaeFrame.Glow2:SetVertexColor(0, 0.5, 1)

    AZPRenownCompactFrame.VenthyrFrame = CreateFrame("FRAME", nil, AZPRenownCompactFrame)
    AZPRenownCompactFrame.VenthyrFrame:SetSize(curWidth, curHeight)
    AZPRenownCompactFrame.VenthyrFrame:SetPoint("TOP", -25, -50)

    AZPRenownCompactFrame.VenthyrFrame.BG = AZPRenownCompactFrame.VenthyrFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownCompactFrame.VenthyrFrame.BG:SetSize(curWidth, curHeight)
    AZPRenownCompactFrame.VenthyrFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownCompactFrame.VenthyrFrame.BG:SetAtlas("shadowlands-landingbutton-venthyr-up")

    AZPRenownCompactFrame.VenthyrFrame.Level = AZPRenownCompactFrame.VenthyrFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPRenownCompactFrame.VenthyrFrame.Level:SetSize(AZPRenownCompactFrame.VenthyrFrame:GetWidth(), AZPRenownCompactFrame.VenthyrFrame:GetHeight())
    AZPRenownCompactFrame.VenthyrFrame.Level:SetPoint("CENTER", 0, -1)
    AZPRenownCompactFrame.VenthyrFrame.Level:SetText("0")
    AZPRenownCompactFrame.VenthyrFrame.Level:SetJustifyV("CENTER")
    AZPRenownCompactFrame.VenthyrFrame.Level:SetTextColor(1, 1, 1, 1)

    AZPRenownCompactFrame.VenthyrFrame.Glow = AZPRenownCompactFrame.VenthyrFrame:CreateTexture(nil, "ARTWORK")
    AZPRenownCompactFrame.VenthyrFrame.Glow:SetSize(curWidth + 5, curHeight + 5)
    AZPRenownCompactFrame.VenthyrFrame.Glow:SetPoint("CENTER", 0, 0)
    AZPRenownCompactFrame.VenthyrFrame.Glow:SetAtlas("shadowlands-landingbutton-venthyr-highlight")
    AZPRenownCompactFrame.VenthyrFrame.Glow:SetBlendMode("add")
    AZPRenownCompactFrame.VenthyrFrame.Glow:SetDesaturated(true)
    AZPRenownCompactFrame.VenthyrFrame.Glow:SetVertexColor(1, 0, 0)

    AZPRenownCompactFrame.VenthyrFrame.Glow2 = AZPRenownCompactFrame.VenthyrFrame:CreateTexture(nil, "ARTWORK")
    AZPRenownCompactFrame.VenthyrFrame.Glow2:SetSize(curWidth + 5, curHeight + 5)
    AZPRenownCompactFrame.VenthyrFrame.Glow2:SetPoint("CENTER", 0, 0)
    AZPRenownCompactFrame.VenthyrFrame.Glow2:SetAtlas("shadowlands-landingbutton-venthyr-highlight")
    AZPRenownCompactFrame.VenthyrFrame.Glow2:SetBlendMode("add")
    AZPRenownCompactFrame.VenthyrFrame.Glow2:SetDesaturated(true)
    AZPRenownCompactFrame.VenthyrFrame.Glow2:SetVertexColor(1, 0, 0)

    AZPRenownCompactFrame.NecrolordFrame = CreateFrame("FRAME", nil, AZPRenownCompactFrame)
    AZPRenownCompactFrame.NecrolordFrame:SetSize(curWidth, curHeight)
    AZPRenownCompactFrame.NecrolordFrame:SetPoint("TOP", 25, -50)

    AZPRenownCompactFrame.NecrolordFrame.BG = AZPRenownCompactFrame.NecrolordFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownCompactFrame.NecrolordFrame.BG:SetSize(curWidth, curHeight)
    AZPRenownCompactFrame.NecrolordFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownCompactFrame.NecrolordFrame.BG:SetAtlas("shadowlands-landingbutton-necrolord-up")

    AZPRenownCompactFrame.NecrolordFrame.Level = AZPRenownCompactFrame.NecrolordFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPRenownCompactFrame.NecrolordFrame.Level:SetSize(AZPRenownCompactFrame.NecrolordFrame:GetWidth(), AZPRenownCompactFrame.NecrolordFrame:GetHeight())
    AZPRenownCompactFrame.NecrolordFrame.Level:SetPoint("CENTER", -1, -1)
    AZPRenownCompactFrame.NecrolordFrame.Level:SetText("0")
    AZPRenownCompactFrame.NecrolordFrame.Level:SetJustifyV("CENTER")
    AZPRenownCompactFrame.NecrolordFrame.Level:SetTextColor(1, 1, 1, 1)

    AZPRenownCompactFrame.NecrolordFrame.Glow = AZPRenownCompactFrame.NecrolordFrame:CreateTexture(nil, "ARTWORK")
    AZPRenownCompactFrame.NecrolordFrame.Glow:SetSize(curWidth + 5, curHeight + 5)
    AZPRenownCompactFrame.NecrolordFrame.Glow:SetPoint("CENTER", 0, 0)
    AZPRenownCompactFrame.NecrolordFrame.Glow:SetAtlas("shadowlands-landingbutton-necrolord-highlight")
    AZPRenownCompactFrame.NecrolordFrame.Glow:SetBlendMode("add")
    AZPRenownCompactFrame.NecrolordFrame.Glow:SetDesaturated(true)
    AZPRenownCompactFrame.NecrolordFrame.Glow:SetVertexColor(0, 0.5, 0)

    AZPRenownCompactFrame.NecrolordFrame.Glow2 = AZPRenownCompactFrame.NecrolordFrame:CreateTexture(nil, "ARTWORK")
    AZPRenownCompactFrame.NecrolordFrame.Glow2:SetSize(curWidth + 5, curHeight + 5)
    AZPRenownCompactFrame.NecrolordFrame.Glow2:SetPoint("CENTER", 0, 0)
    AZPRenownCompactFrame.NecrolordFrame.Glow2:SetAtlas("shadowlands-landingbutton-necrolord-highlight")
    AZPRenownCompactFrame.NecrolordFrame.Glow2:SetBlendMode("add")
    AZPRenownCompactFrame.NecrolordFrame.Glow2:SetDesaturated(true)
    AZPRenownCompactFrame.NecrolordFrame.Glow2:SetVertexColor(0, 0.5, 0)

    AZPRenownCompactFrame.KyrianFrame = CreateFrame("FRAME", nil, AZPRenownCompactFrame)
    AZPRenownCompactFrame.KyrianFrame:SetSize(curWidth, curHeight)
    AZPRenownCompactFrame.KyrianFrame:SetPoint("TOP", 75, -50)

    AZPRenownCompactFrame.KyrianFrame.BG = AZPRenownCompactFrame.KyrianFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownCompactFrame.KyrianFrame.BG:SetSize(curWidth, curHeight)
    AZPRenownCompactFrame.KyrianFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownCompactFrame.KyrianFrame.BG:SetAtlas("shadowlands-landingbutton-kyrian-up")

    AZPRenownCompactFrame.KyrianFrame.Level = AZPRenownCompactFrame.KyrianFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPRenownCompactFrame.KyrianFrame.Level:SetSize(AZPRenownCompactFrame.KyrianFrame:GetWidth(), AZPRenownCompactFrame.KyrianFrame:GetHeight())
    AZPRenownCompactFrame.KyrianFrame.Level:SetPoint("CENTER", 1, -1)
    AZPRenownCompactFrame.KyrianFrame.Level:SetText("0")
    AZPRenownCompactFrame.KyrianFrame.Level:SetJustifyV("CENTER")
    AZPRenownCompactFrame.KyrianFrame.Level:SetTextColor(1, 1, 1, 1)

    AZPRenownCompactFrame.KyrianFrame.Glow = AZPRenownCompactFrame.KyrianFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownCompactFrame.KyrianFrame.Glow:SetSize(curWidth + 10, curHeight + 10)
    AZPRenownCompactFrame.KyrianFrame.Glow:SetPoint("CENTER", 0, 0)
    AZPRenownCompactFrame.KyrianFrame.Glow:SetAtlas("shadowlands-landingbutton-kyrian-highlight")
    AZPRenownCompactFrame.KyrianFrame.Glow:SetBlendMode("add")
    AZPRenownCompactFrame.KyrianFrame.Glow:SetDesaturated(true)
    AZPRenownCompactFrame.KyrianFrame.Glow:SetVertexColor(1, 1, 1)

    AZPRenownCompactFrame.KyrianFrame.Glow2 = AZPRenownCompactFrame.KyrianFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownCompactFrame.KyrianFrame.Glow2:SetSize(curWidth + 10, curHeight + 10)
    AZPRenownCompactFrame.KyrianFrame.Glow2:SetPoint("CENTER", 0, 0)
    AZPRenownCompactFrame.KyrianFrame.Glow2:SetAtlas("shadowlands-landingbutton-kyrian-highlight")
    AZPRenownCompactFrame.KyrianFrame.Glow2:SetBlendMode("add")
    AZPRenownCompactFrame.KyrianFrame.Glow2:SetDesaturated(true)
    AZPRenownCompactFrame.KyrianFrame.Glow2:SetVertexColor(1, 1, 1)

    local font, size, other = AZPRenownCompactFrame.NightFaeFrame.Level:GetFont()
    curFont = {font, size, other}
    AZPRenownCompactFrame. NightFaeFrame.Level:SetFont(curFont[1], curFont[2], curFont[3])
    AZPRenownCompactFrame.  VenthyrFrame.Level:SetFont(curFont[1], curFont[2], curFont[3])
    AZPRenownCompactFrame.NecrolordFrame.Level:SetFont(curFont[1], curFont[2], curFont[3])
    AZPRenownCompactFrame.   KyrianFrame.Level:SetFont(curFont[1], curFont[2], curFont[3])

    AZPRenownCompactFrame:Hide()
end

function AZPRenownCreateFullFrame()
    AZPRenownFullFrame = CreateFrame("FRAME", nil, UIParent, "BackdropTemplate")
    AZPRenownFullFrame:SetSize(AZPRenownSizes.Full.Width, AZPRenownSizes.Full.Height)
    AZPRenownFullFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZPRenownFullFrame:SetBackdropColor(0.5, 0.5, 0.5, 0.75)

    AZPRenownFullFrame:EnableMouse(true)
    AZPRenownFullFrame:SetMovable(true)
    AZPRenownFullFrame:RegisterForDrag("LeftButton")
    AZPRenownFullFrame:SetScript("OnDragStart", AZPRenownFullFrame.StartMoving)
    AZPRenownFullFrame:SetScript("OnDragStop", function() AZPRenownFullFrame:StopMovingOrSizing() AZPRenownSavePositionFrame() end)

    AZPRenownFullFrame.Header = AZPRenownFullFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPRenownFullFrame.Header:SetSize(AZPRenownFullFrame:GetWidth(), 50)
    AZPRenownFullFrame.Header:SetPoint("TOP", 0, -5)
    AZPRenownFullFrame.Header:SetText(string.format("AzerPUG's\nRenown Checker v%s", AZPRenownVersion))

    AZPRenownFullFrame.OpenOptionPanelButton = CreateFrame("Frame", nil, AZPRenownFullFrame)
    AZPRenownFullFrame.OpenOptionPanelButton:SetSize(15, 15)
    AZPRenownFullFrame.OpenOptionPanelButton:SetPoint("TOPLEFT", AZPRenownFullFrame, "TOPLEFT", 3, -3)
    AZPRenownFullFrame.OpenOptionPanelButton:SetScript("OnMouseDown", function() OptionsFrame:Show() end)
    AZPRenownFullFrame.OpenOptionPanelButton.Texture = AZPRenownFullFrame.OpenOptionPanelButton:CreateTexture(nil, "ARTWORK")
    AZPRenownFullFrame.OpenOptionPanelButton.Texture:SetSize(AZPRenownFullFrame.OpenOptionPanelButton:GetWidth(), AZPRenownFullFrame.OpenOptionPanelButton:GetHeight())
    AZPRenownFullFrame.OpenOptionPanelButton.Texture:SetPoint("CENTER", 0, 0)
    AZPRenownFullFrame.OpenOptionPanelButton.Texture:SetTexture("Interface/BUTTONS/UI-OptionsButton")

    AZPRenownFullFrame.CloseButton = CreateFrame("Button", nil, AZPRenownFullFrame, "UIPanelCloseButton")
    AZPRenownFullFrame.CloseButton:SetSize(20, 21)
    AZPRenownFullFrame.CloseButton:SetPoint("TOPRIGHT", AZPRenownFullFrame, "TOPRIGHT", 2, 2)
    AZPRenownFullFrame.CloseButton:SetScript("OnClick", function() AZPRenownShowHideToggle() end)

    local curWidth, curHeight = 180, 48

    AZPRenownFullFrame.NightFaeFrame = CreateFrame("FRAME", nil, AZPRenownFullFrame)
    AZPRenownFullFrame.NightFaeFrame:SetSize(curWidth, curHeight)
    AZPRenownFullFrame.NightFaeFrame:SetPoint("TOP", 0, -50)
    AZPRenownFullFrame.NightFaeFrame.BG = AZPRenownFullFrame. NightFaeFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownFullFrame.NightFaeFrame.BG:SetSize(AZPRenownFullFrame.NightFaeFrame:GetWidth(), AZPRenownFullFrame.NightFaeFrame:GetHeight())
    AZPRenownFullFrame.NightFaeFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownFullFrame.NightFaeFrame.BG:SetAtlas("shadowlands-landingpage-renownbutton-nightfae")

    AZPRenownFullFrame.NightFaeFrame.Name = AZPRenownFullFrame. NightFaeFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPRenownFullFrame.NightFaeFrame.Name:SetSize(AZPRenownFullFrame.NightFaeFrame:GetWidth() * 0.75, AZPRenownFullFrame.NightFaeFrame:GetHeight())
    AZPRenownFullFrame.NightFaeFrame.Name:SetPoint("LEFT", AZPRenownFullFrame.NightFaeFrame, "LEFT", 0, -2)
    AZPRenownFullFrame.NightFaeFrame.Name:SetText("Night Fae")
    AZPRenownFullFrame.NightFaeFrame.Name:SetJustifyV("CENTER")

    AZPRenownFullFrame.NightFaeFrame.Level = AZPRenownFullFrame.NightFaeFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPRenownFullFrame.NightFaeFrame.Level:SetSize(AZPRenownFullFrame.NightFaeFrame:GetWidth() * 0.25, AZPRenownFullFrame.NightFaeFrame:GetHeight())
    AZPRenownFullFrame.NightFaeFrame.Level:SetPoint("CENTER", AZPRenownFullFrame.NightFaeFrame, "CENTER", 52, -2)
    AZPRenownFullFrame.NightFaeFrame.Level:SetText("0")
    AZPRenownFullFrame.NightFaeFrame.Level:SetJustifyV("CENTER")
    AZPRenownFullFrame.NightFaeFrame.Level:SetTextColor(1, 1, 1, 1)

    AZPRenownFullFrame.NightFaeFrame.Glow = AZPRenownFullFrame.NightFaeFrame:CreateTexture(nil, "ARTWORK")
    AZPRenownFullFrame.NightFaeFrame.Glow:SetSize(curWidth, curHeight)
    AZPRenownFullFrame.NightFaeFrame.Glow:SetPoint("CENTER", 0, 0)
    AZPRenownFullFrame.NightFaeFrame.Glow:SetAtlas("shadowlands-landingpage-soulbindsbutton-highlight")
    AZPRenownFullFrame.NightFaeFrame.Glow:SetBlendMode("ADD")

    AZPRenownFullFrame.NightFaeFrame.Glow2 = AZPRenownFullFrame.NightFaeFrame:CreateTexture(nil, "ARTWORK")
    AZPRenownFullFrame.NightFaeFrame.Glow2:SetSize(curWidth, curHeight)
    AZPRenownFullFrame.NightFaeFrame.Glow2:SetPoint("CENTER", 0, 0)
    AZPRenownFullFrame.NightFaeFrame.Glow2:SetAtlas("shadowlands-landingpage-soulbindsbutton-highlight")
    AZPRenownFullFrame.NightFaeFrame.Glow2:SetBlendMode("ADD")

    AZPRenownFullFrame.VenthyrFrame = CreateFrame("FRAME", nil, AZPRenownFullFrame)
    AZPRenownFullFrame.VenthyrFrame:SetSize(curWidth, curHeight)
    AZPRenownFullFrame.VenthyrFrame:SetPoint("TOP", AZPRenownFullFrame.NightFaeFrame, "BOTTOM", 0, 0)

    AZPRenownFullFrame.VenthyrFrame.BG = AZPRenownFullFrame. VenthyrFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownFullFrame.VenthyrFrame.BG:SetSize(AZPRenownFullFrame.VenthyrFrame:GetWidth(), AZPRenownFullFrame.VenthyrFrame:GetHeight())
    AZPRenownFullFrame.VenthyrFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownFullFrame.VenthyrFrame.BG:SetAtlas("shadowlands-landingpage-renownbutton-venthyr")

    AZPRenownFullFrame.VenthyrFrame.Name = AZPRenownFullFrame. VenthyrFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPRenownFullFrame.VenthyrFrame.Name:SetSize(AZPRenownFullFrame.VenthyrFrame:GetWidth() * 0.75, AZPRenownFullFrame.VenthyrFrame:GetHeight())
    AZPRenownFullFrame.VenthyrFrame.Name:SetPoint("LEFT", AZPRenownFullFrame.VenthyrFrame, "LEFT", 0, -3)
    AZPRenownFullFrame.VenthyrFrame.Name:SetText("Venthyr")
    AZPRenownFullFrame.VenthyrFrame.Name:SetJustifyV("CENTER")

    AZPRenownFullFrame.VenthyrFrame.Level = AZPRenownFullFrame.VenthyrFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPRenownFullFrame.VenthyrFrame.Level:SetSize(AZPRenownFullFrame.VenthyrFrame:GetWidth() * 0.25, AZPRenownFullFrame.VenthyrFrame:GetHeight())
    AZPRenownFullFrame.VenthyrFrame.Level:SetPoint("CENTER", AZPRenownFullFrame.VenthyrFrame, "CENTER", 52, -2)
    AZPRenownFullFrame.VenthyrFrame.Level:SetText("0")
    AZPRenownFullFrame.VenthyrFrame.Level:SetJustifyV("CENTER")
    AZPRenownFullFrame.VenthyrFrame.Level:SetTextColor(1, 1, 1, 1)

    AZPRenownFullFrame.VenthyrFrame.Glow = AZPRenownFullFrame.VenthyrFrame:CreateTexture(nil, "ARTWORK")
    AZPRenownFullFrame.VenthyrFrame.Glow:SetSize(curWidth, curHeight)
    AZPRenownFullFrame.VenthyrFrame.Glow:SetPoint("CENTER", 0, 0)
    AZPRenownFullFrame.VenthyrFrame.Glow:SetAtlas("shadowlands-landingpage-soulbindsbutton-highlight")
    AZPRenownFullFrame.VenthyrFrame.Glow:SetBlendMode("ADD")

    AZPRenownFullFrame.VenthyrFrame.Glow2 = AZPRenownFullFrame.VenthyrFrame:CreateTexture(nil, "ARTWORK")
    AZPRenownFullFrame.VenthyrFrame.Glow2:SetSize(curWidth, curHeight)
    AZPRenownFullFrame.VenthyrFrame.Glow2:SetPoint("CENTER", 0, 0)
    AZPRenownFullFrame.VenthyrFrame.Glow2:SetAtlas("shadowlands-landingpage-soulbindsbutton-highlight")
    AZPRenownFullFrame.VenthyrFrame.Glow2:SetBlendMode("ADD")

    AZPRenownFullFrame.NecrolordFrame = CreateFrame("FRAME", nil, AZPRenownFullFrame)
    AZPRenownFullFrame.NecrolordFrame:SetSize(curWidth, curHeight)
    AZPRenownFullFrame.NecrolordFrame:SetPoint("TOP", AZPRenownFullFrame.VenthyrFrame, "BOTTOM", 0, 0)

    AZPRenownFullFrame.NecrolordFrame.BG = AZPRenownFullFrame. NecrolordFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownFullFrame.NecrolordFrame.BG:SetSize(AZPRenownFullFrame.NecrolordFrame:GetWidth(), AZPRenownFullFrame.NecrolordFrame:GetHeight())
    AZPRenownFullFrame.NecrolordFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownFullFrame.NecrolordFrame.BG:SetAtlas("shadowlands-landingpage-renownbutton-necrolord")

    AZPRenownFullFrame.NecrolordFrame.Name = AZPRenownFullFrame. NecrolordFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPRenownFullFrame.NecrolordFrame.Name:SetSize(AZPRenownFullFrame.NecrolordFrame:GetWidth() * 0.75, AZPRenownFullFrame.NecrolordFrame:GetHeight())
    AZPRenownFullFrame.NecrolordFrame.Name:SetPoint("LEFT", AZPRenownFullFrame.NecrolordFrame, "LEFT", 0, -2)
    AZPRenownFullFrame.NecrolordFrame.Name:SetText("Necrolord")
    AZPRenownFullFrame.NecrolordFrame.Name:SetJustifyV("CENTER")

    AZPRenownFullFrame.NecrolordFrame.Level = AZPRenownFullFrame.NecrolordFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPRenownFullFrame.NecrolordFrame.Level:SetSize(AZPRenownFullFrame.NecrolordFrame:GetWidth() * 0.25, AZPRenownFullFrame.NecrolordFrame:GetHeight())
    AZPRenownFullFrame.NecrolordFrame.Level:SetPoint("CENTER", AZPRenownFullFrame.NecrolordFrame, "CENTER", 52, -3)
    AZPRenownFullFrame.NecrolordFrame.Level:SetText("0")
    AZPRenownFullFrame.NecrolordFrame.Level:SetJustifyV("CENTER")
    AZPRenownFullFrame.NecrolordFrame.Level:SetTextColor(1, 1, 1, 1)

    AZPRenownFullFrame.NecrolordFrame.Glow = AZPRenownFullFrame.NecrolordFrame:CreateTexture(nil, "ARTWORK")
    AZPRenownFullFrame.NecrolordFrame.Glow:SetSize(curWidth, curHeight)
    AZPRenownFullFrame.NecrolordFrame.Glow:SetPoint("CENTER", 0, 0)
    AZPRenownFullFrame.NecrolordFrame.Glow:SetAtlas("shadowlands-landingpage-soulbindsbutton-highlight")
    AZPRenownFullFrame.NecrolordFrame.Glow:SetBlendMode("ADD")

    AZPRenownFullFrame.NecrolordFrame.Glow2 = AZPRenownFullFrame.NecrolordFrame:CreateTexture(nil, "ARTWORK")
    AZPRenownFullFrame.NecrolordFrame.Glow2:SetSize(curWidth, curHeight)
    AZPRenownFullFrame.NecrolordFrame.Glow2:SetPoint("CENTER", 0, 0)
    AZPRenownFullFrame.NecrolordFrame.Glow2:SetAtlas("shadowlands-landingpage-soulbindsbutton-highlight")
    AZPRenownFullFrame.NecrolordFrame.Glow2:SetBlendMode("ADD")

    AZPRenownFullFrame.KyrianFrame = CreateFrame("FRAME", nil, AZPRenownFullFrame)
    AZPRenownFullFrame.KyrianFrame:SetSize(curWidth, curHeight)
    AZPRenownFullFrame.KyrianFrame:SetPoint("TOP", AZPRenownFullFrame.NecrolordFrame, "BOTTOM", 0, 0)

    AZPRenownFullFrame.KyrianFrame.BG = AZPRenownFullFrame. KyrianFrame:CreateTexture(nil, "BACKGROUND")
    AZPRenownFullFrame.KyrianFrame.BG:SetSize(AZPRenownFullFrame.KyrianFrame:GetWidth(), AZPRenownFullFrame.KyrianFrame:GetHeight())
    AZPRenownFullFrame.KyrianFrame.BG:SetPoint("CENTER", 0, 0)
    AZPRenownFullFrame.KyrianFrame.BG:SetAtlas("shadowlands-landingpage-renownbutton-kyrian")

    AZPRenownFullFrame.KyrianFrame.Name = AZPRenownFullFrame. KyrianFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPRenownFullFrame.KyrianFrame.Name:SetSize(AZPRenownFullFrame.KyrianFrame:GetWidth() * 0.75, AZPRenownFullFrame.KyrianFrame:GetHeight())
    AZPRenownFullFrame.KyrianFrame.Name:SetPoint("LEFT", AZPRenownFullFrame.KyrianFrame, "LEFT", 0, -2)
    AZPRenownFullFrame.KyrianFrame.Name:SetText("Kyrian")
    AZPRenownFullFrame.KyrianFrame.Name:SetJustifyV("CENTER")

    AZPRenownFullFrame.KyrianFrame.Level = AZPRenownFullFrame.KyrianFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPRenownFullFrame.KyrianFrame.Level:SetSize(AZPRenownFullFrame.KyrianFrame:GetWidth() * 0.25, AZPRenownFullFrame.KyrianFrame:GetHeight())
    AZPRenownFullFrame.KyrianFrame.Level:SetPoint("CENTER", AZPRenownFullFrame.KyrianFrame, "CENTER", 52, -2)
    AZPRenownFullFrame.KyrianFrame.Level:SetText("0")
    AZPRenownFullFrame.KyrianFrame.Level:SetJustifyV("CENTER")
    AZPRenownFullFrame.KyrianFrame.Level:SetTextColor(1, 1, 1, 1)

    AZPRenownFullFrame.KyrianFrame.Glow = AZPRenownFullFrame.KyrianFrame:CreateTexture(nil, "ARTWORK")
    AZPRenownFullFrame.KyrianFrame.Glow:SetSize(curWidth, curHeight)
    AZPRenownFullFrame.KyrianFrame.Glow:SetPoint("CENTER", 0, 0)
    AZPRenownFullFrame.KyrianFrame.Glow:SetAtlas("shadowlands-landingpage-soulbindsbutton-highlight")
    AZPRenownFullFrame.KyrianFrame.Glow:SetBlendMode("ADD")

    AZPRenownFullFrame.KyrianFrame.Glow2 = AZPRenownFullFrame.KyrianFrame:CreateTexture(nil, "ARTWORK")
    AZPRenownFullFrame.KyrianFrame.Glow2:SetSize(curWidth, curHeight)
    AZPRenownFullFrame.KyrianFrame.Glow2:SetPoint("CENTER", 0, 0)
    AZPRenownFullFrame.KyrianFrame.Glow2:SetAtlas("shadowlands-landingpage-soulbindsbutton-highlight")
    AZPRenownFullFrame.KyrianFrame.Glow2:SetBlendMode("ADD")

    local font, size, other = AZPRenownFullFrame.NightFaeFrame.Level:GetFont()
    curFont = {font, size, other}

    AZPRenownFullFrame. NightFaeFrame.Level:SetFont(curFont[1], curFont[2], curFont[3])
    AZPRenownFullFrame.  VenthyrFrame.Level:SetFont(curFont[1], curFont[2], curFont[3])
    AZPRenownFullFrame.NecrolordFrame.Level:SetFont(curFont[1], curFont[2], curFont[3])
    AZPRenownFullFrame.   KyrianFrame.Level:SetFont(curFont[1], curFont[2], curFont[3])

    AZPRenownFullFrame:Hide()
end

function AZPRenownCreateAltFrame()
    local curGUID = UnitGUID("PLAYER")
    local curCharName = UnitName("PLAYER")
    local _, _, curClass = UnitClass("PLAYER")
    local curActivCov = C_Covenants.GetActiveCovenantID()
    if AZPRenownLevels[curGUID] == nil then AZPRenownLevels[curGUID] = {NightFae = 0, Venthyr = 0, Necrolord = 0, Kyrian = 0} end
    AZPRenownLevels[curGUID].Name = curCharName
    AZPRenownLevels[curGUID].Class = curClass
    AZPRenownLevels[curGUID].Active = curActivCov

    AZPRenownAltFrame = CreateFrame("FRAME", nil, UIParent, "BackdropTemplate")
    AZPRenownAltFrame:SetPoint("CENTER", 0, 0)
    AZPRenownAltFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZPRenownAltFrame:SetBackdropColor(0.5, 0.5, 0.5, 0.75)

    AZPRenownAltFrame:EnableMouse(true)
    AZPRenownAltFrame:SetMovable(true)
    AZPRenownAltFrame:RegisterForDrag("LeftButton")
    AZPRenownAltFrame:SetScript("OnDragStart", AZPRenownAltFrame.StartMoving)
    AZPRenownAltFrame:SetScript("OnDragStop", function() AZPRenownAltFrame:StopMovingOrSizing() AZPRenownSavePositionFrame() end)

    AZPRenownAltFrame.Header = AZPRenownAltFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPRenownAltFrame.Header:SetSize(AZPRenownAltFrame:GetWidth(), 50)
    AZPRenownAltFrame.Header:SetPoint("TOP", 0, -5)
    AZPRenownAltFrame.Header:SetText(string.format("AzerPUG's\nRenown Checker v%s", AZPRenownVersion))

    AZPRenownAltFrame.SubHeader = AZPRenownAltFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPRenownAltFrame.SubHeader:SetSize(AZPRenownAltFrame:GetWidth(), 25)
    AZPRenownAltFrame.SubHeader:SetPoint("TOP", AZPRenownAltFrame.Header, "BOTTOM", 0, 5)
    AZPRenownAltFrame.SubHeader:SetText("Alt Frame")

    AZPRenownAltFrame.OpenOptionPanelButton = CreateFrame("Frame", nil, AZPRenownAltFrame)
    AZPRenownAltFrame.OpenOptionPanelButton:SetSize(15, 15)
    AZPRenownAltFrame.OpenOptionPanelButton:SetPoint("TOPLEFT", AZPRenownAltFrame, "TOPLEFT", 3, -3)
    AZPRenownAltFrame.OpenOptionPanelButton:SetScript("OnMouseDown", function() OptionsFrame:Show() end)
    AZPRenownAltFrame.OpenOptionPanelButton.Texture = AZPRenownAltFrame.OpenOptionPanelButton:CreateTexture(nil, "ARTWORK")
    AZPRenownAltFrame.OpenOptionPanelButton.Texture:SetSize(AZPRenownAltFrame.OpenOptionPanelButton:GetWidth(), AZPRenownAltFrame.OpenOptionPanelButton:GetHeight())
    AZPRenownAltFrame.OpenOptionPanelButton.Texture:SetPoint("CENTER", 0, 0)
    AZPRenownAltFrame.OpenOptionPanelButton.Texture:SetTexture("Interface/BUTTONS/UI-OptionsButton")

    AZPRenownAltFrame.CloseButton = CreateFrame("Button", nil, AZPRenownAltFrame, "UIPanelCloseButton")
    AZPRenownAltFrame.CloseButton:SetSize(20, 21)
    AZPRenownAltFrame.CloseButton:SetPoint("TOPRIGHT", AZPRenownAltFrame, "TOPRIGHT", 2, 2)
    AZPRenownAltFrame.CloseButton:SetScript("OnClick", function() AZPRenownAltFrame:Hide() end)

    local curWidth, curHeight = 75, 75

    AZPRenownAltFrame.AllCharFrames = {}

    for curGUID, CharInfo in pairs(AZPRenownLevels) do
        local CurCharFrame = CreateFrame("FRAME", nil, AZPRenownAltFrame)
        CurCharFrame:SetSize(375, curHeight)
          if #AZPRenownAltFrame.AllCharFrames == 0 then CurCharFrame:SetPoint("TOPLEFT", 0, -65)
        else CurCharFrame:SetPoint("TOP", AZPRenownAltFrame.AllCharFrames[#AZPRenownAltFrame.AllCharFrames], "BOTTOM", 0, 10) end

        AZPRenownAltFrame.AllCharFrames[#AZPRenownAltFrame.AllCharFrames + 1] = CurCharFrame

        CurCharFrame.CharName = CurCharFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        CurCharFrame.CharName:SetSize(150, 25)
        CurCharFrame.CharName:SetPoint("LEFT", 10, 0)
        local curName = nil
        if CharInfo.Name == nil then curName = "UnLogged Char" else curName = CharInfo.Name end
        CurCharFrame.CharName:SetText(curName)
        CurCharFrame.CharName:SetJustifyV("CENTER")
        CurCharFrame.CharName:SetTextColor(1, 1, 1, 1)

        CurCharFrame.NightFaeFrame = CreateFrame("FRAME", nil, CurCharFrame)
        CurCharFrame.NightFaeFrame:SetSize(curWidth, curHeight)
        CurCharFrame.NightFaeFrame:SetPoint("LEFT", CurCharFrame.CharName, "RIGHT", -5, 0)

        CurCharFrame.NightFaeFrame.BG = CurCharFrame.NightFaeFrame:CreateTexture(nil, "BACKGROUND")
        CurCharFrame.NightFaeFrame.BG:SetSize(curWidth, curHeight)
        CurCharFrame.NightFaeFrame.BG:SetPoint("CENTER", 0, 0)
        CurCharFrame.NightFaeFrame.BG:SetAtlas("shadowlands-landingbutton-NightFae-up")

        CurCharFrame.NightFaeFrame.Level = CurCharFrame.NightFaeFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
        CurCharFrame.NightFaeFrame.Level:SetSize(CurCharFrame.NightFaeFrame:GetWidth(), CurCharFrame.NightFaeFrame:GetHeight())
        CurCharFrame.NightFaeFrame.Level:SetPoint("CENTER", 2, -1)
        CurCharFrame.NightFaeFrame.Level:SetText(CharInfo.NightFae)
        CurCharFrame.NightFaeFrame.Level:SetJustifyV("CENTER")
        CurCharFrame.NightFaeFrame.Level:SetTextColor(1, 1, 1, 1)

        CurCharFrame.NightFaeFrame.Glow = CurCharFrame.NightFaeFrame:CreateTexture(nil, "ARTWORK")
        CurCharFrame.NightFaeFrame.Glow:SetSize(curWidth + 15, curHeight + 15)
        CurCharFrame.NightFaeFrame.Glow:SetPoint("CENTER", 0, 0)
        CurCharFrame.NightFaeFrame.Glow:SetAtlas("shadowlands-landingbutton-NightFae-highlight")
        CurCharFrame.NightFaeFrame.Glow:SetBlendMode("ADD")
        CurCharFrame.NightFaeFrame.Glow:SetDesaturated(true)
        CurCharFrame.NightFaeFrame.Glow:SetVertexColor(0, 1, 1)

        CurCharFrame.NightFaeFrame.Glow2 = CurCharFrame.NightFaeFrame:CreateTexture(nil, "ARTWORK")
        CurCharFrame.NightFaeFrame.Glow2:SetSize(curWidth + 15, curHeight + 15)
        CurCharFrame.NightFaeFrame.Glow2:SetPoint("CENTER", 0, 0)
        CurCharFrame.NightFaeFrame.Glow2:SetAtlas("shadowlands-landingbutton-NightFae-highlight")
        CurCharFrame.NightFaeFrame.Glow2:SetBlendMode("ADD")
        CurCharFrame.NightFaeFrame.Glow2:SetDesaturated(true)
        CurCharFrame.NightFaeFrame.Glow2:SetVertexColor(0, 0.5, 1)

        CurCharFrame.VenthyrFrame = CreateFrame("FRAME", nil, CurCharFrame)
        CurCharFrame.VenthyrFrame:SetSize(curWidth, curHeight)
        CurCharFrame.VenthyrFrame:SetPoint("LEFT", CurCharFrame.NightFaeFrame, "RIGHT", -25, 0)

        CurCharFrame.VenthyrFrame.BG = CurCharFrame.VenthyrFrame:CreateTexture(nil, "BACKGROUND")
        CurCharFrame.VenthyrFrame.BG:SetSize(curWidth, curHeight)
        CurCharFrame.VenthyrFrame.BG:SetPoint("CENTER", 0, 0)
        CurCharFrame.VenthyrFrame.BG:SetAtlas("shadowlands-landingbutton-venthyr-up")

        CurCharFrame.VenthyrFrame.Level = CurCharFrame.VenthyrFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
        CurCharFrame.VenthyrFrame.Level:SetSize(CurCharFrame.VenthyrFrame:GetWidth(), CurCharFrame.VenthyrFrame:GetHeight())
        CurCharFrame.VenthyrFrame.Level:SetPoint("CENTER", 1, -1)
        CurCharFrame.VenthyrFrame.Level:SetText(CharInfo.Venthyr)
        CurCharFrame.VenthyrFrame.Level:SetJustifyV("CENTER")
        CurCharFrame.VenthyrFrame.Level:SetTextColor(1, 1, 1, 1)

        CurCharFrame.VenthyrFrame.Glow = CurCharFrame.VenthyrFrame:CreateTexture(nil, "ARTWORK")
        CurCharFrame.VenthyrFrame.Glow:SetSize(curWidth + 5, curHeight + 5)
        CurCharFrame.VenthyrFrame.Glow:SetPoint("CENTER", 0, 0)
        CurCharFrame.VenthyrFrame.Glow:SetAtlas("shadowlands-landingbutton-venthyr-highlight")
        CurCharFrame.VenthyrFrame.Glow:SetBlendMode("add")
        CurCharFrame.VenthyrFrame.Glow:SetDesaturated(true)
        CurCharFrame.VenthyrFrame.Glow:SetVertexColor(1, 0, 0)

        CurCharFrame.VenthyrFrame.Glow2 = CurCharFrame.VenthyrFrame:CreateTexture(nil, "ARTWORK")
        CurCharFrame.VenthyrFrame.Glow2:SetSize(curWidth + 5, curHeight + 5)
        CurCharFrame.VenthyrFrame.Glow2:SetPoint("CENTER", 0, 0)
        CurCharFrame.VenthyrFrame.Glow2:SetAtlas("shadowlands-landingbutton-venthyr-highlight")
        CurCharFrame.VenthyrFrame.Glow2:SetBlendMode("add")
        CurCharFrame.VenthyrFrame.Glow2:SetDesaturated(true)
        CurCharFrame.VenthyrFrame.Glow2:SetVertexColor(1, 0, 0)

        CurCharFrame.NecrolordFrame = CreateFrame("FRAME", nil, CurCharFrame)
        CurCharFrame.NecrolordFrame:SetSize(curWidth, curHeight)
        CurCharFrame.NecrolordFrame:SetPoint("LEFT", CurCharFrame.VenthyrFrame, "RIGHT", -25, 0)

        CurCharFrame.NecrolordFrame.BG = CurCharFrame.NecrolordFrame:CreateTexture(nil, "BACKGROUND")
        CurCharFrame.NecrolordFrame.BG:SetSize(curWidth, curHeight)
        CurCharFrame.NecrolordFrame.BG:SetPoint("CENTER", 0, 0)
        CurCharFrame.NecrolordFrame.BG:SetAtlas("shadowlands-landingbutton-necrolord-up")

        CurCharFrame.NecrolordFrame.Level = CurCharFrame.NecrolordFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
        CurCharFrame.NecrolordFrame.Level:SetSize(CurCharFrame.NecrolordFrame:GetWidth(), CurCharFrame.NecrolordFrame:GetHeight())
        CurCharFrame.NecrolordFrame.Level:SetPoint("CENTER", 0, -1)
        CurCharFrame.NecrolordFrame.Level:SetText(CharInfo.Necrolord)
        CurCharFrame.NecrolordFrame.Level:SetJustifyV("CENTER")
        CurCharFrame.NecrolordFrame.Level:SetTextColor(1, 1, 1, 1)

        CurCharFrame.NecrolordFrame.Glow = CurCharFrame.NecrolordFrame:CreateTexture(nil, "ARTWORK")
        CurCharFrame.NecrolordFrame.Glow:SetSize(curWidth + 5, curHeight + 5)
        CurCharFrame.NecrolordFrame.Glow:SetPoint("CENTER", 0, 0)
        CurCharFrame.NecrolordFrame.Glow:SetAtlas("shadowlands-landingbutton-necrolord-highlight")
        CurCharFrame.NecrolordFrame.Glow:SetBlendMode("add")
        CurCharFrame.NecrolordFrame.Glow:SetDesaturated(true)
        CurCharFrame.NecrolordFrame.Glow:SetVertexColor(0, 0.5, 0)

        CurCharFrame.NecrolordFrame.Glow2 = CurCharFrame.NecrolordFrame:CreateTexture(nil, "ARTWORK")
        CurCharFrame.NecrolordFrame.Glow2:SetSize(curWidth + 5, curHeight + 5)
        CurCharFrame.NecrolordFrame.Glow2:SetPoint("CENTER", 0, 0)
        CurCharFrame.NecrolordFrame.Glow2:SetAtlas("shadowlands-landingbutton-necrolord-highlight")
        CurCharFrame.NecrolordFrame.Glow2:SetBlendMode("add")
        CurCharFrame.NecrolordFrame.Glow2:SetDesaturated(true)
        CurCharFrame.NecrolordFrame.Glow2:SetVertexColor(0, 0.5, 0)

        CurCharFrame.KyrianFrame = CreateFrame("FRAME", nil, CurCharFrame)
        CurCharFrame.KyrianFrame:SetSize(curWidth, curHeight)
        CurCharFrame.KyrianFrame:SetPoint("LEFT", CurCharFrame.NecrolordFrame, "RIGHT", -25, 0)

        CurCharFrame.KyrianFrame.BG = CurCharFrame.KyrianFrame:CreateTexture(nil, "BACKGROUND")
        CurCharFrame.KyrianFrame.BG:SetSize(curWidth, curHeight)
        CurCharFrame.KyrianFrame.BG:SetPoint("CENTER", 0, 0)
        CurCharFrame.KyrianFrame.BG:SetAtlas("shadowlands-landingbutton-kyrian-up")

        CurCharFrame.KyrianFrame.Level = CurCharFrame.KyrianFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
        CurCharFrame.KyrianFrame.Level:SetSize(CurCharFrame.KyrianFrame:GetWidth(), CurCharFrame.KyrianFrame:GetHeight())
        CurCharFrame.KyrianFrame.Level:SetPoint("CENTER", 2, -1)
        CurCharFrame.KyrianFrame.Level:SetText(CharInfo.Kyrian)
        CurCharFrame.KyrianFrame.Level:SetJustifyV("CENTER")
        CurCharFrame.KyrianFrame.Level:SetTextColor(1, 1, 1, 1)

        CurCharFrame.KyrianFrame.Glow = CurCharFrame.KyrianFrame:CreateTexture(nil, "BACKGROUND")
        CurCharFrame.KyrianFrame.Glow:SetSize(curWidth + 10, curHeight + 10)
        CurCharFrame.KyrianFrame.Glow:SetPoint("CENTER", 0, 0)
        CurCharFrame.KyrianFrame.Glow:SetAtlas("shadowlands-landingbutton-kyrian-highlight")
        CurCharFrame.KyrianFrame.Glow:SetBlendMode("add")
        CurCharFrame.KyrianFrame.Glow:SetDesaturated(true)
        CurCharFrame.KyrianFrame.Glow:SetVertexColor(1, 1, 1)

        CurCharFrame.KyrianFrame.Glow2 = CurCharFrame.KyrianFrame:CreateTexture(nil, "BACKGROUND")
        CurCharFrame.KyrianFrame.Glow2:SetSize(curWidth + 10, curHeight + 10)
        CurCharFrame.KyrianFrame.Glow2:SetPoint("CENTER", 0, 0)
        CurCharFrame.KyrianFrame.Glow2:SetAtlas("shadowlands-landingbutton-kyrian-highlight")
        CurCharFrame.KyrianFrame.Glow2:SetBlendMode("add")
        CurCharFrame.KyrianFrame.Glow2:SetDesaturated(true)
        CurCharFrame.KyrianFrame.Glow2:SetVertexColor(1, 1, 1)

        local font, size, other = CurCharFrame.NightFaeFrame.Level:GetFont()
        curFont = {font, size, other}
        CurCharFrame. NightFaeFrame.Level:SetFont(curFont[1], curFont[2] - 4, curFont[3])
        CurCharFrame.  VenthyrFrame.Level:SetFont(curFont[1], curFont[2] - 4, curFont[3])
        CurCharFrame.NecrolordFrame.Level:SetFont(curFont[1], curFont[2] - 4, curFont[3])
        CurCharFrame.   KyrianFrame.Level:SetFont(curFont[1], curFont[2] - 4, curFont[3])
    end

    local curAltFrameHeight = #AZPRenownAltFrame.AllCharFrames * 65 + 75
    AZPRenownAltFrame:SetSize(375, curAltFrameHeight)

    AZPRenownAltFrame:Hide()
end

function AZPRenownFrameSizeToggle()
    if AZPRenownVars.Size == "Full" then
        AZPRenownVars.Size = "Compact"
        AZPRenownCompactFrame:Show()
        AZPRenownFrameMarkActiveCompact()
        AZPRenownFullFrame:Hide()
        OptionsFrame.ChangeSizeButton:SetText("Size: Compact")
    elseif AZPRenownVars.Size == "Compact" then
        AZPRenownVars.Size = "Full"
        AZPRenownFullFrame:Show()
        AZPRenownFrameMarkActiveFull()
        AZPRenownCompactFrame:Hide()
        OptionsFrame.ChangeSizeButton:SetText("Size: Full")
    end
    AZPRenownLoadPositionFrame()
end

function AZPRenownFrameMarkActiveCompact()
    local curCovID = C_Covenants.GetActiveCovenantID()
    AZPRenownCompactFrame.NightFaeFrame.Glow:Hide()
    AZPRenownCompactFrame.NightFaeFrame.Glow2:Hide()
    AZPRenownCompactFrame.VenthyrFrame.Glow:Hide()
    AZPRenownCompactFrame.VenthyrFrame.Glow2:Hide()
    AZPRenownCompactFrame.NecrolordFrame.Glow:Hide()
    AZPRenownCompactFrame.NecrolordFrame.Glow2:Hide()
    AZPRenownCompactFrame.KyrianFrame.Glow:Hide()
    AZPRenownCompactFrame.KyrianFrame.Glow2:Hide()
    if curCovID == 1 then
        AZPRenownCompactFrame.KyrianFrame.Glow:Show()
        AZPRenownCompactFrame.KyrianFrame.Glow2:Show()
    elseif curCovID == 2 then
        AZPRenownCompactFrame.VenthyrFrame.Glow:Show()
        AZPRenownCompactFrame.VenthyrFrame.Glow2:Show()
    elseif curCovID == 3 then
        AZPRenownCompactFrame.NightFaeFrame.Glow:Show()
        AZPRenownCompactFrame.NightFaeFrame.Glow2:Show()
    elseif curCovID == 4 then
        AZPRenownCompactFrame.NecrolordFrame.Glow:Show()
        AZPRenownCompactFrame.NecrolordFrame.Glow2:Show()
    end
end

function AZPRenownFrameMarkActiveFull()
    local curCovID = C_Covenants.GetActiveCovenantID()
    AZPRenownFullFrame.NightFaeFrame.Glow:Hide()
    AZPRenownFullFrame.NightFaeFrame.Glow2:Hide()
    AZPRenownFullFrame.VenthyrFrame.Glow:Hide()
    AZPRenownFullFrame.VenthyrFrame.Glow2:Hide()
    AZPRenownFullFrame.NecrolordFrame.Glow:Hide()
    AZPRenownFullFrame.NecrolordFrame.Glow2:Hide()
    AZPRenownFullFrame.KyrianFrame.Glow:Hide()
    AZPRenownFullFrame.KyrianFrame.Glow2:Hide()
    if curCovID == 1 then
        AZPRenownFullFrame.KyrianFrame.Glow:Show()
        AZPRenownFullFrame.KyrianFrame.Glow2:Show()
    elseif curCovID == 2 then
        AZPRenownFullFrame.VenthyrFrame.Glow:Show()
        AZPRenownFullFrame.VenthyrFrame.Glow2:Show()
    elseif curCovID == 3 then
        AZPRenownFullFrame.NightFaeFrame.Glow:Show()
        AZPRenownFullFrame.NightFaeFrame.Glow2:Show()
    elseif curCovID == 4 then
        AZPRenownFullFrame.NecrolordFrame.Glow:Show()
        AZPRenownFullFrame.NecrolordFrame.Glow2:Show()
    end
end

function AZPRenownFrameUpdateValues()
    if valuesRecentlyUpdated == false then
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
                if AZPRenownVars.Size == "Compact" then AZPRenownFrameMarkActiveCompact() end
                if AZPRenownVars.Size == "Full" then AZPRenownFrameMarkActiveFull() end
            end
        end)
    end
end

function AZPRenownOnEvent(_, event, ...)
    if event == "COVENANT_CHOSEN" then
        AZPRenownFrameUpdateValues()
    elseif event == "COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED" then
        AZPRenownFrameUpdateValues()
    elseif event == "VARIABLES_LOADED" then
        AZPRenownLoadPositionFrame()
        OptionsFrame.ChangeSizeButton:SetText(string.format("Size: %s", AZPRenownVars.Size))
        AZPRenownColorLoad()
        AZPRenownFrameUpdateValues()
        AZPRenownCreateAltFrame()
    end
end

function AZPRenownColorLoad()
    if AZPRenownVars.BG ~= nil then
        SetColorForFrames({AZPRenownCompactFrame, AZPRenownFullFrame}, AZPRenownVars.BG, "BG")
    end
    if AZPRenownVars.Border ~= nil then
        SetColorForFrames({AZPRenownCompactFrame, AZPRenownFullFrame}, AZPRenownVars.Border, "Border")
    end
    if AZPRenownVars.Text ~= nil then
        SetColorForFrames(
        {
            AZPRenownCompactFrame.Header,
            AZPRenownCompactFrame.NightFaeFrame.Level,
            AZPRenownCompactFrame.VenthyrFrame.Level,
            AZPRenownCompactFrame.NecrolordFrame.Level,
            AZPRenownCompactFrame.KyrianFrame.Level,
            AZPRenownFullFrame.Header,
            AZPRenownFullFrame.NightFaeFrame.Level,
            AZPRenownFullFrame.NightFaeFrame.Name,
            AZPRenownFullFrame.VenthyrFrame.Level,
            AZPRenownFullFrame.VenthyrFrame.Name,
            AZPRenownFullFrame.NecrolordFrame.Level,
            AZPRenownFullFrame.NecrolordFrame.Name,
            AZPRenownFullFrame.KyrianFrame.Level,
            AZPRenownFullFrame.KyrianFrame.Name,
        }, AZPRenownVars.Text, "Text")
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
    if AZPRenownVars.Size == nil then AZPRenownVars.Size = "Full" end
    local curPos = AZPRenownVars.Position

    AZPRenownCompactFrame:ClearAllPoints()
    AZPRenownFullFrame:ClearAllPoints()

    AZPRenownCompactFrame:SetPoint(curPos[1], curPos[4], curPos[5])
    AZPRenownFullFrame:SetPoint(curPos[1], curPos[4], curPos[5])

    if AZPRenownVars.Show == nil then AZPRenownVars.Show = true end

    if AZPRenownVars.Show == true then
            if AZPRenownVars.Size == "Compact" then AZPRenownCompactFrame:Show()
        elseif AZPRenownVars.Size == "Full" then AZPRenownFullFrame:Show() end
    end
end

function AZPRenownSavePositionFrame()
    local v1, v2, v3, v4, v5 = nil, nil, nil, nil, nil
        if AZPRenownVars.Size == "Compact" then v1, v2, v3, v4, v5 = AZPRenownCompactFrame:GetPoint()
    elseif AZPRenownVars.Size == "Full" then v1, v2, v3, v4, v5 = AZPRenownFullFrame:GetPoint() end
    AZPRenownVars.Position = {v1, v2, v3, v4, v5}
end

function AZPRenownShowHideToggle()
    if AZPRenownVars.Size == "Compact" then
        if AZPRenownVars.Show == true then AZPRenownVars.Show = false AZPRenownCompactFrame:Hide()
        elseif AZPRenownVars.Show == false then AZPRenownVars.Show = true AZPRenownCompactFrame:Show() end
    elseif AZPRenownVars.Size == "Full" then
        if AZPRenownVars.Show == true then AZPRenownVars.Show = false AZPRenownFullFrame:Hide()
        elseif AZPRenownVars.Show == false then AZPRenownVars.Show = true AZPRenownFullFrame:Show() end
    end
end

function ColorPickerMain(Frames, Component)
    ColorPickerFrameInUse = Component
    local r, g, b, a = nil, nil, nil, nil
        if Component == "BG" then r, g, b, a = Frames[1]:GetBackdropColor()
    elseif Component == "Border" then r, g, b, a = Frames[1]:GetBackdropBorderColor()
    elseif Component == "Text" then r, g, b, a = Frames[1]:GetTextColor() end
    ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a
    ColorPickerFrame.previousValues = {r,g,b,a}
    ColorPickerFrame:SetColorRGB(r,g,b)

    ColorPickerFrame.func = function() ColorPickerAcceptFunction(Frames, Component) end
    ColorPickerFrame.opacityFunc = ColorPickerFrame.func
    ColorPickerFrame.cancelFunc = function(prev) ColorPickerCancelFunction(Frames, Component, prev) end

    ColorPickerFrame:Hide()
    ColorPickerFrame:Show()
end

function AZPRenownColorSave()
    if ColorPickerFrameInUse ~= nil then
        local r, g, b = ColorPickerFrame:GetColorRGB()
        local a = OpacitySliderFrame:GetValue()
        AZPRenownVars[ColorPickerFrameInUse] = {r, g, b, a}
        ColorPickerFrameInUse = nil
    end
end

function ColorPickerAcceptFunction(Frames, Component)
    local r, g, b = ColorPickerFrame:GetColorRGB()
    local a = OpacitySliderFrame:GetValue()
    SetColorForFrames(Frames, {r, g, b, a}, Component)
end

function ColorPickerCancelFunction(Frames, Component, prev)
    ColorPickerFrameInUse = nil
    SetColorForFrames(Frames, prev, Component)
end

function SetColorForFrames(Frames, Color, Component)
    local r, g, b, a = unpack(Color)
    for _, curFrame in pairs(Frames) do
        if Component == "BG" then curFrame:SetBackdropColor(r, g, b, a)
    elseif Component == "Border" then curFrame:SetBackdropBorderColor(r, g, b, a)
    elseif Component == "Text" then curFrame:SetTextColor(r, g, b, a) end
    end
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