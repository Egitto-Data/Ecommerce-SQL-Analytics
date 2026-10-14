/*
Business Question:
Which purchasing customers are Champions, Loyal, or At Risk?

RFM:
R = Recency
F = Frequency
M = Monetary Value
*/

WITH customer_rfm AS
(
    SELECT
        c.customer_id,
        c.customer_name,

        DATEDIFF(
            DAY,
            MAX(o.order_date),
            CAST(GETDATE() AS DATE)
        ) AS recency_days,

        COUNT(DISTINCT o.order_id) AS frequency,

        SUM(oi.quantity * oi.unit_price) AS monetary

    FROM dbo.customers AS c
    INNER JOIN dbo.orders AS o
        ON o.customer_id = c.customer_id
    INNER JOIN dbo.order_items AS oi
        ON oi.order_id = o.order_id

    GROUP BY c.customer_id, c.customer_name
),
rfm_scores AS
(
    SELECT
        *,

        NTILE(5) OVER (
            ORDER BY recency_days DESC
        ) AS r_score,

        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS f_score,

        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS m_score

    FROM customer_rfm
)

SELECT
    customer_id,
    customer_name,
    recency_days,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,

    CASE
        WHEN r_score >= 4
         AND f_score >= 4
         AND m_score >= 4
            THEN 'Champions'

        WHEN r_score >= 3
         AND f_score >= 4
            THEN 'Loyal Customers'

        WHEN r_score <= 2
         AND f_score >= 3
            THEN 'At Risk'

        ELSE 'Other Customers'
    END AS customer_segment

FROM rfm_scores
ORDER BY r_score DESC, f_score DESC, m_score DESC;