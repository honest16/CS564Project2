
CREATE OR REPLACE VIEW view1 AS(
SELECT dept, norm_sales 
FROM (
	SELECT *, rank() OVER (ORDER BY norm_sales DESC) AS OrderRank
	FROM (
		SELECT dept, SUM(sub.weeklysales/ sub.size) AS norm_sales
		FROM (
			SELECT * 
			FROM sales INNER JOIN stores ON sales.store = stores.store
		) AS sub
		GROUP BY dept
	) AS sub2
) AS sub3
WHERE OrderRank <= 10)
;


CREATE OR REPLACE VIEW view2 AS(
SELECT sales.dept as dept, DATE_PART('year', weekdate) AS yr, DATE_PART('month', weekdate) AS month, sales.weeklysales AS weeklysales 
FROM view1 INNER JOIN sales ON view1.dept = sales.dept);



CREATE OR REPLACE VIEW view3 AS(SELECT dept, yr, month, sum(weeklysales) AS monthly_sales FROM view2 GROUP BY dept, yr, month ORDER BY dept, yr, month);

SELECT dept, yr, month,SUM(monthly_sales) OVER (PARTITION BY dept ORDER BY dept, yr, month) AS cumulative_sales FROM view3 ORDER BY dept, yr, month;

DROP VIEW view1, view2, view3;

