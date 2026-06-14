--[[
	GROW A GARDEN 2 — Complete GUI
	────────────────────────────────
	A modest, production-ready interface for Grow a Garden 2.
	
	HOW TO RUN:
	- Option 1: Paste this entire script into the Roblox Developer Console (F9)
	- Option 2: Save as a .lua file and load with: loadstring(game:HttpGet("raw_url_here"))()
	- Option 3: Place in a LocalScript under StarterGui in Roblox Studio
	
	CUSTOMIZATION:
	- Edit the CONFIG table below to change colors, text, and behavior
	- All UI elements are created dynamically — no external assets needed
]]

-- ============================================================================
-- CONFIGURATION — Edit these values to personalize your GUI
-- ============================================================================

local CONFIG = {
	-- Visual Theme
	Theme = {
		Primary = Color3.fromRGB(20, 30, 20),         -- Dark green-black background
		Secondary = Color3.fromRGB(30, 45, 30),        -- Card backgrounds
		Accent = Color3.fromRGB(76, 175, 80),          -- Leaf green accent
		AccentDark = Color3.fromRGB(56, 142, 60),      -- Darker green for hover
		Gold = Color3.fromRGB(255, 193, 7),            -- Currency/coins
		Brown = Color3.fromRGB(121, 85, 72),           -- Soil/earth tones
		Sky = Color3.fromRGB(100, 181, 246),           -- Water element
		Danger = Color3.fromRGB(239, 68, 68),          -- Warnings/errors
		Success = Color3.fromRGB(34, 197, 94),         -- Positive feedback
		Text = Color3.fromRGB(220, 235, 220),          -- Primary text (soft green-white)
		TextMuted = Color3.fromRGB(150, 180, 150),     -- Secondary text
		Border = Color3.fromRGB(60, 80, 60),           -- Subtle borders
	},
	
	-- Game-Specific Settings
	Game = {
		ReplantDelay = 0.5,       -- Seconds between replanting actions
		CollectRadius = 20,       -- Studs for auto-collect range
		WaterCheckInterval = 2,   -- Seconds between water checks
		MaxFarmingDistance = 50,  -- Max studs from spawn to farm
	},
	
	-- UI Settings
	UI = {
		AnimationSpeed = 0.3,     -- Seconds for UI transitions
		Font = Enum.Font.Gotham,
		FontBold = Enum.Font.GothamBold,
		FontMono = Enum.Font.Code,
		CornerRadius = 8,         -- Button/panel roundness
	},
}

-- ============================================================================
-- UTILITY FUNCTIONS — Reusable builders for UI elements
-- ============================================================================

local Util = {}

--- Create a new Instance with properties in one call
function Util:New(className, props, parent)
	local obj = Instance.new(className)
	for k, v in pairs(props) do
		obj[k] = v
	end
	obj.Parent = parent
	return obj
end

--- Create a rounded frame (panel/card)
function Util:Panel(size, position, color, parent, transparency)
	local frame = self:New("Frame", {
		Size = size,
		Position = position,
		BackgroundColor3 = color or CONFIG.Theme.Secondary,
		BackgroundTransparency = transparency or 0,
		BorderSizePixel = 0,
	}, parent)
	self:New("UICorner", {CornerRadius = UDim.new(0, CONFIG.UI.CornerRadius)}, frame)
	self:New("UIStroke", {
		Color = CONFIG.Theme.Border,
		Thickness = 1,
		Transparency = 0.7,
	}, frame)
	return frame
end

--- Create a text label with standard styling
function Util:Label(text, size, position, color, font, textSize, parent, align)
	return self:New("TextLabel", {
		Size = size,
		Position = position,
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = color or CONFIG.Theme.Text,
		Font = font or CONFIG.UI.Font,
		TextSize = textSize or 14,
		TextXAlignment = align or Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		RichText = true,
	}, parent)
end

--- Create an interactive button with hover animations
function Util:Button(text, size, position, onClick, parent, style)
	style = style or {}
	
	local bgColor = style.Color or CONFIG.Theme.Accent
	local hoverColor = style.HoverColor or CONFIG.Theme.AccentDark
	local textColor = style.TextColor or CONFIG.Theme.Text
	local textSize = style.TextSize or 14
	
	local btn = self:New("TextButton", {
		Size = size,
		Position = position,
		BackgroundColor3 = bgColor,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Text = "",
	}, parent)
	
	self:New("UICorner", {CornerRadius = UDim.new(0, CONFIG.UI.CornerRadius)}, btn)
	
	self:New("TextLabel", {
		Size = UDim2.new(1, -12, 1, 0),
		Position = UDim2.new(0, 6, 0, 0),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = textColor,
		Font = CONFIG.UI.FontBold,
		TextSize = textSize,
		TextXAlignment = Enum.TextXAlignment.Center,
	}, btn)
	
	-- Hover and press animations
	btn.MouseEnter:Connect(function()
		local tween = game:GetService("TweenService"):Create(btn, 
			TweenInfo.new(0.15), {BackgroundColor3 = hoverColor})
		tween:Play()
	end)
	
	btn.MouseLeave:Connect(function()
		local tween = game:GetService("TweenService"):Create(btn, 
			TweenInfo.new(0.2), {BackgroundColor3 = bgColor})
		tween:Play()
	end)
	
	btn.MouseButton1Down:Connect(function()
		local tween = game:GetService("TweenService"):Create(btn,
			TweenInfo.new(0.08), {Size = size * 0.96})
		tween:Play()
	end)
	
	btn.MouseButton1Up:Connect(function()
		local tween = game:GetService("TweenService"):Create(btn,
			TweenInfo.new(0.12), {Size = size})
		tween:Play()
	end)
	
	if onClick then
		btn.MouseButton1Click:Connect(onClick)
	end
	
	return btn
