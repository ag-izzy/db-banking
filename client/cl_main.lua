Citizen.CreateThread(function()
    for k,v in pairs(Config["BankZones"]) do
    exports[Config["TargetName"]]:AddBoxZone("bank"..k, v, {
        name="bank"..k,
        useZ = true,
        options = {
            {
                event = "db-banking:open",
                label = "Open Bank",
                icon = "fas fa-hand-holding-usd"
            }
        }
    })
    end
end)

RegisterNetEvent("db-banking:open", function
    OpenGui()    
end)

function CloseGui()
    SetNuiFocus(false,false)
    SendNUIMessage({show = false})
end

function OpenGui()
    TriggerServerEvent("db-banking:openBank")
    SetNuiFocus(true,true)
    SendNUIMessage({show = true})
end

RegisterNetEvent("db-banking:recieveData", function(data)
    SendNUIMessage({
        type = "updateData",
        firstname = data.firstname,
        lastname = data.lastname,
        balance = data.balance,
    })
    Wait(500)
    OpenGui()
end)

RegisterNUICallback("close", CloseGui())

RegisterNUICallback("withdraw", function(data)
    TriggerServerEvent("db-banking:withdraw", data.amount)
end)

RegisterNUICallback("deposit", function(data)
    TriggerServerEvent("db-banking:deposit", data.amount)
end)

RegisterNUICallback("transfer", function(data)
    TriggerServerEvent("db-banking:transfer", data)
end)
