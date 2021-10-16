local cacheVeh = {}
local currentHouseGarage = nil
local InsideSaveHouse = false
local hasGarageKey = nil
local currentGarage = nil
local OutsideVehicles = {}
local PlayerGang = {}
local show = false
local DamageVeh = {}

local function OpenMenu()
    QBCore.Functions.TriggerCallback("qb-garages:server:GetVehicles",function(Vehicles)
        if type(Vehicles) == "table" then
        for k, v in ipairs(Vehicles) do
            if not cacheVeh[Vehicles[k].plate] then
                cacheVeh[Vehicles[k].plate] = {}
            end
            cacheVeh[Vehicles[k].plate].vehicle = Vehicles[k].vehicle
            cacheVeh[Vehicles[k].plate].fuel = Vehicles[k].fuel
        end
        SetNuiFocus(true, true)
        SendNUIMessage({
            show = not show,
            Vehicles = Vehicles,
            IsImpound = Garages[CurrentGarage]["impound"] or false,
            garageType = currentGarage,
            Garagelabel = Garages[CurrentGarage]["label"],
            type = "garage"
        })
    end
    end, CurrentGarage)
end

local function OpenHouseMenu()
    QBCore.Functions.TriggerCallback("qb-garages:server:GetHouseVehicles",function(Cars)
        if Cars ~= nil then
            for k, v in ipairs(Cars) do
                if not cacheVeh[Cars[k].plate] then
                    cacheVeh[Cars[k].plate] = {}
                end
                cacheVeh[Cars[k].plate].vehicle = Cars[k].vehicle
                cacheVeh[Cars[k].plate].fuel = Cars[k].fuel
            end
            SetNuiFocus(true, true)
            SendNUIMessage({
                show = not show,
                Vehicles = Cars,
                IsImpound = false,
                Garagelabel = HouseGarages[currentHouseGarage].label,
                garageType = currentHouseGarage,
                type = "house"
            })
        else
            QBCore.Functions.Notify("No Vehicles in this garage")
        end

    end, currentHouseGarage)

end

local function OpenDepotMenu()
    QBCore.Functions.TriggerCallback("qb-garages:server:GetVehicles",function(Vehicles)
        if Vehicles ~= nil then
            for k, v in ipairs(Vehicles) do
                if not cacheVeh[Vehicles[k].plate] then
                    cacheVeh[Vehicles[k].plate] = {}
                end
                cacheVeh[Vehicles[k].plate].vehicle = Vehicles[k].vehicle
                cacheVeh[Vehicles[k].plate].fuel = Vehicles[k].fuel
            end
            SetNuiFocus(true, true)
            SendNUIMessage({
                show = not show,
                Vehicles = Vehicles,
                IsImpound = true,
                garageType = CurrentGarage,
                Garagelabel = Depots[CurrentGarage]["label"],
                type = "impound"
            })
        end
    end, CurrentGarage)
end

local function OpenGangMenu()
    QBCore.Functions.TriggerCallback("qb-garages:server:GetVehicles",function(Vehicles)
        if Vehicles ~= nil then
            for k, v in ipairs(Vehicles) do
                if not cacheVeh[Vehicles[k].plate] then
                    cacheVeh[Vehicles[k].plate] = {}
                end
                cacheVeh[Vehicles[k].plate].vehicle = Vehicles[k].vehicle
                cacheVeh[Vehicles[k].plate].fuel = Vehicles[k].fuel
            end
            SetNuiFocus(true, true)
            SendNUIMessage({
                show = not show,
                Vehicles = Vehicles,
                IsImpound = false,
                garageType = CurrentGarage,
                Garagelabel = GangGarages[CurrentGarage]["label"],
                type = "gangs"
            })
        end
    end, CurrentGarage)
end


local function CloseMenu()
    SendNUIMessage({data = "hide", show = false})
    SetNuiFocus(false, false)
    currentGarage = nil
    currentHouseGarage = nil
end
-- CALLBACKS
RegisterNUICallback("ExitApp", function(data, cb)
    SetNuiFocus(false, false)
    cb({})
end)

