-- [[ CẤU HÌNH WEBHOOK ]]
local webhook_url = "https://discord.com/api/webhooks/1470018869497171989/ojxHmFvOGsQmuz_T36i566RHNXGzbnerb77cdO5AeDCXI2NDxl1sIppfFutbZKXsQdeb"
local update_interval = 30 

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Định nghĩa lại hàm notify để không bị lỗi
local function notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 5;
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
    local data = {
        ["content"] = "BSS_DATA_BRIDGE", 
        ["embeds"] = {{
            ["title"] = player.Name,
            ["fields"] = {
                {["name"] = "Honey", ["value"] = tostring(player.leaderstats.Honey.Value)},
                {["name"] = "Inventory", ["value"] = getInv()},
                {["name"] = "Quests", ["value"] = getQuests()}
            }
        }}
    }

    local payload = HttpService:JSONEncode(data)
    local request = syn and syn.request or http_request or request or httprequest
    
    if request then
        pcall(function()
            request({
                Url = webhook_url,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = payload
            })
        end)
    end
end

-- [[ VẬN HÀNH ]]
notify("BSS Bridge", "Đang khởi tạo kết nối Webhook...")

task.spawn(function()
    task.wait(2) -- Sau 2 giây là nổ tin nhắn liền
    sendToWebhook()
    print("✅ Đã gửi bản tin đầu tiên tới Discord!")

    while true do
        task.wait(update_interval)
        sendToWebhook()
        print("🔄 Đã cập nhật dữ liệu mới.")
    end
end)
