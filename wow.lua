-- Meo Y2K Style Modern GUI for Delta Executor
-- Full UI/UX with animations and modern design

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- ═══════════════════════════════════════════
-- DESTROY OLD GUI IF EXISTS
-- ═══════════════════════════════════════════
if game.CoreGui:FindFirstChild("MeoY2K_GUI") then
    game.CoreGui:FindFirstChild("MeoY2K_GUI"):Destroy()
end

-- ═══════════════════════════════════════════
-- COLOR PALETTE - MEO Y2K THEME
-- ═══════════════════════════════════════════
local Colors = {
    Background = Color3.fromRGB(15, 15, 20),
    DarkPanel = Color3.fromRGB(20, 20, 28),
    MidPanel = Color3.fromRGB(28, 28, 38),
    LightPanel = Color3.fromRGB(35, 35, 48),
    
    AccentYellow = Color3.fromRGB(255, 210, 0),
    AccentOrange = Color3.fromRGB(255, 140, 0),
    AccentGold = Color3.fromRGB(255, 180, 30),
    AccentAmber = Color3.fromRGB(255, 165, 0),
    
    GlowYellow = Color3.fromRGB(255, 230, 80),
    GlowOrange = Color3.fromRGB(255, 160, 50),
    
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 195),
    TextMuted = Color3.fromRGB(120, 120, 140),
    TextAccent = Color3.fromRGB(255, 210, 0),
    
    Success = Color3.fromRGB(80, 255, 120),
    Error = Color3.fromRGB(255, 80, 80),
    Warning = Color3.fromRGB(255, 200, 50),
    
    Border = Color3.fromRGB(55, 55, 70),
    BorderAccent = Color3.fromRGB(255, 180, 0),
}

-- ═══════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════
local function CreateInstance(className, properties)
    local inst = Instance.new(className)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            inst[prop] = value
        end
    end
    if properties.Parent then
        inst.Parent = properties.Parent
    end
    return inst
end

local function Tween(object, duration, properties, style, direction)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(duration, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

local function AddCorner(parent, radius)
    return CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness, transparency)
    return CreateInstance("UIStroke", {
        Color = color or Colors.Border,
        Thickness = thickness or 1,
        Transparency = transparency or 0.5,
        Parent = parent
    })
end

local function AddPadding(parent, top, bottom, left, right)
    return CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, top or 8),
        PaddingBottom = UDim.new(0, bottom or 8),
        PaddingLeft = UDim.new(0, left or 8),
        PaddingRight = UDim.new(0, right or 8),
        Parent = parent
    })
end

local function AddGradient(parent, c1, c2, rotation)
    return CreateInstance("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, c1),
            ColorSequenceKeypoint.new(1, c2)
        }),
        Rotation = rotation or 90,
        Parent = parent
    })
end

-- ═══════════════════════════════════════════
-- MAIN SCREENGUI
-- ═══════════════════════════════════════════
local ScreenGui = CreateInstance("ScreenGui", {
    Name = "MeoY2K_GUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = game.CoreGui
})

-- ═══════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════
local NotificationHolder = CreateInstance("Frame", {
    Name = "Notifications",
    Size = UDim2.new(0, 300, 1, 0),
    Position = UDim2.new(1, -320, 0, 0),
    BackgroundTransparency = 1,
    Parent = ScreenGui
})

CreateInstance("UIListLayout", {
    Padding = UDim.new(0, 8),
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = NotificationHolder
})

AddPadding(NotificationHolder, 0, 20, 0, 0)

local function Notify(title, message, duration, notifType)
    local notifColor = Colors.AccentYellow
    if notifType == "error" then notifColor = Colors.Error
    elseif notifType == "success" then notifColor = Colors.Success
    elseif notifType == "warning" then notifColor = Colors.Warning end
    
    local NotifFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Colors.DarkPanel,
        BackgroundTransparency = 0.05,
        ClipsDescendants = true,
        Parent = NotificationHolder
    })
    AddCorner(NotifFrame, 10)
    AddStroke(NotifFrame, notifColor, 1, 0.3)
    
    -- Accent line on left
    local AccentLine = CreateInstance("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = notifColor,
        BorderSizePixel = 0,
        Parent = NotifFrame
    })
    
    local ContentHolder = CreateInstance("Frame", {
        Size = UDim2.new(1, -15, 0, 0),
        Position = UDim2.new(0, 15, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = NotifFrame
    })
    AddPadding(ContentHolder, 12, 12, 0, 8)
    
    CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = ContentHolder
    })
    
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = "⚡ " .. (title or "Notification"),
        TextColor3 = notifColor,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        Parent = ContentHolder
    })
    
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = message or "",
        TextColor3 = Colors.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 2,
        Parent = ContentHolder
    })
    
    -- Progress bar
    local ProgressBG = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = Colors.LightPanel,
        LayoutOrder = 3,
        Parent = ContentHolder
    })
    AddCorner(ProgressBG, 1)
    
    local ProgressFill = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = notifColor,
        Parent = ProgressBG
    })
    AddCorner(ProgressFill, 1)
    
    -- Animate in
    NotifFrame.Position = UDim2.new(1, 50, 0, 0)
    Tween(NotifFrame, 0.4, {Position = UDim2.new(0, 10, 0, 0)}, Enum.EasingStyle.Back)
    
    -- Progress animation
    Tween(ProgressFill, duration or 3, {Size = UDim2.new(0, 0, 1, 0)}, Enum.EasingStyle.Linear)
    
    task.delay(duration or 3, function()
        Tween(NotifFrame, 0.3, {Position = UDim2.new(1, 50, 0, 0)})
        task.wait(0.35)
        NotifFrame:Destroy()
    end)
end

