--Query 4: Calc Total Discount Cost belongs to Seasonal Discount for each SubCategory
SELECT DISTINCT
    FORMAT_DATETIME('%Y',s.ModifiedDate) AS Year
    ,sub.Name AS Name
    ,SUM(sO.DiscountPct * s.UnitPrice * s.OrderQty) AS total_cost
FROM `adventureworks2019.Sales.SalesOrderDetail` s
    LEFT JOIN `adventureworks2019.Production.Product` p
        ON s.ProductID = p.ProductID
    LEFT JOIN `adventureworks2019.Production.ProductSubcategory` sub
        ON CAST(p.ProductSubcategoryID AS INT) = sub.ProductSubcategoryID
    LEFT JOIN `adventureworks2019.Sales.SpecialOffer` sO
        ON s.SpecialOfferID = sO.SpecialOfferID
WHERE LOWER(sO.Type) LIKE '%seasonal discount%'
GROUP BY 1,2;

--Query 5: Retention rate of Customer in 2014 with status of Successfully Shipped (Cohort Analysis)
WITH order_info AS (
  SELECT
      DISTINCT CustomerID
      ,EXTRACT(MONTH FROM ModifiedDate) AS Month_order
  FROM `adventureworks2019.Sales.SalesOrderHeader` sales
  WHERE EXTRACT(YEAR FROM ModifiedDate) = 2014 AND Status = 5
  ORDER BY CustomerID, Month_order
)
,ranked_order AS (
  SELECT
       *
      ,MIN(Month_order) OVER (PARTITION BY CustomerID) AS Month_join
  FROM order_info
  )
SELECT
    Month_join
    ,'M-' || (Month_order  - Month_join) AS month_diff
    ,COUNT(DISTINCT CustomerID) AS cnt_customer
FROM ranked_order
GROUP BY 1,2
ORDER BY 1,2;
