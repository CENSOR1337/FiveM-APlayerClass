RegisterNetEvent("onPlayerJoining", function(src, name, playerid)
    local bSuccess = false
    while NetworkIsPlayerActive(playerid) do
        if DoesEntityExist(GetPlayerPed(playerid)) then
            bSuccess = true
            break
        end
        Wait(0)
    end
    if (bSuccess) then
        TriggerEvent("APlayer:onPlayerJoined", src)
    end
end)

RegisterNetEvent("onPlayerDropped", function(src, name, playerid)
    src = tonumber(src)
    TriggerEvent("APlayer:onPlayerDropped", src)
end)
