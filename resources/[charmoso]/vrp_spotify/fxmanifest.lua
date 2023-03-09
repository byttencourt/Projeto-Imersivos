fx_version 'cerulean'
games { 'gta5' }

ui_page 'nui/index.html'

client_scripts {
	'@vrp/lib/utils.lua',
  	'config.lua',
  	'client.lua',
}

files {
	'nui/index.html',
	'nui/script.js',
	'nui/*.png',
	'nui/radio.png',
	'nui/main.css',
}

server_scripts {
	'@vrp/lib/utils.lua',
  	'config.lua',
  	'server.lua',
}