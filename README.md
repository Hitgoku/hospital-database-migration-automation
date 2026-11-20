
# Hospital Database Migration & Automation

## Project Overview

This project focuses on migrating hospital management data from CSV files into a structured MySQL relational database.

The objective is to improve data organization, maintain data integrity, implement appointment validation, control access to patient information, and generate department-wise monthly revenue reports.

## Business Problems

The hospital initially maintains information in CSV files, creating challenges such as:

- Data duplication and inconsistent records.
- Lack of proper relationships between hospital entities.
- Appointment scheduling conflicts.
- Restricted access to sensitive patient information.
- Difficulty generating monthly department-wise revenue reports.

## Technologies Used

- MySQL
- MySQL Workbench
- SQL Stored Procedures
- SQL Triggers
- Foreign Keys and Constraints
- CSV Data Migration

## Database Design

The project includes the following tables:

1. Departments
2. Doctors
3. Patients
4. Appointments
5. Prescription
6. Bill
7. Labrep

## Project Implementation

### 1. Database and Table Creation

- Created relational tables using MySQL.
- Implemented primary keys and foreign keys.
- Applied constraints to maintain data integrity.

### 2. CSV Data Migration

- Imported source CSV data into a staging table.
- Extracted individual entities from the staging table.
- Migrated records into normalized relational tables.
- Converted source date formats using STR_TO_DATE().
- Handled empty and NULL values during migration.

### 3. Appointment Scheduling Validation

Created a BEFORE INSERT trigger to:

- Prevent appointments from being scheduled in the past.
- Prevent a doctor from having another scheduled appointment at the same time.

### 4. Role-Based Data Access

Created a stored procedure to demonstrate different patient-data access rules:

- Senior doctors: View patients belonging to their department.
- Other doctors: View patients associated with their appointments.

### 5. Department-wise Monthly Revenue

Created a stored procedure named `monthly_revenue` to calculate total bill amounts for each department based on the selected year and month.

Example:

```sql
CALL monthly_revenue(2025, 1);
```

## Key SQL Concepts Demonstrated

- CREATE TABLE
- INSERT INTO SELECT
- JOIN operations
- Primary and Foreign Keys
- CHECK Constraints
- Stored Procedures
- Triggers
- Aggregate Functions
- GROUP BY
- Date Functions
- STR_TO_DATE()

## Project Outcomes

- Migrated hospital data from a staging table into relational tables.
- Established relationships between hospital entities.
- Implemented database-side appointment validation.
- Demonstrated role-based patient-data retrieval.
- Automated monthly department-wise revenue calculations.

## Future Improvements

- Implement transaction-safe appointment booking.
- Improve authentication and password security.
- Introduce more detailed billing and payment management.
- Connect the database to a Power BI dashboard.

## Author

Data Analyst | SQL | MySQL | Power BI
