-- LocalScript - Panel Utility (BELI BEKAL + TOOLS)
-- Layout: 1 kolom bagian (stack), tiap bagian grid 2 kolom.
-- Tema: frame transparan 0.4, title 0.2, textbox 0.2, tombol biru solid,
-- close merah, minimize hijau (ikon 25x25 di bawah, solid agar jelas).
-- Draggable + top layer.

local FRAME_TRANSPARENCY = 0.4
local TITLE_TRANSPARENCY = 0.2
local TEXTBOX_TRANSPARENCY = 0.2
local BUTTON_COLOR = Color3.fromRGB(0,120,255)
local CLOSE_COLOR  = Color3.fromRGB(220,0,0)
local MINIM_COLOR  = Color3.fromRGB(0,180,0)
local CORNER = 10

local Players = game:GetService("Players")
local RS      = game:GetService("ReplicatedStorage")
local UIS     = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player  = Players.LocalPlayer

-- Root GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MinimalTransGUI"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.DisplayOrder = 9999
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(560, 460)
main.Position = UDim2.new(0.5, -280, 0.5, -230)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BackgroundTransparency = FRAME_TRANSPARENCY
main.BorderSizePixel = 0
main.Active = true
main.ZIndex = 50
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, CORNER)

-- Title bar
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
titleBar.BackgroundTransparency = TITLE_TRANSPARENCY
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 51
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, CORNER)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "Panel Utility"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(230,230,230)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 52

-- Close & Minimize (di title bar)
local function makeTopButton(txt, col, offset)
	local b = Instance.new("TextButton", titleBar)
	b.Size = UDim2.fromOffset(32,24)
	b.Position = UDim2.new(1, -offset, 0.5, -12)
	b.BackgroundColor3 = col
	b.BackgroundTransparency = 0  -- solid agar jelas
	b.Text = txt
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.ZIndex = 60
	b.Active = true; b.Selectable = true
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,CORNER)
	return b
end
local btnClose = makeTopButton("×", CLOSE_COLOR, 12)
local btnMin   = makeTopButton("—", MINIM_COLOR, 52)

-- Ikon minimize di bawah layar (25x25)
local miniIcon = Instance.new("TextButton", gui)
miniIcon.Size = UDim2.fromOffset(25,25)
miniIcon.Position = UDim2.new(0, 10, 1, -35) -- kiri bawah
miniIcon.BackgroundColor3 = MINIM_COLOR
miniIcon.BackgroundTransparency = 0
miniIcon.Text = "◙"
miniIcon.Font = Enum.Font.GothamBold
miniIcon.TextSize = 14
miniIcon.TextColor3 = Color3.new(1,1,1)
miniIcon.Visible = false
miniIcon.ZIndex = 70
Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(1,0)

-- CONTENT: 1 kolom bagian (stacked)
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -24, 1, -60)
content.Position = UDim2.fromOffset(12, 48)
content.BackgroundTransparency = 1
content.ZIndex = 55

local stack = Instance.new("UIListLayout", content)
stack.FillDirection = Enum.FillDirection.Vertical
stack.Padding = UDim.new(0, 12)
stack.SortOrder = Enum.SortOrder.LayoutOrder

