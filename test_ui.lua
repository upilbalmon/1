-- 1. Load Wind UI Library dengan error handling
local WindUI
local success, result = pcall(function()
    WindUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/main_example.lua'))()
end)

if not success or not WindUI then
    warn("Gagal load WindUI, menggunakan UI default")
    -- Bisa tambahkan fallback UI sederhana di sini
    return
end

-- 2. Buat Window Utama
local Window = WindUI:CreateWindow({
    Title = "Speed Control Hub",
    Icon = "zap",
    Author = "Developer",
    Folder = "WindUIConfig",
    Size = UDim2.fromOffset(500, 350),
    Transparent = true,
    Theme = "Dark",
})

-- 3. Buat Tab Utama
local MainTab = Window:Tab({
    Title = "Player Settings",
    Icon = "user",
})

-- 4. Buat Section Speed
local SpeedSection = MainTab:Section({
    Title = "Movement Settings",
})

-- Variabel Global
local NormalSpeed = 16
local MaxSpeed = 100
local player = game.Players.LocalPlayer
local currentMultiplier = 2
local isSpeedActive = false

-- Fungsi untuk mendapatkan Humanoid dengan aman
local function getHumanoid()
    local character = player.Character
    if not character then
        character = player.CharacterAdded:Wait()
    end
    return character:FindFirstChildOfClass("Humanoid")
end

-- Fungsi update speed
local function updateSpeed()
    local humanoid = getHumanoid()
    if not humanoid then return end
    
    if isSpeedActive then
        humanoid.WalkSpeed = NormalSpeed * currentMultiplier
    else
        humanoid.WalkSpeed = NormalSpeed
    end
end

-- Handle respawn karakter
player.CharacterAdded:Connect(function(character)
    task.wait(0.5) -- Tunggu humanoid muncul
    updateSpeed()
end)

-- 5. Toggle Speed
SpeedSection:Toggle({
    Title = "Speed " .. currentMultiplier .. "x",
    Desc = "Aktifkan untuk melipatgandakan kecepatan (Current: " .. NormalSpeed * currentMultiplier .. " WalkSpeed)",
    Value = false,
    Callback = function(State)
        isSpeedActive = State
        updateSpeed()
    end,
})

-- 6. Slider untuk mengatur Multiplier (Fitur Tambahan)
SpeedSection:Slider({
    Title = "Multiplier Speed",
    Desc = "Atur kelipatan kecepatan (1x - 5x)",
    Value = currentMultiplier,
    Min = 1,
    Max = 5,
    Step = 0.5,
    Callback = function(Value)
        currentMultiplier = Value
        -- Update title toggle
        -- Note: Di WindUI, update title agak tricky, better recreate or use variable
        if isSpeedActive then
            updateSpeed()
        end
    end,
})

-- 7. Tombol Reset Speed
SpeedSection:Button({
    Title = "Reset Speed",
    Desc = "Kembalikan kecepatan ke normal (16)",
    Callback = function()
        isSpeedActive = false
        currentMultiplier = 2
        updateSpeed()
        WindUI:Notify({
            Title = "Speed Reset",
            Content = "Kecepatan dikembalikan ke normal!",
            Duration = 2,
        })
    end,
})

-- 8. Section Tambahan: Info Player
local InfoSection = MainTab:Section({
    Title = "Player Info",
})

-- Label untuk menampilkan speed saat ini
local speedLabel = InfoSection:Label({
    Title = "Current Speed: " .. NormalSpeed,
})

-- Update label setiap detik (opsional)
game:GetService("RunService").Heartbeat:Connect(function()
    local humanoid = getHumanoid()
    if humanoid then
        speedLabel:Set("Current Speed: " .. math.round(humanoid.WalkSpeed * 10) / 10)
    end
end)

-- 9. Notifikasi
WindUI:Notify({
    Title = "Wind UI Active",
    Content = "Speed Control Hub siap digunakan!",
    Duration = 3,
})
