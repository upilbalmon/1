-- Letakkan script ini di StarterPlayerScripts sebagai LocalScript
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

-- Event Idled akan terpicu saat Roblox mendeteksi pemain sedang AFK
LocalPlayer.Idled:Connect(function()
    -- Mengambil kontrol dan mensimulasikan klik, seolah-olah ada input dari pemain
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    print("Anti-AFK triggered at " .. os.date("%X"))
end)
