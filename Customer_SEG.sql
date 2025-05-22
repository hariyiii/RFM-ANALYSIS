 WITH RFM AS (
    SELECT CustomerID, CompanyName,
           ContactName,
           MAX(OrderDate) AS Last_Purchase,
           DATEDIFF('1998-05-06', MAX(OrderDate)) AS Recency,
           COUNT(DISTINCT OrderID) AS Frequency,
           ROUND(SUM(UnitPrice * Quantity), 2) AS Monetary
    FROM Orders
    LEFT JOIN Customers USING(CustomerID)
    LEFT JOIN `order details` USING(OrderID)
    GROUP BY CustomerID, CompanyName, ContactName
),

Final AS (
    SELECT *,
    CASE 
        WHEN Recency <= 100 THEN 5
        WHEN Recency <= 200 THEN 4
        WHEN Recency <= 400 THEN 3
        WHEN Recency <= 600 THEN 2
        ELSE 1
    END AS R_SCORE,

    CASE 
        WHEN Frequency >= 20 THEN 5
        WHEN Frequency >= 14 THEN 4
        WHEN Frequency >= 8 THEN 3
        WHEN Frequency >= 4 THEN 2
        ELSE 1
    END AS F_SCORE,

    CASE 
        WHEN Monetary >= 90000 THEN 5
        WHEN Monetary >= 60000 THEN 4
        WHEN Monetary >= 30000 THEN 3
        WHEN Monetary >= 10000 THEN 2
        ELSE 1
    END AS M_SCORE

    FROM RFM
),

Segmented AS (
    SELECT *,
    CONCAT(R_SCORE, F_SCORE, M_SCORE) AS Customer_Seg,

    CASE
        WHEN R_SCORE = 5 AND F_SCORE >= 4 AND M_SCORE >= 4 THEN 'VIP (Champions)'
        WHEN R_SCORE >= 4 AND F_SCORE >= 3 AND M_SCORE >= 3 THEN 'Loyal Customers'
        WHEN R_SCORE >= 3 AND F_SCORE >= 2 AND M_SCORE >= 2 THEN 'Potential Loyalists'
        WHEN R_SCORE <= 3 AND F_SCORE BETWEEN 2 AND 3 THEN 'Slipping Away'
        WHEN R_SCORE = 1 AND F_SCORE <= 2 THEN 'Lost Customers'
        ELSE 'Others'
    END AS Customer_Category

    FROM Final
)

SELECT CustomerID, CompanyName, ContactName, Last_Purchase, Recency, Frequency, Monetary, 
       R_SCORE, F_SCORE, M_SCORE, Customer_Seg, Customer_Category
FROM Segmented
ORDER BY Customer_Category DESC, R_SCORE DESC, F_SCORE DESC, M_SCORE DESC;