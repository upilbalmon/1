--[[
    AUTO COIN V3 - WindUI Version
    Menggunakan WindUI untuk tampilan yang lebih modern
--]]

------ LOAD WINDUI ------
local WindUI
local success, err = pcall(function()
    WindUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/main_example.lua'))()
end)

if not success or not WindUI then
    warn("Gagal load WindUI: " .. tostring(err))
    return
end

------ SERVICES ------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

------ CONSTANTS ------
local PAUSE_INTERVAL = 60 * 60
local PAUSE_DURATION = 30
local WIN_DELAY_BASE = 10000
local DEFAULT_HEIGHT = 5000
local DEFAULT_DELAY = 5
local HEIGHT_MULTIPLIER = 2.8
local MAX_HEIGHT = 14400

------ STATE MANAGEMENT ------
local State = {
    jumpID = nil,
    landingID = nil,
    winID = nil,
    magicTokenID = nil,
    isReady = false,
    running = false,
    autoWinEnabled = false,
    autoTokenEnabled = false,
    runTime = 0,
    lastLoopTime = 0,
    nextLoopTime = 0,
    lastWinTime = 0,
    hookEnabled = true,
    minimized = false,
    climbSpeed = 0,
    climbing = false,
    climbStartY = 0,
    climbStartTime = 0,
    maxY = 0,
    lockDelay = false,
    currentHeight = DEFAULT_HEIGHT,
    currentDelay = DEFAULT_DELAY,
}

------ UTILITY FUNCTIONS ------
local function GetWinDelay()
    return State.climbSpeed > 0 and (WIN_DELAY_BASE / State.climbSpeed) or 20
end

local function CalculateHeight()
    local delay = State.currentDelay or DEFAULT_DELAY
    local calculatedHeight = math.floor((State.climbSpeed * HEIGHT_MULTIPLIER) * delay)
    return math.min(calculatedHeight, MAX_HEIGHT)
end

local function UpdateHeight()
    if State.climbSpeed > 0 then
        State.currentHeight = CalculateHeight()
        -- Update UI jika ada komponen yang perlu diupdate
    end
end

------ REMOTE EVENT FUNCTIONS ------
local function SendRemoteEvent(eventName, ...)
    local args = {eventName, ...}
    local remote = ReplicatedStorage:FindFirstChild("ProMgs")
    if remote then
        local event = remote:FindFirstChild("RemoteEvent")
        if event then
            event:FireServer(unpack(args))
        end
    end
end

local function SendJumpData()
    if State.jumpID then
        SendRemoteEvent("JumpResults", State.jumpID, State.currentHeight)
    end
end

local function SendLandingData()
    if State.landingID then
        SendRemoteEvent("LandingResults", State.landingID)
    end
end

local function SendWinData()
    if State.winID then
        SendRemoteEvent("ClaimRooftopWinsReward", State.winID)
        State.lastWinTime = os.time()
    end
end

local function SendTokenData()
    if State.magicTokenID then
        SendRemoteEvent("ClaimRooftopMagicToken", State.magicTokenID)
    end
end

------ CORE LOGIC ------
local function UpdateStatus()
    -- Update status di UI melalui callback
end

local function RunLoop()
    while State.running and State.hookEnabled do
        local internalDelay = State.currentDelay
        
        if State.autoTokenEnabled and State.climbSpeed > 0 and not State.lockDelay then
            internalDelay = math.floor((10000 / State.climbSpeed) * 10) / 10
            State.currentDelay = internalDelay
        end
        
        State.lastLoopTime = os.time()
        State.nextLoopTime = State.lastLoopTime + internalDelay
        
        if State.autoTokenEnabled and State.magicTokenID then
            local tokenTime = State.lastLoopTime + (internalDelay / 2)
            while os.time() < tokenTime and State.running and State.hookEnabled do
                task.wait(0.1)
            end
            if State.running and State.hookEnabled then
                SendTokenData()
            end
        end
        
        local currentWinDelay = GetWinDelay()
        if State.autoWinEnabled and os.time() - State.lastWinTime >= currentWinDelay then
            SendWinData()
        end
        
        while os.time() < State.nextLoopTime and State.running and State.hookEnabled do
            task.wait(0.1)
        end
        
        if not State.running or not State.hookEnabled then break end
        
        SendJumpData()
        SendLandingData()
        
        State.runTime = State.runTime + (os.time() - State.lastLoopTime)
        if State.runTime >= PAUSE_INTERVAL then
            State.running = false
            task.wait(PAUSE_DURATION)
            State.runTime = 0
            State.running = true
        end
    end
end

