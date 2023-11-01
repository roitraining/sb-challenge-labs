SELECT
  FORMAT_DATE('%m/%Y', loan_date) AS month_year,
  COUNT(*) AS new_loan_count,
  sum(l.loan_amount) as new_loan_total
FROM
  `sb-challenge-labs.normalized.opt_loans` l
WHERE
  loan_date >= DATE_SUB("2023-10-15", INTERVAL 12 MONTH)
GROUP BY
  month_year
ORDER BY
  month_year