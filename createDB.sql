/*
Zweck:  Erstellt die Datenbank mit allen benötigten Tabellen und Relationen
Autor:  Luca Vatrella, Tom Marcon, Jamie Dridi
Datum:  12.10.2025
Ausführung: mysql -u root -p < C:\pfad\zum\Script\createDB.sql
*/


-- Deaktiviert den FOREIGN_KEY_CHECKS und löscht die alte Datenbank
SET FOREIGN_KEY_CHECKS = 0;
DROP DATABASE IF EXISTS Trendwear;

-- -----------------------------------------------------
-- Database Trendwear
-- -----------------------------------------------------
CREATE Database IF NOT EXISTS Trendwear;
USE Trendwear;

-- -----------------------------------------------------
-- Table Trendwear.Zahlmethode
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Trendwear.Zahlmethode (
  `id_Zahlmethode` INT NOT NULL AUTO_INCREMENT,
  `Zahlmethode` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id_Zahlmethode`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table Trendwear.Kunde
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Trendwear.Kunde (
  `id_Kunde` INT NOT NULL AUTO_INCREMENT,
  `Nachname` VARCHAR(25) NOT NULL,
  `Vorname` VARCHAR(25) NOT NULL,
  `Strasse` VARCHAR(25) NOT NULL,
  `Postleitzahl` CHAR(4) NOT NULL,
  `Ort` VARCHAR(25) NOT NULL,
  `Telefonnummer` CHAR(10) NULL,
  `Handynummer` CHAR(10) NULL,
  `Geburtsdatum` DATE NOT NULL,
  `E-Mail Adresse` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`id_Kunde`)
) ENGINE = InnoDB;

-- Indexierung von Vor- und Nachname
CREATE INDEX idx_kunde_vorname ON Kunde (Vorname);
CREATE INDEX idx_kunde_nachname ON Kunde (Nachname);

-- -----------------------------------------------------
-- Table Trendwear.Bestellung
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Trendwear.Bestellung (
  `id_Bestellung` INT NOT NULL AUTO_INCREMENT,
  `Zahlmethode_id_Zahlmethode` INT NOT NULL,
  `Zeitstempfel` DATETIME NOT NULL,
  `Abgerechnet` ENUM('Ja', 'Nein') NOT NULL,
  `Kunde_id_Kunde` INT NOT NULL,
  PRIMARY KEY (`id_Bestellung`),
  INDEX `fk_Bestellung_Zahlmethode1_idx` (`Zahlmethode_id_Zahlmethode` ASC) VISIBLE,
  INDEX `fk_Bestellung_Kunde1_idx` (`Kunde_id_Kunde` ASC) VISIBLE,
  CONSTRAINT `fk_Bestellung_Zahlmethode1`
    FOREIGN KEY (`Zahlmethode_id_Zahlmethode`)
    REFERENCES `Trendwear`.`Zahlmethode` (`id_Zahlmethode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bestellung_Kunde1`
    FOREIGN KEY (`Kunde_id_Kunde`)
    REFERENCES `Trendwear`.`Kunde` (`id_Kunde`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table Trendwear.Produktkategorie
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Trendwear.Produktkategorie (
  `id_Produktkategorie` INT NOT NULL AUTO_INCREMENT,
  `Produktkategorie` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`id_Produktkategorie`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table Trendwear.Produkt
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Trendwear.Produkt (
  `id_Produkt` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(25) NOT NULL,
  `Hersteller` VARCHAR(25) NOT NULL,
  `Produktnummer` VARCHAR(15) NOT NULL,
  `Preis` DECIMAL(7,2) NULL,
  `Produktkategorie_id_Produktkategorie` INT NOT NULL,
  PRIMARY KEY (`id_Produkt`),
  INDEX `fk_Produkt_Produktkategorie1_idx` (`Produktkategorie_id_Produktkategorie` ASC) VISIBLE,
  CONSTRAINT `fk_Produkt_Produktkategorie1`
    FOREIGN KEY (`Produktkategorie_id_Produktkategorie`)
    REFERENCES `Trendwear`.`Produktkategorie` (`id_Produktkategorie`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Indexierung des Produktnames
CREATE INDEX idx_produkt_name ON Produkt (Name);

-- -----------------------------------------------------
-- Table Trendwear.Warenkorb
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Trendwear.Warenkorb (
  `id_Warenkorb` INT NOT NULL AUTO_INCREMENT,
  `Bestellung_id_Bestellung` INT NOT NULL,
  `Produkt_id_Produkt` INT NOT NULL,
  PRIMARY KEY (`id_Warenkorb`),
  INDEX `fk_Warenkorb_Bestellung1_idx` (`Bestellung_id_Bestellung` ASC) VISIBLE,
  INDEX `fk_Warenkorb_Produkt1_idx` (`Produkt_id_Produkt` ASC) VISIBLE,
  CONSTRAINT `fk_Warenkorb_Bestellung1`
    FOREIGN KEY (`Bestellung_id_Bestellung`)
    REFERENCES `Trendwear`.`Bestellung` (`id_Bestellung`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Warenkorb_Produkt1`
    FOREIGN KEY (`Produkt_id_Produkt`)
    REFERENCES `Trendwear`.`Produkt` (`id_Produkt`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table Trendwear.Lager
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Trendwear.Lager (
  `id_Lager` INT NOT NULL AUTO_INCREMENT,
  `Anzahl` SMALLINT NULL,
  `Lagerort` TINYINT NULL,
  `Produkt_id_Produkt` INT NOT NULL,
  PRIMARY KEY (`id_Lager`),
  INDEX `fk_Lager_Produkt1_idx` (`Produkt_id_Produkt` ASC) VISIBLE,
  CONSTRAINT `fk_Lager_Produkt1`
    FOREIGN KEY (`Produkt_id_Produkt`)
    REFERENCES `Trendwear`.`Produkt` (`id_Produkt`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Indexierung des Lagerorts
CREATE INDEX idx_lager_lagerort ON Lager (Lagerort);

-- Reaktiviert den FOREIGN_KEY_CHECKS und löscht die alte Datenbank
SET FOREIGN_KEY_CHECKS = 1;
