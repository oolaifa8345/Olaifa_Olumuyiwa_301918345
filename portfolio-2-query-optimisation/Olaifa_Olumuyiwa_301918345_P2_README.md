# Bank / Fintech Platform — SQL queries

## 1. Show related payment, account, customer records (up to 20).

```sql
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
```

| payment_payment_id | payment_amount | account_account_id | account_account_number | customer_customer_id | customer_email |
| --- | --- | --- | --- | --- | --- |
| 3001 | 25.75 | 2001 | ACCT-2001 | 1001 | customer1@example.test |

## 2. Find account records where customer_id matches 1001 (up to 20).

```sql
SELECT * FROM portfolio."account"
WHERE "customer_id" IS NOT DISTINCT FROM 1001
ORDER BY "account_id"
LIMIT 20;
```

| account_id | customer_id | account_number | currency | balance | status | opened_on |
| --- | --- | --- | --- | --- | --- | --- |
| 2001 | 1001 | ACCT-2001 | USD | 1250.5 | active | 2026-01-16 |

## 3. Count payment records for each account_id (up to 20 groups).

```sql
SELECT "account_id", count(*) AS record_count
FROM portfolio."payment"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;
```

| account_id | record_count |
| --- | --- |
| 2001 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.231 | 2.231, 2.25, 2.218 | Sort → Seq Scan | 274 |
| After index | 0.234 | 0.234, 0.234, 0.253 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.231 ms to 0.234 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.203..2.206 rows=50 loops=1)
  Seq Scan on payment (actual time=0.014..2.167 rows=50 loops=1)
Planning Time: 0.336 ms
Execution Time: 2.231 ms
```

### Before index, run 2

```text
Sort (actual time=2.222..2.224 rows=50 loops=1)
  Seq Scan on payment (actual time=0.013..2.186 rows=50 loops=1)
Planning Time: 0.341 ms
Execution Time: 2.25 ms
```

### Before index, run 3

```text
Sort (actual time=2.191..2.193 rows=50 loops=1)
  Seq Scan on payment (actual time=0.013..2.157 rows=50 loops=1)
Planning Time: 0.297 ms
Execution Time: 2.218 ms
```

### After index, run 1

```text
Sort (actual time=0.178..0.181 rows=50 loops=1)
  Bitmap Heap Scan on payment (actual time=0.03..0.143 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.621 ms
Execution Time: 0.234 ms
```

### After index, run 2

```text
Sort (actual time=0.176..0.179 rows=50 loops=1)
  Bitmap Heap Scan on payment (actual time=0.029..0.14 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.016 rows=50 loops=1)
Planning Time: 0.559 ms
Execution Time: 0.234 ms
```

### After index, run 3

```text
Sort (actual time=0.202..0.204 rows=50 loops=1)
  Bitmap Heap Scan on payment (actual time=0.054..0.169 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.041..0.041 rows=50 loops=1)
Planning Time: 0.486 ms
Execution Time: 0.253 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Olaifa_Olumuyiwa_301918345_P2_Queries.sql, then Olaifa_Olumuyiwa_301918345_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Olaifa_Olumuyiwa_301918345_P2_QueryResults.png) · [Index comparison](screenshots/Olaifa_Olumuyiwa_301918345_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