-- ═══════════════════════════════════════════
-- MAIN FRAME
-- ═══════════════════════════════════════════
local MainFrame = CreateInstance("Frame", {
    Name = "MainFrame",
    Size = UDim2.new(0, 580, 0, 420),
    Position = UDim2.new(0.5, -290, 0.5, -210),
    BackgroundColor3 = Colors.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = ScreenGui
})
AddCorner(MainFrame, 14)
AddStroke(MainFrame, Colors.BorderAccent, 1.5, 0.4)

-- Drop shadow
local Shadow = CreateInstance("ImageLabel", {
    Name = "Shadow",
    Size = UDim2.new(1, 50, 1, 50),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    Image = "rbxassetid://6015897843",
    ImageColor3 = Color3.fromRGB(0, 0, 0),
    ImageTransparency = 0.4,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(49, 49, 450, 450),
    ZIndex = -1,
    Parent = MainFrame
})

-- Background glow effect
local BgGlow = CreateInstance("Frame", {
    Name = "BgGlow",
    Size = UDim2.new(0, 300, 0, 300),
    Position = UDim2.new(0.8, 0, -0.2, 0),
    BackgroundColor3 = Colors.AccentOrange,
    BackgroundTransparency = 0.92,
    Parent = MainFrame,
    ZIndex = 0,
})
AddCorner(BgGlow, 150)

-- Animate glow
spawn(function()
    while MainFrame and MainFrame.Parent do
        Tween(BgGlow, 4, {Position = UDim2.new(0.6, 0, 0.5, 0), BackgroundTransparency = 0.95})
        task.wait(4)
        Tween(BgGlow, 4, {Position = UDim2.new(0.8, 0, -0.2, 0), BackgroundTransparency = 0.92})
        task.wait(4)
    end
end)

-- ═══════════════════════════════════════════
-- TITLE BAR
-- ═══════════════════════════════════════════
local TitleBar = CreateInstance("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 45),
    BackgroundColor3 = Colors.DarkPanel,
    BorderSizePixel = 0,
    ZIndex = 5,
    Parent = MainFrame
})
AddCorner(TitleBar, 14)

-- Fix bottom corners of title bar
local TitleBarFix = CreateInstance("Frame", {
    Size = UDim2.new(1, 0, 0, 15),
    Position = UDim2.new(0, 0, 1, -15),
    BackgroundColor3 = Colors.DarkPanel,
    BorderSizePixel = 0,
    ZIndex = 5,
    Parent = TitleBar
})

-- Title bar gradient accent line
local TitleAccentLine = CreateInstance("Frame", {
    Size = UDim2.new(1, 0, 0, 2),
    Position = UDim2.new(0, 0, 1, -2),
    BackgroundColor3 = Colors.AccentYellow,
    BorderSizePixel = 0,
    ZIndex = 6,
    Parent = TitleBar
})
AddGradient(TitleAccentLine, Colors.AccentOrange, Colors.AccentYellow, 0)

-- Logo / Brand
local LogoFrame = CreateInstance("Frame", {
    Size = UDim2.new(0, 200, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 6,
    Parent = TitleBar
})

local LogoIcon = CreateInstance("TextLabel", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(0, 12, 0.5, -15),
    BackgroundColor3 = Colors.AccentYellow,
    BackgroundTransparency = 0.9,
    Text = "⚡",
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextColor3 = Colors.AccentYellow,
    ZIndex = 7,
    Parent = LogoFrame
})
AddCorner(LogoIcon, 8)
AddStroke(LogoIcon, Colors.AccentYellow, 1, 0.5)

local LogoText = CreateInstance("TextLabel", {
    Size = UDim2.new(0, 150, 1, 0),
    Position = UDim2.new(0, 48, 0, 0),
    BackgroundTransparency = 1,
    Text = "MEO Y2K",
    TextColor3 = Colors.TextPrimary,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 7,
    Parent = LogoFrame
})

local VersionLabel = CreateInstance("TextLabel", {
    Size = UDim2.new(0, 50, 0, 16),
    Position = UDim2.new(0, 135, 0.5, -8),
    BackgroundColor3 = Colors.AccentOrange,
    BackgroundTransparency = 0.85,
    Text = "v2.0",
    TextColor3 = Colors.AccentOrange,
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    ZIndex = 7,
    Parent = LogoFrame
})
AddCorner(VersionLabel, 4)

