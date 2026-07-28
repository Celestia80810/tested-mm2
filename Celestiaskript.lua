--[[
    @File: Celestiaskript.lua
    @Project: MM2 Advanced Security Hub & Trolling
    @Author: Celestia
    @Description: Xeno-Compatible Stable Build v3.2
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
pcall(function()
    if CoreGui:FindFirstChild("CelestiaAdvancedHub") then
        CoreGui.CelestiaAdvancedHub:Destroy()
    end
    if CoreGui:FindFirstChild("CelestiaLoader") then
        CoreGui.CelestiaLoader:Destroy()
    end
end)

--------------------------------------------------------------------------------
-- СТАБИЛЬНЫЙ ЭКРАН ЗАГРУЗКИ (Xeno-Safe)
--------------------------------------------------------------------------------
local LoaderGui = Instance.new("ScreenGui")
LoaderGui.Name = "CelestiaLoader"
LoaderGui.ResetOnSpawn = false
LoaderGui.Parent = CoreGui

local LoaderFrame = Instance.new("Frame")
LoaderFrame.Size = UDim2.new(0, 320, 0, 100)
LoaderFrame.Position = UDim2.new(0.5, -160, 0.5, -50)
LoaderFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
LoaderFrame.BorderSizePixel = 0
LoaderFrame.Parent = LoaderGui

local LoaderCorner = Instance.new("UICorner")
LoaderCorner.CornerRadius = UDim.new(0, 8)
LoaderCorner.Parent = LoaderFrame

local LoaderText = Instance.new("TextLabel")
LoaderText.Size = UDim2.new(1, 0, 0, 40)
LoaderText.Position = UDim2.new(0, 0, 0, 15)
LoaderText.BackgroundTransparency = 1
LoaderText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoaderText.TextSize = 22
LoaderText.Font = Enum.Font.GothamBold
LoaderText.Text = ""
LoaderText.Parent = LoaderFrame

local LoaderSub = Instance.new("TextLabel")
LoaderSub.Size = UDim2.new(1, 0, 0, 20)
LoaderSub.Position = UDim2.new(0, 0, 0, 60)
LoaderSub.BackgroundTransparency = 1
LoaderSub.TextColor3 = Color3.fromRGB(115, 115, 135)
LoaderSub.TextSize = 11
LoaderSub.Font = Enum.Font.GothamMedium
LoaderSub.Text = "Loading Xeno Compatibility..."
LoaderSub.Parent = LoaderFrame

task.spawn(function()
    pcall(function()
        local nameStr = "Celestia"
        for i = 1, #nameStr do
            LoaderText.Text = nameStr:sub(1, i)
            task.wait(0.1)
        end
        task.wait(0.4)
    end)
    pcall(function()
        LoaderGui:Destroy()
    end)
end)

--------------------------------------------------------------------------------
-- СОСТОЯНИЕ СКРИПТА
--------------------------------------------------------------------------------
local Settings = {
    AutoFarm = false,
    FarmMode = "Nearest",
    ESPEnabled = false,
    AutoAim = false,
    AutoGrabGun = false,
    BunnyHop = false,
    TrollingMode = "None",
    SelectedEmote = "None"
}

--------------------------------------------------------------------------------
-- ГЛАВНЫЙ ИНТЕРФЕЙС
--------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CelestiaAdvancedHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 400)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = Sidebar

local HubTitle = Instance.new("TextLabel")
HubTitle.Size = UDim2.new(1, 0, 0, 55)
HubTitle.BackgroundTransparency = 1
HubTitle.TextColor3 = Color3.fromRGB(245, 245, 250)
HubTitle.TextSize = 12
HubTitle.Font = Enum.Font.GothamBold
HubTitle.Text = "MM2 SECURITY HUB\nCelestia v3.2"
HubTitle.Parent = Sidebar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Position = UDim2.new(1, -30, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
CloseButton.TextColor3 = Color3.fromRGB(180, 180, 195)
CloseButton.TextSize = 10
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -162, 1, -20)
ContentArea.Position = UDim2.new(0, 156, 0, 10)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local TabsList = {}
local ButtonsList = {}
local ActiveTab = nil

local function CreateTab(tabName)
    local idx = #ButtonsList + 1
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, -16, 0, 34)
    tabButton.Position = UDim2.new(0, 8, 0, 65 + ((idx - 1) * 38))
    tabButton.BackgroundColor3 = Color3.fromRGB(20, 20, 27)
    tabButton.TextColor3 = Color3.fromRGB(130, 130, 145)
    tabButton.TextSize = 11
    tabButton.Font = Enum.Font.GothamMedium
    tabButton.Text = "  " .. tabName
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
    tabScrolling.ScrollBarThickness = 2
    tabScrolling.Visible = false
    tabScrolling.Parent = ContentArea

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 6)
    listLayout.Parent = tabScrolling

    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabScrolling.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)

    table.insert(TabsList, tabScrolling)
    table.insert(ButtonsList, tabButton)

    local currentIdx = #TabsList
    tabButton.MouseButton1Click:Connect(function()
        for i, tFrame in ipairs(TabsList) do
            tFrame.Visible = (i == currentIdx)
            ButtonsList[i].BackgroundColor3 = (i == currentIdx) and Color3.fromRGB(28, 28, 38) or Color3.fromRGB(20, 20, 27)
            ButtonsList[i].TextColor3 = (i == currentIdx) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(130, 130, 145)
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

local TabMain = CreateTab("Automation")
local TabVisuals = CreateTab("Visuals & ESP")
local TabCombat = CreateTab("Combat & Misc")
local TabTrolling = CreateTab("Trolling & Emotes")

local function CreateToggle(targetTab, textLabel, callback)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, -4, 0, 36)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    toggleBtn.TextColor3 = Color3.fromRGB(175, 175, 190)
    toggleBtn.TextSize = 11
    toggleBtn.Font = Enum.Font.GothamMedium
    toggleBtn.Text = "  " .. textLabel
    toggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    toggleBtn.Parent = targetTab
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 6)
    tCorner.Parent = toggleBtn
    
    local statusIndicator = Instance.new("Frame")
    statusIndicator.Size = UDim2.new(0, 8, 0, 8)
    statusIndicator.Position = UDim2.new(1, -14, 0.5, -4)
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
        pcall(function() callback(toggled) end)
    end)
