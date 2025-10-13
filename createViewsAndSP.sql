/*
Zweck:	- Erstellt benötige Views und Stored Procedures
		- Definiert die Berechtigungen auf den Views und Stored Procedures
Autor:  Luca Vatrella, Tom Marcon, Jamie Dridi
Datum:  12.10.2025
Ausführung: mysql -u root -p < C:\pfad\zum\Script\createViewsAndSPs.sql
*/

-- Löschen der bestehenden Views, falls vorhanden
DROP VIEW IF EXISTS View_KundenBestellungen;
DROP VIEW IF EXISTS View_LagerbestandProdukte;

/* 
    --------------------------------------------------------
    View 1: View_KundenBestellungen
    --------------------------------------------------------
    Beschreibung: Diese View zeigt die Bestellungen der Kunden zusammen mit den jeweiligen Zahlungsmethoden an.
    Sie enthält einen INNER JOIN zwischen den Tabellen Kunde, Bestellung und Zahlmethode.
    Die View filtert nur Bestellungen, die abgerechnet wurden.
*/
CREATE VIEW View_KundenBestellungen AS
SELECT 
    Kunde.Vorname, 
    Kunde.Nachname, 
    Bestellung.Zeitstempfel, 
    Bestellung.Abgerechnet, 
    Zahlmethode.Zahlmethode
FROM 
    Kunde
INNER JOIN 
    Bestellung ON Kunde.id_Kunde = Bestellung.Kunde_id_Kunde
INNER JOIN 
    Zahlmethode ON Bestellung.Zahlmethode_id_Zahlmethode = Zahlmethode.id_Zahlmethode
WHERE 
    Bestellung.Abgerechnet = 'Ja';

/* 
--------------------------------------------------------
    View 2: View_LagerbestandProdukte
--------------------------------------------------------
    Beschreibung: Diese View zeigt den Lagerbestand von Produkten und enthält eine WHERE-Bedingung,
    um nur Produkte anzuzeigen, die im Lager vorhanden sind (Anzahl > 0).
*/
CREATE VIEW View_LagerbestandProdukte AS
SELECT 
    Produkt.Name, 
    Produkt.Hersteller, 
    Lager.Anzahl, 
    Lager.Lagerort
FROM 
    Produkt
INNER JOIN 
    Lager ON Produkt.id_Produkt = Lager.Produkt_id_Produkt
WHERE 
    Lager.Anzahl > 0;



-- Drop existing Stored Procedures
DROP PROCEDURE IF EXISTS getCustomerInfo;
DROP PROCEDURE IF EXISTS updateStock;
DROP PROCEDURE IF EXISTS createOrder;

/* 
-----------------------------------------------------
Stored Procedure: getCustomerInfo
-----------------------------------------------------
Beschreibung: 		Liefert Informationen zu einem Kunden basierend auf der Kundennummer.
IN Parameter: 		id_Kunde (INT) - Die Kundennummer.
OUT Parameter: 		Vorname, Nachname, E-Mail (VARCHAR) - Kundeninformationen.
*/

DELIMITER //
CREATE PROCEDURE getCustomerInfo(
    IN p_id_Kunde INT,
    OUT p_Vorname VARCHAR(25),
    OUT p_Nachname VARCHAR(25),
    OUT p_Email VARCHAR(40)
)
BEGIN
    SELECT Vorname, Nachname, `E-Mail Adresse`
    INTO p_Vorname, p_Nachname, p_Email
    FROM Kunde
    WHERE id_Kunde = p_id_Kunde;
END //

/* 
-----------------------------------------------------
Stored Procedure: updateStock
-----------------------------------------------------
Beschreibung: 		Aktualisiert den Lagerbestand eines Produkts.
IN Parameter: 		id_Produkt (INT), Anzahl (INT) - Die Produktnummer und die Menge, um den Lagerbestand zu aktualisieren.
OUT Parameter: 		-
*/

CREATE PROCEDURE updateStock(
    IN p_id_Produkt INT,
    IN p_Anzahl INT
)
BEGIN
    UPDATE Lager
    SET Anzahl = p_Anzahl
    WHERE Produkt_id_Produkt = p_id_Produkt;
END //

/* 
-----------------------------------------------------
Stored Procedure: createOrder
-----------------------------------------------------
Beschreibung: 		Erstellt eine neue Bestellung und fügt Produkte zum Warenkorb hinzu.
IN Parameter: 		id_Kunde (INT), id_Produkt (INT) - Kundennummer und Produktnummer.
OUT Parameter: 		Neue Bestellnummer (INT)
*/

CREATE PROCEDURE createOrder(
    IN p_id_Kunde INT,
    IN p_id_Produkt INT,
    OUT p_id_Bestellung INT
)
BEGIN
    -- Neue Bestellung erstellen
    INSERT INTO Bestellung (Kunde_id_Kunde, Zahlmethode_id_Zahlmethode, Zeitstempfel, Abgerechnet)
    VALUES (p_id_Kunde, 1, NOW(), 'Nein');
    
    -- Bestellnummer abrufen
    SET p_id_Bestellung = LAST_INSERT_ID();

    -- Produkt in den Warenkorb legen
    INSERT INTO Warenkorb (Bestellung_id_Bestellung, Produkt_id_Produkt)
    VALUES (p_id_Bestellung, p_id_Produkt);
END //
DELIMITER ;

-- -----------------------------------------------------
-- Berechtigungen für Views festlegen
-- -----------------------------------------------------

-- Berechtigung für Benutzer Kunde_Manager: 
GRANT SELECT ON View_KundenBestellungen TO 'kunde_manager'@'localhost';

-- Berechtigung für Benutzer lager_manager: 
GRANT SELECT ON View_LagerbestandProdukte TO 'lager_manager'@'localhost';

-- Berechtigung für Benutzer admin_user: 
GRANT SELECT ON View_KundenBestellungen TO 'admin_user'@'localhost';
GRANT SELECT ON View_LagerbestandProdukte TO 'admin_user'@'localhost';

-- -----------------------------------------------------
-- Berechtigungen für Stored Procedures festlegen
-- -----------------------------------------------------

-- Berechtigung für Benutzer Kunde_Manager: 
GRANT EXECUTE ON PROCEDURE Trendwear.getCustomerInfo TO 'kunde_manager'@'localhost';

-- Berechtigung für Benutzer lager_manager: 
GRANT EXECUTE ON PROCEDURE Trendwear.updateStock TO 'lager_manager'@'localhost';

-- Berechtigung für Benutzer admin_user: 
GRANT EXECUTE ON PROCEDURE Trendwear.createOrder TO 'admin_user'@'localhost';

-- Berechtigungen übernehmen
FLUSH PRIVILEGES;


