--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

--// Vars
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Mouse = Player:GetMouse()

--// GUI Lib
local Library = {}
do
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AirFlow_GAG"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 550, 0, 400)
    Main.Position = UDim2.new(0.5, -275, 0.5, -200)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Main

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 8)
    TopCorner.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔥 GROW A GARDEN · CUSTOM"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(0, 255, 100)
    Title.Parent = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 2.5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent = TopBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        for _, v in pairs(getconnections) do
            v:Disable()
        end
    end)

    -- Tab system
    local TabHolder = Instance.new("Frame")
    TabHolder.Size = UDim2.new(0, 130, 1, -35)
    TabHolder.Position = UDim2.new(0, 0, 0, 35)
    TabHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TabHolder.BorderSizePixel = 0
    TabHolder.Parent = Main

    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -130, 1, -35)
    Container.Position = UDim2.new(0, 130, 0, 35)
    Container.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Container.BorderSizePixel = 0
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.ScrollBarThickness = 4
    Container.Parent = Main

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 6)
    UIListLayout.Parent = Container

    local Tabs = {}
    local CurrentTab = nil

    function Library:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.Text = "  " .. name
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 14
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.BorderSizePixel = 0
        TabBtn.Parent = TabHolder

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = TabBtn

        local Frame = Instance.new("ScrollingFrame")
        Frame.Size = UDim2.new(1, 0, 1, 0)
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        Frame.CanvasSize = UDim2.new(0, 0, 0, 0)
        Frame.ScrollBarThickness = 4
        Frame.Visible = false
        Frame.Parent = Container

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 6)
        Layout.Parent = Frame

        local Bind = {}
        Bind.Frame = Frame
        Bind.Layout = Layout
        Bind.Button = TabBtn
        Bind.Elements = {}

        function Bind:Toggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = Frame

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 4)
            ToggleCorner.Parent = ToggleFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 8, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = "  " .. text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ToggleFrame

            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(0, 35, 0, 20)
            ToggleBtn.Position = UDim2.new(1, -45, 0.5, -10)
            ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 255, 80) or Color3.fromRGB(60, 60, 60)
            ToggleBtn.Text = ""
            ToggleBtn.BorderSizePixel = 0
            ToggleBtn.Parent = ToggleFrame

            local ToggleCornerBtn = Instance.new("UICorner")
            ToggleCornerBtn.CornerRadius = UDim.new(0, 10)
            ToggleCornerBtn.Parent = ToggleBtn

            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Position = default and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
            Circle.BackgroundColor3 = Color3.new(1, 1, 1)
            Circle.BorderSizePixel = 0
            Circle.Parent = ToggleBtn

            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(0, 8)
            CircleCorner.Parent = Circle

            local toggled = default or false
            ToggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                ToggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(0, 255, 80) or Color3.fromRGB(60, 60, 60)
                Circle:TweenPosition(
                    toggled and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8),
                    "Out", "Quad", 0.15, true
                )
                pcall(callback, toggled)
            end)

            return {Set = function(v) toggled = v; ToggleBtn.BackgroundColor3 = v and Color3.fromRGB(0,255,80) or Color3.fromRGB(60,60,60) end}
        end

        function Bind:Button(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -10, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            Btn.Text = "  " .. text
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.TextColor3 = Color3.fromRGB(200, 200, 255)
            Btn.BorderSizePixel = 0
            Btn.Parent = Frame

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 4)
            BtnCorner.Parent = Btn

            Btn.MouseButton1Click:Connect(callback)
            return Btn
        end

        function Bind:Label(text)
            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(1, -10, 0, 25)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = "  " .. text
            Lbl.Font = Enum.Font.Gotham
            Lbl.TextSize = 13
            Lbl.TextColor3 = Color3.fromRGB(0, 255, 100)
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = Frame
            return Lbl
        end

        function Bind:Dropdown(text, options, callback)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, -10, 0, 35)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Parent = Frame

            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 4)
            DropdownCorner.Parent = DropdownFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.7, -8, 1, 0)
            Label.Position = UDim2.new(0, 8, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = "  " .. text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = DropdownFrame

            local DropBtn = Instance.new("TextButton")
            DropBtn.Size = UDim2.new(0.3, -10, 0, 25)
            DropBtn.Position = UDim2.new(0.7, 5, 0.5, -12.5)
            DropBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            DropBtn.Text = options[1] or "..."
            DropBtn.Font = Enum.Font.Gotham
            DropBtn.TextSize = 12
            DropBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
            DropBtn.BorderSizePixel = 0
            DropBtn.Parent = DropdownFrame

            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 4)
            DropCorner.Parent = DropBtn

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

            return {Set = function(v) selected = v; DropBtn.Text = v end}
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, tb in pairs(Tabs) do
                tb.Frame.Visible = false
                tb.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                tb.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
            Frame.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            TabBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
            CurrentTab = Bind
        end)

        table.insert(Tabs, Bind)
        if #Tabs == 1 then
            Frame.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            TabBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
        end

        return Bind
    end
