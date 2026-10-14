/*
Business Question:
What is cumulative revenue, and how does the
three-row moving average behave?
*/

WITH monthly_revenue AS
(
    SELECT
        DATETRUNC(MONTH, o.order_date) AS sales_month,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM dbo.orders AS o
    INNER JOIN dbo.order_items AS oi
        ON oi.order_id = o.order_id
    GROUP BY DATETRUNC(MONTH, o.order_date)
)

SELECT
    sales_month,
    revenue,

    SUM(revenue) OVER (
        ORDER BY sales_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue,

    CAST(
        AVG(revenue * 1.0) OVER (
            ORDER BY sales_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        )
        AS DECIMAL(18,2)
    ) AS moving_average_3_rows

FROM monthly_revenue
ORDER BY sales_month;