-- 🍓 Strawberry Hub - Modern Delta Executor GUI
-- Full featured with animations, tabs, and strawberry theme

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- ═══════════════════════════════════════════════
-- 🎨 STRAWBERRY THEME COLORS
-- ═══════════════════════════════════════════════
local Theme = {
    Primary = Color3.fromRGB(220, 40, 60),        -- Strawberry Red
    PrimaryDark = Color3.fromRGB(180, 30, 50),     -- Dark Strawberry
    PrimaryLight = Color3.fromRGB(255, 99, 120),   -- Light Strawberry
    Secondary = Color3.fromRGB(255, 140, 160),     -- Pink Strawberry
    Accent = Color3.fromRGB(80, 160, 60),          -- Strawberry Leaf Green
    AccentLight = Color3.fromRGB(120, 200, 90),    -- Light Green
    Background = Color3.fromRGB(18, 15, 20),       -- Dark BG
    BackgroundLight = Color3.fromRGB(28, 24, 32),  -- Lighter BG
    Card = Color3.fromRGB(35, 30, 40),             -- Card BG
    CardHover = Color3.fromRGB(45, 38, 52),        -- Card Hover
    Surface = Color3.fromRGB(42, 36, 50),          -- Surface
    TextPrimary = Color3.fromRGB(255, 255, 255),   -- White Text
    TextSecondary = Color3.fromRGB(180, 170, 190), -- Gray Text
    TextMuted = Color3.fromRGB(120, 110, 130),     -- Muted Text
    Border = Color3.fromRGB(60, 50, 70),           -- Border
    Shadow = Color3.fromRGB(0, 0, 0),              -- Shadow
    Success = Color3.fromRGB(80, 200, 120),        -- Green
    Warning = Color3.fromRGB(255, 180, 50),        -- Yellow
    Error = Color3.fromRGB(255, 80, 80),           -- Red
    GradientStart = Color3.fromRGB(220, 40, 60),   -- Gradient Start
    GradientEnd = Color3.fromRGB(255, 100, 130),   -- Gradient End
}

-- ═══════════════════════════════════════════════
-- 🧹 CLEANUP OLD GUI
-- ═══════════════════════════════════════════════
if game.CoreGui:FindFirstChild("StrawberryHub") then
    game.CoreGui:FindFirstChild("StrawberryHub"):Destroy()
end

-- ═══════════════════════════════════════════════
-- 🖥️ MAIN SCREENGUI
-- ═══════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StrawberryHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- ═══════════════════════════════════════════════
-- 🛠️ UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════
local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.5
    stroke.Parent = parent
    return stroke
end

local function CreateGradient(parent, startColor, endColor, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, startColor or Theme.GradientStart),
        ColorSequenceKeypoint.new(1, endColor or Theme.GradientEnd)
    })
    gradient.Rotation = rotation or 45
    gradient.Parent = parent
    return gradient
end

local function CreatePadding(parent, top, bottom, left, right)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, top or 8)
    padding.PaddingBottom = UDim.new(0, bottom or 8)
    padding.PaddingLeft = UDim.new(0, left or 8)
    padding.PaddingRight = UDim.new(0, right or 8)
    padding.Parent = parent
    return padding
end

local function CreateShadow(parent, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = parent
    return shadow
end

local function Tween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function Ripple(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 5
    ripple.Parent = button
    CreateCorner(ripple, 100)
    
    local mousePos = UserInputService:GetMouseLocation()
    local relativePos = Vector2.new(
        mousePos.X - button.AbsolutePosition.X,
        mousePos.Y - button.AbsolutePosition.Y
    )
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    
    ripple.Position = UDim2.new(0, relativePos.X, 0, relativePos.Y)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    
    Tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, 0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    task.delay(0.6, function()
        ripple:Destroy()
    end)
end

-- ═══════════════════════════════════════════════
-- 🍓 NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════
local NotificationHolder = Instance.new("Frame")
NotificationHolder.Name = "NotificationHolder"
NotificationHolder.BackgroundTransparency = 1
NotificationHolder.Position = UDim2.new(1, -320, 0, 10)
NotificationHolder.Size = UDim2.new(0, 310, 1, -20)
NotificationHolder.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 8)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotifLayout.Parent = NotificationHolder

local function Notify(title, message, notifType, duration)
    local typeColors = {
        success = Theme.Success,
        warning = Theme.Warning,
        error = Theme.Error,
        info = Theme.Primary
    }
    local typeIcons = {
        success = "✅",
        warning = "⚠️",
        error = "❌",
        info = "🍓"
    }
    
    local color = typeColors[notifType] or Theme.Primary
    local icon = typeIcons[notifType] or "🍓"
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "Notification"
    NotifFrame.BackgroundColor3 = Theme.Card
    NotifFrame.Size = UDim2.new(1, 0, 0, 70)
    NotifFrame.ClipsDescendants = true
    NotifFrame.Parent = NotificationHolder
    CreateCorner(NotifFrame, 10)
    CreateStroke(NotifFrame, color, 1, 0.3)
    CreateShadow(NotifFrame, 0.6)
    
    -- Accent bar
    local AccentBar = Instance.new("Frame")
    AccentBar.BackgroundColor3 = color
    AccentBar.Size = UDim2.new(0, 4, 1, 0)
    AccentBar.BorderSizePixel = 0
    AccentBar.Parent = NotifFrame
    CreateCorner(AccentBar, 2)
    
    -- Icon
    local IconLabel = Instance.new("TextLabel")
    IconLabel.BackgroundTransparency = 1
    IconLabel.Position = UDim2.new(0, 16, 0, 12)
    IconLabel.Size = UDim2.new(0, 30, 0, 30)
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.Text = icon
    IconLabel.TextSize = 20
    IconLabel.Parent = NotifFrame
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 50, 0, 10)
    TitleLabel.Size = UDim2.new(1, -100, 0, 20)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Theme.TextPrimary
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = NotifFrame
    
    -- Message
    local MsgLabel = Instance.new("TextLabel")
    MsgLabel.BackgroundTransparency = 1
    MsgLabel.Position = UDim2.new(0, 50, 0, 32)
    MsgLabel.Size = UDim2.new(1, -60, 0, 30)
    MsgLabel.Font = Enum.Font.Gotham
    MsgLabel.Text = message
    MsgLabel.TextColor3 = Theme.TextSecondary
    MsgLabel.TextSize = 11
    MsgLabel.TextXAlignment = Enum.TextXAlignment.Left
    MsgLabel.TextWrapped = true
    MsgLabel.Parent = NotifFrame
    
    -- Progress bar
    local ProgressBar = Instance.new("Frame")
    ProgressBar.BackgroundColor3 = color
    ProgressBar.BackgroundTransparency = 0.5
    ProgressBar.Position = UDim2.new(0, 0, 1, -3)
    ProgressBar.Size = UDim2.new(1, 0, 0, 3)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = NotifFrame
    
    -- Animate in
    NotifFrame.BackgroundTransparency = 1
    TitleLabel.TextTransparency = 1
    MsgLabel.TextTransparency = 1
    AccentBar.BackgroundTransparency = 1
    
    Tween(NotifFrame, {BackgroundTransparency = 0}, 0.3)
    Tween(TitleLabel, {TextTransparency = 0}, 0.3)
    Tween(MsgLabel, {TextTransparency = 0}, 0.3)
    Tween(AccentBar, {BackgroundTransparency = 0}, 0.3)
    
    -- Progress animation
    Tween(ProgressBar, {Size = UDim2.new(0, 0, 0, 3)}, duration or 4, Enum.EasingStyle.Linear)
    
    -- Animate out
    task.delay(duration or 4, function()
        Tween(NotifFrame, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)}, 0.4)
        Tween(TitleLabel, {TextTransparency = 1}, 0.3)
        Tween(MsgLabel, {TextTransparency = 1}, 0.3)
        task.delay(0.5, function()
            NotifFrame:Destroy()
        end)
    end)
end

