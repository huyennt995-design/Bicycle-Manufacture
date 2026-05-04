--Query 6: Trend of Stock level & MoM diff % by all product in 2011.
WITH stockLevel_tbl AS (
    SELECT
        FORMAT_DATETIME('%m',wo.ModifiedDate) AS Month
        ,FORMAT_DATETIME('%Y',wo.ModifiedDate) AS Year
        ,pro.Name AS Name
        ,SUM(OrderQty - ScrappedQty) AS qty_stock
    FROM `adventureworks2019.Production.WorkOrder` wo
    LEFT JOIN `adventureworks2019.Production.Product` pro
        ON pro.ProductID = wo.ProductID
    WHERE EXTRACT (YEAR FROM wo.ModifiedDate) = 2011
    GROUP BY 1,2,3
)
, summary_stockLevel AS (
    SELECT
        Month
        ,Year
        ,Name AS ProductName
        ,qty_stock AS current_stock
        ,LEAD(qty_stock) OVER (PARTITION BY Name ORDER BY Year, Month DESC) AS prv_stock
    FROM stockLevel_tbl
)
SELECT
    ProductName
    ,Year
    ,Month
    ,current_stock
    ,prv_stock
    ,ROUND(
        (current_stock - prv_stock)
        / NULLIF(prv_stock,0) * 100
         ,1) AS diff_stock
FROM summary_stockLevel;

--Query 7: Calc Ratio of Stock / Sales (Sum of Order Quantity) 2011.
WITH sales_tbl AS (
    SELECT
        FORMAT_DATETIME('%m/ %Y', sales.ModifiedDate) AS Period
        ,pro.Name AS Name
        ,SUM(OrderQty) AS cnt_sales  
    FROM `adventureworks2019.Sales.SalesOrderDetail` sales
    LEFT JOIN `adventureworks2019.Production.ProductTable` pro
      ON sales.ProductID = pro.ProductID
    WHERE EXTRACT(YEAR FROM sales.ModifiedDate) = 2011
    GROUP BY 1,2
)
,stock_tbl AS (
    SELECT
            FORMAT_DATETIME('%m/ %Y', wo.ModifiedDate) AS Period
            ,pro.Name AS Name
            ,SUM(OrderQty - ScrappedQty) AS cnt_stock
        FROM `adventureworks2019.Production.WorkOrder` wo
        LEFT JOIN `adventureworks2019.Production.Product` pro
            ON pro.ProductID = wo.ProductID
        WHERE EXTRACT (YEAR FROM wo.ModifiedDate) = 2011
        GROUP BY 1,2
)
SELECT  
    sa.Period
    ,sa.Name
    ,sa.cnt_sales
    ,st.cnt_stock
    ,ROUND(
      COALESCE(st.cnt_stock,0) / NULLIF(COALESCE(sa.cnt_sales,0),0)
      ,1) AS ratio
FROM sales_tbl sa
JOIN stock_tbl st
    ON sa.Period = st.Period AND sa.Name = st.Name
ORDER BY sa.Period DESC, ratio DESC;
