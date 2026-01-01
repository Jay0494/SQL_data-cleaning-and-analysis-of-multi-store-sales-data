
[See powerbi Analysis](https://github.com/Jay0494/Data-Driven-Sales-Performance-Analysis-for-Multi-Store-Retail.git)
## SQL Workflow 

SQL was used as the primary analytical layer to ensure **data integrity, relational accuracy, and reproducible analysis** before visualization in Power BI.

---

### 1. Data Familiarization & Volume Assessment

Initial queries were used to understand the structure and scale of the transactional dataset.

```sql
-- View raw transactional data
SELECT *
FROM retailco_transactions;
```

```sql
-- Inspect table structure and data types
DESCRIBE retailco_transactions;
```

```sql
-- Assess overall data volume
SELECT COUNT(*) AS total_rows
FROM retailco_transactions;
```

This step establishes baseline confidence in the dataset before transformation or aggregation.

---

### 2. Data Quality & Completeness Checks

Key business-critical fields were tested for missing values to prevent misstatement or incorrect attribution in downstream analysis.

```sql
-- Identify records with missing critical fields
SELECT *
FROM retailco_transactions
WHERE invoice_id IS NULL
   OR store_id IS NULL
   OR customer_id IS NULL
   OR product_id IS NULL
   OR created_by IS NULL;
```

Records failing these checks were flagged for review to avoid distorted revenue, volume, or store-level metrics.

---

### 3. Controlled Date Standardization (Text → DATE)

Date fields originally stored as text were converted into proper `DATE` formats using a controlled transformation process.

```sql
-- Create and populate invoice date column
ALTER TABLE retailco_transactions
ADD COLUMN inv_date DATE;

UPDATE retailco_transactions
SET inv_date = STR_TO_DATE(invoice_date, '%Y-%m-%d');
```

```sql
-- Create and populate posting date column
ALTER TABLE retailco_transactions
ADD COLUMN pos_date DATE;

UPDATE retailco_transactions
SET pos_date = STR_TO_DATE(posting_date, '%Y-%m-%d');
```

```sql
-- Remove original text-based date columns after validation
ALTER TABLE retailco_transactions
DROP COLUMN invoice_date;

ALTER TABLE retailco_transactions
DROP COLUMN posting_date;
```

This ensures accurate time-based aggregation, filtering, and trend analysis.

---

### 4. Relational Integrity via JOIN Operations

To evaluate performance within the correct business context, transactional data was enriched using **INNER JOINs** with reference tables.

```sql
-- Store-level revenue and sales volume analysis using JOINs
SELECT s.store_name,
       SUM(t.net_amount) AS revenue,
       SUM(t.quantity) AS sales_volume
FROM retailco_transactions t
INNER JOIN retailco_store_data s
    ON t.store_id = s.store_id
GROUP BY s.store_name
ORDER BY revenue DESC;
```

```sql
-- Discount distribution by store
SELECT s.store_name,
       SUM(t.discount_amount) AS total_discount,
       SUM(t.net_amount) AS revenue
FROM retailco_transactions t
INNER JOIN retailco_store_data s
    ON t.store_id = s.store_id
GROUP BY s.store_name
ORDER BY total_discount DESC;
```

JOINs ensure accurate attribution of transactions to stores and prevent orphaned or misclassified records.

---

### 5. Exploratory & Risk-Focused Aggregations

With data integrity confirmed, SQL was used to generate core analytical views.

```sql
-- Product performance by sales volume
SELECT product_id,
       SUM(quantity) AS sales_volume
FROM retailco_transactions
GROUP BY product_id
ORDER BY sales_volume DESC;
```

```sql
-- Product performance by revenue
SELECT product_id,
       SUM(net_amount) AS revenue
FROM retailco_transactions
GROUP BY product_id
ORDER BY revenue DESC
LIMIT 7;
```

These aggregations support identification of demand drivers, revenue concentration, and potential operational risk areas.

---

### 6. Analytics-Ready Outputs

The final SQL outputs are **clean, well-structured, and BI-ready**, enabling consistent KPI calculation and scalable reporting in Power BI.

