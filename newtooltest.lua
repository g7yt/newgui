-- ═══════════════════════════════════════════════════════════════
-- 🍓 STRAWBERRY CRAWLER - Server Side Exploit Tool
-- Modern UI/UX | Delta Executor | Full Featured
-- ═══════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local NetworkClient = game:GetService("NetworkClient")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Cleanup
if game.CoreGui:FindFirstChild("StrawberryCrawler") then
    game.CoreGui:FindFirstChild("StrawberryCrawler"):Destroy()
end

-- ═══════════════════════════════════════════
-- 🍓 STRAWBERRY COLOR PALETTE
-- ═══════════════════════════════════════════
local C = {
    -- Backgrounds
    Bg = Color3.fromRGB(12, 8, 14),
    BgDark = Color3.fromRGB(16, 10, 18),
    BgPanel = Color3.fromRGB(22, 14, 26),
    BgCard = Color3.fromRGB(30, 18, 35),
    BgHover = Color3.fromRGB(40, 24, 46),
    BgInput = Color3.fromRGB(18, 12, 22),

    -- Strawberry Accents
    Berry = Color3.fromRGB(255, 45, 85),
    BerryLight = Color3.fromRGB(255, 90, 120),
    BerryDark = Color3.fromRGB(200, 30, 65),
    BerryGlow = Color3.fromRGB(255, 130, 155),
    BerryPale = Color3.fromRGB(255, 180, 195),

    -- Pink Tones
    Pink = Color3.fromRGB(255, 105, 140),
    PinkSoft = Color3.fromRGB(255, 160, 185),
    PinkDark = Color3.fromRGB(180, 40, 75),

    -- Cream / Leaf
    Cream = Color3.fromRGB(255, 235, 220),
    Leaf = Color3.fromRGB(80, 200, 120),
    LeafDark = Color3.fromRGB(50, 160, 90),

    -- Text
    TextWhite = Color3.fromRGB(255, 250, 252),
    TextLight = Color3.fromRGB(220, 200, 210),
    TextMuted = Color3.fromRGB(140, 110, 130),
    TextDark = Color3.fromRGB(90, 70, 85),
    TextAccent = Color3.fromRGB(255, 90, 120),

    -- Status
    Success = Color3.fromRGB(80, 220, 130),
    Error = Color3.fromRGB(255, 60, 60),
    Warning = Color3.fromRGB(255, 200, 80),
    Info = Color3.fromRGB(120, 180, 255),

    -- Borders
    Border = Color3.fromRGB(60, 35, 70),
    BorderAccent = Color3.fromRGB(255, 45, 85),
    BorderSoft = Color3.fromRGB(45, 28, 52),
}

-- ═══════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════
local function New(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Tw(obj, dur, props, style, dir)
    local t = TweenService:Create(obj,
        TweenInfo.new(dur, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props)
    t:Play()
    return t
end

local function Corner(p, r) return New("UICorner", {CornerRadius = UDim.new(0, r or 8), Parent = p}) end
local function Stroke(p, c, t, tr) return New("UIStroke", {Color = c or C.Border, Thickness = t or 1, Transparency = tr or 0.5, Parent = p}) end
local function Pad(p, t, b, l, r) return New("UIPadding", {PaddingTop=UDim.new(0,t or 8), PaddingBottom=UDim.new(0,b or 8), PaddingLeft=UDim.new(0,l or 8), PaddingRight=UDim.new(0,r or 8), Parent=p}) end
local function Grad(p, c1, c2, rot) return New("UIGradient", {Color=ColorSequence.new({ColorSequenceKeypoint.new(0,c1), ColorSequenceKeypoint.new(1,c2)}), Rotation=rot or 90, Parent=p}) end

-- ═══════════════════════════════════════════
-- MAIN GUI
-- ═══════════════════════════════════════════
local Gui = New("ScreenGui", {
    Name = "StrawberryCrawler",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = game.CoreGui
})

-- ═══════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════
local NotifHolder = New("Frame", {
    Name = "Notifs",
    Size = UDim2.new(0, 320, 1, 0),
    Position = UDim2.new(1, -340, 0, 0),
    BackgroundTransparency = 1,
    Parent = Gui
})
New("UIListLayout", {
    Padding = UDim.new(0, 6),
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = NotifHolder
})
Pad(NotifHolder, 0, 15, 0, 0)

local function Notify(title, msg, dur, nType)
    local col = C.Berry
    local icon = "🍓"
    if nType == "success" then col = C.Success; icon = "✅"
    elseif nType == "error" then col = C.Error; icon = "❌"
    elseif nType == "warning" then col = C.Warning; icon = "⚠️"
    elseif nType == "info" then col = C.Info; icon = "ℹ️"
    elseif nType == "crawl" then col = C.Leaf; icon = "🕷️"
    end

    local NF = New("Frame", {
        Size = UDim2.new(1, -10, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = C.BgPanel,
        BackgroundTransparency = 0.02,
        ClipsDescendants = true,
        Parent = NotifHolder
    })
    Corner(NF, 10)
    Stroke(NF, col, 1, 0.3)

    -- Left accent
    New("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = col,
        BorderSizePixel = 0,
        Parent = NF
    })

    local NC = New("Frame", {
        Size = UDim2.new(1, -15, 0, 0),
        Position = UDim2.new(0, 15, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = NF
    })
    Pad(NC, 10, 10, 0, 8)
    New("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = NC})

    New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        Text = icon .. " " .. (title or ""),
        TextColor3 = col,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        Parent = NC
    })
    New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = msg or "",
        TextColor3 = C.TextLight,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 2,
        Parent = NC
    })

    local PBG = New("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = C.BgHover,
        LayoutOrder = 3,
        Parent = NC
    })
    Corner(PBG, 1)
    local PF = New("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = col, Parent = PBG})
    Corner(PF, 1)

    NF.Position = UDim2.new(1, 40, 0, 0)
    Tw(NF, 0.35, {Position = UDim2.new(0, 5, 0, 0)}, Enum.EasingStyle.Back)
    Tw(PF, dur or 3, {Size = UDim2.new(0, 0, 1, 0)}, Enum.EasingStyle.Linear)

    task.delay(dur or 3, function()
        Tw(NF, 0.3, {Position = UDim2.new(1, 40, 0, 0)})
        task.wait(0.35)
        NF:Destroy()
    end)
end

-- ═══════════════════════════════════════════
-- MAIN WINDOW
-- ═══════════════════════════════════════════
local Main = New("Frame", {
    Name = "Main",
    Size = UDim2.new(0, 640, 0, 460),
    Position = UDim2.new(0.5, -320, 0.5, -230),
    BackgroundColor3 = C.Bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = Gui
})
Corner(Main, 16)
Stroke(Main, C.Berry, 1.5, 0.35)

-- Shadow
New("ImageLabel", {
    Size = UDim2.new(1, 60, 1, 60),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    Image = "rbxassetid://6015897843",
    ImageColor3 = Color3.fromRGB(0, 0, 0),
    ImageTransparency = 0.35,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(49, 49, 450, 450),
    ZIndex = -1,
    Parent = Main
})

-- Animated glow
local Glow1 = New("Frame", {
    Size = UDim2.new(0, 250, 0, 250),
    Position = UDim2.new(0.75, 0, -0.15, 0),
    BackgroundColor3 = C.Berry,
    BackgroundTransparency = 0.94,
    ZIndex = 0,
    Parent = Main
})
Corner(Glow1, 125)

local Glow2 = New("Frame", {
    Size = UDim2.new(0, 200, 0, 200),
    Position = UDim2.new(-0.1, 0, 0.6, 0),
    BackgroundColor3 = C.Pink,
    BackgroundTransparency = 0.95,
    ZIndex = 0,
    Parent = Main
})
Corner(Glow2, 100)

spawn(function()
    while Main and Main.Parent do
        Tw(Glow1, 5, {Position = UDim2.new(0.6, 0, 0.5, 0), BackgroundTransparency = 0.96})
        Tw(Glow2, 5, {Position = UDim2.new(0.1, 0, 0.2, 0), BackgroundTransparency = 0.93})
        task.wait(5)
        Tw(Glow1, 5, {Position = UDim2.new(0.75, 0, -0.15, 0), BackgroundTransparency = 0.94})
        Tw(Glow2, 5, {Position = UDim2.new(-0.1, 0, 0.6, 0), BackgroundTransparency = 0.95})
        task.wait(5)
    end
end)

-- ═══════════════════════════════════════════
-- TITLE BAR
-- ═══════════════════════════════════════════
local TitleBar = New("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = C.BgDark,
    BorderSizePixel = 0,
    ZIndex = 10,
    Parent = Main
})
Corner(TitleBar, 16)
New("Frame", {
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 1, -16),
    BackgroundColor3 = C.BgDark,
    BorderSizePixel = 0,
    ZIndex = 10,
    Parent = TitleBar
})

