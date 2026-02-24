--[[
    Fabled Legacy - Advanced Dungeon Bot (Walk-Only)
    UI Edition by HoafngKhooi
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Fabled Legacy | HoafngKhooi Hub",
    LoadingTitle = "Đang tải Script...",
    LoadingSubtitle = "by HoafngKhooi",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "HoafngKhooi_Fabled",
       FileName = "Config"
    },
    KeySystem = false -- Bạn có thể bật Key System nếu muốn
})

-- Biến Trạng Thái (Global)
_G.AutoFarm = false
_G.AutoSkill = false
_G.AutoDodge = false

local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

-- 1. HÀM TÌM QUÁI
local function getTarget()
    local closestTarget = nil
    local maxDist = 100 -- Tầm quét quái
    for _, v in pairs(workspace:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v ~= Character then
            local dist = (Root.Position - v.PrimaryPart.Position).Magnitude
            if dist < maxDist then
                maxDist = dist
                closestTarget = v
            end
        end
    end
    return closestTarget
end

-- 2. HÀM NÉ CHIÊU
local function checkAndDodge()
    if not _G.AutoDodge then return false end
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("BasePart") and (obj.BrickColor == BrickColor.new("Really red") or obj.Name:find("Indicator")) then
            local dist = (Root.Position - obj.Position).Magnitude
            if dist < (obj.Size.X / 2 + 5) then
                Humanoid:MoveTo(Root.Position + (Root.CFrame.RightVector * 20)) -- Né sang phải
                return true
            end
        end
    end
    return false
end

-- 3. HÀM DI CHUYỂN BỘ
local function walkTo(position)
    local path = PathfindingService:CreatePath({AgentCanJump = true})
    path:ComputeAsync(Root.Position, position)
    if path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for i, waypoint in pairs(waypoints) do
            if not _G.AutoFarm or checkAndDodge() then break end
            Humanoid:MoveTo(waypoint.Position)
            if getTarget() and (Root.Position - getTarget().PrimaryPart.Position).Magnitude < 12 then break end
            Humanoid.MoveToFinished:Wait(0.05)
        end
    end
end

-- TAB GIAO DIỆN
local MainTab = Window:CreateTab("Main Farm", 4483362458) -- Icon ID

MainTab:CreateToggle({
    Name = "Auto Dungeon (Walk Only)",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoFarm = Value
    end,
})

MainTab:CreateToggle({
    Name = "Auto Use Skills",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoSkill = Value
    end,
})

MainTab:CreateToggle({
    Name = "Smart Dodge (Né vùng đỏ)",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoDodge = Value
    end,
})

MainTab:CreateSlider({
   Name = "Quét quái xa (Range)",
   Range = {30, 200},
   Increment = 10,
   Suffix = "Studs",
   CurrentValue = 60,
   Callback = function(Value)
      -- Cập nhật tầm quét nếu cần
   end,
})

-- VÒNG LẶP CHÍNH
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoFarm then
            local target = getTarget()
            if not checkAndDodge() then
                if target then
                    local dist = (Root.Position - target.PrimaryPart.Position).Magnitude
                    if dist > 12 then
                        walkTo(target.PrimaryPart.Position)
                    else
                        if _G.AutoSkill then
                            -- Gửi lệnh Skill tới Server (Ví dụ)
                            -- game:GetService("VirtualInputManager"):SendKeyEvent(true, "Q", false, game)
                            print("Sử dụng kỹ năng lên: " .. target.Name)
                        end
                    end
                end
            end
        end
    end
end)

Rayfield:Notify({
   Title = "Script Loaded!",
   Content = "Chúc bạn cày game vui vẻ - HoafngKhooi",
   Duration = 5,
   Image = 4483362458,
})
