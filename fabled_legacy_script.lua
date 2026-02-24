--[[
    Fabled Legacy - Advanced Dungeon Bot (Walk-Only)
    Author: HoafngKhooi
]]

local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

-- CÀI ĐẶT CHUNG
local Settings = {
    AutoSkill = true,
    DodgeRedZones = true,
    SkillKeys = {"Q", "E", "R", "F"},
    DetectionRadius = 60
}

-- 1. HÀM TÌM QUÁI (Targeting)
local function getTarget()
    local closestTarget = nil
    local maxDist = Settings.DetectionRadius
    
    -- Fabled Legacy thường để quái trong workspace.Enemies hoặc Mob
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

-- 2. HÀM NÉ CHIÊU (Dodge Logic)
-- Quét các Part cảnh báo màu đỏ trên mặt đất
local function checkAndDodge()
    for _, obj in pairs(workspace:GetChildren()) do
        -- Kiểm tra các vùng đỏ (thường là Part có màu đỏ hoặc tên "Indicator")
        if obj:IsA("BasePart") and (obj.BrickColor == BrickColor.new("Really red") or obj.Name:find("Zone")) then
            local dist = (Root.Position - obj.Position).Magnitude
            if dist < (obj.Size.X / 2 + 3) then
                -- Lệnh nhảy hoặc lướt ra xa
                Humanoid:MoveTo(Root.Position + (Root.CFrame.RightVector * 15))
                return true
            end
        end
    end
    return false
end

-- 3. HÀM DI CHUYỂN BỘ (Pathfinding)
local function walkTo(position)
    local path = PathfindingService:CreatePath({AgentCanJump = true})
    path:ComputeAsync(Root.Position, position)
    
    if path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for i, waypoint in pairs(waypoints) do
            if checkAndDodge() then break end -- Ưu tiên né chiêu
            Humanoid:MoveTo(waypoint.Position)
            
            -- Nếu có quái gần, dừng lại đánh một chút rồi đi tiếp
            if getTarget() and (Root.Position - getTarget().PrimaryPart.Position).Magnitude < 15 then
                break
            end
            Humanoid.MoveToFinished:Wait(0.1)
        end
    end
end

-- 4. VÒNG LẶP CHÍNH (Main Loop)
task.spawn(function()
    while task.wait(0.5) do
        local target = getTarget()
        
        if not checkAndDodge() then
            if target then
                local dist = (Root.Position - target.PrimaryPart.Position).Magnitude
                if dist > 10 then
                    walkTo(target.PrimaryPart.Position)
                else
                    -- Xả Skill khi đủ gần
                    for _, key in pairs(Settings.SkillKeys) do
                        -- Thay thế đoạn này bằng RemoteEvent của game sau khi dùng SimpleSpy
                        print("Đang xả chiêu: " .. key)
                    end
                end
            else
                -- Nếu không có quái, đi tìm checkpoint tiếp theo (Cổng Dungeon)
                -- walkTo(Vector3.new(x, y, z))
            end
        end
    end
end)
