-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy  = module("vrp","lib/Proxy")
local Tools  = module("vrp","lib/Tools")
local config = module("ps_coins","config")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
psRP = {}
Tunnel.bindInterface("ps_coins",psRP)
vCLIENT = Tunnel.getInterface("ps_coins")
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERYES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("ps_coins/select_product","SELECT * FROM ps_coins_products WHERE id = @id")
vRP.prepare("ps_coins/select_all_products","SELECT * FROM ps_coins_products")
vRP.prepare("ps_coins/select_products","SELECT * FROM ps_coins_products WHERE box = @box")
vRP.prepare("ps_coins/select_my_product","SELECT * FROM ps_coins_my_products WHERE id = @id AND user_id = @user_id")
vRP.prepare("ps_coins/select_my_products","SELECT * FROM ps_coins_my_products WHERE user_id = @user_id")
vRP.prepare("ps_coins/add_my_products","INSERT INTO ps_coins_my_products (`user_id`, `item_id`) VALUES(@user_id, @item_id);")
vRP.prepare("ps_coins/rem_my_products","DELETE FROM ps_coins_my_products WHERE id = @id AND user_id = @user_id")
vRP.prepare("ps_coins/select_my_skins","SELECT * FROM ps_coins_my_skins WHERE user_id = @user_id")
vRP.prepare("ps_coins/add_my_skins","INSERT INTO ps_coins_my_skins (`user_id`, `item_id`) VALUES(@user_id, @item_id);")
vRP.prepare("ps_coins/add_product","INSERT INTO ps_coins_products (`name`, `index`, `box`, `category`, `type`, `image`, `weapon`, `price`, `pricereal`) VALUES(@name, @index, @box, @category, @type, @image, @weapon, @price, @pricereal);")
vRP.prepare("ps_coins/edit_product","UPDATE ps_coins_products SET name = @name, `index` = @index, box = @box, category = @category, type = @type, image = @image, weapon = @weapon, price = @price, pricereal = @pricereal WHERE id = @id")
vRP.prepare("ps_coins/delete_product","DELETE FROM ps_coins_products WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- classeType
-----------------------------------------------------------------------------------------------------------------------------------------
local function classeType(type)
    if type == "rare" then
        return "Raro";
    elseif type == "special" then
        return "Especial";
    else
        return "Epico";
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- notify
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.notify(type, message, time)
    local source  = source
    sendnotify(source,type,message,time)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- openLink
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.openLink()
    local source  = source
    local user_id = getUserId(source)

    if user_id then
        local link = "start "..config.buycoins.link
        os.execute(link)
    else
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SelectAllProducts
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.SelectAllProducts()
    local source  = source
    local user_id = getUserId(source)
    local data    = {}

    if user_id then
        local query = vRP.query("ps_coins/select_all_products")
        if query and query[1] then
            data = query
        end

        return data
    else
        return data
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SelectProducts
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.SelectProducts(index)
    local source  = source
    local user_id = getUserId(source)
    local data    = {}

    if user_id then
        local query = vRP.query("ps_coins/select_products",{ box = index })
        if query and query[1] then
            data = query
        end

        return data
    else
        return data
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- AddProductUser
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.AddProductUser(data)
    local source  = source
    local user_id = getUserId(source)

    if user_id then
        if paymentCoins(user_id, tonumber(data.boxprice)) then
            vRP.execute("ps_coins/add_my_products",{ user_id = user_id, item_id = data.id })

            local nameuser = getUserFullName(user_id)
            local data = {
                {
                    title = "REGISTRO DE GANHO DE ITEM\n ",
                    thumbnail = {
                        url = config.webhooks.icon
                    }, 
                    fields = {
                        { 
                            name = "**INFORMAÇÔES DO PLAYER:**",
                            value = ""..nameuser.." [**"..user_id.."**]\n"
                        },
                        { 
                            name = "**ITEM:**",
                            value = data.name
                        },
                        { 
                            name = "**TIPO:**",
                            value = classeType(data.type)
                        }
                    },
                    footer = { 
                        text = "PEQUISHOP "..os.date("%d/%m/%Y | %H:%M:%S"), 
                        icon_url = config.webhooks.icon
                    },
                    color = config.webhooks.color
                }
            }

            sendwebhook(config.webhooks.reward, data)
            return true
        else
            return false
        end
    else
        return false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SelectProducts
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.SelectRewardsSkins()
    local source  = source
    local user_id = getUserId(source)
    local data    = {}

    if user_id then
        local query = vRP.query("ps_coins/select_my_skins",{ user_id = user_id })
        if query and query[1] then
            for k,v in pairs(query) do
                local item = vRP.query("ps_coins/select_product",{ id = v.item_id })
                if item and item[1] then
                    local nitem = {
                        id       = v.id,
                        item_id  = v.item_id,
                        name     = item[1].name,
                        index    = item[1].index,
                        category = item[1].category,
                        type     = item[1].type,
                        image    = item[1].image,
                        weapon   = item[1].weapon,
                        price    = item[1].price
                    }
                    table.insert(data, nitem)
                end
            end
        end

        return data
    else
        return data
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SelectProducts
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.SelectRewardsProducts()
    local source  = source
    local user_id = getUserId(source)
    local data    = {}

    if user_id then
        local query = vRP.query("ps_coins/select_my_products",{ user_id = user_id })
        if query and query[1] then
            for k,v in pairs(query) do
                local item = vRP.query("ps_coins/select_product",{ id = v.item_id })
                if item and item[1] then
                    local nitem = {
                        id       = v.id,
                        item_id  = v.item_id,
                        name     = item[1].name,
                        index    = item[1].index,
                        category = item[1].category,
                        type     = item[1].type,
                        price    = item[1].price
                    }
                    table.insert(data, nitem)
                end
            end
        end

        return data
    else
        return data
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GetCoins
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.GetCoins()
    local source  = source
    local user_id = getUserId(source)

    if user_id then
        local coins = getCoins(user_id)
        if coins ~= "" then
            return coins
        end
    else
        return 0
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RewardCoins
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.RewardCoins()
    local source  = source
    local user_id = getUserId(source)

    if user_id then
        local amount = config.onlinetime.amount
        if amount <= 0 then
            return
        end
        addCoins(user_id, amount)
        sendnotify(source,"verde","Você recebeu <b>"..amount.."</b> StreetCoins por estar online")
        
        local nameuser = getUserFullName(user_id)
        local data = {
            {
                title = "REGISTRO DE COINS ONLINE\n ",
                thumbnail = {
                    url = config.webhooks.icon
                }, 
                fields = {
                    { 
                        name = "**INFORMAÇÔES DO PLAYER:**",
                        value = ""..nameuser.." [**"..user_id.."**]\n"
                    },
                    { 
                        name = "**QUANTIDADE:**",
                        value = amount
                    }
                },
                footer = { 
                    text = "PEQUISHOP "..os.date("%d/%m/%Y | %H:%M:%S"), 
                    icon_url = config.webhooks.icon
                },
                color = config.webhooks.color
            }
        }

        sendwebhook(config.webhooks.online, data)
    else
        return
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RedeemItem
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.RedeemItem(data)
    local source  = source
    local user_id = getUserId(source)

    if user_id and data.item then
        local query = vRP.query("ps_coins/select_my_product",{ id = data.item, user_id = user_id })
        if query and query[1] then
            local item = vRP.query("ps_coins/select_product",{ id = query[1].item_id })
            if item and item[1] then
                if item[1].category == "item" then
                    local item = item[1].index
                    vRP.execute("ps_coins/rem_my_products",{ id = data.item, user_id = user_id })
                    giveInventoryItem(user_id,item,1)
                elseif item[1].category == "vehicle" then
                    local vehicle = item[1].index
                    vRP.execute("ps_coins/rem_my_products",{ id = data.item, user_id = user_id })
                    addVehicle(user_id,vehicle)
                elseif item[1].category == "skin" then
                    vRP.execute("ps_coins/rem_my_products",{ id = data.item, user_id = user_id })
                    vRP.execute("ps_coins/add_my_skins",{ user_id = user_id, item_id = query[1].item_id })
                end

                local nameuser = getUserFullName(user_id)
                local data = {
                    {
                        title = "REGISTRO DE RESGATE DE ITEM\n ",
                        thumbnail = {
                            url = config.webhooks.icon
                        }, 
                        fields = {
                            { 
                                name = "**INFORMAÇÔES DO PLAYER:**",
                                value = ""..nameuser.." [**"..user_id.."**]\n"
                            },
                            { 
                                name = "**ITEM:**",
                                value = item[1].name
                            },
                            { 
                                name = "**TIPO:**",
                                value = classeType(item[1].type)
                            }
                        },
                        footer = { 
                            text = "PEQUISHOP "..os.date("%d/%m/%Y | %H:%M:%S"), 
                            icon_url = config.webhooks.icon
                        },
                        color = config.webhooks.color
                    }
                }

                sendwebhook(config.webhooks.redeem, data)
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GiveBackItem
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.GiveBackItem(data)
    local source  = source
    local user_id = getUserId(source)

    if user_id and data.item then
        local query = vRP.query("ps_coins/select_my_product",{ id = data.item, user_id = user_id })
        if query and query[1] then
            local item = vRP.query("ps_coins/select_product",{ id = query[1].item_id })
            if item and item[1] then
                local amount = item[1].price
                addCoins(user_id, amount)
                vRP.execute("ps_coins/rem_my_products",{ id = data.item, user_id = user_id })

                local nameuser = getUserFullName(user_id)
                local data = {
                    {
                        title = "REGISTRO DE DEVOLUÇÃO DE ITEM\n ",
                        thumbnail = {
                            url = config.webhooks.icon
                        }, 
                        fields = {
                            { 
                                name = "**INFORMAÇÔES DO PLAYER:**",
                                value = ""..nameuser.." [**"..user_id.."**]\n"
                            },
                            { 
                                name = "**ITEM:**",
                                value = item[1].name
                            },
                            { 
                                name = "**TIPO:**",
                                value = classeType(item[1].type)
                            },
                            { 
                                name = "**PREÇO:**",
                                value = amount
                            }
                        },
                        footer = { 
                            text = "PEQUISHOP "..os.date("%d/%m/%Y | %H:%M:%S"), 
                            icon_url = config.webhooks.icon
                        },
                        color = config.webhooks.color
                    }
                }

                sendwebhook(config.webhooks.giveback, data)
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ChangeTexture
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.ChangeTexture(hash,url)
    if hash and url then
        vCLIENT.ChangeTexture(source,hash,url)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- checkPermission
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.checkPermission()
    local source   = source
    local user_id  = getUserId(source)
    if user_id then
        local permissions = config.permissions

        for k, v in pairs(permissions) do
            if getHasPermission(user_id,v) then
                return true
            end
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- AddProductPainel
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.AddProductPainel(data)
    local source   = source
    local user_id  = getUserId(source)

    if user_id ~= nil and data.name ~= nil and data.index ~= nil and data.box ~= nil and data.category ~= nil and data.type ~= nil and data.price ~= nil and data.pricereal ~= nil then

        local check = false
        local permissions = config.permissions

        for k, v in pairs(permissions) do
            if getHasPermission(user_id,v) then
                check = true
            end
        end
        
        if check then
                
            vRP.execute("ps_coins/add_product",{ 
                name      = data.name,
                index     = data.index,
                box       = data.box,
                category  = data.category,
                type      = data.type,
                image     = data.image,
                weapon    = data.weapon,
                price     = data.price,
                pricereal = data.pricereal
            })

            local nameuser = getUserFullName(user_id)
            local data = {
                {
                    title = "REGISTRO DE CADASTRO DE ITEM\n ",
                    thumbnail = {
                        url = config.webhooks.icon
                    }, 
                    fields = {
                        { 
                            name = "**COLABORADOR DA EQUIPE:**", 
                            value = ""..nameuser.." [**"..user_id.."**]\n"
                        },
                        { 
                            name = "**NOME DO ITEM:**",
                            value = data.name
                        }
                    },
                    footer = { 
                        text = "PEQUISHOP "..os.date("%d/%m/%Y | %H:%M:%S"), 
                        icon_url = config.webhooks.icon
                    },
                    color = config.webhooks.color
                }
            }

            sendwebhook(config.webhooks.painel, data)

            return true
        else
            sendnotify(source,"amarelo","Você não tem permissão")
            return false
        end
    else
        return false
    end    
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EditProductPainel
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.EditProductPainel(data)
    local source   = source
    local user_id  = getUserId(source)

    if user_id ~= nil and data.id ~= nil and data.name ~= nil and data.index ~= nil and data.box ~= nil and data.category ~= nil and data.type ~= nil and data.price ~= nil and data.pricereal ~= nil then

        local check = false
        local permissions = config.permissions

        for k, v in pairs(permissions) do
            if getHasPermission(user_id,v) then
                check = true
            end
        end
        
        if check then

            local query = vRP.query("ps_coins/select_product", { id = data.id })

            if query and query[1] then
                
                vRP.execute("ps_coins/edit_product",{ 
                    name      = data.name,
                    index     = data.index,
                    box       = data.box,
                    category  = data.category,
                    type      = data.type,
                    image     = data.image,
                    weapon    = data.weapon,
                    price     = data.price,
                    pricereal = data.pricereal,
                    id        = data.id
                })

                local nameuser = getUserFullName(user_id)
                local data = {
                    {
                        title = "REGISTRO DE EDIÇÃO DE ITEM\n ",
                        thumbnail = {
                            url = config.webhooks.icon
                        }, 
                        fields = {
                            { 
                                name = "**COLABORADOR DA EQUIPE:**", 
                                value = ""..nameuser.." [**"..user_id.."**]\n"
                            },
                            { 
                                name = "**NOME ANTIGO DO ITEM:**",
                                value = ""..query[1].name.." [**"..data.id.."**]\n"
                            },
                            { 
                                name = "**NOVO NOME DO ITEM:**",
                                value = ""..data.name.." [**"..data.id.."**]\n"
                            }
                        },
                        footer = { 
                            text = "PEQUISHOP "..os.date("%d/%m/%Y | %H:%M:%S"), 
                            icon_url = config.webhooks.icon
                        },
                        color = config.webhooks.color
                    }
                }

                sendwebhook(config.webhooks.painel, data)

                return true
            else
                return false
            end 
        else
            sendnotify(source,"amarelo","Você não tem permissão")
            return false
        end
    else
        return false
    end    
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DeleteProductPainel
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.DeleteProductPainel(data)
    local source   = source
    local user_id  = getUserId(source)

    if user_id ~= nil and data.id ~= nil then

        local check = false
        local permissions = config.permissions

        for k, v in pairs(permissions) do
            if getHasPermission(user_id,v) then
                check = true
            end
        end
        
        if check then

            local query = vRP.query("ps_coins/select_product", { id = data.id })

            if query and query[1] then
                
                vRP.execute("ps_coins/delete_product",{ id = data.id })

                local nameuser = getUserFullName(user_id)
                local data = {
                    {
                        title = "REGISTRO DE REMOÇÃO DE ITEM\n ",
                        thumbnail = {
                            url = config.webhooks.icon
                        }, 
                        fields = {
                            { 
                                name = "**COLABORADOR DA EQUIPE:**", 
                                value = ""..nameuser.." [**"..user_id.."**]\n"
                            },
                            { 
                                name = "**NOME DO ITEM:**",
                                value = ""..query[1].name.." [**"..data.id.."**]\n"
                            }
                        },
                        footer = { 
                            text = "PEQUISHOP "..os.date("%d/%m/%Y | %H:%M:%S"), 
                            icon_url = config.webhooks.icon
                        },
                        color = config.webhooks.color
                    }
                }

                sendwebhook(config.webhooks.painel, data)

                return true
            else
                return false
            end
        else
            sendnotify(source,"amarelo","Você não tem permissão")
            return false
        end
    else
        return false
    end    
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- command setcoins
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('setcoins',function(source,args,rawCommand)
    local source  = source
	local user_id = getUserId(source)
    local check   = false

    for k, v in pairs(config.permissions) do
        if getHasPermission(user_id, v) then
            check = true
        end
    end

	if check and args[1] ~= nil and args[2] ~= nil then
        local nuser_id = tonumber(args[1])
        if nuser_id then
            local amount = tonumber(args[2])
            if amount > 0 then
                setCoins(nuser_id, amount)
                local nsource = getUserSource(nuser_id)
                if nsource ~= nil then
                    sendnotify(nsource,"verde","Seus coins agora são <b>"..amount.."</b>")
                end
                sendnotify(source,"verde","Você setou <b>"..amount.."</b> para o usuário <b>"..nuser_id.."</b>")

                local nameuser = getUserFullName(user_id)
                local nameusertwo =getUserFullName(nuser_id)
                local data = {
                    {
                        title = "REGISTRO DE SET COINS\n ",
                        thumbnail = {
                            url = config.webhooks.icon
                        }, 
                        fields = {
                            { 
                                name = "**COLABORADOR DA EQUIPE:**", 
                                value = ""..nameuser.." [**"..user_id.."**]\n"
                            },
                            { 
                                name = "**INFORMAÇÔES DO PLAYER:**",
                                value = ""..nameusertwo.." [**"..user_id.."**]\n"
                            },
                            { 
                                name = "**QUANTIDADE:**",
                                value = amount
                            }
                        },
                        footer = { 
                            text = "PEQUISHOP "..os.date("%d/%m/%Y | %H:%M:%S"), 
                            icon_url = config.webhooks.icon
                        },
                        color = config.webhooks.color
                    }
                }
    
                sendwebhook(config.webhooks.setcoins, data)
            else
                sendnotify(source,"amarelo","Digite um valor maior que 0")
            end
        end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- command addcoins
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('addcoins',function(source,args,rawCommand)
    local source  = source
	local user_id = getUserId(source)
    local check   = false

    for k, v in pairs(config.permissions) do
        if getHasPermission(user_id, v) then
            check = true
        end
    end

	if check and args[1] ~= nil and args[2] ~= nil then
        local nuser_id = tonumber(args[1])
        if nuser_id then
            local amount = tonumber(args[2])
            if amount > 0 then
                addCoins(nuser_id, amount)
                local nsource = getUserSource(nuser_id)
                if nsource ~= nil then
                    sendnotify(nsource,"verde","Você recebeu <b>"..amount.."</b> StreetCoins")
                end
                sendnotify(source,"verde","Você adicionou <b>"..amount.."</b> para o usuário <b>"..nuser_id.."</b>")
                
                local nameuser = getUserFullName(user_id)
                local nameusertwo =getUserFullName(nuser_id)
                local data = {
                    {
                        title = "REGISTRO DE ADD COINS\n ",
                        thumbnail = {
                            url = config.webhooks.icon
                        }, 
                        fields = {
                            { 
                                name = "**COLABORADOR DA EQUIPE:**", 
                                value = ""..nameuser.." [**"..user_id.."**]\n"
                            },
                            { 
                                name = "**INFORMAÇÔES DO PLAYER:**",
                                value = ""..nameusertwo.." [**"..user_id.."**]\n"
                            },
                            { 
                                name = "**QUANTIDADE:**",
                                value = amount
                            }
                        },
                        footer = { 
                            text = "PEQUISHOP "..os.date("%d/%m/%Y | %H:%M:%S"), 
                            icon_url = config.webhooks.icon
                        },
                        color = config.webhooks.color
                    }
                }
    
                sendwebhook(config.webhooks.addcoins, data)
            else
                sendnotify(source,"amarelo","Digite um valor maior que 0")
            end
        end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- command remcoins
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('remcoins',function(source,args,rawCommand)
    local source  = source
	local user_id = getUserId(source)
    local check   = false

    for k, v in pairs(config.permissions) do
        if getHasPermission(user_id, v) then
            check = true
        end
    end

	if check and args[1] ~= nil and args[2] ~= nil then
        local nuser_id = tonumber(args[1])
        if nuser_id then
            local amount = tonumber(args[2])
            if amount > 0 then
                removeCoins(nuser_id, amount)
                local nsource = getUserSource(nuser_id)
                if nsource ~= nil then
                    sendnotify(nsource,"verde","Foi removido <b>"..amount.."</b> coins da sua conta")
                end
                sendnotify(source,"verde","Você removeu <b>"..amount.."</b> do usuário <b>"..nuser_id.."</b>")
                
                local nameuser = getUserFullName(user_id)
                local nameusertwo =getUserFullName(nuser_id)
                local data = {
                    {
                        title = "REGISTRO DE REM COINS\n ",
                        thumbnail = {
                            url = config.webhooks.icon
                        }, 
                        fields = {
                            { 
                                name = "**COLABORADOR DA EQUIPE:**", 
                                value = ""..nameuser.." [**"..user_id.."**]\n"
                            },
                            { 
                                name = "**INFORMAÇÔES DO PLAYER:**",
                                value = ""..nameusertwo.." [**"..user_id.."**]\n"
                            },
                            { 
                                name = "**QUANTIDADE:**",
                                value = amount
                            }
                        },
                        footer = { 
                            text = "PEQUISHOP "..os.date("%d/%m/%Y | %H:%M:%S"), 
                            icon_url = config.webhooks.icon
                        },
                        color = config.webhooks.color
                    }
                }
        
                sendwebhook(config.webhooks.remcoins, data)
            else
                sendnotify(source,"amarelo","Digite um valor maior que 0")
            end
        end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- command bonuscoins
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('bonuscoins',function(source,args,rawCommand)
    local source  = source
	local user_id = getUserId(source)
    local check   = false

    for k, v in pairs(config.permissions) do
        if getHasPermission(user_id, v) then
            check = true
        end
    end

	if check and args[1] ~= nil then
        local amount = tonumber(args[1])
        if amount > 0 then
            local nameuser = getUserFullName(user_id)
            local users = getUsers()
            for k,v in pairs(users) do
                local nuser_id = tonumber(k)
                if nuser_id then
                    local nsource = getUserSource(nuser_id)
                    if nsource ~= nil then
                        addCoins(nuser_id, amount)
                        sendnotify(nsource,"verde","Você recebeu <b>"..amount.."</b> StreetCoins")
                    end
                end
            end

            sendnotify(source,"verde","Você adicionou <b>"..amount.."</b> para todos players online")

            local data = {
                {
                    title = "REGISTRO DE BONUS COINS\n ",
                    thumbnail = {
                        url = config.webhooks.icon
                    }, 
                    fields = {
                        { 
                            name = "**COLABORADOR DA EQUIPE:**", 
                            value = ""..nameuser.." [**"..user_id.."**]\n"
                        },
                        { 
                            name = "**QUANTIDADE:**",
                            value = amount
                        }
                    },
                    footer = { 
                        text = "PEQUISHOP "..os.date("%d/%m/%Y | %H:%M:%S"), 
                        icon_url = config.webhooks.icon
                    },
                    color = config.webhooks.color
                }
            }
        
            sendwebhook(config.webhooks.bonuscoins, data)
        else
            sendnotify(source,"amarelo","Digite um valor maior que 0")
        end
	end
end)
