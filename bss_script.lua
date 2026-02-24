-- [[ CẤU HÌNH CHÍNH THỨC ]]
-- Tui đã chuyển link của ông sang dạng Proxy để Delta không bị chặn
local webhook_url = "https://webhook.lewisakura.moe/api/webhooks/1470018869497171989/ojxHmFvOGsQmuz_T36i566RHNXGzbnerb77cdO5AeDCXI2NDxl1sIppfFutbZKXsQdeb"
local update_interval = 30 

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local function notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title; Text = text; Duration = 5;
    })
end

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
    -- Hệ thống tự nhận diện hàm request của Delta
    local request = syn and syn.request or http_request or request or httprequest
    
    if request then
        local data = {
            ["content"] = "BSS_DATA_BRIDGE",
            ["embeds"] = {{
                ["title"] = "🐝 BSS STATUS: " .. player.Name,
                ["color"] = 16776960,
                ["fields"] = {
                    {["name"] = "🍯 Honey", ["value"] = "```" .. tostring(player.leaderstats.Honey.Value) .. "```", ["inline"] = false},
                    {["name"] = "📦 Kho đồ", ["value"] = getInv(), ["inline"] = true},
                    {["name"] = "📜 Nhiệm vụ", ["value"] = getQuests(), ["inline"] = false}
                },
                ["footer"] = {["text"] = "Cập nhật lúc: " .. os.date("%X")}
            }}
        }
        
        local success, result = pcall(function()
            return request({
                Url = webhook_url,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(data)
            })
        end)
        
        if success then
            print("✅ Đã gửi dữ liệu thành công!")
        else
            warn("❌ Lỗi gửi dữ liệu: " .. tostring(result))
        end
    end
end

-- [[ VẬN HÀNH ]]
notify("BSS System", "Khởi động hệ thống chính thức...")

task.spawn(function()
    task.wait(2) -- Gửi ngay lập tức sau 2 giây
    sendToWebhook()
    
    while true do
        task.wait(update_interval)
        sendToWebhook()
    end
end)