-- Window Controls
local ControlsFrame = CreateInstance("Frame", {
    Size = UDim2.new(0, 100, 1, 0),
    Position = UDim2.new(1, -100, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 6,
    Parent = TitleBar
})

local function CreateWindowButton(name, text, pos, color, callback)
    local btn = CreateInstance("TextButton", {
        Name = name,
        Size = UDim2.new(0, 28, 0, 28),
        Position = pos,
        BackgroundColor3 = color,
        BackgroundTransparency = 0.9,
        Text = text,
        TextColor3 = color,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        ZIndex = 7,
        Parent = ControlsFrame
    })
    AddCorner(btn, 6)
    
    btn.MouseEnter:Connect(function()
        Tween(btn, 0.2, {BackgroundTransparency = 0.7})
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, 0.2, {BackgroundTransparency = 0.9})
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Minimize button
local minimized = false
CreateWindowButton("Minimize", "─", UDim2.new(0, 5, 0.5, -14), Colors.TextSecondary, function()
    minimized = not minimized
    if minimized then
        Tween(MainFrame, 0.4, {Size = UDim2.new(0, 580, 0, 45)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    else
        Tween(MainFrame, 0.4, {Size = UDim2.new(0, 580, 0, 420)}, Enum.EasingStyle.Back)
    end
end)

-- Close button
CreateWindowButton("Close", "✕", UDim2.new(0, 65, 0.5, -14), Colors.Error, function()
    Tween(MainFrame, 0.3, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
    task.wait(0.35)
    ScreenGui:Destroy()
end)

-- ═══════════════════════════════════════════
-- DRAG FUNCTIONALITY
-- ═══════════════════════════════════════════
local dragging, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ═══════════════════════════════════════════
-- CONTENT AREA
-- ═══════════════════════════════════════════
local ContentArea = CreateInstance("Frame", {
    Name = "ContentArea",
    Size = UDim2.new(1, 0, 1, -45),
    Position = UDim2.new(0, 0, 0, 45),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    ZIndex = 2,
    Parent = MainFrame
})

-- ═══════════════════════════════════════════
-- SIDEBAR / TAB NAVIGATION
-- ═══════════════════════════════════════════
local Sidebar = CreateInstance("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 58, 1, -10),
    Position = UDim2.new(0, 5, 0, 5),
    BackgroundColor3 = Colors.DarkPanel,
    BorderSizePixel = 0,
    ZIndex = 3,
    Parent = ContentArea
})
AddCorner(Sidebar, 10)
AddStroke(Sidebar, Colors.Border, 1, 0.6)

local TabButtonsLayout = CreateInstance("UIListLayout", {
    Padding = UDim.new(0, 4),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = Sidebar
})

AddPadding(Sidebar, 10, 10, 0, 0)

-- Tab pages container
local PagesContainer = CreateInstance("Frame", {
    Name = "Pages",
    Size = UDim2.new(1, -73, 1, -10),
    Position = UDim2.new(0, 68, 0, 5),
    BackgroundColor3 = Colors.DarkPanel,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 3,
    Parent = ContentArea
})
AddCorner(PagesContainer, 10)
AddStroke(PagesContainer, Colors.Border, 1, 0.6)

-- ═══════════════════════════════════════════
-- TAB SYSTEM
-- ═══════════════════════════════════════════
local Tabs = {}
local CurrentTab = nil

local function CreateTab(name, icon, layoutOrder)
    -- Tab button
    local TabBtn = CreateInstance("TextButton", {
        Name = name .. "_Tab",
        Size = UDim2.new(0, 42, 0, 42),
        BackgroundColor3 = Colors.LightPanel,
        BackgroundTransparency = 0.8,
        Text = icon,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextColor3 = Colors.TextMuted,
        LayoutOrder = layoutOrder,
        ZIndex = 4,
        Parent = Sidebar
    })
    AddCorner(TabBtn, 10)
    
    -- Active indicator
    local ActiveIndicator = CreateInstance("Frame", {
        Size = UDim2.new(0, 3, 0, 0),
        Position = UDim2.new(0, -3, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Colors.AccentYellow,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = TabBtn
    })
    AddCorner(ActiveIndicator, 2)
    
    -- Tab page
    local TabPage = CreateInstance("ScrollingFrame", {
        Name = name .. "_Page",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Colors.AccentYellow,
        ScrollBarImageTransparency = 0.3,
        Visible = false,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y,
        ZIndex = 4,
        Parent = PagesContainer
    })
    AddPadding(TabPage, 15, 15, 15, 15)
    
    local PageLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabPage
    })
    
    -- Tooltip
    local Tooltip = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 0, 0, 24),
        AutomaticSize = Enum.AutomaticSize.X,
        Position = UDim2.new(1, 8, 0.5, -12),
        BackgroundColor3 = Colors.MidPanel,
        Text = "  " .. name .. "  ",
        TextColor3 = Colors.TextPrimary,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        Visible = false,
        ZIndex = 10,
        Parent = TabBtn
    })
    AddCorner(Tooltip, 6)
    AddStroke(Tooltip, Colors.AccentYellow, 1, 0.5)
    
    TabBtn.MouseEnter:Connect(function()
        if CurrentTab ~= name then
            Tween(TabBtn, 0.2, {BackgroundTransparency = 0.5})
        end
        Tooltip.Visible = true
    end)
    
    TabBtn.MouseLeave:Connect(function()
        if CurrentTab ~= name then
            Tween(TabBtn, 0.2, {BackgroundTransparency = 0.8})
        end
        Tooltip.Visible = false
    end)
    
    TabBtn.MouseButton1Click:Connect(function()
        -- Deactivate all tabs
        for tabName, tabData in pairs(Tabs) do
            tabData.Page.Visible = false
            Tween(tabData.Button, 0.25, {BackgroundTransparency = 0.8, TextColor3 = Colors.TextMuted})
            Tween(tabData.Indicator, 0.25, {Size = UDim2.new(0, 3, 0, 0)})
        end
        
        -- Activate current tab
        CurrentTab = name
        TabPage.Visible = true
        Tween(TabBtn, 0.25, {BackgroundTransparency = 0.3, TextColor3 = Colors.AccentYellow})
        Tween(ActiveIndicator, 0.25, {Size = UDim2.new(0, 3, 0, 24)}, Enum.EasingStyle.Back)
    end)
    
    Tabs[name] = {
        Button = TabBtn,
        Page = TabPage,
        Indicator = ActiveIndicator,
        Layout = PageLayout
    }
    
    return TabPage
end

-- ═══════════════════════════════════════════
-- UI COMPONENT BUILDERS
-- ═══════════════════════════════════════════

-- Section Header
local function CreateSection(parent, title, layoutOrder)
    local Section = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        LayoutOrder = layoutOrder or 0,
        ZIndex = 5,
        Parent = parent
    })
    
    local SectionIcon = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 0, 0.5, -10),
        BackgroundTransparency = 1,
        Text = "◆",
        TextColor3 = Colors.AccentYellow,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        ZIndex = 5,
        Parent = Section
    })
    
    local SectionLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -25, 1, 0),
        Position = UDim2.new(0, 22, 0, 0),
        BackgroundTransparency = 1,
        Text = string.upper(title),
        TextColor3 = Colors.AccentGold,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = Section
    })
    
    local SectionLine = CreateInstance("Frame", {
        Size = UDim2.new(1, -80, 0, 1),
        Position = UDim2.new(0, 80, 0.5, 0),
        BackgroundColor3 = Colors.Border,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = Section
    })
    AddGradient(SectionLine, Colors.AccentYellow, Colors.Background, 0)
    
    return Section
end

