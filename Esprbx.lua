-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Проверка устройства
local isMobile = UserInputService.TouchEnabled
local isPC = UserInputService.KeyboardEnabled
local showButtons = isMobile

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SquirtMenu"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- ===== ОПОВЕЩЕНИЕ ПРИ ЗАПУСКЕ =====
local startupNotification = Instance.new("Frame")
startupNotification.Name = "StartupNotification"
startupNotification.Size = UDim2.new(0.8, 0, 0, 250)
startupNotification.Position = UDim2.new(0.1, 0, 0.1, 0)
startupNotification.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
startupNotification.BackgroundTransparency = 0.05
startupNotification.BorderSizePixel = 2
startupNotification.BorderColor3 = Color3.fromRGB(0, 255, 0)
startupNotification.Parent = gui

local startupCorner = Instance.new("UICorner")
startupCorner.CornerRadius = UDim.new(0, 15)
startupCorner.Parent = startupNotification

local startupTitle = Instance.new("TextLabel")
startupTitle.Name = "Title"
startupTitle.Size = UDim2.new(1, 0, 0, 50)
startupTitle.Position = UDim2.new(0, 0, 0, 0)
startupTitle.BackgroundTransparency = 1
startupTitle.Text = "🚀 Squirt Menu - Инструкция 🚀"
startupTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
startupTitle.Font = Enum.Font.GothamBold
startupTitle.TextSize = 18
startupTitle.TextStrokeTransparency = 0.7
startupTitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
startupTitle.Parent = startupNotification

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0, 2)
divider.Position = UDim2.new(0.05, 0, 0, 50)
divider.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
divider.BorderSizePixel = 0
divider.Parent = startupNotification

local dividerCorner = Instance.new("UICorner")
dividerCorner.CornerRadius = UDim.new(1, 0)
dividerCorner.Parent = divider

local startupText = Instance.new("TextLabel")
startupText.Name = "Text"
startupText.Size = UDim2.new(1, -40, 0, 140)
startupText.Position = UDim2.new(0, 20, 0, 60)
startupText.BackgroundTransparency = 1
startupText.Text = "🇷🇺 Русский:\n• Нажмите F5 для открытия/закрытия меню\n• Нажмите Q для телепортации к выбранному игроку\n• Круглая кнопка телепортирует вас к выбранному игроку (выбирается в настройках)\n\n🇬🇧 English:\n• Press F5 to open/close the menu\n• Press Q to teleport to selected player\n• Round button teleports you to selected player (select in settings)"
startupText.TextColor3 = Color3.fromRGB(220, 220, 220)
startupText.Font = Enum.Font.Gotham
startupText.TextSize = 14
startupText.TextXAlignment = Enum.TextXAlignment.Left
startupText.TextYAlignment = Enum.TextYAlignment.Top
startupText.TextWrapped = true
startupText.Parent = startupNotification

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0.6, 0, 0, 35)
closeBtn.Position = UDim2.new(0.2, 0, 1, -45)
closeBtn.Text = "Понятно / Got it"
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = startupNotification

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Анимация появления оповещения
startupNotification.BackgroundTransparency = 1
startupTitle.TextTransparency = 1
divider.BackgroundTransparency = 1
startupText.TextTransparency = 1
closeBtn.BackgroundTransparency = 1
closeBtn.TextTransparency = 1

local fadeIn = TweenService:Create(startupNotification, TweenInfo.new(0.5), {BackgroundTransparency = 0.05})
local textFadeIn = TweenService:Create(startupTitle, TweenInfo.new(0.5), {TextTransparency = 0})
local dividerFadeIn = TweenService:Create(divider, TweenInfo.new(0.5), {BackgroundTransparency = 0})
local textFadeIn2 = TweenService:Create(startupText, TweenInfo.new(0.5), {TextTransparency = 0})
local btnFadeIn = TweenService:Create(closeBtn, TweenInfo.new(0.5), {BackgroundTransparency = 0, TextTransparency = 0})

fadeIn:Play()
task.wait(0.1)
textFadeIn:Play()
task.wait(0.1)
dividerFadeIn:Play()
textFadeIn2:Play()
btnFadeIn:Play()