-- ═══════════════════════════════════════════════
-- 🍓 MAIN WINDOW
-- ═══════════════════════════════════════════════
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
MainFrame.Size = UDim2.new(0, 650, 0, 450)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
CreateCorner(MainFrame, 12)
CreateShadow(MainFrame, 0.3)

local MainStroke = CreateStroke(MainFrame, Theme.PrimaryDark, 1.5, 0.4)

-- ═══════════════════════════════════════════════
-- 🎨 BACKGROUND DECORATIONS
-- ═══════════════════════════════════════════════
local BgDecor1 = Instance.new("Frame")
BgDecor1.Name = "BgDecor1"
BgDecor1.BackgroundColor3 = Theme.Primary
BgDecor1.BackgroundTransparency = 0.93
BgDecor1.Position = UDim2.new(0.7, 0, -0.1, 0)
BgDecor1.Size = UDim2.new(0, 200, 0, 200)
BgDecor1.ZIndex = 1
BgDecor1.Parent = MainFrame
CreateCorner(BgDecor1, 100)

local BgDecor2 = Instance.new("Frame")
BgDecor2.Name = "BgDecor2"
BgDecor2.BackgroundColor3 = Theme.Secondary
BgDecor2.BackgroundTransparency = 0.95
BgDecor2.Position = UDim2.new(-0.05, 0, 0.6, 0)
BgDecor2.Size = UDim2.new(0, 180, 0, 180)
BgDecor2.ZIndex = 1
BgDecor2.Parent = MainFrame
CreateCorner(BgDecor2, 100)

-- Float animation for decorations
spawn(function()
    while MainFrame and MainFrame.Parent do
        Tween(BgDecor1, {Position = UDim2.new(0.7, 0, -0.05, 0)}, 3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(3)
        Tween(BgDecor1, {Position = UDim2.new(0.7, 0, -0.1, 0)}, 3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(3)
    end
end)

-- ═══════════════════════════════════════════════
-- 📌 TITLE BAR
-- ═══════════════════════════════════════════════
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.BackgroundColor3 = Theme.BackgroundLight
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.ZIndex = 10
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 12)
TitleBarCorner.Parent = TitleBar

-- Bottom cover for title bar (removes bottom radius)
local TitleBarCover = Instance.new("Frame")
TitleBarCover.BackgroundColor3 = Theme.BackgroundLight
TitleBarCover.Size = UDim2.new(1, 0, 0, 15)
TitleBarCover.Position = UDim2.new(0, 0, 1, -15)
TitleBarCover.BorderSizePixel = 0
TitleBarCover.ZIndex = 10
TitleBarCover.Parent = TitleBar

-- Title gradient bar
local TitleGradientBar = Instance.new("Frame")
TitleGradientBar.BackgroundColor3 = Color3.new(1, 1, 1)
TitleGradientBar.Size = UDim2.new(1, 0, 0, 2)
TitleGradientBar.Position = UDim2.new(0, 0, 1, 0)
TitleGradientBar.BorderSizePixel = 0
TitleGradientBar.ZIndex = 11
TitleGradientBar.Parent = TitleBar
CreateGradient(TitleGradientBar, Theme.Primary, Theme.Secondary, 0)

-- Strawberry Icon
local StrawberryIcon = Instance.new("TextLabel")
StrawberryIcon.Name = "StrawberryIcon"
StrawberryIcon.BackgroundTransparency = 1
StrawberryIcon.Position = UDim2.new(0, 12, 0, 5)
StrawberryIcon.Size = UDim2.new(0, 32, 0, 32)
StrawberryIcon.ZIndex = 11
StrawberryIcon.Font = Enum.Font.GothamBold
StrawberryIcon.Text = "🍓"
StrawberryIcon.TextSize = 22
StrawberryIcon.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 46, 0, 0)
TitleText.Size = UDim2.new(0, 200, 1, 0)
TitleText.ZIndex = 11
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "Strawberry Hub"
TitleText.TextColor3 = Theme.TextPrimary
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Version Badge
local VersionBadge = Instance.new("Frame")
VersionBadge.BackgroundColor3 = Theme.Primary
VersionBadge.BackgroundTransparency = 0.7
VersionBadge.Position = UDim2.new(0, 195, 0.5, -10)
VersionBadge.Size = UDim2.new(0, 42, 0, 20)
VersionBadge.ZIndex = 11
VersionBadge.Parent = TitleBar
CreateCorner(VersionBadge, 6)

local VersionText = Instance.new("TextLabel")
VersionText.BackgroundTransparency = 1
VersionText.Size = UDim2.new(1, 0, 1, 0)
VersionText.ZIndex = 12
VersionText.Font = Enum.Font.GothamBold
VersionText.Text = "v2.0"
VersionText.TextColor3 = Theme.PrimaryLight
VersionText.TextSize = 10
VersionText.Parent = VersionBadge

-- ═══════════════════════════════════════════════
-- ❌ WINDOW CONTROLS
-- ═══════════════════════════════════════════════
local function CreateWindowButton(name, text, color, position)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.8
    btn.Position = position
    btn.Size = UDim2.new(0, 28, 0, 28)
    btn.ZIndex = 12
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Theme.TextSecondary
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.Parent = TitleBar
    CreateCorner(btn, 8)
    
    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundTransparency = 0.3, TextColor3 = Theme.TextPrimary}, 0.2)
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, {BackgroundTransparency = 0.8, TextColor3 = Theme.TextSecondary}, 0.2)
    end)
    
    return btn
end

local CloseBtn = CreateWindowButton("Close", "✕", Theme.Error, UDim2.new(1, -38, 0, 7))
local MinimizeBtn = CreateWindowButton("Minimize", "─", Theme.Warning, UDim2.new(1, -72, 0, 7))

