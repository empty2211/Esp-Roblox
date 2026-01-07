local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local player=Players.LocalPlayer
local camera=workspace.CurrentCamera

local gui=Instance.new("ScreenGui",player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn=false

local menuBtn=Instance.new("TextButton",gui)
menuBtn.Size=UDim2.new(0,50,0,50)
menuBtn.Position=UDim2.new(0,20,0,200)
menuBtn.Text="≡"
menuBtn.Font=Enum.Font.GothamBold
menuBtn.TextSize=24
menuBtn.TextColor3=Color3.new(1,1,1)
menuBtn.BackgroundColor3=Color3.fromRGB(0,0,0)
menuBtn.BorderSizePixel=0
Instance.new("UICorner",menuBtn).CornerRadius=UDim.new(1,0)

local main=Instance.new("Frame",gui)
main.Size=UDim2.new(0,330,0,460)
main.Position=UDim2.new(0.5,-165,0.5,-230)
main.BackgroundColor3=Color3.fromRGB(0,0,0)
main.BorderSizePixel=0
main.Active=true
main.Draggable=true
main.Visible=false
Instance.new("UICorner",main).CornerRadius=UDim.new(0,10)

menuBtn.MouseButton1Click:Connect(function()
	main.Visible=not main.Visible
end)

UserInputService.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode==Enum.KeyCode.Q then
		main.Visible=not main.Visible
	end
end)

local top=Instance.new("Frame",main)
top.Size=UDim2.new(1,0,0,40)
top.BackgroundColor3=Color3.fromRGB(0,0,0)
top.BorderSizePixel=0

local function tabBtn(txt,pos)
	local b=Instance.new("TextButton",top)
	b.Size=UDim2.new(0.33,0,1,0)
	b.Position=UDim2.new(pos,0,0,0)
	b.Text=txt
	b.BackgroundColor3=Color3.fromRGB(15,15,15)
	b.TextColor3=Color3.new(1,1,1)
	return b
end

local espTab=tabBtn("ESP",0)
local tgtTab=tabBtn("TARGET",0.33)
local tpTab=tabBtn("TP",0.67)

local espC=Instance.new("Frame",main)
espC.Position=UDim2.new(0,0,0,40)
espC.Size=UDim2.new(1,0,1,-40)

local tgtC=espC:Clone()
tgtC.Parent=main
tgtC.Visible=false

local tpC=espC:Clone()
tpC.Parent=main
tpC.Visible=false

local function tab(t)
	espC.Visible=t=="ESP"
	tgtC.Visible=t=="TARGET"
	tpC.Visible=t=="TP"
end

espTab.MouseButton1Click:Connect(function()tab("ESP")end)
tgtTab.MouseButton1Click:Connect(function()tab("TARGET")end)
tpTab.MouseButton1Click:Connect(function()tab("TP")end)

local function mkBtn(p,y,txt)
	local b=Instance.new("TextButton",p)
	b.Size=UDim2.new(1,-20,0,36)
	b.Position=UDim2.new(0,10,0,y)
	b.Text=txt
	b.Font=Enum.Font.GothamBold
	b.TextSize=14
	b.TextColor3=Color3.new(1,1,1)
	b.BackgroundColor3=Color3.fromRGB(20,20,20)
	Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
	return b
end

local espEnabled=false
local showName=true
local showHP=true
local showDist=true
local showTeam=true
local espData={}

local espToggle=mkBtn(espC,10,"ESP: OFF")
local nameBtn=mkBtn(espC,56,"NAME: ON")
local hpBtn=mkBtn(espC,102,"HP: ON")
local distBtn=mkBtn(espC,148,"DISTANCE: ON")
local teamBtn=mkBtn(espC,194,"TEAM: ON")

espToggle.MouseButton1Click:Connect(function()
	espEnabled=not espEnabled
	espToggle.Text=espEnabled and "ESP: ON" or "ESP: OFF"
end)

nameBtn.MouseButton1Click:Connect(function()
	showName=not showName
	nameBtn.Text=showName and "NAME: ON" or "NAME: OFF"
end)

hpBtn.MouseButton1Click:Connect(function()
	showHP=not showHP
	hpBtn.Text=showHP and "HP: ON" or "HP: OFF"
end)

distBtn.MouseButton1Click:Connect(function()
	showDist=not showDist
	distBtn.Text=showDist and "DISTANCE: ON" or "DISTANCE: OFF"
end)

teamBtn.MouseButton1Click:Connect(function()
	showTeam=not showTeam
	teamBtn.Text=showTeam and "TEAM: ON" or "TEAM: OFF"
end)

local function clearESP()
	for _,v in pairs(espData) do
		if v.gui then v.gui:Destroy() end
	end
	table.clear(espData)
end

