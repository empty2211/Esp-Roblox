local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESP_TP_TargetHelper"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 450)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0,10)
mainCorner.Parent = mainFrame

local titleFrame = Instance.new("Frame")
titleFrame.Parent = mainFrame
titleFrame.Size = UDim2.new(1,0,0,35)
titleFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
titleFrame.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0,10)
titleCorner.Parent = titleFrame

local espTabBtn = Instance.new("TextButton")
espTabBtn.Parent = titleFrame
espTabBtn.Size = UDim2.new(0.33,0,1,0)
espTabBtn.Position = UDim2.new(0,0,0,0)
espTabBtn.Text = "ESP"
espTabBtn.BackgroundColor3 = Color3.fromRGB(60,120,255)
espTabBtn.TextColor3 = Color3.fromRGB(255,255,255)

local targetTabBtn = Instance.new("TextButton")
targetTabBtn.Parent = titleFrame
targetTabBtn.Size = UDim2.new(0.34,0,1,0)
targetTabBtn.Position = UDim2.new(0.33,0,0,0)
targetTabBtn.Text = "Target Helper"
targetTabBtn.BackgroundColor3 = Color3.fromRGB(80,80,90)
targetTabBtn.TextColor3 = Color3.fromRGB(200,200,200)

local tpTabBtn = Instance.new("TextButton")
tpTabBtn.Parent = titleFrame
tpTabBtn.Size = UDim2.new(0.33,0,1,0)
tpTabBtn.Position = UDim2.new(0.67,0,0,0)
tpTabBtn.Text = "Teleport"
tpTabBtn.BackgroundColor3 = Color3.fromRGB(80,80,90)
tpTabBtn.TextColor3 = Color3.fromRGB(200,200,200)

local espContainer = Instance.new("ScrollingFrame")
espContainer.Parent = mainFrame
espContainer.Size = UDim2.new(1,-10,1,-45)
espContainer.Position = UDim2.new(0,5,0,40)
espContainer.BackgroundTransparency = 1
espContainer.Visible = true

local targetContainer = Instance.new("Frame")
targetContainer.Parent = mainFrame
targetContainer.Size = UDim2.new(1,0,1,-45)
targetContainer.Position = UDim2.new(0,0,0,40)
targetContainer.BackgroundTransparency = 1
targetContainer.Visible = false

local tpContainer = Instance.new("Frame")
tpContainer.Parent = mainFrame
tpContainer.Size = UDim2.new(1,0,1,-45)
tpContainer.Position = UDim2.new(0,0,0,40)
tpContainer.BackgroundTransparency = 1
tpContainer.Visible = false

espTabBtn.MouseButton1Click:Connect(function()
    espContainer.Visible = true
    targetContainer.Visible = false
    tpContainer.Visible = false
end)
targetTabBtn.MouseButton1Click:Connect(function()
    espContainer.Visible = false
    targetContainer.Visible = true
    tpContainer.Visible = false
end)
tpTabBtn.MouseButton1Click:Connect(function()
    espContainer.Visible = false
    targetContainer.Visible = false
    tpContainer.Visible = true
end)

-- ESP
local espEnabled = true
local espObjects = {}

local function createESP(character)
    if not character or espObjects[character] then return end
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = character
    highlight.Parent = character
    espObjects[character] = highlight
end

local function updateESP()
    if not espEnabled then return end
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            createESP(otherPlayer.Character)
        end
    end
end

RunService.RenderStepped:Connect(updateESP)

-- Target Helper
local targetMarker = Instance.new("BillboardGui")
targetMarker.Size = UDim2.new(0,100,0,50)
targetMarker.AlwaysOnTop = true
local markerLabel = Instance.new("TextLabel")
markerLabel.Size = UDim2.new(1,0,1,0)
markerLabel.BackgroundTransparency = 1
markerLabel.TextColor3 = Color3.fromRGB(255,50,50)
markerLabel.Font = Enum.Font.GothamBold
markerLabel.TextSize = 14
markerLabel.Text = "Target"
markerLabel.Parent = targetMarker

local function findNearestEnemy()
    local nearest=nil
    local shortest=math.huge
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = player.Character.HumanoidRootPart.Position
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl~=player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (pl.Character.HumanoidRootPart.Position-myPos).Magnitude
            if dist<shortest then
                shortest=dist
                nearest=pl
            end
        end
    end
    return nearest
end

spawn(function()
    while true do
        if targetContainer.Visible then
            local target = findNearestEnemy()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                targetMarker.Adornee = target.Character.HumanoidRootPart
                targetMarker.Parent = target.Character.HumanoidRootPart
                markerLabel.Text = "Target\nVOF\nDist: "..math.floor((target.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude)
            else
                targetMarker.Parent = nil
            end
        end
        wait(1)
    end
end)

-- Teleport
local function updateTPList()
    for _, obj in ipairs(tpContainer:GetChildren()) do
        if obj:IsA("TextButton") then obj:Destroy() end
    end
    local yPos = 10
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl~=player then
            local btn = Instance.new("TextButton")
            btn.Parent = tpContainer
            btn.Size = UDim2.new(1,-10,0,30)
            btn.Position = UDim2.new(0,5,0,yPos)
            btn.Text = pl.Name
            btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.MouseButton1Click:Connect(function()
                local char = pl.Character
                if char and char:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    player.Character.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(0,3,0)
                end
            end)
            yPos=yPos+35
        end
    end
end

Players.PlayerAdded:Connect(updateTPList)
Players.PlayerRemoving:Connect(updateTPList)
updateTPList()

-- Драг кнопка для открытия меню
local menuBtn = Instance.new("TextButton")
menuBtn.Parent = screenGui
menuBtn.Size = UDim2.new(0,50,0,50)
menuBtn.Position = UDim2.new(0,10,0,435)
menuBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
menuBtn.Text = "Menu"
menuBtn.TextColor3 = Color3.new(1,1,1)
menuBtn.Font = Enum.Font.SourceSansBold
menuBtn.TextSize = 18
menuBtn.BorderSizePixel = 0
menuBtn.Active = true
menuBtn.ClipsDescendants = true

local dragging = false
local dragOffset = Vector2.new()

menuBtn.MouseButton1Down:Connect(function(x,y)
    dragging = true
    dragOffset = Vector2.new(x,y) - Vector2.new(menuBtn.AbsolutePosition.X, menuBtn.AbsolutePosition.Y)
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        menuBtn.Position = UDim2.new(0, input.Position.X - dragOffset.X, 0, input.Position.Y - dragOffset.Y)
    end
end)

menuBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)
