if Config["Framework"] == "esx" then

ESX = exports["es_extended"]:getSharedObject()
local transactions

RegisterServerEvent("db-banking:openBank", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    exports.oxmysql:query("SELECT * FROM _bankTransactions WHERE identifier = @identifier", {
        ['@identifier'] = xPlayer.getIdentifier()
    }, function(r)
        if r then
            for _,v in pairs(r) do
                transactions = v.msg
            end
        end
    end)
    local data = {
        firstname = xPlayer.variables.firstName,
        lastname = xPlayer.variables.lastName,
        balance = xPlayer.getAccount('bank').money,
        transactions = transactions
    }
    TriggerClientEvent("db-banking:recieveData", source, data)
end)

RegisterServerEvent("db-banking:logTransaction", function(identifier,msg)
    exports.oxmysql:insert("INSERT INTO _bankTransactions (identifier, msg)", {identifier, msg})
end)

RegisterServerEvent("db-banking:withdraw", function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount('bank').money >= amount then
        xPlayer.removeAccountMoney('bank', amount)
        xPlayer.addAccountMoney('money', amount)
        TriggerEvent("db-banking:logTransaction", source, xPlayer.getIdentifier(), "Withdrew $"..amount)
    end
end)

RegisterServerEvent("db-banking:deposit", function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount('money').money >= amount then
        xPlayer.addAccountMoney('bank', amount)
        xPlayer.removeAccountMoney('money', amount)
        TriggerEvent("db-banking:logTransaction", source, xPlayer.getIdentifier(), "Deposited $"..amount)
    end
end)

RegisterServerEvent("db-banking:transfer", function(data) --TOOD Post Transfers Vals And Use The Data For This
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(data.target)
    if xPlayer.getAccount('bank').money >= data.amount then
        xPlayer.removeAccountMoney('bank', data.amount)
        xTarget.addAccountMoney('bank', data.amount)
        TriggerEvent("db-banking:logTransaction", source, xTarget.getIdentifier(), "+ $"..data.amount.." from"..xPlayer.variables.firstName.." "..xPlayer.variables.lastName)
        TriggerEvent("db-banking:logTransaction", source, xPlayer.getIdentifier(), "You Transferred $"..data.amount.." to"..xTarget.firstName)
    end
end)

elseif Config["Framework"] == "qb" then
QBCore = exports["qb-core"]:getCoreObject()
local transactions
local PlayerData = QBCore.Functions.GetPlayerData()

RegisterServerEvent("db-banking:openBank", function()
    local Player = QBCore.Functions.GetPlayer(source)
    exports.oxmysql:query("SELECT * FROM _bankTransactions WHERE identifier = @identifier", {
        ['@identifier'] = Player.identifier
    }, function(r)
        if r then
            for _,v in pairs(r) do
                transactions = v.msg
            end
        end
    end)
    local data = {
        firstname = PlayerData.charinfo.firstname,
        lastname = PlayerData.charinfo.lastname,
        balance = Player.getAccount('bank').money,
        transactions = transactions
    }
    TriggerClientEvent("db-banking:recieveData", source, data)
end)

RegisterServerEvent("db-banking:logTransaction", function(identifier,msg)
    exports.oxmysql:insert("INSERT INTO _bankTransactions (identifier, msg)", {identifier, msg})
end)

RegisterServerEvent("db-banking:withdraw", function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount('bank').money >= amount then
        xPlayer.removeAccountMoney('bank', amount)
        xPlayer.addAccountMoney('money', amount)
        TriggerEvent("db-banking:logTransaction", source, xPlayer.getIdentifier(), "Withdrew $"..amount)
    end
end)

RegisterServerEvent("db-banking:deposit", function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount('money').money >= amount then
        xPlayer.addAccountMoney('bank', amount)
        xPlayer.removeAccountMoney('money', amount)
        TriggerEvent("db-banking:logTransaction", source, xPlayer.getIdentifier(), "Deposited $"..amount)
    end
end)

RegisterServerEvent("db-banking:transfer", function(data) --TOOD Post Transfers Vals And Use The Data For This
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(data.target)
    if xPlayer.getAccount('bank').money >= data.amount then
        xPlayer.removeAccountMoney('bank', data.amount)
        xTarget.addAccountMoney('bank', data.amount)
        TriggerEvent("db-banking:logTransaction", source, xTarget.getIdentifier(), "+ $"..data.amount.." from"..xPlayer.variables.firstName.." "..xPlayer.variables.lastName)
        TriggerEvent("db-banking:logTransaction", source, xPlayer.getIdentifier(), "You Transferred $"..data.amount.." to"..xTarget.firstName)
    end
end)
end