SELECT store, sales 
FROM (
	SELECT *, rank() OVER (ORDER BY sub2.Sales DESC) AS SalesRank
	FROM (
		SELECT store, sum(weeklysales) AS Sales
		FROM (
			SELECT store, weeklysales 
			FROM sales INNER JOIN holidays ON sales.weekdate = holidays.weekdate
			WHERE isHoliday = true	
			) AS sub
		GROUP BY store
		) AS sub2
	) AS sub3
WHERE SalesRank = 1

UNION ALL 

SELECT store, sales 
FROM (
	SELECT *, rank() OVER (ORDER BY sub2.Sales) AS SalesRank
	FROM (
		SELECT store, sum(weeklysales) AS Sales
		FROM (
			SELECT store, weeklysales 
			FROM sales INNER JOIN holidays ON sales.weekdate = holidays.weekdate
			WHERE isHoliday = true	
			) AS sub
		GROUP BY store
		) AS sub2
	) AS sub3
WHERE SalesRank = 1;
