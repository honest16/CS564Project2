SELECT stores.type, DATE_PART('month', weekdate), sum(weeklysales) 
FROM sales INNER JOIN stores ON sales.store = stores.store 
GROUP BY type, date_part 
ORDER BY type, date_part;