-- Close functionality
CloseBtn.MouseButton1Click:Connect(function()
    Ripple(CloseBtn)
    Tween(MainFrame, {
        Size = UDim2.new(0, 650, 0, 0),
        Position = UDim2.new(0.5, -325, 0.5, 0),
        BackgroundTransparency = 1
    }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.wait(0.5)
    ScreenGui:Destroy()
end)

-- Minimize functionality
local minimized = false
local savedSize = MainFrame.Size
local savedPos = MainFrame.Position

MinimizeBtn.MouseButton1Click:Connect(function()
    Ripple(MinimizeBtn)
    minimized = not minimized
    if minimized then
        savedSize = MainFrame.Size
        savedPos = MainFrame.Position
        Tween(MainFrame, {Size = UDim2.new(0, 650, 0, 42)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    else
        Tween(MainFrame, {Size = savedSize}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end
end)

-- ═══════════════════════════════════════════════
-- 🖱️ DRAGGING SYSTEM
-- ═══════════════════════════════════════════════
local dragging, dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ═══════════════════════════════════════════════
-- 📑 SIDEBAR NAVIGATION
-- ═══════════════════════════════════════════════
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.BackgroundColor3 = Theme.BackgroundLight
Sidebar.Position = UDim2.new(0, 0, 0, 44)
Sidebar.Size = UDim2.new(0, 160, 1, -44)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 5
Sidebar.Parent = MainFrame

-- Sidebar separator
local SidebarSep = Instance.new("Frame")
SidebarSep.BackgroundColor3 = Theme.Border
SidebarSep.BackgroundTransparency = 0.5
SidebarSep.Position = UDim2.new(1, 0, 0, 0)
SidebarSep.Size = UDim2.new(0, 1, 1, 0)
SidebarSep.BorderSizePixel = 0
SidebarSep.ZIndex = 6
SidebarSep.Parent = Sidebar

-- User Info Section
local UserSection = Instance.new("Frame")
UserSection.BackgroundColor3 = Theme.Card
UserSection.BackgroundTransparency = 0.5
UserSection.Size = UDim2.new(1, -16, 0, 60)
UserSection.Position = UDim2.new(0, 8, 0, 10)
UserSection.ZIndex = 6
UserSection.Parent = Sidebar
CreateCorner(UserSection, 10)

local UserAvatar = Instance.new("ImageLabel")
UserAvatar.Name = "UserAvatar"
UserAvatar.BackgroundColor3 = Theme.Primary
UserAvatar.Position = UDim2.new(0, 8, 0.5, -18)
UserAvatar.Size = UDim2.new(0, 36, 0, 36)
UserAvatar.ZIndex = 7
UserAvatar.Parent = UserSection
CreateCorner(UserAvatar, 18)
CreateStroke(UserAvatar, Theme.Primary, 2, 0.3)

-- Try to load avatar
pcall(function()
    local userId = Player.UserId
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size48x48
    local content = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
    UserAvatar.Image = content
end)

local UserName = Instance.new("TextLabel")
UserName.BackgroundTransparency = 1
UserName.Position = UDim2.new(0, 50, 0, 10)
UserName.Size = UDim2.new(1, -58, 0, 18)
UserName.ZIndex = 7
UserName.Font = Enum.Font.GothamBold
UserName.Text = Player.DisplayName
UserName.TextColor3 = Theme.TextPrimary
UserName.TextSize = 12
UserName.TextXAlignment = Enum.TextXAlignment.Left
UserName.TextTruncate = Enum.TextTruncate.AtEnd
UserName.Parent = UserSection

local UserStatus = Instance.new("TextLabel")
UserStatus.BackgroundTransparency = 1
UserStatus.Position = UDim2.new(0, 50, 0, 30)
UserStatus.Size = UDim2.new(1, -58, 0, 16)
UserStatus.ZIndex = 7
UserStatus.Font = Enum.Font.Gotham
UserStatus.Text = "🟢 Premium"
UserStatus.TextColor3 = Theme.Success
UserStatus.TextSize = 10
UserStatus.TextXAlignment = Enum.TextXAlignment.Left
UserStatus.Parent = UserSection

-- Nav Buttons Container
local NavContainer = Instance.new("ScrollingFrame")
NavContainer.Name = "NavContainer"
NavContainer.BackgroundTransparency = 1
NavContainer.Position = UDim2.new(0, 0, 0, 80)
NavContainer.Size = UDim2.new(1, 0, 1, -80)
NavContainer.BorderSizePixel = 0
NavContainer.ScrollBarThickness = 0
NavContainer.ZIndex = 6
NavContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
NavContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
NavContainer.Parent = Sidebar
CreatePadding(NavContainer, 4, 4, 8, 8)

local NavLayout = Instance.new("UIListLayout")
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Padding = UDim.new(0, 4)
NavLayout.Parent = NavContainer

-- ═══════════════════════════════════════════════
-- 📄 CONTENT AREA
-- ═══════════════════════════════════════════════
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 162, 0, 44)
ContentArea.Size = UDim2.new(1, -162, 1, -44)
ContentArea.ZIndex = 5
ContentArea.Parent = MainFrame

-- ═══════════════════════════════════════════════
-- 🏗️ TAB SYSTEM
-- ═══════════════════════════════════════════════
local Tabs = {}
local TabContents = {}
local ActiveTab = nil
local ActiveIndicator = nil

-- Tab indicator (moving highlight)
local TabIndicator = Instance.new("Frame")
TabIndicator.Name = "TabIndicator"
TabIndicator.BackgroundColor3 = Theme.Primary
TabIndicator.Size = UDim2.new(0, 3, 0, 28)
TabIndicator.Position = UDim2.new(0, 0, 0, 0)
TabIndicator.ZIndex = 8
TabIndicator.Visible = false
TabIndicator.Parent = NavContainer
CreateCorner(TabIndicator, 2)

local function CreateTab(name, icon, layoutOrder)
    -- Nav Button
    local NavBtn = Instance.new("TextButton")
    NavBtn.Name = name .. "Tab"
    NavBtn.BackgroundColor3 = Theme.Primary
    NavBtn.BackgroundTransparency = 1
    NavBtn.Size = UDim2.new(1, 0, 0, 38)
    NavBtn.ZIndex = 7
    NavBtn.Font = Enum.Font.Gotham
    NavBtn.Text = ""
    NavBtn.AutoButtonColor = false
    NavBtn.LayoutOrder = layoutOrder or 0
    NavBtn.Parent = NavContainer
    CreateCorner(NavBtn, 8)
    
    local NavIcon = Instance.new("TextLabel")
    NavIcon.BackgroundTransparency = 1
    NavIcon.Position = UDim2.new(0, 10, 0, 0)
    NavIcon.Size = UDim2.new(0, 28, 1, 0)
    NavIcon.ZIndex = 8
    NavIcon.Font = Enum.Font.GothamBold
    NavIcon.Text = icon
    NavIcon.TextSize = 16
    NavIcon.Parent = NavBtn
    
    local NavLabel = Instance.new("TextLabel")
    NavLabel.BackgroundTransparency = 1
    NavLabel.Position = UDim2.new(0, 40, 0, 0)
    NavLabel.Size = UDim2.new(1, -48, 1, 0)
    NavLabel.ZIndex = 8
    NavLabel.Font = Enum.Font.GothamSemibold
    NavLabel.Text = name
    NavLabel.TextColor3 = Theme.TextMuted
    NavLabel.TextSize = 12
    NavLabel.TextXAlignment = Enum.TextXAlignment.Left
    NavLabel.Parent = NavBtn
    
    -- Content Page
    local ContentPage = Instance.new("ScrollingFrame")
    ContentPage.Name = name .. "Page"
    ContentPage.BackgroundTransparency = 1
    ContentPage.Size = UDim2.new(1, 0, 1, 0)
    ContentPage.BorderSizePixel = 0
    ContentPage.ScrollBarThickness = 3
    ContentPage.ScrollBarImageColor3 = Theme.Primary
    ContentPage.ZIndex = 5
    ContentPage.Visible = false
    ContentPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentPage.Parent = ContentArea
    CreatePadding(ContentPage, 12, 12, 12, 12)
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.Parent = ContentPage
    
    -- Tab switching
    NavBtn.MouseEnter:Connect(function()
        if ActiveTab ~= name then
            Tween(NavBtn, {BackgroundTransparency = 0.85}, 0.2)
            Tween(NavLabel, {TextColor3 = Theme.TextSecondary}, 0.2)
        end
    end)
    
    NavBtn.MouseLeave:Connect(function()
        if ActiveTab ~= name then
            Tween(NavBtn, {BackgroundTransparency = 1}, 0.2)
            Tween(NavLabel, {TextColor3 = Theme.TextMuted}, 0.2)
        end
    end)
    
    NavBtn.MouseButton1Click:Connect(function()
        Ripple(NavBtn)
        
        -- Deactivate all tabs
        for tabName, tabData in pairs(Tabs) do
            Tween(tabData.Button, {BackgroundTransparency = 1}, 0.3)
            Tween(tabData.Label, {TextColor3 = Theme.TextMuted}, 0.3)
            tabData.Content.Visible = false
        end
        
        -- Activate clicked tab
        ActiveTab = name
        Tween(NavBtn, {BackgroundTransparency = 0.8}, 0.3)
        Tween(NavLabel, {TextColor3 = Theme.TextPrimary}, 0.3)
        ContentPage.Visible = true
        
        -- Animate indicator
        TabIndicator.Visible = true
        Tween(TabIndicator, {
            Position = UDim2.new(0, -5, 0, NavBtn.AbsolutePosition.Y - NavContainer.AbsolutePosition.Y + 5)
        }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
    
    Tabs[name] = {
        Button = NavBtn,
        Label = NavLabel,
        Icon = NavIcon,
        Content = ContentPage,
        Layout = ContentLayout
    }
    
    return ContentPage, ContentLayout
end

-- ═══════════════════════════════════════════════
-- 🧩 UI COMPONENT BUILDERS
-- ═══════════════════════════════════════════════

local function CreateSectionHeader(parent, text, layoutOrder)
    local Header = Instance.new("Frame")
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, 0, 0, 30)
    Header.ZIndex = 6
    Header.LayoutOrder = layoutOrder or 0
    Header.Parent = parent
    
    local HeaderText = Instance.new("TextLabel")
    HeaderText.BackgroundTransparency = 1
    HeaderText.Size = UDim2.new(1, 0, 1, 0)
    HeaderText.ZIndex = 7
    HeaderText.Font = Enum.Font.GothamBold
    HeaderText.Text = "🍓 " .. text
    HeaderText.TextColor3 = Theme.PrimaryLight
    HeaderText.TextSize = 14
    HeaderText.TextXAlignment = Enum.TextXAlignment.Left
    HeaderText.Parent = Header
    
    local HeaderLine = Instance.new("Frame")
    HeaderLine.BackgroundColor3 = Theme.Primary
    HeaderLine.BackgroundTransparency = 0.7
    HeaderLine.Position = UDim2.new(0, 0, 1, -1)
    HeaderLine.Size = UDim2.new(1, 0, 0, 1)
    HeaderLine.BorderSizePixel = 0
    HeaderLine.ZIndex = 7
    HeaderLine.Parent = Header
    
    return Header
end

local function CreateButton(parent, text, description, callback, layoutOrder)
    local BtnFrame = Instance.new("Frame")
    BtnFrame.Name = text .. "Frame"
    BtnFrame.BackgroundColor3 = Theme.Card
    BtnFrame.Size = UDim2.new(1, 0, 0, description and 60 or 42)
    BtnFrame.ZIndex = 6
    BtnFrame.LayoutOrder = layoutOrder or 0
    BtnFrame.Parent = parent
    CreateCorner(BtnFrame, 10)
    CreateStroke(BtnFrame, Theme.Border, 1, 0.7)
    
    local Btn = Instance.new("TextButton")
    Btn.BackgroundColor3 = Theme.Primary
    Btn.Position = UDim2.new(1, -100, 0.5, -15)
    Btn.Size = UDim2.new(0, 88, 0, 30)
    Btn.ZIndex = 8
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = "Execute"
    Btn.TextColor3 = Theme.TextPrimary
    Btn.TextSize = 11
    Btn.AutoButtonColor = false
    Btn.ClipsDescendants = true
    Btn.Parent = BtnFrame
    CreateCorner(Btn, 8)
    CreateGradient(Btn, Theme.Primary, Theme.PrimaryLight, 90)
    
    local BtnLabel = Instance.new("TextLabel")
    BtnLabel.BackgroundTransparency = 1
    BtnLabel.Position = UDim2.new(0, 14, 0, description and 8 or 0)
    BtnLabel.Size = UDim2.new(1, -120, 0, description and 22 or 42)
    BtnLabel.ZIndex = 7
    BtnLabel.Font = Enum.Font.GothamSemibold
    BtnLabel.Text = text
    BtnLabel.TextColor3 = Theme.TextPrimary
    BtnLabel.TextSize = 13
    BtnLabel.TextXAlignment = Enum.TextXAlignment.Left
    BtnLabel.Parent = BtnFrame
    
    if description then
        local DescLabel = Instance.new("TextLabel")
        DescLabel.BackgroundTransparency = 1
        DescLabel.Position = UDim2.new(0, 14, 0, 30)
        DescLabel.Size = UDim2.new(1, -120, 0, 20)
        DescLabel.ZIndex = 7
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.Text = description
        DescLabel.TextColor3 = Theme.TextMuted
        DescLabel.TextSize = 10
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.Parent = BtnFrame
    end
    
    -- Hover effects
    BtnFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            Tween(BtnFrame, {BackgroundColor3 = Theme.CardHover}, 0.2)
        end
    end)
    BtnFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            Tween(BtnFrame, {BackgroundColor3 = Theme.Card}, 0.2)
        end
    end)
    
    Btn.MouseEnter:Connect(function()
        Tween(Btn, {Size = UDim2.new(0, 92, 0, 32)}, 0.2)
    end)
    Btn.MouseLeave:Connect(function()
        Tween(Btn, {Size = UDim2.new(0, 88, 0, 30)}, 0.2)
    end)
    
    Btn.MouseButton1Click:Connect(function()
        Ripple(Btn)
        -- Press animation
        Tween(Btn, {Size = UDim2.new(0, 84, 0, 28)}, 0.1)
        task.wait(0.1)
        Tween(Btn, {Size = UDim2.new(0, 88, 0, 30)}, 0.2)
        if callback then callback() end
    end)
    
    return BtnFrame
end

local function CreateToggle(parent, text, description, default, callback, layoutOrder)
    local toggled = default or false
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = text .. "Toggle"
    ToggleFrame.BackgroundColor3 = Theme.Card
    ToggleFrame.Size = UDim2.new(1, 0, 0, description and 56 or 42)
    ToggleFrame.ZIndex = 6
    ToggleFrame.LayoutOrder = layoutOrder or 0
    ToggleFrame.Parent = parent
    CreateCorner(ToggleFrame, 10)
    CreateStroke(ToggleFrame, Theme.Border, 1, 0.7)
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 14, 0, description and 8 or 0)
    ToggleLabel.Size = UDim2.new(1, -80, 0, description and 20 or 42)
    ToggleLabel.ZIndex = 7
    ToggleLabel.Font = Enum.Font.GothamSemibold
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Theme.TextPrimary
    ToggleLabel.TextSize = 13
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    if description then
        local DescLabel = Instance.new("TextLabel")
        DescLabel.BackgroundTransparency = 1
        DescLabel.Position = UDim2.new(0, 14, 0, 28)
        DescLabel.Size = UDim2.new(1, -80, 0, 18)
        DescLabel.ZIndex = 7
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.Text = description
        DescLabel.TextColor3 = Theme.TextMuted
        DescLabel.TextSize = 10
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.Parent = ToggleFrame
    end
    
    -- Toggle switch
    local ToggleBg = Instance.new("Frame")
    ToggleBg.BackgroundColor3 = toggled and Theme.Primary or Theme.Surface
    ToggleBg.Position = UDim2.new(1, -62, 0.5, -12)
    ToggleBg.Size = UDim2.new(0, 48, 0, 24)
    ToggleBg.ZIndex = 8
    ToggleBg.Parent = ToggleFrame
    CreateCorner(ToggleBg, 12)
    
    local ToggleKnob = Instance.new("Frame")
    ToggleKnob.BackgroundColor3 = Theme.TextPrimary
    ToggleKnob.Position = toggled and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    ToggleKnob.Size = UDim2.new(0, 18, 0, 18)
    ToggleKnob.ZIndex = 9
    ToggleKnob.Parent = ToggleBg
    CreateCorner(ToggleKnob, 9)
    CreateShadow(ToggleKnob, 0.6)
    
    local function UpdateToggle()
        if toggled then
            Tween(ToggleBg, {BackgroundColor3 = Theme.Primary}, 0.3)
            Tween(ToggleKnob, {Position = UDim2.new(1, -22, 0.5, -9)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            Tween(ToggleBg, {BackgroundColor3 = Theme.Surface}, 0.3)
            Tween(ToggleKnob, {Position = UDim2.new(0, 3, 0.5, -9)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
    end
    
    -- Click handler
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
    ToggleBtn.ZIndex = 10
    ToggleBtn.Text = ""
    ToggleBtn.Parent = ToggleFrame
    
    ToggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        UpdateToggle()
        if callback then callback(toggled) end
    end)
    
    -- Hover effects
    ToggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            Tween(ToggleFrame, {BackgroundColor3 = Theme.CardHover}, 0.2)
        end
    end)
    ToggleFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            Tween(ToggleFrame, {BackgroundColor3 = Theme.Card}, 0.2)
        end
    end)
    
    return ToggleFrame
end

local function CreateSlider(parent, text, min, max, default, callback, layoutOrder)
    local value = default or min
    
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = text .. "Slider"
    SliderFrame.BackgroundColor3 = Theme.Card
    SliderFrame.Size = UDim2.new(1, 0, 0, 62)
    SliderFrame.ZIndex = 6
    SliderFrame.LayoutOrder = layoutOrder or 0
    SliderFrame.Parent = parent
    CreateCorner(SliderFrame, 10)
    CreateStroke(SliderFrame, Theme.Border, 1, 0.7)
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Position = UDim2.new(0, 14, 0, 8)
    SliderLabel.Size = UDim2.new(1, -80, 0, 20)
    SliderLabel.ZIndex = 7
    SliderLabel.Font = Enum.Font.GothamSemibold
    SliderLabel.Text = text
    SliderLabel.TextColor3 = Theme.TextPrimary
    SliderLabel.TextSize = 13
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(1, -60, 0, 8)
    ValueLabel.Size = UDim2.new(0, 48, 0, 20)
    ValueLabel.ZIndex = 7
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Text = tostring(value)
    ValueLabel.TextColor3 = Theme.PrimaryLight
    ValueLabel.TextSize = 12
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame
    
    -- Slider Track
    local SliderTrack = Instance.new("Frame")
    SliderTrack.BackgroundColor3 = Theme.Surface
    SliderTrack.Position = UDim2.new(0, 14, 0, 38)
    SliderTrack.Size = UDim2.new(1, -28, 0, 8)
    SliderTrack.ZIndex = 8
    SliderTrack.Parent = SliderFrame
    CreateCorner(SliderTrack, 4)
    
    -- Slider Fill
    local SliderFill = Instance.new("Frame")
    SliderFill.BackgroundColor3 = Theme.Primary
    SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    SliderFill.ZIndex = 9
    SliderFill.Parent = SliderTrack
    CreateCorner(SliderFill, 4)
    CreateGradient(SliderFill, Theme.Primary, Theme.PrimaryLight, 0)
    
    -- Slider Knob
    local SliderKnob = Instance.new("Frame")
    SliderKnob.BackgroundColor3 = Theme.TextPrimary
    SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    SliderKnob.Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
    SliderKnob.Size = UDim2.new(0, 16, 0, 16)
    SliderKnob.ZIndex = 10
    SliderKnob.Parent = SliderTrack
    CreateCorner(SliderKnob, 8)
    CreateStroke(SliderKnob, Theme.Primary, 2, 0)
    CreateShadow(SliderKnob, 0.5)
    
    -- Slider Logic
    local sliding = false
    
    local function UpdateSlider(input)
        local trackPos = SliderTrack.AbsolutePosition.X
        local trackSize = SliderTrack.AbsoluteSize.X
        local mouseX = input.Position.X
        local percent = math.clamp((mouseX - trackPos) / trackSize, 0, 1)
        value = math.floor(min + (max - min) * percent)
        
        ValueLabel.Text = tostring(value)
        Tween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
        Tween(SliderKnob, {Position = UDim2.new(percent, 0, 0.5, 0)}, 0.1)
        
        if callback then callback(value) end
    end
    
    SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            UpdateSlider(input)
        end
    end)
    
    SliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
    
    -- Hover effect
    SliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            Tween(SliderFrame, {BackgroundColor3 = Theme.CardHover}, 0.2)
        end
    end)
    SliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            Tween(SliderFrame, {BackgroundColor3 = Theme.Card}, 0.2)
        end
    end)
    
    return SliderFrame
