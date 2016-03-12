CREATE OR REPLACE VIEW view1 AS(SELECT Sales.Store, Sales.Dept, Date_part('month', Sales.weekdate) as month, Date_part('year', weekdate) as year, WeeklySales
FROM Sales
ORDER BY store, dept, month, year)
;

CREATE OR REPLACE VIEW TotNumDept AS (SELECT store, COUNT(DISTINCT dept) FROM view1 GROUP BY store, year);

CREATE OR REPLACE VIEW AllMonthsDept AS (SELECT store, dept, COUNT(DISTINCT month) AS numMonths, year FROM view1 GROUP BY store, dept, year HAVING COUNT(DISTINCT month) = 12);

CREATE OR REPLACE VIEW CountDept AS (SELECT store, COUNT(DISTINCT dept) AS deptCount, year FROM AllMonthsDept GROUP BY store, year);

SELECT TotNumDept.store FROM TotNumDept INNER JOIN CountDept ON TotNumDept.Store = CountDept.Store WHERE TotNumDept.count= CountDept.deptCount;


DROP VIEW view1, TotNumDept, AllMonthsDept, CountDept;
