SELECT to_char(to_timestamp(Date_Part('month', sales.weekdate)::text,'MM'),'TMmon') AS months, stores.type, sum(weeklysales) 
FROM sales INNER JOIN stores ON sales.store = stores.store 
GROUP BY type, Date_Part('month',sales.weekdate)
ORDER BY Date_Part('month',sales.weekdate), type;
