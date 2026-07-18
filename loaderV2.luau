getgenv().gamesConfig = {
    {
        gameName = "Die of death",
        placeId = 71895508397153,
        ConfigScript = [[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/HS1HYDRAX7/45786153617475726E/refs/heads/main/loader/ExaSaturn%20X%20DOD.luau"))()        ]]
    },
}

local CONFIG = {
    ContainerWidth   = 440,
    ContainerHeight  = 138,
    BarHeight        = 10,
    BarPaddingX      = 36,
    BarLerpSpeed     = 0.5,
    FadeInSpeed      = 0.4,
    FadeOutSpeed     = 0.4,
    SlideOffset      = 20,

    Credits          = {
        "Made by Atlas (Owner, Coder)",
        "Made by dekyo (Coder)",
    },
    TypeSpeed        = 0.032,
    EraseSpeed       = 0.018,
    CreditsHoldTime  = 1.1,
    CreditsGapTime   = 0.3,
    CursorBlink      = 0.5,

    LoadStepWait     = 1.2,   -- base wait per loading step
    ExtraWaitPerCredit = 0.5, -- loader takes longer the more credits there are
    ScriptTimeout    = 5,     -- seconds to wait for the game script before force-closing
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
screenGui.Name           = "EXASATURN_Loader"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn   = false
screenGui.DisplayOrder   = 999

local ok = pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
if not ok then screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://12222253"
sound.Volume  = 1
sound.Parent  = SoundService
sound.Ended:Connect(function() sound:Destroy() end)

-- Soft drop shadow behind the container for depth
local shadow = Instance.new("Frame")
shadow.Size               = UDim2.new(0, CONFIG.ContainerWidth + 24, 0, CONFIG.ContainerHeight + 24)
shadow.Position           = UDim2.new(0.5, 0, 0.5, 4)
shadow.AnchorPoint         = Vector2.new(0.5, 0.5)
shadow.BackgroundColor3   = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 1
shadow.BorderSizePixel    = 0
shadow.ZIndex             = 1
shadow.Parent             = screenGui

Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 24)

local shadowGrad = Instance.new("UIGradient")
shadowGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.55),
    NumberSequenceKeypoint.new(1, 1),
})
shadowGrad.Rotation = 90
shadowGrad.Parent = shadow

local container = Instance.new("Frame")
container.Size                = UDim2.new(0, CONFIG.ContainerWidth, 0, CONFIG.ContainerHeight)
container.Position            = UDim2.new(0.5, 0, 0.5, 0)
container.AnchorPoint         = Vector2.new(0.5, 0.5)
container.BackgroundColor3    = Color3.fromRGB(16, 7, 7)
container.BorderSizePixel     = 0
container.BackgroundTransparency = 0
container.ZIndex              = 3
container.Parent              = screenGui

Instance.new("UICorner", container).CornerRadius = UDim.new(0, 18)

local backGradient = Instance.new("UIGradient")
backGradient.Rotation     = -30
backGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(1, 1),
})
backGradient.Parent = container

local containerStroke = Instance.new("UIStroke")
containerStroke.Color       = Color3.fromRGB(190, 35, 35)
containerStroke.Thickness   = 1.4
containerStroke.Transparency = 1
containerStroke.Parent      = container

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 11, 11)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 5, 5))
}
grad.Rotation = 135
grad.Parent   = container

local titleLabel = Instance.new("TextLabel")
titleLabel.Size               = UDim2.new(1, -CONFIG.BarPaddingX * 2, 0, 24)
titleLabel.Position           = UDim2.new(0, CONFIG.BarPaddingX - CONFIG.SlideOffset, 0, 14)
titleLabel.BackgroundTransparency = 1
titleLabel.Text               = "EXASATURN"
titleLabel.TextColor3         = Color3.fromRGB(235, 65, 65)
titleLabel.TextSize           = 21
titleLabel.Font               = Enum.Font.GothamBold
titleLabel.TextXAlignment     = Enum.TextXAlignment.Left
titleLabel.TextTransparency   = 1
titleLabel.ZIndex             = 4
titleLabel.Parent             = container

local titleStroke = Instance.new("UIStroke")
titleStroke.Color       = Color3.fromRGB(90, 10, 10)
titleStroke.Thickness   = 0.6
titleStroke.Transparency = 1
titleStroke.Parent      = titleLabel

-- Terminal-style credits line (typing animation), directly under EXASATURN
local creditsLabel = Instance.new("TextLabel")
creditsLabel.Size              = UDim2.new(1, -CONFIG.BarPaddingX * 2, 0, 16)
creditsLabel.Position          = UDim2.new(0, CONFIG.BarPaddingX, 0, 42)
creditsLabel.BackgroundTransparency = 1
creditsLabel.Text              = ""
creditsLabel.TextColor3        = Color3.fromRGB(190, 110, 110)
creditsLabel.TextSize          = 12
creditsLabel.Font              = Enum.Font.Code
creditsLabel.TextXAlignment    = Enum.TextXAlignment.Left
creditsLabel.TextTransparency  = 1
creditsLabel.ZIndex            = 4
creditsLabel.Parent            = container

