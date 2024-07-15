local QBCore = exports['qb-core']:GetCoreObject()

------------------
-- [CREATE PED] --
------------------
function CreateRobPed()
    if not Config.PedSettings["enabled"] then
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

    local RobPed = CreatePed(0, pedModel, pedCoords, pedHeading, false, false)
    FreezeEntityPosition(RobPed, true)
    SetEntityInvincible(RobPed, true)

    exports['qb-target']:AddTargetEntity(RobPed, {
        options = {
            {
                type = "client",
                event = "talk-rob-ped",
                icon = "fas fa-user",
                label = Config.Translate.target.talk_to_ped
            },
        },
        distance = 2.0
    })
end

function AddBlip()
    local enabled = Config.BlipSettings.enabled
    if not enabled then
        return
    end
    local settings = Config.BlipSettings
    local blip = AddBlipForCoord(settings["coords"])
    SetBlipSprite(blip, settings["sprite"])
    SetBlipDisplay(blip, settings["display"])
    SetBlipScale(blip, settings["scale"])
    SetBlipColour(blip, settings["color"])
    SetBlipAsShortRange(blip, settings["shortRange"])
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(settings["label"])
    EndTextCommandSetBlipName(blip)
end