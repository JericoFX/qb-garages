Config = {}
Config.DefaultDepot =  "hayesdepot"

Garages = {
    ["motelgarage"] = {
        label = "Motel Parking",
        takeVehicle = vector3(275.58, -344.6, 45.17),
        spawnPoint = vector4(270.94, -342.96, 43.97, 161.5),
        putVehicle = vector3(280.0, -337.0, 44.92),
        showBlip = true,
        length =  15.6,
        width = 40.8,
        heading = 340
    },
    ["sapcounsel"] = {
        label = "San Andreas Parking",
        takeVehicle = vector3(-330.01, -780.33, 33.96),
        spawnPoint = vector4(-334.44, -780.75, 33.96, 137.5),
        putVehicle = vector3(-342.68, -765.37, 33.97),
        showBlip = true,
        length = 32.0,
        width = 18.8,
        heading = 0
    },
    ["spanishave"] = {
        label = "Spanish Ave Parking",
        takeVehicle = vector3(-1159.04, -739.77, 19.89),
        spawnPoint = vector4(-1163.88, -749.32, 18.42, 35.5),
        putVehicle = vector3(-1136.9, -750.75, 19.66),
        showBlip = true,
        length = 20.75,
        width = 33.0,
        heading = 310
    },
    ["caears24"] = {
        label = "Caears 24 Parking",
        takeVehicle = vector3(68.29, 12.52, 69.21),
        spawnPoint = vector4(73.21, 10.72, 68.83, 163.5),
        putVehicle = vector3(64.93, 22.66, 69.09),
        showBlip = true,
        length = 12,
        width = 25.6,
        heading = 339
    },
    ["lagunapi"] = {
        label = "Laguna Parking",
        takeVehicle = vector3(360.9, 298.94, 103.75),
        spawnPoint = vector4(367.49, 297.71, 103.43, 340.5),
        putVehicle = vector3(377.51, 279.03, 103.41),
        showBlip = true,
        length = 34.0,
        width = 33.15,
        heading = 344
    },
    ["airportp"] = {
        label = "Airport Parking",
        takeVehicle = vector3(-796.34, -2023.35, 9.17),
        spawnPoint = vector4(-800.41, -2016.53, 9.32, 48.5),
        putVehicle = vector3(-772.9, -2032.07, 8.88),
        showBlip = true,
        length = 30.0,
        width = 32.8,
        heading = 313
    },
    ["beachp"] = {
        label = "Beach Parking",
        takeVehicle = vector3(-1184.14, -1509.76, 4.65),
        spawnPoint = vector4(-1181.0, -1505.98, 4.37, 214.5),
        putVehicle = vector3(-1187.97, -1488.45, 4.38),
        showBlip = true,
        length = 28.6,
        width = 26.2,
        heading = 307
    },
    ["themotorhotel"] = {
        label = "The Motor Hotel Parking",
        takeVehicle = vector3(1133.03, 2666.11, 38.27),
        spawnPoint = vector4(1137.69, 2673.61, 37.9, 359.5),
        putVehicle = vector3(1125.76, 2651.06, 38.0),
        showBlip = true,
        length = 13,
        width = 29.2,
        heading = 359
    },
    ["liqourparking"] = {
        label = "Liqour Parking",
        takeVehicle = vector3(938.34, 3607.77, 33.13),
        spawnPoint = vector4(941.57, 3619.99, 32.5, 141.5),
        putVehicle = vector3(947.39, 3619.06, 32.64),
        showBlip = true,
        length = 12.0,
        width = 14,
        heading = 0
    },
    ["shoreparking"] = {
        label = "Shore Parking",
        takeVehicle = vector3(1718.22, 3718.31, 34.42),
        spawnPoint = vector4(1730.31, 3711.07, 34.2, 20.5),
        putVehicle = vector3(1736.01, 3720.98, 34.19),
        showBlip = true,
        length = 24.0,
        width = 13,
        heading = 21
    },
    ["haanparking"] = {
        label = "Bell Farms Parking",
        takeVehicle = vector3(83.77, 6420.17, 31.76),
        spawnPoint = vector4(70.71, 6425.16, 30.92, 68.5),
        putVehicle = vector3(64.48, 6389.45, 31.23),
        showBlip = true,
        length = 36.8,
        width = 32.2,
        heading = 312
    },
    ["dumbogarage"] = {
        label = "Dumbo Private Parking",
        takeVehicle = vector3(157.26, -3240.00, 7.00),
        spawnPoint = vector4(165.32, -3236.10, 5.93, 268.5),
        putVehicle = vector3(165.32, -3230.00, 5.93),
        showBlip = true,
        length = 36.8,
        width = 32.2,
        heading = 312
    },
    ["pillboxgarage"] = {
        label = "Pillbox Garage Parking",
        takeVehicle = vector3(213.2, -809.1, 31.01),
        spawnPoint = vector4(234.1942, -787.066, 30.193, 159.6),
        putVehicle = vector3(213.75, -794.61, 30.89),
        showBlip = true,
        length = 21.4,
        width = 16.4,
        heading = 338
    }

}

HouseGarages = {}

GangGarages = {
    ["ballasgarage"] = {
        label = "Ballas",
        takeVehicle = vector3(98.50, -1954.49, 20.84),
        spawnPoint = vector4(98.50, -1954.49, 20.75, 335.73),
        putVehicle = vector3(94.75, -1959.93, 20.84),
        job = "ballas",
        minZ = 0,
        maxZ = 0
    },
    ["la_familiagarage"] = {
        label = "La Familia",
        takeVehicle = vector3(-811.65, 187.49, 72.48),
        spawnPoint = vector4(-818.43, 184.97, 72.28, 107.85),
        putVehicle = vector3(-811.65, 187.49, 72.48),
        job = "la_familia",
        minZ = 0,
        maxZ = 0
    },
    ["the_lostgarage"] = {
        label = "Lost MC",
        takeVehicle = vector3(957.25, -129.63, 74.39),
        spawnPoint = vector4(957.25, -129.63, 74.39, 199.21),
        putVehicle = vector3(950.47, -122.05, 74.36),
        job = "the_lost",
        minZ = 0,
        maxZ = 0
    },
    ["cartelgarage"] = {
        label = "Cartel",
        takeVehicle = vector3(1407.18, 1118.04, 114.84),
        spawnPoint = vector4(1407.18, 1118.04, 114.84, 88.34),
        putVehicle = vector3(1407.18, 1118.04, 114.84),
        job = "cartel",
        minZ = 0,
        maxZ = 0
    }
}

Depots = {
    ["hayesdepot"] = {
        label = "Hayes Depot",
        takeVehicle = vector4(491.0, -1314.69, 29.25, 304.5),
        showBlip = true
    }
}
