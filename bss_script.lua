local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- 1. Tạo Cửa Sổ
local Window = OrionLib:MakeWindow({
    Name = "✨ CELESTIAL HUB ✨", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "CelestialBSS",
    IntroEnabled = true,
    IntroText = "Celestial Veil Edition"
})

-- 2. Hàm chèn ảnh nền (Ép hiển thị trên Orion)
local function ApplyWallpaper()
    task.wait(0.5) -- Đợi UI khởi tạo
    local CoreGui = game:GetService("CoreGui")
    local OrionUI = CoreGui:FindFirstChild("Orion")
    
    if OrionUI then
        local Main = OrionUI:FindFirstChild("Main")
        if Main then
            -- Tạo ImageLabel làm nền
            local Bg = Instance.new("ImageLabel")
            Bg.Name = "CelestialBg"
            Bg.Parent = Main
            Bg.Size = UDim2.new(1, 0, 1, 0)
            Bg.Position = UDim2.new(0, 0, 0, 0)
            Bg.Image = "rbxassetid://338833954" -- ID Wallpaper bạn chọn
            Bg.ImageTransparency = 0.5 -- Độ mờ để không che chữ
            Bg.BackgroundTransparency = 1
            Bg.ScaleType = Enum.ScaleType.Crop
            Bg.ZIndex = 0 -- Nằm dưới các Tab
            
            -- Làm mờ các lớp Frame mặc định của Orion để lộ ảnh bên dưới
            for _, v in pairs(Main:GetChildren()) do
                if v:IsA("Frame") and v.Name ~= "CelestialBg" then
                    v.BackgroundTransparency = 0.8
                end
            end
            
            -- Hiệu ứng dải sáng chạy ngang (Vibe động)
            local Gradient = Instance.new("UIGradient", Bg)
            Gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 255))
            })
            
            task.spawn(function()
                local TS = game:GetService("TweenService")
                while true do
                    Gradient.Offset = Vector2.new(-1, 0)
                    local tween = TS:Create(Gradient, TweenInfo.new(5, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)})
                    tween:Play()
                    tween.Completed:Wait()
                end
            end)
        end
    end
end

-- Chạy hàm dán skin
task.spawn(ApplyWallpaper)

-- 3. Cấu trúc các Tab
local Tab = Window:MakeTab({
	Name = "Trang Chủ",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddLabel("Hệ thống giao diện Celestial đã sẵn sàng")

Tab:AddButton({
	Name = "Test Notification",
	Callback = function()
        OrionLib:MakeNotification({
            Name = "Thông báo",
            Content = "Giao diện Orion đang chạy rất tốt!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
	end    
})

local Tab2 = Window:MakeTab({
	Name = "Tiện Ích",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab2:AddSlider({
	Name = "Tốc độ chạy",
	Min = 16,
	Max = 500,
	Default = 16,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Speed",
	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end    
})

OrionLib:Init()
