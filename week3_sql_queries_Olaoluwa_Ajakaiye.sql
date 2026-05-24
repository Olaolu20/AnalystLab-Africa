-- ANALYSTLAB AFRICA DATA ANALYTICS INTERNSHIP
-- WEEK 3: SQL & DATA QUERYING
-- OLAOLUWA AJAKAIYE
-- DATE: MAY 2025

-- SECTION 1: CHINOOK DATABASE 
USE chinook;
-- 1.1. Core SQL Queries

-- to list the artists
select * from artist;

-- Track count by unit price
SELECT DISTINCT UnitPrice FROM track;
SELECT UnitPrice, COUNT(*) AS TotalTracks
FROM track
GROUP BY UnitPrice;

-- finding tracks that cost more than the 0.99 dollars (the cost of most of the tracks)
SELECT Name, UnitPrice 
FROM track
WHERE UnitPrice > 0.99
ORDER BY UnitPrice DESC;

-- number of tracks in each genre
SELECT g.Name AS Genre, COUNT(t.TrackId) AS TotalTracks
FROM track t
JOIN genre g ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY TotalTracks DESC;

-- total revenue generated in each country
SELECT BillingCountry, ROUND(SUM(Total), 2) AS TotalRevenue
FROM invoice
GROUP BY BillingCountry
ORDER BY TotalRevenue DESC;

-- countries with total revenue above 150 dollars
SELECT BillingCountry, ROUND(SUM(Total), 2) AS TotalRevenue
FROM invoice
GROUP BY BillingCountry
HAVING TotalRevenue > 150
ORDER BY TotalRevenue DESC;

-- 1.2. Advanced SQL Concepts
-- customers who actually made a purchase
SELECT c.FirstName, c.LastName, i.InvoiceId, i.Total
FROM customer c
INNER JOIN invoice i ON c.CustomerId = i.CustomerId;

SELECT COUNT(*) AS TotalRows
FROM customer c
INNER JOIN invoice i ON c.CustomerId = i.CustomerId;

-- to return customers even if they have no invoices
SELECT COUNT(*) AS TotalRows
FROM customer c
LEFT JOIN invoice i ON c.CustomerId = i.CustomerId;

-- to check for invoices even if customer's record is missing
SELECT COUNT(*) AS TotalRows
FROM customer c
RIGHT JOIN invoice i ON c.CustomerId = i.CustomerId;

-- 1.3. Business Questions
-- Top 10 Customers by total spending
SELECT c.FirstName, c.LastName, c.Country,
ROUND(SUM(i.Total), 2) AS TotalSpent
FROM customer c
JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY TotalSpent DESC
LIMIT 10;

-- Revenue trend by year
SELECT YEAR(InvoiceDate) AS Year,
ROUND(SUM(Total), 2) AS TotalRevenue
FROM invoice
GROUP BY Year
ORDER BY TotalRevenue desc;

-- Top 10 best selling tracks
SELECT t.Name AS Track, ar.Name AS Artist,
COUNT(il.TrackId) AS TimesPurchased
FROM invoiceline il
JOIN track t ON il.TrackId = t.TrackId
JOIN album al ON t.AlbumId = al.AlbumId
JOIN artist ar ON al.ArtistId = ar.ArtistId
GROUP BY il.TrackId
ORDER BY TimesPurchased DESC
LIMIT 10;

-- Most popular genre by sales
SELECT g.Name AS Genre,
COUNT(il.TrackId) AS TotalSales
FROM invoiceline il
JOIN track t ON il.TrackId = t.TrackId
JOIN genre g ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY TotalSales DESC;

-- 1.4. subqueries
-- customers who spent more than the average customer
SELECT c.FirstName, c.LastName,
ROUND(SUM(i.Total), 2) AS TotalSpent
FROM customer c
JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
HAVING TotalSpent > (
    SELECT AVG(CustomerTotal)
    FROM (
        SELECT SUM(Total) AS CustomerTotal
        FROM invoice
        GROUP BY CustomerId
    ) AS AvgTable
)
ORDER BY TotalSpent DESC;