end

local function CreateTextInput(parent, text, placeholder, callback, layoutOrder)
    local InputFrame = Instance.new("Frame")
    InputFrame.Name = text .. "Input"
    InputFrame.BackgroundColor3 = Theme.Card
    InputFrame.Size = UDim2.new(1, 0, 0, 68)
    InputFrame.ZIndex = 6
    InputFrame.LayoutOrder = layoutOrder or 0
    InputFrame.Parent = parent
    CreateCorner(InputFrame, 10)
    CreateStroke(InputFrame, Theme.Border, 1, 0.7)
    
    local InputLabel = Instance.new("TextLabel")
    InputLabel.BackgroundTransparency = 1
    InputLabel.Position = UDim2.new(0, 14, 0, 8)
    InputLabel.Size = UDim2.new(1, -28, 0, 20)
    InputLabel.ZIndex = 7
    InputLabel.Font = Enum.Font.GothamSemibold
    InputLabel.Text = text
    InputLabel.TextColor3 = Theme.TextPrimary
    InputLabel.TextSize = 13
    InputLabel.TextXAlignment = Enum.TextXAlignment.Left
    InputLabel.Parent = InputFrame
    
    local InputBox = Instance.new("TextBox")
    InputBox.BackgroundColor3 = Theme.Surface
    InputBox.Position = UDim2.new(0, 12, 0, 34)
    InputBox.Size = UDim2.new(1, -24, 0, 28)
    InputBox.ZIndex = 8
    InputBox.Font = Enum.Font.Gotham
    InputBox.PlaceholderText = placeholder or "Type here..."
    InputBox.PlaceholderColor3 = Theme.TextMuted
    InputBox.Text = ""
    InputBox.TextColor3 = Theme.TextPrimary
    InputBox.TextSize = 12
    InputBox.TextXAlignment = Enum.TextXAlignment.Left
    InputBox.ClearTextOnFocus = false
    InputBox.ClipsDescendants = true
    InputBox.Parent = InputFrame
    CreateCorner(InputBox, 8)
    CreateStroke(InputBox, Theme.Border, 1, 0.6)
    CreatePadding(InputBox, 0, 0, 10, 10)
    
    InputBox.Focused:Connect(function()
        Tween(InputBox, {BackgroundColor3 = Theme.BackgroundLight}, 0.2)
        local stroke = InputBox:FindFirstChildOfClass("UIStroke")
        if stroke then
            Tween(stroke, {Color = Theme.Primary, Transparency = 0}, 0.2)
        end
    end)
    
    InputBox.FocusLost:Connect(function(enterPressed)
        Tween(InputBox, {BackgroundColor3 = Theme.Surface}, 0.2)
        local stroke = InputBox:FindFirstChildOfClass("UIStroke")
        if stroke then
            Tween(stroke, {Color = Theme.Border, Transparency = 0.6}, 0.2)
        end
        if enterPressed and callback then
            callback(InputBox.Text)
        end
    end)
    
    return InputFrame, InputBox
