SELECT *
FROM retailco_transactions;

-- SUMMARIZE THE TABLES 
Describe retailco_transactions;

-- DATA VOLUME  
SELECT COUNT(*) AS Total_rows
FROM retailco_transactions;

-- PERCENTAGE OF MISSING VALUES
SELECT *
FROM 
		retailco_transactions
		WHERE 'invoice_id' IS NULL
		OR 'store_id' IS NULL
        OR 'customer_id'IS NULL
        OR 'product_id' IS NULL
        OR 'created_by' IS NULL;

	
-- CHANGE DATE COLUMNS FROM TEXT TO DATE FORMAT 
ALTER TABLE retailco_transactions
ADD COLUMN `inv_date` DATE;
UPDATE retailco_transactions
SET `inv_date` = str_to_date(invoice_date, '%Y-%m-%d');

ALTER TABLE retailco_transactions
ADD COLUMN `pos_date` DATE;
UPDATE retailco_transactions
SET `pos_date` = str_to_date(posting_date, '%Y-%m-%d');


ALTER TABLE retailco_transactions
DROP COLUMN invoice_date; -- To avoid data issues we created a new column and populated the new column with the correct date

ALTER TABLE retailco_transactions
DROP COLUMN posting_date; -- To avoid data issues we created a new column and populated the new column with the correct date

-- EXPLORATORY ANALYSIS

-- Product performance by volume 
SELECT `product_id`, SUM(quantity) AS order_volume
FROM retailco_transactions
GROUP BY `product_id`
ORDER BY order_volume
DESC;
        
        
-- product performance by revenue
SELECT `product_id`, SUM(net_amount) AS Revenue
FROM retailco_transactions
GROUP BY `product_id`
ORDER BY Revenue
DESC
LIMIT 7;         
       
-- Store performance by revenue       
SELECT s.store_name, SUM(t.net_amount) AS Revenue, SUM(t.quantity) AS Sales_Volume
FROM retailco_transactions t
INNER JOIN retailco_store_data s 
	ON t.store_id = s.store_id
GROUP BY s.store_name
ORDER BY Revenue
DESC;         

SELECT s.store_name, SUM(t.discount_amount) AS Discount, SUM(t.net_amount)
FROM retailco_transactions t
INNER JOIN retailco_store_data s 
	ON t.store_id = s.store_id
GROUP BY s.store_name
ORDER BY Discount
DESC;        


