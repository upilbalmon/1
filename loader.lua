local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuration
local toolbarHeight = 36
local buttonWidth = 100
local buttonHeight = 28
local buttonSpacing = 5
local buttonNames = {"Farming", "Gacha", "bekal", "gunung", "fuse", "Season 3", "teleaim", "lokasi"}

local scriptURLs = {
    "https://raw.githubusercontent.com/upilbalmon/goblox/refs/heads/main/AUTO%20COIN%20V3.lua",
    "https://raw.githubusercontent.com/upilbalmon/goblox/refs/heads/main/autohatchx10.lua",
    "https://raw.githubusercontent.com/upilbalmon/1/refs/heads/main/perbekalan.lua",
    "https://raw.githubusercontent.com/upilbalmon/Gunung/refs/heads/main/pengendalitanah.lua",
    "https://raw.githubusercontent.com/upilbalmon/1/refs/heads/main/Fusion.lua",
    "https://raw.githubusercontent.com/upilbalmon/1/refs/heads/main/ClaimRewardSeason.lua",
    "https://raw.githubusercontent.com/upilbalmon/1/refs/heads/main/aimteleport.lua",
    "https://raw.githubusercontent.com/upilbalmon/Gunung/refs/heads/main/koordinatsaver.lua",
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
toolbar.Size = UDim2.new(1, 0, 0, toolbarHeight)
toolbar.Position = UDim2.new(0, 0, 1, -toolbarHeight)
toolbar.BackgroundColor3 = theme.background
toolbar.BackgroundTransparency = 0.2
toolbar.BorderSizePixel = 0
toolbar.Parent = screenGui

-- Add top border accent
local topAccent = Instance.new("Frame")
topAccent.Size = UDim2.new(1, 0, 0, 2)
topAccent.Position = UDim2.new(0, 0, 0, 0)
topAccent.BackgroundColor3 = theme.accentColor
topAccent.BorderSizePixel = 0
topAccent.Parent = toolbar

-- Button container for proper centering
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -60, 1, 0)
buttonContainer.Position = UDim2.new(0, 0, 0, 0)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = toolbar

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.Padding = UDim.new(0, buttonSpacing)
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = buttonContainer

-- Function to create smooth border blink effect
local function borderBlink(stroke)
    local tweenService = game:GetService("TweenService")
    
    -- Blink on (fade in)
    local fadeIn = tweenService:Create(
        stroke,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Transparency = 0, Thickness = 2}
    )
    
    -- Blink off (fade out)
    local fadeOut = tweenService:Create(
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
    btn.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
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
        game:GetService("TweenService"):Create(
            btn,
            TweenInfo.new(0.2),
            {BackgroundColor3 = theme.buttonHover}
        ):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            btn,
            TweenInfo.new(0.2),
            {BackgroundColor3 = theme.buttonNormal}
        ):Play()
    end)
    
    btn.MouseButton1Down:Connect(function()
        game:GetService("TweenService"):Create(
            btn,
            TweenInfo.new(0.1),
            {BackgroundColor3 = theme.buttonActive, Size = UDim2.new(0, buttonWidth-4, 0, buttonHeight-4)}
        ):Play()
    end)
    
    btn.MouseButton1Up:Connect(function()
        game:GetService("TweenService"):Create(
            btn,
            TweenInfo.new(0.1),
            {BackgroundColor3 = theme.buttonHover, Size = UDim2.new(0, buttonWidth, 0, buttonHeight)}
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
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -32, 0.5, -14)
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
    game:GetService("TweenService"):Create(
        closeBtn,
        TweenInfo.new(0.2),
        {BackgroundColor3 = theme.closeButtonHover, Rotation = 90}
    ):Play()
end)

closeBtn.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(
        closeBtn,
        TweenInfo.new(0.2),
        {BackgroundColor3 = theme.closeButton, Rotation = 0}
    ):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
    game:GetService("TweenService"):Create(
        toolbar,
        TweenInfo.new(0.3),
        {Position = UDim2.new(0, 0, 1, 10)}
    ):Play()
    task.delay(0.3, function()
        screenGui:Destroy()
    end)
end)

-- Make toolbar draggable
local dragInput, dragStart, startPos

toolbar.InputBegan:Connect(function(input)
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

toolbar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragStart then
        local delta = input.Position - dragStart
        toolbar.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Initial animation
toolbar.Position = UDim2.new(0, 0, 1, 10)
game:GetService("TweenService"):Create(
    toolbar,
    TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Position = UDim2.new(0, 0, 1, -toolbarHeight)}
):Play()
