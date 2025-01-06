-- Assets Required For The Game
local CCDecalID = "http://www.roblox.com/asset/?id=135537245717452"
local confettiName = "confetti" 

local function loadDecals(Part)
    if Part:IsA("Part") and Part.Name ~= "HumanoidRootPart" and Part.Name ~= confettiName then
        local faces = {"Back", "Bottom", "Front", "Left", "Right", "Top"}
        
        for _, face in ipairs(faces) do
            local newDecal = Instance.new("Decal")
            newDecal.Texture = CCDecalID
            newDecal.Face = Enum.NormalId[face]
            newDecal.Parent = Part
        end
    end
end

workspace.DescendantAdded:Connect(loadDecals)

for _, part in ipairs(workspace:GetDescendants()) do
    loadDecals(part)
end

local sky = game.Lighting:FindFirstChildOfClass("Sky")

if sky then
    sky.SkyboxBk = CCDecalID
    sky.SkyboxDn = CCDecalID
    sky.SkyboxFt = CCDecalID
    sky.SkyboxLf = CCDecalID
    sky.SkyboxRt = CCDecalID
    sky.SkyboxUp = CCDecalID
end
