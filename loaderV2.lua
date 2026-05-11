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
    ContainerWidth  = 420,
    ContainerHeight = 110,
    BarHeight       = 10,
    BarPaddingX     = 36,
    BarLerpSpeed    = 0.5,
    FadeInSpeed     = 0.4,   -- duração do wipe de entrada (estilo DexPlus)
    FadeOutSpeed    = 0.4,
    SlideOffset     = 20,    -- px do slide-in do título
}

local loader      = {}
local TweenService = game:GetService("TweenService")
local RunService  = game:GetService("RunService")
local Players     = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local function fastwait(t)
    if not t then return RunService.RenderStepped:Wait() end
    local st = tick()
    repeat RunService.RenderStepped:Wait() until (tick() - st) >= t
end

local function tweenNumber(n, ti, func)
    local val = Instance.new("IntValue")
    val.Value = 0
    val.Changed:Connect(func)
    local tw = TweenService:Create(val, ti, {Value = n})
    tw:Play()
    tw.Completed:Connect(function() val:Destroy() end)
end

local function tw(obj, props, speed, style, dir)
    TweenService:Create(
        obj,
        TweenInfo.new(speed, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props
    ):Play()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "EXR_LOADER"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn   = false
screenGui.DisplayOrder   = 999

local ok = pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
if not ok then screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://18497827791"
sound.Volume  = 0.5
sound.Parent  = SoundService
sound.Ended:Connect(function() sound:Destroy() end)

local container = Instance.new("Frame")
container.Size                = UDim2.new(0, CONFIG.ContainerWidth, 0, CONFIG.ContainerHeight)
container.Position            = UDim2.new(0.5, 0, 0.5, 0)
container.AnchorPoint         = Vector2.new(0.5, 0.5)
container.BackgroundColor3    = Color3.fromRGB(18, 8, 8)
container.BorderSizePixel     = 0
container.BackgroundTransparency = 0   -- visível desde o início (gradiente cobre)
container.ZIndex              = 3
container.Parent              = screenGui

Instance.new("UICorner", container).CornerRadius = UDim.new(0, 16)

local backGradient = Instance.new("UIGradient")
backGradient.Rotation     = -30
backGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(1, 1),
})
backGradient.Parent = container

local containerStroke = Instance.new("UIStroke")
containerStroke.Color       = Color3.fromRGB(180, 30, 30)
containerStroke.Thickness   = 1.5
containerStroke.Transparency = 1
containerStroke.Parent      = container

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 10, 10)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 6, 6))
}
grad.Rotation = 135
grad.Parent   = container

local titleLabel = Instance.new("TextLabel")
titleLabel.Size               = UDim2.new(1, -CONFIG.BarPaddingX * 2, 0, 28)
titleLabel.Position           = UDim2.new(0, CONFIG.BarPaddingX - CONFIG.SlideOffset, 0, 10)  -- começa deslocado
titleLabel.BackgroundTransparency = 1
titleLabel.Text               = "Elysium X"
titleLabel.TextColor3         = Color3.fromRGB(230, 60, 60)
titleLabel.TextSize           = 20
titleLabel.Font               = Enum.Font.GothamBold
titleLabel.TextXAlignment     = Enum.TextXAlignment.Left
titleLabel.TextTransparency   = 1
titleLabel.ZIndex             = 4
titleLabel.Parent             = container

local statusLabel = Instance.new("TextLabel")
statusLabel.Size              = UDim2.new(1, -CONFIG.BarPaddingX * 2, 0, 18)
statusLabel.Position          = UDim2.new(0, CONFIG.BarPaddingX - CONFIG.SlideOffset, 0, 36)
statusLabel.BackgroundTransparency = 1
statusLabel.Text              = ""
statusLabel.TextColor3        = Color3.fromRGB(210, 210, 210)
statusLabel.TextSize          = 13
statusLabel.Font              = Enum.Font.GothamMedium
statusLabel.TextXAlignment    = Enum.TextXAlignment.Left
statusLabel.TextTransparency  = 1
statusLabel.ZIndex            = 4
statusLabel.Parent            = container

local percentLabel = Instance.new("TextLabel")
percentLabel.Size             = UDim2.new(1, -CONFIG.BarPaddingX * 2, 0, 18)
percentLabel.Position         = UDim2.new(0, CONFIG.BarPaddingX, 0, 36)
percentLabel.BackgroundTransparency = 1
percentLabel.Text             = "0%"
percentLabel.TextColor3       = Color3.fromRGB(210, 55, 55)
percentLabel.TextSize         = 13
percentLabel.Font             = Enum.Font.GothamBold
percentLabel.TextXAlignment   = Enum.TextXAlignment.Right
percentLabel.TextTransparency = 1
percentLabel.ZIndex           = 4
percentLabel.Parent           = container