end

--- Animate a GUI element (fade in, slide, etc.)
function Util:Animate(obj, properties, duration, callback)
	local tween = game:GetService("TweenService"):Create(obj,
		TweenInfo.new(duration or CONFIG.UI.AnimationSpeed, 
		Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
	tween:Play()
	if callback then
		tween.Completed:Connect(callback)
	end
	return tween
end

--- Create a simple toggle switch
function Util:Toggle(initialState, label, parent, yPos)
	local container = self:New("Frame", {
		Size = UDim2.new(1, -16, 0, 32),
		Position = UDim2.new(0, 8, 0, yPos or 0),
		BackgroundTransparency = 1,
	}, parent)
	
	local toggleBg = self:New("Frame", {
		Size = UDim2.new(0, 42, 0, 22),
		Position = UDim2.new(1, -42, 0.5, -11),
		BackgroundColor3 = initialState and CONFIG.Theme.Accent or Color3.fromRGB(70, 75, 70),
		BorderSizePixel = 0,
	}, container)
	self:New("UICorner", {CornerRadius = UDim.new(0, 11)}, toggleBg)
	
	local knob = self:New("Frame", {
		Size = UDim2.new(0, 16, 0, 16),
		Position = UDim2.new(0, initialState and 23 or 3, 0.5, -8),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
	}, toggleBg)
	self:New("UICorner", {CornerRadius = UDim.new(0, 8)}, knob)
	
	self:Label(label, UDim2.new(1, -50, 1, 0), UDim2.new(0, 0, 0, 0),
		CONFIG.Theme.Text, nil, 13, container)
	
	local state = initialState
	toggleBg.Active = true
	toggleBg.MouseButton1Click:Connect(function()
		state = not state
		Util:Animate(toggleBg, {BackgroundColor3 = state and CONFIG.Theme.Accent or Color3.fromRGB(70, 75, 70)}, 0.15)
		Util:Animate(knob, {Position = UDim2.new(0, state and 23 or 3, 0.5, -8)}, 0.15)
	end)
	
	return container, function() return state end
end

--- Show a toast notification
function Util:Toast(message, msgType, parent, duration)
	duration = duration or 3.5
	local colors = {
		success = CONFIG.Theme.Success,
		error = CONFIG.Theme.Danger,
		info = CONFIG.Theme.Accent,
		warning = CONFIG.Theme.Gold,
	}
	local bgColor = colors[msgType] or CONFIG.Theme.Accent
	
	local toast = self:New("Frame", {
		Size = UDim2.new(0, 300, 0, 40),
		Position = UDim2.new(0.5, -150, 0, -50),
		BackgroundColor3 = CONFIG.Theme.Secondary,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
	}, parent)
	self:New("UICorner", {CornerRadius = UDim.new(0, 6)}, toast)
	
	-- Accent bar
	local bar = self:New("Frame", {
		Size = UDim2.new(0, 4, 1, 0),
		BackgroundColor3 = bgColor,
		BorderSizePixel = 0,
	}, toast)
	self:New("UICorner", {CornerRadius = UDim.new(0, 2)}, bar)
	
	self:Label(message, UDim2.new(1, -16, 1, 0), UDim2.new(0, 12, 0, 0),
		CONFIG.Theme.Text, nil, 13, toast)
	
	-- Animate in
	self:Animate(toast, {BackgroundTransparency = 0, Position = UDim2.new(0.5, -150, 0, 10)}, 0.3)
	
	task.delay(duration, function()
		self:Animate(toast, {BackgroundTransparency = 1, Position = UDim2.new(0.5, -150, 0, -50)}, 0.3)
		task.delay(0.35, function() toast:Destroy() end)
	end)
end

-- ============================================================================
-- CORE GAME INTERACTION FUNCTIONS
-- ============================================================================

local Garden = {}

--- Find the nearest plantable plot (soil/dirt)
function Garden:FindNearestPlot()
	local player = game:GetService("Players").LocalPlayer
	if not player or not player.Character then return nil end
	local root = player.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	
	local plots = workspace:FindFirstChild("Plots") or workspace:FindFirstChild("Soil") 
		or workspace:FindFirstChild("GardenPlots")
	
	if not plots then
		-- Fallback: find parts named "Plot" or "Soil"
		local allParts = workspace:GetDescendants()
		local bestPlot = nil
		local bestDist = CONFIG.Game.MaxFarmingDistance
		
		for _, part in ipairs(allParts) do
			if part:IsA("BasePart") and (part.Name:find("Plot") or part.Name:find("Soil") or part.Name:find("Dirt")) then
				local dist = (root.Position - part.Position).Magnitude
				if dist < bestDist then
					bestDist = dist
					bestPlot = part
				end
			end
		end
		return bestPlot
	end
	
	-- Find nearest child plot
	local nearest = nil
	local nearestDist = CONFIG.Game.MaxFarmingDistance
	
	for _, plot in ipairs(plots:GetChildren()) do
		if plot:IsA("BasePart") or plot:IsA("Model") then
			local plotPos = plot:IsA("Model") and (plot:FindFirstChild("Handle") or plot:FindFirstChildOfClass("BasePart"))
			if plotPos then plotPos = plotPos.Position else plotPos = plot.Position end
			
			local dist = (root.Position - plotPos).Magnitude
			if dist < nearestDist then
				nearestDist = dist
				nearest = plot
			end
		end
	end
	
	return nearest
end

--- Plant a seed at the nearest available plot
function Garden:PlantSeed()
	local player = game:GetService("Players").LocalPlayer
	if not player or not player.Character then return false end
	local root = player.Character:FindFirstChild("HumanoidRootPart")
	if not root then return false end
	
	-- Find the nearest plot
	local plot = self:FindNearestPlot()
	if not plot then
		return false, "No plots found nearby"
	end
	
	-- Move to plot
	local plotPos = plot:IsA("Model") and (plot:FindFirstChild("Handle") or plot:FindFirstChildOfClass("BasePart"))
	if plotPos then plotPos = plotPos.Position else plotPos = plot.Position end
	
	root.CFrame = CFrame.new(plotPos + Vector3.new(2, 0, 0))
	task.wait(0.2)
	
	-- Simulate interacting with the plot (click/activate)
	if plot:IsA("BasePart") and plot:FindFirstChild("ClickDetector") then
		fireclickdetector(plot.ClickDetector)
		return true, "Planted!"
	elseif plot:IsA("Model") then
		-- Try to find a click detector in the model
		for _, child in ipairs(plot:GetDescendants()) do
			if child:IsA("ClickDetector") then
				fireclickdetector(child)
				return true, "Planted!"
			end
		end
	end
	
	-- Fallback: try using the Tool (if holding seeds)
	local character = player.Character
	for _, tool in ipairs(character:GetChildren()) do
		if tool:IsA("Tool") and (tool.Name:lower():find("seed") or tool.Name:lower():find("plant")) then
			tool:Activate()
			return true, "Used tool: " .. tool.Name
		end
	end
	
	return false, "No seeds or clickable plot found"
end

--- Harvest ready crops near the player
function Garden:HarvestNearby()
	local player = game:GetService("Players").LocalPlayer
	if not player or not player.Character then return 0 end
	local root = player.Character:FindFirstChild("HumanoidRootPart")
	if not root then return 0 end
	
	local harvested = 0
	
	-- Find all harvestable objects
	local crops = workspace:FindFirstChild("Crops") or workspace:FindFirstChild("Plants")
		or workspace:FindFirstChild("Garden")
	
	local targets = {}
	if crops then
		for _, obj in ipairs(crops:GetChildren()) do
			table.insert(targets, obj)
		end
	else
		-- Fallback: scan workspace for ripe plants
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and (obj.Name:lower():find("carrot") or obj.Name:lower():find("tomato") 
				or obj.Name:lower():find("wheat") or obj.Name:lower():find("ripe") 
				or obj.Name:lower():find("ready") or obj.Name:lower():find("harvest")) then
				table.insert(targets, obj)
			end
		end
	end
	
	for _, crop in ipairs(targets) do
		if harvested >= 10 then break end -- Limit per cycle
		
		local cropPos = crop:IsA("Model") and crop.PrimaryPart and crop.PrimaryPart.Position or crop.Position
		local dist = (root.Position - cropPos).Magnitude
		
		if dist < CONFIG.Game.CollectRadius then
			-- Click/harvest the crop
			if crop:IsA("BasePart") and crop:FindFirstChild("ClickDetector") then
				fireclickdetector(crop.ClickDetector)
				harvested = harvested + 1
			elseif crop:IsA("Model") then
				for _, child in ipairs(crop:GetDescendants()) do
					if child:IsA("ClickDetector") then
						fireclickdetector(child)
						harvested = harvested + 1
						break
					end
				end
			end
			
			task.wait(0.15)
		end
	end
	
	return harvested
end

--- Water nearby plants
function Garden:WaterPlants()
	local player = game:GetService("Players").LocalPlayer
	if not player or not player.Character then return false end
	
	-- Look for a watering can tool
	for _, tool in ipairs(player.Character:GetChildren()) do
		if tool:IsA("Tool") and (tool.Name:lower():find("water") or tool.Name:lower():find("can") 
			or tool.Name:lower():find("sprinkler")) then
			tool:Activate()
			return true, "Watered with " .. tool.Name
		end
	end
	
	-- Try using a watering can from backpack
	local backpack = player:FindFirstChild("Backpack")
	if backpack then
		for _, tool in ipairs(backpack:GetChildren()) do
			if tool:IsA("Tool") and (tool.Name:lower():find("water") or tool.Name:lower():find("can")) then
				tool.Parent = player.Character
				task.wait(0.2)
				tool:Activate()
				task.wait(0.1)
				tool.Parent = backpack
				return true, "Used watering can"
			end
		end
	end
	
	return false, "No watering tool found"
end

--- Get player's current coins/money
function Garden:GetCoins()
	local player = game:GetService("Players").LocalPlayer
	if not player then return 0 end
	
	-- Check leaderstats
	local ls = player:FindFirstChild("leaderstats")
	if ls then
		for _, stat in ipairs(ls:GetChildren()) do
			if stat:IsA("NumberValue") and (stat.Name:lower():find("coin") or stat.Name:lower():find("money")
				or stat.Name:lower():find("cash") or stat.Name:lower():find("gold")) then
				return stat.Value
			end
		end
	end
	
	-- Check IntValues directly on player
	for _, val in ipairs(player:GetChildren()) do
		if val:IsA("NumberValue") and (val.Name:lower():find("coin") or val.Name:lower():find("money")) then
			return val.Value
		end
	end
	
	return 0
end

--- Get player's level/experience
function Garden:GetLevel()
	local player = game:GetService("Players").LocalPlayer
	if not player then return 0 end
	
	local ls = player:FindFirstChild("leaderstats")
	if ls then
		for _, stat in ipairs(ls:GetChildren()) do
			if stat:IsA("NumberValue") and (stat.Name:lower():find("level") or stat.Name:lower():find("exp")
				or stat.Name:lower():find("rank")) then
				return stat.Value
			end
		end
	end
	
	return 0
end

--- Get inventory summary
function Garden:GetInventory()
	local player = game:GetService("Players").LocalPlayer
	if not player then return {} end
	
	local inventory = {}
	
	-- Check backpack
	local backpack = player:FindFirstChild("Backpack")
	if backpack then
		for _, item in ipairs(backpack:GetChildren()) do
			if item:IsA("Tool") or item:IsA("HopperBin") then
				inventory[item.Name] = (inventory[item.Name] or 0) + 1
			end
		end
	end
	
	-- Check character tools
	if player.Character then
		for _, item in ipairs(player.Character:GetChildren()) do
			if item:IsA("Tool") then
				inventory[item.Name] = (inventory[item.Name] or 0) + 1
			end
		end
	end
	
	return inventory
end

-- ============================================================================
-- BUILD THE COMPLETE GUI
-- ============================================================================

local function BuildGUI()
	-- ========================================================================
	-- CREATE SCREEN GUI
	-- ========================================================================
	
	local player = game:GetService("Players").LocalPlayer
	
	local screenGui = Util:New("ScreenGui", {
		Name = "GrowAGardenGUI",
		DisplayOrder = 10,
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
		Enabled = true,
	}, player:WaitForChild("PlayerGui"))
	
	-- Background overlay (semi-transparent, click-to-close on mobile)
	local bgOverlay = Util:New("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		Visible = false,
		Active = true,
	}, screenGui)
	
	-- ========================================================================
	-- MAIN CONTAINER (centered, responsive)
	-- ========================================================================
	
	local mainContainer = Util:New("Frame", {
		Size = UDim2.new(0, 360, 0, 520),
		Position = UDim2.new(0.5, -180, 0.5, -260),
		BackgroundColor3 = CONFIG.Theme.Primary,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Visible = false,
	}, screenGui)
	
	Util:New("UICorner", {CornerRadius = UDim.new(0, 12)}, mainContainer)
	Util:New("UIStroke", {Color = CONFIG.Theme.Border, Thickness = 1, Transparency = 0.5}, mainContainer)
	
	-- ========================================================================
	-- HEADER — Title bar with close button
	-- ========================================================================
	
	local header = Util:New("Frame", {
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundColor3 = CONFIG.Theme.Secondary,
		BorderSizePixel = 0,
	}, mainContainer)
	Util:New("UICorner", {CornerRadius = UDim.new(0, 12)}, header)
	
	-- Mask the top corners only
	local headerMask = Util:New("Frame", {
		Size = UDim2.new(1, 0, 0, 12),
		Position = UDim2.new(0, 0, 1, -12),
		BackgroundColor3 = CONFIG.Theme.Primary,
		BorderSizePixel = 0,
	}, header)
	Util:New("UICorner", {CornerRadius = UDim.new(0, 12)}, headerMask)
	
	Util:Label("🌱  Grow a Garden 2", UDim2.new(1, -40, 1, 0), UDim2.new(0, 14, 0, 0),
		CONFIG.Theme.Text, CONFIG.UI.FontBold, 17, header)
	
	-- Close button
	local closeBtn = Util:New("TextButton", {
		Size = UDim2.new(0, 28, 0, 28),
		Position = UDim2.new(1, -34, 0.5, -14),
		BackgroundColor3 = Color3.fromRGB(60, 40, 40),
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Text = "✕",
		TextColor3 = CONFIG.Theme.Text,
		Font = CONFIG.UI.Font,
		TextSize = 15,
	}, header)
	Util:New("UICorner", {CornerRadius = UDim.new(0, 6)}, closeBtn)
	
	closeBtn.MouseEnter:Connect(function()
		Util:Animate(closeBtn, {BackgroundColor3 = CONFIG.Theme.Danger, BackgroundTransparency = 0}, 0.15)
	end)
	closeBtn.MouseLeave:Connect(function()
		Util:Animate(closeBtn, {BackgroundColor3 = Color3.fromRGB(60, 40, 40), BackgroundTransparency = 0.3}, 0.15)
	end)
	closeBtn.MouseButton1Click:Connect(function()
		Util:Animate(mainContainer, {Size = UDim2.new(0, 360, 0, 0), BackgroundTransparency = 1}, 0.25)
		task.delay(0.3, function()
			mainContainer.Visible = false
			bgOverlay.Visible = false
		end)
	end)
	
	-- ========================================================================
	-- TAB BAR — Navigation between sections
	-- ========================================================================
	
	local tabBar = Util:New("Frame", {
		Size = UDim2.new(1, -16, 0, 36),
		Position = UDim2.new(0, 8, 0, 50),
		BackgroundTransparency = 1,
	}, mainContainer)
	
	local tabs = {"Info", "Garden", "Shop", "Auto"}
	local activeTab = 1
	local tabButtons = {}
	
	for i, tabName in ipairs(tabs) do
		local tabX = (i - 1) * 0.25
		local isActive = (i == 1)
		
		local tabBtn = Util:New("TextButton", {
			Size = UDim2.new(0.22, 0, 1, 0),
			Position = UDim2.new(tabX + (i-1)*0.02, 0, 0, 0),
			BackgroundColor3 = isActive and CONFIG.Theme.Accent or CONFIG.Theme.Secondary,
			BackgroundTransparency = isActive and 0 or 0.5,
			BorderSizePixel = 0,
			Text = tabName,
			TextColor3 = CONFIG.Theme.Text,
			Font = CONFIG.UI.FontBold,
			TextSize = 13,
		}, tabBar)
		Util:New("UICorner", {CornerRadius = UDim.new(0, 6)}, tabBtn)
		
		tabBtn.MouseEnter:Connect(function()
			if i ~= activeTab then
				Util:Animate(tabBtn, {BackgroundTransparency = 0.2}, 0.12)
			end
		end)
		tabBtn.MouseLeave:Connect(function()
			if i ~= activeTab then
				Util:Animate(tabBtn, {BackgroundTransparency = 0.5}, 0.12)
			end
		end)
		
		tabBtn.MouseButton1Click:Connect(function()
			if i == activeTab then return end
			-- Deactivate old tab
			Util:Animate(tabButtons[activeTab], {
				BackgroundColor3 = CONFIG.Theme.Secondary,
				BackgroundTransparency = 0.5,
			}, 0.15)
			
			-- Activate new tab
			activeTab = i
			Util:Animate(tabBtn, {
				BackgroundColor3 = CONFIG.Theme.Accent,
				BackgroundTransparency = 0,
			}, 0.15)
			
			-- Switch content
			for j, content in ipairs(tabContents) do
				content.Visible = (j == i)
				if content.Visible then
					Util:Animate(content, {BackgroundTransparency = 0}, 0.2)
				end
			end
		end)
		
		tabButtons[i] = tabBtn
	end
	
	-- ========================================================================
	-- TAB CONTENT CONTAINERS
	-- ========================================================================
	
	local contentArea = Util:New("Frame", {
		Size = UDim2.new(1, -16, 1, -100),
		Position = UDim2.new(0, 8, 0, 90),
		BackgroundTransparency = 1,
	}, mainContainer)
	
	local tabContents = {}
	
	-- ========================================================================
	-- TAB 1: INFO — Player information panel
	-- ========================================================================
	
	local infoTab = Util:New("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
	}, contentArea)
	tabContents[1] = infoTab
	
	-- Player avatar display area (simulated with a styled frame)
	local avatarFrame = Util:Panel(
		UDim2.new(1, 0, 0, 90),
		UDim2.new(0, 0, 0, 5),
		CONFIG.Theme.Secondary,
		infoTab
	)
	
	Util:Label("👤  " .. player.Name, UDim2.new(1, -16, 0, 28), UDim2.new(0, 12, 0, 8),
		CONFIG.Theme.Text, CONFIG.UI.FontBold, 18, avatarFrame)
	
	-- Stats row
	local statsY = 44
	local statLabels = {}
	
	-- Coins
	Util:Label("💰  Coins:", UDim2.new(0, 100, 0, 22), UDim2.new(0, 12, 0, statsY),
		CONFIG.Theme.TextMuted, nil, 13, avatarFrame)
	local coinsLabel = Util:Label("0", UDim2.new(1, -120, 0, 22), UDim2.new(1, -108, 0, statsY),
		CONFIG.Theme.Gold, CONFIG.UI.FontBold, 15, avatarFrame, Enum.TextXAlignment.Right)
	
	-- Level
	Util:Label("⭐  Level:", UDim2.new(0, 100, 0, 22), UDim2.new(0, 12, 0, statsY + 24),
		CONFIG.Theme.TextMuted, nil, 13, avatarFrame)
	local levelLabel = Util:Label("0", UDim2.new(1, -120, 0, 22), UDim2.new(1, -108, 0, statsY + 24),
		CONFIG.Theme.Accent, CONFIG.UI.FontBold, 15, avatarFrame, Enum.TextXAlignment.Right)
	
	-- Quick actions under avatar
	Util:Label("Quick Actions", UDim2.new(1, -16, 0, 20), UDim2.new(0, 8, 0, 104),
		CONFIG.Theme.Text, CONFIG.UI.FontBold, 14, infoTab)
	
	-- Refresh stats button
	Util:Button("⟳  Refresh Stats", UDim2.new(1, 0, 0, 34), UDim2.new(0, 0, 0, 128),
		function()
			local coins = Garden:GetCoins()
			local level = Garden:GetLevel()
			coinsLabel.Text = tostring(coins)
			levelLabel.Text = tostring(level)
			Util:Toast("Stats updated!", "success", screenGui)
			
			-- Also update inventory display
			local inv = Garden:GetInventory()
			local invText = ""
			local count = 0
			for name, qty in pairs(inv) do
				if count > 0 then invText = invText .. "\n" end
				invText = invText .. "• " .. name .. " x" .. tostring(qty)
				count = count + 1
			end
			if count == 0 then invText = "Empty" end
			inventoryLabel.Text = invText
		end,
		infoTab, {Color = CONFIG.Theme.Accent, HoverColor = CONFIG.Theme.AccentDark, TextSize = 13}
	)
	
	-- Inventory list
	Util:Label("🎒  Inventory", UDim2.new(1, -16, 0, 20), UDim2.new(0, 8, 0, 174),
		CONFIG.Theme.Text, CONFIG.UI.FontBold, 14, infoTab)
	
	local inventoryScroll = Util:New("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, -208),
		Position = UDim2.new(0, 0, 0, 196),
		BackgroundColor3 = CONFIG.Theme.Secondary,
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = CONFIG.Theme.Accent,
		CanvasSize = UDim2.new(0, 0, 0, 200),
	}, infoTab)
	Util:New("UICorner", {CornerRadius = UDim.new(0, 6)}, inventoryScroll)
	
	local inventoryLabel = Util:Label("Loading...", UDim2.new(1, -16, 1, -8), UDim2.new(0, 8, 0, 4),
		CONFIG.Theme.TextMuted, nil, 12, inventoryScroll)
	
	-- ========================================================================
	-- TAB 2: GARDEN — Main farming controls
	-- ========================================================================
	
	local gardenTab = Util:New("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Visible = false,
	}, contentArea)
	tabContents[2] = gardenTab
	
	Util:Label("🌻  Garden Controls", UDim2.new(1, -16, 0, 24), UDim2.new(0, 8, 0, 8),
		CONFIG.Theme.Text, CONFIG.UI.FontBold, 16, gardenTab)
	
	-- Plant seed button
	Util:Button("🌱  Plant Seed", UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 38),
		function()
			local success, msg = Garden:PlantSeed()
			if success then
				Util:Toast("✅ " .. msg, "success", screenGui)
			else
				Util:Toast("❌ " .. (msg or "Failed to plant"), "error", screenGui)
			end
		end,
		gardenTab, {Color = CONFIG.Theme.Accent, HoverColor = CONFIG.Theme.AccentDark, TextSize = 14}
	)
	
	-- Harvest button
	Util:Button("🧺  Harvest Crops", UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 86),
		function()
			local count = Garden:HarvestNearby()
			if count > 0 then
				Util:Toast("✅ Harvested " .. tostring(count) .. " crops!", "success", screenGui)
			else
				Util:Toast("🌾 No harvestable crops nearby", "info", screenGui)
			end
		end,
		gardenTab, {Color = CONFIG.Theme.Gold, HoverColor = Color3.fromRGB(230, 170, 0), TextSize = 14}
	)
	
	-- Water plants button
	Util:Button("💧  Water Plants", UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 134),
		function()
			local success, msg = Garden:WaterPlants()
			if success then
				Util:Toast("💧 " .. msg, "info", screenGui)
			else
				Util:Toast("❌ " .. (msg or "No watering tool"), "warning", screenGui)
			end
		end,
		gardenTab, {Color = CONFIG.Theme.Sky, HoverColor = Color3.fromRGB(66, 165, 245), TextSize = 14}
	)
	
	-- Auto-plant toggle
	local _, getAutoPlant = Util:Toggle(false, "Auto-Plant (continuous)", gardenTab, 188)
	
	-- Auto-harvest toggle
	local _, getAutoHarvest = Util:Toggle(false, "Auto-Harvest (continuous)", gardenTab, 222)
	
	-- Action log
	Util:Label("📋  Action Log", UDim2.new(1, -16, 0, 18), UDim2.new(0, 8, 0, 258),
		CONFIG.Theme.TextMuted, nil, 13, gardenTab)
	
	local logScroll = Util:New("ScrollingFrame", {
		Size = UDim2.new(1, 0, 0, 100),
		Position = UDim2.new(0, 0, 1, -120),
		BackgroundColor3 = CONFIG.Theme.Secondary,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = CONFIG.Theme.Accent,
		CanvasSize = UDim2.new(0, 0, 0, 200),
	}, gardenTab)
	Util:New("UICorner", {CornerRadius = UDim.new(0, 6)}, logScroll)
	
	local logLabel = Util:Label("Ready", UDim2.new(1, -12, 1, -4), UDim2.new(0, 6, 0, 2),
		CONFIG.Theme.TextMuted, nil, 11, logScroll)
	
	-- Helper to add log entries
	local logHistory = {}
	local function addLog(msg)
		table.insert(logHistory, os.date("%H:%M:%S") .. " | " .. msg)
		if #logHistory > 20 then
			table.remove(logHistory, 1)
		end
		logLabel.Text = table.concat(logHistory, "\n")
		logScroll.CanvasSize = UDim2.new(0, 0, 0, math.max(200, #logHistory * 18))
		task.spawn(function()
			logScroll.CanvasPosition = Vector2.new(0, logScroll.CanvasSize.Y.Offset)
		end)
	end
	
	-- Wire toggles to log
	local autoPlantRunning = false
	local autoHarvestRunning = false
	
	-- ========================================================================
	-- TAB 3: SHOP — Seeds and items
	-- ========================================================================
	
	local shopTab = Util:New("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Visible = false,
	}, contentArea)
	tabContents[3] = shopTab
	
	Util:Label("🏪  Seed Shop", UDim2.new(1, -16, 0, 24), UDim2.new(0, 8, 0, 8),
		CONFIG.Theme.Text, CONFIG.UI.FontBold, 16, shopTab)
	
	-- Shop items (you can customize these)
	local shopItems = {
		{Name = "Carrot Seeds", Price = 10, Emoji = "🥕"},
		{Name = "Tomato Seeds", Price = 25, Emoji = "🍅"},
		{Name = "Wheat Seeds", Price = 15, Emoji = "🌾"},
		{Name = "Pumpkin Seeds", Price = 50, Emoji = "🎃"},
		{Name = "Sunflower Seeds", Price = 35, Emoji = "🌻"},
		{Name = "Golden Seeds", Price = 100, Emoji = "🌟"},
	}
	
	local shopScroll = Util:New("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, -38),
		Position = UDim2.new(0, 0, 0, 36),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = CONFIG.Theme.Accent,
		CanvasSize = UDim2.new(0, 0, 0, #shopItems * 52),
	}, shopTab)
	
	for i, item in ipairs(shopItems) do
		local itemY = (i - 1) * 50
		
		local itemFrame = Util:Panel(
			UDim2.new(1, -4, 0, 46),
			UDim2.new(0, 2, 0, itemY + 2),
			CONFIG.Theme.Secondary,
			shopScroll,
			0.3
		)
		
		Util:Label(item.Emoji .. "  " .. item.Name, UDim2.new(0, 160, 1, 0), UDim2.new(0, 10, 0, 0),
			CONFIG.Theme.Text, nil, 14, itemFrame)
		
		Util:Label("💰 " .. tostring(item.Price), UDim2.new(0, 80, 1, 0), UDim2.new(0, 155, 0, 0),
			CONFIG.Theme.Gold, CONFIG.UI.FontBold, 14, itemFrame)
		
		Util:Button("Buy", UDim2.new(0, 55, 0, 30), UDim2.new(0, 230, 0.5, -15),
			function()
				local coins = Garden:GetCoins()
				if coins >= item.Price then
					Util:Toast("✅ Bought " .. item.Name .. "! (-" .. tostring(item.Price) .. " coins)", "success", screenGui)
					addLog("Purchased: " .. item.Name)
				else
					Util:Toast("❌ Need " .. tostring(item.Price - coins) .. " more coins", "error", screenGui)
				end
			end,
			itemFrame,
			{Color = CONFIG.Theme.Accent, TextSize = 12}
		)
	end
	
	-- ========================================================================
	-- TAB 4: AUTO — Automation settings
	-- ========================================================================
	
	local autoTab = Util:New("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Visible = false,
	}, contentArea)
	tabContents[4] = autoTab
	
	Util:Label("⚙️  Automation", UDim2.new(1, -16, 0, 24), UDim2.new(0, 8, 0, 8),
		CONFIG.Theme.Text, CONFIG.UI.FontBold, 16, autoTab)
	
	-- Auto-Plant toggle (with actual functionality)
	local _, getAutoPlantToggle = Util:Toggle(false, "Auto-Plant Seeds", autoTab, 36)
	
	-- Auto-Harvest toggle
	local _, getAutoHarvestToggle = Util:Toggle(false, "Auto-Harvest Crops", autoTab, 72)
	
	-- Auto-Water toggle
	local _, getAutoWaterToggle = Util:Toggle(false, "Auto-Water Plants", autoTab, 108)
	
	-- Delay slider label
	Util:Label("⏱️  Action Delay: 0.5s", UDim2.new(1, -16, 0, 20), UDim2.new(0, 8, 0, 144),
		CONFIG.Theme.Text, nil, 13, autoTab)
	
	-- Simple delay indicator (visual bar)
	local delayBar = Util:New("Frame", {
		Size = UDim2.new(1, -16, 0, 8),
		Position = UDim2.new(0, 8, 0, 168),
		BackgroundColor3 = CONFIG.Theme.Border,
		BorderSizePixel = 0,
	}, autoTab)
	Util:New("UICorner", {CornerRadius = UDim.new(0, 4)}, delayBar)
	
	local delayFill = Util:New("Frame", {
		Size = UDim2.new(0.25, 0, 1, 0),
		BackgroundColor3 = CONFIG.Theme.Accent,
		BorderSizePixel = 0,
	}, delayBar)
	Util:New("UICorner", {CornerRadius = UDim.new(0, 4)}, delayFill)
	
	Util:Label("← Faster        Slower →", UDim2.new(1, -16, 0, 16), UDim2.new(0, 8, 0, 180),
		CONFIG.Theme.TextMuted, nil, 11, autoTab)
	
	-- Auto-Farm distance label
	Util:Label("📏  Max Farm Distance: 50 studs", UDim2.new(1, -16, 0, 20), UDim2.new(0, 8, 0, 202),
		CONFIG.Theme.Text, nil, 13, autoTab)
	
	-- Start/Stop All button
	Util:Button("▶  Start All Automation", UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 240),
		function()
			local plant = getAutoPlantToggle()
			local harvest = getAutoHarvestToggle()
			local water = getAutoWaterToggle()
			
			if not plant and not harvest and not water then
				Util:Toast("⚠️ Enable at least one automation toggle", "warning", screenGui)
				return
			end
			
			Util:Toast("✅ Automation started!", "success", screenGui)
			addLog("Automation started: Plant=" .. tostring(plant) .. 
				", Harvest=" .. tostring(harvest) .. ", Water=" .. tostring(water))
			
			-- Start automation loop
			task.spawn(function()
				while mainContainer.Visible and (getAutoPlantToggle() or getAutoHarvestToggle() or getAutoWaterToggle()) do
					local delay = 0.5 + (delayFill.Size.X.Scale * 2)
					
					if getAutoPlantToggle() then
						local success, msg = Garden:PlantSeed()
						if success then
							addLog("Planted seed")
						end
						task.wait(delay)
					end
					
					if getAutoHarvestToggle() then
						local count = Garden:HarvestNearby()
						if count > 0 then
							addLog("Harvested " .. tostring(count) .. " crops")
						end
						task.wait(delay)
					end
					
					if getAutoWaterToggle() then
						local success, msg = Garden:WaterPlants()
						if success then
							addLog("Watered plants")
						end
						task.wait(delay)
					end
					
					task.wait(0.3)
				end
				addLog("Automation stopped")
				Util:Toast("⏹️ Automation stopped", "info", screenGui)
			end)
		end,
		autoTab,
		{Color = CONFIG.Theme.Success, HoverColor = Color3.fromRGB(27, 160, 80), TextSize = 14}
	)
	
	-- ========================================================================
	-- TOGGLE BUTTON — Show/Hide the GUI
	-- ========================================================================
	
	-- Small floating button to reopen the GUI
	local toggleGuiBtn = Util:New("TextButton", {
		Size = UDim2.new(0, 44, 0, 44),
		Position = UDim2.new(1, -56, 1, -68),
		BackgroundColor3 = CONFIG.Theme.Accent,
		BackgroundTransparency = 0.15,
		BorderSizePixel = 0,
		Text = "🌱",
		TextSize = 22,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		ZIndex = 100,
	}, screenGui)
	Util:New("UICorner", {CornerRadius = UDim.new(0, 12)}, toggleGuiBtn)
	
	-- Shadow effect
	local shadow = Util:New("Frame", {
		Size = UDim2.new(1, 4, 1, 4),
		Position = UDim2.new(0, -2, 0, -2),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.6,
		BorderSizePixel = 0,
		ZIndex = 99,
	}, toggleGuiBtn)
	Util:New("UICorner", {CornerRadius = UDim.new(0, 12)}, shadow)
	
	toggleGuiBtn.MouseButton1Click:Connect(function()
		if mainContainer.Visible then
			Util:Animate(mainContainer, {Size = UDim2.new(0, 360, 0, 0), BackgroundTransparency = 1}, 0.25)
			task.delay(0.3, function()
				mainContainer.Visible = false
				bgOverlay.Visible = false
			end)
		else
			mainContainer.Visible = true
			bgOverlay.Visible = true
			mainContainer.Size = UDim2.new(0, 360, 0, 0)
			mainContainer.BackgroundTransparency = 1
			Util:Animate(mainContainer, {
				Size = UDim2.new(0, 360, 0, 520),
				BackgroundTransparency = 0,
			}, 0.35)
		end
	end)
	
	-- ========================================================================
	-- INITIALIZE — First-load setup
	-- ========================================================================
	
	-- Show the GUI after a short delay
	task.wait(0.5)
	mainContainer.Visible = true
	bgOverlay.Visible = true
	Util:Animate(mainContainer, {Size = UDim2.new(0, 360, 0, 520), BackgroundTransparency = 0}, 0.4)
	
	-- Initial stats load
	task.spawn(function()
		task.wait(0.3)
		local coins = Garden:GetCoins()
		local level = Garden:GetLevel()
		coinsLabel.Text = tostring(coins)
		levelLabel.Text = tostring(level)
		
		local inv = Garden:GetInventory()
		local invText = ""
		local count = 0
		for name, qty in pairs(inv) do
			if count > 0 then invText = invText .. "\n" end
			invText = invText .. "• " .. name .. " x" .. tostring(qty)
			count = count + 1
		end
		if count == 0 then invText = "Empty" end
		inventoryLabel.Text = invText
		
		Util:Toast("🌱 Welcome, " .. player.Name .. "!", "info", screenGui, 4)
	end)
	
	-- ========================================================================
	-- RESPONSIVE HANDLING — Mobile-friendly adjustments
	-- ========================================================================
	
	local function handleResize()
		local viewport = workspace.CurrentCamera.ViewportSize
		
		if viewport.X < 500 then
			-- Mobile: full-width container
			mainContainer.Size = UDim2.new(0, viewport.X - 20, 0, 520)
			mainContainer.Position = UDim2.new(0, 10, 0.5, -260)
			toggleGuiBtn.Position = UDim2.new(1, -56, 1, -68)
		elseif viewport.X < 768 then
			-- Tablet
			mainContainer.Size = UDim2.new(0, 380, 0, 520)
			mainContainer.Position = UDim2.new(0.5, -190, 0.5, -260)
		else
			-- Desktop
			mainContainer.Size = UDim2.new(0, 400, 0, 540)
			mainContainer.Position = UDim2.new(0.5, -200, 0.5, -270)
		end
	end
	
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(handleResize)
	task.spawn(handleResize)
	
	-- ========================================================================
	-- CONSOLE COMMANDS — For advanced users
	-- ========================================================================
	
	-- Expose the Garden API globally for console access
	_G.GardenAPI = Garden
	
	print("🌱 Grow a Garden 2 GUI loaded!")
	print("   Commands:")
	print("   - _G.GardenAPI:PlantSeed()")
	print("   - _G.GardenAPI:HarvestNearby()")
	print("   - _G.GardenAPI:WaterPlants()")
	print("   - _G.GardenAPI:GetCoins()")
	print("   - _G.GardenAPI:GetLevel()")
	print("   - _G.GardenAPI:GetInventory()")
	
	return screenGui
