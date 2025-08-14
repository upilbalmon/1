local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

-- Cek FusePet
local fusePet = pg:FindFirstChild("ScreenGui", true) and pg.ScreenGui:FindFirstChild("FusePet")
if fusePet then
    -- Tampilkan semua frame & elemen di dalam FusePet
    local function showAll(obj)
        if obj:IsA("GuiObject") then
            obj.Visible = true
        end
        for _, child in ipairs(obj:GetChildren()) do
            showAll(child)
        end
    end

    fusePet.Visible = true
    showAll(fusePet)
    warn("[FusePet] Menu Fuse Pet sudah dibuka!")
else
    warn("[FusePet] Tidak menemukan GUI FusePet di PlayerGui.")
end
