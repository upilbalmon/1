-- LocalScript - Teleport Bidik Only (Cherry 🌸 Edition)

local FRAME_TRANSPARENCY = 0.4
local TITLE_TRANSPARENCY = 0.2
local TEXTBOX_TRANSPARENCY = 0.2
local BUTTON_COLOR = Color3.fromRGB(0,120,255)
local CLOSE_COLOR  = Color3.fromRGB(220,0,0)
local MINIM_COLOR  = Color3.fromRGB(0,180,0)
local CORNER = 8

local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local player  = Players.LocalPlayer
local cam     = workspace.CurrentCamera

-- Root GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TeleportBidikGUI"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.DisplayOrder = 9999
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260, 140)
frame.Position = UDim2.new(0.5, -130, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = FRAME_TRANSPARENCY
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, CORNER)

-- Title bar
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1,0,0,30)
titleBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
titleBar.BackgroundTransparency = TITLE_TRANSPARENCY
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, CORNER)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.fromOffset(10,0)
title.BackgroundTransparency = 1
title.Text = "Teleport Bidik"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)

-- Close & Minimize buttons
local function makeBtn(txt, col, xoff)
	local b = Instance.new("TextButton", titleBar)
	b.Size = UDim2.fromOffset(24,24)
	b.Position = UDim2.new(1, -xoff, 0, 3)
	b.BackgroundColor3 = col
	b.Text = txt
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
	return b
end

local btnClose = makeBtn("×", CLOSE_COLOR, 28)
local btnMin   = makeBtn("–", MINIM_COLOR, 56)

local miniIcon = Instance.new("TextButton", gui)
miniIcon.Size = UDim2.fromOffset(25,25)
miniIcon.Position = UDim2.new(1,-35,1,-35) -- kanan bawah
miniIcon.BackgroundColor3 = MINIM_COLOR
miniIcon.Text = "◙"
miniIcon.Font = Enum.Font.GothamBold
miniIcon.TextSize = 14
miniIcon.TextColor3 = Color3.new(1,1,1)
miniIcon.Visible = false
Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(1,0)

btnClose.MouseButton1Click:Connect(function() gui:Destroy() end)
btnMin.MouseButton1Click:Connect(function() frame.Visible=false; miniIcon.Visible=true end)
miniIcon.MouseButton1Click:Connect(function() frame.Visible=true; miniIcon.Visible=false end)

-- Draggable
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true; dragStart = input.Position; startPos = frame.Position
	end
end)
titleBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local d = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)

-- Offset Y box
local tbOffsetY = Instance.new("TextBox", frame)
tbOffsetY.Size = UDim2.new(1,-20,0,26)
tbOffsetY.Position = UDim2.fromOffset(10, 40)
tbOffsetY.BackgroundColor3 = Color3.fromRGB(255,255,255)
tbOffsetY.BackgroundTransparency = TEXTBOX_TRANSPARENCY
tbOffsetY.Text = "5"
tbOffsetY.PlaceholderText = "Offset Y (stud)"
tbOffsetY.Font = Enum.Font.Gotham
tbOffsetY.TextSize = 12
tbOffsetY.TextColor3 = Color3.fromRGB(0,0,0)
tbOffsetY.ClearTextOnFocus = false
Instance.new("UICorner", tbOffsetY).CornerRadius = UDim.new(0,6)

-- Teleport button
local btnAimTp = Instance.new("TextButton", frame)
btnAimTp.Size = UDim2.new(1,-20,0,28)
btnAimTp.Position = UDim2.fromOffset(10, 74)
btnAimTp.BackgroundColor3 = BUTTON_COLOR
btnAimTp.Text = "Teleport Bidik (Q)"
btnAimTp.Font = Enum.Font.GothamBold
btnAimTp.TextSize = 12
btnAimTp.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnAimTp).CornerRadius = UDim.new(0,6)

-- Crosshair
local crossCenter = Instance.new("Frame", gui)
crossCenter.Size = UDim2.fromOffset(4,4)
crossCenter.AnchorPoint = Vector2.new(0.5,0.5)
crossCenter.Position = UDim2.new(0.5,0,0.5,0)
crossCenter.BackgroundColor3 = Color3.new(1,1,1)
crossCenter.BorderSizePixel = 0
crossCenter.ZIndex = 100

local hLine = Instance.new("Frame", gui)
hLine.Size = UDim2.fromOffset(20,2)
hLine.AnchorPoint = Vector2.new(0.5,0.5)
hLine.Position = UDim2.new(0.5,0,0.5,0)
hLine.BackgroundColor3 = Color3.new(1,1,1)
hLine.BorderSizePixel = 0
hLine.ZIndex = 100

local vLine = Instance.new("Frame", gui)
vLine.Size = UDim2.fromOffset(2,20)
vLine.AnchorPoint = Vector2.new(0.5,0.5)
vLine.Position = UDim2.new(0.5,0,0.5,0)
vLine.BackgroundColor3 = Color3.new(1,1,1)
vLine.BorderSizePixel = 0
vLine.ZIndex = 100

-- Teleport function
local function teleportToAim()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local rayOrigin    = cam.CFrame.Position
	local rayDirection = cam.CFrame.LookVector * 1000
	local params       = RaycastParams.new()
	params.FilterDescendantsInstances = {player.Character}
	params.FilterType = Enum.RaycastFilterType.Blacklist

	local result  = workspace:Raycast(rayOrigin, rayDirection, params)
	local offsetY = tonumber(tbOffsetY.Text) or 5
	local target

	if result then
		target = result.Position
		if result.Instance and (result.Instance:IsA("Terrain") or result.Instance.Anchored) then
			target = target + Vector3.new(0, offsetY, 0)
		end
	else
		target = rayOrigin + rayDirection
	end

	hrp.CFrame = CFrame.new(target, target + cam.CFrame.LookVector)
end

btnAimTp.MouseButton1Click:Connect(teleportToAim)
UIS.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.Q then teleportToAim() end
end)

