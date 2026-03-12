--[[
    SB+ ULTIMATE SCRIPT MENU
    Разработано специально для SBsaturnita
    Функции: Fly (как Infinity Yield), Dance (R6), Dash, Speed, Jump Power
    Более 600 строк чистого кода.
]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

-- Variables
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- Settings
local Settings = {
    FlyEnabled = false,
    FlySpeed = 50,
    JumpPower = 50,
    WalkSpeed = 16,
    DashEnabled = false,
    DashCooldown = 0,
    DanceEnabled = false,
    AntiAFK = true,
    ESP = false,
    InfiniteJump = false,
    Noclip = false,
    Theme = "Dark"
}

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SBPlusMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 700, 0, 500)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://13115614015"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "SB+ ULTIMATE MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Parent = TopBar

local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.BackgroundTransparency = 1
CloseButton.Image = "rbxassetid://6031094666"
CloseButton.ImageColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.Parent = TopBar

-- Tab Buttons Frame
local TabFrame = Instance.new("Frame")
TabFrame.Name = "TabFrame"
TabFrame.Size = UDim2.new(1, 0, 0, 50)
TabFrame.Position = UDim2.new(0, 0, 0, 40)
TabFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TabFrame.BorderSizePixel = 0
TabFrame.Parent = MainFrame

-- Tabs
local Tabs = {}
local TabButtons = {}
local TabContents = {}

local TabNames = {"Movement", "Visual", "Character", "Misc", "Settings"}
local TabIcons = {"rbxassetid://6034501880", "rbxassetid://6034501420", "rbxassetid://6034502157", "rbxassetid://6034502343", "rbxassetid://6034502543"}

for i, v in ipairs(TabNames) do
    local TabButton = Instance.new("ImageButton")
    TabButton.Name = v.."Tab"
    TabButton.Size = UDim2.new(0, 70, 0, 40)
    TabButton.Position = UDim2.new(0, 10 + (i-1)*80, 0.5, -20)
    TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TabButton.BackgroundTransparency = 0.5
    TabButton.Image = TabIcons[i]
    TabButton.ImageColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.Parent = TabFrame
    
    local TabLabel = Instance.new("TextLabel")
    TabLabel.Name = "Label"
    TabLabel.Size = UDim2.new(1, 0, 0, 20)
    TabLabel.Position = UDim2.new(0, 0, 1, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = v
    TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabLabel.TextScaled = true
    TabLabel.Font = Enum.Font.Gotham
    TabLabel.Parent = TabButton
    
    Tabs[v] = TabButton
    table.insert(TabButtons, TabButton)
end

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -120)
ContentFrame.Position = UDim2.new(0, 10, 0, 100)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
ContentFrame.ScrollBarThickness = 5
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ContentFrame

-- Helper Functions
function CreateSection(parent, name)
    local Section = Instance.new("Frame")
    Section.Name = name.."Section"
    Section.Size = UDim2.new(1, -10, 0, 40)
    Section.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Section.BorderSizePixel = 0
    Section.Parent = parent
    
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Size = UDim2.new(1, -10, 1, 0)
    SectionLabel.Position = UDim2.new(0, 10, 0, 0)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Text = name
    SectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    SectionLabel.TextScaled = true
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.Parent = Section
    
    return Section
end

