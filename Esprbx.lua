local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Teams = game:GetService("Teams")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "FINAL_GUI"
gui.ResetOnSpawn = false

local menuBtn = Instance.new("TextButton", gui)
menuBtn.Size = UDim2.new(0,50,0,50)
menuBtn.Position = UDim2.new(0,20,0,200)
menuBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
menuBtn.Text = "≡"
menuBtn.TextColor3 = Color3.new(1,1,1)
menuBtn.Font = Enum.Font.GothamBold
menuBtn.TextSize = 24
menuBtn.BorderSizePixel = 0
menuBtn.Active = true
Instance.new("UICorner", menuBtn).CornerRadius = UDim.new(1,0)

local dragging, dragStart, startPos, dragInput = false

menuBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = menuBtn.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

menuBtn.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart
		menuBtn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
	end
end)

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0,320,0,420)
menu.Position = UDim2.new(0.5,-160,0.5,-210)
menu.BackgroundColor3 = Color3.fromRGB(0,0,0)
menu.BorderSizePixel = 0
menu.Visible = false
menu.Active = true
menu.Draggable = true
Instance.new("UICorner", menu).CornerRadius = UDim.new(0,12)

local function toggleMenu()
	menu.Visible = not menu.Visible
end

menuBtn.MouseButton1Click:Connect(toggleMenu)

UserInputService.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode == Enum.KeyCode.Q then
		toggleMenu()
	end
end)

local tabBar = Instance.new("Frame", menu)
tabBar.Size = UDim2.new(1,0,0,40)
tabBar.BackgroundColor3 = Color3.fromRGB(0,0,0)
tabBar.BorderSizePixel = 0

local function tabButton(text,pos)
	local b = Instance.new("TextButton", tabBar)
	b.Size = UDim2.new(0.33,0,1,0)
	b.Position = pos
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(20,20,20)
	b.BorderSizePixel = 0
	return b
end

local espTab = tabButton("ESP",UDim2.new(0,0,0,0))
local tgtTab = tabButton("Target",UDim2.new(0.33,0,0,0))
local tpTab  = tabButton("TP",UDim2.new(0.66,0,0,0))

local function container()
	local f = Instance.new("Frame", menu)
	f.Size = UDim2.new(1,0,1,-40)
	f.Position = UDim2.new(0,0,0,40)
	f.BackgroundTransparency = 1
	f.Visible = false
	return f
end

local espC = container()
local tgtC = container()
local tpC  = container()
espC.Visible = true

local function show(c)
	espC.Visible=false
	tgtC.Visible=false
	tpC.Visible=false
	c.Visible=true
end

espTab.MouseButton1Click:Connect(function() show(espC) end)
tgtTab.MouseButton1Click:Connect(function() show(tgtC) end)
tpTab.MouseButton1Click:Connect(function() show(tpC) end)

local toggles = {}
local function toggle(text,y)
	local b = Instance.new("TextButton", espC)
	b.Size = UDim2.new(1,-20,0,35)
	b.Position = UDim2.new(0,10,0,y)
	b.BackgroundColor3 = Color3.fromRGB(20,20,20)
	b.TextColor3 = Color3.new(1,1,1)
	b.Text = text..": ON"
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.BorderSizePixel = 0
	Instance.new("UICorner", b)
	toggles[text]=true
	b.MouseButton1Click:Connect(function()
		toggles[text]=not toggles[text]
		b.Text = text..": "..(toggles[text] and "ON" or "OFF")
	end)
end

toggle("Name",10)
toggle("Distance",55)
toggle("HP",100)
toggle("Team",145)

local espObjects = {}

local function teamColor(plr)
	if plr.Team and plr.Team.TeamColor then
		return plr.Team.TeamColor.Color
	end
	return Color3.new(1,1,1)
end

RunService.Heartbeat:Connect(function()
	for _,pl in ipairs(Players:GetPlayers()) do
		if pl~=player and pl.Character and pl.Character:FindFirstChild("Head") and pl.Character:FindFirstChild("HumanoidRootPart") then
			if not espObjects[pl] then
				local bb = Instance.new("BillboardGui", pl.Character.Head)
				bb.Size = UDim2.new(0,200,0,70)
				bb.AlwaysOnTop = true
				local t = Instance.new("TextLabel", bb)
				t.Size = UDim2.new(1,0,1,0)
				t.BackgroundTransparency = 1
				t.Font = Enum.Font.GothamBold
				t.TextSize = 14
				t.TextStrokeTransparency = 0.6
				espObjects[pl]={bb=bb,t=t}
			end
			local data = espObjects[pl]
			local txt=""
			if toggles.Name then txt=pl.Name.."\n" end
			if toggles.Distance then
				local d=(pl.Character.HumanoidRootPart.Position-player.Character.HumanoidRootPart.Position).Magnitude
				txt=txt..math.floor(d).."m\n"
			end
			if toggles.HP then
				local h=pl.Character:FindFirstChildOfClass("Humanoid")
				if h then txt=txt.."HP "..math.floor(h.Health).."\n" end
			end
			if toggles.Team then txt=txt.."["..(pl.Team and pl.Team.Name or "None").."]" end
			data.t.Text=txt
			data.t.TextColor3=teamColor(pl)
		end
	end
end)

local fov = 200
local fovCircle = Drawing.new("Circle")
fovCircle.Radius = fov
fovCircle.Color = Color3.fromRGB(255,0,0)
fovCircle.Thickness = 2
fovCircle.Filled = false

RunService.RenderStepped:Connect(function()
	fovCircle.Position = Vector2.new(camera.ViewportSize.X/2,camera.ViewportSize.Y/2)
	fovCircle.Visible = tgtC.Visible
end)

local targetLabel = Instance.new("TextLabel", tgtC)
targetLabel.Size = UDim2.new(1,0,0,40)
targetLabel.Position = UDim2.new(0,0,0,20)
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = Color3.new(1,0,0)
targetLabel.Font = Enum.Font.GothamBold
targetLabel.TextSize = 18

task.spawn(function()
	while task.wait(1) do
		if tgtC.Visible and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local nearest,dist=nil,fov
			for _,pl in ipairs(Players:GetPlayers()) do
				if pl~=player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
					local p,onscreen=camera:WorldToViewportPoint(pl.Character.HumanoidRootPart.Position)
					if onscreen then
						local d=(Vector2.new(p.X,p.Y)-Vector2.new(camera.ViewportSize.X/2,camera.ViewportSize.Y/2)).Magnitude
						if d<dist then
							dist=d
							nearest=pl
						end
					end
				end
			end
			targetLabel.Text = nearest and ("Target: "..nearest.Name) or "Target: none"
		end
	end
end)
