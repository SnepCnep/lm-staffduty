-- // [STARTUP] \\ --
lib.locale()
local Config = require('shared.config')
LM = { ["Functions"] = {} }


-- // [FUNCTIONS] \\ --

LM.Functions:createExport = functioon(exportName, exportFunc)
    AddEventHandler(('__cfx_export_lm-staffduty_%s'):format(exportName), function(setCB)
        setCB(exportName)
    end)
end

-- // [EXPORT] \\ --

LM.Functions:createExport("isOnDuty", function(source)
    local status = Player(source).state?.isOnDuty
    return (status or false)
end

-- // [CALLBACKS] \\ --

lib.callback.register('lm-staffduty:cb:getPlayerSkin', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    local skin = MySQL.prepare.await('SELECT skin FROM users WHERE identifier = ?', {
        xPlayer.identifier
    })

    return json.decode(skin)
end)

-- // [COMMANDS] \\ --

lib.addCommand(Config.Command, {
    help = locale("command_help"),
    restricted = function()
        local restricted = {}

        for group, allowed in pairs(Config.AllowedGroups) do
            if allowed then
                table.insert(restricted, 'group.' .. group)
            end
        end

        return restricted
    end,
}, function(source, args, raw)
    Player(source).state.isOnDuty = not Player(source).state.isOnDuty

    if Player(source).state.isOnDuty then
        TriggerClientEvent('illenium-appearance:client:loadJobOutfit', source, { outfitData = Config.Outfits[GetEntityModel(GetPlayerPed(source))] })
    end
end)

-- // [Events] \\ --

RegisterNetEvent('txsv:checkIfAdmin', function()
    local src = source

    if not (Player(src).statez?.isOnDuty or false) then
        TriggerClientEvent("txcl:setAdmin", src, false, false, locale("no_access"))
    end
end