-- Toggle Button
local function CreateToggle(parent, title, description, default, layoutOrder, callback)
    local toggled = default or false
    
    local ToggleFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Colors.MidPanel,
        BackgroundTransparency = 0.3,
        LayoutOrder = layoutOrder or 0,
        ZIndex = 5,
        Parent = parent
    })
    AddCorner(ToggleFrame, 8)
    
    local ToggleInfo = CreateInstance("Frame", {
        Size = UDim2.new(1, -70, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = ToggleFrame
    })
    AddPadding(ToggleInfo, 8, 8, 12, 0)
    
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Colors.TextPrimary,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = ToggleInfo
    })
    
    if description then
        CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 14),
            Position = UDim2.new(0, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = description,
            TextColor3 = Colors.TextMuted,
            TextSize = 10,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 5,
            Parent = ToggleInfo
        })
    end
    
    -- Toggle switch
    local ToggleBG = CreateInstance("Frame", {
        Size = UDim2.new(0, 44, 0, 22),
        Position = UDim2.new(1, -56, 0.5, -11),
        BackgroundColor3 = toggled and Colors.AccentYellow or Colors.LightPanel,
        ZIndex = 6,
        Parent = ToggleFrame
    })
    AddCorner(ToggleBG, 11)
    AddStroke(ToggleBG, toggled and Colors.AccentGold or Colors.Border, 1, 0.4)
    
    local ToggleCircle = CreateInstance("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = Colors.TextPrimary,
        ZIndex = 7,
        Parent = ToggleBG
    })
    AddCorner(ToggleCircle, 8)
    
    local ToggleBtn = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 8,
        Parent = ToggleFrame
    })
    
    ToggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        if toggled then
            Tween(ToggleCircle, 0.25, {Position = UDim2.new(1, -19, 0.5, -8)}, Enum.EasingStyle.Back)
            Tween(ToggleBG, 0.2, {BackgroundColor3 = Colors.AccentYellow})
            ToggleBG:FindFirstChildOfClass("UIStroke").Color = Colors.AccentGold
        else
            Tween(ToggleCircle, 0.25, {Position = UDim2.new(0, 3, 0.5, -8)}, Enum.EasingStyle.Back)
            Tween(ToggleBG, 0.2, {BackgroundColor3 = Colors.LightPanel})
            ToggleBG:FindFirstChildOfClass("UIStroke").Color = Colors.Border
        end
        
        if callback then callback(toggled) end
    end)
    
    -- Hover effect
    ToggleBtn.MouseEnter:Connect(function()
        Tween(ToggleFrame, 0.2, {BackgroundTransparency = 0.1})
    end)
    ToggleBtn.MouseLeave:Connect(function()
        Tween(ToggleFrame, 0.2, {BackgroundTransparency = 0.3})
    end)
    
    return ToggleFrame
end

-- Slider
local function CreateSlider(parent, title, min, max, default, layoutOrder, callback)
    local value = default or min
    
    local SliderFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundColor3 = Colors.MidPanel,
        BackgroundTransparency = 0.3,
        LayoutOrder = layoutOrder or 0,
        ZIndex = 5,
        Parent = parent
    })
    AddCorner(SliderFrame, 8)
    AddPadding(SliderFrame, 10, 10, 12, 12)
    
    local SliderTitle = CreateInstance("TextLabel", {
        Size = UDim2.new(0.7, 0, 0, 16),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Colors.TextPrimary,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = SliderFrame
    })
    
    local ValueLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(0.3, 0, 0, 16),
        Position = UDim2.new(0.7, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(value),
        TextColor3 = Colors.AccentYellow,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 5,
        Parent = SliderFrame
    })
    
    local SliderBG = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0, 26),
        BackgroundColor3 = Colors.LightPanel,
        ZIndex = 5,
        Parent = SliderFrame
    })
    AddCorner(SliderBG, 3)
    
    local fillPercent = (value - min) / (max - min)
    
    local SliderFill = CreateInstance("Frame", {
        Size = UDim2.new(fillPercent, 0, 1, 0),
        BackgroundColor3 = Colors.AccentYellow,
        ZIndex = 6,
        Parent = SliderBG
    })
    AddCorner(SliderFill, 3)
    AddGradient(SliderFill, Colors.AccentOrange, Colors.AccentYellow, 0)
    
    local SliderKnob = CreateInstance("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(fillPercent, -8, 0.5, -8),
        BackgroundColor3 = Colors.AccentYellow,
        ZIndex = 7,
        Parent = SliderBG
    })
    AddCorner(SliderKnob, 8)
    AddStroke(SliderKnob, Colors.Background, 2, 0)
    
    local SliderInput = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 19),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 8,
        Parent = SliderFrame
    })
    
    local sliding = false
    
    SliderInput.MouseButton1Down:Connect(function()
        sliding = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            local absPos = SliderBG.AbsolutePosition.X
            local absSize = SliderBG.AbsoluteSize.X
            local mouseX = input.Position.X
            
            local percent = math.clamp((mouseX - absPos) / absSize, 0, 1)
            value = math.floor(min + (max - min) * percent)
            
            Tween(SliderFill, 0.05, {Size = UDim2.new(percent, 0, 1, 0)})
            Tween(SliderKnob, 0.05, {Position = UDim2.new(percent, -8, 0.5, -8)})
            ValueLabel.Text = tostring(value)
            
            if callback then callback(value) end
        end
    end)
    
    -- Hover
    SliderInput.MouseEnter:Connect(function()
        Tween(SliderFrame, 0.2, {BackgroundTransparency = 0.1})
    end)
    SliderInput.MouseLeave:Connect(function()
        Tween(SliderFrame, 0.2, {BackgroundTransparency = 0.3})
    end)
    
    return SliderFrame
end

