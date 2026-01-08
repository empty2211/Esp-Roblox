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

-- Меню
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 450)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0,10)
mainCorner.Parent = mainFrame

-- Вкладки
local titleFrame = Instance.new("Frame")
titleFrame.Parent = mainFrame
titleFrame.Size = UDim2.new(1,0,0,35)
titleFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
titleFrame.BorderSizePixel = 0

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
targetTabBtn.Text = "Target"
targetTabBtn.BackgroundColor3 = Color3.fromRGB(80,80,90)
targetTabBtn.TextColor3 = Color3.fromRGB(200,200,200)

local tpTabBtn = Instance.new("TextButton")
tpTabBtn.Parent = titleFrame
tpTabBtn.Size = UDim2.new(0.33,0,1,0)
tpTabBtn.Position = UDim2.new(0.67,0,0,0)
tpTabBtn.Text = "Teleport"
tpTabBtn.BackgroundColor3 = Color3.fromRGB(80,80,90)
tpTabBtn.TextColor3 = Color3.fromRGB(200,200,200)

-- Контейнеры
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

-- Драг кнопка меню
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

-- Брендинг (плавающий)
local branding = Instance.new("TextLabel")
branding.Parent = screenGui
branding.Text = "by @SVERHNOVACOLA"
branding.TextColor3 = Color3.fromRGB(255,255,255)
branding.BackgroundTransparency = 1
branding.Font = Enum.Font.GothamBold
branding.TextSize = 18
branding.Position = UDim2.new(0.5, -75, 0.1, 0)

local velocity = Vector2.new(3,3)
local screenSize = workspace.CurrentCamera.ViewportSize
RunService.RenderStepped:Connect(function()
    local pos = branding.Position
    local x = pos.X.Offset + velocity.X
    local y = pos.Y.Offset + velocity.Y

    if x <= 0 or x >= screenSize.X - branding.TextBounds.X then
        velocity = Vector2.new(-velocity.X, velocity.Y)
        x = math.clamp(x, 0, screenSize.X - branding.TextBounds.X)
    end
    if y <= 0 or y >= screenSize.Y - branding.TextBounds.Y then
        velocity = Vector2.new(velocity.X, -velocity.Y)
        y = math.clamp(y, 0, screenSize.Y - branding.TextBounds.Y)
    end

    branding.Position = UDim2.new(0, x, 0, y)
end)
