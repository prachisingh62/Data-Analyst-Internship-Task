/*Monthly Performance*/

CREATE TABLE orders (
    row_id INT,
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code INT,
    region VARCHAR(50),
    product_id VARCHAR(30),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales NUMERIC(10,2),
    quantity INT,
    discount NUMERIC(5,2),
    profit NUMERIC(10,2)
);

DROP TABLE orders;

SELECT*FROM orders LIMIT 5;

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'orders';
SELECT COUNT(*)
FROM information_schema.columns
WHERE table_name = 'orders';

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'orders'
ORDER BY ordinal_position;

SELECT COUNT(*) FROM orders;

/*monthly performance*/

SELECT
EXTRACT(YEAR FROM order_date) AS Year,
EXTRACT(MONTH FROM order_date) AS Month,
SUM(sales) AS Monthly_Sales,
SUM(profit) AS Monthly_Profit
FROM orders
GROUP BY
EXTRACT(YEAR FROM order_date),
EXTRACT(MONTH FROM order_date)
ORDER BY Year, Month;

/*Growth Rate Calculation (Subquery)*/

SELECT
    t1.month,
    t1.monthly_sales,
    t2.monthly_sales AS previous_month_sales,
    ((t1.monthly_sales - t2.monthly_sales) * 100.0 / t2.monthly_sales) AS growth_percentage
FROM
(
    SELECT
        EXTRACT(MONTH FROM order_date) AS month,
        SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY EXTRACT(MONTH FROM order_date)
) t1
JOIN
(
    SELECT
        EXTRACT(MONTH FROM order_date) AS month,
        SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY EXTRACT(MONTH FROM order_date)
) t2
ON t1.month = t2.month + 1;

/*CASE Statement*/

SELECT
order_id,
sales,
CASE
WHEN sales>1000 THEN 'High Value'
WHEN sales BETWEEN 500 AND 1000 THEN 'Medium Value'
ELSE 'Low Value'
END AS order_type
FROM orders;

/*Underperforming Region*/

SELECT
region,
SUM(profit) AS total_profit
FROM orders
GROUP BY region
HAVING SUM(profit)<1000;

