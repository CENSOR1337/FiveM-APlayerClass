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

    if (self.onConstruction) then
        self:onConstruction()
    end

    return self
end