end

local function CreateDropdown(targetTab, titleText, optionsList, defaultOption, callback)
    local dropContainer = Instance.new("Frame")
    dropContainer.Size = UDim2.new(1, -4, 0, 36)
    dropContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    dropContainer.Parent = targetTab
    
    local dCorner = Instance.new("UICorner")
    dCorner.CornerRadius = UDim.new(0, 6)
    dCorner.Parent = dropContainer

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 8, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(175, 175, 190)
    titleLabel.TextSize = 11
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.Text = titleText .. ": " .. defaultOption
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = dropContainer

    local arrowBtn = Instance.new("TextButton")
    arrowBtn.Size = UDim2.new(0, 30, 0, 36)
    arrowBtn.Position = UDim2.new(1, -30, 0, 0)
    arrowBtn.BackgroundTransparency = 1
    arrowBtn.TextColor3 = Color3.fromRGB(200, 200, 215)
    arrowBtn.TextSize = 12
    arrowBtn.Font = Enum.Font.GothamBold
    arrowBtn.Text = "v"
    arrowBtn.Parent = dropContainer

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, 0, 0, 0)
    listFrame.Position = UDim2.new(0, 0, 1, 3)
    listFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    listFrame.BorderSizePixel = 0
    listFrame.Visible = false
    listFrame.ZIndex = 5
    listFrame.CanvasSize = UDim2.new(0, 0, 0, #optionsList * 30)
    listFrame.ScrollBarThickness = 2
    listFrame.Parent = dropContainer

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 6)
    listCorner.Parent = listFrame

    local isOpen = false
    arrowBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            listFrame.Visible = true
            arrowBtn.Text = "^"
            listFrame.Size = UDim2.new(1, 0, 0, math.min(#optionsList * 30, 110))
        else
            arrowBtn.Text = "v"
            listFrame.Visible = false
            listFrame.Size = UDim2.new(1, 0, 0, 0)
        end
    end)

    for _, opt in ipairs(optionsList) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
        optBtn.BackgroundTransparency = 1
        optBtn.TextColor3 = Color3.fromRGB(160, 160, 180)
        optBtn.TextSize = 10
        optBtn.Font = Enum.Font.Gotham
        optBtn.Text = "  " .. opt
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.ZIndex = 6
        optBtn.Parent = listFrame

        optBtn.MouseButton1Click:Connect(function()
            titleLabel.Text = titleText .. ": " .. opt
            isOpen = false
            arrowBtn.Text = "v"
            listFrame.Visible = false
            listFrame.Size = UDim2.new(1, 0, 0, 0)
            pcall(function() callback(opt) end)
        end)
    end
end

-- Наполнение элементов
CreateToggle(TabMain, "Автофарм (Nearest)", function(state) Settings.AutoFarm = state Settings.FarmMode = "Nearest" end)
CreateToggle(TabMain, "Автофарм (Random)", function(state) Settings.AutoFarm = state Settings.FarmMode = "Random" end)
CreateToggle(TabMain, "Автоподбор оружия", function(state) Settings.AutoGrabGun = state end)

CreateToggle(TabVisuals, "ESP Ролей", function(state) Settings.ESPEnabled = state end)

CreateToggle(TabCombat, "Автоаим на Маньяка", function(state) Settings.AutoAim = state end)
CreateToggle(TabCombat, "Банихоп (Spacebar)", function(state) Settings.BunnyHop = state end)

CreateDropdown(TabTrolling, "Троллинг", {"None", "Fling Aura", "Spinbot", "Orbit Target"}, "None", function(val) Settings.TrollingMode = val end)
CreateDropdown(TabTrolling, "Эмоция", {"None", "Sit", "Dance", "Headless", "Zen", "Laugh"}, "None", function(val)
    Settings.SelectedEmote = val
    pcall(function()
        if val ~= "None" then
            local rem = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Emote")
            if rem then rem:FireServer(val) end
        end
    end)
end)

--------------------------------------------------------------------------------
-- ЛОГИКА ФУНКЦИЙ (Безопасный прогон)
--------------------------------------------------------------------------------

-- Автофарм
task.spawn(function()
    while true do
        task.wait(0.25)
        if Settings.AutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not Settings.AutoFarm then break end
                    local name = obj.Name:lower()
                    if name == "coin" or name == "coinvisual" or name:find("coin") then
                        local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
                        if part and part.Parent and (part.Position - hrp.Position).Magnitude < 400 then
                            local t = tick()
                            while part.Parent and (tick() - t) < 1.2 do
                                if not Settings.AutoFarm then break end
                                hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 0.4, 0))
                                task.wait(0.04)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Троллинг / Флинг
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if Settings.TrollingMode == "Fling Aura" then
            hrp.Velocity = Vector3.new(35000, 35000, 35000)
            hrp.RotVelocity = Vector3.new(99999, 99999, 99999)
        elseif Settings.TrollingMode == "Spinbot" then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(45), 0)
        elseif Settings.TrollingMode == "Orbit Target" then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local thrp = plr.Character.HumanoidRootPart
                    local angle = tick() * 6
                    hrp.CFrame = thrp.CFrame * CFrame.new(math.cos(angle) * 8, 3, math.sin(angle) * 8)
                    break
                end
            end
        end
    end)
