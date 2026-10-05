-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. customer pk violation. Expected: pk_customer, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "email", "created_at")
VALUES (1001, 'different-customer@example.test', '2026-03-01T00:00:00Z');

-- 2. customer email violation. Expected: uq_customer_0, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "email", "created_at")
VALUES (9001, 'customer1@example.test', '2026-03-01T00:00:00Z');

-- 3. customer id not null. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "email", "created_at")
VALUES (NULL, 'fresh-customer@example.test', '2026-03-01T00:00:00Z');

-- 4. customer email not null. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "email", "created_at")
VALUES (9002, NULL, '2026-03-01T00:00:00Z');

-- 5. customer created at not null. Expected: created_at, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "email", "created_at")
VALUES (9003, 'fresh-created@example.test', NULL);

-- 6. account pk violation. Expected: pk_account, SQLSTATE 23505.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "status", "opened_on")
VALUES (2001, 1001, 'ACCT-FRESH-1', 'USD', 10, 'active', '2026-03-01');

-- 7. account number violation. Expected: uq_account_0, SQLSTATE 23505.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "status", "opened_on")
VALUES (9004, 1001, 'ACCT-2001', 'USD', 10, 'active', '2026-03-01');

-- 8. account customer fk violation. Expected: fk_account_0, SQLSTATE 23503.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "status", "opened_on")
VALUES (9005, 999999, 'ACCT-FRESH-2', 'USD', 10, 'active', '2026-03-01');

-- 9. account id not null. Expected: account_id, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "status", "opened_on")
VALUES (NULL, 1001, 'ACCT-FRESH-3', 'USD', 10, 'active', '2026-03-01');

-- 10. account customer id not null. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "status", "opened_on")
VALUES (9006, NULL, 'ACCT-FRESH-4', 'USD', 10, 'active', '2026-03-01');

-- 11. account number not null. Expected: account_number, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "status", "opened_on")
VALUES (9007, 1001, NULL, 'USD', 10, 'active', '2026-03-01');

-- 12. account currency not null. Expected: currency, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "status", "opened_on")
VALUES (9008, 1001, 'ACCT-FRESH-5', NULL, 10, 'active', '2026-03-01');

-- 13. account balance not null. Expected: balance, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "status", "opened_on")
VALUES (9009, 1001, 'ACCT-FRESH-6', 'USD', NULL, 'active', '2026-03-01');

-- 14. account status not null. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "status", "opened_on")
VALUES (9010, 1001, 'ACCT-FRESH-7', 'USD', 10, NULL, '2026-03-01');

-- 15. account opened on not null. Expected: opened_on, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "status", "opened_on")
VALUES (9011, 1001, 'ACCT-FRESH-8', 'USD', 10, 'active', NULL);

-- 16. payment pk violation. Expected: pk_payment, SQLSTATE 23505.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "amount", "status", "initiated_at", "reference", "settled_at")
VALUES (3001, 2001, 5, 'initiated', '2026-03-01T00:00:00Z', 'PAY-FRESH-1', NULL);

-- 17. payment account fk violation. Expected: fk_payment_0, SQLSTATE 23503.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "amount", "status", "initiated_at", "reference", "settled_at")
VALUES (9013, 999999, 5, 'initiated', '2026-03-01T00:00:00Z', 'PAY-FRESH-2', NULL);

-- 18. payment id not null. Expected: payment_id, SQLSTATE 23502.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "amount", "status", "initiated_at", "reference", "settled_at")
VALUES (NULL, 2001, 5, 'initiated', '2026-03-01T00:00:00Z', 'PAY-FRESH-3', NULL);

-- 19. payment account id not null. Expected: account_id, SQLSTATE 23502.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "amount", "status", "initiated_at", "reference", "settled_at")
VALUES (9014, NULL, 5, 'initiated', '2026-03-01T00:00:00Z', 'PAY-FRESH-4', NULL);

-- 20. payment amount not null. Expected: amount, SQLSTATE 23502.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "amount", "status", "initiated_at", "reference", "settled_at")
VALUES (9015, 2001, NULL, 'initiated', '2026-03-01T00:00:00Z', 'PAY-FRESH-5', NULL);

-- 21. payment status not null. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "amount", "status", "initiated_at", "reference", "settled_at")
VALUES (9016, 2001, 5, NULL, '2026-03-01T00:00:00Z', 'PAY-FRESH-6', NULL);

-- 22. payment initiated at not null. Expected: initiated_at, SQLSTATE 23502.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "amount", "status", "initiated_at", "reference", "settled_at")
VALUES (9017, 2001, 5, 'initiated', NULL, 'PAY-FRESH-7', NULL);

-- 23. account balance check violation. Expected: account_balance_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "status", "opened_on")
VALUES (9012, 1001, 'ACCT-FRESH-9', 'USD', -1, 'active', '2026-03-01');

-- 24. payment amount check violation. Expected: payment_amount_positive, SQLSTATE 23514.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "amount", "status", "initiated_at", "reference", "settled_at")
VALUES (9018, 2001, 0, 'initiated', '2026-03-01T00:00:00Z', 'PAY-FRESH-8', NULL);

-- 25. payment reference violation. Expected: payment_reference_per_account, SQLSTATE 23505.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "amount", "status", "initiated_at", "reference", "settled_at")
VALUES (9019, 2001, 5, 'initiated', '2026-03-01T00:00:00Z', 'PAY-001', NULL);
