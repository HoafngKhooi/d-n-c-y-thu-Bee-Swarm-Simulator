local CelestialLib = {}
CelestialLib.__index = CelestialLib

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Hàm hỗ trợ bo góc
local function RoundElement(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = obj
end

-- Hàm hỗ trợ kéo thả (Dùng được cho cả PC và Mobile)
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

function CelestialLib.new(title)
    local self = setmetatable({}, CelestialLib)
    
    -- Main GUI
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "Celestial_UI"
    self.Gui.Parent = game:GetService("CoreGui")
    self.Gui.ResetOnSpawn = false

    -- Main Frame
    self.Main = Instance.new("Frame")
    self.Main.Size = UDim2.new(0, 550, 0, 380)
    self.Main.Position = UDim2.new(0.5, -275, 0.5, -190)
    self.Main.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
    self.Main.ClipsDescendants = true
    self.Main.Parent = self.Gui
    RoundElement(self.Main, 10)
    MakeDraggable(self.Main) -- Cho phép kéo ở bất kỳ đâu trên Main hoặc thanh tiêu đề

    -- Top Bar (Thanh điều khiển)
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = self.Main

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = "  " .. title
    TitleLabel.Size = UDim2.new(1, -120, 1, 0)
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    -- Nút bấm điều khiển (X, -, □)
    local BtnContainer = Instance.new("Frame")
    BtnContainer.Size = UDim2.new(0, 110, 1, 0)
    BtnContainer.Position = UDim2.new(1, -115, 0, 0)
    BtnContainer.BackgroundTransparency = 1
    BtnContainer.Parent = TopBar
    
    local btnLayout = Instance.new("UIListLayout", BtnContainer)
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    btnLayout.Padding = UDim.new(0, 8)

    local function CreateTopBtn(text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 28, 0, 28)
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.Parent = BtnContainer
        RoundElement(btn, 6)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- Icon 😏 khi thu nhỏ
    local MiniIcon = Instance.new("TextButton")
    MiniIcon.Size = UDim2.new(0, 50, 0, 50)
    MiniIcon.Position = UDim2.new(0.1, 0, 0.1, 0)
    MiniIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MiniIcon.Text = "😏"
    MiniIcon.TextSize = 30
    MiniIcon.Visible = false
    MiniIcon.Parent = self.Gui
    RoundElement(MiniIcon, 25)
    MakeDraggable(MiniIcon)

    -- Logic Nút X (Xóa)
    CreateTopBtn("✕", Color3.fromRGB(200, 50, 50), function()
        self.Gui:Destroy()
    end)

    -- Logic Nút □ (Zoom to/nhỏ)
    local isMaximized = true
    CreateTopBtn("□", Color3.fromRGB(60, 60, 65), function()
        isMaximized = not isMaximized
        TweenService:Create(self.Main, TweenInfo.new(0.3), {
            Size = isMaximized and UDim2.new(0, 550, 0, 380) or UDim2.new(0, 550, 0, 40)
        }):Play()
    end)

    -- Logic Nút - (Ẩn tạm)
    CreateTopBtn("−", Color3.fromRGB(60, 60, 65), function()
        self.Main.Visible = false
        MiniIcon.Visible = true
    end)

    MiniIcon.MouseButton1Click:Connect(function()
        self.Main.Visible = true
        MiniIcon.Visible = false
    end)

    -- Các phần cũ của bạn (Sidebar, TabContainer, UserProfile)
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Size = UDim2.new(0, 140, 1, -80)
    self.Sidebar.Position = UDim2.new(0, 10, 0, 45)
    self.Sidebar.BackgroundTransparency = 1
    self.Sidebar.Parent = self.Main
    Instance.new("UIListLayout", self.Sidebar).Padding = UDim.new(0, 6)

    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(1, -170, 1, -55)
    self.TabContainer.Position = UDim2.new(0, 160, 0, 45)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = self.Main

    -- User Profile
    local UserProfile = Instance.new("Frame")
    UserProfile.Size = UDim2.new(0, 130, 0, 45)
    UserProfile.Position = UDim2.new(0, 10, 1, -55)
    UserProfile.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    UserProfile.Parent = self.Main
    RoundElement(UserProfile, 8)

    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(0, 30, 0, 30)
    Avatar.Position = UDim2.new(0, 7, 0.5, -15)
    Avatar.Image = game:GetService("Players"):GetUserThumbnailAsync(game.Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    Avatar.Parent = UserProfile
    RoundElement(Avatar, 15)

    local UserName = Instance.new("TextLabel")
    UserName.Size = UDim2.new(1, -45, 1, 0)
    UserName.Position = UDim2.new(0, 42, 0, 0)
    UserName.BackgroundTransparency = 1
    UserName.Text = game.Players.LocalPlayer.DisplayName
    UserName.TextColor3 = Color3.fromRGB(255, 255, 255)
    UserName.TextSize = 11
    UserName.Font = Enum.Font.GothamMedium
    UserName.TextXAlignment = Enum.TextXAlignment.Left
    UserName.Parent = UserProfile

    return self
end

function CelestialLib:CreateTab(name)
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.ScrollBarThickness = 0
    TabPage.CanvasSize = UDim2.new(0, 600, 0, 0)
    TabPage.Parent = self.TabContainer
    
    local pageLayout = Instance.new("UIListLayout", TabPage)
    pageLayout.FillDirection = Enum.FillDirection.Horizontal
    pageLayout.Padding = UDim.new(0, 12)

    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 32)
    TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextSize = 13
    TabButton.Parent = self.Sidebar
    RoundElement(TabButton, 6)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, v in pairs(self.TabContainer:GetChildren()) do v.Visible = false end
        TabPage.Visible = true
    end)

    function TabPage:AddColumn(title)
        local Column = Instance.new("Frame")
        Column.Size = UDim2.new(0, 180, 1, -10)
        Column.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
        Column.Parent = TabPage
        RoundElement(Column, 8)

        local ColTitle = Instance.new("TextLabel")
        ColTitle.Text = title:upper()
        ColTitle.Size = UDim2.new(1, 0, 0, 30)
        ColTitle.BackgroundTransparency = 1
        ColTitle.TextColor3 = Color3.fromRGB(120, 120, 130)
        ColTitle.Font = Enum.Font.GothamBold
        ColTitle.TextSize = 10
        ColTitle.Parent = Column

        local ItemList = Instance.new("UIListLayout", Column)
        ItemList.Padding = UDim.new(0, 6)
        ItemList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        Instance.new("UIPadding", Column).PaddingTop = UDim.new(0, 35)

        function Column:AddButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.9, 0, 0, 32)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 12
            btn.Parent = Column
            RoundElement(btn, 6)
            btn.MouseButton1Click:Connect(callback)
        end

        function Column:AddToggle(text, callback)
            local TglFrame = Instance.new("TextButton")
            TglFrame.Size = UDim2.new(0.9, 0, 0, 32)
            TglFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            TglFrame.Text = "  " .. text
            TglFrame.TextColor3 = Color3.fromRGB(180, 180, 180)
            TglFrame.TextXAlignment = Enum.TextXAlignment.Left
            TglFrame.Font = Enum.Font.Gotham
            TglFrame.TextSize = 12
            TglFrame.Parent = Column
            RoundElement(TglFrame, 6)

            local Status = Instance.new("Frame")
            Status.Size = UDim2.new(0, 16, 0, 16)
            Status.Position = UDim2.new(1, -24, 0.5, -8)
            Status.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            Status.Parent = TglFrame
            RoundElement(Status, 4)

            local enabled = false
            TglFrame.MouseButton1Click:Connect(function()
                enabled = not enabled
                Status.BackgroundColor3 = enabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
                callback(enabled)
            end)
        end

        return Column
    end

    return TabPage
end

return CelestialLib
