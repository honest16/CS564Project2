DROP TABLE Output7;

CREATE TABLE Output7(AttributeName VARCHAR(20), CorrSign char(1), CorrValue float);

INSERT INTO Output7 SELECT 'Temperature', (SELECT case when val > 0 then '+'
            else '-' end                                                                                                                                  
FROM (SELECT corr(Sales.WeeklySales,TemporalData.Temperature) FROM Sales INNER JOIN TemporalData ON Sales.WeekDate = TemporalData.WeekDate) AS float(val)), (SELECT corr(Sales.WeeklySales,TemporalData.Temperature) FROM Sales INNER JOIN TemporalData ON Sales.WeekDate = TemporalData.WeekDate);



INSERT INTO Output7 SELECT 'Fuel Price', (SELECT case when val > 0 then '+'
            else '-' end                                                                                                                                  
FROM (SELECT corr(Sales.WeeklySales,TemporalData.FuelPrice) FROM Sales INNER JOIN TemporalData ON Sales.WeekDate = TemporalData.WeekDate) AS float(val)), (SELECT corr(Sales.WeeklySales,TemporalData.FuelPrice) FROM Sales INNER JOIN TemporalData ON Sales.WeekDate = TemporalData.WeekDate);


INSERT INTO Output7 SELECT 'CPI', (SELECT case when val > 0 then '+'
            else '-' end                                                                                                                                  
FROM (SELECT corr(Sales.WeeklySales,TemporalData.CPI) FROM Sales INNER JOIN TemporalData ON Sales.WeekDate = TemporalData.WeekDate) AS float(val)), (SELECT corr(Sales.WeeklySales,TemporalData.CPI) FROM Sales INNER JOIN TemporalData ON Sales.WeekDate = TemporalData.WeekDate);


INSERT INTO Output7 SELECT 'UnemploymentRate', (SELECT case when val > 0 then '+'
            else '-' end                                                                                                                                  
FROM (SELECT corr(Sales.WeeklySales,TemporalData.UnemploymentRate) FROM Sales INNER JOIN TemporalData ON Sales.WeekDate = TemporalData.WeekDate) AS float(val)), (SELECT corr(Sales.WeeklySales,TemporalData.UnemploymentRate) FROM Sales INNER JOIN TemporalData ON Sales.WeekDate = TemporalData.WeekDate);

SELECT * FROM Output7;
