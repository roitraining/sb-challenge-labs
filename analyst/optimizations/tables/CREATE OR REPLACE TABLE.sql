  CREATE OR REPLACE TABLE
  `optimized.transactions_denorm` AS (
  SELECT
    c.*,
    a.* except (customer_id),
    t.* except (account_id)
  FROM
    `raw.customers` c
  JOIN
    `raw.accounts` a
  ON
    c.customer_id = a.customer_id
  JOIN
    `raw.transactions` t
  ON
    t.account_id = a.account_id)

  SELECT
  customer_id,
  first_name,
  last_name,
  email,
  phone_number,
  address,
  city,
  province,
  postal_code,
  primary_branch,
  COUNT(account_id) AS num_transactions
FROM
  `sb-challenge-labs.optimized.transactions_denorm`
WHERE
  DATE(transaction_datetime) >= DATE_ADD("2023-10-15", INTERVAL -90 DAY)
GROUP BY
  customer_id,
  first_name,
  last_name,
  email,
  phone_number,
  address,
  city,
  province,
  postal_code,
  primary_branch
HAVING
  COUNT(transaction_id) < 5

    WITH
    t AS (
    SELECT
      DATE(transaction_datetime) AS transaction_date,
      customer_id
    FROM
      `sb-challenge-labs.optimized.transactions_denorm`
    WHERE
      DATE(transaction_datetime) >= DATE_ADD("2023-10-15", INTERVAL -89 day) ),
    date_customer_with_one_transaction AS (
    SELECT
      transaction_date,
      customer_id
    FROM
      t
    GROUP BY
      transaction_date,
      customer_id )
  SELECT
    DATE_ADD(transaction_date, INTERVAL i DAY) report_date,
    COUNT(DISTINCT  customer_id) unique_7day_active_customers
  FROM
    date_customer_with_one_transaction,
    UNNEST(GENERATE_ARRAY(0, 6)) i
  GROUP BY
    report_date
  HAVING
    report_date <= "2023-10-15"
  ORDER BY
    report_date DESC

  