-- 1.5. Windows Function
-- customers rank according to how much they spent
SELECT c.FirstName, c.LastName,
ROUND(SUM(i.Total), 2) AS TotalSpent,
ROW_NUMBER() OVER (ORDER BY SUM(i.Total) DESC) AS RowNum
FROM customer c
JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId;

SELECT c.FirstName, c.LastName,
ROUND(SUM(i.Total), 2) AS TotalSpent,
RANK() OVER (ORDER BY SUM(i.Total) DESC) AS Rank_Position
FROM customer c
JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId;

-- customers by country
SELECT c.FirstName, c.LastName, c.Country,
ROUND(SUM(i.Total), 2) AS TotalSpent,
RANK() OVER (PARTITION BY c.Country ORDER BY SUM(i.Total) DESC) AS CountryRank
FROM customer c
JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.Country;


-- SECTION 2: SALES DATASET

USE sales_data;
-- 2.1. Core Queries
-- Core Queries 
-- total revenue by year
SELECT YEAR_ID, ROUND(SUM(SALES), 2) AS TotalRevenue
FROM sales_data_sample
GROUP BY YEAR_ID
ORDER BY TotalRevenue;

-- total revenue by product line
SELECT PRODUCTLINE, ROUND(SUM(SALES), 2) AS TotalRevenue
FROM sales_data_sample
GROUP BY PRODUCTLINE
ORDER BY TotalRevenue DESC;

-- Orders by status
SELECT STATUS, COUNT(*) AS TotalOrders
FROM sales_data_sample
GROUP BY STATUS
ORDER BY TotalOrders DESC;

-- top 10 customers by revenue
SELECT CUSTOMERNAME, ROUND(SUM(SALES), 2) AS TotalRevenue
FROM sales_data_sample
GROUP BY CUSTOMERNAME
ORDER BY TotalRevenue DESC
LIMIT 10;

-- 2.2. Business Questions
-- Revenue trend by month and year
SELECT YEAR_ID, MONTH_ID,
ROUND(SUM(SALES), 2) AS TotalRevenue
FROM sales_data_sample
GROUP BY YEAR_ID, MONTH_ID
ORDER BY TotalRevenue DESC;

-- customer purchasing behaviour
SELECT CUSTOMERNAME,
COUNT(DISTINCT ORDERNUMBER) AS TotalOrders,
ROUND(SUM(SALES), 2) AS TotalRevenue,
ROUND(AVG(SALES), 2) AS AvgOrderValue
FROM sales_data_sample
GROUP BY CUSTOMERNAME
ORDER BY TotalOrders DESC
LIMIT 10;

-- 2.3. Subqueries
-- customers whose revenue is greater than the average customer revenue
SELECT CUSTOMERNAME, ROUND(SUM(SALES), 2) AS TotalRevenue
FROM sales_data_sample
GROUP BY CUSTOMERNAME
HAVING TotalRevenue > (
    SELECT AVG(CustomerTotal)
    FROM (
        SELECT SUM(SALES) AS CustomerTotal
        FROM sales_data_sample
        GROUP BY CUSTOMERNAME
    ) AS AvgTable
)
ORDER BY TotalRevenue DESC;

-- 2.4. Windows Functions
-- customer rank by revenue
SELECT CUSTOMERNAME,
ROUND(SUM(SALES), 2) AS TotalRevenue,
ROW_NUMBER() OVER (ORDER BY SUM(SALES) DESC) AS RowNum
FROM sales_data_sample
GROUP BY CUSTOMERNAME;

SELECT CUSTOMERNAME,
ROUND(SUM(SALES), 2) AS TotalRevenue,
RANK() OVER (ORDER BY SUM(SALES) DESC) AS Rank_Position
FROM sales_data_sample
GROUP BY CUSTOMERNAME;

-- customer rank by country
SELECT CUSTOMERNAME, COUNTRY,
ROUND(SUM(SALES), 2) AS TotalRevenue,
RANK() OVER (PARTITION BY COUNTRY ORDER BY SUM(SALES) DESC) AS CountryRank
FROM sales_data_sample
GROUP BY CUSTOMERNAME, COUNTRY;