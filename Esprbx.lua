local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local isMobile = UserInputService.TouchEnabled
local isPC = UserInputService.KeyboardEnabled

local selectedPlayerForTP = nil
local espOn = false
local espPlayers = {}
local espSettings = {
    showDistance = true,
    showHealth = true,
    showName = true,
    teamColor = true,
    maxDistance = 15000
}
local keyBinds = {
    toggleMenu = Enum.KeyCode.F5,
    teleport = Enum.KeyCode.Q
}

local rebindingKey = nil

local gui = Instance.new("ScreenGui")
gui.Name = "SquirtMenu"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local branding = Instance.new("TextLabel")
branding.Name = "Brand"
branding.Size = UDim2.new(0, 120, 0, 30)
branding.Position = UDim2.new(1, -130, 0, 10)
branding.AnchorPoint = Vector2.new(1, 0)
branding.Text = "by Squirt"
branding.TextColor3 = Color3.fromRGB(29, 172, 214)
branding.BackgroundTransparency = 1
branding.Font = Enum.Font.GothamBold
branding.TextSize = 18
branding.TextStrokeTransparency = 0.6
branding.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
branding.Parent = gui

local openBtn = Instance.new("TextButton")
openBtn.Name = "OpenMenu"
openBtn.Size = UDim2.new(0, 40, 0, 40) 
openBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
openBtn.Text = "menu"
openBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
openBtn.BackgroundTransparency = 0.3
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.TextScaled = true
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 15
openBtn.Visible = true
openBtn.Parent = gui
openBtn.Active = true

local openBtnCorner = Instance.new("UICorner")
openBtnCorner.CornerRadius = UDim.new(1, 0) 
openBtnCorner.Parent = openBtn

local tpFloatingBtn = Instance.new("TextButton")
tpFloatingBtn.Name = "TPFloatingBtn"
tpFloatingBtn.Size = UDim2.new(0, 40, 0, 40) 
tpFloatingBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
tpFloatingBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tpFloatingBtn.BackgroundTransparency = 0.3
tpFloatingBtn.Text = "TP"
tpFloatingBtn.TextScaled = true
tpFloatingBtn.TextColor3 = Color3.new(1, 1, 1)
tpFloatingBtn.BorderSizePixel = 0
tpFloatingBtn.Parent = gui
tpFloatingBtn.Active = true
tpFloatingBtn.Visible = true

local tpFloatingCorner = Instance.new("UICorner")
tpFloatingCorner.CornerRadius = UDim.new(1, 0) 
tpFloatingCorner.Parent = tpFloatingBtn

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Parent = gui
if isMobile then
    frame.Size = UDim2.new(0.45, 0, 0.9, 0) 
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
else
    frame.Size = UDim2.new(0, 280, 0, 350)
    frame.Position = UDim2.new(0.5, -140, 0.5, -175)
end
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 150)
frame.Visible = false
frame.Active = true

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 15)
frameCorner.Parent = frame

local function toggleMenu()
    frame.Visible = not frame.Visible
end

openBtn.MouseButton1Click:Connect(toggleMenu)

local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Parent = frame
tabBar.Size = UDim2.new(1, 0, 0, 35)
tabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
tabBar.BorderSizePixel = 0

local tabBarCorner = Instance.new("UICorner")
tabBarCorner.CornerRadius = UDim.new(0, 10)
tabBarCorner.Parent = tabBar

local function tabBtn(txt, x, width)
    local b = Instance.new("TextButton")
    b.Parent = tabBar
    b.Size = UDim2.new(width or 0.333, 0, 1, 0)
    b.Position = UDim2.new(x, 0, 0, 0)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.TextSize = isMobile and 9 or 10
    b.TextScaled = true
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 8)
    bCorner.Parent = b
    
    return b
end

local espBtn = tabBtn("ESP", 0, 0.333)
local tpBtn = tabBtn("TP", 0.333, 0.333)
local bindBtn = tabBtn("BINDS", 0.666, 0.334)

