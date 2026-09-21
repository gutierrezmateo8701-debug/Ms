-- [ obfuscated with basic string/var mangling ]
local _G_Rayfield = {}
local _U_CoreGui = game:GetService("CoreGui")
local _U_Players = game:GetService("Players")
_G_Rayfield.Flags = {}

function _G_Rayfield:CreateWindow(s)
    s = s or {}
    local n = s.Name or "Rayfield Window"
    local g = Instance.new("ScreenGui")
    g.Name, g.ZIndexBehavior = "RayfieldClone", Enum.ZIndexBehavior.Sibling
    pcall(function() g.Parent = _U_CoreGui end)
    if not g.Parent then g.Parent = _U_Players.LocalPlayer:WaitForChild("PlayerGui") end

    local f = Instance.new("Frame")
    f.Size, f.Position, f.BackgroundColor3, f.BorderSizePixel = UDim2.new(0, 550, 0, 400), UDim2.new(0.5, -275, 0.5, -200), Color3.fromRGB(18, 18, 18), 0
    f.Parent = g

    local c = Instance.new("UICorner")
    c.CornerRadius, c.Parent = UDim.new(0, 8), f

    local w = {}
    function w:CreateTab(t)
        local o = {}
        function o:CreateSection(x) end
        function o:CreateButton(cfg) cfg = cfg or {} if cfg.Callback then pcall(cfg.Callback) end end
        function o:CreateToggle(cfg) cfg = cfg or {} if cfg.Flag then _G_Rayfield.Flags[cfg.Flag] = cfg.CurrentValue end end
        function o:CreateSlider(cfg) cfg = cfg or {} if cfg.Flag then _G_Rayfield.Flags[cfg.Flag] = cfg.CurrentValue end end
        function o:CreateDropdown(cfg) cfg = cfg or {} if cfg.Flag then _G_Rayfield.Flags[cfg.Flag] = cfg.CurrentOption end end
        function o:CreateColorPicker(cfg) cfg = cfg or {} if cfg.Flag then _G_Rayfield.Flags[cfg.Flag] = cfg.Color end end
        function o:CreateKeybind(cfg) cfg = cfg or {} if cfg.Flag then _G_Rayfield.Flags[cfg.Flag] = cfg.CurrentKeybind end end
        function o:CreateInput(cfg) cfg = cfg or {} if cfg.Flag then _G_Rayfield.Flags[cfg.Flag] = cfg.CurrentValue end end
        return o
    end

    function _G_Rayfield:Notify(cfg)
        print("[Notification]: " .. tostring(cfg.Title) .. " - " .. tostring(cfg.Content))
    end

    return w
end

return _G_Rayfield
