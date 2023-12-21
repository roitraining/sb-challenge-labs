WITH
  stats AS (
  SELECT
    branch_id,
    ARRAY_LENGTH(accounts) AS num_accounts,
    ARRAY_LENGTH(loans) AS num_loans,
    ARRAY_LENGTH(credit_cards) AS num_credit_cards,
    (
    SELECT
      SUM(balance)
    FROM
      UNNEST(accounts)) AS total_deposits,
    (
    SELECT
      SUM(loan_amount)
    FROM
      UNNEST(loans)) AS total_loan_amount
  FROM
    `sb-challenge-labs.optimized.branch_data` ),
  rankings AS (
  SELECT
    stats.*,
    RANK() OVER (ORDER BY num_accounts DESC ) AS num_account_rank,
    RANK() OVER (ORDER BY total_deposits DESC ) AS total_deposits_rank,
    RANK() OVER (ORDER BY num_loans DESC ) AS num_loans_rank,
    RANK() OVER (ORDER BY total_loan_amount DESC ) AS total_loan_amount_rank,
    RANK() OVER (ORDER BY num_credit_cards DESC ) AS num_credit_cards_rank
  FROM
    stats)
SELECT
  *
FROM
  rankings