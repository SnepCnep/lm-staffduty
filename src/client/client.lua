-- // [STARTUP] \\ --
lib.locale() -- Register ox locales
LM = { ["Functions"] = {} } -- Vairable handler.

-- // [FUNCTIONS] \\ --

LM.Functions:createExport = function(exportName, exportFunc)
    AddEventHandler(('__cfx_export_lm-staffduty_%s'):format(exportName), function(setCB)
        setCB(exportName)
    end)
end

-- // [EXPORTS] \\ --

LM.Functions:createExport("isOnDuty", function()
    local status = LocalPlayer.state?.isOnDuty
    return (status or false)
end

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
