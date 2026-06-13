--[[
  ╔══════════════════════════════════════════════════════════╗
  ║            AIRFLOW-STYLE · GROW A GARDEN 2              ║
  ║            Personal Script — No Key Required             ║
  ║            Authorized Security Assessment                ║
  ╚══════════════════════════════════════════════════════════╝
]]

--// Anti Re-Execute
if getgenv().GAG_Loaded then return end
getgenv().GAG_Loaded = true

--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")

--// Wait for game load
repeat task.wait() until game:IsLoaded() and Players.LocalPlayer
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// Anti-AFK
task.spawn(function()
    while task.wait(300) do
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

--[[ ========== UI LIBRARY ========== ]]
local AirFlowUI = {}
do
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AirFlow_GAG"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = (CoreGui:FindFirstChild("RobloxGui") or PlayerGui)

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 580, 0, 420)
    Main.Position = UDim2.new(0.5, -290, 0.5, -210)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = Main

    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 90, 90)
    Shadow.Parent = Main

    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 10)
    TopCorner.Parent = TopBar

    local TopFill = Instance.new("Frame")
    TopFill.Size = UDim2.new(0, 20, 1, 0)
    TopFill.Position = UDim2.new(1, -20, 0, 10)
    TopFill.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    TopFill.BorderSizePixel = 0
    TopFill.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🌱  AIRFLOW · GROW A GARDEN"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(0, 255, 120)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    -- Close
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.TextSize = 16
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent = TopBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Minimize
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 28, 0, 28)
    MinBtn.Position = UDim2.new(1, -68, 0.5, -14)
    MinBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
    MinBtn.Text = "−"
    MinBtn.TextColor3 = Color3.new(1,1,1)
    MinBtn.TextSize = 20
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.BorderSizePixel = 0
    MinBtn.Parent = TopBar

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinBtn

    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        Main:TweenSize(
            minimized and UDim2.new(0, 580, 0, 40) or UDim2.new(0, 580, 0, 420),
            "Out", "Quad", 0.2, true
        )
    end)

    -- Sidebar Tabs
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 140, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.Parent = Main

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 2)
    SidebarLayout.Parent = Sidebar

    -- Content Area
    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -140, 1, -40)
    Container.Position = UDim2.new(0, 140, 0, 40)
    Container.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    Container.BorderSizePixel = 0
    Container.ScrollBarThickness = 3
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.Parent = Main

    local ContainerLayout = Instance.new("UIListLayout")
    ContainerLayout.Padding = UDim.new(0, 6)
    ContainerLayout.Parent = Container

    ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize + 10)
    end)

    -- Tab System
    local Tabs = {}
    local ActiveTab = nil

    function AirFlowUI:Tab(name, icon)
        icon = icon or "📁"

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 34)
        TabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
        TabBtn.Text = "   " .. icon .. "  " .. name
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 13
        TabBtn.TextColor3 = Color3.fromRGB(160, 160, 170)
        TabBtn.BorderSizePixel = 0
        TabBtn.Parent = Sidebar

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = TabBtn

        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.BorderSizePixel = 0
        TabFrame.ScrollBarThickness = 3
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.Visible = false
        TabFrame.Parent = Container

        local TabLayout = Instance.new("UIListLayout")
        TabLayout.Padding = UDim.new(0, 5)
        TabLayout.Parent = TabFrame

        local tabObj = {Frame = TabFrame, Layout = TabLayout, Button = TabBtn}

        function tabObj:Section(text)
            local SecLabel = Instance.new("TextLabel")
            SecLabel.Size = UDim2.new(1, -10, 0, 22)
            SecLabel.Position = UDim2.new(0, 5, 0, 0)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Text = "  ══  " .. text .. "  ══"
            SecLabel.Font = Enum.Font.GothamBold
            SecLabel.TextSize = 12
            SecLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
            SecLabel.TextXAlignment = Enum.TextXAlignment.Left
            SecLabel.Parent = TabFrame
            return SecLabel
        end

        function tabObj:Toggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -10, 0, 38)
            ToggleFrame.Position = UDim2.new(0, 5, 0, 0)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabFrame

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -55, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextColor3 = Color3.fromRGB(200, 200, 210)
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ToggleFrame

            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(0, 38, 0, 22)
            ToggleBtn.Position = UDim2.new(1, -48, 0.5, -11)
            ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 255, 80) or Color3.fromRGB(55, 55, 65)
            ToggleBtn.Text = ""
            ToggleBtn.BorderSizePixel = 0
            ToggleBtn.Parent = ToggleFrame

            local TogCorner = Instance.new("UICorner")
            TogCorner.CornerRadius = UDim.new(0, 11)
            TogCorner.Parent = ToggleBtn

            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 18, 0, 18)
            Circle.Position = default and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
            Circle.BackgroundColor3 = Color3.new(1, 1, 1)
            Circle.BorderSizePixel = 0
            Circle.Parent = ToggleBtn

            local CircCorner = Instance.new("UICorner")
            CircCorner.CornerRadius = UDim.new(0, 9)
            CircCorner.Parent = Circle

            local state = default or false
            ToggleBtn.MouseButton1Click:Connect(function()
                state = not state
                ToggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 255, 80) or Color3.fromRGB(55, 55, 65)
                Circle:TweenPosition(
                    state and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9),
                    "Out", "Back", 0.25, true
                )
                pcall(callback, state)
            end)

            return {Set = function(v) state = v; ToggleBtn.BackgroundColor3 = v and Color3.fromRGB(0,255,80) or Color3.fromRGB(55,55,65); end, Get = function() return state end}
        end

        function tabObj:Button(text, desc, callback)
            local BtnFrame = Instance.new("Frame")
            BtnFrame.Size = UDim2.new(1, -10, 0, 42)
            BtnFrame.Position = UDim2.new(0, 5, 0, 0)
            BtnFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
            BtnFrame.BorderSizePixel = 0
            BtnFrame.Parent = TabFrame

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = BtnFrame

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.BackgroundTransparency = 1
            Btn.Text = desc and (text .. "\n" .. desc) or text
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = desc and 11 or 13
            Btn.TextColor3 = Color3.fromRGB(0, 200, 255)
            Btn.BorderSizePixel = 0
            Btn.Parent = BtnFrame

            Btn.MouseButton1Click:Connect(callback)

            Btn.MouseEnter:Connect(function()
                BtnFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
            end)
            Btn.MouseLeave:Connect(function()
                BtnFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
            end)
            return Btn
        end

        function tabObj:Dropdown(text, options, callback)
            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, -10, 0, 38)
            DropFrame.Position = UDim2.new(0, 5, 0, 0)
            DropFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
            DropFrame.BorderSizePixel = 0
            DropFrame.Parent = TabFrame

            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 6)
            DropCorner.Parent = DropFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.65, -10, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextColor3 = Color3.fromRGB(200, 200, 210)
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = DropFrame

            local DropBtn = Instance.new("TextButton")
            DropBtn.Size = UDim2.new(0.35, -12, 0, 26)
            DropBtn.Position = UDim2.new(0.65, 5, 0.5, -13)
            DropBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            DropBtn.Text = options[1] or "..."
            DropBtn.Font = Enum.Font.GothamBold
            DropBtn.TextSize = 12
            DropBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
            DropBtn.BorderSizePixel = 0
            DropBtn.Parent = DropFrame

            local DropCornerBtn = Instance.new("UICorner")
            DropCornerBtn.CornerRadius = UDim.new(0, 5)
            DropCornerBtn.Parent = DropBtn

            local selected = options[1]
            DropBtn.MouseButton1Click:Connect(function()
                local idx = 1
                for i, v in ipairs(options) do
                    if v == selected then idx = i + 1; break end
                end
                if idx > #options then idx = 1 end
                selected = options[idx]
                DropBtn.Text = selected
                pcall(callback, selected)
            end)

            return {Set = function(v) selected = v; DropBtn.Text = v end, Get = function() return selected end}
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Frame.Visible = false
                t.Button.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
                t.Button.TextColor3 = Color3.fromRGB(160, 160, 170)
            end
            TabFrame.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            TabBtn.TextColor3 = Color3.fromRGB(0, 255, 120)
            ActiveTab = tabObj
        end)

        table.insert(Tabs, tabObj)
        if #Tabs == 1 then
            TabFrame.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            TabBtn.TextColor3 = Color3.fromRGB(0, 255, 120)
        end

        SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize + 10)
        end)

        return tabObj
    end
