-- [[ CẤU HÌNH CHUẨN - ĐÃ FIX LỖI LOAD ]]
-- Dùng lại link Spidey Bot đã thông mạng ở Ảnh 1
local webhook_url = "https://webhook.lewisakura.moe/api/webhooks/1470318869497171989/ojxHWFvDGsQwuz_T361566RHNK9ZbnrB77O6N233E_U599E0S4892YF871Y7"
local update_interval = 30 

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- FIX LỖI: Đợi game load xong bảng điểm mới chạy tiếp
repeat 
    task.wait(1) 
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
                    {["name"] = "🍯 Honey", ["value"] = "```" .. tostring(player.leaderstats.Honey.Value) .. "```"},
                    {["name"] = "📦 Inventory", ["value"] = getInv()}
                },
                ["color"] = 16776960,
                ["footer"] = {["text"] = "Cập nhật: " .. os.date("%X")}
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

-- Thông báo khi đã sẵn sàng
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "BSS System";
    Text = "Dữ liệu Honey đã load xong!";
    Duration = 5;
})

task.spawn(function()
    sendToWebhook() -- Gửi phát đầu tiên ngay khi load xong
    while true do
        task.wait(update_interval)
        sendToWebhook()
    end
end)
