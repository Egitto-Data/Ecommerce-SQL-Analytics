/*
Business Question:
Which product pairs are frequently purchased together?

Support    = Pair Orders / All Orders
Confidence = Pair Orders / Orders Containing Product A
Lift       = Confidence(A -> B) / Support(B)
*/

WITH order_lines AS
(
    SELECT DISTINCT
        oi.order_id,
        p.product_id,
        p.product_name
    FROM dbo.order_items AS oi
    INNER JOIN dbo.products AS p
        ON p.product_id = oi.product_id
),
product_pairs AS
(
    SELECT
        a.product_id AS product_a_id,
        b.product_id AS product_b_id,
        a.product_name AS product_a,
        b.product_name AS product_b,

        COUNT(DISTINCT a.order_id) AS pair_order_count

    FROM order_lines AS a
    INNER JOIN order_lines AS b
        ON a.order_id = b.order_id
       AND a.product_id < b.product_id

    GROUP BY
        a.product_id,
        b.product_id,
        a.product_name,
        b.product_name
),
product_counts AS
(
    SELECT
        product_id,
        product_name,
        COUNT(DISTINCT order_id) AS product_order_count
    FROM order_lines
    GROUP BY product_id, product_name
),
total_orders AS
(
    SELECT
        COUNT(DISTINCT order_id) AS total_orders
    FROM dbo.orders
)

SELECT
    pairs.product_a,
    pairs.product_b,
    pairs.pair_order_count,

    a_counts.product_order_count AS product_a_orders,
    b_counts.product_order_count AS product_b_orders,
    totals.total_orders,

    CAST(
        pairs.pair_order_count * 100.0
        / NULLIF(totals.total_orders, 0)
        AS DECIMAL(10,2)
    ) AS support_pct,

    CAST(
        pairs.pair_order_count * 100.0
        / NULLIF(a_counts.product_order_count, 0)
        AS DECIMAL(10,2)
    ) AS confidence_a_to_b_pct,

    CAST(
        pairs.pair_order_count * 1.0 * totals.total_orders
        / NULLIF(
            a_counts.product_order_count * 1.0
            * b_counts.product_order_count,
            0
        )
        AS DECIMAL(10,2)
    ) AS lift

FROM product_pairs AS pairs
INNER JOIN product_counts AS a_counts
    ON a_counts.product_id = pairs.product_a_id
INNER JOIN product_counts AS b_counts
    ON b_counts.product_id = pairs.product_b_id
CROSS JOIN total_orders AS totals

ORDER BY lift DESC, pairs.pair_order_count DESC;