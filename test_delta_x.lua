local webhook_url = "DÁN_LINK_WEBHOOK_CỦA_ÔNG_VÀO_ĐÂY"
local HttpService = game:GetService("HttpService")

-- Thông báo bắt đầu test
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Hệ Thống Test";
    Text = "Đang thử gửi tới Discord...";
    Duration = 5;
})

-- Kiểm tra xem Executor có hỗ trợ Request không
local request = syn and syn.request or http_request or request or httprequest

if request then
    local success, result = pcall(function()
        return request({
            Url = webhook_url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                ["content"] = "🚀 TEST THÀNH CÔNG! Delta của ông đã thông mạng."
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
