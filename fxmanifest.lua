fx_version 'cerulean'
game 'gta5'
author 'Slime - Registers for QBCore'
version '1.0.0'

client_scripts {
	'config.lua',
	'client.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server.lua'	
}

lua54 'yes'