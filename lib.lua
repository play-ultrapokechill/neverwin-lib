-- [[ NEVERWIN UI LIBRARY - CORE MODULE ]] --
-- Exploit Environments & Optimizations --
local cloneref = cloneref or function(i) return i end
local clonefunction = clonefunction or function(...) return ... end
local protect_gui = protect_gui or protectgui or (syn and syn.protect_gui) or function() end

-- Services --
local Players = cloneref(game:GetService("Players"))
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local TextService = cloneref(game:GetService("TextService"))
local Lighting = cloneref(game:GetService("Lighting"))

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local _, CoreGui = xpcall(function()
    return (gethui and gethui()) or game:GetService("CoreGui"):FindFirstChild("RobloxGui") or game:GetService("CoreGui")
end, function()
    return LocalPlayer:WaitForChild("PlayerGui")
end)

-- Limpeza de Blurs residuais
for _, obj in ipairs(Lighting:GetChildren()) do
    if obj.Name:find("Neverwin") then
        obj:Destroy()
    end
end

-- TABELA DE CORES & TEMA NEVERWIN
local THEME = {
    RightBackground    = Color3.fromHex("#080808"),
    SidebarColor       = Color3.fromRGB(30, 37, 50),
    SidebarTransparency= 0.002,
    ProfileBackground  = Color3.fromHex("#171717"),
    CardBackground     = Color3.fromHex("#0e0e10"),
    ElementBackground  = Color3.fromHex("#141416"),
    
    FontOn             = Color3.fromHex("#e8e8ea"),
    FontOff            = Color3.fromHex("#8b8b8d"),
    CategoryFont       = Color3.fromRGB(115, 122, 138),
    
    -- Slider & Accent
    SliderKnob         = Color3.fromHex("#4285de"),
    SliderActiveBar    = Color3.fromHex("#394d60"),
    SliderInactiveBar  = Color3.fromHex("#303032"),
    
    -- Toggle
    ToggleKnob         = Color3.fromHex("#00a8ed"),
    ToggleBgOff        = Color3.fromHex("#2d2e31"),
    ToggleBgOn         = Color3.fromHex("#03162b"),
    
    -- Divisores e Bordas
    HeaderDivider      = Color3.fromRGB(30, 36, 50),
    CardBlueDivider    = Color3.fromRGB(28, 58, 92),
    BorderColor        = Color3.fromRGB(36, 42, 58),
    AccentBlue         = Color3.fromHex("#00a8ed"),
    PreviewBackground  = Color3.fromHex("#080808"),
}

-- BIBLIOTECA NEVERWIN
local NeverwinLib = {
    Ascii = "qwertyuiopasdfghjklzxcvbnmQWRTYUIOPASDFGHJKLZXCVBNM",
    Windows = {},
    DragBlacklist = {},
    GLOBAL_ENVIRONMENT = {},
}
NeverwinLib.__index = NeverwinLib

-- ÍCONES LUCIDE
NeverwinLib.Lucide = {
    ["lucide-crosshair"] = "rbxassetid://10709818534",
    ["lucide-shield"] = "rbxassetid://10734951847",
    ["lucide-user"] = "rbxassetid://10747373176",
    ["lucide-users"] = "rbxassetid://10747373426",
    ["lucide-eye"] = "rbxassetid://10723346959",
    ["lucide-eye-off"] = "rbxassetid://10723346871",
    ["lucide-sword"] = "rbxassetid://10734975486",
    ["lucide-swords"] = "rbxassetid://10734975692",
    ["lucide-target"] = "rbxassetid://10734977012",
    ["lucide-settings"] = "rbxassetid://10734950309",
    ["lucide-sliders"] = "rbxassetid://10734963400",
    ["lucide-globe"] = "rbxassetid://10723404337",
    ["lucide-code"] = "rbxassetid://10709810463",
    ["lucide-terminal"] = "rbxassetid://10734982144",
    ["lucide-folder"] = "rbxassetid://10723387563",
    ["lucide-copy"] = "rbxassetid://10709812159",
    ["lucide-clipboard"] = "rbxassetid://10709799288",
    ["lucide-clipboard-edit"] = "rbxassetid://10709798682",
    ["lucide-check"] = "rbxassetid://10709790644",
    ["lucide-chevron-down"] = "rbxassetid://10709790948",
    ["lucide-palette"] = "rbxassetid://10734910430",
    ["lucide-mouse-pointer"] = "rbxassetid://10734898476",
    ["lucide-flame"] = "rbxassetid://10723376114",
    ["lucide-zap"] = "rbxassetid://10723345749",
    ["lucide-lock"] = "rbxassetid://10723434711",
}

local function GetArgs(a, b)
    if typeof(a) == "table" and typeof(b) == "table" then
        return b
    elseif typeof(a) == "table" and b == nil then
        return a
    end
    return b or a or {}
end

local function MatchesKey(input, key)
    if not key then return false end
    if typeof(key) == "EnumItem" then
        return input.KeyCode == key
    elseif typeof(key) == "string" then
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            return input.KeyCode.Name:lower() == key:lower()
        end
    end
    return false
end

function NeverwinLib:GetIcon(name: string): string
    if not name then return "rbxassetid://6031075931" end
    if name:find("rbxassetid://") or name:find("http") then return name end
    return NeverwinLib.Lucide["lucide-" .. tostring(name)] or NeverwinLib.Lucide[name] or "rbxassetid://6031075931"
end

function NeverwinLib:RandomString(len: number): string
    len = len or 16
    local str = ""
    for _ = 1, len do
        local rand = math.random(1, #NeverwinLib.Ascii)
        str = str .. NeverwinLib.Ascii:sub(rand, rand)
    end
    return str
end

function NeverwinLib:CreateAnimation(instance: Instance, time: number, style: Enum.EasingStyle, properties: {[string]: any}): Tween
    if not properties and typeof(style) == "table" then
        properties = style
        style = nil
    end
    local tween = TweenService:Create(instance, TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

function NeverwinLib:CreateHover(element: GuiObject, callback: (boolean) -> any)
    element.MouseEnter:Connect(function() callback(true) end)
    element.MouseLeave:Connect(function() callback(false) end)
end

function NeverwinLib:IsMouseOverFrame(frame: Frame): boolean
    if not frame or not frame.Visible then return false end
    local absPos, absSize = frame.AbsolutePosition, frame.AbsoluteSize
    return Mouse.X >= absPos.X and Mouse.X <= absPos.X + absSize.X and Mouse.Y >= absPos.Y and Mouse.Y <= absPos.Y + absSize.Y
end

function NeverwinLib:AddDragBlacklist(frame: Frame)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if not table.find(NeverwinLib.DragBlacklist, frame) then
                table.insert(NeverwinLib.DragBlacklist, frame)
            end
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local idx = table.find(NeverwinLib.DragBlacklist, frame)
            if idx then table.remove(NeverwinLib.DragBlacklist, idx) end
        end
    end)
end

-- DRAGGABLE COM SUPORTE A BLACKLIST
local function MakeDraggable(dragHandle, mainFrame)
    local dragging = false
    local dragInput, mousePos, framePos

    dragHandle.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and #NeverwinLib.DragBlacklist == 0 then
            dragging = true
            mousePos = input.Position
            framePos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging and #NeverwinLib.DragBlacklist == 0 then
            local delta = input.Position - mousePos
            local targetPos = UDim2.new(
                framePos.X.Scale, framePos.X.Offset + delta.X,
                framePos.Y.Scale, framePos.Y.Offset + delta.Y
            )
            NeverwinLib:CreateAnimation(mainFrame, 0.08, Enum.EasingStyle.Sine, {Position = targetPos})
        end
    end)
end

