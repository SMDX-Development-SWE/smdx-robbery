local QBCore = exports['qb-core']:GetCoreObject()

local pedSpawned = false
local spawnPed = Config.PedSettings.enabled

if spawnPed and not pedSpawned then
    CreatePed()
    pedSpawned = true
end