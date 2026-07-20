local _version = "1.6.66"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. _version .. "/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "ExaSaturn",
    Icon = "hexagon",
    Author = "none",
    Folder = "ExaSaturn",
    Transparent = true,
    Theme = "Crimson",
    NewElements = true,
    ElementRadius = 13,
    Resizable = true,
    HideSearchBar = false,
    ScrollBarEnabled = true
})

Window:SetToggleKey(Enum.KeyCode.G)

Window:Tag({
    Title = "V0.1",
    Color = Color3.fromHex("#990000"),
    Radius = 13,
})

Window:EditOpenButton({
    Title = "ExaSaturn",
    Icon = "shield-cog-corner",
    CornerRadius = UDim.new(0,50),
    StrokeThickness = 1,
    Color = ColorSequence.new(
        Color3.fromHex("FF0000"),
        Color3.fromHex("000080")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

local MainTab = Window:Tab({ Title = "Main", Icon = "star", Locked = false, })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "folder", Locked = false, })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "cog", Locked = false, })

MainTab:Paragraph({
    Title = "Open or Minimize UI IN PC",
    Desc = "PRESS G in your keyboard to open the ui or minimize the ui in pc",
    Color = "Green",
    Locked = false,
})

MainTab:Space()

MainTab:Section({
    Title = "Interface Customization",
    Icon = "brush",
})

MainTab:Dropdown({
    Title = "Theme",
    Values = { "Rose","Light","MonokaiPro","Plant","Midnight","CottonCandy","Dark","Indigo","Sky","Crimson","Amber","Violet","Red" },
    Value = "Crimson",
    Callback = function(option)
        WindUI:SetTheme(option)
    end
})

MainTab:Toggle({
    Title = "Transparency",
    Icon = "palette",
    Value = true,
    Callback = function(state)
        Window:ToggleTransparency(state)
    end
})

MainTab:Section({
    Title = "User Profile",
    Icon = "shield-user",
})

MainTab:Toggle({
    Title = "Profile icon",
    Desc = "Your profile on your left down",
    Icon = "user",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        local stateinfo = state
        if stateinfo then
            Window.User:Enable()
        else
            Window.User:Disable()
        end
    end
})

MainTab:Toggle({
    Title = "Set profile anonymous",
    Desc = "Your profile on your left down",
    Icon = "hat-glasses",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        local stateinfo = state
        if stateinfo then
            Window.User:SetAnonymous(true)
        else
            Window.User:SetAnonymous(false)
        end
    end
})

MiscTab:Section({
    Title = "External Scripts",
    Icon = "folder-open",
})

MiscTab:Button({
    Title = "Infinite yield",
    Icon = "file",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

MiscTab:Button({
    Title = "Dex explorer",
    Icon = "file",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end
})

MiscTab:Button({
    Title = "Dex plus",
    Icon = "file",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/uuuuuuu/refs/heads/main/DexPlusBackup.luau"))()
    end
})



SettingsTab:Section({
    Title = "General Settings",
    Icon = "cog",
})

SettingsTab:Input({
    Title = "Config name",
    Desc = "",
    Value = "",
    Placeholder = "Enter config name...",
    Callback = function(input)
        _cfgName = input and input:match("%S") and input or nil
        _selectedConfig = nil
    end
})

local dropdown = SettingsTab:Dropdown({
    Title = "Configs",
    Desc = "",
    Values = {},
    Value = nil,
    Callback = function(option)
        _selectedConfig = option
        _cfgName = nil
    end
})

local function refreshDropdown()
    local ConfigManager = Window.ConfigManager
    local ok, values = pcall(function()
        return ConfigManager:AllConfigs()
    end)

    if ok and type(values) == "table" then
        table.sort(values, function(a,b)
            return tostring(a):lower() < tostring(b):lower()
        end)
        dropdown:Refresh(values)
    else
        dropdown:Refresh({})
    end
end

SettingsTab:Button({
    Title = "Refresh",
    Desc = "",
    Callback = function()
        refreshDropdown()

        WindUI:Notify({
            Title = "Config Manager",
            Content = "Dropdown refreshed",
            Duration = 5,
            Icon = "folder-sync",
        })
    end
})

SettingsTab:Button({
    Title = "Load",
    Desc = "",
    Callback = function()
        if not _selectedConfig then return end

        local ConfigManager = Window.ConfigManager
        local name = _selectedConfig

        local exists = false
        local ok, configs = pcall(function()
            return ConfigManager:AllConfigs()
        end)

        if ok and type(configs) == "table" then
            for _,v in pairs(configs) do
                if v == name then
                    exists = true
                    break
                end
            end
        end

        if not exists then
            _selectedConfig = nil

            WindUI:Notify({
                Title = "Config Manager",
                Content = "Configuration (" .. name .. ") doesn't exist",
                Duration = 5,
                Icon = "folder-closed",
            })

            return
        end

        local success = pcall(function()
            ConfigManager:CreateConfig(name):Load()
        end)

        if success then
            WindUI:Notify({
                Title = "Config Manager",
                Content = "Configuration (" .. name .. ") loaded",
                Duration = 5,
                Icon = "folder-input",
            })
        end
    end
})

SettingsTab:Button({
    Title = "Save",
    Desc = "",
    Callback = function()
        local ConfigManager = Window.ConfigManager
        local name = _cfgName or _selectedConfig
        if not name or name == "" then return end

        local ok = pcall(function()
            ConfigManager:CreateConfig(name):Save()
        end)

        if ok then
            _selectedConfig = name
            _cfgName = nil

            refreshDropdown()

            WindUI:Notify({
                Title = "Config Manager",
                Content = "Configuration (" .. name .. ") saved",
                Duration = 5,
                Icon = "folder-open",
            })
        end
    end
})

SettingsTab:Button({
    Title = "Delete",
    Desc = "",
    Callback = function()
        if not _selectedConfig then return end

        local ConfigManager = Window.ConfigManager
        local name = _selectedConfig

        local ok = pcall(function()
            ConfigManager:DeleteConfig(name)
        end)

        if ok then
            _selectedConfig = nil

            refreshDropdown()

            WindUI:Notify({
                Title = "Config Manager",
                Content = "Configuration (" .. name .. ") deleted",
                Duration = 5,
                Icon = "folder-closed",
            })
        end
    end
})

SettingsTab:Section({
    Title = "Minor Settings",
    Icon = "cog",
})

SettingsTab:Button({
    Title = "ServerHop",
    Desc = "",
    Locked = false,
    Callback = function()

        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")

        TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)

    end
})

SettingsTab:Button({
    Title = "Rejoin",
    Desc = "",
    Locked = false,
    Callback = function()

        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")

        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)

    end
})

WindUI:Notify({
    Title = "ExaSaturn",
    Content = "Welcome! We're glad to have you here. Enjoy your experience!",
    Icon = "sparkles",
    Duration = 5,
})
