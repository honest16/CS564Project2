SELECT fuel2.store 
FROM (
	(SELECT *
	FROM (
		SELECT store, max(fuelprice) AS MaxFuelPrice
		FROM temporaldata
		GROUP BY store
	) AS fuel
	WHERE MaxFuelPrice < 4) AS fuel2
	INNER JOIN
	(SELECT *
	FROM (
		SELECT store, max(unemploymentrate) AS MaxUnemploymentRate
		FROM temporaldata
		GROUP BY store
	)AS unemp
	WHERE MaxUnemploymentRate > 10) AS unemp2
	ON fuel2.store = unemp2.store
);
