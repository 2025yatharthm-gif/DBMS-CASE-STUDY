# Ration Shop Distribution Ledger Database Using SQL

## 1. Project Overview

This project is a PostgreSQL database system designed to manage ration shop distribution records.

The database stores information about:
- Ration card holders
- Family members
- Commodities
- Monthly entitlements
- Available stock
- Commodity distributions

The system also prevents distribution beyond the monthly entitlement and available stock using a PostgreSQL trigger.

## 2. Objectives

The main objectives of this project are:

- To design a normalized relational database for ration shop management.
- To store card holder and family member information.
- To maintain commodity entitlements based on family size.
- To track available commodity stock.
- To record daily commodity distributions.
- To prevent over-distribution using database constraints and triggers.
- To answer important business queries using SQL.
- To demonstrate single-column and composite indexes.
- To compare query performance using `EXPLAIN ANALYZE`.

## 3. Database Tables

The database contains the following six tables:

| Table | Purpose |
|---|---|
| `card_holder` | Stores ration card holder details |
| `family_member` | Stores individual family member details |
| `commodity` | Stores commodity information |
| `entitlement` | Defines allowed quantity based on family size |
| `stock` | Stores currently available stock |
| `distribution` | Records commodities distributed to card holders |

### Relationships

- One card holder can have many family members.
- One card holder can have many distribution records.
- One commodity can appear in many distribution records.
- One commodity can have multiple entitlement rules based on family size.
- Each commodity has one stock record.

## 4. Sample Data

The project uses a small classroom-sized dataset:

- 10 card holders
- 20 family members
- 5 commodities
- 10 entitlement records
- 5 stock records
- 20 distribution records

## 5. Important SQL Queries

The database answers the following questions:

### Query 1: Card holders who collected less than their entitlement

This query compares the total quantity collected by each card holder with the applicable monthly entitlement.

It uses:
- `JOIN`
- `LEFT JOIN`
- `GROUP BY`
- `HAVING`
- `COALESCE`

### Query 2: Remaining stock per commodity

This query displays the current quantity available for every commodity.

### Query 3: Families with more than six members

This query identifies card holders whose family size is greater than six.

### Query 4: Daily commodity distribution

This query calculates how much of each commodity was distributed on each day.

It uses aggregation and `GROUP BY`.

### Query 5: Card holders with no collection

This query identifies card holders who have not collected any ration during the selected three-month period.

A `NOT IN` subquery is used for this purpose.

## 6. Data Integrity and Over-Distribution Prevention

A PostgreSQL trigger named `prevent_over_distribution` is used to protect the distribution data.

Before a distribution is inserted, the trigger:

1. Finds the applicable entitlement based on family size and commodity.
2. Calculates the quantity already issued during the same month.
3. Checks whether the new distribution would exceed the entitlement.
4. Checks whether sufficient stock is available.
5. Rejects the transaction if either limit is exceeded.
6. Reduces the stock quantity after a valid distribution.

This prevents invalid distribution records from being inserted.

A normal `CHECK` constraint was not used for the monthly entitlement check because a `CHECK` constraint cannot calculate totals from multiple existing rows.

## 7. Design Decisions

### Separate Family Member Table

Family members are stored in a separate `family_member` table instead of storing multiple names in one column.

**Reason:** This follows relational database normalization and makes it easier to count, search, and manage individual family members.

### Separate Entitlement Table

Entitlements are stored separately because the allowed quantity changes according to family size and commodity.

**Reason:** This avoids repeating entitlement information in the distribution table.

### Separate Stock Table

Current stock is maintained separately from distribution records.

**Reason:** Distribution records represent historical transactions, while the stock table represents the current available quantity.

### Composite Index

A composite index is created on:

```text
(card_id, issue_date)

## 8. Indexing and Query Performance

Three custom indexes were created:

- `idx_distribution_issue_date` — single-column index on `issue_date`
- `idx_card_holder_family_size` — single-column index on `family_size`
- `idx_distribution_card_date` — composite index on `(card_id, issue_date)`

Query performance was examined using PostgreSQL `EXPLAIN ANALYZE`.

### Important Observation

The database contains only a small number of rows, so PostgreSQL often prefers a sequential scan instead of using an index.

For example, the query:

```sql
SELECT *
FROM distribution
WHERE issue_date = '2026-09-05';

## 9. Rejected Alternatives

### Storing Family Members in One Column

An alternative was to store all family member names in the `card_holder` table as a comma-separated value.

**Rejected because:** It violates normalization and makes individual member searches and counting difficult.

### Using Only CHECK Constraints for Distribution Limits

A `CHECK` constraint was considered for preventing over-distribution.

**Rejected because:** The monthly limit depends on the sum of previous distribution records. A `CHECK` constraint cannot perform this type of multi-row calculation.

### Using Only a Single-Column Card ID Index

A separate index on `card_id` was tested.

**Rejected because:** The composite index `(card_id, issue_date)` already begins with `card_id` and can support searches using the leading column. Keeping both would add unnecessary index overhead.

## 10. Technologies Used

- PostgreSQL 16
- SQL
- PL/pgSQL
- VS Code
- PostgreSQL `EXPLAIN ANALYZE`

## 11. Files in the Project

```text
DBMS-CASE-STUDY/
│
├── schema.sql
├── seed.sql
├── queries.sql
├── README.md
└── ER_Diagram