local statusLabel = Instance.new("TextLabel")
statusLabel.Size              = UDim2.new(1, -CONFIG.BarPaddingX * 2, 0, 18)
statusLabel.Position          = UDim2.new(0, CONFIG.BarPaddingX - CONFIG.SlideOffset, 0, 78)
statusLabel.BackgroundTransparency = 1
statusLabel.Text              = ""
statusLabel.TextColor3        = Color3.fromRGB(215, 215, 215)
statusLabel.TextSize          = 13
statusLabel.Font              = Enum.Font.GothamMedium
statusLabel.TextXAlignment    = Enum.TextXAlignment.Left
statusLabel.TextTransparency  = 1
statusLabel.ZIndex            = 4
statusLabel.Parent            = container

local percentLabel = Instance.new("TextLabel")
percentLabel.Size             = UDim2.new(1, -CONFIG.BarPaddingX * 2, 0, 18)
percentLabel.Position         = UDim2.new(0, CONFIG.BarPaddingX, 0, 78)
percentLabel.BackgroundTransparency = 1
percentLabel.Text             = "0%"
percentLabel.TextColor3       = Color3.fromRGB(215, 60, 60)
percentLabel.TextSize         = 13
percentLabel.Font             = Enum.Font.GothamBold
percentLabel.TextXAlignment   = Enum.TextXAlignment.Right
percentLabel.TextTransparency = 1
percentLabel.ZIndex           = 4
percentLabel.Parent           = container

local barBackground = Instance.new("Frame")
barBackground.Size             = UDim2.new(1, -CONFIG.BarPaddingX * 2, 0, CONFIG.BarHeight)
barBackground.Position         = UDim2.new(0, CONFIG.BarPaddingX, 0, 108)
barBackground.BackgroundColor3 = Color3.fromRGB(35, 10, 10)
barBackground.BorderSizePixel  = 0
barBackground.BackgroundTransparency = 1
barBackground.ZIndex           = 4
barBackground.Parent           = container

Instance.new("UICorner", barBackground).CornerRadius = UDim.new(0, 5)

local barStroke = Instance.new("UIStroke")
barStroke.Color       = Color3.fromRGB(105, 22, 22)
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

Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 5)

local barGrad = Instance.new("UIGradient")
barGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(160, 20, 20)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 50, 50)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 80, 80))
}
barGrad.Parent = barFill

local shimmer = Instance.new("Frame")
shimmer.Size                = UDim2.new(0.25, 0, 1, 0)
shimmer.Position            = UDim2.new(-0.3, 0, 0, 0)
shimmer.BackgroundColor3    = Color3.fromRGB(255, 255, 255)
shimmer.BackgroundTransparency = 0.78
shimmer.BorderSizePixel     = 0
shimmer.ZIndex              = 6
shimmer.Parent              = barFill

Instance.new("UICorner", shimmer).CornerRadius = UDim.new(0, 5)

local shimGrad = Instance.new("UIGradient")
shimGrad.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0,   1),
    NumberSequenceKeypoint.new(0.5, 0.55),
    NumberSequenceKeypoint.new(1,   1)
}
shimGrad.Parent = shimmer

local dotsLabel = Instance.new("TextLabel")
dotsLabel.Size              = UDim2.new(0, 24, 0, 18)
dotsLabel.Position          = UDim2.new(0, CONFIG.BarPaddingX, 0, 78)
dotsLabel.BackgroundTransparency = 1
dotsLabel.Text              = ""
dotsLabel.TextColor3        = Color3.fromRGB(215, 60, 60)
dotsLabel.TextSize          = 13
dotsLabel.Font              = Enum.Font.GothamBold
dotsLabel.TextXAlignment    = Enum.TextXAlignment.Left
dotsLabel.TextTransparency  = 1
dotsLabel.ZIndex            = 4
dotsLabel.Parent            = container

-- Terminal typing animation for the credits line: types one credit,
-- holds with a blinking cursor, erases it, then types the next one.
local creditsRunning = false

local function typeThenErase(label, text, typeDelay, eraseDelay, holdTime)
    for i = 1, #text do
        if not creditsRunning then return end
        label.Text = string.sub(text, 1, i) .. "▌"
        task.wait(typeDelay)
    end
    if not creditsRunning then return end
    label.Text = text .. "▌"

    local blinkEnd = tick() + holdTime
    local show = true
    while tick() < blinkEnd do
        if not creditsRunning then return end
        task.wait(CONFIG.CursorBlink)
        show = not show
        label.Text = show and (text .. "▌") or text
    end

    for i = #text, 0, -1 do
        if not creditsRunning then return end
        label.Text = string.sub(text, 1, i) .. "▌"
        task.wait(eraseDelay)
    end

    if not creditsRunning then return end
    task.wait(CONFIG.CreditsGapTime)
