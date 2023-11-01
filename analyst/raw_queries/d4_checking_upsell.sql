-- CHECKING UPSELL
--
-- STRATEGY
-- 1. Get a table with one row per customer/account
-- 2. Filter by customers with only savings accounts
--
-- Difficulty: 4/5

WITH

  customers_accounts AS (

  -- join customers and accounts tables
  -- group by customer_id
  -- project customer_id and array of account types
  SELECT
    c.customer_id,
    ARRAY_AGG(account_type) AS accts
  FROM
    normalized.customers c
  JOIN
    normalized.accounts a
  ON
    c.customer_id = a.customer_id
  GROUP BY
    customer_id),

  savings_only AS (

  -- query the customer_accounts intermediate table
  -- filter by customers that have an array of length 1
  -- filter by customers where first array element is "Savings"
  -- project customer_id
  SELECT
    customer_id
  FROM
    customers_accounts
  WHERE
    ARRAY_LENGTH(accts) = 1
    AND accts[ORDINAL(1)] = "Savings"),

  transactions_accounts AS (

  -- join the accounts and transactions tables
  -- filter by transactions in the last 180 days
  -- filter by account_type = "Savings"
  -- group by account_id, customer_id, and account_type
  -- project customer_id and num_transactions
  SELECT
    COUNT(transaction_id) AS num_transactions,
    customer_id,
  FROM
    normalized.accounts a
  JOIN
    normalized.transactions t
  ON
    a.account_id = t.account_id
  where
    DATE(t.transaction_datetime) >= DATE_ADD("2023-10-15", INTERVAL -180 DAY)
    and account_type = "Savings"
  GROUP BY
    customer_id
  ),

percentiles AS (

-- use PERCENT_RANK() window function to get percentile for each customer
-- project customer_id, num_transactions, and percentile
SELECT
  customer_id,
  num_transactions,
  PERCENT_RANK() OVER (ORDER BY num_transactions DESC) AS percentile
FROM
  transactions_accounts),

top_20 AS (
  -- filter percentile table for percentile > 0.8
  -- project customer_id, num_transactions, and percentile
  SELECT
    *
  FROM
    percentiles
  WHERE
    percentile > 0.8
)

-- join savings_only and top_20 tables
-- project customer_id, num_transactions, and percentile
SELECT
  s.customer_id,
  num_transactions,
  percentile
FROM
  savings_only s
JOIN
  top_20 t
ON
  s.customer_id = t.customer_id