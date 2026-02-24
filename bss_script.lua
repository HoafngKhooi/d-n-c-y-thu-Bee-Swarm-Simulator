-- [[ CẤU HÌNH WEBHOOK ]]
local webhook_url = "https://discord.com/api/webhooks/1470018869497171989/ojxHmFvOGsQmuz_T36i566RHNXGzbnerb77cdO5AeDCXI2NDxl1sIppfFutbZKXsQdeb"
local update_interval = 30 

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

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
        ["content"] = "BSS_DATA_BRIDGE", -- Từ khóa quan trọng để Bot nhận diện
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

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "BSS Bridge";
    Text = "Đang chạy chế độ Webhook!";
    Duration = 5;
})

task.spawn(function()
    while true do
        sendToWebhook()
        task.wait(update_interval)
    end
end)
