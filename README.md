# QB-GARAGES

qb-garages is a work in progress re-imagination of qb-garages made in Vue 3 + Quasar + Vuex

## Installation

Download the script, put the script on you'r resource's folder, dont rename it or if you want to rename it just change all the links on Vue's side, Start the resource on server.cfg

```bash
ensure qb-garages
```

## Usage

```python
Go to any garage and press E.
```

## Contributing
```lua
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
```

Please make sure to update tests as appropriate.

## Features

* NUI Garages with Fuel,Engine,Body %

* Impound Feature with ammount to pay and Note system (qb-impound coming soon)

* Simplify the States , 0 is Out, 1 is in Garage and 2 is Impounded
* Lang System (only english and spanish at the moment)
* Dark and Light Mode

## IMAGES

![Hi](https://image.prntscr.com/image/1nsSqcOZRZGE3eAS1efZdA.png)
![Hi](https://image.prntscr.com/image/60RersY_SZe8u3HTStT_-g.png)
![Hi](https://image.prntscr.com/image/1SEoJP0hRbKIZ1XnSeWmIg.png)
![Hi](https://image.prntscr.com/image/-3z-kSN5T-mWHemccLtapg.png)

## SQL

```sql
CREATE TABLE `player_vehicles` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`license` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`citizenid` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`vehicle` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`hash` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`mods` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`plate` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`fakeplate` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`garage` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`fuel` INT(11) NULL DEFAULT '100',
	`engine` FLOAT NULL DEFAULT '1000',
	`body` FLOAT NULL DEFAULT '1000',
	`state` INT(11) NULL DEFAULT '1',
	`depotprice` INT(11) NOT NULL DEFAULT '0',
	`drivingdistance` INT(50) NULL DEFAULT NULL,
	`status` TEXT NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`notes` LONGTEXT NULL DEFAULT 'No Message' COLLATE 'utf8_general_ci',
	`pics` TEXT NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `plate` (`plate`) USING BTREE,
	INDEX `citizenid` (`citizenid`) USING BTREE,
	INDEX `license` (`license`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=11
;

```

## Bugs or TO-DO

```lua
* The impound doest take money //FIXED
* some JSON errors //NO MORE
* Clear the Lua code
* Gangs doesn't work yet  //DONE
* Save Damage
* Migrate to PolyZone
* At resource restart the vehicles doesnt go to Impound
```

## License
[MIT](https://choosealicense.com/licenses/mit/)
