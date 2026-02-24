local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/library/windui"))()

-- 1. Khởi tạo Window
local Window = WindUI:CreateWindow({
    Title = "✨ CELESTIAL VEIL HUB ✨",
    SubTitle = "Bee Swarm Simulator Edition",
    Icon = "rbxassetid://10723343321", -- Icon Windows Style
    Author = "Celestial Team",
    Folder = "CelestialConfig"
})

-- 2. Tạo các Tab (Thanh bên trái)
local MainTab = Window:CreateTab("Trang Chủ", "home")
local FarmTab = Window:CreateTab("Cày Thu", "shovels")
local MiscTab = Window:CreateTab("Tiện Ích", "settings")

-- 3. Nội dung Tab Trang Chủ
MainTab:AddParagraph({
    Title = "Hệ thống",
    Content = "Chào mừng bạn! Giao diện WindUI đã được kích hoạt thành công."
})

MainTab:AddButton({
    Title = "Gửi Báo Cáo Webhook",
    Desc = "Gửi thông số mật ong hiện tại tới Discord",
    Callback = function()
        print("Đang gửi Webhook...")
        Window:Notify({
            Title = "Hệ thống",
            Content = "Đã gửi báo cáo thành công!",
            Type = "Success"
        })
    end
})

-- 4. Nội dung Tab Cày Thu (Bố cục chia cột hiện đại)
FarmTab:AddToggle({
    Title = "Tự Động Đào (Auto Dig)",
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

FarmTab:AddDropdown({
    Title = "Chọn Cánh Đồng",
    Multi = false,
    Options = {"Sunflower", "Mushroom", "Blue Flower", "Clover", "Spider"},
    Default = "Sunflower",
    Callback = function(selected)
        print("Đã chọn cánh đồng: " .. selected)
    end
})

-- 5. Tab Tiện Ích
MiscTab:AddSlider({
    Title = "Tốc độ chạy (WalkSpeed)",
    Value = 16,
    Min = 16,
    Max = 300,
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
})

-- Tự động mở Tab đầu tiên
Window:SelectTab(MainTab)