local espC = Instance.new("ScrollingFrame")
espC.Name = "ESPContainer"
espC.Parent = frame
espC.Size = UDim2.new(1, 0, 1, -35)
espC.Position = UDim2.new(0, 0, 0, 35)
espC.BackgroundTransparency = 1
espC.Visible = true
espC.ScrollBarThickness = 4
espC.CanvasSize = UDim2.new(0, 0, 0, 0)
espC.AutomaticCanvasSize = Enum.AutomaticSize.Y

local tpC = Instance.new("ScrollingFrame")
tpC.Name = "TPContainer"
tpC.Parent = frame
tpC.Size = UDim2.new(1, 0, 1, -35)
tpC.Position = UDim2.new(0, 0, 0, 35)
tpC.BackgroundTransparency = 1
tpC.Visible = false
tpC.ScrollBarThickness = 4
tpC.CanvasSize = UDim2.new(0, 0, 0, 0)
tpC.AutomaticCanvasSize = Enum.AutomaticSize.Y

local bindC = Instance.new("ScrollingFrame")
bindC.Name = "BindsContainer"
bindC.Parent = frame
bindC.Size = UDim2.new(1, 0, 1, -35)
bindC.Position = UDim2.new(0, 0, 0, 35)
bindC.BackgroundTransparency = 1
bindC.Visible = false
bindC.ScrollBarThickness = 4
bindC.CanvasSize = UDim2.new(0, 0, 0, 0)
bindC.AutomaticCanvasSize = Enum.AutomaticSize.Y

local function show(c)
    espC.Visible = false
    tpC.Visible = false
    bindC.Visible = false
    c.Visible = true
end

espBtn.MouseButton1Click:Connect(function() 
    show(espC) 
    espBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
    tpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    bindBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
end)

tpBtn.MouseButton1Click:Connect(function() 
    show(tpC) 
    tpBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
    espBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    bindBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
end)

bindBtn.MouseButton1Click:Connect(function() 
    show(bindC) 
    bindBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
    espBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    tpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
end)

espBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)

local yPosition = 10
local espToggle = Instance.new("TextButton")
espToggle.Name = "ESPToggle"
espToggle.Parent = espC
espToggle.Size = UDim2.new(1, -20, 0, isMobile and 55 or 40)
espToggle.Position = UDim2.new(0, 10, 0, yPosition)
espToggle.Text = "ESP OFF"
espToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
espToggle.BackgroundTransparency = 0.1
espToggle.TextColor3 = Color3.new(1, 1, 1)
espToggle.BorderSizePixel = 0
espToggle.Font = Enum.Font.GothamBold
espToggle.TextSize = isMobile and 9 or 10
espToggle.TextScaled = true

local espToggleCorner = Instance.new("UICorner")
espToggleCorner.CornerRadius = UDim.new(0, 8)
espToggleCorner.Parent = espToggle

yPosition = yPosition + (isMobile and 60 or 45)

local distanceToggle = Instance.new("TextButton")
distanceToggle.Name = "DistanceToggle"
distanceToggle.Parent = espC
distanceToggle.Size = UDim2.new(1, -20, 0, isMobile and 50 or 35)
distanceToggle.Position = UDim2.new(0, 10, 0, yPosition)
distanceToggle.Text = "Дистанция: ВКЛ"
distanceToggle.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
distanceToggle.BackgroundTransparency = 0.1
distanceToggle.TextColor3 = Color3.new(1, 1, 1)
distanceToggle.BorderSizePixel = 0
distanceToggle.Font = Enum.Font.Gotham
distanceToggle.TextSize = isMobile and 11 or 13
distanceToggle.TextScaled = true

local distanceCorner = Instance.new("UICorner")
distanceCorner.CornerRadius = UDim.new(0, 8)
distanceCorner.Parent = distanceToggle

yPosition = yPosition + (isMobile and 55 or 40)

