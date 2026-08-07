local _version = "1.6.66"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. _version .. "/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "ExaSaturn",
    Icon = "rbxassetid://74955410184437",
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
    Title = "ExaSaturn Simple Executor",
    Icon = "code",
})

local executor_code = ""

MiscTab:Input({
    Title = "ESE",
    Desc = "",
    Type = "Textarea",
    Placeholder = "print('Hello World')",
    Value = "",
    Locked = false,
    Callback = function(text)
        executor_code = text
    end
})

MiscTab:Space()

MiscTab:Button({
    Title = "Execute",
    Desc = "",
    Locked = false,
    Callback = function()
        if executor_code == "" then
            print("No code to execute")
            return
        end
        
        local func
        if loadstring then
            func = loadstring(executor_code)
        else
            func = load(executor_code)
        end
        
        local success, result = pcall(function()
            return func()
        end)
        
        if success then
            if result then
                print("Result:", result)
            end
        else
            print("Error:", result)
        end
    end
})

MiscTab:Button({
    Title = "Clear",
    Desc = "",
    Locked = false,
    Callback = function()
        executor_code = ""
    end
})

MiscTab:Space()

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

local _cfgName = nil
local _selectedConfig = nil

local function configExists(name)
    if not name or name == "" then return false end
    
    local ConfigManager = Window.ConfigManager
    local ok, configs = pcall(function()
        return ConfigManager:AllConfigs()
    end)

    if ok and type(configs) == "table" then
        for _, v in pairs(configs) do
            if v == name then
                return true
            end
        end
    end
    return false
end

local function isValidName(input)
    if not input then return false end
    return input:match("%S") ~= nil
end

local function showNotification(title, content, icon, duration)
    WindUI:Notify({
        Title = title or "Config Manager",
        Content = content,
        Duration = duration or 5,
        Icon = icon or "folder",
    })
end

local function showConfirmPopup(title, content, onConfirm, onCancel)
    WindUI:Popup({
        Title = title or "Confirmation",
        Icon = "alert-circle",
        Content = content,
        Buttons = {
            {
                Title = "Cancel",
                Callback = function()
                    if onCancel then onCancel() end
                end,
                Variant = "Tertiary",
            },
            {
                Title = "Continue",
                Icon = "arrow-right",
                Callback = function()
                    if onConfirm then onConfirm() end
                end,
                Variant = "Primary",
            }
        }
    })
end

SettingsTab:Input({
    Title = "Config Name",
    Desc = "Enter a new name to save",
    Value = "",
    Placeholder = "Enter config name...",
    Callback = function(input)
        _cfgName = isValidName(input) and input or nil
        _selectedConfig = nil
    end
})

local dropdown = SettingsTab:Dropdown({
    Title = "Saved Configs",
    Desc = "Select an existing configuration",
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
        table.sort(values, function(a, b)
            return tostring(a):lower() < tostring(b):lower()
        end)
        dropdown:Refresh(values)
        return true
    else
        dropdown:Refresh({})
        return false
    end
end

SettingsTab:Button({
    Title = "Refresh",
    Desc = "",
    Callback = function()
        if refreshDropdown() then
            showNotification("Config Manager", "List updated successfully", "folder-sync", 3)
        else
            showNotification("Config Manager", "Error updating list", "alert-circle", 5)
        end
    end
})

SettingsTab:Button({
    Title = "Load",
    Desc = "",
    Callback = function()
        if not _selectedConfig then
            showNotification("Config Manager", "No config selected", "alert-circle", 5)
            return
        end

        local ConfigManager = Window.ConfigManager
        local name = _selectedConfig

        if not configExists(name) then
            _selectedConfig = nil
            showNotification("Config Manager", "Config (" .. name .. ") doesn't exist", "folder-closed", 5)
            return
        end

        local success = pcall(function()
            ConfigManager:CreateConfig(name):Load()
        end)

        if success then
            showNotification("Config Manager", "Config (" .. name .. ") loaded", "folder-input", 3)
        else
            showNotification("Config Manager", "Error loading (" .. name .. ")", "alert-circle", 5)
        end
    end
})

SettingsTab:Button({
    Title = "Save",
    Desc = "",
    Callback = function()
        local ConfigManager = Window.ConfigManager
        local name = _cfgName or _selectedConfig
        
        if not name or name == "" then
            showNotification("Config Manager", "Enter a valid name", "alert-circle", 5)
            return
        end

        if configExists(name) then
            showConfirmPopup(
                "Config Manager - Overwrite Config",
                "The config '" .. name .. "' already exists. Do you want to overwrite it? This action cannot be undone.",
                function()
                    local ok = pcall(function()
                        ConfigManager:CreateConfig(name):Save()
                    end)

                    if ok then
                        _selectedConfig = name
                        _cfgName = nil
                        refreshDropdown()
                        showNotification("Config Manager", "Config (" .. name .. ") overwritten", "folder-open", 3)
                    else
                        showNotification("Config Manager", "Error saving (" .. name .. ")", "alert-circle", 5)
                    end
                end,
                function()
                    showNotification("Config Manager", "Operation cancelled", "x-circle", 3)
                end
            )
        else
            local ok = pcall(function()
                ConfigManager:CreateConfig(name):Save()
            end)

            if ok then
                _selectedConfig = name
                _cfgName = nil
                refreshDropdown()
                showNotification("Config Manager", "Config (" .. name .. ") saved", "folder-open", 3)
            else
                showNotification("Config Manager", "Error saving (" .. name .. ")", "alert-circle", 5)
            end
        end
    end
})

SettingsTab:Button({
    Title = "Delete",
    Desc = "",
    Callback = function()
        if not _selectedConfig then
            showNotification("Config Manager", "No config selected", "alert-circle", 5)
            return
        end

        local ConfigManager = Window.ConfigManager
        local name = _selectedConfig

        showConfirmPopup(
            "Config Manager - Delete Config",
            "Delete config '" .. name .. "'? This action cannot be undone.",
            function()
                local ok = pcall(function()
                    ConfigManager:DeleteConfig(name)
                end)

                if ok then
                    _selectedConfig = nil
                    refreshDropdown()
                    showNotification("Config Manager", "Config (" .. name .. ") deleted", "folder-closed", 3)
                else
                    showNotification("Config Manager", "Error deleting (" .. name .. ")", "alert-circle", 5)
                end
            end,
            function()
                showNotification("Config Manager", "Operation cancelled", "x-circle", 3)
            end
        )
    end
})

refreshDropdown()

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
