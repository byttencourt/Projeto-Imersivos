config = {}

config.Token      = "seu token de usuário"
config.LicenseKey = "sua chave de licença"

config.ipimages   = {
    items    = "http://191.96.78.187/images/",        --link images itens
    vehicles = "http://191.96.78.187/images/cars/",     --link images vehicles
    skins    = "http://191.96.78.187/images/",    --link images skins
}

config.percentage = { --percentage to add itens in list
    rare    = 20,
    special = 5,
    common  = 75,
}

config.buycoins = {
    active = false,          --active button buy
    link   = ""    --link button buy
}

config.blips = { --blips to open painel
    { ['x'] = 159.23, ['y'] = -960.03, ['z'] = 30.1, ['title'] = "Pressione [~r~E~w~] para acessar a ~r~ROLETA DE ITENS~w~" }
}

config.boxes = { --boxes to open
    { index = "special", title = "", price = 10, image = "https://media.discordapp.net/attachments/852363864406360104/1008572270727397479/BOX_RARO.png" },
    { index = "weapons", title = "", price = 30, image = "https://media.discordapp.net/attachments/852363864406360104/1008572270341541918/BOX_EPICO.png" },
    { index = "vehicles", title = "", price = 50, image = "https://media.discordapp.net/attachments/852363864406360104/1008572269926297620/BOX_LENDARIA.png" }
}

config.permissions = { --staff permission
    "Admin"
}

config.webhooks = {
    setcoins   = "", --webhook log commmand setcoins
    addcoins   = "", --webhook log commmand addcoins
    remcoins   = "", --webhook log commmand remcoins
    bonuscoins = "", --webhook log commmand bonuscoins
    reward     = "", --webhook log give item
    online     = "", --webhook log bonus online
    redeem     = "", --webhook log redeem item
    giveback   = "", --webhook log give-back item
    painel     = "", --webhook log actions painel
    icon       = "",
    color      = 15906321
}

config.testdrive = {
    time        = 45,   --time testdrive
    maxDistance = 310,  --max distance to player to move
    places      = {     --locations testdrive
		{ coords = vec3(-11.25,-1080.46,26.68), h = 129.4 },
		{ coords = vec3(-14.11,-1079.84,26.67), h = 122.02 },
		{ coords = vec3(-16.43,-1078.62,26.67), h = 126.74 },
		{ coords = vec3(-8.45,-1081.58,26.67), h = 117.45 },
    }
}

config.onlinetime = {   --bonus online
    active = true,     --active
    time   = 30,        --time in minutes
    amount = 1        --amount reward
}

return config

--PEQUELSOM PARA DE VENDER BGL CONVERTIDO PELO MENOS DER SUPORTE!!!
--cRP.M4 da https://discord.gg/klauscommunity