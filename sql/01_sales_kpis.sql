/*
Business Question:
What are the overall sales KPIs?
*/

SELECT
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS total_units_sold,
    COUNT(DISTINCT oi.product_id) AS distinct_products_sold,

    CAST(
        SUM(oi.quantity * oi.unit_price) * 1.0
        / NULLIF(COUNT(DISTINCT o.order_id), 0)
        AS DECIMAL(18,2)
    ) AS AOV,

    CAST(
        SUM(oi.quantity * oi.unit_price) * 1.0
        / NULLIF(SUM(oi.quantity), 0)
        AS DECIMAL(18,2)
    ) AS ASP,

    CAST(
        SUM(oi.quantity) * 1.0
        / NULLIF(COUNT(DISTINCT o.order_id), 0)
        AS DECIMAL(18,2)
    ) AS UPT

FROM dbo.orders AS o
INNER JOIN dbo.order_items AS oi
    ON oi.order_id = o.order_id;