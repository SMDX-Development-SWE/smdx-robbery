fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'SMDX Development'
description 'A robbery script created by SMDX Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/menu.lua',
    'client/events.lua',
    'client/functions.lua',
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

dependency {
    'ox_lib'
}