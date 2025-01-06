local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local confettiPart = ReplicatedStorage:WaitForChild("confetti")
local debounce = false
local triggeredCheckpoints = {}

local function toggleParticleEmitters(state)
    for _, emitter in ipairs(confettiPart:GetChildren()) do
        if emitter:IsA("ParticleEmitter") then
            emitter.Enabled = state
        end
    end
end

local function showConfetti(checkpoint)
    if not debounce then
        debounce = true
        confettiPart.Parent = workspace 
        confettiPart.Position = checkpoint.Position + Vector3.new(0, 0, 0)
        toggleParticleEmitters(true)
        task.wait(1)
        toggleParticleEmitters(false)
        task.wait(2)
        confettiPart.Parent = ReplicatedStorage
        debounce = false
    end
end

local function onCheckpointTouched(hit, checkpointPart)
    local checkpointID = checkpointPart.Name
    if not triggeredCheckpoints[checkpointID] then
        triggeredCheckpoints[checkpointID] = true
        showConfetti(checkpointPart)
    end
end

for _, descendant in ipairs(workspace.checkpoints:GetDescendants()) do
    if descendant:IsA("Part") then
        descendant.Touched:Connect(function(hit)
            onCheckpointTouched(hit, descendant)
        end)
    end
end

workspace.checkpoints.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Part") then
        descendant.Touched:Connect(function(hit)
            onCheckpointTouched(hit, descendant)
        end)
    end
end)
