-- Gọi thư viện tự chế của bạn
-- Chú ý: Thay link bên dưới bằng link Raw chuẩn của CelestialLib.lua
local CelestialLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/HoafngKhooi/d-n-c-y-thu-Bee-Swarm-Simulator/main/CelestialLib.lua"))()

-- 1. Khởi tạo Cửa sổ chính (Tên gọi theo hàm .new bạn đã viết)
local Window = CelestialLib.new("✨ CELESTIAL VEIL HUB ✨")

-- 2. Tạo các Tab chính
local MainTab = Window:CreateTab("Trang Chủ")
local FarmTab = Window:CreateTab("Tự Động")
local MiscTab = Window:CreateTab("Tiện Ích")

-- ==========================================
-- TRANG CHỦ
-- ==========================================
-- (Lưu ý: CelestialLib hiện tại chỉ có AddButton và AddToggle, 
-- nên mình chuyển Paragraph thành Button hoặc Label tùy ý)

MainTab:AddButton("Người chơi: " .. game.Players.LocalPlayer.Name, function()
    print("Đây là thông tin người dùng.")
end)

MainTab:AddButton("Gửi Webhook Báo Cáo", function()
    -- Logic Webhook của bạn
    print("Đang gửi báo cáo tới Discord...")
end)

-- ==========================================
-- TỰ ĐỘNG (Auto Farm)
-- ==========================================
FarmTab:AddToggle("Tự Động Đào (Auto Dig)", function(state)
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

-- ==========================================
-- TIỆN ÍCH (Settings)
-- ==========================================

-- Hiện tại Library của bạn chưa có Slider, 
-- tạm thời mình dùng Button để tăng tốc độ chạy nhé!
MiscTab:AddButton("Tốc độ chạy: Siêu nhanh (100)", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)

MiscTab:AddButton("Tốc độ chạy: Bình thường (16)", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
end)

MiscTab:AddButton("Hủy Script (Destroy UI)", function()
    Window.Gui:Destroy()
end)

-- Mặc định hiển thị Tab đầu tiên
MainTab.Visible = true