-- Helper: Section/Card
local function makeSection(titleText)
	local card = Instance.new("Frame")
	card.BackgroundColor3 = Color3.fromRGB(30,30,30)
	card.BackgroundTransparency = FRAME_TRANSPARENCY
	card.BorderSizePixel = 0
	card.Size = UDim2.new(1, 0, 0, 200) -- cukup untuk 3 baris (bisa diubah)
	card.ZIndex = 56
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, CORNER)

	local ttl = Instance.new("TextLabel", card)
	ttl.BackgroundTransparency = 1
	ttl.Position = UDim2.fromOffset(10, 6)
	ttl.Size = UDim2.new(1, -20, 0, 24)
	ttl.Text = titleText
	ttl.Font = Enum.Font.GothamBold
	ttl.TextSize = 14
	ttl.TextColor3 = Color3.fromRGB(235,235,235)
	ttl.TextXAlignment = Enum.TextXAlignment.Left
	ttl.ZIndex = 57

	local gridHolder = Instance.new("Frame", card)
	gridHolder.BackgroundTransparency = 1
	gridHolder.Position = UDim2.fromOffset(10, 36)
	gridHolder.Size = UDim2.new(1, -20, 1, -46)
	gridHolder.ZIndex = 57

	local grid = Instance.new("UIGridLayout", gridHolder)
	grid.CellPadding = UDim2.fromOffset(10, 10)
	grid.CellSize = UDim2.new(0.5, -5, 0, 40) -- 2 kolom
	grid.FillDirectionMaxCells = 2
	grid.SortOrder = Enum.SortOrder.LayoutOrder
	grid.StartCorner = Enum.StartCorner.TopLeft

	return card, gridHolder
end

local function makeBlueButton(txt)
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromOffset(180, 40)
	b.BackgroundColor3 = BUTTON_COLOR
	b.BackgroundTransparency = 0 -- solid
	b.Text = txt
	b.Font = Enum.Font.GothamMedium
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.ZIndex = 60
	b.Active = true; b.Selectable = true
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, CORNER)
	return b
end

local function makeDisabledSlot()
	local f = Instance.new("TextButton")
	f.Size = UDim2.fromOffset(180, 40)
	f.BackgroundColor3 = Color3.fromRGB(60,60,60)
	f.BackgroundTransparency = 0
	f.AutoButtonColor = false
	f.Text = "—"
	f.Font = Enum.Font.Gotham
	f.TextSize = 14
	f.TextColor3 = Color3.fromRGB(180,180,180)
	f.ZIndex = 58
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, CORNER)
	return f
end

-- ========= BELI BEKAL (EVENTS) =========
local bekalCard = makeSection("BELI BEKAL")
bekalCard.Parent = content
local bekalGrid = bekalCard:FindFirstChildOfClass("Frame"):FindFirstChildOfClass("UIGridLayout")

local btnRoti = makeBlueButton("ROTI");        btnRoti.Parent = bekalCard:FindFirstChildOfClass("Frame")
local btnPop  = makeBlueButton("POP MIE");     btnPop.Parent  = bekalCard:FindFirstChildOfClass("Frame")
local btnTeh  = makeBlueButton("ES TEH");      btnTeh.Parent  = bekalCard:FindFirstChildOfClass("Frame")
local btnSTMJ = makeBlueButton("STMJ");        btnSTMJ.Parent = bekalCard:FindFirstChildOfClass("Frame")
local btnMed  = makeBlueButton("KOTAK OBAT");  btnMed.Parent  = bekalCard:FindFirstChildOfClass("Frame")
makeDisabledSlot().Parent = bekalCard:FindFirstChildOfClass("Frame") -- slot ke-6 agar rapi

-- ========= TOOLS =========
local toolsCard = makeSection("TOOLS")
toolsCard.Parent = content
local toolsGrid = toolsCard:FindFirstChildOfClass("Frame"):FindFirstChildOfClass("UIGridLayout")

local btnFly = makeBlueButton("Fly Mode");          btnFly.Parent = toolsCard:FindFirstChildOfClass("Frame")
local btnPin = makeBlueButton("Pin Lokasi");        btnPin.Parent = toolsCard:FindFirstChildOfClass("Frame")
local btnTp  = makeBlueButton("Teleport (X,Y,Z)");  btnTp.Parent  = toolsCard:FindFirstChildOfClass("Frame")
makeDisabledSlot().Parent = toolsCard:FindFirstChildOfClass("Frame") -- jadi 2x2: 7 8 / 9 10

-- DRAGGABLE (titleBar)
local dragging, dragStart, startPos = false, nil, nil
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true; dragStart = input.Position; startPos = main.Position
	end
