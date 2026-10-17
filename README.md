Student Performance Tracker - README
Welcome to the Student Performance Tracker database repository! This project provides a robust relational database schema and a comprehensive collection of SQL queries designed to manage, analyze, and report on academic data including students, faculty, courses, enrollments, attendance, and grades.

🏗️ Database Schema Overview
The database (student_performance_tracker) consists of 7 interconnected tables with strict foreign key constraints, indexes, and cascades configured:

Departments: Stores academic departments (e.g., Computer Science, Business Administration).

Students: Stores individual student demographic details, contact info, and department affiliations.

Faculty: Stores faculty member profiles, experience years, and department associations.

Courses: Tracks offered courses, assigned faculty, credits, and departments.

Enrollments: Junction table mapping students to their enrolled courses.

Attendance: Tracks daily attendance status (Present, Absent, Late) per student and course.

Grades: Records marks obtained and letter grades per student and course with validation checks.

🚀 Getting Started
To set up the database and run the queries:

Open your MySQL client (such as MySQL Workbench or command line).

Execute the setup script to create the database, tables, indexes, and seed sample data:
SOURCE sql exam rnw.sql;

📂 Included SQL Script Features
The provided script (sql exam rnw.sql) covers a wide spectrum of SQL operations and analytics:

CRUD Operations: Examples of INSERT, SELECT, UPDATE, and DELETE statements respecting foreign key constraints.

Filtering & Conditions: Utilization of WHERE, HAVING, LIMIT, and logical operators (AND, OR) for targeted data extraction.

Sorting & Grouping: Alphabetical sorting, aggregations (COUNT, AVG, SUM, MAX, MIN), and grouped summaries.

Joins & Set Operations: Demonstrations of INNER JOIN, LEFT JOIN, RIGHT JOIN, and UNION.

Subqueries: Advanced subqueries for filtering records relative to aggregate metrics (e.g., above-average performers, high absentee counts).

Date & Time Functions: Month extractions, age/duration calculations via TIMESTAMPDIFF, and date formatting (DATE_FORMAT).

String Manipulations: Text cleaning (TRIM, UPPER) and missing-value handling (COALESCE, NULLIF).

Window Functions: Advanced analytical queries using RANK() and running totals with sliding windows (ROWS BETWEEN).

Conditional Expressions: Categorizing performance tiers and attendance health (CASE).

Comprehensive Reports: Combined multi-table reports highlighting students needing academic or attendance intervention.

