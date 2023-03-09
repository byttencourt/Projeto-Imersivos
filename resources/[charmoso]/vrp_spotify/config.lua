cfg = {}

cfg.distanceToVolume = 100.0 -- A distância que ficará com o volume em 1,0, então se o volume for 0,5 a distância será 15,0, se o volume for 0,2 a distância será 6. 
cfg.dlayToEveryone = true -- A música no carro será tocada para todos? Ou apenas para as pessoas que estão nesse veículo? Se false, o Distance Volume não fará nada
cfg.dommandVehicle = "som" 
cfg.permissao = "Admin"
cfg.zones = {
	-- {
	-- 	name = "Mechanic Zone", -- The name of the radio, it doesn't matter
	-- 	coords = vector3(836.47,-813.12,26.34), -- the position where the music is played
	-- 	job = "Admin", --the job that can change the music
	-- 	range = 30.0, -- the range that music can be heard
	-- 	volume = 0.05, --default volume? min 0.00, max 1.00
	-- 	deflink = "https://www.youtube.com/watch?v=xKmHQ6H1wwE",-- the default link, if nill it won't play nothing
	-- 	isplaying = true, -- will the music play when the server start?
	-- 	loop = true,-- when does the music stop it will repaeat?
	-- 	deftime = 0, -- where does the music starts? 0 and it will start in the beginning
	-- 	changemusicblip = vector3(826.51,-802.76,26.34) -- where the player can change the music
	-- },
	-- {
	-- 	name = "Caio Perico", -- The name of the radio, it doesn't matter
	-- 	coords = vector3(4891.53,-4925.01,3.37), -- the position where the music is played
	-- 	job = "Admin", --the job that can change the music
	-- 	range = 30.0, -- the range that music can be heard
	-- 	volume = 0.10, --default volume? min 0.00, max 1.00
	-- 	deflink = "https://youtu.be/xKmHQ6H1wwE",-- the default link, if nill it won't play nothing
	-- 	isplaying = true, -- will the music play when the server start?
	-- 	loop = true,-- when does the music stop it will repaeat?
	-- 	deftime = 0, -- where does the music starts? 0 and it will start in the beginning
	-- 	changemusicblip = vector3(4893.54,-4907.76,3.37) -- where the player can change the music
	-- },
	{
		name = "Vanilla Zone", -- The name of the radio, it doesn't matter
		coords = vector3(116.57,-1287.63,28.27), -- the position where the music is played
		job = "Admin", --the job that can change the music
		range = 30.0, -- the range that music can be heard
		volume = 0.05, --default volume? min 0.00, max 1.00
		deflink = "https://www.youtube.com/watch?v=W9iUh23Xrsg",-- the default link, if nill it won't play nothing
		isplaying = true, -- the music will play when the server start?
		loop = false,-- when the music stops it will repaeat?
		deftime = 0, -- where does the music starts? 0 and it will start in the beginning
		changemusicblip = vector3(120.54,-1281.46,29.49) -- where the player can change the music
	},
}