--[[
    Fabled Legacy - Advanced Dungeon Bot (7 Rooms Edition)
    Author: HoafngKhooi
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local VIM = game:GetService("VirtualInputManager")
local PathfindingService = game:GetService("PathfindingService")

local Window = Rayfield:CreateWindow({
    Name = "Fabled Legacy | HoafngKhooi Hub",
    LoadingTitle = "Đang cấu hình 7 Rooms...",
    LoadingSubtitle = "by HoafngKhooi",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "HoafngKhooi_Fabled",
       FileName = "Config"
    },
    KeySystem = false 
})

-- Biến Trạng Thái
_G.AutoFarm = false
_G.AutoSkill = false
_G.AutoDodge = false
_G.CurrentRoom = 0
_G.MaxRooms = 7 -- Dựa trên thông số (1/7) trong game

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

-- 1. HÀM TÌM QUÁI TRONG FOLDER ENEMIES
local function getTarget()
    local enemyFolder = workspace:FindFirstChild("Enemies") -- Quét đúng folder Enemies
    local closestTarget = nil
    local maxDist = 200 
    
    if enemyFolder then
        for _, v in pairs(enemyFolder:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                local eRoot = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                if eRoot then
                    local dist = (Root.Position - eRoot.Position).Magnitude
                    if dist < maxDist then
                        maxDist = dist
                        closestTarget = v
                    end
                end
            end
        end
    end
    return closestTarget
end

-- 2. HÀM TỰ DÙNG SKILL Q/E
local function useSkills()
    VIM:SendKeyEvent(true, "Q", false, game) -- Skill Q
    task.wait(0.1)
    VIM:SendKeyEvent(false, "Q", false, game)
    task.wait(0.2)
    VIM:SendKeyEvent(true, "E", false, game) -- Skill E
    task.wait(0.1)
    VIM:SendKeyEvent(false, "E", false, game)
end

-- 3. HÀM DI CHUYỂN TỚI ROOM TIẾP THEO
local function goToRoom()
    local info = workspace:FindFirstChild("roomInformation") -- Quét folder roomInformation
    if info then
        local room = info:FindFirstChild("Room" .. _G.CurrentRoom)
        if room then
            local part = room:FindFirstChildWhichIsA("BasePart", true)
            if part then
                Humanoid:MoveTo(part.Position)
                return true
            end
        end
    end
    return false
end

-- 4. HÀM NÉ CHIÊU
local function checkAndDodge()
    if not _G.AutoDodge then return false end
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("BasePart") and (obj.BrickColor == BrickColor.new("Really red") or obj.Name:find("Indicator")) then
            local dist = (Root.Position - obj.Position).Magnitude
            if dist < (obj.Size.X / 2 + 5) then
                Humanoid:MoveTo(Root.Position + (Root.CFrame.RightVector * 20)) 
                return true
            end
        end
    end
    return false
end

-- TAB GIAO DIỆN
local MainTab = Window:CreateTab("Chiến Dungeon", 4483362458)

MainTab:CreateToggle({
    Name = "Auto Farm (7 Rooms Mode)",
    CurrentValue = false,
    Callback = function(Value) _G.AutoFarm = Value end,
})

MainTab:CreateToggle({
    Name = "Auto Skill (Q + E)",
    CurrentValue = false,
    Callback = function(Value) _G.AutoSkill = Value end,
})

MainTab:CreateToggle({
    Name = "Smart Dodge (Né vùng đỏ)",
    CurrentValue = false,
    Callback = function(Value) _G.AutoDodge = Value end,
})

MainTab:CreateButton({
   Name = "Reset Room Count (Về Room 0)",
   Callback = function() _G.CurrentRoom = 0 end,
})

-- VÒNG LẶP CHÍNH
task.spawn(function()
    while task.wait(0.4) do
        if _G.AutoFarm and Humanoid.Health > 0 then
            local target = getTarget()
            
            if not checkAndDodge() then
                if target then
                    -- CÓ QUÁI: Tiến tới đánh
                    local tRoot = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart
                    local dist = (Root.Position - tRoot.Position).Magnitude
                    
                    if dist > 12 then
                        Humanoid:MoveTo(tRoot.Position)
                    else
                        if _G.AutoSkill then useSkills() end
                    end
                else
                    -- HẾT QUÁI: Đi tới Room hiện tại hoặc chuyển Room
                    local moved = goToRoom()
                    if not moved and _G.CurrentRoom < _G.MaxRooms then
                        _G.CurrentRoom = _G.CurrentRoom + 1
                    end
                end
            end
        end
    end
end)

Rayfield:Notify({
   Title = "Hub Loaded!",
   Content = "Đã sẵn sàng cày 7 Rooms!",
   Duration = 5
})