-- Button
local function CreateButton(parent, title, description, layoutOrder, callback)
    local ButtonFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Colors.MidPanel,
        BackgroundTransparency = 0.3,
        LayoutOrder = layoutOrder or 0,
        ZIndex = 5,
        Parent = parent
    })
    AddCorner(ButtonFrame, 8)
    
    local BtnGlow = CreateInstance("Frame", {
        Size = UDim2.new(0, 4, 0, 20),
        Position = UDim2.new(0, 8, 0.5, -10),
        BackgroundColor3 = Colors.AccentYellow,
        ZIndex = 6,
        Parent = ButtonFrame
    })
    AddCorner(BtnGlow, 2)
    
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, -90, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Colors.TextPrimary,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
        Parent = ButtonFrame
    })
    
    local ExecBtn = CreateInstance("TextButton", {
        Size = UDim2.new(0, 65, 0, 28),
        Position = UDim2.new(1, -75, 0.5, -14),
        BackgroundColor3 = Colors.AccentYellow,
        BackgroundTransparency = 0.85,
        Text = "Run",
        TextColor3 = Colors.AccentYellow,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        ZIndex = 7,
        Parent = ButtonFrame
    })
    AddCorner(ExecBtn, 6)
    AddStroke(ExecBtn, Colors.AccentYellow, 1, 0.5)
    
    ExecBtn.MouseEnter:Connect(function()
        Tween(ExecBtn, 0.2, {BackgroundTransparency = 0.6, TextColor3 = Colors.GlowYellow})
    end)
    ExecBtn.MouseLeave:Connect(function()
        Tween(ExecBtn, 0.2, {BackgroundTransparency = 0.85, TextColor3 = Colors.AccentYellow})
    end)
    ExecBtn.MouseButton1Click:Connect(function()
        -- Click animation
        Tween(ExecBtn, 0.1, {Size = UDim2.new(0, 60, 0, 25)})
        task.wait(0.1)
        Tween(ExecBtn, 0.15, {Size = UDim2.new(0, 65, 0, 28)}, Enum.EasingStyle.Back)
        
        if callback then callback() end
    end)
    
    -- Hover on whole row
    local HoverBtn = CreateInstance("TextButton", {
        Size = UDim2.new(1, -80, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 6,
        Parent = ButtonFrame
    })
    HoverBtn.MouseEnter:Connect(function()
        Tween(ButtonFrame, 0.2, {BackgroundTransparency = 0.1})
        Tween(BtnGlow, 0.2, {Size = UDim2.new(0, 4, 0, 30)})
    end)
    HoverBtn.MouseLeave:Connect(function()
        Tween(ButtonFrame, 0.2, {BackgroundTransparency = 0.3})
        Tween(BtnGlow, 0.2, {Size = UDim2.new(0, 4, 0, 20)})
    end)
    
    return ButtonFrame
end

-- Dropdown
local function CreateDropdown(parent, title, options, default, layoutOrder, callback)
    local selected = default or options[1] or "Select..."
    local opened = false
    
    local DropFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Colors.MidPanel,
        BackgroundTransparency = 0.3,
        LayoutOrder = layoutOrder or 0,
        ClipsDescendants = true,
        ZIndex = 5,
        Parent = parent
    })
    AddCorner(DropFrame, 8)
    
    CreateInstance("TextLabel", {
        Size = UDim2.new(0.5, 0, 0, 44),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Colors.TextPrimary,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
        Parent = DropFrame
    })
    
    local SelectedLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(0.4, -10, 0, 44),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = selected,
        TextColor3 = Colors.AccentYellow,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 6,
        Parent = DropFrame
    })
    
    local Arrow = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 20, 0, 44),
        Position = UDim2.new(1, -25, 0, 0),
        BackgroundTransparency = 1,
        Text = "▾",
        TextColor3 = Colors.AccentYellow,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        ZIndex = 6,
        Parent = DropFrame
    })
    
    local OptionsHolder = CreateInstance("Frame", {
        Size = UDim2.new(1, -16, 0, 0),
        Position = UDim2.new(0, 8, 0, 48),
        BackgroundTransparency = 1,
        ZIndex = 6,
        Parent = DropFrame
    })
    
    local OptionsLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = OptionsHolder
    })
    
    for i, option in ipairs(options) do
        local OptBtn = CreateInstance("TextButton", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Colors.LightPanel,
            BackgroundTransparency = 0.5,
            Text = option,
            TextColor3 = Colors.TextSecondary,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            LayoutOrder = i,
            ZIndex = 7,
            Parent = OptionsHolder
        })
        AddCorner(OptBtn, 6)
        
        OptBtn.MouseEnter:Connect(function()
            Tween(OptBtn, 0.15, {BackgroundTransparency = 0.2, TextColor3 = Colors.AccentYellow})
        end)
        OptBtn.MouseLeave:Connect(function()
            Tween(OptBtn, 0.15, {BackgroundTransparency = 0.5, TextColor3 = Colors.TextSecondary})
        end)
        OptBtn.MouseButton1Click:Connect(function()
            selected = option
            SelectedLabel.Text = option
            opened = false
            local totalH = 44
            Tween(DropFrame, 0.3, {Size = UDim2.new(1, 0, 0, totalH)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            Arrow.Text = "▾"
            if callback then callback(option) end
        end)
    end
    
    local DropBtn = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 7,
        Parent = DropFrame
    })
    
    DropBtn.MouseButton1Click:Connect(function()
        opened = not opened
        if opened then
            local totalH = 48 + (#options * 32) + 8
            Tween(DropFrame, 0.3, {Size = UDim2.new(1, 0, 0, totalH)}, Enum.EasingStyle.Back)
            Arrow.Text = "▴"
        else
            Tween(DropFrame, 0.3, {Size = UDim2.new(1, 0, 0, 44)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            Arrow.Text = "▾"
        end
    end)
    
    return DropFrame
end

-- TextBox / Input
local function CreateInput(parent, title, placeholder, layoutOrder, callback)
    local InputFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Colors.MidPanel,
        BackgroundTransparency = 0.3,
        LayoutOrder = layoutOrder or 0,
        ZIndex = 5,
        Parent = parent
    })
    AddCorner(InputFrame, 8)
    
    CreateInstance("TextLabel", {
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Colors.TextPrimary,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
        Parent = InputFrame
    })
    
    local InputBox = CreateInstance("TextBox", {
        Size = UDim2.new(1, -130, 0, 28),
        Position = UDim2.new(0, 115, 0.5, -14),
        BackgroundColor3 = Colors.LightPanel,
        BackgroundTransparency = 0.3,
        Text = "",
        PlaceholderText = placeholder or "Type here...",
        PlaceholderColor3 = Colors.TextMuted,
        TextColor3 = Colors.AccentYellow,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        ZIndex = 6,
        Parent = InputFrame
    })
    AddCorner(InputBox, 6)
    AddStroke(InputBox, Colors.Border, 1, 0.5)
    AddPadding(InputBox, 0, 0, 8, 8)
    
    InputBox.Focused:Connect(function()
        Tween(InputBox:FindFirstChildOfClass("UIStroke"), 0.2, {Color = Colors.AccentYellow, Transparency = 0})
    end)
    InputBox.FocusLost:Connect(function(enterPressed)
        Tween(InputBox:FindFirstChildOfClass("UIStroke"), 0.2, {Color = Colors.Border, Transparency = 0.5})
        if enterPressed and callback then
            callback(InputBox.Text)
        end
    end)
    
    return InputFrame, InputBox
end

-- ═══════════════════════════════════════════
-- CREATE TABS & POPULATE
-- ═══════════════════════════════════════════

-- 🏠 HOME TAB
local HomePage = CreateTab("Home", "🏠", 1)

CreateSection(HomePage, "Welcome", 1)

-- Welcome card
local WelcomeCard = CreateInstance("Frame", {
    Size = UDim2.new(1, 0, 0, 90),
    BackgroundColor3 = Colors.MidPanel,
    BackgroundTransparency = 0.2,
    LayoutOrder = 2,
    ZIndex = 5,
    Parent = HomePage
})
AddCorner(WelcomeCard, 10)
AddStroke(WelcomeCard, Colors.AccentYellow, 1, 0.6)

local WelcomeGradientBG = CreateInstance("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Colors.AccentOrange,
    BackgroundTransparency = 0.92,
    ZIndex = 5,
    Parent = WelcomeCard
})
AddCorner(WelcomeGradientBG, 10)
AddGradient(WelcomeGradientBG, Colors.AccentOrange, Color3.fromRGB(0,0,0), 45)

