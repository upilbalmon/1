--// LocalScript: Multi-Tab GUI + Settings Toggle External UI (hide/show)
-- Desain sesuai spesifikasi Cherry: close/minimize, draggable, top layer, transparansi, tombol biru, dsb.

--== Services ==
local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player  = Players.LocalPlayer
local pg      = player:WaitForChild("PlayerGui")

--== Bootstrap & Top Layer ==
local GUI_NAME = "MultiTabGUI"
local ScreenGui = pg:FindFirstChild(GUI_NAME)
if not ScreenGui then
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = GUI_NAME
    ScreenGui.Parent = pg
end
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.DisplayOrder   = 9999 -- top layer

if ScreenGui:GetAttribute("Initialized") then return end
ScreenGui:SetAttribute("Initialized", true)

--== Root Frame ==
local Frame = Instance.new("Frame")
Frame.Name = "Root"
Frame.Size = UDim2.fromOffset(480, 340)
Frame.Position = UDim2.new(0.5, -240, 0.5, -170)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BackgroundTransparency = 0.4 -- sesuai request
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

--== Title Bar ==
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = Frame
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BackgroundTransparency = 0.2 -- sesuai request
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(12, 0)
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "Multi-Tab Panel"
Title.TextColor3 = Color3.fromRGB(255,255,255)

--== Window Buttons ==
local function MakeTopBtn(txt, color, transparency, xRight)
    local b = Instance.new("TextButton")
    b.AutoButtonColor = true
    b.Parent = TitleBar
    b.Size = UDim2.fromOffset(26, 26)
    b.Position = UDim2.new(1, -xRight, 0.5, -13)
    b.BackgroundColor3 = color
    b.BackgroundTransparency = transparency or 0
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local BtnClose = MakeTopBtn("×", Color3.fromRGB(220,0,0), 0, 8)     -- close merah
local BtnMini  = MakeTopBtn("–", Color3.fromRGB(0,180,0), 0.5, 40) -- minimize hijau transparan 0.5

--== Minimized Dock Icon ==
local Dock = Instance.new("TextButton")
Dock.Name = "DockIcon"
Dock.Parent = ScreenGui
Dock.Size = UDim2.fromOffset(34, 34)
Dock.Position = UDim2.new(1, -44, 1, -44)
Dock.BackgroundColor3 = Color3.fromRGB(0,180,0)
Dock.BackgroundTransparency = 0.5
Dock.Text = "◙"
Dock.Font = Enum.Font.GothamBold
Dock.TextSize = 16
Dock.TextColor3 = Color3.fromRGB(255,255,255)
Dock.Visible = false
Dock.BorderSizePixel = 0
Instance.new("UICorner", Dock).CornerRadius = UDim.new(1, 0)

BtnClose.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
BtnMini.MouseButton1Click:Connect(function()
    Frame.Visible = false
    Dock.Visible = true
end)
Dock.MouseButton1Click:Connect(function()
    Frame.Visible = true
    Dock.Visible = false
end)

--== Dragging ==
do
    local dragging = false
    local dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

--== Tab Bar ==
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Parent = Frame
TabBar.Position = UDim2.fromOffset(10, 46)
TabBar.Size = UDim2.new(1, -20, 0, 32)
TabBar.BackgroundColor3 = Color3.fromRGB(35,35,45)
TabBar.BackgroundTransparency = 0.2
TabBar.BorderSizePixel = 0
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabBar
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 8)
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

--== Content Area ==
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Parent = Frame
Content.Position = UDim2.fromOffset(10, 86)
Content.Size = UDim2.new(1, -20, 1, -96)
Content.BackgroundTransparency = 1

--== Utils ==
local function MakeTextBox(parent, placeholder)
    local tb = Instance.new("TextBox")
    tb.Parent = parent
    tb.Size = UDim2.new(0, 260, 0, 32)
    tb.PlaceholderText = placeholder or "..."
    tb.Font = Enum.Font.Gotham
    tb.TextSize = 14
    tb.TextColor3 = Color3.fromRGB(255,255,255)
    tb.BackgroundColor3 = Color3.fromRGB(50,50,60)
    tb.BackgroundTransparency = 0.2 -- textbox transparansi 0.2
    tb.ClearTextOnFocus = false
    tb.BorderSizePixel = 0
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
    return tb
