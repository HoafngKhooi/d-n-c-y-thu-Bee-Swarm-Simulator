-- [[ CONFIG ]]
-- Link này trỏ về Server Flask đang chạy trên Termux của ông
local termux_url = "http://127.0.0.1:5000/update" 
local update_interval = 30 -- Cập nhật mỗi 30s cho nhanh

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- [[ HÀM LẤY DỮ LIỆU ]]
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

-- [[ HÀM GỬI VỀ BOT TERMUX ]]
local function sendToBot()
    local data = {
        ["player_name"] = player.Name,
        ["honey"] = tostring(player.leaderstats.Honey.Value),
        ["planters"] = getPlanters(),
        ["inventory"] = getInv(), -- Gửi kho đồ để Bot hiện khi bấm nút
        ["quests"] = "Đang cày...", -- Sau này ông thêm hàm quét quest ở đây
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

-- [[ VÒNG LẶP ]]
task.spawn(function()
    print("🚀 BSS to Termux System Started!")
    while true do
        sendToBot()
        task.wait(update_interval)
    end
end)
