CREATE DATABASE IF NOT EXISTS student_performance_tracker;
USE student_performance_tracker;
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Grades;
DROP TABLE IF EXISTS Attendance;
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Faculty;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Departments;
SET FOREIGN_KEY_CHECKS = 1;

# DATABASE SCHEMA
create table departments(
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    dob DATE,
    gender ENUM('Male', 'Female', 'Other', 'Prefer not to say') DEFAULT 'Prefer not to say',
    email VARCHAR(150) UNIQUE,
    phone_number VARCHAR(20),
    address VARCHAR(255),
    admission_date DATE NOT NULL,
    department_id INT NOT NULL,
    CONSTRAINT fk_students_department
        FOREIGN KEY (department_id) REFERENCES Departments(department_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Faculty (
    faculty_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(150) UNIQUE,
    phone_number VARCHAR(20),
    department_id INT NOT NULL,
    years_experience INT NOT NULL DEFAULT 0,
    CONSTRAINT chk_faculty_experience CHECK (years_experience >= 0),
    CONSTRAINT fk_faculty_department
        FOREIGN KEY (department_id) REFERENCES Departments(department_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(120) NOT NULL,
    department_id INT NOT NULL,
    faculty_id INT NULL,
    credits TINYINT UNSIGNED NOT NULL DEFAULT 3,
    CONSTRAINT fk_courses_department
        FOREIGN KEY (department_id) REFERENCES Departments(department_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_courses_faculty
        FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    CONSTRAINT uq_student_course UNIQUE (student_id, course_id),
    CONSTRAINT fk_enrollments_student
        FOREIGN KEY (student_id) REFERENCES Students(student_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_enrollments_course
        FOREIGN KEY (course_id) REFERENCES Courses(course_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('Present', 'Absent', 'Late') NOT NULL,
    CONSTRAINT uq_attendance_record UNIQUE (student_id, course_id, attendance_date),
    CONSTRAINT fk_attendance_student
        FOREIGN KEY (student_id) REFERENCES Students(student_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_attendance_course
        FOREIGN KEY (course_id) REFERENCES Courses(course_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    marks_obtained DECIMAL(5,2) NOT NULL,
    grade VARCHAR(2),
    CONSTRAINT chk_marks_range CHECK (marks_obtained BETWEEN 0 AND 100),
    CONSTRAINT uq_student_course_grade UNIQUE (student_id, course_id),
    CONSTRAINT fk_grades_student
        FOREIGN KEY (student_id) REFERENCES Students(student_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_grades_course
        FOREIGN KEY (course_id) REFERENCES Courses(course_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX idx_attendance_date ON Attendance(attendance_date);
CREATE INDEX idx_grades_marks ON Grades(marks_obtained);
CREATE INDEX idx_students_department ON Students(department_id);

# insert data 
INSERT INTO Departments (department_id, department_name) VALUES
(1, 'Computer Science'),
(2, 'Business Administration'),
(3, 'Mathematics'),
(4, 'Physics');

INSERT INTO Students
(student_id, name, dob, gender, email, phone_number, address, admission_date, department_id)
VALUES
(1, 'jay prajapati', '2004-02-14', 'Male', 'jay@example.com', '9876500001', 'Ahmedabad', '2022-07-15', 1),
(2, 'priya patel', '2003-11-08', 'Female', 'priya@example.com', '9876500002', 'Vadodara', '2021-07-12', 1),
(3, 'Rohan thesiya ', '2004-06-21', 'Male', NULL, '9876500003', 'Surat', '2023-07-10', 2),
(4, 'swati gadhiya', '2003-04-03', 'Female', 'swati@example.com', '9876500004', 'Ahmedabad', '2021-07-12', 3),
(5, 'kabir singh', '2004-09-19', 'Male', 'kabir@example.com', '9876500005', 'Rajkot', '2022-07-15', 1),
(6, 'kajal singh', '2003-12-30', 'Female', 'kajal@example.com', '9876500006', 'Gandhinagar', '2020-07-14', 2),
(7, 'amit  Trivedi', '2004-01-27', 'Male', 'amit@example.com', '9876500007', 'Bhavnagar', '2023-07-10', 4),
(8, 'hasti vadoriya ', '2003-08-11', 'Female', 'hasti@example.com', '9876500008', 'Ahmedabad', '2022-07-15', 3),
(9, 'Neel rathod', '2004-05-25', 'Male', 'neel@example.com', '9876500009', 'Anand', '2024-07-11', 1),
(10, 'drashti sutariya', '2003-03-17', 'Female', 'drashti@example.com', '9876500010', 'Nadiad', '2020-07-14', 2);

INSERT INTO Faculty
(faculty_id, name, email, phone_number, department_id, years_experience)
VALUES
(1, 'Dr. Priyanka padshala', 'priyanka padshla@example.com', '9825000101', 1, 8),
(2, 'Prof. Amit Verma', 'amit.verma@example.com', '9825000102', 1, 4),
(3, 'Dr. Kavita Rao', 'kavita.rao@example.com', '9825000103', 2, 12),
(4, 'Prof. Sanjay Iyer', 'sanjay.iyer@example.com', '9825000104', 3, 6),
(5, 'Dr. Leena Bose', 'leena.bose@example.com', '9825000105', 4, 9),
(6, 'Prof. Unassigned', 'unassigned@example.com', '9825000106', 2, 2);

INSERT INTO Courses (course_id, course_name, department_id, faculty_id, credits) VALUES
(1, 'Database Management', 1, 1, 4),
(2, 'Python Programming', 1, 2, 4),
(3, 'Marketing Fundamentals', 2, 3, 3),
(4, 'Statistics', 3, 4, 3),
(5, 'Applied Physics', 4, 5, 3),
(6, 'Business Analytics', 2, NULL, 3),
(7, 'Discrete Mathematics', 3, 4, 4);

INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date) VALUES
(1,1,1,'2024-07-15'), (2,1,2,'2024-07-15'), (3,1,4,'2024-07-16'),
(4,2,1,'2024-07-15'), (5,2,2,'2024-07-15'), (6,2,7,'2024-07-16'),
(7,3,3,'2024-07-15'), (8,3,6,'2024-07-16'), (9,4,4,'2024-07-15'),
(10,4,7,'2024-07-16'), (11,5,1,'2024-07-15'), (12,5,2,'2024-07-15'),
(13,6,3,'2024-07-15'), (14,6,6,'2024-07-16'), (15,7,5,'2024-07-15'),
(16,8,4,'2024-07-15'), (17,8,7,'2024-07-16'), (18,9,1,'2024-07-15');

INSERT INTO Grades (grade_id, student_id, course_id, marks_obtained, grade) VALUES
(1,1,1,94,'A'), (2,1,2,88,'B'), (3,1,4,76,'B'),
(4,2,1,97,'A'), (5,2,2,92,'A'), (6,2,7,89,'B'),
(7,3,3,72,'C'), (8,3,6,68,'D'), (9,4,4,91,'A'),
(10,4,7,95,'A'), (11,5,1,61,'D'), (12,5,2,74,'C'),
(13,6,3,86,'B'), (14,6,6,90,'A'), (15,7,5,82,'B'),
(16,8,4,79,'C'), (17,8,7,84,'B'), (18,9,1,55,'D');

INSERT INTO Attendance (attendance_id, student_id, course_id, attendance_date, status) VALUES
(1,1,1,'2025-01-01','Present'), (2,1,1,'2025-01-02','Present'), (3,1,1,'2025-01-03','Late'),
(4,1,2,'2025-01-01','Present'), (5,1,2,'2025-01-02','Absent'),
(6,2,1,'2025-01-01','Present'), (7,2,1,'2025-01-02','Present'), (8,2,1,'2025-01-03','Present'),
(9,2,2,'2025-01-01','Present'), (10,2,2,'2025-01-02','Present'),
(11,3,3,'2025-01-01','Absent'), (12,3,3,'2025-01-02','Absent'), (13,3,3,'2025-01-03','Present'),
(14,3,6,'2025-01-01','Absent'), (15,3,6,'2025-01-02','Absent'),
(16,4,4,'2025-01-01','Present'), (17,4,4,'2025-01-02','Present'), (18,4,4,'2025-01-03','Present'),
(19,5,1,'2025-01-01','Absent'), (20,5,1,'2025-01-02','Absent'), (21,5,1,'2025-01-03','Late'),
(22,5,2,'2025-01-01','Absent'), (23,5,2,'2025-01-02','Absent'),
(24,6,3,'2025-01-01','Present'), (25,6,3,'2025-01-02','Present'),
(26,7,5,'2025-01-01','Present'), (27,7,5,'2025-01-02','Late'),
(28,8,4,'2025-01-01','Present'), (29,8,4,'2025-01-02','Absent'),
(30,9,1,'2025-01-01','Absent'), (31,9,1,'2025-01-02','Absent');

#  CRUD OPERATIONS
CREATE: add a student (uncomment and edit values to test)
 INSERT INTO Students
 (name, dob, gender, email, phone_number, address, admission_date, department_id)
 VALUES ('New Student', '2005-05-10', 'Other', 'new.student@example.com',
         '9876500099', 'Ahmedabad', CURDATE(), 1);

SELECT * FROM Students ORDER BY student_id;

 UPDATE: update a student's contact details
 UPDATE Students SET email = 'updated@example.com',
 phone_number = '9876500098' WHERE student_id = 1;

 DELETE: delete a dropped-out student (child records cascade)
 DELETE FROM Students WHERE student_id = 10;
 
#  WHERE, HAVING, LIMIT AND LOGICAL OPERATORS
SELECT s.student_id, s.name, d.department_name
FROM Students s
JOIN Departments d ON d.department_id = s.department_id
WHERE d.department_name = 'Computer Science';

-- Top 10 highest-scoring student-course results
SELECT s.name, c.course_name, g.marks_obtained
FROM Grades g
JOIN Students s ON s.student_id = g.student_id
JOIN Courses c ON c.course_id = g.course_id
ORDER BY g.marks_obtained DESC
LIMIT 10;

-- Students whose overall attendance is below 75%
SELECT s.student_id, s.name,
       ROUND(100.0 * SUM(a.status IN ('Present','Late')) / COUNT(*), 2) AS attendance_pct
FROM Students s
JOIN Attendance a ON a.student_id = s.student_id
GROUP BY s.student_id, s.name
HAVING attendance_pct < 75;

-- Attendance below 50% AND failing (average marks below 40)
SELECT s.student_id, s.name,
       ROUND(100.0 * SUM(a.status IN ('Present','Late')) / COUNT(*), 2) AS attendance_pct,
       AVG(g.marks_obtained) AS average_marks
FROM Students s
JOIN Attendance a ON a.student_id = s.student_id
JOIN Grades g ON g.student_id = s.student_id
GROUP BY s.student_id, s.name
HAVING attendance_pct < 50 AND average_marks < 40;

-- Score above 90 OR perfect attendance
SELECT s.student_id, s.name
FROM Students s
LEFT JOIN Grades g ON g.student_id = s.student_id
LEFT JOIN Attendance a ON a.student_id = s.student_id
GROUP BY s.student_id, s.name
HAVING MAX(g.marks_obtained) > 90
    OR (COUNT(a.attendance_id) > 0 AND SUM(a.status IN ('Present','Late')) = COUNT(a.attendance_id));

-- Faculty not assigned to any course
SELECT f.faculty_id, f.name
FROM Faculty f
LEFT JOIN Courses c ON c.faculty_id = f.faculty_id
WHERE c.course_id IS NULL;

#--SORTING, GROUPING AND AGGREGATE FUNCTIONS

-- Students alphabetically
SELECT student_id, TRIM(name) AS student_name
FROM Students
ORDER BY student_name ASC;

-- Number of students in each department
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM Departments d
LEFT JOIN Students s ON s.department_id = d.department_id
GROUP BY d.department_id, d.department_name
ORDER BY student_count DESC;

-- Average marks per course
SELECT c.course_name, ROUND(AVG(g.marks_obtained), 2) AS average_marks
FROM Courses c
LEFT JOIN Grades g ON g.course_id = c.course_id
GROUP BY c.course_id, c.course_name
ORDER BY c.course_name;

-- Average attendance percentage across all recorded attendance
SELECT ROUND(100.0 * AVG(status IN ('Present','Late')), 2) AS average_attendance_pct
FROM Attendance;

-- Highest and lowest marks in each course
SELECT c.course_name, MAX(g.marks_obtained) AS highest_marks,
       MIN(g.marks_obtained) AS lowest_marks
FROM Courses c
LEFT JOIN Grades g ON g.course_id = c.course_id
GROUP BY c.course_id, c.course_name;

-- Total students per department
SELECT d.department_name, COUNT(s.student_id) AS total_students
FROM Departments d
LEFT JOIN Students s ON s.department_id = d.department_id
GROUP BY d.department_id, d.department_name;


# -- . PRIMARY KEY / FOREIGN KEY RELATIONSHIP CHECKS
select   c.course_name, f.name AS faculty_name
FROM Courses c
LEFT JOIN Faculty f ON f.faculty_id = c.faculty_id
ORDER BY c.course_name;

# --  JOINS
-- INNER JOIN: 
SELECT s.student_id, s.name, s.email, d.department_name
FROM Students s
INNER JOIN Departments d ON d.department_id = s.department_id;

-- LEFT JOIN: 
SELECT s.student_id, s.name
FROM Students s
LEFT JOIN Enrollments e ON e.student_id = s.student_id
WHERE e.enrollment_id IS NULL;

-- RIGHT JOIN: 
SELECT c.course_id, c.course_name, f.name AS faculty_name
FROM Faculty f
RIGHT JOIN Courses c ON c.faculty_id = f.faculty_id
WHERE f.faculty_id IS NULL;

SELECT s.student_id, s.name, g.course_id, g.marks_obtained
FROM Students s
LEFT JOIN Grades g ON g.student_id = s.student_id
UNION
SELECT s.student_id, s.name, g.course_id, g.marks_obtained
FROM Students s
RIGHT JOIN Grades g ON g.student_id = s.student_id
WHERE s.student_id IS NULL;


# -- SUBQUERIES

SELECT DISTINCT s.student_id, s.name, g.marks_obtained
FROM Students s
JOIN Grades g ON g.student_id = s.student_id
WHERE g.marks_obtained > (SELECT AVG(marks_obtained) FROM Grades)
ORDER BY g.marks_obtained DESC;

-- Courses taught by faculty with at least 5 years of experience
SELECT c.course_id, c.course_name, f.name, f.years_experience
FROM Courses c
JOIN Faculty f ON f.faculty_id = c.faculty_id
WHERE f.years_experience >= 5;

-- Students who have missed more than 10 classes
SELECT s.student_id, s.name, COUNT(*) AS classes_missed
FROM Students s
JOIN Attendance a ON a.student_id = s.student_id
WHERE a.status = 'Absent'
GROUP BY s.student_id, s.name
HAVING COUNT(*) > 10;

# -- DATE AND TIME FUNCTIONS
SEselect  MONTH(attendance_date) AS attendance_month,
       MONTHNAME(attendance_date) AS month_name,
       COUNT(*) AS record_count
FROM Attendance
GROUP BY MONTH(attendance_date), MONTHNAME(attendance_date)
ORDER BY attendance_month;

-- Years since each student's admission
SELECT student_id, name, admission_date,
       TIMESTAMPDIFF(YEAR, admission_date, CURDATE()) AS years_since_admission
FROM Students
ORDER BY name;

-- Format attendance date as DD-MM-YYYY
SELECT attendance_id, student_id, course_id,
       DATE_FORMAT(attendance_date, '%d-%m-%Y') AS formatted_attendance_date,
       status
FROM Attendance;

--  STRING FUNCTIONS
SELECT faculty_id, UPPER(name) AS faculty_name_uppercase
FROM Faculty;

SELECT student_id, TRIM(name) AS cleaned_student_name
FROM Students;

SELECT student_id, name,
       COALESCE(NULLIF(TRIM(email), ''), 'Email Not Provided') AS email_display
FROM Students;

--- WINDOW FUNCTIONS 
SELECT student_id, student_name, average_marks,
       RANK() OVER (ORDER BY average_marks DESC) AS performance_rank
FROM (
    SELECT s.student_id, s.name AS student_name,
           ROUND(AVG(g.marks_obtained), 2) AS average_marks
    FROM Students s
    JOIN Grades g ON g.student_id = s.student_id
    GROUP BY s.student_id, s.name
) AS student_scores
ORDER BY performance_rank, student_name;

SELECT course_id, attendance_date, present_count, total_count,
       ROUND(100.0 * SUM(present_count) OVER (
           PARTITION BY course_id ORDER BY attendance_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) / SUM(total_count) OVER (
           PARTITION BY course_id ORDER BY attendance_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ), 2) AS cumulative_attendance_pct
FROM (
    SELECT course_id, attendance_date,
           SUM(status IN ('Present','Late')) AS present_count,
           COUNT(*) AS total_count
    FROM Attendance
    GROUP BY course_id, attendance_date
) AS daily_attendance
ORDER BY course_id, attendance_date;

SELECT enrollment_month, monthly_enrollments,
       SUM(monthly_enrollments) OVER (
           ORDER BY enrollment_month
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_total_enrollments
FROM (
    SELECT DATE_FORMAT(enrollment_date, '%Y-%m-01') AS enrollment_month,
           COUNT(*) AS monthly_enrollments
    FROM Enrollments
    GROUP BY DATE_FORMAT(enrollment_date, '%Y-%m-01')
) AS monthly_data
ORDER BY enrollment_month;

-- CASE EXPRESSIONS
SELECT s.name, c.course_name, g.marks_obtained,
       CASE
           WHEN g.marks_obtained > 90 THEN 'Excellent'
           WHEN g.marks_obtained BETWEEN 75 AND 90 THEN 'Good'
           ELSE 'Needs Improvement'
       END AS performance_level
FROM Grades g
JOIN Students s ON s.student_id = g.student_id
JOIN Courses c ON c.course_id = g.course_id
ORDER BY s.name, c.course_name;

-- Attendance category per student-course
SELECT s.name, c.course_name,
       ROUND(100.0 * SUM(a.status IN ('Present','Late')) / COUNT(*), 2) AS attendance_pct,
       CASE
           WHEN 100.0 * SUM(a.status IN ('Present','Late')) / COUNT(*) > 80 THEN 'Regular'
           WHEN 100.0 * SUM(a.status IN ('Present','Late')) / COUNT(*) BETWEEN 50 AND 80 THEN 'Irregular'
           ELSE 'Defaulter'
       END AS attendance_category
FROM Attendance a
JOIN Students s ON s.student_id = a.student_id
JOIN Courses c ON c.course_id = a.course_id
GROUP BY s.student_id, s.name, c.course_id, c.course_name
ORDER BY s.name, c.course_name;

# --EXTRA REPORTS
SELECT s.student_id, s.name, d.department_name,
       ROUND(g.avg_marks, 2) AS average_marks,
       ROUND(a.attendance_pct, 2) AS attendance_pct
FROM Students s
JOIN Departments d ON d.department_id = s.department_id
LEFT JOIN (
    SELECT student_id, AVG(marks_obtained) AS avg_marks
    FROM Grades GROUP BY student_id
) g ON g.student_id = s.student_id
LEFT JOIN (
    SELECT student_id,
           100.0 * SUM(status IN ('Present','Late')) / COUNT(*) AS attendance_pct
    FROM Attendance GROUP BY student_id
) a ON a.student_id = s.student_id
ORDER BY average_marks DESC, attendance_pct DESC;

-- Students needing attention: low attendance or low average marks
SELECT s.student_id, s.name,
       ROUND(a.attendance_pct, 2) AS attendance_pct,
       ROUND(g.avg_marks, 2) AS average_marks
FROM Students s
LEFT JOIN (
    SELECT student_id,
           100.0 * SUM(status IN ('Present','Late')) / COUNT(*) AS attendance_pct
    FROM Attendance GROUP BY student_id
) a ON a.student_id = s.student_id
LEFT JOIN (
    SELECT student_id, AVG(marks_obtained) AS avg_marks
    FROM Grades GROUP BY student_id
) g ON g.student_id = s.student_id
WHERE a.attendance_pct < 75 OR g.avg_marks < 40
ORDER BY attendance_pct ASC;