end)

-- ESP
local function GetRole(plr)
    if plr.Character then
        if plr.Character:FindFirstChild("Gun") or plr.Backpack:FindFirstChild("Gun") then return Color3.fromRGB(52, 152, 219) end
        if plr.Character:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Knife") then return Color3.fromRGB(231, 76, 60) end
    end
    return Color3.fromRGB(46, 204, 113)
end

RunService.RenderStepped:Connect(function()
    pcall(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hl = plr.Character:FindFirstChild("CelestiaESP")
                if Settings.ESPEnabled then
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "CelestiaESP"
                        hl.Adornee = plr.Character
                        hl.Parent = plr.Character
                    end
                    hl.FillColor = GetRole(plr)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                else
                    if hl then hl:Destroy() end
                end
            end
        end
    end)
end)

-- Автоподбор оружия
task.spawn(function()
    while true do
        task.wait(0.3)
        if Settings.AutoGrabGun then
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

-- Автоаим
RunService.RenderStepped:Connect(function()
    if Settings.AutoAim then
        pcall(function()
            local char = LocalPlayer.Character
            if char and (char:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")) then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and GetRole(plr) == Color3.fromRGB(231, 76, 60) then
                        local th = plr.Character:FindFirstChild("HumanoidRootPart")
                        if th then Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, th.Position) end
                    end
                end
            end
        end)
    end
end)

-- Банихоп
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and Settings.BunnyHop and input.KeyCode == Enum.KeyCode.Space then
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
end)
