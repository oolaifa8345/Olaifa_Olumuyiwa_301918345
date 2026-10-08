-- Show related payment, account, customer records (up to 20).
SELECT t0."payment_id" AS "payment_payment_id",
       t0."amount" AS "payment_amount",
       t1."account_id" AS "account_account_id",
       t1."account_number" AS "account_account_number",
       t2."customer_id" AS "customer_customer_id",
       t2."email" AS "customer_email"
FROM portfolio."payment" t0
JOIN portfolio."account" t1 ON t0."account_id" = t1."account_id"
JOIN portfolio."customer" t2 ON t1."customer_id" = t2."customer_id"
ORDER BY t0."payment_id", t1."account_id", t2."customer_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."payment_id" AS "payment_payment_id",
       t0."amount" AS "payment_amount",
       t1."account_id" AS "account_account_id",
       t1."account_number" AS "account_account_number",
       t2."customer_id" AS "customer_customer_id",
       t2."email" AS "customer_email"
FROM portfolio."payment" t0
JOIN portfolio."account" t1 ON t0."account_id" = t1."account_id"
JOIN portfolio."customer" t2 ON t1."customer_id" = t2."customer_id"
ORDER BY t0."payment_id", t1."account_id", t2."customer_id"
LIMIT 20;

-- Find account records where customer_id matches 1001 (up to 20).
SELECT * FROM portfolio."account"
WHERE "customer_id" IS NOT DISTINCT FROM 1001
ORDER BY "account_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."account"
WHERE "customer_id" IS NOT DISTINCT FROM 1001
ORDER BY "account_id"
LIMIT 20;

-- Count payment records for each account_id (up to 20 groups).
SELECT "account_id", count(*) AS record_count
FROM portfolio."payment"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "account_id", count(*) AS record_count
FROM portfolio."payment"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;
