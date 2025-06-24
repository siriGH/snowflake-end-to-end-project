// Creating AWS free account

// Create storage integration object
create or replace storage integration s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE 
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::548775194136:role/aws_s3_snowflake_intg'
  STORAGE_ALLOWED_LOCATIONS = ('s3://awss3sirik/csv/', 's3://awss3sirik/json/')
  COMMENT = 'Integration with aws s3 buckets' ;
   
   
// Get external_id and update it in S3
DESC integration s3_int;

// ARN -- Amazon Resource Names
// S3 -- Simple Storage Service
// IAM -- Integrated Account Management

-----------------------------------
// Create database and schema
CREATE DATABASE IF NOT EXISTS MYDB;
CREATE SCHEMA IF NOT EXISTS MYDB.file_formats;

// Create file format object
CREATE OR REPLACE file format mydb.file_formats.csv_fileformat
    type = csv
    field_delimiter = '|'
    skip_header = 1
    empty_field_as_null = TRUE;    
    
// Create stage object with integration object & file format object
CREATE OR REPLACE STAGE mydb.external_stages.aws_s3_csv
    URL = 's3://awss3sirik/csv/'
    STORAGE_INTEGRATION = s3_int
    FILE_FORMAT = mydb.file_formats.csv_fileformat ;

//Listing files under your s3 buckets
list @mydb.external_stages.aws_s3_csv;


// Create a table first
CREATE OR REPLACE TABLE mydb.public.customer_data (
customerid NUMBER,
custname STRING,
email STRING,
city STRING,
state STRING,
DOB DATE
); 

// Use Copy command to load the files
COPY INTO mydb.public.customer_data
    FROM @mydb.external_stages.aws_s3_csv
    PATTERN = '.*customer.*';    
	
//Validate the data
SELECT * FROM mydb.public.customer_data;