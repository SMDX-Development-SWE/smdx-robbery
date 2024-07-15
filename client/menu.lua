Citizen.CreateThread(function()
  while true do
      local hasLockpick = exports['qb-inventory']:HasItem("lockpick")

      lib.registerContext({
          id = 'rob_menu',
          title = Config.Translate.start_menu.title,
          options = {
            {
              title = Config.Translate.start_menu.btn_title,
              description = hasLockpick and Config.Translate.start_menu.btn_desc or "You need a lockpick to start the mission.",
              icon = 'sack-dollar',
              disabled = not hasLockpick,
              onSelect = function()
                if hasLockpick then
                  TriggerEvent('smdx-robbery:MissionStarted')
                else
                  TriggerEvent('notification', "You need a lockpick to start this mission.", 2)
                end
              end,
            },
            {
              title = Config.Translate.start_menu.exit_btn,
              description = Config.Translate.start_menu.exit_desc,
              icon = 'xmark',
              onSelect = function()
                return
              end,
            }
          }
      })

      Citizen.Wait(1000)
  end
end)