local termux_url = "http://127.0.0.1:5000/update" 
local update_interval = 30 

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Hàm thông báo
local function notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 5;
    })
end

-- Hàm quét nhiệm vụ (Quests)
local function getQuests()
    local questList = {}
    pcall(function()
        local quests = player.PlayerGui.Main.Quests.Content.ScrollingFrame
        for _, v in pairs(quests:GetChildren()) do
            if v:IsA("Frame") and v:FindFirstChild("Title") then
                local qName = v.Title.Text
                local qProg = v.Description.Text:gsub("\n", " ")
                table.insert(questList, "📜 **" .. qName .. "**: " .. qProg)
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

local function sendToBot()
    local data = {
        ["player_name"] = player.Name,
        ["honey"] = tostring(player.leaderstats.Honey.Value),
        ["inventory"] = getInv(),
        ["quests"] = getQuests(), -- Quét quest thật
        ["time"] = os.date("%X")
    }

    local payload = HttpService:JSONEncode(data)
    local request = syn and syn.request or http_request or request or httprequest
    
    if request then
        pcall(function()
            request({
                Url = termux_url,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = payload
            })
        end)
    end
end

notify("BSS System", "Kết nối Termux thành công!")
task.spawn(function()
    while true do
        sendToBot()
        task.wait(update_interval)
    end
end)