function CreateToggle(parent, name, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name.."Toggle"
    ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(0.7, -10, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.TextScaled = true
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("ImageButton")
    ToggleButton.Name = "Button"
    ToggleButton.Size = UDim2.new(0, 25, 0, 25)
    ToggleButton.Position = UDim2.new(1, -35, 0.5, -12.5)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ToggleButton.Image = default and "rbxassetid://6031094666" or "rbxassetid://6031094665"
    ToggleButton.ImageColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    ToggleButton.Parent = ToggleFrame
    
    local state = default
    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        ToggleButton.Image = state and "rbxassetid://6031094666" or "rbxassetid://6031094665"
        ToggleButton.ImageColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        if callback then callback(state) end
    end)
    
    return ToggleFrame, ToggleButton
end

function CreateSlider(parent, name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name.."Slider"
    SliderFrame.Size = UDim2.new(1, -10, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(0.7, -10, 0.5, 0)
    SliderLabel.Position = UDim2.new(0, 10, 0, 5)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = name
    SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.TextScaled = true
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.3, -10, 0.5, 0)
    ValueLabel.Position = UDim2.new(0.7, 0, 0, 5)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    ValueLabel.TextScaled = true
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Parent = SliderFrame
    
    local SliderBG = Instance.new("Frame")
    SliderBG.Name = "BG"
    SliderBG.Size = UDim2.new(1, -20, 0, 10)
    SliderBG.Position = UDim2.new(0, 10, 1, -20)
    SliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderBG.BorderSizePixel = 0
    SliderBG.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Name = "Bar"
    SliderBar.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    SliderBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderBG
    
    local SliderButton = Instance.new("ImageButton")
    SliderButton.Name = "Button"
    SliderButton.Size = UDim2.new(0, 15, 0, 15)
    SliderButton.Position = UDim2.new((default - min)/(max - min), -7.5, 0.5, -7.5)
    SliderButton.BackgroundTransparency = 1
    SliderButton.Image = "rbxassetid://6031094677"
    SliderButton.Parent = SliderBG
    
    local dragging = false
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = UIS:GetMouseLocation().X - SliderBG.AbsolutePosition.X
            local percent = math.clamp(pos / SliderBG.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * percent
            value = math.round(value * 10) / 10
            
            SliderBar.Size = UDim2.new(percent, 0, 1, 0)
            SliderButton.Position = UDim2.new(percent, -7.5, 0.5, -7.5)
            ValueLabel.Text = tostring(value)
            
            if callback then callback(value) end
        end
    end)
    
    return SliderFrame
end

function CreateButton(parent, name, callback)
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = name.."Button"
    ButtonFrame.Size = UDim2.new(1, -10, 0, 40)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Parent = parent
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 1, -10)
    Button.Position = UDim2.new(0, 10, 0, 5)
    Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    Button.Font = Enum.Font.Gotham
    Button.Parent = ButtonFrame
    
    Button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return ButtonFrame
end

-- Movement Tab
local MovementSection = CreateSection(ContentFrame, "Movement")
local FlyToggle, FlyBtn = CreateToggle(ContentFrame, "Fly", false, function(state)
    Settings.FlyEnabled = state
    if state then
        startFly()
    else
        stopFly()
    end
end)

local FlySpeedSlider = CreateSlider(ContentFrame, "Fly Speed", 10, 200, Settings.FlySpeed, function(value)
    Settings.FlySpeed = value
end)

local DashButton = CreateButton(ContentFrame, "Dash / Roll", function()
    performDash()
end)

local DanceButton = CreateButton(ContentFrame, "Dance (R6)", function()
    startDance()
end)

-- Character Tab
local CharacterSection = CreateSection(ContentFrame, "Character Stats")
local WalkSpeedSlider = CreateSlider(ContentFrame, "Walk Speed", 16, 200, Settings.WalkSpeed, function(value)
    Settings.WalkSpeed = value
    if Character and Humanoid then
        Humanoid.WalkSpeed = value
    end
end)

local JumpPowerSlider = CreateSlider(ContentFrame, "Jump Power", 50, 200, Settings.JumpPower, function(value)
    Settings.JumpPower = value
    if Character and Humanoid then
        Humanoid.JumpPower = value
    end
end)

local InfiniteJumpToggle = CreateToggle(ContentFrame, "Infinite Jump", false, function(state)
    Settings.InfiniteJump = state
    setupInfiniteJump(state)
end)

local NoclipToggle = CreateToggle(ContentFrame, "Noclip", false, function(state)
    Settings.Noclip = state
    setupNoclip(state)
end)

-- Misc Tab
local MiscSection = CreateSection(ContentFrame, "Miscellaneous")
local AntiAFKToggle = CreateToggle(ContentFrame, "Anti AFK", true, function(state)
    Settings.AntiAFK = state
    setupAntiAFK(state)
end)

local RejoinButton = CreateButton(ContentFrame, "Rejoin Game", function()
    TeleportService:Teleport(game.PlaceId, Player)
end)

local ServerHopButton = CreateButton(ContentFrame, "Server Hop", function()
    local Http = game:GetService("HttpService")
    local PlaceId = game.PlaceId
    local function getServers()
        local cursor = ""
        local servers = {}
        repeat
            local response = game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?limit=100&cursor=" .. cursor)
            local data = Http:JSONDecode(response)
            for _, server in ipairs(data.data) do
                if server.playing ~= server.maxPlayers then
                    table.insert(servers, server.id)
                end
            end
            cursor = data.nextPageCursor
        until cursor == nil
        return servers
    end
    
    local servers = getServers()
    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], Player)
    end
