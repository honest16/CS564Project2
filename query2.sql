SELECT dept, SalesPerWeek 
FROM (
	SELECT *, rank() OVER (ORDER BY SalesPerWeek DESC) AS OrderRank
	FROM (
		SELECT dept, SUM(sub.weeklysales/ sub.size) AS SalesPerWeek
		FROM (
			SELECT * 
			FROM sales INNER JOIN stores ON sales.store = stores.store
		) AS sub
		GROUP BY dept
	) AS sub2
) AS sub3
WHERE OrderRank <= 10
;