-- Query 1: Sales metrics by Subcategory in the Last 12 Months (L12M)
WITH LY_tble AS (
    SELECT DISTINCT 
        DATE_TRUNC(DATE_SUB(CAST(MAX(ModifiedDate) AS DATE), INTERVAL 12 MONTH), MONTH) AS first_dateLY
    FROM `adventureworks2019.Sales.SalesOrderDetail`
)
SELECT
    FORMAT_DATETIME('%b %Y', sales.ModifiedDate) AS Period,
    subCat.Name AS NameSubCat,
    SUM(OrderQty) AS cnt_items,
    COUNT(DISTINCT SalesOrderID) AS cnt_orders,
    ROUND(SUM(LineTotal), 4) AS total_values
FROM `adventureworks2019.Sales.SalesOrderDetail` sales
LEFT JOIN `adventureworks2019.Production.Product` pro ON sales.ProductID = pro.ProductID
LEFT JOIN `adventureworks2019.Production.ProductSubcategory` subCat ON pro.ProductSubcategoryID = subCat.ProductSubcategoryID
WHERE CAST(sales.ModifiedDate AS DATE) >= (SELECT first_dateLY FROM LY_tble)
GROUP BY 1, 2
ORDER BY MIN(sales.ModifiedDate) DESC, 2;

-- Query 2: YoY growth rate and Top 3 Subcategories by growth
WITH summary_tbl AS (
    SELECT
        EXTRACT(YEAR FROM s.ModifiedDate) AS Year,
        sub.Name AS Name,
        SUM(OrderQty) AS qty_items
    FROM `adventureworks2019.Sales.SalesOrderDetail` s
    LEFT JOIN `adventureworks2019.Production.Product` p ON s.ProductID = p.ProductID
    LEFT JOIN `adventureworks2019.Production.ProductSubcategory` sub ON p.ProductSubcategoryID = sub.ProductSubcategoryID
    GROUP BY 1, 2
),
growth_analysis AS (
    SELECT *, LAG(qty_items) OVER (PARTITION BY Name ORDER BY Year) AS prv_qty
    FROM summary_tbl
)
SELECT Name, Year, qty_items, prv_qty,
       ROUND(SAFE_DIVIDE(qty_items, prv_qty) - 1, 2) AS qty_diff
FROM growth_analysis
QUALIFY DENSE_RANK() OVER (PARTITION BY Year ORDER BY (SAFE_DIVIDE(qty_items, prv_qty) - 1) DESC) <= 3;

-- Query 3: Top 3 Territories with highest Order Quantity per Year
WITH AggregatedSales AS (
    SELECT
        EXTRACT(YEAR FROM de.ModifiedDate) AS Year,
        ter.TerritoryID,
        SUM(OrderQty) AS qty_orders  
    FROM `adventureworks2019.Sales.SalesOrderDetail` de
    JOIN `adventureworks2019.Sales.SalesOrderHeader` he ON de.SalesOrderID = he.SalesOrderID
    JOIN `adventureworks2019.Sales.SalesTerritory` ter ON he.TerritoryID = ter.TerritoryID
    GROUP BY 1, 2
)
SELECT * FROM AggregatedSales
QUALIFY DENSE_RANK() OVER (PARTITION BY Year ORDER BY qty_orders DESC) <= 3;
