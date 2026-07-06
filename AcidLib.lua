--// Acid Lib v1 - FIXED FULL VERSION

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Acid = {}
Acid.__index = Acid

--// remove old gui
pcall(function()
	local old = PlayerGui:FindFirstChild("AcidLib")
	if old then old:Destroy() end
end)

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AcidLib"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

--// MAIN
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,650,0,420)
Main.Position = UDim2.new(.5,-325,.5,-210)
Main.BackgroundColor3 = Color3.fromRGB(12,12,12)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0,255,120)
Stroke.Thickness = 2
Stroke.Parent = Main

--// TOPBAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,38)
TopBar.BackgroundColor3 = Color3.fromRGB(18,18,18)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0,12,0,0)
Title.Size = UDim2.new(1,-150,1,0)
Title.Font = Enum.Font.GothamBold
Title.Text = "🧪 Acid Library"
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(0,255,120)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

--// BUTTONS (FIXED)
local ButtonHolder = Instance.new("Frame")
ButtonHolder.Size = UDim2.new(0,120,1,0)
ButtonHolder.Position = UDim2.new(1,-120,0,0)
ButtonHolder.BackgroundTransparency = 1
ButtonHolder.Parent = TopBar

local HL = Instance.new("UIListLayout")
HL.FillDirection = Enum.FillDirection.Horizontal
HL.HorizontalAlignment = Enum.HorizontalAlignment.Right
HL.Padding = UDim.new(0,6)
HL.Parent = ButtonHolder

local function MakeTopButton(text)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,32,0,28)
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Parent = ButtonHolder
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
	return b
end

local Minimize = MakeTopButton("-")
local Maximize = MakeTopButton("□")
local Close = MakeTopButton("X")

--// SIDEBAR
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0,170,1,-38)
Sidebar.Position = UDim2.new(0,0,0,38)
Sidebar.BackgroundColor3 = Color3.fromRGB(16,16,16)
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 3
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
Sidebar.Parent = Main

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0,6)
SideLayout.Parent = Sidebar

local SidePad = Instance.new("UIPadding")
SidePad.PaddingTop = UDim.new(0,8)
SidePad.PaddingLeft = UDim.new(0,8)
SidePad.PaddingRight = UDim.new(0,8)
SidePad.Parent = Sidebar

--// SEPARATOR
local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(0,2,1,-38)
Separator.Position = UDim2.new(0,170,0,38)
Separator.BackgroundColor3 = Color3.fromRGB(0,255,120)
Separator.BorderSizePixel = 0
Separator.Parent = Main

--// CONTENT
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-172,1,-38)
Content.Position = UDim2.new(0,172,0,38)
Content.BackgroundColor3 = Color3.fromRGB(20,20,20)
Content.BorderSizePixel = 0
Content.Parent = Main
Instance.new("UICorner", Content).CornerRadius = UDim.new(0,10)

local CP = Instance.new("UIPadding")
CP.PaddingTop = UDim.new(0,10)
CP.PaddingLeft = UDim.new(0,10)
CP.PaddingRight = UDim.new(0,10)
CP.PaddingBottom = UDim.new(0,10)
CP.Parent = Content

--// DRAG
local dragging, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

TopBar.InputEnded:Connect(function()
	dragging = false
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

--// MINIMIZE
local minimized = false
Minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	Sidebar.Visible = not minimized
	Separator.Visible = not minimized
	Content.Visible = not minimized

	Main.Size = minimized and UDim2.new(0,650,0,38) or UDim2.new(0,650,0,420)
end)

--// MAXIMIZE
local maximized = false
local oldSize, oldPos = Main.Size, Main.Position

Maximize.MouseButton1Click:Connect(function()
	maximized = not maximized

	if maximized then
		oldSize = Main.Size
		oldPos = Main.Position
		Main.Size = UDim2.new(0.9,0,0.9,0)
		Main.Position = UDim2.new(0.05,0,0.05,0)
	else
		Main.Size = oldSize
		Main.Position = oldPos
	end
end)

--// CLOSE
Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

--// TABS
local CurrentTab = nil

