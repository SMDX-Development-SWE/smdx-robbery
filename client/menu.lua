local QBCore = exports['qb-core']:GetCoreObject()

lib.registerContext({
  id = 'rob_menu',
  title = Config.Translate.start_menu.title,
  options = {
      {
          title = Config.Translate.start_menu.btn_title,
          description = Config.Translate.start_menu.btn_desc,
          icon = 'sack-dollar',
          onSelect = function()
            TriggerEvent('smdx-robbery:MissionStarted')
          end,
      },
      {
          title = Config.Translate.start_menu.exit_btn,
          description = Config.Translate.start_menu.exit_desc,
          icon = 'xmark',
          onSelect = function()
              lib.hideContext()
          end,
      }
  }
})