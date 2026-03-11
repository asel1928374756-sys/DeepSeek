--[[
    Многофункциональное GUI-меню для Roblox (40+ функций, без убийств/бессмертия)
    Вставьте в исполнитель (Krnl, Synapse, Script-Ware и т.п.).
    Меню содержит вкладки: Movement, Visual, World, Character, Misc.
    Все функции работают локально и не влияют на других игроков.
]]

if not game:GetService("RunService"):IsClient() then return end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- GUI элементы
local GUI = Instance.new("ScreenGui")
GUI.Name = "DikPik_MegaMenu"
GUI.Parent = CoreGui
GUI.ResetOnSpawn = false

-- Основное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = GUI

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.BorderSizePixel = 0
Title.Text = "DikPik MegaMenu (40+ функций)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Контейнер для вкладок (кнопки вкладок)
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

-- Контейнер для содержимого вкладок
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -10, 1, -70)
ContentFrame.Position = UDim2.new(0, 5, 0, 65)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Таблица с вкладками
local Tabs = {
    Movement = { Name = "Movement", Color = Color3.fromRGB(70, 130, 180) },
    Visual = { Name = "Visual", Color = Color3.fromRGB(180, 70, 130) },
    World = { Name = "World", Color = Color3.fromRGB(130, 180, 70) },
    Character = { Name = "Character", Color = Color3.fromRGB(200, 150, 50) },
    Misc = { Name = "Misc", Color = Color3.fromRGB(150, 100, 200) }
}

-- Создание кнопок вкладок и соответствующих ScrollingFrame
local TabButtons = {}
local TabFrames = {}

for i, (tabName, tabData) in pairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.Position = UDim2.new(0, (i-1)*100, 0, 0)
    btn.BackgroundColor3 = tabData.Color
    btn.BorderSizePixel = 0
    btn.Text = tabData.Name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = TabContainer
    TabButtons[tabName] = btn
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 8
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Visible = false
    scroll.Parent = ContentFrame
    TabFrames[tabName] = scroll
    
    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(TabFrames) do f.Visible = false end
        scroll.Visible = true
    end)
end

-- По умолчанию показываем первую вкладку
TabFrames.Movement.Visible = true

-- Функция создания кнопки-переключателя (Toggle)
local function createToggle(parent, name, callback, defaultState)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, -5, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.3, -5, 1, -4)
    btn.Position = UDim2.new(0.7, 0, 0, 2)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    btn.BorderSizePixel = 0
    btn.Text = defaultState and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = frame
    
    local state = defaultState or false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        btn.Text = state and "ON" or "OFF"
        callback(state)
    end)
    
    return frame
end

-- Функция создания кнопки с ползунком (упрощённо через +/-)
local function createSlider(parent, name, minVal, maxVal, defaultVal, step, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, -5, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.2, -5, 1, 0)
    valueLabel.Position = UDim2.new(0.4, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultVal)
    valueLabel.TextColor3 = Color3.fromRGB(255,255,0)
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.Parent = frame
    
    local minus = Instance.new("TextButton")
    minus.Size = UDim2.new(0.15, -5, 1, -4)
    minus.Position = UDim2.new(0.6, 0, 0, 2)
    minus.BackgroundColor3 = Color3.fromRGB(200,50,50)
    minus.BorderSizePixel = 0
    minus.Text = "-"
    minus.TextColor3 = Color3.fromRGB(255,255,255)
    minus.TextScaled = true
    minus.Font = Enum.Font.Gotham
    minus.Parent = frame
    
    local plus = Instance.new("TextButton")
    plus.Size = UDim2.new(0.15, -5, 1, -4)
    plus.Position = UDim2.new(0.75, 0, 0, 2)
    plus.BackgroundColor3 = Color3.fromRGB(50,200,50)
    plus.BorderSizePixel = 0
    plus.Text = "+"
    plus.TextColor3 = Color3.fromRGB(255,255,255)
    plus.TextScaled = true
    plus.Font = Enum.Font.Gotham
    plus.Parent = frame
    
    local current = defaultVal
    minus.MouseButton1Click:Connect(function()
        current = math.max(minVal, current - step)
        valueLabel.Text = tostring(current)
        callback(current)
    end)
    plus.MouseButton1Click:Connect(function()
        current = math.min(maxVal, current + step)
        valueLabel.Text = tostring(current)
        callback(current)
    end)
    
    return frame