-- Accent line under title
local TitleLine = New("Frame", {
    Size = UDim2.new(1, 0, 0, 2),
    Position = UDim2.new(0, 0, 1, -2),
    BackgroundColor3 = C.Berry,
    BorderSizePixel = 0,
    ZIndex = 11,
    Parent = TitleBar
})
Grad(TitleLine, C.BerryDark, C.BerryLight, 0)

-- Strawberry icon
local LogoIcon = New("TextLabel", {
    Size = UDim2.new(0, 32, 0, 32),
    Position = UDim2.new(0, 12, 0.5, -16),
    BackgroundColor3 = C.Berry,
    BackgroundTransparency = 0.88,
    Text = "🍓",
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextColor3 = C.Berry,
    ZIndex = 12,
    Parent = TitleBar
})
Corner(LogoIcon, 8)
Stroke(LogoIcon, C.Berry, 1, 0.5)

-- Pulsing icon animation
spawn(function()
    while LogoIcon and LogoIcon.Parent do
        Tw(LogoIcon, 1.5, {BackgroundTransparency = 0.75, Rotation = 5})
        task.wait(1.5)
        Tw(LogoIcon, 1.5, {BackgroundTransparency = 0.88, Rotation = 0})
        task.wait(1.5)
    end
end)

New("TextLabel", {
    Size = UDim2.new(0, 200, 1, 0),
    Position = UDim2.new(0, 52, 0, 0),
    BackgroundTransparency = 1,
    Text = "Strawberry Crawler",
    TextColor3 = C.TextWhite,
    TextSize = 17,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12,
    Parent = TitleBar
})

-- SS badge
local SSBadge = New("TextLabel", {
    Size = UDim2.new(0, 58, 0, 18),
    Position = UDim2.new(0, 218, 0.5, -9),
    BackgroundColor3 = C.Berry,
    BackgroundTransparency = 0.8,
    Text = "SS Tool",
    TextColor3 = C.BerryLight,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    ZIndex = 12,
    Parent = TitleBar
})
Corner(SSBadge, 4)
Stroke(SSBadge, C.Berry, 1, 0.6)

