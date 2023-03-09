-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
arc = {}
Tunnel.bindInterface("arcade_restaurant",arc)
vCLIENT = Tunnel.getInterface("arcade_restaurant")

local invoices = {}
local cooldown = {}

RegisterServerEvent("restaurant:register")
AddEventHandler("restaurant:register",function(resName)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id and config["restaurant"][resName] and vRP.hasGroup(user_id,config["restaurant"][resName]["perm"]) then
        invoices[resName] = {}
        local price = vKEYBOARD.keySingle(source,"Valor:")[1]
        if price and tonumber(price) > 0 then
            invoices[resName]["price"] = tonumber(price)
            invoices[resName]["registred"] = source
            invoices[resName]["cobrador"] = user_id
            invoices[resName]["estabelecimento"] = resName
			TriggerClientEvent("Notify",source,"azul","Fatura registrada no valor de: "..price,5000)
        end
    end
end)

RegisterServerEvent("restaurant:payment")
AddEventHandler("restaurant:payment",function(resName)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if invoices[resName] and invoices[resName]["price"] and invoices[resName]["registred"] and config["restaurant"][resName] and config["restaurant"][resName]["owner"] then
            local ok = vRP.request(source,"Deseja pagar a fatura no valor de: "..invoices[resName]["price"].." ?")
            if ok and invoices[resName] then
                if vRP.paymentFull(user_id,invoices[resName]["price"]) then
                    TriggerClientEvent("Notify",source,"verde","Fatura paga com sucesso!",5000)

                    if invoices[resName]["estabelecimento"] == "BlazeIt" then
                        vRP.addBank(config["restaurant"][resName]["owner"],invoices[resName]["price"] * 0.4,"Private")
                        vRP.addBank(invoices[resName]["cobrador"],invoices[resName]["price"] * 0.6,"Private")
                    else
                        vRP.addBank(config["restaurant"][resName]["owner"],invoices[resName]["price"],"Private")
                    end
                    
                    TriggerClientEvent("Notify",invoices[resName]["registred"],"amarelo","Fatura registrada foi paga!",5000)
                    invoices[resName] = nil
                else
                    TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente!",5000)
                end
            end
        end
    end
end)

function arc.Chamar(grupo,estabelecimento)
    local source = source
	local user_id = vRP.getUserId(source)
    local numberIdentity = parseInt(user_id)
	local identity = vRP.userIdentity(numberIdentity)

    local result = vRP.getUsersByPermission2(grupo)

    if cooldown[user_id] then
        if GetGameTimer() < cooldown[user_id] then
            local cooldown = parseInt((cooldown[user_id] - GetGameTimer()) / 1000)
            TriggerClientEvent("Notify",source,"vermelho","Aguarde <b>"..cooldown.." segundos</b>.",5000)
            return
        end
    end
    
    cooldown[user_id] = GetGameTimer() + 300000
    for k,v in pairs(result) do
        async(function()
            TriggerClientEvent("Notify",v,"verde","Um cliente chegou ao "..estabelecimento..".<br> <b>Nome</b>: "..identity["name"].." "..identity["name2"].."<br> <b>Telefone</b>: "..identity["phone"].."",60000,left)
            vRPC.playSound(v,"Beep_Red","DLC_HEIST_HACKING_SNAKE_SOUNDS")
        end)
    end
end

function arc.Disponivel(grupo)
    local source = source
    local result = vRP.getUsersByPermission2(grupo)
    if parseInt(#result) < 1 then
        return false
    else
        return true
    end
end

function arc.Cooldown()
    local source = source
    local user_id = vRP.getUserId(source)
    if cooldown[user_id] ~= nil then
        return true
    else
        return false
    end
end