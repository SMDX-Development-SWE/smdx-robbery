# smdx-robbery
- This is a simple and easy robbery script, made for the QBCore framework by SMDX Development.

# Latest Update
- Script creation completed!

# Upcoming
- Support for ps-dispatch

# Dependencies
- ox_lib
- ox_target

# Installation
- Drag smdx-robbery into your resource folder.
- in your server.cfg, add "ensure smdx-robbery"
- Make sure you have all dependencies installed on your server.
- You are good to go!

# ps-dispatch compatibility
If you want to use ps-dispatch, you need to follow the steps below:
- In your client/alerts.lua in ps-dispatch you need to add this code:
```
local function RobberyAlert()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('robberyalert'), -- add this into your locale
        codeName = 'robberyalert', -- this should be the same as in config.lua
        code = '10-35',
        icon = 'fas fa-gun',
        priority = 2,
        coords = coords,
        street = GetStreetAndZone(coords),
        heading = GetPlayerHeading(),
        alertTime = nil,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('RobberyAlert', RobberyAlert)
```
You also need to add this code into shared/config.lua in the Config.Blips section in ps-dispatch:
```
['robberyalert'] = {
        radius = 0,
        sprite = 207,
        color = 1,
        scale = 1.2,
        length = 2,
        sound = 'Lose_1st',
        sound2 = 'GTAO_FM_Events_Soundset',
        offset = false,
        flash = false
    },
```
And finally you need to add this code into ps-dispatch/locales/en.json:
```
"robberyalert": "Robbery Attempt",
```

# contact
- Discord: https://discord.gg/9KbbPvUmq3