--// Acid Lib v1 - Core (Rebuilt)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Acid = {}

--// remove old gui
pcall(function()
	local old = PlayerGui:FindFirstChild("AcidLib")
	if old then old:Destroy() end
end)

--// ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AcidLib"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

--// Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 600, 0, 360)
Main.Position = UDim2.new(0.5, -300, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(10, 12, 10)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 255, 120)
Stroke.Thickness = 2
Stroke.Parent = Main

--// TopBar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 22, 18)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

-- fix bottom rounding
local Fix = Instance.new("Frame")
Fix.Size = UDim2.new(1, 0, 0, 12)
Fix.Position = UDim2.new(0, 0, 1, -12)
Fix.BackgroundColor3 = TopBar.BackgroundColor3
Fix.BorderSizePixel = 0
Fix.Parent = TopBar

--// Title
local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "🧪 Acid Library"
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(0, 255, 120)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

--// Tween helper
local function tween(obj, info, props)
	TweenService:Create(obj, info, props):Play()
end

local btnInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

--// Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0.5, -15)
MinBtn.BackgroundColor3 = Color3.fromRGB(18, 22, 18)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 22
MinBtn.TextColor3 = Color3.fromRGB(0, 255, 120)
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TopBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
	minimized = not minimized

	if minimized then
		tween(Main, btnInfo, {Size = UDim2.new(0, 600, 0, 40)})
	else
		tween(Main, btnInfo, {Size = UDim2.new(0, 600, 0, 360)})
	end
end)

--// Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(18, 22, 18)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = Color3.fromRGB(0, 255, 120)
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
	tween(Main, TweenInfo.new(0.2), {BackgroundTransparency = 1})
	task.wait(0.2)
	ScreenGui:Destroy()
end)

--// Drag System (TopBar)
local dragging = false
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	Main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

TopBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		update(input)
	end
end)

print("🧪 Acid Lib Core Loaded")

function Acid:CreateSplash(data)
	local text = data.Text or "Loading..."

	local Splash = Instance.new("Frame")
	Splash.Name = "AcidSplash"
	Splash.Size = UDim2.new(1, 0, 1, 0)
	Splash.BackgroundColor3 = Color3.fromRGB(5, 6, 5)
	Splash.BorderSizePixel = 0
	Splash.Parent = ScreenGui

	local SplashText = Instance.new("TextLabel")
	SplashText.BackgroundTransparency = 1
	SplashText.Size = UDim2.new(1, 0, 1, 0)
	SplashText.Font = Enum.Font.GothamBold
	SplashText.Text = text
	SplashText.TextSize = 24
	SplashText.TextColor3 = Color3.fromRGB(0, 255, 120)
	SplashText.Parent = Splash

	local TweenService = game:GetService("TweenService")

	local function tween(obj, info, props)
		TweenService:Create(obj, info, props):Play()
	end

	-- fade in
	SplashText.TextTransparency = 1
	tween(SplashText, TweenInfo.new(0.6), {TextTransparency = 0})

	task.wait(2)

	-- fade out
	tween(SplashText, TweenInfo.new(0.6), {TextTransparency = 1})
	tween(Splash, TweenInfo.new(0.6), {BackgroundTransparency = 1})

	task.wait(0.6)

	Splash:Destroy()
end

function Acid:CreateNotif(data)
	local title = data.Title or "Notification"
	local text = data.Text or ""

	local TweenService = game:GetService("TweenService")

	local function tween(obj, info, props)
		TweenService:Create(obj, info, props):Play()
	end

	--// holder
	local Notif = Instance.new("Frame")
	Notif.Size = UDim2.new(0, 250, 0, 70)
	Notif.Position = UDim2.new(1, 260, 1, -90)
	Notif.BackgroundColor3 = Color3.fromRGB(10, 12, 10)
	Notif.BorderSizePixel = 0
	Notif.Parent = ScreenGui

	Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 10)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(0, 255, 120)
	Stroke.Thickness = 2
	Stroke.Parent = Notif

	--// Title
	local Title = Instance.new("TextLabel")
	Title.BackgroundTransparency = 1
	Title.Size = UDim2.new(1, -10, 0, 25)
	Title.Position = UDim2.new(0, 10, 0, 5)
	Title.Font = Enum.Font.GothamBold
	Title.Text = title
	Title.TextSize = 16
	Title.TextColor3 = Color3.fromRGB(0, 255, 120)
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Notif

	--// Text
	local Text = Instance.new("TextLabel")
	Text.BackgroundTransparency = 1
	Text.Size = UDim2.new(1, -10, 0, 35)
	Text.Position = UDim2.new(0, 10, 0, 30)
	Text.Font = Enum.Font.Gotham
	Text.Text = text
	Text.TextSize = 14
	Text.TextColor3 = Color3.fromRGB(200, 200, 200)
	Text.TextXAlignment = Enum.TextXAlignment.Left
	Text.TextWrapped = true
	Text.Parent = Notif

	--// slide in
	tween(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, -270, 1, -90)
	})

	--// auto close
	task.wait(2.5)

	--// slide out
	tween(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = UDim2.new(1, 260, 1, -90)
	})

	task.wait(0.3)
	Notif:Destroy()
