# Data Dictionary

## Project Overview

This document describes the tables, columns, data types, and relationships used in the E-commerce SQL Analytics project.

The database consists of four tables: customers, products, orders, and order_items.

## 1. Customers Table

**Table Name:** `dbo.customers`

Stores customer information.

| Column | Data Type | Description |
|---|---|---|
| customer_id | INT | Unique identifier for each customer; Primary Key |
| customer_name | VARCHAR(100) | Customer name |
| country | VARCHAR(50) | Customer's country |
| signup_date | DATE | Date the customer registered |

## 2. Products Table

**Table Name:** `dbo.products`

Stores product information.

| Column | Data Type | Description |
|---|---|---|
| product_id | INT | Unique identifier for each product; Primary Key |
| product_name | VARCHAR(100) | Product name |
| category | VARCHAR(50) | Product category |
| cost | DECIMAL(10,2) | Cost per unit |

## 3. Orders Table

**Table Name:** `dbo.orders`

Stores order-level information.

| Column | Data Type | Description |
|---|---|---|
| order_id | INT | Unique identifier for each order; Primary Key |
| customer_id | INT | Customer who placed the order; Foreign Key |
| order_date | DATE | Date the order was placed |

## 4. Order Items Table

**Table Name:** `dbo.order_items`

Stores the products included in each order.

| Column | Data Type | Description |
|---|---|---|
| order_id | INT | Order identifier; Foreign Key |
| product_id | INT | Product identifier; Foreign Key |
| quantity | INT | Number of units purchased |
| unit_price | DECIMAL(10,2) | Selling price per unit |

The composite Primary Key is `(order_id, product_id)`.

This means each product can appear only once per order in this table.

## Table Relationships

- One customer can place multiple orders.
- One order can contain multiple order items.
- One product can appear in multiple order items.

## Derived Metrics

| Metric | Calculation |
|---|---|
| Revenue | Quantity × Unit Price |
| Average Order Value (AOV) | Total Revenue ÷ Total Orders |
| Average Selling Price (ASP) | Total Revenue ÷ Units Sold |
| Units Per Transaction (UPT) | Units Sold ÷ Total Orders |
| Estimated Gross Profit | Quantity × (Unit Price − Product Cost) |

## Important Notes

- Primary Keys uniquely identify records.
- Foreign Keys maintain relationships between tables.
- The database schema defines the structure but does not include a dataset.
- Analysis queries require data to be loaded into the tables before they can produce meaningful results.