local healthToggle = Instance.new("TextButton")
healthToggle.Name = "HealthToggle"
healthToggle.Parent = espC
healthToggle.Size = UDim2.new(1, -20, 0, isMobile and 50 or 35)
healthToggle.Position = UDim2.new(0, 10, 0, yPosition)
healthToggle.Text = "Здоровье: ВКЛ"
healthToggle.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
healthToggle.BackgroundTransparency = 0.1
healthToggle.TextColor3 = Color3.new(1, 1, 1)
healthToggle.BorderSizePixel = 0
healthToggle.Font = Enum.Font.Gotham
healthToggle.TextSize = isMobile and 11 or 13
healthToggle.TextScaled = true

local healthCorner = Instance.new("UICorner")
healthCorner.CornerRadius = UDim.new(0, 8)
healthCorner.Parent = healthToggle

yPosition = yPosition + (isMobile and 55 or 40)

local nameToggle = Instance.new("TextButton")
nameToggle.Name = "NameToggle"
nameToggle.Parent = espC
nameToggle.Size = UDim2.new(1, -20, 0, isMobile and 50 or 35)
nameToggle.Position = UDim2.new(0, 10, 0, yPosition)
nameToggle.Text = "Никнейм: ВКЛ"
nameToggle.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
nameToggle.BackgroundTransparency = 0.1
nameToggle.TextColor3 = Color3.new(1, 1, 1)
nameToggle.BorderSizePixel = 0
nameToggle.Font = Enum.Font.Gotham
nameToggle.TextSize = isMobile and 11 or 13
nameToggle.TextScaled = true

local nameCorner = Instance.new("UICorner")
nameCorner.CornerRadius = UDim.new(0, 8)
nameCorner.Parent = nameToggle

yPosition = yPosition + (isMobile and 55 or 40)

local teamToggle = Instance.new("TextButton")
teamToggle.Name = "TeamToggle"
teamToggle.Parent = espC
teamToggle.Size = UDim2.new(1, -20, 0, isMobile and 50 or 35)
teamToggle.Position = UDim2.new(0, 10, 0, yPosition)
teamToggle.Text = "Команды: ВКЛ"
teamToggle.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
teamToggle.BackgroundTransparency = 0.1
teamToggle.TextColor3 = Color3.new(1, 1, 1)
teamToggle.BorderSizePixel = 0
teamToggle.Font = Enum.Font.Gotham
teamToggle.TextSize = isMobile and 11 or 13
teamToggle.TextScaled = true

local teamCorner = Instance.new("UICorner")
teamCorner.CornerRadius = UDim.new(0, 8)
teamCorner.Parent = teamToggle

distanceToggle.MouseButton1Click:Connect(function()
    espSettings.showDistance = not espSettings.showDistance
    distanceToggle.Text = "Дистанция: " .. (espSettings.showDistance and "ВКЛ" or "ВЫКЛ")
    distanceToggle.BackgroundColor3 = espSettings.showDistance and Color3.fromRGB(60, 120, 255) or Color3.fromRGB(45, 45, 60)
end)

healthToggle.MouseButton1Click:Connect(function()
    espSettings.showHealth = not espSettings.showHealth
    healthToggle.Text = "Здоровье: " .. (espSettings.showHealth and "ВКЛ" or "ВЫКЛ")
    healthToggle.BackgroundColor3 = espSettings.showHealth and Color3.fromRGB(60, 120, 255) or Color3.fromRGB(45, 45, 60)
end)

nameToggle.MouseButton1Click:Connect(function()
    espSettings.showName = not espSettings.showName
    nameToggle.Text = "Никнейм: " .. (espSettings.showName and "ВКЛ" or "ВЫКЛ")
    nameToggle.BackgroundColor3 = espSettings.showName and Color3.fromRGB(60, 120, 255) or Color3.fromRGB(45, 45, 60)
end)

teamToggle.MouseButton1Click:Connect(function()
    espSettings.teamColor = not espSettings.teamColor
    teamToggle.Text = "Команды: " .. (espSettings.teamColor and "ВКЛ" or "ВЫКЛ")
    teamToggle.BackgroundColor3 = espSettings.teamColor and Color3.fromRGB(60, 120, 255) or Color3.fromRGB(45, 45, 60)
end)

