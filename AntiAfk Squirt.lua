local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

local enabled = false
local startTime = 0
local lastAction = os.clock()
local nextDelay = math.random(35,120)
local lastNotify = 0
local logs = {}
local idleStart = nil

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "AntiAFK_GUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.3,0.35)
frame.Position = UDim2.fromScale(0.35,0.3)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.15)
title.Text = "Anti AFK Squirt"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1

local toggle = Instance.new("TextButton", frame)
toggle.Position = UDim2.fromScale(0.1,0.18)
toggle.Size = UDim2.fromScale(0.8,0.15)
toggle.Text = "OFF"
toggle.Font = Enum.Font.GothamBold
toggle.TextScaled = true
toggle.BackgroundColor3 = Color3.fromRGB(150,50,50)
toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,10)

local timerLabel = Instance.new("TextLabel", frame)
timerLabel.Position = UDim2.fromScale(0.1,0.35)
timerLabel.Size = UDim2.fromScale(0.8,0.1)
timerLabel.Text = "⏱ 00:00:00"
timerLabel.TextColor3 = Color3.fromRGB(200,200,200)
timerLabel.Font = Enum.Font.Gotham
timerLabel.TextScaled = true
timerLabel.BackgroundTransparency = 1

local logBox = Instance.new("TextLabel", frame)
logBox.Position = UDim2.fromScale(0.05,0.48)
logBox.Size = UDim2.fromScale(0.9,0.47)
logBox.TextWrapped = true
logBox.TextYAlignment = Enum.TextYAlignment.Top
logBox.TextXAlignment = Enum.TextXAlignment.Left
logBox.TextColor3 = Color3.fromRGB(180,180,180)
logBox.Font = Enum.Font.Code
logBox.TextSize = 14
logBox.BackgroundColor3 = Color3.fromRGB(15,15,15)
logBox.BorderSizePixel = 0
Instance.new("UICorner", logBox).CornerRadius = UDim.new(0,8)

local mobileBtn = Instance.new("TextButton", gui)
mobileBtn.Size = UDim2.fromScale(0.12,0.07)
mobileBtn.Position = UDim2.fromScale(0.85,0.6)
mobileBtn.Text = "AFK"
mobileBtn.Font = Enum.Font.GothamBold
mobileBtn.TextScaled = true
mobileBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
mobileBtn.TextColor3 = Color3.new(1,1,1)
mobileBtn.Active = true
mobileBtn.Draggable = true
Instance.new("UICorner", mobileBtn).CornerRadius = UDim.new(1,0)

local function notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Anti-AFK",
            Text = txt,
            Duration = 3
        })
    end)
end

local function log(msg)
    table.insert(logs, os.date("[%H:%M:%S] ") .. msg)
    if #logs > 8 then table.remove(logs,1) end
    logBox.Text = table.concat(logs,"\n")
end

local function formatTime(sec)
    return string.format("%02d:%02d:%02d",
        math.floor(sec/3600),
        math.floor(sec%3600/60),
        sec%60
    )
end

local function setState(state)
    enabled = state
    if enabled then
        startTime = os.time()
        toggle.Text = "ON"
        toggle.BackgroundColor3 = Color3.fromRGB(50,150,50)
        mobileBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
        log("Anti-AFK ENABLED")
        notify("Anti-AFK включён")
    else
        toggle.Text = "OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(150,50,50)
        mobileBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
        log("Anti-AFK DISABLED")
        notify("Anti-AFK выключен")
    end
end

toggle.MouseButton1Click:Connect(function()
    setState(not enabled)
end)
mobileBtn.MouseButton1Click:Connect(function()
    setState(not enabled)
end)

UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.F6 then
        setState(not enabled)
    end
end)

local function randf(a,b) return a + math.random()*(b-a) end

local function isMoving()
    if not player.Character then return false end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    return hrp.Velocity.Magnitude > 0.1
end

local function humanAction()
    local cam = workspace.CurrentCamera
    local action = math.random(1,4)
    if action == 1 then
        cam.CFrame *= CFrame.Angles(0, math.rad(randf(-0.2,0.2)), 0)
    elseif action == 2 then
        cam.CFrame *= CFrame.Angles(math.rad(randf(-0.15,0.15)),0,0)
    elseif action == 3 then
        local old = cam.FieldOfView
        cam.FieldOfView = old + randf(-1,1)
        task.delay(0.2,function() cam.FieldOfView = old end)
    elseif action == 4 then
        task.wait(randf(0.05,0.2))
    end
end

RunService.Heartbeat:Connect(function()
    if not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if isMoving() then
        idleStart = nil
        if enabled then
            enabled = false
            toggle.Text = "OFF"
            toggle.BackgroundColor3 = Color3.fromRGB(150,50,50)
            mobileBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
            log("Player moving → Anti-AFK OFF")
        end
    else
        if not idleStart then
            idleStart = os.time()
        elseif os.time() - idleStart >= 60 then
            if not enabled then
                enabled = true
                startTime = os.time()
                toggle.Text = "ON"
                toggle.BackgroundColor3 = Color3.fromRGB(50,150,50)
                mobileBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
                log("Player idle ≥1 min → Anti-AFK ON")
            end
        end
    end

    if enabled then
        if os.clock() - lastAction >= nextDelay then
            lastAction = os.clock()
            nextDelay = math.random(40,120)
            humanAction()
            log("Smart activity ("..nextDelay.."s)")
            if os.time() - lastNotify > 180 then
                lastNotify = os.time()
                notify("AFK предотвращён")
            end
        end

        local elapsed = os.time() - startTime
        timerLabel.Text = "⏱ "..formatTime(elapsed)
    end
end)

log("GUI loaded | F6 / Mobile Button | Anti-Detect ACTIVE")
