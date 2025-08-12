local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local toolbarHeight = 30
local buttonWidth = 100
local buttonHeight = 25
local buttonNames = {"Farming","Gacha","Ngumpet","Teleport","Tombol 5","Tombol 6","Tombol 7","Tombol 8"}

local scriptURLs = {
    "https://raw.githubusercontent.com/upilbalmon/goblox/refs/heads/main/AUTO%20COIN%20V3.lua",
    "https://raw.githubusercontent.com/upilbalmon/goblox/refs/heads/main/autohatchx10.lua",
    "https://raw.githubusercontent.com/upilbalmon/goblox/refs/heads/main/hiddenplace.lua",
    "https://raw.githubusercontent.com/upilbalmon/goblox/refs/heads/main/tele.lua",
    "https://url-script-5.lua",
    "https://url-script-6.lua",
    "https://url-script-7.lua",
    "https://url-script-8.lua",
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToolbarUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local toolbar = Instance.new("Frame")
toolbar.Size = UDim2.new(1, 0, 0, toolbarHeight)
toolbar.Position = UDim2.new(0, 0, 1, -toolbarHeight)
toolbar.BackgroundColor3 = Color3.new(0,0,0)
toolbar.BackgroundTransparency = 0.4
toolbar.BorderSizePixel = 0
toolbar.Parent = screenGui

for i, name in ipairs(buttonNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
    btn.Position = UDim2.new(0, (i - 1) * (buttonWidth + 5), 0.5, -buttonHeight/2)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = toolbar

    btn.MouseButton1Click:Connect(function()
        local originalColor = btn.TextColor3
        btn.TextColor3 = Color3.new(1,1,0) -- kuning menyala
        local success, err = pcall(function()
            local source = game:HttpGet(scriptURLs[i])
            loadstring(source)()
        end)
        if not success then
            warn("Error menjalankan script tombol "..i..": "..err)
        end
        task.delay(0.3, function()
            btn.TextColor3 = originalColor
        end)
    end)
end

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.new(1,0,0)
closeBtn.BackgroundTransparency = 0.2
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = toolbar
closeBtn.MouseButton1Click:Connect(function()
    toolbar:Destroy()
end)