local function updatePlayerList()
    for _, child in ipairs(tpC:GetChildren()) do
        if child.Name == "PlayerButton" then
            child:Destroy()
        end
    end
    
    local yPosTP = 10
    
    local playerListLabel = Instance.new("TextLabel")
    playerListLabel.Parent = tpC
    playerListLabel.Size = UDim2.new(1, -20, 0, isMobile and 35 or 25)
    playerListLabel.Position = UDim2.new(0, 10, 0, yPosTP)
    playerListLabel.Text = "Select Player:"
    playerListLabel.TextColor3 = Color3.new(1, 1, 1)
    playerListLabel.BackgroundTransparency = 1
    playerListLabel.Font = Enum.Font.GothamBold
    playerListLabel.TextSize = isMobile and 9 or 11
    playerListLabel.TextScaled = true
    playerListLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    yPosTP = yPosTP + (isMobile and 40 or 30)
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local playerBtn = Instance.new("TextButton")
            playerBtn.Name = "PlayerButton"
            playerBtn.Parent = tpC
            playerBtn.Size = UDim2.new(1, -20, 0, isMobile and 45 or 35)
            playerBtn.Position = UDim2.new(0, 10, 0, yPosTP)
            playerBtn.Text = plr.Name
            playerBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            playerBtn.TextColor3 = Color3.new(1, 1, 1)
            playerBtn.Font = Enum.Font.Gotham
            playerBtn.TextSize = isMobile and 11 or 13
            playerBtn.TextScaled = true
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = playerBtn
            
            playerBtn.MouseButton1Click:Connect(function()
                selectedPlayerForTP = plr
                for _, btn in ipairs(tpC:GetChildren()) do
                    if btn.Name == "PlayerButton" then
                        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
                    end
                end
                playerBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
                
                local shortName = plr.Name
                if #shortName > 6 then
                    shortName = string.sub(shortName, 1, 4) .. ".."
                end
                tpFloatingBtn.Text = shortName
                tpFloatingBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
            end)
            
            yPosTP = yPosTP + (isMobile and 50 or 40)
        end
    end
    
    local toolBtn = Instance.new("TextButton")
    toolBtn.Name = "TPToolButton"
    toolBtn.Parent = tpC
    toolBtn.Size = UDim2.new(1, -20, 0, isMobile and 50 or 40)
    toolBtn.Position = UDim2.new(0, 10, 0, yPosTP)
    toolBtn.Text = "Create TP Tool"
    toolBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
    toolBtn.BackgroundTransparency = 0.1
    toolBtn.TextColor3 = Color3.new(1, 1, 1)
    toolBtn.Font = Enum.Font.GothamBold
    toolBtn.TextSize = isMobile and 12 or 14
    toolBtn.TextScaled = true
    
    local toolBtnCorner = Instance.new("UICorner")
    toolBtnCorner.CornerRadius = UDim.new(0, 8)
    toolBtnCorner.Parent = toolBtn
    
    toolBtn.MouseButton1Click:Connect(function()
        local mouse = player:GetMouse()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "tp @SquirtMenu"
        tool.Activated:Connect(function()
            local pos = mouse.Hit + Vector3.new(0, 2.5, 0)
            pos = CFrame.new(pos.X, pos.Y, pos.Z)
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = pos
                showNotification("Teleported!", 1)
            end
        end)
        
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            local existingTool = backpack:FindFirstChild("tp @SquirtMenu")
            if existingTool then
                existingTool:Destroy()
            end
            tool.Parent = backpack
            showNotification("TP Tool created in backpack!", 2)
        else
            showNotification("Backpack not found!", 2)
        end
    end)
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function(plr)
    if selectedPlayerForTP == plr then
        selectedPlayerForTP = nil
        tpFloatingBtn.Text = "TP"
        tpFloatingBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    end
    updatePlayerList()
end)
updatePlayerList()

