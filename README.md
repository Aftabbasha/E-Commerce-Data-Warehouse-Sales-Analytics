# E-Commerce-Data-Warehouse-Sales-Analytics

Project Overview:-
This project implements an end-to-end e-commerce data warehouse using MySQL. The objective is to transform raw transactional CSV data into a structured star schema that enables efficient analytical queries and meaningful business insights.
The project follows real-world data warehousing best practices, including a staging layer, dimensional modeling, ETL logic, and analytics-ready fact and dimension tables.

Architecture Overview
The project is designed using a two-layer architecture:

1️.Staging Layer (staging database):-
.Acts as a raw data landing zon
.Stores CSV data exactly as received
.Used only for ingestion and transformation

2.Data Warehouse Layer (ecommerce_project database)
.Cleaned and structured data
.Optimized for analytics and reporting
.Implements a Star Schema

Data Model (Star Schema)
Fact Table
fact_sales – Stores order-item level sales transactions

Dimension Tables
customer_dim – Customer details at unique-customer level
product_dim – Product attributes
category_dim – Product category details
seller_dim – Seller information
date_dim – Calendar attributes for time-based analysis

The data warehouse enables answering key business questions such as:-

How does revenue trend monthly and yearly?
Which product categories and products generate the most revenue?
Who are the top customers by lifetime value?
What percentage of customers are repeat buyers?
Which sellers contribute most to overall sales?
How do logistics (freight costs) impact profitability?
The fact table connects to all dimensions via primary and foreign keys, enabling fast and reliable analytical queries.

