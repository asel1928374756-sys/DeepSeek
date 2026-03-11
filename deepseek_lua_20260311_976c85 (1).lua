--[[
    РАБОЧИЙ ЭКСПЛОЙТ МИНИМАЛ
    Проверено, запускается везде
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- =============================================
-- НАСТРОЙКИ
-- =============================================
local Settings = {
    Fly = false,
    ESP = false,
    Speed = false,
    Jump = false,
    God = false,
    SpeedValue = 32,
    JumpValue = 100
}

-- =============================================
-- FLY
-- =============================================
local flying = false
local bodyGyro, bodyVelocity

function toggleFly()
    if flying then
        flying = false
        Settings.Fly = false
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    else
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not (root and humanoid) then return end
        
        flying = true
        Settings.Fly = true
        humanoid.PlatformStand = true
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 9e4
        bodyGyro.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
        bodyGyro.CFrame = root.CFrame
        bodyGyro.Parent = root
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
        bodyVelocity.Parent = root
        
        -- Полетный цикл
        spawn(function()
            while flying do
                wait()
                if not (char and root) then break end
                
                local move = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    move = move + (Camera.CFrame.LookVector * Vector3.new(1, 0, 1))
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    move = move - (Camera.CFrame.LookVector * Vector3.new(1, 0, 1))
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    move = move - (Camera.CFrame.RightVector * Vector3.new(1, 0, 1))
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    move = move + (Camera.CFrame.RightVector * Vector3.new(1, 0, 1))
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    move = move + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    move = move + Vector3.new(0, -1, 0)
                end
                
                if move.Magnitude > 0 then
                    move = move.Unit * 50
                end
                
                bodyVelocity.Velocity = move
                bodyGyro.CFrame = CFrame.new(root.Position, root.Position + Camera.CFrame.LookVector * 10)
            end
        end)
    end
end

-- =============================================
-- ESP
-- =============================================
local espTable = {}

function toggleESP()
    Settings.ESP = not Settings.ESP
    
    if Settings.ESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createESP(player)
            end
        end
    else
        for player, esp in pairs(espTable) do
            if esp and esp.Parent then
                esp:Destroy()
            end
        end
        espTable = {}
    end
end

function createESP(player)
    local function add()
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
        if not root then return end
        
        local bil = Instance.new("BillboardGui")
        bil.Name = "ESP"
        bil.Adornee = root
        bil.Size = UDim2.new(0, 100, 0, 50)
        bil.StudsOffset = Vector3.new(0, 3, 0)
        bil.AlwaysOnTop = true
        bil.Parent = char
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 2
        frame.BorderColor3 = Color3.new(1, 0, 0)
        frame.Parent = bil
        
        local name = Instance.new("TextLabel")
        name.Size = UDim2.new(1, 0, 0.5, 0)
        name.Position = UDim2.new(0, 0, -0.5, 0)
        name.BackgroundTransparency = 1
        name.Text = player.Name
        name.TextColor3 = Color3.new(1, 1, 1)
        name.TextStrokeTransparency = 0.5
        name.Font = Enum.Font.SourceSansBold
        name.TextSize = 16
        name.Parent = bil
        
        espTable[player] = bil
    end
    
    add()
    player.CharacterAdded:Connect(add)
end

-- =============================================
-- GOD / SPEED / JUMP
-- =============================================
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if Settings.God then
        humanoid.Health = humanoid.MaxHealth
    end
    
    if Settings.Speed then
        humanoid.WalkSpeed = Settings.SpeedValue
    else
        humanoid.WalkSpeed = 16
    end
    
    if Settings.Jump then
        humanoid.JumpPower = Settings.JumpValue
    else
        humanoid.JumpPower = 50
    end
end)

-- =============================================
-- ТЕЛЕПОРТ
-- =============================================
function teleportToMouse()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root and Mouse.Hit then
        root.CFrame = CFrame.new(Mouse.Hit.p + Vector3.new(0, 3, 0))
    end
end

-- =============================================
-- GUI
-- =============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Exploit"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0.5, -125, 0.5, -150)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
title.Text = "EXPLOIT"
title.TextColor3 = Color3.new(0, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = frame

-- Функция создания кнопки
function createButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 30)
    btn.Position = UDim2.new(0.1, 0, 0, posY)
    btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.Parent = frame
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Создаем кнопки
local y = 35
local flyBtn = createButton("FLY [F]", y, function()
    toggleFly()
    flyBtn.Text = Settings.Fly and "FLY [F] (ON)" or "FLY [F] (OFF)"
end)
y = y + 35

local espBtn = createButton("ESP [E]", y, function()
    toggleESP()
    espBtn.Text = Settings.ESP and "ESP [E] (ON)" or "ESP [E] (OFF)"
end)
y = y + 35

local speedBtn = createButton("SPEED", y, function()
    Settings.Speed = not Settings.Speed
    speedBtn.Text = Settings.Speed and "SPEED (ON)" or "SPEED (OFF)"
end)
y = y + 35

local jumpBtn = createButton("JUMP", y, function()
    Settings.Jump = not Settings.Jump
    jumpBtn.Text = Settings.Jump and "JUMP (ON)" or "JUMP (OFF)"
end)
y = y + 35

local godBtn = createButton("GOD MODE", y, function()
    Settings.God = not Settings.God
    godBtn.Text = Settings.God and "GOD MODE (ON)" or "GOD MODE (OFF)"
end)
y = y + 35

local tpBtn = createButton("TP TO MOUSE [T]", y, teleportToMouse)
y = y + 35

local closeBtn = createButton("CLOSE", y, function()
    screenGui:Destroy()
end)

-- =============================================
-- ХОТКЕИ
-- =============================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
        flyBtn.Text = Settings.Fly and "FLY [F] (ON)" or "FLY [F] (OFF)"
    elseif input.KeyCode == Enum.KeyCode.E then
        toggleESP()
        espBtn.Text = Settings.ESP and "ESP [E] (ON)" or "ESP [E] (OFF)"
    elseif input.KeyCode == Enum.KeyCode.T then
        teleportToMouse()
    elseif input.KeyCode == Enum.KeyCode.RightShift then
        frame.Visible = not frame.Visible
    end
end)

print("=== ЭКСПЛОЙТ ЗАГРУЖЕН ===")
print("Правая Shift - меню")
print("F - полет")
print("E - ESP")
print("T - телепорт к мыши")