------ CLIMB SPEED METER ------
local function SetupCharacter(char)
    local humanoid = char:WaitForChild("Humanoid")
    
    humanoid.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Climbing then
            State.climbStartY = char:WaitForChild("HumanoidRootPart").Position.Y
            State.climbStartTime = tick()
            State.maxY = State.climbStartY
            State.climbing = true
        else
            if State.climbing then
                local climbEndY = State.maxY
                local climbEndTime = tick()
                local totalY = climbEndY - State.climbStartY
                local totalTime = climbEndTime - State.climbStartTime
                
                if totalY > 0 and totalTime > 0 then
                    State.climbSpeed = totalY / totalTime
                    
                    if not State.lockDelay then
                        UpdateHeight()
                        if State.autoTokenEnabled then
                            State.currentDelay = math.floor((10000 / State.climbSpeed) * 10) / 10
                        end
                    end
                end
                State.climbing = false
            end
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if State.climbing and char:FindFirstChild("HumanoidRootPart") then
            local y = char.HumanoidRootPart.Position.Y
            if y > State.maxY then
                State.maxY = y
            end
        end
    end)
end

------ EVENT HANDLERS ------
local function InitializeRemoteHook()
    local remoteEvent = ReplicatedStorage:FindFirstChild("ProMgs")
    if remoteEvent then
        remoteEvent = remoteEvent:FindFirstChild("RemoteEvent")
    end
    
    if not remoteEvent then return end
    
    local oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if not State.hookEnabled then
            return oldNamecall(self, ...)
        end
        
        local args = {...}
        local method = getnamecallmethod()
        
        if self == remoteEvent and method == "FireServer" then
            local eventType = args[1]
            local eventID = args[2]
            
            if typeof(eventID) == "number" then
                if eventType == "JumpResults" then
                    State.jumpID = eventID
                elseif eventType == "LandingResults" then
                    State.landingID = eventID
                elseif eventType == "ClaimRooftopWinsReward" then
                    State.winID = eventID
                elseif eventType == "ClaimRooftopMagicToken" then
                    State.magicTokenID = eventID
                end
            end
        end
        
        return oldNamecall(self, ...)
    end)
end

