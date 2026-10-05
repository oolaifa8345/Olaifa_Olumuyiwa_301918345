-- Fictional sample records for Bank / Fintech Platform.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customer" ("customer_id", "email", "created_at") VALUES (1001, 'customer1@example.test', '2026-01-15T10:00:00Z');
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "status", "opened_on") VALUES (2001, 1001, 'ACCT-2001', 'USD', 1250.5, 'active', '2026-01-16');
INSERT INTO portfolio."payment" ("payment_id", "account_id", "amount", "status", "initiated_at", "reference", "settled_at") VALUES (3001, 2001, 25.75, 'settled', '2026-02-01T12:30:00Z', 'PAY-001', '2026-02-01T12:31:00Z');
COMMIT;
