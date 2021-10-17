local DamageVeh = {}

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

--///////--


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


function GetVehicleDamage(vehicle,plate)
    if not DamageVeh[plate] then
        DamageVeh[plate] = {
            wheel_tires = {},
            vehicle_doors = {},
            vehicle_window = {}
        }
    end
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
    TriggerServerEvent("SaveWeelsDamage",DamageVeh[plate],plate)
end

function SetVehicleDamage(vehicle,mods,plate)
    if not DamageVeh[plate] then
        DamageVeh[plate] = {
            wheel_tires = {},
            vehicle_doors = {},
            vehicle_window = {}
        }  -- if the table is empty, fill the data from the database
        QBCore.Functions.TriggerCallback("qb-garages:server:ReturnDamage",function(Damage)
            if Damage then
                DamageVeh[plate].wheel_tires = Damage.wheel_tires
                DamageVeh[plate].vehicle_window = Damage.vehicle_window
                DamageVeh[plate].vehicle_doors = Damage.vehicle_doors
            end
        end,plate)
    end
    Wait(200)
    if DamageVeh[plate].wheel_tires then
        for tireid = 1, 7 do
            if DamageVeh[plate].wheel_tires[tireid] ~= false then
                SetVehicleTyreBurst(vehicle, tireid, true, 1000)
            end
        end
    end
    if DamageVeh[plate].vehicle_window then
        for windowid = 0, 5, 1 do
            if DamageVeh[plate].vehicle_window[windowid] ~= false then
                RemoveVehicleWindow(vehicle, windowid)
            end
        end
    end
    if DamageVeh[plate].vehicle_doors then
        for doorid = 0, 5, 1 do
            if DamageVeh[plate].vehicle_doors[doorid] ~= false then
                SetVehicleDoorBroken(vehicle, doorid-1, true)
            end
        end
    end
    Wait(500)
    DamageVeh[plate] = nil
end

-- https://github.com/renzuzu/renzu_garage BIG thanks to RENZU for let me grab this code
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