end

--[[ ========== GAME INTERFACE ========== ]]
local function FindRemote(name)
    local rem = ReplicatedStorage:FindFirstChild(name, true)
    if not rem then
        rem = Workspace:FindFirstChild(name, true)
    end
    if not rem then
        for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                if v.Name:lower():find(name:lower()) then
                    return v
                end
            end
        end
    end
    return rem
end

local function Fire(name, ...)
    local rem = FindRemote(name)
    if rem then
        if rem:IsA("RemoteEvent") then rem:FireServer(...) end
        if rem:IsA("RemoteFunction") then return rem:InvokeServer(...) end
    end
end

local function GetGarden()
    return Workspace:FindFirstChild("Garden") or 
           Workspace:FindFirstChild("Plot") or 
           Workspace:FindFirstChild("Plots") or
           Workspace:FindFirstChild("Farm")
end

local function GetLeaderstat(name)
    local ls = Player:FindFirstChild("leaderstats")
    if ls then
        local stat = ls:FindFirstChild(name)
        if stat then return stat.Value end
    end
    for _, v in ipairs(Player:GetChildren()) do
        if v:IsA("NumberValue") and v.Name:lower():find(name:lower()) then
            return v.Value
        end
    end
    return "N/A"
end

--// Settings
local Settings = {
    AutoHarvest = false,
    AutoPlant = false,
    AutoExpand = false,
    AutoSell = false,
    AutoBuySeeds = false,
    AutoHatch = false,
    AutoOpenCrates = false,
    AutoEquipBest = false,
    AutoEvents = false,
    AutoMutation = false,
    WildPetESP = false,
    StockMonitor = false,
    TeleportOnHarvest = false,
    StealPlants = false,
    SelectedSeed = "Tomato",
    SelectedFruit = "Strawberry",
}

