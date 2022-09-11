--[[ APlayer ]]
APlayer = {}
APlayer.__index = APlayer

function APlayer.new(src, playerClass)
    playerClass = (playerClass and type(playerClass) == "table") and playerClass or APlayer
    local self = setmetatable({}, playerClass)
    self.src = src
    self.source = self.src
    self.playerid = GetPlayerFromServerId(self.src)
    self.ped = GetPlayerPed(self.playerid)

    -- Validate Entity
    local timeout = GetGameTimer() + 10000
    while not (DoesEntityExist(self.ped)) do
        self.ped = GetPlayerPed(self.playerid)
        if (GetGameTimer() > timeout) then
            break
        end
        Wait(50)
    end

    if (GetGameTimer() <= timeout) then
        CreateThread(function()
            if (self.onConstruction) then
                self:onConstruction()
            end
        end)
        return self
    end

    return nil
end