RunService.RenderStepped:Connect(function()
	if not espEnabled then
		clearESP()
		return
	end
	local myHRP=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			if not espData[p] then
				local g=Instance.new("BillboardGui")
				g.Size=UDim2.new(0,220,0,90)
				g.AlwaysOnTop=true
				local l=Instance.new("TextLabel",g)
				l.Size=UDim2.new(1,0,1,0)
				l.BackgroundTransparency=1
				l.Font=Enum.Font.GothamBold
				l.TextSize=14
				espData[p]={gui=g,label=l}
			end
			local d=espData[p]
			local clr=p.Team and p.Team.TeamColor.Color or Color3.new(1,1,1)
			d.label.TextColor3=clr
			local txt=""
			if showName then txt=txt..p.Name end
			if showTeam then txt=txt.."\n"..(p.Team and p.Team.Name or "NoTeam") end
			if showHP then
				local h=p.Character:FindFirstChildOfClass("Humanoid")
				if h then txt=txt.."\nHP: "..math.floor(h.Health) end
			end
			if showDist and myHRP then
				local dist=(p.Character.HumanoidRootPart.Position-myHRP.Position).Magnitude
				txt=txt.."\n"..math.floor(dist).."m"
			end
			d.label.Text=txt
			d.gui.Parent=p.Character.HumanoidRootPart
			d.gui.Adornee=p.Character.HumanoidRootPart
		end
	end
end)

local targetEnabled=false
local fov=200
local currentTarget=nil
local lastUpdate=0

local tgtToggle=mkBtn(tgtC,10,"TARGET: OFF")
local fovLbl=Instance.new("TextLabel",tgtC)
fovLbl.Position=UDim2.new(0,10,0,56)
fovLbl.Size=UDim2.new(1,-20,0,30)
fovLbl.Text="FOV: "..fov
fovLbl.TextColor3=Color3.new(1,1,1)
fovLbl.BackgroundTransparency=1
fovLbl.Font=Enum.Font.GothamBold

local fovCircle=Instance.new("Frame",gui)
fovCircle.Size=UDim2.new(0,fov*2,0,fov*2)
fovCircle.AnchorPoint=Vector2.new(0.5,0.5)
fovCircle.Position=UDim2.new(0.5,0,0.5,0)
fovCircle.BackgroundTransparency=1
fovCircle.Visible=false
local stroke=Instance.new("UIStroke",fovCircle)
stroke.Thickness=2
stroke.Color=Color3.fromRGB(255,60,60)
Instance.new("UICorner",fovCircle).CornerRadius=UDim.new(1,0)

local marker=Instance.new("BillboardGui")
marker.Size=UDim2.new(0,160,0,40)
marker.AlwaysOnTop=true
local ml=Instance.new("TextLabel",marker)
ml.Size=UDim2.new(1,0,1,0)
ml.BackgroundTransparency=1
ml.Font=Enum.Font.GothamBold
ml.TextSize=14
ml.TextColor3=Color3.fromRGB(255,60,60)

tgtToggle.MouseButton1Click:Connect(function()
	targetEnabled=not targetEnabled
	tgtToggle.Text=targetEnabled and "TARGET: ON" or "TARGET: OFF"
	fovCircle.Visible=targetEnabled
end)

local function findTarget()
	local center=Vector2.new(camera.ViewportSize.X/2,camera.ViewportSize.Y/2)
	local best=nil
	local bestDist=fov
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local pos,vis=camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
			if vis then
				local d=(Vector2.new(pos.X,pos.Y)-center).Magnitude
				if d<bestDist then
					bestDist=d
					best=p
				end
			end
		end
	end
	return best
end

RunService.RenderStepped:Connect(function(dt)
	if not targetEnabled then
		marker.Parent=nil
		return
	end
	lastUpdate=lastUpdate+dt
	if lastUpdate>=1 then
		lastUpdate=0
		currentTarget=findTarget()
	end
	if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
		local hrp=currentTarget.Character.HumanoidRootPart
		local dist=(hrp.Position-(player.Character and player.Character.HumanoidRootPart.Position or hrp.Position)).Magnitude
		ml.Text=currentTarget.Name.." | "..math.floor(dist).."m"
		marker.Parent=hrp
		marker.Adornee=hrp
	else
		marker.Parent=nil
	end
end)

local y=10
local function tpList()
	for _,c in ipairs(tpC:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	y=10
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=player then
			local b=Instance.new("TextButton",tpC)
			b.Size=UDim2.new(1,-20,0,30)
			b.Position=UDim2.new(0,10,0,y)
			b.Text=p.Name
			b.BackgroundColor3=Color3.fromRGB(20,20,20)
			b.TextColor3=Color3.new(1,1,1)
			b.MouseButton1Click:Connect(function()
				if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and player.Character then
					player.Character.HumanoidRootPart.CFrame=p.Character.HumanoidRootPart.CFrame+Vector3.new(0,3,0)
				end
			end)
			y=y+35
		end
	end
end

Players.PlayerAdded:Connect(tpList)
Players.PlayerRemoving:Connect(tpList)
tpList()
