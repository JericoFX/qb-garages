QBCore.Functions.CreateCallback("fx-garage:server:GetVehicles",
                                function(source, cb, garage)
    local Player = QBCore.Functions.GetPlayer(source)
    local GetVehicles = exports.oxmysql:fetchSync(
                            "SELECT * FROM player_vehicles WHERE citizenid = ? AND garage = ?",
                            {Player.PlayerData.citizenid, garage})
    cb(GetVehicles)
end)

QBCore.Functions.CreateCallback("fx-garage:server:GetVehicleProps",
                                function(source, cb, plate)
    local src = source
    local properties = {}
    local result = exports.oxmysql:fetchSync(
                       'SELECT mods FROM player_vehicles WHERE plate=@plate',
                       {['@plate'] = plate})
    if result[1] ~= nil then properties = json.decode(result[1].mods) end
    cb(properties)
end)

QBCore.Functions.CreateCallback("fx-garage:server:CheckVeh",
                                function(source, cb, plate, citizenid)
    local src = source
    local result = exports.oxmysql:executeSync(
                       'SELECT citizenid FROM player_vehicles WHERE plate=@plate',
                       {['@plate'] = plate})
    print(citizenid, result[1].citizenid)
    if result[1].citizenid == citizenid then cb(true) end
end)

RegisterNetEvent('fx-garage:server:UpdateState', function(plate)
    local result = exports.oxmysql:executeSync(
                       'UPDATE player_vehicles SET state = 0, garage = "" WHERE plate = @plate',
                       {['@plate'] = plate})
end)

RegisterNetEvent('veh:server:SaveCar', function(data)
    print(data[1], data[2], data[3])
    local result = exports.oxmysql:executeSync(
                       'UPDATE player_vehicles SET state = 1, garage = @garage, mods = @mods WHERE plate = @plate',
                       {
            ['@plate'] = data[3],
            ['@garage'] = data[2],
            ['@mods'] = json.encode(data[1])
        })
end)

QBCore.Functions.CreateCallback('fx-garage:server:HasMoney',
                                function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local Money = Player.PlayerData.money.cash
    cb(Money)
end)

QBCore.Functions.CreateCallback("fx-garage:server:GetHouseVehicles",
                                function(source, cb, house)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)

    exports.oxmysql:fetch('SELECT * FROM player_vehicles WHERE garage = ?',
                          {house}, function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

QBCore.Functions.CreateCallback("qb-garage:server:checkVehicleHouseOwner",
                                function(source, cb, plate, house)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    exports.oxmysql:fetch('SELECT * FROM player_vehicles WHERE plate = ?',
                          {plate}, function(result)
        if result[1] ~= nil then
            local hasHouseKey = exports['qb-houses']:hasKey(result[1].license,
                                                            result[1].citizenid,
                                                            house)
            if hasHouseKey then
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)
