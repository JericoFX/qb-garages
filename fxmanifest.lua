fx_version 'cerulean'
game 'gta5'

description 'FX GARAGE'
version '1.0.2'
author 'JericoFX'
ui_page 'html/index.html'

client_scripts {
    'GaragesConfig.lua', 'client/functions.lua',
    'client/client.lua'
}

shared_script 'config.lua'

server_scripts {'GaragesConfig.lua','server/server.lua'}
files {
    'html/index.html', 'html/js/*.js', 'html/css/*.css', 'html/fonts/*.css',
    'html/icons/*.css'
}

