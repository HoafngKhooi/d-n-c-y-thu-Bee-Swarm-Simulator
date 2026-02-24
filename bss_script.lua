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
    task.wait(1) 
    
    local CoreGui = game:GetService("CoreGui")
    -- Quét kỹ hơn các thư mục UI của Rayfield
    local RayfieldGui = CoreGui:FindFirstChild("Rayfield") or CoreGui:FindFirstChild("RayfieldUI") or CoreGui:FindFirstChild("Rayfield Gui")

    if RayfieldGui then
        local MainFrame = RayfieldGui:FindFirstChild("Main")
        if MainFrame then
            if MainFrame:FindFirstChild("CelestialBg") then return end

            local BgImage = Instance.new("ImageLabel")
            BgImage.Name = "CelestialBg"
            BgImage.Parent = MainFrame
            BgImage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            BgImage.BackgroundTransparency = 1
            BgImage.BorderSizePixel = 0
            BgImage.Position = UDim2.new(0, 0, 0, 0)
            BgImage.Size = UDim2.new(1, 0, 1, 0)
            
            -- CẬP NHẬT ID MỚI TẠI ĐÂY
            BgImage.Image = "rbxassetid://338833954" 
            
            BgImage.ImageTransparency = 0.5 -- Chỉnh lại độ mờ cho vừa mắt
            BgImage.ScaleType = Enum.ScaleType.Crop
            BgImage.ZIndex = 1 -- Đảm bảo nổi trên lớp nền đen mặc định

            -- Hiệu ứng Gradient lướt sáng (Tạo cảm giác ảnh động)
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
    else
        task.delay(2, ApplyCelestialEffect)
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
