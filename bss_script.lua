-- Ép tải bản mới bằng cách thêm tick() vào link (nếu cần load lại link chính)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "✨ CELESTIAL HUB ✨",
    SubTitle = "Celestial Veil Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- BẮT BUỘC PHẢI LÀ FALSE ĐỂ HIỆN ẢNH
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- HÀM CHÈN ẢNH NỀN (Tối ưu cho Fluent)
local function AddWallpaper()
    local FluentGui = game:GetService("CoreGui"):WaitForChild("FluentGui", 5)
    if FluentGui then
        -- Tìm đến khung Main, nơi chứa nội dung của Fluent
        local target = FluentGui:FindFirstChild("Main")
        if target then
            -- Xóa ảnh cũ nếu có
            if target:FindFirstChild("CelestialBackground") then
                target.CelestialBackground:Destroy()
            end

            local Bg = Instance.new("ImageLabel")
            Bg.Name = "CelestialBackground"
            Bg.Parent = target
            Bg.Size = UDim2.new(1, 0, 1, 0)
            -- Đẩy ZIndex lên 0 hoặc 1 để nó nằm trên lớp nền đen nhưng dưới chữ
            Bg.ZIndex = 0 
            Bg.Image = "rbxassetid://338833954" 
            Bg.ImageTransparency = 0.4 -- Chỉnh số này thấp xuống (0.2 hoặc 0.3) nếu muốn ảnh hiện rõ hơn
            Bg.BackgroundTransparency = 1
            Bg.ScaleType = Enum.ScaleType.Crop
            
            -- Cưỡng ép các Frame nền của Fluent phải trong suốt để lộ ảnh
            for _, v in pairs(target:GetDescendants()) do
                if v:IsA("Frame") and v.BackgroundTransparency < 1 then
                    -- Nếu là frame nền đen thì cho nó trong suốt hẳn
                    if v.BackgroundColor3 == Color3.fromRGB(27, 27, 27) or v.Name == "Content" then
                        v.BackgroundTransparency = 1
                    end
                end
            end

            -- Hiệu ứng Gradient lấp lánh
            local Gradient = Instance.new("UIGradient", Bg)
            Gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 120, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 255))
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
