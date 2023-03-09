function beforeBuyTruck(source,truck_name,price,user_id)
	-- Here you can do any verification when a player is buying an truck, like if player has driver license or anything else you want to check before buy the truck. return true or false
	return true
end

function beforeBuyLocation(source,user_id)
	-- Here you can do any verification when a player is opening the trucker UI for the first time, like if player has the permission or money to that or anything else you want to check. return true or false
	return true
end

function onFinishJob(source,received_amount,received_xp,distance)
	-- Here you can run any code when player finishes the job. Does not return anything
end

function beforeStartContract(source,contract_id)
	-- Here you can do any verification when a player is starting a contract. return true or false
	return true
end

function MySQL_Sync_execute(sql,params)
	MySQL.Sync.execute(sql, params)
end

function MySQL_Sync_fetchAll(sql,params)
	return MySQL.Sync.fetchAll(sql, params)
end

function getTopTruckers()
    local sql = [[SELECT U.name, U.name2 as firstname, T.user_id, T.exp, T.traveled_distance 
        FROM trucker_users T 
        INNER JOIN summerz_characters U ON (T.user_id = U.id)
        WHERE traveled_distance > 0 ORDER BY traveled_distance DESC LIMIT 10]];
    return MySQL_Sync_fetchAll(sql,{});
end

function getpartyMembers(party_id)
    local sql = [[SELECT U.name, U.name2 as firstname, P.* 
        FROM `trucker_party_members` P
        INNER JOIN summerz_characters U ON (P.user_id = U.id)
        WHERE party_id = @party_id]];
    return MySQL_Sync_fetchAll(sql,{['@party_id'] = party_id});
end