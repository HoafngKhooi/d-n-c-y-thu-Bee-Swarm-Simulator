local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/library/windui"))()

-- 1. Khởi tạo Cửa sổ chính
local Window = WindUI:CreateWindow({
    Title = "✨ CELESTIAL VEIL HUB ✨",
    SubTitle = "Bee Swarm Simulator Edition",
    Icon = "rbxassetid://10723343321", -- Icon Fluent Windows
    Author = "Celestial Team",
    Folder = "Celestial_BSS_Config", -- Thư mục lưu cài đặt
    
    OpenButton = {
        Title = "Celestial Menu",
        Enabled = true,
        Draggable = true,
        OnlyMobile = true, -- Chỉ hiện nút nổi trên điện thoại
        Color = ColorSequence.new(Color3.fromHex("#7775F2"), Color3.fromHex("#AFADFF"))
    }
})

-- 2. Tạo các Tab chính
local MainTab = Window:Tab({ Title = "Trang Chủ", Icon = "solar:home-2-bold" })
local FarmTab = Window:Tab({ Title = "Tự Động", Icon = "solar:check-square-bold" })
local MiscTab = Window:Tab({ Title = "Tiện Ích", Icon = "solar:settings-bold" })

-- ==========================================
-- TRANG CHỦ (Thông tin & Webhook)
-- ==========================================
MainTab:Section({ Title = "Thông Tin Hệ Thống" })

MainTab:Paragraph({
    Title = "Người chơi: " .. game.Players.LocalPlayer.Name,
    Content = "Trạng thái: Đang hoạt động ✅\nPhiên bản: 1.0.5",
})

MainTab:Button({
    Title = "Gửi Webhook Báo Cáo",
    Desc = "Cập nhật mật ong và túi đồ lên Discord",
    Callback = function()
        -- Chèn logic Webhook của bạn ở đây
        WindUI:Notify({
            Title = "Hệ thống",
            Content = "Đã gửi báo cáo thành công!",
            Type = "Success"
        })
    end
})

-- ==========================================
-- TỰ ĐỘNG (Auto Farm)
-- ==========================================
FarmTab:Section({ Title = "Cấu Hình Cày Thu" })

FarmTab:Toggle({
    Title = "Tự Động Đào (Auto Dig)",
    Desc = "Tự động sử dụng Tool để thu hoạch",
    Value = false,
    Callback = function(state)
        _G.AutoDig = state
        task.spawn(function()
            while _G.AutoDig do
                local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
                task.wait(0.1)
            end
        end)
    end
})

FarmTab:Dropdown({
    Title = "Chọn Cánh Đồng",
    Values = {"Sunflower", "Mushroom", "Blue Flower", "Clover", "Spider", "Bamboo"},
    Value = "Sunflower",
    Callback = function(selected)
        print("Đã chọn cánh đồng: " .. selected)
    end
})

-- ==========================================
-- TIỆN ÍCH (Settings)
-- ==========================================
MiscTab:Section({ Title = "Cải Thiện Nhân Vật" })

MiscTab:Slider({
    Title = "Tốc Độ Chạy",
    Step = 1,
    Value = { Min = 16, Max = 300, Default = 16 },
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
})

MiscTab:Button({
    Title = "Hủy Script (Destroy)",
    Color = Color3.fromHex("#FF4830"),
    Callback = function()
        Window:Destroy()
    end
})

-- Tự động chọn Tab đầu tiên khi load
Window:SelectTab(MainTab)
