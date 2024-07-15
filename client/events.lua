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
    BrokenIn = true
    exports['qb-target']:RemoveZone("trev_door")
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
    lib.notify({
        title = 'GREAT!',
        description = 'You broke the door open, now go inside and look for items to steal',
        type = 'success'
    })
    TriggerEvent("smdx-robbery:steal")
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
                    exports['qb-target']:AddBoxZone("trev_door", vector3(1973.69, 3815.5, 32.43), 1.5, 1.6, {
                        name = "trev_door",
                        heading = 12.0,
                        debugPoly = false,
                        minZ = 36.7,
                        maxZ = 38.9,
                    }, {
                        options = {
                            {
                                num = 1,
                                type = "client",
                                event = "break-open-door",
                                icon = 'fas fa-lock',
                                label = 'Break open the door',
                                targeticon = 'fas fa-lock',
                            }
                        },
                        distance = 2.5,
                    })
                    BrokenIn = true
                end
            end
        end
    end)
end)

RegisterNetEvent("smdx-robbery:steal")
AddEventHandler("smdx-robbery:steal", function()
    local player = PlayerPedId()
    local plyCoords = GetEntityCoords(player)
    local coords1 = vector3(1978.34, 3819.85, 32.54)
    local coords2 = vector3(1974.62, 3820.63, 32.43)
    local coords3 = vector3(1975.43, 3818.47, 32.44)
    local coords4 = vector3(1969.27, 3814.79, 32.43)

    local ItemOneStolen = false
    local ItemTwoStolen = false
    local ItemThreeStolen = false
    local ItemFourStolen = false

    local function addTargetZone(zoneName, coords, event)
        exports['qb-target']:AddBoxZone(zoneName, coords, 1.5, 1.6, {
            name = zoneName,
            heading = 12.0,
            debugPoly = false,
            minZ = 36.7,
            maxZ = 38.9,
        }, {
            options = {
                {
                    num = 1,
                    type = "client",
                    event = event,
                    icon = 'fas fa-lock',
                    label = 'Steal Item',
                    targeticon = 'fas fa-lock',
                }
            },
            distance = 2.5,
        })
    end

    CreateThread(function()
        while not ItemOneStolen or not ItemTwoStolen or not ItemThreeStolen or not ItemFourStolen do
            Wait(1000)

            local player = PlayerPedId()
            local plyCoords = GetEntityCoords(player)

            if not ItemOneStolen then
                local dst1 = #(plyCoords - coords1)
                if dst1 <= 5.0 then
                    addTargetZone("trev_search1", coords1, "steal-item-one")
                    ItemOneStolen = true
                end
            end

            if not ItemTwoStolen then
                local dst2 = #(plyCoords - coords2)
                if dst2 <= 5.0 then
                    addTargetZone("trev_search2", coords2, "steal-item-two")
                    ItemTwoStolen = true
                end
            end

            if not ItemThreeStolen then
                local dst3 = #(plyCoords - coords3)
                if dst3 <= 5.0 then
                    addTargetZone("trev_search3", coords3, "steal-item-three")
                    ItemThreeStolen = true
                end
            end

            if not ItemFourStolen then
                local dst4 = #(plyCoords - coords4)
                if dst4 <= 5.0 then
                    addTargetZone("trev_search4", coords4, "steal-item-four")
                    ItemFourStolen = true
                end
            end
        end
    end)
end)

local item1Stolen = false
local item2Stolen = false
local item3Stolen = false
local item4Stolen = false

RegisterNetEvent("steal-item-one")
AddEventHandler("steal-item-one", function()
    exports['qb-target']:RemoveZone("trev_search1")
    lib.progressBar({
        duration = 10000,
        label = 'Stealing Items...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'anim@gangops@facility@servers@bodysearch@',
            clip = 'player_search'
        },
    })
    item1Stolen = true
    lib.notify({
        title = 'ITEM STOLEN',
        description = 'You stole one item!',
        type = 'success'
    })
end)

RegisterNetEvent("steal-item-two")
AddEventHandler("steal-item-two", function()
    exports['qb-target']:RemoveZone("trev_search2")
    lib.progressBar({
        duration = 10000,
        label = 'Stealing Items...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'anim@gangops@facility@servers@bodysearch@',
            clip = 'player_search'
        },
    })
    item2Stolen = true
    lib.notify({
        title = 'ITEM STOLEN',
        description = 'You stole one item!',
        type = 'success'
    })
end)

RegisterNetEvent("steal-item-three")
AddEventHandler("steal-item-three", function()
    exports['qb-target']:RemoveZone("trev_search3")
    lib.progressBar({
        duration = 10000,
        label = 'Stealing Items...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'anim@gangops@facility@servers@bodysearch@',
            clip = 'player_search'
        },
    })
    item3Stolen = true
    lib.notify({
        title = 'ITEM STOLEN',
        description = 'You stole one item!',
        type = 'success'
    })
end)

RegisterNetEvent("steal-item-four")
AddEventHandler("steal-item-four", function()
    exports['qb-target']:RemoveZone("trev_search4")
    lib.progressBar({
        duration = 10000,
        label = 'Stealing Items...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'anim@gangops@facility@servers@bodysearch@',
            clip = 'player_search'
        },
    })
    item4Stolen = true
    lib.notify({
        title = 'ITEM STOLEN',
        description = 'You stole one item!',
        type = 'success'
    })
end)

CreateThread(function()
    local notifyShown = false
    local MWSet = false
    while true do
        Wait(1000)

        if item1Stolen and item2Stolen and item3Stolen and item4Stolen and not notifyShown then
            lib.notify({
                title = 'GREAT',
                description = 'You have stolen all the items, now move to the next place located on your GPS!',
                type = 'success'
            })
            notifyShown = true
            if not MWSet then
                SetNewWaypoint(-817.2, 178.04)
                MWSet = true
            end

            local player = PlayerPedId()
            local plyCoords = GetEntityCoords(player)
            local WPCoords = vector3(-817.22, 178.0, 72.23)
            local dst = #(plyCoords - WPCoords)

            if dst <= 3.0 then
                lib.notify({
                    title = 'BREAK IN',
                    description = 'Break open the door and keep stealing stuff!',
                    type = 'info'
                })
            end
        end
    end
end)