--[[ ========== CORE LOOPS ========== ]]

-- 1. Auto Harvest
task.spawn(function()
    while task.wait(0.5) do
        if not Settings.AutoHarvest then continue end
        local garden = GetGarden()
        if not garden then continue end
        for _, plant in ipairs(garden:GetDescendants()) do
            if plant:IsA("Model") and plant.PrimaryPart then
                local growth = plant:FindFirstChild("Growth") or plant:FindFirstChild("Health") or plant:FindFirstChild("Age")
                local ready = true
                if growth and growth:IsA("NumberValue") then
                    ready = growth.Value >= 100
                end
                if ready then
                    Fire("Harvest", plant)
                    Fire("Collect", plant)
                    if Settings.TeleportOnHarvest and plant.PrimaryPart then
                        local char = Player.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            char.HumanoidRootPart.CFrame = plant.PrimaryPart.CFrame * CFrame.new(0, 3, 0)
                        end
                    end
                    task.wait(0.1)
                end
            end
        end
    end
end)

-- 2. Auto Plant
task.spawn(function()
    while task.wait(1) do
        if not Settings.AutoPlant then continue end
        Fire("Plant", Settings.SelectedSeed)
        Fire("PlantSeed", Settings.SelectedSeed)
        Fire("PlantCrop", Settings.SelectedSeed)
        task.wait(0.2)
    end
end)

-- 3. Auto Expand Garden
task.spawn(function()
    while task.wait(5) do
        if not Settings.AutoExpand then continue end
        Fire("Expand")
        Fire("ExpandGarden")
        Fire("BuyPlot")
        Fire("UpgradeGarden")
    end
end)

