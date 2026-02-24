-- Ép tải bản mới bằng cách thêm tick() vào link (nếu cần load lại link chính)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "✨ CELESTIAL HUB ✨",
    SubTitle = "Celestial Veil Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- Tắt Acrylic để nhìn xuyên qua ảnh nền rõ hơn
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- HÀM CHÈN ẢNH NỀN (Tối ưu cho Fluent)
local function AddWallpaper()
    -- Đợi cho đến khi Fluent thực sự tạo ra Folder trong CoreGui
    local FluentGui = game:GetService("CoreGui"):WaitForChild("FluentGui", 5)
    if FluentGui then
        local target = FluentGui:FindFirstChild("Main")
        if target then
            -- Xóa hình nền cũ nếu có
            if target:FindFirstChild("CelestialBackground") then
                target.CelestialBackground:Destroy()
            end

            local Bg = Instance.new("ImageLabel")
            Bg.Name = "CelestialBackground"
            Bg.Parent = target
            Bg.Size = UDim2.new(1, 0, 1, 0)
            Bg.ZIndex = -1 
            Bg.Image = "rbxassetid://338833954" -- Wallpaper ổn định
            Bg.ImageTransparency = 0.6 -- Độ mờ ảnh
            Bg.BackgroundTransparency = 1
            Bg.ScaleType = Enum.ScaleType.Crop
            
            -- Hiệu ứng Gradient động (Lấp lánh)
            local Gradient = Instance.new("UIGradient", Bg)
            Gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 100, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 255))
            })
            
            task.spawn(function()
                while true do
                    local t = game:GetService("TweenService"):Create(Gradient, TweenInfo.new(5, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)})
                    Gradient.Offset = Vector2.new(-1, 0)
                    t:Play()
                    t.Completed:Wait()
                end
            end)
        end
    end
end

-- Chạy hàm thêm nền
task.spawn(AddWallpaper)

-- Cấu trúc Tab
local Tabs = {
    Main = Window:AddTab({ Title = "Trang Chủ", Icon = "home" }),
    Misc = Window:AddTab({ Title = "Tiện ích", Icon = "package" })
}

Tabs.Main:AddParagraph({
    Title = "Hệ thống",
    Content = "Đã sửa lỗi cache. Giao diện Fluent hiện đã sẵn sàng."
})

Tabs.Main:AddButton({
    Title = "Gửi Webhook Test",
    Callback = function()
        print("Đang gửi dữ liệu...")
    end
})

Tabs.Misc:AddSlider("WalkSpeed", {
    Title = "Tốc độ chạy",
    Default = 16,
    Min = 16,
    Max = 300,
    Rounding = 1,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

Window:SelectTab(1)
