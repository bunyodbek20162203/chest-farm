local UIS = game:GetService("UserInputService")

-- 1. UI Yaratish
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local IslandList = Instance.new("ScrollingFrame")
local ChestToggle = Instance.new("TextButton")
local LevelToggle = Instance.new("TextButton")
local FruitBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton") -- Yangi: X tugmasi

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "BunyodbekHub"
ScreenGui.ResetOnSpawn = false -- O'lganda menyu yo'qolmasligi uchun

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Position = UDim2.new(0.3, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 260, 0, 450)
Frame.Active = true
Frame.Draggable = true

-- --- YANGI: X TUGMASI ---
CloseBtn.Parent = Frame
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextScaled = true

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false -- Menyuni yashirish
end)

-- --- YANGI: K TUGMASI (KLAVIATURA) ---
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then -- Agar chatga yozilmayotgan bo'lsa
        if input.KeyCode == Enum.KeyCode.K then
            ScreenGui.Enabled = not ScreenGui.Enabled -- K ni bossa ochiladi/yopiladi
        end
    end
end)

-- --- QOLGAN FUNKSIYALAR ---
Title.Parent = Frame
Title.Text = "Bunyodbek Hub (K to Open)"
Title.Size = UDim2.new(1, 0, 0.08, 0)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Orollar ro'yxati (Oldingi kodingdek...)
local Islands = {
    ["Starter Island"] = CFrame.new(1000, 50, 1000),
    ["Jungle"] = CFrame.new(-1200, 40, 200),
    ["Pirate Village"] = CFrame.new(-1100, 30, -3500),
    ["Desert"] = CFrame.new(1000, 10, -3000),
    ["Snow Island"] = CFrame.new(1200, 150, -1300)
}

IslandList.Parent = Frame
IslandList.Position = UDim2.new(0, 5, 0.1, 0)
IslandList.Size = UDim2.new(1, -10, 0.4, 0)
IslandList.CanvasSize = UDim2.new(0, 0, 2, 0)

local yOffset = 0
for name, coords in pairs(Islands) do
    local btn = Instance.new("TextButton")
    btn.Parent = IslandList
    btn.Text = name
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, yOffset)
    yOffset = yOffset + 35
    btn.MouseButton1Click:Connect(function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = coords
    end)
end

-- Chest Farm
local farmingChest = false
ChestToggle.Parent = Frame
ChestToggle.Position = UDim2.new(0, 5, 0.55, 0)
ChestToggle.Size = UDim2.new(1, -10, 0, 35)
ChestToggle.Text = "Chest Farm: OFF"
ChestToggle.BackgroundColor3 = Color3.new(0.6, 0, 0)

ChestToggle.MouseButton1Click:Connect(function()
    farmingChest = not farmingChest
    ChestToggle.Text = farmingChest and "Chest Farm: ON" or "Chest Farm: OFF"
    ChestToggle.BackgroundColor3 = farmingChest and Color3.new(0, 0.6, 0) or Color3.new(0.6, 0, 0)
    spawn(function()
        while farmingChest do
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v.Name:find("Chest") and v:IsA("Part") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                    wait(0.7)
                end
            end
            wait(1)
        end
    end)
end)

-- Auto Level & Hitbox
local autoLevel = false
LevelToggle.Parent = Frame
LevelToggle.Position = UDim2.new(0, 5, 0.65, 0)
LevelToggle.Size = UDim2.new(1, -10, 0, 35)
LevelToggle.Text = "Auto Level: OFF"
LevelToggle.BackgroundColor3 = Color3.new(0.6, 0, 0)

LevelToggle.MouseButton1Click:Connect(function()
    autoLevel = not autoLevel
    LevelToggle.Text = autoLevel and "Auto Level: ON" or "Auto Level: OFF"
    LevelToggle.BackgroundColor3 = autoLevel and Color3.new(0, 0.6, 0) or Color3.new(0.6, 0, 0)
    spawn(function()
        while autoLevel do
            pcall(function()
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                        if v.HumanoidRootPart:FindFirstChild("Size") then
                            v.HumanoidRootPart.Size = Vector3.new(30, 30, 30)
                            v.HumanoidRootPart.CanCollide = false
                        end
                    end
                end
            end)
            wait(0.1)
        end
    end)
end)

-- Fruit Finder
FruitBtn.Parent = Frame
FruitBtn.Position = UDim2.new(0, 5, 0.75, 0)
FruitBtn.Size = UDim2.new(1, -10, 0, 35)
FruitBtn.Text = "Find Fruit"
FruitBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 150)

FruitBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") and v.Name:find("Fruit") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
            break
        end
    end
end)