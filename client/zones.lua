InsideGarage, IsInGang, InsideSaveVehicle, IsInDepot, CurrentGarage, Zones, Type =
    false, false, false, false, "", {}, ""

CreateThread(function()
    Wait(2000)
    for k, v in pairs(Garages) do
        Zones[k] = {PutVehicle = {}, OpenMenu = {}, SpawnVehicle = {}}
        --------------------------- SAVE VEHICLE -----------------------------
        Zones[k].PutVehicle = BoxZone:Create(Garages[k].putVehicle,
                                             Garages[k].length or 12.0,
                                             Garages[k].width or 12.0, {
            name = k,
            heading = Garages[k].heading,
            debugPoly = false,
            minZ = Garages[k].putVehicle.z - 1,
            maxZ = Garages[k].putVehicle.z + 2
        })
        Zones[k].PutVehicle:onPlayerInOut(
            function(isInside, point)
                if isInside then

                    InsideSaveVehicle = true
                    CurrentGarage = Zones[k].PutVehicle.name
                    exports['qb-menu']:showHeader({
                        {
                            header = 'Press E to Save the Vehicle',
                            isMenuHeader = true -- Set to true to make a nonclickable title
                        }
                    })
                else
                    InsideSaveVehicle = false
                    CurrentGarage = nil
                    exports['qb-menu']:closeMenu()
                end
            end)
        --------------------------- OPEN THE MENU -----------------------------
        Zones[k].OpenMenu = BoxZone:Create(Garages[k].takeVehicle, 4.2, 4.2, {
            name = k,
            debugPoly = false,
            minZ = Garages[k].takeVehicle.z - 1,
            maxZ = Garages[k].takeVehicle.z + 2
        })

        Zones[k].OpenMenu:onPlayerInOut(function(isInside, point)
            if isInside then
                InsideGarage = true
                CurrentGarage = Zones[k].OpenMenu.name

                exports['qb-menu']:showHeader({
                    {
                        header = 'Press E to open ' ..
                            Garages[Zones[k].OpenMenu.name].label,
                        isMenuHeader = true -- Set to true to make a nonclickable title
                    }
                })
            else
                InsideGarage = false
                CurrentGarage = nil
                exports['qb-menu']:closeMenu()
            end
        end)
        ---------------------------  -----------------------------

    end
    ---- DEPOTS -----
    for k, v in pairs(Depots) do

        Zones[k] = {OpenMenu = {}, takeVehicle = {}}
        --------------------------- SAVE VEHICLE -----------------------------
        Zones[k].takeVehicle = BoxZone:Create(Depots[k].takeVehicle, 5.0, 8.0, {
            name = k,
            debugPoly = false,
            minZ = Depots[k].takeVehicle.z - 1,
            maxZ = Depots[k].takeVehicle.z + 2
        })
        Zones[k].takeVehicle:onPlayerInOut(
            function(isInside, point)
                if isInside then
                    IsInDepot = true
                    CurrentGarage = Zones[k].takeVehicle.name
                    exports['qb-menu']:showHeader({
                        {
                            header = 'Press E to open ' ..
                                Depots[Zones[k].OpenMenu.name].label .. " Depot",
                            isMenuHeader = true -- Set to true to make a nonclickable title
                        }
                    })
                else
                    IsInDepot = false
                    CurrentGarage = nil
                    exports['qb-menu']:closeMenu()
                end
            end)
        --------------------------- OPEN THE MENU -----------------------------

        ---------------------------  -----------------------------

    end
    ---- GANGS -----
    for k, v in pairs(GangGarages) do
        Zones[k] = {PutVehicle = {}, OpenMenu = {}, SpawnVehicle = {}}
        --------------------------- SAVE VEHICLE -----------------------------
        Zones[k].PutVehicle = BoxZone:Create(GangGarages[k].putVehicle, 5.0,
                                             8.0, {
            name = k,
            debugPoly = false,
            minZ = GangGarages[k].putVehicle.z - 1,
            maxZ = GangGarages[k].putVehicle.z + 2
        })
        Zones[k].PutVehicle:onPlayerInOut(
            function(isInside, point)
                if isInside then
                    InsideSaveVehicle = true
                    CurrentGarage = Zones[k].PutVehicle.name
                else
                    InsideSaveVehicle = false
                    CurrentGarage = nil
                end
            end)
        --------------------------- OPEN THE MENU -----------------------------
        Zones[k].OpenMenu = BoxZone:Create(GangGarages[k].takeVehicle, 3.0, 5.0,
                                           {
            name = k,
            debugPoly = false,
            minZ = GangGarages[k].takeVehicle.z - 1,
            maxZ = GangGarages[k].takeVehicle.z + 2
        })

        Zones[k].OpenMenu:onPlayerInOut(function(isInside, point)
            if isInside then
                IsInGang = true
                CurrentGarage = Zones[k].OpenMenu.name
                exports['qb-menu']:showHeader({
                    {
                        header = 'Press E to open ' ..
                            GangGarages[Zones[k].OpenMenu.name].label,
                        isMenuHeader = true -- Set to true to make a nonclickable title
                    }
                })
            else
                IsInGang = false
                CurrentGarage = nil
                exports['qb-menu']:closeMenu()
            end
        end)
        ---------------------------  -----------------------------

        -- exports['qb-menu']:AddBoxZone(k, Zones[k].OpenMenu.startPos, 3.0, 5.0,
        --                               {
        --     name = k,
        --     heading = 13.1,
        --     debugPoly = false,
        --     minZ = GangGarages[k].takeVehicle.z - 1,
        --     maxZ = GangGarages[k].takeVehicle.z + 2
        -- }, {
        --     buttons = {
        --         {
        --             type = "header",
        --             title = "Open Menu",
        --             description = "Press E to open the " ..
        --                 GangGarages[Zones[k].OpenMenu.name].label .. " Garage"
        --         }
        --     }
        -- })
    end

end)
