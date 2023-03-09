-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
local actived = {}
cRP = {}
Tunnel.bindInterface("SosaBank",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREAPARES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/Get_Transactions","SELECT * FROM SosaBank_transactions WHERE receiver_identifier = @identifier OR sender_identifier = @identifier ORDER BY id DESC")
vRP.prepare("vRP/Transactions",'SELECT *, DATE(date) = CURDATE() AS "day1", DATE(date) = CURDATE() - INTERVAL 1 DAY AS "day2", DATE(date) = CURDATE() - INTERVAL 2 DAY AS "day3", DATE(date) = CURDATE() - INTERVAL 3 DAY AS "day4", DATE(date) = CURDATE() - INTERVAL 4 DAY AS "day5", DATE(date) = CURDATE() - INTERVAL 5 DAY AS "day6", DATE(date) = CURDATE() - INTERVAL 6 DAY AS "day7" FROM `SosaBank_transactions` WHERE DATE(date) >= CURDATE() - INTERVAL 7 DAY')
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERINFO
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.GetPlayerInfo()
    local source = source
    local user_id = vRP.getUserId(source)
    local identity = vRP.userIdentity(user_id)
    local sex = vRPclient.getModelPlayer(source)
	if tostring(sex) == "mp_m_freemode_01" then
        sex = "m"
    else
        sex = "f"
    end
    local data = {
        playerName = identity.name .. " " .. identity.name2,
        playerBankMoney = vRP.getBank(user_id),
        walletMoney = vRP.getInventoryItemAmount(user_id,"dollars") or 0,
        sex = sex,
    }
    return data
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPIN
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.GetPIN()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)

	return identity.pincode
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPOSITMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("SosaBank:DepositMoney")
AddEventHandler("SosaBank:DepositMoney", function(amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and actived[user_id] == nil then
		actived[user_id] = true

		if parseInt(amount) > 0 then
			if vRP.tryGetInventoryItem(user_id,"dollars",amount,true) then 
				TriggerEvent('SosaBank:AddDepositTransaction', amount, source)
				vRP.addBank(user_id,amount,"Private")
				TriggerClientEvent('SosaBank:updateTransactions', source, vRP.getBank(user_id), vRP.getInventoryItemAmount(user_id,"dollars"))
				TriggerClientEvent("Notify",source,"verde","Você Depositou $"..amount..".",5000)
			else
				TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
			end
		end

		actived[user_id] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAWMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("SosaBank:WithdrawMoney")
AddEventHandler("SosaBank:WithdrawMoney", function(amount)
	local source = source
	local user_id = vRP.getUserId(source)

	if vRP.paymentBank(user_id,amount) then
		vRP.giveInventoryItem(user_id,"dollars",amount,true)
		TriggerEvent('SosaBank:AddWithdrawTransaction', amount, source)
		TriggerClientEvent('SosaBank:updateTransactions', source, vRP.getBank(user_id), vRP.getInventoryItemAmount(user_id,"dollars"))
		TriggerClientEvent("Notify",source,"verde","Você Sacou $"..amount..".",5000)
	else
		TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("SosaBank:TransferMoney")
AddEventHandler("SosaBank:TransferMoney", function(amount, nuser_id)
    local source = source
    local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
    if user_id ~= nuser_id then
        if vRP.paymentBank(user_id,amount) then
            if nuser_id ~= nil then
                vRP.addBank(nuser_id, amount)
                for i=1, #vRP.userSource(), 1 do
                    local xForPlayer = vRP.getUserId(vRP.userSource()[i])
                    if xForPlayer == nuser_id then
						local identity2 = vRP.userIdentity(xForPlayer)
                        TriggerClientEvent('SosaBank:updateTransactions', vRP.userSource()[i], vRP.getBank(nuser_id), vRP.getInventoryItemAmount(nuser_id,"dollars"))
                        TriggerClientEvent('okokNotify:Alert', vRP.userSource()[i], "BANK", "Você recebeu $"..amount.." from "..identity2.name .. " " .. identity2.name2, 5000, 'success')
                    end
                end
                TriggerEvent('SosaBank:AddTransferTransaction', amount, nuser_id, source)
				TriggerClientEvent('SosaBank:updateTransactions', source, vRP.getBank(user_id), vRP.getInventoryItemAmount(user_id,"dollars"))
                TriggerClientEvent('okokNotify:Alert', source, "BANK", "Você transferiu $"..amount.." para "..identity.name .. " " .. identity.name2, 5000, 'success')
            end
        else
            TriggerClientEvent('okokNotify:Alert', source, "BANK", "Dinheiro insuficiente.", 5000, 'error')
        end
    else
        TriggerClientEvent('okokNotify:Alert', source, "BANK", "Você não pode transferir para si mesmo.", 5000, 'error')
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETOVERVIEWTRANSACTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.GetOverviewTransactions()
	local source = source
	local user_id = vRP.getUserId(source)
	local playerIdentifier = user_id
	local allDays = {}
	local income = 0
	local outcome = 0
	local totalIncome = 0
	local day1_total, day2_total, day3_total, day4_total, day5_total, day6_total, day7_total = 0, 0, 0, 0, 0, 0, 0

	local result = vRP.query("vRP/Get_Transactions", { identifier = playerIdentifier })

	local result2 = vRP.query("vRP/Transactions", { })
	for k, v in pairs(result2) do
		local type = v.type
		local receiver_identifier = v.receiver_identifier
		local sender_identifier = v.sender_identifier
		local value = tonumber(v.value)

		if v.day1 == 1 then
			if value ~= nil then
				if type == "deposit" then
					day1_total = day1_total + value
					income = income + value
				elseif type == "withdraw" then
					day1_total = day1_total - value
					outcome = outcome - value
				elseif type == "transfer" and receiver_identifier == playerIdentifier then
					day1_total = day1_total + value
					income = income + value
				elseif type == "transfer" and sender_identifier == playerIdentifier then
					day1_total = day1_total - value
					outcome = outcome - value
				end
			end
			
		elseif v.day2 == 1 then
			if value ~= nil then
				if type == "deposit" then
					day2_total = day2_total + value
					income = income + value
				elseif type == "withdraw" then
					day2_total = day2_total - value
					outcome = outcome - value
				elseif type == "transfer" and receiver_identifier == playerIdentifier then
					day2_total = day2_total + value
					income = income + value
				elseif type == "transfer" and sender_identifier == playerIdentifier then
					day2_total = day2_total - value
					outcome = outcome - value
				end
			end

		elseif v.day3 == 1 then
			if value ~= nil then
				if type == "deposit" then
					day3_total = day3_total + value
					income = income + value
				elseif type == "withdraw" then
					day3_total = day3_total - value
					outcome = outcome - value
				elseif type == "transfer" and receiver_identifier == playerIdentifier then
					day3_total = day3_total + value
					income = income + value
				elseif type == "transfer" and sender_identifier == playerIdentifier then
					day3_total = day3_total - value
					outcome = outcome - value
				end
			end

		elseif v.day4 == 1 then
			if value ~= nil then
				if type == "deposit" then
					day4_total = day4_total + value
					income = income + value
				elseif type == "withdraw" then
					day4_total = day4_total - value
					outcome = outcome - value
				elseif type == "transfer" and receiver_identifier == playerIdentifier then
					day4_total = day4_total + value
					income = income + value
				elseif type == "transfer" and sender_identifier == playerIdentifier then
					day4_total = day4_total - value
					outcome = outcome - value
				end
			end

		elseif v.day5 == 1 then
			if value ~= nil then
				if type == "deposit" then
					day5_total = day5_total + value
					income = income + value
				elseif type == "withdraw" then
					day5_total = day5_total - value
					outcome = outcome - value
				elseif type == "transfer" and receiver_identifier == playerIdentifier then
					day5_total = day5_total + value
					income = income + value
				elseif type == "transfer" and sender_identifier == playerIdentifier then
					day5_total = day5_total - value
					outcome = outcome - value
				end
			end

		elseif v.day6 == 1 then
			if value ~= nil then
				if type == "deposit" then
					day6_total = day6_total + value
					income = income + value
				elseif type == "withdraw" then
					day6_total = day6_total - value
					outcome = outcome - value
				elseif type == "transfer" and receiver_identifier == playerIdentifier then
					day6_total = day6_total + value
					income = income + value
				elseif type == "transfer" and sender_identifier == playerIdentifier then
					day6_total = day6_total - value
					outcome = outcome - value
				end
			end

		elseif v.day7 == 1 then
			if value ~= nil then
				if type == "deposit" then
					day7_total = day7_total + value
					income = income + value
				elseif type == "withdraw" then
					day7_total = day7_total - value
					outcome = outcome - value
				elseif type == "transfer" and receiver_identifier == playerIdentifier then
					day7_total = day7_total + value
					income = income + value
				elseif type == "transfer" and sender_identifier == playerIdentifier then
					day7_total = day7_total - value
					outcome = outcome - value
				end
			end

		end
	end

	totalIncome = day1_total + day2_total + day3_total + day4_total + day5_total + day6_total + day7_total

	table.remove(allDays)
	table.insert(allDays, day1_total)
	table.insert(allDays, day2_total)
	table.insert(allDays, day3_total)
	table.insert(allDays, day4_total)
	table.insert(allDays, day5_total)
	table.insert(allDays, day6_total)
	table.insert(allDays, day7_total)
	table.insert(allDays, income)
	table.insert(allDays, outcome)
	table.insert(allDays, totalIncome)

	return result, playerIdentifier, allDays
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDDEPOSITTRANSACTION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("SosaBank:AddDepositTransaction")
AddEventHandler("SosaBank:AddDepositTransaction", function(amount, source_)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local user_id = vRP.getUserId(_source)
	local identity = vRP.userIdentity(user_id)

	MySQL.Async.insert('INSERT INTO SosaBank_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = 'bank',
		['@receiver_name'] = 'Bank Account',
		['@sender_identifier'] = tostring(user_id),
		['@sender_name'] = identity.name .. " " .. identity.name2,
		['@value'] = tonumber(amount),
		['@type'] = 'deposit'
	}, function (result)
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSALARI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("SosaBank:AddSalaryTransaction")
AddEventHandler("SosaBank:AddSalaryTransaction", function(amount, source_)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local user_id = vRP.getUserId(_source)
	local identity = vRP.userIdentity(user_id)

	MySQL.Async.insert('INSERT INTO SosaBank_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = 'bank',
		['@receiver_name'] = 'Pagamento',
		['@sender_identifier'] = tostring(user_id),
		['@sender_name'] = identity.name .. " " .. identity.name2,
		['@value'] = tonumber(amount),
		['@type'] = 'salary'
	}, function (result)
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDWITHDRAWTRANSACTION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("SosaBank:AddWithdrawTransaction")
AddEventHandler("SosaBank:AddWithdrawTransaction", function(amount, source_)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local user_id = vRP.getUserId(_source)
	local identity = vRP.userIdentity(user_id)

	MySQL.Async.insert('INSERT INTO SosaBank_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = tostring(user_id),
		['@receiver_name'] = identity.name .. " " .. identity.name2,
		['@sender_identifier'] = 'bank',
		['@sender_name'] = 'Bank Account',
		['@value'] = tonumber(amount),
		['@type'] = 'withdraw'
	}, function (result)
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDTRANSFERTRANSACTION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("SosaBank:AddTransferTransaction")
AddEventHandler("SosaBank:AddTransferTransaction", function(amount, xTarget, source_, targetName, targetIdentifier)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local user_id = vRP.getUserId(_source)
	local identity = vRP.userIdentity(user_id)
	local identity2 = vRP.userIdentity(xTarget)

	if targetName == nil then
		MySQL.Async.insert('INSERT INTO SosaBank_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
			['@receiver_identifier'] = tostring(xTarget),
			['@receiver_name'] = identity2.name .. " " .. identity2.name2,
			['@sender_identifier'] = tostring(user_id),
			['@sender_name'] = identity.name .. " " .. identity.name2,
			['@value'] = tonumber(amount),
			['@type'] = 'transfer'
		}, function (result)
		end)
	elseif targetName ~= nil and targetIdentifier ~= nil then
		MySQL.Async.insert('INSERT INTO SosaBank_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
			['@receiver_identifier'] = tostring(targetIdentifier),
			['@receiver_name'] = tostring(targetName),
			['@sender_identifier'] = tostring(user_id),
			['@sender_name'] = identity.name .. " " .. identity.name2,
			['@value'] = tonumber(amount),
			['@type'] = 'transfer'
		}, function (result)
		end)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPINDB
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("SosaBank:UpdatePINDB")
AddEventHandler("SosaBank:UpdatePINDB", function(pin, amount)
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.paymentBank(user_id,amount) then
        MySQL.Async.execute('UPDATE summerz_characters SET pincode = @pin WHERE id = @identifier', {
            ['@pin'] = pin,
            ['@identifier'] = user_id,
        }, function(changed)
        end)

        TriggerClientEvent('SosaBank:updateIbanPinChange', source)
		TriggerClientEvent('SosaBank:updateMoney',source, vRP.getBank(user_id), vRP.getInventoryItemAmount(user_id,"dollars"))
        TriggerClientEvent('Notify', source, "azul", "PIN trocado com sucesso para "..pin, 5000)
    else
        TriggerClientEvent('Notify', source, "vermelho", "Dinheiro insuficiente.", 5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTFINES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestFines()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local fines = {}
        local consult = vRP.getFines(user_id)
            if nuser_id == 0 then
                table.insert(fines,{ id = id, user_id = parseInt(user_id), nuser_id = "Government", date = date, price = parseInt(price), text = tostring(text) })
            else
                local identity = vRP.userIdentity(nuser_id)
                table.insert(fines,{ id = id, user_id = parseInt(user_id), date = date, price = parseInt(price), text = tostring(text) })
            end
        return fines
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINESPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.finesPayment(id,price)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.paymentBank(user_id,parseInt(price)) then
            vRP.execute("vRP/del_fines",{ id = parseInt(id), user_id = parseInt(user_id) })
        else
            TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente na sua conta bancária.",5000)
        end
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTINVOICES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestMyInvoices()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local invoices = {}
		local consult = vRP.getMyInvoice(user_id)
		for k,v in pairs(consult) do
			local identity = vRP.userIdentity(v.user_id)
			if identity then
				table.insert(invoices,{ name = tostring(identity.name.." "..identity.name2), date = v.date, price = parseInt(v.price), text = tostring(v.text) })
			end
		end
		return invoices
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOICESPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.invoicesPayment(id,price,nuser_id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.paymentBank(user_id,parseInt(price)) then
			if parseInt(nuser_id) > 0 then
				vRP.addBank(nuser_id,parseInt(price))
			end
			TriggerClientEvent("SosaBank:updateInvoices",source)
			vRP.execute("vRP/del_invoice",{ id = parseInt(id), user_id = parseInt(user_id) })
		else
			TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente na sua conta bancária.",5000)
		end
	end
end