local cacheVeh = {}
local currentHouseGarage = nil
local hasGarageKey = nil
local currentGarage = nil
local OutsideVehicles = {}
local PlayerGang = {}
local show = false
local CachedCamera = nil
local DamageVeh = {}

local function OpenMenu()
    QBCore.Functions.TriggerCallback("fx-garage:server:GetVehicles",function(Vehicles)
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
            IsImpound = Garages[currentGarage]["impound"] or false,
            garageType = currentGarage,
            Garagelabel = Garages[currentGarage]["label"],
            type = "garage"
        })
    end, currentGarage)
end
local function OpenHouseMenu()
    QBCore.Functions.TriggerCallback("fx-garage:server:GetHouseVehicles",function(Cars)
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
    QBCore.Functions.TriggerCallback("fx-garage:server:GetVehicles",function(Vehicles)
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
                garageType = currentGarage,
                Garagelabel = Depots[currentGarage]["label"],
                type = "impound"
            })
        end
    end, currentGarage)
end
local function OpenGangMenu(garage)
    QBCore.Functions.TriggerCallback("fx-garage:server:GetVehicles",function(Vehicles)
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
                garageType = garage,
                Garagelabel = GangGarages[garage]["label"],
                type = "gangs"
            })
        end
    end, garage)
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
    SpawnVehicle(Plate, function(message) cb(message) end, Type)
end)
RegisterNUICallback("PayImpound", function(data, cb)
    QBCore.Functions.TriggerCallback("fx-garage:server:HasMoney",function(hasMoney) 
      cb(hasMoney) 
    end)
end)


function GetCarToGarage(plate, garage)

    local Player = QBCore.Functions.GetPlayerData().citizenid
    local OtherPlayer = PlayerPedId()
    local Vehicle = GetVehiclePedIsIn(OtherPlayer)
    local Engine = GetVehicleEngineHealth(Vehicle)
    local Body = GetVehicleBodyHealth(Vehicle)
    
    QBCore.Functions.TriggerCallback("fx-garage:server:CheckVeh", function(ID)
        if ID then
            GetVehicleDamage(Vehicle,plate)
            TriggerServerEvent("fx-garage:server:SetVehicleProps",{body=Body,engine=Engine},plate)
          
            TaskLeaveVehicle(OtherPlayer, Vehicle, 1)
          
            Wait(2000)
            if not AreAnyVehicleSeatsFree(Vehicle) then
                QBCore.Functions.Notify("Something is preventing the car to despawn")
                return
            end
            if Vehicle then
                TriggerServerEvent("veh:server:SaveCar", garage, plate)
                QBCore.Functions.DeleteVehicle(Vehicle)
            end
        end
    end, plate, Player)
end

-- function GetVehicleDamage(Vehicle,Plate)
    
--     if not DamageVeh[Plate] then
--         DamageVeh[Plate] = {}
--         DamageVeh[Plate].OldVehicle = Vehicle
--     end
--     --Windows
--     for i = 0,5 do
--         if IsVehicleTyreBurst(Vehicle, i, false) then
--           table.insert(DamageVeh[Plate],{ wheels = i})
 
--         end
--     end
    

-- end