function Acid:CreateTab(name)

	--// TAB BUTTON (LEFT SIDEBAR)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1,0,0,32)
	tabBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
	tabBtn.Text = name
	tabBtn.TextColor3 = Color3.fromRGB(255,255,255)
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.TextSize = 14
	tabBtn.Parent = Sidebar
	Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0,6)

	--// TAB PAGE (CONTENT AREA)
	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1,0,1,0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.Visible = false
	page.ScrollBarThickness = 4
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.CanvasSize = UDim2.new(0,0,0,0)
	page.Parent = Content

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0,8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = page

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0,10)
	padding.PaddingLeft = UDim.new(0,10)
	padding.PaddingRight = UDim.new(0,10)
	padding.PaddingBottom = UDim.new(0,10)
	padding.Parent = page

	--// TAB OBJECT
	local Tab = {}
	Tab.Page = page

	--// FIRST TAB AUTO SELECT
	if not CurrentTab then
		CurrentTab = Tab
		page.Visible = true
		tabBtn.BackgroundColor3 = Color3.fromRGB(0,255,120)
		tabBtn.TextColor3 = Color3.fromRGB(12,12,12)
	end

	--// TAB SWITCH
	tabBtn.MouseButton1Click:Connect(function()

		if CurrentTab then
			CurrentTab.Page.Visible = false
		end

		CurrentTab = Tab
		page.Visible = true

	end)

	---------------------------------------------------
	-- 🔘 BUTTON
	---------------------------------------------------
	function Tab:CreateButton(data)

		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1,0,0,36)
		btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
		btn.Text = data.Title or "Button"
		btn.TextColor3 = Color3.fromRGB(255,255,255)
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 14
		btn.Parent = page
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

		btn.MouseButton1Click:Connect(function()
			task.spawn(function()
				pcall(function()
					if data.Callback then data.Callback() end
				end)
			end)
		end)

		return btn
	end

	---------------------------------------------------
	-- 🔘 TOGGLE
	---------------------------------------------------
	function Tab:CreateToggle(data)

		local state = data.Default or false

		local holder = Instance.new("Frame")
		holder.Size = UDim2.new(1,0,0,38)
		holder.BackgroundColor3 = Color3.fromRGB(30,30,30)
		holder.BorderSizePixel = 0
		holder.Parent = page
		Instance.new("UICorner", holder).CornerRadius = UDim.new(0,8)

		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Size = UDim2.new(1,-80,1,0)
		label.Position = UDim2.new(0,10,0,0)
		label.Text = data.Title or "Toggle"
		label.TextColor3 = Color3.fromRGB(255,255,255)
		label.Font = Enum.Font.GothamBold
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = holder

		local back = Instance.new("Frame")

	--// BUTTON FIXED
	function Tab:CreateButton(data)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1,0,0,36)
		btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
		btn.Text = data.Title
		btn.TextColor3 = Color3.fromRGB(255,255,255)
		btn.Font = Enum.Font.GothamBold
		btn.Parent = page
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

		btn.MouseButton1Click:Connect(function()
			pcall(data.Callback)
		end)

		return btn
	end

	return Tab
end

function Tab:CreateToggle(data)
	local state = data.Default or false

	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1,0,0,38)
	holder.BackgroundColor3 = Color3.fromRGB(30,30,30)
	holder.Parent = page
	Instance.new("UICorner", holder).CornerRadius = UDim.new(0,8)

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1,-80,1,0)
	label.Position = UDim2.new(0,10,0,0)
	label.Text = data.Title
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder

	local back = Instance.new("Frame")
	back.Size = UDim2.new(0,46,0,22)
	back.Position = UDim2.new(1,-60,0.5,-11)
	back.BackgroundColor3 = Color3.fromRGB(60,60,60)
	back.Parent = holder
	Instance.new("UICorner", back).CornerRadius = UDim.new(1,0)

	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0,18,0,18)
	circle.Position = UDim2.new(0,2,0.5,-9)
	circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
	circle.Parent = back
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

	holder.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			state = not state
			back.BackgroundColor3 = state and Color3.fromRGB(0,255,120) or Color3.fromRGB(60,60,60)
			circle.Position = state and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)
			pcall(function() data.Callback(state) end)
		end
	end)

	return {
		Set = function(_,v)
			state = v
		end,
		Get = function()
			return state
		end
	}
end

function Tab:CreateTextbox(data)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1,0,0,38)
	box.BackgroundColor3 = Color3.fromRGB(30,30,30)
	box.PlaceholderText = data.Placeholder or "Type..."
	box.Text = ""
	box.TextColor3 = Color3.fromRGB(255,255,255)
	box.Font = Enum.Font.Gotham
	box.Parent = page
	Instance.new("UICorner", box).CornerRadius = UDim.new(0,8)

	box.FocusLost:Connect(function(enter)
		if enter then
			pcall(function()
				data.Callback(box.Text)
			end)
		end
	end)

	return box
end

function Tab:CreateDropdown(data)
	local open = false
	local selected = data.Default or data.Options[1]

	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1,0,0,40)
	holder.BackgroundColor3 = Color3.fromRGB(30,30,30)
	holder.ClipsDescendants = true
	holder.Parent = page
	Instance.new("UICorner", holder).CornerRadius = UDim.new(0,8)

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1,0,0,40)
	button.Text = data.Title .. " - " .. selected
	button.BackgroundTransparency = 1
	button.TextColor3 = Color3.fromRGB(255,255,255)
	button.Parent = holder

	local list = Instance.new("Frame")
	list.Position = UDim2.new(0,0,0,40)
	list.Size = UDim2.new(1,0,0,0)
	list.Parent = holder

	local layout = Instance.new("UIListLayout", list)

	button.MouseButton1Click:Connect(function()
		open = not open
		holder.Size = open and UDim2.new(1,0,0,40 + (#data.Options*32)) or UDim2.new(1,0,0,40)
	end)

	for _,v in ipairs(data.Options) do
		local opt = Instance.new("TextButton")
		opt.Size = UDim2.new(1,0,0,32)
		opt.Text = v
		opt.BackgroundColor3 = Color3.fromRGB(20,20,20)
		opt.TextColor3 = Color3.fromRGB(255,255,255)
		opt.Parent = list
		Instance.new("UICorner", opt).CornerRadius = UDim.new(0,6)

		opt.MouseButton1Click:Connect(function()
			selected = v
			button.Text = data.Title .. " - " .. v
			open = false
			holder.Size = UDim2.new(1,0,0,40)
			pcall(function() data.Callback(v) end)
		end)
	end

	return holder
end

return Acid