end

local function MakeBlueBtn(parent, text)
    local b = Instance.new("TextButton")
    b.Parent = parent
    b.Size = UDim2.fromOffset(130, 34)
    b.Text = text or "Button"
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.BackgroundColor3 = Color3.fromRGB(0,120,255) -- tombol biru
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

--== Tab System ==
local Tabs = {}
local ActiveTab = nil

local function SetActiveTab(name)
    for tabName, data in pairs(Tabs) do
        local on = (tabName == name)
        data.Content.Visible = on
        data.Button.BackgroundColor3 = on and Color3.fromRGB(0,140,255) or Color3.fromRGB(0,120,255)
        data.Button.AutoButtonColor = true
    end
    ActiveTab = name
end

local function AddTab(name)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "_TabButton"
    btn.Parent = TabBar
    btn.AutoButtonColor = true
    btn.Size = UDim2.fromOffset(120, 28)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(0,120,255)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local pane = Instance.new("Frame")
    pane.Name = name .. "_Content"
    pane.Parent = Content
    pane.Size = UDim2.fromScale(1,1)
    pane.BackgroundTransparency = 1
    pane.Visible = false

    Tabs[name] = { Button = btn, Content = pane }
    btn.MouseButton1Click:Connect(function() SetActiveTab(name) end)
    if not ActiveTab then SetActiveTab(name) end
    return pane
end

--== Create Tabs ==
local TabTeleport = AddTab("Teleport")
local TabBookmark = AddTab("Bookmark")
local TabSettings = AddTab("Settings")

-- (Placeholder isi Teleport/Bookmark, biar kerangka konsisten)
do
    local info = Instance.new("TextLabel")
    info.Parent = TabTeleport
    info.BackgroundTransparency = 1
    info.Position = UDim2.new(0, 8, 0, 8)
    info.Size = UDim2.new(1, -16, 0, 24)
    info.Font = Enum.Font.Gotham
    info.TextSize = 14
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextColor3 = Color3.fromRGB(220,220,220)
    info.Text = "<Teleport> — isi komponenmu di sini."

    local infoB = info:Clone()
    infoB.Parent = TabBookmark
    infoB.Text = "<Bookmark> — isi komponenmu di sini."
end

--== SETTINGS: Toggle External UI (Load ON / Hide OFF) ==
local URLS = {
    "https://raw.githubusercontent.com/upilbalmon/Gunung/refs/heads/main/dronespy.lua",
    "https://raw.githubusercontent.com/upilbalmon/Gunung/refs/heads/main/pengendalitanah.lua",
    "https://raw.githubusercontent.com/upilbalmon/1/refs/heads/main/aimteleport.lua",
}

-- container kiri: tombol & status
local left = Instance.new("Frame")
left.Parent = TabSettings
left.BackgroundTransparency = 1
left.Position = UDim2.new(0, 8, 0, 8)
left.Size = UDim2.new(0, 200, 1, -16)

local titleSet = Instance.new("TextLabel")
titleSet.Parent = left
titleSet.BackgroundTransparency = 1
titleSet.Size = UDim2.new(1, 0, 0, 24)
titleSet.Font = Enum.Font.GothamBold
titleSet.TextSize = 16
titleSet.TextXAlignment = Enum.TextXAlignment.Left
titleSet.TextColor3 = Color3.fromRGB(255,255,255)
titleSet.Text = "External UI"

local toggleBtn = MakeBlueBtn(left, "UI: OFF")
toggleBtn.Position = UDim2.new(0, 0, 0, 32)

local statusLbl = Instance.new("TextLabel")
statusLbl.Parent = left
statusLbl.BackgroundTransparency = 1
statusLbl.Position = UDim2.new(0, 0, 0, 72)
statusLbl.Size = UDim2.new(1, 0, 0, 22)
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 14
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.TextColor3 = Color3.fromRGB(200,200,200)
statusLbl.Text = "Status: belum dimuat"

