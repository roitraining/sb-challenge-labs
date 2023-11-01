  -- CUSTOMERS AT RISK OF CHURN AS OF 2023-10-15
  --
  -- STRATEGY
  -- 1. Join the customer, accounts, and transaction tables
  -- 2. Filter by transaction date using DATE() and DATE_SUB()
  -- 3. Group by all the customer columns
  -- 4. Filter by count of transactions using HAVING
  --
  -- Difficulty: 2/5
SELECT
  customer_id,
  COUNT(account_id) AS num_transactions
FROM
  `sb-challenge-labs.optimized.transactions`
WHERE
  DATE(transaction_datetime) >= DATE_ADD("2023-10-15", INTERVAL -90 DAY)
GROUP BY
  customer_id
HAVING
  COUNT(transaction_id) < 5