end

local function CreateDropdown(parent, text, options, default, callback, layoutOrder)
    local selected = default or options[1] or "Select..."
    local isOpen = false
    
    local DropFrame = Instance.new("Frame")
    DropFrame.Name = text .. "Dropdown"
    DropFrame.BackgroundColor3 = Theme.Card
    DropFrame.Size = UDim2.new(1, 0, 0, 68)
    DropFrame.ZIndex = 6
    DropFrame.LayoutOrder = layoutOrder or 0
    DropFrame.ClipsDescendants = true
    DropFrame.Parent = parent
    CreateCorner(DropFrame, 10)
    CreateStroke(DropFrame, Theme.Border, 1, 0.7)
    
    local DropLabel = Instance.new("TextLabel")
    DropLabel.BackgroundTransparency = 1
    DropLabel.Position = UDim2.new(0, 14, 0, 8)
    DropLabel.Size = UDim2.new(1, -28, 0, 20)
    DropLabel.ZIndex = 7
    DropLabel.Font = Enum.Font.GothamSemibold
    DropLabel.Text = text
    DropLabel.TextColor3 = Theme.TextPrimary
    DropLabel.TextSize = 13
    DropLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropLabel.Parent = DropFrame
    
    local DropBtn = Instance.new("TextButton")
    DropBtn.BackgroundColor3 = Theme.Surface
    DropBtn.Position = UDim2.new(0, 12, 0, 34)
    DropBtn.Size = UDim2.new(1, -24, 0, 28)
    DropBtn.ZIndex = 8
    DropBtn.Font = Enum.Font.Gotham
    DropBtn.Text = "  " .. selected .. "  ▼"
    DropBtn.TextColor3 = Theme.TextPrimary
    DropBtn.TextSize = 12
    DropBtn.TextXAlignment = Enum.TextXAlignment.Left
    DropBtn.AutoButtonColor = false
    DropBtn.Parent = DropFrame
    CreateCorner(DropBtn, 8)
    CreateStroke(DropBtn, Theme.Border, 1, 0.6)
    
    -- Options container
    local OptionsContainer = Instance.new("Frame")
    OptionsContainer.BackgroundTransparency = 1
    OptionsContainer.Position = UDim2.new(0, 12, 0, 68)
    OptionsContainer.Size = UDim2.new(1, -24, 0, #options * 30)
    OptionsContainer.ZIndex = 9
    OptionsContainer.Parent = DropFrame
    
    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    OptionsLayout.Padding = UDim.new(0, 2)
    OptionsLayout.Parent = OptionsContainer
    
    for i, option in ipairs(options) do
        local OptionBtn = Instance.new("TextButton")
        OptionBtn.BackgroundColor3 = Theme.Surface
        OptionBtn.BackgroundTransparency = 0.5
        OptionBtn.Size = UDim2.new(1, 0, 0, 28)
        OptionBtn.ZIndex = 10
        OptionBtn.Font = Enum.Font.Gotham
        OptionBtn.Text = "  " .. option
        OptionBtn.TextColor3 = Theme.TextSecondary
        OptionBtn.TextSize = 11
        OptionBtn.TextXAlignment = Enum.TextXAlignment.Left
        OptionBtn.AutoButtonColor = false
        OptionBtn.Parent = OptionsContainer
        CreateCorner(OptionBtn, 6)
        
        OptionBtn.MouseEnter:Connect(function()
            Tween(OptionBtn, {BackgroundTransparency = 0, BackgroundColor3 = Theme.Primary, TextColor3 = Theme.TextPrimary}, 0.2)
        end)
        OptionBtn.MouseLeave:Connect(function()
            Tween(OptionBtn, {BackgroundTransparency = 0.5, BackgroundColor3 = Theme.Surface, TextColor3 = Theme.TextSecondary}, 0.2)
        end)
        
        OptionBtn.MouseButton1Click:Connect(function()
            selected = option
            DropBtn.Text = "  " .. selected .. "  ▼"
            isOpen = false
            Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 68)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            if callback then callback(selected) end
        end)
    end
    
    DropBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 72 + #options * 30)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            DropBtn.Text = "  " .. selected .. "  ▲"
        else
            Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 68)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            DropBtn.Text = "  " .. selected .. "  ▼"
        end
    end)
    
    return DropFrame
