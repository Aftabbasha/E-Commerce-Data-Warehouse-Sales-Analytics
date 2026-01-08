CREATE DATABASE IF NOT EXISTS ecommerce_project;
USE ecommerce_project;

CREATE DATABASE IF NOT EXISTS staging;
USE staging;




-- Customers staging table
CREATE TABLE IF NOT EXISTS stg_customers (
    customer_id CHAR(32),
    customer_unique_id CHAR(32),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(60),
    customer_state CHAR(2)
);
SELECT * FROM stg_customers;


-- Orders staging table
CREATE TABLE IF NOT EXISTS stg_orders (
    order_id CHAR(32),
    customer_id CHAR(32),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);
SELECT * FROM stg_orders;


-- Order items staging table
CREATE TABLE IF NOT EXISTS stg_order_items (
    order_id CHAR(32),
    order_item_id INT,
    product_id CHAR(32),
    seller_id CHAR(32),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);
SELECT * FROM stg_order_items;


-- Order payments staging table
CREATE TABLE IF NOT EXISTS stg_order_payments (
    order_id CHAR(32),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);
SELECT * FROM stg_order_payments;


-- Order reviews staging table
CREATE TABLE IF NOT EXISTS stg_order_reviews (
    review_id CHAR(32),
    order_id CHAR(32),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);
SELECT * FROM stg_order_reviews;


-- Products staging table
CREATE TABLE IF NOT EXISTS stg_products (
    product_id CHAR(32),
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);
SELECT * FROM stg_products;


-- Sellers staging table
CREATE TABLE IF NOT EXISTS stg_sellers (
    seller_id CHAR(32),
    seller_zip_code_prefix INT,
    seller_city VARCHAR(60),
    seller_state CHAR(2)
);
SELECT * FROM stg_sellers;


-- Geolocation staging table
CREATE TABLE IF NOT EXISTS stg_geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(9,6),
    geolocation_lng DECIMAL(9,6),
    geolocation_city VARCHAR(60),
    geolocation_state CHAR(2)
);
SELECT * FROM stg_geolocation;


-- Category translation staging table
CREATE TABLE IF NOT EXISTS stg_category_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);
SELECT * FROM stg_category_translation;





-- Loading data into staging tables
-- Customers Table
LOAD DATA LOCAL INFILE'F:/Innomatics/MySQL/Unique Project/Dataset/customers_dataset.csv'
INTO TABLE stg_customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Orders Table
LOAD DATA LOCAL INFILE 'F:/Innomatics/MySQL/Unique Project/Dataset/orders_dataset.csv'
INTO TABLE stg_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Order items Table
LOAD DATA LOCAL INFILE 'F:/Innomatics/MySQL/Unique Project/Dataset/order_items_dataset.csv'
INTO TABLE stg_order_items
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Order payments Table
LOAD DATA LOCAL INFILE 'F:/Innomatics/MySQL/Unique Project/Dataset/order_payments_dataset.csv'
INTO TABLE stg_order_payments
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- Order Reviews Table
LOAD DATA LOCAL INFILE 'F:/Innomatics/MySQL/Unique Project/Dataset/order_reviews_dataset.csv'
INTO TABLE stg_order_reviews
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Products Table
LOAD DATA LOCAL INFILE 'F:/Innomatics/MySQL/Unique Project/Dataset/products_dataset.csv'
INTO TABLE stg_products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Sellers Table
LOAD DATA LOCAL INFILE 'F:/Innomatics/MySQL/Unique Project/Dataset/sellers_dataset.csv'
INTO TABLE stg_sellers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Geolocation Table
LOAD DATA LOCAL INFILE 'F:/Innomatics/MySQL/Unique Project/Dataset/geolocation_dataset.csv'
INTO TABLE staging.stg_geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Product Category name Translation Table
LOAD DATA LOCAL INFILE 'F:/Innomatics/MySQL/Unique Project/Dataset/product_category_name_translation.csv'
INTO TABLE stg_category_translation
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;




