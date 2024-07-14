local QBCore = exports['qb-core']:GetCoreObject()

local function spawnPed(model, coords, heading)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local ped = CreatePed(4, model, coords.x, coords.y, coords.z, heading, false, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetPedFleeAttributes(ped, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped, true)
end

AddEventHandler('onClientMapStart', function()
    local pedConfig = Config.Ped
    local model = GetHashKey(pedConfig.model)

    spawnPed(model, pedConfig.coords, pedConfig.heading)
end)