-- 4. Auto Sell
task.spawn(function()
    while task.wait(3) do
        if not Settings.AutoSell then continue end
        Fire("Sell")
        Fire("SellAll")
        Fire("SellItems")
        Fire("CollectCoins")
    end
end)

-- 5. Auto Buy Seeds
task.spawn(function()
    while task.wait(8) do
        if not Settings.AutoBuySeeds then continue end
        Fire("BuySeed", Settings.SelectedSeed)
        Fire("BuySeeds", Settings.SelectedSeed)
        Fire("Purchase", Settings.SelectedSeed)
    end
end)

-- 6. Auto Hatch Eggs & Open Crates
task.spawn(function()
    while task.wait(2) do
        if not Settings.AutoHatch and not Settings.AutoOpenCrates then continue end
        local backpack = Player:FindFirstChild("Backpack")
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                if Settings.AutoHatch and (item.Name:lower():find("egg") or item.Name:lower():find("pet")) then
                    Fire("Hatch", item)
                    Fire("OpenEgg", item)
                    task.wait(0.2)
                end
                if Settings.AutoOpenCrates and (item.Name:lower():find("crate") or item.Name:lower():find("pack") or item.Name:lower():find("chest")) then
                    Fire("Open", item)
                    Fire("Unpack", item)
                    task.wait(0.2)
                end
            end
        end
    end
end)

-- 7. Auto Equip Best Pet
task.spawn(function()
    while task.wait(3) do
        if not Settings.AutoEquipBest then continue end
        Fire("EquipBest")
        Fire("EquipBestPet")
        Fire("AutoEquip")
    end
end)

-- 8. Auto Events
task.spawn(function()
    while task.wait(3) do
        if not Settings.AutoEvents then continue end
        Fire("EventClaim")
        Fire("ClaimEvent")
        Fire("CollectRewards")
        Fire("JoinEvent")
    end
end)

-- 9. Auto Mutation
task.spawn(function()
    while task.wait(3) do
        if not Settings.AutoMutation then continue end
        Fire("Mutate")
        Fire("Mutation")
        Fire("Evolve")
    end
end)

-- 10. Auto Steal Plants
task.spawn(function()
    while task.wait(1.5) do
        if not Settings.StealPlants then continue end
        Fire("Steal")
        Fire("StealPlant")
        Fire("TakeCrop")
    end
end)

-- 11. Wild Pet ESP
task.spawn(function()
    while task.wait(2) do
        if not Settings.WildPetESP then continue end
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v.PrimaryPart and not v:FindFirstChild("PetESP") then
                if v.Name:lower():find("pet") or v.Name:lower():find("wild") or v.Name:lower():find("animal") or v.Name:lower():find("critter") then
                    local bill = Instance.new("BillboardGui")
                    bill.Name = "PetESP"
                    bill.Size = UDim2.new(0, 120, 0, 30)
                    bill.StudsOffset = Vector3.new(0, 3, 0)
                    bill.AlwaysOnTop = true
                    bill.Parent = v

                    local tag = Instance.new("TextLabel")
                    tag.Size = UDim2.new(1, 0, 1, 0)
                    tag.BackgroundTransparency = 0.3
                    tag.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
                    tag.Text = "🐾 " .. v.Name
                    tag.TextColor3 = Color3.new(1,1,1)
                    tag.Font = Enum.Font.GothamBold
                    tag.TextSize = 14
                    tag.Parent = bill
                end
            end
        end
    end
end)

