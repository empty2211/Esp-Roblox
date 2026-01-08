local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local player=Players.LocalPlayer
local camera=workspace.CurrentCamera

local gui=Instance.new("ScreenGui",player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn=false

local openBtn=Instance.new("TextButton",gui)
openBtn.Size=UDim2.new(0,50,0,50)
openBtn.Position=UDim2.new(0,20,0,200)
openBtn.Text="≡"
openBtn.BackgroundColor3=Color3.fromRGB(0,0,0)
openBtn.TextColor3=Color3.new(1,1,1)
openBtn.BorderSizePixel=0
openBtn.Active=true
openBtn.Draggable=true
Instance.new("UICorner",openBtn)

local frame=Instance.new("Frame",gui)
frame.Size=UDim2.new(0,360,0,480)
frame.Position=UDim2.new(0.5,-180,0.5,-240)
frame.BackgroundColor3=Color3.fromRGB(0,0,0)
frame.Visible=false
frame.Active=true
frame.Draggable=true
Instance.new("UICorner",frame)

openBtn.MouseButton1Click:Connect(function()
	frame.Visible=not frame.Visible
end)

UserInputService.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode==Enum.KeyCode.Q then
		frame.Visible=not frame.Visible
	end
end)

local tabBar=Instance.new("Frame",frame)
tabBar.Size=UDim2.new(1,0,0,40)
tabBar.BackgroundTransparency=1

local function tabBtn(txt,x)
	local b=Instance.new("TextButton",tabBar)
	b.Size=UDim2.new(0.33,0,1,0)
	b.Position=UDim2.new(x,0,0,0)
	b.Text=txt
	b.BackgroundColor3=Color3.fromRGB(20,20,20)
	b.TextColor3=Color3.new(1,1,1)
	b.BorderSizePixel=0
	return b
end

local espBtn=tabBtn("ESP",0)
local tgtBtn=tabBtn("Target",0.33)
local tpBtn=tabBtn("TP",0.66)

local espC=Instance.new("Frame",frame)
local tgtC=Instance.new("Frame",frame)
local tpC=Instance.new("Frame",frame)
for _,c in ipairs({espC,tgtC,tpC}) do
	c.Size=UDim2.new(1,0,1,-40)
	c.Position=UDim2.new(0,0,0,40)
	c.BackgroundTransparency=1
	c.Visible=false
end
espC.Visible=true

local function show(c)
	espC.Visible=false
	tgtC.Visible=false
	tpC.Visible=false
	c.Visible=true
end

espBtn.MouseButton1Click:Connect(function()show(espC)end)
tgtBtn.MouseButton1Click:Connect(function()show(tgtC)end)
tpBtn.MouseButton1Click:Connect(function()show(tpC)end)

local espOn=false
local espMap={}

local function makeESP(char,plr)
	if espMap[char] then return end
	local h=Instance.new("Highlight",char)
	h.FillTransparency=0.85
	h.OutlineTransparency=0
	h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
	h.FillColor=plr.TeamColor.Color
	espMap[char]=h
end

RunService.RenderStepped:Connect(function()
	if not espOn then return end
	for _,pl in ipairs(Players:GetPlayers()) do
		if pl~=player and pl.Character then
			makeESP(pl.Character,pl)
		end
	end
end)

local espToggle=Instance.new("TextButton",espC)
espToggle.Size=UDim2.new(1,-20,0,40)
espToggle.Position=UDim2.new(0,10,0,10)
espToggle.Text="ESP OFF"
espToggle.BackgroundColor3=Color3.fromRGB(20,20,20)
espToggle.TextColor3=Color3.new(1,1,1)
espToggle.BorderSizePixel=0
Instance.new("UICorner",espToggle)

espToggle.MouseButton1Click:Connect(function()
	espOn=not espOn
	espToggle.Text=espOn and "ESP ON" or "ESP OFF"
	if not espOn then
		for _,h in pairs(espMap) do h:Destroy() end
		espMap={}
	end
end)

local marker=Instance.new("BillboardGui")
marker.Size=UDim2.new(0,120,0,50)
marker.AlwaysOnTop=true
local ml=Instance.new("TextLabel",marker)
ml.Size=UDim2.new(1,0,1,0)
ml.BackgroundTransparency=1
ml.TextColor3=Color3.new(1,0,0)
ml.Font=Enum.Font.GothamBold
ml.TextSize=14

local lastTarget=nil
local acc=0

RunService.RenderStepped:Connect(function(dt)
	acc+=dt
	if acc<1 then return end
	acc=0
	if not tgtC.Visible then
		marker.Parent=nil
		return
	end
	local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local best,dist=nil,math.huge
	for _,pl in ipairs(Players:GetPlayers()) do
		if pl~=player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
			local d=(pl.Character.HumanoidRootPart.Position-hrp.Position).Magnitude
			if d<dist then
				dist=d
				best=pl
			end
		end
	end
	if best then
		marker.Parent=best.Character.HumanoidRootPart
		ml.Text=best.Name.." ["..math.floor(dist).."]"
	end
end)

local function giveTool()
	if player.Backpack:FindFirstChild("tp @SVERHNOVACOLA") then return end
	local tool=Instance.new("Tool")
	tool.Name="tp @SVERHNOVACOLA"
	tool.RequiresHandle=false
	tool.Activated:Connect(function()
		local char=player.Character
		if not char then return end
		local hrp=char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		local ray=workspace:Raycast(
			camera.CFrame.Position,
			camera.CFrame.LookVector*1000,
			RaycastParams.new()
		)
		if ray and ray.Position.Y>-5 then
			hrp.CFrame=CFrame.new(ray.Position+Vector3.new(0,2.5,0))
		end
	end)
	tool.Parent=player.Backpack
end

local y=10
local give=Instance.new("TextButton",tpC)
give.Size=UDim2.new(1,-20,0,40)
give.Position=UDim2.new(0,10,0,y)
give.Text="Give TP Tool"
give.BackgroundColor3=Color3.fromRGB(20,20,20)
give.TextColor3=Color3.new(1,1,1)
give.BorderSizePixel=0
Instance.new("UICorner",give)
give.MouseButton1Click:Connect(giveTool)
y+=50

local function rebuildTP()
	for _,v in ipairs(tpC:GetChildren()) do
		if v:IsA("TextButton") and v~=give then v:Destroy() end
	end
	local y2=y
	for _,pl in ipairs(Players:GetPlayers()) do
		if pl~=player then
			local b=Instance.new("TextButton",tpC)
			b.Size=UDim2.new(1,-20,0,35)
			b.Position=UDim2.new(0,10,0,y2)
			b.Text="TP above "..pl.Name
			b.BackgroundColor3=Color3.fromRGB(20,20,20)
			b.TextColor3=Color3.new(1,1,1)
			b.BorderSizePixel=0
			Instance.new("UICorner",b)
			b.MouseButton1Click:Connect(function()
				if player.Character and pl.Character then
					local a=player.Character:FindFirstChild("HumanoidRootPart")
					local t=pl.Character:FindFirstChild("HumanoidRootPart")
					if a and t then
						a.CFrame=t.CFrame*CFrame.new(0,5,0)
					end
				end
			end)
			y2+=40
		end
	end
end

Players.PlayerAdded:Connect(rebuildTP)
Players.PlayerRemoving:Connect(rebuildTP)
rebuildTP()