end

function Acid:CreateTab(name)
	local Tab = {}

	--// Tab button (left side)
	local TabButton = Instance.new("TextButton")
	TabButton.Size = UDim2.new(1, 0, 0, 35)
	TabButton.BackgroundColor3 = Color3.fromRGB(12, 16, 12)
	TabButton.BorderSizePixel = 0
	TabButton.Text = name
	TabButton.Font = Enum.Font.GothamBold
	TabButton.TextSize = 14
	TabButton.TextColor3 = Color3.fromRGB(0, 255, 120)
	TabButton.Parent = self.TabHolder

	Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)

	--// Content frame for tab
	local TabFrame = Instance.new("Frame")
	TabFrame.Size = UDim2.new(1, 0, 1, 0)
	TabFrame.BackgroundTransparency = 1
	TabFrame.Visible = false
	TabFrame.Parent = self.Content

	--// Store tab reference
	Tab.Button = TabButton
	Tab.Frame = TabFrame

	--// Switch tab function
	local function openTab()
		-- hide all tabs
		for _, v in pairs(self.Content:GetChildren()) do
			if v:IsA("Frame") then
				v.Visible = false
			end
		end

		-- show selected
		TabFrame.Visible = true
	end

	TabButton.MouseButton1Click:Connect(openTab)

	--// auto-select first tab
	if not self.CurrentTab then
		self.CurrentTab = Tab
		TabFrame.Visible = true
	end

	return Tab
end


function Acid:CreateButton(data)
	local title = data.Title or "Button"
	local callback = data.Callback or function() end

	--// Button UI
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1, -10, 0, 35)
	Button.Position = UDim2.new(0, 5, 0, 5)
	Button.BackgroundColor3 = Color3.fromRGB(12, 16, 12)
	Button.BorderSizePixel = 0
	Button.Text = title
	Button.Font = Enum.Font.GothamBold
	Button.TextSize = 14
	Button.TextColor3 = Color3.fromRGB(0, 255, 120)
	Button.Parent = self.CurrentTab and self.CurrentTab.Frame or self.Content

	Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(0, 255, 120)
	Stroke.Thickness = 1
	Stroke.Parent = Button

	--// Tween
	local TweenService = game:GetService("TweenService")

	local function tween(obj, info, props)
		TweenService:Create(obj, info, props):Play()
	end

	local hoverInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	--// Hover animations
	Button.MouseEnter:Connect(function()
		tween(Button, hoverInfo, {BackgroundColor3 = Color3.fromRGB(0, 255, 120), TextColor3 = Color3.fromRGB(10,10,10)})
	end)

	Button.MouseLeave:Connect(function()
		tween(Button, hoverInfo, {BackgroundColor3 = Color3.fromRGB(12, 16, 12), TextColor3 = Color3.fromRGB(0, 255, 120)})
	end)

	--// Click
	Button.MouseButton1Click:Connect(function()
		-- click effect
		tween(Button, TweenInfo.new(0.08), {Size = UDim2.new(1, -14, 0, 32)})
		task.wait(0.08)
		tween(Button, TweenInfo.new(0.08), {Size = UDim2.new(1, -10, 0, 35)})

		-- run callback
		pcall(callback)
	end)
end

