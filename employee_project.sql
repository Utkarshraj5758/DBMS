-- Step 1: Create Tables

CREATE TABLE EMPLOYEE (
    SSN INT PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(255),
    Sex CHAR(1),
    Salary DECIMAL(10,2),
    Super_SSN INT,
    D_No INT
);

CREATE TABLE DEPARTMENT (
    D_No INT PRIMARY KEY,
    D_Name VARCHAR(100),
    Mgr_SSN INT,
    Mgr_Start_Date DATE
);

CREATE TABLE DLOCATION (
    D_No INT,
    D_Loc VARCHAR(100),
    FOREIGN KEY (D_No) REFERENCES DEPARTMENT(D_No)
);

CREATE TABLE PROJECT (
    P_No INT PRIMARY KEY,
    P_Name VARCHAR(100),
    P_Location VARCHAR(100),
    D_No INT,
    FOREIGN KEY (D_No) REFERENCES DEPARTMENT(D_No)
);

CREATE TABLE WORKS_ON (
    SSN INT,
    P_No INT,
    Hours DECIMAL(5,2),
    FOREIGN KEY (SSN) REFERENCES EMPLOYEE(SSN),
    FOREIGN KEY (P_No) REFERENCES PROJECT(P_No)
);

-- Step 2: Insert Sample Data

INSERT INTO DEPARTMENT VALUES
(1, 'Accounts', 1001, '2020-01-01'),
(2, 'Engineering', 1002, '2019-03-15');

INSERT INTO EMPLOYEE VALUES
(1001, 'Scott James', 'Bangalore', 'M', 75000, NULL, 1),
(1002, 'Linda Smith', 'Mumbai', 'F', 80000, 1001, 2),
(1003, 'Mark Scott', 'Delhi', 'M', 60000, 1001, 2),
(1004, 'John Doe', 'Bangalore', 'M', 55000, 1002, 1);

INSERT INTO PROJECT VALUES
(2001, 'IoT', 'Bangalore', 2),
(2002, 'AI Platform', 'Mumbai', 1),
(2003, 'CloudInfra', 'Delhi', 1);

INSERT INTO WORKS_ON VALUES
(1002, 2001, 10.5),
(1003, 2001, 12.0),
(1004, 2002, 8.0);

INSERT INTO DLOCATION VALUES
(1, 'Bangalore'),
(2, 'Mumbai');

-- Step 3: SQL Queries

-- 1. Project numbers involving an employee with last name ‘Scott’ (as worker or manager)

SELECT DISTINCT P.P_No
FROM PROJECT P
JOIN DEPARTMENT D ON P.D_No = D.D_No
JOIN EMPLOYEE E ON D.Mgr_SSN = E.SSN
WHERE E.Name LIKE '%Scott%'

UNION

SELECT DISTINCT W.P_No
FROM WORKS_ON W
JOIN EMPLOYEE E ON W.SSN = E.SSN
WHERE E.Name LIKE '%Scott%';

-- 2. Resulting salaries after 10% raise for employees working on 'IoT' project

SELECT E.Name, E.Salary, (E.Salary * 1.10) AS New_Salary
FROM EMPLOYEE E
JOIN WORKS_ON W ON E.SSN = W.SSN
JOIN PROJECT P ON W.P_No = P.P_No
WHERE P.P_Name = 'IoT';

-- 3. Sum, Max, and Average salaries in 'Accounts' department

SELECT 
    SUM(E.Salary) AS Total_Salary,
    MAX(E.Salary) AS Max_Salary,
    AVG(E.Salary) AS Avg_Salary
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.D_No = D.D_No
WHERE D.D_Name = 'Accounts';
