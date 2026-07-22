-- 1. Load Wind UI Library
local WindUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/main_example.lua'))()

-- 2. Buat Window Utama
local Window = WindUI:CreateWindow({
    Title = "Speed Control Hub",
    Icon = "zap", -- Ikon dari Lucide Icons
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

-- 4. Buat Section
local SpeedSection = MainTab:Section({
    Title = "Movement",
})

-- Local Variables untuk menyimpan status kecepatan
local NormalSpeed = 16
local Multiplier = 2 -- Speeed 2x
local BoostedSpeed = NormalSpeed * Multiplier

-- 5. Tambahkan Tombol ON / OFF (Toggle) untuk Speed
SpeedSection:Toggle({
    Title = "Speed 2x",
    Desc = "Aktifkan untuk melipatgandakan kecepatan lari (32 WalkSpeed)",
    Value = false, -- Status awal: OFF
    Callback = function(State)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            if State then
                -- Jika ON: Ubah speed menjadi 2x (32)
                humanoid.WalkSpeed = BoostedSpeed
            else
                -- Jika OFF: Kembalikan speed ke Normal (16)
                humanoid.WalkSpeed = NormalSpeed
            end
        end
    end,
})

-- Notifikasi bahwa UI berhasil dimuat
WindUI:Notify({
    Title = "Wind UI Active",
    Content = "Menu Speed 2x siap digunakan!",
    Duration = 3,
})
