--[[
    @File: Celestiaskript.lua
    @Project: MM2 Advanced Security Hub & Trolling
    @Author: Celestia
    @Description: Professional grade automation, custom UI loader, universal coin farm, and advanced trolling mechanics
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- Защита от повторного запуска
if CoreGui:FindFirstChild("CelestiaAdvancedHub") then
    CoreGui.CelestiaAdvancedHub:Destroy()
end
if CoreGui:FindFirstChild("CelestiaLoader") then
    CoreGui.CelestiaLoader:Destroy()
end

--------------------------------------------------------------------------------
-- ЭКРАН ЗАГРУЗКИ (LOADING INTRO: "Celestia")
--------------------------------------------------------------------------------
local LoaderGui = Instance.new("ScreenGui")
LoaderGui.Name = "CelestiaLoader"
LoaderGui.ResetOnSpawn = false
LoaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoaderGui.Parent = CoreGui

local LoaderFrame = Instance.new("Frame")
LoaderFrame.Size = UDim2.new(0, 320, 0, 110)
LoaderFrame.Position = UDim2.new(0.5, -160, 0.5, -55)
LoaderFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
LoaderFrame.BorderSizePixel = 0
LoaderFrame.Parent = LoaderGui

local LoaderCorner = Instance.new("UICorner")
LoaderCorner.CornerRadius = UDim.new(0, 10)
LoaderCorner.Parent = LoaderFrame

local LoaderStroke = Instance.new("UIStroke")
LoaderStroke.Color = Color3.fromRGB(45, 45, 60)
LoaderStroke.Thickness = 1
LoaderStroke.Parent = LoaderFrame

local LoaderText = Instance.new("TextLabel")
LoaderText.Size = UDim2.new(1, 0, 0, 40)
LoaderText.Position = UDim2.new(0, 0, 0, 20)
LoaderText.BackgroundTransparency = 1
LoaderText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoaderText.TextSize = 24
LoaderText.Font = Enum.Font.GothamBold
LoaderText.Text = ""
LoaderText.Parent = LoaderFrame

local LoaderSub = Instance.new("TextLabel")
LoaderSub.Size = UDim2.new(1, 0, 0, 20)
LoaderSub.Position = UDim2.new(0, 0, 0, 65)
LoaderSub.BackgroundTransparency = 1
LoaderSub.TextColor3 = Color3.fromRGB(115, 115, 135)
LoaderSub.TextSize = 11
LoaderSub.Font = Enum.Font.GothamMedium
LoaderSub.Text = "Initializing Security & Trolling Hub..."
LoaderSub.Parent = LoaderFrame

-- Анимация побуквенного появления имени "Celestia"
task.spawn(function()
    local targetString = "Celestia"
    for i = 1, #targetString do
        LoaderText.Text = targetString:sub(1, i)
        task.wait(0.12)
    end
    task.wait(0.5)
    
    -- Плавное исчезновение загрузчика
    local fadeTween = TweenService:Create(LoaderFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
    fadeTween:Play()
    TweenService:Create(LoaderText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(LoaderSub, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(LoaderStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
    task.wait(0.5)
    LoaderGui:Destroy()
end)

--------------------------------------------------------------------------------
-- СОСТОЯНИЕ СКРИПТА (SETTINGS)
--------------------------------------------------------------------------------
local Settings = {
    AutoFarm = false,
    FarmMode = "Nearest",
    ESPEnabled = false,
    AutoAim = false,
    AutoGrabGun = false,
    BunnyHop = false,
    TrollingMode = "None",
    SelectedEmote = "None",
    TargetPlayer = "None"
}

--------------------------------------------------------------------------------
-- ГЛАВНЫЙ ИНТЕРФЕЙС (UI ARCHITECTURE)
--------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CelestiaAdvancedHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 420)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -210)
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

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = Sidebar

local SidebarFix = Instance.new("Frame")
SidebarFix.Size = UDim2.new(0, 10, 1, 0)
SidebarFix.Position = UDim2.new(1, -10, 0, 0)
SidebarFix.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
SidebarFix.BorderSizePixel = 0
SidebarFix.Parent = Sidebar

local HubTitle = Instance.new("TextLabel")
HubTitle.Size = UDim2.new(1, 0, 0, 60)
HubTitle.BackgroundTransparency = 1
HubTitle.TextColor3 = Color3.fromRGB(245, 245, 250)
HubTitle.TextSize = 13
HubTitle.Font = Enum.Font.GothamBold
HubTitle.Text = "MM2 SECURITY HUB\n<font size='9' color='#7A7A8C'>v3.0 Pro Ultimate</font>"
HubTitle.RichText = true
HubTitle.Parent = Sidebar

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

-- Создание вкладок
local TabMain = CreateTab("Automation")
local TabVisuals = CreateTab("Visuals & ESP")
local TabCombat = CreateTab("Combat & Misc")
local TabTrolling = CreateTab("Trolling & Emotes")

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

-- Компонент выпадающего меню со стрелочкой (Dropdown)
local function CreateDropdown(targetTab, titleText, optionsList, defaultOption, callbackFunction)
    local dropContainer = Instance.new("Frame")
    dropContainer.Size = UDim2.new(1, -6, 0, 38)
    dropContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    dropContainer.Parent = targetTab
    
    local dCorner = Instance.new("UICorner")
    dCorner.CornerRadius = UDim.new(0, 6)
    dCorner.Parent = dropContainer

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(175, 175, 190)
    titleLabel.TextSize = 12
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.Text = titleText .. ": " .. defaultOption
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = dropContainer

    local arrowBtn = Instance.new("TextButton")
    arrowBtn.Size = UDim2.new(0, 30, 0, 38)
    arrowBtn.Position = UDim2.new(1, -35, 0, 0)
    arrowBtn.BackgroundTransparency = 1
    arrowBtn.TextColor3 = Color3.fromRGB(200, 200, 215)
    arrowBtn.TextSize = 14
    arrowBtn.Font = Enum.Font.GothamBold
    arrowBtn.Text = "▼"
    arrowBtn.Parent = dropContainer

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, 0, 0, 0)
    listFrame.Position = UDim2.new(0, 0, 1, 4)
    listFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    listFrame.BorderSizePixel = 0
    listFrame.Visible = false
    listFrame.ZIndex = 5
    listFrame.CanvasSize = UDim2.new(0, 0, 0, #optionsList * 32)
    listFrame.ScrollBarThickness = 2
    listFrame.Parent = dropContainer

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 6)
    listCorner.Parent = listFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = listFrame

    local isOpen = false
    arrowBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            listFrame.Visible = true
            arrowBtn.Text = "▲"
            TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, math.min(#optionsList * 32, 120)}):Play()
        else
            arrowBtn.Text = "▼"
            local tw = TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)})
            tw:Play()
            tw.Completed:Connect(function()
                if not isOpen then listFrame.Visible = false end
            end)
        end
    end)

    for _, opt in ipairs(optionsList) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 32)
        optBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
        optBtn.BackgroundTransparency = 1
        optBtn.TextColor3 = Color3.fromRGB(160, 160, 180)
        optBtn.TextSize = 11
        optBtn.Font = Enum.Font.Gotham
        optBtn.Text = "  " .. opt
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.ZIndex = 6
        optBtn.Parent = listFrame

        optBtn.MouseButton1Click:Connect(function()
            titleLabel.Text = titleText .. ": " .. opt
            isOpen = false
            arrowBtn.Text = "▼"
            listFrame.Visible = false
            listFrame.Size = UDim2.new(1, 0, 0, 0)
            callbackFunction(opt)
        end)
    end
