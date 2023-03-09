fx_version 'bodacious'
game 'gta5'

author 'Mitsu'
contact 'mitsitço.br - Discord: MITSU#3867'
version '1.0.0'

dependency 'vrp'
ui_page 'nui/mitsu.html'

client_scripts{
    '@vrp/lib/utils.lua',
    'charizard.lua',
    'shinyzard.lua',
	'config.lua'
}

server_scripts{
    '@vrp/lib/utils.lua',
    'sceptile.lua',
    'config.lua'
}

files {
	'nui/mitsu.html',
	'nui/mitsu.js',
    'nui/mitsu.css',
	'nui/controle.png'
}