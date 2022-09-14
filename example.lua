--[[ PlayerClass ]]
local PlayerClass = {}
PlayerClass.__index = PlayerClass
setmetatable(PlayerClass, APlayer) -- inheritance from APlayer class

local function DrawText3D(coords, text, size) -- Just a function to draw Text
    local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)

    local camCoords = GetFinalRenderedCamCoord()
    local distance = #(vector - camCoords)

    if not size then
        size = 1
    end

    local scale = (size / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropshadow(100, 0, 0, 0, 255)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(vector.xyz, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

function PlayerClass:onTick()
    DrawText3D(GetEntityCoords(self.ped), string.format("name : [%s]\nsrc : %s\nplayerid : %s\nped : %s\n", self.playername, self.src, self.playerid, self.ped))
end

function PlayerClass:onConstruction()
    self.playername = GetPlayerName(self.playerid)
    print(self.source, self.playerid, self.ped)
end

function PlayerClass:destroy()
    print("Pool destroyed, Removing ", self.src)
end

local APlayerPoolInherit = {}
APlayerPoolInherit.__index = APlayerPoolInherit
setmetatable(APlayerPoolInherit, APlayerPool) -- inheritance from APlayerPool class

function APlayerPoolInherit:onConstruction()
    print("Pool Construction")
end

function APlayerPoolInherit:onPlayerLoaded(src)
    print("Player loaded : ", src)
end

function APlayerPoolInherit:onPlayerDropped(src)
    print("Player dropped : ", src)
end

--[[ Create Pool ]]
CreateThread(function()
    while PlayerPedId() == 770 do
        Wait(0)
    end

    local PlayersPool = APlayerPool.newPool({
        poolClass = APlayerPoolInherit,
        playerClass = PlayerClass,
        tickRate = 4,
        bTick = true
    })

    --Wait(5000) -- Destory after 5 second
    --PlayersPool:destroy()
end)