RegisterNUICallback("OutVehicle", function(data, cb)
    local Plate = data.plate
    local Type = data.type
    SpawnVehicle(Plate, function(message) 
        cb(message) 
    end, Type)
end)

RegisterNUICallback("PayImpound", function(data, cb)
    QBCore.Functions.TriggerCallback("qb-garages:server:HasMoney",function(hasMoney)
        cb(hasMoney)
    end)
end)



function GetCarToGarage(plate, garage)
    local Player = QBCore.Functions.GetPlayerData().citizenid
    local OtherPlayer = PlayerPedId()
    local Vehicle = GetVehiclePedIsIn(OtherPlayer)
    local Engine = GetVehicleEngineHealth(Vehicle)
    local Body = GetVehicleBodyHealth(Vehicle)

    QBCore.Functions.TriggerCallback("qb-garages:server:CheckVeh", function(ID)
        if ID then
            GetVehicleDamage(Vehicle,plate)
            TriggerServerEvent("qb-garages:server:SetVehicleProps",{body=Body,engine=Engine},plate)
            TaskLeaveVehicle(OtherPlayer, Vehicle, 1)
            Wait(2000)
            if not AreAnyVehicleSeatsFree(Vehicle) then
                QBCore.Functions.Notify("Something is preventing the car to despawn \n get everyone off the car")
                return
            end
            if Vehicle then
                TriggerServerEvent("qb-garages:server:SaveCar", garage, plate)
                QBCore.Functions.DeleteVehicle(Vehicle)
            end
        end
    end, plate, Player)
