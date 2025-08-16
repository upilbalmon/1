local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ClaimAwardGui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame (centered initially)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 170, 0, 90)
Frame.Position = UDim2.new(0.5, -85, 0.5, -45) -- Centered (0.5, -halfWidth, 0.5, -halfHeight)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = Frame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -25, 0, 20)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "CLAIM AWARD SEASON"
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Frame

-- Close Button (transparent)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Text = "×"
CloseButton.BackgroundTransparency = 1
CloseButton.TextColor3 = Color3.fromRGB(220, 220, 220)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = Frame

-- Input Box
local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0, 50, 0, 25)
TextBox.Position = UDim2.new(0, 10, 0, 30)
TextBox.PlaceholderText = "1-30"
TextBox.Text = "1-30"
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Font = Enum.Font.Gotham
TextBox.TextSize = 13
TextBox.TextXAlignment = Enum.TextXAlignment.Center
TextBox.Parent = Frame

-- Claim Button
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 80, 0, 25)
Button.Position = UDim2.new(0, 70, 0, 30)
Button.Text = "CLAIM"
Button.BackgroundColor3 = Color3.fromRGB(70, 140, 80)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 13
Button.Parent = Frame

-- Status Label
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 16)
Status.Position = UDim2.new(0, 10, 0, 60)
Status.BackgroundTransparency = 1
Status.Text = "Ready"
Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.TextXAlignment = Enum.TextXAlignment.Center
Status.Parent = Frame

-- Add rounded corners
local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 4)
    corner.Parent = parent
end

addCorner(TextBox)
addCorner(Button)

-- Claim function
local function claimAward(boxNumber)
    local args = {
        "ClaimOnceSeasonAward",
        {boxNumber, false}
    }
    local success, result = pcall(function()
        return game:GetService("ReplicatedStorage"):WaitForChild("Msg"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
    end)
    return success and result
end

-- Claim button functionality
Button.MouseButton1Click:Connect(function()
    local input = TextBox.Text:gsub("%s+", "")
    Status.Text = "Processing..."
    
    if input:find("-") then
        local s, e = input:match("(%d+)%-(%d+)")
        s, e = tonumber(s), tonumber(e)
        if s and e and s <= e then
            local claimed = 0
            for i = s, e do
                if claimAward(i) then claimed += 1 end
                Status.Text = "Claiming "..i
                task.wait(0.1)
            end
            Status.Text = "Claimed "..claimed.."/"..(e-s+1)
        else
            Status.Text = "Invalid range"
        end
    else
        local num = tonumber(input)
        if num then
            if claimAward(num) then
                Status.Text = "Claimed "..num
            else
                Status.Text = "Failed!"
            end
        else
            Status.Text = "Invalid input"
        end
    end
end)

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Hover effects
local function addHover(button, normal, hover, isText)
    if isText then
        button.MouseEnter:Connect(function() button.TextColor3 = hover end)
        button.MouseLeave:Connect(function() button.TextColor3 = normal end)
    else
        button.MouseEnter:Connect(function() button.BackgroundColor3 = hover end)
        button.MouseLeave:Connect(function() button.BackgroundColor3 = normal end)
    end
end

addHover(Button, Color3.fromRGB(70, 140, 80), Color3.fromRGB(90, 160, 90))
addHover(CloseButton, Color3.fromRGB(220, 220, 220), Color3.fromRGB(255, 255, 255), true)

-- Input focus effects
TextBox.Focused:Connect(function()
    TextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
end)

TextBox.FocusLost:Connect(function()
    TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
end)

-- Make sure GUI appears on top
ScreenGui.ResetOnSpawn = false
if game:GetService("RunService"):IsStudio() then
    ScreenGui.Enabled = true
end
