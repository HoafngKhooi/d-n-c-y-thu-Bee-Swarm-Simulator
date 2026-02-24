-- [[ CELESTIAL UI FRAMEWORK - UPDATED WITH STABLE ASSET ]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. Khởi tạo cửa sổ chính
local Window = Rayfield:CreateWindow({
   Name = "✨ CELESTIAL VEIL HUB ✨",
   LoadingTitle = "Đang kết nối không gian...",
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
local function ApplyCelestialEffect()
    task.wait(2) -- Đợi lâu hơn xíu cho Delta load xong hẳn
    
    local CoreGui = game:GetService("CoreGui")
    local RayfieldGui = CoreGui:FindFirstChild("Rayfield") or CoreGui:FindFirstChild("RayfieldUI")

    if RayfieldGui then
        local MainFrame = RayfieldGui:FindFirstChild("Main")
        if MainFrame then
            -- Xóa cái cũ nếu có để tránh chồng chéo
            if MainFrame:FindFirstChild("CelestialBg") then 
                MainFrame:FindFirstChild("CelestialBg"):Destroy() 
            end

            local BgImage = Instance.new("ImageLabel")
            BgImage.Name = "CelestialBg"
            BgImage.Parent = MainFrame
            BgImage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            BgImage.BackgroundTransparency = 1
            BgImage.BorderSizePixel = 0
            BgImage.Position = UDim2.new(0, 0, 0, 0)
            BgImage.Size = UDim2.new(1, 0, 1, 0)
            
            -- Thử dùng ID ảnh mẫu cực kỳ ổn định này trước để test
            BgImage.Image = "rbxassetid://15654030614" 
            
            -- CHỈNH LẠI CÁC THÔNG SỐ NÀY ĐỂ HIỆN RÕ
            BgImage.ImageTransparency = 0.4 
            BgImage.ZIndex = 0 -- Thử để 0 nhưng chỉnh Parent của khung nền đen
            
            -- Mẹo: Tìm cái khung nền đen của Rayfield và làm nó trong suốt
            for _, v in pairs(MainFrame:GetChildren()) do
                if v:IsA("Frame") and v.BackgroundColor3 == Color3.fromRGB(0, 0, 0) then
                    v.BackgroundTransparency = 1 -- Làm nền đen của Rayfield biến mất
                end
            end

            BgImage.ScaleType = Enum.ScaleType.Crop

            -- Hiệu ứng lướt sáng
            local Gradient = Instance.new("UIGradient", BgImage)
            Gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 255))
            })

            task.spawn(function()
                local TweenService = game:GetService("TweenService")
                while true do
                    Gradient.Offset = Vector2.new(-1, 0)
                    local tween = TweenService:Create(Gradient, TweenInfo.new(6, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)})
                    tween:Play()
                    tween.Completed:Wait()
                end
            end)
        end
    end
end

-- Chạy hiệu ứng ngay khi load
task.spawn(ApplyCelestialEffect)

-- 3. Cấu trúc Tab
local HomeTab = Window:CreateTab("Trang Chủ", 4483362458)
local FarmTab = Window:CreateTab("Tự Động", 4483362458)
local MiscTab = Window:CreateTab("Tiện Ích", 4483362458)

-- 4. Các nút chức năng mẫu
HomeTab:CreateSection("Thông tin")
HomeTab:CreateLabel("Script đang sử dụng Wallpaper ID: 338833954")

FarmTab:CreateSection("Cấu hình Farm")
FarmTab:CreateToggle({
   Name = "Auto Farm Mode",
   CurrentValue = false,
   Callback = function(Value)
       print("Farm Status: ", Value)
   end,
})

MiscTab:CreateSection("Người chơi")
MiscTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

Rayfield:Notify({
   Title = "Celestial Hub Loaded!",
   Content = "Đã áp dụng hình nền thành công.",
   Duration = 5,
   Image = 4483362458,
})
