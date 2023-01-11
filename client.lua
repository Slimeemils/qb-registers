QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()	
	for k, v in pairs(Config.Locations) do
        exports['qb-target']:AddBoxZone(v.label, v.coords, 2, 2,{
            name = v.label,
            heading = 335,
            debugPoly = false,
        }, {
            options = {
                {
                    event = "qb-registers:openmenu",
                    icon = "fas fa-circle",
                    label = "Make a payment",
                    shop = v.name
                },
                {
                    event = "qb-registers:checkpayments",
                    icon = "fas fa-circle",
                    label = "Check recent payments",
                    shop = v.name,
                    job = v.name
                },
            },
            distance = 2
        })
    end
end)

RegisterNetEvent("qb-registers:openmenu", function(data)
    local payment = exports['qb-input']:ShowInput({
        header = "Make a payment to "..data.shop.. ".",
        submitText = "Make Payment",
        inputs = {
            {
                text = "amount",
                name = "payamount",
                type = "text",
                isRequired = true 
            },
        }
    })
    if payment ~= nil then
        if not payment.payamount then 
            return 
        end
        TriggerEvent("qb-registers:finalizepayment", payment.payamount, data.shop)
    end
end)

RegisterNetEvent("qb-registers:finalizepayment", function(amount, shop)
    TriggerServerEvent('qb-registers:sendpayment', amount, shop)
end)

RegisterNetEvent("qb-registers:checkpayments", function(data)
    QBCore.Functions.TriggerCallback("qb-registers:getpayments", function(result)
        if result == nil then
            QBCore.Functions.Notify('No recent payments...', "error", 5000)
        else
            local PaymentMenuOptions = {
                {
                    header = 'Recent Payments',
                    isMenuHeader = true
                },
            }
            for _, v in pairs(result) do

                PaymentMenuOptions[#PaymentMenuOptions + 1] = {
                    header = 'Name: '..v.name,
                    txt = '$'..v.amount,
                }
            end

            PaymentMenuOptions[#PaymentMenuOptions + 1] = {
                header = 'Clear Payments',
                txt = "",
                params = {
                    event = "qb-registers:clearpayments",
                }
            }

            PaymentMenuOptions[#PaymentMenuOptions + 1] = {
                header = 'Close Menu',
                txt = "",
                params = {
                    event = "qb-menu:closeMenu",
                }
            }
            exports['qb-menu']:openMenu(PaymentMenuOptions)
        end
    end)
end)

RegisterNetEvent("qb-registers:clearpayments", function()
    local player = QBCore.Functions.GetPlayerData()
    if player.job.grade.level > 3 then
        TriggerServerEvent("qb-registers:deletepayments")
    else
        QBCore.Functions.Notify('You do not have permission for this.', 'error', 5000)
    end
end)