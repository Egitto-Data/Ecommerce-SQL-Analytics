/*
Business Question:
Which products generate the most revenue and estimated gross profit?
*/

SELECT
    p.product_id,
    p.product_name,
    p.category,

    SUM(oi.quantity) AS units_sold,

    SUM(
        oi.quantity * oi.unit_price
    ) AS revenue,

    SUM(
        oi.quantity * (oi.unit_price - p.cost)
    ) AS estimated_gross_profit

FROM dbo.products AS p
INNER JOIN dbo.order_items AS oi
    ON oi.product_id = p.product_id

GROUP BY
    p.product_id,
    p.product_name,
    p.category

ORDER BY revenue DESC;