function Acid:CreateTextBox(data)
	local title = data.Title or "TextBox"
	local mode = data.Mode or "Text" -- "Text" or "Numbers"
	local placeholder = data.Placeholder or ""
	local callback = data.Callback or function() end

	local TweenService = game:GetService("TweenService")

	local function tween(obj, info, props)
		TweenService:Create(obj, info, props):Play()
	end

	--// container
	local Box = Instance.new("Frame")
	Box.Size = UDim2.new(1, -10, 0, 60)
	Box.Position = UDim2.new(0, 5, 0, 5)
	Box.BackgroundColor3 = Color3.fromRGB(12, 16, 12)
	Box.BorderSizePixel = 0
	Box.Parent = self.CurrentTab and self.CurrentTab.Frame or self.Content

	Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(0, 255, 120)
	Stroke.Thickness = 1
	Stroke.Parent = Box

	--// title
	local Label = Instance.new("TextLabel")
	Label.BackgroundTransparency = 1
	Label.Size = UDim2.new(1, -10, 0, 20)
	Label.Position = UDim2.new(0, 5, 0, 2)
	Label.Font = Enum.Font.GothamBold
	Label.Text = title .. " [" .. mode .. "]"
	Label.TextSize = 14
	Label.TextColor3 = Color3.fromRGB(0, 255, 120)
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Box

	--// textbox
	local Input = Instance.new("TextBox")
	Input.Size = UDim2.new(1, -10, 0, 28)
	Input.Position = UDim2.new(0, 5, 0, 28)
	Input.BackgroundColor3 = Color3.fromRGB(18, 22, 18)
	Input.BorderSizePixel = 0
	Input.PlaceholderText = placeholder
	Input.Text = ""
	Input.Font = Enum.Font.Gotham
	Input.TextSize = 14
	Input.TextColor3 = Color3.fromRGB(255, 255, 255)
	Input.ClearTextOnFocus = false
	Input.Parent = Box

	Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)

	--// number filter
	if mode == "Numbers" then
		Input:GetPropertyChangedSignal("Text"):Connect(function()
			local new = Input.Text:gsub("%D", "") -- remove non-digits
			if Input.Text ~= new then
				Input.Text = new
			end
		end)
	end

	--// submit
	Input.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			pcall(function()
				callback(Input.Text)
			end)
		end
	end)

	--// hover glow effect
	Input.Focused:Connect(function()
		tween(Stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 255, 255)})
	end)

	Input.FocusLost:Connect(function()
		tween(Stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 255, 120)})
	end)
end

function Acid:CreateDropdown(data)
	local title = data.Title or "Dropdown"
	local options = data.Options or {}
	local callback = data.Callback or function() end

	local TweenService = game:GetService("TweenService")

	local function tween(obj, info, props)
		TweenService:Create(obj, info, props):Play()
	end

	--// main container
	local Drop = Instance.new("Frame")
	Drop.Size = UDim2.new(1, -10, 0, 40)
	Drop.Position = UDim2.new(0, 5, 0, 5)
	Drop.BackgroundColor3 = Color3.fromRGB(12, 16, 12)
	Drop.BorderSizePixel = 0
	Drop.ClipsDescendants = true
	Drop.Parent = self.CurrentTab and self.CurrentTab.Frame or self.Content

	Instance.new("UICorner", Drop).CornerRadius = UDim.new(0, 6)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(0, 255, 120)
	Stroke.Thickness = 1
	Stroke.Parent = Drop

	--// title button (opens dropdown)
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1, 0, 0, 40)
	Button.BackgroundTransparency = 1
	Button.Text = title .. " ▼"
	Button.Font = Enum.Font.GothamBold
	Button.TextSize = 14
	Button.TextColor3 = Color3.fromRGB(0, 255, 120)
	Button.Parent = Drop

	--// list holder
	local List = Instance.new("Frame")
	List.Size = UDim2.new(1, 0, 0, #options * 30)
	List.Position = UDim2.new(0, 0, 0, 40)
	List.BackgroundTransparency = 1
	List.Parent = Drop

	local Layout = Instance.new("UIListLayout")
	Layout.Parent = List

	--// state
	local open = false

	--// create options
	for _, v in pairs(options) do
		local Opt = Instance.new("TextButton")
		Opt.Size = UDim2.new(1, 0, 0, 30)
		Opt.BackgroundColor3 = Color3.fromRGB(18, 22, 18)
		Opt.BorderSizePixel = 0
		Opt.Text = v
		Opt.Font = Enum.Font.Gotham
		Opt.TextSize = 13
		Opt.TextColor3 = Color3.fromRGB(255, 255, 255)
		Opt.Parent = List

		Instance.new("UICorner", Opt).CornerRadius = UDim.new(0, 6)

		Opt.MouseButton1Click:Connect(function()
			Button.Text = title .. ": " .. v .. " ▼"
			pcall(function()
				callback(v)
			end)

			-- close after select
			open = false
			tween(Drop, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 40)})
		end)
	end

	--// toggle open/close
	Button.MouseButton1Click:Connect(function()
		open = not open

		if open then
			tween(Drop, TweenInfo.new(0.2), {
				Size = UDim2.new(1, -10, 0, 40 + (#options * 30))
			})
		else
			tween(Drop, TweenInfo.new(0.2), {
				Size = UDim2.new(1, -10, 0, 40)
			})
		end
	end)
end

function Acid:CreateToggle(data)
	local title = data.Title or "Toggle"
	local default = data.Default or false
	local callback = data.Callback or function() end

	local TweenService = game:GetService("TweenService")

	local function tween(obj, info, props)
		TweenService:Create(obj, info, props):Play()
	end

	local state = default

	--// container
	local Box = Instance.new("Frame")
	Box.Size = UDim2.new(1, -10, 0, 40)
	Box.Position = UDim2.new(0, 5, 0, 5)
	Box.BackgroundColor3 = Color3.fromRGB(12, 16, 12)
	Box.BorderSizePixel = 0
	Box.Parent = self.CurrentTab and self.CurrentTab.Frame or self.Content

	Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(0, 255, 120)
	Stroke.Thickness = 1
	Stroke.Parent = Box

	--// title
	local Label = Instance.new("TextLabel")
	Label.BackgroundTransparency = 1
	Label.Size = UDim2.new(1, -70, 1, 0)
	Label.Position = UDim2.new(0, 10, 0, 0)
	Label.Font = Enum.Font.GothamBold
	Label.Text = title
	Label.TextSize = 14
	Label.TextColor3 = Color3.fromRGB(0, 255, 120)
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Box

	--// toggle button (right side)
	local Toggle = Instance.new("Frame")
	Toggle.Size = UDim2.new(0, 45, 0, 22)
	Toggle.Position = UDim2.new(1, -55, 0.5, -11)
	Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	Toggle.BorderSizePixel = 0
	Toggle.Parent = Box

	Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

	local Circle = Instance.new("Frame")
	Circle.Size = UDim2.new(0, 18, 0, 18)
	Circle.Position = UDim2.new(0, 2, 0.5, -9)
	Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Circle.BorderSizePixel = 0
	Circle.Parent = Toggle

	Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

	--// update function
	local function update()
		if state then
			tween(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 255, 120)})
			tween(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9)})
		else
			tween(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
			tween(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9)})
		end
	end

	update()

	--// click
	Toggle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			state = not state
			update()

			pcall(function()
				callback(state)
			end)
		end
	end)