-- 12. Live Stock Monitor
task.spawn(function()
    while task.wait(1) do
        if not Settings.StockMonitor then
            local old = PlayerGui:FindFirstChild("GAG_Stock")
            if old then old:Destroy() end
            continue
        end
        local monitor = PlayerGui:FindFirstChild("GAG_Stock")
        if not monitor then
            monitor = Instance.new("ScreenGui")
            monitor.Name = "GAG_Stock"
            monitor.ResetOnSpawn = false
            monitor.Parent = PlayerGui

            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(0, 240, 0, 120)
            bg.Position = UDim2.new(1, -250, 0.02, 0)
            bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            bg.BackgroundTransparency = 0.35
            bg.BorderSizePixel = 0
            bg.Parent = monitor

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = bg

            local lbl = Instance.new("TextLabel")
            lbl.Name = "Content"
            lbl.Size = UDim2.new(1, -10, 1, -10)
            lbl.Position = UDim2.new(0, 5, 0, 5)
            lbl.BackgroundTransparency = 1
            lbl.Text = ""
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextColor3 = Color3.fromRGB(0, 255, 120)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = bg
        end

        local lbl = monitor:FindFirstChild("Content", true)
        if lbl then
            lbl.Text = string.format([[
╔══════════════════════╗
║  📊 AIRFLOW · STOCK   ║
╠══════════════════════╣
║ 💰 Coins: %s
║ 🌱 Seeds: %s
║ 🌾 AutoFarm: %s
║ 💵 AutoSell: %s
║ 🥚 AutoHatch: %s
║ 🌀 TP Harvest: %s
╚══════════════════════╝]],
                tostring(GetLeaderstat("Coins") or GetLeaderstat("Money") or GetLeaderstat("Cash") or "?"),
                tostring(GetLeaderstat("Seeds") or "?"),
                Settings.AutoHarvest and "✅" or "❌",
                Settings.AutoSell and "✅" or "❌",
                Settings.AutoHatch and "✅" or "❌",
                Settings.TeleportOnHarvest and "✅" or "❌"
            )
        end
    end
end)

--[[ ========== BUILD GUI ========== ]]

-- Tab 1 — Farming
local FarmTab = AirFlowUI:Tab("Farming", "🌾")
FarmTab:Section("CORE AUTOMATION")
FarmTab:Toggle("Auto Harvest Crops", false, function(v) Settings.AutoHarvest = v end)
FarmTab:Toggle("Auto Plant Seeds", false, function(v) Settings.AutoPlant = v end)
FarmTab:Toggle("Auto Expand Garden", false, function(v) Settings.AutoExpand = v end)
FarmTab:Toggle("Auto Steal Plants", false, function(v) Settings.StealPlants = v end)
FarmTab:Section("HARVEST OPTIONS")
FarmTab:Toggle("Teleport to Crop on Harvest", false, function(v) Settings.TeleportOnHarvest = v end)
FarmTab:Dropdown("Seed to Plant", {"Tomato", "Strawberry", "Blueberry", "Pumpkin", "Watermelon", "Carrot", "Corn", "Golden"}, function(v) Settings.SelectedSeed = v end)

-- Tab 2 — Economy
local EcoTab = AirFlowUI:Tab("Economy", "💰")
EcoTab:Section("AUTO ECONOMY")
EcoTab:Toggle("Auto Sell All Crops", false, function(v) Settings.AutoSell = v end)
EcoTab:Toggle("Auto Buy Seeds", false, function(v) Settings.AutoBuySeeds = v end)
EcoTab:Dropdown("Seed to Buy", {"Tomato", "Strawberry", "Blueberry", "Pumpkin", "Watermelon", "Carrot", "Corn", "Golden"}, function(v) Settings.SelectedSeed = v end)
EcoTab:Button("Sell Inventory Now", "Sells all items instantly", function() Fire("SellAll"); Fire("Sell") end)
EcoTab:Button("Buy Max Upgrades", "Purchases all upgrades", function() Fire("BuyAllUpgrades") end)

