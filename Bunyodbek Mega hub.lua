local UIS = game:GetService("UserInputService")
local TPS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")

-- 1. UI Yaratish
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MainList = Instance.new("ScrollingFrame")
local IslandList = Instance.new("ScrollingFrame")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "Bunyodbek_Mega_Hub_V4"
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Frame.Position = UDim2.new(0.3, 0, 0.1, 0)
Frame.Size = UDim2.new(0, 320, 0, 580)
Frame.Active = true
Frame.Draggable = true
Frame.BorderSizePixel = 3
Frame.BorderColor3 = Color3.fromRGB(0, 255, 127) -- Neon yashil

Title.Parent = Frame
Title.Text = "BUNYODBEK MEGA HUB | K: Open"
Title.Size = UDim2.new(1, 0, 0.06, 0)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)

-- X tugmasi
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Frame
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui.Enabled = false end)

-- K tugmasi boshqaruvi
UIS.InputBegan:Connect(function(input, proc)
    if not proc and input.KeyCode == Enum.KeyCode.K then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- Listlarni sozlash
MainList.Parent = Frame
MainList.Position = UDim2.new(0, 5, 0.08, 0)
MainList.Size = UDim2.new(1, -10, 0.5, 0)
MainList.CanvasSize = UDim2.new(0, 0, 1.5, 0)
MainList.BackgroundTransparency = 1

IslandList.Parent = Frame
IslandList.Position = UDim2.new(0, 5, 0.6, 0)
IslandList.Size = UDim2.new(1, -10, 0.38, 0)
IslandList.CanvasSize = UDim2.new(0, 0, 3, 0)
IslandList.BackgroundColor3 = Color3.fromRGB(20, 20, 25)

-- Tugma yaratish funksiyasi
local function createButton(name, y, color, parent, callback)
    local b = Instance.new("TextButton")
    b.Parent = parent
    b.Text = name
    b.Size = UDim2.new(1, -10, 0, 35)
    b.Position = UDim2.new(0, 5, 0, y)
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    b.MouseButton1Click:Connect(callback)
    return b
end

-- --- ASOSIY FUNKSIYALAR ---

-- 1. Fruit Rain
createButton("FRUIT RAIN (Collect All)", 0, Color3.fromRGB(150, 0, 200), MainList, function()
    local found = false
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
            v.Handle.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            found = true
        end
    end
    game.StarterGui:SetCore("SendNotification", {
        Title = "Fruit Rain",
        Text = found and "Mevalar yig'ildi!" or "Meva topilmadi.",
        Duration = 3
    })
end)

-- 2. Fast Attack
local fa = false
local faBtn = createButton("Fast Attack: OFF", 40, Color3.fromRGB(100, 0, 0), MainList, function()
    fa = not fa
    faBtn.Text = "Fast Attack: " .. (fa and "ON" or "OFF")
    faBtn.BackgroundColor3 = fa and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
    task.spawn(function()
        while fa do
            local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
            task.wait(0.1)
        end
    end)
end)

-- 3. Auto Chest Farm
local cf = false
local cfBtn = createButton("Auto Chest Farm: OFF", 80, Color3.fromRGB(100, 0, 0), MainList, function()
    cf = not cf
    cfBtn.Text = "Auto Chest: " .. (cf and "ON" or "OFF")
    cfBtn.BackgroundColor3 = cf and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
    task.spawn(function()
        while cf do
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v.Name:find("Chest") and v:IsA("Part") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                    task.wait(0.6)
                end
            end
            task.wait(1)
        end
    end)
end)

-- 4. Auto Level (Hitbox)
local al = false
local alBtn = createButton("Auto Level (Hitbox): OFF", 120, Color3.fromRGB(100, 0, 0), MainList, function()
    al = not al
    alBtn.Text = "Auto Level: " .. (al and "ON" or "OFF")
    alBtn.BackgroundColor3 = al and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
    task.spawn(function()
        while al do
            pcall(function()
                for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                        enemy.HumanoidRootPart.Size = Vector3.new(40,40,40)
                        enemy.HumanoidRootPart.CanCollide = false
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end)

-- 5. Server Hop
createButton("Server Hop", 160, Color3.fromRGB(60, 60, 60), MainList, function()
    local servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
    for _, s in pairs(servers) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            TPS:TeleportToPlaceInstance(game.PlaceId, s.id)
        end
    end
end)

-- --- OROLLAR RO'YXATI ---
local Locations = {
    ["Starter Island"] = CFrame.new(1054, 16, 1547),
    ["Jungle (Monkey)"] = CFrame.new(-1250, 6, 345),
    ["Pirate Village"] = CFrame.new(-1120, 4, 3850),
    ["Desert"] = CFrame.new(1090, 6, 4400),
    ["Frozen Village"] = CFrame.new(1150, 27, -1300),
    ["Marine Fortress"] = CFrame.new(-5000, 20, 4300),
    ["Skylands"] = CFrame.new(-4800, 750, -1800),
    ["Prison"] = CFrame.new(4800, 5, 800),
    ["Magma Village"] = CFrame.new(-5300, 8, 8500),
    ["Underwater City"] = CFrame.new(3750, -10, -5450),
    ["Fountain City"] = CFrame.new(5250, 38, 4050),
    ["Middle Town"] = CFrame.new(-480, 20, 430)
}

local iy = 0
for name, cf in pairs(Locations) do
    local b = Instance.new("TextButton")
    b.Parent = IslandList
    b.Text = name
    b.Size = UDim2.new(1, -10, 0, 30)
    b.Position = UDim2.new(0, 5, 0, iy)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    b.TextColor3 = Color3.new(1, 1, 1)
    iy = iy + 35
    b.MouseButton1Click:Connect(function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cf
    end)
end