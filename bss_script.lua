-- [[ CẤU HÌNH CHÍNH THỨC - ĐÃ THÊM ĐỘ TRỄ CHỐNG LỖI ]]
-- Dùng link Spidey Bot đã thông mạng ở ảnh test của ông
local webhook_url = "https://webhook.lewisakura.moe/api/webhooks/1470318869497171989/ojxHWFvDGsQwuz_T361566RHNK9ZbnrB77O6N233E_U599E0S4892YF871Y7"
local update_interval = 30 

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- CHẬM LẠI: Đợi game tải xong xuôi (Tránh lỗi leaderstats ở Ảnh 4, 5, 7)
repeat 
    task.wait(2) -- Kiểm tra mỗi 2 giây
until player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Honey")

local function getInv()
    local items = {"BlueExtract", "RedExtract", "SwirlWax", "TropicalDrink", "Neonberry"}
    local str = ""
    for _, name in pairs(items) do
        local count = 0
        pcall(function() count = player.ItemInventory[name].Value end)
        str = str .. "🔹 " .. name .. ": " .. count .. "\n"
    end
    return str
end

local function sendToWebhook()
    local request = syn and syn.request or http_request or request or httprequest
    if request then
        local data = {
            ["content"] = "BSS_DATA_BRIDGE",
            ["embeds"] = {{
                ["title"] = "🐝 BSS STATUS: " .. player.Name,
                ["fields"] = {
                    {["name"] = "🍯 Honey", ["value"] = "```" .. tostring(player.leaderstats.Honey.Value) .. "```", ["inline"] = false},
                    {["name"] = "📦 Inventory", ["value"] = getInv(), ["inline"] = true}
                },
                ["color"] = 16776960,
                ["footer"] = {["text"] = "Cập nhật lúc: " .. os.date("%X")}
            }}
        }
        
        pcall(function()
            request({
                Url = webhook_url,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(data)
            })
        end)
    end
end

-- Thông báo khi hệ thống đã "ngấm" dữ liệu
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "BSS Bridge";
    Text = "Hệ thống đã nhận diện được mật ong! Đang gửi dữ liệu...";
    Duration = 5;
})

task.spawn(function()
    sendToWebhook() -- Gửi lần đầu ngay khi load xong
    while true do
        task.wait(update_interval)
        sendToWebhook()
    end
end)


-- Khởi tạo thư viện UI (Dùng Rayfield cho mượt và đẹp)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Tạo cửa sổ chính
local Window = Rayfield:CreateWindow({
   Name = "✨ CELESTIAL HUB ✨",
   LoadingTitle = "Đang tải giao diện huyền ảo...",
   LoadingSubtitle = "by YourName",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "CelestialConfig",
      FileName = "MainHub"
   },
   Discord = { Enabled = false },
   KeySystem = false 
})

-- HIỆU ỨNG HÌNH NỀN (Dùng ID ảnh của bạn)
local function CreateBackground()
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    local BgImage = Instance.new("ImageLabel", ScreenGui)
    
    BgImage.Name = "CelestialBackground"
    BgImage.Size = UDim2.new(0, 500, 0, 300) -- Khớp với kích thước menu Rayfield
    BgImage.Position = UDim2.new(0.5, -250, 0.5, -150)
    BgImage.Image = "rbxassetid://74060450766496" -- ID ảnh bạn cung cấp
    BgImage.BackgroundTransparency = 1
    BgImage.ImageTransparency = 0.4 -- Làm mờ nhẹ để thấy chữ
    BgImage.ZIndex = -1 -- Đẩy ra sau cùng
    
    -- Hiệu ứng Gradient trôi (Làm ảnh động giả)
    local Gradient = Instance.new("UIGradient", BgImage)
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 255)), -- Xanh Celestial
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)), -- Ánh sáng trắng
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 255))
    })

    task.spawn(function()
        local TweenService = game:GetService("TweenService")
        while true do
            local tween = TweenService:Create(Gradient, TweenInfo.new(4, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)})
            Gradient.Offset = Vector2.new(-1, 0)
            tween:Play()
            tween.Completed:Wait()
        end
    end)
end

-- Gọi hàm tạo nền
CreateBackground()

-- TẠO CÁC TÍNH NĂNG TRONG MENU
local Tab = Window:CreateTab("Tính Năng", 4483362458)

Tab:CreateButton({
   Name = "Bật Auto Farm",
   Callback = function()
       print("Đã kích hoạt tính năng!")
       -- Dán code logic của bạn vào đây
   end,
})

Tab:CreateSlider({
   Name = "Tốc độ (Speed)",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

Rayfield:Notify({
   Title = "Thành công!",
   Content = "Giao diện Celestial đã sẵn sàng",
   Duration = 5,
   Image = 4483362458,
})
