-- Create and use the database
CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- 1. Create Tables
CREATE TABLE PUBLISHER (
    Name VARCHAR(100) PRIMARY KEY,
    Address VARCHAR(255),
    Phone VARCHAR(15)
);

CREATE TABLE LIBRARY_BRANCH (
    Branch_id INT PRIMARY KEY,
    Branch_Name VARCHAR(100),
    Address VARCHAR(255)
);

CREATE TABLE BOOK (
    Book_id VARCHAR(10) PRIMARY KEY,
    Title VARCHAR(100),
    Publisher_Name VARCHAR(100),
    Pub_Year YEAR,
    FOREIGN KEY (Publisher_Name) REFERENCES PUBLISHER(Name) ON DELETE CASCADE
);

CREATE TABLE BOOK_AUTHORS (
    Book_id VARCHAR(10),
    Author_Name VARCHAR(100),
    PRIMARY KEY (Book_id, Author_Name),
    FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id) ON DELETE CASCADE
);

CREATE TABLE BOOK_COPIES (
    Book_id VARCHAR(10),
    Branch_id INT,
    No_of_Copies INT,
    PRIMARY KEY (Book_id, Branch_id),
    FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id) ON DELETE CASCADE,
    FOREIGN KEY (Branch_id) REFERENCES LIBRARY_BRANCH(Branch_id) ON DELETE CASCADE
);

CREATE TABLE BOOK_LENDING (
    Book_id VARCHAR(10),
    Br_id INT,
    Card_No INT,
    Date_Out DATE,
    Due_Date DATE,
    PRIMARY KEY (Book_id, Br_id, Card_No, Date_Out),
    FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id) ON DELETE CASCADE,
    FOREIGN KEY (Br_id) REFERENCES LIBRARY_BRANCH(Branch_id) ON DELETE CASCADE
);

-- 2. Insert Sample Data
INSERT INTO PUBLISHER VALUES
('Penguin', '123 Penguin St, NY', '1234567890'),
('HarperCollins', '456 Harper Ave, LA', '2345678901'),
('O\'Reilly Media', '789 OReilly Blvd, SF', '3456789012');

INSERT INTO LIBRARY_BRANCH VALUES
(1, 'Central Library', 'Main Street, City Center'),
(2, 'North Branch', 'North Road, Uptown'),
(3, 'South Branch', 'South Avenue, Downtown');

INSERT INTO BOOK VALUES
('B101', 'Learn SQL', 'O\'Reilly Media', 2020),
('B102', 'Data Structures', 'Penguin', 2019),
('B103', 'Machine Learning', 'HarperCollins', 2021),
('B104', 'Operating Systems', 'Penguin', 2022);

INSERT INTO BOOK_AUTHORS VALUES
('B101', 'John Doe'),
('B102', 'Jane Smith'),
('B103', 'Andrew Ng'),
('B104', 'Abraham Silberschatz'),
('B104', 'Peter Galvin');

INSERT INTO BOOK_COPIES VALUES
('B101', 1, 5),
('B101', 2, 2),
('B102', 1, 3),
('B103', 2, 4),
('B104', 3, 1);

INSERT INTO BOOK_LENDING VALUES
('B101', 1, 1001, '2020-02-15', '2020-03-15'),
('B102', 1, 1001, '2021-03-10', '2021-04-10'),
('B103', 2, 1002, '2022-01-20', '2022-02-20'),
('B104', 3, 1003, '2022-05-01', '2022-06-01'),
('B101', 1, 1001, '2021-07-10', '2021-08-10'),
('B104', 3, 1001, '2022-01-15', '2022-02-15'),
('B103', 2, 1001, '2022-03-01', '2022-04-01');

-- 3. Queries

-- Query 1: Retrieve all book details
SELECT 
    B.Book_id,
    B.Title,
    P.Name AS Publisher_Name,
    BA.Author_Name,
    BC.Branch_id,
    BC.No_of_Copies,
    LB.Branch_Name
FROM 
    BOOK B
JOIN PUBLISHER P ON B.Publisher_Name = P.Name
JOIN BOOK_AUTHORS BA ON B.Book_id = BA.Book_id
JOIN BOOK_COPIES BC ON B.Book_id = BC.Book_id
JOIN LIBRARY_BRANCH LB ON BC.Branch_id = LB.Branch_id;

-- Query 2: Borrowers who borrowed more than 3 books between Jan 2020 and Jun 2022
SELECT 
    Card_No,
    COUNT(*) AS Books_Borrowed
FROM 
    BOOK_LENDING
WHERE 
    Date_Out BETWEEN '2020-01-01' AND '2022-06-30'
GROUP BY 
    Card_No
HAVING 
    COUNT(*) > 3;

-- Query 3: Delete a book and cascade to other tables
-- Deleting book with Book_id = 'B104'
DELETE FROM BOOK WHERE Book_id = 'B104';
