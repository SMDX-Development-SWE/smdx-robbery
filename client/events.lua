local QBCore = exports['qb-core']:GetCoreObject()


------------
-- LOCALS --
------------
local waypointSet = false
local notified = false
local doorHash = GetHashKey("v_ilev_trevtraildr")
local doorHash2 = GetHashKey("v_ilev_mm_doorm_l")
local doorHash3 = GetHashKey("v_ilev_mm_doorm_r")
local doorCoords = vector3(1973.46, 3815.61, 33.51)
local doorCoords2 = vector3(-816.65, 178.46, 72.23)
local doorCoords3 = vector3(-816.55, 177.87, 72.23)
local targetCoords = vector3(1973.69, 3815.5, 33.43)
local DoorUnlocked = false
local Door2Unlocked = false
local BrokenIn = false
local BrokenIn2 = false
local MissionStarted = false
local MissionEnded = false
local MichaelMission = false
local targetAdded = false

-------------------------
-- ADD THE NEEDED DOOR --
-------------------------
CreateThread(function()
    AddDoorToSystem(doorHash, doorHash, doorCoords.x, doorCoords.y, doorCoords.z, false, false, false)
    AddDoorToSystem(doorHash2, doorHash2, doorCoords2.x, doorCoords2.y, doorCoords2.z, false, false, false)
    AddDoorToSystem(doorHash3, doorHash3, doorCoords3.x, doorCoords3.y, doorCoords3.z, false, false, false)
end)

---------------------------------------------------------------
-- EVENT THAT HANDLES BREAKING UP THE DOOR AT TREVOR'S PLACE --
---------------------------------------------------------------
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
    }) 
    DoorUnlocked = true
    lib.notify({
        title = 'GREAT!',
        description = 'You broke the door open, now go inside and look for items to steal',
        type = 'success'
    })
    TriggerEvent("smdx-robbery:steal")
end)

---------------------------------------------------------------
-- EVENT THAT HANDLES BREAKING UP THE DOOR AT MICHAELS PLACE --
---------------------------------------------------------------
RegisterNetEvent('break-open-door-two')
AddEventHandler('break-open-door-two', function()
    BrokenIn2 = true
    exports['qb-target']:RemoveZone("mich_door")
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
    })
    Door2Unlocked = true
    lib.notify({
        title = 'GREAT!',
        description = 'You broke the door open, now go inside and look for items to steal',
        type = 'success'
    })
    TriggerEvent("smdx-robbery:stealtwo")
end)

--------------------------------------------
-- OPENS THE MENU WHEN TALKING TO THE PED --
--------------------------------------------
RegisterNetEvent('talk-rob-ped')
AddEventHandler('talk-rob-ped', function()
    if not MissionStarted then
        lib.showContext("rob_menu")
    else
        lib.showContext("rob_end_menu")
    end
end)

-------------------------------------------
-- GETS CALLED WHEN STARTING THE MISSION --
-------------------------------------------
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

----------------------------------------
-- HANDLES STEALING ITEMS AT TREVOR'S --
----------------------------------------
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

-----------------------------------------
-- HANDLES STEALING ITEMS AT MICHAEL'S --
-----------------------------------------
RegisterNetEvent("smdx-robbery:stealtwo")
AddEventHandler("smdx-robbery:stealtwo", function()
    local player = PlayerPedId()
    local plyCoords = GetEntityCoords(player)
    local coords1 = vector3(-811.32, 178.66, 71.15)
    local coords2 = vector3(-804.69, 177.52, 71.83)
    local coords3 = vector3(-799.83, 177.2, 71.83)
    local coords4 = vector3(-797.96, 187.68, 71.61)

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
                    addTargetZone("mich_search1", coords1, "steal-item-one-mich")
                    ItemOneStolen = true
                end
            end

            if not ItemTwoStolen then
                local dst2 = #(plyCoords - coords2)
                if dst2 <= 5.0 then
                    addTargetZone("mich_search2", coords2, "steal-item-two-mich")
                    ItemTwoStolen = true
                end
            end

            if not ItemThreeStolen then
                local dst3 = #(plyCoords - coords3)
                if dst3 <= 5.0 then
                    addTargetZone("mich_search3", coords3, "steal-item-three-mich")
                    ItemThreeStolen = true
                end
            end

            if not ItemFourStolen then
                local dst4 = #(plyCoords - coords4)
                if dst4 <= 5.0 then
                    addTargetZone("mich_search4", coords4, "steal-item-four-mich")
                    ItemFourStolen = true
                end
            end
        end
    end)
end)

------------------------------
-- LOCALE STEAL ITEM CHECKS --
------------------------------
local item1Stolen = false
local item2Stolen = false
local item3Stolen = false
local item4Stolen = false

local item_1_Stolen = false
local item_2_Stolen = false
local item_3_Stolen = false
local item_4_Stolen = false