end

--[[ ========== FEATURES ========== ]]

local Settings = {
    AutoHarvest = false,
    AutoPlant = false,
    AutoExpand = false,
    AutoSell = false,
    AutoBuySeeds = false,
    AutoHatch = false,
    AutoEquipBest = false,
    AutoEvents = false,
    AutoMutation = false,
    WildPetTracking = false,
    LiveStockMonitor = false,
    TeleportToFruit = false,
    SelectedSeed = "Tomato",
    SelectedFruit = "Strawberry",
}

--// Helper Functions
local function GetRemote(name)
    return ReplicatedStorage:FindFirstChild(name, true) or 
           Workspace:FindFirstChild(name, true)
end

local function FireRemote(name, ...)
    local rem = GetRemote(name)
    if rem and rem:IsA("RemoteEvent") then
        rem:FireServer(...)
    elseif rem and rem:IsA("RemoteFunction") then
        return rem:InvokeServer(...)
    end
end

local function GetPlants()
    local plants = {}
    local garden = Workspace:FindFirstChild("Garden") or Workspace:FindFirstChild("Plots")
    if garden then
        for _, v in ipairs(garden:GetDescendants()) do
            if v:IsA("Model") and v.PrimaryPart then
                table.insert(plants, v)
            end
        end
    end
    return plants
end

local function GetInventory()
    local inv = Player:FindFirstChild("Backpack") or Player:FindFirstChild("Inventory")
    return inv
end

--// 1. AUTO HARVEST & TP TO FRUIT
task.spawn(function()
    while task.wait(0.5) do
        if Settings.AutoHarvest then
            local plants = GetPlants()
            for _, plant in ipairs(plants) do
                local health = plant:FindFirstChild("Health") or plant:FindFirstChild("Growth")
                local ready = true
                if health then
                    ready = health.Value >= 100
                end
                if ready then
                    FireRemote("Harvest", plant)
                    if Settings.TeleportToFruit and plant.PrimaryPart then
                        Player.Character:SetPrimaryPartCFrame(plant.PrimaryPart.CFrame * CFrame.new(0, 3, 0))
                    end
                end
            end
        end
    end
end)

--// 2. AUTO PLANT
task.spawn(function()
    while task.wait(1) do
        if Settings.AutoPlant then
            FireRemote("PlantSeed", Settings.SelectedSeed)
        end
    end
end)

--// 3. AUTO EXPAND GARDEN
task.spawn(function()
    while task.wait(5) do
        if Settings.AutoExpand then
            FireRemote("ExpandGarden")
        end
    end
end)

--// 4. AUTO SELL
task.spawn(function()
    while task.wait(3) do
        if Settings.AutoSell then
            local inv = GetInventory()
            if inv then
                for _, item in ipairs(inv:GetChildren()) do
                    if item:IsA("Tool") or item:IsA("Folder") then
                        FireRemote("SellItem", item)
                    end
                end
            end
        end
    end
end)

--// 5. AUTO BUY SEEDS
task.spawn(function()
    while task.wait(10) do
        if Settings.AutoBuySeeds then
            FireRemote("BuySeed", Settings.SelectedSeed)
        end
    end
end)

--// 6. AUTO HATCH EGGS & OPEN CRATES
task.spawn(function()
    while task.wait(2) do
        if Settings.AutoHatch then
            local inv = GetInventory()
            if inv then
                for _, item in ipairs(inv:GetChildren()) do
                    if item.Name:lower():match("egg") or item.Name:lower():match("crate") or item.Name:lower():match("pack") then
                        FireRemote("Open", item)
                        task.wait(0.3)
                    end
                end
            end
        end
    end
end)

