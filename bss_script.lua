-- [[ CẤU HÌNH CHÍNH THỨC - ĐÃ FIX LINK THEO ẢNH TEST ]]
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
    if request then
        local data = {
            ["content"] = "BSS_DATA_BRIDGE",
            ["embeds"] = {{
                ["title"] = "🐝 BSS STATUS: " .. player.Name,
                ["fields"] = {
                    {["name"] = "🍯 Honey", ["value"] = "```" .. tostring(player.leaderstats.Honey.Value) .. "```"},
                    {["name"] = "📦 Inventory", ["value"] = getInv()}
                },
                ["color"] = 16776960
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

task.spawn(function()
    task.wait(2)
    sendToWebhook()
    while true do
        task.wait(update_interval)
        sendToWebhook()
    end
end)