------ CREATE WINDUI INTERFACE ------
local function CreateWindUI()
    -- Main Window
    local Window = WindUI:CreateWindow({
        Title = "AUTO COIN V3",
        Icon = "dollar-sign",
        Author = "CAJT",
        Folder = "AutoCoinConfig",
        Size = UDim2.fromOffset(420, 500),
        Transparent = true,
        Theme = "Dark",
    })
    
    -- Tab: Main
    local MainTab = Window:Tab({
        Title = "Main",
        Icon = "home",
    })
    
    -- Section: Status
    local StatusSection = MainTab:Section({
        Title = "📊 Status",
    })
    
    -- Status Labels
    local coinStatus = StatusSection:Label({
        Title = "🪙 Coin: ❌",
    })
    
    local winStatus = StatusSection:Label({
        Title = "🏆 Win: ❌",
    })
    
    local tokenStatus = StatusSection:Label({
        Title = "🔮 Token: ❌",
    })
    
    local speedStatus = StatusSection:Label({
        Title = "📈 Speed: 0 studs/s",
    })
    
    -- Section: Settings
    local SettingsSection = MainTab:Section({
        Title = "⚙️ Settings",
    })
    
    -- Height Input
    local heightInput = SettingsSection:Input({
        Title = "Height",
        Desc = "Ketinggian lompatan (auto-calculate jika kosong)",
        Value = tostring(DEFAULT_HEIGHT),
        Placeholder = "Auto",
        Callback = function(Value)
            local num = tonumber(Value)
            if num and num > 0 then
                State.currentHeight = math.min(num, MAX_HEIGHT)
            end
        end,
    })
    
    -- Delay Input
    local delayInput = SettingsSection:Input({
        Title = "Delay (seconds)",
        Desc = "Delay antar lompatan",
        Value = tostring(DEFAULT_DELAY),
        Placeholder = "5",
        Callback = function(Value)
            local num = tonumber(Value)
            if num and num > 0 then
                State.currentDelay = num
                if not State.lockDelay then
                    UpdateHeight()
                end
            end
        end,
    })
    
    -- Lock Delay Toggle
    local lockDelayToggle = SettingsSection:Toggle({
        Title = "🔒 Lock Delay Setting",
        Desc = "Mencegah delay berubah otomatis",
        Value = false,
        Callback = function(State)
            State.lockDelay = State
            if State then
                delayInput:SetEditable(false)
            else
                delayInput:SetEditable(true)
            end
        end,
    })
    
    -- Section: Controls
    local ControlsSection = MainTab:Section({
        Title = "🎮 Controls",
    })
    
    -- Start/Stop Button
    local startButton = ControlsSection:Button({
        Title = "▶ START AUTO COIN",
        Desc = "Mulai proses auto coin",
        Callback = function()
            if State.isReady then
                State.running = not State.running
                if State.running then
                    startButton:Set("⏹ STOP AUTO COIN")
                    State.lastWinTime = os.time()
                    coroutine.wrap(RunLoop)()
                else
                    startButton:Set("▶ START AUTO COIN")
                end
            else
                WindUI:Notify({
                    Title = "⚠️ Not Ready",
                    Content = "Lompat dari tower terlebih dahulu!",
                    Duration = 2,
                })
            end
        end,
    })
    
    -- Toggles Frame
    local ToggleSection = MainTab:Section({
        Title = "🔄 Auto Features",
    })
    
    -- Auto Win Toggle
    local autoWinToggle = ToggleSection:Toggle({
        Title = "🏆 Auto Win",
        Desc = "Klaim reward win secara otomatis",
        Value = false,
        Callback = function(Value)
            if State.winID then
                State.autoWinEnabled = Value
                if Value and State.climbSpeed > 0 then
                    WindUI:Notify({
                        Title = "Auto Win Active",
                        Content = string.format("Win delay: %.1fs", GetWinDelay()),
                        Duration = 2,
                    })
                end
            else
                WindUI:Notify({
                    Title = "⚠️ Error",
                    Content = "Belum ada Win ID!",
                    Duration = 2,
                })
            end
        end,
    })
    
    -- Auto Token Toggle
    local autoTokenToggle = ToggleSection:Toggle({
        Title = "🔮 Auto Token",
        Desc = "Klaim magic token secara otomatis",
        Value = false,
        Callback = function(Value)
            if State.magicTokenID then
                State.autoTokenEnabled = Value
                if Value and State.climbSpeed > 0 and not State.lockDelay then
                    local newDelay = math.floor((10000 / State.climbSpeed) * 10) / 10
                    State.currentDelay = newDelay
                    delayInput:Set(tostring(newDelay))
                end
            else
                WindUI:Notify({
                    Title = "⚠️ Error",
                    Content = "Belum ada Token ID!",
                    Duration = 2,
                })
            end
        end,
    })
    
    -- Tab: Info
    local InfoTab = Window:Tab({
        Title = "Info",
        Icon = "info",
    })
    
    local InfoSection = InfoTab:Section({
        Title = "📖 Informasi",
    })
    
    InfoSection:Label({
        Title = "AUTO COIN V3 - WindUI Version",
    })
    
    InfoSection:Label({
        Title = "Fitur:",
    })
    
    InfoSection:Label({
        Title = "• Auto height calculation",
    })
    
    InfoSection:Label({
        Title = "• Dynamic auto win delay",
    })
    
    InfoSection:Label({
        Title = "• Auto token delay formula",
    })
    
    InfoSection:Label({
        Title = "• Max height limit: 14400",
    })
    
    InfoSection:Label({
        Title = "• Lock delay setting",
    })
    
    InfoSection:Label({
        Title = "",
    })
    
    InfoSection:Label({
        Title = "📌 Cara Penggunaan:",
    })
    
    InfoSection:Label({
        Title = "1. Lompat dari tower",
    })
    
    InfoSection:Label({
        Title = "2. Tunggu speed terdeteksi",
    })
    
    InfoSection:Label({
        Title = "3. Klik START AUTO COIN",
    })
    
    -- Status update function
    local function UpdateUIStatus()
        coinStatus:Set(string.format("🪙 Coin: %s", (State.jumpID and State.landingID) and "✅" or "❌"))
        winStatus:Set(string.format("🏆 Win: %s", State.winID and "✅" or "❌"))
        tokenStatus:Set(string.format("🔮 Token: %s", State.magicTokenID and "✅" or "❌"))
        speedStatus:Set(string.format("📈 Speed: %.2f studs/s", State.climbSpeed))
        
        State.isReady = State.jumpID and State.landingID and true or false
    end
    
    -- Override UpdateStatus
    local oldUpdate = UpdateStatus
    UpdateStatus = UpdateUIStatus
    
    -- Update status setiap detik
    task.spawn(function()
        while State.hookEnabled do
            UpdateUIStatus()
            task.wait(1)
        end
    end)
    
    return {
        Window = Window,
        MainTab = MainTab,
        startButton = startButton,
        delayInput = delayInput,
        heightInput = heightInput,
        lockDelayToggle = lockDelayToggle,
        autoWinToggle = autoWinToggle,
        autoTokenToggle = autoTokenToggle,
        coinStatus = coinStatus,
        winStatus = winStatus,
        tokenStatus = tokenStatus,
        speedStatus = speedStatus,
    }
end

------ INITIALIZATION ------
-- Setup karakter
local LocalPlayer = Players.LocalPlayer
if LocalPlayer.Character then
    SetupCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(SetupCharacter)

-- Initialize Remote Hook
InitializeRemoteHook()

-- Create UI
local UI = CreateWindUI()

-- Notifikasi
WindUI:Notify({
    Title = "🚀 AUTO COIN V3",
    Content = "WindUI version loaded successfully!",
    Duration = 3,
})

print("AUTO COIN V3 - WindUI Version Loaded!")