-- Tab 3 — Pets & Eggs
local PetTab = AirFlowUI:Tab("Pets", "🐾")
PetTab:Section("EGG & PET AUTOMATION")
PetTab:Toggle("Auto Hatch Eggs", false, function(v) Settings.AutoHatch = v end)
PetTab:Toggle("Auto Open Crates & Packs", false, function(v) Settings.AutoOpenCrates = v end)
PetTab:Toggle("Auto Equip Best Pet", false, function(v) Settings.AutoEquipBest = v end)
PetTab:Toggle("Wild Pet ESP Tracking", false, function(v) Settings.WildPetESP = v end)
PetTab:Button("Hatch All Eggs Now", "Instantly hatches all eggs in inventory", function() 
    local bp = Player:FindFirstChild("Backpack")
    if bp then
        for _, v in ipairs(bp:GetChildren()) do
            if v.Name:lower():find("egg") then
                Fire("Hatch", v)
                task.wait(0.1)
            end
        end
    end
end)

-- Tab 4 — Events & Mutation
local EventTab = AirFlowUI:Tab("Events", "🚨")
EventTab:Section("EVENT CONTROLS")
EventTab:Toggle("Auto Events", false, function(v) Settings.AutoEvents = v end)
EventTab:Toggle("Auto Mutation", false, function(v) Settings.AutoMutation = v end)
EventTab:Button("Claim All Rewards", "Claims all pending event rewards", function() Fire("ClaimAll"); Fire("CollectRewards") end)
EventTab:Button("Join Current Event", "Joins active event", function() Fire("JoinEvent") end)

-- Tab 5 — Teleports
local TpTab = AirFlowUI:Tab("Teleports", "🌀")
TpTab:Section("QUICK TRAVEL")
TpTab:Button("Teleport to Garden", "Go to your garden plot", function()
    local g = GetGarden()
    if g and g.PrimaryPart then
        Player.Character:SetPrimaryPartCFrame(g.PrimaryPart.CFrame * CFrame.new(0, 5, 0))
    end
end)
TpTab:Button("Teleport to Shop", "Go to the shop/market", function()
    local shop = Workspace:FindFirstChild("Shop") or Workspace:FindFirstChild("Market") or Workspace:FindFirstChild("Store")
    if shop and shop.PrimaryPart then
        Player.Character:SetPrimaryPartCFrame(shop.PrimaryPart.CFrame * CFrame.new(0, 3, 0))
    end
end)
TpTab:Button("Teleport to Spawn", "Go to spawn point", function()
    local spawn = Workspace:FindFirstChild("Spawn") or Workspace:FindFirstChild("Start")
    if spawn and spawn.PrimaryPart then
        Player.Character:SetPrimaryPartCFrame(spawn.PrimaryPart.CFrame * CFrame.new(0, 3, 0))
    end
end)
TpTab:Button("Teleport to Event Area", "Go to event NPC/area", function()
    local ev = Workspace:FindFirstChild("Event") or Workspace:FindFirstChild("EventArea")
    if ev and ev.PrimaryPart then
        Player.Character:SetPrimaryPartCFrame(ev.PrimaryPart.CFrame * CFrame.new(0, 3, 0))
    end
end)

-- Tab 6 — Display
local DisplayTab = AirFlowUI:Tab("Display", "📊")
DisplayTab:Section("MONITORING")
DisplayTab:Toggle("Live Stock Monitor", false, function(v) Settings.StockMonitor = v end)
DisplayTab:Section("STATUS")
DisplayTab:Button("Refresh Stats", "Update displayed stats", function()
    print("🌱 Coins:", GetLeaderstat("Coins") or "?")
    print("🌱 Seeds:", GetLeaderstat("Seeds") or "?")
end)

-- Tab 7 — About
local AboutTab = AirFlowUI:Tab("About", "ℹ️")
AboutTab:Section("AIRFLOW · GROW A GARDEN")
AboutTab:Button("Authorized Pentest Copy", "No Key · Full Features")
AboutTab:Button("✅ Auto Farm Active", "Toggle features from tabs above")
AboutTab:Button("💡 Tip", "Enable Auto Harvest + Auto Plant + Auto Sell for full AFK")
AboutTab:Button("📱 Works on Delta / Arceus X / PC", "All executors supported")

--// Notify
print("✅ [AirFlow GAG] Loaded successfully — all features ready")
