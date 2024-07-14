local QBCore = exports['qb-core']:GetCoreObject()

function CreatePed()
    if not Config.PedSettings.enabled then
        return
    end
    local settings = Config.PedSettings
    local pedModel = settings["model"]
    local pedCoords = settings["coords"]
    local pedHeading = settings["heading"]

    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(0)
    end

    local Ped = CreatePed(0, pedModel, pedCoords, pedHeading, false, false)
    FreezeEntityPosition(Ped, true)
    SetEntityInvincible(Ped, true)
end