local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. Khởi tạo Window (Ẩn các thành phần mặc định của Rayfield)
local Window = Rayfield:CreateWindow({
   Name = "✨ CELESTIAL HUB ✨",
   LoadingTitle = "CELESTIAL SYSTEM",
   LoadingSubtitle = "by Celestial Team",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "CelestialConfig", 
      FileName = "Data"
   },
   Discord = {
      Enabled = false -- Tắt phần quảng cáo Discord của Rayfield
   },
   KeySystem = false 
})

-- 2. Hàm ẩn Logo và làm sạch giao diện
local function CleanRayfield()
    local CoreGui = game:GetService("CoreGui")
    -- Đợi UI xuất hiện
    local RayfieldGui = CoreGui:WaitForChild("Rayfield", 5) or CoreGui:WaitForChild("RayfieldUI", 5)
    
    if RayfieldGui then
        local Main = RayfieldGui:FindFirstChild("Main")
        if Main then
            -- Duyệt tìm các ImageLabel chứa Logo của Rayfield
            for _, v in pairs(Main:GetDescendants()) do
                if v:IsA("ImageLabel") then
                    -- Ẩn các hình ảnh không phải là icon của Tab
                    if not v.Parent:IsA("TextButton") and v.Name ~= "Icon" then
                        v.Visible = false
                    end
                end
                
                -- Đổi tên thương hiệu Sirius/Rayfield nếu nó xuất hiện trong văn bản
                if v:IsA("TextLabel") and (v.Text:find("Rayfield") or v.Text:find("Sirius")) then
                    v.Text = "CELESTIAL"
                end
            end
        end
    end
end

-- Thực hiện dọn dẹp ngay sau khi khởi tạo
task.spawn(CleanRayfield)

-- 3. Cấu trúc Tab
local HomeTab = Window:CreateTab("Trang Chủ", "home") -- Sử dụng tên icon thay vì ID để chuyên nghiệp hơn
local FarmTab = Window:CreateTab("Tự Động", "play")
local MiscTab = Window:CreateTab("Tiện Ích", "settings")

-- Tab Trang Chủ
HomeTab:CreateSection("Thông tin bản quyền")
HomeTab:CreateLabel("Giao diện thuộc về Celestial Hub - Version 1.0")

HomeTab:CreateButton({
   Name = "Gửi Báo Cáo Webhook",
   Callback = function()
       -- Tích hợp code Webhook của bạn ở đây
       Rayfield:Notify({
          Title = "Hệ thống",
          Content = "Đã gửi dữ liệu tới máy chủ báo cáo.",
          Duration = 3,
          Image = 0
       })
   end,
})

-- Tab Tiện Ích
MiscTab:CreateSection("Người chơi")
MiscTab:CreateSlider({
   Name = "Tốc độ chạy",
   Range = {16, 500},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- Thông báo hoàn tất
Rayfield:Notify({
   Title = "Celestial Hub Loaded!",
   Content = "Chúc bạn trải nghiệm vui vẻ.",
   Duration = 5,
   Image = 0, -- Ẩn icon mặc định để sạch sẽ hơn
})