-- Закрытие оповещения
closeBtn.MouseButton1Click:Connect(function()
    local fadeOut = TweenService:Create(startupNotification, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    local textFadeOut = TweenService:Create(startupTitle, TweenInfo.new(0.5), {TextTransparency = 1})
    local dividerFadeOut = TweenService:Create(divider, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    local textFadeOut2 = TweenService:Create(startupText, TweenInfo.new(0.5), {TextTransparency = 1})
    local btnFadeOut = TweenService:Create(closeBtn, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1})
    
    fadeOut:Play()
    textFadeOut:Play()
    dividerFadeOut:Play()
    textFadeOut2:Play()
    btnFadeOut:Play()
    
    fadeOut.Completed:Connect(function()
        startupNotification:Destroy()
    end)
end)

-- Автоматическое закрытие через 20 секунд
task.delay(20, function()
    if startupNotification and startupNotification.Parent then
        closeBtn:Fire("MouseButton1Click")
    end
end)

-- ===== ФУНКЦИЯ ДЛЯ УВЕДОМЛЕНИЙ =====
local function showNotification(message, duration)
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 50)
    notification.Position = UDim2.new(0.5, -150, 1, -100)
    notification.AnchorPoint = Vector2.new(0.5, 1)
    notification.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
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
    notifText.TextSize = 14
    notifText.TextWrapped = true
    notifText.Parent = notification
    
    notification.Position = UDim2.new(0.5, -150, 1, 60)
    TweenService:Create(notification, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 1, -100)}):Play()
    
    -- Разные длительности для разных типов уведомлений
    if not duration then
        -- Если уведомление о телепортации - 1 секунда, для остальных - 2 секунды
        if message:find("Teleported") or message:find("Selected:") or message:find("Cannot teleport") or message:find("No player selected") then
            duration = 1.0
        else
            duration = 2.0
        end
    end
    
    task.delay(duration, function()
        if notification and notification.Parent then
            TweenService:Create(notification, TweenInfo.new(0.2), {Position = UDim2.new(0.5, -150, 1, 60)}):Play()
            task.wait(0.2)
            notification:Destroy()
        end
    end)
end

-- Брендинг "by Squirt"
local branding = Instance.new("TextLabel")
branding.Name = "Brand"
branding.Size = UDim2.new(0, 120, 0, 30)
branding.Position = UDim2.new(1, -130, 0, 10)
branding.AnchorPoint = Vector2.new(1, 0)
branding.Text = "by Squirt"
branding.TextColor3 = Color3.fromRGB(0, 255, 0)
branding.BackgroundTransparency = 1
branding.Font = Enum.Font.GothamBold
branding.TextSize = 18
branding.TextStrokeTransparency = 0.6
branding.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
branding.Parent = gui

-- Кнопка открытия главного меню
local openBtn = Instance.new("TextButton")
openBtn.Name = "OpenMenu"
openBtn.Size = UDim2.new(0.05, 0, 0.114, 0)
openBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
openBtn.Text = "Menu"
openBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
openBtn.BackgroundTransparency = 0.5
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.TextScaled = true
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 20
openBtn.Visible = true
openBtn.Parent = gui
openBtn.Active = true

local openBtnCorner = Instance.new("UICorner")
openBtnCorner.CornerRadius = UDim.new(1, 0)
openBtnCorner.Parent = openBtn

-- Главное меню
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Parent = gui
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 0
frame.Visible = false
frame.Active = true

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

-- Функция для управления видимостью меню
local function toggleMenu()
    frame.Visible = not frame.Visible
end

openBtn.MouseButton1Up:Connect(toggleMenu)

-- Таб кнопок
local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Parent = frame
tabBar.Size = UDim2.new(1, 0, 0, 40)
tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabBar.BorderSizePixel = 0

local tabBarCorner = Instance.new("UICorner")
tabBarCorner.CornerRadius = UDim.new(0, 10)
tabBarCorner.Parent = tabBar

local function tabBtn(txt, x)
    local b = Instance.new("TextButton")
    b.Parent = tabBar
    b.Size = UDim2.new(0.5, 0, 1, 0)
    b.Position = UDim2.new(x, 0, 0, 0)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 8)
    bCorner.Parent = b
    
    return b
end

local espBtn = tabBtn("ESP", 0)
local tpBtn = tabBtn("TP", 0.5)

local espC = Instance.new("ScrollingFrame")
espC.Name = "ESPContainer"
espC.Parent = frame
espC.Size = UDim2.new(1, 0, 1, -40)
espC.Position = UDim2.new(0, 0, 0, 40)
espC.BackgroundTransparency = 1
espC.Visible = true
espC.ScrollBarThickness = 5
espC.CanvasSize = UDim2.new(0, 0, 0, 0)
espC.AutomaticCanvasSize = Enum.AutomaticSize.Y

local tpC = Instance.new("ScrollingFrame")
tpC.Name = "TPContainer"
tpC.Parent = frame
tpC.Size = UDim2.new(1, 0, 1, -40)
tpC.Position = UDim2.new(0, 0, 0, 40)
tpC.BackgroundTransparency = 1
tpC.Visible = false
tpC.ScrollBarThickness = 5
tpC.CanvasSize = UDim2.new(0, 0, 0, 0)
tpC.AutomaticCanvasSize = Enum.AutomaticSize.Y

local function show(c)
    espC.Visible = false
    tpC.Visible = false
    c.Visible = true
end

