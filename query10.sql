
CREATE OR REPLACE VIEW view1 AS (
SELECT sdws.yr, sdws.qtr, sdws.store_a_sales, sts.store_b_sales
FROM
(SELECT yr, qtr, sum AS store_a_sales
	FROM (
		SELECT yr ,CASE WHEN salemonth <= 3 THEN '1' WHEN salemonth <= 6 THEN '2'  WHEN salemonth <= 9 THEN '3' WHEN salemonth <= 12 THEN '4' END AS qtr, type, sum(weeklysales)
		FROM ( 
			    SELECT DATE_PART('year', weekDate) AS yr, DATE_PART('month', weekDate) AS saleMonth, type, weeklysales
				FROM (
					SELECT * 
					FROM (sales INNER JOIN stores ON sales.store = stores.store)
				) AS sub
			)AS sub2
		GROUP BY yr, qtr, type
		ORDER BY yr, qtr
		) AS sub3
	WHERE type = 'A') sdws

INNER JOIN

(SELECT yr, qtr, sum AS store_b_sales
	FROM (
		SELECT yr ,CASE WHEN salemonth <= 3 THEN '1' WHEN salemonth <= 6 THEN '2'  WHEN salemonth <= 9 THEN '3' WHEN salemonth <= 12 THEN '4' END AS qtr, type, sum(weeklysales)
		FROM ( 
			    SELECT DATE_PART('year', weekDate) AS yr, DATE_PART('month', weekDate) AS saleMonth, type, weeklysales
				FROM (
					SELECT * 
					FROM (sales INNER JOIN stores ON sales.store = stores.store)
				) AS sub4
			)AS sub5
		GROUP BY yr, qtr, type
		ORDER BY yr, qtr
		) AS sub6
	WHERE type = 'B') sts
	
ON sdws.yr = sts.yr AND sdws.qtr = sts.qtr);

SELECT * FROM view1 UNION ALL SELECT view1.yr, null as qtr, sum(view1.store_a_sales) AS store_a_sales, sum(view1.store_b_sales) AS store_b_sales FROM view1 GROUP BY yr ORDER BY yr, qtr;
DROP VIEW view1
;




