  CREATE TEMP TABLE denorm AS (
  SELECT
    c.*,
    a.* EXCEPT (customer_id),
    t.* EXCEPT (account_id)
  FROM
    `raw.customers` c
  JOIN
    `raw.accounts` a
  ON
    c.customer_id = a.customer_id
  JOIN
    `raw.transactions` t
  ON
    t.account_id = a.account_id);
CREATE OR REPLACE TABLE
  `optimized.transaction_denorm_part_clust`
PARTITION BY
  DATE(transaction_datetime)
CLUSTER BY
  customer_id AS (
  SELECT
    *
  FROM
    denorm);