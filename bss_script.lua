-- [[ CẤU HÌNH KẾT NỐI ]]
-- Thử cả IP Wifi và IP nội bộ máy để tăng tỉ lệ thành công
local ip_list = {
    "http://127.0.0.1:5000/update",
    "http://192.168.1.3:5000/update" -- Nhớ đổi số này theo số mới nhất hiện trên Termux
}
local update_interval = 25 

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Hàm thông báo
local function notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title; Text = text; Duration = 5;
    })
end

-- Hàm lấy dữ liệu (Giữ nguyên logic của ông vì đã chuẩn)
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

-- Hàm gửi dữ liệu có Log lỗi
local function sendToBot()
    local data = {
        ["player_name"] = player.Name,
        ["honey"] = tostring(player.leaderstats.Honey.Value),
        ["inventory"] = getInv(),
        ["quests"] = getQuests(),
        ["time"] = os.date("%X")
    }

    local payload = HttpService:JSONEncode(data)
    local request = syn and syn.request or http_request or request or httprequest
    
    if request then
        for _, url in pairs(ip_list) do
            local success, result = pcall(function()
                return request({
                    Url = url,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = payload,
                    Timeout = 5 -- Không bắt đợi quá lâu nếu sai IP
                })
            end)

            if success and result.StatusCode == 200 then
                print("✅ [BSS-Bot] Gửi thành công tới: " .. url)
                return -- Dừng lại nếu đã gửi thành công 1 cái
            else
                print("⚠️ [BSS-Bot] Thử kết nối " .. url .. " thất bại.")
            end
        end
    end
end

-- Khởi động
notify("BSS System", "Bot đang cố gắng kết nối với Termux...")
print("🚀 Script đã Execute! Nhấn F9 để xem quá trình kết nối.")

task.spawn(function()
    while true do
        sendToBot()
        task.wait(update_interval)
    end
end)
