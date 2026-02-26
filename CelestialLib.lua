local CelestialLib = {}
CelestialLib.__index = CelestialLib

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Hàm hỗ trợ bo góc, viền và hiệu ứng mờ
local function AddVisuals(obj, radius, strokeColor, thickness)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = obj
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = strokeColor or Color3.fromRGB(255, 255, 255)
    stroke.Thickness = thickness or 1
    stroke.Transparency = 0.5
    stroke.Parent = obj
end

local function MakeDraggable(dragHandle, mainFrame)
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function CelestialLib.new(title)
    local self = setmetatable({}, CelestialLib)
    
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "Celestial_UI"
    self.Gui.Parent = game:GetService("CoreGui")
    self.Gui.ResetOnSpawn = false

    -- Khung chính
    self.Main = Instance.new("Frame")
    self.Main.Size = UDim2.new(0, 550, 0, 380)
    self.Main.Position = UDim2.new(0.5, -275, 0.5, -190)
    self.Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    self.Main.ClipsDescendants = true
    self.Main.Parent = self.Gui
    AddVisuals(self.Main, 10, Color3.fromRGB(255, 255, 255), 1.2)

    -- LỚP NỀN SKIN (ImageLabel)
    local BackgroundSkin = Instance.new("ImageLabel")
    BackgroundSkin.Name = "Skin"
    BackgroundSkin.Size = UDim2.new(1, 0, 1, 0)
    BackgroundSkin.BackgroundTransparency = 1
    -- Thử dùng ID Image trực tiếp (Nếu vẫn không hiện, hãy thử ID: rbxassetid://1050467319)
    BackgroundSkin.Image = "http://www.roblox.com/asset/?id=1050467319"
    BackgroundSkin.ScaleType = Enum.ScaleType.Crop
    BackgroundSkin.ZIndex = 0
    BackgroundSkin.Parent = self.Main
    
    -- Lớp phủ tối (Để nhìn rõ chữ hơn)
    local Overlay = Instance.new("Frame")
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 0.4
    Overlay.ZIndex = 1
    Overlay.Parent = self.Main

    -- TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundTransparency = 1
    TopBar.ZIndex = 5
    TopBar.Parent = self.Main
    MakeDraggable(TopBar, self.Main)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = "  " .. title
    TitleLabel.Size = UDim2.new(1, -120, 1, 0)
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 6
    TitleLabel.Parent = TopBar

    -- Cụm nút điều khiển
    local BtnContainer = Instance.new("Frame")
    BtnContainer.Size = UDim2.new(0, 110, 1, 0)
    BtnContainer.Position = UDim2.new(1, -115, 0, 0)
    BtnContainer.BackgroundTransparency = 1
    BtnContainer.ZIndex = 6
    BtnContainer.Parent = TopBar
    local bl = Instance.new("UIListLayout", BtnContainer)
    bl.FillDirection = Enum.FillDirection.Horizontal
    bl.HorizontalAlignment = Enum.HorizontalAlignment.Right
    bl.VerticalAlignment = Enum.VerticalAlignment.Center
    bl.Padding = UDim.new(0, 8)

    local function CreateTopBtn(text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 28, 0, 28)
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.Parent = BtnContainer
        AddVisuals(btn, 6, Color3.fromRGB(255,255,255), 0.5)
        btn.MouseButton1Click:Connect(callback)
    end

    CreateTopBtn("✕", Color3.fromRGB(200, 50, 50), function() self.Gui:Destroy() end)
    
    local isMax = true
    CreateTopBtn("□", Color3.fromRGB(60, 60, 65), function()
        isMax = not isMax
        TweenService:Create(self.Main, TweenInfo.new(0.3), {Size = isMax and UDim2.new(0, 550, 0, 380) or UDim2.new(0, 550, 0, 45)}):Play()
    end)

    local MiniIcon = Instance.new("TextButton")
    MiniIcon.Size = UDim2.new(0, 50, 0, 50)
    MiniIcon.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MiniIcon.Text = "😏"
    MiniIcon.TextSize = 30
    MiniIcon.Visible = false
    MiniIcon.Parent = self.Gui
    AddVisuals(MiniIcon, 25, Color3.fromRGB(255,255,255), 1.5)
    MakeDraggable(MiniIcon, MiniIcon)

    CreateTopBtn("−", Color3.fromRGB(60, 60, 65), function() self.Main.Visible = false; MiniIcon.Visible = true end)
    MiniIcon.MouseButton1Click:Connect(function() self.Main.Visible = true; MiniIcon.Visible = false end)

    -- Sidebar & Container (Làm mờ để hiện skin)
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Size = UDim2.new(0, 140, 1, -115)
    self.Sidebar.Position = UDim2.new(0, 10, 0, 55)
    self.Sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.Sidebar.BackgroundTransparency = 0.8 -- Trong suốt 80%
    self.Sidebar.ZIndex = 3
    self.Sidebar.Parent = self.Main
    AddVisuals(self.Sidebar, 8, Color3.fromRGB(255,255,255), 0.5)
    Instance.new("UIListLayout", self.Sidebar).Padding = UDim.new(0, 6)

    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(1, -170, 1, -65)
    self.TabContainer.Position = UDim2.new(0, 160, 0, 55)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.ZIndex = 3
    self.TabContainer.Parent = self.Main

    -- User Profile
    local UserProfile = Instance.new("Frame")
    UserProfile.Size = UDim2.new(0, 130, 0, 45)
    UserProfile.Position = UDim2.new(0, 10, 1, -55)
    UserProfile.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    UserProfile.BackgroundTransparency = 0.6
    UserProfile.ZIndex = 4
    UserProfile.Parent = self.Main
    AddVisuals(UserProfile, 8, Color3.fromRGB(255,255,255), 0.5)

    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(0, 30, 0, 30)
    Avatar.Position = UDim2.new(0, 7, 0.5, -15)
    Avatar.Image = game:GetService("Players"):GetUserThumbnailAsync(game.Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    Avatar.Parent = UserProfile
    AddVisuals(Avatar, 15, Color3.fromRGB(255,255,255), 1)

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
    TabPage.ZIndex = 4
    TabPage.Parent = self.TabContainer
    local l = Instance.new("UIListLayout", TabPage)
    l.FillDirection = Enum.FillDirection.Horizontal
    l.Padding = UDim.new(0, 12)

    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 32)
    TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.BackgroundTransparency = 0.9 -- Rất trong suốt
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.ZIndex = 5
    TabButton.Parent = self.Sidebar
    AddVisuals(TabButton, 6, Color3.fromRGB(255,255,255), 0.5)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, v in pairs(self.TabContainer:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        TabPage.Visible = true
    end)

    function TabPage:AddColumn(title)
        local Column = Instance.new("Frame")
        Column.Size = UDim2.new(0, 180, 1, -10)
        Column.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Column.BackgroundTransparency = 0.7
        Column.ZIndex = 5
        Column.Parent = TabPage
        AddVisuals(Column, 8, Color3.fromRGB(255,255,255), 0.8)

        local ColTitle = Instance.new("TextLabel")
        ColTitle.Text = title:upper()
        ColTitle.Size = UDim2.new(1, 0, 0, 30)
        ColTitle.BackgroundTransparency = 1
        ColTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        ColTitle.ZIndex = 6
        ColTitle.Parent = Column

        local ItemList = Instance.new("UIListLayout", Column)
        ItemList.Padding = UDim.new(0, 6)
        ItemList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        Instance.new("UIPadding", Column).PaddingTop = UDim.new(0, 35)

        function Column:AddButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.9, 0, 0, 32)
            btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundTransparency = 0.9
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.ZIndex = 7
            btn.Parent = Column
            AddVisuals(btn, 6, Color3.fromRGB(255,255,255), 0.4)
            btn.MouseButton1Click:Connect(callback)
        end

        function Column:AddToggle(text, callback)
            local Tgl = Instance.new("TextButton")
            Tgl.Size = UDim2.new(0.9, 0, 0, 32)
            Tgl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Tgl.BackgroundTransparency = 0.9
            Tgl.Text = "  " .. text
            Tgl.TextColor3 = Color3.fromRGB(255, 255, 255)
            Tgl.TextXAlignment = Enum.TextXAlignment.Left
            Tgl.ZIndex = 7
            Tgl.Parent = Column
            AddVisuals(Tgl, 6, Color3.fromRGB(255,255,255), 0.4)

            local Status = Instance.new("Frame")
            Status.Size = UDim2.new(0, 18, 0, 18)
            Status.Position = UDim2.new(1, -25, 0.5, -9)
            Status.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            Status.ZIndex = 8
            Status.Parent = Tgl
            AddVisuals(Status, 4, Color3.fromRGB(0,0,0), 0)

            local en = false
            Tgl.MouseButton1Click:Connect(function()
                en = not en
                Status.BackgroundColor3 = en and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
                callback(en)
            end)
        end
        return Column
    end
    return TabPage
end

return CelestialLib
