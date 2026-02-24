--[[
    Fabled Legacy - Walk-Only Dungeon Bot
    Tính năng: Tự tìm quái, Dùng skill, Né vùng đỏ (Indicator)
]]

local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Cấu hình
local CONFIG = {
    DetectionRange = 100, -- Tầm quét quái
    SkillRange = 30,      -- Tầm xả skill
    DodgeDistance = 25,   -- Khoảng cách né vùng đỏ
    Skills = {"Q", "E", "R", "V"} -- Các phím skill
}

-- 1. Hàm tìm quái gần nhất
local function getNearestEnemy()
    local nearest = nil
    local minDist = CONFIG.DetectionRange
    
    -- Lưu ý: Kiểm tra folder chứa quái trong workspace của Fabled Legacy
    -- Thường là workspace.Enemies hoặc workspace.Mobs
    for _, enemy in pairs(workspace:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy ~= Character then
            local dist = (Root.Position - enemy.PrimaryPart.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = enemy
            end
        end
    end
    return nearest
end

-- 2. Hàm né chiêu (Logic né vùng báo đỏ)
local function dodgeAOE()
    -- Quét các Part hình tròn/vuông màu đỏ xuất hiện dưới đất (Indicators)
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("BasePart") and (obj.Name:find("Indicator") or obj.Transparency > 0.5) then
            local dist = (Root.Position - obj.Position).Magnitude
            if dist < obj.Size.X / 2 + 5 then -- Nếu đang đứng trong vùng đỏ
                -- Di chuyển lùi lại hoặc sang ngang
                Humanoid:MoveTo(Root.Position + (Root.CFrame.RightVector * CONFIG.DodgeDistance))
                return true
            end
        end
    end
    return false
end

-- 3. Hàm di chuyển thông minh (Pathfinding)
local function moveToTarget(targetPos)
    local path = PathfindingService:CreatePath({AgentCanJump = true, AgentRadius = 3})
    path:ComputeAsync(Root.Position, targetPos)
    
    if path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for i = 1, math.min(#waypoints, 3) do -- Chỉ lấy vài điểm đầu để cập nhật liên tục
            if dodgeAOE() then break end -- Ưu tiên né chiêu
            Humanoid:MoveTo(waypoints[i].Position)
            Humanoid.MoveToFinished:Wait(0.1)
        end
    end
end

-- 4. Main Loop (Vòng lặp chính)
spawn(function()
    while task.wait(0.5) do
        if not Character or Humanoid.Health <= 0 then break end
        
        local enemy = getNearestEnemy()
        if enemy then
            local dist = (Root.Position - enemy.PrimaryPart.Position).Magnitude
            
            if dist > CONFIG.SkillRange then
                moveToTarget(enemy.PrimaryPart.Position)
            else
                -- Tấn công khi vào tầm
                for _, key in pairs(CONFIG.Skills) do
                    -- Giả lập nhấn phím (Cần VirtualInputManager hoặc RemoteEvent của game)
                    -- Ví dụ gọi qua Remote:
                    -- game:GetService("ReplicatedStorage").Remotes.Skill:FireServer(key)
                    print("Sử dụng Skill: " .. key)
                end
            end
        else
            -- Nếu không có quái, đi tới cổng/điểm checkpoint tiếp theo
            -- moveToTarget(Vector3.new(x, y, z)) 
        end
    end
end)

