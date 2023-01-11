# qb-registers
A simple register system using qb-input and qb-menu.

Run this through your database.
This is used to keep up with recent payments made by players.

```
CREATE TABLE `register_payments` (
	`shop` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf16_general_ci',
	`name` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf16_general_ci',
	`amount` INT(255) NULL DEFAULT NULL
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;
```
