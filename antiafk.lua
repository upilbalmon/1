-- Script Status GUI untuk Anti-AFK (160x60 - Timer Font 16)
-- Letakkan di StarterPlayerScripts sebagai LocalScript

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Hapus GUI lama jika ada
if playerGui:FindFirstChild("AntiAFKStatus") then
    playerGui:FindFirstChild("AntiAFKStatus"):Destroy()
end

-- Buat ScreenGui
local MainFrame = Instance.new("ScreenGui")
MainFrame.Name = "AntiAFKStatus"
MainFrame.Parent = playerGui
MainFrame.ResetOnSpawn = false
MainFrame.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame Utama (160x60)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 160, 0, 60)
Frame.Position = UDim2.new(0.5, -80, 0.5, -30)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Frame.BackgroundTransparency = 0
Frame.BorderSizePixel = 0
Frame.Parent = MainFrame
Frame.Draggable = true
Frame.Active = true
Frame.ClipsDescendants = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

-- Title Bar (tinggi 20)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 20)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
TitleBar.BackgroundTransparency = 0
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8, 0, 0)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -40, 1, 0)
TitleText.Position = UDim2.new(0, 8, 0, 0)
TitleText.Text = "⚡"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.BackgroundTransparency = 1
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 10
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Close Button (16x16)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 16, 0, 16)
CloseButton.Position = UDim2.new(1, -20, 0.5, -8)
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 8
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.AutoButtonColor = false
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    MainFrame:Destroy()
end)

-- Reset Button (16x16)
local ResetButton = Instance.new("TextButton")
ResetButton.Size = UDim2.new(0, 16, 0, 16)
ResetButton.Position = UDim2.new(1, -40, 0.5, -8)
ResetButton.Text = "↺"
ResetButton.Font = Enum.Font.GothamBold
ResetButton.TextSize = 10
ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
ResetButton.AutoButtonColor = false
ResetButton.Parent = TitleBar

local ResetCorner = Instance.new("UICorner")
ResetCorner.CornerRadius = UDim.new(0, 4)
ResetCorner.Parent = ResetButton

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -12, 1, -28)
Content.Position = UDim2.new(0, 6, 0, 24)
Content.BackgroundTransparency = 1
Content.Parent = Frame

-- Status Label (LED) - kiri
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.2, 0, 1, 0)
StatusLabel.Position = UDim2.new(0, 0, 0, 0)
StatusLabel.Text = "🟢"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 10
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.Parent = Content

-- Stopwatch Label - tengah (FONT 16)
local StopwatchLabel = Instance.new("TextLabel")
StopwatchLabel.Size = UDim2.new(0.7, 0, 1, 0)
StopwatchLabel.Position = UDim2.new(0.2, 0, 0, 0)
StopwatchLabel.Text = "00:00"
StopwatchLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StopwatchLabel.BackgroundTransparency = 1
StopwatchLabel.Font = Enum.Font.GothamBold
StopwatchLabel.TextSize = 16  -- FONT KHUSUS TIMER
StopwatchLabel.TextXAlignment = Enum.TextXAlignment.Center
StopwatchLabel.Parent = Content

-- Info Label - kanan bawah (kecil)
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(0.2, 0, 1, 0)
InfoLabel.Position = UDim2.new(0.8, 0, 0, 0)
InfoLabel.Text = "last"
InfoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Font = Enum.Font.GothamMedium
InfoLabel.TextSize = 8
InfoLabel.TextXAlignment = Enum.TextXAlignment.Center
InfoLabel.Parent = Content

-- Variabel stopwatch
local lastTriggerTime = tick()
local stopwatchRunning = true

-- Fungsi format waktu (MM:SS)
local function FormatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%02d:%02d", minutes, secs)
end

-- Update stopwatch setiap 0.1 detik
task.spawn(function()
    while MainFrame and MainFrame.Parent do
        if stopwatchRunning then
            local elapsed = tick() - lastTriggerTime
            StopwatchLabel.Text = FormatTime(elapsed)
        end
        task.wait(0.1)
    end
end)

-- Reset Button function
ResetButton.MouseButton1Click:Connect(function()
    lastTriggerTime = tick()
    StopwatchLabel.Text = "00:00"
    StatusLabel.Text = "🔄"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    task.delay(0.5, function()
        StatusLabel.Text = "🟢"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    end)
    print("⏱ Stopwatch reset!")
end)

-- Event ketika Anti-AFK dipicu
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    
    lastTriggerTime = tick()
    stopwatchRunning = true
    
    StatusLabel.Text = "🟡"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    StopwatchLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    
    task.delay(0.8, function()
        StatusLabel.Text = "🟢"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        StopwatchLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    print("Anti-AFK triggered at " .. os.date("%X"))
end)

print("✅ Anti-AFK Status GUI (160x60 - Timer Font 16) Loaded!")
