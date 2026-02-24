local webhook_url = "https://webhook.lewisakura.moe/api/webhooks/1470318869497171989/ojxHWFvDGsQwuz_T361566RHNK9ZbnrB77O6N233E_U599E0S4892YF871Y7"
local HttpService = game:GetService("HttpService")

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Hệ Thống Test";
    Text = "Đang thử lại với ID chuẩn...";
    Duration = 5;
})

local request = syn and syn.request or http_request or request or httprequest

if request then
    local success, result = pcall(function()
        return request({
            Url = webhook_url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                ["content"] = "🚀 ĐÃ FIX ID! Delta lại thông mạng rồi nhé."
            })
        })
    end)

    if success then
        print("✅ Đã gửi request! Hãy check Discord.")
    else
        warn("❌ Lỗi gửi request: " .. tostring(result))
    end
else
    warn("❌ Executor Delta này không hỗ trợ hàm HTTP Request!")
end
