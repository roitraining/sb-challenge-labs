CREATE OR REPLACE TABLE
  optimized.loans ( 
    `loan_id` STRING NOT NULL,
    `customer_id` STRING NOT NULL,
    `employee_id` STRING NOT NULL,
    `loan_type` STRING,
    `loan_amount` NUMERIC,
    `loan_date` DATE,
    `branch_id` STRING,)
PARTITION BY loan_date AS (
  SELECT
    l.*,
    e.branch_id
  FROM
    `sb-challenge-labs.normalized.loans` l
  JOIN
    `sb-challenge-labs.normalized.employees` e
  ON
    l.employee_id = e.employee_id)