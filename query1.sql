--comment

SELECT * 
FROM (
	SELECT *, rank() OVER (ORDER BY sub.weeklysales DESC) AS SalesRank
	FROM (
		SELECT * 
		FROM sales INNER JOIN holidays ON sales.weekdate = holidays.weekdate
		WHERE isHoliday = true
	) AS sub
) AS sub2
WHERE SalesRank = 1;

SELECT * 
FROM (
	SELECT *, rank() OVER (ORDER BY sub.weeklysales ASC) AS SalesRank
	FROM (
		SELECT * 
		FROM sales INNER JOIN holidays ON sales.weekdate = holidays.weekdate
		WHERE isHoliday = true
	) AS sub
) AS sub2
WHERE SalesRank = 1;

