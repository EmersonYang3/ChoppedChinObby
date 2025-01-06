-- Services and Variables
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local BadgeService = game:GetService("BadgeService")

local checkPointFolder = workspace.checkpoints
local DataStore = DataStoreService:GetDataStore("checkpoints")
local debounceTimes = {}
local playerCheckpoints = {}
local LastCheckPoint = 25
local BADGE_ID = 2874162070205701

-- Functions
local function fetchCheckPoint(userID)
    return DataStore:GetAsync(userID) or 0
end

local function updateCheckPoint(userID, checkPointID)
    local highestCheckPoint = fetchCheckPoint(userID)

    if checkPointID > highestCheckPoint then
        print("Updating checkpoint for user: ", userID, " to checkpoint: ", checkPointID)
        DataStore:SetAsync(userID, checkPointID)
        playerCheckpoints[userID] = checkPointID
        
        local player = Players:GetPlayerByUserId(userID)
        if player then
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats then
                local checkpointValue = leaderstats:FindFirstChild("Stage")
                if checkpointValue then
                    checkpointValue.Value = checkPointID
                end
            end

            if checkPointID == LastCheckPoint then
                BadgeService:AwardBadge(player.UserId, BADGE_ID)
                print("Awarded badge to user: ", userID)
            end
        end
    end
end

local function onPlayerAdded(player)
    local userID = player.UserId
    local savedCheckpoint = fetchCheckPoint(userID)
    print("Player added with saved checkpoint: ", savedCheckpoint)

    playerCheckpoints[userID] = savedCheckpoint

    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local checkpointValue = Instance.new("IntValue")
    checkpointValue.Name = "Stage"
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
                    print("Player touched checkpoint: ", checkPointID)
                    updateCheckPoint(userID, checkPointID)
                end
            end
        end)
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)