local function teleportToPlayer(targetPlayer)
    if not targetPlayer then
        return false, "No player selected"
    end
    
    local targetChar = targetPlayer.Character
    local localChar = player.Character
    
    if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then
        return false, "Target has no character"
    end
    
    if not localChar or not localChar:FindFirstChild("HumanoidRootPart") then
        return false, "You have no character"
    end
    
    local humanoid = localChar:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
    end
    
    localChar.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame
    return true, "Teleported to " .. targetPlayer.Name
end

tpFloatingBtn.MouseButton1Click:Connect(function()
    local success, message = teleportToPlayer(selectedPlayerForTP)
    if success then
        showNotification(message, 1)
    else
        showNotification(message, 2)
    end
end)

local yPosBinds = 10

local function createKeybindButton(keyName, displayName, currentKey, yPosition)
    local keybindFrame = Instance.new("Frame")
    keybindFrame.Name = keyName .. "Frame"
    keybindFrame.Parent = bindC
    keybindFrame.Size = UDim2.new(1, -20, 0, isMobile and 45 or 35)
    keybindFrame.Position = UDim2.new(0, 10, 0, yPosition)
    keybindFrame.BackgroundTransparency = 1
    
    local keybindLabel = Instance.new("TextLabel")
    keybindLabel.Name = "Label"
    keybindLabel.Parent = keybindFrame
    keybindLabel.Size = UDim2.new(0.6, 0, 1, 0)
    keybindLabel.Position = UDim2.new(0, 0, 0, 0)
    keybindLabel.Text = displayName .. ":"
    keybindLabel.TextColor3 = Color3.new(1, 1, 1)
    keybindLabel.BackgroundTransparency = 1
    keybindLabel.Font = Enum.Font.Gotham
    keybindLabel.TextSize = isMobile and 11 or 13
    keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local keybindBtn = Instance.new("TextButton")
    keybindBtn.Name = "KeyButton"
    keybindBtn.Parent = keybindFrame
    keybindBtn.Size = UDim2.new(0.35, 0, 0.8, 0)
    keybindBtn.Position = UDim2.new(0.6, 0, 0.1, 0)
    keybindBtn.Text = tostring(currentKey):gsub("Enum.KeyCode.", "")
    keybindBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
    keybindBtn.BackgroundTransparency = 0.1
    keybindBtn.TextColor3 = Color3.new(1, 1, 1)
    keybindBtn.Font = Enum.Font.GothamBold
    keybindBtn.TextSize = isMobile and 10 or 12
    
    local keybindCorner = Instance.new("UICorner")
    keybindCorner.CornerRadius = UDim.new(0, 6)
    keybindCorner.Parent = keybindBtn
    
    keybindBtn.MouseButton1Click:Connect(function()
        rebindingKey = keyName
        keybindBtn.Text = "Press a key..."
        keybindBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 60)
    end)
    
    return keybindBtn
end

local menuKeyBtn = createKeybindButton("toggleMenu", "Toggle Menu", keyBinds.toggleMenu, yPosBinds)
yPosBinds = yPosBinds + (isMobile and 50 or 40)

local teleportKeyBtn = createKeybindButton("teleport", "Teleport", keyBinds.teleport, yPosBinds)
yPosBinds = yPosBinds + (isMobile and 50 or 40)

local instructionLabel = Instance.new("TextLabel")
instructionLabel.Parent = bindC
instructionLabel.Size = UDim2.new(1, -20, 0, isMobile and 60 or 40)
instructionLabel.Position = UDim2.new(0, 10, 0, yPosBinds)
instructionLabel.Text = "Click a key button and press any key to rebind. Press ESC to cancel."
instructionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
instructionLabel.BackgroundTransparency = 1
instructionLabel.Font = Enum.Font.Gotham
instructionLabel.TextSize = isMobile and 10 or 12
instructionLabel.TextWrapped = true
instructionLabel.TextXAlignment = Enum.TextXAlignment.Left

