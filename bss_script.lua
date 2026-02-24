-- [[ CẤU HÌNH CHÍNH THỨC ]]
local webhook_url = "https://webhook.lewisakura.moe/api/webhooks/1470018869497171989/ojxHmFvOGsQmuz_T36i566RHNXGzbnerb77cdO5AeDCXI2NDxl1sIppfFutbZKXsQdeb"
local update_interval = 30 

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Hàm thông báo
local function notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title; Text = text; Duration = 5;
    })
end

-- Hàm lấy nhiệm vụ
local function getQuests()
    local questList = {}
    pcall(function()
        local quests = player.PlayerGui.Main.Quests.Content.ScrollingFrame
        for _, v in pairs(quests:GetChildren()) do
            if v:IsA("Frame") and v:FindFirstChild("Title") then
                table.insert(questList, "📜 **" .. v.Title.Text .. "**: " .. v.Description.Text:gsub("\n", " "))
            end
        end
    end)
    return #questList > 0 and table.concat(questList, "\n") or "Không có nhiệm vụ"
end

-- Hàm lấy kho đồ
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

-- Hàm gửi dữ liệu
local function sendToWebhook()
    local request = syn and syn.request or http_request or request or httprequest
    if request then
        local data = {
            ["content"] = "BSS_DATA_BRIDGE",
            ["embeds"] = {{
                ["title"] = "🐝 BSS STATUS: " .. player.Name,
                ["color"] = 16776960,
                ["fields"] = {
                    {["name"] = "🍯 Honey", ["value"] = "```" .. tostring(player.leaderstats.Honey.Value) .. "```", ["inline"] = false},
                    {["name"] = "📦 Inventory", ["value"] = getInv(), ["inline"] = true},
                    {["name"] = "📜 Quests", ["value"] = getQuests(), ["inline"] = false}
                },
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

-- [[ KHỞI CHẠY ]]
notify("BSS System", "Hệ thống chính thức đã bắt đầu!")

task.spawn(function()
    task.wait(2) -- Gửi ngay sau 2 giây khi bật
    sendToWebhook()
    
    while true do
        task.wait(update_interval)
        sendToWebhook()
    end
end)
