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
local CORNER = 6

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

-- Main Frame (ukuran lebih compact)
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(250, 350) -- Frame lebih kecil
main.Position = UDim2.new(0.5, -125, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BackgroundTransparency = FRAME_TRANSPARENCY
main.BorderSizePixel = 0
main.Active = true
main.ZIndex = 50
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, CORNER)
mainCorner.Parent = main

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 28) -- Title bar lebih kecil
titleBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
titleBar.BackgroundTransparency = TITLE_TRANSPARENCY
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 51
titleBar.Parent = main

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, CORNER)
titleBarCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.fromOffset(6, 0)
title.BackgroundTransparency = 1
title.Text = "Panel Utility"
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextColor3 = Color3.fromRGB(230,230,230)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 52
title.Parent = titleBar

-- Close & Minimize (di title bar)
local function makeTopButton(txt, col, offset)
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromOffset(26,20) -- Tombol lebih kecil
	b.Position = UDim2.new(1, -offset, 0.5, -10)
	b.BackgroundColor3 = col
	b.BackgroundTransparency = 0
	b.Text = txt
	b.Font = Enum.Font.GothamBold
	b.TextSize = 11
	b.TextColor3 = Color3.new(1,1,1)
	b.ZIndex = 60
	b.Active = true
	b.Selectable = true
	b.Parent = titleBar
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, CORNER)
	corner.Parent = b
	
	return b
end

local btnClose = makeTopButton("×", CLOSE_COLOR, 35)
local btnMin   = makeTopButton("—", MINIM_COLOR, 68)

-- Ikon minimize di bawah layar
local miniIcon = Instance.new("TextButton")
miniIcon.Size = UDim2.fromOffset(35,35)
miniIcon.Position = UDim2.new(0, 6, 1, -26)
miniIcon.BackgroundColor3 = MINIM_COLOR
miniIcon.BackgroundTransparency = 0
miniIcon.Text = "◙"
miniIcon.Font = Enum.Font.GothamBold
miniIcon.TextSize = 11
miniIcon.TextColor3 = Color3.new(1,1,1)
miniIcon.Visible = false
miniIcon.ZIndex = 70
miniIcon.Parent = gui

local miniIconCorner = Instance.new("UICorner")
miniIconCorner.CornerRadius = UDim.new(1,0)
miniIconCorner.Parent = miniIcon

-- CONTENT: 1 kolom bagian (stacked)
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -12, 1, -46)
content.Position = UDim2.fromOffset(6, 36)
content.BackgroundTransparency = 1
content.ZIndex = 55
content.Parent = main

local stack = Instance.new("UIListLayout")
stack.FillDirection = Enum.FillDirection.Vertical
stack.Padding = UDim.new(0, 6) -- Padding lebih kecil
stack.SortOrder = Enum.SortOrder.LayoutOrder
stack.Parent = content

-- Helper: Section/Card
local function makeSection(titleText)
	local card = Instance.new("Frame")
	card.BackgroundColor3 = Color3.fromRGB(30,30,30)
	card.BackgroundTransparency = FRAME_TRANSPARENCY
	card.BorderSizePixel = 0
	card.Size = UDim2.new(1, 0, 0, 120) -- Card lebih kecil
	card.ZIndex = 56
	
	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, CORNER)
	cardCorner.Parent = card

	local ttl = Instance.new("TextLabel")
	ttl.BackgroundTransparency = 1
	ttl.Position = UDim2.fromOffset(6, 3)
	ttl.Size = UDim2.new(1, -12, 0, 18)
	ttl.Text = titleText
	ttl.Font = Enum.Font.GothamBold
	ttl.TextSize = 11
	ttl.TextColor3 = Color3.fromRGB(235,235,235)
	ttl.TextXAlignment = Enum.TextXAlignment.Left
	ttl.ZIndex = 57
	ttl.Parent = card

	local gridHolder = Instance.new("Frame")
	gridHolder.BackgroundTransparency = 1
	gridHolder.Position = UDim2.fromOffset(6, 24)
	gridHolder.Size = UDim2.new(1, -12, 1, -30)
	gridHolder.ZIndex = 57
	gridHolder.Parent = card

	local grid = Instance.new("UIGridLayout")
	grid.CellPadding = UDim2.fromOffset(4, 4) -- Padding lebih kecil
	grid.CellSize = UDim2.new(0.5, -2, 0, 25) -- 2 kolom, tinggi 25, lebar disesuaikan
	grid.FillDirectionMaxCells = 2
	grid.SortOrder = Enum.SortOrder.LayoutOrder
	grid.StartCorner = Enum.StartCorner.TopLeft
	grid.Parent = gridHolder

	return card, gridHolder
end

