-- LocalScript - Teleport Bidik + Zoom First-Person + Tombol Kamera 5/15/30 stud (single button) 🌸

-- ===== THEME =====
local FRAME_TRANSPARENCY = 0.4
local TITLE_TRANSPARENCY = 0.2
local TEXTBOX_TRANSPARENCY = 0.2
local BUTTON_COLOR = Color3.fromRGB(0,120,255) -- tombol biru
local CLOSE_COLOR  = Color3.fromRGB(220,0,0)   -- close merah
local MINIM_COLOR  = Color3.fromRGB(0,180,0)   -- minimize hijau
local MINIM_ALPHA  = 0.5                       -- transparansi 0.5
local CORNER       = 8                         -- sudut sedikit melengkung
local DEFAULT_FOV  = 70

local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ===== ENV CHECK =====
local function getPlayerGui()
	local lp = Players.LocalPlayer
	if not lp then
		warn("[TeleportBidik] LocalPlayer nil. Pastikan ini LocalScript di StarterPlayerScripts/StarterGui dan jalankan dengan Play (F5), bukan Run.")
		return nil
	end
	local pg = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui", 10)
	if not pg then
		warn("[TeleportBidik] PlayerGui tidak ditemukan setelah 10 detik.")
		return nil
	end
	return pg
end

local playerGui = getPlayerGui()
if not playerGui then return end

local player  = Players.LocalPlayer
local cam     = workspace.CurrentCamera

-- Hapus GUI lama bila ada (anti duplikasi)
local OLD = playerGui:FindFirstChild("TeleportBidikZoomGUI")
if OLD then OLD:Destroy() end

-- ===== ROOT GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "TeleportBidikZoomGUI"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.DisplayOrder = 9999 -- top layer
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Enabled = true
gui.Parent = playerGui

-- ===== PANEL =====
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(280, 206) -- tinggi panel untuk tombol kamera
frame.Position = UDim2.new(0.5, -140, 0.5, -103)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = FRAME_TRANSPARENCY
frame.BorderSizePixel = 0
frame.Active = true
frame.ZIndex = 50
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, CORNER)

local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1,0,0,30)
titleBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
titleBar.BackgroundTransparency = TITLE_TRANSPARENCY
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 51
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, CORNER)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1,-90,1,0)
title.Position = UDim2.fromOffset(10,0)
title.BackgroundTransparency = 1
title.Text = "Teleport Bidik (Zoom)"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.ZIndex = 52

local function makeTopBtn(txt, col, xoff, alpha)
	local b = Instance.new("TextButton", titleBar)
	b.Size = UDim2.fromOffset(24,24)
	b.Position = UDim2.new(1, -xoff, 0, 3)
	b.BackgroundColor3 = col
	b.BackgroundTransparency = alpha or 0
	b.Text = txt
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.ZIndex = 60
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
	return b
end
local btnClose = makeTopBtn("×", CLOSE_COLOR, 28, 0)
local btnMin   = makeTopBtn("–", MINIM_COLOR, 56, MINIM_ALPHA)

-- Ikon minimize (kanan bawah)
local miniIcon = Instance.new("TextButton", gui)
miniIcon.Size = UDim2.fromOffset(25,25)
miniIcon.Position = UDim2.new(1,-35,1,-35)
miniIcon.BackgroundColor3 = MINIM_COLOR
miniIcon.BackgroundTransparency = MINIM_ALPHA
miniIcon.Text = "◙"
miniIcon.Font = Enum.Font.GothamBold
miniIcon.TextSize = 14
miniIcon.TextColor3 = Color3.new(1,1,1)
miniIcon.Visible = false
miniIcon.ZIndex = 70
Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(1,0)

btnMin.MouseButton1Click:Connect(function()
	frame.Visible=false; miniIcon.Visible=true
end)
miniIcon.MouseButton1Click:Connect(function()
	frame.Visible=true; miniIcon.Visible=false
end)

-- ===== DRAGGABLE (Mouse & Touch) =====
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
	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
		   input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos  = frame.Position
		end
	end)
	titleBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
		   input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		      or input.UserInputType == Enum.UserInputType.Touch) then
			updateDrag(input)
		end
	end)
end

