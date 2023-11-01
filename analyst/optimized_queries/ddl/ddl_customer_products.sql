CREATE OR REPLACE TABLE
  `sb-challenge-labs.optimized.customer_products` AS (
  WITH
    nested_accounts AS(
    SELECT
      c.*,
      ARRAY_AGG(STRUCT(account_id,
          account_type,
          balance )) AS accounts
    FROM
      `normalized.customers` c
    JOIN
      `normalized.accounts` a
    ON
      c.customer_id = a.customer_id
    GROUP BY
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10 ),
    nested_loans AS(
    SELECT
      c.customer_id,
      ARRAY_AGG(STRUCT(loan_id,
          employee_id,
          loan_type,
          loan_amount,
          loan_date)) AS loans
    FROM
      `normalized.customers` c
    JOIN
      `normalized.loans` a
    ON
      c.customer_id = a.customer_id
    GROUP BY
      customer_id)
  SELECT
    a.*,
    l.loans
  FROM
    nested_accounts a
  JOIN
    nested_loans l
  ON
    a.customer_id = l.customer_id)