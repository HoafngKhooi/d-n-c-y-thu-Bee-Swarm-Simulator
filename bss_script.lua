-- [[ CẤU HÌNH CHÍNH THỨC ]]
local webhook_url = "https://webhook.lewisakura.moe/api/webhooks/1470318869497171989/ojxHWFvDGsQwuz_T361566RHNK9ZbnrB77O6N233E_U599E0S4892YF871Y7"
local update_interval = 30 

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Chờ cho đến khi bảng leaderstats xuất hiện để tránh lỗi "not a valid member"
repeat task.wait(1) until player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Honey")

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

-- Thông báo cho ông biết là đã load xong và bắt đầu chạy
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "BSS System";
    Text = "Đã load xong dữ liệu Honey!";
    Duration = 5;
})

task.spawn(function()
    sendToWebhook() -- Gửi ngay lập tức khi load xong
    while true do
        task.wait(update_interval)
        sendToWebhook()
    end
end)
