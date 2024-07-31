SELECT * FROM customerpurchasedb.customer_purchase_data;



set sql_safe_updates=0;
DELETE FROM customer_purchase_data
WHERE customerid IS NULL OR productid IS NULL OR purchasedate IS NULL;
alter table customer_purchase_data
column productid column_definition
drop column productid;
add column customerid_1 int
auto_increment primary key;
ALTER TABLE customer_purchase_data
drop column productid;
CHANGE customerid_1 customerid int;
ALTER TABLE customer_purchase_data
MODIFY customerid int FIRST;
ALTER TABLE customer_purchase_data
product_id INT AUTO_INCREMENT PRIMARY KEY,
    productname UNIQUE;
    CREATE TABLE product_mapping (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    productname VARCHAR(255) UNIQUE
);
INSERT INTO product_mapping (productname)
SELECT DISTINCT productname
FROM customer_purchase_data;
ALTER TABLE customer_purchase_data ADD COLUMN product_id INT;
UPDATE customer_purchase_data t
JOIN product_mapping m ON t.productname = m.productname
SET t.product_id = m.product_id;
#now customerid and productid has been corrected 
CREATE TABLE customers (
    customerid INT PRIMARY KEY,
    customername VARCHAR(100),
    country VARCHAR(100)
);
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    productname VARCHAR(100),
    productcategory VARCHAR(100)
);

CREATE TABLE transactions (
    transactionid INT PRIMARY KEY,
    customerid INT,
    product_id INT,
    purchasequantity INT,
    purchaseprice DECIMAL(10, 2),
    purchasedate DATE,
    FOREIGN KEY (customerid) REFERENCES customers(customerid),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
INSERT INTO customers (customerid, customername, country)
SELECT DISTINCT customerid, customername, country FROM customer_purchase_data;

INSERT INTO products (product_id, productname, productcategory)
SELECT DISTINCT product_id, productname, ProductCategory FROM customer_purchase_data;

INSERT INTO transactions (transactionid, customerid, product_id, purchasequantity, PurchasePrice, purchasedate)
SELECT transactionid, customerid, product_id, purchasequantity, purchaseprice, purchasedate FROM customer_purchase_data;
#total purchases per customer
SELECT customerid, SUM(purchasequantity) AS total_purchases
FROM transactions
GROUP BY customerid;

-- Total sales per product
SELECT product_id, SUM(purchasequantity * purchaseprice) AS total_sales
FROM transactions
GROUP BY product_id;





