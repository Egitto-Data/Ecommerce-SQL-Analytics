/*
Business Question:
How do revenue and orders change by month?
*/

SELECT
    DATETRUNC(MONTH, o.order_date) AS sales_month,

    SUM(oi.quantity * oi.unit_price) AS revenue,

    COUNT(DISTINCT o.order_id) AS total_orders,

    SUM(oi.quantity) AS units_sold,

    CAST(
        SUM(oi.quantity * oi.unit_price) * 1.0
        / NULLIF(COUNT(DISTINCT o.order_id), 0)
        AS DECIMAL(18,2)
    ) AS AOV

FROM dbo.orders AS o
INNER JOIN dbo.order_items AS oi
    ON oi.order_id = o.order_id

GROUP BY DATETRUNC(MONTH, o.order_date)

ORDER BY sales_month;