end

-- Элементы управления
CreateToggle(TabMain, "Автофарм монет (Nearest)", function(state) 
    Settings.AutoFarm = state 
    Settings.FarmMode = "Nearest"
end)

CreateToggle(TabMain, "Автофарм монет (Random)", function(state) 
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

-- Выпадающие меню для троллинга и эмоций
CreateDropdown(TabTrolling, "Режим троллинга", {"None", "Fling Aura", "Orbit Target", "Spinbot"}, "None", function(val)
    Settings.TrollingMode = val
end)

CreateDropdown(TabTrolling, "Эмоция MM2", {"None", "Sit", "Dance", "Headless", "Zen", "Laugh"}, "None", function(val)
    Settings.SelectedEmote = val
    pcall(function()
        if val ~= "None" then
            local emotesRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Emote")
            if emotesRemote then
                emotesRemote:FireServer(val)
            end
        end
    end)
end)


--------------------------------------------------------------------------------
-- УНИВЕРСАЛЬНЫЙ АВТОФАРМ МОНЕТ (Любая карта и контейнеры)
--------------------------------------------------------------------------------
local RoundCollectedCount = 0
local MaxRoundCoins = 10

local function GetValidCoins()
    local coins = {}
    -- Проходим по всем объектам Workspace, включая динамические папки карт и хранилища монет
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local nameLower = obj.Name:lower()
        if nameLower == "coin" or nameLower == "coinvisual" or nameLower:find("coin") or nameLower == "coingrab" then
            if obj:IsA("BasePart") and obj.Parent ~= nil then
                table.insert(coins, obj)
            elseif obj:IsA("Model") and obj.PrimaryPart then
                table.insert(coins, obj.PrimaryPart)
            elseif obj:IsA("Model") then
                for _, part in ipairs(obj:GetChildren()) do
                    if part:IsA("BasePart") then
                        table.insert(coins, part)
                        break
                    end
                end
            end
        end
    end
    return coins
end

-- Сброс счетчика при смене раунда/карты
Workspace.ChildAdded:Connect(function(child)
    if child.Name == "CoinContainer" or child.Name == "Map" or child.Name == "CurrentMap" then
        RoundCollectedCount = 0
    end
end)

-- Основной цикл универсального фарма
task.spawn(function()
    local activeTween = nil
    while true do
        task.wait(0.08)
        if Settings.AutoFarm then
            pcall(function()
                if RoundCollectedCount >= MaxRoundCoins then return end

                local character = LocalPlayer.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if not rootPart or not humanoid or humanoid.Health <= 0 then return end

                local availableCoins = GetValidCoins()
                if #availableCoins == 0 then return end

                local targetCoin = nil

                if Settings.FarmMode == "Nearest" then
                    local minDistance = math.huge
                    for _, coin in ipairs(availableCoins) do
                        local dist = (rootPart.Position - coin.Position).Magnitude
                        if dist < minDistance then
                            minDistance = dist
                            targetCoin = coin
                        end
                    end
                elseif Settings.FarmMode == "Random" then
                    targetCoin = availableCoins[math.random(1, #availableCoins)]
                end

                if targetCoin then
                    if activeTween then activeTween:Cancel() end

                    local travelSpeed = 65 -- скорость полета к монете
                    local distanceToCoin = (rootPart.Position - targetCoin.Position).Magnitude
                    local flightDuration = distanceToCoin / travelSpeed

                    local tweenInfo = TweenInfo.new(flightDuration, Enum.EasingStyle.Linear)
                    activeTween = TweenService:Create(rootPart, tweenInfo, {CFrame = CFrame.new(targetCoin.Position + Vector3.new(0, 1.5, 0))})
                    activeTween:Play()

                    while activeTween.PlaybackState == Enum.PlaybackState.Playing do
                        if not targetCoin.Parent or (rootPart.Position - targetCoin.Position).Magnitude < 3 then
                            activeTween:Cancel()
                            RoundCollectedCount = RoundCollectedCount + 1
                            break
                        end
                        task.wait(0.02)
                    end
                end
            end)
        else
            if activeTween then activeTween:Cancel() end
        end
    end
end)


--------------------------------------------------------------------------------
-- ЛОГИКА ТРОЛЛИНГА, ФЛИНГА И ОРБИТЫ
--------------------------------------------------------------------------------
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if Settings.TrollingMode == "Fling Aura" then
            hrp.Velocity = Vector3.new(35000, 35000, 35000)
            hrp.RotVelocity = Vector3.new(99999, 99999, 99999)
        elseif Settings.TrollingMode == "S
