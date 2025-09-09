--[[
   Nama Skrip: CleanToolbarUI.lua
   Deskripsi: Membuat toolbar GUI yang bisa digeser dan berisi tombol-tombol.
   PENTING: Letakkan skrip ini di dalam 'StarterPlayer.StarterCharacterScripts'
   atau 'StarterPlayer.StarterPlayerScripts'. Ini HARUS berupa LocalScript.
--]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

-- Configuration
local toolbarSize = UDim2.new(0, 320, 0, 260)
local buttonSize = UDim2.new(0, 60, 0, 30)
local buttonPadding = UDim.new(0, 5)
local buttonNames = {"CAJ1", "CAJ2", "CP", "GUNUNG", "BM", "TELE", "SPEED", "LOC", "SIZE", "Weater",}

local scriptURLs = {
    "https://raw.githubusercontent.com/upilbalmon/goblox/refs/heads/main/AUTO%20COIN%20V3.lua",
    "https://raw.githubusercontent.com/upilbalmon/goblox/refs/heads/main/autohatchx10.lua",
    "https://raw.githubusercontent.com/upilbalmon/1/refs/heads/main/perbekalan.lua",
    "https://raw.githubusercontent.com/upilbalmon/Gunung/refs/heads/main/UiGunung.lua",
    "https://raw.githubusercontent.com/upilbalmon/Gunung/refs/heads/main/koordinatsaver.lua",
    "https://raw.githubusercontent.com/upilbalmon/goblox/refs/heads/main/tele.lua",
    "https://raw.githubusercontent.com/upilbalmon/Gunung/refs/heads/main/speed.lua",
    "https://raw.githubusercontent.com/upilbalmon/Gunung/refs/heads/main/koordinatsaver.lua",
    "https://raw.githubusercontent.com/upilbalmon/Gunung/refs/heads/main/size.lua",
    "https://raw.githubusercontent.com/upilbalmon/Gunung/refs/heads/main/weaterControll.lua",
}

-- Color theme
local theme = {
    background = Color3.fromRGB(30, 30, 40),
    buttonNormal = Color3.fromRGB(60, 60, 80),
    buttonHover = Color3.fromRGB(80, 80, 100),
    buttonActive = Color3.fromRGB(100, 150, 255),
    textColor = Color3.fromRGB(255, 255, 255),
    closeButton = Color3.fromRGB(255, 80, 80),
    closeButtonHover = Color3.fromRGB(255, 120, 120),
    accentColor = Color3.fromRGB(100, 150, 255)
}

-- Create UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CleanToolbarUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local toolbar = Instance.new("Frame")
toolbar.Size = toolbarSize
-- New: Position in the center of the screen
toolbar.Position = UDim2.new(0.5, -toolbarSize.X.Offset/2, 0.5, -toolbarSize.Y.Offset/2)
toolbar.BackgroundColor3 = theme.background
toolbar.BackgroundTransparency = 0.2
toolbar.BorderSizePixel = 0
toolbar.Parent = screenGui

-- Draggable handle
local dragHandle = Instance.new("Frame")
dragHandle.Name = "DragHandle"
dragHandle.Size = UDim2.new(1, 0, 0, 5)
dragHandle.BackgroundTransparency = 1
dragHandle.Parent = toolbar

-- Button container
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, 0, 1, 0)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = toolbar

-- Change to UIGridLayout for wrapping buttons
local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.CellSize = buttonSize
UIGridLayout.CellPadding = buttonPadding
UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIGridLayout.Parent = buttonContainer

-- Create mini button (will be hidden initially)
local miniButton = Instance.new("TextButton")
miniButton.Size = UDim2.new(0, 40, 0, 40)
miniButton.Position = UDim2.new(1, -45, 1, -45)
miniButton.BackgroundColor3 = theme.accentColor
miniButton.Text = "+"
miniButton.TextColor3 = theme.textColor
miniButton.TextSize = 24
miniButton.Font = Enum.Font.GothamBold
miniButton.AutoButtonColor = false
miniButton.Visible = false
miniButton.Parent = screenGui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 20)
miniCorner.Parent = miniButton

-- Function to create smooth border blink effect
local function borderBlink(stroke)
    -- Blink on (fade in)
    local fadeIn = TweenService:Create(
        stroke,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Transparency = 0, Thickness = 2}
    )

    -- Blink off (fade out)
    local fadeOut = TweenService:Create(
        stroke,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Transparency = 0.7, Thickness = 1}
    )

    fadeIn:Play()
    fadeIn.Completed:Connect(function()
        fadeOut:Play()
    end)
