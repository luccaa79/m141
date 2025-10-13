/*
Zweck:	- Erstellt sämtliche Benutzer mit den benötigten Berechtigungen
		- Nicht benötigte leere Benutzer und Zugriffe von überall werden gelöscht
		- Das root-Passwort wird gesetzt
Autor:  Luca Vatrella, Tom Marcon, Jamie Dridi
Datum:  12.10.2025
Ausführung: mysql -u root -p < C:\pfad\zum\Script\createUsers.sql
*/

-- Vorhandene Benutzer löschen, um das Skript mehrfach auszuführen
DROP USER IF EXISTS 'lager_manager'@'localhost';
DROP USER IF EXISTS 'admin_user'@'localhost';
DROP USER IF EXISTS 'kunde_manager'@'localhost';

-- -----------------------------------------------------
-- Anlegen eines neuen Benutzers für die Verwaltung der Tabelle „Lager“.
-- -----------------------------------------------------
CREATE USER 'lager_manager'@'localhost' IDENTIFIED BY '1234';
GRANT SELECT, UPDATE ON Trendwear.lager TO 'lager_manager'@'localhost';

-- -----------------------------------------------------
-- Erstellen eines neuen Admin-Benutzers mit vollen Rechten für die Datenbank
-- -----------------------------------------------------
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON Trendwear.* TO 'admin_user'@'localhost' WITH GRANT OPTION;

-- -----------------------------------------------------
-- Anlegen eines neuen Benutzers für die Verwaltung der Tabelle 'kunde'.
-- -----------------------------------------------------
CREATE USER 'kunde_manager'@'localhost' IDENTIFIED BY '1234';
GRANT SELECT ON Trendwear.kunde TO 'kunde_manager'@'localhost';

-- -----------------------------------------------------
-- Root-Passwort setzen
-- -----------------------------------------------------
ALTER USER 'root'@'localhost' IDENTIFIED BY '1234';

-- Berechtigungen neu laden, um sicherzustellen, dass alle Änderungen wirksam sind.
FLUSH PRIVILEGES;