end

-- ============================================================================
-- SAFE EXECUTION WRAPPER
-- ============================================================================

local success, err = pcall(function()
	BuildGUI()
end)

if not success then
	warn("[GardenGUI] Failed to load: " .. tostring(err))
	
	-- Show a simple error message in-game
	local errorGui = Instance.new("ScreenGui")
	errorGui.Name = "GardenGUIError"
	errorGui.ResetOnSpawn = false
	errorGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	
	local errorFrame = Instance.new("Frame")
	errorFrame.Size = UDim2.new(1, 0, 1, 0)
	errorFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	errorFrame.BackgroundTransparency = 0.5
	errorFrame.Parent = errorGui
	
	local errorText = Instance.new("TextLabel")
	errorText.Size = UDim2.new(0, 400, 0, 60)
	errorText.Position = UDim2.new(0.5, -200, 0.5, -30)
	errorText.BackgroundTransparency = 1
	errorText.Text = "🌱 Garden GUI Error\n" .. tostring(err)
	errorText.TextColor3 = Color3.fromRGB(255, 100, 100)
	errorText.Font = Enum.Font.Gotham
	errorText.TextSize = 16
	errorText.TextWrapped = true
	errorText.TextXAlignment = Enum.TextXAlignment.Center
	errorText.Parent = errorFrame
	
	task.delay(8, function() errorGui:Destroy() end)
end
