-- Script Type: Module
-- LarpingHub - Loading Screen Module
-- docs not avaible as of now

local TweenService = game:GetService("TweenService")
local Players      = game:GetService("Players")
local LocalPlayer  = Players.LocalPlayer
local accent    = Color3.fromRGB(120, 180, 255)
local bgDark    = Color3.fromRGB(16, 16, 20)
local bgLight   = Color3.fromRGB(36, 36, 44)
local textDim   = Color3.fromRGB(160, 160, 175)
local textColor = Color3.fromRGB(240, 240, 245)

local function build()
    local gui = Instance.new("ScreenGui")
    gui.Name = "LarpingHubLoading"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 1000
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local card = Instance.new("Frame")
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.new(0.5, 0, 0.5, 0)
    card.Size = UDim2.new(0, 0, 0, 0)
    card.BackgroundColor3 = bgDark
    card.BackgroundTransparency = 0.05
    card.BorderSizePixel = 0
    card.Parent = gui

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 20)
    cardCorner.Parent = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = accent
    cardStroke.Thickness = 1.5
    cardStroke.Transparency = 0.15
    cardStroke.Parent = card

    local innerStroke = Instance.new("Frame")
    innerStroke.Size = UDim2.new(1, -12, 1, -12)
    innerStroke.Position = UDim2.new(0, 6, 0, 6)
    innerStroke.BackgroundTransparency = 1
    innerStroke.BorderSizePixel = 0
    innerStroke.Parent = card

    local innerStrokeCorner = Instance.new("UICorner")
    innerStrokeCorner.CornerRadius = UDim.new(0, 15)
    innerStrokeCorner.Parent = innerStroke

    local innerStrokeLine = Instance.new("UIStroke")
    innerStrokeLine.Color = accent
    innerStrokeLine.Thickness = 1
    innerStrokeLine.Transparency = 0.78
    innerStrokeLine.Parent = innerStroke

    local topBar = Instance.new("Frame")
    topBar.AnchorPoint = Vector2.new(0.5, 0)
    topBar.Position = UDim2.new(0.5, 0, 0, 12)
    topBar.Size = UDim2.new(0, 80, 0, 3)
    topBar.BackgroundColor3 = accent
    topBar.BorderSizePixel = 0
    topBar.Parent = card

    local topBarCorner = Instance.new("UICorner")
    topBarCorner.CornerRadius = UDim.new(1, 0)
    topBarCorner.Parent = topBar

    local topBarGlow = Instance.new("UIStroke")
    topBarGlow.Color = accent
    topBarGlow.Thickness = 5
    topBarGlow.Transparency = 0.55
    topBarGlow.Parent = topBar

    local titleShadow = Instance.new("TextLabel")
    titleShadow.AnchorPoint = Vector2.new(0.5, 0)
    titleShadow.Position = UDim2.new(0.5, 0, 0, 32)
    titleShadow.Size = UDim2.new(1, 0, 0, 46)
    titleShadow.BackgroundTransparency = 1
    titleShadow.Text = "LARPING HUB"
    titleShadow.TextColor3 = accent
    titleShadow.TextTransparency = 0.55
    titleShadow.TextSize = 38
    titleShadow.Font = Enum.Font.GothamBlack
    titleShadow.Parent = card

    local title = Instance.new("TextLabel")
    title.AnchorPoint = Vector2.new(0.5, 0)
    title.Position = UDim2.new(0.5, 0, 0, 32)
    title.Size = UDim2.new(1, 0, 0, 46)
    title.BackgroundTransparency = 1
    title.Text = "LARPING HUB"
    title.TextColor3 = textColor
    title.TextSize = 38
    title.Font = Enum.Font.GothamBlack
    title.Parent = card

    local titleStroke = Instance.new("UIStroke")
    titleStroke.Color = accent
    titleStroke.Thickness = 1
    titleStroke.Transparency = 0.35
    titleStroke.Parent = title

    local divider = Instance.new("Frame")
    divider.AnchorPoint = Vector2.new(0.5, 0.5)
    divider.Position = UDim2.new(0.5, 0, 0, 88)
    divider.Size = UDim2.new(0, 180, 0, 1)
    divider.BackgroundColor3 = accent
    divider.BackgroundTransparency = 0.4
    divider.BorderSizePixel = 0
    divider.Parent = card

    local dividerDot = Instance.new("Frame")
    dividerDot.AnchorPoint = Vector2.new(0.5, 0.5)
    dividerDot.Position = UDim2.new(0.5, 0, 0, 88)
    dividerDot.Size = UDim2.new(0, 6, 0, 6)
    dividerDot.BackgroundColor3 = accent
    dividerDot.BorderSizePixel = 0
    dividerDot.Parent = card

    local dividerDotCorner = Instance.new("UICorner")
    dividerDotCorner.CornerRadius = UDim.new(1, 0)
    dividerDotCorner.Parent = dividerDot

    local dividerDotGlow = Instance.new("UIStroke")
    dividerDotGlow.Color = accent
    dividerDotGlow.Thickness = 6
    dividerDotGlow.Transparency = 0.55
    dividerDotGlow.Parent = dividerDot

    local barBg = Instance.new("Frame")
    barBg.AnchorPoint = Vector2.new(0.5, 0)
    barBg.Position = UDim2.new(0.5, 0, 0, 108)
    barBg.Size = UDim2.new(1, -70, 0, 5)
    barBg.BackgroundColor3 = bgLight
    barBg.BorderSizePixel = 0
    barBg.Parent = card

    local barBgCorner = Instance.new("UICorner")
    barBgCorner.CornerRadius = UDim.new(1, 0)
    barBgCorner.Parent = barBg

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = accent
    barFill.BorderSizePixel = 0
    barFill.Parent = barBg

    local barFillCorner = Instance.new("UICorner")
    barFillCorner.CornerRadius = UDim.new(1, 0)
    barFillCorner.Parent = barFill

    local barFillGlow = Instance.new("UIStroke")
    barFillGlow.Color = accent
    barFillGlow.Thickness = 6
    barFillGlow.Transparency = 0.55
    barFillGlow.Parent = barFill

    local statusLabel = Instance.new("TextLabel")
    statusLabel.AnchorPoint = Vector2.new(0.5, 0)
    statusLabel.Position = UDim2.new(0.5, 0, 0, 124)
    statusLabel.Size = UDim2.new(1, -70, 0, 14)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "..."
    statusLabel.TextColor3 = textDim
    statusLabel.TextSize = 10
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = card

    local pctLabel = Instance.new("TextLabel")
    pctLabel.AnchorPoint = Vector2.new(0.5, 0)
    pctLabel.Position = UDim2.new(0.5, 0, 0, 124)
    pctLabel.Size = UDim2.new(1, -70, 0, 14)
    pctLabel.BackgroundTransparency = 1
    pctLabel.Text = "0%"
    pctLabel.TextColor3 = accent
    pctLabel.TextSize = 10
    pctLabel.Font = Enum.Font.GothamBold
    pctLabel.TextXAlignment = Enum.TextXAlignment.Right
    pctLabel.Parent = card

    local cardW = 360
    local cardH = 160

    TweenService:Create(
        card,
        TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, cardW, 0, cardH) }
    ):Play()

    TweenService:Create(
        titleShadow,
        TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        { TextTransparency = 0.8 }
    ):Play()

    TweenService:Create(
        topBarGlow,
        TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        { Transparency = 0.85 }
    ):Play()

    TweenService:Create(
        dividerDotGlow,
        TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        { Transparency = 0.85 }
    ):Play()

    local function setProgress(pct, text)
        pct = math.clamp(pct, 0, 1)
        TweenService:Create(
            barFill,
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            { Size = UDim2.new(pct, 0, 1, 0) }
        ):Play()
        pctLabel.Text = string.format("%d%%", math.floor(pct * 100))
        if text then
            statusLabel.Text = string.upper(text)
        end
    end

    local function destroy()
        TweenService:Create(
            card,
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
            }
        ):Play()

        TweenService:Create(
            cardStroke,
            TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            { Transparency = 1, Thickness = 6 }
        ):Play()

        TweenService:Create(
            innerStrokeLine,
            TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            { Transparency = 1 }
        ):Play()

        for _, item in ipairs(card:GetDescendants()) do
            pcall(function()
                TweenService:Create(
                    item,
                    TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                    {
                        BackgroundTransparency = 1,
                        TextTransparency = 1,
                        Transparency = 1,
                    }
                ):Play()
            end)
        end

        task.delay(0.55, function()
            if gui and gui.Parent then
                gui:Destroy()
            end
        end)
    end

    return {
        gui = gui,
        setProgress = setProgress,
        destroy = destroy,
    }
end

return build
