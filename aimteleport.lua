--// Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

--// Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local cam = workspace.CurrentCamera

-- Hapus GUI lama bila ada
local OLD = playerGui:FindFirstChild("TeleportBidikGUI")
if OLD then OLD:Destroy() end

-- ===== ROOT GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "TeleportBidikGUI"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.DisplayOrder = 9999
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Enabled = true
gui.Parent = playerGui

-- ===== PANEL =====
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(70, 70)
frame.Position = UDim2.new(0.9, 15, 0.3, 0)
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0
frame.Active = true
frame.ZIndex = 50

-- ===== DRAGGABLE =====
do
	local dragging = false
	local dragStart, startPos
	local function updateDrag(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
		   input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)
	frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
		   input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
		   input.UserInputType == Enum.UserInputType.Touch) then
			updateDrag(input)
		end
	end)
end

-- ===== TOMBOL TELEPORT LINGKARAN =====
local btnAimTp = Instance.new("TextButton", frame)
btnAimTp.Size = UDim2.fromOffset(50, 50)
btnAimTp.AnchorPoint = Vector2.new(0.5, 0.5)
btnAimTp.Position = UDim2.new(0.5, 0, 0.5, 0)
btnAimTp.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
btnAimTp.BackgroundTransparency = 0.5
btnAimTp.Text = "Q"
btnAimTp.Font = Enum.Font.GothamBold
btnAimTp.TextSize = 16
btnAimTp.TextColor3 = Color3.new(1, 1, 1)
btnAimTp.ZIndex = 55
Instance.new("UICorner", btnAimTp).CornerRadius = UDim.new(1, 0)

-- ===== Crosshair =====
local ZCROSS = 5
local function makeCross(a, b, pos)
	local f = Instance.new("Frame", gui)
	f.Size = UDim2.fromOffset(a, b)
	f.AnchorPoint = Vector2.new(0.5, 0.5)
	f.Position = pos
	f.BackgroundColor3 = Color3.new(1, 1, 1)
	f.BorderSizePixel = 0
	f.ZIndex = ZCROSS
	return f
end

local crossCenter = makeCross(4, 4, UDim2.new(0.5, 0, 0.5, 0))
local hLine = makeCross(20, 2, UDim2.new(0.5, 0, 0.5, 0))
local vLine = makeCross(2, 20, UDim2.new(0.5, 0, 0.5, 0))

-- ===== Teleport Bidik =====
local function teleportToAim()
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local offsetY = 5 -- Default offset Y
	local rayOrigin = cam.CFrame.Position
	local rayDirection = cam.CFrame.LookVector * 1000
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = { char }
	params.FilterType = Enum.RaycastFilterType.Blacklist

	local result = workspace:Raycast(rayOrigin, rayDirection, params)
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
	if processed then return end
	if input.KeyCode == Enum.KeyCode.Q then
		teleportToAim()
	end
end)

-- ===== Close =====
btnClose.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
