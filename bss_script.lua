-- Gọi thư viện từ GitHub của bạn
local CelestialLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/HoafngKhooi/d-n-c-y-thu-Bee-Swarm-Simulator/main/CelestialLib.lua"))()

-- 1. Khởi tạo Cửa sổ chính
local Window = CelestialLib.new("CELESTIAL VEIL HUB")

-- 2. Tạo các Tab chính
local MainTab = Window:CreateTab("Trang Chủ")
local FarmTab = Window:CreateTab("Tự Động")
local MiscTab = Window:CreateTab("Tiện Ích")

-- ==========================================
-- TRANG CHỦ (Chia thành các cột thông tin)
-- ==========================================
local InfoCol = MainTab:AddColumn("Thông Tin")

InfoCol:AddButton("Player: " .. game.Players.LocalPlayer.DisplayName, function()
    print("User ID: " .. game.Players.LocalPlayer.UserId)
end)

InfoCol:AddButton("Gửi Webhook Báo Cáo", function()
    -- Chèn logic Webhook Discord của bạn vào đây
    print("Đã gửi dữ liệu lên Discord Webhook!")
end)

-- ==========================================
-- TỰ ĐỘNG (Chia thành các cột chức năng cày)
-- ==========================================
-- Cột bên trái: Các tính năng Farm cơ bản
local ToolCol = FarmTab:AddColumn("Công Cụ")

ToolCol:AddToggle("Tự Động Đào (Auto Dig)", function(state)
    _G.AutoDig = state
    if state then
        task.spawn(function()
            while _G.AutoDig do
                local char = game.Players.LocalPlayer.Character
                local tool = char and char:FindFirstChildOfClass("Tool")
                if tool then 
                    tool:Activate() 
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- Cột bên phải: Các cài đặt phụ cho Farm
local SettingCol = FarmTab:AddColumn("Cấu Hình")
SettingCol:AddToggle("Hút Token (Collect)", function(state)
    print("Trạng thái hút Token: ", state)
    -- Logic hút token sẽ chèn ở đây
end)

-- ==========================================
-- TIỆN ÍCH (Cải thiện nhân vật)
-- ==========================================
local PlayerCol = MiscTab:AddColumn("Nhân Vật")

PlayerCol:AddButton("Tốc độ: Siêu nhanh (100)", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)

PlayerCol:AddButton("Tốc độ: Bình thường (16)", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
end)

local SystemCol = MiscTab:AddColumn("Hệ Thống")
SystemCol:AddButton("Hủy Script (Destroy)", function()
    Window.Gui:Destroy()
end)

-- Hiển thị tab đầu tiên mặc định
MainTab.Visible = true