-- Creating Dimension tables in ecommerce_project database.
USE ecommerce_project;

-- Customer dimension
CREATE TABLE IF NOT EXISTS customer_dim (
    customer_unique_id CHAR(32) PRIMARY KEY,
    customer_zip_code_prefix INT,
    customer_city VARCHAR(60),
    customer_state CHAR(2)
);

-- Seller dimension
CREATE TABLE IF NOT EXISTS seller_dim (
    seller_id CHAR(32) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(60),
    seller_state CHAR(2)
);

-- Category dimension
CREATE TABLE IF NOT EXISTS category_dim (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100),
    category_name_english VARCHAR(100)
);

-- Product dimension
CREATE TABLE IF NOT EXISTS product_dim (
    product_id CHAR(32) PRIMARY KEY,
    category_id INT,
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT,
    FOREIGN KEY (category_id) REFERENCES category_dim(category_id)
);

-- Date dimension
CREATE TABLE IF NOT EXISTS date_dim (
    date_id DATE PRIMARY KEY,
    day INT,
    month INT,
    year INT,
    quarter INT,
    day_of_week VARCHAR(10)
);

-- Fact Tabale
CREATE TABLE IF NOT EXISTS fact_sales (
    order_id CHAR(32),
    order_item_id INT,
    date_id DATE,
    customer_unique_id CHAR(32),
    product_id CHAR(32),
    seller_id CHAR(32),
    category_id INT,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),

    PRIMARY KEY (order_id, order_item_id),

    FOREIGN KEY (date_id) REFERENCES date_dim(date_id),
    FOREIGN KEY (customer_unique_id) REFERENCES customer_dim(customer_unique_id),
    FOREIGN KEY (product_id) REFERENCES product_dim(product_id),
    FOREIGN KEY (seller_id) REFERENCES seller_dim(seller_id),
    FOREIGN KEY (category_id) REFERENCES category_dim(category_id)
);



-- Customer dimension population
INSERT INTO customer_dim (
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
)
SELECT
    customer_unique_id,
    MIN(customer_zip_code_prefix) AS customer_zip_code_prefix,
    MIN(customer_city) AS customer_city,
    MIN(customer_state) AS customer_state
FROM staging.stg_customers
WHERE customer_unique_id IS NOT NULL
GROUP BY customer_unique_id;

-- Seller dimension population
INSERT INTO seller_dim (seller_id, seller_zip_code_prefix, seller_city, seller_state)
SELECT DISTINCT seller_id, seller_zip_code_prefix, seller_city, seller_state
FROM staging.stg_sellers;

-- Category dimension population
INSERT INTO category_dim (category_name, category_name_english)
SELECT DISTINCT product_category_name, product_category_name_english
FROM staging.stg_category_translation;