end

function Acid:CreateSlider(data)
	local title = data.Title or "Slider"
	local min = data.Min or 0
	local max = data.Max or 100
	local default = data.Default or min
	local callback = data.Callback or function() end

	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")

	local function tween(obj, info, props)
		TweenService:Create(obj, info, props):Play()
	end

	local dragging = false
	local value = math.clamp(default, min, max)

	--// container
	local Box = Instance.new("Frame")
	Box.Size = UDim2.new(1, -10, 0, 55)
	Box.Position = UDim2.new(0, 5, 0, 5)
	Box.BackgroundColor3 = Color3.fromRGB(12, 16, 12)
	Box.BorderSizePixel = 0
	Box.Parent = self.CurrentTab and self.CurrentTab.Frame or self.Content

	Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(0, 255, 120)
	Stroke.Thickness = 1
	Stroke.Parent = Box

	--// title + value
	local Label = Instance.new("TextLabel")
	Label.BackgroundTransparency = 1
	Label.Size = UDim2.new(1, -10, 0, 20)
	Label.Position = UDim2.new(0, 5, 0, 2)
	Label.Font = Enum.Font.GothamBold
	Label.Text = title
	Label.TextSize = 14
	Label.TextColor3 = Color3.fromRGB(0, 255, 120)
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Box

	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.Size = UDim2.new(1, -10, 0, 20)
	ValueLabel.Position = UDim2.new(0, 5, 0, 2)
	ValueLabel.Font = Enum.Font.Gotham
	ValueLabel.TextSize = 13
	ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
	ValueLabel.Parent = Box

	--// bar background
	local BarBG = Instance.new("Frame")
	BarBG.Size = UDim2.new(1, -20, 0, 10)
	BarBG.Position = UDim2.new(0, 10, 0, 32)
	BarBG.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	BarBG.BorderSizePixel = 0
	BarBG.Parent = Box

	Instance.new("UICorner", BarBG).CornerRadius = UDim.new(1, 0)

	--// fill bar
	local Fill = Instance.new("Frame")
	Fill.Size = UDim2.new(0, 0, 1, 0)
	Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
	Fill.BorderSizePixel = 0
	Fill.Parent = BarBG

	Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

	--// update function
	local function update(v)
		value = math.clamp(v, min, max)

		local percent = (value - min) / (max - min)
		tween(Fill, TweenInfo.new(0.05), {Size = UDim2.new(percent, 0, 1, 0)})

		ValueLabel.Text = tostring(math.floor(value))

		pcall(function()
			callback(value)
		end)
	end

	update(default)

	--// input handling
	BarBG.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local pos = input.Position.X
			local absPos = BarBG.AbsolutePosition.X
			local size = BarBG.AbsoluteSize.X

			local percent = math.clamp((pos - absPos) / size, 0, 1)
			local newValue = min + (max - min) * percent

			update(newValue)
		end
	end)
end

return Acid