local barBackground = Instance.new("Frame")
barBackground.Size             = UDim2.new(1, -CONFIG.BarPaddingX * 2, 0, CONFIG.BarHeight)
barBackground.Position         = UDim2.new(0, CONFIG.BarPaddingX, 0, 70)
barBackground.BackgroundColor3 = Color3.fromRGB(35, 10, 10)
barBackground.BorderSizePixel  = 0
barBackground.BackgroundTransparency = 1
barBackground.ZIndex           = 4
barBackground.Parent           = container

Instance.new("UICorner", barBackground).CornerRadius = UDim.new(0, 4)

local barStroke = Instance.new("UIStroke")
barStroke.Color       = Color3.fromRGB(100, 20, 20)
barStroke.Thickness   = 1
barStroke.Transparency = 1
barStroke.Parent      = barBackground

local barClip = Instance.new("Frame")
barClip.Size                 = UDim2.new(1, 0, 1, 0)
barClip.BackgroundTransparency = 1
barClip.ClipsDescendants     = true
barClip.ZIndex               = 4
barClip.Parent               = barBackground

local barFill = Instance.new("Frame")
barFill.Size                = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3    = Color3.fromRGB(200, 40, 40)
barFill.BorderSizePixel     = 0
barFill.BackgroundTransparency = 1
barFill.ZIndex              = 5
barFill.Parent              = barClip

Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 4)

local barGrad = Instance.new("UIGradient")
barGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(160, 20, 20)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 50, 50)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 80, 80))
}
barGrad.Parent = barFill

-- Shimmer na barra
local shimmer = Instance.new("Frame")
shimmer.Size                = UDim2.new(0.25, 0, 1, 0)
shimmer.Position            = UDim2.new(-0.3, 0, 0, 0)
shimmer.BackgroundColor3    = Color3.fromRGB(255, 255, 255)
shimmer.BackgroundTransparency = 0.78
shimmer.BorderSizePixel     = 0
shimmer.ZIndex              = 6
shimmer.Parent              = barFill

Instance.new("UICorner", shimmer).CornerRadius = UDim.new(0, 4)

local shimGrad = Instance.new("UIGradient")
shimGrad.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0,   1),
    NumberSequenceKeypoint.new(0.5, 0.55),
    NumberSequenceKeypoint.new(1,   1)
}
shimGrad.Parent = shimmer

local dotsLabel = Instance.new("TextLabel")
dotsLabel.Size              = UDim2.new(0, 24, 0, 18)
dotsLabel.Position          = UDim2.new(0, CONFIG.BarPaddingX, 0, 36)
dotsLabel.BackgroundTransparency = 1
dotsLabel.Text              = ""
dotsLabel.TextColor3        = Color3.fromRGB(210, 55, 55)
dotsLabel.TextSize          = 13
dotsLabel.Font              = Enum.Font.GothamBold
dotsLabel.TextXAlignment    = Enum.TextXAlignment.Left
dotsLabel.TextTransparency  = 1
dotsLabel.ZIndex            = 4
dotsLabel.Parent            = container

local ti = TweenInfo.new(CONFIG.FadeInSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

tweenNumber(100, ti, function(val)
    val = val / 200
    local start = NumberSequenceKeypoint.new(0, 0)
    local a1    = NumberSequenceKeypoint.new(val, 0)
    local a2    = NumberSequenceKeypoint.new(math.min(0.5, val + math.min(0.05, val)), 1)
    if a1.Time == a2.Time then a2 = a1 end
    local b1    = NumberSequenceKeypoint.new(1 - val, 0)
    local b2    = NumberSequenceKeypoint.new(math.max(0.5, 1 - val - math.min(0.05, val)), 1)
    if b1.Time == b2.Time then b2 = b1 end
    local goal  = NumberSequenceKeypoint.new(1, 0)
    backGradient.Transparency = NumberSequence.new({start, a1, a2, b2, b1, goal})
end)

fastwait(CONFIG.FadeInSpeed * 0.5)

TweenService:Create(titleLabel, ti, {
    Position        = UDim2.new(0, CONFIG.BarPaddingX, 0, 10),
    TextTransparency = 0
}):Play()

fastwait(CONFIG.FadeInSpeed * 0.4)

tw(containerStroke, {Transparency = 0},           CONFIG.FadeInSpeed)
tw(barBackground,   {BackgroundTransparency = 0}, CONFIG.FadeInSpeed)
tw(barStroke,       {Transparency = 0},           CONFIG.FadeInSpeed)
tw(barFill,         {BackgroundTransparency = 0}, CONFIG.FadeInSpeed)

TweenService:Create(statusLabel, ti, {
    Position        = UDim2.new(0, CONFIG.BarPaddingX, 0, 36),
    TextTransparency = 0
}):Play()
tw(percentLabel, {TextTransparency = 0}, CONFIG.FadeInSpeed)
tw(dotsLabel,    {TextTransparency = 0}, CONFIG.FadeInSpeed)

local shimmerRunning = true
task.spawn(function()
    while shimmerRunning do
        shimmer.Position = UDim2.new(-0.3, 0, 0, 0)
        TweenService:Create(shimmer,
            TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Position = UDim2.new(1.3, 0, 0, 0)}
        ):Play()
        task.wait(1.5)
    end
end)

