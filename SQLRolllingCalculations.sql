USE sakila;
SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month, COUNT(DISTINCT customer_id) AS active_customers
FROM payment
GROUP BY month; -- Get number of monthly active customers.
SELECT 
    month,
    active_customers,
    LAG(active_customers) OVER (ORDER BY month) AS active_customers_previous_month
FROM (
    SELECT 
        DATE_FORMAT(p.payment_date, '%Y-%m') AS month,
        COUNT(DISTINCT c.customer_id) AS active_customers
    FROM payment p
    JOIN customer c ON p.customer_id = c.customer_id
    JOIN rental r ON c.customer_id = r.customer_id
    WHERE DATE_FORMAT(p.payment_date, '%Y-%m') = DATE_FORMAT(r.rental_date, '%Y-%m')
    GROUP BY month
) AS subquery; -- Active users in the previous month.
SELECT 
    month,
    active_customers,
    LAG(active_customers) OVER (ORDER BY month) AS active_customers_previous_month,
    ROUND(((active_customers - LAG(active_customers) OVER (ORDER BY month)) / LAG(active_customers) OVER (ORDER BY month)) * 100, 2) AS percentage_change
FROM (
    SELECT 
        DATE_FORMAT(p.payment_date, '%Y-%m') AS month,
        COUNT(DISTINCT c.customer_id) AS active_customers
    FROM payment p
    JOIN customer c ON p.customer_id = c.customer_id
    JOIN rental r ON c.customer_id = r.customer_id
    WHERE DATE_FORMAT(p.payment_date, '%Y-%m') = DATE_FORMAT(r.rental_date, '%Y-%m')
    GROUP BY month
) AS subquery; -- Percentage change in the number of active customers.