end
-- https://github.com/renzuzu/renzu_garage BIG thanks to RENZU for let me grab this code
function GetVehicleDamage(vehicle,plate)
    if not  DamageVeh[plate] then
        DamageVeh[plate] = {}
    end
   
    DamageVeh[plate].wheel_tires = {}
    DamageVeh[plate].vehicle_doors = {}
    DamageVeh[plate].vehicle_window = {}
        for tireid = 1, 7 do
            local normal = IsVehicleTyreBurst(vehicle, tireid, true)
            local completely = IsVehicleTyreBurst(vehicle, tireid, false)
            if normal or completely then
                DamageVeh[plate].wheel_tires[tireid] = true
                
            else
                DamageVeh[plate].wheel_tires[tireid] = false
            end
        end
        Wait(100)
        for doorid = 0, 5 do
            DamageVeh[plate].vehicle_doors[#DamageVeh[plate].vehicle_doors+1] = IsVehicleDoorDamaged(vehicle, doorid)
        end
        Wait(500)
        for windowid = 0, 7 do
            DamageVeh[plate].vehicle_window[#DamageVeh[plate].vehicle_window+1] = IsVehicleWindowIntact(vehicle, windowid)
        end
        tPrint(DamageVeh[plate])
end

function SetVehicleDamage(vehicle,mods)
    if DamageVeh[mods.plate].wheel_tires then
        for tireid = 1, 7 do
            if DamageVeh[mods.plate].wheel_tires[tireid] ~= false then
                SetVehicleTyreBurst(vehicle, tireid, true, 1000)
            end
        end
    end
    if DamageVeh[mods.plate].vehicle_window then
        for windowid = 0, 5, 1 do
            if DamageVeh[mods.plate].vehicle_window[windowid] ~= false then
                RemoveVehicleWindow(vehicle, windowid)
            end
        end
    end
    if DamageVeh[mods.plate].vehicle_doors then
        for doorid = 0, 5, 1 do
            if DamageVeh[mods.plate].vehicle_doors[doorid] ~= false then
                SetVehicleDoorBroken(vehicle, doorid-1, true)
            end
        end
    end
end


function SpawnVehicle(plate, cb, IsHouse)
    local ped = PlayerPedId()
    local pool = GetGamePool("CVehicle")
    for i = 0, #pool do
        local Plate = pool[i]
        if DoesEntityExist(Plate) then
            if GetVehicleNumberPlateText(Plate) == plate then
                QBCore.Functions.Notify("The vehicle is outside")
                cb(false)
                return
            end
        end
    end

    if IsHouse == 'house' then
        if IsPositionOccupied(HouseGarages[currentHouseGarage].takeVehicle.x, HouseGarages[currentHouseGarage].takeVehicle.y,HouseGarages[currentHouseGarage].takeVehicle.z, 10, false, true, false, 0, 0, 0, 0) == 1 then
            QBCore.Functions.Notify("There is a vehicle Blocking the spawnPoint","error")
            cb(false)
        else
            QBCore.Functions.SpawnVehicle(cacheVeh[plate].vehicle,function(veh)
                QBCore.Functions.TriggerCallback("qb-garages:server:GetVehicleProps", function(mods)
                    QBCore.Functions.SetVehicleProperties(veh, mods)
                    SetVehicleNumberPlateText(veh, plate)
                    exports['LegacyFuel']:SetFuel(veh, cacheVeh[plate].fuel)
                    TriggerEvent("vehiclekeys:client:SetOwner",GetVehicleNumberPlateText(veh))
                    TaskWarpPedIntoVehicle(ped, veh, -1)
                    SetVehicleDamage(veh,mods)
                end, plate)
            end, HouseGarages[currentHouseGarage].takeVehicle, false)
            TriggerServerEvent("qb-garages:server:UpdateState", plate)
            DamageVeh[plate] = nil
            cb(true)
           
        end
    elseif IsHouse == "garage" then
        if IsPositionOccupied(Garages[CurrentGarage].spawnPoint.x,Garages[CurrentGarage].spawnPoint.y,Garages[CurrentGarage].spawnPoint.z, 10, false,true, false, 0, 0, 0, 0) == 1 then
            QBCore.Functions.Notify("There is a vehicle Blocking the spawnPoint","error")
            cb(false)
        else
            QBCore.Functions.SpawnVehicle(cacheVeh[plate].vehicle,function(veh)
                    QBCore.Functions.TriggerCallback("qb-garages:server:GetVehicleProps", function(mods)
                        QBCore.Functions.SetVehicleProperties(veh, mods)
                        SetVehicleNumberPlateText(veh, plate)
                        exports['LegacyFuel']:SetFuel(veh, cacheVeh[plate].fuel)
                        TriggerEvent("vehiclekeys:client:SetOwner",GetVehicleNumberPlateText(veh))
                        TaskLookAtEntity(PlayerPedId(), veh, 5000, 2048, 3)
                        SetVehicleDamage(veh,mods)
                    end, plate)
            end, Garages[CurrentGarage].spawnPoint, false)
            TriggerServerEvent("qb-garages:server:UpdateState", plate)
            DamageVeh[plate] = nil
            cb(true)
           
        end
    elseif IsHouse == "impound" then
        if IsPositionOccupied(Depots[CurrentGarage].takeVehicle.x,Depots[CurrentGarage].takeVehicle.y,Depots[CurrentGarage].takeVehicle.z, 10, false,true, false, 0, 0, 0, 0) == 1 then
            QBCore.Functions.Notify("There is a vehicle Blocking the spawnPoint")
            cb(false)
        else
            QBCore.Functions.SpawnVehicle(cacheVeh[plate].vehicle, function(veh)
                    QBCore.Functions.TriggerCallback("qb-garages:server:GetVehicleProps", function(mods)
                        QBCore.Functions.SetVehicleProperties(veh, mods)
                        SetVehicleNumberPlateText(veh, plate)
                        exports['LegacyFuel']:SetFuel(veh, cacheVeh[plate].fuel)
                        TriggerEvent("vehiclekeys:client:SetOwner",GetVehicleNumberPlateText(veh))
                        TaskWarpPedIntoVehicle(ped, veh, -1)
                        SetVehicleDamage(veh,mods)
                    end, plate)
            end, Depots[CurrentGarage].takeVehicle, false)
            TriggerServerEvent("qb-garages:server:UpdateState", plate)
            DamageVeh[plate] = nil
            cb(true)
        end
    elseif IsHouse == "gangs" then
        if IsPositionOccupied(GangGarages[CurrentGarage].spawnPoint.x,GangGarages[CurrentGarage].spawnPoint.y,GangGarages[CurrentGarage].spawnPoint.z, 10, false,true, false, 0, 0, 0, 0) == 1 then
            QBCore.Functions.Notify("There is a vehicle Blocking the spawnPoint")
            cb(false)
        else
            QBCore.Functions.SpawnVehicle(cacheVeh[plate].vehicle, function(veh)
                    QBCore.Functions.TriggerCallback("qb-garages:server:GetVehicleProps", function(mods)
                        QBCore.Functions.SetVehicleProperties(veh, mods)
                        SetVehicleNumberPlateText(veh, plate)
                        exports['LegacyFuel']:SetFuel(veh, cacheVeh[plate].fuel)
                        TriggerEvent("vehiclekeys:client:SetOwner",GetVehicleNumberPlateText(veh))
                        TaskWarpPedIntoVehicle(ped, veh, -1)
                        SetVehicleDamage(veh,mods)
                    end, plate)
                  
            end, GangGarages[CurrentGarage].spawnPoint, false)
            TriggerServerEvent("qb-garages:server:UpdateState", plate)
            DamageVeh[plate] = nil
            cb(true)
        end
    end
end
---
-- QBCORE STUFF
RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerGang = QBCore.Functions.GetPlayerData().gang
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate')
AddEventHandler('QBCore:Client:OnGangUpdate',
    function(gang) PlayerGang = gang end)

RegisterNetEvent('qb-garages:client:setHouseGarage')
AddEventHandler('qb-garages:client:setHouseGarage', function(house, hasKey)
    currentHouseGarage = house
    hasGarageKey = hasKey
end)

RegisterNetEvent('qb-garages:client:houseGarageConfig')
AddEventHandler('qb-garages:client:houseGarageConfig',
    function(garageConfig) HouseGarages = garageConfig end)

RegisterNetEvent('qb-garages:client:addHouseGarage')
AddEventHandler('qb-garages:client:addHouseGarage', function(house, garageInfo)
    HouseGarages[house] = garageInfo
end)
---
local isclose = false
local isCloseToSave = false
---BLIPS AND 3D TEXT STUFF
-- CreateThread(function()
--     Wait(1000)
--     while true do
--         Wait(5)
--         local ped = PlayerPedId()
--         local pos = GetEntityCoords(ped)
--         local inGarageRange = false
--         for k, v in pairs(Garages) do
--             local takeDist = #(pos - vector3(Garages[k].takeVehicle.x,Garages[k].takeVehicle.y, Garages[k].takeVehicle.z))
--             local saveDist = #(pos - vector3(Garages[k].putVehicle.x, Garages[k].putVehicle.y,Garages[k].putVehicle.z))
--             if takeDist <= 15 then
--                 inGarageRange = true
--                 DrawMarker(2, Garages[k].takeVehicle.x, Garages[k].takeVehicle.y, Garages[k].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0,0, 222, false, false, false, true, false, false,false)
--                 if takeDist <= 1.5 then
--                     if not IsPedInAnyVehicle(ped) then
--                         QBCore.Functions.DrawText3D(Garages[k].takeVehicle.x,Garages[k].takeVehicle.y,Garages[k].takeVehicle.z + 0.5, '~g~E~w~ - Garage')
--                         currentGarage = k
--                         isclose = true
--                     end
--                 end
--                 if takeDist >= 2 then isclose = false end
--             end

--             ------------------SAVE VEHICLE
--             if saveDist <= 15 then
--                 inGarageRange = true
--                 DrawMarker(2, Garages[k].putVehicle.x, Garages[k].putVehicle.y,
--                     Garages[k].putVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0,
--                     0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false,
--                     false, true, false, false, false)
--                 if saveDist <= 1.5 then
--                     if IsPedInAnyVehicle(ped) then
--                         QBCore.Functions.DrawText3D(Garages[k].putVehicle.x,Garages[k].putVehicle.y,Garages[k].putVehicle.z + 0.5, '~g~E~w~ - Garage')
--                         currentGarage = k
--                         isCloseToSave = true
--                     end
--                 end
--                 if saveDist >= 2 then isCloseToSave = false end
--             end
--         end

--         if not inGarageRange then Citizen.Wait(5000) end
--     end

-- end)

Citizen.CreateThread(function()
    for k, v in pairs(Garages) do
        if v.showBlip then
            local Garage = AddBlipForCoord(Garages[k].takeVehicle.x,Garages[k].takeVehicle.y,Garages[k].takeVehicle.z)
            SetBlipSprite(Garage, 357)
            SetBlipDisplay(Garage, 4)
            SetBlipScale(Garage, 0.65)
            SetBlipAsShortRange(Garage, true)
            SetBlipColour(Garage, 3)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Garages[k].label)
            EndTextCommandSetBlipName(Garage)
        end
    end

    for k, v in pairs(Depots) do
        if v.showBlip then
            local Depot = AddBlipForCoord(Depots[k].takeVehicle.x,Depots[k].takeVehicle.y,Depots[k].takeVehicle.z)
            SetBlipSprite(Depot, 68)
            SetBlipDisplay(Depot, 4)
            SetBlipScale(Depot, 0.7)
            SetBlipAsShortRange(Depot, true)
            SetBlipColour(Depot, 5)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Depots[k].label)
            EndTextCommandSetBlipName(Depot)
        end
    end

end)
RegisterKeyMapping('OpenMenu', 'Open The menu on Garage', 'keyboard', 'e')
local isInHouse = false
RegisterCommand('OpenMenu', function()
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    local plate = GetVehicleNumberPlateText(Vehicle)
    if InsideGarage then
        OpenMenu()
    elseif isInHouse then
        OpenHouseMenu()
    elseif IsInDepot then
        OpenDepotMenu()
    elseif IsInGang then
        OpenGangMenu()
    end

    if InsideSaveVehicle then
        GetCarToGarage(plate, CurrentGarage)
    elseif InsideSaveHouse then
        GetCarToGarage(plate, currentHouseGarage)
    end
end)

