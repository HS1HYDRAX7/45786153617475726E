getgenv().gamesConfig = {
    {
        gameName = "Die of death",
        placeId = 71895508397153,
        ConfigScript = [[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/HS1HYDRAX7/Elysium-X-Rework/refs/heads/main/Loader/Elysium%20X%20DOD"))()
        ]]
    },
}

local CONFIG = {
    ContainerWidth = 420,
    ContainerHeight = 110,
    BarHeight = 10,
    BarPaddingX = 36,
    BarLerpSpeed = 0.5,
    FadeInSpeed = 0.5,
    FadeOutSpeed = 0.4,
}

local loader = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EXR_LOADER"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999

local ok = pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
if not ok then
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://3166533612"
sound.Volume = 0.6
sound.Parent = SoundService
sound:Play()

sound.Ended:Connect(function()
    sound:Destroy()
end)

local container = Instance.new("Frame")
container.Size = UDim2.new(0, CONFIG.ContainerWidth, 0, CONFIG.ContainerHeight)
container.Position = UDim2.new(0.5, 0, 0.5, 0)
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.BackgroundColor3 = Color3.fromRGB(18, 8, 8)
container.BorderSizePixel = 0
container.BackgroundTransparency = 1
container.ZIndex = 3
container.Parent = screenGui

Instance.new("UICorner", container).CornerRadius = UDim.new(0, 16)

local containerStroke = Instance.new("UIStroke")
containerStroke.Color = Color3.fromRGB(180, 30, 30)
containerStroke.Thickness = 1.5
containerStroke.Transparency = 1
containerStroke.Parent = container

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 10, 10)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 6, 6))
}
grad.Rotation = 135
grad.Parent = container

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -CONFIG.BarPaddingX * 2, 0, 18)
statusLabel.Position = UDim2.new(0, CONFIG.BarPaddingX, 0, 30)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextTransparency = 1
statusLabel.ZIndex = 4
statusLabel.Parent = container

local percentLabel = Instance.new("TextLabel")
percentLabel.Size = UDim2.new(1, -CONFIG.BarPaddingX * 2, 0, 18)
percentLabel.Position = UDim2.new(0, CONFIG.BarPaddingX, 0, 30)
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "0%"
percentLabel.TextColor3 = Color3.fromRGB(210, 55, 55)
percentLabel.TextSize = 13
percentLabel.Font = Enum.Font.GothamBold
percentLabel.TextXAlignment = Enum.TextXAlignment.Right
percentLabel.TextTransparency = 1
percentLabel.ZIndex = 4
percentLabel.Parent = container

local barBackground = Instance.new("Frame")
barBackground.Size = UDim2.new(1, -CONFIG.BarPaddingX * 2, 0, CONFIG.BarHeight)
barBackground.Position = UDim2.new(0, CONFIG.BarPaddingX, 0, 62)
barBackground.BackgroundColor3 = Color3.fromRGB(35, 10, 10)
barBackground.BorderSizePixel = 0
barBackground.BackgroundTransparency = 1
barBackground.ZIndex = 4
barBackground.Parent = container

Instance.new("UICorner", barBackground).CornerRadius = UDim.new(0, 4)

local barStroke = Instance.new("UIStroke")
barStroke.Color = Color3.fromRGB(100, 20, 20)
barStroke.Thickness = 1
barStroke.Transparency = 1
barStroke.Parent = barBackground

local barClip = Instance.new("Frame")
barClip.Size = UDim2.new(1, 0, 1, 0)
barClip.BackgroundTransparency = 1
barClip.ClipsDescendants = true
barClip.ZIndex = 4
barClip.Parent = barBackground

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
barFill.BorderSizePixel = 0
barFill.BackgroundTransparency = 1
barFill.ZIndex = 5
barFill.Parent = barClip

Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 4)

local barGrad = Instance.new("UIGradient")
barGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 20, 20)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 80))
}
barGrad.Parent = barFill

local shimmer = Instance.new("Frame")
shimmer.Size = UDim2.new(0.25, 0, 1, 0)
shimmer.Position = UDim2.new(-0.3, 0, 0, 0)
shimmer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shimmer.BackgroundTransparency = 0.78
shimmer.BorderSizePixel = 0
shimmer.ZIndex = 6
shimmer.Parent = barFill

Instance.new("UICorner", shimmer).CornerRadius = UDim.new(0, 4)

local shimGrad = Instance.new("UIGradient")
shimGrad.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.55),
    NumberSequenceKeypoint.new(1, 1)
}
shimGrad.Parent = shimmer