-- SISTEMA DE POPUP DE OPTIONS (ENGRENAGEM LATERAL)
function NeverwinLib:CreateOptionPopup(optionButton: ImageButton, parentWindow: Frame)
    local OptionPopup = Instance.new("Frame")
    OptionPopup.Name = "OptionPopup_" .. NeverwinLib:RandomString(6)
    OptionPopup.Parent = parentWindow
    OptionPopup.BackgroundColor3 = THEME.CardBackground
    OptionPopup.BorderSizePixel = 0
    OptionPopup.ClipsDescendants = true
    OptionPopup.Size = UDim2.new(0, 190, 0, 0)
    OptionPopup.Visible = false
    OptionPopup.ZIndex = 120

    local PopCorner = Instance.new("UICorner")
    PopCorner.CornerRadius = UDim.new(0, 6)
    PopCorner.Parent = OptionPopup

    local PopStroke = Instance.new("UIStroke")
    PopStroke.Color = THEME.BorderColor
    PopStroke.Thickness = 1
    PopStroke.Transparency = 1
    PopStroke.Parent = OptionPopup

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, -12, 1, -12)
    Scroll.Position = UDim2.new(0, 6, 0, 6)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 2
    Scroll.ScrollBarImageColor3 = THEME.AccentBlue
    Scroll.ZIndex = 121
    Scroll.Parent = OptionPopup

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 6)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Scroll

    NeverwinLib:AddDragBlacklist(OptionPopup)

    local isOpen = false
    local function ToggleOption(state)
        isOpen = (state ~= nil) and state or not isOpen
        if isOpen then
            OptionPopup.Visible = true
            local targetH = math.clamp(Layout.AbsoluteContentSize.Y + 16, 40, 220)
            OptionPopup.Position = UDim2.fromOffset(
                optionButton.AbsolutePosition.X - parentWindow.AbsolutePosition.X + 26,
                optionButton.AbsolutePosition.Y - parentWindow.AbsolutePosition.Y
            )
            NeverwinLib:CreateAnimation(OptionPopup, 0.25, {Size = UDim2.new(0, 190, 0, targetH)})
            NeverwinLib:CreateAnimation(PopStroke, 0.25, {Transparency = 0})
        else
            NeverwinLib:CreateAnimation(PopStroke, 0.15, {Transparency = 1})
            local tween = NeverwinLib:CreateAnimation(OptionPopup, 0.2, {Size = UDim2.new(0, 190, 0, 0)})
            tween.Completed:Connect(function()
                if not isOpen then
                    OptionPopup.Visible = false
                end
            end)
        end
    end

    optionButton.MouseButton1Click:Connect(function() ToggleOption() end)

    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if isOpen and not NeverwinLib:IsMouseOverFrame(OptionPopup) and not NeverwinLib:IsMouseOverFrame(optionButton) and not NeverwinLib.GLOBAL_ENVIRONMENT.HOLDING_PICKER then
                ToggleOption(false)
            end
        end
    end)

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if isOpen then
            local targetH = math.clamp(Layout.AbsoluteContentSize.Y + 16, 40, 220)
            NeverwinLib:CreateAnimation(OptionPopup, 0.15, {Size = UDim2.new(0, 190, 0, targetH)})
            Scroll.CanvasSize = UDim2.fromOffset(0, Layout.AbsoluteContentSize.Y)
        end
    end)

    return Scroll, OptionPopup
end

-- COLOR PICKER COMPLETO
function NeverwinLib:CreateColorPicker(colorBox: Frame, defaultColor: Color3, defaultAlpha: number, callback: (Color3, number) -> any, parentWindow: Frame)
    defaultColor = defaultColor or Color3.fromRGB(0, 168, 237)
    defaultAlpha = defaultAlpha or 0
    callback = callback or function() end

    colorBox.Active = true

    local h, s, v = defaultColor:ToHSV()
    local alpha = defaultAlpha

    local PickerFrame = Instance.new("Frame")
    PickerFrame.Name = "ColorPicker_" .. NeverwinLib:RandomString(6)
    PickerFrame.Parent = parentWindow
    PickerFrame.BackgroundColor3 = THEME.CardBackground
    PickerFrame.BorderSizePixel = 0
    PickerFrame.ClipsDescendants = true
    PickerFrame.Size = UDim2.new(0, 185, 0, 0)
    PickerFrame.Visible = false
    PickerFrame.ZIndex = 200

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = PickerFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = THEME.BorderColor
    Stroke.Transparency = 1
    Stroke.Parent = PickerFrame

    NeverwinLib:AddDragBlacklist(PickerFrame)

    local SatValBox = Instance.new("ImageLabel")
    SatValBox.Size = UDim2.new(0, 138, 0, 130)
    SatValBox.Position = UDim2.new(0, 8, 0, 8)
    SatValBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
    SatValBox.Image = "rbxassetid://4155801252"
    SatValBox.BorderSizePixel = 0
    SatValBox.Active = true
    SatValBox.ZIndex = 201
    SatValBox.Parent = PickerFrame

    local SatCorner = Instance.new("UICorner")
    SatCorner.CornerRadius = UDim.new(0, 4)
    SatCorner.Parent = SatValBox

    local Cursor = Instance.new("Frame")
    Cursor.Size = UDim2.new(0, 6, 0, 6)
    Cursor.AnchorPoint = Vector2.new(0.5, 0.5)
    Cursor.Position = UDim2.new(s, 0, 1 - v, 0)
    Cursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Cursor.BorderSizePixel = 0
    Cursor.ZIndex = 202
    Cursor.Parent = SatValBox

    local CursorCorner = Instance.new("UICorner")
    CursorCorner.CornerRadius = UDim.new(1, 0)
    CursorCorner.Parent = Cursor

    local HueBar = Instance.new("Frame")
    HueBar.Size = UDim2.new(0, 18, 0, 130)
    HueBar.Position = UDim2.new(1, -26, 0, 8)
    HueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HueBar.BorderSizePixel = 0
    HueBar.Active = true
    HueBar.ZIndex = 201
    HueBar.Parent = PickerFrame

    local HueCorner = Instance.new("UICorner")
    HueCorner.CornerRadius = UDim.new(0, 4)
    HueCorner.Parent = HueBar

    local HueGrad = Instance.new("UIGradient")
    HueGrad.Rotation = 90
    HueGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
    })
    HueGrad.Parent = HueBar

    local HueSlider = Instance.new("Frame")
    HueSlider.Size = UDim2.new(1, 4, 0, 3)
    HueSlider.AnchorPoint = Vector2.new(0.5, 0.5)
    HueSlider.Position = UDim2.new(0.5, 0, h, 0)
    HueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HueSlider.BorderSizePixel = 0
    HueSlider.ZIndex = 202
    HueSlider.Parent = HueBar

    local AlphaBar = Instance.new("Frame")
    AlphaBar.Size = UDim2.new(1, -16, 0, 12)
    AlphaBar.Position = UDim2.new(0, 8, 0, 144)
    AlphaBar.BackgroundColor3 = defaultColor
    AlphaBar.BorderSizePixel = 0
    AlphaBar.Active = true
    AlphaBar.ZIndex = 201
    AlphaBar.Parent = PickerFrame

    local AlphaCorner = Instance.new("UICorner")
    AlphaCorner.CornerRadius = UDim.new(0, 3)
    AlphaCorner.Parent = AlphaBar

    local AlphaGrad = Instance.new("UIGradient")
    AlphaGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    AlphaGrad.Parent = AlphaBar

    local AlphaSlider = Instance.new("Frame")
    AlphaSlider.Size = UDim2.new(0, 4, 1, 4)
    AlphaSlider.AnchorPoint = Vector2.new(0.5, 0.5)
    AlphaSlider.Position = UDim2.new(1 - alpha, 0, 0.5, 0)
    AlphaSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    AlphaSlider.BorderSizePixel = 0
    AlphaSlider.ZIndex = 202
    AlphaSlider.Parent = AlphaBar

    local BottomRow = Instance.new("Frame")
    BottomRow.Size = UDim2.new(1, -16, 0, 22)
    BottomRow.Position = UDim2.new(0, 8, 0, 162)
    BottomRow.BackgroundTransparency = 1
    BottomRow.ZIndex = 201
    BottomRow.Parent = PickerFrame

    local HexLabel = Instance.new("TextBox")
    HexLabel.Size = UDim2.new(0, 85, 1, 0)
    HexLabel.BackgroundColor3 = THEME.ElementBackground
    HexLabel.Text = "#" .. defaultColor:ToHex()
    HexLabel.TextColor3 = THEME.FontOn
    HexLabel.Font = Enum.Font.GothamMedium
    HexLabel.TextSize = 11
    HexLabel.ClearTextOnFocus = false
    HexLabel.BorderSizePixel = 0
    HexLabel.ZIndex = 202
    HexLabel.Parent = BottomRow

    local HexCorner = Instance.new("UICorner")
    HexCorner.CornerRadius = UDim.new(0, 4)
    HexCorner.Parent = HexLabel

    local CopyBtn = Instance.new("ImageButton")
    CopyBtn.Size = UDim2.new(0, 22, 0, 22)
    CopyBtn.Position = UDim2.new(1, -50, 0, 0)
    CopyBtn.BackgroundColor3 = THEME.ElementBackground
    CopyBtn.Image = "rbxassetid://10709812159"
    CopyBtn.ImageColor3 = THEME.FontOn
    CopyBtn.BorderSizePixel = 0
    CopyBtn.ZIndex = 202
    CopyBtn.Parent = BottomRow

    local CopyCorner = Instance.new("UICorner")
    CopyCorner.CornerRadius = UDim.new(0, 4)
    CopyCorner.Parent = CopyBtn

    local PasteBtn = Instance.new("ImageButton")
    PasteBtn.Size = UDim2.new(0, 22, 0, 22)
    PasteBtn.Position = UDim2.new(1, -22, 0, 0)
    PasteBtn.BackgroundColor3 = THEME.ElementBackground
    PasteBtn.Image = "rbxassetid://10709799288"
    PasteBtn.ImageColor3 = THEME.FontOn
    PasteBtn.BorderSizePixel = 0
    PasteBtn.ZIndex = 202
    PasteBtn.Parent = BottomRow

    local PasteCorner = Instance.new("UICorner")
    PasteCorner.CornerRadius = UDim.new(0, 4)
    PasteCorner.Parent = PasteBtn

    local function UpdateColor(skipCallback)
        local curColor = Color3.fromHSV(h, s, v)
        colorBox.BackgroundColor3 = curColor
        colorBox.BackgroundTransparency = alpha
        SatValBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        AlphaBar.BackgroundColor3 = curColor
        HexLabel.Text = "#" .. curColor:ToHex()
        if not skipCallback then
            callback(curColor, alpha)
        end
    end

    local draggingSat, draggingHue, draggingAlpha = false, false, false

    SatValBox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSat = true
            NeverwinLib.GLOBAL_ENVIRONMENT.HOLDING_PICKER = true
            local x = math.clamp((input.Position.X - SatValBox.AbsolutePosition.X) / SatValBox.AbsoluteSize.X, 0, 1)
            local y = math.clamp((input.Position.Y - SatValBox.AbsolutePosition.Y) / SatValBox.AbsoluteSize.Y, 0, 1)
            s, v = x, 1 - y
            Cursor.Position = UDim2.new(s, 0, 1 - v, 0)
            UpdateColor()
        end
    end)

    HueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingHue = true
            NeverwinLib.GLOBAL_ENVIRONMENT.HOLDING_PICKER = true
            local y = math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
            h = y
            HueSlider.Position = UDim2.new(0.5, 0, h, 0)
            UpdateColor()
        end
    end)

    AlphaBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingAlpha = true
            NeverwinLib.GLOBAL_ENVIRONMENT.HOLDING_PICKER = true
            local x = math.clamp((input.Position.X - AlphaBar.AbsolutePosition.X) / AlphaBar.AbsoluteSize.X, 0, 1)
            alpha = 1 - x
            AlphaSlider.Position = UDim2.new(x, 0, 0.5, 0)
            UpdateColor()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSat = false
            draggingHue = false
            draggingAlpha = false
            NeverwinLib.GLOBAL_ENVIRONMENT.HOLDING_PICKER = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if draggingSat then
                local x = math.clamp((input.Position.X - SatValBox.AbsolutePosition.X) / SatValBox.AbsoluteSize.X, 0, 1)
                local y = math.clamp((input.Position.Y - SatValBox.AbsolutePosition.Y) / SatValBox.AbsoluteSize.Y, 0, 1)
                s, v = x, 1 - y
                Cursor.Position = UDim2.new(s, 0, 1 - v, 0)
                UpdateColor()
            elseif draggingHue then
                local y = math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                h = y
                HueSlider.Position = UDim2.new(0.5, 0, h, 0)
                UpdateColor()
            elseif draggingAlpha then
                local x = math.clamp((input.Position.X - AlphaBar.AbsolutePosition.X) / AlphaBar.AbsoluteSize.X, 0, 1)
                alpha = 1 - x
                AlphaSlider.Position = UDim2.new(x, 0, 0.5, 0)
                UpdateColor()
            end
        end
    end)

    CopyBtn.MouseButton1Click:Connect(function()
        NeverwinLib.GLOBAL_ENVIRONMENT.COPIED_COLOR = {Color = Color3.fromHSV(h, s, v), Alpha = alpha}
    end)

    PasteBtn.MouseButton1Click:Connect(function()
        if NeverwinLib.GLOBAL_ENVIRONMENT.COPIED_COLOR then
            local c = NeverwinLib.GLOBAL_ENVIRONMENT.COPIED_COLOR.Color
            alpha = NeverwinLib.GLOBAL_ENVIRONMENT.COPIED_COLOR.Alpha
            h, s, v = c:ToHSV()
            Cursor.Position = UDim2.new(s, 0, 1 - v, 0)
            HueSlider.Position = UDim2.new(0.5, 0, h, 0)
            AlphaSlider.Position = UDim2.new(1 - alpha, 0, 0.5, 0)
            UpdateColor()
        end
    end)

    HexLabel.FocusLost:Connect(function()
        local hex = HexLabel.Text:gsub("#", "")
        local success, newCol = pcall(function() return Color3.fromHex(hex) end)
        if success and newCol then
            h, s, v = newCol:ToHSV()
            Cursor.Position = UDim2.new(s, 0, 1 - v, 0)
            HueSlider.Position = UDim2.new(0.5, 0, h, 0)
            UpdateColor()
        else
            HexLabel.Text = "#" .. Color3.fromHSV(h, s, v):ToHex()
        end
    end)

    local isPickerOpen = false
    local function TogglePicker(state)
        isPickerOpen = (state ~= nil) and state or not isPickerOpen
        if isPickerOpen then
            PickerFrame.Visible = true
            PickerFrame.Position = UDim2.fromOffset(
                colorBox.AbsolutePosition.X - parentWindow.AbsolutePosition.X - 150,
                colorBox.AbsolutePosition.Y - parentWindow.AbsolutePosition.Y + 20
            )
            NeverwinLib:CreateAnimation(PickerFrame, 0.25, {Size = UDim2.new(0, 185, 0, 192)})
            NeverwinLib:CreateAnimation(Stroke, 0.25, {Transparency = 0})
        else
            NeverwinLib:CreateAnimation(Stroke, 0.15, {Transparency = 1})
            local tween = NeverwinLib:CreateAnimation(PickerFrame, 0.2, {Size = UDim2.new(0, 185, 0, 0)})
            tween.Completed:Connect(function()
                if not isPickerOpen then
                    PickerFrame.Visible = false
                end
            end)
        end
    end

    colorBox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TogglePicker()
        end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if isPickerOpen and not NeverwinLib:IsMouseOverFrame(PickerFrame) and not NeverwinLib:IsMouseOverFrame(colorBox) and not NeverwinLib.GLOBAL_ENVIRONMENT.HOLDING_PICKER then
                TogglePicker(false)
            end
        end
    end)

    UpdateColor(true)

    return {
        Set = function(newCol, newAlpha)
            h, s, v = newCol:ToHSV()
            alpha = newAlpha or alpha
            Cursor.Position = UDim2.new(s, 0, 1 - v, 0)
            HueSlider.Position = UDim2.new(0.5, 0, h, 0)
            AlphaSlider.Position = UDim2.new(1 - alpha, 0, 0.5, 0)
            UpdateColor()
        end
    }