local function createESP(plr)

    if espPlayers[plr] then
        removeESP(plr)
    end
    
    espPlayers[plr] = {
        billboard = nil,
        text = nil,
        char = nil,
        hrp = nil,
        hum = nil,
        connections = {}
    }
    
    local function setupCharacterESP(character)
        if not character or not espOn then return end
        
        task.wait(1)
        
        if not character or not character:IsDescendantOf(workspace) then return end
        
        local hrp = character:WaitForChild("HumanoidRootPart", 3)
        local hum = character:WaitForChild("Humanoid", 3)
        
        if not hrp or not hum then return end
        
        if espPlayers[plr] and espPlayers[plr].billboard then
            espPlayers[plr].billboard:Destroy()
        end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_" .. plr.Name
        billboard.Size = UDim2.new(0, 200, 0, 100)
        billboard.Adornee = hrp
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
        billboard.MaxDistance = espSettings.maxDistance
        billboard.Parent = gui
        
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = plr.Name
        text.TextColor3 = Color3.fromRGB(255, 255, 255)
        text.Font = Enum.Font.GothamBold
        text.TextSize = 16
        text.TextStrokeTransparency = 0.3
        text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        text.TextYAlignment = Enum.TextYAlignment.Top
        text.Parent = billboard
        
        espPlayers[plr].billboard = billboard
        espPlayers[plr].text = text
        espPlayers[plr].char = character
        espPlayers[plr].hrp = hrp
        espPlayers[plr].hum = hum
    end
    
    if plr.Character then
        setupCharacterESP(plr.Character)
    end
    
    local characterAddedConnection = plr.CharacterAdded:Connect(function(character)
        if espOn then
            setupCharacterESP(character)
        end
    end)
    
    local characterRemovingConnection = plr.CharacterRemoving:Connect(function()
        if espPlayers[plr] then
            if espPlayers[plr].billboard then
                espPlayers[plr].billboard.Enabled = false
            end
        end
    end)
    
    table.insert(espPlayers[plr].connections, characterAddedConnection)
    table.insert(espPlayers[plr].connections, characterRemovingConnection)
end

local function removeESP(plr)
    if espPlayers[plr] then
        if espPlayers[plr].connections then
            for _, connection in ipairs(espPlayers[plr].connections) do
                connection:Disconnect()
            end
        end
        
        if espPlayers[plr].billboard then
            espPlayers[plr].billboard:Destroy()
        end
        
        espPlayers[plr] = nil
    end
end

local function updateESPForAllPlayers()
    if not espOn then return end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and not espPlayers[plr] then
            createESP(plr)
        end
    end
end

espToggle.MouseButton1Click:Connect(function()
    espOn = not espOn
    espToggle.Text = espOn and "ESP ON" or "ESP OFF"
    espToggle.BackgroundColor3 = espOn and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(45, 45, 60)
    
    if espOn then
        updateESPForAllPlayers()
        showNotification("ESP enabled", 2)
    else
        for plr, _ in pairs(espPlayers) do
            removeESP(plr)
        end
        espPlayers = {}
        showNotification("ESP disabled", 2)
    end
end)

RunService.RenderStepped:Connect(function()
    if not espOn then return end
    
    local localChar = player.Character
    local localHrp = localChar and localChar:FindFirstChild("HumanoidRootPart")
    
    for plr, data in pairs(espPlayers) do
        if not Players:FindFirstChild(plr.Name) then
            removeESP(plr)
            return
        end
        
        local char = plr.Character
        if not char then
            if data.billboard then
                data.billboard.Enabled = false
            end
            return
        end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            if data.billboard then
                data.billboard.Enabled = false
            end
            return
        end
        
        local hum = char:FindFirstChild("Humanoid")
        
        if data.billboard and not data.billboard.Enabled then
            data.billboard.Enabled = true
        end
        
        if data.billboard then
            data.billboard.Adornee = hrp
        end
        
        if data.text then
            local textParts = {}
            
            if espSettings.showName then
                table.insert(textParts, plr.Name)
            end
            
            if hum and espSettings.showHealth and hum.MaxHealth > 0 then
                local health = math.floor(hum.Health)
                local maxHealth = math.floor(hum.MaxHealth)
                local healthPercent = health / maxHealth
                
                local healthColor = Color3.fromRGB(0, 255, 0)
                if healthPercent < 0.5 then
                    healthColor = Color3.fromRGB(255, 255, 0)
                end
                if healthPercent < 0.25 then
                    healthColor = Color3.fromRGB(255, 0, 0)
                end
                
                table.insert(textParts, "hp " .. health .. "/" .. maxHealth)
            end
            
            if espSettings.showDistance and localHrp and hrp then
                local distance = math.floor((hrp.Position - localHrp.Position).Magnitude)
                table.insert(textParts, " м" .. distance .. "m")
            end
            
            data.text.Text = table.concat(textParts, "\n")
            
            if espSettings.teamColor then
                local team = plr.Team
                if team then
                    data.text.TextColor3 = team.TeamColor.Color
                else
                    data.text.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            else
                data.text.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    if espOn and plr ~= player then
        createESP(plr)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if espPlayers[plr] then
        removeESP(plr)
    end
end)