local dotsLabel = Instance.new("TextLabel")
dotsLabel.Size = UDim2.new(0, 24, 0, 18)
dotsLabel.Position = UDim2.new(0, CONFIG.BarPaddingX, 0, 30)
dotsLabel.BackgroundTransparency = 1
dotsLabel.Text = ""
dotsLabel.TextColor3 = Color3.fromRGB(210, 55, 55)
dotsLabel.TextSize = 13
dotsLabel.Font = Enum.Font.GothamBold
dotsLabel.TextXAlignment = Enum.TextXAlignment.Left
dotsLabel.TextTransparency = 1
dotsLabel.ZIndex = 4
dotsLabel.Parent = container

local function tw(obj, props, speed, style, dir)
    TweenService:Create(
        obj,
        TweenInfo.new(speed, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props
    ):Play()
end

local shimmerRunning = true

task.spawn(function()
    while shimmerRunning do
        shimmer.Position = UDim2.new(-0.3, 0, 0, 0)

        TweenService:Create(
            shimmer,
            TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {
                Position = UDim2.new(1.3, 0, 0, 0)
            }
        ):Play()

        task.wait(1.5)
    end
end)

local dotRunning = true
local dotCount = 0

task.spawn(function()
    while dotRunning do
        dotCount = (dotCount % 3) + 1
        dotsLabel.Text = string.rep(".", dotCount)
        task.wait(0.4)
    end
end)

task.spawn(function()
    task.wait(0.05)

    tw(container, {BackgroundTransparency = 0}, CONFIG.FadeInSpeed)
    tw(containerStroke, {Transparency = 0}, CONFIG.FadeInSpeed)
    tw(statusLabel, {TextTransparency = 0}, CONFIG.FadeInSpeed)
    tw(percentLabel, {TextTransparency = 0}, CONFIG.FadeInSpeed)
    tw(dotsLabel, {TextTransparency = 0}, CONFIG.FadeInSpeed)
    tw(barBackground, {BackgroundTransparency = 0}, CONFIG.FadeInSpeed)
    tw(barStroke, {Transparency = 0}, CONFIG.FadeInSpeed)
    tw(barFill, {BackgroundTransparency = 0}, CONFIG.FadeInSpeed)
end)

local function updateLoader(status, progress)
    progress = math.clamp(progress, 0, 100)

    tw(
        statusLabel,
        {
            TextTransparency = 1,
            Position = UDim2.new(0, CONFIG.BarPaddingX, 0, 26)
        },
        0.12,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    )

    task.delay(0.15, function()
        statusLabel.Text = status
        statusLabel.Position = UDim2.new(0, CONFIG.BarPaddingX, 0, 34)

        task.spawn(function()
            task.wait()

            dotsLabel.Position = UDim2.new(
                0,
                CONFIG.BarPaddingX + statusLabel.TextBounds.X + 2,
                0,
                30
            )
        end)

        tw(
            statusLabel,
            {
                TextTransparency = 0,
                Position = UDim2.new(0, CONFIG.BarPaddingX, 0, 30)
            },
            0.2
        )
    end)

    local startPct = tonumber(percentLabel.Text:match("%d+")) or 0

    task.spawn(function()
        for i = 1, 20 do
            percentLabel.Text =
                math.floor(startPct + (progress - startPct) * (i / 20)) .. "%"

            task.wait(CONFIG.BarLerpSpeed / 20)
        end

        percentLabel.Text = progress .. "%"
    end)

    TweenService:Create(
        barFill,
        TweenInfo.new(
            CONFIG.BarLerpSpeed,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        {
            Size = UDim2.new(progress / 100, 0, 1, 0)
        }
    ):Play()

    tw(barFill, {BackgroundColor3 = Color3.fromRGB(255, 90, 90)}, 0.1)

    task.delay(0.15, function()
        tw(barFill, {BackgroundColor3 = Color3.fromRGB(200, 40, 40)}, 0.3)
    end)
end

function loader:Remove()
    dotRunning = false
    shimmerRunning = false

    local s = CONFIG.FadeOutSpeed

    tw(
        container,
        {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, -16)
        },
        s,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    )

    tw(containerStroke, {Transparency = 1}, s)
    tw(statusLabel, {TextTransparency = 1}, s)
    tw(percentLabel, {TextTransparency = 1}, s)
    tw(dotsLabel, {TextTransparency = 1}, s)
    tw(barBackground, {BackgroundTransparency = 1}, s)
    tw(barStroke, {Transparency = 1}, s)
    tw(barFill, {BackgroundTransparency = 1}, s)

    task.delay(s + 0.05, function()
        screenGui:Destroy()
    end)
end

task.spawn(function()
    task.wait(0.6)

    updateLoader("Loading assets", 30)

    task.wait(1.2)

    updateLoader("Loading modules", 65)

    task.wait(1.2)

    updateLoader("Launching WindUI", 100)

    local currentPlace = game.PlaceId

    for _, v in pairs(getgenv().gamesConfig) do
        if v.placeId == currentPlace then
            loadstring(v.ConfigScript)()
        end
    end

    loader:Remove()
end)
