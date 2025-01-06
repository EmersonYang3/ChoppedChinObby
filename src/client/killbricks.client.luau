local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function onInputBegan(input, gameProcessedEvent)
    if not gameProcessedEvent then 
        if input.KeyCode == Enum.KeyCode.R then
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                end
            end
        end
    end
end

UserInputService.InputBegan:Connect(onInputBegan)

workspace.killbricks.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("BasePart") then
        descendant.Touched:Connect(function(hit)
            local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end)
    end
end)