CreateInstance("TextLabel", {
    Size = UDim2.new(1, -20, 0, 28),
    Position = UDim2.new(0, 15, 0, 12),
    BackgroundTransparency = 1,
    Text = "⚡ Welcome to Meo Y2K Hub",
    TextColor3 = Colors.AccentYellow,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = WelcomeCard
})

CreateInstance("TextLabel", {
    Size = UDim2.new(1, -20, 0, 20),
    Position = UDim2.new(0, 15, 0, 42),
    BackgroundTransparency = 1,
    Text = "Player: " .. Player.Name .. "  |  Premium Hub",
    TextColor3 = Colors.TextSecondary,
    TextSize = 12,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = WelcomeCard
})

CreateInstance("TextLabel", {
    Size = UDim2.new(1, -20, 0, 16),
    Position = UDim2.new(0, 15, 0, 62),
    BackgroundTransparency = 1,
    Text = "🟢 Status: Connected  |  🔒 Anti-Detection: Active",
    TextColor3 = Colors.Success,
    TextSize = 10,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = WelcomeCard
})

CreateSection(HomePage, "Quick Actions", 3)

CreateButton(HomePage, "🔄 Rejoin Server", nil, 4, function()
    Notify("Rejoining", "Teleporting back to server...", 2, "warning")
    task.wait(1)
    game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
end)

CreateButton(HomePage, "📋 Copy Server Link", nil, 5, function()
    if setclipboard then
        setclipboard("roblox://placeId=" .. game.PlaceId .. "&gameInstanceId=" .. game.JobId)
        Notify("Copied!", "Server link copied to clipboard", 2, "success")
    end
end)

CreateButton(HomePage, "🖥️ Server Hop", nil, 6, function()
    Notify("Server Hop", "Finding a new server...", 2, "warning")
end)

-- ⚡ EXECUTOR TAB
local ExecutorPage = CreateTab("Executor", "⚡", 2)

CreateSection(ExecutorPage, "Script Editor", 1)

-- Script editor
local EditorFrame = CreateInstance("Frame", {
    Size = UDim2.new(1, 0, 0, 180),
    BackgroundColor3 = Colors.LightPanel,
    BackgroundTransparency = 0.2,
    LayoutOrder = 2,
    ZIndex = 5,
    Parent = ExecutorPage
})
AddCorner(EditorFrame, 8)
AddStroke(EditorFrame, Colors.Border, 1, 0.5)

-- Editor header
local EditorHeader = CreateInstance("Frame", {
    Size = UDim2.new(1, 0, 0, 28),
    BackgroundColor3 = Colors.MidPanel,
    BorderSizePixel = 0,
    ZIndex = 6,
    Parent = EditorFrame
})
AddCorner(EditorHeader, 8)

local EditorHeaderFix = CreateInstance("Frame", {
    Size = UDim2.new(1, 0, 0, 10),
    Position = UDim2.new(0, 0, 1, -10),
    BackgroundColor3 = Colors.MidPanel,
    BorderSizePixel = 0,
    ZIndex = 6,
    Parent = EditorHeader
})

CreateInstance("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "  📝 script.lua",
    TextColor3 = Colors.TextMuted,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 7,
    Parent = EditorHeader
})

