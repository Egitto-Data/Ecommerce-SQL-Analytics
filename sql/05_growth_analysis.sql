/*
Business Question:
How is monthly revenue growing over time?
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
),
comparison AS
(
    SELECT
        sales_month,
        revenue,

        LAG(revenue, 1) OVER (
            ORDER BY sales_month
        ) AS previous_row_revenue,

        LAG(revenue, 12) OVER (
            ORDER BY sales_month
        ) AS previous_year_row_revenue

    FROM monthly_revenue
)

SELECT
    sales_month,
    revenue,
    previous_row_revenue,

    CAST(
        (revenue - previous_row_revenue) * 100.0
        / NULLIF(previous_row_revenue, 0)
        AS DECIMAL(10,2)
    ) AS mom_growth_pct,

    previous_year_row_revenue,

    CAST(
        (revenue - previous_year_row_revenue) * 100.0
        / NULLIF(previous_year_row_revenue, 0)
        AS DECIMAL(10,2)
    ) AS yoy_growth_pct

FROM comparison
ORDER BY sales_month;