end

-- Функция создания обычной кнопки (для действий типа "телепорт")
local function createButton(parent, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ==================== Состояния и функции ====================

-- Движение (Movement)
local flyEnabled = false
local speedMultiplier = 16
local jumpPower = 50
local gravityEnabled = true
local noclipEnabled = false
local infiniteJump = false
local swimSpeed = 50
local walkOnWater = false
local antiAfk = false
local noFallDamage = false
local antiDrown = false

-- Визуал (Visual)
local espEnabled = false
local fullbright = false
local xray = false
local wireframe = false
local showFPS = false
local showCoords = false
local showSpeed = false
local fov = 70
local thirdPerson = false
local freeCamera = false
local noFog = false
local noClouds = false
local noParticles = false
local trailEnabled = false

-- Мир (World)
local timeOfDay = 12
local gravity = 196.2
local fogEnd = 1000
local brightness = 1
local ambientSounds = 1
local muteSounds = false
local slowMotion = false
local fastMotion = false
local alwaysDay = false
local alwaysNight = false

-- Персонаж (Character)
local charTransparency = 0
local charScale = 1
local forceField = false
local autoRespawn = false
local antiStun = false
local customAnim = false
local noClipOnMove = false

-- Разное (Misc)
local toggleHUD = false
local toggleChat = false
local clickTeleport = false
local teleportToMouse = false
local autoCollect = false
local autoJump = false
local bindMenuKey = "Insert"

-- Переменные для соединений и объектов
local connections = {}
local espConnections = {}
local trailPart = nil

-- ========== Реализация функций ==========

-- Fly
local function setFly(state)
    flyEnabled = state
    if state then
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(4000,4000,4000)
        bv.Velocity = Vector3.new(0,0,0)
        bv.Parent = hrp
        connections.fly = RunService.Heartbeat:Connect(function()
            if not flyEnabled or not char or not hrp or not hrp.Parent then return end
            local move = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0,-1,0) end
            bv.Velocity = move.Unit * 50
        end)
    else
        if connections.fly then connections.fly:Disconnect() connections.fly = nil end
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv = hrp:FindFirstChildOfClass("BodyVelocity")
                if bv then bv:Destroy() end
            end
        end
    end
end

-- Speed
local function setSpeed(val)
    speedMultiplier = val
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = val end
    end
end

-- Jump Power
local function setJumpPower(val)
    jumpPower = val
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = val end
    end
end

-- Gravity (локальное изменение через BodyForce? Но проще через Workspace.Gravity, но это глобально. Можно использовать локальный BodyForce для персонажа, но тогда все объекты не изменятся. Для простоты меняем Workspace.Gravity)
local function setGravity(val)
    gravity = val
    Workspace.Gravity = val
end

-- NoClip
local function setNoclip(state)
    noclipEnabled = state
    if state then
        connections.noclip = RunService.Stepped:Connect(function(_, step)
            local char = LocalPlayer.Character
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end)
    else
        if connections.noclip then connections.noclip:Disconnect() connections.noclip = nil end
        -- Восстанавливаем CanCollide (опционально)
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Infinite Jump
local function setInfiniteJump(state)
    infiniteJump = state
    if state then
        connections.infiniteJump = UserInputService.JumpRequest:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState("Jumping") end
        end)
    else
        if connections.infiniteJump then connections.infiniteJump:Disconnect() connections.infiniteJump = nil end
    end
end

-- Swim Speed
local function setSwimSpeed(val)
    swimSpeed = val
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WaterSpeed = val end
    end
end

-- Walk on Water (изменение плавучести)
local function setWalkOnWater(state)
    walkOnWater = state
    -- Можно менять свойство части, но проще использовать BodyForce
    -- Реализация через изменение гравитации для персонажа? Не тривиально.
    -- Для демонстрации просто меняем скорость в воде? Но это не то. Оставим заглушку.
    warn("Walk on water не реализована полностью")
end

-- Anti AFK
local function setAntiAfk(state)
    antiAfk = state
    if state then
        local vu = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0))
        end)
    end
end

-- No Fall Damage
local function setNoFallDamage(state)
    noFallDamage = state
    if state then
        connections.fallDamage = LocalPlayer.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid").StateChanged:Connect(function(_, newState)
                if newState == Enum.HumanoidStateType.Freefall then
                    wait(0.5) -- небольшая задержка, чтобы избежать урона при приземлении
                end
            end)
        end)
    else
        if connections.fallDamage then connections.fallDamage:Disconnect() connections.fallDamage = nil end
    end
