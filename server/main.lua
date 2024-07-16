local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("smdx-robbery:missionDone")
AddEventHandler("smdx-robbery:missionDone", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local amount = Config.RewardAmount

    Player.Functions.AddMoney('cash', amount, 'robbery-reward')
end)