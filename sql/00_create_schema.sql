/*
Project: E-commerce Analytics
Purpose: Create the database tables and relationships.
*/

CREATE TABLE dbo.customers
(
    customer_id   INT PRIMARY KEY,
    customer_name VARCHAR(100),
    country       VARCHAR(50),
    signup_date   DATE
);

CREATE TABLE dbo.products
(
    product_id   INT PRIMARY KEY,
    product_name VARCHAR(100),
    category     VARCHAR(50),
    cost         DECIMAL(10,2)
);

CREATE TABLE dbo.orders
(
    order_id    INT PRIMARY KEY,
    customer_id INT,
    order_date  DATE,
    FOREIGN KEY (customer_id)
        REFERENCES dbo.customers(customer_id)
);

CREATE TABLE dbo.order_items
(
    order_id   INT,
    product_id INT,
    quantity   INT,
    unit_price DECIMAL(10,2),

    PRIMARY KEY (order_id, product_id),

    FOREIGN KEY (order_id)
        REFERENCES dbo.orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES dbo.products(product_id)
);