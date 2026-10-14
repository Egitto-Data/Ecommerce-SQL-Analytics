/*
Business Question:
How long has each customer's observed purchasing activity spanned?
This is historical activity span, not predictive CLV.
*/

SELECT
    c.customer_id,
    c.customer_name,

    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date,

    DATEDIFF(
        MONTH,
        MIN(o.order_date),
        MAX(o.order_date)
    ) AS lifetime_months,

    COUNT(DISTINCT o.order_id) AS total_orders,

    CAST(
        COUNT(DISTINCT o.order_id) * 1.0
        / NULLIF(
            DATEDIFF(
                MONTH,
                MIN(o.order_date),
                MAX(o.order_date)
            ) + 1,
            0
        )
        AS DECIMAL(10,2)
    ) AS orders_per_observed_month

FROM dbo.customers AS c
INNER JOIN dbo.orders AS o
    ON o.customer_id = c.customer_id

GROUP BY c.customer_id, c.customer_name

ORDER BY lifetime_months DESC;