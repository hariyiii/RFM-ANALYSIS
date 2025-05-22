SELECT O.CustomerID,
       P.ProductName,
       COUNT(*) AS Total_Orders,
       SUM(OD.UnitPrice * OD.Quantity) AS Total_Spend
FROM Orders O
JOIN `order details` OD ON O.OrderID = OD.OrderID
JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY O.CustomerID, P.ProductName
ORDER BY Total_spend DESC;