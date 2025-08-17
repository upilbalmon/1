--==[ Claim Season Award GUI (dengan Premium Checklist) ]==--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer

-- Root GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ClaimAwardGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Main Frame (centered)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 170, 0, 110) -- dinaikkan agar muat checkbox
Frame.Position = UDim2.new(0.5, -85, 0.5, -55)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = Frame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -25, 0, 20)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "CLAIM SEASON AWD"
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Frame

-- Close Button
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

-- ===== Premium Checklist =====
local PremiumChecked = false

-- Container agar gampang di-klik
local PremiumContainer = Instance.new("TextButton")
PremiumContainer.BackgroundTransparency = 1
PremiumContainer.BorderSizePixel = 0
PremiumContainer.Size = UDim2.new(1, -20, 0, 20)
PremiumContainer.Position = UDim2.new(0, 10, 0, 60)
PremiumContainer.Text = ""
PremiumContainer.AutoButtonColor = false
PremiumContainer.Parent = Frame

-- Kotak cek
local CheckBox = Instance.new("Frame")
CheckBox.Size = UDim2.new(0, 16, 0, 16)
CheckBox.Position = UDim2.new(0, 0, 0, 2)
CheckBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
CheckBox.BorderSizePixel = 0
CheckBox.Parent = PremiumContainer
local cbCorner = Instance.new("UICorner")
cbCorner.CornerRadius = UDim.new(0, 4)
cbCorner.Parent = CheckBox

-- Tanda centang
local CheckMark = Instance.new("TextLabel")
CheckMark.Size = UDim2.new(1, 0, 1, 0)
CheckMark.BackgroundTransparency = 1
CheckMark.Text = "✓"
CheckMark.Visible = false
CheckMark.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckMark.Font = Enum.Font.GothamBold
CheckMark.TextSize = 14
CheckMark.TextXAlignment = Enum.TextXAlignment.Center
CheckMark.TextYAlignment = Enum.TextYAlignment.Center
CheckMark.Parent = CheckBox

-- Label "Premium"
local PremiumLabel = Instance.new("TextLabel")
PremiumLabel.BackgroundTransparency = 1
PremiumLabel.Position = UDim2.new(0, 22, 0, 0)
PremiumLabel.Size = UDim2.new(1, -22, 1, 0)
PremiumLabel.Text = "Premium"
PremiumLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
PremiumLabel.Font = Enum.Font.Gotham
PremiumLabel.TextSize = 12
PremiumLabel.TextXAlignment = Enum.TextXAlignment.Left
PremiumLabel.Parent = PremiumContainer

-- Status Label
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 16)
Status.Position = UDim2.new(0, 10, 0, 85) -- turun karena ada checkbox
Status.BackgroundTransparency = 1
Status.Text = "Ready"
Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.TextXAlignment = Enum.TextXAlignment.Center
Status.Parent = Frame

-- Helpers
local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 4)
    corner.Parent = parent
end

addCorner(TextBox)
addCorner(Button)

-- Toggle Premium
local function setPremium(state: boolean)
    PremiumChecked = state
    CheckMark.Visible = state
    CheckBox.BackgroundColor3 = state and Color3.fromRGB(70, 140, 80) or Color3.fromRGB(50, 50, 55)
end

PremiumContainer.MouseButton1Click:Connect(function()
    setPremium(not PremiumChecked)
end)

-- Remote call helper
local function claimAward(boxNumber: number, isPremium: boolean)
    local args = {
        "ClaimOnceSeasonAward",
        {boxNumber, isPremium}
    }
    local success, result = pcall(function()
        return ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
    end)
    return success and result
end

-- Claim button functionality
Button.MouseButton1Click:Connect(function()
    local input = TextBox.Text:gsub("%s+", "")
    Status.Text = "Processing..."
    local isPremium = PremiumChecked

    if input:find("-") then
        local s, e = input:match("(%d+)%-(%d+)")
        s, e = tonumber(s), tonumber(e)
        if s and e and s <= e then
            local claimed = 0
            for i = s, e do
                if claimAward(i, isPremium) then claimed += 1 end
                Status.Text = string.format("Claiming %d%s", i, isPremium and " (Premium)" or "")
                task.wait(0.1)
            end
            Status.Text = string.format("Claimed %d/%d%s", claimed, (e - s + 1), isPremium and " [Premium]" or "")
        else
            Status.Text = "Invalid range"
        end
    else
        local num = tonumber(input)
        if num then
            if claimAward(num, isPremium) then
                Status.Text = string.format("Claimed %d%s", num, isPremium and " [Premium]" or "")
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

-- Studio helper
if RunService:IsStudio() then
    ScreenGui.Enabled = true -- true jika premium dicentang (UI tetap tampil di Studio)
end
