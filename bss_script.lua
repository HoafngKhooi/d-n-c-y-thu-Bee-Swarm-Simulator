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
    task.wait(2) 
    
    local CoreGui = game:GetService("CoreGui")
    local RayfieldGui = CoreGui:FindFirstChild("Rayfield") or CoreGui:FindFirstChild("RayfieldUI")

    if RayfieldGui then
        -- Tìm đến khung chứa nội dung thực sự của Rayfield
        local MainFrame = RayfieldGui:FindFirstChild("Main")
        if MainFrame then
            -- Tạo ảnh nền mới
            local BgImage = Instance.new("ImageLabel")
            BgImage.Name = "CelestialBg"
            BgImage.Parent = MainFrame
            BgImage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            BgImage.BackgroundTransparency = 1
            BgImage.BorderSizePixel = 0
            BgImage.Position = UDim2.new(0, 0, 0, 0)
            BgImage.Size = UDim2.new(1, 0, 1, 0)
            
            -- Dùng ID ảnh thiên hà xanh tím cực mạnh
            BgImage.Image = "rbxassetid://15654030614" 
            
            -- QUAN TRỌNG: Đẩy ZIndex lên cao hẳn (ví dụ 0 hoặc -1) 
            -- Và ép tất cả các Frame khác của Rayfield phải trong suốt
            BgImage.ZIndex = 0
            BgImage.ImageTransparency = 0.4 
            BgImage.ScaleType = Enum.ScaleType.Crop

            -- Vòng lặp cưỡng ép tất cả các lớp nền của Rayfield biến mất
            for _, v in pairs(MainFrame:GetDescendants()) do
                if v:IsA("Frame") or v:IsA("ScrollingFrame") or v:IsA("CanvasGroup") then
                    -- Nếu là nền đen thì làm trong suốt để lộ ảnh ra
                    if v.BackgroundColor3 == Color3.fromRGB(0, 0, 0) or v.Name == "Main" or v.Name == "Container" then
                        v.BackgroundTransparency = 1
                    end
                end
            end

            -- Hiệu ứng lướt sáng cho sinh động
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
