SELECT  Dept
FROM 
(SELECT Sales.Store, Sales.Dept, SUM(Sales.WeeklySales) as DeptSales
FROM Sales
GROUP BY Sales.Store, Sales.Dept) sdws

INNER JOIN

(SELECT Store, SUM(Sales.WeeklySales) AS TotalSales FROM Sales GROUP BY Sales.Store) sts

ON sdws.Store = sts.Store 

WHERE sdws.DeptSales > 0.05*sts.TotalSales
GROUP BY sdws.Dept
HAVING count(sdws.Store) >= 3
ORDER BY sdws.Dept
;