-- Window controls
local CtrlFrame = New("Frame", {
    Size = UDim2.new(0, 110, 1, 0),
    Position = UDim2.new(1, -110, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 11,
    Parent = TitleBar
})

local function WinBtn(name, txt, pos, col, cb)
    local b = New("TextButton", {
        Name = name,
        Size = UDim2.new(0, 30, 0, 30),
        Position = pos,
        BackgroundColor3 = col,
        BackgroundTransparency = 0.9,
        Text = txt,
        TextColor3 = col,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        ZIndex = 12,
        Parent = CtrlFrame
    })
    Corner(b, 8)
    b.MouseEnter:Connect(function() Tw(b, 0.15, {BackgroundTransparency = 0.6}) end)
    b.MouseLeave:Connect(function() Tw(b, 0.15, {BackgroundTransparency = 0.9}) end)
    b.MouseButton1Click:Connect(cb)
    return b
end

local isMin = false
WinBtn("Min", "─", UDim2.new(0, 5, 0.5, -15), C.TextMuted, function()
    isMin = not isMin
    if isMin then
        Tw(Main, 0.35, {Size = UDim2.new(0, 640, 0, 48)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    else
        Tw(Main, 0.35, {Size = UDim2.new(0, 640, 0, 460)}, Enum.EasingStyle.Back)
    end
end)

WinBtn("Max", "□", UDim2.new(0, 40, 0.5, -15), C.TextMuted, function()
    Tw(Main, 0.35, {
        Size = UDim2.new(0, 640, 0, 460),
        Position = UDim2.new(0.5, -320, 0.5, -230)
    }, Enum.EasingStyle.Back)
end)

WinBtn("Close", "✕", UDim2.new(0, 75, 0.5, -15), C.Error, function()
    Tw(Main, 0.3, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
    task.wait(0.35)
    Gui:Destroy()
end)

-- Drag
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

-- ═══════════════════════════════════════════
-- CONTENT AREA
-- ═══════════════════════════════════════════
local Content = New("Frame", {
    Name = "Content",
    Size = UDim2.new(1, 0, 1, -48),
    Position = UDim2.new(0, 0, 0, 48),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    ZIndex = 2,
    Parent = Main
})

-- ═══════════════════════════════════════════
-- SIDEBAR
-- ═══════════════════════════════════════════
local Sidebar = New("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 60, 1, -10),
    Position = UDim2.new(0, 5, 0, 5),
    BackgroundColor3 = C.BgDark,
    BorderSizePixel = 0,
    ZIndex = 5,
    Parent = Content
})
Corner(Sidebar, 12)
Stroke(Sidebar, C.BorderSoft, 1, 0.5)
Pad(Sidebar, 10, 10, 0, 0)

New("UIListLayout", {
    Padding = UDim.new(0, 5),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = Sidebar
})

-- Pages container
local Pages = New("Frame", {
    Name = "Pages",
    Size = UDim2.new(1, -75, 1, -10),
    Position = UDim2.new(0, 70, 0, 5),
    BackgroundColor3 = C.BgDark,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 3,
    Parent = Content
})
Corner(Pages, 12)
Stroke(Pages, C.BorderSoft, 1, 0.5)

-- ═══════════════════════════════════════════
-- TAB SYSTEM
-- ═══════════════════════════════════════════
local Tabs = {}
local ActiveTab = nil

local function MakeTab(name, icon, order)
    local Btn = New("TextButton", {
        Name = name,
        Size = UDim2.new(0, 44, 0, 44),
        BackgroundColor3 = C.BgCard,
        BackgroundTransparency = 0.8,
        Text = icon,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextColor3 = C.TextMuted,
        LayoutOrder = order,
        ZIndex = 6,
        Parent = Sidebar
    })
    Corner(Btn, 10)

    local Ind = New("Frame", {
        Size = UDim2.new(0, 3, 0, 0),
        Position = UDim2.new(1, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = C.Berry,
        BorderSizePixel = 0,
        ZIndex = 7,
        Parent = Btn
    })
    Corner(Ind, 2)

    local Page = New("ScrollingFrame", {
        Name = name,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.Berry,
        ScrollBarImageTransparency = 0.3,
        Visible = false,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y,
        ZIndex = 4,
        Parent = Pages
    })
    Pad(Page, 14, 14, 14, 14)
    New("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Page})

    -- Tooltip
    local Tip = New("TextLabel", {
        Size = UDim2.new(0, 0, 0, 22),
        AutomaticSize = Enum.AutomaticSize.X,
        Position = UDim2.new(1, 10, 0.5, -11),
        BackgroundColor3 = C.BgCard,
        Text = "  "..name.."  ",
        TextColor3 = C.TextWhite,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        Visible = false,
        ZIndex = 20,
        Parent = Btn
    })
    Corner(Tip, 5)
    Stroke(Tip, C.Berry, 1, 0.5)

    Btn.MouseEnter:Connect(function()
        if ActiveTab ~= name then Tw(Btn, 0.15, {BackgroundTransparency = 0.4}) end
        Tip.Visible = true
    end)
    Btn.MouseLeave:Connect(function()
        if ActiveTab ~= name then Tw(Btn, 0.15, {BackgroundTransparency = 0.8}) end
        Tip.Visible = false
    end)

    Btn.MouseButton1Click:Connect(function()
        for n, d in pairs(Tabs) do
            d.Page.Visible = false
            Tw(d.Btn, 0.2, {BackgroundTransparency = 0.8, TextColor3 = C.TextMuted})
            Tw(d.Ind, 0.2, {Size = UDim2.new(0, 3, 0, 0)})
        end
        ActiveTab = name
        Page.Visible = true
        Tw(Btn, 0.2, {BackgroundTransparency = 0.2, TextColor3 = C.Berry})
        Tw(Ind, 0.25, {Size = UDim2.new(0, 3, 0, 22)}, Enum.EasingStyle.Back)
    end)

    Tabs[name] = {Btn = Btn, Page = Page, Ind = Ind}
    return Page
end

-- ═══════════════════════════════════════════
-- UI COMPONENTS
-- ═══════════════════════════════════════════

local function Section(parent, title, order)
    local S = New("Frame", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1,
        LayoutOrder = order or 0,
        ZIndex = 5,
        Parent = parent
    })
    New("TextLabel", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0, 0, 0.5, -7),
        BackgroundTransparency = 1,
        Text = "🍓",
        TextSize = 10,
        ZIndex = 5,
        Parent = S
    })
    New("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 18, 0, 0),
        BackgroundTransparency = 1,
        Text = string.upper(title),
        TextColor3 = C.BerryLight,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = S
    })
    local L = New("Frame", {
        Size = UDim2.new(1, -100, 0, 1),
        Position = UDim2.new(0, 100, 0.5, 0),
        BackgroundColor3 = C.Border,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = S
    })
    Grad(L, C.Berry, C.Bg, 0)
end

local function Toggle(parent, title, desc, def, order, cb)
    local on = def or false
    local F = New("Frame", {
        Size = UDim2.new(1, 0, 0, desc and 50 or 40),
        BackgroundColor3 = C.BgCard,
        BackgroundTransparency = 0.3,
        LayoutOrder = order or 0,
        ZIndex = 5,
        Parent = parent
    })
    Corner(F, 8)

    local Info = New("Frame", {
        Size = UDim2.new(1, -65, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = F
    })
    Pad(Info, 6, 6, 12, 0)

    New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = C.TextWhite,
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = Info
    })
    if desc then
        New("TextLabel", {
            Size = UDim2.new(1, 0, 0, 12),
            Position = UDim2.new(0, 0, 0, 18),
            BackgroundTransparency = 1,
            Text = desc,
            TextColor3 = C.TextDark,
            TextSize = 9,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 5,
            Parent = Info
        })
    end

    local TBG = New("Frame", {
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -52, 0.5, -10),
        BackgroundColor3 = on and C.Berry or C.BgHover,
        ZIndex = 6,
        Parent = F
    })
    Corner(TBG, 10)
    Stroke(TBG, on and C.BerryDark or C.Border, 1, 0.4)

    local TC = New("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
        BackgroundColor3 = C.TextWhite,
        ZIndex = 7,
        Parent = TBG
    })
    Corner(TC, 7)

    local TB = New("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 8,
        Parent = F
    })

    TB.MouseButton1Click:Connect(function()
        on = not on
        if on then
            Tw(TC, 0.2, {Position = UDim2.new(1, -17, 0.5, -7)}, Enum.EasingStyle.Back)
            Tw(TBG, 0.15, {BackgroundColor3 = C.Berry})
            TBG:FindFirstChildOfClass("UIStroke").Color = C.BerryDark
        else
            Tw(TC, 0.2, {Position = UDim2.new(0, 3, 0.5, -7)}, Enum.EasingStyle.Back)
            Tw(TBG, 0.15, {BackgroundColor3 = C.BgHover})
            TBG:FindFirstChildOfClass("UIStroke").Color = C.Border
        end
        if cb then cb(on) end
    end)

    TB.MouseEnter:Connect(function() Tw(F, 0.15, {BackgroundTransparency = 0.1}) end)
    TB.MouseLeave:Connect(function() Tw(F, 0.15, {BackgroundTransparency = 0.3}) end)
end

