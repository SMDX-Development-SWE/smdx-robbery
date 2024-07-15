RegisterNetEvent('talk-rob-ped')
AddEventHandler('talk-rob-ped', function()
    -- Your interaction logic here
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0 },
        multiline = true,
        args = {"Security Guard", "How can I help you?"}
    })
end)