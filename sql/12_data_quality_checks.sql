/*
Purpose:
Check row counts, duplicate order lines, and customers without orders.
*/

-- 1. Row counts.
SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM dbo.customers

UNION ALL

SELECT 'products', COUNT(*)
FROM dbo.products

UNION ALL

SELECT 'orders', COUNT(*)
FROM dbo.orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM dbo.order_items;


-- 2. Duplicate order/product combinations.
-- Expected result: no rows.
SELECT
    order_id,
    product_id,
    COUNT(*) AS duplicate_count
FROM dbo.order_items
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;


-- 3. Customers who have never placed an order.
SELECT
    c.customer_id,
    c.customer_name
FROM dbo.customers AS c
LEFT JOIN dbo.orders AS o
    ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;