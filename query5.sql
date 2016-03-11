SELECT DATE_PART('month', weekdate) AS months, stores.type, sum(weeklysales) 
FROM sales INNER JOIN stores ON sales.store = stores.store 
GROUP BY type, months 
ORDER BY months, type;
