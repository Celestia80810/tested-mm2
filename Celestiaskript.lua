--[[
    @File: Celestiaskript.lua
    @Project: MM2 Advanced Security Hub
    @Author: Celestia_000
    @Description: Professional grade automation and utility hub for Murder Mystery 2
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- Защита от повторного запуска (удаляем старый GUI, если остался)
if CoreGui:FindFirstChild("CelestiaAdvancedHub") then
    CoreGui.CelestiaAdvancedHub:Destroy()
end

-- Конфигурация параметров скрипта
local Settings = {
    AutoFarm = false,
    FarmMode = "Nearest", -- "Nearest" или "Random"
    ESPEnabled = false,
    AutoAim = false,
    AutoGrabGun = false,
    BunnyHop = false,
}

--------------------------------------------------------------------------------
-- ПОСТРОЕНИЕ ПРОФЕССИОНАЛЬНОГО ИНТЕРФЕЙСА (UI LIBRARY ARCHITECTURE)
--------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CelestiaAdvancedHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 390)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -195)
MainFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(35, 35, 45)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Боковая панель навигации
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = Sidebar

-- Убираем лишнее скругление справа у сайдбара
local SidebarFix = Instance.new("Frame")
SidebarFix.Size = UDim2.new(0, 10, 1, 0)
SidebarFix.Position = UDim2.new(1, -10, 0, 0)
SidebarFix.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
SidebarFix.BorderSizePixel = 0
SidebarFix.Parent = Sidebar

-- Логотип / Текст в шапке сайдбара
local HubTitle = Instance.new("TextLabel")
HubTitle.Size = UDim2.new(1, 0, 0, 60)
HubTitle.BackgroundTransparency = 1
HubTitle.TextColor3 = Color3.fromRGB(245, 245, 250)
HubTitle.TextSize = 13
HubTitle.Font = Enum.Font.GothamBold
HubTitle.Text = "MM2 SECURITY HUB\n<font size='9' color='#7A7A8C'>v2.4 Professional</font>"
HubTitle.RichText = true
HubTitle.Parent = Sidebar

-- Кнопка закрытия интерфейса
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Position = UDim2.new(1, -32, 0, 12)
CloseButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
CloseButton.TextColor3 = Color3.fromRGB(180, 180, 195)
CloseButton.TextSize = 10
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "✕"
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Контейнер для сменяемых вкладок
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -172, 1, -20)
ContentArea.Position = UDim2.new(0, 166, 0, 10)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local TabsList = {}
local ButtonsList = {}
local ActiveTab = nil

