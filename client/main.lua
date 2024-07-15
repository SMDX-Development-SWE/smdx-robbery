local QBCore = exports['qb-core']:GetCoreObject()

local pedSpawned = false

CreateThread(function()
    while true do
        Wait(1000)

        local ped = Config.PedSettings.model
        local xPlayer = PlayerPedId()
        local playerCoords = GetEntityCoords(xPlayer)
        local pedCoords = Config.PedSettings.coords
        local dst = #(playerCoords - pedCoords)
    end
end)















-- [SPAWN PED] --
local function spawnPed()
    if not pedSpawned then
        CreateRobPed()
        pedSpawned = true
    end
end

CreateThread(function()
    spawnPed()
end)