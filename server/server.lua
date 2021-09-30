local CacheInfo = {}
QBCore.Functions.CreateCallback("fx-garage:server:GetVehicles",function(source, cb, garage)
    local Player = QBCore.Functions.GetPlayer(source)
    local GetVehicles = exports.oxmysql:fetchSync("SELECT * FROM player_vehicles WHERE citizenid = ? AND garage = ?",{Player.PlayerData.citizenid, garage})
    cb(GetVehicles)
end)

QBCore.Functions.CreateCallback("fx-garage:server:GetVehicleProps",function(source, cb, plate)
    local src = source
    local properties = {}
    local result = exports.oxmysql:fetchSync('SELECT mods FROM player_vehicles WHERE plate= ?', {plate})
    if result[1] ~= nil then properties = json.decode(result[1].mods) end
    cb(properties)
end)

RegisterNetEvent('fx-garage:server:SetVehicleProps',function(data,plate)
    local src = source
    local Engine = math.floor(data.engine + 0.5)
    local Body = math.floor(data.body + 0.5)
    local Mods
    local ModsPlate = exports.oxmysql:fetchSync('SELECT mods FROM player_vehicles WHERE plate = ?', {plate})
    if ModsPlate[1].mods  then
        Mods = json.decode(ModsPlate[1].mods)
        Mods.engine = data.engine
        Mods.body = data.body
    end

    local result = exports.oxmysql:fetchSync('UPDATE player_vehicles SET engine = ?,body = ? WHERE plate= ?', {Engine,Body,plate})
end)

QBCore.Functions.CreateCallback("fx-garage:server:CheckVeh",function(source, cb, plate, citizenid)
    local src = source
    local result = exports.oxmysql:executeSync( 'SELECT citizenid FROM player_vehicles WHERE plate= ?',{ plate})
    if result[1].citizenid == citizenid then cb(true) end
end)

RegisterNetEvent('fx-garage:server:UpdateState', function(plate)
    local result = exports.oxmysql:executeSync('UPDATE player_vehicles SET state = 0, garage = "" WHERE plate = ?',{plate})
end)

RegisterNetEvent('fx-garage:server:SaveCar', function(garage,plate)
    local Garage = tostring(garage)
    local Plate = tostring(plate)
    exports.oxmysql:execute('UPDATE player_vehicles SET state = 1, garage = ? WHERE plate = ?',{Garage, Plate})
end)

QBCore.Functions.CreateCallback('fx-garage:server:HasMoney',function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local Money = Player.PlayerData.money.cash
    if Money >= 2000 then
        Player.Functions.RemoveMoney("cash",2000,'Pay Impound')
        cb(true)
    else
        cb(false)
    end

end)

QBCore.Functions.CreateCallback("fx-garage:server:GetHouseVehicles",function(source, cb, house)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    exports.oxmysql:fetch('SELECT * FROM player_vehicles WHERE garage = ?', {house}, function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

QBCore.Functions.CreateCallback("qb-garage:server:checkVehicleHouseOwner",function(source, cb, plate, house)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    exports.oxmysql:fetch('SELECT * FROM player_vehicles WHERE plate = ?',{plate}, function(result)
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