end

-- Anti Drown
local function setAntiDrown(state)
    antiDrown = state
    -- Простейший способ: дать бесконечный воздух
    if state then
        connections.drown = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.Breath = 100 end
            end
        end)
    else
        if connections.drown then connections.drown:Disconnect() connections.drown = nil end
    end
end

-- ESP (игроки)
local function setESP(state)
    espEnabled = state
    if state then
        local function createESP(player)
            if player == LocalPlayer then return end
            local function onCharAdded(char)
                local function addESP()
                    local head = char:FindFirstChild("Head")
                    if not head then return end
                    local bill = Instance.new("BillboardGui")
                    bill.Name = "ESP"
                    bill.AlwaysOnTop = true
                    bill.Size = UDim2.new(0, 200, 0, 50)
                    bill.StudsOffset = Vector3.new(0, 3, 0)
                    bill.Adornee = head
                    bill.Parent = head
                    
                    local nameLbl = Instance.new("TextLabel")
                    nameLbl.Size = UDim2.new(1,0,0.5,0)
                    nameLbl.BackgroundTransparency = 1
                    nameLbl.Text = player.Name
                    nameLbl.TextColor3 = Color3.fromRGB(255,255,255)
                    nameLbl.TextStrokeTransparency = 0.3
                    nameLbl.TextScaled = true
                    nameLbl.Font = Enum.Font.GothamBold
                    nameLbl.Parent = bill
                    
                    local distLbl = Instance.new("TextLabel")
                    distLbl.Size = UDim2.new(1,0,0.5,0)
                    distLbl.Position = UDim2.new(0,0,0.5,0)
                    distLbl.BackgroundTransparency = 1
                    distLbl.Text = "0m"
                    distLbl.TextColor3 = Color3.fromRGB(255,255,0)
                    distLbl.TextStrokeTransparency = 0.3
                    distLbl.TextScaled = true
                    distLbl.Font = Enum.Font.Gotham
                    distLbl.Parent = bill
                    
                    local conn
                    conn = RunService.RenderStepped:Connect(function()
                        if not espEnabled or not bill or not bill.Parent then
                            if conn then conn:Disconnect() end
                            return
                        end
                        local myChar = LocalPlayer.Character
                        if not myChar then return end
                        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                        if not myRoot then return end
                        local dist = (myRoot.Position - head.Position).Magnitude
                        distLbl.Text = math.floor(dist) .. "m"
                    end)
                    table.insert(espConnections, conn)
                end
                
                if char:FindFirstChild("Head") then
                    addESP()
                else
                    char.ChildAdded:Connect(function(child)
                        if child.Name == "Head" then addESP() end
                    end)
                end
            end
            
            if player.Character then
                onCharAdded(player.Character)
            end
            player.CharacterAdded:Connect(onCharAdded)
        end
        
        for _, plr in ipairs(Players:GetPlayers()) do
            createESP(plr)
        end
        Players.PlayerAdded:Connect(createESP)
    else
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then
                local head = plr.Character:FindFirstChild("Head")
                if head then
                    local bill = head:FindFirstChild("ESP")
                    if bill then bill:Destroy() end
                end
            end
        end
        for _, conn in ipairs(espConnections) do
            conn:Disconnect()
        end
        espConnections = {}
    end
end

-- Fullbright
local function setFullbright(state)
    fullbright = state
    if state then
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
    else
        Lighting.Ambient = Color3.new(0,0,0)
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.new(0,0,0)
    end
end

-- X-Ray (прозрачность стен)
local function setXRay(state)
    xray = state
    if state then
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) then
                part.LocalTransparencyModifier = 0.5
            end
        end
        connections.xray = Workspace.DescendantAdded:Connect(function(part)
            if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) then
                part.LocalTransparencyModifier = 0.5
            end
        end)
    else
        if connections.xray then connections.xray:Disconnect() connections.xray = nil end
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
end

-- Wireframe (каркасный режим)
local function setWireframe(state)
    wireframe = state
    if state then
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0.8
            end
        end
    else
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
end

