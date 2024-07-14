local QBCore = exports['qb-core']:GetCoreObject()

local pedSpawned = false

---------------
-- SPAWN PED --
---------------
local function spawnPed()
    if not pedSpawned then
        CreatePed()
        pedSpawned = true
    end
end