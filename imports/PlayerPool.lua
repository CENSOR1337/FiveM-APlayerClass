--[[ APlayerPool ]]
APlayerPool = {}
APlayerPool.__index = APlayerPool

function APlayerPool.newPool(options)
    local poolClass = (options.poolClass and type(options.poolClass) == "table") and options.poolClass or APlayerPool
    local self = setmetatable({}, poolClass)
    self.players = {}
    self.playerClass = (options.playerClass and type(options.playerClass) == "table") and options.playerClass or APlayer
    self.bTick = (options.bTick ~= nil) and options.bTick or false
    self.bDestroyed = false
    self.tickRate = (options.bTick ~= nil) and options.tickRate or 0

    --[[ Private functions ]]
    local function AddPlayerIntoPool(src, name, netId)
        src = tonumber(src)
        if (self.players[src]) then
            return
        end

        local player = self.playerClass.new(src, self.playerClass)
        if (player) then
            self.players[player.src] = player
            if (self.onPlayerLoaded) then
                self:onPlayerLoaded(src)
            end
        end
    end

    --[[ End of Private functions ]]

    local function RemovePlayerFromPool(src, name, netId)
        src = tonumber(src)
        if (src) then
            if (self.onPlayerDropped) then
                self:onPlayerDropped(src)
            end
            self.players[src] = nil
        end
    end

    self.baseEvents = {
        onPlayerJoining = AddEventHandler("APlayer:onPlayerJoined", AddPlayerIntoPool),
        onPlayerDropped = AddEventHandler("APlayer:onPlayerDropped", RemovePlayerFromPool)
    }

    -- Constructor
    if (self.onConstruction) then
        self:onConstruction()
    end

    -- When create new pool
    CreateThread(function()
        local players = GetActivePlayers()
        for i = 1, #players, 1 do
            local playerId = players[i]
            local src = GetPlayerServerId(playerId)
            AddPlayerIntoPool(src)
        end
    end)

    -- Start EventTick
    if (self.bTick) then
        CreateThread(function()
            local bSleep = false
            while not (self.bDestroyed) do
                for _, aplayer in pairs(self.players) do
                    if (aplayer.onTick) then
                        bSleep = false
                        aplayer:onTick()
                    end
                end
                Wait(bSleep and 200 or self.tickRate)
            end
        end)
    end
    
    return self
end

function APlayerPool:destroy()
    self.bDestroyed = true
    RemoveEventHandler(self.baseEvents.onPlayerJoining)
    RemoveEventHandler(self.baseEvents.onPlayerDropped)
    for _, aplayer in pairs(self.players) do
        if (aplayer.destroy) then
            aplayer:destroy()
        end
    end
end

function APlayerPool:getPlayer(src)
    src = tonumber(src)
    return self.players[src]
end

function APlayerPool:getPlayers()
    return self.players
end