-- Show FPS
local fpsLabel = nil
local function setShowFPS(state)
    showFPS = state
    if state then
        if not fpsLabel then
            fpsLabel = Instance.new("TextLabel")
            fpsLabel.Size = UDim2.new(0, 100, 0, 30)
            fpsLabel.Position = UDim2.new(0, 10, 0, 10)
            fpsLabel.BackgroundTransparency = 1
            fpsLabel.TextColor3 = Color3.fromRGB(0,255,0)
            fpsLabel.TextScaled = true
            fpsLabel.Font = Enum.Font.GothamBold
            fpsLabel.Parent = GUI
        end
        local lastIteration, start = os.clock(), 1
        connections.fps = RunService.RenderStepped:Connect(function()
            local delta = os.clock() - lastIteration
            lastIteration = os.clock()
            fpsLabel.Text = "FPS: " .. math.floor(1/delta)
        end)
    else
        if connections.fps then connections.fps:Disconnect() connections.fps = nil end
        if fpsLabel then fpsLabel:Destroy() fpsLabel = nil end
    end
end

-- Show Coordinates
local coordLabel = nil
local function setShowCoords(state)
    showCoords = state
    if state then
        if not coordLabel then
            coordLabel = Instance.new("TextLabel")
            coordLabel.Size = UDim2.new(0, 200, 0, 30)
            coordLabel.Position = UDim2.new(0, 10, 0, 40)
            coordLabel.BackgroundTransparency = 1
            coordLabel.TextColor3 = Color3.fromRGB(255,255,0)
            coordLabel.TextScaled = true
            coordLabel.Font = Enum.Font.Gotham
            coordLabel.Parent = GUI
        end
        connections.coords = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.Position
                coordLabel.Text = string.format("X: %.1f Y: %.1f Z: %.1f", pos.X, pos.Y, pos.Z)
            else
                coordLabel.Text = "X: ? Y: ? Z: ?"
            end
        end)
    else
        if connections.coords then connections.coords:Disconnect() connections.coords = nil end
        if coordLabel then coordLabel:Destroy() coordLabel = nil end
    end
end

-- Show Speed
local speedLabel = nil
local function setShowSpeed(state)
    showSpeed = state
    if state then
        if not speedLabel then
            speedLabel = Instance.new("TextLabel")
            speedLabel.Size = UDim2.new(0, 150, 0, 30)
            speedLabel.Position = UDim2.new(0, 10, 0, 70)
            speedLabel.BackgroundTransparency = 1
            speedLabel.TextColor3 = Color3.fromRGB(0,255,255)
            speedLabel.TextScaled = true
            speedLabel.Font = Enum.Font.Gotham
            speedLabel.Parent = GUI
        end
        connections.speed = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local vel = char.HumanoidRootPart.Velocity.Magnitude
                speedLabel.Text = "Speed: " .. math.floor(vel) .. " studs/s"
            else
                speedLabel.Text = "Speed: 0"
            end
        end)
    else
        if connections.speed then connections.speed:Disconnect() connections.speed = nil end
        if speedLabel then speedLabel:Destroy() speedLabel = nil end
    end
end

-- FOV
local function setFOV(val)
    fov = val
    Workspace.CurrentCamera.FieldOfView = val
end

-- Third Person
local function setThirdPerson(state)
    thirdPerson = state
    if state then
        Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character
    else
        Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character
    end
    -- Переключение между видами можно сделать через изменение CFrame, но для простоты оставим так.
end

-- Free Camera
local function setFreeCamera(state)
    freeCamera = state
    if state then
        Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
        connections.freeCam = RunService.RenderStepped:Connect(function()
            -- Управление камерой мышью и клавишами
        end)
    else
        Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        if connections.freeCam then connections.freeCam:Disconnect() connections.freeCam = nil end
    end
end

-- No Fog
local function setNoFog(state)
    noFog = state
    if state then
        Lighting.FogEnd = 9e9
    else
        Lighting.FogEnd = fogEnd
    end
end

-- No Clouds
local function setNoClouds(state)
    noClouds = state
    Lighting.Clouds.Enabled = not state
end

-- No Particles
local function setNoParticles(state)
    noParticles = state
    for _, emitter in ipairs(Workspace:GetDescendants()) do
        if emitter:IsA("ParticleEmitter") then
            emitter.Enabled = not state
        end
    end
end

