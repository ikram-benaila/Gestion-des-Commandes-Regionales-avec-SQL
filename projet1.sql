-- Supprimer la table RegionalOrders si elle existe déjà
DROP TABLE IF EXISTS RegionalOrders;

-- Créer la table RegionalOrders avec les colonnes spécifiées
CREATE TABLE RegionalOrders(
    RowId INT IDENTITY(1,1),
    Country VARCHAR(50),
    Product VARCHAR(50), 
    Year INT,
    Quantity INT
);

-- Insérer des données dans la table RegionalOrders
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

-- Afficher toutes les données de la table RegionalOrders
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
-- Résultat attendu : 3 pays différents (France, India, United Kingdom)
SELECT DISTINCT(Country) FROM RegionalOrders;

-- Liste des produits distincts
-- Résultat attendu : 4 produits différents
SELECT DISTINCT(Product) FROM RegionalOrders;

-- Liste des années distinctes
-- Résultat attendu : 2 années (2020, 2021)
SELECT DISTINCT(Year) FROM RegionalOrders;

-------------------------------------
-- FONCTIONS D'AGRÉGATION
-------------------------------------
-- Total des quantités achetées
SELECT SUM(Quantity) FROM RegionalOrders;

-- Moyenne des quantités achetées
SELECT AVG(Quantity) FROM RegionalOrders;

-- Quantité maximale achetée
SELECT MAX(Quantity) FROM RegionalOrders;

-- Quantité minimale achetée
SELECT MIN(Quantity) FROM RegionalOrders;

-- Produit le plus acheté et le moins acheté
-- Résultat attendu : 
-- - Produit le plus acheté : Networking Supplies
-- - Produit le moins acheté : Laptops
SELECT Product, SUM(Quantity) AS Total_Quantity 
FROM RegionalOrders
GROUP BY Product
ORDER BY Total_Quantity DESC;

-- Pays ayant acheté les plus grandes quantités
-- Résultat attendu : United Kingdom > India > France
SELECT Country, SUM(Quantity) AS Total_Quantity 
FROM RegionalOrders
GROUP BY Country
ORDER BY Total_Quantity DESC;

-- Quantités achetées par pays en 2020
-- Résultat attendu : United Kingdom > India > France
SELECT Country, Year, SUM(Quantity) AS Total_Quantity 
FROM RegionalOrders
WHERE Year = 2020
GROUP BY Country, Year
ORDER BY Total_Quantity DESC;

-- Quantités achetées par pays en 2021
-- Résultat attendu : India > France > United Kingdom
SELECT Country, Year, SUM(Quantity) AS Total_Quantity 
FROM RegionalOrders
WHERE Year = 2021
GROUP BY Country, Year
ORDER BY Total_Quantity DESC;

-- Quantités achetées par pays pour chaque produit
SELECT COALESCE(Country, 'Total Quantities') AS Country, COALESCE(Product, 'Total Quantity') AS Product, SUM(Quantity) AS Total_Quantity 
FROM RegionalOrders
GROUP BY ROLLUP (Country, Product);

-- Quantité totale achetée par chaque pays
SELECT SUM(Quantity), COALESCE(Country, 'Total Quantity') AS Country
FROM RegionalOrders
GROUP BY ROLLUP (Country);

-- Quantités maximales achetées par pays et par produit
-- Analyse :
-- - France : Favorise Networking Supplies
-- - India : Favorise IT Support
-- - United Kingdom : Favorise Networking Supplies mais achète les 4 produits
SELECT Country, Product, MAX(Quantity) AS Max_Quantity 
FROM RegionalOrders
GROUP BY Country, Product
ORDER BY Max_Quantity DESC;

-- Comparaison des ventes de produits entre 2020 et 2021
-- Analyse :
-- - Networking Supplies : Augmentation de 5400 unités vendues
-- - Wiring : Vendu uniquement en 2020 avec 5300 unités
-- - IT Support : Forte augmentation (de 900 à 4800)
-- - Laptops : Vendu uniquement en 2020 avec 2500 unités
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
-- - France : Augmentation de 3200 unités
-- - United Kingdom : Diminution de 2400 unités
-- - India : Augmentation de 700 unités
SELECT Country, Year, SUM(Quantity) AS Total_Quantity 
FROM RegionalOrders
GROUP BY Country, Year
ORDER BY Total_Quantity ASC;

-- Détails des ventes par produit pour 2020 et 2021
SELECT Product, SUM(Quantity) AS Total_Quantity, Year
FROM RegionalOrders
WHERE Year IN (2020, 2021)
GROUP BY Product, Year;
