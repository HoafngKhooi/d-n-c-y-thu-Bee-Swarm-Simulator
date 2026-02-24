local webhook_url = "https://webhook.lewisakura.moe/api/webhooks/1470318869497171989/ojxHWFvDGsQwuz_T361566RHNK9ZbnrB77O6N233E_U599E0S4892YF871Y7"
local request = syn and syn.request or http_request or request or httprequest

if request then
    request({
        Url = webhook_url,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = game:GetService("HttpService"):JSONEncode({["content"] = "✅ XÁC NHẬN: Link này mới là link chuẩn!"})
    })
end