local function CreateTab(tabName)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, -20, 0, 36)
    tabButton.Position = UDim2.new(0, 10, 0, 70 + (#ButtonsList * 42))
    tabButton.BackgroundColor3 = Color3.fromRGB(20, 20, 27)
    tabButton.TextColor3 = Color3.fromRGB(130, 130, 145)
    tabButton.TextSize = 12
    tabButton.Font = Enum.Font.GothamMedium
    tabButton.Text = "   " .. tabName
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.Parent = Sidebar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabButton

    local tabScrolling = Instance.new("ScrollingFrame")
    tabScrolling.Size = UDim2.new(1, 0, 1, 0)
    tabScrolling.BackgroundTransparency = 1
    tabScrolling.BorderSizePixel = 0
    tabScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabScrolling.ScrollBarThickness = 3
    tabScrolling.Visible = false
    tabScrolling.Parent = ContentArea

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = tabScrolling

    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabScrolling.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)

    table.insert(TabsList, tabScrolling)
    table.insert(ButtonsList, tabButton)

    local currentIdx = #TabsList
    tabButton.MouseButton1Click:Connect(function()
        for idx, tFrame in ipairs(TabsList) do
            tFrame.Visible = (idx == currentIdx)
            ButtonsList[idx].BackgroundColor3 = (idx == currentIdx) and Color3.fromRGB(28, 28, 38) or Color3.fromRGB(20, 20, 27)
            ButtonsList[idx].TextColor3 = (idx == currentIdx) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(130, 130, 145)
        end
    end)

    if not ActiveTab then
        ActiveTab = tabScrolling
        tabScrolling.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    return tabScrolling
end

-- Инициализация вкладок
local TabMain = CreateTab("Automation")
local TabVisuals = CreateTab("Visuals & ESP")
local TabCombat = CreateTab("Combat & Misc")

-- Функция создания переключателей (Toggles)
local function CreateToggle(targetTab, textLabel, callbackFunction)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, -6, 0, 38)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    toggleBtn.TextColor3 = Color3.fromRGB(175, 175, 190)
    toggleBtn.TextSize = 12
    toggleBtn.Font = Enum.Font.GothamMedium
    toggleBtn.Text = "  " .. textLabel
    toggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    toggleBtn.Parent = targetTab
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 6)
    tCorner.Parent = toggleBtn
    
    local statusIndicator = Instance.new("Frame")
    statusIndicator.Size = UDim2.new(0, 8, 0, 8)
    statusIndicator.Position = UDim2.new(1, -16, 0.5, -4)
    statusIndicator.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
    statusIndicator.Parent = toggleBtn
    
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = statusIndicator
    
    local toggled = false
    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(22, 38, 28)
            toggleBtn.TextColor3 = Color3.fromRGB(225, 255, 235)
            statusIndicator.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
            toggleBtn.TextColor3 = Color3.fromRGB(175, 175, 190)
            statusIndicator.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
        end
        callbackFunction(toggled)
    end)
end

-- Заполнение интерфейса функциями
CreateToggle(TabMain, "Автофарм монет (Режим: Nearest)", function(state) 
    Settings.AutoFarm = state 
    Settings.FarmMode = "Nearest"
end)

CreateToggle(TabMain, "Автофарм монет (Режим: Random)", function(state) 
    Settings.AutoFarm = state 
    Settings.FarmMode = "Random"
end)

CreateToggle(TabMain, "Автоподбор оружия (GunDrop)", function(state) 
    Settings.AutoGrabGun = state 
end)

CreateToggle(TabVisuals, "ESP Ролей (Highlight игроков)", function(state) 
    Settings.ESPEnabled = state 
end)

CreateToggle(TabCombat, "Автоаим на Маньяка", function(state) 
    Settings.AutoAim = state 
end)

CreateToggle(TabCombat, "Банихоп (Spacebar)", function(state) 
    Settings.BunnyHop = state 
end)


--------------------------------------------------------------------------------
-- ПРОФЕССИОНАЛЬНАЯ ЛОГИКА И СИСТЕМНЫЕ СЕРВИСЫ
--------------------------------------------------------------------------------

local ActiveCoinsCache = {}
local RoundCollectedCount = 0
local MaxRoundCoins = 10

-- Валидация монеты в пространстве
local function IsValidCoin(object)
    return object and object.Name == "Coin" and object:IsA("BasePart") and object.Parent ~= nil
end

-- Первичное сканирование карты
for _, obj in ipairs(Workspace:GetDescendants()) do
    if IsValidCoin(obj) then
        table.insert(ActiveCoinsCache, obj)
    end
end

-- Реактивное добавление новых монет от сервера
Workspace.DescendantAdded:Connect(function(obj)
    if IsValidCoin(obj) then
        table.insert(ActiveCoinsCache, obj)
    end
end)

-- Очистка кэша при сборе/удалении
Workspace.DescendantRemoving:Connect(function(obj)
    for index, coin in ipairs(ActiveCoinsCache) do
        if coin == obj then
            table.remove(ActiveCoinsCache, index)
            break
        end
    end
end)

-- Сброс счетчика лимита раунда
Workspace.ChildAdded:Connect(function(child)
    if child.Name == "CoinContainer" or child.Name == "Map" then
        RoundCollectedCount = 0
    end
end)

