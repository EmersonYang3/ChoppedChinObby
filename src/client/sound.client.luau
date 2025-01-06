-- Assets Required For The Game
local CCAudioID = "75749668399053"

-- Variables
local Player = game:GetService("Players").LocalPlayer

-- Functions
local function loadAudio()
    local sound = Instance.new("Sound")
    sound.Parent = game.SoundService
    sound.SoundId = "rbxassetid://" .. CCAudioID
    sound.Looped = true

    sound:Play()
end

loadAudio()