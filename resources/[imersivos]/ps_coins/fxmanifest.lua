fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

client_scripts {
	'@vrp/lib/utils.lua',
	'config.lua',
	'client/weapons.lua',
	'client/cl_main.lua'
}

server_scripts {
	'@vrp/lib/utils.lua',
	'config.lua',
	'server/functions.lua',
	'server/sv_main.lua'
}

files {
	'html/*.html',
	'html/**/*.html',
	'html/js/*',
	'html/css/*',
	'html/**/*',
}