--// 7. AUTO EQUIP BEST PET
task.spawn(function()
    while task.wait(3) do
        if Settings.AutoEquipBest then
            -- Fire remote to equip best pet
            FireRemote("EquipBestPet")
        end
    end
end)

--// 8. WILD PET TRACKING
task.spawn(function()
    while task.wait(1) do
        if Settings.WildPetTracking then
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and (v.Name:lower():match("pet") or v.Name:lower():match("wild")) and v.PrimaryPart then
                    -- Highlight wild pets (simple ESP via BillboardGui)
                    local billboard = v:FindFirstChild("PetTag")
                    if not billboard then
                        billboard = Instance.new("BillboardGui")
                        billboard.Name = "PetTag"
                        billboard.Size = UDim2.new(0, 100, 0, 30)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = v

                        local tag = Instance.new("TextLabel")
                        tag.Size = UDim2.new(1, 0, 1, 0)
                        tag.BackgroundTransparency = 0.5
                        tag.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
                        tag.Text = "⭐ " .. v.Name
                        tag.TextColor3 = Color3.new(1,1,1)
                        tag.Font = Enum.Font.GothamBold
                        tag.TextSize = 14
                        tag.Parent = billboard
                    end
                end
            end
        end
    end
end)

--// 9. AUTO EVENTS
task.spawn(function()
    while task.wait(2) do
        if Settings.AutoEvents then
            FireRemote("JoinEvent")
            FireRemote("ClaimEventRewards")
        end
    end
end)

--// 10. AUTO MUTATION
task.spawn(function()
    while task.wait(3) do
        if Settings.AutoMutation then
            FireRemote("Mutate")
        end
    end
end)

--// 11. LIVE STOCK MONITOR
task.spawn(function()
    while task.wait(1) do
        if Settings.LiveStockMonitor then
            local label = PlayerGui:FindFirstChild("StockMonitor")
            if not label then
                local scr = Instance.new("ScreenGui")
                scr.Name = "StockMonitor"
                scr.ResetOnSpawn = false
                scr.Parent = PlayerGui

                label = Instance.new("TextLabel")
                label.Name = "MonitorLabel"
                label.Size = UDim2.new(0, 250, 0, 100)
                label.Position = UDim2.new(0.75, -125, 0.85, -50)
                label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                label.BackgroundTransparency = 0.4
                label.TextColor3 = Color3.fromRGB(0, 255, 100)
                label.Font = Enum.Font.Gotham
                label.TextSize = 13
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = scr

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 8)
                corner.Parent = label
            end
            -- Update stock info
            local coins = Player:FindFirstChild("leaderstats") and Player.leaderstats:FindFirstChild("Coins") or Player:FindFirstChild("Coins")
            local seeds = Player:FindFirstChild("leaderstats") and Player.leaderstats:FindFirstChild("Seeds") or Player:FindFirstChild("Seeds")
            label.Text = string.format(
                "📊 LIVE STOCK MONITOR\n━━━━━━━━━━━━━━━\n💰 Coins: %s\n🌱 Seeds: %s\n🔄 AutoHarvest: %s\n🌿 AutoPlant: %s\n💵 AutoSell: %s\n🥚 AutoHatch: %s",
                coins and tostring(coins.Value) or "N/A",
                seeds and tostring(seeds.Value) or "N/A",
                Settings.AutoHarvest and "✅ ON" or "❌ OFF",
                Settings.AutoPlant and "✅ ON" or "❌ OFF",
                Settings.AutoSell and "✅ ON" or "❌ OFF",
                Settings.AutoHatch and "✅ ON" or "❌ OFF"
            )
        end
    end
end)

--[[ ========== BUILD GUI TABS ========== ]]

-- Tab 1: Farming
local FarmingTab = Library:CreateTab("🌾 Farming")
FarmingTab:Label("AUTOMATION CONTROLS")
FarmingTab:Toggle("Auto Harvest & TP to Fruit", false, function(v) Settings.AutoHarvest = v end)
FarmingTab:Toggle("Teleport to Fruit on Harvest", false, function(v) Settings.TeleportToFruit = v end)
FarmingTab:Toggle("Auto Plant", false, function(v) Settings.AutoPlant = v end)
FarmingTab:Toggle("Auto Expand Garden", false, function(v) Settings.AutoExpand = v end)
FarmingTab:Toggle("Auto Sell Crops", false, function(v) Settings.AutoSell = v end)
FarmingTab:Toggle("Auto Buy Seeds", false, function(v) Settings.AutoBuySeeds = v end)

