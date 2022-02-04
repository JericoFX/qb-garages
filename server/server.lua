local QBCore = exports['qb-core']:GetCoreObject()
local CacheInfo = {}

QBCore.Functions.CreateCallback("qb-garages:server:GetVehicles",function(source, cb, garage)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local GetVehicles = MySQL.query.await("SELECT * FROM player_vehicles WHERE citizenid = ? AND garage = ?",{Player.PlayerData.citizenid, garage})
    QBCore.Debug(GetVehicles)
    cb(GetVehicles)
end)

QBCore.Functions.CreateCallback("qb-garages:server:GetVehicleProps",function(source, cb, plate)
    local src = source
    local properties = {}
    local result = MySQL.query.await('SELECT mods FROM player_vehicles WHERE plate= ?', {plate})
    --local result2 = MySQL.prepare.await('SELECT body,engine,fuel FROM player_vehicles WHERE plate= ?', {plate})
    if result[1] then
      cb(json.decode(result[1].mods))
    end
end)

RegisterServerEvent('SaveWeelsDamage', function(Ta,plate)
    if not Ta or not plate then
        print("No Damage Detected ommiting ")
        return
    end

    local result = MySQL.prepare.await('UPDATE player_vehicles SET damages = ? WHERE plate = ?  ',{json.encode(Ta),plate})
end)

QBCore.Functions.CreateCallback('qb-garages:server:ReturnDamage',function(source,cb,plate)

    local result = MySQL.prepare.await('SELECT damages FROM player_vehicles WHERE plate = ?',{plate})
    cb(json.decode(result[1].damages))
end)


RegisterNetEvent('qb-garages:server:SetVehicleProps',function(data,plate)
    local src = source
    local result = MySQL.query.await('UPDATE player_vehicles SET mods = ? WHERE plate= ?', {json.encode(data),plate})
end)

QBCore.Functions.CreateCallback("qb-garages:server:CheckVeh",function(source, cb, plate, citizenid)
    local src = source
    local result = MySQL.query.await( 'SELECT citizenid FROM player_vehicles WHERE plate= ?',{ plate})
    if result[1].citizenid == citizenid then cb(true) end
end)

RegisterNetEvent('qb-garages:server:UpdateState', function(plate)
    local result = MySQL.query.await('UPDATE player_vehicles SET state = 0, garage = "" WHERE plate = ?',{plate})
end)

RegisterNetEvent('qb-garages:server:SaveCar', function(garage,plate)
    local Garage = tostring(garage)
    local Plate = tostring(plate)
    MySQL.prepare('UPDATE player_vehicles SET state = 1, garage = ? WHERE plate = ?',{Garage, Plate})
end)

QBCore.Functions.CreateCallback('qb-garages:server:HasMoney',function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local Money = Player.PlayerData.money.cash
    if Money >= 2000 then
        Player.Functions.RemoveMoney("cash",Config.ImpoundMoney,'Pay Impound')
        cb(true)
    else
        cb(false)
    end
    
end)

QBCore.Functions.CreateCallback("qb-garages:server:GetHouseVehicles",function(source, cb, house)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    MySQL.query('SELECT * FROM player_vehicles WHERE garage = ?', {house}, function(result)
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
    MySQL.query('SELECT * FROM player_vehicles WHERE plate = ?',{plate}, function(result)
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
    local Plate = MySQL.prepare.await('SELECT plate FROM player_vehicles WHERE state = 0 AND citizenid = ?',{citizenid})
        if Plate then
          for k,v in pairs(Plate) do
             local result = MySQL.query.await('UPDATE player_vehicles SET state = 2, garage = "hayesdepot" WHERE plate = ? ',{Plate[k].plate})
          end
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
    local Plate = MySQL.query.await('SELECT plate FROM player_vehicles WHERE state = 0') 
         if Plate then
            for k,v in pairs(Plate) do
                local result = MySQL.query.await('UPDATE player_vehicles SET state = 2, garage = "'..Config.DefaultDepot..'" WHERE plate = ? ',{Plate[k].plate})
            end
         end
end)


function tPrint(tbl, indent)
    indent = indent or 0
    for k, v in pairs(tbl) do
        local tblType = type(v)
        local formatting = ("%s ^3%s:^0"):format(string.rep("  ", indent), k)

        if tblType == "table" then
            print(formatting)
            tPrint(v, indent + 1)
        elseif tblType == 'boolean' then
            print(("%s^1 %s ^0"):format(formatting,v))
        elseif tblType == "function" then
            print(("%s^9 %s ^0"):format(formatting,v))
        elseif tblType == 'number' then
            print(("%s^5 %s ^0"):format(formatting,v))
        elseif tblType == 'string' then
            print(("%s ^2'%s' ^0"):format(formatting,v))
        else
            print(("%s^2 %s ^0"):format(formatting,v))
        end
    end
end
