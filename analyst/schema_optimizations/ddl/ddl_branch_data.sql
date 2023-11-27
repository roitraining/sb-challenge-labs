CREATE OR REPLACE TABLE
  `sb-challenge-labs.optimized.branch_data` AS (
  WITH
    nested_accounts AS(
    SELECT
      b.branch_id,
      b.branch_name,
      b.address,
      b.city,
      b.provice,
      b.postal_code,
      ARRAY_AGG(STRUCT( account_id,
          a.customer_id,
          account_type,
          balance,
          date_opened )) AS accounts
    FROM
      `normalized.customers` c
    JOIN
      `normalized.accounts` a
    ON
      c.customer_id = a.customer_id
    JOIN
      `normalized.branches` b
    ON
      b.branch_id = c.primary_branch
    GROUP BY
      b.branch_id,
      b.branch_name,
      b.address,
      b.city,
      b.provice,
      b.postal_code),
    nested_cards AS(
    SELECT
      c.primary_branch AS branch_id,
      ARRAY_AGG(STRUCT( cc.card_id,
          cc.customer_id,
          cc.card_number,
          cc.expiry_date,
          cc.cvv,
          cc.credit_limit )) AS credit_cards
    FROM
      `normalized.credit_cards` cc
    JOIN
      `normalized.customers` c
    ON
      c.customer_id = cc.customer_id
    GROUP BY
      c.primary_branch),
    nested_loans AS(
    SELECT
      e.branch_id,
      ARRAY_AGG(STRUCT( l.loan_id,
          l.customer_id,
          l.employee_id,
          l.loan_type,
          l.loan_amount,
          l.loan_date )) AS loans
    FROM
      `normalized.loans` l
    JOIN
      `sb-challenge-labs.normalized.employees` e
    ON
      e.employee_id = l.employee_id
    GROUP BY
      e.branch_id)
  SELECT
    a.*,
    l.loans,
    cc.credit_cards
  FROM
    nested_accounts a
  JOIN
    nested_loans l
  ON
    a.branch_id = l.branch_id
  JOIN
    nested_cards cc
  ON
    cc.branch_id = a.branch_id)