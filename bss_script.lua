local termux_url = "http://127.0.0.1:5000/update" 
local update_interval = 30 

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Hàm hiển thị thông báo trong game
local function notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 5;
    })
end

local function getInv()
    local items = {"BlueExtract", "RedExtract", "SwirlWax", "TropicalDrink"}
    local str = ""
    for _, name in pairs(items) do
        local count = 0
        pcall(function() count = player.ItemInventory[name].Value end)
        str = str .. "🔹 " .. name .. ": " .. count .. "\n"
    end
    return str
end

local function getPlanters()
    local l = {}
    pcall(function()
        for _, v in pairs(game.Workspace.Planters:GetChildren()) do
            if v:FindFirstChild("Owner") and v.Owner.Value == player.Name then
                local g = v:FindFirstChild("Growth") and v.Growth.Value or 0
                table.insert(l, "🌱 " .. v.Name .. ": " .. math.floor(g) .. "%")
            end
        end
    end)
    return #l > 0 and table.concat(l, "\n") or "Trống"
end

local function sendToBot()
    local data = {
        ["player_name"] = player.Name,
        ["honey"] = tostring(player.leaderstats.Honey.Value),
        ["planters"] = getPlanters(),
        ["inventory"] = getInv(),
        ["quests"] = "Đang quét...",
        ["time"] = os.date("%X")
    }
    local payload = HttpService:JSONEncode(data)
    local request = syn and syn.request or http_request or request or httprequest
    
    if request then
        local success, result = pcall(function()
            return request({
                Url = termux_url, 
                Method = "POST", 
                Headers = {["Content-Type"] = "application/json"}, 
                Body = payload
            })
        end)
        
        -- Nếu gửi tới Termux thành công thì báo trong game
        if success then
            print("Sent to Termux!")
        else
            notify("Lỗi Kết Nối", "Không tìm thấy Termux (Port 5000)")
        end
    end
end

-- Thông báo ngay khi nhấn Execute
notify("BSS System", "Đang khởi chạy kết nối Termux...")

task.spawn(function()
    while true do
        sendToBot()
        task.wait(update_interval)
    end
end)
