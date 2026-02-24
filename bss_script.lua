-- [[ CONFIG ]]
local webhook_url = _G.Webhook_URL or "https://discord.com/api/webhooks/1470018869497171989/ojxHmFvOGsQmuz_T36i566RHNXGzbnerb77cdO5AeDCXI2NDxl1sIppfFutbZKXsQdeb"
local update_interval = 300 -- 5 phút

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local msg_id = nil -- Biến lưu trữ ID tin nhắn để Edit

-- [[ HÀM LẤY DỮ LIỆU ]]
local function getInv(n)
    local c = 0
    pcall(function() 
        if player.ItemInventory:FindFirstChild(n) then c = player.ItemInventory[n].Value end 
    end)
    return c
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

-- [[ HÀM GỬI/SỬA WEBHOOK ]]
local function sendUpdate()
    local payload = HttpService:JSONEncode({
        ["embeds"] = {{
            ["title"] = "📊 TIẾN TRÌNH: " .. player.Name,
            ["color"] = 16776960,
            ["fields"] = {
                {["name"] = "🍯 Honey", ["value"] = "```" .. tostring(player.leaderstats.Honey.Value) .. "```", ["inline"] = true},
                {["name"] = "🌱 Planters", ["value"] = getPlanters(), ["inline"] = false},
                {["name"] = "📦 Materials", ["value"] = "Blue: "..getInv("BlueExtract").." | Red: "..getInv("RedExtract").."\nSwirl: "..getInv("SwirlWax").." | Tropical: "..getInv("TropicalDrink"), ["inline"] = false}
            },
            ["footer"] = {["text"] = "Cập nhật lúc: " .. os.date("%X") .. " (5p/lần)"}
        }}
    })

    local request = syn and syn.request or http_request or request or httprequest
    
    -- Logic: Nếu chưa có msg_id thì POST (tạo mới), nếu có rồi thì PATCH (sửa)
    local url = (msg_id == nil) and (webhook_url .. "?wait=true") or (webhook_url .. "/messages/" .. msg_id)
    local method = (msg_id == nil) and "POST" or "PATCH"

    local res = request({
        Url = url,
        Method = method,
        Headers = {["Content-Type"] = "application/json"},
        Body = payload
    })

    -- Lưu lại ID tin nhắn từ phản hồi của Discord (chỉ chạy khi POST)
    if msg_id == nil and res.Success then
        local resData = HttpService:JSONDecode(res.Body)
        msg_id = resData.id
    end
end

-- [[ VÒNG LẶP ]]
task.spawn(function()
    while true do
        pcall(sendUpdate)
        task.wait(update_interval)
    end
end)
