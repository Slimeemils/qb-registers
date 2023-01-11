QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("qb-registers:sendpayment", function(amount, shop)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local playername = Player.PlayerData.charinfo.firstname
    

    if Player.Functions.RemoveMoney('bank', amount, "purchase") then
        exports['qb-management']:AddMoney(shop, amount)
        MySQL.insert('INSERT INTO register_payments (shop, name, amount) VALUES (?, ?, ?)',{shop, playername, amount})
    elseif Player.Functions.RemoveMoney('cash', amount, "purchase") then
        exports['qb-management']:AddMoney(shop, amount)
        MySQL.insert('INSERT INTO register_payments (shop, name, amount) VALUES (?, ?, ?)',{shop, playername, amount})
    else
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough money..')
    end
end)

RegisterNetEvent("qb-registers:deletepayments", function(shop)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    local shop = pData.PlayerData.job.name
    MySQL.query('SELECT * FROM register_payments WHERE shop = ?', {shop}, function(result)
        if result[1] then
            MySQL.query('DELETE FROM register_payments WHERE shop = ?', {shop})
            TriggerClientEvent('QBCore:Notify', src, 'Payments have been cleared.')
        else
            TriggerClientEvent('QBCore:Notify', src, 'There is nothing to delete..')
        end
    end)
end)

QBCore.Functions.CreateCallback("qb-registers:getpayments", function(source, cb)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    local shop = pData.PlayerData.job.name
    MySQL.query('SELECT * FROM register_payments WHERE shop = ?', {shop}, function(result)
        if result[1] then
            cb(result)
        else
            cb(nil)
        end
    end)
end)
