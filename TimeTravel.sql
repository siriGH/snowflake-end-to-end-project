// where can you see the retention period?
SHOW TABLES in SCHEMA mydb.public;
SHOW SCHEMAS in DATABASE mydb;
SHOW DATABASES;

// how to set this at the time of table creation
CREATE OR REPLACE TABLE mydb.public.timetravel_ex(id number, name string);

SHOW TABLES like 'timetravel_ex%';

CREATE OR REPLACE TABLE mydb.public.timetravel_ex(id number, name string)
DATA_RETENTION_TIME_IN_DAYS = 10;  --- We can set to any number as per our requirement

SHOW TABLES like 'timetravel_ex%';

// setting at schema level
CREATE SCHEMA mydb.abcxyz DATA_RETENTION_TIME_IN_DAYS = 10;
SHOW SCHEMAS like 'abcxyz';

CREATE OR REPLACE TABLE mydb.abcxyz.timetravel_ex2(id number, name string);
SHOW TABLES like 'timetravel_ex2%';

CREATE OR REPLACE TABLE mydb.abcxyz.timetravel_ex2(id number, name string) DATA_RETENTION_TIME_IN_DAYS = 20;
SHOW TABLES like 'timetravel_ex2%';


// dont forget to change your schema back to public on right top corner
// how to alter retention period later?
ALTER TABLE mydb.public.timetravel_ex 
SET DATA_RETENTION_TIME_IN_DAYS = 1;

SHOW TABLES like 'timetravel_ex%';


// Querying history data

// Updating some data first

// Case1: update some data in customer table

SELECT * FROM mydb.public.customer_data;

SELECT * FROM mydb.public.customer_data WHERE CUSTOMERID=1682100334099;

UPDATE mydb.public.customer_data SET CUSTNAME='ABCXYZ' WHERE CUSTOMERID=1682100334099;

SELECT * FROM mydb.public.customer_data WHERE CUSTOMERID=1682100334099;

=============

// Case2: delete some data from emp_data table

SELECT * FROM mydb.public.emp_data;

SELECT * FROM mydb.public.emp_data where id=1;

DELETE FROM mydb.public.emp_data where id=1;

SELECT CURRENT_TIMESTAMP; -- 2025-06-24 07:44:36.716 -0700

SELECT * FROM mydb.public.emp_data where id=1;

==============

// Case3: update some data in customer table

SELECT * FROM mydb.public.orders_ex;

SELECT * FROM mydb.public.orders_ex WHERE ORDER_ID='B-25601';

UPDATE mydb.public.orders_ex SET AMOUNT=0 WHERE ORDER_ID='B-25601'; -- 01bd3ed7-3203-1b7b-0000-0006746ab2d1

SELECT * FROM mydb.public.orders_ex WHERE ORDER_ID='B-25601';

==============

// Case1: retrieve history data by using AT OFFSET

SELECT * FROM mydb.public.customer_data WHERE CUSTOMERID=1682100334099;

SELECT * FROM mydb.public.customer_data AT (offset => -60*10)
WHERE CUSTOMERID=1682100334099;

// Case2: retrieve history data by using AT TIMESTAMP
SELECT * FROM mydb.public.emp_data where id=1;

SELECT * FROM mydb.public.emp_data AT(timestamp => '2025-06-23 19:47:48.916'::timestamp)
WHERE id=1;


// Case3: retrieve history data by using BEFORE STATEMENT
SELECT * FROM mydb.public.orders_ex WHERE ORDER_ID='B-25601';

SELECT * FROM mydb.public.orders_ex 
before(statement => '01bd3ed7-3203-1b7b-0000-0006746ab2d1')
WHERE ORDER_ID='B-25601';

CREATE TABLE mydb.public.orders_tt
AS
SELECT * FROM mydb.public.orders_ex 
before(statement => '01bd3ed7-3203-1b7b-0000-0006746ab2d1');

SELECT * FROM mydb.public.orders_ex WHERE ORDER_ID='B-25601';
SELECT * FROM mydb.public.orders_tt WHERE ORDER_ID='B-25601';
=================

// Restoring Tables
SHOW TABLEs like 'customer%';
DROP TABLE mydb.public.customer_data;
SHOW TABLEs like 'customer%';
UNDROP TABLE mydb.public.customer_data;
SHOW TABLEs like 'customer%';

// Restoring Schemas
SHOW SCHEMAS in DATABASE myown_db;
DROP SCHEMA STAGE_TBLS;
SHOW SCHEMAS in DATABASE mydb;
UNDROP SCHEMA STAGE_TBLS;
SHOW SCHEMAS in DATABASE mydb;

====================
// Time Travel Cost

SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS;

SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS
WHERE TABLE_NAME = 'CUSTOMER_DATA';

SELECT 	ID, 
		TABLE_NAME, 
		TABLE_SCHEMA,
        TABLE_CATALOG,
		ACTIVE_BYTES / (1024*1024*1024) AS STORAGE_USED_GB,
		TIME_TRAVEL_BYTES / (1024*1024*1024) AS TIME_TRAVEL_STORAGE_USED_GB
FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS
WHERE TABLE_NAME = 'CUSTOMER_DATA'
ORDER BY STORAGE_USED_GB DESC,TIME_TRAVEL_STORAGE_USED_GB DESC;

UPDATE mydb.public.customer_data set state='abc';

SELECT 	ID, 
		TABLE_NAME, 
		TABLE_SCHEMA,
        TABLE_CATALOG,
		ACTIVE_BYTES / (1024*1024*1024) AS STORAGE_USED_GB,
		TIME_TRAVEL_BYTES / (1024*1024*1024) AS TIME_TRAVEL_STORAGE_USED_GB
FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS
WHERE TABLE_NAME = 'CUSTOMER_DATA';