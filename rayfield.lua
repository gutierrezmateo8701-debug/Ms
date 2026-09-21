--[[
    Rayfield Interface Suite Clone - Advanced Functional Version
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

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RayfieldAdvancedGui"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- Ventana Principal (Tamaño compacto y moderno: 480x300)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 480, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -240, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    -- Barra Superior
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 10)
    TopCorner.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 12, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = WindowName
    TitleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    TitleLabel.TextSize = 13
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    -- Botón Minimizar / Cerrar
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 25, 0, 25)
    CloseBtn.Position = UDim2.new(1, -30, 0.5, -12.5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 11
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TopBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local Minimized = false
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
    MinimizeBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 13
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = TopBar

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinimizeBtn

    MinimizeBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        local targetSize = Minimized and UDim2.new(0, 480, 0, 35) or UDim2.new(0, 480, 0, 300)
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    end)

    -- Sistema de arrastre (Draggable)
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- Contenedor de Pestañas (Sidebar)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(0, 120, 1, -45)
    TabContainer.Position = UDim2.new(0, 6, 0, 39)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollBarThickness = 2
    TabContainer.Parent = MainFrame

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 3)
    TabListLayout.Parent = TabContainer

    local PagesContainer = Instance.new("Folder")
    PagesContainer.Parent = MainFrame

    local WindowObj = {}
    local FirstTab = true

    function WindowObj:CreateTab(TabName)
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, -136, 1, -45)
        Page.Position = UDim2.new(0, 132, 0, 39)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.ScrollBarThickness = 3
        Page.Visible = FirstTab
        Page.Parent = PagesContainer

        local PageListLayout = Instance.new("UIListLayout")
        PageListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageListLayout.Padding = UDim.new(0, 5)
        PageListLayout.Parent = Page

        PageListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageListLayout.AbsoluteContentSize.Y + 10)
        end)

        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 28)
        TabButton.BackgroundColor3 = FirstTab and Color3.fromRGB(35, 35, 35) or Color3.fromRGB(20, 20, 20)
        TabButton.BorderSizePixel = 0
        TabButton.Text = "  " .. TabName
        TabButton.TextColor3 = FirstTab and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
        TabButton.TextSize = 12
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = TabContainer

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 5)
        TabCorner.Parent = TabButton

        TabButton.MouseButton1Click:Connect(function()
            for _, p in pairs(PagesContainer:GetChildren()) do p.Visible = false end
            for _, b in pairs(TabContainer:GetChildren()) do
                if b:IsA("TextButton") then
                    TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 20), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                end
            end
            Page.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)

        FirstTab = false
        local TabObj = {}

        function TabObj:CreateSection(Name)
            local Sec = Instance.new("TextLabel")
            Sec.Size = UDim2.new(1, 0, 0, 20)
            Sec.BackgroundTransparency = 1
            Sec.Text = "  " .. string.upper(Name)
            Sec.TextColor3 = Color3.fromRGB(100, 100, 100)
            Sec.TextSize = 10
            Sec.Font = Enum.Font.GothamBold
            Sec.TextXAlignment = Enum.TextXAlignment.Left
            Sec.Parent = Page
        end

        function TabObj:CreateButton(Config)
            Config = Config or {}
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -6, 0, 30)
            Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Btn.BorderSizePixel = 0
            Btn.Text = "  " .. (Config.Name or "Button")
            Btn.TextColor3 = Color3.fromRGB(210, 210, 210)
            Btn.TextSize = 11
            Btn.Font = Enum.Font.Gotham
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 5)
            Corner.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 22)}):Play()
                if Config.Callback then pcall(Config.Callback) end
            end)
        end

        function TabObj:CreateToggle(Config)
            Config = Config or {}
            local Toggled = Config.CurrentValue or false
            if Config.Flag then Rayfield.Flags[Config.Flag] = Toggled end

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -6, 0, 30)
            Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Frame.BorderSizePixel = 0
            Frame.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 5)
            Corner.Parent = Frame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -45, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Config.Name or "Toggle"
            Label.TextColor3 = Color3.fromRGB(210, 210, 210)
            Label.TextSize = 11
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local ToggleBox = Instance.new("Frame")
            ToggleBox.Size = UDim2.new(0, 18, 0, 18)
            ToggleBox.Position = UDim2.new(1, -26, 0.5, -9)
            ToggleBox.BackgroundColor3 = Toggled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 40)
            ToggleBox.BorderSizePixel = 0
            ToggleBox.Parent = Frame

            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 4)
            BoxCorner.Parent = ToggleBox

            Frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Toggled = not Toggled
                    TweenService:Create(ToggleBox, TweenInfo.new(0.2), {BackgroundColor3 = Toggled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 40)}):Play()
                    if Config.Flag then Rayfield.Flags[Config.Flag] = Toggled end
                    if Config.Callback then pcall(function() Config.Callback(Toggled) end) end
                end
            end)
        end

        function TabObj:CreateSlider(Config)
            Config = Config or {}
            local Min, Max = Config.Range[1], Config.Range[2]
            local Current = Config.CurrentValue or Min
            if Config.Flag then Rayfield.Flags[Config.Flag] = Current end

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -6, 0, 42)
            Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Frame.BorderSizePixel = 0
            Frame.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 5)
            Corner.Parent = Frame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -15, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 2)
            Label.BackgroundTransparency = 1
            Label.Text = (Config.Name or "Slider") .. ": " .. tostring(Current)
            Label.TextColor3 = Color3.fromRGB(210, 210, 210)
            Label.TextSize = 11
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -20, 0, 5)
            SliderBar.Position = UDim2.new(0, 10, 0, 28)
            SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = Frame

            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(0, 2)
            BarCorner.Parent = SliderBar

            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((Current - Min) / (Max - Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(0, 2)
            FillCorner.Parent = SliderFill

            local function Update(input)
                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                local val = math.floor(Min + ((Max - Min) * pos))
                Label.Text = (Config.Name or "Slider") .. ": " .. tostring(val)
                if Config.Flag then Rayfield.Flags[Config.Flag] = val end
                if Config.Callback then pcall(function() Config.Callback(val) end) end
            end

            local Sliding = false
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then Sliding = true Update(input) end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if Sliding and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then Sliding = false end
            end)
        end

        function TabObj:CreateInput(Config)
            Config = Config or {}
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -6, 0, 30)
            Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Frame.BorderSizePixel = 0
            Frame.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 5)
            Corner.Parent = Frame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -110, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Config.Name or "Input"
            Label.TextColor3 = Color3.fromRGB(210, 210, 210)
            Label.TextSize = 11
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(0, 95, 0, 20)
            TextBox.Position = UDim2.new(1, -100, 0.5, -10)
            TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            TextBox.Text = Config.CurrentValue or ""
            TextBox.PlaceholderText = Config.PlaceholderText or "Escribe..."
            TextBox.TextColor3 = Color3.fromRGB(210, 210, 210)
            TextBox.TextSize = 10
            TextBox.Font = Enum.Font.Gotham
            TextBox.Parent = Frame

            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 4)
            BoxCorner.Parent = TextBox

            TextBox.FocusLost:Connect(function(enter)
                if enter then
                    if Config.Flag then Rayfield.Flags[Config.Flag] = TextBox.Text end
                    if Config.Callback then pcall(function() Config.Config(TextBox.Text) end) end
                end
            end)
        end

        return TabObj
    end

    function Rayfield:Notify(Config)
        Config = Config or {}
        local NotifGui = ScreenGui:FindFirstChild("NotifContainer") or Instance.new("Frame", ScreenGui)
        NotifGui.Name = "NotifContainer"
        NotifGui.Size = UDim2.new(0, 220, 1, 0)
        NotifGui.Position = UDim2.new(1, -230, 0, 0)
        NotifGui.BackgroundTransparency = 1

        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(1, 0, 0, 50)
        Card.Position = UDim2.new(1, 0, 0.85, -(#NotifGui:GetChildren() * 55))
        Card.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Card.Parent = NotifGui

        local CCorner = Instance.new("UICorner")
        CCorner.CornerRadius = UDim.new(0, 6)
        CCorner.Parent = Card

        local TLabel = Instance.new("TextLabel")
        TLabel.Size = UDim2.new(1, -10, 0, 20)
        TLabel.Position = UDim2.new(0, 8, 0, 4)
        TLabel.BackgroundTransparency = 1
        TLabel.Text = Config.Title or "Notificación"
        TLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TLabel.TextSize = 11
        TLabel.Font = Enum.Font.GothamBold
        TLabel.TextXAlignment = Enum.TextXAlignment.Left
        TLabel.Parent = Card

        local CLabel = Instance.new("TextLabel")
        CLabel.Size = UDim2.new(1, -10, 0, 20)
        CLabel.Position = UDim2.new(0, 8, 0, 22)
        CLabel.BackgroundTransparency = 1
        CLabel.Text = Config.Content or ""
        CLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        CLabel.TextSize = 10
        CLabel.Font = Enum.Font.Gotham
        CLabel.TextXAlignment = Enum.TextXAlignment.Left
        CLabel.Parent = Card

        TweenService:Create(Card, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, Card.Position.Y.Scale, Card.Position.Y.Offset)}):Play()

        task.delay(Config.Duration or 3, function()
            TweenService:Create(Card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 50, Card.Position.Y.Scale, Card.Position.Y.Offset)}):Play()
            task.wait(0.3)
            Card:Destroy()
        end)
    end

    return WindowObj
end

return Rayfield
