local QBCore = exports['qb-core']:GetCoreObject()

local waypointSet = false
local notified = false
local doorHash = GetHashKey("v_ilev_trevtraildr")
local doorCoords = vector3(1973.46, 3815.61, 33.51)
local targetCoords = vector3(1973.69, 3815.5, 33.43)
local DoorUnlocked = false
local BrokenIn = false
local MissionStarted = false
local targetAdded = false

CreateThread(function()
    AddDoorToSystem(doorHash, doorHash, doorCoords.x, doorCoords.y, doorCoords.z, false, false, false)
end)

RegisterNetEvent('break-open-door')
AddEventHandler('break-open-door', function()
    local playerPed = PlayerPedId()
    
    RequestAnimDict("missheistdockssetup1ig_13@kick_idle")
    while not HasAnimDictLoaded("missheistdockssetup1ig_13@kick_idle") do
        Citizen.Wait(100)
    end

    lib.progressBar({
        duration = 10000,
        label = 'Breaking up the door...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'missheistdockssetup1ig_13@kick_idle',
            clip = 'guard_beatup_kickidle_guard2'
        },
    }) DoorUnlocked = true
    BrokenIn = true
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
    MissionStarted = true

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
                if not DoorUnlocked then
                    DoorSystemSetDoorState(doorHash, 1, false, true)
                else
                    DoorSystemSetDoorState(doorHash, 0, false, true)
                end
                if not BrokenIn and MissionStarted then
                    exports.ox_target:addBoxZone(
                        coords = vector3(123.00, 123.00, 123.00)
                    )
                end
            end
        end
    end)
end)