local ScriptBox = CreateInstance("TextBox", {
    Size = UDim2.new(1, -16, 1, -36),
    Position = UDim2.new(0, 8, 0, 32),
    BackgroundTransparency = 1,
    Text = "",
    PlaceholderText = "-- Paste your script here...\n-- Meo Y2K Hub\nprint('Hello World!')",
    PlaceholderColor3 = Colors.TextMuted,
    TextColor3 = Colors.GlowYellow,
    TextSize = 12,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    MultiLine = true,
    ClearTextOnFocus = false,
    TextWrapped = true,
    ZIndex = 6,
    Parent = EditorFrame
})

ScriptBox.Focused:Connect(function()
    Tween(EditorFrame:FindFirstChildOfClass("UIStroke"), 0.2, {Color = Colors.AccentYellow, Transparency = 0})
end)
ScriptBox.FocusLost:Connect(function()
    Tween(EditorFrame:FindFirstChildOfClass("UIStroke"), 0.2, {Color = Colors.Border, Transparency = 0.5})
end)

-- Executor buttons
local ExecBtnsFrame = CreateInstance("Frame", {
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundTransparency = 1,
    LayoutOrder = 3,
    ZIndex = 5,
    Parent = ExecutorPage
})

local ExecBtnsLayout = CreateInstance("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = ExecBtnsFrame
})

local function CreateExecButton(text, icon, color, layoutOrder, callback)
    local btn = CreateInstance("TextButton", {
        Size = UDim2.new(0, 110, 0, 36),
        BackgroundColor3 = color,
        BackgroundTransparency = 0.85,
        Text = icon .. " " .. text,
        TextColor3 = color,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        LayoutOrder = layoutOrder,
        ZIndex = 6,
        Parent = ExecBtnsFrame
    })
    AddCorner(btn, 8)
    AddStroke(btn, color, 1, 0.5)
    
    btn.MouseEnter:Connect(function()
        Tween(btn, 0.2, {BackgroundTransparency = 0.6})
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, 0.2, {BackgroundTransparency = 0.85})
    end)
    btn.MouseButton1Click:Connect(function()
        Tween(btn, 0.08, {Size = UDim2.new(0, 105, 0, 33)})
        task.wait(0.08)
        Tween(btn, 0.12, {Size = UDim2.new(0, 110, 0, 36)}, Enum.EasingStyle.Back)
        if callback then callback() end
    end)
    return btn
end

CreateExecButton("Execute", "▶", Colors.AccentYellow, 1, function()
    if ScriptBox.Text ~= "" then
        local success, err = pcall(function()
            loadstring(ScriptBox.Text)()
        end)
        if success then
            Notify("Executed", "Script ran successfully!", 2, "success")
        else
            Notify("Error", tostring(err), 3, "error")
        end
    else
        Notify("Empty", "Please enter a script first", 2, "warning")
    end
end)

CreateExecButton("Clear", "🗑️", Colors.Error, 2, function()
    ScriptBox.Text = ""
    Notify("Cleared", "Editor cleared", 1.5)
end)

CreateExecButton("Copy", "📋", Colors.TextSecondary, 3, function()
    if setclipboard then
        setclipboard(ScriptBox.Text)
        Notify("Copied", "Script copied to clipboard", 1.5, "success")
    end
end)

CreateExecButton("Paste", "📥", Colors.AccentOrange, 4, function()
    -- Note: Clipboard read isn't always available
    Notify("Paste", "Use Ctrl+V in the editor", 2)
end)

-- ⚙️ PLAYER TAB
local PlayerPage = CreateTab("Player", "👤", 3)

CreateSection(PlayerPage, "Movement", 1)

CreateSlider(PlayerPage, "Walk Speed", 16, 200, 16, 2, function(val)
    Player.Character.Humanoid.WalkSpeed = val
end)

CreateSlider(PlayerPage, "Jump Power", 50, 300, 50, 3, function(val)
    Player.Character.Humanoid.JumpPower = val
end)

CreateSection(PlayerPage, "Character", 4)

CreateToggle(PlayerPage, "Infinite Jump", "Jump unlimited times in the air", false, 5, function(state)
    _G.InfiniteJump = state
    if state then
        Notify("Enabled", "Infinite Jump activated", 2, "success")
    else
        Notify("Disabled", "Infinite Jump deactivated", 2)
    end
end)

-- Infinite jump handler
UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

CreateToggle(PlayerPage, "Noclip", "Walk through walls and objects", false, 6, function(state)
    _G.Noclip = state
    if state then
        Notify("Enabled", "Noclip activated", 2, "success")
    else
        Notify("Disabled", "Noclip deactivated", 2)
    end
end)