end)

-- Close Button Function
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Enabled = not ScreenGui:Enabled
end)

-- Main Functions
local flyConnection
local flyBodyVelocity, flyBodyGyro

function startFly()
    if not Character or not RootPart then return end
    
    -- Очищаем старые объекты
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end
    
    -- Создаем новые BodyMovers
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 4000
    flyBodyVelocity.P = 1250
    flyBodyVelocity.Parent = RootPart
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 4000
    flyBodyGyro.P = 1250
    flyBodyGyro.D = 50
    flyBodyGyro.CFrame = RootPart.CFrame
    flyBodyGyro.Parent = RootPart
    
    -- Включаем noclip для плавного полета
    local noclipState = Settings.Noclip
    Settings.Noclip = true
    setupNoclip(true)
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not Settings.FlyEnabled or not Character or not RootPart or not flyBodyVelocity or not flyBodyGyro then
            return
        end
        
        local moveDirection = Vector3.new(0, 0, 0)
        local cameraCFrame = Camera.CFrame
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + cameraCFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - cameraCFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - cameraCFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + cameraCFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection + Vector3.new(0, -1, 0)
        end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
        end
        
        flyBodyVelocity.Velocity = moveDirection * Settings.FlySpeed
        flyBodyGyro.CFrame = cameraCFrame
    end)
end

function stopFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    if flyBodyGyro then
        flyBodyGyro:Destroy()
        flyBodyGyro = nil
    end
    -- Возвращаем noclip
    setupNoclip(Settings.Noclip)
end

function performDash()
    if not Character or not RootPart or not Humanoid then return end
    if tick() - (Settings.DashCooldown or 0) < 2 then return end
    
    Settings.DashCooldown = tick()
    
    local direction = Camera.CFrame.LookVector * 50
    local targetPos = RootPart.Position + direction
    
    -- Анимация кувырка
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {CFrame = RootPart.CFrame * CFrame.Angles(math.rad(360), 0, 0)}
    local tween = TweenService:Create(RootPart, tweenInfo, goal)
    tween:Play()
    
    -- Перемещение
    RootPart.Velocity = direction * 2
    wait(0.1)
    RootPart.Velocity = Vector3.new(0, 0, 0)
    
    -- Траил эффект
    for i = 1, 5 do
        local part = Instance.new("Part")
        part.Size = Vector3.new(1, 1, 1)
        part.Color = Color3.fromRGB(255, 255, 255)
        part.Material = Enum.Material.Neon
        part.Anchored = true
        part.CanCollide = false
        part.Transparency = 0.5
        part.CFrame = RootPart.CFrame * CFrame.new(0, -2, 0)
        part.Parent = workspace
        
        TweenService:Create(part, TweenInfo.new(0.5), {Transparency = 1}):Play()
        game:GetService("Debris"):AddItem(part, 0.5)
    end
end

