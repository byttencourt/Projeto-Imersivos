function ExtractIdentifiers(src)
    
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

local logs = "https://discord.com/api/webhooks/973383236854087700/cRYHEO03-k1kVfzAOHIL4cBO8iokGUrcPn2eBX5CCNYKVwKs7A7VENN1XB2zpAnK-tW2"

local kick_msg = "Pau no seu cú! Foi pego usando DevTools."
local discord_msg = '`Jogador tentando usar nui_devtools`\n`o mesmo recebeu um kick pelo `\n`ANTI NUI_DEVTOOLS`'
local color_msg = 16767235

function sendToDiscord (source,message,color,identifier)
    
    local name = GetPlayerName(source)
    if not color then
        color = color_msg
    end
    local sendD = {
        {
            ["color"] = color,
            ["title"] = message,
            ["description"] = "`Player`: **"..name.."**\nSteam: **"..identifier.steam.."** \nIP: **"..identifier.ip.."**\nDiscord: **"..identifier.discord.."**\nFivem: **"..identifier.license.."**",
            ["footer"] = {
                ["text"] = "© QamarQ & vjuton - "..os.date("%x %X %p")
            },
        }
    }

    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "Anti nui_devtools", embeds = sendD}), { ['Content-Type'] = 'application/json' })
end


RegisterServerEvent(GetCurrentResourceName())
AddEventHandler(GetCurrentResourceName(), function()
    local _source = source
    local identifier = ExtractIdentifiers(_source)
    local identifierDb
    if extendedVersionV1Final then
        identifierDb = identifier.license
    else
        identifierDb = identifier.steam
    end
    if checkmethod == 'steam' then
	if json.encode(allowlist) == "[]" then
	   sendToDiscord (_source, discord_msg, color_msg,identifier)
           DropPlayer(_source, kick_msg)		
	end
	for _, v in pairs(allowlist) do
           if v ~= identifierDb then
	      sendToDiscord (_source, discord_msg, color_msg,identifier)
              DropPlayer(_source, kick_msg)
           end
        end
     elseif checkmethod == 'SQL' then
        MySQL.Async.fetchAll("SELECT group FROM users WHERE identifier = @identifier",{['@identifier'] = identifierDb }, function(results) 
            if results[1].group ~= 'Owner' then
               sendToDiscord (source, discord_msg, color_msg,identifier)
               DropPlayer(source, kick_msg)
            end
        end)
     end
end)