--== Loader State ==
local uiActive = false
local loadedOnce = false
local managedGuis : { Instance } = {} -- ScreenGui yang kita kelola dari URLS

local function hasProperty(obj, prop)
    local ok, _ = pcall(function() return obj[prop] end)
    return ok
end

local function captureNewScreenGuis(beforeSet)
    local newOnes = {}
    for _, ch in ipairs(pg:GetChildren()) do
        if ch:IsA("ScreenGui") and not beforeSet[ch] then
            table.insert(newOnes, ch)
        end
    end
    return newOnes
end

local function toSet(children)
    local set = {}
    for _, ch in ipairs(children) do set[ch] = true end
    return set
end

local function showManaged()
    for _, gui in ipairs(managedGuis) do
        if gui.Parent ~= pg then
            gui.Parent = pg
        end
        if hasProperty(gui, "Enabled") then
            gui.Enabled = true
        end
        if hasProperty(gui, "IgnoreGuiInset") then
            -- no-op, just ensuring the property exists if needed
        end
        -- fallback: try make all top Frames visible
        for _, d in ipairs(gui:GetDescendants()) do
            if hasProperty(d, "Visible") then
                d.Visible = true
            end
        end
    end
end

local function hideManaged()
    for _, gui in ipairs(managedGuis) do
        if hasProperty(gui, "Enabled") then
            gui.Enabled = false
        else
            -- fallback: set Visible = false pada semua descendants yang punya property Visible
            for _, d in ipairs(gui:GetDescendants()) do
                if hasProperty(d, "Visible") then
                    d.Visible = false
                end
            end
        end
    end
end

local function loadAllIfNeeded()
    -- Sudah pernah load? cukup show
    if loadedOnce and #managedGuis > 0 then
        showManaged()
        return true
    end

    -- Snapshot sebelum load
    local before = toSet(pg:GetChildren())
    local anyLoaded = false

    for _, url in ipairs(URLS) do
        local ok, res = pcall(function()
            return loadstring(game:HttpGet(url))()
        end)
        if ok then
            anyLoaded = true
            -- Jika script return Instance (idealnya ScreenGui), kelola langsung
            if typeof(res) == "Instance" then
                if res:IsA("ScreenGui") then
                    table.insert(managedGuis, res)
                elseif res:IsA("GuiObject") then
                    -- bungkus ke ScreenGui agar bisa di-manage
                    local wrap = Instance.new("ScreenGui")
                    wrap.Name = "Wrapped_" .. (res.Name or "Ext")
                    wrap.ResetOnSpawn = false
                    wrap.DisplayOrder = 9998
                    wrap.ZIndexBehavior = Enum.ZIndexBehavior.Global
                    res.Parent = wrap
                    wrap.Parent = pg
                    table.insert(managedGuis, wrap)
                end
            end
        else
            warn("Load gagal untuk URL: ", url, " | Err: ", res)
        end
    end

    -- Tangkap ScreenGui baru yang ditambahkan oleh script (bila script tak return instance)
    local newOnes = captureNewScreenGuis(before)
    for _, gui in ipairs(newOnes) do
        -- Hindari menambah diri sendiri (MultiTabGUI)
        if gui ~= ScreenGui then
            table.insert(managedGuis, gui)
        end
    end

    loadedOnce = anyLoaded or (#newOnes > 0)
    return loadedOnce
end

--== Toggle Button Behavior ==
toggleBtn.MouseButton1Click:Connect(function()
    uiActive = not uiActive
    if uiActive then
        local ok = loadAllIfNeeded()
        if ok then
            showManaged()
            toggleBtn.Text = "UI: ON"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0,140,255)
            statusLbl.Text = ("Status: aktif (%d GUI)").format(#managedGuis)
        else
            uiActive = false
            statusLbl.Text = "Status: gagal memuat"
        end
    else
        hideManaged()
        toggleBtn.Text = "UI: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
        statusLbl.Text = ("Status: nonaktif (%d GUI di-hide)").format(#managedGuis)
    end
end)

--== Selesai ==
