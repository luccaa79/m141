/*
Zweck:  Importiert sämtliche Daten der Webseite
Autor:  Luca Vatrella, Tom Marcon, Jamie Dridi
Datum:  12.10.2025
Ausführung: mysql -u root -p < C:\pfad\zum\Script\importData.sql
*/

-- Deaktiviert den FOREIGN_KEY_CHECKS und bereitet das Löschen alter Daten vor.
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_SAFE_UPDATES = 0;

-- Vorhandene Daten in allen Tabellen löschen
DELETE FROM Trendwear.Warenkorb;
DELETE FROM Trendwear.Lager;
DELETE FROM Trendwear.Bestellung;
DELETE FROM Trendwear.Produkt;
DELETE FROM Trendwear.Produktkategorie;
DELETE FROM Trendwear.Zahlmethode;
DELETE FROM Trendwear.Kunde;

-- -----------------------------------------------------
-- Insert data für 'Zahlmethode'
-- -----------------------------------------------------
INSERT INTO Trendwear.Zahlmethode (Zahlmethode) 
VALUES 
  ('Kreditkarte'),
  ('Twint'),
  ('Überweisung');

-- -----------------------------------------------------
-- Insert data für 'Produktkategorie'
-- -----------------------------------------------------
INSERT INTO Trendwear.Produktkategorie (Produktkategorie) 
VALUES 
  ('Hose'),
  ('Pullover'),
  ('Shirts');

-- -----------------------------------------------------
-- Insert data für 'Produkt'
-- -----------------------------------------------------
INSERT INTO Trendwear.Produkt (Name, Hersteller, Produktnummer, Preis, Produktkategorie_id_Produktkategorie) 
VALUES 
  ('Jogginghose', 'Nike', '123456', 79.99, 1),
  ('Jeans', 'LEVIS', '654321', 69.99, 1),
  ('Hoodie', 'Fred Perry', '123654', 59.99, 2),
  ('Longsleeve', 'Adidas', '456123', 39.99, 3);

-- -----------------------------------------------------
-- Insert data für 'Bestellung'
-- -----------------------------------------------------
INSERT INTO Trendwear.Bestellung (Zahlmethode_id_Zahlmethode, Zeitstempfel, Abgerechnet, Kunde_id_Kunde) 
VALUES 
  (1, '2025-10-01 14:30:00', 'Ja', 1),
  (2, '2025-10-03 10:15:00', 'Nein', 2),
  (3, '2025-10-05 18:45:00', 'Ja', 3);

-- -----------------------------------------------------
-- Insert data für 'Warenkorb'
-- -----------------------------------------------------
INSERT INTO Trendwear.Warenkorb (Bestellung_id_Bestellung, Produkt_id_Produkt) 
VALUES 
  (1, 1),
  (1, 3),
  (2, 2),
  (3, 4);

-- -----------------------------------------------------
-- Insert data für 'Lager'
-- -----------------------------------------------------
INSERT INTO Trendwear.Lager (Anzahl, Lagerort, Produkt_id_Produkt) 
VALUES 
  (50, 1, 1),
  (30, 2, 2),
  (15, 3, 3),
  (0, 1, 4);

-- -----------------------------------------------------
-- LOAD DATA für 'Kunde'
-- -----------------------------------------------------
-- Windows Path: C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Kunde.csv' 
INTO TABLE Trendwear.Kunde
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
ignore 1 rows
(`Nachname`, `Vorname`, `Strasse`, `Postleitzahl`, `Ort`, `Telefonnummer`, `Handynummer`, `Geburtsdatum`, `E-Mail Adresse`);


-- Reaktiviert den FOREIGN_KEY_CHECKS und SQL_SAFE_UPDATES
SET FOREIGN_KEY_CHECKS = 1;
SET SQL_SAFE_UPDATES = 1;