local function makeBlueButton(txt)
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromOffset(35, 25) -- Ukuran tombol 25x35 (tinggi x lebar)
	b.BackgroundColor3 = BUTTON_COLOR
	b.BackgroundTransparency = 0
	b.Text = txt
	b.Font = Enum.Font.GothamMedium
	b.TextSize = 9 -- Font lebih kecil
	b.TextColor3 = Color3.new(1,1,1)
	b.ZIndex = 60
	b.Active = true
	b.Selectable = true
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, CORNER)
	corner.Parent = b
	
	return b
end

local function makeDisabledSlot()
	local f = Instance.new("TextButton")
	f.Size = UDim2.fromOffset(35, 25) -- Ukuran tombol 25x35
	f.BackgroundColor3 = Color3.fromRGB(60,60,60)
	f.BackgroundTransparency = 0
	f.AutoButtonColor = false
	f.Text = "—"
	f.Font = Enum.Font.Gotham
	f.TextSize = 9
	f.TextColor3 = Color3.fromRGB(180,180,180)
	f.ZIndex = 58
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, CORNER)
	corner.Parent = f
	
	return f
end

-- ========= BELI BEKAL (EVENTS) =========
local bekalCard, bekalGridHolder = makeSection("BELI BEKAL")
bekalCard.Parent = content

local btnRoti = makeBlueButton("ROTI");        btnRoti.Parent = bekalGridHolder
local btnPop  = makeBlueButton("POP MIE");     btnPop.Parent  = bekalGridHolder
local btnTeh  = makeBlueButton("ES TEH");      btnTeh.Parent  = bekalGridHolder
local btnSTMJ = makeBlueButton("STMJ");        btnSTMJ.Parent = bekalGridHolder
local btnMed  = makeBlueButton("KOTAK OBAT");  btnMed.Parent  = bekalGridHolder
local disabledSlot1 = makeDisabledSlot();      disabledSlot1.Parent = bekalGridHolder

-- ========= TOOLS =========
local toolsCard, toolsGridHolder = makeSection("TOOLS")
toolsCard.Parent = content

local btnLampu = makeBlueButton("Lampu");     btnLampu.Parent = toolsGridHolder
local btnPin = makeBlueButton("Pin Lokasi");  btnPin.Parent = toolsGridHolder
local btnTp  = makeBlueButton("Teleport");    btnTp.Parent  = toolsGridHolder
local disabledSlot2 = makeDisabledSlot();     disabledSlot2.Parent = toolsGridHolder

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
-- Fungsi Lampu (toggle on/off)
local lampuOn = false
local pointLight = nil

local function toggleLampu()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    if lampuOn then
        -- Matikan lampu
        if pointLight then
            pointLight:Destroy()
            pointLight = nil
        end
        btnLampu.Text = "Lampu"
        lampuOn = false
    else
        -- Nyalakan lampu
        if pointLight then
            pointLight:Destroy()
        end
        
        pointLight = Instance.new("PointLight")
        pointLight.Color = Color3.fromRGB(255, 255, 204)
        pointLight.Brightness = 5
        pointLight.Range = 100
        pointLight.Parent = hrp
        pointLight.Enabled = true
        
        btnLampu.Text = "Lampu (ON)"
        lampuOn = true
    end
end

btnLampu.MouseButton1Click:Connect(toggleLampu)

-- Pin Lokasi
btnPin.MouseButton1Click:Connect(function()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local p = hrp.Position
	local pos = string.format("%d,%d,%d", p.X, p.Y, p.Z)
	pcall(function() if setclipboard then setclipboard(pos) end end)
	btnPin.Text = "Pinned!"
	task.delay(1.2, function() btnPin.Text = "Pin Lokasi" end)
end)

-- Teleport (X,Y,Z)
local tpBox = Instance.new("TextBox")
tpBox.Size = UDim2.fromOffset(35, 25) -- Ukuran textbox 25x35
tpBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
tpBox.BackgroundTransparency = TEXTBOX_TRANSPARENCY
tpBox.PlaceholderText = "X,Y,Z"
tpBox.Font = Enum.Font.Gotham
tpBox.TextSize = 9
tpBox.TextColor3 = Color3.fromRGB(20,20,20)
tpBox.ClearTextOnFocus = false
tpBox.ZIndex = 60
tpBox.Parent = toolsGridHolder

local tpBoxCorner = Instance.new("UICorner")
tpBoxCorner.CornerRadius = UDim.new(0, CORNER)
tpBoxCorner.Parent = tpBox

btnTp.MouseButton1Click:Connect(function()
	local x,y,z = tpBox.Text:match("([^,]+),([^,]+),([^,]+)")
	x,y,z = tonumber(x), tonumber(y), tonumber(z)
	if x and y and z then
		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if hrp then hrp.CFrame = CFrame.new(x,y,z) end
	else
		btnTp.Text = "Invalid!"
		task.delay(1.2, function() btnTp.Text = "Teleport" end)
	end
end)
