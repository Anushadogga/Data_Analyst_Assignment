-- B1: Revenue by sales channel
SELECT sales_channel,
       SUM(amount) AS revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel;

--------------------------------------------------

-- B2: Top 10 valuable customers
SELECT uid,
       SUM(amount) AS total_spent
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;

--------------------------------------------------

-- B3: Month-wise revenue, expense, profit
SELECT r.month,
       r.revenue,
       e.expense,
       (r.revenue - e.expense) AS profit,
       CASE 
           WHEN (r.revenue - e.expense) > 0 THEN 'Profitable'
           ELSE 'Not Profitable'
       END AS status
FROM (
    SELECT MONTH(datetime) AS month,
           SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
) r
JOIN (
    SELECT MONTH(datetime) AS month,
           SUM(amount) AS expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
) e
ON r.month = e.month;

--------------------------------------------------

-- B4: Most profitable clinic per city (Example: month = 9)
SELECT t.city, t.cid, t.profit
FROM (
    SELECT c.city,
           c.cid,
           SUM(cs.amount) - COALESCE(SUM(e.amount),0) AS profit
    FROM clinics c
    JOIN clinic_sales cs ON c.cid = cs.cid
    LEFT JOIN expenses e ON c.cid = e.cid 
        AND MONTH(e.datetime) = 9
    WHERE MONTH(cs.datetime) = 9
    GROUP BY c.city, c.cid
) t
WHERE t.profit = (
    SELECT MAX(profit)
    FROM (
        SELECT c.city,
               c.cid,
               SUM(cs.amount) - COALESCE(SUM(e.amount),0) AS profit
        FROM clinics c
        JOIN clinic_sales cs ON c.cid = cs.cid
        LEFT JOIN expenses e ON c.cid = e.cid 
            AND MONTH(e.datetime) = 9
        WHERE MONTH(cs.datetime) = 9
        GROUP BY c.city, c.cid
    ) x
    WHERE x.city = t.city
);

--------------------------------------------------

-- B5: Second least profitable clinic per state (month = 9)
SELECT t1.state, t1.cid, t1.profit
FROM (
    SELECT c.state,
           c.cid,
           SUM(cs.amount) - COALESCE(SUM(e.amount),0) AS profit
    FROM clinics c
    JOIN clinic_sales cs ON c.cid = cs.cid
    LEFT JOIN expenses e ON c.cid = e.cid
        AND MONTH(e.datetime) = 9
    WHERE MONTH(cs.datetime) = 9
    GROUP BY c.state, c.cid
) t1
WHERE (
    SELECT COUNT(DISTINCT t2.profit)
    FROM (
        SELECT c.state,
               c.cid,
               SUM(cs.amount) - COALESCE(SUM(e.amount),0) AS profit
        FROM clinics c
        JOIN clinic_sales cs ON c.cid = cs.cid
        LEFT JOIN expenses e ON c.cid = e.cid
            AND MONTH(e.datetime) = 9
        WHERE MONTH(cs.datetime) = 9
        GROUP BY c.state, c.cid
    ) t2
    WHERE t2.state = t1.state
      AND t2.profit < t1.profit
) = 1;
