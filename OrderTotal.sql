 SELECT O.CustomerID, O.OrderID, O.OrderDate,
       SUM(OD.UnitPrice * OD.Quantity) AS OrderTotal
FROM Orders O
JOIN `order details` OD ON O.OrderID = OD.OrderID
GROUP BY O.CustomerID, O.OrderID, O.OrderDate
ORDER BY OrderTotal DESC;