local dotRunning = true
local dotCount   = 0
task.spawn(function()
    while dotRunning do
        dotCount      = (dotCount % 3) + 1
        dotsLabel.Text = string.rep(".", dotCount)
        task.wait(0.4)
    end
end)

local progressTI = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function updateLoader(status, progress)
    progress = math.clamp(progress, 0, 100)

    tw(statusLabel, {TextTransparency = 1, Position = UDim2.new(0, CONFIG.BarPaddingX, 0, 30)},
       0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    task.delay(0.15, function()
        statusLabel.Text     = status
        statusLabel.Position = UDim2.new(0, CONFIG.BarPaddingX - 6, 0, 36)

        task.spawn(function()
            task.wait()
            dotsLabel.Position = UDim2.new(
                0, CONFIG.BarPaddingX + statusLabel.TextBounds.X + 2, 0, 36
            )
        end)

        TweenService:Create(statusLabel, progressTI, {
            TextTransparency = 0,
            Position         = UDim2.new(0, CONFIG.BarPaddingX, 0, 36)
        }):Play()
    end)

    local startPct = tonumber(percentLabel.Text:match("%d+")) or 0
    task.spawn(function()
        for i = 1, 20 do
            percentLabel.Text = math.floor(startPct + (progress - startPct) * (i / 20)) .. "%"
            task.wait(CONFIG.BarLerpSpeed / 20)
        end
        percentLabel.Text = progress .. "%"
    end)

    TweenService:Create(barFill,
        TweenInfo.new(CONFIG.BarLerpSpeed, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = UDim2.new(progress / 100, 0, 1, 0)}
    ):Play()

    tw(barFill, {BackgroundColor3 = Color3.fromRGB(255, 90, 90)}, 0.1)
    task.delay(0.15, function()
        tw(barFill, {BackgroundColor3 = Color3.fromRGB(200, 40, 40)}, 0.3)
    end)
end

function loader:Remove()
    dotRunning     = false
    shimmerRunning = false

    local s = CONFIG.FadeOutSpeed

    -- 1. Fade dos elementos de texto/barra — espera terminar antes do wipe
    tw(containerStroke, {Transparency = 1},           s)
    tw(titleLabel,      {TextTransparency = 1},       s)
    tw(statusLabel,     {TextTransparency = 1},       s)
    tw(percentLabel,    {TextTransparency = 1},       s)
    tw(dotsLabel,       {TextTransparency = 1},       s)
    tw(barBackground,   {BackgroundTransparency = 1}, s)
    tw(barStroke,       {Transparency = 1},           s)
    tw(barFill,         {BackgroundTransparency = 1}, s)

    -- Aguarda o fade dos elementos terminar completamente
    fastwait(s + 0.05)

    -- 2. Wipe de saída (gradiente varre para fora — estilo DexPlus close())
    tweenNumber(100,
        TweenInfo.new(s, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        function(val)
            val = val / 250
            local start = NumberSequenceKeypoint.new(0, 0)
            local a1    = NumberSequenceKeypoint.new(0.6 + val, 0)
            local a2    = NumberSequenceKeypoint.new(math.min(1, 0.601 + val), 1)
            if a1.Time == a2.Time then a2 = a1 end
            local goal  = NumberSequenceKeypoint.new(1, a1 == a2 and 0 or 1)
            backGradient.Transparency = NumberSequence.new({start, a1, a2, goal})
        end
    )

    fastwait(s + 0.05)

    container.BackgroundTransparency = 1
    backGradient.Rotation = 30

    tweenNumber(100,
        TweenInfo.new(s, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        function(val)
            val = val / 100
            local start = NumberSequenceKeypoint.new(0, 1)
            local a1    = NumberSequenceKeypoint.new(val, 1)
            local a2    = NumberSequenceKeypoint.new(math.min(1, val + math.min(0.05, val)), 0)
            if a1.Time == a2.Time then a2 = a1 end
            local goal  = NumberSequenceKeypoint.new(1, a1 == a2 and 1 or 0)
            backGradient.Transparency = NumberSequence.new({start, a1, a2, goal})
        end
    )

    fastwait(s + 0.05)
    screenGui:Destroy()
end

task.spawn(function()
    task.wait(0.8)

    updateLoader("Loading assets", 30)
    task.wait(1.2)

    updateLoader("Loading modules", 65)
    task.wait(1.2)

    updateLoader("Launching WindUI", 100)
task.wait(0.6)
tw(statusLabel, {TextTransparency=1}, 0.3)
tw(percentLabel, {TextTransparency=1}, 0.3)
tw(dotsLabel, {TextTransparency=1}, 0.3)
task.wait(0.35)

local currentPlace = game.PlaceId          -- roda o script do jogo aqui
for _, v in pairs(getgenv().gamesConfig) do
    if v.placeId == currentPlace then
        loadstring(v.ConfigScript)()
    end
end

sound:Play()
loader:Remove()

end)
