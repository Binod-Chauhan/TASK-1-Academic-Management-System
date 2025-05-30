-- 1. Database Creation
CREATE DATABASE IF NOT EXISTS academic_management;
USE academic_management;

-- a) StudentInfo Table
CREATE TABLE IF NOT EXISTS StudentInfo (
    STU_ID INT PRIMARY KEY,
    STU_NAME VARCHAR(100),
    DOB DATE,
    PHONE_NO VARCHAR(15),
    EMAIL_ID VARCHAR(100),
    ADDRESS TEXT
);

-- b) CoursesInfo Table
CREATE TABLE IF NOT EXISTS CoursesInfo (
    COURSE_ID INT PRIMARY KEY,
    COURSE_NAME VARCHAR(100),
    COURSE_INSTRUCTOR_NAME VARCHAR(100)
);

-- c) EnrollmentInfo Table
CREATE TABLE IF NOT EXISTS EnrollmentInfo (
    ENROLLMENT_ID INT PRIMARY KEY,
    STU_ID INT,
    COURSE_ID INT,
    ENROLL_STATUS ENUM('Enrolled', 'Not Enrolled'),
    FOREIGN KEY (STU_ID) REFERENCES StudentInfo(STU_ID),
    FOREIGN KEY (COURSE_ID) REFERENCES CoursesInfo(COURSE_ID)
);

-- 2. Insert Sample Data
INSERT INTO StudentInfo VALUES
(1, 'Amit Sharma', '2002-05-12', '9876543210', 'amit@example.com', 'Delhi'),
(2, 'Binod Chauhan', '2001-08-25', '9988776655', 'binod@example.com', 'Dehradun'),
(3, 'Neha Singh', '2003-01-15', '9871234567', 'neha@example.com', 'Lucknow');

INSERT INTO CoursesInfo VALUES
(101, 'SQL Fundamentals', 'Dr. Verma'),
(102, 'Data Structures', 'Prof. Mehta'),
(103, 'Web Development', 'Ms. Kapoor');

INSERT INTO EnrollmentInfo VALUES
(1, 1, 101, 'Enrolled'),
(2, 1, 102, 'Enrolled'),
(3, 2, 101, 'Enrolled'),
(4, 3, 103, 'Not Enrolled'),
(5, 2, 102, 'Enrolled');

-- 3. Retrieve Student Information
-- a) Student details with enrollment status
SELECT S.STU_NAME, S.PHONE_NO, S.EMAIL_ID, E.ENROLL_STATUS
FROM StudentInfo S
JOIN EnrollmentInfo E ON S.STU_ID = E.STU_ID;

-- b) List of courses a student is enrolled in
SELECT S.STU_NAME, C.COURSE_NAME
FROM StudentInfo S
JOIN EnrollmentInfo E ON S.STU_ID = E.STU_ID
JOIN CoursesInfo C ON E.COURSE_ID = C.COURSE_ID
WHERE E.ENROLL_STATUS = 'Enrolled' AND S.STU_NAME = 'Amit Sharma';

-- c) Retrieve course name and instructor
SELECT COURSE_NAME, COURSE_INSTRUCTOR_NAME FROM CoursesInfo;

-- d) Retrieve course info for specific course
SELECT * FROM CoursesInfo WHERE COURSE_ID = 101;

-- e) Retrieve info for multiple courses
SELECT * FROM CoursesInfo WHERE COURSE_ID IN (101, 102);

-- 4. Reporting and Analytics
-- a) Number of students in each course
SELECT C.COURSE_NAME, COUNT(E.STU_ID) AS No_of_Students
FROM CoursesInfo C
JOIN EnrollmentInfo E ON C.COURSE_ID = E.COURSE_ID
WHERE E.ENROLL_STATUS = 'Enrolled'
GROUP BY C.COURSE_NAME;

-- b) List of students in a specific course
SELECT S.STU_NAME
FROM StudentInfo S
JOIN EnrollmentInfo E ON S.STU_ID = E.STU_ID
WHERE E.COURSE_ID = 101 AND E.ENROLL_STATUS = 'Enrolled';

-- c) Count of enrolled students per instructor
SELECT C.COURSE_INSTRUCTOR_NAME, COUNT(E.STU_ID) AS Total_Enrolled
FROM CoursesInfo C
JOIN EnrollmentInfo E ON C.COURSE_ID = E.COURSE_ID
WHERE E.ENROLL_STATUS = 'Enrolled'
GROUP BY C.COURSE_INSTRUCTOR_NAME;

-- d) Students enrolled in multiple courses
SELECT STU_ID
FROM EnrollmentInfo
WHERE ENROLL_STATUS = 'Enrolled'
GROUP BY STU_ID
HAVING COUNT(COURSE_ID) > 1;

-- e) Courses with highest to lowest enrolled students
SELECT C.COURSE_NAME, COUNT(E.STU_ID) AS Enrolled_Students
FROM CoursesInfo C
JOIN EnrollmentInfo E ON C.COURSE_ID = E.COURSE_ID
WHERE E.ENROLL_STATUS = 'Enrolled'
GROUP BY C.COURSE_NAME
ORDER BY Enrolled_Students DESC;
