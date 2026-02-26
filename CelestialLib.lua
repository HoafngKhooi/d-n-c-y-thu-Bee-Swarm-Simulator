local CelestialLib = {}
CelestialLib.__index = CelestialLib

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Hàm hỗ trợ bo góc và thêm viền (Stroke)
local function AddVisuals(obj, radius, strokeColor, thickness)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = obj
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = strokeColor or Color3.fromRGB(255, 255, 255)
    stroke.Thickness = thickness or 1
    stroke.Transparency = 0.6
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj
end

-- Hàm hỗ trợ kéo thả (Chỉ kéo ở TopBar)
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

    -- Khung chính có Background Image
    self.Main = Instance.new("ImageLabel") -- Đổi thành ImageLabel để làm nền
    self.Main.Size = UDim2.new(0, 550, 0, 380)
    self.Main.Position = UDim2.new(0.5, -275, 0.5, -190)
    self.Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.Main.Image = "rbxassetid://1050467386" -- ID Hình nền bạn yêu cầu
    self.Main.ScaleType = Enum.ScaleType.Crop
    self.Main.ClipsDescendants = true
    self.Main.Active = true
    self.Main.Parent = self.Gui
    AddVisuals(self.Main, 12, Color3.fromRGB(100, 100, 120), 1.5)

    -- Lớp phủ tối nhẹ để nổi bật chữ (Overlay)
    local Overlay = Instance.new("Frame")
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 0.45 -- Giữ ảnh nhưng làm tối một chút để dễ nhìn menu
    Overlay.ZIndex = 0
    Overlay.Parent = self.Main
    AddVisuals(Overlay, 12, Color3.fromRGB(0,0,0), 0)

    -- TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundTransparency = 1
    TopBar.ZIndex = 2
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
    TitleLabel.Parent = TopBar

    -- Nút điều khiển
    local BtnContainer = Instance.new("Frame")
    BtnContainer.Size = UDim2.new(0, 110, 1, 0)
    BtnContainer.Position = UDim2.new(1, -115, 0, 0)
    BtnContainer.BackgroundTransparency = 1
    BtnContainer.Parent = TopBar
    Instance.new("UIListLayout", BtnContainer).FillDirection = Enum.FillDirection.Horizontal
    BtnContainer.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    BtnContainer.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    BtnContainer.UIListLayout.Padding = UDim.new(0, 8)

    local function CreateTopBtn(text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 28, 0, 28)
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.Parent = BtnContainer
        AddVisuals(btn, 6, Color3.fromRGB(255, 255, 255), 1)
        btn.MouseButton1Click:Connect(callback)
    end

    local MiniIcon = Instance.new("TextButton")
    MiniIcon.Size = UDim2.new(0, 60, 0, 60)
    MiniIcon.Position = UDim2.new(0.1, 0, 0.1, 0)
    MiniIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MiniIcon.Text = "😏"
    MiniIcon.TextSize = 35
    MiniIcon.Visible = false
    MiniIcon.Parent = self.Gui
    AddVisuals(MiniIcon, 30, Color3.fromRGB(255, 255, 255), 2)
    MakeDraggable(MiniIcon, MiniIcon)

    CreateTopBtn("✕", Color3.fromRGB(200, 50, 50), function() self.Gui:Destroy() end)
    
    local isMax = true
    CreateTopBtn("□", Color3.fromRGB(60, 60, 65), function()
        isMax = not isMax
        TweenService:Create(self.Main, TweenInfo.new(0.3), {Size = isMax and UDim2.new(0, 550, 0, 380) or UDim2.new(0, 550, 0, 45)}):Play()
    end)

    CreateTopBtn("−", Color3.fromRGB(60, 60, 65), function() self.Main.Visible = false; MiniIcon.Visible = true end)
    MiniIcon.MouseButton1Click:Connect(function() self.Main.Visible = true; MiniIcon.Visible = false end)

    -- Sidebar & TabContainer (Hiệu ứng mờ bằng BackgroundTransparency)
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Size = UDim2.new(0, 140, 1, -115)
    self.Sidebar.Position = UDim2.new(0, 10, 0, 55)
    self.Sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.Sidebar.BackgroundTransparency = 0.7 -- Hiệu ứng kính mờ
    self.Sidebar.Parent = self.Main
    AddVisuals(self.Sidebar, 8, Color3.fromRGB(255, 255, 255), 0.5)
    Instance.new("UIListLayout", self.Sidebar).Padding = UDim.new(0, 6)
    Instance.new("UIPadding", self.Sidebar).PaddingTop = UDim.new(0, 5)

    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(1, -170, 1, -65)
    self.TabContainer.Position = UDim2.new(0, 160, 0, 55)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = self.Main

    -- User Profile
    local UserProfile = Instance.new("Frame")
    UserProfile.Size = UDim2.new(0, 130, 0, 45)
    UserProfile.Position = UDim2.new(0, 10, 1, -55)
    UserProfile.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    UserProfile.BackgroundTransparency = 0.6
    UserProfile.Parent = self.Main
    AddVisuals(UserProfile, 8, Color3.fromRGB(255, 255, 255), 0.5)

    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(0, 32, 0, 32)
    Avatar.Position = UDim2.new(0, 7, 0.5, -16)
    Avatar.Image = game:GetService("Players"):GetUserThumbnailAsync(game.Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    Avatar.Parent = UserProfile
    AddVisuals(Avatar, 16, Color3.fromRGB(255,255,255), 1)

    local UserName = Instance.new("TextLabel")
    UserName.Size = UDim2.new(1, -45, 1, 0)
    UserName.Position = UDim2.new(0, 45, 0, 0)
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
    Instance.new("UIListLayout", TabPage).FillDirection = Enum.FillDirection.Horizontal
    TabPage.UIListLayout.Padding = UDim.new(0, 12)

    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.9, 0, 0, 35)
    TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.BackgroundTransparency = 0.9 -- Nút tab mờ
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.Parent = self.Sidebar
    AddVisuals(TabButton, 6, Color3.fromRGB(255, 255, 255), 0.5)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, v in pairs(self.TabContainer:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        TabPage.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
        task.wait(0.2)
        TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.9}):Play()
    end)

    function TabPage:AddColumn(title)
        local Column = Instance.new("Frame")
        Column.Size = UDim2.new(0, 185, 1, -5)
        Column.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Column.BackgroundTransparency = 0.75 -- Cột mờ
        Column.Parent = TabPage
        AddVisuals(Column, 8, Color3.fromRGB(255, 255, 255), 0.8)

        local ColTitle = Instance.new("TextLabel")
        ColTitle.Text = title:upper()
        ColTitle.Size = UDim2.new(1, 0, 0, 35)
        ColTitle.BackgroundTransparency = 1
        ColTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        ColTitle.Font = Enum.Font.GothamBold
        ColTitle.TextSize = 11
        ColTitle.Parent = Column

        Instance.new("UIListLayout", Column).Padding = UDim.new(0, 7)
        Column.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        Instance.new("UIPadding", Column).PaddingTop = UDim.new(0, 35)

        function Column:AddButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.9, 0, 0, 32)
            btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundTransparency = 0.9
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.Gotham
            btn.Parent = Column
            AddVisuals(btn, 6, Color3.fromRGB(255, 255, 255), 0.5)
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
            Tgl.Parent = Column
            AddVisuals(Tgl, 6, Color3.fromRGB(255, 255, 255), 0.5)

            local Status = Instance.new("Frame")
            Status.Size = UDim2.new(0, 20, 0, 10)
            Status.Position = UDim2.new(1, -30, 0.5, -5)
            Status.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            Status.Parent = Tgl
            AddVisuals(Status, 5, Color3.fromRGB(0,0,0), 0)

            local en = false
            Tgl.MouseButton1Click:Connect(function()
                en = not en
                TweenService:Create(Status, TweenInfo.new(0.2), {BackgroundColor3 = en and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)}):Play()
                callback(en)
            end)
        end
        return Column
    end
    return TabPage
end

return CelestialLib
