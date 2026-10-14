/*
Business Question:
Which customers generate the most revenue?
*/

SELECT
    c.customer_id,
    c.customer_name,

    COUNT(DISTINCT o.order_id) AS total_orders,

    COALESCE(
        SUM(oi.quantity * oi.unit_price),
        0
    ) AS total_revenue,

    CAST(
        COALESCE(
            SUM(oi.quantity * oi.unit_price),
            0
        ) * 1.0
        / NULLIF(COUNT(DISTINCT o.order_id), 0)
        AS DECIMAL(18,2)
    ) AS AOV

FROM dbo.customers AS c
LEFT JOIN dbo.orders AS o
    ON o.customer_id = c.customer_id
LEFT JOIN dbo.order_items AS oi
    ON oi.order_id = o.order_id

GROUP BY
    c.customer_id,
    c.customer_name

ORDER BY total_revenue DESC;