CreateThread(function()
    Wait(2000)
    while true do
        Wait(5)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inGarageRange = false
        if next(HouseGarages) ~= nil and currentHouseGarage ~= nil then
            if hasGarageKey and next(HouseGarages[currentHouseGarage]) and next(HouseGarages[currentHouseGarage]["takeVehicle"]) then

                local house = vector3(HouseGarages[currentHouseGarage].takeVehicle.x,HouseGarages[currentHouseGarage].takeVehicle.y,HouseGarages[currentHouseGarage].takeVehicle.z)

                local takeDist = #(pos - house)

                if takeDist <= 15 then
                    inGarageRange = true
                    DrawMarker(2,HouseGarages[currentHouseGarage].takeVehicle.x,HouseGarages[currentHouseGarage].takeVehicle.y,HouseGarages[currentHouseGarage].takeVehicle.z,
                        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15,
                        200, 0, 0, 222, false, false, false, true, false,
                        false, false)
                    if takeDist < 2.0 then
                        if not IsPedInAnyVehicle(ped) then
                            QBCore.Functions.DrawText3D(HouseGarages[currentHouseGarage].takeVehicle.x,HouseGarages[currentHouseGarage].takeVehicle.y,HouseGarages[currentHouseGarage].takeVehicle.z +
                                0.5, '~g~E~w~ - Garage ' ..
                                HouseGarages[currentHouseGarage].label)
                                isInHouse = true

                        elseif IsPedInAnyVehicle(ped) then
                            QBCore.Functions.DrawText3D(HouseGarages[currentHouseGarage].takeVehicle.x,HouseGarages[currentHouseGarage].takeVehicle.y,HouseGarages[currentHouseGarage].takeVehicle.z +
                                0.5, '~g~E~w~ - To Park')
                                isInHouse = false
                                InsideSaveHouse = true
                            end

                    end

                    if takeDist > 1.99 then 
                        takeDist = nil 
                        InsideSaveHouse = false
                        isInHouse = false
                    end
                end
            end
        end

        if not inGarageRange then Citizen.Wait(5000) end
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
