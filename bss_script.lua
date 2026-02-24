-- [[ 1. HỆ THỐNG WEBHOOK - CHẠY NGẦM ]]
local webhook_url = "https://webhook.lewisakura.moe/api/webhooks/1470318869497171989/ojxHWFvDGsQwuz_T361566RHNK9ZbnrB77O6N233E_U599E0S4892YF871Y7"
local update_interval = 30 
local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

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
    if request and player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Honey") then
        local data = {
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

-- Chạy ngầm gửi dữ liệu
task.spawn(function()
    while true do
        sendToWebhook()
        task.wait(update_interval)
    end
end)

-- [[ 2. KHỞI TẠO GIAO DIỆN CELESTIAL UI ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "✨ CELESTIAL HUB x BSS ✨",
   LoadingTitle = "Đang khởi tạo hệ thống...",
   LoadingSubtitle = "by YourName",
   ConfigurationSaving = { Enabled = true, FileName = "CelestialBSS" },
   Discord = { Enabled = false },
   KeySystem = false 
})

-- Tạo ảnh nền Celestial Veil bám theo Menu
local function CreateBackground()
    local MainGui = game:GetService("CoreGui"):FindFirstChild("Rayfield")
    if MainGui then
        local MainFrame = MainGui:FindFirstChild("Main")
        if MainFrame then
            local BgImage = Instance.new("ImageLabel")
            BgImage.Name = "CelestialBg"
            BgImage.Parent = MainFrame
            BgImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            BgImage.BackgroundTransparency = 1
            BgImage.Position = UDim2.new(0, 0, 0, 0)
            BgImage.Size = UDim2.new(1, 0, 1, 0) -- Phủ kín menu
            BgImage.Image = "rbxassetid://74060450766496"
            BgImage.ImageTransparency = 0.5
            BgImage.ZIndex = 0 -- Nằm dưới các nút bấm
            
            -- Hiệu ứng Gradient trôi cho ảnh nền
            local Gradient = Instance.new("UIGradient", BgImage)
            Gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 255))
            })

            task.spawn(function()
                local TweenService = game:GetService("TweenService")
                while true do
                    local tween = TweenService:Create(Gradient, TweenInfo.new(5, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)})
                    Gradient.Offset = Vector2.new(-1, 0)
                    tween:Play()
                    tween.Completed:Wait()
                end
            end)
        end
    end
end

-- Chạy hàm tạo nền sau khi UI load xong
task.delay(1, CreateBackground)

-- [[ 3. CÁC TAB CHỨC NĂNG ]]
local MainTab = Window:CreateTab("Tự Động", 4483362458)

MainTab:CreateButton({
   Name = "Gửi Webhook ngay lập tức",
   Callback = function()
       sendToWebhook()
       Rayfield:Notify({Title = "Hệ thống", Content = "Đang gửi dữ liệu tới Discord...", Duration = 3})
   end,
})

MainTab:CreateSlider({
   Name = "Tốc độ chạy",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
       player.Character.Humanoid.WalkSpeed = Value
   end,
})

Rayfield:Notify({
   Title = "Thành công!",
   Content = "Chào mừng tới Celestial Veil BSS!",
   Duration = 5,
})