end

-- Function to create buttons with effects
local function createButton(name, index)
    local btn = Instance.new("TextButton")
    btn.Size = buttonSize
    btn.BackgroundColor3 = theme.buttonNormal
    btn.Text = name
    btn.TextColor3 = theme.textColor
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.Parent = buttonContainer

    -- Button styling
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = theme.accentColor
    stroke.Transparency = 0.7
    stroke.Thickness = 1
    stroke.Parent = btn

    -- Button effects
    btn.MouseEnter:Connect(function()
        TweenService:Create(
            btn,
            TweenInfo.new(0.2),
            {BackgroundColor3 = theme.buttonHover}
        ):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(
            btn,
            TweenInfo.new(0.2),
            {BackgroundColor3 = theme.buttonNormal}
        ):Play()
    end)

    btn.MouseButton1Down:Connect(function()
        TweenService:Create(
            btn,
            TweenInfo.new(0.1),
            {BackgroundColor3 = theme.buttonActive}
        ):Play()
    end)

    btn.MouseButton1Up:Connect(function()
        TweenService:Create(
            btn,
            TweenInfo.new(0.1),
            {BackgroundColor3 = theme.buttonHover}
        ):Play()
    end)

    -- Button functionality with clean border blink only
    btn.MouseButton1Click:Connect(function()
        -- Trigger border blink effect
        borderBlink(stroke)

        -- Execute script silently
        pcall(function()
            if scriptURLs[index] then
                loadstring(game:HttpGet(scriptURLs[index]))()
            end
        end)
    end)

    return btn
end

-- Create all buttons
for i, name in ipairs(buttonNames) do
    createButton(name, i)
end

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -25, 0, 5)
closeBtn.BackgroundColor3 = theme.closeButton
closeBtn.Text = "×"
closeBtn.TextColor3 = theme.textColor
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.AutoButtonColor = false
closeBtn.Parent = toolbar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

-- Close button effects
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(
        closeBtn,
        TweenInfo.new(0.2),
        {BackgroundColor3 = theme.closeButtonHover, Rotation = 90}
    ):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TweenService:Create(
        closeBtn,
        TweenInfo.new(0.2),
        {BackgroundColor3 = theme.closeButton, Rotation = 0}
    ):Play()
end)

-- Function to minimize toolbar
local function minimizeToolbar()
    TweenService:Create(
        toolbar,
        TweenInfo.new(0.3),
        {Position = UDim2.new(toolbar.Position.X.Scale, toolbar.Position.X.Offset, 1, 10)}
    ):Play()
    task.delay(0.3, function()
        toolbar.Visible = false
        miniButton.Visible = true
    end)
end

-- Function to restore toolbar
local function restoreToolbar()
    miniButton.Visible = false
    toolbar.Visible = true
    TweenService:Create(
        toolbar,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(toolbar.Position.X.Scale, toolbar.Position.X.Offset, toolbar.Position.Y.Scale, toolbar.Position.Y.Offset)}
    ):Play()
end

-- Close button click - now minimizes instead of destroying
closeBtn.MouseButton1Click:Connect(minimizeToolbar)

-- Mini button effects
miniButton.MouseEnter:Connect(function()
    TweenService:Create(
        miniButton,
        TweenInfo.new(0.2),
        {BackgroundColor3 = theme.buttonHover, Size = UDim2.new(0, 44, 0, 44)}
    ):Play()
end)

miniButton.MouseLeave:Connect(function()
    TweenService:Create(
        miniButton,
        TweenInfo.new(0.2),
        {BackgroundColor3 = theme.accentColor, Size = UDim2.new(0, 40, 0, 40)}
    ):Play()
end)

miniButton.MouseButton1Click:Connect(restoreToolbar)

-- Make toolbar draggable via the new DragHandle
local dragInput, dragStart, startPos

dragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = input.Position
        startPos = toolbar.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragStart = nil
            end
        end)
    end
end)

dragHandle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragStart then
        local delta = input.Position - dragStart
        toolbar.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Initial animation
toolbar.Position = UDim2.new(toolbar.Position.X.Scale, toolbar.Position.X.Offset, -toolbarSize.Y.Offset, -toolbarSize.Y.Offset)
TweenService:Create(
    toolbar,
    TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Position = UDim2.new(0.5, -toolbarSize.X.Offset/2, 0.5, -toolbarSize.Y.Offset/2)}
):Play()