espBtn.MouseButton1Click:Connect(function() 
    show(espC) 
    espBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
    tpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

tpBtn.MouseButton1Click:Connect(function() 
    show(tpC) 
    tpBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
    espBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

espBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)

-- ===== ESP СИСТЕМА С НАСТРОЙКАМИ =====
local espOn = false
local espPlayers = {}
local espSettings = {
    showDistance = true,
    showHealth = true,
    showName = true,
    teamColor = true,
    maxDistance = 10000 -- Максимальная дистанция 10,000 метров
}

-- Основная кнопка ESP
local yPosition = 10
local espToggle = Instance.new("TextButton")
espToggle.Name = "ESPToggle"
espToggle.Parent = espC
espToggle.Size = UDim2.new(1, -20, 0, 45)
espToggle.Position = UDim2.new(0, 10, 0, yPosition)
espToggle.Text = "ESP OFF"
espToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
espToggle.BackgroundTransparency = 0.1
espToggle.TextColor3 = Color3.new(1, 1, 1)
espToggle.BorderSizePixel = 0
espToggle.Font = Enum.Font.GothamBold
espToggle.TextSize = 16

local espToggleCorner = Instance.new("UICorner")
espToggleCorner.CornerRadius = UDim.new(0, 8)
espToggleCorner.Parent = espToggle

yPosition = yPosition + 55

-- Кнопка включения/выключения отображения дистанции
local distanceToggle = Instance.new("TextButton")
distanceToggle.Name = "DistanceToggle"
distanceToggle.Parent = espC
distanceToggle.Size = UDim2.new(1, -20, 0, 40)
distanceToggle.Position = UDim2.new(0, 10, 0, yPosition)
distanceToggle.Text = "Дистанция: ВКЛ"
distanceToggle.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
distanceToggle.BackgroundTransparency = 0.1
distanceToggle.TextColor3 = Color3.new(1, 1, 1)
distanceToggle.BorderSizePixel = 0
distanceToggle.Font = Enum.Font.Gotham
distanceToggle.TextSize = 14

local distanceCorner = Instance.new("UICorner")
distanceCorner.CornerRadius = UDim.new(0, 8)
distanceCorner.Parent = distanceToggle

yPosition = yPosition + 45

-- Кнопка включения/выключения отображения здоровья
local healthToggle = Instance.new("TextButton")
healthToggle.Name = "HealthToggle"
healthToggle.Parent = espC
healthToggle.Size = UDim2.new(1, -20, 0, 40)
healthToggle.Position = UDim2.new(0, 10, 0, yPosition)
healthToggle.Text = "Здоровье: ВКЛ"
healthToggle.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
healthToggle.BackgroundTransparency = 0.1
healthToggle.TextColor3 = Color3.new(1, 1, 1)
healthToggle.BorderSizePixel = 0
healthToggle.Font = Enum.Font.Gotham
healthToggle.TextSize = 14

local healthCorner = Instance.new("UICorner")
healthCorner.CornerRadius = UDim.new(0, 8)
healthCorner.Parent = healthToggle

yPosition = yPosition + 45

-- Кнопка включения/выключения отображения ника
local nameToggle = Instance.new("TextButton")
nameToggle.Name = "NameToggle"
nameToggle.Parent = espC
nameToggle.Size = UDim2.new(1, -20, 0, 40)
nameToggle.Position = UDim2.new(0, 10, 0, yPosition)
nameToggle.Text = "Никнейм: ВКЛ"
nameToggle.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
nameToggle.BackgroundTransparency = 0.1
nameToggle.TextColor3 = Color3.new(1, 1, 1)
nameToggle.BorderSizePixel = 0
nameToggle.Font = Enum.Font.Gotham
nameToggle.TextSize = 14

local nameCorner = Instance.new("UICorner")
nameCorner.CornerRadius = UDim.new(0, 8)
nameCorner.Parent = nameToggle

yPosition = yPosition + 45

-- Кнопка включения/выключения цветов по командам
local teamToggle = Instance.new("TextButton")
teamToggle.Name = "TeamToggle"
teamToggle.Parent = espC
teamToggle.Size = UDim2.new(1, -20, 0, 40)
teamToggle.Position = UDim2.new(0, 10, 0, yPosition)
teamToggle.Text = "Команды: ВКЛ"
teamToggle.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
teamToggle.BackgroundTransparency = 0.1
teamToggle.TextColor3 = Color3.new(1, 1, 1)
teamToggle.BorderSizePixel = 0
teamToggle.Font = Enum.Font.Gotham
teamToggle.TextSize = 14

local teamCorner = Instance.new("UICorner")
teamCorner.CornerRadius = UDim.new(0, 8)
teamCorner.Parent = teamToggle

-- Обработчики для кнопок настроек
distanceToggle.MouseButton1Click:Connect(function()
    espSettings.showDistance = not espSettings.showDistance
    distanceToggle.Text = "Дистанция: " .. (espSettings.showDistance and "ВКЛ" or "ВЫКЛ")
    distanceToggle.BackgroundColor3 = espSettings.showDistance and Color3.fromRGB(60, 120, 255) or Color3.fromRGB(45, 45, 55)
end)

healthToggle.MouseButton1Click:Connect(function()
    espSettings.showHealth = not espSettings.showHealth
    healthToggle.Text = "Здоровье: " .. (espSettings.showHealth and "ВКЛ" or "ВЫКЛ")
    healthToggle.BackgroundColor3 = espSettings.showHealth and Color3.fromRGB(60, 120, 255) or Color3.fromRGB(45, 45
