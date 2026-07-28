--[[
    Test Security Hub for MM2
    by Celestia_000
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Состояние функций
local Config = {
    AutoFarm = false,
    FarmMode = "Nearest",
    FarmSpeed = 16,
    ESPEnabled = false,
    AutoAim = false,
    AutoGrabGun = false,
    KillAll = false,
    BunnyHop = false,
}

--------------------------------------------------------------------------------
-- ИНТЕРФЕЙС С ПРИВЕТСТВИЕМ И ПОДПИСЬЮ
--------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TestSecurityGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 440) -- Немного увеличили высоту для шапки
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Главный заголовок окна
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Security Test Hub (MM2)"
Title.Parent = MainFrame

-- Подпись с автором (приветственное оформление)
local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.Position = UDim2.new(0, 0, 0, 30)
SubTitle.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
SubTitle.TextColor3 = Color3.fromRGB(170, 170, 170)
SubTitle.TextSize = 12
SubTitle.Font = Enum.Font.SourceSansItalic
SubTitle.Text = "Welcome | by Celestia_000"
SubTitle.Parent = MainFrame

-- Функция создания кнопок
local function createButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.SourceSans
    btn.Text = name
    btn.Parent = MainFrame
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
        callback(active)
    end)
end

-- Добавляем элементы управления ниже шапки (сдвиг по Y на +50 пикселей)
createButton("Автофарм (Nearest)", 65, function(state)
    Config.AutoFarm = state
    Config.FarmMode = "Nearest"
end)

createButton("Автофарм (Random)", 100, function(state)
    Config.AutoFarm = state
    Config.FarmMode = "Random"
end)

createButton("ESP Ролей (Шериф/Маньяк)", 135, function(state)
    Config.ESPEnabled = state
end)

createButton("Автоподбор оружия (GunDrop)", 170, function(state)
    Config.AutoGrabGun = state
end)

createButton("Автоаим на Маньяка", 205, function(state)
    Config.AutoAim = state
end)

createButton("Убийство всех (KillAll Server Event)", 240, function(state)
    Config.KillAll = state
end)

createButton("Банихоп (Space)", 275, function(state)
    Config.BunnyHop = state
end)

-- Кнопка закрытия интерфейса
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "X"
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

--------------------------------------------------------------------------------
-- ЛОГИКА ФУНКЦИЙ
--------------------------------------------------------------------------------

-- 1. Автофарм
local function getTargetCoin()
    local coinContainer = Workspace:FindFirstChild("CoinContainer") or Workspace
    local coins = {}
    for _, obj in ipairs(coinContainer:GetChildren()) do
        if obj.Name == "Coin" and obj:IsA("BasePart") then
            table.insert(coins, obj)
        end
    end
    if #coins == 0 then return nil end
    
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    if Config.FarmMode == "Nearest" then
        local closest, minDist = nil, math.huge
        for _, coin in ipairs(coins) do
            local dist = (hrp.Position - coin.Position).Magnitude
            if dist < minDist then minDist = dist closest = coin end
        end
        return closest
    elseif Config.FarmMode == "Random" then
        return coins[math.random(1, #coins)]
    end
    return nil
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if Config.AutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hum and hrp then
                    hum.WalkSpeed = 16
                    local coin = getTargetCoin()
                    if coin then
                        hrp.CFrame = CFrame.new(coin.Position)
                    end
                end
            end)
        end
    end
end)

-- 2. ESP Ролей
local function getRole(player)
    if player.Character then
        if player.Character:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun") then
            return Color3.fromRGB(0, 100, 255)
        elseif player.Character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife") then
            return Color3.fromRGB(255, 0, 0)
        end
    end
    return Color3.fromRGB(0, 255, 0)
end

RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hl = player.Character:FindFirstChild("TestESP")
            if Config.ESPEnabled then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "TestESP"
                    hl.Adornee = player.Character
                    hl.Parent = player.Character
                end
                hl.FillColor = getRole(player)
            else
                if hl then hl:Destroy() end
            end
        end
    end
end)

-- 3. Автоподбор оружия
task.spawn(function()
    while true do
        task.wait(0.5)
        if Config.AutoGrabGun then
            pcall(function()
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj.Name == "GunDrop" and obj:IsA("BasePart") then
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then hrp.CFrame = obj.CFrame end
                    end
                end
            end)
        end
    end
end)

-- 4. Автоаим
RunService.RenderStepped:Connect(function()
    if Config.AutoAim then
        pcall(function()
            local char = LocalPlayer.Character
            if char and (char:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")) then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local roleColor = getRole(player)
                        if roleColor == Color3.fromRGB(255, 0, 0) then
                            local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                            if targetHrp then
                                Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, targetHrp.Position)
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- 5. Банихоп
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and Config.BunnyHop and input.KeyCode == Enum.KeyCode.Space then
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
end)

print("Security Test Hub by Celestia_000 loaded successfully.")