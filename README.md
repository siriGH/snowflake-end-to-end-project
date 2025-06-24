# snowflake-end-to-end-project
This repository documents my hands-on learning and implementation of an end-to-end data pipeline using **Snowflake** and **AWS S3**. The project covers structured and semi-structured data handling, storage integration, automation, security, and advanced Snowflake features like Time travel, Zero copy cloning, and dynamic data masking.

What I Learned & Implemented:

1. Data Ingestion from AWS S3

Uploaded structured (CSV) and semi-structured (JSON) files to an S3 bucket.
Created IAM Role with Trusted Relationship to allow Snowflake to access S3 securely.
Created Storage Integration with AWS S3 in Snowflake.
Defined external stages and file formats objects.
Loaded data using COPY INTO commond from AWS S3 files to Snowflake tables.

2. Semi-Structured Data Processing (JSON)

Created a stage table using the VARIANT data type.
Parsed nested JSON using dot notation (raw_file: field), FLATTEN, ARRAY_SIZE, and path expressions.
Inserted clean data into staging tables.
Created reusable views on top of parsed JSON data.

3. Snowpipe for Auto-Ingestion

Created Snowpipe to automate ingestion from S3 to Snowflake.
Verified status using SYSTEM$PIPE_STATUS.
Metadata columns: lastIngestedTimestamp, lastIngestedFilePath
Ensured minimal latency for streaming file ingestion.

4. Data Governance with Access Control

Created users and custom roles: sales_admin, hr_users, market_admin.
Assigned role hierarchies and applied Role Based Access Control.
Granted granular privileges (SELECT, USAGE, OWNERSHIP).

5. Dynamic Data Masking

Created masking policies for sensitive data columns like:
  Phone numbers
  Account balances
Applied masking on:
  Base tables
  Views
Verified access across roles like sales_users, market_admin.

 6. Time Travel & Recovery
The retention period is 1 day by default.
Set DATA_RETENTION_TIME_IN_DAYS at the table/schema level.
Used Time Travel to recover or query past data using:
AT OFFSET => -60*10
AT TIMESTAMP => '2025-06-23 19:47:48'
BEFORE STATEMENT => '<query_id>'
Restored dropped tables and schemas using UNDROP.

7. Zero Copy Cloning
Cloned tables, schemas, and databases.
Demonstrated that cloned objects are
Independent in content
Linked in storage (no duplication)
Compare cloning vs. CREATE TABLE AS SELECT * FROM ....
Used a clone to recreate the dropped base tables.

8. Stored Procedures & User-Defined Functions
Stored Procedures: Wrote SQL & JavaScript-based procedures:
Customer total spent by category
Row count retrieval using a dynamic table name

User Defined Functions (UDFs)
Scalar UDFs (e.g., tax calculation)
Tabular UDFs (e.g., customer country lookup)
Applied UDFs in queries for modular logic.

Learnings & Takeaways:

Learned the importance of stages in organizing and automating ingestion.
Gained hands-on experience with semi-structured JSON handling using variant & flatten.
Understood how to implement data governance using masking and roles.
Experienced cost-effective cloning and backup recovery through time travel.
Practiced writing procedures and functions for reusable data logic.