end)
titleBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Close & Minimize
btnClose.MouseButton1Click:Connect(function() gui:Destroy() end)
btnMin.MouseButton1Click:Connect(function()
	main.Visible = false
	miniIcon.Visible = true
end)
miniIcon.MouseButton1Click:Connect(function()
	main.Visible = true
	miniIcon.Visible = false
end)

-- ====== LOGIC ======
-- Helper RemoteFunction
local function checkout(args)
	local rf = RS:WaitForChild("Checkout", 5)
	if rf then rf:InvokeServer(unpack(args)) else warn("Checkout RemoteFunction not found") end
end

-- BELI BEKAL (Remote Event payloads)
btnRoti.MouseButton1Click:Connect(function()  checkout({{{Name="Bread",   Price=4000}}})  end)
btnPop.MouseButton1Click:Connect(function()   checkout({{{Name="Mie Cup", Price=12000}}}) end)
btnTeh.MouseButton1Click:Connect(function()   checkout({{{Name="Tea Cup", Price=3000}}})  end)
btnSTMJ.MouseButton1Click:Connect(function()  checkout({{{Name="STMJ",    Price=6500}}})  end)
btnMed.MouseButton1Click:Connect(function()   checkout({{{Name="Medkit",  Price=20000}}}) end)

-- TOOLS
-- Fly Mode (toggle) - gerak relatif kamera: WASD, Space naik, LeftControl turun
local flyOn, flyConn = false, nil
btnFly.MouseButton1Click:Connect(function()
	flyOn = not flyOn
	if flyOn then
		btnFly.Text = "Fly Mode (ON)"
		flyConn = RunService.RenderStepped:Connect(function()
			local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			local move = Vector3.zero
			if UIS:IsKeyDown(Enum.KeyCode.W) then move += workspace.CurrentCamera.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then move -= workspace.CurrentCamera.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then move -= workspace.CurrentCamera.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then move += workspace.CurrentCamera.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
			if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
			if move.Magnitude > 0 then hrp.CFrame = hrp.CFrame + move.Unit * 2 end
		end)
	else
		if flyConn then flyConn:Disconnect() flyConn=nil end
		btnFly.Text = "Fly Mode"
	end
end)

-- Pin Lokasi (copy ke clipboard jika tersedia)
btnPin.MouseButton1Click:Connect(function()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local p = hrp.Position
	local pos = string.format("%d,%d,%d", p.X, p.Y, p.Z)
	pcall(function() if setclipboard then setclipboard(pos) end end)
	btnPin.Text = "Pinned!"
	task.delay(1.2, function() btnPin.Text = "Pin Lokasi" end)
end)

-- Teleport (X,Y,Z) dari satu textbox
local tpBox = Instance.new("TextBox", toolsCard:FindFirstChildOfClass("Frame"))
tpBox.Size = UDim2.fromOffset(180, 40)
tpBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
tpBox.BackgroundTransparency = TEXTBOX_TRANSPARENCY
tpBox.PlaceholderText = "X,Y,Z"
tpBox.Font = Enum.Font.Gotham
tpBox.TextSize = 14
tpBox.TextColor3 = Color3.fromRGB(20,20,20)
tpBox.ClearTextOnFocus = false
tpBox.ZIndex = 60
Instance.new("UICorner", tpBox).CornerRadius = UDim.new(0, CORNER)

btnTp.MouseButton1Click:Connect(function()
	local x,y,z = tpBox.Text:match("([^,]+),([^,]+),([^,]+)")
	x,y,z = tonumber(x), tonumber(y), tonumber(z)
	if x and y and z then
		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if hrp then hrp.CFrame = CFrame.new(x,y,z) end
	else
		btnTp.Text = "Input invalid!"
		task.delay(1.2, function() btnTp.Text = "Teleport (X,Y,Z)" end)
	end
end)
