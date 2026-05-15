CREATE DATABASE analystlab;
SELECT COUNT(*) FROM analystlab.Online_Retail;
SET GLOBAL local_infile = 1;
DROP TABLE IF EXISTS analystlab.Online_Retail;
-- importing the cleaned data
CREATE TABLE analystlab.Online_Retail (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice FLOAT,
    CustomerID INT,
    Country VARCHAR(100),
    TotalPrice FLOAT
);
LOAD DATA LOCAL INFILE 'C:/Users/USER/OneDrive/Desktop/Data Analysis/AnalystLab Africa/Data/Cleaned/Online_Retail.csv'
INTO TABLE analystlab.Online_Retail
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) FROM analystlab.Online_Retail;
-- Checking the first 10 rows
SELECT * FROM analystlab.Online_Retail
LIMIT 10;
UPDATE analystlab.Online_Retail
SET TotalPrice = Quantity * UnitPrice;
SET SQL_SAFE_UPDATES = 0;
-- total revenue
SELECT ROUND(SUM(TotalPrice), 2) AS Total_Revenue
FROM analystlab.Online_Retail;
 -- Top 10 Countries by Revenue
SELECT Country, ROUND(SUM(TotalPrice), 2) AS Revenue
FROM analystlab.Online_Retail
GROUP BY Country
ORDER BY Revenue DESC
LIMIT 10;
-- Top 10 Best Selling Products
SELECT Description, SUM(Quantity) AS Total_Quantity
FROM analystlab.Online_Retail
GROUP BY Description
ORDER BY Total_Quantity DESC
LIMIT 10;
SELECT COUNT(DISTINCT CustomerID) AS Total_Customers
FROM analystlab.Online_Retail;
SELECT DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month,
ROUND(SUM(TotalPrice), 2) AS Revenue
FROM analystlab.Online_Retail
GROUP BY Month
ORDER BY Month;