-- ===== Controls =====
local function makeTB(parent, pos, w, h, placeholder, defaultText)
	local tb = Instance.new("TextBox", parent)
	tb.Size = UDim2.new(0,w,0,h)
	tb.Position = pos
	tb.BackgroundColor3 = Color3.fromRGB(255,255,255)
	tb.BackgroundTransparency = TEXTBOX_TRANSPARENCY
	tb.Font = Enum.Font.Gotham
	tb.TextSize = 12
	tb.TextColor3 = Color3.fromRGB(0,0,0)
	tb.PlaceholderText = placeholder
	tb.Text = defaultText or ""
	tb.ClearTextOnFocus = false
	tb.ZIndex = 55
	Instance.new("UICorner", tb).CornerRadius = UDim.new(0,6)
	return tb
end

local tbOffsetY = makeTB(frame, UDim2.fromOffset(10, 40), 120, 26, "Offset Y", "5")
local tbZoomFOV = makeTB(frame, UDim2.fromOffset(150, 40), 120, 26, "Zoom FOV", "20")

local btnAimTp = Instance.new("TextButton", frame)
btnAimTp.Size = UDim2.new(1,-20,0,28)
btnAimTp.Position = UDim2.fromOffset(10, 74)
btnAimTp.BackgroundColor3 = BUTTON_COLOR
btnAimTp.Text = "Teleport Bidik (Q)"
btnAimTp.Font = Enum.Font.GothamBold
btnAimTp.TextSize = 12
btnAimTp.TextColor3 = Color3.new(1,1,1)
btnAimTp.ZIndex = 55
Instance.new("UICorner", btnAimTp).CornerRadius = UDim.new(0,6)

local hint = Instance.new("TextLabel", frame)
hint.Size = UDim2.new(1,-20,0,34)
hint.Position = UDim2.fromOffset(10, 108)
hint.BackgroundTransparency = 1
hint.Text = "RMB tahan = ZOOM hold, Z = ZOOM toggle. Tombol di bawah berputar jarak 5→15→30 stud."
hint.Font = Enum.Font.Gotham
hint.TextSize = 11
hint.TextColor3 = Color3.new(1,1,1)
hint.TextWrapped = true
hint.TextXAlignment = Enum.TextXAlignment.Left
hint.ZIndex = 55

-- Tombol Kamera 3rd (single button, rotate 5/15/30)
local btnThird = Instance.new("TextButton", frame)
btnThird.Size = UDim2.new(1,-20,0,28)
btnThird.Position = UDim2.fromOffset(10, 144)
btnThird.BackgroundColor3 = BUTTON_COLOR
btnThird.Text = "Kamera 3rd (5 stud)"
btnThird.Font = Enum.Font.GothamBold
btnThird.TextSize = 12
btnThird.TextColor3 = Color3.new(1,1,1)
btnThird.ZIndex = 55
Instance.new("UICorner", btnThird).CornerRadius = UDim.new(0,6)

-- ===== Crosshair (di bawah panel) =====
local ZCROSS = 5
local function makeCross(a, b, pos)
	local f = Instance.new("Frame", gui)
	f.Size = UDim2.fromOffset(a,b)
	f.AnchorPoint = Vector2.new(0.5,0.5)
	f.Position = pos
	f.BackgroundColor3 = Color3.new(1,1,1)
	f.BorderSizePixel = 0
	f.ZIndex = ZCROSS
	return f
end
local crossCenter = makeCross(4,4, UDim2.new(0.5,0,0.5,0))
local hLine       = makeCross(20,2, UDim2.new(0.5,0,0.5,0))
local vLine       = makeCross(2,20, UDim2.new(0.5,0,0.5,0))

-- ===== Util: sembunyikan karakter saat zoom =====
local originalCameraMode, originalMinZoom, originalMaxZoom = nil, nil, nil
local originalFOV = nil
local origLTM = {}

