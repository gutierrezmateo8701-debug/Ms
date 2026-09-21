--[[
    Rayfield Interface Suite Clone - Full Implementation
    Repository: https://github.com/gutierrezmateo8701-debug/Ms/blob/main/rayfield.lua
]]

local Rayfield = {}
Rayfield.Flags = {}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function Rayfield:CreateWindow(Settings)
    Settings = Settings or {}
    local WindowName = Settings.Name or "Rayfield Interface"
    local LoadingTitle = Settings.LoadingTitle or "Rayfield Interface"
    local LoadingSubtitle = Settings.LoadingSubtitle or "by Shlex & Others"

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RayfieldLibrary"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- Main Window Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 560, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 38)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Position = UDim2.new(0, 12, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = WindowName
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    -- Tabs Container / Sidebar
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 140, 1, -48)
    TabContainer.Position = UDim2.new(0, 8, 0, 44)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollBarThickness = 2
    TabContainer.Parent = MainFrame

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.Parent = TabContainer

    -- Content Pages Area
    local PagesContainer = Instance.new("Folder")
    PagesContainer.Name = "PagesContainer"
    PagesContainer.Parent = MainFrame

    local WindowObj = {}
    local FirstTab = true

    function WindowObj:CreateTab(TabName, TabIcon)
        local Page = Instance.new("ScrollingFrame")
        Page.Name = TabName .. "Page"
        Page.Size = UDim2.new(1, -160, 1, -48)
        Page.Position = UDim2.new(0, 154, 0, 44)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.ScrollBarThickness = 4
        Page.Visible = FirstTab
        Page.Parent = PagesContainer

        local PageListLayout = Instance.new("UIListLayout")
        PageListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageListLayout.Padding = UDim.new(0, 6)
        PageListLayout.Parent = Page

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingRight = UDim.new(0, 8)
        PagePadding.Parent = Page

        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.BackgroundColor3 = FirstTab and Color3.fromRGB(35, 35, 35) or Color3.fromRGB(25, 25, 25)
        TabButton.BorderSizePixel = 0
        TabButton.Text = "  " .. TabName
        TabButton.TextColor3 = FirstTab and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 160)
        TabButton.TextSize = 13
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = TabContainer

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabButton

        TabButton.MouseButton1Click:Connect(function()
            for _, p in pairs(PagesContainer:GetChildren()) do
                p.Visible = false
            end
            for _, b in pairs(TabContainer:GetChildren()) do
                if b:IsA("TextButton") then
                    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                    b.TextColor3 = Color3.fromRGB(160, 160, 160)
                end
            end
            Page.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        FirstTab = false
        local TabObj = {}

        function TabObj:CreateSection(SectionName)
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(1, 0, 0, 24)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = "  " .. string.upper(SectionName)
            SectionLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
            SectionLabel.TextSize = 11
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = Page
        end

        function TabObj:CreateButton(Config)
            Config = Config or {}
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 36)
            Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Btn.BorderSizePixel = 0
            Btn.Text = "  " .. (Config.Name or "Button")
            Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            Btn.TextSize = 12
            Btn.Font = Enum.Font.Gotham
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                if Config.Callback then
                    pcall(Config.Callback)
                end
            end)
        end

        function TabObj:CreateToggle(Config)
            Config = Config or {}
            local Toggled = Config.CurrentValue or false
            if Config.Flag then Rayfield.Flags[Config.Flag] = Toggled end

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 36)
            Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Frame.BorderSizePixel = 0
            Frame.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Frame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Config.Name or "Toggle"
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 12
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local ToggleBox = Instance.new("Frame")
            ToggleBox.Size = UDim2.new(0, 22, 0, 22)
            ToggleBox.Position = UDim2.new(1, -32, 0.5, -11)
            ToggleBox.BackgroundColor3 = Toggled and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(45, 45, 45)
            ToggleBox.BorderSizePixel = 0
            ToggleBox.Parent = Frame

            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 4)
            BoxCorner.Parent = ToggleBox

            Frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Toggled = not Toggled
                    ToggleBox.BackgroundColor3 = Toggled and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(45, 45, 45)
                    if Config.Flag then Rayfield.Flags[Config.Flag] = Toggled end
                    if Config.Callback then
                        pcall(function() Config.Callback(Toggled) end)
                    end
                end
            end)
        end

        function TabObj:CreateSlider(Config)
            Config = Config or {}
            local Min = Config.Range and Config.Range[1] or 0
            local Max = Config.Range and Config.Range[2] or 100
            local Current = Config.CurrentValue or Min
            if Config.Flag then Rayfield.Flags[Config.Flag] = Current end

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 52)
            Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Frame.BorderSizePixel = 0
            Frame.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Frame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 0, 24)
            Label.Position = UDim2.new(0, 12, 0, 4)
            Label.BackgroundTransparency = 1
            Label.Text = (Config.Name or "Slider") .. ": " .. tostring(Current)
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 12
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -24, 0, 6)
            SliderBar.Position = UDim2.new(0, 12, 0, 36)
            SliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = Frame

            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(0, 3)
            BarCorner.Parent = SliderBar

            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((Current - Min) / (Max - Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(0, 3)
            FillCorner.Parent = SliderFill

            local function UpdateSlider(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
                SliderFill.Size = pos
                local val = math.floor(Min + ((Max - Min) * pos.X.Scale))
                Label.Text = (Config.Name or "Slider") .. ": " .. tostring(val)
                if Config.Flag then Rayfield.Flags[Config.Flag] = val end
                if Config.Callback then pcall(function() Config.Callback(val) end) end
            end

            local Sliding = false
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = true
                    UpdateSlider(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if Sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = false
                end
            end)
        end

        function TabObj:CreateDropdown(Config)
            Config = Config or {}
            local Current = Config.CurrentOption or (Config.Options and Config.Options[1]) or ""
            if Config.Flag then Rayfield.Flags[Config.Flag] = Current end

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 36)
            Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Frame.BorderSizePixel = 0
            Frame.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Frame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = (Config.Name or "Dropdown") .. " [ " .. tostring(Current) .. " ]"
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 12
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local idx = 1
            Frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and Config.Options and #Config.Options > 0 then
                    idx = idx % #Config.Options + 1
                    Current = Config.Options[idx]
                    Label.Text = (Config.Name or "Dropdown") .. " [ " .. tostring(Current) .. " ]"
                    if Config.Flag then Rayfield.Flags[Config.Flag] = Current end
                    if Config.Callback then pcall(function() Config.Callback(Current) end) end
                end
            end)
        end

        function TabObj:CreateColorPicker(Config)
            Config = Config or {}
            local Color = Config.Color or Color3.fromRGB(255, 255, 255)
            if Config.Flag then Rayfield.Flags[Config.Flag] = Color end

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 36)
            Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Frame.BorderSizePixel = 0
            Frame.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Frame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Config.Name or "Color Picker"
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 12
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local Preview = Instance.new("Frame")
            Preview.Size = UDim2.new(0, 24, 0, 20)
            Preview.Position = UDim2.new(1, -34, 0.5, -10)
            Preview.BackgroundColor3 = Color
            Preview.BorderSizePixel = 0
            Preview.Parent = Frame

            local PrevCorner = Instance.new("UICorner")
            PrevCorner.CornerRadius = UDim.new(0, 4)
            PrevCorner.Parent = Preview
        end

        function TabObj:CreateKeybind(Config)
            Config = Config or {}
            local CurrentKey = Config.CurrentKeybind or "F"
            if Config.Flag then Rayfield.Flags[Config.Flag] = CurrentKey end

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 36)
            Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Frame.BorderSizePixel = 0
            Frame.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Frame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -70, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Config.Name or "Keybind"
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 12
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local KeyLabel = Instance.new("TextLabel")
            KeyLabel.Size = UDim2.new(0, 50, 0, 22)
            KeyLabel.Position = UDim2.new(1, -60, 0.5, -11)
            KeyLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            KeyLabel.Text = tostring(CurrentKey)
            KeyLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            KeyLabel.TextSize = 11
            KeyLabel.Font = Enum.Font.GothamBold
            KeyLabel.Parent = Frame

            local KeyCorner = Instance.new("UICorner")
            KeyCorner.CornerRadius = UDim.new(0, 4)
            KeyCorner.Parent = KeyLabel
        end

        function TabObj:CreateInput(Config)
            Config = Config or {}
            local CurrentVal = Config.CurrentValue or ""
            if Config.Flag then Rayfield.Flags[Config.Flag] = CurrentVal end

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 36)
            Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Frame.BorderSizePixel = 0
            Frame.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Frame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -120, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Config.Name or "Input"
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 12
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(0, 100, 0, 24)
            TextBox.Position = UDim2.new(1, -110, 0.5, -12)
            TextBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            TextBox.Text = CurrentVal
            TextBox.PlaceholderText = Config.PlaceholderText or "Escribe aquí..."
            TextBox.TextColor3 = Color3.fromRGB(220, 220, 220)
            TextBox.TextSize = 11
            TextBox.Font = Enum.Font.Gotham
            TextBox.Parent = Frame

            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 4)
            BoxCorner.Parent = TextBox

            TextBox.FocusLost:Connect(function(enter)
                if enter then
                    local val = TextBox.Text
                    if Config.Flag then Rayfield.Flags[Config.Flag] = val end
                    if Config.Callback then pcall(function() Config.Callback(val) end) end
                end
            end)
        end

        return TabObj
    end

    function Rayfield:Notify(Config)
        Config = Config or {}
        print("[Rayfield Notification] " .. tostring(Config.Title) .. ": " .. tostring(Config.Content))
    end

    return WindowObj
end

return Rayfield
