-- Buat GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ClaimAwardGui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 120)
Frame.Position = UDim2.new(0.5, -110, 0.5, -60)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BackgroundTransparency = 0.35
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Rounded corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = Frame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -25, 0, 25)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Claim Award"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Frame

-- Tombol Close
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -25, 0, 0)
CloseButton.Text = "×"
CloseButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.Parent = Frame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

-- Input box (cukup untuk 4 digit angka)
local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0, 60, 0, 25)
TextBox.Position = UDim2.new(0, 15, 0, 35)
TextBox.PlaceholderText = "1-30"
TextBox.Text = "1-30" -- default value
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.BackgroundTransparency = 0.2
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.ClearTextOnFocus = false
TextBox.Font = Enum.Font.SourceSans
TextBox.TextSize = 14
TextBox.Parent = Frame

local TextBoxCorner = Instance.new("UICorner")
TextBoxCorner.CornerRadius = UDim.new(0, 4)
TextBoxCorner.Parent = TextBox

-- Tombol Claim (di samping kanan TextBox)
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 90, 0, 25)
Button.Position = UDim2.new(0, 85, 0, 35)
Button.Text = "Claim"
Button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
Button.BackgroundTransparency = 0.1
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 14
Button.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 4)
ButtonCorner.Parent = Button

-- Status Label (font kecil, center)
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 18)
Status.Position = UDim2.new(0, 10, 1, -25)
Status.BackgroundTransparency = 1
Status.Text = "Status: Idle"
Status.TextColor3 = Color3.fromRGB(200, 200, 200)
Status.Font = Enum.Font.SourceSans
Status.TextSize = 12
Status.TextXAlignment = Enum.TextXAlignment.Center
Status.Parent = Frame

-- Function claim
local function claimAward(boxNumber)
    local args = {
        "ClaimOnceSeasonAward",
        {
            boxNumber,
            false
        }
    }
    local result = game:GetService("ReplicatedStorage"):WaitForChild("Msg"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
    print("Claim box:", boxNumber, "->", result)
    return result
end

-- Event tombol Claim
Button.MouseButton1Click:Connect(function()
    local inputBox = TextBox.Text
    if inputBox == "" then
        Status.Text = "Status: Harap isi nomor box!"
        return
    end
    
    Status.Text = "Status: Running..."

    if string.find(inputBox, "-") then
        local startNum, endNum = string.match(inputBox, "(%d+)%-(%d+)")
        startNum, endNum = tonumber(startNum), tonumber(endNum)
        if startNum and endNum then
            for i = startNum, endNum do
                claimAward(i)
                Status.Text = "Status: Claimed box " .. i
                task.wait(0.1)
            end
            Status.Text = "Status: Selesai!"
        else
            Status.Text = "Status: Format salah (contoh 1-30)"
        end
    else
        local boxNumber = tonumber(inputBox)
        if boxNumber then
            claimAward(boxNumber)
            Status.Text = "Status: Claimed box " .. boxNumber
        else
            Status.Text = "Status: Input salah!"
        end
    end
end)

-- Event tombol Close
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
