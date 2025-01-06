-- Services and Variables
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local checkPointFolder = workspace.checkpoints
local DataStore = DataStoreService:GetDataStore("checkpoints")
local debounceTimes = {}
local playerCheckpoints = {}

-- Functions
local function fetchCheckPoint(userID)
    return DataStore:GetAsync(userID) or 0
end

local function updateCheckPoint(userID, checkPointID)
    local highestCheckPoint = fetchCheckPoint(userID)

    if checkPointID > highestCheckPoint then
        DataStore:SetAsync(userID, checkPointID)
        playerCheckpoints[userID] = checkPointID
        
        local player = Players:GetPlayerByUserId(userID)
        if player then
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats then
                local checkpointValue = leaderstats:FindFirstChild("Checkpoints")
                if checkpointValue then
                    checkpointValue.Value = checkPointID
                end
            end
        end
    end
end

local function onPlayerAdded(player)
    local userID = player.UserId
    local savedCheckpoint = fetchCheckPoint(userID)

    playerCheckpoints[userID] = savedCheckpoint

    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local checkpointValue = Instance.new("IntValue")
    checkpointValue.Name = "Checkpoints"
    checkpointValue.Value = savedCheckpoint
    checkpointValue.Parent = leaderstats

    player.CharacterAdded:Connect(function(character)
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local checkPointID = playerCheckpoints[userID]
        local respawnLocation = checkPointFolder:FindFirstChild(tostring(checkPointID))
        if respawnLocation then
            humanoidRootPart.CFrame = respawnLocation.CFrame + Vector3.new(0, 3, 0)
        end
    end)
end

-- Connections
for _, descendant in ipairs(checkPointFolder:GetDescendants()) do
    if descendant:IsA("Part") then
        descendant.Touched:Connect(function(hit)
            local player = Players:GetPlayerFromCharacter(hit.Parent)
            if player then
                local userID = player.UserId
                local checkPointID = tonumber(descendant.Name)
                local currentTime = tick()
                
                if checkPointID and (not debounceTimes[userID] or currentTime - debounceTimes[userID] > 5) then
                    debounceTimes[userID] = currentTime
                    updateCheckPoint(userID, checkPointID)
                end
            end
        end)
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)
