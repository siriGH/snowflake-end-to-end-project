// Cloning a Table
CREATE TABLE mydb.public.customer_clone
CLONE mydb.public.customer_data;

SELECT * FROM mydb.public.customer_data;
SELECT * FROM mydb.public.customer_clone;

// Cloning Schema
CREATE SCHEMA mydb.copy_of_file_formats
CLONE mydb.file_formats;


// Cloning Database
CREATE DATABASE mydb_copy
CLONE mydb;


//Update data in source and cloned objects and observer both the tables

select * from mydb.public.customer_data where customerid=1684012735799;
UPDATE mydb.public.customer_data SET CUSTNAME='ABCDEFGH' WHERE CUSTOMERID=1684012735799;
select * from mydb.public.customer_data where customerid=1684012735799;
select * from mydb.public.customer_clone where customerid=1684012735799;

select * from mydb.public.customer_clone where customerid=1654101252899;
UPDATE mydb.public.customer_clone SET CITY='XYZ' WHERE CUSTOMERID=1654101252899;
select * from mydb.public.customer_clone where customerid=1654101252899;
select * from mydb.public.customer_data where customerid=1654101252899;


//Dropping cloned objects
DROP DATABASE mydb_copy;
DROP SCHEMA mydb.copy_of_file_formats;
DROP TABLE mydb.public.customer_clone;


// Clone using Time Travel

SELECT * FROM mydb.public.customer_data;
DELETE FROM mydb.public.customer_data;
SELECT * FROM mydb.public.customer_data;

CREATE OR REPLACE TABLE mydb.PUBLIC.customer_tt_clone
CLONE mydb.public.customer_data at (OFFSET => -60*5);

DROP table mydb.public.customer_data;


SELECT * FROM mydb.public.customer_tt_clone;
SELECT * FROM mydb.public.customer_data;

CREATE OR REPLACE TABLE mydb.PUBLIC.customer_data
CLONE mydb.public.customer_tt_clone;