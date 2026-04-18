-- 1. UI Yaratish
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local IslandList = Instance.new("ScrollingFrame")
local ChestToggle = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 250, 0, 350)
Frame.Active = true
Frame.Draggable = true -- Menuni ekranda surish imkoniyati

Title.Parent = Frame
Title.Text = "Blox Fruits Helper"
Title.Size = UDim2.new(1, 0, 0.1, 0)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1

-- 2. Orollar Ro'yxati (Sea 1 misolida)
local Islands = {
    ["Starter Island"] = CFrame.new(1000, 50, 1000),
    ["Jungle"] = CFrame.new(-1200, 40, 200),
    ["Pirate Village"] = CFrame.new(-1100, 30, -3500),
    ["Desert"] = CFrame.new(1000, 10, -3000),
    ["Snow Island"] = CFrame.new(1200, 150, -1300)
}

IslandList.Parent = Frame
IslandList.Position = UDim2.new(0, 0, 0.15, 0)
IslandList.Size = UDim2.new(1, 0, 0.6, 0)
IslandList.CanvasSize = UDim2.new(0, 0, 2, 0)

-- Orollar uchun tugmalar yaratish
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

-- 3. Chest Farm Funksiyasi
local farming = false
ChestToggle.Parent = Frame
ChestToggle.Position = UDim2.new(0, 5, 0.8, 0)
ChestToggle.Size = UDim2.new(1, -10, 0, 40)
ChestToggle.Text = "Chest Farm: OFF"
ChestToggle.BackgroundColor3 = Color3.new(1, 0, 0)

ChestToggle.MouseButton1Click:Connect(function()
    farming = not farming
    ChestToggle.Text = farming and "Chest Farm: ON" or "Chest Farm: OFF"
    ChestToggle.BackgroundColor3 = farming and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    
    spawn(function()
        while farming do
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