local CelestialLib = {}
CelestialLib.__index = CelestialLib

-- Hàm tạo màu sắc và hiệu ứng bo góc nhanh
local function RoundElement(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = obj
end

function CelestialLib.new(title)
    local self = setmetatable({}, CelestialLib)
    
    -- Khởi tạo ScreenGui
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "Celestial_UI"
    self.Gui.Parent = game:GetService("CoreGui")
    
    -- Khung chính
    self.Main = Instance.new("Frame")
    self.Main.Size = UDim2.new(0, 500, 0, 350)
    self.Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    self.Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12) -- Đen sâu
    self.Main.Parent = self.Gui
    RoundElement(self.Main, 10)
    
    -- Sidebar (Thanh bên trái)
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Size = UDim2.new(0, 140, 1, -40)
    self.Sidebar.Position = UDim2.new(0, 10, 0, 30)
    self.Sidebar.BackgroundTransparency = 1
    self.Sidebar.Parent = self.Main
    
    -- Container chứa nội dung (Bên phải)
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(1, -160, 1, -40)
    self.TabContainer.Position = UDim2.new(0, 150, 0, 30)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = self.Main
    
    -- Tiêu đề
    local Title = Instance.new("TextLabel")
    Title.Text = "  " .. title
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = self.Main

    return self
end

-- Hàm tạo Tab
function CelestialLib:CreateTab(name)
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.ScrollBarThickness = 2
    TabPage.Parent = self.TabContainer
    
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 35)
    TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.Font = Enum.Font.Gotham
    TabButton.Parent = self.Sidebar
    RoundElement(TabButton, 6)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, v in pairs(self.TabContainer:GetChildren()) do v.Visible = false end
        TabPage.Visible = true
    end)
    
    -- Sắp xếp nút trong Sidebar
    local layout = self.Sidebar:FindFirstChild("UIListLayout") or Instance.new("UIListLayout", self.Sidebar)
    layout.Padding = UDim.new(0, 5)

    return TabPage
end

return CelestialLib