local function showNotification(message, duration)
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    if isMobile then
        notification.Size = UDim2.new(0.8, 0, 0, 50)
    else
        notification.Size = UDim2.new(0, 280, 0, 45)
    end
    notification.Position = UDim2.new(0.5, 0, 1, -80)
    notification.AnchorPoint = Vector2.new(0.5, 1)
    notification.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    notification.BackgroundTransparency = 0.1
    notification.BorderSizePixel = 2
    notification.BorderColor3 = Color3.fromRGB(0, 255, 150)
    notification.Parent = gui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notification
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -20, 1, -10)
    notifText.Position = UDim2.new(0, 10, 0, 5)
    notifText.BackgroundTransparency = 1
    notifText.Text = message
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.Font = Enum.Font.Gotham
    notifText.TextSize = isMobile and 12 or 14
    notifText.TextScaled = true
    notifText.TextWrapped = true
    notifText.Parent = notification
    
    notification.Position = UDim2.new(0.5, 0, 1, 60)
    TweenService:Create(notification, TweenInfo.new(0.3), {Position = UDim2.new(0.5, 0, 1, -80)}):Play()
    
    if not duration then
        duration = 2.0
    end
    
    task.delay(duration, function()
        if notification and notification.Parent then
            local tween = TweenService:Create(notification, TweenInfo.new(0.2), {Position = UDim2.new(0.5, 0, 1, 60)})
            tween:Play()
            tween.Completed:Connect(function()
                if notification and notification.Parent then
                    notification:Destroy()
                end
            end)
        end
    end)
end

local function updateKeyDisplay()
    menuKeyBtn.Text = tostring(keyBinds.toggleMenu):gsub("Enum.KeyCode.", "")
    teleportKeyBtn.Text = tostring(keyBinds.teleport):gsub("Enum.KeyCode.", "")
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if rebindingKey then
        if input.KeyCode == Enum.KeyCode.Escape then
            rebindingKey = nil
            updateKeyDisplay()
            showNotification("Key rebind cancelled", 1)
            return
        end
        
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            keyBinds[rebindingKey] = input.KeyCode
            rebindingKey = nil
            updateKeyDisplay()
            showNotification("Key bind updated!", 1)
        end
        return
    end
    
    if input.KeyCode == keyBinds.toggleMenu then
        toggleMenu()
    elseif input.KeyCode == keyBinds.teleport then
        local success, message = teleportToPlayer(selectedPlayerForTP)
        showNotification(message, 1)
    end
end)

if isMobile then
    local draggingBtn = nil
    local dragStart
    local startPos
    
    local function makeDraggable(button)
        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                draggingBtn = button
                dragStart = input.Position
                startPos = button.Position
            end
        end)
        
        button.InputChanged:Connect(function(input)
            if draggingBtn == button and input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                           startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        
        button.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                draggingBtn = nil
            end
        end)
    end
    
    makeDraggable(openBtn)
    makeDraggable(tpFloatingBtn)
end

showNotification("Squirt Menu loaded! Press " .. tostring(keyBinds.toggleMenu):gsub("Enum.KeyCode.", "") .. " to open menu", 3)

updateKeyDisplay()