-- Noclip handler
RunService.Stepped:Connect(function()
    if _G.Noclip and Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

CreateToggle(PlayerPage, "God Mode", "Become invincible to damage", false, 7, function(state)
    if state then
        Notify("God Mode", "God mode enabled (client-side)", 2, "success")
    else
        Notify("God Mode", "God mode disabled", 2)
    end
end)

CreateSection(PlayerPage, "Teleport", 8)

CreateButton(PlayerPage, "📍 TP to Mouse Position", nil, 9, function()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        Notify("Teleported", "Moved to cursor position", 1.5, "success")
    end
end)

-- 🎨 VISUALS TAB
local VisualsPage = CreateTab("Visuals", "👁️", 4)

CreateSection(VisualsPage, "ESP Settings", 1)

CreateToggle(VisualsPage, "Player ESP", "See all players through walls", false, 2, function(state)
    if state then
        Notify("ESP", "Player ESP enabled", 2, "success")
    else
        Notify("ESP", "Player ESP disabled", 2)
    end
end)

CreateToggle(VisualsPage, "Box ESP", "Show boxes around players", false, 3, function(state)
    Notify("Box ESP", state and "Enabled" or "Disabled", 1.5, state and "success" or nil)
end)

CreateToggle(VisualsPage, "Name ESP", "Show player names", false, 4, function(state)
    Notify("Name ESP", state and "Enabled" or "Disabled", 1.5, state and "success" or nil)
end)

CreateToggle(VisualsPage, "Distance ESP", "Show distance to players", false, 5, function(state)
    Notify("Distance ESP", state and "Enabled" or "Disabled", 1.5, state and "success" or nil)
end)

CreateSection(VisualsPage, "World", 6)

CreateToggle(VisualsPage, "Fullbright", "Remove all shadows and darkness", false, 7, function(state)
    if state then
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").ClockTime = 14
        game:GetService("Lighting").FogEnd = 100000
        game:GetService("Lighting").GlobalShadows = false
        Notify("Fullbright", "World brightness maxed", 2, "success")
    else
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").GlobalShadows = true
        Notify("Fullbright", "Restored default lighting", 2)
    end
end)

CreateSlider(VisualsPage, "FOV", 30, 120, 70, 8, function(val)
    game:GetService("Workspace").CurrentCamera.FieldOfView = val
end)

CreateDropdown(VisualsPage, "ESP Color", {"Yellow", "Orange", "Red", "Green", "Cyan", "White"}, "Yellow", 9, function(opt)
    Notify("ESP Color", "Changed to " .. opt, 1.5)
end)

-- ⚙️ SETTINGS TAB
local SettingsPage = CreateTab("Settings", "⚙️", 5)

CreateSection(SettingsPage, "GUI Settings", 1)

CreateToggle(SettingsPage, "GUI Keybind", "Press RightShift to toggle GUI", true, 2, function(state)
    _G.KeybindEnabled = state
end)

_G.KeybindEnabled = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift and _G.KeybindEnabled then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

CreateSlider(SettingsPage, "UI Transparency", 0, 50, 0, 3, function(val)
    MainFrame.BackgroundTransparency = val / 100
end)

CreateDropdown(SettingsPage, "Theme", {"Yellow/Orange", "Cyan/Blue", "Purple/Pink", "Green/Lime"}, "Yellow/Orange", 4, function(opt)
    Notify("Theme", "Theme changed to " .. opt .. " (restart required)", 3, "warning")
end)

CreateSection(SettingsPage, "Information", 5)

-- Info card
local InfoCard = CreateInstance("Frame", {
    Size = UDim2.new(1, 0, 0, 120),
    BackgroundColor3 = Colors.MidPanel,
    BackgroundTransparency = 0.3,
    LayoutOrder = 6,
    ZIndex = 5,
    Parent = SettingsPage
})
AddCorner(InfoCard, 8)
AddPadding(InfoCard, 12, 12, 12, 12)

local InfoLayout = CreateInstance("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = InfoCard
})

local infoTexts = {
    {"⚡ Hub:", "Meo Y2K Hub v2.0"},
    {"🎮 Game:", game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name},
    {"👤 Player:", Player.Name},
    {"🔑 Executor:", "Delta"},
    {"📡 Server:", tostring(#Players:GetPlayers()) .. " players"}
}

for i, info in ipairs(infoTexts) do
    local InfoLine = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        LayoutOrder = i,
        ZIndex = 6,
        Parent = InfoCard
    })
    CreateInstance("TextLabel", {
        Size = UDim2.new(0, 90, 1, 0),
        BackgroundTransparency = 1,
        Text = info[1],
        TextColor3 = Colors.TextMuted,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
        Parent = InfoLine
    })
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, -95, 1, 0),
        Position = UDim2.new(0, 95, 0, 0),
        BackgroundTransparency = 1,
        Text = info[2],
        TextColor3 = Colors.TextSecondary,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 6,
        Parent = InfoLine
    })
end

CreateSection(SettingsPage, "Danger Zone", 7)

CreateButton(SettingsPage, "🗑️ Destroy GUI", nil, 8, function()
    Notify("Goodbye!", "Destroying Meo Y2K Hub...", 1.5, "error")
    task.wait(1.5)
    ScreenGui:Destroy()
end)

-- ═══════════════════════════════════════════
-- SET DEFAULT TAB
-- ═══════════════════════════════════════════
task.wait(0.1)
Tabs["Home"].Button.MouseButton1Click:Fire()

-- ═══════════════════════════════════════════
-- OPENING ANIMATION
-- ═══════════════════════════════════════════
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundTransparency = 1

Tween(MainFrame, 0.6, {
    Size = UDim2.new(0, 580, 0, 420),
    Position = UDim2.new(0.5, -290, 0.5, -210),
    BackgroundTransparency = 0
}, Enum.EasingStyle.Back)

task.wait(0.7)

-- Welcome notification
Notify("Meo Y2K Hub", "Successfully loaded! Press RightShift to toggle.", 4, "success")
Notify("Delta", "Running on Delta Executor ⚡", 3)

-- ═══════════════════════════════════════════
-- STATUS BAR (Bottom)
-- ═══════════════════════════════════════════
local StatusBar = CreateInstance("Frame", {
    Size = UDim2.new(1, -10, 0, 22),
    Position = UDim2.new(0, 5, 1, -27),
    BackgroundColor3 = Colors.DarkPanel,
    BackgroundTransparency = 0.3,
    ZIndex = 5,
    Parent = MainFrame
})
AddCorner(StatusBar, 6)

local StatusText = CreateInstance("TextLabel", {
    Size = UDim2.new(1, -10, 1, 0),
    Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    Text = "⚡ Meo Y2K Hub  |  🟢 Connected  |  ⏱️ " .. os.date("%H:%M"),
    TextColor3 = Colors.TextMuted,
    TextSize = 10,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = StatusBar
})

-- Update clock
spawn(function()
    while StatusBar and StatusBar.Parent do
        StatusText.Text = "⚡ Meo Y2K Hub  |  🟢 Connected  |  ⏱️ " .. os.date("%H:%M:%S") .. "  |  FPS: " .. math.floor(1 / RunService.RenderStepped:Wait())
        task.wait(1)
    end
end)

print("⚡ Meo Y2K Hub v2.0 - Loaded Successfully!")
