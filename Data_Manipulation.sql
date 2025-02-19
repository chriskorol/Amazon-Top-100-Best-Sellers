CREATE DATABASE amazon_electronics; -- Erstellen der Datenbank und Tabelle
USE amazon_electronics;



CREATE TABLE electronics_data (
  date DATE,
  number INT,
  name VARCHAR(255),
  rating FLOAT,
  n_reviews INT,
  price FLOAT
);

DESCRIBE electronics_data; -- Prüfen der Tabellenstruktur


SELECT * FROM electronics_data LIMIT 10; -- Anzeigen von Beispieldaten

SELECT name, COUNT(*) AS frequency --  Häufigkeit von Produkten analysieren
FROM electronics_data
GROUP BY `name`
ORDER BY frequency DESC
LIMIT 10;

WITH product_frequency AS ( --  Monatliche Top-3-Produkte identifizieren
    SELECT 
        DATE_FORMAT(STR_TO_DATE(date, '%Y-%m-%d'), '%Y-%m') AS month, -- Formatierung des Datums
        name, 
        COUNT(*) AS frequency_in_top -- Anzahl der Top-Treffer pro Monat
    FROM electronics_data
    GROUP BY month, name
),
ranked_products AS (
    SELECT 
        month,
        name,
        frequency_in_top,
        ROW_NUMBER() OVER (
            PARTITION BY month 
            ORDER BY frequency_in_top DESC -- Sortieren nach Häufigkeit im oberen Bereich
        ) AS rank_in_month -- Produktrang im Monat
    FROM product_frequency
)
SELECT 
    month,
    name,
    frequency_in_top,
    rank_in_month
FROM ranked_products
WHERE rank_in_month <= 3 -- Auswahl der 3 besten Produkte eines jeden Monats
ORDER BY month, rank_in_month;


SELECT CASE  --  Analyse der Preiskategorien
            WHEN price BETWEEN 0 AND 50 THEN '0-50'
            WHEN price BETWEEN 51 AND 100 THEN '51-100'
            WHEN price BETWEEN 101 AND 150 THEN '101-150'
            ELSE '150+'
       END AS price_range,
       COUNT(*) AS count_of_products
FROM electronics_data
GROUP BY price_range
ORDER BY price_range;



WITH unique_products AS ( -- Einzigartige Produkte nach Preiskategorien analysieren
    SELECT 
        name,
        MAX(price) AS price -- Nehmen Sie den letzten Preis (oder den Höchstpreis, wenn sich die Preise geändert haben)
    FROM electronics_data
    GROUP BY name -- Wir lassen nur einzigartige Produkte mit Namen
)
SELECT CASE 
            WHEN price BETWEEN 0 AND 50 THEN '0-50'
            WHEN price BETWEEN 51 AND 100 THEN '51-100'
            WHEN price BETWEEN 101 AND 150 THEN '101-150'
            ELSE '150+'
       END AS price_range,
       COUNT(*) AS count_of_products
FROM unique_products
GROUP BY price_range
ORDER BY price_range;


SELECT AVG(rating) AS average_rating -- Durchschnittliche Bewertung berechnen
FROM electronics_data;



SELECT name, -- Dynamic der Preisen
       date, 
       price
FROM electronics_data
ORDER BY name, date;





SELECT  -- Top-Produkte nach Frequency
    name, 
    COUNT(*) AS frequency_in_top
FROM electronics_data
GROUP BY name
ORDER BY frequency_in_top DESC
LIMIT 10;

   
SELECT -- Top-Produkte nach average_rating
    name, 
    ROUND(AVG(rating), 2) AS average_rating
FROM electronics_data
GROUP BY name
ORDER BY average_rating DESC
LIMIT 10;

SELECT name, -- Top-Produkte nach gewichteter Bewertung
       COUNT(*) AS frequency_in_top, 
       MAX(rating) AS highest_rating, 
       SUM(n_reviews) AS total_reviews,
       (COUNT(*) * 0.5 + MAX(rating) * 0.3 + SUM(n_reviews) * 0.2) AS weighted_score -- Зважена оцінка
FROM electronics_data
GROUP BY name
ORDER BY weighted_score DESC
LIMIT 10;


SHOW TABLES;
