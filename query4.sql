SELECT count(*)
FROM (
	SELECT sales.weekdate, sum(sales.weeklysales)
	FROM (
		Holidays INNER JOIN Sales ON Sales.WeekDate = Holidays.weekDate
	)
	WHERE isHoliday = 'False'
	GROUP BY sales.weekdate
	HAVING sum(weeklySales) > (	SELECT AVG(sum_sales) 
								FROM (
									SELECT SUM(sales.WeeklySales) AS sum_sales
									FROM (Sales INNER JOIN Holidays ON Sales.WeekDate = Holidays.weekDate) 
									WHERE holidays.IsHoliday = 'True'
									GROUP BY sales.weekdate
								) AS holiday_avg)
	ORDER BY sales.weekdate
) AS num_greater;
