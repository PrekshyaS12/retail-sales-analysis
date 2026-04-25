
CREATE TABLE superstore (
    row_id INT,
    order_id VARCHAR(20),
    order_date VARCHAR(20),
    ship_date VARCHAR(20),
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(20),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales NUMERIC(10,2),
    quantity INT,
    discount NUMERIC(4,2),
    profit NUMERIC(10,2)
);

SELECT COUNT(*) FROM superstore;


-- Query 1: Total revenue by product category
SELECT 
    category,
    SUM(sales) AS total_revenue
FROM superstore
GROUP BY category
ORDER BY total_revenue DESC;

-- Query 2: Top 10 customers by total spend
SELECT 
    customer_name, 
    SUM(sales) AS total_spent
FROM superstore
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 10;

-- Query 3: Monthly sales trend
SELECT 
    EXTRACT(YEAR FROM order_date::DATE) AS year,
    EXTRACT(MONTH FROM order_date::DATE) AS month,
    SUM(sales) AS monthly_sales
FROM superstore
GROUP BY 
    EXTRACT(YEAR FROM order_date::DATE),
    EXTRACT(MONTH FROM order_date::DATE)
ORDER BY year, month;

-- Query 4: Running total of sales
SELECT 
    order_date,
    sales,
    SUM(sales) OVER (ORDER BY order_date::DATE) AS running_total
FROM superstore
ORDER BY order_date::DATE;

-- Query 5: Profit by region
SELECT 
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY region
ORDER BY total_profit DESC;

-- Query 6: Months where sales dropped vs previous month
WITH monthly AS (
    SELECT 
        EXTRACT(YEAR FROM order_date::DATE) AS year,
        EXTRACT(MONTH FROM order_date::DATE) AS month,
        SUM(sales) AS monthly_sales
    FROM superstore
    GROUP BY 
        EXTRACT(YEAR FROM order_date::DATE),
        EXTRACT(MONTH FROM order_date::DATE)
),
with_lag AS (
    SELECT 
        year,
        month,
        monthly_sales,
        LAG(monthly_sales) OVER (ORDER BY year, month) AS prev_month_sales
    FROM monthly
)
SELECT 
    year,
    month,
    monthly_sales,
    prev_month_sales,
    monthly_sales - prev_month_sales AS difference
FROM with_lag
WHERE monthly_sales < prev_month_sales
ORDER BY year, month;