end

local function CreateKeybind(parent, text, defaultKey, callback, layoutOrder)
    local currentKey = defaultKey or Enum.KeyCode.F
    local listening = false
    
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Name = text .. "Keybind"
    KeyFrame.BackgroundColor3 = Theme.Card
    KeyFrame.Size = UDim2.new(1, 0, 0, 42)
    KeyFrame.ZIndex = 6
    KeyFrame.LayoutOrder = layoutOrder or 0
    KeyFrame.Parent = parent
    CreateCorner(KeyFrame, 10)
    CreateStroke(KeyFrame, Theme.Border, 1, 0.7)
    
    local KeyLabel = Instance.new("TextLabel")
    KeyLabel.BackgroundTransparency = 1
    KeyLabel.Position = UDim2.new(0, 14, 0, 0)
    KeyLabel.Size = UDim2.new(1, -90, 1, 0)
    KeyLabel.ZIndex = 7
    KeyLabel.Font = Enum.Font.GothamSemibold
    KeyLabel.Text = text
    KeyLabel.TextColor3 = Theme.TextPrimary
    KeyLabel.TextSize = 13
    KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
    KeyLabel.Parent = KeyFrame
    
    local KeyBtn = Instance.new("TextButton")
    KeyBtn.BackgroundColor3 = Theme.Surface
    KeyBtn.Position = UDim2.new(1, -78, 0.5, -14)
    KeyBtn.Size = UDim2.new(0, 66, 0, 28)
    KeyBtn.ZIndex = 8
    KeyBtn.Font = Enum.Font.GothamBold
    KeyBtn.Text = currentKey.Name
    KeyBtn.TextColor3 = Theme.PrimaryLight
    KeyBtn.TextSize = 11
    KeyBtn.AutoButtonColor = false
    KeyBtn.Parent = KeyFrame
    CreateCorner(KeyBtn, 6)
    CreateStroke(KeyBtn, Theme.Primary, 1, 0.5)
    
    KeyBtn.MouseButton1Click:Connect(function()
        listening = true
        KeyBtn.Text = "..."
        Tween(KeyBtn, {BackgroundColor3 = Theme.Primary}, 0.2)
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            currentKey = input.KeyCode
            KeyBtn.Text = currentKey.Name
            listening = false
            Tween(KeyBtn, {BackgroundColor3 = Theme.Surface}, 0.2)
            if callback then callback(currentKey) end
        end
    end)
    
    -- Hover
    KeyFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            Tween(KeyFrame, {BackgroundColor3 = Theme.CardHover}, 0.2)
        end
    end)
    KeyFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            Tween(KeyFrame, {BackgroundColor3 = Theme.Card}, 0.2)
        end
    end)
    
    return KeyFrame
end

local function CreateColorPicker(parent, text, defaultColor, callback, layoutOrder)
    local currentColor = defaultColor or Theme.Primary
    
    local ColorFrame = Instance.new("Frame")
    ColorFrame.Name = text .. "Color"
    ColorFrame.BackgroundColor3 = Theme.Card
    ColorFrame.Size = UDim2.new(1, 0, 0, 42)
    ColorFrame.ZIndex = 6
    ColorFrame.LayoutOrder = layoutOrder or 0
    ColorFrame.Parent = parent
    CreateCorner(ColorFrame, 10)
    CreateStroke(ColorFrame, Theme.Border, 1, 0.7)
    
    local ColorLabel = Instance.new("TextLabel")
    ColorLabel.BackgroundTransparency = 1
    ColorLabel.Position = UDim2.new(0, 14, 0, 0)
    ColorLabel.Size = UDim2.new(1, -60, 1, 0)
    ColorLabel.ZIndex = 7
    ColorLabel.Font = Enum.Font.GothamSemibold
    ColorLabel.Text = text
    ColorLabel.TextColor3 = Theme.TextPrimary
    ColorLabel.TextSize = 13
    ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
    ColorLabel.Parent = ColorFrame
    
    local ColorPreview = Instance.new("Frame")
    ColorPreview.BackgroundColor3 = currentColor
    ColorPreview.Position = UDim2.new(1, -44, 0.5, -12)
    ColorPreview.Size = UDim2.new(0, 30, 0, 24)
    ColorPreview.ZIndex = 8
    ColorPreview.Parent = ColorFrame
    CreateCorner(ColorPreview, 6)
    CreateStroke(ColorPreview, Theme.TextPrimary, 1, 0.5)
    
    -- Hover
    ColorFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            Tween(ColorFrame, {BackgroundColor3 = Theme.CardHover}, 0.2)
        end
    end)
    ColorFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            Tween(ColorFrame, {BackgroundColor3 = Theme.Card}, 0.2)
        end
    end)
    
    return ColorFrame
end

-- ═══════════════════════════════════════════════
-- 📑 CREATE TABS WITH CONTENT
-- ═══════════════════════════════════════════════

-- 🏠 HOME TAB
local HomePage, HomeLayout = CreateTab("Home", "🏠", 1)

CreateSectionHeader(HomePage, "Welcome to Strawberry Hub", 1)

-- Stats Card
local StatsCard = Instance.new("Frame")
StatsCard.BackgroundColor3 = Theme.Card
StatsCard.Size = UDim2.new(1, 0, 0, 90)
StatsCard.ZIndex = 6
StatsCard.LayoutOrder = 2
StatsCard.Parent = HomePage
CreateCorner(StatsCard, 12)
CreateStroke(StatsCard, Theme.Primary, 1, 0.5)

local StatsGradient = Instance.new("Frame")
StatsGradient.BackgroundColor3 = Color3.new(1, 1, 1)
StatsGradient.Size = UDim2.new(1, 0, 0, 3)
StatsGradient.Position = UDim2.new(0, 0, 0, 0)
StatsGradient.BorderSizePixel = 0
StatsGradient.ZIndex = 7
StatsGradient.Parent = StatsCard
CreateCorner(StatsGradient, 12)
CreateGradient(StatsGradient, Theme.Primary, Theme.Accent, 0)

