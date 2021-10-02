fx_version 'cerulean'
game 'gta5'

description 'FX GARAGE'
version '1.0.0'
author 'JericoFX'
ui_page 'html/index.html'

client_scripts {  '@PolyZone/client.lua',
'@PolyZone/BoxZone.lua','client/zones.lua','client/client.lua'}

shared_script {'@qb-core/import.lua', 'config.lua'}

server_script 'server/server.lua'

files { -- Credits to https://github.com/LVRP-BEN/bl_coords for clipboard copy method
    'html/index.html', 'html/js/*.js', 'html/css/*.css', 'html/fonts/*.css',
    'html/icons/*.css'
}

