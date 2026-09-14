-- Script Type: Module
-- LarpingHub - Loading Screen Module
-- docs not avaible as of now

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

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
    card.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    card.BorderSizePixel = 0
    card.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 70)
    stroke.Thickness = 1
    stroke.Transparency = 0.2
    stroke.Parent = card

    local title = Instance.new("TextLabel")
    title.Position = UDim2.new(0, 16, 0, 12)
    title.Size = UDim2.new(1, -32, 0, 22)
    title.BackgroundTransparency = 1
    title.Text = "Larping Hub"
    title.TextColor3 = Color3.fromRGB(230, 230, 240)
    title.TextSize = 19
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = card

    local version = Instance.new("TextLabel")
    version.Position = UDim2.new(0, 16, 0, 36)
    version.Size = UDim2.new(1, -32, 0, 14)
    version.BackgroundTransparency = 1
    version.Text = "v1.0"
    version.TextColor3 = Color3.fromRGB(120, 130, 150)
    version.TextSize = 11
    version.Font = Enum.Font.Gotham
    version.TextXAlignment = Enum.TextXAlignment.Left
    version.Parent = card

    local statusRow = Instance.new("Frame")
    statusRow.Position = UDim2.new(0, 16, 0, 62)
    statusRow.Size = UDim2.new(1, -32, 0, 14)
    statusRow.BackgroundTransparency = 1
    statusRow.Parent = card

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0.7, 0, 1, 0)
    status.BackgroundTransparency = 1
    status.Text = "starting up"
    status.TextColor3 = Color3.fromRGB(150, 160, 180)
    status.TextSize = 11
    status.Font = Enum.Font.Gotham
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = statusRow

    local pct = Instance.new("TextLabel")
    pct.Position = UDim2.new(0.7, 0, 0, 0)
    pct.Size = UDim2.new(0.3, 0, 1, 0)
    pct.BackgroundTransparency = 1
    pct.Text = "0%"
    pct.TextColor3 = Color3.fromRGB(150, 160, 180)
    pct.TextSize = 11
    pct.Font = Enum.Font.Gotham
    pct.TextXAlignment = Enum.TextXAlignment.Right
    pct.Parent = statusRow

    local barTrack = Instance.new("Frame")
    barTrack.Position = UDim2.new(0, 16, 0, 84)
    barTrack.Size = UDim2.new(1, -32, 0, 4)
    barTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
    barTrack.BorderSizePixel = 0
    barTrack.Parent = card

    local barTrackCorner = Instance.new("UICorner")
    barTrackCorner.CornerRadius = UDim.new(1, 0)
    barTrackCorner.Parent = barTrack

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(120, 180, 255)
    barFill.BorderSizePixel = 0
    barFill.Parent = barTrack

    local barFillCorner = Instance.new("UICorner")
    barFillCorner.CornerRadius = UDim.new(1, 0)
    barFillCorner.Parent = barFill

    TweenService:Create(
        card,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 300, 0, 108) }
    ):Play()

    local function setProgress(value, text)
        value = math.clamp(value, 0, 1)
        TweenService:Create(
            barFill,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Size = UDim2.new(value, 0, 1, 0) }
        ):Play()
        pct.Text = string.format("%d%%", math.floor(value * 100))
        if text then
            status.Text = tostring(text)
        end
    end

    local function destroy()
        TweenService:Create(
            card,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
            }
        ):Play()

        TweenService:Create(
            stroke,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            { Transparency = 1 }
        ):Play()

        for _, item in ipairs(card:GetDescendants()) do
            pcall(function()
                TweenService:Create(
                    item,
                    TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                    {
                        BackgroundTransparency = 1,
                        TextTransparency = 1,
                        Transparency = 1,
                    }
                ):Play()
            end)
        end

        task.delay(0.35, function()
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
