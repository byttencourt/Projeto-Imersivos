getUserSource = function(user_id)
    return vRP.userSource(tonumber(user_id))
end

getUserId = function(source)
    return vRP.getUserId(source)
end

getUserIdentity = function(user_id)
    return vRP.userIdentity(user_id)
end

getUserFullName = function(user_id)
    local identity = getUserIdentity(user_id)
    local name = identity.name.." "..identity.name2
    return name
end

getUsers = function()
    return vRP.getUsers()
end

getHasPermission = function(user_id, perm)
    return vRP.hasPermission(user_id,perm)
end

getCoins = function(user_id)
    local identity = getUserIdentity(user_id)
    return vRP.userGemstone(identity["steam"]) or 0
end

setCoins = function(user_id, amount)
    local identity = getUserIdentity(user_id)
    vRP.execute("accounts/setGems",{ steam = identity["steam"], gems = amount })
end

addCoins = function(user_id, amount)
    local identity = getUserIdentity(user_id)
    vRP.execute("accounts/infosUpdategems",{ steam = identity["steam"], gems = amount })
end

removeCoins = function(user_id, amount)
    local identity = getUserIdentity(user_id)
    vRP.execute("accounts/removeGems",{ steam = identity["steam"], gems = amount })
end

paymentCoins = function(user_id, amount)
    if amount >= 0 then
		local coins = getCoins(user_id)
		if amount >= 0 and coins >= amount then
            removeCoins(user_id, amount)
			return true
		else
			return false
		end
	end
	return false
end


sendnotify = function(source, type, message, time)
    if time == nil then
        time = 5000
    end
    if source then 
        TriggerClientEvent("Notify",source,type,message,time)
    end
end

sendwebhook = function(webhook,data)
    if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
			embeds = data
		}), { ['Content-Type'] = 'application/json' })
	end
end

giveInventoryItem = function(user_id,item,amount)
    vRP.giveInventoryItem(user_id,item,amount)
end

addVehicle = function(user_id,vehicle)
    vRP.execute("vehicles/addVehicles",{ user_id = user_id, vehicle = vehicle, plate = vRP.generatePlate(), work = "false" })
end