-------------------------------------------------------
-- HANDLES THE ACTUALL STEALING OF ITEMS AT TREVOR'S --
-------------------------------------------------------
RegisterNetEvent("steal-item-one")
AddEventHandler("steal-item-one", function()
    exports['qb-target']:RemoveZone("trev_search1")
    lib.progressBar({
        duration = 2000,
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
        duration = 2000,
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
        duration = 2000,
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
        duration = 2000,
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

--------------------------------------------------------
-- HANDLES THE ACTUALL STEALING OF ITEMS AT MICHAEL'S --
--------------------------------------------------------
RegisterNetEvent("steal-item-one-mich")
AddEventHandler("steal-item-one-mich", function()
    exports['qb-target']:RemoveZone("mich_search1")
    lib.progressBar({
        duration = 2000,
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
    item_1_Stolen = true
    lib.notify({
        title = 'ITEM STOLEN',
        description = 'You stole one item!',
        type = 'success'
    })
end)

RegisterNetEvent("steal-item-two-mich")
AddEventHandler("steal-item-two-mich", function()
    exports['qb-target']:RemoveZone("mich_search2")
    lib.progressBar({
        duration = 2000,
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
    item_2_Stolen = true
    lib.notify({
        title = 'ITEM STOLEN',
        description = 'You stole one item!',
        type = 'success'
    })
end)

RegisterNetEvent("steal-item-three-mich")
AddEventHandler("steal-item-three-mich", function()
    exports['qb-target']:RemoveZone("mich_search3")
    lib.progressBar({
        duration = 2000,
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
    item_3_Stolen = true
    lib.notify({
        title = 'ITEM STOLEN',
        description = 'You stole one item!',
        type = 'success'
    })
end)

RegisterNetEvent("steal-item-four-mich")
AddEventHandler("steal-item-four-mich", function()
    exports['qb-target']:RemoveZone("mich_search4")
    lib.progressBar({
        duration = 2000,
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
    item_4_Stolen = true
    lib.notify({
        title = 'ITEM STOLEN',
        description = 'You stole one item!',
        type = 'success'
    })
end)

----------------------------------------------------------------------------------
-- CHECKS IF ALL ITEMS ARE STOLEN AT MICHAELS AND THEN EXECUTES THE FINAL EVENT --
----------------------------------------------------------------------------------
CreateThread(function()
    local notifyShown = false
    while true do
        Wait(1000)

        if item_1_Stolen and item_2_Stolen and item_3_Stolen and item_4_Stolen and not notifyShown then
            TriggerEvent("smdx-robbery:Finish")
        end
    end
end)

---------------------------------------------------------------------------------------------
-- CHECKS IF ALL ITEMS ARE STOLEN AT TREVOR'S AND THEN EXECUTES THE MICHAEL STEALING EVENT --
---------------------------------------------------------------------------------------------
CreateThread(function()
    local notifyShown = false
    while true do
        Wait(1000)

        if item1Stolen and item2Stolen and item3Stolen and item4Stolen and not notifyShown then
            TriggerEvent("smdx-robbery:MichaelMission")
        end
    end
end)

--------------------------------------------------------
-- GET'S CALLED AFTER STEALING EVERYTHING AT TREVOR'S --
--------------------------------------------------------
RegisterNetEvent("smdx-robbery:MichaelMission")
AddEventHandler("smdx-robbery:MichaelMission", function()
    if not notifyShown then
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
        MichaelMission = true

        CreateThread(function()
            while true do
                Wait(1000)
                local player = PlayerPedId()
                local plyCoords = GetEntityCoords(player)
                local WPCoords = vector3(-817.22, 178.0, 72.23)
                local dst = #(plyCoords - WPCoords)
        
                if dst <= 3.0 then
                    if not secondNotify then
                        lib.notify({
                            title = 'BREAK IN',
                            description = 'Break open the door and keep stealing stuff!',
                            type = 'info'
                        })
                        secondNotify = true
                    end
        
                    if not Door2Unlocked then
                        DoorSystemSetDoorState(doorHash2, 1, false, true)
                        DoorSystemSetDoorState(doorHash3, 1, false, true)
                    else
                        DoorSystemSetDoorState(doorHash2, 0, false, true)
                        DoorSystemSetDoorState(doorHash3, 0, false, true)
                    end
        
                    if not BrokenIn2 and MichaelMission then
                        exports['qb-target']:AddBoxZone("mich_door", vector3(-817.09, 178.03, 71.23), 1.5, 1.6, {
                            name = "mich_door",
                            heading = 12.0,
                            debugPoly = false,
                            minZ = 36.7,
                            maxZ = 38.9,
                        }, {
                            options = {
                                {
                                    num = 1,
                                    type = "client",
                                    event = "break-open-door-two",
                                    icon = 'fas fa-lock',
                                    label = 'Break open the door',
                                    targeticon = 'fas fa-lock',
                                }
                            },
                            distance = 2.5,
                        })
                        BrokenIn2 = true
                    end
                end
            end
        end)
    end
end)

---------------------------------------------------------
-- GET'S CALLED AFTER STEALING EVERYTHING AT MICHAEL'S --
---------------------------------------------------------
RegisterNetEvent("smdx-robbery:Finish")
AddEventHandler("smdx-robbery:Finish", function()
    local notifyShown = false
    local WayPSet = false

    if not notifyShown then
        lib.notify({
            title = 'RETURN',
            description = 'You got everything, now return to the robbery guy to get paid!',
            type = 'success'
        })
        notifyShown = true
    end
    if not WayPSet then
        SetNewWaypoint(1775.56, -1617.45)
        WayPSet = true
    end
end)

----------------
-- START MENU --
----------------
lib.registerContext({
    id = 'rob_menu',
    title = Config.Translate.start_menu.title,
    options = {
        {
            title = Config.Translate.start_menu.btn_title,
            description = Config.Translate.start_menu.btn_desc,
            icon = 'sack-dollar',
            onSelect = function()
            TriggerEvent('smdx-robbery:MissionStarted')
            end,
        },
        {
            title = Config.Translate.start_menu.exit_btn,
            description = Config.Translate.start_menu.exit_desc,
            icon = 'xmark',
            onSelect = function()
                lib.hideContext()
            end,
        }
    }
})

lib.registerContext({
    id = 'rob_end_menu',
    title = Config.Translate.start_menu.title,
    options = {
        {
            title = Config.Translate.start_menu.exit_btn,
            description = Config.Translate.start_menu.exit_desc,
            icon = 'xmark',
            onSelect = function()
                lib.hideContext()
                MissionEnded = true
            end,
        },
    }
})