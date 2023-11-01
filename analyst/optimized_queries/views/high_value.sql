WITH
  totals AS(
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
    SUM(loan.loan_amount) AS total_loan_amount,
    SUM(account.balance) AS total_account_balance
  FROM
    `optimized.customer_products`,
    UNNEST(loans) AS loan,
    UNNEST(accounts) AS account
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
    primary_branch)
SELECT
  *,
  ROUND( 1 -( PERCENT_RANK() OVER (ORDER BY total_loan_amount DESC ) + PERCENT_RANK() OVER (ORDER BY total_account_balance DESC ) ) / 2, 2 ) * 100 AS value_rank
FROM
  totals
ORDER BY
  value_rank desc