-- function SetVehicleDamage(Vehicle,plate)
--     if DamageVeh[plate] then
--         for k,v in pairs(DamageVeh[plate]) do
--             SetVehicleTyreBurst(Vehicle, v.wheels, true, 1000)
--         end
--     end
-- end DOEST WORK YET


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
            cb(false)
        else
            QBCore.Functions.SpawnVehicle(cacheVeh[plate].vehicle,function(veh)
                QBCore.Functions.TriggerCallback("fx-garage:server:GetVehicleProps", function(mods)
                        QBCore.Functions.SetVehicleProperties(veh, mods)
                        SetVehicleNumberPlateText(veh, plate)
                        exports['LegacyFuel']:SetFuel(veh, cacheVeh[plate].fuel)
                        TriggerEvent("vehiclekeys:client:SetOwner",GetVehicleNumberPlateText(veh))
                        TaskWarpPedIntoVehicle(ped, veh, -1)
                    end, plate)
            end, HouseGarages[currentHouseGarage].takeVehicle, false)
            TriggerServerEvent("fx-garage:server:UpdateState", plate)
            cb(true)

        end
    elseif IsHouse == "garage" then
        if IsPositionOccupied(Garages[currentGarage].spawnPoint.x,
                              Garages[currentGarage].spawnPoint.y,
                              Garages[currentGarage].spawnPoint.z, 10, false,
                              true, false, 0, 0, 0, 0) == 1 then
            cb(false)
        else
            QBCore.Functions.SpawnVehicle(cacheVeh[plate].vehicle,function(veh)
             --   
             
                QBCore.Functions.TriggerCallback("fx-garage:server:GetVehicleProps", function(mods)
                        QBCore.Functions.SetVehicleProperties(veh, mods)
                       
                       
                        SetVehicleNumberPlateText(veh, plate)
                        exports['LegacyFuel']:SetFuel(veh, cacheVeh[plate].fuel)
                        TriggerEvent("vehiclekeys:client:SetOwner",
                                     GetVehicleNumberPlateText(veh))
                        TaskLookAtEntity(PlayerPedId(), veh, 5000, 2048, 3)
                        
                      
                    end, plate)
            end, Garages[currentGarage].spawnPoint, false)
            TriggerServerEvent("fx-garage:server:UpdateState", plate)
            cb(true)

        end
    elseif IsHouse == "impound" then
        if IsPositionOccupied(Depots[currentGarage].takeVehicle.x,Depots[currentGarage].takeVehicle.y,Depots[currentGarage].takeVehicle.z, 10, false,true, false, 0, 0, 0, 0) == 1 then
            cb(false)
        else
            QBCore.Functions.SpawnVehicle(cacheVeh[plate].vehicle, function(veh)
                QBCore.Functions.TriggerCallback("fx-garage:server:GetVehicleProps", function(mods)
                        QBCore.Functions.SetVehicleProperties(veh, mods)
                        SetVehicleNumberPlateText(veh, plate)
                        exports['LegacyFuel']:SetFuel(veh, cacheVeh[plate].fuel)
                        TriggerEvent("vehiclekeys:client:SetOwner",GetVehicleNumberPlateText(veh))
                        TaskWarpPedIntoVehicle(ped, veh, -1)
                end, plate)
            end, Depots[currentGarage].takeVehicle, false)
            TriggerServerEvent("fx-garage:server:UpdateState", plate)
            cb(true)
        end
    elseif IsHouse == "gangs" then
        if IsPositionOccupied(GangGarages[currentGarage].spawnPoint.x,GangGarages[currentGarage].spawnPoint.y,GangGarages[currentGarage].spawnPoint.z, 10, false,true, false, 0, 0, 0, 0) == 1 then
            cb(false)
        else
            QBCore.Functions.SpawnVehicle(cacheVeh[plate].vehicle, function(veh)
                QBCore.Functions.TriggerCallback("fx-garage:server:GetVehicleProps", function(mods)
                        QBCore.Functions.SetVehicleProperties(veh, mods)
                        SetVehicleNumberPlateText(veh, plate)
                        exports['LegacyFuel']:SetFuel(veh, cacheVeh[plate].fuel)
                        TriggerEvent("vehiclekeys:client:SetOwner",GetVehicleNumberPlateText(veh))
                        TaskWarpPedIntoVehicle(ped, veh, -1)
                end, plate)
            end, GangGarages[currentGarage].spawnPoint, false)
            TriggerServerEvent("fx-garage:server:UpdateState", plate)
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
CreateThread(function()
    Wait(1000)
    while true do
        Wait(5)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inGarageRange = false
        for k, v in pairs(Garages) do
            local takeDist = #(pos - vector3(Garages[k].takeVehicle.x,Garages[k].takeVehicle.y, Garages[k].takeVehicle.z))
            local saveDist = #(pos - vector3(Garages[k].putVehicle.x, Garages[k].putVehicle.y,Garages[k].putVehicle.z))
            if takeDist <= 15 then
                inGarageRange = true
                DrawMarker(2, Garages[k].takeVehicle.x, Garages[k].takeVehicle.y, Garages[k].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0,0, 222, false, false, false, true, false, false,false)
                if takeDist <= 1.5 then
                    if not IsPedInAnyVehicle(ped) then
                        QBCore.Functions.DrawText3D(Garages[k].takeVehicle.x,Garages[k].takeVehicle.y,Garages[k].takeVehicle.z + 0.5, '~g~E~w~ - Garage')
                        currentGarage = k
                        isclose = true
                    end
                end
                if takeDist >= 2 then isclose = false end
            end

            ------------------SAVE VEHICLE
            if saveDist <= 15 then
                inGarageRange = true
                DrawMarker(2, Garages[k].putVehicle.x, Garages[k].putVehicle.y,
                           Garages[k].putVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0,
                           0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false,
                           false, true, false, false, false)
                if saveDist <= 1.5 then
                    if IsPedInAnyVehicle(ped) then
                        QBCore.Functions.DrawText3D(Garages[k].putVehicle.x,Garages[k].putVehicle.y,Garages[k].putVehicle.z + 0.5, '~g~E~w~ - Garage')
                        currentGarage = k
                        isCloseToSave = true
                    end
                end
                if saveDist >= 2 then isCloseToSave = false end
            end
        end

        if not inGarageRange then Citizen.Wait(5000) end
    end

end)

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
local IsInImpound = false
local isInHouse = false
-- 1) Name of the command, 2) Description,3) Can be keyboard, mouse_button, 4) can be anyone
RegisterCommand('OpenMenu', function()
    if isclose then
        OpenMenu()
    elseif isInHouse then
        OpenHouseMenu()
    elseif IsInImpound then
        OpenDepotMenu()
    end

    if isCloseToSave then
        local Vehicle = GetVehiclePedIsIn(PlayerPedId())
        local plate = GetVehicleNumberPlateText(Vehicle)
        GetCarToGarage(plate, currentGarage)
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

                            if IsControlJustPressed(1, 38) then

                                PlaySound(-1, "SELECT",
                                          "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0,
                                          1)

                                isInHouse = true
                            end

                        elseif IsPedInAnyVehicle(ped) then
                            QBCore.Functions.DrawText3D(HouseGarages[currentHouseGarage].takeVehicle.x,HouseGarages[currentHouseGarage].takeVehicle.y,HouseGarages[currentHouseGarage].takeVehicle.z +
                                    0.5, '~g~E~w~ - To Park')
                            if IsControlJustPressed(0, 38) then
                                local curVeh = GetVehiclePedIsIn(ped)
                                local plate = GetVehicleNumberPlateText(curVeh)
                                GetCarToGarage(plate, currentHouseGarage)
                            end
                        end

                    end

                    if takeDist > 1.99 then takeDist = nil end
                end
            end
        end

        if not inGarageRange then Citizen.Wait(5000) end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inGarageRange = false

        for k, v in pairs(Depots) do
            local takeDist = #(pos - vector3(Depots[k].takeVehicle.x,Depots[k].takeVehicle.y,Depots[k].takeVehicle.z))
            if takeDist <= 15 then
                inGarageRange = true
                DrawMarker(2, Depots[k].takeVehicle.x, Depots[k].takeVehicle.y,
                           Depots[k].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0,
                           0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false,
                           false, true, false, false, false)
                if takeDist <= 1.5 then
                    if not IsPedInAnyVehicle(ped) then
                        QBCore.Functions.DrawText3D(Depots[k].takeVehicle.x,
                                                    Depots[k].takeVehicle.y,
                                                    Depots[k].takeVehicle.z +
                                                        0.5, '~g~E~w~ - Garage')

                        if IsControlJustPressed(0, 38) then
                            currentGarage = k
                            IsInImpound = true
                        end
                    end
                end

                if takeDist >= 4 then CloseMenu() end
            end
        end

        if not inGarageRange then Citizen.Wait(5000) end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inGarageRange = false
        if PlayerGang.name ~= nil then
        Name = PlayerGang.name.."garage"
        end
         for k, v in pairs(GangGarages) do
            if PlayerGang.name == GangGarages[k].job then
                local ballasDist = #(pos - vector3(GangGarages[Name].takeVehicle.x, GangGarages[Name].takeVehicle.y, GangGarages[Name].takeVehicle.z))
                if ballasDist <= 15 then
                    inGarageRange = true
                    DrawMarker(2, GangGarages[Name].takeVehicle.x, GangGarages[Name].takeVehicle.y, GangGarages[Name].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                    if ballasDist <= 1.5 then
                        if not IsPedInAnyVehicle(ped) then
                            QBCore.Functions.DrawText3D(GangGarages[Name].takeVehicle.x, GangGarages[Name].takeVehicle.y, GangGarages[Name].takeVehicle.z + 0.5, '~g~E~w~ - '..GangGarages[Name]["label"].. ' Garage')
                            if IsControlJustPressed(0, 38) then
                                
                                OpenGangMenu(Name)
                                currentGarage = Name
                               
                            end
                        else
                            QBCore.Functions.DrawText3D(GangGarages[Name].takeVehicle.x, GangGarages[Name].takeVehicle.y, GangGarages[Name].takeVehicle.z, GangGarages[Name].label)
                        end
                    end
                    if ballasDist >= 4  then
                      CloseMenu()
                    end
                end

                local putDist = #(pos - vector3(GangGarages[Name].putVehicle.x, GangGarages[Name].putVehicle.y, GangGarages[Name].putVehicle.z))

                if putDist <= 25 and IsPedInAnyVehicle(ped) then
                    inGarageRange = true
                    DrawMarker(2, GangGarages[Name].putVehicle.x, GangGarages[Name].putVehicle.y, GangGarages[Name].putVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 255, 255, 255, false, false, false, true, false, false, false)
                    if putDist <= 1.5 then
                        QBCore.Functions.DrawText3D(GangGarages[Name].putVehicle.x, GangGarages[Name].putVehicle.y, GangGarages[Name].putVehicle.z + 0.5, '~g~E~w~ - Park Vehicle')
                        if IsControlJustPressed(0, 38) then
                            local curVeh = GetVehiclePedIsIn(ped)
                            local plate = GetVehicleNumberPlateText(curVeh)
                            GetCarToGarage(plate, Name)
                        end
                    end
                end
            end
        end
        if not inGarageRange then
            Citizen.Wait(1000)
        end
    end
end)