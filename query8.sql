
CREATE OR REPLACE VIEW view1 AS (SELECT  Dept
FROM 
(SELECT Sales.Store, Sales.Dept, SUM(Sales.WeeklySales) as DeptSales
FROM Sales
GROUP BY Sales.Store, Sales.Dept) sdws

INNER JOIN

(SELECT Store, SUM(Sales.WeeklySales) AS TotalSales FROM Sales GROUP BY Sales.Store) sts

ON sdws.Store = sts.Store 

WHERE sdws.DeptSales > 0.05*sts.TotalSales
GROUP BY sdws.Dept
HAVING count(sdws.Store) >= 3)
;


SELECT sdds.dept, AVG(sdds.DeptSales/sts.TotalSales)
FROM
(SELECT sdws.store, sdws.dept, sdws.DeptSales FROM view1 INNER JOIN (SELECT Sales.Store, Sales.Dept, SUM(Sales.WeeklySales) as DeptSales
FROM Sales
GROUP BY Sales.Store, Sales.Dept) as sdws ON view1.dept = sdws.dept ORDER BY view1.dept, sdws.store) sdds

INNER JOIN

(SELECT Store, SUM(Sales.WeeklySales) AS TotalSales FROM Sales GROUP BY Sales.Store) sts
ON sdds.store = sts.store  
GROUP BY sdds.dept;


DROP VIEW view1;

