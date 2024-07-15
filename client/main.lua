local QBCore = exports['qb-core']:GetCoreObject()

local pedSpawned = false

















-- [SPAWN PED] --
local function spawnPed()
    if not pedSpawned then
        CreateRobPed()
        pedSpawned = true
    end
end

Citizen.CreateThread(function()
    spawnPed()
end)