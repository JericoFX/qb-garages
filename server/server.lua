local CacheInfo = {}
QBCore.Functions.CreateCallback("qb-garages:server:GetVehicles",function(source, cb, garage)
    local Player = QBCore.Functions.GetPlayer(source)
    local GetVehicles = exports.oxmysql:fetchSync("SELECT * FROM player_vehicles WHERE citizenid = ? AND garage = ?",{Player.PlayerData.citizenid, garage})
    cb(GetVehicles)
end)

QBCore.Functions.CreateCallback("qb-garages:server:GetVehicleProps",function(source, cb, plate)
    local src = source
    local properties = {}
    local result = exports.oxmysql:fetchSync('SELECT mods FROM player_vehicles WHERE plate= ?', {plate})
    if result[1] ~= nil then properties = json.decode(result[1].mods) end
    cb(properties)
end)

RegisterNetEvent('qb-garages:server:SetVehicleProps',function(data,plate)
    local src = source
    local Engine = math.floor(data.engine + 0.5)
    local Body = math.floor(data.body + 0.5)
    print(Engine,Body)
    local result = exports.oxmysql:fetchSync('UPDATE player_vehicles SET engine = ?,body = ? WHERE plate= ?', {Engine,Body,plate})
end)

QBCore.Functions.CreateCallback("qb-garages:server:CheckVeh",function(source, cb, plate, citizenid)
    local src = source
    local result = exports.oxmysql:executeSync( 'SELECT citizenid FROM player_vehicles WHERE plate= ?',{ plate})
    if result[1].citizenid == citizenid then cb(true) end
end)

RegisterNetEvent('qb-garages:server:UpdateState', function(plate)
    local result = exports.oxmysql:executeSync('UPDATE player_vehicles SET state = 0, garage = "" WHERE plate = ?',{plate})
end)

RegisterNetEvent('qb-garages:server:SaveCar', function(garage,plate)
    print(garage,plate)
    local Garage = tostring(garage)
    local Plate = tostring(plate)
    exports.oxmysql:execute('UPDATE player_vehicles SET state = 1, garage = ? WHERE plate = ?',{Garage, Plate})
end)

QBCore.Functions.CreateCallback('qb-garages:server:HasMoney',function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local Money = Player.PlayerData.money.cash
    if Money >= 2000 then
        Player.Functions.RemoveMoney("cash",2000,'Pay Impound')
        cb(true)
    else
        cb(false)
    end
    
end)

QBCore.Functions.CreateCallback("qb-garages:server:GetHouseVehicles",function(source, cb, house)
    print(house)
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
            local hasHouseKey = exports['qb-houses']:hasKey(result[1].license, result[1].citizenid,house)
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
RegisterServerEvent('qb-garage:server:GetImpounded', function(citizenid)
    if citizenid then
    local Plate = exports.oxmysql:fetchSync('SELECT plate FROM player_vehicles WHERE state = 0 AND citizenid = ?',{citizenid})
        if Plate then
          for k,v in pairs(Plate) do
             local result = exports.oxmysql:executeSync('UPDATE player_vehicles SET state = 2, garage = "hayesdepot" WHERE plate = ? ',{Plate[k].plate})
          end
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
    local Plate = exports.oxmysql:fetchSync('SELECT plate FROM player_vehicles WHERE state = 0') 
         if Plate then
            for k,v in pairs(Plate) do
                local result = exports.oxmysql:executeSync('UPDATE player_vehicles SET state = 2, garage = "'..Config.DefaultDepot..'" WHERE plate = ? ',{Plate[k].plate})
            end
         end
end)
