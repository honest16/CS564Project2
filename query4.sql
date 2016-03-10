SELECT Count(DISTINCT Sales.WeekDate)
FROM Holidays INNER JOIN Sales ON Sales.WeekDate = Holidays.weekDate
WHERE Sales.WeeklySales > (SELECT AVG(Sales.WeeklySales) FROM Sales INNER JOIN Holidays ON Sales.WeekDate = Holidays.weekDate WHERE Holidays.IsHoliday = 'True') AND Holidays.IsHoliday = 'False';

