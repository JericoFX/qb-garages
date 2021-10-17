local cacheVeh = {}
local currentHouseGarage = nil
local InsideSaveHouse = false
local hasGarageKey = nil
local currentGarage = nil
local OutsideVehicles = {}
local PlayerGang = {}
local show = false


local function OpenMenu()
    QBCore.Functions.TriggerCallback("qb-garages:server:GetVehicles",function(Vehicles)
        if type(Vehicles) == "table" then
            for k, v in ipairs(Vehicles) do
                if not cacheVeh[Vehicles[k].plate] then
                    cacheVeh[Vehicles[k].plate] = {}
                end
                cacheVeh[Vehicles[k].plate].vehicle = Vehicles[k].vehicle
                cacheVeh[Vehicles[k].plate].fuel = Vehicles[k].fuel
                cacheVeh[Vehicles[k].plate].body = Vehicles[k].body
                cacheVeh[Vehicles[k].plate].engine = Vehicles[k].engine
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
                cacheVeh[Cars[k].plate].body = Cars[k].body
                cacheVeh[Cars[k].plate].engine = Cars[k].engine
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
                cacheVeh[Vehicles[k].plate].body = Vehicles[k].body
                cacheVeh[Vehicles[k].plate].engine = Vehicles[k].engine
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
                cacheVeh[Vehicles[k].plate].body = Vehicles[k].body
                cacheVeh[Vehicles[k].plate].engine = Vehicles[k].engine
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
                    SetVehicleBodyHealth(veh, cacheVeh[plate].body)
                    SetVehicleEngineHealth(veh, cacheVeh[plate].engine)
                    SetVehicleNumberPlateText(veh, plate)
                    exports['LegacyFuel']:SetFuel(veh, cacheVeh[plate].fuel)
                    TriggerEvent("vehiclekeys:client:SetOwner",GetVehicleNumberPlateText(veh))
                    TaskWarpPedIntoVehicle(ped, veh, -1)
                    SetVehicleDamage(veh,mods,plate)

                end, plate)
                DamageVeh[plate] = nil
            end, HouseGarages[currentHouseGarage].takeVehicle, false)
            TriggerServerEvent("qb-garages:server:UpdateState", plate)
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
                    SetVehicleDamage(veh,mods,plate)
                    Wait(500)
                    DamageVeh[plate] = nil
                end, plate)
            end, Garages[CurrentGarage].spawnPoint, false)
            TriggerServerEvent("qb-garages:server:UpdateState", plate)

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
                    SetVehicleDamage(veh,mods,plate)
                    Wait(500)
                    DamageVeh[plate] = nil
                end, plate)
            end, Depots[CurrentGarage].takeVehicle, false)
            TriggerServerEvent("qb-garages:server:UpdateState", plate)

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
                    SetVehicleDamage(veh,mods,plate)
                    Wait(500)
                    DamageVeh[plate] = nil
                end, plate)

            end, GangGarages[CurrentGarage].spawnPoint, false)
            TriggerServerEvent("qb-garages:server:UpdateState", plate)

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