local function CreateStatItem(statParent, pos, icon, label, value)
    local StatItem = Instance.new("Frame")
    StatItem.BackgroundTransparency = 1
    StatItem.Position = pos
    StatItem.Size = UDim2.new(0.33, 0, 1, -12)
    StatItem.ZIndex = 7
    StatItem.Parent = statParent
    
    local StatIcon = Instance.new("TextLabel")
    StatIcon.BackgroundTransparency = 1
    StatIcon.Position = UDim2.new(0.5, 0, 0, 12)
    StatIcon.Size = UDim2.new(0, 30, 0, 25)
    StatIcon.AnchorPoint = Vector2.new(0.5, 0)
    StatIcon.ZIndex = 8
    StatIcon.Font = Enum.Font.GothamBold
    StatIcon.Text = icon
    StatIcon.TextSize = 20
    StatIcon.Parent = StatItem
    
    local StatValue = Instance.new("TextLabel")
    StatValue.BackgroundTransparency = 1
    StatValue.Position = UDim2.new(0, 0, 0, 40)
    StatValue.Size = UDim2.new(1, 0, 0, 18)
    StatValue.ZIndex = 8
    StatValue.Font = Enum.Font.GothamBold
    StatValue.Text = value
    StatValue.TextColor3 = Theme.TextPrimary
    StatValue.TextSize = 14
    StatValue.Parent = StatItem
    
    local StatLabel = Instance.new("TextLabel")
    StatLabel.BackgroundTransparency = 1
    StatLabel.Position = UDim2.new(0, 0, 0, 58)
    StatLabel.Size = UDim2.new(1, 0, 0, 16)
    StatLabel.ZIndex = 8
    StatLabel.Font = Enum.Font.Gotham
    StatLabel.Text = label
    StatLabel.TextColor3 = Theme.TextMuted
    StatLabel.TextSize = 10
    StatLabel.Parent = StatItem
    
    return StatValue
end

CreateStatItem(StatsCard, UDim2.new(0, 0, 0, 0), "🎮", "Game", game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name:sub(1, 12) or "Unknown")
CreateStatItem(StatsCard, UDim2.new(0.33, 0, 0, 0), "👥", "Players", tostring(#Players:GetPlayers()))
CreateStatItem(StatsCard, UDim2.new(0.66, 0, 0, 0), "⚡", "FPS", "60")

-- Update FPS counter
spawn(function()
    while ScreenGui and ScreenGui.Parent do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        -- Update FPS display if needed
        task.wait(1)
    end
end)

CreateSectionHeader(HomePage, "Quick Actions", 3)

CreateButton(HomePage, "Rejoin Server", "Quickly rejoin the current server", function()
    Notify("🍓 Rejoining", "Teleporting back to server...", "info", 3)
    task.wait(1)
    game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
end, 4)

CreateButton(HomePage, "Server Hop", "Join a different server", function()
    Notify("🍓 Server Hop", "Finding a new server...", "info", 3)
end, 5)

CreateButton(HomePage, "Copy Game Link", "Copy the game link to clipboard", function()
    if setclipboard then
        setclipboard("https://www.roblox.com/games/" .. game.PlaceId)
        Notify("✅ Copied", "Game link copied to clipboard!", "success", 3)
    end
end, 6)

-- ⚔️ COMBAT TAB
local CombatPage, CombatLayout = CreateTab("Combat", "⚔️", 2)

CreateSectionHeader(CombatPage, "Aim Assist", 1)

CreateToggle(CombatPage, "Silent Aim", "Automatically locks onto nearest target", false, function(state)
    Notify(state and "✅ Enabled" or "❌ Disabled", "Silent Aim " .. (state and "activated" or "deactivated"), state and "success" or "error", 2)
end, 2)

CreateSlider(CombatPage, "FOV Size", 50, 500, 180, function(value)
    -- FOV circle size
end, 3)

CreateToggle(CombatPage, "Show FOV Circle", "Display the FOV circle on screen", true, function(state)
end, 4)

CreateDropdown(CombatPage, "Aim Part", {"Head", "HumanoidRootPart", "Torso", "Random"}, "Head", function(selected)
    Notify("🍓 Aim Part", "Changed to: " .. selected, "info", 2)
end, 5)

CreateSectionHeader(CombatPage, "Hit Settings", 6)

CreateSlider(CombatPage, "Hit Chance", 0, 100, 85, function(value)
end, 7)

CreateToggle(CombatPage, "Auto Shoot", "Automatically fires when locked on", false, function(state)
end, 8)

CreateKeybind(CombatPage, "Toggle Aim Key", Enum.KeyCode.E, function(key)
    Notify("🍓 Keybind", "Aim key set to: " .. key.Name, "info", 2)
end, 9)

-- 👁️ VISUALS TAB
local VisualsPage, VisualsLayout = CreateTab("Visuals", "👁️", 3)

CreateSectionHeader(VisualsPage, "ESP Settings", 1)

CreateToggle(VisualsPage, "Player ESP", "Show boxes around all players", false, function(state)
    Notify(state and "✅ Enabled" or "❌ Disabled", "Player ESP " .. (state and "activated" or "deactivated"), state and "success" or "error", 2)
end, 2)

CreateToggle(VisualsPage, "Name Tags", "Display player names above heads", false, function(state)
end, 3)

CreateToggle(VisualsPage, "Health Bars", "Show health bars next to players", false, function(state)
end, 4)

CreateToggle(VisualsPage, "Tracers", "Draw lines to other players", false, function(state)
end, 5)

CreateToggle(VisualsPage, "Chams / Highlight", "Highlight players through walls", false, function(state)
end, 6)

CreateSectionHeader(VisualsPage, "Customization", 7)

CreateDropdown(VisualsPage, "ESP Style", {"2D Box", "3D Box", "Corner", "Circle"}, "2D Box", function(selected)
end, 8)

CreateColorPicker(VisualsPage, "Enemy Color", Color3.fromRGB(255, 50, 50), function(color)
end, 9)

CreateColorPicker(VisualsPage, "Team Color", Color3.fromRGB(50, 255, 50), function(color)
end, 10)

CreateSlider(VisualsPage, "ESP Distance", 100, 2000, 500, function(value)
end, 11)

-- 🏃 MOVEMENT TAB
local MovementPage, MovementLayout = CreateTab("Movement", "🏃", 4)

CreateSectionHeader(MovementPage, "Speed & Flight", 1)

CreateToggle(MovementPage, "Speed Hack", "Increase your movement speed", false, function(state)
    if state then
        Player.Character.Humanoid.WalkSpeed = 32
        Notify("⚡ Speed", "Speed hack enabled!", "success", 2)
    else
        Player.Character.Humanoid.WalkSpeed = 16
        Notify("🛑 Speed", "Speed reset to normal", "warning", 2)
    end
end, 2)

CreateSlider(MovementPage, "Walk Speed", 16, 200, 16, function(value)
    pcall(function()
        Player.Character.Humanoid.WalkSpeed = value
    end)
end, 3)

CreateSlider(MovementPage, "Jump Power", 50, 500, 50, function(value)
    pcall(function()
        Player.Character.Humanoid.JumpPower = value
    end)
end, 4)

CreateToggle(MovementPage, "Infinite Jump", "Jump unlimited times in air", false, function(state)
    _G.InfJump = state
    if state then
        Notify("🍓 Infinite Jump", "You can now jump in the air!", "success", 2)
    end
end, 5)

-- Infinite Jump Handler
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump then
        pcall(function()
            Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end)
    end
end)

CreateToggle(MovementPage, "No Clip", "Walk through walls and objects", false, function(state)
    _G.NoClip = state
    Notify(state and "👻 No Clip" or "🧱 Collision", state and "You can phase through walls!" or "Collisions restored", state and "success" or "warning", 2)
end, 6)

-- No Clip Handler
RunService.Stepped:Connect(function()
    if _G.NoClip and Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

CreateSectionHeader(MovementPage, "Teleportation", 7)

CreateToggle(MovementPage, "Click Teleport", "Click anywhere to teleport there", false, function(state)
    _G.ClickTP = state
    Notify(state and "✨ Click TP" or "🛑 Click TP", state and "Click to teleport!" or "Disabled", state and "success" or "error", 2)
end, 8)

CreateKeybind(MovementPage, "Fly Toggle Key", Enum.KeyCode.F, function(key)
    Notify("🍓 Keybind", "Fly key set to: " .. key.Name, "info", 2)
end, 9)

-- Click TP Handler
Mouse.Button1Down:Connect(function()
    if _G.ClickTP and Mouse.Target then
        pcall(function()
            Player.Character:MoveTo(Mouse.Hit.Position)
        end)
    end
end)

-- 🔧 MISC TAB
local MiscPage, MiscLayout = CreateTab("Misc", "🔧", 5)

CreateSectionHeader(MiscPage, "Player Utilities", 1)

CreateButton(MiscPage, "Reset Character", "Kill your character instantly", function()
    pcall(function()
        Player.Character:FindFirstChildOfClass("Humanoid").Health = 0
    end)
    Notify("💀 Reset", "Character has been reset!", "warning", 2)
end, 2)

CreateButton(MiscPage, "Goto Nearest Player", "Teleport to the closest player", function()
    local closest, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                closest = p
                dist = d
            end
        end
    end
    if closest then
        Player.Character.HumanoidRootPart.CFrame = closest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
        Notify("✅ Teleported", "Teleported to " .. closest.DisplayName, "success", 2)
    end
end, 3)

CreateSectionHeader(MiscPage, "World Settings", 4)

CreateToggle(MiscPage, "Fullbright", "Remove all darkness from the game", false, function(state)
    pcall(function()
        local lighting = game:GetService("Lighting")
        if state then
            lighting.Brightness = 2
            lighting.ClockTime = 14
            lighting.FogEnd = 100000
            lighting.GlobalShadows = false
            Notify("☀️ Fullbright", "Darkness removed!", "success", 2)
        else
            lighting.Brightness = 1
            lighting.GlobalShadows = true
            Notify("🌙 Normal", "Lighting restored", "info", 2)
        end
    end)
end, 5)

CreateToggle(MiscPage, "Anti AFK", "Prevent being kicked for inactivity", true, function(state)
    if state then
        Notify("✅ Anti-AFK", "You won't be kicked for being idle!", "success", 2)
    end
end, 6)

-- Anti AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end)
end)

