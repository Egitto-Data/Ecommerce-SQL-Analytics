/*
Business Question:
How can customers be grouped by their revenue contribution?
*/

WITH customer_revenue AS
(
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM dbo.customers AS c
    INNER JOIN dbo.orders AS o
        ON o.customer_id = c.customer_id
    INNER JOIN dbo.order_items AS oi
        ON oi.order_id = o.order_id
    GROUP BY c.customer_id, c.customer_name
),
ranked_customers AS
(
    SELECT
        *,
        NTILE(3) OVER (
            ORDER BY revenue DESC
        ) AS revenue_group
    FROM customer_revenue
)

SELECT
    customer_id,
    customer_name,
    revenue,

    CASE revenue_group
        WHEN 1 THEN 'High Revenue'
        WHEN 2 THEN 'Mid Revenue'
        WHEN 3 THEN 'Low Revenue'
    END AS customer_segment

FROM ranked_customers
ORDER BY revenue DESC;