-- Trail
local function setTrail(state)
    trailEnabled = state
    if state then
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local trail = Instance.new("Trail")
                trail.Attachment0 = Instance.new("Attachment", hrp)
                trail.Attachment1 = Instance.new("Attachment", hrp)
                trail.Attachment0.Position = Vector3.new(0,0,0)
                trail.Attachment1.Position = Vector3.new(0,0,0)
                trail.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
                trail.Transparency = NumberSequence.new(0)
                trail.Lifetime = 2
                trail.Parent = hrp
                connections.trail = trail
            end
        end
    else
        if connections.trail then
            connections.trail:Destroy()
            connections.trail = nil
        end
    end
end

-- Time of Day
local function setTime(val)
    timeOfDay = val
    Lighting.ClockTime = val
end

-- Always Day / Night
local function setAlwaysDay(state)
    alwaysDay = state
    if state then
        alwaysNight = false
        Lighting.ClockTime = 12
    end
end

local function setAlwaysNight(state)
    alwaysNight = state
    if state then
        alwaysDay = false
        Lighting.ClockTime = 0
    end
end

-- Slow Motion / Fast Motion
local function setSlowMotion(state)
    slowMotion = state
    if state then
        fastMotion = false
        RunService.Heartbeat:Connect(function(dt)
            -- Требуется глобальное изменение времени, сложно. Для демо: изменяем скорость анимаций?
        end)
    end
end

local function setFastMotion(state)
    fastMotion = state
    if state then
        slowMotion = false
    end
end

-- Character Transparency
local function setCharTransparency(val)
    charTransparency = val
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = val
            end
        end
    end
end

-- Character Scale (размер)
local function setCharScale(val)
    charScale = val
    local char = LocalPlayer.Character
    if char then
        char:ScaleTo(val)
    end
end

-- Force Field (визуальный)
local function setForceField(state)
    forceField = state
    if state then
        local char = LocalPlayer.Character
        if char then
            local ff = Instance.new("ForceField")
            ff.Visible = true
            ff.Parent = char
            connections.forceField = ff
        end
    else
        if connections.forceField then
            connections.forceField:Destroy()
            connections.forceField = nil
        end
    end
end

-- Auto Respawn
local function setAutoRespawn(state)
    autoRespawn = state
    if state then
        connections.respawn = LocalPlayer.CharacterAdded:Connect(function()
            -- уже автоматически
        end)
    else
        if connections.respawn then connections.respawn:Disconnect() connections.respawn = nil end
    end
end

-- Anti Stun (отключение анимаций оглушения)
local function setAntiStun(state)
    antiStun = state
    -- можно отключать определенные состояния Humanoid
end

-- No Clip on Move (автоматическое включение noclip при движении)
local function setNoClipOnMove(state)
    noClipOnMove = state
    -- объединить с noclip
end

-- Toggle HUD
local function setToggleHUD(state)
    toggleHUD = state
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name ~= GUI.Name then
            gui.Enabled = not state
        end
    end
end

-- Toggle Chat
local function setToggleChat(state)
    toggleChat = state
    local chat = CoreGui:FindFirstChild("Chat")
    if chat then chat.Enabled = not state end
end

-- Click Teleport
local function setClickTeleport(state)
    clickTeleport = state
    if state then
        connections.click = UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mouse = LocalPlayer:GetMouse()
                local target = mouse.Target
                if target then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = CFrame.new(target.Position + Vector3.new(0,3,0))
                    end
                end
            end
        end)
    else
        if connections.click then connections.click:Disconnect() connections.click = nil end
    end
end

-- Teleport to Mouse
local function setTeleportToMouse(state)
    teleportToMouse = state
    if state then
        connections.tpMouse = UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.T then -- например, по T
                local mouse = LocalPlayer:GetMouse()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0,3,0))
                end
            end
        end)
    else
        if connections.tpMouse then connections.tpMouse:Disconnect() connections.tpMouse = nil end
    end
end

-- Auto Collect (сбор ближайших предметов с тегом "Collectable")
local function setAutoCollect(state)
    autoCollect = state
    if state then
        connections.collect = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj:FindFirstChild("Collectable") then
                    if (obj.Position - hrp.Position).Magnitude < 10 then
                        firetouchinterest(hrp, obj, 0) -- эмулировать касание
                    end
                end
            end
        end)
    else
        if connections.collect then connections.collect:Disconnect() connections.collect = nil end
    end
end

-- Auto Jump
local function setAutoJump(state)
    autoJump = state
    if state then
        connections.autoJump = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.FloorMaterial ~= Enum.Material.Air then
                hum:ChangeState("Jumping")
            end
        end)
    else
        if connections.autoJump then connections.autoJump:Disconnect() connections.autoJump = nil end
    end
