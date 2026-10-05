# Bank / Fintech Platform — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| account_id | payment records (list) |
| --- | --- |
| 2001 | [3001] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| payment.payment_id | payment.account_id | payment.status | account.account_id | account.customer_id | account.account_number | customer.customer_id | customer.email |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3001 | 2001 | settled | 2001 | 1001 | ACCT-2001 | 1001 | customer1@example.test |

Key: payment_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## payment_example

| payment.payment_id | payment.account_id | payment.status | account.account_id | account.customer_id | account.account_number | customer.customer_id | customer.email |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3001 | 2001 | settled | 2001 | 1001 | ACCT-2001 | 1001 | customer1@example.test |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customer

| customer_id | email | created_at |
| --- | --- | --- |
| 1001 | customer1@example.test | 2026-01-15T10:00:00+00:00 |

## account

| account_id | customer_id | account_number | currency | balance | status | opened_on |
| --- | --- | --- | --- | --- | --- | --- |
| 2001 | 1001 | ACCT-2001 | USD | 1250.5 | active | 2026-01-16 |

## payment

| payment_id | account_id | amount | status | initiated_at | reference | settled_at |
| --- | --- | --- | --- | --- | --- | --- |
| 3001 | 2001 | 25.75 | settled | 2026-02-01T12:30:00+00:00 | PAY-001 | 2026-02-01T12:31:00+00:00 |

## Dependencies

- customer: (customer_id) → email, created_at
- account: (account_id) → customer_id, account_number, currency, balance, status, opened_on
- payment: (payment_id) → account_id, amount, status, initiated_at, reference, settled_at

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
