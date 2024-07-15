local QBCore = exports['qb-core']:GetCoreObject()

local waypointSet = false
local notified = false
local doorHash = GetHashKey("v_ilev_trevtraildr")
local doorCoords = vector3(1973.46, 3815.61, 33.51)

CreateThread(function()
    AddDoorToSystem(doorHash, doorHash, doorCoords.x, doorCoords.y, doorCoords.z, false, false, false)
end)

RegisterNetEvent('talk-rob-ped')
AddEventHandler('talk-rob-ped', function()
    lib.showContext("rob_menu")
end)

RegisterNetEvent('smdx-robbery:MissionStarted')
AddEventHandler('smdx-robbery:MissionStarted', function()
    lib.notify({
        title = 'STEP 1',
        description = 'Go to the marked location on your map.',
        type = 'info'
    })
    if not waypointSet then
        SetNewWaypoint(1973.73, 3815.08)
        waypointSet = true
    end
    CreateThread(function()
        while true do
            Wait(1000)

            local player = PlayerPedId()
            local playerCoords = GetEntityCoords(player)
            local markerPos = vector3(1973.73, 3815.08, 33.43)
            local dst = #(playerCoords - markerPos)

            if dst <= 3.0 then
                if not notified then
                    lib.notify({
                        title = 'STEP 2',
                        description = 'Break open the door!',
                        type = 'info'
                    })
                    notified = true
                end
                DoorSystemSetDoorState(doorHash, 1, false, true)
                if not exports['qb-inventory']:HasItem(Config.LockPickItem) then
                    lib.notify({
                        title = 'NO LOCKPICK',
                        description = 'You have no lockpicks to break open this door...',
                        type = 'error'
                    })
                else
                    exports['qb-core']:DrawText('[E] - Break open door', 'left')
                end
            end
        end
    end)
end)