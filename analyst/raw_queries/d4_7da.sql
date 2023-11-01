-- 7 DAY ACTIVE CUSTOMERS
-- Difficulty: 4/5

WITH transactions_w_customerids AS (
  SELECT
    DATE(t.transaction_datetime) AS transaction_date,
    a.customer_id
  FROM
    `raw.transactions` t
    JOIN `raw.accounts` a ON a.account_id = t.account_id
  WHERE
    DATE(t.transaction_datetime) >= DATE_ADD("2023-10-15", INTERVAL -90 day)
)

SELECT
  DATE_ADD(transaction_date, INTERVAL i DAY) sdau_window,
  COUNT(DISTINCT IF(i < 8, customer_id, null)) unique_7_day_users
FROM
  (
    SELECT
      transaction_date,
      customer_id
    FROM
      transactions_w_customerids
    GROUP BY
      transaction_date,
      customer_id
  ),
  UNNEST(GENERATE_ARRAY(1, 7)) i
GROUP BY
  sdau_window
ORDER BY
  sdau_window