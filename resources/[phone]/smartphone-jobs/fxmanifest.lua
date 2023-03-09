fx_version 'adamant'
game 'gta5'

shared_script '@vrp/lib/utils.lua'

server_scripts {
  'server/*'
}

client_scripts {
  'client/*'
}

files {
  'build/**/*',
  'config.json',
}