-- 1. Интеллектуальный автофарм (TweenService + Режимы Nearest/Random)
task.spawn(function()
    local activeTween = nil
    while true do
        task.wait(0.15)
        if Settings.AutoFarm then
            pcall(function()
                if RoundCollectedCount >= MaxRoundCoins then return end

                local character = LocalPlayer.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if not rootPart or not humanoid or humanoid.Health <= 0 then return end

                local targetCoin = nil

                -- Обработка режимов фарма
                if Settings.FarmMode == "Nearest" then
                    local minDistance = math.huge
                    for i = #ActiveCoinsCache, 1, -1 do
                        local coin = ActiveCoinsCache[i]
                        if IsValidCoin(coin) then
                            local dist = (rootPart.Position - coin.Position).Magnitude
                            if dist < minDistance then
                                minDistance = dist
                                targetCoin = coin
                            end
                        else
                            table.remove(ActiveCoinsCache, i)
                        end
                    end
                elseif Settings.FarmMode == "Random" then
                    local validList = {}
                    for i = #ActiveCoinsCache, 1, -1 do
                        local coin = ActiveCoinsCache[i]
                        if IsValidCoin(coin) then
                            table.insert(validList, coin)
                        else
                            table.remove(ActiveCoinsCache, i)
                        end
                    end
                    if #validList > 0 then
                        targetCoin = validList[math.random(1, #validList)]
                    end
                end

                if targetCoin then
                    if activeTween then activeTween:Cancel() end

                    local travelSpeed = 45 -- Оптимальная скорость во избежание десинка
                    local distanceToCoin = (rootPart.Position - targetCoin.Position).Magnitude
                    local flightDuration = distanceToCoin / travelSpeed

                    local tweenInfo = TweenInfo.new(flightDuration, Enum.EasingStyle.Linear)
                    activeTween = TweenService:Create(rootPart, tweenInfo, {CFrame = CFrame.new(targetCoin.Position + Vector3.new(0, 2, 0))})
                    activeTween:Play()

                    while activeTween.PlaybackState == Enum.PlaybackState.Playing do
                        if not IsValidCoin(targetCoin) then
                            activeTween:Cancel()
                            RoundCollectedCount = RoundCollectedCount + 1
                            break
                        end
                        task.wait(0.03)
                    end
                    activeTween.Completed:Wait()
                end
            end)
        else
            if activeTween then activeTween:Cancel() end
        end
    end
end)

-- 2. ESP Ролей (Определение Шерифа, Маньяка и Мирных)
local function ResolvePlayerRole(player)
    if player.Character then
        if player.Character:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun") then
            return Color3.fromRGB(52, 152, 219) -- Шериф (Синий)
        elseif player.Character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife") then
            return Color3.fromRGB(231, 76, 60)  -- Маньяк (Красный)
        end
    end
    return Color3.fromRGB(46, 204, 113)         -- Мирный (Зеленый)
end

RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local highlight = plr.Character:FindFirstChild("ProfessionalHubESP")
            if Settings.ESPEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ProfessionalHubESP"
                    highlight.Adornee = plr.Character
                    highlight.Parent = plr.Character
                end
                highlight.FillColor = ResolvePlayerRole(plr)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

-- 3. Автоподбор упавшего оружия (GunDrop)
task.spawn(function()
    while true do
        task.wait(0.4)
        if Settings.AutoGrabGun then
            pcall(function()
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj.Name == "GunDrop" and obj:IsA("BasePart") then
                        local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            rootPart.CFrame = obj.CFrame
                        end
                    end
                end
            end)
        end
    end
end)

-- 4. Автоаим на владельца ножа (Маньяка)
RunService.RenderStepped:Connect(function()
    if Settings.AutoAim then
        pcall(function()
            local char = LocalPlayer.Character
            if char and (char:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")) then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        if ResolvePlayerRole(plr) == Color3.fromRGB(231, 76, 60) then
                            local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                            if targetRoot then
                                Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, targetRoot.Position)
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- 5. Банихоп
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and Settings.BunnyHop and input.KeyCode == Enum.KeyCode.Space then
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

print("MM2 Security Hub successfully initialized.")
