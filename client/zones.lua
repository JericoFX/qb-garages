
InsideGarage,IsInGang,InsideSaveVehicle,IsInDepot,CurrentGarage,Zones,Type =false,false,false,false, "", {}, ""

CreateThread(function()
    Wait(2000)
    for k,v in pairs(Garages) do
        Zones[k] = {
            PutVehicle = {},
            OpenMenu = {},
            SpawnVehicle = {}
        }
        --------------------------- SAVE VEHICLE -----------------------------
        Zones[k].PutVehicle = BoxZone:Create(Garages[k].putVehicle,3.0,5.0,{
            name=k,
            debugPoly = false,
            minZ = Garages[k].putVehicle.z - 1,
            maxZ = Garages[k].putVehicle.z + 2
        })
        Zones[k].PutVehicle:onPlayerInOut(function(isInside, point)
            if isInside then
                InsideSaveVehicle = true
                CurrentGarage = Zones[k].PutVehicle.name
            else
                InsideSaveVehicle = false
                CurrentGarage = nil
            end
        end)
        --------------------------- OPEN THE MENU -----------------------------
        Zones[k].OpenMenu = BoxZone:Create(Garages[k].takeVehicle,3.0,5.0,{
            name=k,
            debugPoly = false,
            minZ = Garages[k].takeVehicle.z - 1,
            maxZ = Garages[k].takeVehicle.z +2
        })

        Zones[k].OpenMenu:onPlayerInOut(function(isInside, point)
            if isInside then
                InsideGarage = true
                CurrentGarage = Zones[k].OpenMenu.name
            else
                InsideGarage = false
                CurrentGarage = nil
            end
        end)
        ---------------------------  -----------------------------

        exports['qb-menu']:AddBoxZone(k,Zones[k].PutVehicle.startPos,3.0,5.0,{
            name = k,
            heading = 180,
            debugPoly = false,
            minZ = Garages[k].putVehicle.z - 1,
            maxZ = Garages[k].putVehicle.z +2
        },{
            buttons={
                {
                    type="header",
                    title = "Save Car",
                    description = "Press E to save the Car"
                }
            }
        })


        exports['qb-menu']:AddBoxZone(k,Zones[k].OpenMenu.startPos,3.0,5.0,{
            name = k,
            heading = 13.1,
            debugPoly = false,
            minZ = Garages[k].takeVehicle.z - 1,
            maxZ = Garages[k].takeVehicle.z + 2
        },{
            buttons={
                {
                    type="header",
                    title = "Open Menu",
                    description = "Press E to open the "..Garages[Zones[k].OpenMenu.name].label.." Garage"
                }
            }
        })

    end
---- DEPOTS -----
    for k,v in pairs(Depots) do
     
        Zones[k] = {
            OpenMenu = {},
            takeVehicle = {}
        }
        --------------------------- SAVE VEHICLE -----------------------------
        Zones[k].takeVehicle = BoxZone:Create(Depots[k].takeVehicle,3.0,5.0,{
            name=k,
            debugPoly = true,
            minZ = Depots[k].takeVehicle.z - 1,
            maxZ = Depots[k].takeVehicle.z + 2
        })
        Zones[k].takeVehicle:onPlayerInOut(function(isInside, point)
            if isInside then
                IsInDepot = true
                CurrentGarage = Zones[k].takeVehicle.name
            else
                IsInDepot = false
                CurrentGarage = nil
            end
        end)
        --------------------------- OPEN THE MENU -----------------------------

        ---------------------------  -----------------------------
        exports['qb-menu']:AddBoxZone(k,Zones[k].takeVehicle.startPos,3.0,5.0,{
            name = k,
            heading = 13.1,
            debugPoly = false,
            minZ = Depots[k].takeVehicle.z - 1,
            maxZ = Depots[k].takeVehicle.z + 2
        },{
            buttons={
                {
                    type="header",
                    title = "Open Menu",
                    description = "Press E to open the "..Depots[Zones[k].takeVehicle.name].label.." Garage"
                }
            }
        })
      
    end
    ---- GANGS -----
    for k,v in pairs(GangGarages) do
        Zones[k] = {
            PutVehicle = {},
            OpenMenu = {},
            SpawnVehicle = {}
        }
        --------------------------- SAVE VEHICLE -----------------------------
        Zones[k].PutVehicle = BoxZone:Create(GangGarages[k].putVehicle,3.0,5.0,{
            name=k,
            debugPoly = false,
            minZ = GangGarages[k].putVehicle.z - 1,
            maxZ = GangGarages[k].putVehicle.z + 2
        })
        Zones[k].PutVehicle:onPlayerInOut(function(isInside, point)
            if isInside then
                InsideSaveVehicle = true
                CurrentGarage = Zones[k].PutVehicle.name
            else
                InsideSaveVehicle = false
                CurrentGarage = nil
            end
        end)
        --------------------------- OPEN THE MENU -----------------------------
        Zones[k].OpenMenu = BoxZone:Create(GangGarages[k].takeVehicle,3.0,5.0,{
            name=k,
            debugPoly = false,
            minZ = GangGarages[k].takeVehicle.z - 1,
            maxZ = GangGarages[k].takeVehicle.z +2
        })

        Zones[k].OpenMenu:onPlayerInOut(function(isInside, point)
            if isInside then
                IsInGang = true
                CurrentGarage = Zones[k].OpenMenu.name
            else
                IsInGang = false
                CurrentGarage = nil
            end
        end)
        ---------------------------  -----------------------------

        exports['qb-menu']:AddBoxZone(k,Zones[k].PutVehicle.startPos,3.0,5.0,{
            name = k,
            heading = 180,
            debugPoly = false,
            minZ = GangGarages[k].putVehicle.z - 1,
            maxZ = GangGarages[k].putVehicle.z +2
        },{
            buttons={
                {
                    type="header",
                    title = "Save Car",
                    description = "Press E to save the Car"
                }
            }
        })


        exports['qb-menu']:AddBoxZone(k,Zones[k].OpenMenu.startPos,3.0,5.0,{
            name = k,
            heading = 13.1,
            debugPoly = false,
            minZ = GangGarages[k].takeVehicle.z - 1,
            maxZ = GangGarages[k].takeVehicle.z + 2
        },{
            buttons={
                {
                    type="header",
                    title = "Open Menu",
                    description = "Press E to open the "..GangGarages[Zones[k].OpenMenu.name].label.." Garage"
                }
            }
        })

    end
      
end)
