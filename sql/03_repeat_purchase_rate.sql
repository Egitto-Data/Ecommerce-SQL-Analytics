/*
Business Question:
What percentage of purchasing customers place repeat orders?
*/

WITH customer_orders AS
(
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS order_count
    FROM dbo.orders
    GROUP BY customer_id
)

SELECT
    COUNT(*) AS purchasing_customers,

    SUM(
        CASE
            WHEN order_count >= 2 THEN 1
            ELSE 0
        END
    ) AS repeat_customers,

    CAST(
        SUM(
            CASE
                WHEN order_count >= 2 THEN 1.0
                ELSE 0
            END
        ) * 100.0
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS repeat_purchase_rate_pct

FROM customer_orders;