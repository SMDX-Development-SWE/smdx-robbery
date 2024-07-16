local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("smdx-robbery:missionDone")
AddEventHandler("smdx-robbery:missionDone", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local amount = Config.RewardAmount
    local rewardtype = Config.RewardType

    Player.Functions.AddMoney(rewardtype, amount, 'robbery-reward')
    if Config.UseItemRewards then
        for _, item in ipairs(Config.RewardItems) do
            Player.Functions.AddItem(item, 1)
        end
    end
end)