-- Product dimension population
INSERT INTO product_dim (
    product_id,
    category_id,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT
    p.product_id,
    MIN(c.category_id) AS category_id,
    MAX(p.product_name_lenght) AS product_name_length,
    MAX(p.product_description_lenght) AS product_description_length,
    MAX(p.product_photos_qty) AS product_photos_qty,
    MAX(p.product_weight_g) AS product_weight_g,
    MAX(p.product_length_cm) AS product_length_cm,
    MAX(p.product_height_cm) AS product_height_cm,
    MAX(p.product_width_cm) AS product_width_cm
FROM staging.stg_products p
LEFT JOIN category_dim c
    ON p.product_category_name = c.category_name
GROUP BY p.product_id;

-- Date dimension population (from order purchase dates)
INSERT INTO date_dim (date_id, day, month, year, quarter, day_of_week)
SELECT DISTINCT
    DATE(order_purchase_timestamp) AS date_id,
    DAY(order_purchase_timestamp) AS day,
    MONTH(order_purchase_timestamp) AS month,
    YEAR(order_purchase_timestamp) AS year,
    QUARTER(order_purchase_timestamp) AS quarter,
    DAYNAME(order_purchase_timestamp) AS day_of_week
FROM staging.stg_orders;

-- Fact Sales Population
INSERT INTO fact_sales (
    order_id,
    order_item_id,
    date_id,
    customer_unique_id,
    product_id,
    seller_id,
    category_id,
    price,
    freight_value
)
SELECT DISTINCT
    oi.order_id,
    oi.order_item_id,
    DATE(o.order_purchase_timestamp) AS date_id,
    cd.customer_unique_id,
    oi.product_id,
    oi.seller_id,
    pd.category_id,
    oi.price,
    oi.freight_value
FROM staging.stg_order_items oi
JOIN staging.stg_orders o
  ON oi.order_id = o.order_id
JOIN staging.stg_customers c
  ON o.customer_id = c.customer_id
JOIN customer_dim cd
  ON c.customer_unique_id = cd.customer_unique_id
JOIN product_dim pd
  ON oi.product_id = pd.product_id
WHERE o.order_purchase_timestamp IS NOT NULL;



-- Business Problems

-- 1. What is the monthly revenue trend across all years?
SELECT
    d.year,
    d.month,
    SUM(f.price + f.freight_value) AS monthly_revenue
FROM fact_sales f
JOIN date_dim d ON f.date_id = d.date_id
GROUP BY d.year, d.month
ORDER BY d.year, d.month;

-- 2. Which product categories contribute the most to total revenue?
SELECT
    c.category_name_english,
    SUM(f.price) AS total_revenue
FROM fact_sales f
JOIN category_dim c ON f.category_id = c.category_id
GROUP BY c.category_name_english
ORDER BY total_revenue DESC;

-- 3. Who are the top 10 customers by lifetime value?
SELECT
    customer_unique_id,
    SUM(price + freight_value) AS lifetime_value
FROM fact_sales
GROUP BY customer_unique_id
ORDER BY lifetime_value DESC
LIMIT 10;

-- 4. What percentage of customers are repeat buyers?
SELECT
    ROUND(
        SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS repeat_customer_percentage
FROM (
    SELECT customer_unique_id, COUNT(DISTINCT order_id) AS order_count
    FROM fact_sales
    GROUP BY customer_unique_id
) t;
 
-- 5. Which sellers generate the highest revenue?
SELECT
    seller_id,
    SUM(price) AS seller_revenue
FROM fact_sales
GROUP BY seller_id
ORDER BY seller_revenue DESC
LIMIT 10;
 
-- 6. Which categories have the highest logistics cost relative to sales?
SELECT
    c.category_name_english,
    ROUND(SUM(f.freight_value) / SUM(f.price), 2) AS freight_to_sales_ratio
FROM fact_sales f
JOIN category_dim c ON f.category_id = c.category_id
GROUP BY c.category_name_english
ORDER BY freight_to_sales_ratio DESC;
 
-- 7. On which day of the week are the most orders placed?
SELECT
    d.day_of_week,
    COUNT(DISTINCT f.order_id) AS total_orders
FROM fact_sales f
JOIN date_dim d ON f.date_id = d.date_id
GROUP BY d.day_of_week
ORDER BY total_orders DESC;
 
-- 8. What is the average order value (AOV)?
SELECT
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM (
    SELECT
        order_id,
        SUM(price + freight_value) AS order_total
    FROM fact_sales
    GROUP BY order_id
) t;

-- 9. Which products generate high freight cost but low revenue?
SELECT
    product_id,
    SUM(price) AS product_revenue,
    SUM(freight_value) AS freight_cost
FROM fact_sales
GROUP BY product_id
HAVING freight_cost > product_revenue
ORDER BY freight_cost DESC;

-- 10. How does yearly revenue change over time?
SELECT
    d.year,
    SUM(f.price + f.freight_value) AS yearly_revenue
FROM fact_sales f
JOIN date_dim d ON f.date_id = d.date_id
GROUP BY d.year
ORDER BY d.year;