end

-- DROPDOWN / MULTI-DROPDOWN
function NeverwinLib:CreateDropdownPopup(dropdownBtn: TextButton, values: {string}, default: any, isMulti: boolean, callback: (any) -> any, parentWindow: Frame)
    values = values or {}
    callback = callback or function() end

    local selected = isMulti and {} or default
    if isMulti and typeof(default) == "table" then
        for _, v in ipairs(default) do selected[v] = true end
    end

    local DropFrame = Instance.new("Frame")
    DropFrame.Name = "DropdownPopup_" .. NeverwinLib:RandomString(6)
    DropFrame.Parent = parentWindow
    DropFrame.BackgroundColor3 = THEME.CardBackground
    DropFrame.BorderSizePixel = 0
    DropFrame.ClipsDescendants = true
    DropFrame.Size = UDim2.new(0, 150, 0, 0)
    DropFrame.Visible = false
    DropFrame.ZIndex = 150

    local DropCorner = Instance.new("UICorner")
    DropCorner.CornerRadius = UDim.new(0, 4)
    DropCorner.Parent = DropFrame

    local DropStroke = Instance.new("UIStroke")
    DropStroke.Color = THEME.BorderColor
    DropStroke.Transparency = 1
    DropStroke.Parent = DropFrame

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, -8, 1, -8)
    Scroll.Position = UDim2.new(0, 4, 0, 4)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 2
    Scroll.ScrollBarImageColor3 = THEME.AccentBlue
    Scroll.ZIndex = 151
    Scroll.Parent = DropFrame

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 4)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Scroll

    NeverwinLib:AddDragBlacklist(DropFrame)

    local function FormatText()
        if isMulti then
            local active = {}
            for k, v in pairs(selected) do
                if v then table.insert(active, tostring(k)) end
            end
            return #active > 0 and table.concat(active, ", ") or "None"
        else
            return tostring(selected or "None")
        end
    end

    local itemButtons = {}
    local function RenderItems()
        for _, b in ipairs(itemButtons) do b:Destroy() end
        table.clear(itemButtons)

        for _, val in ipairs(values) do
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 20)
            Btn.BackgroundTransparency = 1
            Btn.Text = "  " .. tostring(val)
            Btn.Font = Enum.Font.GothamMedium
            Btn.TextSize = 12
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.ZIndex = 152
            Btn.Parent = Scroll

            local isSelected = isMulti and selected[val] or (selected == val)
            Btn.TextColor3 = isSelected and THEME.AccentBlue or THEME.FontOff

            Btn.MouseButton1Click:Connect(function()
                if isMulti then
                    selected[val] = not selected[val]
                    Btn.TextColor3 = selected[val] and THEME.AccentBlue or THEME.FontOff
                    dropdownBtn.Text = "  " .. FormatText()
                    callback(selected)
                else
                    selected = val
                    for _, b in ipairs(itemButtons) do b.TextColor3 = THEME.FontOff end
                    Btn.TextColor3 = THEME.AccentBlue
                    dropdownBtn.Text = "  " .. FormatText()
                    callback(selected)
                end
            end)

            table.insert(itemButtons, Btn)
        end
    end

    RenderItems()
    dropdownBtn.Text = "  " .. FormatText()

    local isDropOpen = false
    local function ToggleDrop(state)
        isDropOpen = (state ~= nil) and state or not isDropOpen
        if isDropOpen then
            DropFrame.Visible = true
            local targetH = math.clamp(#values * 24 + 10, 30, 160)
            DropFrame.Position = UDim2.fromOffset(
                dropdownBtn.AbsolutePosition.X - parentWindow.AbsolutePosition.X,
                dropdownBtn.AbsolutePosition.Y - parentWindow.AbsolutePosition.Y + dropdownBtn.AbsoluteSize.Y + 4
            )
            DropFrame.Size = UDim2.new(0, dropdownBtn.AbsoluteSize.X, 0, 0)
            NeverwinLib:CreateAnimation(DropFrame, 0.25, {Size = UDim2.new(0, dropdownBtn.AbsoluteSize.X, 0, targetH)})
            NeverwinLib:CreateAnimation(DropStroke, 0.25, {Transparency = 0})
            Scroll.CanvasSize = UDim2.fromOffset(0, Layout.AbsoluteContentSize.Y)
        else
            NeverwinLib:CreateAnimation(DropStroke, 0.15, {Transparency = 1})
            local tween = NeverwinLib:CreateAnimation(DropFrame, 0.2, {Size = UDim2.new(0, dropdownBtn.AbsoluteSize.X, 0, 0)})
            tween.Completed:Connect(function()
                if not isDropOpen then
                    DropFrame.Visible = false
                end
            end)
        end
    end

    dropdownBtn.MouseButton1Click:Connect(function() ToggleDrop() end)

    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if isDropOpen and not NeverwinLib:IsMouseOverFrame(DropFrame) and not NeverwinLib:IsMouseOverFrame(dropdownBtn) then
                ToggleDrop(false)
            end
        end
    end)

    return {
        SetValues = function(newVals)
            values = newVals
            RenderItems()
        end,
        Set = function(newVal)
            selected = newVal
            dropdownBtn.Text = "  " .. FormatText()
            RenderItems()
        end
    }
