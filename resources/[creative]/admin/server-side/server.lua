-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("admin",cRP)
vCLIENT = Tunnel.getInterface("admin")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- GEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("gem",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Owner") and parseInt(args[1]) > 0 and parseInt(args[2]) > 0 then
			local ID = parseInt(args[1])
			local Amount = parseInt(args[2])
			local identity = vRP.userIdentity(ID)
			if identity then
				vRP.execute("accounts/infosUpdategems",{ steam = identity["steam"], gems = Amount })
				TriggerClientEvent("Notify",source,"verde","Passaporte: "..ID.." Recebeu: "..Amount.." Gemas",5000)
				TriggerEvent("discordLogs","Gemstones","**Passaporte:** "..ID.."\n**Recebeu:** "..Amount.." Gemas\n**Horário:** "..os.date("%H:%M:%S"),3092790)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("blips",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") then
			vRPC.blipsAdmin(source)
			TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Usou comando:**  blips\n**Horário:** "..os.date("%H:%M:%S"),3092790)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("god",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			if args[1] then
				local nuser_id = parseInt(args[1])
				local otherPlayer = vRP.userSource(nuser_id)
				if otherPlayer then
					vRP.upgradeThirst(nuser_id,100)
					vRP.upgradeHunger(nuser_id,100)
					vRP.downgradeStress(nuser_id,100)
					vRPC.revivePlayer(otherPlayer,200)
					TriggerClientEvent("resetBleeding",source)
					TriggerClientEvent("resetDiagnostic",source)
					TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Usou comando:**  God\n**No player:** "..nuser_id.."\n**Horário:** "..os.date("%H:%M:%S"),3092790)
				end
			else
				vRP.setArmour(source,100)
				vRPC.revivePlayer(source,200)
				vRP.upgradeThirst(user_id,100)
				vRP.upgradeHunger(user_id,100)
				vRP.downgradeStress(user_id,100)
				TriggerClientEvent("resetHandcuff",source)
				TriggerClientEvent("resetBleeding",source)
				TriggerClientEvent("resetDiagnostic",source)
				TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Usou comando:**  God\n**Horário:** "..os.date("%H:%M:%S"),3092790)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("item",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Owner") then
			if args[1] and args[2] and itemBody(args[1]) ~= nil then
				vRP.generateItem(user_id,args[1],parseInt(args[2]),true)
				--TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Usou comando:** /item\n**spawnou:** "..args[2].."x "..args[1].."\n**Horário:** "..os.date("%H:%M:%S"),3092790)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRIORITY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("priority",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(args[1]) > 0 then
		if vRP.hasGroup(user_id,"Owner") then
			local nuser_id = parseInt(args[1])
			local identity = vRP.userIdentity(nuser_id)
			if identity then
				TriggerClientEvent("Notify",source,"verde","Prioridade adicionada.",5000)
				vRP.execute("accounts/setPriority",{ steam = identity["steam"], priority = 99 })
				TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Usou comando:** /priority\n**Adicionou prioridade ao id** "..nuser_id.."\n**Horário:** "..os.date("%H:%M:%S"),3092790)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("delete",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and args[1] then
		if vRP.hasGroup(user_id,"Moderator") then
			local nuser_id = parseInt(args[1])
			vRP.execute("characters/removeCharacters",{ id = nuser_id })
			TriggerClientEvent("Notify",source,"verde","Personagem <b>"..nuser_id.."</b> deletado.",5000)
			TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Usou comando:** /delete\n**Apagou personagem id:** "..nuser_id.."\n**Horário:** "..os.date("%H:%M:%S"),3092790)

		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("nc",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") then
			vRPC.noClip(source)
			TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Usou comando:** /no clip\n**Horário:** "..os.date("%H:%M:%S"),3092790)

		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
local Spectate = false
RegisterCommand("spectate",function(source,args)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			if Spectate then
				Spectate = false
				TriggerClientEvent("admin:resetSpectate",source)
				TriggerClientEvent("Notify",source,"amarelo","Desativado.",5000)
			else
				Spectate = true
				TriggerClientEvent("admin:initSpectate",source)
				TriggerClientEvent("Notify",source,"verde","Ativado.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
local Spectate = {}
RegisterCommand("spectate",function(source,args)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			if Spectate[user_id] then
				TriggerClientEvent("Notify",source,"verde","Desativado.",5000)

				local Ped = GetPlayerPed(Spectate[user_id])
				if DoesEntityExist(Ped) then
					SetEntityDistanceCullingRadius(Ped,0.0)
				end

				TriggerClientEvent("admin:resetSpectate",source)
				Spectate[user_id] = nil
			else
				TriggerClientEvent("Notify",source,"verde","Ativado.",5000)

				local nsource = vRP.userSource(args[1])
				if nsource then
					local Ped = GetPlayerPed(nsource)
					if DoesEntityExist(Ped) then
						SetEntityDistanceCullingRadius(Ped,999999999.0)
						Wait(1000)
						TriggerClientEvent("admin:initSpectate",source,nsource)
						Spectate[user_id] = nsource
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kick",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") and parseInt(args[1]) > 0 then
			TriggerClientEvent("Notify",source,"amarelo","Passaporte <b>"..args[1].."</b> expulso.",5000)
			TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Usou comando:** /kick\n**chutou a bunda do id:** "..args[1].."\n**Horário:** "..os.date("%H:%M:%S"),3092790)
			vRP.kick(args[1],"Expulso da cidade.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ban",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") and parseInt(args[1]) > 0 and parseInt(args[2]) > 0 then
			local time = parseInt(args[2])
			local nuser_id = parseInt(args[1])
			local identity = vRP.userIdentity(nuser_id)
			if identity then
				vRP.kick(nuser_id,"Banido.")
				vRP.execute("banneds/insertBanned",{ steam = identity["steam"], time = time })
				TriggerClientEvent("Notify",source,"amarelo","Passaporte <b>"..nuser_id.."</b> banido por <b>"..time.." dias.",5000)
				TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Usou comando:** /Ban\n**Rasgou o Passaporte do id:** "..nuser_id.."\n**tempo:** "..time.." dias.\n**Horário:** "..os.date("%H:%M:%S"),3092790)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unban",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") and parseInt(args[1]) > 0 then
			local nuser_id = parseInt(args[1])
			local identity = vRP.userIdentity(nuser_id)
			if identity then
				vRP.execute("banneds/removeBanned",{ steam = identity["steam"] })
				TriggerClientEvent("Notify",source,"verde","Passaporte <b>"..nuser_id.."</b> desbanido.",5000)
				TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Removeu Banimento**\n**id:** "..nuser_id.."\n**Horário:** "..os.date("%H:%M:%S"),3092790)

			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpcds",function(source)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasGroup(user_id,"Moderator") then
			local Keyboard = vKEYBOARD.keySingle(source,"Cordenadas:")
			if Keyboard then
				local Split = splitString(Keyboard[1],",")
				vRP.teleport(source,Split[1] or 0,Split[2] or 0,Split[3] or 0)
				TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Usou comando:** /tpcds\n**foi para :**"..fcoords.."\n**Horário:** "..os.date("%H:%M:%S"),3092790)
			end
       	end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cds",function(source)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") then
			local Ped = GetPlayerPed(source)
			local coords = GetEntityCoords(Ped)
			local heading = GetEntityHeading(Ped)
			TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Usou comando:** /cds\n**coordenadas :**"..coords.."\n**Horário:** "..os.date("%H:%M:%S"),3092790)
			vKEYBOARD.keyCopy(source,"Cordenadas:",mathLegth(coords["x"])..","..mathLegth(coords["y"])..","..mathLegth(coords["z"])..","..mathLegth(heading))
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("group",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if (args[2] == "Owner" and not vRP.hasGroup(user_id,"Owner")) then return end
		if vRP.hasGroup(user_id,"Admin") and parseInt(args[1]) > 0 and args[2] then
			TriggerClientEvent("Notify",source,"verde","Adicionado <b>"..args[2].."</b> ao passaporte <b>"..args[1].."</b>.",5000)
			TriggerEvent("discordLogs","group","**Passaporte:** "..user_id.."\n**Setou o passaporte :** "..args[1].." no Grupo** "..args[2].."**\n**Horário:** "..os.date("%H:%M:%S"),3092790)
			vRP.setPermission(args[1],args[2])
		end

	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ungroup",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") and parseInt(args[1]) > 0 and args[2] then
			TriggerClientEvent("Notify",source,"verde","Removido <b>"..args[2].."</b> ao passaporte <b>"..args[1].."</b>.",5000)
			TriggerEvent("discordLogs","ungroup","**Passaporte:** "..user_id.."\n**Removeu a permissão :** "..args[2].." do id** "..args[1].."**\n**Horário:** "..os.date("%H:%M:%S"),3092790)
			vRP.remPermission(args[1],args[2])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tptome",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") and parseInt(args[1]) > 0 then
			local otherPlayer = vRP.userSource(args[1])
			if otherPlayer then
				local ped = GetPlayerPed(source)
				local coords = GetEntityCoords(ped)
				TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Puxou o id:** "..args[1].."\n**Horário:** "..os.date("%H:%M:%S"),3092790)
				vRP.teleport(otherPlayer,coords["x"],coords["y"],coords["z"])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpto",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") and parseInt(args[1]) > 0 then
			local otherPlayer = vRP.userSource(args[1])
			if otherPlayer then
				local ped = GetPlayerPed(otherPlayer)
				local coords = GetEntityCoords(ped)
				TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Teleportou até o id:** "..args[1].."\n**Horário:** "..os.date("%H:%M:%S"),3092790)
				vRP.teleport(source,coords["x"],coords["y"],coords["z"])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpway",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") then
			vCLIENT.teleportWay(source)
			--TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Usou Tpway**\n**Horário:** "..os.date("%H:%M:%S"),3092790)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limbo",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and vRP.getHealth(source) <= 101 then
			vCLIENT.teleportLimbo(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hash",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			local vehicle = vRPC.vehicleHash(source)
			if vehicle then
				print(vehicle)
				vKEYBOARD.keyCopy(source,"Hash:",vehicle)
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tuning",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			TriggerClientEvent("admin:vehicleTuning",source)
			TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Usou /tuning:** \n**Horário:** "..os.date("%H:%M:%S"),3092790)

		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fix",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasGroup(user_id,"Admin") then
            local vehicle,vehNet,vehPlate,vehiclex = vRPC.vehList(source,10)
            if vehicle then
                local activePlayers = vRPC.activePlayers(source)
                for _,v in ipairs(activePlayers) do
                    async(function()
                        TriggerClientEvent("inventory:repairAdmin",v,vehNet,vehPlate)
                        TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Usou /fix:** em um "..vehiclex.." \n**placas:** "..vehPlate.." \n**Horário:** "..os.date("%H:%M:%S"),3092790)
                    end)
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limparea",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)

			local activePlayers = vRPC.activePlayers(source)
			for _,v in ipairs(activePlayers) do
				async(function()
					TriggerClientEvent("syncarea",v,coords["x"],coords["y"],coords["z"],100)
					TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Usou /limparea** \n**coords: "..coords.."** \n**Horário:** "..os.date("%H:%M:%S"),3092790)
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("players",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") then
			TriggerClientEvent("Notify",source,"azul","<b>Jogadores Conectados:</b> "..GetNumPlayerIndices(),5000)
			TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**Usou /players** \n**Jogadores Conectados: "..GetNumPlayerIndices().."** \n**Horário:** "..os.date("%H:%M:%S"),3092790)

		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.buttonTxt()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)

			vRP.updateTxt(user_id..".txt",mathLegth(coords.x)..","..mathLegth(coords.y)..","..mathLegth(coords.z)..","..mathLegth(heading))
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("announce",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") and args[1] then
			TriggerClientEvent("chatME",-1,"^6ALERTA^9Governador^0"..rawCommand:sub(9))
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSOLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("console",function(source,args,rawCommand)
	if source == 0 then
		TriggerClientEvent("chatME",-1,"^6ALERTA^9Governador^0"..rawCommand:sub(9))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICKALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kickall",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if source == 0 then
		local playerList = vRP.userList()
		for k,v in pairs(playerList) do
			vRP.kick(k,"Desconectado, você foi vitima da tempestade.")
			Citizen.Wait(100)
		end

		TriggerEvent("admin:KickAll")
		
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMALL
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand("itemall",function(source,args,rawCommand)
-- 	local user_id = vRP.getUserId(source)
-- 	if user_id then
-- 		if vRP.hasGroup(user_id,"Admin") then
-- 			local playerList = vRP.userList()
-- 			for k,v in pairs(playerList) do
-- 				async(function()
-- 					vRP.generateItem(k,tostring(args[1]),parseInt(args[2]),true)
-- 				end)
-- 			end

-- 			TriggerClientEvent("Notify",source,"verde","Envio concluído.",10000)
			
-- 		end
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- status
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("status",function(source,args,rawCommand)
    if exports["chat"]:statusChat(source) then
        local source = source
        local user_id = vRP.getUserId(source)
        if user_id then
            if vRP.hasGroup(user_id,"Admin") then
                local service1 = {}
                local service1qtd = 0
                local service2 = {}
                local service2qtd = 0
                local service3 = {}
                local service3qtd = 0
				local service4 = {}
                local service4qtd = 0
                local onDuty1 = "<b> Police:</b> "
                local onDuty2 = "<b> Paramedic:</b> "
                local onDuty3 = "<b> Bennys:</b> "
				local onDuty4 = "<b> LosSantos:</b> "
    
                service1 = vRP.numPermission("Police")
                service2 = vRP.numPermission("Paramedic")
                service3 = vRP.numPermission("Mechanic")
				service4 = vRP.numPermission("LosSantos")
    
                for k,v in pairs(service1) do
                    local nuser_id = vRP.getUserId(v)
                    if nuser_id then
                        if k ~= #service1 then
                            onDuty1 = onDuty1..nuser_id..", "
                        else
                            onDuty1 = onDuty1..nuser_id
                        end
                    end
                    service1qtd = #service1
                end
              --  TriggerClientEvent("Notify",source,"azul",onDuty1.." <b>Quantidade:</b> "..service1qtd.."</br>".. onDuty2.." <b>Quantidade:</b> "..service2qtd.."</br>"..onDuty3.." <b>Quantidade:</b> "..service3qtd.."</br>"..onDuty4.." <b>Quantidade:</b> "..service4qtd,15000)

                for k,v in pairs(service2) do
                    local nuser_id = vRP.getUserId(v)
                    if nuser_id then
                        if k ~= #service2 then
                            onDuty2 = onDuty2..nuser_id..", "
                        else
                            onDuty2 = onDuty2..nuser_id
                        end
                    end
                    service2qtd = #service2
                end
               -- TriggerClientEvent("Notify",source,"azul",onDuty2.." <b>Quantidade:</b> "..service2qtd,15000)

                for k,v in pairs(service3) do
                    local nuser_id = vRP.getUserId(v)
                    if nuser_id then
                        if k ~= #service3 then
                            onDuty3 = onDuty3..nuser_id..", "
                        else
                            onDuty3 = onDuty3..nuser_id
                        end
                    end
                    service3qtd = #service3
                end
                --TriggerClientEvent("Notify",source,"azul",onDuty3.." <b>Quantidade:</b> "..service3qtd,15000)

				for k,v in pairs(service4) do
                    local nuser_id = vRP.getUserId(v)
                    if nuser_id then
                        if k ~= #service4 then
                            onDuty4 = onDuty4..nuser_id..", "
                        else
                            onDuty4 = onDuty4..nuser_id
                        end
                    end
                    service4qtd = #service4
                end
               -- TriggerClientEvent("Notify",source,"azul",onDuty4.." <b>Quantidade:</b> "..service4qtd,15000)
                TriggerClientEvent("Notify",source,"azul",onDuty1.." <b>Quantidade:</b> "..service1qtd.."</br>".. onDuty2.." <b>Quantidade:</b> "..service2qtd.."</br>"..onDuty3.." <b>Quantidade:</b> "..service3qtd.."</br>"..onDuty4.." <b>Quantidade:</b> "..service4qtd,35000)

                local users = vRP.userList()
                local players = ""
                local quantidade = 0
                for k,v in pairs(users) do
                    if k ~= #users then
                        players = players..", "
                    end
                    players = players..k
                end

                TriggerClientEvent("Notify",source,"azul","<b>Jogadores Conectados:</b> "..GetNumPlayerIndices(),35000)
                TriggerClientEvent("Notify",source,"azul","<b>Ids Conectados:</b> "..players,35000)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MENSAGEM DISCORD QUANO SERVIDOR TA ONLINE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    PerformHttpRequest("webhookaqui", function(err, text, headers) end, 'POST', json.encode({
        content = '||@everyone||',
        embeds = {
            {
                description = '** ✅ CIDADE ONLINE: **\n\n🚀 Abra seu FiveM, utilize F8 e use o seguinte comando: \n\n ```connect cfx.re/join/o3xxd7``` \n\n 😋 - siga nosso instagram: https://www.instagram.com/imersivosrp\n\n🤩 - Nosso Tiktok: https://www.tiktok.com/@imersivosrp',
                color = 2723266 -- Se quiser mudar a cor é aqui
            }
        }
    }), { ['Content-Type'] = 'application/json' })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MENSAGEM PARAMÉDICO
-----------------------------------------------------------------------------------------------------------------------------------------
local emergencyTexts = {
	{ "Necessito de ajuda, uma pessoa está ferida gravemente e perdendo muito sangue." }	
}
RegisterNetEvent("help:Paramedic")
AddEventHandler("help:Paramedic",function()

local ped = GetPlayerPed(source)
local coords = GetEntityCoords(ped)
local user_id = vRP.getUserId(source)
local identity = vRP.userIdentity(user_id)
local playerName = identity.name .. " " .. identity.name2


	local paramedicResult = vRP.numPermission("Paramedic")
	if parseInt(#paramedicResult) >= 1 then
		for k,v in pairs(paramedicResult) do
			async(function()
				vRPC.playSound(v,"Event_Start_Text","GTAO_FM_Events_Soundset")
				TriggerClientEvent("NotifyPush",v,{ code = 50, title = "PARAMÉDICOS", x = coords["x"], y = coords["y"], z = coords["z"], vehicle = emergencyTexts, criminal = playerName, time = "Recebido às "..os.date("%H:%M"), blipColor = 16 })
			end)
		end
		TriggerClientEvent("Notify",source,"amarelo","Os paramédicos foram notificados. Aguarde uma ambulância chegar até você.",15000)
	else
		TriggerClientEvent("Notify",source,"amarelo","Não existem Médicos em serviço use <b>/paramedico</b>.",15000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MENSAGEM PARAMÉDICO
-----------------------------------------------------------------------------------------------------------------------------------------
local mechanicTexts = {
	{ "Necessito de um guincho, meu veículo está danificado." }	
}
RegisterNetEvent("help:Mechanic")
AddEventHandler("help:Mechanic",function()

local ped = GetPlayerPed(source)
local coords = GetEntityCoords(ped)
local user_id = vRP.getUserId(source)
local identity = vRP.userIdentity(user_id)
local playerName = identity.name .. " " .. identity.name2


	local mechanicResult = vRP.numPermission("Mechanic") or vRP.numPermission("LosSantos") 
	if parseInt(#mechanicResult) >= 1 then
		for k,v in pairs(mechanicResult) do
			async(function()
				vRPC.playSound(v,"Event_Start_Text","GTAO_FM_Events_Soundset")
				TriggerClientEvent("NotifyPush",v,{ code = 50, title = "MECÂNICOS", x = coords["x"], y = coords["y"], z = coords["z"], vehicle = mechanicTexts, criminal = playerName, time = "Recebido às "..os.date("%H:%M"), blipColor = 16 })
			end)
		end
		TriggerClientEvent("Notify",source,"amarelo","Os Mecânicos foram notificados. Aguarde um guincho chegar até você.",15000)
	else
		TriggerClientEvent("Notify",source,"amarelo","Infelizmente seu chamado não será atendido. Sistema indisponível no momento.",15000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- IMORTAL
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.isAdmin()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id, "Admin") then
			TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**usou /imortal** \n**Horário:** "..os.date("%H:%M:%S"),3092790)
            return true
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELNPCS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("delnpcs",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			vCLIENT.deleteNpcs(source)
			TriggerClientEvent("Notify",source,"amarelo","NPCs próximos deletados.",3000)
			TriggerEvent("discordLogs","Admin","**Passaporte:** "..user_id.."\n**usou /delnpcswwwww** \n**Horário:** "..os.date("%H:%M:%S"),3092790)
		end
	end
end)