-- Tab 2: Seeds & Shop
local ShopTab = Library:CreateTab("🛒 Shop")
ShopTab:Label("SEED SELECTION")
ShopTab:Dropdown("Seed Type", {"Tomato", "Strawberry", "Blueberry", "Pumpkin", "Watermelon", "Golden"}, function(v) Settings.SelectedSeed = v end)
ShopTab:Dropdown("Fruit Targeting", {"Strawberry", "Apple", "Cherry", "Golden Fruit"}, function(v) Settings.SelectedFruit = v end)
ShopTab:Button("Buy All Seeds", function() FireRemote("BuyAllSeeds") end)
ShopTab:Button("Buy All Upgrades", function() FireRemote("BuyAllUpgrades") end)

-- Tab 3: Pets & Eggs
local PetTab = Library:CreateTab("🐾 Pets")
PetTab:Label("PET & EGG CONTROLS")
PetTab:Toggle("Auto Hatch Eggs", false, function(v) Settings.AutoHatch = v end)
PetTab:Toggle("Auto Equip Best Pet", false, function(v) Settings.AutoEquipBest = v end)
PetTab:Toggle("Wild Pet Tracking (ESP)", false, function(v) Settings.WildPetTracking = v end)
PetTab:Button("Open All Crates", function() FireRemote("OpenAllCrates") end)
PetTab:Button("Open All Seed Packs", function() FireRemote("OpenAllSeedPacks") end)

-- Tab 4: Events & Mutation
local EventTab = Library:CreateTab("🚨 Events")
EventTab:Label("EVENT & MUTATION")
EventTab:Toggle("Auto Events", false, function(v) Settings.AutoEvents = v end)
EventTab:Toggle("Auto Mutation", false, function(v) Settings.AutoMutation = v end)
EventTab:Toggle("Live Stock Monitor", false, function(v) Settings.LiveStockMonitor = v end)
EventTab:Button("Claim All Rewards", function() FireRemote("ClaimAllRewards") end)

-- Tab 5: Teleports
local TpTab = Library:CreateTab("🌀 Teleports")
TpTab:Label("QUICK TELEPORTS")
TpTab:Button("Teleport to Garden", function()
    local garden = Workspace:FindFirstChild("Garden") or Workspace:FindFirstChild("Plots")
    if garden and garden.PrimaryPart then
        Player.Character:SetPrimaryPartCFrame(garden.PrimaryPart.CFrame * CFrame.new(0, 5, 0))
    end
end)
TpTab:Button("Teleport to Shop", function()
    local shop = Workspace:FindFirstChild("Shop") or Workspace:FindFirstChild("Market")
    if shop and shop.PrimaryPart then
        Player.Character:SetPrimaryPartCFrame(shop.PrimaryPart.CFrame * CFrame.new(0, 3, 0))
    end
end)
TpTab:Button("Teleport to Event Area", function()
    local event = Workspace:FindFirstChild("Event") or Workspace:FindFirstChild("EventArea")
    if event and event.PrimaryPart then
        Player.Character:SetPrimaryPartCFrame(event.PrimaryPart.CFrame * CFrame.new(0, 3, 0))
    end
end)
TpTab:Button("Teleport to NPC", function()
    local npc = Workspace:FindFirstChild("NPC") or Workspace:FindFirstChildWhichIsA("Model")
    if npc and npc.PrimaryPart then
        Player.Character:SetPrimaryPartCFrame(npc.PrimaryPart.CFrame * CFrame.new(0, 3, 0))
    end
end)

-- Tab 6: Info
local InfoTab = Library:CreateTab("📊 Info")
InfoTab:Label("⚡ GROW A GARDEN · CUSTOM SCRIPT")
InfoTab:Label("━"):Label("✅ Auto Farm Active")
InfoTab:Label("✅ Supports Delta / Arceus X / PC")
InfoTab:Label("✅ All features toggleable")
InfoTab:Label("━"):Label("💡 Tip: Enable AUTO HARVEST")
InfoTab:Label("and AUTO PLANT together for")
InfoTab:Label("a full AFK farming loop!")

-- Notify
print("✅ AirFlow Grow a Garden script loaded!")
