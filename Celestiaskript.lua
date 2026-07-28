local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

pcall(function()
    if CoreGui:FindFirstChild("CelestiaLegacyHub") then
        CoreGui.CelestiaLegacyHub:Destroy()
    end
end)

local Settings = {
    AutoFarm = false,
    ESP = false,
    AutoGun = false,
    Fling = false
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CelestiaLegacyHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 260)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 6)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.Text = "Celestia Hub [MM2]"
Title.Parent = MainFrame

local function CreateButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
    btn.Text = name .. ": OFF"
    btn.Parent = MainFrame
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 4)
    bCorner.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(30, 80, 45)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = name .. ": ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Text = name .. ": OFF"
        end
        callback(state)
    end)
end

CreateButton("Auto Farm Coins", 45, function(state) Settings.AutoFarm = state end)
CreateButton("ESP Roles", 85, function(state) Settings.ESP = state end)
CreateButton("Auto Grab Gun", 125, function(state) Settings.AutoGun = state end)
CreateButton("Fling Aura", 165, function(state) Settings.Fling = state end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(1, -20, 0, 30)
CloseBtn.Position = UDim2.new(0, 10, 0, 215)
CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 25, 25)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "Unload Hub"
CloseBtn.Parent = MainFrame

local cCorner = Instance.new("UICorner")
cCorner.CornerRadius = UDim.new(0, 4)
cCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

task.spawn(function()
    while true do
        task.wait(0.2)
        if Settings.AutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not Settings.AutoFarm then break end
                    if obj.Name:lower():find("coin") then
                        local part = obj:IsA("BasePart") and obj or (obj:IsModel() and obj.PrimaryPart)
                        if part and (part.Position - hrp.Position).Magnitude < 400 then
                            hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 0.5, 0))
                            task.wait(0.05)
                        end
                    end
                end
            end)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and Settings.Fling then
            hrp.Velocity = Vector3.new(30000, 30000, 30000)
        end
    end)
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hl = plr.Character:FindFirstChild("LegacyESP")
                if Settings.ESP then
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "LegacyESP"
                        hl.Adornee = plr.Character
                        hl.Parent = plr.Character
                    end
                    local col = Color3.fromRGB(0, 255, 0)
                    if plr.Character:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Knife") then
                        col = Color3.fromRGB(255, 0, 0)
                    elseif plr.Character:FindFirstChild("Gun") or plr.Backpack:FindFirstChild("Gun") then
                        col = Color3.fromRGB(0, 120, 255)
                    end
                    hl.FillColor = col
                else
                    if hl then hl:Destroy() end
                end
            end
        end
    end)
end)

task.spawn(function()
    while true do
        task.wait(0.3)
        if Settings.AutoGun then
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