local function Button(parent, title, icon, order, cb)
    local F = New("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = C.BgCard,
        BackgroundTransparency = 0.3,
        LayoutOrder = order or 0,
        ZIndex = 5,
        Parent = parent
    })
    Corner(F, 8)

    local Glow = New("Frame", {
        Size = UDim2.new(0, 3, 0, 18),
        Position = UDim2.new(0, 8, 0.5, -9),
        BackgroundColor3 = C.Berry,
        ZIndex = 6,
        Parent = F
    })
    Corner(Glow, 2)

    New("TextLabel", {
        Size = UDim2.new(1, -90, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        Text = (icon or "") .. " " .. title,
        TextColor3 = C.TextWhite,
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
        Parent = F
    })

    local Btn = New("TextButton", {
        Size = UDim2.new(0, 60, 0, 26),
        Position = UDim2.new(1, -70, 0.5, -13),
        BackgroundColor3 = C.Berry,
        BackgroundTransparency = 0.82,
        Text = "Run",
        TextColor3 = C.BerryLight,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        ZIndex = 7,
        Parent = F
    })
    Corner(Btn, 6)
    Stroke(Btn, C.Berry, 1, 0.5)

    Btn.MouseEnter:Connect(function() Tw(Btn, 0.15, {BackgroundTransparency = 0.5}) end)
    Btn.MouseLeave:Connect(function() Tw(Btn, 0.15, {BackgroundTransparency = 0.82}) end)
    Btn.MouseButton1Click:Connect(function()
        Tw(Btn, 0.06, {Size = UDim2.new(0, 56, 0, 23)})
        task.wait(0.06)
        Tw(Btn, 0.1, {Size = UDim2.new(0, 60, 0, 26)}, Enum.EasingStyle.Back)
        if cb then cb() end
    end)

    local HoverBtn = New("TextButton", {
        Size = UDim2.new(1, -75, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 6,
        Parent = F
    })
    HoverBtn.MouseEnter:Connect(function()
        Tw(F, 0.15, {BackgroundTransparency = 0.1})
        Tw(Glow, 0.15, {Size = UDim2.new(0, 3, 0, 26)})
    end)
    HoverBtn.MouseLeave:Connect(function()
        Tw(F, 0.15, {BackgroundTransparency = 0.3})
        Tw(Glow, 0.15, {Size = UDim2.new(0, 3, 0, 18)})
    end)
end

local function Slider(parent, title, min, max, def, order, cb)
    local val = def or min
    local F = New("Frame", {
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = C.BgCard,
        BackgroundTransparency = 0.3,
        LayoutOrder = order or 0,
        ZIndex = 5,
        Parent = parent
    })
    Corner(F, 8)
    Pad(F, 8, 8, 12, 12)

    New("TextLabel", {
        Size = UDim2.new(0.65, 0, 0, 14),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = C.TextWhite,
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = F
    })

    local VL = New("TextLabel", {
        Size = UDim2.new(0.35, 0, 0, 14),
        Position = UDim2.new(0.65, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(val),
        TextColor3 = C.Berry,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 5,
        Parent = F
    })

    local SBG = New("Frame", {
        Size = UDim2.new(1, 0, 0, 5),
        Position = UDim2.new(0, 0, 0, 24),
        BackgroundColor3 = C.BgHover,
        ZIndex = 5,
        Parent = F
    })
    Corner(SBG, 3)

    local pct = (val - min) / (max - min)
    local SF = New("Frame", {
        Size = UDim2.new(pct, 0, 1, 0),
        BackgroundColor3 = C.Berry,
        ZIndex = 6,
        Parent = SBG
    })
    Corner(SF, 3)
    Grad(SF, C.BerryDark, C.BerryLight, 0)

    local SK = New("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(pct, -7, 0.5, -7),
        BackgroundColor3 = C.Berry,
        ZIndex = 7,
        Parent = SBG
    })
    Corner(SK, 7)
    Stroke(SK, C.Bg, 2, 0)

    local SI = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 22),
        Position = UDim2.new(0, 0, 0, 16),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 8,
        Parent = F
    })

    local sliding = false
    SI.MouseButton1Down:Connect(function() sliding = true end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then
            local p = math.clamp((i.Position.X - SBG.AbsolutePosition.X) / SBG.AbsoluteSize.X, 0, 1)
            val = math.floor(min + (max - min) * p)
            Tw(SF, 0.04, {Size = UDim2.new(p, 0, 1, 0)})
            Tw(SK, 0.04, {Position = UDim2.new(p, -7, 0.5, -7)})
            VL.Text = tostring(val)
            if cb then cb(val) end
        end
    end)
end