local function hideCharacterLocal(hidden)
	local char = player.Character
	if not char then return end

	if hidden then
		if originalCameraMode == nil then
			originalCameraMode = player.CameraMode
			originalMinZoom = player.CameraMinZoomDistance
			originalMaxZoom = player.CameraMaxZoomDistance
		end
		player.CameraMode = Enum.CameraMode.Classic
		player.CameraMinZoomDistance = 0.5
		player.CameraMaxZoomDistance = 0.5
		UIS.MouseBehavior = Enum.MouseBehavior.LockCenter

		for _, d in ipairs(char:GetDescendants()) do
			if d:IsA("BasePart") then
				if origLTM[d] == nil then origLTM[d] = d.LocalTransparencyModifier end
				d.LocalTransparencyModifier = 1
				d.CastShadow = false
			end
		end
		local tool = char:FindFirstChildOfClass("Tool")
		if tool then
			for _, d in ipairs(tool:GetDescendants()) do
				if d:IsA("BasePart") then
					if origLTM[d] == nil then origLTM[d] = d.LocalTransparencyModifier end
					d.LocalTransparencyModifier = 1
					d.CastShadow = false
				end
			end
		end
	else
		for part, val in pairs(origLTM) do
			if part and part.Parent then
				part.LocalTransparencyModifier = val or 0
				part.CastShadow = true
			end
		end
		table.clear(origLTM)

		if originalCameraMode ~= nil then
			player.CameraMode = originalCameraMode
			player.CameraMinZoomDistance = originalMinZoom or player.CameraMinZoomDistance
			player.CameraMaxZoomDistance = originalMaxZoom or player.CameraMaxZoomDistance
			originalCameraMode, originalMinZoom, originalMaxZoom = nil, nil, nil
		end
		UIS.MouseBehavior = Enum.MouseBehavior.Default
	end
end

-- ===== Teleport Bidik =====
local function teleportToAim()
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local rayOrigin    = cam.CFrame.Position
	local rayDirection = cam.CFrame.LookVector * 1000
	local params       = RaycastParams.new()
	params.FilterDescendantsInstances = {char}
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
	if processed then return end
	if UIS:GetFocusedTextBox() then return end
	if input.KeyCode == Enum.KeyCode.Q then teleportToAim() end
end)

-- ===== Zoom Hold/Toggle + Restore =====
local zoomOn = false
local zoomTween
local rmbHeld = false
local zoomLocked = false

local function setZoom(nextState)
	-- saat masuk zoom pertama kali, simpan FOV asli
	if nextState and not zoomOn then
		originalFOV = cam.FieldOfView
	end

	zoomOn = nextState
	local targetFOV = zoomOn and math.clamp(tonumber(tbZoomFOV.Text) or 20, 5, 70) or (originalFOV or DEFAULT_FOV)

	if zoomTween then zoomTween:Cancel() end
	zoomTween = TweenService:Create(cam, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {FieldOfView = targetFOV})
	zoomTween:Play()

	hideCharacterLocal(zoomOn)

	if not zoomOn then originalFOV = nil end
end

-- RMB hold & Z toggle
UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		rmbHeld = true
		setZoom(true)
	elseif input.KeyCode == Enum.KeyCode.Z then
		if UIS:GetFocusedTextBox() then return end
		zoomLocked = not zoomLocked
		setZoom(zoomLocked or rmbHeld)
	end
end)
UIS.InputEnded:Connect(function(input, processed)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		rmbHeld = false
		setZoom(zoomLocked)
	end
end)

-- ===== Kamera 3rd: satu tombol, berputar 5→15→30 =====
local thirdDistances = {5, 15, 30}
local thirdIndex = 1

local function applyThirdPerson(distance)
	-- matikan semua status zoom
	zoomLocked = false
	rmbHeld = false
	if zoomOn then setZoom(false) else hideCharacterLocal(false) end

	-- set third-person di jarak tertentu
	player.CameraMode = Enum.CameraMode.Classic
	player.CameraMinZoomDistance = distance
	player.CameraMaxZoomDistance = distance
	UIS.MouseBehavior = Enum.MouseBehavior.Default

	-- FOV standar
	if zoomTween then zoomTween:Cancel() end
	cam.FieldOfView = DEFAULT_FOV

	-- update teks tombol agar terlihat jarak aktif
	btnThird.Text = ("Kamera 3rd (%d stud)"):format(distance)
end

-- inisialisasi ke 5 stud (sesuai teks awal)
applyThirdPerson(thirdDistances[thirdIndex])

btnThird.MouseButton1Click:Connect(function()
	thirdIndex = thirdIndex % #thirdDistances + 1
	applyThirdPerson(thirdDistances[thirdIndex])
end)

-- ===== Close =====
btnClose.MouseButton1Click:Connect(function()
	zoomLocked = false
	rmbHeld = false
	if zoomOn then setZoom(false) end
	gui:Destroy()
end)

-- ===== Respawn safety =====
Players.LocalPlayer.CharacterAdded:Connect(function()
	if zoomOn then
		task.defer(function()
			setZoom(zoomLocked or rmbHeld)
		end)
	end
end)
