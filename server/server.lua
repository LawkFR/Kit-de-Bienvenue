ESX = nil

TriggerEvent(Config.Trigger, function(obj) ESX = obj end)

function lawkLogsDiscord(message,url)
    local DiscordWebHook = url
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({username = "Logs LTD - Lawk#0008", content = message}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('lawk:logsDiscord')
AddEventHandler('lawk:logsDiscord', function(message, url)
	lawkLogsDiscord(message,url)
end)

ESX.RegisterServerCallback('lawk:checkkit', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    MySQL.Async.fetchAll('SELECT * FROM kitbienvenue WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        if result[1] then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent('lawk:kitbienvenue')
AddEventHandler('lawk:kitbienvenue', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local usekit = false
    
    if usekit == false then
        for k in pairs(Config.Items) do
            xPlayer.addInventoryItem(Config.Items[k].item, Config.Items[k].count)
        end
        for k in pairs(Config.Weapon) do
            xPlayer.addWeapon(Config.Weapon[k].weapon, Config.Weapon[k].ammo)
        end
        if Config.Argent == true then    
            xPlayer.addMoney(Config.Money.cash)
            xPlayer.addAccountMoney('bank', Config.Money.bank)
        end
        TriggerClientEvent('esx:showNotification', source, "Vous avez reçu votre kit de bienvenue")
        lawkLogsDiscord("Le Joueur : **" ..xPlayer.getName().."** à prit son kit de bienvenue !", Config.Logs.Webhook)
    else
        TriggerClientEvent('esx:showNotification', source, "Vous avez déjà pris votre kit de bienvenue")
        return
    end

    MySQL.Async.execute('INSERT INTO kitbienvenue (identifier, date) VALUES (@identifier, @date)', {
        ['@identifier'] = xPlayer.identifier,
        ['@date'] = os.date("%d/%m/%Y %X"),
    }, function(rowsChanged)
    end)
end)