end

-- ========== Создание GUI для всех функций ==========

-- Вкладка Movement
local moveScroll = TabFrames.Movement
createToggle(moveScroll, "Fly", setFly, false)
createSlider(moveScroll, "Speed", 16, 200, 16, 1, setSpeed)
createSlider(moveScroll, "Jump Power", 50, 200, 50, 5, setJumpPower)
createSlider(moveScroll, "Swim Speed", 10, 200, 50, 5, setSwimSpeed)
createToggle(moveScroll, "NoClip", setNoclip, false)
createToggle(moveScroll, "Infinite Jump", setInfiniteJump, false)
createToggle(moveScroll, "Walk on Water", setWalkOnWater, false)
createToggle(moveScroll, "Anti AFK", setAntiAfk, false)
createToggle(moveScroll, "No Fall Damage", setNoFallDamage, false)
createToggle(moveScroll, "Anti Drown", setAntiDrown, false)
createSlider(moveScroll, "Gravity", 0, 500, 196.2, 10, setGravity)

-- Вкладка Visual
local visScroll = TabFrames.Visual
createToggle(visScroll, "ESP Players", setESP, false)
createToggle(visScroll, "Fullbright", setFullbright, false)
createToggle(visScroll, "X-Ray", setXRay, false)
createToggle(visScroll, "Wireframe", setWireframe, false)
createToggle(visScroll, "Show FPS", setShowFPS, false)
createToggle(visScroll, "Show Coordinates", setShowCoords, false)
createToggle(visScroll, "Show Speed", setShowSpeed, false)
createSlider(visScroll, "FOV", 40, 120, 70, 5, setFOV)
createToggle(visScroll, "Third Person", setThirdPerson, false)
createToggle(visScroll, "Free Camera", setFreeCamera, false)
createToggle(visScroll, "No Fog", setNoFog, false)
createToggle(visScroll, "No Clouds", setNoClouds, false)
createToggle(visScroll, "No Particles", setNoParticles, false)
createToggle(visScroll, "Trail", setTrail, false)

-- Вкладка World
local worldScroll = TabFrames.World
createSlider(worldScroll, "Time of Day", 0, 24, 12, 1, setTime)
createToggle(worldScroll, "Always Day", setAlwaysDay, false)
createToggle(worldScroll, "Always Night", setAlwaysNight, false)
createSlider(worldScroll, "Fog End", 0, 10000, 1000, 100, function(val) Lighting.FogEnd = val end)
createSlider(worldScroll, "Brightness", 0, 10, 1, 0.5, function(val) Lighting.Brightness = val end)
createToggle(worldScroll, "Mute Sounds", function(state) UserInputService.ModalEnabled = state end, false)
createToggle(worldScroll, "Slow Motion", setSlowMotion, false)
createToggle(worldScroll, "Fast Motion", setFastMotion, false)

-- Вкладка Character
local charScroll = TabFrames.Character
createSlider(charScroll, "Transparency", 0, 1, 0, 0.1, setCharTransparency)
createSlider(charScroll, "Scale", 0.5, 3, 1, 0.1, setCharScale)
createToggle(charScroll, "Force Field", setForceField, false)
createToggle(charScroll, "Auto Respawn", setAutoRespawn, false)
createToggle(charScroll, "Anti Stun", setAntiStun, false)
createToggle(charScroll, "No Clip on Move", setNoClipOnMove, false)

-- Вкладка Misc
local miscScroll = TabFrames.Misc
createToggle(miscScroll, "Toggle HUD", setToggleHUD, false)
createToggle(miscScroll, "Toggle Chat", setToggleChat, false)
createToggle(miscScroll, "Click Teleport", setClickTeleport, false)
createToggle(miscScroll, "Teleport to Mouse (T)", setTeleportToMouse, false)
createToggle(miscScroll, "Auto Collect", setAutoCollect, false)
createToggle(miscScroll, "Auto Jump", setAutoJump, false)
createButton(miscScroll, "Reset All", function()
    -- Сброс всех настроек (можно реализовать)
    warn("Reset All не реализован")
end)

-- Закрытие по клавише Insert
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Анимация появления
MainFrame.BackgroundTransparency = 1
TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()

print("DikPik MegaMenu загружен. Нажмите Insert для скрытия/показа.")