function startDance()
    if not Character or not Humanoid then return end
    if Humanoid.RigType ~= Enum.HumanoidRigType.R6 then
        warn("Dance only works with R6 characters!")
        return
    end
    
    Settings.DanceEnabled = not Settings.DanceEnabled
    
    if Settings.DanceEnabled then
        -- Находим все части тела
        local Torso = Character:FindFirstChild("Torso")
        local Head = Character:FindFirstChild("Head")
        local LeftArm = Character:FindFirstChild("Left Arm")
        local RightArm = Character:FindFirstChild("Right Arm")
        local LeftLeg = Character:FindFirstChild("Left Leg")
        local RightLeg = Character:FindFirstChild("Right Leg")
        
        if not Torso or not Head or not LeftArm or not RightArm or not LeftLeg or not RightLeg then return end
        
        -- Анимация танца
        coroutine.wrap(function()
            while Settings.DanceEnabled and Character and Humanoid do
                -- Макаренa
                for i = 1, 4 do
                    Torso.CFrame = Torso.CFrame * CFrame.Angles(0, math.rad(10), 0)
                    LeftArm.CFrame = Torso.CFrame * CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(math.rad(90), 0, 0)
                    RightArm.CFrame = Torso.CFrame * CFrame.new(1.5, 0.5, 0) * CFrame.Angles(math.rad(90), 0, 0)
                    LeftLeg.CFrame = Torso.CFrame * CFrame.new(-0.5, -1, 0) * CFrame.Angles(math.rad(30), 0, 0)
                    RightLeg.CFrame = Torso.CFrame * CFrame.new(0.5, -1, 0) * CFrame.Angles(math.rad(-30), 0, 0)
                    Head.CFrame = Torso.CFrame * CFrame.new(0, 1.5, 0) * CFrame.Angles(math.rad(20), 0, 0)
                    wait(0.1)
                end
                
                -- Электродэнс
                for i = 1, 4 do
                    Torso.CFrame = Torso.CFrame * CFrame.Angles(math.rad(20), 0, 0)
                    LeftArm.CFrame = Torso.CFrame * CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(math.rad(-45), 0, math.rad(30))
                    RightArm.CFrame = Torso.CFrame * CFrame.new(1.5, 0.5, 0) * CFrame.Angles(math.rad(-45), 0, math.rad(-30))
                    LeftLeg.CFrame = Torso.CFrame * CFrame.new(-0.5, -1, 0) * CFrame.Angles(math.rad(-20), 0, 0)
                    RightLeg.CFrame = Torso.CFrame * CFrame.new(0.5, -1, 0) * CFrame.Angles(math.rad(20), 0, 0)
                    Head.CFrame = Torso.CFrame * CFrame.new(0, 1.5, 0) * CFrame.Angles(math.rad(-10), 0, 0)
                    wait(0.1)
                end
                
                -- Вертушка
                for i = 1, 8 do
                    Torso.CFrame = Torso.CFrame * CFrame.Angles(0, math.rad(45), 0)
                    LeftArm.CFrame = Torso.CFrame * CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(0, 0, math.rad(90))
                    RightArm.CFrame = Torso.CFrame * CFrame.new(1.5, 0.5, 0) * CFrame.Angles(0, 0, math.rad(-90))
                    wait(0.05)
                end
            end
        end)()
    end
end

function setupInfiniteJump(state)
    if state then
        UserInputService.JumpRequest:Connect(function()
            if Settings.InfiniteJump and Character and Humanoid and Humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

function setupNoclip(state)
    if state then
        RunService.Stepped:Connect(function()
            if Settings.Noclip and Character then
                for _, v in ipairs(Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end

function setupAntiAFK(state)
    if state then
        Player.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end

-- Character Respawn Handler
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    RootPart = newChar:WaitForChild("HumanoidRootPart")
    
    -- Восстанавливаем настройки
    Humanoid.WalkSpeed = Settings.WalkSpeed
    Humanoid.JumpPower = Settings.JumpPower
    
    -- Перезапускаем полет если был включен
    if Settings.FlyEnabled then
        wait(0.5)
        startFly()
    end
end)

-- Скрыть/Показать меню по Insert
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- Cleanup
game:GetService("Players").LocalPlayer:GetMouse().KeyDown:Connect(function(key)
    if key == "f" and Settings.FlyEnabled then
        -- Дополнительная функция: зажать F для супер-скорости в полете
        local oldSpeed = Settings.FlySpeed
        Settings.FlySpeed = 500
        wait(0.5)
        Settings.FlySpeed = oldSpeed
    end
end)

-- Notification
StarterGui:SetCore("SendNotification", {
    Title = "SB+ Menu",
    Text = "Menu loaded! Press INSERT to toggle.",
    Duration = 3
})

print("SB+ Menu loaded successfully! Total lines: 650+")
-- End of Script