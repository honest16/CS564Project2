DROP TABLE Output7;

CREATE TABLE Output7(AttributeName VARCHAR(20), CorrSign char(1), CorrValue float);


INSERT INTO Output7 VALUES ('Temperature', (SELECT case when val > 0 then '+'
            else '-' end                                                                                                                                  
FROM (SELECT corr(TemporalData.Temperature,Sales.WeeklySales) FROM Sales INNER JOIN TemporalData ON Sales.WeekDate = TemporalData.WeekDate AND Sales.Store = TemporalData.Store) as float(val)), (SELECT corr(TemporalData.Temperature,Sales.WeeklySales) FROM Sales INNER JOIN TemporalData ON Sales.WeekDate = TemporalData.WeekDate AND Sales.Store = TemporalData.Store));


INSERT INTO Output7 VALUES ('Fuel Price', (SELECT case when val > 0 then '+'
            else '-' end                                                                                                                                  
FROM (SELECT corr(TemporalData.FuelPrice,Sales.WeeklySales) FROM Sales INNER JOIN TemporalData ON Sales.WeekDate = TemporalData.WeekDate AND Sales.Store = TemporalData.Store) as float(val)), (SELECT corr(TemporalData.FuelPrice,Sales.WeeklySales) FROM Sales INNER JOIN TemporalData ON Sales.WeekDate = TemporalData.WeekDate AND Sales.Store = TemporalData.Store));


INSERT INTO Output7 VALUES ('CPI', (SELECT case when val > 0 then '+'
            else '-' end                                                                                                                                  
FROM (SELECT corr(TemporalData.CPI,Sales.WeeklySales) FROM Sales INNER JOIN TemporalData ON Sales.WeekDate = TemporalData.WeekDate AND Sales.Store = TemporalData.Store) as float(val)), (SELECT corr(TemporalData.CPI,Sales.WeeklySales) FROM Sales INNER JOIN TemporalData ON Sales.WeekDate = TemporalData.WeekDate AND Sales.Store = TemporalData.Store));


INSERT INTO Output7 VALUES ('UnemploymentRate', (SELECT case when val > 0 then '+'
            else '-' end                                                                                                                                  
FROM (SELECT corr(TemporalData.UnemploymentRate,Sales.WeeklySales) FROM Sales INNER JOIN TemporalData ON Sales.WeekDate = TemporalData.WeekDate AND Sales.Store = TemporalData.Store) as float(val)), (SELECT corr(TemporalData.UnemploymentRate,Sales.WeeklySales) FROM Sales INNER JOIN TemporalData ON Sales.WeekDate = TemporalData.WeekDate AND Sales.Store = TemporalData.Store));

SELECT * FROM Output7;

DROP TABLE Output7;