end

local function startCreditsCycle()
    creditsRunning = true
    task.spawn(function()
        local idx = 1
        while creditsRunning do
            typeThenErase(
                creditsLabel,
                CONFIG.Credits[idx],
                CONFIG.TypeSpeed,
                CONFIG.EraseSpeed,
                CONFIG.CreditsHoldTime
            )
            idx = (idx % #CONFIG.Credits) + 1
        end
    end)
end

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

tw(shadow, {BackgroundTransparency = 0.55}, CONFIG.FadeInSpeed)

fastwait(CONFIG.FadeInSpeed * 0.5)

TweenService:Create(titleLabel, ti, {
    Position        = UDim2.new(0, CONFIG.BarPaddingX, 0, 14),
    TextTransparency = 0
}):Play()
tw(titleStroke, {Transparency = 0.4}, CONFIG.FadeInSpeed)

fastwait(CONFIG.FadeInSpeed * 0.4)

tw(containerStroke, {Transparency = 0},           CONFIG.FadeInSpeed)
tw(barBackground,   {BackgroundTransparency = 0}, CONFIG.FadeInSpeed)
tw(barStroke,       {Transparency = 0},           CONFIG.FadeInSpeed)
tw(barFill,         {BackgroundTransparency = 0}, CONFIG.FadeInSpeed)

tw(creditsLabel, {TextTransparency = 0.15}, CONFIG.FadeInSpeed * 0.6)
startCreditsCycle()

TweenService:Create(statusLabel, ti, {
    Position        = UDim2.new(0, CONFIG.BarPaddingX, 0, 78),
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

    tw(statusLabel, {TextTransparency = 1, Position = UDim2.new(0, CONFIG.BarPaddingX, 0, 72)},
       0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    task.delay(0.15, function()
        statusLabel.Text     = status
        statusLabel.Position = UDim2.new(0, CONFIG.BarPaddingX - 6, 0, 78)

        task.spawn(function()
            task.wait()
            dotsLabel.Position = UDim2.new(
                0, CONFIG.BarPaddingX + statusLabel.TextBounds.X + 2, 0, 78
            )
        end)

        TweenService:Create(statusLabel, progressTI, {
            TextTransparency = 0,
            Position         = UDim2.new(0, CONFIG.BarPaddingX, 0, 78)
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
    creditsRunning = false

    local s = CONFIG.FadeOutSpeed

    tw(containerStroke, {Transparency = 1},           s)
    tw(titleLabel,      {TextTransparency = 1},       s)
    tw(titleStroke,     {Transparency = 1},           s)
    tw(creditsLabel,    {TextTransparency = 1},       s)
    tw(statusLabel,     {TextTransparency = 1},       s)
    tw(percentLabel,    {TextTransparency = 1},       s)
    tw(dotsLabel,       {TextTransparency = 1},       s)
    tw(barBackground,   {BackgroundTransparency = 1}, s)
    tw(barStroke,       {Transparency = 1},           s)
    tw(barFill,         {BackgroundTransparency = 1}, s)
    tw(shadow,          {BackgroundTransparency = 1}, s)

    fastwait(s + 0.05)

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
    -- the more credits there are, the longer the loading takes
    local stepWait = CONFIG.LoadStepWait + (#CONFIG.Credits - 1) * CONFIG.ExtraWaitPerCredit

    task.wait(0.8)

    updateLoader("Loading assets", 30)
    task.wait(stepWait)

    updateLoader("Loading modules", 65)
    task.wait(stepWait)

    -- Check whether the current game is registered before doing anything else
    local currentPlace = game.PlaceId
    local matchedConfig = nil
    for _, v in pairs(getgenv().gamesConfig) do
        if v.placeId == currentPlace then
            matchedConfig = v
            break
        end
    end

    if not matchedConfig then
        updateLoader("Script not found", 100)
        task.wait(0.9)
        tw(statusLabel, {TextTransparency = 1}, 0.3)
        tw(percentLabel, {TextTransparency = 1}, 0.3)
        tw(dotsLabel, {TextTransparency = 1}, 0.3)
        task.wait(0.35)
        loader:Remove()
        return
    end

    updateLoader("Launching WindUI", 100)
    task.wait(0.6)
    tw(statusLabel, {TextTransparency=1}, 0.3)
    tw(percentLabel, {TextTransparency=1}, 0.3)
    tw(dotsLabel, {TextTransparency=1}, 0.3)
    task.wait(0.35)

    -- Load the matched game script, but never let the loader hang for
    -- more than CONFIG.ScriptTimeout seconds
    local scriptLoaded = false
    task.spawn(function()
        pcall(function()
            loadstring(matchedConfig.ConfigScript)()
        end)
        scriptLoaded = true
    end)

    local waited = 0
    while not scriptLoaded and waited < CONFIG.ScriptTimeout do
        task.wait(0.1)
        waited += 0.1
    end

    sound:Play()
    loader:Remove()
end)
