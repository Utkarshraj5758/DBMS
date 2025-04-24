-- Step 1: Create Tables

CREATE TABLE SALESMAN (
    Salesman_id INT PRIMARY KEY,
    Name VARCHAR(100),
    City VARCHAR(100),
    Commission DECIMAL(5,2)
);

CREATE TABLE CUSTOMER (
    C_id INT PRIMARY KEY,
    Cust_Name VARCHAR(100),
    City VARCHAR(100),
    Grade INT,
    Salesman_id INT,
    FOREIGN KEY (Salesman_id) REFERENCES SALESMAN(Salesman_id)
);

CREATE TABLE ORDERS (
    Ord_No INT PRIMARY KEY,
    Purchase_Amt DECIMAL(10,2),
    Ord_Date DATE,
    C_id INT,
    S_id INT,
    FOREIGN KEY (C_id) REFERENCES CUSTOMER(C_id),
    FOREIGN KEY (S_id) REFERENCES SALESMAN(Salesman_id)
);

-- Step 2: Insert Sample Data

INSERT INTO SALESMAN VALUES
(5001, 'James', 'Bangalore', 0.15),
(5002, 'Smith', 'Mumbai', 0.13),
(5003, 'Miller', 'Bangalore', 0.14),
(5004, 'Robert', 'Delhi', 0.12),
(5005, 'John', 'Mumbai', 0.11);

INSERT INTO CUSTOMER VALUES
(3001, 'Ravi', 'Bangalore', 200, 5001),
(3002, 'Meena', 'Delhi', 300, 5002),
(3003, 'Kiran', 'Bangalore', 150, 5001),
(3004, 'Anita', 'Mumbai', 250, 5003),
(3005, 'Raj', 'Delhi', 100, 5002),
(3006, 'Zoya', 'Mumbai', 350, 5005);

INSERT INTO ORDERS VALUES
(7001, 1200.50, '2023-03-15', 3001, 5001),
(7002, 1500.00, '2023-03-17', 3002, 5002),
(7003, 500.00, '2023-03-20', 3003, 5001),
(7004, 2200.00, '2023-03-25', 3004, 5003),
(7005, 1800.00, '2023-03-30', 3006, 5005);

-- Step 3: SQL Queries

-- 1. Count the customers with grades above Bangalore’s average.
SELECT COUNT(*) AS Customers_Above_Avg
FROM CUSTOMER
WHERE Grade > (
    SELECT AVG(Grade)
    FROM CUSTOMER
    WHERE City = 'Bangalore'
);

-- 2. Find the name and numbers of all salesman who had more than one customer.
SELECT S.Salesman_id, S.Name, COUNT(C.C_id) AS Total_Customers
FROM SALESMAN S
JOIN CUSTOMER C ON S.Salesman_id = C.Salesman_id
GROUP BY S.Salesman_id, S.Name
HAVING COUNT(C.C_id) > 1;

-- 3. List all salesman and indicate those who have and don’t have customers in their cities (using UNION)
SELECT S.Name AS Salesman_Name, 'Has Customer in Same City' AS Status
FROM SALESMAN S
JOIN CUSTOMER C ON S.Salesman_id = C.Salesman_id AND S.City = C.City
UNION
SELECT S.Name AS Salesman_Name, 'No Customer in Same City' AS Status
FROM SALESMAN S
WHERE S.Salesman_id NOT IN (
    SELECT DISTINCT S1.Salesman_id
    FROM SALESMAN S1
    JOIN CUSTOMER C1 ON S1.Salesman_id = C1.Salesman_id
    WHERE S1.City = C1.City
);

-- 4. Create a view that finds the salesman who has the customer with the highest order
CREATE VIEW Top_Salesman AS
SELECT S.Salesman_id, S.Name, O.Purchase_Amt
FROM ORDERS O
JOIN SALESMAN S ON O.S_id = S.Salesman_id
WHERE O.Purchase_Amt = (
    SELECT MAX(Purchase_Amt) FROM ORDERS
);
