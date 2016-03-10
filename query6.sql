SELECT DISTINCT storeDept.Store
FROM 
(SELECT Store, Dept as dpt1, (Extract(month from Sales.WeekDate)) as month, Extract(year from Sales.WeekDate) as year
FROM Sales
GROUP BY Store, dpt1 , month, year ORDER BY Store, dpt1, month, year) storeDeptMonthYear

INNER JOIN

(SELECT Store, Dept as dpt2
FROM Sales
GROUP BY Store, dpt2 ORDER BY Store, dpt2) storeDept 

ON storeDeptMonthYear.Store = storeDept.Store 

GROUP BY storeDept.Store, dpt1, year, dpt2
HAVING Count(DISTINCT storeDeptMonthYear.month) = 12 AND Count(DISTINCT storeDeptMonthYear.dpt1) = Count(DISTINCT storeDept.dpt2)
;

