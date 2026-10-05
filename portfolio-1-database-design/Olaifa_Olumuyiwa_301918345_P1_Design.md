# Bank / Fintech Platform — database design

My case study records customer, account, payment.

## Users

- Customers reviewing account activity
- Operations staff monitoring payment outcomes
- Students practicing relational design and transaction control

## Main operations

- Create synthetic customer accounts and record payments.
- Join Payment to Account and Customer to retrieve customer payment history.
- Filter payments by account, status, and initiation date.
- Join Payment to Account, filter settled payments by date, and aggregate counts and amounts by account and currency.
- Separate benchmark plan: load 50000 synthetic payments, compare the initiated_at date-range filter before and after a B-tree index, and compare returned row counts and execution plans.

## Entities

| Entity | Information stored |
| --- | --- |
| customer | A synthetic person or organization that owns bank accounts. |
| account | A customer-owned account with a currency, status, and nonnegative available balance. |
| payment | A payment attempt or settlement debiting one account. |

## customer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| email | TEXT | Unique | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- Unique key: (email).

## account

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| account_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| account_number | TEXT | Unique | Yes |
| currency | TEXT |  | Yes |
| balance | NUMERIC(18,2) |  | Yes |
| status | TEXT |  | Yes |
| opened_on | DATE |  | Yes |
- customer_id → customer.customer_id
- Unique key: (account_number).

## payment

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| payment_id | BIGINT | PK | Yes |
| account_id | BIGINT | FK | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| status | TEXT |  | Yes |
| initiated_at | TIMESTAMPTZ |  | Yes |
| reference | TEXT |  | No |
| settled_at | TIMESTAMPTZ |  | No |
- account_id → account.account_id

## Relationships and business rules

- Each customer email identifies at most one customer.
- Every account references an existing customer through customer_id.
- Each account number identifies one account.
- Account balance must be greater than or equal to zero.
- Every payment references an existing account through account_id.
- Payment amount must be greater than zero.
- When reference is not null, it must be unique within its account.

## Assumptions

- All records and identifiers are synthetic; identifiers are globally unique across entity types.
- Each account belongs to exactly one customer; a customer may own multiple accounts.
- Each payment debits exactly one account; transfers between accounts are outside this model.
- Account balance is the stored available balance, and a debit must not make it negative.
- Payment amounts are positive decimal values, and currency values use three-letter codes.
- Timestamps are recorded in UTC; a reference is optional and unique per account when present.

