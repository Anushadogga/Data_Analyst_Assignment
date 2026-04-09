-- Q1: Last booked room per user
SELECT b.user_id, b.room_no
FROM bookings b
JOIN (
    SELECT user_id, MAX(booking_date) AS last_date
    FROM bookings
    GROUP BY user_id
) t
ON b.user_id = t.user_id 
AND b.booking_date = t.last_date;

--------------------------------------------------

-- Q2: Booking ID & total billing in November 2021
SELECT bc.booking_id,
       SUM(bc.item_quantity * i.item_rate) AS total_bill
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
JOIN bookings b ON bc.booking_id = b.booking_id
WHERE MONTH(b.booking_date) = 11
  AND YEAR(b.booking_date) = 2021
GROUP BY bc.booking_id;

--------------------------------------------------

-- Q3: Bills in October 2021 with amount > 1000
SELECT bc.bill_id,
       SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date) = 10
  AND YEAR(bc.bill_date) = 2021
GROUP BY bc.bill_id
HAVING bill_amount > 1000;

--------------------------------------------------

-- Q4: Most ordered item per month (2021)
SELECT t.month, t.item_id, t.total_qty
FROM (
    SELECT MONTH(bill_date) AS month,
           item_id,
           SUM(item_quantity) AS total_qty
    FROM booking_commercials
    WHERE YEAR(bill_date) = 2021
    GROUP BY MONTH(bill_date), item_id
) t
WHERE total_qty = (
    SELECT MAX(total_qty)
    FROM (
        SELECT MONTH(bill_date) AS m,
               item_id,
               SUM(item_quantity) AS total_qty
        FROM booking_commercials
        WHERE YEAR(bill_date) = 2021
        GROUP BY MONTH(bill_date), item_id
    ) x
    WHERE x.m = t.month
);

--------------------------------------------------

-- Q4: Least ordered item per month (2021)
SELECT t.month, t.item_id, t.total_qty
FROM (
    SELECT MONTH(bill_date) AS month,
           item_id,
           SUM(item_quantity) AS total_qty
    FROM booking_commercials
    WHERE YEAR(bill_date) = 2021
    GROUP BY MONTH(bill_date), item_id
) t
WHERE total_qty = (
    SELECT MIN(total_qty)
    FROM (
        SELECT MONTH(bill_date) AS m,
               item_id,
               SUM(item_quantity) AS total_qty
        FROM booking_commercials
        WHERE YEAR(bill_date) = 2021
        GROUP BY MONTH(bill_date), item_id
    ) x
    WHERE x.m = t.month
);

--------------------------------------------------

-- Q5: Customers with 2nd highest bill per month
SELECT t1.month, t1.user_id, t1.total_bill
FROM (
    SELECT MONTH(bc.bill_date) AS month,
           b.user_id,
           SUM(bc.item_quantity * i.item_rate) AS total_bill
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    JOIN bookings b ON bc.booking_id = b.booking_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), b.user_id
) t1
WHERE (
    SELECT COUNT(DISTINCT t2.total_bill)
    FROM (
        SELECT MONTH(bc.bill_date) AS month,
               b.user_id,
               SUM(bc.item_quantity * i.item_rate) AS total_bill
        FROM booking_commercials bc
        JOIN items i ON bc.item_id = i.item_id
        JOIN bookings b ON bc.booking_id = b.booking_id
        WHERE YEAR(bc.bill_date) = 2021
        GROUP BY MONTH(bc.bill_date), b.user_id
    ) t2
    WHERE t2.month = t1.month
      AND t2.total_bill > t1.total_bill
) = 1;
