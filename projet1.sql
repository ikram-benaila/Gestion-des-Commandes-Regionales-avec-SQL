-- Supprimer la table RegionalOrders si elle existe d�j�
DROP TABLE IF EXISTS RegionalOrders;

-- Cr�er la table RegionalOrders avec les colonnes sp�cifi�es
CREATE TABLE RegionalOrders(
    RowId INT IDENTITY(1,1),
    Country VARCHAR(50),
    Product VARCHAR(50), 
    Year INT,
    Quantity INT
);

-- Ins�rer des donn�es dans la table RegionalOrders
INSERT INTO RegionalOrders (Country, Product, Year, Quantity) VALUES ('France', 'Wirirng', 2020, 1300);
INSERT INTO RegionalOrders (Country, Product, Year, Quantity) VALUES ('France', 'NetWorking Supplies', 2021, 4500);
INSERT INTO RegionalOrders (Country, Product, Year, Quantity) VALUES ('United Kingdom', 'Laptops', 2020, 2500);
INSERT INTO RegionalOrders (Country, Product, Year, Quantity) VALUES ('United Kingdom', 'It Support', 2020, 900);
INSERT INTO RegionalOrders (Country, Product, Year, Quantity) VALUES ('United Kingdom', 'Wirirng', 2020, 2500);
INSERT INTO RegionalOrders (Country, Product, Year, Quantity) VALUES ('United Kingdom', 'Networking Supplies', 2021, 3500);
INSERT INTO RegionalOrders (Country, Product, Year, Quantity) VALUES ('India', 'Wirirng', 2020, 1500);
INSERT INTO RegionalOrders (Country, Product, Year, Quantity) VALUES ('India', 'Networking Suplies', 2020, 2600);
INSERT INTO RegionalOrders (Country, Product, Year, Quantity) VALUES ('India', 'It Support', 2021, 2700);
INSERT INTO RegionalOrders (Country, Product, Year, Quantity) VALUES ('India', 'It Support', 2021, 2100);

-- Afficher toutes les donn�es de la table RegionalOrders
SELECT * FROM RegionalOrders;

-- Correction des erreurs dans les noms de produits
UPDATE RegionalOrders
SET Product = 'Networking Supplies'
WHERE Product IN ('NetWorking Supplies', 'Networking Suplies');

UPDATE RegionalOrders
SET Product = 'Wiring'
WHERE Product = 'Wirirng';

-- Nombre total de lignes dans la table
SELECT COUNT(RowId) FROM RegionalOrders;

-- Liste des pays distincts
-- R�sultat attendu : 3 pays diff�rents (France, India, United Kingdom)
SELECT DISTINCT(Country) FROM RegionalOrders;

-- Liste des produits distincts
-- R�sultat attendu : 4 produits diff�rents
SELECT DISTINCT(Product) FROM RegionalOrders;

-- Liste des ann�es distinctes
-- R�sultat attendu : 2 ann�es (2020, 2021)
SELECT DISTINCT(Year) FROM RegionalOrders;

-------------------------------------
-- FONCTIONS D'AGR�GATION
-------------------------------------
-- Total des quantit�s achet�es
SELECT SUM(Quantity) FROM RegionalOrders;

-- Moyenne des quantit�s achet�es
SELECT AVG(Quantity) FROM RegionalOrders;

-- Quantit� maximale achet�e
SELECT MAX(Quantity) FROM RegionalOrders;

-- Quantit� minimale achet�e
SELECT MIN(Quantity) FROM RegionalOrders;

-- Produit le plus achet� et le moins achet�
-- R�sultat attendu : 
-- - Produit le plus achet� : Networking Supplies
-- - Produit le moins achet� : Laptops
SELECT Product, SUM(Quantity) AS Total_Quantity 
FROM RegionalOrders
GROUP BY Product
ORDER BY Total_Quantity DESC;

-- Pays ayant achet� les plus grandes quantit�s
-- R�sultat attendu : United Kingdom > India > France
SELECT Country, SUM(Quantity) AS Total_Quantity 
FROM RegionalOrders
GROUP BY Country
ORDER BY Total_Quantity DESC;

-- Quantit�s achet�es par pays en 2020
-- R�sultat attendu : United Kingdom > India > France
SELECT Country, Year, SUM(Quantity) AS Total_Quantity 
FROM RegionalOrders
WHERE Year = 2020
GROUP BY Country, Year
ORDER BY Total_Quantity DESC;

-- Quantit�s achet�es par pays en 2021
-- R�sultat attendu : India > France > United Kingdom
SELECT Country, Year, SUM(Quantity) AS Total_Quantity 
FROM RegionalOrders
WHERE Year = 2021
GROUP BY Country, Year
ORDER BY Total_Quantity DESC;

-- Quantit�s achet�es par pays pour chaque produit
SELECT COALESCE(Country, 'Total Quantities') AS Country, COALESCE(Product, 'Total Quantity') AS Product, SUM(Quantity) AS Total_Quantity 
FROM RegionalOrders
GROUP BY ROLLUP (Country, Product);

-- Quantit� totale achet�e par chaque pays
SELECT SUM(Quantity), COALESCE(Country, 'Total Quantity') AS Country
FROM RegionalOrders
GROUP BY ROLLUP (Country);

-- Quantit�s maximales achet�es par pays et par produit
-- Analyse :
-- - France : Favorise Networking Supplies
-- - India : Favorise IT Support
-- - United Kingdom : Favorise Networking Supplies mais ach�te les 4 produits
SELECT Country, Product, MAX(Quantity) AS Max_Quantity 
FROM RegionalOrders
GROUP BY Country, Product
ORDER BY Max_Quantity DESC;

-- Comparaison des ventes de produits entre 2020 et 2021
-- Analyse :
-- - Networking Supplies : Augmentation de 5400 unit�s vendues
-- - Wiring : Vendu uniquement en 2020 avec 5300 unit�s
-- - IT Support : Forte augmentation (de 900 � 4800)
-- - Laptops : Vendu uniquement en 2020 avec 2500 unit�s
SELECT Product, Year, SUM(Quantity) AS Total_Quantity 
FROM RegionalOrders
GROUP BY Product, Year
ORDER BY Total_Quantity DESC;

-- Produit le plus vendu en 2020 et 2021
-- Analyse :
-- - 2020 : Networking Supplies
-- - 2021 : Networking Supplies
SELECT Product, Year, MAX(Quantity) AS Max_Quantity 
FROM RegionalOrders
GROUP BY Product, Year
ORDER BY Max_Quantity DESC;

-- Produit le moins vendu en 2020 et 2021
-- Analyse :
-- - 2020 : IT Support
-- - 2021 : IT Support
SELECT Product, Year, MIN(Quantity) AS Min_Quantity 
FROM RegionalOrders
GROUP BY Product, Year
ORDER BY Min_Quantity ASC;

-- Comparaison des achats par pays entre 2020 et 2021
-- Analyse :
-- - France : Augmentation de 3200 unit�s
-- - United Kingdom : Diminution de 2400 unit�s
-- - India : Augmentation de 700 unit�s
SELECT Country, Year, SUM(Quantity) AS Total_Quantity 
FROM RegionalOrders
GROUP BY Country, Year
ORDER BY Total_Quantity ASC;

-- D�tails des ventes par produit pour 2020 et 2021
SELECT Product, SUM(Quantity) AS Total_Quantity, Year
FROM RegionalOrders
WHERE Year IN (2020, 2021)
GROUP BY Product, Year;