local function InputField(parent, title, placeholder, order, cb)
    local F = New("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = C.BgCard,
        BackgroundTransparency = 0.3,
        LayoutOrder = order or 0,
        ZIndex = 5,
        Parent = parent
    })
    Corner(F, 8)

    New("TextLabel", {
        Size = UDim2.new(0, 90, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = C.TextWhite,
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
        Parent = F
    })

    local Box = New("TextBox", {
        Size = UDim2.new(1, -115, 0, 26),
        Position = UDim2.new(0, 105, 0.5, -13),
        BackgroundColor3 = C.BgInput,
        BackgroundTransparency = 0.2,
        Text = "",
        PlaceholderText = placeholder or "",
        PlaceholderColor3 = C.TextDark,
        TextColor3 = C.BerryLight,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        ZIndex = 6,
        Parent = F
    })
    Corner(Box, 6)
    Stroke(Box, C.BorderSoft, 1, 0.4)
    Pad(Box, 0, 0, 8, 8)

    Box.Focused:Connect(function()
        Tw(Box:FindFirstChildOfClass("UIStroke"), 0.15, {Color = C.Berry, Transparency = 0})
    end)
    Box.FocusLost:Connect(function(enter)
        Tw(Box:FindFirstChildOfClass("UIStroke"), 0.15, {Color = C.BorderSoft, Transparency = 0.4})
        if enter and cb then cb(Box.Text) end
    end)

    return F, Box
end

-- Log/Console output
local function ConsoleBox(parent, order)
    local F = New("Frame", {
        Size = UDim2.new(1, 0, 0, 150),
        BackgroundColor3 = C.BgInput,
        BackgroundTransparency = 0.1,
        LayoutOrder = order or 0,
        ClipsDescendants = true,
        ZIndex = 5,
        Parent = parent
    })
    Corner(F, 8)
    Stroke(F, C.BorderSoft, 1, 0.5)

    -- Header
    local H = New("Frame", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundColor3 = C.BgCard,
        BorderSizePixel = 0,
        ZIndex = 6,
        Parent = F
    })
    Corner(H, 8)
    New("Frame", {
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 1, -8),
        BackgroundColor3 = C.BgCard,
        BorderSizePixel = 0,
        ZIndex = 6,
        Parent = H
    })
    New("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "  🖥️ Console Output",
        TextColor3 = C.TextDark,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
        Parent = H
    })

    local Scroll = New("ScrollingFrame", {
        Size = UDim2.new(1, -8, 1, -28),
        Position = UDim2.new(0, 4, 0, 26),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = C.Berry,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y,
        ZIndex = 6,
        Parent = F
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 1),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = Scroll
    })

    local lineCount = 0
    local function AddLine(text, color)
        lineCount = lineCount + 1
        New("TextLabel", {
            Size = UDim2.new(1, -8, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text = "[" .. os.date("%H:%M:%S") .. "] " .. text,
            TextColor3 = color or C.TextLight,
            TextSize = 10,
            Font = Enum.Font.Code,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            LayoutOrder = lineCount,
            ZIndex = 7,
            Parent = Scroll
        })
        -- Auto scroll to bottom
        task.wait()
        Scroll.CanvasPosition = Vector2.new(0, Scroll.AbsoluteCanvasSize.Y)
    end

    local function Clear()
        for _, c in pairs(Scroll:GetChildren()) do
            if c:IsA("TextLabel") then c:Destroy() end
        end
        lineCount = 0
    end

    return F, AddLine, Clear
end

-- ═══════════════════════════════════════════════════════════════
-- ═══════════════════════════════════════════════════════════════
--               TAB PAGES - SERVER SIDE TOOLS
-- ═══════════════════════════════════════════════════════════════
-- ═══════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════
-- 🕷️ CRAWLER TAB - Remote Spy & Scanner
-- ═══════════════════════════════════════════
local CrawlerPage = MakeTab("Crawler", "🕷️", 1)

Section(CrawlerPage, "Remote Scanner", 1)

local _, CrawlLog, ClearCrawl = ConsoleBox(CrawlerPage, 2)

local CrawlData = {
    Remotes = {},
    Events = {},
    Functions = {},
    Connections = {}
}

Button(CrawlerPage, "Scan All Remotes", "🔍", 3, function()
    ClearCrawl()
    CrawlLog("🕷️ Starting deep remote crawl...", C.Berry)
    CrawlData.Remotes = {}
    CrawlData.Events = {}
    CrawlData.Functions = {}

    local count = 0
    local function ScanContainer(container, path)
        for _, child in pairs(container:GetDescendants()) do
            if child:IsA("RemoteEvent") then
                count = count + 1
                table.insert(CrawlData.Events, {Name = child.Name, Path = child:GetFullName()})
                CrawlLog("📡 RemoteEvent: " .. child:GetFullName(), C.BerryLight)
            elseif child:IsA("RemoteFunction") then
                count = count + 1
                table.insert(CrawlData.Functions, {Name = child.Name, Path = child:GetFullName()})
                CrawlLog("📞 RemoteFunction: " .. child:GetFullName(), C.Pink)
            elseif child:IsA("BindableEvent") then
                count = count + 1
                CrawlLog("🔗 BindableEvent: " .. child:GetFullName(), C.Warning)
            elseif child:IsA("BindableFunction") then
                count = count + 1
                CrawlLog("🔗 BindableFunction: " .. child:GetFullName(), C.Warning)
            end
        end
    end

    ScanContainer(ReplicatedStorage, "ReplicatedStorage")
    ScanContainer(Workspace, "Workspace")

    pcall(function()
        local rs = game:GetService("ReplicatedFirst")
        ScanContainer(rs, "ReplicatedFirst")
    end)
    pcall(function()
        local sp = game:GetService("StarterPack")
        ScanContainer(sp, "StarterPack")
    end)
    pcall(function()
        if Player.PlayerGui then
            ScanContainer(Player.PlayerGui, "PlayerGui")
        end
    end)
    pcall(function()
        if Player.Backpack then
            ScanContainer(Player.Backpack, "Backpack")
        end
    end)
    pcall(function()
        if Player.Character then
            ScanContainer(Player.Character, "Character")
        end
    end)

    CrawlLog("", C.TextDark)
    CrawlLog("✅ Scan complete! Found " .. count .. " remotes/bindables", C.Success)
    CrawlLog("📡 Events: " .. #CrawlData.Events .. " | 📞 Functions: " .. #CrawlData.Functions, C.Info)
    Notify("Crawl Complete", "Found " .. count .. " remotes", 3, "success")
end)

Button(CrawlerPage, "Scan Hidden Services", "🔒", 4, function()
    CrawlLog("", C.TextDark)
    CrawlLog("🔒 Scanning hidden/protected services...", C.Warning)

    local services = {
        "ServerScriptService", "ServerStorage",
        "Chat", "TextChatService", "SocialService",
        "PolicyService", "MemStorageService",
        "RbxAnalyticsService", "AnalyticsService"
    }

    for _, sName in pairs(services) do
        local success, service = pcall(function()
            return game:GetService(sName)
        end)
        if success and service then
            local childCount = 0
            pcall(function()
                childCount = #service:GetChildren()
            end)
            CrawlLog("🟢 " .. sName .. " (accessible, " .. childCount .. " children)", C.Success)
        else
            CrawlLog("🔴 " .. sName .. " (blocked/protected)", C.Error)
        end
    end

    CrawlLog("✅ Hidden service scan complete", C.Success)
    Notify("Service Scan", "Hidden services scanned", 2, "crawl")
end)

Button(CrawlerPage, "Dump Remote Names to Clipboard", "📋", 5, function()
    local dump = "=== STRAWBERRY CRAWLER - REMOTE DUMP ===\n"
    dump = dump .. "Game: " .. game.PlaceId .. "\n"
    dump = dump .. "Date: " .. os.date() .. "\n\n"

    dump = dump .. "--- REMOTE EVENTS ---\n"
    for _, re in pairs(CrawlData.Events) do
        dump = dump .. re.Path .. "\n"
    end

    dump = dump .. "\n--- REMOTE FUNCTIONS ---\n"
    for _, rf in pairs(CrawlData.Functions) do
        dump = dump .. rf.Path .. "\n"
    end

    if setclipboard then
        setclipboard(dump)
        Notify("Copied!", "Remote dump copied to clipboard", 2, "success")
        CrawlLog("📋 Dumped to clipboard!", C.Success)
    else
        CrawlLog("❌ Clipboard not supported", C.Error)
    end
end)

Button(CrawlerPage, "Clear Console", "🗑️", 6, function()
    ClearCrawl()
    CrawlLog("🖥️ Console cleared", C.TextDark)
end)

-- ═══════════════════════════════════════════
-- ⚡ FIRE TAB - Remote Executor
-- ═══════════════════════════════════════════
local FirePage = MakeTab("Fire", "⚡", 2)

Section(FirePage, "Remote Executor", 1)

local _, FirePathBox = InputField(FirePage, "Path", "game.ReplicatedStorage.RemoteEvent", 2)

-- Arguments input
local ArgsFrame = New("Frame", {
    Size = UDim2.new(1, 0, 0, 80),
    BackgroundColor3 = C.BgInput,
    BackgroundTransparency = 0.1,
    LayoutOrder = 3,
    ZIndex = 5,
    Parent = FirePage
})
Corner(ArgsFrame, 8)
Stroke(ArgsFrame, C.BorderSoft, 1, 0.5)

New("TextLabel", {
    Size = UDim2.new(1, 0, 0, 22),
    BackgroundColor3 = C.BgCard,
    Text = "  📝 Arguments (Lua table format)",
    TextColor3 = C.TextDark,
    TextSize = 10,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = ArgsFrame
})
Corner(ArgsFrame, 8)

local ArgsBox = New("TextBox", {
    Size = UDim2.new(1, -12, 1, -28),
    Position = UDim2.new(0, 6, 0, 24),
    BackgroundTransparency = 1,
    Text = "",
    PlaceholderText = '{Player.Name, "argument2", 100, true}',
    PlaceholderColor3 = C.TextDark,
    TextColor3 = C.BerryLight,
    TextSize = 11,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    MultiLine = true,
    ClearTextOnFocus = false,
    TextWrapped = true,
    ZIndex = 6,
    Parent = ArgsFrame
})

local _, FireLog, ClearFire = ConsoleBox(FirePage, 4)

Button(FirePage, "Fire RemoteEvent", "📡", 5, function()
    local path = FirePathBox.Text
    if path == "" then
        Notify("Error", "Enter a remote path first", 2, "error")
        return
    end

    FireLog("📡 Firing RemoteEvent: " .. path, C.Berry)

    local success, result = pcall(function()
        local remote = nil
        -- Try to resolve path
        local current = game
        for part in path:gmatch("[^%.]+") do
            if part == "game" then
                current = game
            else
                current = current:FindFirstChild(part)
                if not current then
                    -- Try WaitForChild briefly
                    current = game
                    for p in path:gmatch("[^%.]+") do
                        if p ~= "game" then
                            current = current:WaitForChild(p, 1)
                            if not current then error("Could not find: " .. p) end
                        end
                    end
                    break
                end
            end
        end
        remote = current

        if remote and remote:IsA("RemoteEvent") then
            -- Parse arguments
            local args = {}
            if ArgsBox.Text ~= "" then
                local argFunc = loadstring("return " .. ArgsBox.Text)
                if argFunc then
                    args = argFunc()
                    if type(args) ~= "table" then args = {args} end
                end
            end
            remote:FireServer(unpack(args))
            return "Fired successfully with " .. #args .. " args"
        else
            error("Not a valid RemoteEvent")
        end
    end)

    if success then
        FireLog("✅ " .. tostring(result), C.Success)
        Notify("Fired!", result, 2, "success")
    else
        FireLog("❌ Error: " .. tostring(result), C.Error)
        Notify("Fire Failed", tostring(result), 3, "error")
    end
end)

Button(FirePage, "Invoke RemoteFunction", "📞", 6, function()
    local path = FirePathBox.Text
    if path == "" then
        Notify("Error", "Enter a remote path first", 2, "error")
        return
    end

    FireLog("📞 Invoking RemoteFunction: " .. path, C.Pink)

    local success, result = pcall(function()
        local current = game
        for part in path:gmatch("[^%.]+") do
            if part ~= "game" then
                current = current:FindFirstChild(part) or current:WaitForChild(part, 2)
                if not current then error("Could not find path segment") end
            end
        end

        if current and current:IsA("RemoteFunction") then
            local args = {}
            if ArgsBox.Text ~= "" then
                local argFunc = loadstring("return " .. ArgsBox.Text)
                if argFunc then
                    args = argFunc()
                    if type(args) ~= "table" then args = {args} end
                end
            end
            return current:InvokeServer(unpack(args))
        else
            error("Not a valid RemoteFunction")
        end
    end)

    if success then
        local resultStr = tostring(result)
        if type(result) == "table" then
            pcall(function()
                resultStr = HttpService:JSONEncode(result)
            end)
        end
        FireLog("✅ Result: " .. resultStr, C.Success)
        Notify("Invoked!", "Got response", 2, "success")
    else
        FireLog("❌ Error: " .. tostring(result), C.Error)
        Notify("Invoke Failed", tostring(result), 3, "error")
    end
end)

Button(FirePage, "Mass Fire All Found Events", "💥", 7, function()
    if #CrawlData.Events == 0 then
        Notify("No Data", "Run crawler scan first!", 2, "warning")
        FireLog("⚠️ No events found - run crawler first", C.Warning)
        return
    end

    FireLog("💥 Mass firing " .. #CrawlData.Events .. " events...", C.Warning)
    local fired = 0
    local failed = 0

    for _, re in pairs(CrawlData.Events) do
        local s, e = pcall(function()
            local current = game
            for part in re.Path:gmatch("[^%.]+") do
                if part ~= "game" then
                    current = current:FindFirstChild(part)
                    if not current then error("Not found") end
                end
            end
            if current:IsA("RemoteEvent") then
                current:FireServer()
                fired = fired + 1
            end
        end)
        if not s then
            failed = failed + 1
        end
    end

    FireLog("✅ Mass fire complete: " .. fired .. " fired, " .. failed .. " failed", C.Success)
    Notify("Mass Fire", fired .. " events fired", 3, "success")
end)

Button(FirePage, "Clear Fire Log", "🗑️", 8, function()
    ClearFire()
    FireLog("🖥️ Log cleared", C.TextDark)
end)

-- ═══════════════════════════════════════════
-- 🛡️ BYPASS TAB
-- ═══════════════════════════════════════════
local BypassPage = MakeTab("Bypass", "🛡️", 3)

Section(BypassPage, "Anti-Cheat Bypass", 1)

local _, BypassLog, ClearBypass = ConsoleBox(BypassPage, 2)

Toggle(BypassPage, "Anti-Kick Protection", "Block server kick attempts", false, 3, function(on)
    if on then
        local mt = getrawmetatable(game)
        if mt and setreadonly then
            local oldNamecall = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" or method == "kick" then
                    BypassLog("🛡️ Blocked kick attempt!", C.Success)
                    Notify("Blocked!", "Kick attempt intercepted", 2, "success")
                    return
                end
                return oldNamecall(self, ...)
            end)
            setreadonly(mt, true)
            BypassLog("🛡️ Anti-Kick hook installed", C.Success)
        else
            BypassLog("⚠️ Metatable functions not available", C.Warning)
        end
        Notify("Anti-Kick", "Protection enabled", 2, "success")
    else
        BypassLog("🛡️ Anti-Kick disabled (requires rejoin to fully remove)", C.Warning)
        Notify("Anti-Kick", "Protection disabled", 2)
    end
end)

Toggle(BypassPage, "Anti-Teleport", "Block forced teleports", false, 4, function(on)
    if on then
        local TeleportService = game:GetService("TeleportService")
        local mt = getrawmetatable(game)
        if mt and setreadonly then
            local oldIdx = mt.__index
            setreadonly(mt, false)
            mt.__index = newcclosure(function(self, key)
                if self == TeleportService and (key == "Teleport" or key == "TeleportToPlaceInstance") then
                    BypassLog("🛡️ Blocked teleport attempt: " .. key, C.Success)
                    return function() end
                end
                return oldIdx(self, key)
            end)
            setreadonly(mt, true)
            BypassLog("🛡️ Anti-Teleport hook installed", C.Success)
        end
        Notify("Anti-Teleport", "Teleport blocking enabled", 2, "success")
    else
        Notify("Anti-Teleport", "Disabled", 2)
    end
end)

Toggle(BypassPage, "Namecall Hook", "Hook __namecall for monitoring", false, 5, function(on)
    if on then
        local mt = getrawmetatable(game)
        if mt and setreadonly then
            local oldNamecall = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if self:IsA("RemoteEvent") and method == "FireServer" then
                    BypassLog("📡 " .. self.Name .. ":FireServer(" .. tostring(select(1,...) or "") .. ")", C.BerryLight)
                elseif self:IsA("RemoteFunction") and method == "InvokeServer" then
                    BypassLog("📞 " .. self.Name .. ":InvokeServer(" .. tostring(select(1,...) or "") .. ")", C.Pink)
                end
                return oldNamecall(self, ...)
            end)
            setreadonly(mt, true)
            BypassLog("🕷️ Namecall spy active - monitoring all remote calls", C.Success)
        else
            BypassLog("⚠️ getrawmetatable/setreadonly not available", C.Warning)
        end
        Notify("Namecall Hook", "Monitoring remote calls", 2, "crawl")
    else
        Notify("Namecall Hook", "Disabled (rejoin to remove)", 2)
    end
end)

Section(BypassPage, "Network Tools", 6)

Button(BypassPage, "Spoof Walk Speed (Server)", "🏃", 7, function()
    BypassLog("🏃 Attempting walkspeed spoof via remotes...", C.Info)

    -- Try common patterns
    local patterns = {
        "SetWalkSpeed", "WalkSpeed", "Speed", "SetSpeed",
        "PlayerSpeed", "MoveSpeed", "UpdateSpeed"
    }

    local found = false
    for _, child in pairs(ReplicatedStorage:GetDescendants()) do
        if child:IsA("RemoteEvent") then
            for _, pattern in pairs(patterns) do
                if child.Name:lower():find(pattern:lower()) then
                    BypassLog("🔍 Found potential: " .. child:GetFullName(), C.BerryLight)
                    found = true
                end
            end
        end
    end

    if not found then
        BypassLog("⚠️ No speed-related remotes found", C.Warning)
        BypassLog("💡 Try scanning with Crawler first", C.Info)
    end
    Notify("Speed Spoof", "Scan complete", 2, "info")
end)

Button(BypassPage, "Detect Anti-Cheat Type", "🔍", 8, function()
    BypassLog("🔍 Analyzing anti-cheat systems...", C.Info)

    -- Check for common AC patterns
    local acSigns = {
        {Name = "Adonis", Check = function()
            return game.ReplicatedStorage:FindFirstChild("Adonis") or game.ReplicatedStorage:FindFirstChild("_Adonis")
        end},
        {Name = "Byfron (Hyperion)", Check = function()
            return game:GetService("GuiService"):FindFirstChild("ByfronCheck") ~= nil
        end},
        {Name = "ServerSide Validator", Check = function()
            local found = false
            for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") and (v.Name:lower():find("valid") or v.Name:lower():find("check") or v.Name:lower():find("verify")) then
                    found = true
                end
            end
            return found
        end},
        {Name = "Heartbeat Monitor", Check = function()
            local found = false
            for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") and (v.Name:lower():find("heartbeat") or v.Name:lower():find("ping") or v.Name:lower():find("alive")) then
                    found = true
                end
            end
            return found
        end},
        {Name = "Character Validator", Check = function()
            local found = false
            for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") and (v.Name:lower():find("character") or v.Name:lower():find("humanoid")) then
                    found = true
                end
            end
            return found
        end}
    }

    for _, ac in pairs(acSigns) do
        local s, detected = pcall(ac.Check)
        if s and detected then
            BypassLog("🔴 Detected: " .. ac.Name, C.Error)
        else
            BypassLog("🟢 Not Found: " .. ac.Name, C.Success)
        end
    end

    BypassLog("✅ AC analysis complete", C.Success)
    Notify("AC Detection", "Anti-cheat analysis done", 2, "info")
end)

Button(BypassPage, "Clear Bypass Log", "🗑️", 9, function()
    ClearBypass()
    BypassLog("🖥️ Log cleared", C.TextDark)
end)

-- ═══════════════════════════════════════════
-- 🎯 EXPLOITS TAB
-- ═══════════════════════════════════════════
local ExploitsPage = MakeTab("Exploits", "🎯", 4)

Section(ExploitsPage, "Player Exploits", 1)

Slider(ExploitsPage, "Walk Speed", 16, 500, 16, 2, function(v)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = v
    end
end)

Slider(ExploitsPage, "Jump Power", 50, 500, 50, 3, function(v)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.JumpPower = v
    end
end)

Toggle(ExploitsPage, "Infinite Jump", "Jump unlimited in air", false, 4, function(on)
    _G.InfJump = on
    Notify(on and "Enabled" or "Disabled", "Infinite Jump", 1.5, on and "success" or nil)
end)
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

Toggle(ExploitsPage, "Noclip", "Walk through everything", false, 5, function(on)
    _G.Noclip = on
    Notify(on and "Enabled" or "Disabled", "Noclip", 1.5, on and "success" or nil)
end)
RunService.Stepped:Connect(function()
    if _G.Noclip and Player.Character then
        for _, p in pairs(Player.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

Toggle(ExploitsPage, "Fly Mode", "Fly around the map", false, 6, function(on)
    _G.Flying = on
    if on then
        local bp = Instance.new("BodyPosition")
        bp.Name = "StrawberryFly"
        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bp.D = 100
        bp.P = 10000
        bp.Parent = Player.Character.HumanoidRootPart

        local bg = Instance.new("BodyGyro")
        bg.Name = "StrawberryGyro"
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.D = 100
        bg.P = 10000
        bg.Parent = Player.Character.HumanoidRootPart

        spawn(function()
            while _G.Flying and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") do
                local hrp = Player.Character.HumanoidRootPart
                local cam = Workspace.CurrentCamera
                bp.Position = hrp.Position + (cam.CFrame.LookVector * (UserInputService:IsKeyDown(Enum.KeyCode.W) and 2 or 0))
                    + (cam.CFrame.LookVector * (UserInputService:IsKeyDown(Enum.KeyCode.S) and -2 or 0))
                    + (cam.CFrame.RightVector * (UserInputService:IsKeyDown(Enum.KeyCode.D) and 2 or 0))
                    + (cam.CFrame.RightVector * (UserInputService:IsKeyDown(Enum.KeyCode.A) and -2 or 0))
                    + Vector3.new(0, UserInputService:IsKeyDown(Enum.KeyCode.Space) and 2 or 0, 0)
                    - Vector3.new(0, UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 2 or 0, 0)
                bg.CFrame = cam.CFrame
                RunService.RenderStepped:Wait()
            end
        end)
        Notify("Fly", "WASD + Space/Shift to move", 3, "success")
    else
        pcall(function()
            Player.Character.HumanoidRootPart:FindFirstChild("StrawberryFly"):Destroy()
            Player.Character.HumanoidRootPart:FindFirstChild("StrawberryGyro"):Destroy()
        end)
    end
end)

Section(ExploitsPage, "Utility", 7)

Button(ExploitsPage, "TP to Mouse", "📍", 8, function()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        Notify("Teleported", "Moved to cursor", 1.5, "success")
    end
end)

Button(ExploitsPage, "Fullbright", "💡", 9, function()
    local L = game:GetService("Lighting")
    L.Brightness = 2
    L.ClockTime = 14
    L.FogEnd = 100000
    L.GlobalShadows = false
    for _, e in pairs(L:GetDescendants()) do
        if e:IsA("Atmosphere") or e:IsA("BloomEffect") or e:IsA("BlurEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("DepthOfFieldEffect") then
            e.Enabled = false
        end
    end
    Notify("Fullbright", "Lighting maxed", 1.5, "success")
end)

Button(ExploitsPage, "Rejoin Server", "🔄", 10, function()
    Notify("Rejoining", "Teleporting...", 1.5, "warning")
    task.wait(1)
    game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
end)

Button(ExploitsPage, "Copy Server Link", "🔗", 11, function()
    if setclipboard then
        setclipboard("roblox://placeId=" .. game.PlaceId .. "&gameInstanceId=" .. game.JobId)
        Notify("Copied!", "Server link copied", 1.5, "success")
    end
end)

-- ═══════════════════════════════════════════
-- 📜 EXECUTOR TAB
-- ═══════════════════════════════════════════
local ExecPage = MakeTab("Execute", "📜", 5)

Section(ExecPage, "Script Editor", 1)

local EditorFrame = New("Frame", {
    Size = UDim2.new(1, 0, 0, 200),
    BackgroundColor3 = C.BgInput,
    BackgroundTransparency = 0.05,
    LayoutOrder = 2,
    ClipsDescendants = true,
    ZIndex = 5,
    Parent = ExecPage
})
Corner(EditorFrame, 8)
Stroke(EditorFrame, C.BorderSoft, 1, 0.4)

-- Editor header
local EH = New("Frame", {
    Size = UDim2.new(1, 0, 0, 26),
    BackgroundColor3 = C.BgCard,
    BorderSizePixel = 0,
    ZIndex = 6,
    Parent = EditorFrame
})
Corner(EH, 8)
New("Frame", {
    Size = UDim2.new(1, 0, 0, 8),
    Position = UDim2.new(0, 0, 1, -8),
    BackgroundColor3 = C.BgCard,
    BorderSizePixel = 0,
    ZIndex = 6,
    Parent = EH
})

-- Tab dots
for i, col in pairs({C.Error, C.Warning, C.Success}) do
    New("Frame", {
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0, 8 + (i - 1) * 16, 0.5, -5),
        BackgroundColor3 = col,
        BackgroundTransparency = 0.3,
        ZIndex = 7,
        Parent = EH
    })
    Corner(New("Frame", {Size = UDim2.new(0,0,0,0), Parent = EH}), 5) -- dummy for last corner
    -- Fix: apply corner to the dot
end

New("TextLabel", {
    Size = UDim2.new(1, -60, 1, 0),
    Position = UDim2.new(0, 58, 0, 0),
    BackgroundTransparency = 1,
    Text = "script.lua — Strawberry Editor",
    TextColor3 = C.TextDark,
    TextSize = 10,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 7,
    Parent = EH
})

local ScriptBox = New("TextBox", {
    Size = UDim2.new(1, -12, 1, -32),
    Position = UDim2.new(0, 6, 0, 28),
    BackgroundTransparency = 1,
    Text = "",
    PlaceholderText = "-- 🍓 Paste your script here\n-- Strawberry Crawler\nprint('Hello from Strawberry!')",
    PlaceholderColor3 = C.TextDark,
    TextColor3 = C.BerryPale,
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
    Tw(EditorFrame:FindFirstChildOfClass("UIStroke"), 0.15, {Color = C.Berry, Transparency = 0})
end)
ScriptBox.FocusLost:Connect(function()
    Tw(EditorFrame:FindFirstChildOfClass("UIStroke"), 0.15, {Color = C.BorderSoft, Transparency = 0.4})
end)

-- Exec buttons row
local ExecBtns = New("Frame", {
    Size = UDim2.new(1, 0, 0, 34),
    BackgroundTransparency = 1,
    LayoutOrder = 3,
    ZIndex = 5,
    Parent = ExecPage
})
New("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = ExecBtns
})

local function ExecActionBtn(txt, icon, col, order, cb)
    local b = New("TextButton", {
        Size = UDim2.new(0, 105, 0, 34),
        BackgroundColor3 = col,
        BackgroundTransparency = 0.83,
        Text = icon .. " " .. txt,
        TextColor3 = col,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        LayoutOrder = order,
        ZIndex = 6,
        Parent = ExecBtns
    })
    Corner(b, 8)
    Stroke(b, col, 1, 0.5)

    b.MouseEnter:Connect(function() Tw(b, 0.12, {BackgroundTransparency = 0.5}) end)
    b.MouseLeave:Connect(function() Tw(b, 0.12, {BackgroundTransparency = 0.83}) end)
    b.MouseButton1Click:Connect(function()
        Tw(b, 0.05, {Size = UDim2.new(0, 100, 0, 31)})
        task.wait(0.05)
        Tw(b, 0.1, {Size = UDim2.new(0, 105, 0, 34)}, Enum.EasingStyle.Back)
        if cb then cb() end
    end)
end

ExecActionBtn("Execute", "▶", C.Berry, 1, function()
    if ScriptBox.Text ~= "" then
        local s, e = pcall(function() loadstring(ScriptBox.Text)() end)
        if s then
            Notify("Executed!", "Script ran successfully", 2, "success")
        else
            Notify("Error", tostring(e), 3, "error")
        end
    else
        Notify("Empty", "Write a script first", 2, "warning")
    end
end)

ExecActionBtn("Clear", "🗑️", C.Error, 2, function()
    ScriptBox.Text = ""
    Notify("Cleared", "Editor cleared", 1, "info")
end)

ExecActionBtn("Copy", "📋", C.TextMuted, 3, function()
    if setclipboard then
        setclipboard(ScriptBox.Text)
        Notify("Copied", "Script copied", 1, "success")
    end
end)

ExecActionBtn("Loadstring", "🔗", C.Info, 4, function()
    Notify("Loadstring", "Paste a loadstring URL", 2, "info")
end)

-- ═══════════════════════════════════════════
-- ⚙️ SETTINGS TAB
-- ═══════════════════════════════════════════
local SettingsPage = MakeTab("Settings", "⚙️", 6)

Section(SettingsPage, "GUI Settings", 1)

Toggle(SettingsPage, "Toggle Keybind (RightShift)", "Press to show/hide GUI", true, 2, function(on)
    _G.KeybindOn = on
end)
_G.KeybindOn = true

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift and _G.KeybindOn then
        Main.Visible = not Main.Visible
    end
end)

Slider(SettingsPage, "GUI Opacity", 0, 60, 0, 3, function(v)
    Main.BackgroundTransparency = v / 100
end)

Section(SettingsPage, "About", 4)

-- Info card
local InfoCard = New("Frame", {
    Size = UDim2.new(1, 0, 0, 140),
    BackgroundColor3 = C.BgCard,
    BackgroundTransparency = 0.2,
    LayoutOrder = 5,
    ZIndex = 5,
    Parent = SettingsPage
})
Corner(InfoCard, 10)
Stroke(InfoCard, C.Berry, 1, 0.7)
Pad(InfoCard, 12, 12, 14, 14)

local InfoLayout = New("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = InfoCard
})

local infoData = {
    {"🍓 Hub:", "Strawberry Crawler v1.0"},
    {"🎮 Game:", "Loading..."},
    {"👤 Player:", Player.Name .. " (@" .. Player.DisplayName .. ")"},
    {"🔑 Executor:", "Delta"},
    {"📡 Server:", tostring(#Players:GetPlayers()) .. " / " .. Players.MaxPlayers .. " players"},
    {"🆔 PlaceId:", tostring(game.PlaceId)},
    {"🌐 JobId:", string.sub(game.JobId, 1, 16) .. "..."}
}

-- Get game name
pcall(function()
    infoData[2][2] = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)

for i, info in ipairs(infoData) do
    local Row = New("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundTransparency = 1,
        LayoutOrder = i,
        ZIndex = 6,
        Parent = InfoCard
    })
    New("TextLabel", {
        Size = UDim2.new(0, 85, 1, 0),
        BackgroundTransparency = 1,
        Text = info[1],
        TextColor3 = C.TextDark,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
        Parent = Row
    })
    New("TextLabel", {
        Size = UDim2.new(1, -90, 1, 0),
        Position = UDim2.new(0, 90, 0, 0),
        BackgroundTransparency = 1,
        Text = info[2],
        TextColor3 = C.TextLight,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 6,
        Parent = Row
    })
end

Section(SettingsPage, "Danger Zone", 6)

Button(SettingsPage, "Destroy GUI", "💀", 7, function()
    Notify("Goodbye! 🍓", "Destroying Strawberry Crawler...", 1.5, "error")
    task.wait(1.5)
    Gui:Destroy()
end)

-- ═══════════════════════════════════════════
-- STATUS BAR
-- ═══════════════════════════════════════════
local StatusBar = New("Frame", {
    Size = UDim2.new(1, -10, 0, 20),
    Position = UDim2.new(0, 5, 1, -25),
    BackgroundColor3 = C.BgDark,
    BackgroundTransparency = 0.2,
    ZIndex = 10,
    Parent = Main
})
Corner(StatusBar, 5)

local StatusText = New("TextLabel", {
    Size = UDim2.new(1, -10, 1, 0),
    Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    Text = "🍓 Loading...",
    TextColor3 = C.TextDark,
    TextSize = 9,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 11,
    Parent = StatusBar
})

spawn(function()
    while StatusBar and StatusBar.Parent do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        StatusText.Text = "🍓 Strawberry Crawler  |  🟢 Active  |  ⏱️ " .. os.date("%H:%M:%S") .. "  |  FPS: " .. fps .. "  |  📡 Remotes: " .. (#CrawlData.Events + #CrawlData.Functions)
    end
end)

-- ═══════════════════════════════════════════
-- SET DEFAULT TAB + OPENING ANIMATION
-- ═══════════════════════════════════════════
task.wait(0.1)
Tabs["Crawler"].Btn.MouseButton1Click:Fire()

-- Opening animation
Main.Size = UDim2.new(0, 0, 0, 0)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.BackgroundTransparency = 1

Tw(Main, 0.5, {
    Size = UDim2.new(0, 640, 0, 460),
    Position = UDim2.new(0.5, -320, 0.5, -230),
    BackgroundTransparency = 0
}, Enum.EasingStyle.Back)

task.wait(0.6)

Notify("🍓 Strawberry Crawler", "Server-side exploit tool loaded!", 4, "success")
Notify("Crawler Ready", "Start by scanning remotes in the Crawler tab", 3, "crawl")

print("🍓 Strawberry Crawler v1.0 - Loaded!")
