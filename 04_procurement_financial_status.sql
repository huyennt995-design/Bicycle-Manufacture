--Query 8: Nr of order and value at Pending status (Filter 1) in 2014 (Purchasing)
SELECT
    EXTRACT(YEAR FROM ModifiedDate) AS Year
    ,Status AS Pending_status
    ,COUNT(DISTINCT PurchaseOrderID) AS cnt_orders
    ,SUM(TotalDue) AS value
FROM `adventureworks2019.Purchasing.PurchaseOrderHeader`
WHERE EXTRACT(YEAR FROM ModifiedDate) = 2014 AND Status = 1
GROUP BY 1,2;
