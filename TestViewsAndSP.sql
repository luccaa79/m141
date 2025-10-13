/*
    Internes Testen der erstellten Views und Stored Procedures
    Autor:  Luca Vatrella, Tom Marcon, Jamie Dridi
    Datum:  12.10.2025
*/

-- -----------------------------------------------------
-- Test für die Views
-- -----------------------------------------------------
/*
    Test für View_KundenBestellungen:
    Diese Abfrage gibt die Bestellungen der Kunden zurück, inklusive der Zahlungsmethode.
    Es werden nur Bestellungen angezeigt, die abgerechnet wurden.
*/

SELECT * FROM View_KundenBestellungen;

/*
    Test für View_LagerbestandProdukte:
    Diese Abfrage zeigt den Lagerbestand der Produkte an, die im Lager verfügbar sind (Anzahl > 0).
*/

SELECT * FROM View_LagerbestandProdukte;

-- -----------------------------------------------------
-- Test für die Stored Procedures
-- -----------------------------------------------------

/*
    Test für Stored Procedure: getCustomerInfo
    Zweck: Liefert Informationen über einen Kunden basierend auf der Kundennummer.
    OUT-Parameter: Vorname, Nachname, E-Mail-Adresse des Kunden.
*/

-- Deklarieren der OUT-Parameter für die gespeicherte Prozedur
SET @Vorname = '';
SET @Nachname = '';
SET @Email = '';

-- Aufruf der Prozedur mit einer Beispiel-Kundennummer (z.B. 1)
CALL getCustomerInfo(1, @Vorname, @Nachname, @Email);

-- Ausgabe der zurückgegebenen Werte
SELECT @Vorname AS Vorname, @Nachname AS Nachname, @Email AS Email;

-- -----------------------------------------------------

/*
    Test für Stored Procedure: updateStock
    Zweck: Aktualisiert den Lagerbestand eines Produkts basierend auf der Produktnummer.
    IN-Parameter: Produktnummer (id_Produkt), Menge (Anzahl).
*/

-- Beispiel: Lagerbestand eines Produkts (z.B. Produkt 1) auf 50 setzen
CALL updateStock(1, 55);

-- Überprüfen der Aktualisierung im Lagerbestand
SELECT * FROM Lager WHERE Produkt_id_Produkt = 1;

-- -----------------------------------------------------

/*
    Test für Stored Procedure: createOrder
    Zweck: Erstellt eine neue Bestellung für einen Kunden und fügt ein Produkt zum Warenkorb hinzu.
    OUT-Parameter: Neue Bestellnummer.
*/

-- Deklarieren des OUT-Parameters für die neue Bestellnummer
SET @Bestellnummer = 0;

-- Aufruf der Prozedur mit einer Beispiel-Kundennummer (z.B. Kunde 1) und einer Produktnummer (z.B. Produkt 1)
CALL createOrder(1, 1, @Bestellnummer);

-- Ausgabe der neu erstellten Bestellnummer
SELECT @Bestellnummer AS Bestellnummer;

-- Überprüfen, ob die Bestellung korrekt im Warenkorb eingetragen wurde
SELECT * FROM Warenkorb WHERE Bestellung_id_Bestellung = @Bestellnummer;