CreateSectionHeader(MiscPage, "Script Hub", 7)

local _, ScriptBox = CreateTextInput(MiscPage, "Execute Script", "Paste your script here...", function(text)
    pcall(function()
        loadstring(text)()
        Notify("✅ Executed", "Script ran successfully!", "success", 2)
    end)
end, 8)

CreateButton(MiscPage, "Infinite Yield", "Load Infinite Yield admin commands", function()
    Notify("📜 Loading", "Loading Infinite Yield...", "info", 3)
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"))()
    end)
end, 9)

CreateButton(MiscPage, "Dex Explorer", "Browse game hierarchy and properties", function()
    Notify("📜 Loading", "Loading Dex Explorer...", "info", 3)
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end)
end, 10)

-- ⚙️ SETTINGS TAB
local SettingsPage, SettingsLayout = CreateTab("Settings", "⚙️", 6)

CreateSectionHeader(SettingsPage, "GUI Settings", 1)

CreateSlider(SettingsPage, "GUI Transparency", 0, 50, 0, function(value)
    MainFrame.BackgroundTransparency = value / 100
end, 2)

CreateToggle(SettingsPage, "GUI Keybind", "Toggle GUI with Right Shift", true, function(state)
    _G.GuiKeybind = state
end, 3)
_G.GuiKeybind = true

CreateDropdown(SettingsPage, "Theme Accent", {"Strawberry Red", "Rose Pink", "Berry Purple", "Mint Green", "Ocean Blue"}, "Strawberry Red", function(selected)
    Notify("🎨 Theme", "Accent changed to: " .. selected, "info", 2)
end, 4)

CreateSectionHeader(SettingsPage, "Notifications", 5)

CreateToggle(SettingsPage, "Show Notifications", "Display notification popups", true, function(state)
end, 6)

CreateToggle(SettingsPage, "Sound Effects", "Play sounds on interactions", false, function(state)
end, 7)

CreateSectionHeader(SettingsPage, "About", 8)

-- About Card
local AboutCard = Instance.new("Frame")
AboutCard.BackgroundColor3 = Theme.Card
AboutCard.Size = UDim2.new(1, 0, 0, 100)
AboutCard.ZIndex = 6
AboutCard.LayoutOrder = 9
AboutCard.Parent = SettingsPage
CreateCorner(AboutCard, 10)
CreateStroke(AboutCard, Theme.Primary, 1, 0.5)

local AboutText = Instance.new("TextLabel")
AboutText.BackgroundTransparency = 1
AboutText.Position = UDim2.new(0, 14, 0, 10)
AboutText.Size = UDim2.new(1, -28, 1, -20)
AboutText.ZIndex = 7
AboutText.Font = Enum.Font.Gotham
AboutText.Text = "🍓 Strawberry Hub v2.0\n\nA modern, feature-rich GUI for Delta Executor.\nDesigned with a beautiful strawberry theme.\n\nMade with ❤️ for the community."
AboutText.TextColor3 = Theme.TextSecondary
AboutText.TextSize = 11
AboutText.TextXAlignment = Enum.TextXAlignment.Left
AboutText.TextYAlignment = Enum.TextYAlignment.Top
AboutText.TextWrapped = true
AboutText.Parent = AboutCard

CreateButton(SettingsPage, "Destroy GUI", "Completely remove this GUI", function()
    Notify("👋 Goodbye", "Destroying Strawberry Hub...", "warning", 2)
    task.wait(2)
    ScreenGui:Destroy()
end, 10)

-- ═══════════════════════════════════════════════
-- 🎬 OPEN ANIMATION & DEFAULT TAB
-- ═══════════════════════════════════════════════

-- Opening animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundTransparency = 1

Tween(MainFrame, {
    Size = UDim2.new(0, 650, 0, 450),
    Position = UDim2.new(0.5, -325, 0.5, -225),
    BackgroundTransparency = 0
}, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- Select Home tab by default
task.wait(0.3)
Tabs["Home"].Button.MouseButton1Click:Fire()

-- ═══════════════════════════════════════════════
-- ⌨️ KEYBIND TO TOGGLE GUI
-- ═══════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift and _G.GuiKeybind then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ═══════════════════════════════════════════════
-- 🔔 WELCOME NOTIFICATION
-- ═══════════════════════════════════════════════
task.wait(0.8)
Notify("🍓 Strawberry Hub", "Welcome back, " .. Player.DisplayName .. "!", "success", 4)
task.wait(0.3)
Notify("💡 Tip", "Press Right Shift to toggle the GUI", "info", 5)

-- ═══════════════════════════════════════════════
-- 🍓 MINI BUTTON (when minimized/hidden)
-- ═══════════════════════════════════════════════
local MiniButton = Instance.new("TextButton")
MiniButton.Name = "MiniButton"
MiniButton.BackgroundColor3 = Theme.Primary
MiniButton.Position = UDim2.new(0, 10, 0.5, -20)
MiniButton.Size = UDim2.new(0, 40, 0, 40)
MiniButton.ZIndex = 100
MiniButton.Font = Enum.Font.GothamBold
MiniButton.Text = "🍓"
MiniButton.TextSize = 22
MiniButton.AutoButtonColor = false
MiniButton.Visible = false
MiniButton.Parent = ScreenGui
CreateCorner(MiniButton, 20)
CreateShadow(MiniButton, 0.4)
CreateStroke(MiniButton, Theme.PrimaryLight, 2, 0.3)

-- Pulse animation for mini button
spawn(function()
    while MiniButton and MiniButton.Parent do
        Tween(MiniButton, {Size = UDim2.new(0, 44, 0, 44), Position = UDim2.new(0, 8, 0.5, -22)}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1)
        Tween(MiniButton, {Size = UDim2.new(0, 40, 0, 40), Position = UDim2.new(0, 10, 0.5, -20)}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1)
    end
end)

print("🍓 Strawberry Hub v2.0 loaded successfully!")
