-- // [STARTUP] \\ --
lib.locale()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(PlayerData)
    ESX.PlayerData = PlayerData
    ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
    ESX.PlayerLoaded = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(Job)
    ESX.PlayerData.job = Job
end)

-- // [THREADS] \\ --

CreateThread(function()
    while not ESX.PlayerLoaded do Wait(0) end

    TriggerEvent("txcl:setAdmin", false, false, locale("no_access"))
end)

-- // [STATEBAG] \\ --

AddStateBagChangeHandler('isOnDuty', nil, function(bagName, key, value, _reserved, replicated)
    lib.callback('lm-staffduty:cb:getPlayerSkin', false, function(skin)
        if value then
            TriggerServerEvent('txsv:checkIfAdmin')

            return lib.notify({ title = locale("duty_on"), type = 'infrom', position = 'top' })
        else
            TriggerEvent('skinchanger:loadSkin', skin)
            TriggerEvent('txcl:setAdmin', false, false, locale("no_access"))

            return lib.notify({ title = locale("duty_off"), type = 'infrom', position = 'top' })
        end
    end)
end)