end

-- ==================================================================== --
--                           CRIADOR DA JANELA                          --
-- ==================================================================== --

function NeverwinLib:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "NEVERWIN"
    local toggleKey = config.Keybind or Enum.KeyCode.Insert
    local windowScale = config.Scale or UDim2.new(0, 880, 0, 540)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NeverwinUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui
    protect_gui(ScreenGui)

    -- JANELA PRINCIPAL
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Size = windowScale
    MainWindow.Position = UDim2.new(0.5, -505, 0.5, -270)
    MainWindow.BackgroundTransparency = 1
    MainWindow.BorderSizePixel = 0
    MainWindow.Parent = ScreenGui

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = THEME.BorderColor
    MainStroke.Thickness = 1
    MainStroke.Parent = MainWindow

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainWindow

    -- SIDEBAR ACRÍLICA
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 220, 1, 0)
    Sidebar.BackgroundColor3 = THEME.SidebarColor
    Sidebar.BackgroundTransparency = THEME.SidebarTransparency
    Sidebar.BorderSizePixel = 0
    Sidebar.ClipsDescendants = true
    Sidebar.Parent = MainWindow

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 10)
    SidebarCorner.Parent = Sidebar

    local FrostedTexture = Instance.new("ImageLabel")
    FrostedTexture.Size = UDim2.new(1, 0, 1, 0)
    FrostedTexture.BackgroundTransparency = 1
    FrostedTexture.Image = "rbxassetid://9968344887"
    FrostedTexture.ImageTransparency = 0.82
    FrostedTexture.ScaleType = Enum.ScaleType.Tile
    FrostedTexture.TileSize = UDim2.new(0, 128, 0, 128)
    FrostedTexture.Parent = Sidebar

    local GlassSheen = Instance.new("UIGradient")
    GlassSheen.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 230, 245)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 195, 220))
    })
    GlassSheen.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0.12)
    })
    GlassSheen.Rotation = 45
    GlassSheen.Parent = Sidebar

    local SidebarRightFiller = Instance.new("Frame")
    SidebarRightFiller.Size = UDim2.new(0, 10, 1, 0)
    SidebarRightFiller.Position = UDim2.new(1, -10, 0, 0)
    SidebarRightFiller.BackgroundColor3 = THEME.SidebarColor
    SidebarRightFiller.BorderSizePixel = 0
    SidebarRightFiller.Parent = Sidebar

    local SidebarBorder = Instance.new("Frame")
    SidebarBorder.Size = UDim2.new(0, 1, 1, 0)
    SidebarBorder.Position = UDim2.new(1, -1, 0, 0)
    SidebarBorder.BackgroundColor3 = THEME.HeaderDivider
    SidebarBorder.BorderSizePixel = 0
    SidebarBorder.Parent = Sidebar

    local LogoTitle = Instance.new("TextLabel")
    LogoTitle.Size = UDim2.new(1, 0, 0, 68)
    LogoTitle.Text = windowTitle
    LogoTitle.Font = Enum.Font.GothamBlack
    LogoTitle.TextSize = 32
    LogoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogoTitle.TextXAlignment = Enum.TextXAlignment.Center
    LogoTitle.BackgroundTransparency = 1
    LogoTitle.ZIndex = 3
    LogoTitle.Parent = Sidebar

    -- PAINEL DIREITO
    local RightPanel = Instance.new("Frame")
    RightPanel.Name = "RightPanel"
    RightPanel.Size = UDim2.new(1, -220, 1, 0)
    RightPanel.Position = UDim2.new(0, 220, 0, 0)
    RightPanel.BackgroundColor3 = THEME.RightBackground
    RightPanel.BorderSizePixel = 0
    RightPanel.ClipsDescendants = true
    RightPanel.Parent = MainWindow

    local RightCorner = Instance.new("UICorner")
    RightCorner.CornerRadius = UDim.new(0, 10)
    RightCorner.Parent = RightPanel

    local RightLeftFiller = Instance.new("Frame")
    RightLeftFiller.Size = UDim2.new(0, 10, 1, 0)
    RightLeftFiller.BackgroundColor3 = THEME.RightBackground
    RightLeftFiller.BorderSizePixel = 0
    RightLeftFiller.Parent = RightPanel

    local TopHeader = Instance.new("Frame")
    TopHeader.Size = UDim2.new(1, 0, 0, 68)
    TopHeader.BackgroundTransparency = 1
    TopHeader.Parent = RightPanel

    local HeaderLine = Instance.new("Frame")
    HeaderLine.Size = UDim2.new(1, 0, 0, 1)
    HeaderLine.Position = UDim2.new(0, 0, 0, 68)
    HeaderLine.BackgroundColor3 = THEME.HeaderDivider
    HeaderLine.BorderSizePixel = 0
    HeaderLine.Parent = RightPanel

    MakeDraggable(Sidebar, MainWindow)
    MakeDraggable(TopHeader, MainWindow)

    -- CONTAINER DE ABAS
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, 0, 1, -122)
    TabContainer.Position = UDim2.new(0, 0, 0, 72)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContainer.ZIndex = 3
    TabContainer.Parent = Sidebar

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 4)
    TabLayout.Parent = TabContainer

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingLeft = UDim.new(0, 18)
    TabPadding.PaddingRight = UDim.new(0, 18)
    TabPadding.Parent = TabContainer

    -- PERFIL INFERIOR
    local ProfileFrame = Instance.new("Frame")
    ProfileFrame.Size = UDim2.new(1, 0, 0, 46)
    ProfileFrame.Position = UDim2.new(0, 0, 1, -46)
    ProfileFrame.BackgroundColor3 = THEME.ProfileBackground
    ProfileFrame.BorderSizePixel = 0
    ProfileFrame.ZIndex = 4
    ProfileFrame.Parent = Sidebar

    local ProfileCorner = Instance.new("UICorner")
    ProfileCorner.CornerRadius = UDim.new(0, 10)
    ProfileCorner.Parent = ProfileFrame

    local ProfileTopFiller = Instance.new("Frame")
    ProfileTopFiller.Size = UDim2.new(1, 0, 0, 12)
    ProfileTopFiller.BackgroundColor3 = THEME.ProfileBackground
    ProfileTopFiller.BorderSizePixel = 0
    ProfileTopFiller.ZIndex = 4
    ProfileTopFiller.Parent = ProfileFrame

    local ProfileFiller = Instance.new("Frame")
    ProfileFiller.Size = UDim2.new(0, 10, 1, 0)
    ProfileFiller.Position = UDim2.new(1, -10, 0, 0)
    ProfileFiller.BackgroundColor3 = THEME.ProfileBackground
    ProfileFiller.BorderSizePixel = 0
    ProfileFiller.ZIndex = 4
    ProfileFiller.Parent = ProfileFrame

    local ProfileTopLine = Instance.new("Frame")
    ProfileTopLine.Size = UDim2.new(1, 0, 0, 1)
    ProfileTopLine.BackgroundColor3 = THEME.HeaderDivider
    ProfileTopLine.BorderSizePixel = 0
    ProfileTopLine.ZIndex = 5
    ProfileTopLine.Parent = ProfileFrame

    local AvatarImage = Instance.new("ImageLabel")
    AvatarImage.Size = UDim2.new(0, 30, 0, 30)
    AvatarImage.Position = UDim2.new(0, 14, 0.5, -15)
    AvatarImage.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    AvatarImage.BorderSizePixel = 0
    AvatarImage.ZIndex = 6
    AvatarImage.Parent = ProfileFrame

    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(0, 6)
    AvatarCorner.Parent = AvatarImage

    task.spawn(function()
        local thumb, isReady = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        if isReady then AvatarImage.Image = thumb end
    end)

    local NickLabel = Instance.new("TextLabel")
    NickLabel.Size = UDim2.new(1, -60, 1, 0)
    NickLabel.Position = UDim2.new(0, 52, 0, 0)
    NickLabel.Text = LocalPlayer.Name
    NickLabel.Font = Enum.Font.GothamBold
    NickLabel.TextSize = 13
    NickLabel.TextColor3 = THEME.FontOn
    NickLabel.TextXAlignment = Enum.TextXAlignment.Left
    NickLabel.BackgroundTransparency = 1
    NickLabel.TextTruncate = Enum.TextTruncate.AtEnd
    NickLabel.ZIndex = 6
    NickLabel.Parent = ProfileFrame

    -- CONTAINER DE CONTEÚDO
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, 0, 1, -69)
    ContentContainer.Position = UDim2.new(0, 0, 0, 69)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = RightPanel

    -- ================= 3D PREVIEW (300x540, FOV 80, LIMPO SEM ESP INTERNO) =================
    local PreviewWindow = Instance.new("Frame")
    PreviewWindow.Name = "PlayerPreview3D"
    PreviewWindow.Size = UDim2.new(0, 300, 0, 540)
    PreviewWindow.Position = UDim2.new(0.5, 395, 0.5, -270)
    PreviewWindow.BackgroundColor3 = THEME.PreviewBackground
    PreviewWindow.BorderSizePixel = 0
    PreviewWindow.ClipsDescendants = true
    PreviewWindow.Parent = ScreenGui

    local PreviewCorner = Instance.new("UICorner")
    PreviewCorner.CornerRadius = UDim.new(0, 10)
    PreviewCorner.Parent = PreviewWindow

    local PreviewStroke = Instance.new("UIStroke")
    PreviewStroke.Color = THEME.BorderColor
    PreviewStroke.Thickness = 1
    PreviewStroke.Parent = PreviewWindow

    local PreviewHeader = Instance.new("Frame")
    PreviewHeader.Size = UDim2.new(1, 0, 0, 36)
    PreviewHeader.BackgroundTransparency = 1
    PreviewHeader.Parent = PreviewWindow

    local PreviewTitle = Instance.new("TextLabel")
    PreviewTitle.Size = UDim2.new(1, -20, 1, 0)
    PreviewTitle.Position = UDim2.new(0, 14, 0, 0)
    PreviewTitle.Text = "PREVIEW"
    PreviewTitle.Font = Enum.Font.GothamBold
    PreviewTitle.TextSize = 11
    PreviewTitle.TextColor3 = THEME.CategoryFont
    PreviewTitle.TextXAlignment = Enum.TextXAlignment.Left
    PreviewTitle.BackgroundTransparency = 1
    PreviewTitle.Parent = PreviewHeader

    local PreviewHeaderLine = Instance.new("Frame")
    PreviewHeaderLine.Size = UDim2.new(1, 0, 0, 1)
    PreviewHeaderLine.Position = UDim2.new(0, 0, 0, 36)
    PreviewHeaderLine.BackgroundColor3 = THEME.HeaderDivider
    PreviewHeaderLine.BorderSizePixel = 0
    PreviewHeaderLine.Parent = PreviewHeader

    MakeDraggable(PreviewHeader, PreviewWindow)

    local Viewport = Instance.new("ViewportFrame")
    Viewport.Size = UDim2.new(1, 0, 1, -37)
    Viewport.Position = UDim2.new(0, 0, 0, 37)
    Viewport.BackgroundTransparency = 1
    Viewport.LightColor = Color3.fromRGB(255, 255, 255)
    Viewport.LightDirection = Vector3.new(-1, 1, -1)
    Viewport.Ambient = Color3.fromRGB(180, 180, 180)
    Viewport.Active = true
    Viewport.Parent = PreviewWindow

    local WorldModel = Instance.new("WorldModel")
    WorldModel.Parent = Viewport

    local PreviewCamera = Instance.new("Camera")
    PreviewCamera.CameraType = Enum.CameraType.Scriptable
    PreviewCamera.FieldOfView = 80
    Viewport.CurrentCamera = PreviewCamera
    PreviewCamera.Parent = Viewport

    -- RENDERIZAÇÃO DO AVATAR 3D (LIMPO)
    task.spawn(function()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        character.Archivable = true
        local clone = character:Clone()
        character.Archivable = false

        for _, obj in ipairs(clone:GetDescendants()) do
            if obj:IsA("LuaSourceContainer") or obj:IsA("Sound") then
                obj:Destroy()
            elseif obj:IsA("BasePart") then
                obj.Anchored = true
                obj.CanCollide = false
            end
        end

        clone.Parent = WorldModel
        local root = clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChild("Torso") or clone:FindFirstChild("UpperTorso") or clone.PrimaryPart

      if root then
            -- Adicionado * CFrame.Angles(0, math.pi, 0) para girar 180° de frente para a câmera
            if clone.PrimaryPart then
                clone:SetPrimaryPartCFrame(CFrame.new(0, 0, 0) * CFrame.Angles(0, math.pi, 0))
            else
                root.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.pi, 0)
            end
            local targetPos = root.Position + Vector3.new(0, -0.15, 0)
            PreviewCamera.CFrame = CFrame.lookAt(Vector3.new(0, 0.05, 5.5), targetPos)
        end

        local isRotating = false
        local lastMouseX = 0
        local currentAngle = math.pi -- Inicia o ângulo do mouse em 180° (math.pi) para a rotação continuar suave

        local isRotating = false
        local lastMouseX = 0
        local currentAngle = 0

        Viewport.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isRotating = true
                lastMouseX = input.Position.X
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isRotating = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if isRotating and input.UserInputType == Enum.UserInputType.MouseMovement and root then
                local delta = input.Position.X - lastMouseX
                lastMouseX = input.Position.X
                currentAngle = currentAngle + (delta * 0.015)
                if clone.PrimaryPart then
                    clone:SetPrimaryPartCFrame(CFrame.new(0, 0, 0) * CFrame.Angles(0, currentAngle, 0))
                else
                    root.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, currentAngle, 0)
                end
            end
        end)
    end)

    -- MÉTODOS DE CONTROLE DA JANELA & KEYBIND TOGGLE (100% CORRIGIDO)
    local WindowObj = {
        Tabs = {},
        Categories = {},
        TabContainer = TabContainer,
        ContentContainer = ContentContainer,
        MainWindow = MainWindow,
        ScreenGui = ScreenGui,
        IsVisible = true
    }

    local function SetUIVisibility(state)
        if state ~= nil then
            WindowObj.IsVisible = state
        else
            WindowObj.IsVisible = not WindowObj.IsVisible
        end
        ScreenGui.Enabled = WindowObj.IsVisible
    end

    WindowObj.Toggle = SetUIVisibility
    WindowObj.SetVisible = SetUIVisibility

    -- OUVINTE DE KEYBIND ATUALIZADO (SUPORTA RIGHTSHIFT / INSERT / QUALQUER TECLA)
    UserInputService.InputBegan:Connect(function(input)
        -- Ignora apenas se o usuário estiver digitando em uma caixa de texto
        if UserInputService:GetFocusedTextBox() ~= nil then return end

        if MatchesKey(input, toggleKey) then
            SetUIVisibility()
        end
    end)

    function WindowObj:GetPreviewViewport() return Viewport end
    function WindowObj:GetPreviewCamera() return PreviewCamera end
    function WindowObj:GetPreviewWorldModel() return WorldModel end

    function WindowObj:CreateTab(categoryName, tabName, iconName)
        if not self.Categories[categoryName] then
            local CatLabel = Instance.new("TextLabel")
            CatLabel.Size = UDim2.new(1, 0, 0, 28)
            CatLabel.Text = categoryName
            CatLabel.Font = Enum.Font.GothamBold
            CatLabel.TextSize = 12
            CatLabel.TextColor3 = THEME.CategoryFont
            CatLabel.TextXAlignment = Enum.TextXAlignment.Left
            CatLabel.BackgroundTransparency = 1
            CatLabel.Parent = self.TabContainer
            self.Categories[categoryName] = true
        end

        local TabButton = Instance.new("TextButton")
        TabButton.Name = "Tab_" .. tabName
        TabButton.Size = UDim2.new(1, 0, 0, 36)
        TabButton.BackgroundTransparency = 1
        TabButton.Text = ""
        TabButton.ZIndex = 3
        TabButton.Parent = self.TabContainer

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 0, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = NeverwinLib:GetIcon(iconName)
        TabIcon.ImageColor3 = THEME.FontOff
        TabIcon.ZIndex = 3
        TabIcon.Parent = TabButton

        local TabText = Instance.new("TextLabel")
        TabText.Name = "Title"
        TabText.Size = UDim2.new(1, -32, 1, 0)
        TabText.Position = UDim2.new(0, 32, 0, 0)
        TabText.Text = tabName
        TabText.Font = Enum.Font.GothamMedium
        TabText.TextSize = 14
        TabText.TextColor3 = THEME.FontOff
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.BackgroundTransparency = 1
        TabText.ZIndex = 3
        TabText.Parent = TabButton

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = "Page_" .. tabName
        TabPage.Size = UDim2.new(1, -32, 1, -32)
        TabPage.Position = UDim2.new(0, 16, 0, 16)
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = THEME.AccentBlue
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.Visible = false
        TabPage.Parent = self.ContentContainer

        local ColumnsContainer = Instance.new("Frame")
        ColumnsContainer.Size = UDim2.new(1, 0, 1, 0)
        ColumnsContainer.BackgroundTransparency = 1
        ColumnsContainer.Parent = TabPage

        local ColumnLayout = Instance.new("UIListLayout")
        ColumnLayout.FillDirection = Enum.FillDirection.Horizontal
        ColumnLayout.Padding = UDim.new(0, 16)
        ColumnLayout.Parent = ColumnsContainer

        local LeftColumn = Instance.new("Frame")
        LeftColumn.Size = UDim2.new(0.5, -8, 0, 0)
        LeftColumn.AutomaticSize = Enum.AutomaticSize.Y
        LeftColumn.BackgroundTransparency = 1
        LeftColumn.Parent = ColumnsContainer

        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.Padding = UDim.new(0, 14)
        LeftLayout.Parent = LeftColumn

        local RightColumn = Instance.new("Frame")
        RightColumn.Size = UDim2.new(0.5, -8, 0, 0)
        RightColumn.AutomaticSize = Enum.AutomaticSize.Y
        RightColumn.BackgroundTransparency = 1
        RightColumn.Parent = ColumnsContainer

        local RightLayout = Instance.new("UIListLayout")
        RightLayout.Padding = UDim.new(0, 14)
        RightLayout.Parent = RightColumn

        local TabObj = {
            Button = TabButton,
            Icon = TabIcon,
            Text = TabText,
            Page = TabPage,
            LeftCol = LeftColumn,
            RightCol = RightColumn,
        }

        local function ActivateTab()
            for _, t in pairs(WindowObj.Tabs) do
                t.Page.Visible = false
                NeverwinLib:CreateAnimation(t.Icon, 0.15, {ImageColor3 = THEME.FontOff})
                NeverwinLib:CreateAnimation(t.Text, 0.15, {TextColor3 = THEME.FontOff})
            end
            TabPage.Visible = true
            NeverwinLib:CreateAnimation(TabIcon, 0.15, {ImageColor3 = THEME.AccentBlue})
            NeverwinLib:CreateAnimation(TabText, 0.15, {TextColor3 = THEME.FontOn})
            WindowObj.CurrentTab = TabObj
        end

        TabButton.MouseButton1Click:Connect(ActivateTab)

        if #WindowObj.Tabs == 0 then
            ActivateTab()
        end

        table.insert(WindowObj.Tabs, TabObj)

        -- CARDS
        function TabObj:CreateCard(cardTitle, side)
            side = side or "Left"
            local targetCol = (side == "Right") and self.RightCol or self.LeftCol

            local CardFrame = Instance.new("Frame")
            CardFrame.Name = "Card_" .. cardTitle
            CardFrame.Size = UDim2.new(1, 0, 0, 0)
            CardFrame.AutomaticSize = Enum.AutomaticSize.Y
            CardFrame.BackgroundColor3 = THEME.CardBackground
            CardFrame.BorderSizePixel = 0
            CardFrame.Parent = targetCol

            local CardCorner = Instance.new("UICorner")
            CardCorner.CornerRadius = UDim.new(0, 8)
            CardCorner.Parent = CardFrame

            local CardHeader = Instance.new("TextLabel")
            CardHeader.Size = UDim2.new(1, -28, 0, 38)
            CardHeader.Position = UDim2.new(0, 14, 0, 0)
            CardHeader.Text = cardTitle
            CardHeader.Font = Enum.Font.GothamBold
            CardHeader.TextSize = 14
            CardHeader.TextColor3 = THEME.FontOn
            CardHeader.TextXAlignment = Enum.TextXAlignment.Left
            CardHeader.BackgroundTransparency = 1
            CardHeader.Parent = CardFrame

            local CardSeparator = Instance.new("Frame")
            CardSeparator.Size = UDim2.new(1, 0, 0, 1)
            CardSeparator.Position = UDim2.new(0, 0, 0, 38)
            CardSeparator.BackgroundColor3 = THEME.CardBlueDivider
            CardSeparator.BorderSizePixel = 0
            CardSeparator.Parent = CardFrame

            local ItemList = Instance.new("Frame")
            ItemList.Size = UDim2.new(1, 0, 0, 0)
            ItemList.Position = UDim2.new(0, 0, 0, 42)
            ItemList.AutomaticSize = Enum.AutomaticSize.Y
            ItemList.BackgroundTransparency = 1
            ItemList.Parent = CardFrame

            local ItemLayout = Instance.new("UIListLayout")
            ItemLayout.Padding = UDim.new(0, 8)
            ItemLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ItemLayout.Parent = ItemList

            local ItemPadding = Instance.new("UIPadding")
            ItemPadding.PaddingLeft = UDim.new(0, 14)
            ItemPadding.PaddingRight = UDim.new(0, 14)
            ItemPadding.PaddingBottom = UDim.new(0, 14)
            ItemPadding.Parent = ItemList

            local CardBuilder = {}

            local function AttachElements(builder, container)
                -- 1. TOGGLE
                local function CreateToggleComponent(selfObj, toggleData)
                    toggleData = GetArgs(selfObj, toggleData)
                    local name = toggleData.Name or "Toggle"
                    local state = (toggleData.Default ~= nil) and toggleData.Default or false
                    local hasOption = toggleData.Option or false
                    local callback = toggleData.Callback or function() end

                    local Row = Instance.new("Frame")
                    Row.Name = "ToggleRow_" .. name
                    Row.Size = UDim2.new(1, 0, 0, 30)
                    Row.BackgroundTransparency = 1
                    Row.Parent = container

                    local Label = Instance.new("TextLabel")
                    Label.Size = UDim2.new(1, hasOption and -68 or -48, 1, 0)
                    Label.Text = name
                    Label.Font = Enum.Font.GothamMedium
                    Label.TextSize = 13
                    Label.TextColor3 = state and THEME.FontOn or THEME.FontOff
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    Label.BackgroundTransparency = 1
                    Label.Parent = Row

                    local Switch = Instance.new("TextButton")
                    Switch.Size = UDim2.new(0, 32, 0, 12)
                    Switch.Position = UDim2.new(1, hasOption and -58 or -38, 0.5, -6)
                    Switch.BackgroundColor3 = state and THEME.ToggleBgOn or THEME.ToggleBgOff
                    Switch.Text = ""
                    Switch.BorderSizePixel = 0
                    Switch.AutoButtonColor = false
                    Switch.ClipsDescendants = false
                    Switch.Parent = Row

                    local SwitchCorner = Instance.new("UICorner")
                    SwitchCorner.CornerRadius = UDim.new(1, 0)
                    SwitchCorner.Parent = Switch

                    local SwitchKnob = Instance.new("Frame")
                    SwitchKnob.Size = UDim2.new(0, 18, 0, 18)
                    SwitchKnob.Position = state and UDim2.new(1, -15, 0.5, -9) or UDim2.new(0, -3, 0.5, -9)
                    SwitchKnob.BackgroundColor3 = THEME.ToggleKnob
                    SwitchKnob.BorderSizePixel = 0
                    SwitchKnob.Parent = Switch

                    local KnobCorner = Instance.new("UICorner")
                    KnobCorner.CornerRadius = UDim.new(1, 0)
                    KnobCorner.Parent = SwitchKnob

                    local SubContainer = Instance.new("Frame")
                    SubContainer.Name = "SubContainer_" .. name
                    SubContainer.Size = UDim2.new(1, 0, 0, 0)
                    SubContainer.BackgroundTransparency = 1
                    SubContainer.ClipsDescendants = true
                    SubContainer.Visible = false
                    SubContainer.Parent = container

                    local SubLayout = Instance.new("UIListLayout")
                    SubLayout.Padding = UDim.new(0, 8)
                    SubLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    SubLayout.Parent = SubContainer

                    local SubPadding = Instance.new("UIPadding")
                    SubPadding.PaddingLeft = UDim.new(0, 10)
                    SubPadding.Parent = SubContainer

                    local OptionObj = nil
                    if hasOption then
                        local OptionBtn = Instance.new("ImageButton")
                        OptionBtn.Size = UDim2.new(0, 16, 0, 16)
                        OptionBtn.Position = UDim2.new(1, -20, 0.5, -8)
                        OptionBtn.BackgroundTransparency = 1
                        OptionBtn.Image = "http://www.roblox.com/asset/?id=14007344336"
                        OptionBtn.ImageTransparency = 0.5
                        OptionBtn.Parent = Row

                        NeverwinLib:CreateHover(OptionBtn, function(h)
                            NeverwinLib:CreateAnimation(OptionBtn, 0.2, {ImageTransparency = h and 0.1 or 0.5})
                        end)

                        local optionScroll = NeverwinLib:CreateOptionPopup(OptionBtn, MainWindow)
                        OptionObj = {}
                        AttachElements(OptionObj, optionScroll)
                    end

                    local function UpdateAccordion(isOpen, skipAnim)
                        if #SubContainer:GetChildren() <= 2 then return end

                        if isOpen then
                            SubContainer.Visible = true
                            local targetHeight = SubLayout.AbsoluteContentSize.Y
                            if targetHeight == 0 then
                                for _, c in ipairs(SubContainer:GetChildren()) do
                                    if c:IsA("GuiObject") then
                                        targetHeight = targetHeight + (c.Size.Y.Offset > 0 and c.Size.Y.Offset or 30) + 8
                                    end
                                end
                            end

                            if skipAnim then
                                SubContainer.Size = UDim2.new(1, 0, 0, targetHeight)
                            else
                                NeverwinLib:CreateAnimation(SubContainer, 0.24, Enum.EasingStyle.Quart, {Size = UDim2.new(1, 0, 0, targetHeight)})
                            end
                        else
                            if skipAnim then
                                SubContainer.Size = UDim2.new(1, 0, 0, 0)
                                SubContainer.Visible = false
                            else
                                local tween = NeverwinLib:CreateAnimation(SubContainer, 0.2, Enum.EasingStyle.Quart, {Size = UDim2.new(1, 0, 0, 0)})
                                tween.Completed:Connect(function()
                                    if not state then SubContainer.Visible = false end
                                end)
                            end
                        end
                    end

                    SubLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                        if state and SubContainer.Visible then
                            NeverwinLib:CreateAnimation(SubContainer, 0.15, {Size = UDim2.new(1, 0, 0, SubLayout.AbsoluteContentSize.Y)})
                        end
                    end)

                    local function SetState(newState, skipAnim)
                        state = newState
                        local knobTarget = state and UDim2.new(1, -15, 0.5, -9) or UDim2.new(0, -3, 0.5, -9)
                        local bgTarget = state and THEME.ToggleBgOn or THEME.ToggleBgOff
                        local textTarget = state and THEME.FontOn or THEME.FontOff

                        if skipAnim then
                            SwitchKnob.Position = knobTarget
                            Switch.BackgroundColor3 = bgTarget
                            Label.TextColor3 = textTarget
                        else
                            NeverwinLib:CreateAnimation(SwitchKnob, 0.18, {Position = knobTarget})
                            NeverwinLib:CreateAnimation(Switch, 0.18, {BackgroundColor3 = bgTarget})
                            NeverwinLib:CreateAnimation(Label, 0.18, {TextColor3 = textTarget})
                        end

                        UpdateAccordion(state, skipAnim)
                        callback(state)
                    end

                    Switch.MouseButton1Click:Connect(function() SetState(not state) end)

                    task.defer(function()
                        SetState(state, true)
                    end)

                    local ToggleObj = {
                        Row = Row,
                        Label = Label,
                        SubContainer = SubContainer,
                        Option = OptionObj,
                        Set = SetState
                    }

                    AttachElements(ToggleObj, SubContainer)

                    return ToggleObj
                end

                builder.AddToggle = CreateToggleComponent
                builder.CreateToggle = CreateToggleComponent

                -- 2. SLIDER
                local function CreateSliderComponent(selfObj, sliderData)
                    sliderData = GetArgs(selfObj, sliderData)
                    local name = sliderData.Name or "Slider"
                    local min = sliderData.Min or 0
                    local max = sliderData.Max or 100
                    local default = sliderData.Default or min
                    local hasOption = sliderData.Option or false
                    local callback = sliderData.Callback or function() end
                    local isEnabled = true

                    local Row = Instance.new("Frame")
                    Row.Name = "SliderRow_" .. name
                    Row.Size = UDim2.new(1, 0, 0, 30)
                    Row.BackgroundTransparency = 1
                    Row.Parent = container

                    local Label = Instance.new("TextLabel")
                    Label.Size = UDim2.new(0, 80, 1, 0)
                    Label.Text = name
                    Label.Font = Enum.Font.GothamMedium
                    Label.TextSize = 13
                    Label.TextColor3 = THEME.FontOn
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    Label.BackgroundTransparency = 1
                    Label.Parent = Row

                    local ValueLabel = Instance.new("TextLabel")
                    ValueLabel.Size = UDim2.new(0, 36, 1, 0)
                    ValueLabel.Position = UDim2.new(1, hasOption and -62 or -36, 0, 0)
                    ValueLabel.Text = tostring(default)
                    ValueLabel.Font = Enum.Font.GothamMedium
                    ValueLabel.TextSize = 13
                    ValueLabel.TextColor3 = THEME.FontOn
                    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                    ValueLabel.BackgroundTransparency = 1
                    ValueLabel.Parent = Row

                    local SliderBar = Instance.new("TextButton")
                    SliderBar.Size = UDim2.new(1, hasOption and -170 or -140, 0, 4)
                    SliderBar.Position = UDim2.new(0, 88, 0.5, -2)
                    SliderBar.BackgroundColor3 = THEME.SliderInactiveBar
                    SliderBar.Text = ""
                    SliderBar.BorderSizePixel = 0
                    SliderBar.AutoButtonColor = false
                    SliderBar.Parent = Row

                    local BarCorner = Instance.new("UICorner")
                    BarCorner.CornerRadius = UDim.new(1, 0)
                    BarCorner.Parent = SliderBar

                    local percent = math.clamp((default - min) / (max - min), 0, 1)

                    local ActiveFill = Instance.new("Frame")
                    ActiveFill.Size = UDim2.new(percent, 0, 1, 0)
                    ActiveFill.BackgroundColor3 = THEME.SliderActiveBar
                    ActiveFill.BorderSizePixel = 0
                    ActiveFill.Parent = SliderBar

                    local FillCorner = Instance.new("UICorner")
                    FillCorner.CornerRadius = UDim.new(1, 0)
                    FillCorner.Parent = ActiveFill

                    local SliderKnob = Instance.new("Frame")
                    SliderKnob.Size = UDim2.new(0, 12, 0, 12)
                    SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
                    SliderKnob.Position = UDim2.new(1, 0, 0.5, 0)
                    SliderKnob.BackgroundColor3 = THEME.SliderKnob
                    SliderKnob.BorderSizePixel = 0
                    SliderKnob.Parent = ActiveFill

                    local KnobCorner = Instance.new("UICorner")
                    KnobCorner.CornerRadius = UDim.new(1, 0)
                    KnobCorner.Parent = SliderKnob

                    local OptionObj = nil
                    if hasOption then
                        local OptionBtn = Instance.new("ImageButton")
                        OptionBtn.Size = UDim2.new(0, 16, 0, 16)
                        OptionBtn.Position = UDim2.new(1, -20, 0.5, -8)
                        OptionBtn.BackgroundTransparency = 1
                        OptionBtn.Image = "http://www.roblox.com/asset/?id=14007344336"
                        OptionBtn.ImageTransparency = 0.5
                        OptionBtn.Parent = Row

                        NeverwinLib:CreateHover(OptionBtn, function(h)
                            NeverwinLib:CreateAnimation(OptionBtn, 0.2, {ImageTransparency = h and 0.1 or 0.5})
                        end)

                        local optionScroll = NeverwinLib:CreateOptionPopup(OptionBtn, MainWindow)
                        OptionObj = {}
                        AttachElements(OptionObj, optionScroll)
                    end

                    local isDragging = false
                    local function UpdateValue(input)
                        if not isEnabled then return end
                        local barWidth = SliderBar.AbsoluteSize.X
                        local mouseOffset = math.clamp(input.Position.X - SliderBar.AbsolutePosition.X, 0, barWidth)
                        local pct = mouseOffset / barWidth
                        local val = math.floor(min + ((max - min) * pct))
                        ActiveFill.Size = UDim2.new(pct, 0, 1, 0)
                        ValueLabel.Text = tostring(val)
                        callback(val)
                    end

                    SliderBar.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 and isEnabled then
                            isDragging = true
                            UpdateValue(input)
                        end
                    end)

                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end
                    end)

                    UserInputService.InputChanged:Connect(function(input)
                        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            UpdateValue(input)
                        end
                    end)

                    local SliderObj = {
                        Option = OptionObj
                    }

                    function SliderObj:Set(newVal)
                        local pct = math.clamp((newVal - min) / (max - min), 0, 1)
                        ActiveFill.Size = UDim2.new(pct, 0, 1, 0)
                        ValueLabel.Text = tostring(newVal)
                        callback(newVal)
                    end

                    function SliderObj:SetEnabled(enabled)
                        isEnabled = enabled
                        local targetTextColor = isEnabled and THEME.FontOn or THEME.FontOff
                        local targetKnobColor = isEnabled and THEME.SliderKnob or THEME.SliderInactiveBar
                        local targetFillColor = isEnabled and THEME.SliderActiveBar or THEME.SliderInactiveBar

                        NeverwinLib:CreateAnimation(Label, 0.18, {TextColor3 = targetTextColor})
                        NeverwinLib:CreateAnimation(ValueLabel, 0.18, {TextColor3 = targetTextColor})
                        NeverwinLib:CreateAnimation(SliderKnob, 0.18, {BackgroundColor3 = targetKnobColor})
                        NeverwinLib:CreateAnimation(ActiveFill, 0.18, {BackgroundColor3 = targetFillColor})
                    end

                    return SliderObj
                end

                builder.AddSlider = CreateSliderComponent
                builder.CreateSlider = CreateSliderComponent

                -- 3. DROPDOWN
                local function CreateDropdownComponent(selfObj, dropData)
                    dropData = GetArgs(selfObj, dropData)
                    local name = dropData.Name or "Dropdown"
                    local values = dropData.Values or {}
                    local default = dropData.Default
                    local isMulti = dropData.Multi or false
                    local hasOption = dropData.Option or false
                    local callback = dropData.Callback or function() end

                    local Row = Instance.new("Frame")
                    Row.Size = UDim2.new(1, 0, 0, 32)
                    Row.BackgroundTransparency = 1
                    Row.Parent = container

                    local Label = Instance.new("TextLabel")
                    Label.Size = UDim2.new(0, 80, 1, 0)
                    Label.Text = name
                    Label.Font = Enum.Font.GothamMedium
                    Label.TextSize = 13
                    Label.TextColor3 = THEME.FontOn
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    Label.BackgroundTransparency = 1
                    Label.Parent = Row

                    local DropBtn = Instance.new("TextButton")
                    DropBtn.Size = UDim2.new(1, hasOption and -116 or -90, 0, 24)
                    DropBtn.Position = UDim2.new(0, 88, 0.5, -12)
                    DropBtn.BackgroundColor3 = THEME.ElementBackground
                    DropBtn.Font = Enum.Font.GothamMedium
                    DropBtn.TextSize = 12
                    DropBtn.TextColor3 = THEME.FontOn
                    DropBtn.TextXAlignment = Enum.TextXAlignment.Left
                    DropBtn.BorderSizePixel = 0
                    DropBtn.Parent = Row

                    local BtnCorner = Instance.new("UICorner")
                    BtnCorner.CornerRadius = UDim.new(0, 4)
                    BtnCorner.Parent = DropBtn

                    local Icon = Instance.new("ImageLabel")
                    Icon.Size = UDim2.new(0, 14, 0, 14)
                    Icon.Position = UDim2.new(1, -18, 0.5, -7)
                    Icon.BackgroundTransparency = 1
                    Icon.Image = "rbxassetid://10709790948"
                    Icon.ImageColor3 = THEME.FontOff
                    Icon.Parent = DropBtn

                    local OptionObj = nil
                    if hasOption then
                        local OptionBtn = Instance.new("ImageButton")
                        OptionBtn.Size = UDim2.new(0, 16, 0, 16)
                        OptionBtn.Position = UDim2.new(1, -20, 0.5, -8)
                        OptionBtn.BackgroundTransparency = 1
                        OptionBtn.Image = "http://www.roblox.com/asset/?id=14007344336"
                        OptionBtn.ImageTransparency = 0.5
                        OptionBtn.Parent = Row

                        local optionScroll = NeverwinLib:CreateOptionPopup(OptionBtn, MainWindow)
                        OptionObj = {}
                        AttachElements(OptionObj, optionScroll)
                    end

                    local res = NeverwinLib:CreateDropdownPopup(DropBtn, values, default, isMulti, callback, MainWindow)
                    res.Option = OptionObj
                    return res
                end

                builder.AddDropdown = CreateDropdownComponent
                builder.CreateDropdown = CreateDropdownComponent

                -- 4. COLOR PICKER
                local function CreateColorPickerComponent(selfObj, pickerData)
                    pickerData = GetArgs(selfObj, pickerData)
                    local name = pickerData.Name or "Color Picker"
                    local default = pickerData.Default or Color3.fromRGB(0, 168, 237)
                    local defaultAlpha = pickerData.Transparency or 0
                    local hasOption = pickerData.Option or false
                    local callback = pickerData.Callback or function() end

                    local Row = Instance.new("Frame")
                    Row.Size = UDim2.new(1, 0, 0, 30)
                    Row.BackgroundTransparency = 1
                    Row.Parent = container

                    local Label = Instance.new("TextLabel")
                    Label.Size = UDim2.new(1, hasOption and -68 or -48, 1, 0)
                    Label.Text = name
                    Label.Font = Enum.Font.GothamMedium
                    Label.TextSize = 13
                    Label.TextColor3 = THEME.FontOn
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    Label.BackgroundTransparency = 1
                    Label.Parent = Row

                    local ColorBox = Instance.new("Frame")
                    ColorBox.Size = UDim2.new(0, 24, 0, 16)
                    ColorBox.Position = UDim2.new(1, hasOption and -54 or -30, 0.5, -8)
                    ColorBox.BackgroundColor3 = default
                    ColorBox.BorderSizePixel = 0
                    ColorBox.Active = true
                    ColorBox.Parent = Row

                    local BoxCorner = Instance.new("UICorner")
                    BoxCorner.CornerRadius = UDim.new(0, 4)
                    BoxCorner.Parent = ColorBox

                    local OptionObj = nil
                    if hasOption then
                        local OptionBtn = Instance.new("ImageButton")
                        OptionBtn.Size = UDim2.new(0, 16, 0, 16)
                        OptionBtn.Position = UDim2.new(1, -20, 0.5, -8)
                        OptionBtn.BackgroundTransparency = 1
                        OptionBtn.Image = "http://www.roblox.com/asset/?id=14007344336"
                        OptionBtn.ImageTransparency = 0.5
                        OptionBtn.Parent = Row

                        local optionScroll = NeverwinLib:CreateOptionPopup(OptionBtn, MainWindow)
                        OptionObj = {}
                        AttachElements(OptionObj, optionScroll)
                    end

                    local res = NeverwinLib:CreateColorPicker(ColorBox, default, defaultAlpha, callback, MainWindow)
                    res.Option = OptionObj
                    return res
                end

                builder.AddColorPicker = CreateColorPickerComponent
                builder.CreateColorPicker = CreateColorPickerComponent

                -- 5. KEYBIND
                local function CreateKeybindComponent(selfObj, keyData)
                    keyData = GetArgs(selfObj, keyData)
                    local name = keyData.Name or "Keybind"
                    local default = keyData.Default or Enum.KeyCode.E
                    local callback = keyData.Callback or function() end

                    local Row = Instance.new("Frame")
                    Row.Size = UDim2.new(1, 0, 0, 30)
                    Row.BackgroundTransparency = 1
                    Row.Parent = container

                    local Label = Instance.new("TextLabel")
                    Label.Size = UDim2.new(1, -80, 1, 0)
                    Label.Text = name
                    Label.Font = Enum.Font.GothamMedium
                    Label.TextSize = 13
                    Label.TextColor3 = THEME.FontOn
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    Label.BackgroundTransparency = 1
                    Label.Parent = Row

                    local KeyBtn = Instance.new("TextButton")
                    KeyBtn.Size = UDim2.new(0, 64, 0, 20)
                    KeyBtn.Position = UDim2.new(1, -64, 0.5, -10)
                    KeyBtn.BackgroundColor3 = THEME.ElementBackground
                    KeyBtn.Text = typeof(default) == "EnumItem" and default.Name or tostring(default)
                    KeyBtn.Font = Enum.Font.GothamMedium
                    KeyBtn.TextSize = 11
                    KeyBtn.TextColor3 = THEME.FontOn
                    KeyBtn.BorderSizePixel = 0
                    KeyBtn.Parent = Row

                    local Corner = Instance.new("UICorner")
                    Corner.CornerRadius = UDim.new(0, 4)
                    Corner.Parent = KeyBtn

                    local isBinding = false
                    KeyBtn.MouseButton1Click:Connect(function()
                        if isBinding then return end
                        isBinding = true
                        KeyBtn.Text = "..."

                        local inputConnection
                        inputConnection = UserInputService.InputBegan:Connect(function(input)
                            local chosen = nil
                            if input.KeyCode ~= Enum.KeyCode.Unknown then
                                chosen = input.KeyCode
                            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                                chosen = "Mouse1"
                            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                                chosen = "Mouse2"
                            end

                            if chosen then
                                isBinding = false
                                inputConnection:Disconnect()
                                KeyBtn.Text = typeof(chosen) == "EnumItem" and chosen.Name or tostring(chosen)
                                callback(chosen)
                            end
                        end)
                    end)

                    return {
                        Set = function(newKey)
                            KeyBtn.Text = typeof(newKey) == "EnumItem" and newKey.Name or tostring(newKey)
                            callback(newKey)
                        end
                    }
                end

                builder.AddKeybind = CreateKeybindComponent
                builder.CreateKeybind = CreateKeybindComponent

                -- 6. BUTTON
                local function CreateButtonComponent(selfObj, btnData)
                    btnData = GetArgs(selfObj, btnData)
                    local name = btnData.Name or "Button"
                    local callback = btnData.Callback or function() end

                    local Btn = Instance.new("TextButton")
                    Btn.Size = UDim2.new(1, 0, 0, 28)
                    Btn.BackgroundColor3 = THEME.ElementBackground
                    Btn.Text = name
                    Btn.Font = Enum.Font.GothamMedium
                    Btn.TextSize = 13
                    Btn.TextColor3 = THEME.FontOn
                    Btn.BorderSizePixel = 0
                    Btn.Parent = container

                    local Corner = Instance.new("UICorner")
                    Corner.CornerRadius = UDim.new(0, 4)
                    Corner.Parent = Btn

                    NeverwinLib:CreateHover(Btn, function(h)
                        NeverwinLib:CreateAnimation(Btn, 0.2, {BackgroundColor3 = h and Color3.fromRGB(28, 28, 32) or THEME.ElementBackground})
                    end)

                    Btn.MouseButton1Click:Connect(callback)
                    return Btn
                end

                builder.AddButton = CreateButtonComponent
                builder.CreateButton = CreateButtonComponent
            end

            AttachElements(CardBuilder, ItemList)
            return CardBuilder
        end

        return TabObj
    end

    return WindowObj
end

return NeverwinLib
