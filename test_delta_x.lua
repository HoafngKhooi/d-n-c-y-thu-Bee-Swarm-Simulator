local HttpService = game:GetService("HttpService")
local webhook_url = "DÁN_LINK_WEBHOOK_CỦA_ÔNG_VÀO_ĐÂY"

local request = syn and syn.request or http_request or request or httprequest

if request then
    request({
        Url = webhook_url,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = game:GetService("HttpService"):JSONEncode({["content"] = "TEST KẾT NỐI SIÊU TỐC!"})
    })
    print("🚀 Đã bấm nút gửi, hãy check Discord!")
else
    warn("❌ Executor của ông không hỗ trợ gửi Request!")
end
