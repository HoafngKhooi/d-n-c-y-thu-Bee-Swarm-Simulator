-- [[ CELESTIAL UI FRAMEWORK - VERSION 1.0 ]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. Khởi tạo cửa sổ chính
local Window = Rayfield:CreateWindow({
   Name = "✨ CELESTIAL VEIL HUB ✨",
   LoadingTitle = "Đang khởi tạo không gian...",
   LoadingSubtitle = "by YourName",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "CelestialConfig",
      FileName = "UILayout"
   },
   Discord = { Enabled = false },
   KeySystem = false 
})

-- 2. Hàm tạo hiệu ứng hình nền bám theo Menu
-- (Được thiết kế để tự động nhận diện khung của Rayfield)
local function ApplyCelestialEffect()
    -- Đợi một chút để Rayfield tạo xong các Frame nội bộ
    task.wait(1) 
    
    -- Tìm kiếm UI của Rayfield trong CoreGui
    local CoreGui = game:GetService("CoreGui")
    local RayfieldGui = CoreGui:FindFirstChild("Rayfield") or CoreGui:FindFirstChild("RayfieldUI")

    if RayfieldGui then
        local MainFrame = RayfieldGui:FindFirstChild("Main")
        if MainFrame then
            -- Kiểm tra xem đã có nền chưa để tránh tạo trùng
            if MainFrame:FindFirstChild("CelestialBg") then return end

            local BgImage = Instance.new("ImageLabel")
            BgImage.Name = "CelestialBg"
            BgImage.Parent = MainFrame
            BgImage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            BgImage.BackgroundTransparency = 1
            BgImage.BorderSizePixel = 0
            -- Căn chỉnh phủ kín toàn bộ menu
            BgImage.Position = UDim2.new(0, 0, 0, 0)
            BgImage.Size = UDim2.new(1, 0, 1, 0)
            BgImage.Image = "rbxassetid://74060450766496"
            BgImage.ImageTransparency = 0.5 -- Giữ mức này để vẫn nhìn xuyên qua thấy nội dung
            BgImage.ScaleType = Enum.ScaleType.Crop
            -- Chỉnh lại chỗ này trong code của bạn:
            BgImage.ZIndex = 1 -- Thay vì 0, để nó nổi lên trên lớp nền mặc định của Rayfield
            -- Hiệu ứng lấp lánh (Gradient)
            local Gradient = Instance.new("UIGradient", BgImage)
            Gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 120, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 255))
            })

            task.spawn(function()
                local TweenService = game:GetService("TweenService")
                while true do
                    Gradient.Offset = Vector2.new(-1, 0)
                    local tween = TweenService:Create(Gradient, TweenInfo.new(5, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)})
                    tween:Play()
                    tween.Completed:Wait()
                end
            end)
        end
    else
        -- Nếu không tìm thấy, thử lại sau 2 giây (Dành cho máy lag)
        task.delay(2, ApplyCelestialEffect)
    end
end

-- Chạy hiệu ứng sau khi Rayfield dựng xong khung
task.delay(0.5, ApplyCelestialEffect)

-- 3. Cấu trúc Tab mẫu
local HomeTab = Window:CreateTab("Trang Chủ", 4483362458)
local FarmTab = Window:CreateTab("Tự Động", 4483362458)
local MiscTab = Window:CreateTab("Tiện Ích", 4483362458)

-- 4. Thêm các nút bấm test giao diện
HomeTab:CreateSection("Thông tin")
HomeTab:CreateLabel("Chào mừng bạn đến với giao diện Celestial")

FarmTab:CreateSection("Cấu hình Farm")
FarmTab:CreateToggle({
   Name = "Bật Auto Dig",
   CurrentValue = false,
   Callback = function(Value)
       print("Auto Dig: ", Value)
   end,
})

MiscTab:CreateSection("Người chơi")
MiscTab:CreateSlider({
   Name = "Tốc độ chạy",
   Range = {16, 500},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- Thông báo hoàn tất
Rayfield:Notify({
   Title = "Celestial Ready!",
   Content = "Giao diện đã tải xong, chúc bạn trải nghiệm vui vẻ.",
   Duration = 5,
   Image = 4483362458,
})
