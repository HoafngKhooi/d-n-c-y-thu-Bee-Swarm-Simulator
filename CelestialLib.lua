local CelestialLib = {}
CelestialLib.__index = CelestialLib

-- Hàm hỗ trợ tạo UI nhanh
local function RoundElement(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = obj
end

function CelestialLib.new(title)
    local self = setmetatable({}, CelestialLib)
    
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "Celestial_UI"
    self.Gui.Parent = game:GetService("CoreGui")
    self.Gui.ResetOnSpawn = false

    self.Main = Instance.new("Frame")
    self.Main.Size = UDim2.new(0, 550, 0, 380) -- Nới rộng một chút để chia cột đẹp hơn
    self.Main.Position = UDim2.new(0.5, -275, 0.5, -190)
    self.Main.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
    self.Main.Parent = self.Gui
    RoundElement(self.Main, 10)
    
    -- Sidebar
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Size = UDim2.new(0, 140, 1, -80) -- Chừa chỗ cho User Profile ở dưới
    self.Sidebar.Position = UDim2.new(0, 10, 0, 45)
    self.Sidebar.BackgroundTransparency = 1
    self.Sidebar.Parent = self.Main
    
    local layout = Instance.new("UIListLayout", self.Sidebar)
    layout.Padding = UDim.new(0, 6)

    -- Container nội dung
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(1, -170, 1, -55)
    self.TabContainer.Position = UDim2.new(0, 160, 0, 45)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = self.Main

    -- Tiêu đề Hub
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = "  " .. title
    TitleLabel.Size = UDim2.new(1, 0, 0, 40)
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = self.Main

    -- [USER PROFILE SECTION] - Phần này đúng theo hình vẽ tay của bạn
    local UserProfile = Instance.new("Frame")
    UserProfile.Size = UDim2.new(0, 130, 0, 45)
    UserProfile.Position = UDim2.new(0, 10, 1, -55)
    UserProfile.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    UserProfile.Parent = self.Main
    RoundElement(UserProfile, 8)

    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(0, 30, 0, 30)
    Avatar.Position = UDim2.new(0, 7, 0.5, -15)
    Avatar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
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

-- HÀM TẠO TAB
function CelestialLib:CreateTab(name)
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.ScrollBarThickness = 0
    TabPage.CanvasSize = UDim2.new(0, 600, 0, 0) -- Canvas ngang để chứa các cột
    TabPage.Parent = self.TabContainer
    
    local pageLayout = Instance.new("UIListLayout", TabPage)
    pageLayout.FillDirection = Enum.FillDirection.Horizontal -- Sắp xếp cột theo hàng ngang
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

    -- [HÀM TẠO CỘT - SECTION] - Để chia bảng như hình vẽ
    function TabPage:AddColumn(title)
        local Column = Instance.new("Frame")
        Column.Size = UDim2.new(0, 180, 1, -10)
        Column.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
        Column.BorderSizePixel = 0
        Column.Parent = TabPage
        RoundElement(Column, 8)

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = Color3.fromRGB(35, 35, 40)
        UIStroke.Thickness = 1
        UIStroke.Parent = Column

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
        
        local Padding = Instance.new("UIPadding", Column)
        Padding.PaddingTop = UDim.new(0, 35)

        -- Thêm Toggle vào Cột
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
