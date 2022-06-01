Citizen.CreateThread(function()
    for k,v in pairs(Config.BankZones) do
        exports[Config.TargetName]:AddBoxZone("bank"..k, v, 0.5, 0.5, {
            name="bank"..k,
            heading=90,
            debugPoly=false,
            minZ=v.z -0.8,
            maxZ=v.z +0.8,
        }, {
            options = {
                {
                    event = "db-banking:open",
                    label = "Open Bank",
                    icon = "fas fa-hand-holding-usd"
                }
            }
        })
    end
    exports[Config.TargetName]:AddTargetModel(Config.ATMS, {
        options = {
            {
                event = "db-banking:open",
                label = "Open Bank",
                icon = "fas fa-hand-holding-usd"
            }
        }
    })
end)

RegisterNetEvent('db-banking:open', function(data)
    if Config.Framework == 'qb' then
        local QBCore = exports['qb-core']:GetCoreObject()
        QBCore.Functions.TriggerCallback('db-bank:GetData', function(data)
            SendNUIMessage({
                show = true,
                firstname = data.firstname,
                lastname = data.lastname,
                balance = data.balance,
                transactions = data.transactions,
            })
            SetNuiFocus(true, true)
        end)
    elseif Config.Framework == 'esx' then
        local ESX = exports['es_extended']:getSharedObject()
        ESX.TriggerServerCallback('db-bank:GetData', function(data)
            SendNUIMessage({
                show = true,
                firstname = data.firstname,
                lastname = data.lastname,
                balance = data.balance,
                transactions = data.transactions,
            })
            SetNuiFocus(true, true)
        end)
    end
end)

RegisterCommand('opbank', function()
    if Config.Framework == 'qb' then
        local QBCore = exports['qb-core']:GetCoreObject()
        QBCore.Functions.TriggerCallback('db-bank:GetData', function(data)
            SendNUIMessage({
                show = true,
                firstname = data.firstname,
                lastname = data.lastname,
                balance = data.balance,
                transactions = data.transactions,
            })
            SetNuiFocus(true, true)
        end)
    elseif Config.Framework == 'esx' then
        local ESX = exports['es_extended']:getSharedObject()
        ESX.TriggerServerCallback('db-bank:GetData', function(data)
            SendNUIMessage({
                show = true,
                firstname = data.firstname,
                lastname = data.lastname,
                balance = data.balance,
                transactions = data.transactions,
            })
            SetNuiFocus(true, true)
        end)
    end
end)

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        show = false,
    })
end)

RegisterNUICallback('withdraw', function(data)
    TriggerServerEvent('db-banking:withdraw', data.amount)
end)

RegisterNUICallback('deposit', function(data)
    TriggerServerEvent('db-banking:deposit', data.amount)
end)

RegisterNUICallback('transfer', function(data)
    TriggerServerEvent('db-banking:transfer', data)
end)
