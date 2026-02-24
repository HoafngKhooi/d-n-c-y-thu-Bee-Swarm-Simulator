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
    self.Main.Size = UDim2.new(0, 500, 0, 350)
    self.Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    self.Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    self.Main.Parent = self.Gui
    RoundElement(self.Main, 10)
    
    -- Sidebar và Container
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Size = UDim2.new(0, 130, 1, -50)
    self.Sidebar.Position = UDim2.new(0, 10, 0, 40)
    self.Sidebar.BackgroundTransparency = 1
    self.Sidebar.Parent = self.Main
    
    local layout = Instance.new("UIListLayout", self.Sidebar)
    layout.Padding = UDim.new(0, 5)

    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(1, -160, 1, -50)
    self.TabContainer.Position = UDim2.new(0, 150, 0, 40)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = self.Main

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = "  " .. title
    TitleLabel.Size = UDim2.new(1, 0, 0, 40)
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = self.Main

    return self
end

-- HÀM TẠO TAB
function CelestialLib:CreateTab(name)
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.ScrollBarThickness = 2
    TabPage.CanvasSize = UDim2.new(0, 0, 2, 0) -- Cho phép cuộn xuống
    TabPage.Parent = self.TabContainer
    
    local pageLayout = Instance.new("UIListLayout", TabPage)
    pageLayout.Padding = UDim.new(0, 8)

    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 35)
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.Font = Enum.Font.Gotham
    TabButton.Parent = self.Sidebar
    RoundElement(TabButton, 6)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, v in pairs(self.TabContainer:GetChildren()) do v.Visible = false end
        TabPage.Visible = true
    end)

    -- Hàm con: THÊM NÚT (Button) VÀO TAB
    function TabPage:AddButton(text, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -10, 0, 35)
        Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        Btn.Text = text
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.Font = Enum.Font.Gotham
        Btn.Parent = TabPage
        RoundElement(Btn, 6)
        Btn.MouseButton1Click:Connect(callback)
    end

    -- Hàm con: THÊM BẬT/TẮT (Toggle) VÀO TAB
    function TabPage:AddToggle(text, callback)
        local TglFrame = Instance.new("TextButton")
        TglFrame.Size = UDim2.new(1, -10, 0, 35)
        TglFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        TglFrame.Text = "  " .. text
        TglFrame.TextColor3 = Color3.fromRGB(200, 200, 200)
        TglFrame.TextXAlignment = Enum.TextXAlignment.Left
        TglFrame.Font = Enum.Font.Gotham
        TglFrame.Parent = TabPage
        RoundElement(TglFrame, 6)

        local Status = Instance.new("Frame")
        Status.Size = UDim2.new(0, 20, 0, 20)
        Status.Position = UDim2.new(1, -30, 0.5, -10)
        Status.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- Đỏ là Tắt
        Status.Parent = TglFrame
        RoundElement(Status, 4)

        local enabled = false
        TglFrame.MouseButton1Click:Connect(function()
            enabled = not enabled
            Status.BackgroundColor3 = enabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
            callback(enabled)
        end)
    end

    return TabPage
end

return CelestialLib
