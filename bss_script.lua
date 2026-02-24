local termux_url = "http://192.168.1.3:5000/update" -- KIỂM TRA LẠI SỐ NÀY TRONG TERMUX
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

local function sendToBot()
    local success_data, data = pcall(function()
        return {
            ["player_name"] = player.Name,
            ["honey"] = tostring(player.leaderstats.Honey.Value),
            ["inventory"] = getInv(),
            ["quests"] = getQuests(),
            ["time"] = os.date("%X")
        }
    end)

    if not success_data then return end

    local payload = HttpService:JSONEncode(data)
    local request = syn and syn.request or http_request or request or httprequest
    
    if request then
        -- Bọc pcall để tránh văng script nếu sai IP
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

-- Chỉ thông báo khi script bắt đầu chạy
notify("BSS System", "Đang gửi dữ liệu tới Bot...")

task.spawn(function()
    while true do
        sendToBot()
        task.wait(update_interval)
    end
end)
