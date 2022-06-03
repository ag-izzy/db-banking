if Config.Framework == 'esx' then
    local ESX = exports['es_extended']:getSharedObject()

    ESX.RegisterServerCallback('db-bank:GetData', function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local transactions = {}
        exports.oxmysql:query('SELECT * FROM db_transactions WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.getIdentifier()
        }, function(r)
            if r then
                table.insert(transactions, result[i])
            end
        end)
        cb({firstname = xPlayer.firstName, lastname = xPlayer.lastName, balance = xPlayer.getAccount('bank').money, transactions = transactions})
    end)

    RegisterNetEvent('db-banking:withdraw', function(amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getAccount('bank').money >= amount then
            xPlayer.removeAccountMoney('bank', amount)
            xPlayer.addAccountMoney('money', amount)
            InsertInDatabase(xPlayer.getIdentifier(), '- '..amount..'$ '..Config.Locales[Config.Language]['withdrew'])
        end
    end)

    RegisterNetEvent('db-banking:deposit', function(amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getAccount('money').money >= amount then
            xPlayer.addAccountMoney('bank', amount)
            xPlayer.removeAccountMoney('money', amount)
            InsertInDatabase(xPlayer.getIdentifier(), '- '..amount..'$ '..Config.Locales[Config.Language]['deposited'])
        end
    end)

    RegisterNetEvent('db-banking:transfer', function(data)
        local xPlayer = ESX.GetPlayerFromId(source)
        local xTarget = ESX.GetPlayerFromId(data.target)
        if xPlayer.getAccount('bank').money >= data.amount then
            xPlayer.removeAccountMoney('bank', data.amount)
            xTarget.addAccountMoney('bank', data.amount)
            InsertInDatabase(xTarget.getIdentifier(), '+ '..data.amount..'$ '..Config.Locales[Config.Language]['from'].. ' '..xPlayer.firstName..' '..xPlayer.variables.lastName)
            InsertInDatabase(xPlayer.getIdentifier(), '- '..data.amount..'$ '..Config.Locales[Config.Language]['to'].. ' '..xTarget.firstName..' '..xTarget.lastName)
        end
    end)

elseif Config.Framework == 'qb' then
    local QBCore = exports['qb-core']:GetCoreObject()

    QBCore.Functions.CreateCallback('db-bank:GetData', function(source, cb)
        local Player = QBCore.Functions.GetPlayer(source)
        local PlayerData = Player.PlayerData.charinfo
        local transactions = {}
        exports.oxmysql:query('SELECT * FROM db_transactions WHERE identifier = @identifier', {
            ['@identifier'] = Player.PlayerData.license:gsub('license:','')
        }, function(result)
            if result[1] then
                for i = 0, #result do
                    table.insert(transactions, result[i])
                end
            end
        end)
        Wait(100)
        cb({firstname = PlayerData.firstname, lastname = PlayerData.lastname, balance = Player.Functions.GetMoney('bank'), transactions = transactions})
    end)

    RegisterNetEvent('db-banking:withdraw', function(amount)
        amount = tonumber(amount)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.Functions.GetMoney('bank') >= amount then
            Player.Functions.RemoveMoney('bank', amount, 'withdraw')
            Player.Functions.AddMoney('money', amount, 'withdraw')
            InsertInDatabase(Player.PlayerData.license, '- '..amount..'$ '..Config.Locales[Config.Language]['withdrew'])
        end
    end)

    RegisterNetEvent('db-banking:deposit', function(amount)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.Functions.GetMoney('money') >= amount then
            Player.Functions.AddMoney('bank', amount, 'deposit')
            Player.Functions.RemoveMoney('money', amount, 'deposit')
            InsertInDatabase(Player.PlayerData.license, '- '..amount..'$ '..Config.Locales[Config.Language]['deposited'])
        end
    end)

    RegisterNetEvent('db-banking:transfer', function(data) --TOOD Post Transfers Vals And Use The Data For This
        local Player = QBCore.Functions.GetPlayer(source)
        local Target = QBCore.Functions.GetPlayer(data.target)
        local PlayerData = Player.PlayerData.charinfo
        local TargetData = Target.PlayerData.charinfo
        if Player.Functions.GetMoney('bank') >= data.amount then
            Player.Functions.RemoveMoney('bank', data.amount, 'transfer')
            Target.Functions.AddMoney('bank', data.amount, 'transfer')
            InsertInDatabase(Target.PlayerData.license, '+ '..data.amount..'$ '..Config.Locales[Config.Language]['from'].. ' '..PlayerData.firstName..' '..PlayerData.lastName)
            InsertInDatabase(Player.PlayerData.license, '- '..data.amount..'$ '..Config.Locales[Config.Language]['to'].. ' '..TargetData.firstName..' '..TargetData.lastName)
        end
    end)
end

function InsertInDatabase(identifier,msg)
    exports.oxmysql:insert('INSERT INTO db_transactions (identifier, message) VALUES(@identifier, @message)', {
        ['@identifier'] = tostring(identifier:gsub('license:','')), 
        ['@message'] = tostring(msg)
    })
end
